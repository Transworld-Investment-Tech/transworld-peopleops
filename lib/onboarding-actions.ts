"use server";
// Write-side server actions for Onboarding & Probation. Every mutation is gated
// by onboarding.manage, validated, and writes an audit_logs row. Updates are
// scoped to the parent plan's own children (never trust a client-supplied id).
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { DEFAULT_TASKS, TASK_STATUSES } from "@/lib/onboarding";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

function nz(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}

function parseDateUTC(v: FormDataEntryValue | null): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(`${s}T00:00:00.000Z`);
  return Number.isNaN(d.getTime()) ? null : d;
}

async function refreshPlanCompletion(planId: string): Promise<void> {
  const [total, open] = await Promise.all([
    prisma.onboardingTask.count({ where: { planId } }),
    prisma.onboardingTask.count({
      where: { planId, status: { notIn: ["DONE", "WAIVED"] } },
    }),
  ]);
  const complete = total > 0 && open === 0;
  await prisma.onboardingPlan.update({
    where: { id: planId },
    data: { status: complete ? "COMPLETE" : "IN_PROGRESS", completedAt: complete ? new Date() : null },
  });
}

// --- Start onboarding (create a plan for an eligible employee) --------------
export async function startOnboardingAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!employeeId) return { ok: false, error: "Choose an employee." };

  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, status: true, startDate: true },
  });
  if (!e) return { ok: false, error: "Employee not found." };
  if (String(e.status) === "EXITED") return { ok: false, error: "That employee has exited." };

  const existing = await prisma.onboardingPlan.findUnique({
    where: { employeeId },
    select: { id: true },
  });
  if (existing) {
    // Already has a plan — just go to it.
    redirect(`/onboarding/${employeeId}`);
  }

  await prisma.onboardingPlan.create({
    data: {
      employeeId,
      startDate: e.startDate ?? new Date(),
      probationMonths: 3,
      status: "IN_PROGRESS",
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "onboardingplan.create",
    entityType: "OnboardingPlan",
    entityId: employeeId,
    metadata: {},
  });
  revalidatePath("/onboarding");
  redirect(`/onboarding/${employeeId}`);
}

// --- Seed the default checklist ---------------------------------------------
export async function seedDefaultTasksAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const planId = String(fd.get("planId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!planId || !employeeId) return { ok: false, error: "Missing plan." };

  const plan = await prisma.onboardingPlan.findFirst({
    where: { id: planId, employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "Plan not found." };

  const existing = await prisma.onboardingTask.findMany({
    where: { planId },
    select: { label: true, sortOrder: true },
  });
  const have = new Set(existing.map((t) => t.label));
  let order = existing.reduce((m, t) => Math.max(m, t.sortOrder), -1);
  const toAdd = DEFAULT_TASKS.filter((t) => !have.has(t.label)).map((t) => ({
    planId,
    label: t.label,
    category: t.category,
    sortOrder: ++order,
  }));
  if (toAdd.length) {
    await prisma.onboardingTask.createMany({ data: toAdd });
    await refreshPlanCompletion(planId);
  }
  await writeAudit({
    actorId: me.id,
    action: "onboardingtask.seed",
    entityType: "OnboardingPlan",
    entityId: employeeId,
    metadata: { added: toAdd.length },
  });
  revalidatePath(`/onboarding/${employeeId}`);
  return { ok: true };
}

// --- Add a single task ------------------------------------------------------
const taskSchema = z.object({
  planId: z.string().min(1),
  employeeId: z.string().min(1),
  label: z.string().trim().min(2, "Task label is required"),
  category: z.string().trim().optional().or(z.literal("")),
});

export async function addTaskAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const parsed = taskSchema.safeParse({
    planId: fd.get("planId"),
    employeeId: fd.get("employeeId"),
    label: fd.get("label"),
    category: fd.get("category"),
  });
  if (!parsed.success) {
    const fe: Record<string, string> = {};
    for (const i of parsed.error.issues) fe[String(i.path[0])] = i.message;
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: fe };
  }
  const plan = await prisma.onboardingPlan.findFirst({
    where: { id: parsed.data.planId, employeeId: parsed.data.employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "Plan not found." };

  const max = await prisma.onboardingTask.aggregate({
    where: { planId: parsed.data.planId },
    _max: { sortOrder: true },
  });
  await prisma.onboardingTask.create({
    data: {
      planId: parsed.data.planId,
      label: parsed.data.label,
      category: nz(parsed.data.category ?? null),
      dueDate: parseDateUTC(fd.get("dueDate")),
      sortOrder: (max._max.sortOrder ?? -1) + 1,
    },
  });
  await refreshPlanCompletion(parsed.data.planId);
  await writeAudit({
    actorId: me.id,
    action: "onboardingtask.create",
    entityType: "OnboardingPlan",
    entityId: parsed.data.employeeId,
    metadata: { label: parsed.data.label },
  });
  revalidatePath(`/onboarding/${parsed.data.employeeId}`);
  return { ok: true };
}

// --- Set a task's status ----------------------------------------------------
export async function setTaskStatusAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const taskId = String(fd.get("taskId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  const status = String(fd.get("status") ?? "");
  if (!taskId || !employeeId) return { ok: false, error: "Missing task." };
  if (!(TASK_STATUSES as readonly string[]).includes(status)) {
    return { ok: false, error: "Invalid status." };
  }
  // Scope: the task must belong to this employee's plan.
  const task = await prisma.onboardingTask.findUnique({
    where: { id: taskId },
    select: { id: true, planId: true, plan: { select: { employeeId: true } } },
  });
  if (!task || task.plan.employeeId !== employeeId) {
    return { ok: false, error: "Task not found." };
  }
  await prisma.onboardingTask.update({
    where: { id: taskId },
    data: { status, doneAt: status === "DONE" ? new Date() : null },
  });
  await refreshPlanCompletion(task.planId);
  await writeAudit({
    actorId: me.id,
    action: "onboardingtask.set_status",
    entityType: "OnboardingTask",
    entityId: taskId,
    metadata: { status },
  });
  revalidatePath(`/onboarding/${employeeId}`);
  return { ok: true };
}

// --- Set probation (start date + length) ------------------------------------
const probationSchema = z.object({
  planId: z.string().min(1),
  employeeId: z.string().min(1),
  probationMonths: z.coerce.number().int().min(0).max(24),
});

export async function setProbationAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const parsed = probationSchema.safeParse({
    planId: fd.get("planId"),
    employeeId: fd.get("employeeId"),
    probationMonths: fd.get("probationMonths") || "3",
  });
  if (!parsed.success) return { ok: false, error: "Enter a probation length in months (0–24)." };

  const plan = await prisma.onboardingPlan.findFirst({
    where: { id: parsed.data.planId, employeeId: parsed.data.employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "Plan not found." };

  await prisma.onboardingPlan.update({
    where: { id: parsed.data.planId },
    data: {
      probationMonths: parsed.data.probationMonths,
      startDate: parseDateUTC(fd.get("startDate")) ?? undefined,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "onboardingplan.set_probation",
    entityType: "OnboardingPlan",
    entityId: parsed.data.employeeId,
    metadata: { probationMonths: parsed.data.probationMonths },
  });
  revalidatePath(`/onboarding/${parsed.data.employeeId}`);
  return { ok: true };
}

// --- Schedule the 30-day review ---------------------------------------------
export async function scheduleReviewAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const planId = String(fd.get("planId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!planId || !employeeId) return { ok: false, error: "Missing plan." };

  const plan = await prisma.onboardingPlan.findFirst({
    where: { id: planId, employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "Plan not found." };

  await prisma.onboardingPlan.update({
    where: { id: planId },
    data: { review30ScheduledAt: new Date() },
  });
  await writeAudit({
    actorId: me.id,
    action: "onboardingplan.schedule_review",
    entityType: "OnboardingPlan",
    entityId: employeeId,
    metadata: {},
  });
  revalidatePath(`/onboarding/${employeeId}`);
  return { ok: true };
}
