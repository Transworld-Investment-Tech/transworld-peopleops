// Performance toolkit — shared queries and presentation helpers (v0.18.0).
// Read-only here; the audited writes live in lib/performance-toolkit-actions.ts.
//
// Activates the four toolkit actions on top of the v0.10.0 cycle/appraisal layer:
//   (1) goal-setting        -> performance_goals
//   (2) weekly reporting     -> weekly_reports
//   (3) development plan     -> development_plans
//   (4) PIP workflow         -> improvement_plans (+ items)
//
// Cross-entity references (employee_id, cycle_id, appraisal_id) are bare columns
// on the new tables (their FKs are enforced in SQL), so this module resolves
// employee names by lookup rather than via a Prisma relation.
import { prisma } from "@/lib/db";

// ---------------------------------------------------------------------------
// Vocabularies
// ---------------------------------------------------------------------------
export const GOAL_STATUSES = [
  { value: "DRAFT", label: "Draft" },
  { value: "ACTIVE", label: "Active" },
  { value: "ACHIEVED", label: "Achieved" },
  { value: "PARTIAL", label: "Partly met" },
  { value: "MISSED", label: "Missed" },
  { value: "DROPPED", label: "Dropped" },
] as const;

export const DEV_STATUSES = [
  { value: "OPEN", label: "Open" },
  { value: "IN_PROGRESS", label: "In progress" },
  { value: "DONE", label: "Done" },
] as const;

export const PIP_STATUSES = [
  { value: "OPEN", label: "Open" },
  { value: "IN_PROGRESS", label: "In progress" },
  { value: "MET", label: "Met" },
  { value: "NOT_MET", label: "Not met" },
  { value: "EXTENDED", label: "Extended" },
  { value: "CLOSED", label: "Closed" },
] as const;

export const PIP_RESULTS = [
  { value: "PENDING", label: "Pending" },
  { value: "MET", label: "Met" },
  { value: "NOT_MET", label: "Not met" },
] as const;

// ---------------------------------------------------------------------------
// Badges (reuse the house b-grn / b-amb / b-blu / b-gry / b-red palette)
// ---------------------------------------------------------------------------
export function goalStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "ACHIEVED":
      return { cls: "b-grn", label: "Achieved" };
    case "ACTIVE":
      return { cls: "b-blu", label: "Active" };
    case "PARTIAL":
      return { cls: "b-amb", label: "Partly met" };
    case "MISSED":
      return { cls: "b-red", label: "Missed" };
    case "DROPPED":
      return { cls: "b-gry", label: "Dropped" };
    case "DRAFT":
      return { cls: "b-gry", label: "Draft" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function devStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "DONE":
      return { cls: "b-grn", label: "Done" };
    case "IN_PROGRESS":
      return { cls: "b-blu", label: "In progress" };
    case "OPEN":
      return { cls: "b-amb", label: "Open" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function pipStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "MET":
      return { cls: "b-grn", label: "Met" };
    case "CLOSED":
      return { cls: "b-gry", label: "Closed" };
    case "IN_PROGRESS":
      return { cls: "b-blu", label: "In progress" };
    case "EXTENDED":
      return { cls: "b-amb", label: "Extended" };
    case "OPEN":
      return { cls: "b-amb", label: "Open" };
    case "NOT_MET":
      return { cls: "b-red", label: "Not met" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function pipResultBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "MET":
      return { cls: "b-grn", label: "Met" };
    case "NOT_MET":
      return { cls: "b-red", label: "Not met" };
    default:
      return { cls: "b-gry", label: "Pending" };
  }
}

export function goalStatusLabel(s: string): string {
  return GOAL_STATUSES.find((x) => x.value === s)?.label ?? s;
}
export function devStatusLabel(s: string): string {
  return DEV_STATUSES.find((x) => x.value === s)?.label ?? s;
}
export function pipStatusLabel(s: string): string {
  return PIP_STATUSES.find((x) => x.value === s)?.label ?? s;
}

// ---------------------------------------------------------------------------
// Date helpers
// ---------------------------------------------------------------------------
export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

export function fmtDateTime(d: Date | null | undefined): string {
  if (!d) return "—";
  return d.toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

/** Monday (00:00 UTC) of the ISO week containing `d`. Used to key weekly reports. */
export function isoWeekStart(d: Date): Date {
  const x = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
  const day = x.getUTCDay(); // 0 Sun .. 6 Sat
  const diff = day === 0 ? -6 : 1 - day; // back to Monday
  x.setUTCDate(x.getUTCDate() + diff);
  return x;
}

/** "Week of Jun 1 – Jun 7, 2026" style label. */
export function weekRangeLabel(weekStart: Date): string {
  const end = new Date(weekStart);
  end.setUTCDate(end.getUTCDate() + 6);
  const o: Intl.DateTimeFormatOptions = { month: "short", day: "numeric", timeZone: "UTC" };
  const oy: Intl.DateTimeFormatOptions = { ...o, year: "numeric" };
  return `${weekStart.toLocaleDateString("en-US", o)} – ${end.toLocaleDateString("en-US", oy)}`;
}

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Self-scope: the employee linked to a signed-in user
// ---------------------------------------------------------------------------
export async function myEmployeeLite(userId: string) {
  return prisma.employee.findUnique({
    where: { userId },
    select: { id: true, eeId: true, fullName: true, preferredName: true },
  });
}

// ---------------------------------------------------------------------------
// Goals
// ---------------------------------------------------------------------------
export type GoalRow = {
  id: string;
  cycleId: string;
  title: string;
  description: string | null;
  measure: string | null;
  target: string | null;
  weight: number | null;
  dueDate: Date | null;
  status: string;
  sortOrder: number;
};

export async function getGoalsForEmployee(employeeId: string, cycleId?: string): Promise<GoalRow[]> {
  const rows = await prisma.performanceGoal.findMany({
    where: { employeeId, ...(cycleId ? { cycleId } : {}) },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
  });
  return rows.map((g) => ({
    id: g.id,
    cycleId: g.cycleId,
    title: g.title,
    description: g.description,
    measure: g.measure,
    target: g.target,
    weight: g.weight,
    dueDate: g.dueDate,
    status: g.status,
    sortOrder: g.sortOrder,
  }));
}

/** Cycle-level goals overview: every appraisable-or-goaled employee with a count. */
export async function getGoalsOverview(cycleId: string) {
  const goals = await prisma.performanceGoal.findMany({
    where: { cycleId },
    select: { id: true, employeeId: true, status: true },
  });
  const byEmp = new Map<string, { total: number; active: number; achieved: number }>();
  for (const g of goals) {
    const e = byEmp.get(g.employeeId) ?? { total: 0, active: 0, achieved: 0 };
    e.total += 1;
    if (g.status === "ACTIVE" || g.status === "DRAFT") e.active += 1;
    if (g.status === "ACHIEVED") e.achieved += 1;
    byEmp.set(g.employeeId, e);
  }
  const empIds = [...byEmp.keys()];
  const employees: { id: string; eeId: string; fullName: string; preferredName: string | null }[] =
    empIds.length
      ? await prisma.employee.findMany({
          where: { id: { in: empIds } },
          select: { id: true, eeId: true, fullName: true, preferredName: true },
        })
      : [];
  return employees
    .map((e) => ({
      employeeId: e.id,
      eeId: e.eeId,
      name: personName(e),
      ...(byEmp.get(e.id) ?? { total: 0, active: 0, achieved: 0 }),
    }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

// ---------------------------------------------------------------------------
// Weekly reports
// ---------------------------------------------------------------------------
export async function getWeeklyReports(employeeId: string, limit = 12) {
  return prisma.weeklyReport.findMany({
    where: { employeeId },
    orderBy: { weekStart: "desc" },
    take: limit,
  });
}

export async function getWeeklyReport(employeeId: string, weekStart: Date) {
  return prisma.weeklyReport.findUnique({
    where: { employeeId_weekStart: { employeeId, weekStart } },
  });
}

// ---------------------------------------------------------------------------
// Development plans
// ---------------------------------------------------------------------------
export async function getDevelopmentPlans(employeeId: string, appraisalId?: string | null) {
  return prisma.developmentPlan.findMany({
    where: { employeeId, ...(appraisalId ? { appraisalId } : {}) },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
  });
}

// ---------------------------------------------------------------------------
// PIPs
// ---------------------------------------------------------------------------
export type PipListRow = {
  id: string;
  title: string;
  employeeId: string;
  employeeName: string;
  eeId: string;
  status: string;
  startDate: Date | null;
  reviewDate: Date | null;
  endDate: Date | null;
  acknowledged: boolean;
  itemCount: number;
};

export async function getPips(): Promise<PipListRow[]> {
  const plans = await prisma.improvementPlan.findMany({
    orderBy: [{ createdAt: "desc" }],
    include: { items: { select: { id: true } } },
  });
  const empIds = [...new Set(plans.map((p) => p.employeeId))];
  const employees: { id: string; eeId: string; fullName: string; preferredName: string | null }[] =
    empIds.length
      ? await prisma.employee.findMany({
          where: { id: { in: empIds } },
          select: { id: true, eeId: true, fullName: true, preferredName: true },
        })
      : [];
  const byId = new Map(employees.map((e) => [e.id, e] as const));
  return plans.map((p) => {
    const e = byId.get(p.employeeId);
    return {
      id: p.id,
      title: p.title,
      employeeId: p.employeeId,
      employeeName: e ? personName(e) : "—",
      eeId: e?.eeId ?? "—",
      status: p.status,
      startDate: p.startDate,
      reviewDate: p.reviewDate,
      endDate: p.endDate,
      acknowledged: !!p.ackAt,
      itemCount: p.items.length,
    };
  });
}

export async function getPip(id: string) {
  const plan = await prisma.improvementPlan.findUnique({
    where: { id },
    include: { items: { orderBy: [{ position: "asc" }, { createdAt: "asc" }] } },
  });
  if (!plan) return null;
  const employee = await prisma.employee.findUnique({
    where: { id: plan.employeeId },
    select: { id: true, eeId: true, fullName: true, preferredName: true },
  });
  return {
    plan,
    employee: employee
      ? { id: employee.id, eeId: employee.eeId, name: personName(employee) }
      : null,
  };
}

/** The appraisable roster for opening a PIP / setting goals against people. */
export async function getActiveEmployeesLite() {
  const employees = await prisma.employee.findMany({
    where: { status: { in: ["ACTIVE", "PROBATION"] } },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { title: true } },
    },
    orderBy: { eeId: "asc" },
  });
  return employees.map((e) => ({
    id: e.id,
    eeId: e.eeId,
    name: personName(e),
    role: e.jobProfile?.title ?? null,
  }));
}

// ---------------------------------------------------------------------------
// "My Performance" — everything the self-service surface needs for one user
// ---------------------------------------------------------------------------
export async function getMyPerformance(userId: string) {
  const employee = await myEmployeeLite(userId);
  if (!employee) return { linked: false as const };

  // The cycle to show goals against: latest OPEN, else latest of any status.
  const cycle =
    (await prisma.appraisalCycle.findFirst({
      where: { status: "OPEN" },
      orderBy: { createdAt: "desc" },
    })) ?? (await prisma.appraisalCycle.findFirst({ orderBy: { createdAt: "desc" } }));

  const [goals, weekly, devPlans, openPips] = await Promise.all([
    cycle ? getGoalsForEmployee(employee.id, cycle.id) : Promise.resolve([] as GoalRow[]),
    getWeeklyReports(employee.id, 8),
    getDevelopmentPlans(employee.id),
    prisma.improvementPlan.findMany({
      where: { employeeId: employee.id, status: { notIn: ["CLOSED"] } },
      include: { items: { orderBy: [{ position: "asc" }, { createdAt: "asc" }] } },
      orderBy: { createdAt: "desc" },
    }),
  ]);

  const thisWeek = isoWeekStart(new Date());
  const thisWeekReport = weekly.find((w) => +w.weekStart === +thisWeek) ?? null;

  return {
    linked: true as const,
    employee,
    cycle: cycle ? { id: cycle.id, name: cycle.name, stage: cycle.stage, status: cycle.status } : null,
    goals: goals.filter((g) => g.status !== "DRAFT"),
    weekly,
    thisWeek,
    thisWeekReport,
    devPlans,
    pips: openPips,
  };
}
