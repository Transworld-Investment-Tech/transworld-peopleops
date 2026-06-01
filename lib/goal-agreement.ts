// Goal agreement & sign-off — shared queries and presentation helpers (v0.18.1).
// Read-only here; audited writes live in lib/goal-agreement-actions.ts.
//
// A "goal sheet" is one employee's goals for one cycle, with a review lifecycle
// and, once approved, a permanently sealed agreement. Goals themselves live in
// performance_goals, bound to the sheet by the natural key (cycleId, employeeId)
// — there is no FK column on the goal. Line-manager scope is resolved straight
// from the org chart (employee.managerId).
import { prisma } from "@/lib/db";

// ---------------------------------------------------------------------------
// Vocabularies
// ---------------------------------------------------------------------------
export const REVIEW_STATES = [
  { value: "DRAFT", label: "Draft" },
  { value: "SUBMITTED", label: "Submitted for review" },
  { value: "CHANGES_REQUESTED", label: "Changes requested" },
  { value: "APPROVED", label: "Approved & sealed" },
] as const;

export const AMENDMENT_KINDS = [
  { value: "AMEND", label: "Amend" },
  { value: "EXPAND", label: "Expand" },
  { value: "CONTRACT", label: "Contract" },
  { value: "NEW_GOAL", label: "New goal" },
  { value: "FOLLOWUP_NOTE", label: "Follow-up note" },
  { value: "NOTE", label: "Note" },
] as const;

export function reviewStateBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "APPROVED":
      return { cls: "b-grn", label: "Approved & sealed" };
    case "SUBMITTED":
      return { cls: "b-blu", label: "Submitted" };
    case "CHANGES_REQUESTED":
      return { cls: "b-amb", label: "Changes requested" };
    case "DRAFT":
      return { cls: "b-gry", label: "Draft" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function amendmentKindLabel(k: string): string {
  return AMENDMENT_KINDS.find((x) => x.value === k)?.label ?? k;
}
export function reviewStateLabel(s: string): string {
  return REVIEW_STATES.find((x) => x.value === s)?.label ?? s;
}

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

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Self-scope + org-chart scope
// ---------------------------------------------------------------------------
export async function myEmployeeLite(userId: string) {
  return prisma.employee.findUnique({
    where: { userId },
    select: { id: true, eeId: true, fullName: true, preferredName: true, managerId: true },
  });
}

/** The active direct reports of a manager (one level down the org chart). */
export async function getDirectReports(managerEmployeeId: string) {
  const rows = await prisma.employee.findMany({
    where: { managerId: managerEmployeeId, status: { in: ["ACTIVE", "PROBATION"] } },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { title: true } },
    },
    orderBy: { eeId: "asc" },
  });
  return rows.map((e) => ({
    id: e.id,
    eeId: e.eeId,
    name: personName(e),
    role: e.jobProfile?.title ?? null,
  }));
}

/** True iff `employeeId` is a direct report of the manager. The scope guard. */
export async function isDirectReport(managerEmployeeId: string, employeeId: string): Promise<boolean> {
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { managerId: true },
  });
  return !!e && e.managerId === managerEmployeeId;
}

// ---------------------------------------------------------------------------
// The current (or most recent) cycle to set goals against
// ---------------------------------------------------------------------------
export async function getActiveCycle() {
  return (
    (await prisma.appraisalCycle.findFirst({
      where: { status: "OPEN" },
      orderBy: { createdAt: "desc" },
      select: { id: true, name: true, stage: true, status: true },
    })) ??
    (await prisma.appraisalCycle.findFirst({
      orderBy: { createdAt: "desc" },
      select: { id: true, name: true, stage: true, status: true },
    }))
  );
}

// ---------------------------------------------------------------------------
// Goals bound to a sheet by natural key (cycleId, employeeId)
// ---------------------------------------------------------------------------
export type GoalRow = {
  id: string;
  title: string;
  description: string | null;
  measure: string | null;
  target: string | null;
  weight: number | null;
  dueDate: Date | null;
  status: string;
  sortOrder: number;
};

export async function getGoals(cycleId: string, employeeId: string): Promise<GoalRow[]> {
  const rows = await prisma.performanceGoal.findMany({
    where: { cycleId, employeeId },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
  });
  return rows.map((g) => ({
    id: g.id,
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

// ---------------------------------------------------------------------------
// Sheets
// ---------------------------------------------------------------------------
export async function getSheet(cycleId: string, employeeId: string) {
  return prisma.goalSheet.findUnique({
    where: { cycleId_employeeId: { cycleId, employeeId } },
  });
}

export async function getAmendments(sheetId: string) {
  return prisma.goalAmendment.findMany({
    where: { sheetId },
    orderBy: { createdAt: "asc" },
  });
}

/** Everything the employee's own goal-setting surface needs for the active cycle. */
export async function getMyGoalSetting(userId: string) {
  const employee = await myEmployeeLite(userId);
  if (!employee) return { linked: false as const };

  const cycle = await getActiveCycle();
  const sheet = cycle ? await getSheet(cycle.id, employee.id) : null;
  const goals = cycle ? await getGoals(cycle.id, employee.id) : [];
  const amendments = sheet ? await getAmendments(sheet.id) : [];

  let manager: { name: string } | null = null;
  if (employee.managerId) {
    const m = await prisma.employee.findUnique({
      where: { id: employee.managerId },
      select: { fullName: true, preferredName: true },
    });
    manager = m ? { name: personName(m) } : null;
  }

  return { linked: true as const, employee, cycle, sheet, goals, amendments, manager };
}

// ---------------------------------------------------------------------------
// Manager: my team's goal-setting status for the active cycle
// ---------------------------------------------------------------------------
export async function getTeamGoalSetting(managerUserId: string) {
  const manager = await myEmployeeLite(managerUserId);
  if (!manager) return { linked: false as const };

  const cycle = await getActiveCycle();
  const reports = await getDirectReports(manager.id);
  if (!cycle) return { linked: true as const, manager, cycle: null, rows: [] };

  const sheets = await prisma.goalSheet.findMany({
    where: { cycleId: cycle.id, employeeId: { in: reports.map((r) => r.id) } },
  });
  const byEmp = new Map<string, (typeof sheets)[number]>(
    sheets.map((s) => [s.employeeId, s] as const)
  );

  // goal counts per report
  const goals = reports.length
    ? await prisma.performanceGoal.groupBy({
        by: ["employeeId"],
        where: { cycleId: cycle.id, employeeId: { in: reports.map((r) => r.id) } },
        _count: { _all: true },
      })
    : [];
  const countByEmp = new Map(goals.map((g) => [g.employeeId, g._count._all] as const));

  const rows = reports.map((r) => {
    const s = byEmp.get(r.id);
    return {
      employeeId: r.id,
      eeId: r.eeId,
      name: r.name,
      role: r.role,
      reviewState: s?.reviewState ?? "DRAFT",
      sealed: !!s?.sealed,
      goalCount: countByEmp.get(r.id) ?? 0,
      submittedAt: s?.submittedAt ?? null,
      approvedAt: s?.approvedAt ?? null,
      acknowledged: !!s?.ackAt,
    };
  });

  return { linked: true as const, manager, cycle, rows };
}

/** Manager: one report's full sheet for review. Returns null if not a report. */
export async function getReportSheetForReview(managerUserId: string, employeeId: string) {
  const manager = await myEmployeeLite(managerUserId);
  if (!manager) return { ok: false as const, reason: "no-manager" as const };
  if (!(await isDirectReport(manager.id, employeeId)))
    return { ok: false as const, reason: "not-a-report" as const };

  const cycle = await getActiveCycle();
  if (!cycle) return { ok: false as const, reason: "no-cycle" as const };

  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true, preferredName: true, jobProfile: { select: { title: true } } },
  });
  if (!employee) return { ok: false as const, reason: "not-found" as const };

  const [sheet, goals] = await Promise.all([
    getSheet(cycle.id, employeeId),
    getGoals(cycle.id, employeeId),
  ]);
  const amendments = sheet ? await getAmendments(sheet.id) : [];

  return {
    ok: true as const,
    cycle,
    employee: {
      id: employee.id,
      eeId: employee.eeId,
      name: personName(employee),
      role: employee.jobProfile?.title ?? null,
    },
    sheet,
    goals,
    amendments,
  };
}

// ---------------------------------------------------------------------------
// HR stewardship: org-wide goal-setting status for a cycle (read-only)
// ---------------------------------------------------------------------------
export async function getGoalSettingOverview(cycleId: string) {
  const sheets = await prisma.goalSheet.findMany({ where: { cycleId } });
  const counts = { total: sheets.length, draft: 0, submitted: 0, changes: 0, approved: 0 };
  for (const s of sheets) {
    if (s.reviewState === "APPROVED") counts.approved += 1;
    else if (s.reviewState === "SUBMITTED") counts.submitted += 1;
    else if (s.reviewState === "CHANGES_REQUESTED") counts.changes += 1;
    else counts.draft += 1;
  }
  return counts;
}
