"use server";
// Write-side server actions for the goal agreement workflow (v0.18.1).
// Exports ONLY async functions plus the FormState type (Next 15 "use server").
//
// Immutability is the point of this module. The rules, enforced here:
//   * A staff member edits their own goals ONLY while the sheet is DRAFT or
//     CHANGES_REQUESTED. Once SUBMITTED or APPROVED, the staff side is locked.
//   * A line manager acts ONLY on their own direct reports (org chart, scoped on
//     every call). HR (performance.manage) does not approve.
//   * On approval the sheet is SEALED: the agreed goal definitions and the
//     agreement note become permanently read-only. No employee, manager, or HR
//     action edits a sealed agreement. Only goal PROGRESS (status) may still be
//     marked at review — never the agreed definition.
//   * Mid-cycle changes are APPEND-ONLY amendments (a new row each time) and are
//     allowed only once the cycle has advanced past Goal setting. The original
//     sealed positions are never overwritten.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { headers } from "next/headers";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = {
  ok: boolean;
  error?: string;
  message?: string;
  fieldErrors?: Record<string, string>;
};

const GOAL_PROGRESS = ["ACTIVE", "ACHIEVED", "PARTIAL", "MISSED", "DROPPED"] as const;
const AMEND_KINDS = ["AMEND", "EXPAND", "CONTRACT", "NEW_GOAL", "FOLLOWUP_NOTE", "NOTE"] as const;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function parseDate(v?: string | null): Date | null {
  const s = (v ?? "").trim();
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
function weightOrNull(v: unknown): number | null {
  if (v === null || v === undefined || String(v).trim() === "") return null;
  const n = Number(v);
  if (!Number.isInteger(n) || n < 0 || n > 100) return null;
  return n;
}
function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}
async function clientIp(): Promise<string | null> {
  try {
    const h = await headers();
    return h.get("x-forwarded-for")?.split(",")[0]?.trim() || h.get("x-real-ip") || null;
  } catch {
    return null;
  }
}
async function myEmployee(userId: string) {
  return prisma.employee.findUnique({
    where: { userId },
    select: { id: true, fullName: true, preferredName: true, managerId: true },
  });
}
async function activeCycle() {
  return (
    (await prisma.appraisalCycle.findFirst({
      where: { status: "OPEN" },
      orderBy: { createdAt: "desc" },
      select: { id: true, stage: true },
    })) ??
    (await prisma.appraisalCycle.findFirst({
      orderBy: { createdAt: "desc" },
      select: { id: true, stage: true },
    }))
  );
}
/** Get-or-create the DRAFT sheet for (cycle, employee). */
async function ensureSheet(cycleId: string, employeeId: string, managerId: string | null) {
  const existing = await prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId, employeeId } },
  });
  if (existing) return existing;
  return prisma.goalSheet.create({
    data: { cycleId, employeeId, managerId, reviewState: "DRAFT" },
  });
}

// ===========================================================================
// EMPLOYEE — draft goals (performance.self, self-scoped). Editable only while
// the sheet is DRAFT or CHANGES_REQUESTED.
// ===========================================================================
const draftGoalSchema = z.object({
  title: z.string().trim().min(2, "Give the goal a title."),
});

async function staffEditableSheet(employeeId: string, cycleId: string, managerId: string | null) {
  const sheet = await ensureSheet(cycleId, employeeId, managerId);
  if (sheet.reviewState === "SUBMITTED")
    return { sheet, blocked: "Your goals are submitted and awaiting your manager's review." };
  if (sheet.reviewState === "APPROVED")
    return { sheet, blocked: "Your goals are approved and sealed — they can't be edited." };
  return { sheet, blocked: null as string | null };
}

export async function draftAddGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };
  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };

  const parsed = draftGoalSchema.safeParse({ title: String(fd.get("title") ?? "") });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const { blocked } = await staffEditableSheet(emp.id, cycle.id, emp.managerId);
  if (blocked) return { ok: false, error: blocked };

  const count = await prisma.performanceGoal.count({
    where: { cycleId: cycle.id, employeeId: emp.id },
  });
  const goal = await prisma.performanceGoal.create({
    data: {
      cycleId: cycle.id,
      employeeId: emp.id,
      title: parsed.data.title,
      description: nz(String(fd.get("description") ?? "")),
      measure: nz(String(fd.get("measure") ?? "")),
      target: nz(String(fd.get("target") ?? "")),
      weight: weightOrNull(fd.get("weight")),
      dueDate: parseDate(String(fd.get("dueDate") ?? "")),
      status: "DRAFT",
      sortOrder: count,
      createdById: me.id,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "goaldraft.create",
    entityType: "performance_goal",
    entityId: goal.id,
    metadata: { cycleId: cycle.id, title: goal.title },
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Goal added to your draft." };
}

export async function draftUpdateGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };
  const id = String(fd.get("goalId") ?? "");
  const goal = id ? await prisma.performanceGoal.findUnique({ where: { id } }) : null;
  if (!goal) return { ok: false, error: "Goal not found." };
  if (goal.employeeId !== emp.id) return { ok: false, error: "That isn't your goal." };

  const { blocked } = await staffEditableSheet(emp.id, goal.cycleId, emp.managerId);
  if (blocked) return { ok: false, error: blocked };

  const title = String(fd.get("title") ?? "").trim();
  if (title.length < 2) return { ok: false, error: "Give the goal a title." };

  await prisma.performanceGoal.update({
    where: { id },
    data: {
      title,
      description: nz(String(fd.get("description") ?? "")),
      measure: nz(String(fd.get("measure") ?? "")),
      target: nz(String(fd.get("target") ?? "")),
      weight: weightOrNull(fd.get("weight")),
      dueDate: parseDate(String(fd.get("dueDate") ?? "")),
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "goaldraft.update",
    entityType: "performance_goal",
    entityId: id,
    metadata: {},
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Goal updated." };
}

export async function draftDeleteGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };
  const id = String(fd.get("goalId") ?? "");
  const goal = id ? await prisma.performanceGoal.findUnique({ where: { id } }) : null;
  if (!goal) return { ok: false, error: "Goal not found." };
  if (goal.employeeId !== emp.id) return { ok: false, error: "That isn't your goal." };

  const { blocked } = await staffEditableSheet(emp.id, goal.cycleId, emp.managerId);
  if (blocked) return { ok: false, error: blocked };

  await prisma.performanceGoal.delete({ where: { id } });
  await writeAudit({
    actorId: me.id,
    action: "goaldraft.delete",
    entityType: "performance_goal",
    entityId: id,
    metadata: { title: goal.title },
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Goal removed." };
}

export async function submitGoalSheetAction(_prev: FormState, _fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };
  if (!emp.managerId)
    return { ok: false, error: "Your line manager isn't set in the org chart yet — ask HR to set it before submitting." };
  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };

  const sheet = await ensureSheet(cycle.id, emp.id, emp.managerId);
  if (sheet.reviewState === "APPROVED")
    return { ok: false, error: "Your goals are already approved and sealed." };
  if (sheet.reviewState === "SUBMITTED")
    return { ok: false, error: "Your goals are already submitted." };

  const goalCount = await prisma.performanceGoal.count({
    where: { cycleId: cycle.id, employeeId: emp.id },
  });
  if (goalCount === 0) return { ok: false, error: "Add at least one goal before submitting." };

  await prisma.goalSheet.update({
    where: { id: sheet.id },
    data: { reviewState: "SUBMITTED", submittedAt: new Date(), managerId: emp.managerId, changesNote: null },
  });
  await writeAudit({
    actorId: me.id,
    action: "goalsheet.submit",
    entityType: "goal_sheet",
    entityId: sheet.id,
    metadata: { cycleId: cycle.id, goals: goalCount, managerId: emp.managerId },
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Submitted to your line manager for review." };
}

export async function acknowledgeAgreementAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };

  const sheetId = String(fd.get("sheetId") ?? "");
  const ackName = String(fd.get("ackName") ?? "").trim();
  const consent = String(fd.get("consent") ?? "");
  if (ackName.length < 2) return { ok: false, error: "Type your full name to acknowledge." };
  if (consent !== "1") return { ok: false, error: "Please confirm you have read and agreed the goals." };

  const sheet = sheetId ? await prisma.goalSheet.findUnique({ where: { id: sheetId } }) : null;
  if (!sheet) return { ok: false, error: "Goal sheet not found." };
  if (sheet.employeeId !== emp.id) return { ok: false, error: "That isn't your goal sheet." };
  if (sheet.reviewState !== "APPROVED") return { ok: false, error: "These goals aren't approved yet." };
  if (sheet.ackAt) return { ok: false, error: "You have already acknowledged this agreement." };

  await prisma.goalSheet.update({
    where: { id: sheet.id },
    data: { ackName, ackAt: new Date(), ackIp: await clientIp() },
  });
  await writeAudit({
    actorId: me.id,
    action: "goalsheet.acknowledge",
    entityType: "goal_sheet",
    entityId: sheet.id,
    metadata: { ackName },
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Acknowledged. The agreement is now fully sealed." };
}

// ===========================================================================
// LINE MANAGER — review / request changes / approve & seal (performance.team,
// scoped to direct reports via the org chart).
// ===========================================================================
async function requireManagerOver(employeeId: string) {
  const me = await requirePermission("performance.team");
  const mgr = await myEmployee(me.id);
  if (!mgr) return { error: "Your login isn't linked to an employee record yet." as string };
  const target = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { managerId: true },
  });
  if (!target || target.managerId !== mgr.id)
    return { error: "You can only act on your own direct reports." as string };
  return { me, mgr };
}

export async function requestChangesAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const employeeId = String(fd.get("employeeId") ?? "");
  const guard = await requireManagerOver(employeeId);
  if ("error" in guard) return { ok: false, error: guard.error };
  const { me } = guard;

  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };
  const note = String(fd.get("changesNote") ?? "").trim();
  if (note.length < 2) return { ok: false, error: "Add a short note on what to change." };

  const sheet = await prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId } },
  });
  if (!sheet) return { ok: false, error: "No goal sheet to review." };
  if (sheet.reviewState !== "SUBMITTED")
    return { ok: false, error: "Only a submitted sheet can be sent back." };

  await prisma.goalSheet.update({
    where: { id: sheet.id },
    data: { reviewState: "CHANGES_REQUESTED", changesNote: note },
  });
  await writeAudit({
    actorId: me.id,
    action: "goalsheet.request_changes",
    entityType: "goal_sheet",
    entityId: sheet.id,
    metadata: { employeeId },
  });
  revalidatePath(`/my-team/${employeeId}`);
  revalidatePath("/my-team");
  return { ok: true, message: "Sent back to the employee with your note." };
}

export async function approveAndSealAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const employeeId = String(fd.get("employeeId") ?? "");
  const guard = await requireManagerOver(employeeId);
  if ("error" in guard) return { ok: false, error: guard.error };
  const { me } = guard;

  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };

  const agreement = String(fd.get("agreementNote") ?? "").trim();
  if (agreement.length < 2)
    return { ok: false, error: "Record what was discussed and agreed before approving — this becomes the canonical agreement." };
  const consent = String(fd.get("consent") ?? "");
  if (consent !== "1")
    return { ok: false, error: "Please confirm this is the final agreed position — approval seals it permanently." };

  const sheet = await prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId } },
  });
  if (!sheet) return { ok: false, error: "No goal sheet to approve." };
  if (sheet.reviewState === "APPROVED") return { ok: false, error: "Already approved and sealed." };
  if (sheet.reviewState !== "SUBMITTED")
    return { ok: false, error: "Only a submitted sheet can be approved." };

  const goalCount = await prisma.performanceGoal.count({
    where: { cycleId: cycle.id, employeeId },
  });
  if (goalCount === 0) return { ok: false, error: "There are no goals on this sheet to approve." };

  await prisma.$transaction(async (tx) => {
    await tx.goalSheet.update({
      where: { id: sheet.id },
      data: {
        reviewState: "APPROVED",
        agreementNote: agreement,
        approvedById: me.id,
        approvedAt: new Date(),
        managerSealIp: await clientIp(),
        sealed: true,
        changesNote: null,
      },
    });
    // Activate the agreed goals (DRAFT -> ACTIVE). Definitions are now frozen;
    // only progress (status) may change hereafter, at review.
    await tx.performanceGoal.updateMany({
      where: { cycleId: cycle.id, employeeId, status: "DRAFT" },
      data: { status: "ACTIVE" },
    });
  });

  await writeAudit({
    actorId: me.id,
    action: "goalsheet.approve",
    entityType: "goal_sheet",
    entityId: sheet.id,
    metadata: { employeeId, goals: goalCount },
  });
  revalidatePath(`/my-team/${employeeId}`);
  revalidatePath("/my-team");
  return { ok: true, message: "Approved and sealed. Awaiting the employee's acknowledgment." };
}

// ---------------------------------------------------------------------------
// LINE MANAGER — mark goal progress at review (sealed goals: STATUS ONLY).
// ---------------------------------------------------------------------------
export async function markGoalProgressAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const employeeId = String(fd.get("employeeId") ?? "");
  const guard = await requireManagerOver(employeeId);
  if ("error" in guard) return { ok: false, error: guard.error };
  const { me } = guard;

  const goalId = String(fd.get("goalId") ?? "");
  const status = String(fd.get("status") ?? "");
  if (!(GOAL_PROGRESS as readonly string[]).includes(status))
    return { ok: false, error: "Invalid progress status." };
  const goal = goalId ? await prisma.performanceGoal.findUnique({ where: { id: goalId } }) : null;
  if (!goal || goal.employeeId !== employeeId) return { ok: false, error: "Goal not found for this report." };

  // STATUS ONLY — definitional fields are never touched here.
  await prisma.performanceGoal.update({ where: { id: goalId }, data: { status } });
  await writeAudit({
    actorId: me.id,
    action: "goal.progress",
    entityType: "performance_goal",
    entityId: goalId,
    metadata: { status, employeeId },
  });
  revalidatePath(`/my-team/${employeeId}`);
  return { ok: true, message: "Progress recorded." };
}

// ===========================================================================
// MID-CYCLE — append-only amendments. Allowed only once the cycle has advanced
// past Goal setting, and only on a sealed sheet. Never overwrites the original.
// ===========================================================================
const amendSchema = z.object({
  employeeId: z.string().trim().min(1, "Missing employee."),
  kind: z.enum(AMEND_KINDS),
  body: z.string().trim().min(2, "Describe the change or note."),
});

export async function addAmendmentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const employeeId = String(fd.get("employeeId") ?? "");
  const guard = await requireManagerOver(employeeId);
  if ("error" in guard) return { ok: false, error: guard.error };
  const { me } = guard;

  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };
  if (cycle.stage === "GOAL_SETTING")
    return { ok: false, error: "Amendments open at the Mid-cycle stage — the goal-setting period is still running." };

  const parsed = amendSchema.safeParse({
    employeeId,
    kind: String(fd.get("kind") ?? "NOTE"),
    body: String(fd.get("body") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const sheet = await prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId } },
  });
  if (!sheet || !sheet.sealed)
    return { ok: false, error: "Only a sealed agreement can be amended at mid-cycle." };

  const amendment = await prisma.goalAmendment.create({
    data: {
      sheetId: sheet.id,
      goalId: nz(String(fd.get("goalId") ?? "")),
      kind: parsed.data.kind,
      body: parsed.data.body,
      newMeasure: nz(String(fd.get("newMeasure") ?? "")),
      newTarget: nz(String(fd.get("newTarget") ?? "")),
      createdById: me.id,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "goalsheet.amend",
    entityType: "goal_amendment",
    entityId: amendment.id,
    metadata: { sheetId: sheet.id, kind: parsed.data.kind, employeeId },
  });
  revalidatePath(`/my-team/${employeeId}`);
  revalidatePath("/my-performance");
  return { ok: true, message: "Amendment added to the record." };
}

/** Employee may add a follow-up note to their own sealed sheet at mid-cycle. */
export async function addFollowupNoteAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };
  const cycle = await activeCycle();
  if (!cycle) return { ok: false, error: "There is no review cycle open yet." };
  if (cycle.stage === "GOAL_SETTING")
    return { ok: false, error: "Notes open at the Mid-cycle stage." };

  const body = String(fd.get("body") ?? "").trim();
  if (body.length < 2) return { ok: false, error: "Write your note." };

  const sheet = await prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId: emp.id } },
  });
  if (!sheet || !sheet.sealed) return { ok: false, error: "Your agreement isn't sealed yet." };

  const amendment = await prisma.goalAmendment.create({
    data: { sheetId: sheet.id, kind: "FOLLOWUP_NOTE", body, createdById: me.id },
  });
  await writeAudit({
    actorId: me.id,
    action: "goalsheet.amend",
    entityType: "goal_amendment",
    entityId: amendment.id,
    metadata: { sheetId: sheet.id, kind: "FOLLOWUP_NOTE", byEmployee: true },
  });
  revalidatePath("/my-performance");
  return { ok: true, message: "Note added to the record." };
}
