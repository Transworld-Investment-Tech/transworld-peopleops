"use server";
// Grievance (E9) write actions. Raising is self-service (grievance.raise),
// self-scoped to the signed-in user's employee record. Coordination &
// investigation are gated grievance.manage; appeals are heard under
// grievance.approve. Confidentiality: the named respondent never sees the
// record. All mutations zod-validated and audited.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { addWorkingDays, GRIEVANCE_FINDINGS } from "@/lib/ws5";

export type FormState = { ok: boolean; error?: string; message?: string; fieldErrors?: Record<string, string> };

function nz(v: FormDataEntryValue | string | null | undefined): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}
function fe(err: z.ZodError): Record<string, string> {
  const o: Record<string, string> = {};
  for (const i of err.issues) o[String(i.path[0] ?? "form")] = i.message;
  return o;
}

const raiseSchema = z.object({
  subject: z.string().trim().min(4, "Give your grievance a short subject"),
  details: z.string().trim().min(10, "Describe the grievance"),
  respondentId: z.string().optional().or(z.literal("")),
});

export async function raiseGrievanceAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("grievance.raise");
  const mine = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true, fullName: true } });
  if (!mine) return { ok: false, error: "Your login isn’t linked to an employee record yet, so a grievance can’t be filed against your name." };

  const parsed = raiseSchema.safeParse({
    subject: String(fd.get("subject") ?? ""),
    details: String(fd.get("details") ?? ""),
    respondentId: String(fd.get("respondentId") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;

  let respondentName: string | null = null;
  const respondentId = nz(v.respondentId);
  if (respondentId) {
    const r = await prisma.employee.findUnique({ where: { id: respondentId }, select: { fullName: true } });
    respondentName = r?.fullName ?? null;
  }

  const created = await prisma.grievance.create({
    data: {
      complainantId: mine.id,
      complainantName: mine.fullName,
      respondentId,
      respondentName,
      subject: v.subject.trim(),
      details: v.details.trim(),
      status: "RECEIVED",
      targetDate: addWorkingDays(new Date(), 15),
    },
  });
  await writeAudit({ actorId: me.id, action: "grievance.raise", entityType: "Grievance", entityId: created.id, metadata: {} });
  revalidatePath("/grievances/raise");
  revalidatePath("/grievances");
  return { ok: true, message: "Your grievance has been submitted. People Ops will acknowledge it within two working days." };
}

export async function acknowledgeGrievanceAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("grievance.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing grievance." };
  await prisma.grievance.update({ where: { id }, data: { status: "ACKNOWLEDGED", acknowledgedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "grievance.acknowledge", entityType: "Grievance", entityId: id, metadata: {} });
  revalidatePath(`/grievances/${id}`);
  return { ok: true };
}

const findingSchema = z.object({
  id: z.string().min(1),
  investigatorName: z.string().trim().min(2, "Who investigated?"),
  finding: z.enum(GRIEVANCE_FINDINGS),
  findingSummary: z.string().trim().min(10, "Summarize the finding"),
  recommendedAction: z.string().trim().optional().or(z.literal("")),
});

export async function recordFindingAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("grievance.manage");
  const parsed = findingSchema.safeParse({
    id: String(fd.get("id") ?? ""),
    investigatorName: String(fd.get("investigatorName") ?? ""),
    finding: String(fd.get("finding") ?? ""),
    findingSummary: String(fd.get("findingSummary") ?? ""),
    recommendedAction: String(fd.get("recommendedAction") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;
  const now = new Date();
  await prisma.grievance.update({
    where: { id: v.id },
    data: {
      investigatorId: me.id,
      investigatorName: v.investigatorName.trim(),
      investigatedAt: now,
      finding: v.finding,
      findingSummary: v.findingSummary.trim(),
      recommendedAction: nz(v.recommendedAction),
      communicatedAt: now,
      status: "FINDING_ISSUED",
    },
  });
  await writeAudit({ actorId: me.id, action: "grievance.finding", entityType: "Grievance", entityId: v.id, metadata: { finding: v.finding } });
  revalidatePath(`/grievances/${v.id}`);
  return { ok: true };
}

export async function recordAppealAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("grievance.approve");
  const id = String(fd.get("id") ?? "");
  const outcome = nz(fd.get("appealOutcome"));
  if (!id) return { ok: false, error: "Missing grievance." };
  if (!outcome) return { ok: false, fieldErrors: { appealOutcome: "Enter the appeal outcome." } };
  const g = await prisma.grievance.findUnique({ where: { id }, select: { appealRequestedAt: true } });
  const now = new Date();
  await prisma.grievance.update({
    where: { id },
    data: {
      appealRequestedAt: g?.appealRequestedAt ?? now,
      appealHeardById: me.id,
      appealHeardByName: me.name,
      appealOutcome: outcome,
      appealAt: now,
      status: "APPEALED",
    },
  });
  await writeAudit({ actorId: me.id, action: "grievance.appeal", entityType: "Grievance", entityId: id, metadata: {} });
  revalidatePath(`/grievances/${id}`);
  return { ok: true };
}

export async function closeGrievanceAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("grievance.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing grievance." };
  await prisma.grievance.update({ where: { id }, data: { status: "CLOSED", closedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "grievance.close", entityType: "Grievance", entityId: id, metadata: {} });
  revalidatePath(`/grievances/${id}`);
  revalidatePath("/grievances");
  return { ok: true };
}
