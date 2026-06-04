"use server";
// Whistleblower write actions. Submitting is self-service (whistleblower.report);
// anonymous reports store NO reporter identity and audit rows never carry one.
// Routing: a report that involves senior management is auto-routed to BARC_CHAIR
// and is reachable only by whistleblower.exec (the Chairman) — never the CCO.
// Handler actions require whistleblower.access plus, for senior-management
// reports, whistleblower.exec.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission, type CurrentUser } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { nextWbCaseRef } from "@/lib/whistleblower";
import { WB_CATEGORIES, WB_STATUSES } from "@/lib/ws5";

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

const submitSchema = z.object({
  category: z.enum(WB_CATEGORIES),
  summary: z.string().trim().min(10, "Describe the concern in a few sentences"),
  isAnonymous: z.boolean().optional(),
  involvesSeniorManagement: z.boolean().optional(),
});

export async function submitReportAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("whistleblower.report");
  const parsed = submitSchema.safeParse({
    category: String(fd.get("category") ?? ""),
    summary: String(fd.get("summary") ?? ""),
    isAnonymous: fd.get("isAnonymous") === "on",
    involvesSeniorManagement: fd.get("involvesSeniorManagement") === "on",
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;

  let reporterId: string | null = null;
  let reporterName: string | null = null;
  if (!v.isAnonymous) {
    const mine = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true, fullName: true } });
    reporterId = mine?.id ?? null;
    reporterName = mine?.fullName ?? me.name;
  }

  const route = v.involvesSeniorManagement ? "BARC_CHAIR" : "CCO";
  const caseRef = await nextWbCaseRef();
  await prisma.whistleblowerReport.create({
    data: {
      caseRef,
      isAnonymous: Boolean(v.isAnonymous),
      reporterId,
      reporterName,
      category: v.category,
      involvesSeniorManagement: Boolean(v.involvesSeniorManagement),
      route,
      summary: v.summary.trim(),
      status: "RECEIVED",
    },
  });

  // Audit WITHOUT the reporter's identity (anonymity is protected regardless).
  await writeAudit({
    actorId: v.isAnonymous ? undefined : me.id,
    action: "whistleblower.submit",
    entityType: "WhistleblowerReport",
    entityId: caseRef,
    metadata: { caseRef, route, anonymous: Boolean(v.isAnonymous), category: v.category },
  });

  revalidatePath("/whistleblower");
  return {
    ok: true,
    message: `Your report has been submitted under reference ${caseRef}. ${route === "BARC_CHAIR" ? "It has been routed to the BARC Chair / Chairman." : "It has been routed to the Compliance Officer."} Keep this reference for any follow-up.`,
  };
}

// Loads a report and confirms the caller may access it (senior-management
// reports require whistleblower.exec). Returns null+error string if not.
async function authorize(reportId: string, me: CurrentUser) {
  const report = await prisma.whistleblowerReport.findUnique({ where: { id: reportId } });
  if (!report) return { report: null as null, error: "Report not found." };
  if (report.involvesSeniorManagement && !me.permissions.has("whistleblower.exec")) {
    return { report: null as null, error: "This report involves senior management and is restricted to the Chairman / BARC Chair." };
  }
  return { report, error: null as null };
}

export async function assignHandlerAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("whistleblower.access");
  const id = String(fd.get("id") ?? "");
  const { report, error } = await authorize(id, me);
  if (error || !report) return { ok: false, error: error ?? "Report not found." };
  await prisma.whistleblowerReport.update({
    where: { id },
    data: { handlerId: me.id, handlerName: me.name, status: report.status === "RECEIVED" ? "UNDER_REVIEW" : report.status },
  });
  await writeAudit({ actorId: me.id, action: "whistleblower.assign", entityType: "WhistleblowerReport", entityId: report.caseRef, metadata: {} });
  revalidatePath(`/whistleblower/${id}`);
  return { ok: true };
}

export async function recordWbInvestigationAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("whistleblower.access");
  const id = String(fd.get("id") ?? "");
  const summary = nz(fd.get("investigationSummary"));
  const { report, error } = await authorize(id, me);
  if (error || !report) return { ok: false, error: error ?? "Report not found." };
  if (!summary) return { ok: false, fieldErrors: { investigationSummary: "Enter the investigation summary." } };
  await prisma.whistleblowerReport.update({ where: { id }, data: { investigationSummary: summary, status: "INVESTIGATING" } });
  await writeAudit({ actorId: me.id, action: "whistleblower.investigation", entityType: "WhistleblowerReport", entityId: report.caseRef, metadata: {} });
  revalidatePath(`/whistleblower/${id}`);
  return { ok: true };
}

const outcomeSchema = z.object({
  id: z.string().min(1),
  status: z.enum(WB_STATUSES),
  outcome: z.string().trim().optional().or(z.literal("")),
  actionTaken: z.string().trim().optional().or(z.literal("")),
});

export async function recordWbOutcomeAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("whistleblower.access");
  const parsed = outcomeSchema.safeParse({
    id: String(fd.get("id") ?? ""),
    status: String(fd.get("status") ?? ""),
    outcome: String(fd.get("outcome") ?? ""),
    actionTaken: String(fd.get("actionTaken") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: fe(parsed.error) };
  const v = parsed.data;
  const { report, error } = await authorize(v.id, me);
  if (error || !report) return { ok: false, error: error ?? "Report not found." };
  await prisma.whistleblowerReport.update({
    where: { id: v.id },
    data: {
      status: v.status,
      outcome: nz(v.outcome),
      actionTaken: nz(v.actionTaken),
      closedAt: v.status === "CLOSED" ? new Date() : report.closedAt,
    },
  });
  await writeAudit({ actorId: me.id, action: "whistleblower.outcome", entityType: "WhistleblowerReport", entityId: report.caseRef, metadata: { status: v.status } });
  revalidatePath(`/whistleblower/${v.id}`);
  return { ok: true };
}

export async function acknowledgeReporterAction(_p: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("whistleblower.access");
  const id = String(fd.get("id") ?? "");
  const { report, error } = await authorize(id, me);
  if (error || !report) return { ok: false, error: error ?? "Report not found." };
  if (report.isAnonymous) return { ok: false, error: "This is an anonymous report — there is no reporter to acknowledge." };
  await prisma.whistleblowerReport.update({ where: { id }, data: { acknowledgedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "whistleblower.acknowledge", entityType: "WhistleblowerReport", entityId: report.caseRef, metadata: {} });
  revalidatePath(`/whistleblower/${id}`);
  return { ok: true };
}
