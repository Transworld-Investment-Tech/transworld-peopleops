"use server";
// Disciplinary (E8) write actions. Gated by discipline.manage to prepare/record;
// issuing a sanction escalates to discipline.approve (COO · verbal/written) or
// discipline.dismiss (MD/Chairman · final written/dismissal). No self-approval:
// at the approval tiers the issuer must differ from the case preparer. Every
// mutation is zod-validated and audited.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  DISCIPLINARY_STAGES,
  approvalPermForStage,
  approverRoleForStage,
  retentionMonthsFor,
  expiresAt,
} from "@/lib/ws5";

export type FormState = { ok: boolean; error?: string; fieldErrors?: Record<string, string> };

function nz(v: FormDataEntryValue | string | null | undefined): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}
function nint(v: FormDataEntryValue | string | null | undefined): number | null {
  const s = String(v ?? "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isInteger(n) && n >= 0 ? n : null;
}
function fe(err: z.ZodError): Record<string, string> {
  const o: Record<string, string> = {};
  for (const i of err.issues) o[String(i.path[0] ?? "form")] = i.message;
  return o;
}

const openSchema = z.object({
  employeeId: z.string().min(1, "Select an employee"),
  concern: z.string().trim().min(4, "Describe the concern"),
  isRegulatory: z.boolean().optional(),
  isGrossMisconduct: z.boolean().optional(),
});

export async function openCaseAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const parsed = openSchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    concern: String(fd.get("concern") ?? ""),
    isRegulatory: fd.get("isRegulatory") === "on",
    isGrossMisconduct: fd.get("isGrossMisconduct") === "on",
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;
  const emp = await prisma.employee.findUnique({ where: { id: v.employeeId }, select: { id: true, eeId: true, fullName: true } });
  if (!emp) return { ok: false, fieldErrors: { employeeId: "Employee not found." } };

  const created = await prisma.disciplinaryCase.create({
    data: {
      employeeId: emp.id,
      employeeName: emp.fullName,
      concern: v.concern.trim(),
      isRegulatory: Boolean(v.isRegulatory),
      isGrossMisconduct: Boolean(v.isGrossMisconduct),
      status: "OPEN",
      preparedById: me.id,
      preparedByName: me.name,
    },
  });
  await writeAudit({ actorId: me.id, action: "discipline.open", entityType: "DisciplinaryCase", entityId: created.id, metadata: { eeId: emp.eeId, regulatory: created.isRegulatory, gross: created.isGrossMisconduct } });
  revalidatePath("/discipline");
  redirect(`/discipline/${created.id}`);
}

async function loadCase(caseId: string) {
  return prisma.disciplinaryCase.findUnique({ where: { id: caseId } });
}

export async function recordInvestigationAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const caseId = String(fd.get("caseId") ?? "");
  const summary = nz(fd.get("summary"));
  if (!caseId) return { ok: false, error: "Missing case." };
  if (!summary) return { ok: false, fieldErrors: { summary: "Enter the investigation summary." } };
  const c = await loadCase(caseId);
  if (!c) return { ok: false, error: "Case not found." };
  await prisma.disciplinaryCase.update({
    where: { id: caseId },
    data: {
      investigationSummary: summary,
      investigatedById: me.id,
      investigatedByName: me.name,
      investigatedAt: new Date(),
      status: c.status === "OPEN" ? "INVESTIGATING" : c.status,
    },
  });
  await writeAudit({ actorId: me.id, action: "discipline.investigation", entityType: "DisciplinaryCase", entityId: caseId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
  return { ok: true };
}

export async function suspendAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const caseId = String(fd.get("caseId") ?? "");
  if (!caseId) return { ok: false, error: "Missing case." };
  const c = await loadCase(caseId);
  if (!c) return { ok: false, error: "Case not found." };
  const ends = fd.get("suspensionEndsAt") ? new Date(String(fd.get("suspensionEndsAt"))) : null;
  await prisma.disciplinaryCase.update({
    where: { id: caseId },
    data: { suspendedAt: new Date(), suspensionEndsAt: ends, status: "SUSPENDED" },
  });
  await writeAudit({ actorId: me.id, action: "discipline.suspend", entityType: "DisciplinaryCase", entityId: caseId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
  return { ok: true };
}

export async function liftSuspensionAction(fd: FormData): Promise<void> {
  const me = await requirePermission("discipline.manage");
  const caseId = String(fd.get("caseId") ?? "");
  if (!caseId) return;
  await prisma.disciplinaryCase.update({
    where: { id: caseId },
    data: { suspensionEndsAt: new Date(), status: "INVESTIGATING" },
  });
  await writeAudit({ actorId: me.id, action: "discipline.lift_suspension", entityType: "DisciplinaryCase", entityId: caseId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
}

const issueSchema = z.object({
  caseId: z.string().min(1),
  stage: z.enum(DISCIPLINARY_STAGES),
  requiredStandard: z.string().trim().optional().or(z.literal("")),
  improvementPeriodMonths: z.string().optional().or(z.literal("")),
  consequence: z.string().trim().optional().or(z.literal("")),
  note: z.string().trim().optional().or(z.literal("")),
});

export async function issueActionAction(_p: FormState, fd: FormData): Promise<FormState> {
  const stage = String(fd.get("stage") ?? "");
  const perm = approvalPermForStage(stage) ?? "discipline.manage";
  // Approval tier (verbal/written -> COO; final/dismissal -> MD/Chairman).
  const me = await requirePermission(perm);

  const parsed = issueSchema.safeParse({
    caseId: String(fd.get("caseId") ?? ""),
    stage,
    requiredStandard: String(fd.get("requiredStandard") ?? ""),
    improvementPeriodMonths: String(fd.get("improvementPeriodMonths") ?? ""),
    consequence: String(fd.get("consequence") ?? ""),
    note: String(fd.get("note") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;

  const c = await loadCase(v.caseId);
  if (!c) return { ok: false, error: "Case not found." };

  // No self-approval at the approval tiers.
  if (approvalPermForStage(v.stage) && c.preparedById && c.preparedById === me.id) {
    return { ok: false, error: "The person signing off a warning must be different from the person who prepared the case." };
  }
  // A Written warning or above requires a documented investigation summary (E8.3).
  const needsInvestigation = v.stage === "WRITTEN_WARNING" || v.stage === "FINAL_WRITTEN_WARNING" || v.stage === "DISMISSAL";
  if (needsInvestigation && !c.investigationSummary) {
    return { ok: false, error: "Record the investigation summary before issuing a written warning or above (E8.3)." };
  }

  const issuedAt = new Date();
  const retention = retentionMonthsFor(v.stage, c.isRegulatory);
  const exp = expiresAt(issuedAt, retention);
  const approverRole = approverRoleForStage(v.stage);

  await prisma.disciplinaryAction.create({
    data: {
      caseId: v.caseId,
      stage: v.stage,
      issuedAt,
      requiredStandard: nz(v.requiredStandard),
      improvementPeriodMonths: nint(v.improvementPeriodMonths),
      consequence: nz(v.consequence),
      retentionMonths: retention,
      expiresAt: exp,
      approverRole: approverRole,
      approvedById: approverRole ? me.id : null,
      approvedByName: approverRole ? me.name : null,
      approvedAt: approverRole ? issuedAt : null,
      note: nz(v.note),
      createdById: me.id,
    },
  });

  const closes = v.stage === "DISMISSAL";
  await prisma.disciplinaryCase.update({
    where: { id: v.caseId },
    data: {
      currentStage: v.stage,
      status: closes ? "CLOSED" : "SANCTION_ISSUED",
      closedAt: closes ? issuedAt : c.closedAt,
      outcome: closes ? "Dismissal" : c.outcome,
    },
  });

  await writeAudit({ actorId: me.id, action: "discipline.issue", entityType: "DisciplinaryCase", entityId: v.caseId, metadata: { stage: v.stage, approverRole } });
  revalidatePath(`/discipline/${v.caseId}`);
  revalidatePath("/discipline");
  return { ok: true };
}

export async function recordResponseAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const actionId = String(fd.get("actionId") ?? "");
  const caseId = String(fd.get("caseId") ?? "");
  const response = nz(fd.get("employeeResponse"));
  if (!actionId || !caseId) return { ok: false, error: "Missing sanction." };
  if (!response) return { ok: false, fieldErrors: { employeeResponse: "Enter the employee’s response." } };
  await prisma.disciplinaryAction.update({
    where: { id: actionId },
    data: { employeeResponse: response, employeeResponseAt: new Date() },
  });
  await writeAudit({ actorId: me.id, action: "discipline.response", entityType: "DisciplinaryAction", entityId: actionId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
  return { ok: true };
}

export async function recordAckAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const caseId = String(fd.get("caseId") ?? "");
  const name = nz(fd.get("ackName"));
  if (!caseId) return { ok: false, error: "Missing case." };
  if (!name) return { ok: false, fieldErrors: { ackName: "Enter the acknowledging name." } };
  await prisma.disciplinaryCase.update({ where: { id: caseId }, data: { ackName: name, ackAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "discipline.ack", entityType: "DisciplinaryCase", entityId: caseId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
  return { ok: true };
}

export async function closeCaseAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("discipline.manage");
  const caseId = String(fd.get("caseId") ?? "");
  const outcome = nz(fd.get("outcome"));
  if (!caseId) return { ok: false, error: "Missing case." };
  await prisma.disciplinaryCase.update({ where: { id: caseId }, data: { status: "CLOSED", closedAt: new Date(), outcome } });
  await writeAudit({ actorId: me.id, action: "discipline.close", entityType: "DisciplinaryCase", entityId: caseId, metadata: {} });
  revalidatePath(`/discipline/${caseId}`);
  revalidatePath("/discipline");
  return { ok: true };
}
