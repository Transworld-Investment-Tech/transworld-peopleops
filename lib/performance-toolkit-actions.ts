"use server";
// Write-side server actions for the Performance toolkit (v0.18.0). Mirrors the
// conventions of the other module actions (performance/leave/staff-documents):
// gated, zod-validated, audited. Per the Next 15 "use server" rule this module
// exports ONLY async functions plus the FormState type.
//
// Gating:
//  - HR/manager authoring is gated `performance.manage` (goals, dev plans, PIPs).
//  - Self-service is gated `performance.self` and SELF-SCOPED to the signed-in
//    user's linked employee (weekly reports; PIP acknowledgment). A staff member
//    may act only on their OWN linked employee record — never a client-supplied
//    subject id.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { headers } from "next/headers";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { isoWeekStart } from "@/lib/performance-toolkit";

export type FormState = {
  ok: boolean;
  error?: string;
  message?: string;
  fieldErrors?: Record<string, string>;
};

const GOAL_STATUS = ["DRAFT", "ACTIVE", "ACHIEVED", "PARTIAL", "MISSED", "DROPPED"] as const;
const DEV_STATUS = ["OPEN", "IN_PROGRESS", "DONE"] as const;
const PIP_STATUS = ["OPEN", "IN_PROGRESS", "MET", "NOT_MET", "EXTENDED", "CLOSED"] as const;
const PIP_RESULT = ["PENDING", "MET", "NOT_MET"] as const;

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
/** The employee linked to the signed-in user, or null. */
async function myEmployee(userId: string) {
  return prisma.employee.findUnique({
    where: { userId },
    select: { id: true, fullName: true, preferredName: true },
  });
}

// ===========================================================================
// (1) Goal-setting — HR/manager authored (performance.manage)
// ===========================================================================
const goalSchema = z.object({
  cycleId: z.string().trim().min(1, "Missing cycle."),
  employeeId: z.string().trim().min(1, "Missing employee."),
  title: z.string().trim().min(2, "Give the goal a title."),
  status: z.enum(GOAL_STATUS),
});

export async function createGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const parsed = goalSchema.safeParse({
    cycleId: String(fd.get("cycleId") ?? ""),
    employeeId: String(fd.get("employeeId") ?? ""),
    title: String(fd.get("title") ?? ""),
    status: String(fd.get("status") ?? "ACTIVE"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const [cycle, employee] = await Promise.all([
    prisma.appraisalCycle.findUnique({ where: { id: parsed.data.cycleId }, select: { id: true } }),
    prisma.employee.findUnique({ where: { id: parsed.data.employeeId }, select: { id: true, fullName: true } }),
  ]);
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (!employee) return { ok: false, error: "Employee not found." };

  const count = await prisma.performanceGoal.count({
    where: { cycleId: parsed.data.cycleId, employeeId: parsed.data.employeeId },
  });

  const goal = await prisma.performanceGoal.create({
    data: {
      cycleId: parsed.data.cycleId,
      employeeId: parsed.data.employeeId,
      title: parsed.data.title,
      description: nz(String(fd.get("description") ?? "")),
      measure: nz(String(fd.get("measure") ?? "")),
      target: nz(String(fd.get("target") ?? "")),
      weight: weightOrNull(fd.get("weight")),
      dueDate: parseDate(String(fd.get("dueDate") ?? "")),
      status: parsed.data.status,
      sortOrder: count,
      createdById: me.id,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "goal.create",
    entityType: "performance_goal",
    entityId: goal.id,
    metadata: { employee: employee.fullName, cycleId: parsed.data.cycleId, title: goal.title },
  });

  revalidatePath(`/performance/${parsed.data.cycleId}/${parsed.data.employeeId}`);
  return { ok: true, message: "Goal added." };
}

export async function updateGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("goalId") ?? "");
  if (!id) return { ok: false, error: "Missing goal." };
  const existing = await prisma.performanceGoal.findUnique({ where: { id } });
  if (!existing) return { ok: false, error: "Goal not found." };

  const title = String(fd.get("title") ?? "").trim();
  if (title.length < 2) return { ok: false, error: "Give the goal a title." };
  const status = String(fd.get("status") ?? "");
  if (!(GOAL_STATUS as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  await prisma.performanceGoal.update({
    where: { id },
    data: {
      title,
      description: nz(String(fd.get("description") ?? "")),
      measure: nz(String(fd.get("measure") ?? "")),
      target: nz(String(fd.get("target") ?? "")),
      weight: weightOrNull(fd.get("weight")),
      dueDate: parseDate(String(fd.get("dueDate") ?? "")),
      status,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "goal.update",
    entityType: "performance_goal",
    entityId: id,
    metadata: { status },
  });

  revalidatePath(`/performance/${existing.cycleId}/${existing.employeeId}`);
  return { ok: true, message: "Goal updated." };
}

export async function deleteGoalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("goalId") ?? "");
  if (!id) return { ok: false, error: "Missing goal." };
  const existing = await prisma.performanceGoal.findUnique({ where: { id } });
  if (!existing) return { ok: false, error: "Goal not found." };

  await prisma.performanceGoal.delete({ where: { id } });
  await writeAudit({
    actorId: me.id,
    action: "goal.delete",
    entityType: "performance_goal",
    entityId: id,
    metadata: { title: existing.title },
  });

  revalidatePath(`/performance/${existing.cycleId}/${existing.employeeId}`);
  return { ok: true, message: "Goal removed." };
}

// ===========================================================================
// (2) Weekly reporting — self-service (performance.self), self-scoped
// ===========================================================================
const weeklySchema = z.object({
  weekStart: z.string().trim().min(1, "Missing week."),
  accomplishments: z.string().trim().min(2, "Add at least a line on what you accomplished."),
});

export async function saveWeeklyReportAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };

  const parsed = weeklySchema.safeParse({
    weekStart: String(fd.get("weekStart") ?? ""),
    accomplishments: String(fd.get("accomplishments") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const rawWeek = parseDate(parsed.data.weekStart);
  if (!rawWeek) return { ok: false, error: "Invalid week." };
  const weekStart = isoWeekStart(rawWeek); // normalize to Monday 00:00 UTC

  const submit = String(fd.get("submit") ?? "") === "1";
  const status = submit ? "SUBMITTED" : "DRAFT";

  // Active cycle (optional tag).
  const cycle = await prisma.appraisalCycle.findFirst({
    where: { status: "OPEN" },
    orderBy: { createdAt: "desc" },
    select: { id: true },
  });

  const existing = await prisma.weeklyReport.findUnique({
    where: { employeeId_weekStart: { employeeId: emp.id, weekStart } },
  });
  if (existing && existing.status === "SUBMITTED")
    return { ok: false, error: "This week's report is already submitted." };

  const data = {
    accomplishments: parsed.data.accomplishments,
    priorities: nz(String(fd.get("priorities") ?? "")),
    blockers: nz(String(fd.get("blockers") ?? "")),
    status,
    submittedAt: submit ? new Date() : null,
    cycleId: cycle?.id ?? null,
  };

  if (existing) {
    await prisma.weeklyReport.update({ where: { id: existing.id }, data });
  } else {
    await prisma.weeklyReport.create({
      data: { employeeId: emp.id, weekStart, ...data },
    });
  }

  await writeAudit({
    actorId: me.id,
    action: submit ? "weeklyreport.submit" : "weeklyreport.save",
    entityType: "weekly_report",
    entityId: `${emp.id}:${weekStart.toISOString().slice(0, 10)}`,
    metadata: { week: weekStart.toISOString().slice(0, 10), status },
  });

  revalidatePath("/my-performance");
  return { ok: true, message: submit ? "Weekly report submitted." : "Draft saved." };
}

// ===========================================================================
// (3) Development plan — HR/manager authored (performance.manage)
// ===========================================================================
const devSchema = z.object({
  employeeId: z.string().trim().min(1, "Missing employee."),
  objective: z.string().trim().min(2, "Describe the development objective."),
  status: z.enum(DEV_STATUS),
});

export async function createDevPlanAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const parsed = devSchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    objective: String(fd.get("objective") ?? ""),
    status: String(fd.get("status") ?? "OPEN"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const employee = await prisma.employee.findUnique({
    where: { id: parsed.data.employeeId },
    select: { id: true, fullName: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  const appraisalId = nz(String(fd.get("appraisalId") ?? ""));
  const cycleId = nz(String(fd.get("cycleId") ?? ""));
  const count = await prisma.developmentPlan.count({ where: { employeeId: parsed.data.employeeId } });

  const plan = await prisma.developmentPlan.create({
    data: {
      employeeId: parsed.data.employeeId,
      appraisalId,
      cycleId,
      objective: parsed.data.objective,
      action: nz(String(fd.get("action") ?? "")),
      support: nz(String(fd.get("support") ?? "")),
      targetDate: parseDate(String(fd.get("targetDate") ?? "")),
      status: parsed.data.status,
      sortOrder: count,
      createdById: me.id,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "devplan.create",
    entityType: "development_plan",
    entityId: plan.id,
    metadata: { employee: employee.fullName, objective: plan.objective },
  });

  if (cycleId) revalidatePath(`/performance/${cycleId}/${parsed.data.employeeId}`);
  revalidatePath("/my-performance");
  return { ok: true, message: "Development objective added." };
}

export async function updateDevPlanAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("planId") ?? "");
  if (!id) return { ok: false, error: "Missing item." };
  const existing = await prisma.developmentPlan.findUnique({ where: { id } });
  if (!existing) return { ok: false, error: "Item not found." };

  const objective = String(fd.get("objective") ?? "").trim();
  if (objective.length < 2) return { ok: false, error: "Describe the development objective." };
  const status = String(fd.get("status") ?? "");
  if (!(DEV_STATUS as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  await prisma.developmentPlan.update({
    where: { id },
    data: {
      objective,
      action: nz(String(fd.get("action") ?? "")),
      support: nz(String(fd.get("support") ?? "")),
      targetDate: parseDate(String(fd.get("targetDate") ?? "")),
      status,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "devplan.update",
    entityType: "development_plan",
    entityId: id,
    metadata: { status },
  });

  if (existing.cycleId) revalidatePath(`/performance/${existing.cycleId}/${existing.employeeId}`);
  revalidatePath("/my-performance");
  return { ok: true, message: "Development objective updated." };
}

export async function deleteDevPlanAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("planId") ?? "");
  if (!id) return { ok: false, error: "Missing item." };
  const existing = await prisma.developmentPlan.findUnique({ where: { id } });
  if (!existing) return { ok: false, error: "Item not found." };

  await prisma.developmentPlan.delete({ where: { id } });
  await writeAudit({
    actorId: me.id,
    action: "devplan.delete",
    entityType: "development_plan",
    entityId: id,
    metadata: { objective: existing.objective },
  });

  if (existing.cycleId) revalidatePath(`/performance/${existing.cycleId}/${existing.employeeId}`);
  revalidatePath("/my-performance");
  return { ok: true, message: "Development objective removed." };
}

// ===========================================================================
// (4) PIP workflow — HR/manager authored (performance.manage); staff ACK self.
// ===========================================================================
type PipItemPayload = Record<string, unknown>;
function readItems(fd: FormData): PipItemPayload[] {
  try {
    const arr = JSON.parse(String(fd.get("items") ?? "[]"));
    return Array.isArray(arr) ? (arr as PipItemPayload[]) : [];
  } catch {
    return [];
  }
}

const pipSchema = z.object({
  employeeId: z.string().trim().min(1, "Choose the employee."),
  title: z.string().trim().min(2, "Give the plan a title."),
  concerns: z.string().trim().min(2, "Summarize the performance concerns."),
});

export async function openPipAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const parsed = pipSchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    title: String(fd.get("title") ?? ""),
    concerns: String(fd.get("concerns") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const employee = await prisma.employee.findUnique({
    where: { id: parsed.data.employeeId },
    select: { id: true, fullName: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  const items = readItems(fd)
    .map((r, i) => ({
      expectation: String(r.expectation ?? "").trim(),
      measure: nz(String(r.measure ?? "")),
      targetDate: parseDate(String(r.targetDate ?? "")),
      position: i,
    }))
    .filter((r) => r.expectation.length > 0);

  const plan = await prisma.improvementPlan.create({
    data: {
      employeeId: parsed.data.employeeId,
      title: parsed.data.title,
      concerns: parsed.data.concerns,
      support: nz(String(fd.get("support") ?? "")),
      startDate: parseDate(String(fd.get("startDate") ?? "")),
      reviewDate: parseDate(String(fd.get("reviewDate") ?? "")),
      endDate: parseDate(String(fd.get("endDate") ?? "")),
      status: "OPEN",
      createdById: me.id,
      items: { create: items.map(({ position, expectation, measure, targetDate }) => ({ position, expectation, measure, targetDate })) },
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "pip.open",
    entityType: "improvement_plan",
    entityId: plan.id,
    metadata: { employee: employee.fullName, items: items.length },
  });

  revalidatePath("/performance/pip");
  redirect(`/performance/pip/${plan.id}`);
}

export async function updatePipAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("pipId") ?? "");
  if (!id) return { ok: false, error: "Missing plan." };
  const existing = await prisma.improvementPlan.findUnique({ where: { id }, include: { items: { select: { id: true } } } });
  if (!existing) return { ok: false, error: "Plan not found." };

  const status = String(fd.get("status") ?? "");
  if (!(PIP_STATUS as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  // Per-item results (optional payload).
  const allowed = new Set(existing.items.map((i) => i.id));
  const itemResults = readItems(fd).filter((r) => allowed.has(String(r.id ?? "")));

  await prisma.$transaction(async (tx) => {
    await tx.improvementPlan.update({
      where: { id },
      data: {
        status,
        outcome: nz(String(fd.get("outcome") ?? "")),
        reviewDate: parseDate(String(fd.get("reviewDate") ?? "")) ?? existing.reviewDate,
        endDate: parseDate(String(fd.get("endDate") ?? "")) ?? existing.endDate,
      },
    });
    for (const r of itemResults) {
      const result = String(r.result ?? "PENDING");
      await tx.improvementPlanItem.update({
        where: { id: String(r.id) },
        data: {
          result: (PIP_RESULT as readonly string[]).includes(result) ? result : "PENDING",
          note: nz(String(r.note ?? "")),
        },
      });
    }
  });

  await writeAudit({
    actorId: me.id,
    action: status === "CLOSED" || status === "MET" || status === "NOT_MET" ? "pip.close" : "pip.update",
    entityType: "improvement_plan",
    entityId: id,
    metadata: { status },
  });

  revalidatePath(`/performance/pip/${id}`);
  revalidatePath("/performance/pip");
  return { ok: true, message: "Plan updated." };
}

const ackSchema = z.object({
  pipId: z.string().trim().min(1, "Missing plan."),
  ackName: z.string().trim().min(2, "Type your full name to acknowledge."),
  consent: z.literal("1", { errorMap: () => ({ message: "Please confirm you have read and discussed the plan." }) }),
});

export async function acknowledgePipAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };

  const parsed = ackSchema.safeParse({
    pipId: String(fd.get("pipId") ?? ""),
    ackName: String(fd.get("ackName") ?? ""),
    consent: String(fd.get("consent") ?? ""),
  });
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0]?.message ?? "Check the form." };

  const plan = await prisma.improvementPlan.findUnique({ where: { id: parsed.data.pipId } });
  if (!plan) return { ok: false, error: "Plan not found." };
  if (plan.employeeId !== emp.id) return { ok: false, error: "This plan isn't assigned to you." };
  if (plan.ackAt) return { ok: false, error: "You have already acknowledged this plan." };

  await prisma.improvementPlan.update({
    where: { id: plan.id },
    data: { ackName: parsed.data.ackName, ackAt: new Date(), ackIp: await clientIp() },
  });

  await writeAudit({
    actorId: me.id,
    action: "pip.acknowledge",
    entityType: "improvement_plan",
    entityId: plan.id,
    metadata: { ackName: parsed.data.ackName, employeeId: emp.id },
  });

  revalidatePath("/my-performance");
  revalidatePath(`/performance/pip/${plan.id}`);
  return { ok: true, message: "Acknowledged. Thank you." };
}
