// Read-side helpers for the Onboarding & Probation module. Pure formatters +
// badge mappers and the queries that back the onboarding list and the per-hire
// checklist + probation tracker. No writes here — those live in
// lib/onboarding-actions.ts. The plan's employee_id is a bare column, resolved
// by lookup here.
import { prisma } from "@/lib/db";

// The starter induction checklist seeded by the in-app "Seed default tasks"
// button. HR can add/remove/edit tasks afterward.
export const DEFAULT_TASKS: { label: string; category: string }[] = [
  { label: "Signed contract & offer letter on file", category: "Paperwork" },
  { label: "Bank & pension details collected", category: "Paperwork" },
  { label: "Guarantor forms received", category: "Paperwork" },
  { label: "Workstation & system access", category: "IT" },
  { label: "Employee handbook acknowledged", category: "Compliance" },
  { label: "AML/KYC induction training assigned", category: "Compliance" },
  { label: "Meet line manager", category: "Orientation" },
  { label: "30/60/90-day goals set with manager", category: "Orientation" },
];

export const TASK_STATUSES = ["PENDING", "IN_PROGRESS", "DONE", "WAIVED"] as const;
export type TaskStatus = (typeof TASK_STATUSES)[number];

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

export function isTaskOverdue(status: string, dueDate: Date | null | undefined): boolean {
  if (status === "DONE" || status === "WAIVED") return false;
  if (!dueDate) return false;
  return new Date(dueDate).getTime() < Date.now();
}

export function taskStatusBadge(
  status: string,
  dueDate: Date | null | undefined
): { cls: string; label: string } {
  if (isTaskOverdue(status, dueDate)) return { cls: "b-red", label: "Outstanding" };
  switch (status) {
    case "DONE":
      return { cls: "b-grn", label: "Done" };
    case "IN_PROGRESS":
      return { cls: "b-amb", label: "In progress" };
    case "WAIVED":
      return { cls: "b-gry", label: "Waived" };
    default:
      return { cls: "b-gry", label: "Pending" };
  }
}

export function planStatusBadge(status: string): { cls: string; label: string } {
  switch (status) {
    case "COMPLETE":
      return { cls: "b-grn", label: "Complete" };
    case "IN_PROGRESS":
      return { cls: "b-amb", label: "In progress" };
    default:
      return { cls: "b-gry", label: "Not started" };
  }
}

export type Progress = { done: number; total: number; pct: number };

export function progressOf(tasks: { status: string }[]): Progress {
  const total = tasks.length;
  const done = tasks.filter((t) => t.status === "DONE" || t.status === "WAIVED").length;
  const pct = total ? Math.round((done / total) * 100) : 0;
  return { done, total, pct };
}

export type Probation = {
  startDate: Date | null;
  probationMonths: number;
  confirmationDue: Date | null;
  review30Due: Date | null;
  daysUntilReview: number | null;
  review30Scheduled: boolean;
};

export function deriveProbation(
  startDate: Date | null,
  probationMonths: number,
  review30ScheduledAt: Date | null
): Probation {
  if (!startDate) {
    return {
      startDate: null,
      probationMonths,
      confirmationDue: null,
      review30Due: null,
      daysUntilReview: null,
      review30Scheduled: !!review30ScheduledAt,
    };
  }
  const confirmationDue = new Date(startDate);
  confirmationDue.setMonth(confirmationDue.getMonth() + probationMonths);
  const review30Due = new Date(new Date(startDate).getTime() + 30 * 86400000);
  const daysUntilReview = Math.ceil((review30Due.getTime() - Date.now()) / 86400000);
  return {
    startDate,
    probationMonths,
    confirmationDue,
    review30Due,
    daysUntilReview,
    review30Scheduled: !!review30ScheduledAt,
  };
}

export type OnboardingRow = {
  employeeId: string;
  name: string;
  eeId: string;
  employeeStatus: string;
  planStatus: string;
  startDate: Date | null;
  done: number;
  total: number;
  pct: number;
};

export type EligibleEmployee = { id: string; eeId: string; name: string; status: string };

export type OnboardingList = {
  rows: OnboardingRow[];
  eligible: EligibleEmployee[];
};

export async function getOnboardingList(): Promise<OnboardingList> {
  const plans = await prisma.onboardingPlan.findMany({
    orderBy: { createdAt: "desc" },
    include: { tasks: { select: { status: true } } },
  });
  const empIds = plans.map((p) => p.employeeId);
  type EmpLite = {
    id: string;
    eeId: string;
    fullName: string;
    preferredName: string | null;
    status: string;
    startDate: Date | null;
  };
  const emps: EmpLite[] = empIds.length
    ? await prisma.employee.findMany({
        where: { id: { in: empIds } },
        select: { id: true, eeId: true, fullName: true, preferredName: true, status: true, startDate: true },
      })
    : [];
  const byId = new Map<string, EmpLite>(emps.map((e) => [e.id, e] as const));

  const rows: OnboardingRow[] = plans.map((p) => {
    const e = byId.get(p.employeeId);
    const prog = progressOf(p.tasks);
    return {
      employeeId: p.employeeId,
      name: e ? personName(e) : "(unknown)",
      eeId: e?.eeId ?? "—",
      employeeStatus: e ? String(e.status) : "—",
      planStatus: p.status,
      startDate: p.startDate ?? e?.startDate ?? null,
      done: prog.done,
      total: prog.total,
      pct: prog.pct,
    };
  });

  const eligibleWhere = empIds.length
    ? { status: { not: "EXITED" as const }, id: { notIn: empIds } }
    : { status: { not: "EXITED" as const } };
  const eligibleRows = await prisma.employee.findMany({
    where: eligibleWhere,
    orderBy: { eeId: "asc" },
    select: { id: true, eeId: true, fullName: true, preferredName: true, status: true },
  });
  const eligible: EligibleEmployee[] = eligibleRows.map((e) => ({
    id: e.id,
    eeId: e.eeId,
    name: personName(e),
    status: String(e.status),
  }));

  return { rows, eligible };
}

export type OnboardingTaskView = {
  id: string;
  label: string;
  category: string | null;
  status: string;
  dueDate: Date | null;
};

export type OnboardingDetail = {
  employee: { id: string; eeId: string; name: string; status: string; startDate: Date | null };
  plan: {
    id: string;
    status: string;
    probation: Probation;
    tasks: OnboardingTaskView[];
    progress: Progress;
  } | null;
};

export async function getOnboardingDetail(employeeId: string): Promise<OnboardingDetail | null> {
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true, preferredName: true, status: true, startDate: true },
  });
  if (!e) return null;

  const plan = await prisma.onboardingPlan.findUnique({
    where: { employeeId },
    include: { tasks: { orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }] } },
  });

  return {
    employee: {
      id: e.id,
      eeId: e.eeId,
      name: personName(e),
      status: String(e.status),
      startDate: e.startDate,
    },
    plan: plan
      ? {
          id: plan.id,
          status: plan.status,
          probation: deriveProbation(
            plan.startDate ?? e.startDate ?? null,
            plan.probationMonths,
            plan.review30ScheduledAt
          ),
          tasks: plan.tasks.map((t) => ({
            id: t.id,
            label: t.label,
            category: t.category,
            status: t.status,
            dueDate: t.dueDate,
          })),
          progress: progressOf(plan.tasks),
        }
      : null,
  };
}
