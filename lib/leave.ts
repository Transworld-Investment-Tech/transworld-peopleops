// Read-side helpers for the Leave module. Pure formatters + badge mappers, the
// working-day counter the request form and actions share, and the queries that
// back the Leave page, the Balances editor and the Types editor. No writes here
// — those live in lib/leave-actions.ts. Mirrors the shape of lib/compensation.ts.
import { prisma } from "@/lib/db";
import type { CurrentUser } from "@/lib/auth/rbac";
import { empInitials } from "@/lib/employees";

// ---------------------------------------------------------------------------
// Constants & small helpers
// ---------------------------------------------------------------------------

/** The leave year the portal is currently working in (calendar year of today). */
export function leaveYear(): number {
  return new Date().getFullYear();
}

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = Number(v);
  return Number.isNaN(n) ? 0 : n;
}

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

/** A friendly given name from a preferred name or a "LAST, FIRST MIDDLE" full name. */
export function firstName(e: { preferredName: string | null; fullName: string }): string {
  const pref = e.preferredName?.trim();
  if (pref) return pref.split(/\s+/)[0];
  const fn = (e.fullName || "").trim();
  if (fn.includes(",")) return (fn.split(",")[1] ?? "").trim().split(/\s+/)[0] || fn;
  return fn.split(/\s+/)[0] || fn;
}

/** Days shown without trailing ".0" but keeping ".5" for half days. */
export function fmtDays(n: number): string {
  return Number.isInteger(n) ? String(n) : n.toFixed(1);
}

function d(date: Date): string {
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}
function dY(date: Date): string {
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

/** Compact inclusive range, e.g. "10–14 Jun" or "26 May – 2 Jun". */
export function fmtDateRange(start: Date, end: Date): string {
  const sameMonth =
    start.getUTCFullYear() === end.getUTCFullYear() &&
    start.getUTCMonth() === end.getUTCMonth();
  if (start.getTime() === end.getTime()) return dY(start);
  if (sameMonth) {
    const month = start.toLocaleDateString("en-US", { month: "short" });
    return `${start.getUTCDate()}–${end.getUTCDate()} ${month}`;
  }
  return `${d(start)} – ${dY(end)}`;
}

/**
 * Inclusive count of weekdays (Mon–Fri) between two dates, computed in UTC so a
 * date-only input ("2026-06-10") isn't shifted by the server timezone. There is
 * no public-holiday calendar in v0.14.0, so only weekends are excluded.
 */
export function workingDaysBetween(start: Date, end: Date): number {
  const a = Date.UTC(start.getUTCFullYear(), start.getUTCMonth(), start.getUTCDate());
  const b = Date.UTC(end.getUTCFullYear(), end.getUTCMonth(), end.getUTCDate());
  if (b < a) return 0;
  let count = 0;
  for (let t = a; t <= b; t += 86400000) {
    const day = new Date(t).getUTCDay(); // 0 Sun … 6 Sat
    if (day !== 0 && day !== 6) count += 1;
  }
  return count;
}

/** Days a request consumes: a half day (only valid on a single date) or the weekday span. */
export function computeRequestDays(start: Date, end: Date, half: boolean): number {
  if (half) return start.getTime() === end.getTime() ? 0.5 : 0;
  return workingDaysBetween(start, end);
}

export function statusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PENDING":
      return { cls: "b-amb", label: "Pending" };
    case "APPROVED":
      return { cls: "b-grn", label: "Approved" };
    case "REJECTED":
      return { cls: "b-red", label: "Rejected" };
    case "CANCELLED":
      return { cls: "b-gry", label: "Cancelled" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function managerStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PENDING":
      return { cls: "b-amb", label: "Awaiting manager" };
    case "RECOMMENDED":
      return { cls: "b-grn", label: "Recommended" };
    case "DECLINED":
      return { cls: "b-red", label: "Declined" };
    default:
      return { cls: "b-gry", label: s };
  }
}

// ---------------------------------------------------------------------------
// Shared row + view types
// ---------------------------------------------------------------------------

export type LeaveTypeRow = { id: string; name: string; daysPerYear: number };

export type BalanceRow = {
  leaveTypeId: string;
  typeName: string;
  entitled: number;
  taken: number;
  remaining: number;
  hasRow: boolean;
};

export type RequestRow = {
  id: string;
  employeeId: string;
  employeeName: string;
  firstName: string;
  eeId: string;
  initials: string;
  leaveTypeId: string;
  typeName: string;
  startDate: Date;
  endDate: Date;
  dateRange: string;
  days: number;
  status: string;
  note: string | null;
  managerStatus: string;
  managerReviewer: string | null;
  managerReviewedAt: Date | null;
  managerNote: string | null;
  approver: string | null;
  decidedAt: Date | null;
  decisionNote: string | null;
  createdAt: Date;
  needsManager: boolean;
  // viewer-relative flags
  selfApproval: boolean; // the requester is the signed-in user (HR self-approval)
  canReviewAsManager: boolean; // the viewer is this requester's line manager and a review is due
  canDecide: boolean; // HR may take the final decision now
  awaitingManager: boolean; // HR is blocked until the manager reviews
  canCancel: boolean;
  canEdit: boolean; // owner / line manager / HR may modify while pending
};

type RawRequest = {
  id: string;
  employeeId: string;
  leaveTypeId: string;
  startDate: Date;
  endDate: Date;
  days: unknown;
  status: string;
  note: string | null;
  managerStatus: string;
  managerReviewerId: string | null;
  managerReviewedAt: Date | null;
  managerNote: string | null;
  approverId: string | null;
  decidedAt: Date | null;
  decisionNote: string | null;
  createdAt: Date;
  employee: {
    eeId: string;
    fullName: string;
    preferredName: string | null;
    userId: string | null;
    managerId: string | null;
  };
  leaveType: { name: string };
};

const REQUEST_INCLUDE = {
  employee: {
    select: { eeId: true, fullName: true, preferredName: true, userId: true, managerId: true },
  },
  leaveType: { select: { name: true } },
} as const;

// ---------------------------------------------------------------------------
// Viewer context
// ---------------------------------------------------------------------------

export type Viewer = {
  employeeId: string | null;
  employeeName: string | null;
  managerId: string | null;
  canManage: boolean; // holds leave.manage (the HR decision side)
  isManager: boolean; // line-manages at least one non-exited report
  reportIds: Set<string>;
};

export async function resolveViewer(me: CurrentUser): Promise<Viewer> {
  const employee = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true, fullName: true, preferredName: true, managerId: true },
  });
  const canManage = me.permissions.has("leave.manage");

  let reportIds = new Set<string>();
  if (employee) {
    const reports = await prisma.employee.findMany({
      where: { managerId: employee.id, status: { not: "EXITED" } },
      select: { id: true },
    });
    reportIds = new Set(reports.map((r) => r.id));
  }

  return {
    employeeId: employee?.id ?? null,
    employeeName: employee ? personName(employee) : null,
    managerId: employee?.managerId ?? null,
    canManage,
    isManager: reportIds.size > 0,
    reportIds,
  };
}

// ---------------------------------------------------------------------------
// Row hydration (resolve approver / manager-reviewer user names in one query)
// ---------------------------------------------------------------------------

async function hydrateRows(
  raw: RawRequest[],
  me: CurrentUser,
  viewer: Viewer
): Promise<RequestRow[]> {
  const userIds = new Set<string>();
  for (const r of raw) {
    if (r.approverId) userIds.add(r.approverId);
    if (r.managerReviewerId) userIds.add(r.managerReviewerId);
  }
  const nameById = new Map<string, string>();
  if (userIds.size) {
    const users = await prisma.user.findMany({
      where: { id: { in: [...userIds] } },
      select: { id: true, name: true },
    });
    for (const u of users) nameById.set(u.id, u.name);
  }

  return raw.map((r) => {
    const needsManager = !!r.employee.managerId;
    const isPending = r.status === "PENDING";
    const managerReviewed = r.managerStatus !== "PENDING";
    const isOwner = r.employee.userId === me.id;
    const isLineManager =
      !!viewer.employeeId && r.employee.managerId === viewer.employeeId;

    const awaitingManager =
      viewer.canManage && isPending && needsManager && !managerReviewed;

    return {
      id: r.id,
      employeeId: r.employeeId,
      employeeName: personName(r.employee),
      firstName: firstName(r.employee),
      eeId: r.employee.eeId,
      initials: empInitials(r.employee.fullName),
      leaveTypeId: r.leaveTypeId,
      typeName: r.leaveType.name,
      startDate: r.startDate,
      endDate: r.endDate,
      dateRange: fmtDateRange(r.startDate, r.endDate),
      days: num(r.days),
      status: r.status,
      note: r.note,
      managerStatus: r.managerStatus,
      managerReviewer: r.managerReviewerId ? nameById.get(r.managerReviewerId) ?? null : null,
      managerReviewedAt: r.managerReviewedAt,
      managerNote: r.managerNote,
      approver: r.approverId ? nameById.get(r.approverId) ?? null : null,
      decidedAt: r.decidedAt,
      decisionNote: r.decisionNote,
      createdAt: r.createdAt,
      needsManager,
      selfApproval: isOwner,
      canReviewAsManager: isLineManager && isPending && !managerReviewed,
      canDecide: viewer.canManage && isPending && (!needsManager || managerReviewed),
      awaitingManager,
      canCancel: isPending && (isOwner || viewer.canManage),
      canEdit: isPending && (isOwner || isLineManager || viewer.canManage),
    };
  });
}

// ---------------------------------------------------------------------------
// Page data
// ---------------------------------------------------------------------------

export type LeaveKpis = {
  pending: number;
  pendingCaption: string;
  onLeaveThisWeek: number;
  onLeaveName: string | null;
  avgAnnualRemaining: number;
};

function weekBounds(now = new Date()): { start: Date; end: Date } {
  // Monday→Sunday window in UTC.
  const day = now.getUTCDay(); // 0 Sun … 6 Sat
  const diffToMon = (day + 6) % 7;
  const base = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
  const start = new Date(base - diffToMon * 86400000);
  const end = new Date(start.getTime() + 6 * 86400000 + (86400000 - 1));
  return { start, end };
}

/** Org-wide leave stats. Also exported for the (future) executive Dashboard. */
export async function getLeaveDashboardStats(): Promise<{
  pending: number;
  onLeaveThisWeek: number;
  onLeaveName: string | null;
  avgAnnualRemaining: number;
}> {
  const year = leaveYear();
  const { start, end } = weekBounds();

  const annualType = await prisma.leaveType.findFirst({
    where: { name: { contains: "Annual", mode: "insensitive" } },
    select: { id: true, daysPerYear: true },
  });

  const [pending, onLeave, employees, balances] = await Promise.all([
    prisma.leaveRequest.count({ where: { status: "PENDING" } }),
    prisma.leaveRequest.findMany({
      where: { status: "APPROVED", startDate: { lte: end }, endDate: { gte: start } },
      select: { employee: { select: { fullName: true, preferredName: true } } },
    }),
    prisma.employee.findMany({
      where: { status: { not: "EXITED" } },
      select: { id: true },
    }),
    annualType
      ? prisma.leaveBalance.findMany({
          where: { leaveTypeId: annualType.id, year },
          select: { employeeId: true, daysEntitled: true, daysTaken: true },
        })
      : Promise.resolve([] as { employeeId: string; daysEntitled: unknown; daysTaken: unknown }[]),
  ]);

  const onLeaveNames = new Set(onLeave.map((r) => personName(r.employee)));
  const onLeaveName = onLeaveNames.size ? [...onLeaveNames][0] : null;

  let avgAnnualRemaining = 0;
  if (annualType && employees.length) {
    const byEmp = new Map(balances.map((b) => [b.employeeId, b] as const));
    const def = num(annualType.daysPerYear);
    const total = employees.reduce((sum, e) => {
      const b = byEmp.get(e.id);
      const entitled = b ? num(b.daysEntitled) : def;
      const taken = b ? num(b.daysTaken) : 0;
      return sum + (entitled - taken);
    }, 0);
    avgAnnualRemaining = Math.round(total / employees.length);
  }

  return { pending, onLeaveThisWeek: onLeaveNames.size, onLeaveName, avgAnnualRemaining };
}

export type LeavePageData = {
  viewer: Viewer;
  types: LeaveTypeRow[];
  year: number;
  kpis: LeaveKpis | null; // only for approvers (HR or line managers)
  reviewQueue: RequestRow[]; // line-manager review queue (managers only)
  approvalQueue: RequestRow[]; // HR decision queue (canManage only)
  orgRecent: RequestRow[]; // recently decided, org-wide (canManage only)
  myBalances: BalanceRow[]; // the viewer's own balances (if linked)
  myRequests: RequestRow[]; // the viewer's own requests (if linked)
};

export async function getLeavePageData(me: CurrentUser): Promise<LeavePageData> {
  const viewer = await resolveViewer(me);
  const year = leaveYear();

  const types = (
    await prisma.leaveType.findMany({ orderBy: { name: "asc" } })
  ).map((t) => ({ id: t.id, name: t.name, daysPerYear: num(t.daysPerYear) }));

  // --- approver queues -----------------------------------------------------
  let approvalQueue: RequestRow[] = [];
  let orgRecent: RequestRow[] = [];
  let reviewQueue: RequestRow[] = [];
  let kpis: LeaveKpis | null = null;

  // Any line manager gets a review queue (their reports awaiting a recommendation),
  // whether or not they also hold HR rights.
  if (viewer.isManager) {
    const reviewRaw = await prisma.leaveRequest.findMany({
      where: {
        status: "PENDING",
        managerStatus: "PENDING",
        employeeId: { in: [...viewer.reportIds] },
      },
      include: REQUEST_INCLUDE,
      orderBy: { createdAt: "asc" },
    });
    reviewQueue = await hydrateRows(reviewRaw as unknown as RawRequest[], me, viewer);
  }

  if (viewer.canManage) {
    // HR: the org-wide decision queue, recent decisions, and the headline KPIs.
    const [pendingRaw, recentRaw, stats] = await Promise.all([
      prisma.leaveRequest.findMany({
        where: { status: "PENDING" },
        include: REQUEST_INCLUDE,
        orderBy: { createdAt: "asc" },
      }),
      prisma.leaveRequest.findMany({
        where: { status: { in: ["APPROVED", "REJECTED"] } },
        include: REQUEST_INCLUDE,
        orderBy: { decidedAt: "desc" },
        take: 8,
      }),
      getLeaveDashboardStats(),
    ]);
    approvalQueue = await hydrateRows(pendingRaw as unknown as RawRequest[], me, viewer);
    orgRecent = await hydrateRows(recentRaw as unknown as RawRequest[], me, viewer);
    kpis = {
      pending: stats.pending,
      pendingCaption: "awaiting decision",
      onLeaveThisWeek: stats.onLeaveThisWeek,
      onLeaveName: stats.onLeaveName,
      avgAnnualRemaining: stats.avgAnnualRemaining,
    };
  } else if (viewer.isManager) {
    // Line manager without HR rights: a single review-count KPI.
    kpis = {
      pending: reviewQueue.length,
      pendingCaption: "awaiting your review",
      onLeaveThisWeek: 0,
      onLeaveName: null,
      avgAnnualRemaining: 0,
    };
  }

  // --- the viewer's own leave ---------------------------------------------
  let myBalances: BalanceRow[] = [];
  let myRequests: RequestRow[] = [];
  if (viewer.employeeId) {
    const [balRows, myRaw] = await Promise.all([
      prisma.leaveBalance.findMany({
        where: { employeeId: viewer.employeeId, year },
        select: { leaveTypeId: true, daysEntitled: true, daysTaken: true },
      }),
      prisma.leaveRequest.findMany({
        where: { employeeId: viewer.employeeId },
        include: REQUEST_INCLUDE,
        orderBy: { createdAt: "desc" },
        take: 40,
      }),
    ]);
    const byType = new Map(balRows.map((b) => [b.leaveTypeId, b] as const));
    myBalances = types.map((t) => {
      const b = byType.get(t.id);
      const entitled = b ? num(b.daysEntitled) : t.daysPerYear;
      const taken = b ? num(b.daysTaken) : 0;
      return {
        leaveTypeId: t.id,
        typeName: t.name,
        entitled,
        taken,
        remaining: entitled - taken,
        hasRow: !!b,
      };
    });
    myRequests = await hydrateRows(myRaw as unknown as RawRequest[], me, viewer);
  }

  return {
    viewer,
    types,
    year,
    kpis,
    reviewQueue,
    approvalQueue,
    orgRecent,
    myBalances,
    myRequests,
  };
}

// ---------------------------------------------------------------------------
// Balances matrix (the Balances editor — HR only)
// ---------------------------------------------------------------------------

export type BalancesMatrixRow = {
  employeeId: string;
  eeId: string;
  name: string;
  cells: { leaveTypeId: string; entitled: number; taken: number; remaining: number }[];
};

export async function getBalancesMatrix(
  year: number
): Promise<{ types: LeaveTypeRow[]; rows: BalancesMatrixRow[] }> {
  const [typesRaw, employees, balances] = await Promise.all([
    prisma.leaveType.findMany({ orderBy: { name: "asc" } }),
    prisma.employee.findMany({
      where: { status: { not: "EXITED" } },
      select: { id: true, eeId: true, fullName: true, preferredName: true },
      orderBy: { eeId: "asc" },
    }),
    prisma.leaveBalance.findMany({
      where: { year },
      select: { employeeId: true, leaveTypeId: true, daysEntitled: true, daysTaken: true },
    }),
  ]);

  const types: LeaveTypeRow[] = typesRaw.map((t) => ({
    id: t.id,
    name: t.name,
    daysPerYear: num(t.daysPerYear),
  }));
  const defByType = new Map(types.map((t) => [t.id, t.daysPerYear] as const));
  const balKey = (e: string, t: string) => `${e}::${t}`;
  const byKey = new Map(balances.map((b) => [balKey(b.employeeId, b.leaveTypeId), b] as const));

  const rows: BalancesMatrixRow[] = employees.map((e) => ({
    employeeId: e.id,
    eeId: e.eeId,
    name: personName(e),
    cells: types.map((t) => {
      const b = byKey.get(balKey(e.id, t.id));
      const entitled = b ? num(b.daysEntitled) : defByType.get(t.id) ?? 0;
      const taken = b ? num(b.daysTaken) : 0;
      return { leaveTypeId: t.id, entitled, taken, remaining: entitled - taken };
    }),
  }));

  return { types, rows };
}

// ---------------------------------------------------------------------------
// Types list (the Types editor — HR only)
// ---------------------------------------------------------------------------

export async function getLeaveTypesWithUsage(): Promise<
  { id: string; name: string; daysPerYear: number; balanceCount: number; requestCount: number }[]
> {
  const types = await prisma.leaveType.findMany({
    orderBy: { name: "asc" },
    select: {
      id: true,
      name: true,
      daysPerYear: true,
      _count: { select: { balances: true, requests: true } },
    },
  });
  return types.map((t) => ({
    id: t.id,
    name: t.name,
    daysPerYear: num(t.daysPerYear),
    balanceCount: t._count.balances,
    requestCount: t._count.requests,
  }));
}

export async function getLeaveTypeOptions(): Promise<LeaveTypeRow[]> {
  return (await prisma.leaveType.findMany({ orderBy: { name: "asc" } })).map((t) => ({
    id: t.id,
    name: t.name,
    daysPerYear: num(t.daysPerYear),
  }));
}

// ---------------------------------------------------------------------------
// Single request detail (the /leave/[requestId] view + modify page)
// ---------------------------------------------------------------------------

export type RequestDetail = {
  row: RequestRow;
  /** UTC date-only strings for prefilling <input type="date">. */
  startInput: string;
  endInput: string;
  /** Whether the stored request is a half day on a single date. */
  isHalf: boolean;
  typeOptions: LeaveTypeRow[];
  /** The employee's balance for this leave type / year, for context. */
  balanceForType: { entitled: number; taken: number; remaining: number } | null;
};

function toDateInput(d: Date): string {
  return d.toISOString().slice(0, 10);
}

/**
 * Detail for one request. Returns null if it doesn't exist. View access is
 * row-level: the requester, their line manager, or anyone with leave.manage.
 * Returns { allowed: false } when the signed-in user may not see it so the page
 * can redirect to /access-denied.
 */
export async function getLeaveRequestDetail(
  me: CurrentUser,
  requestId: string
): Promise<{ allowed: true; detail: RequestDetail } | { allowed: false } | null> {
  const viewer = await resolveViewer(me);

  const raw = await prisma.leaveRequest.findUnique({
    where: { id: requestId },
    include: REQUEST_INCLUDE,
  });
  if (!raw) return null;

  const isOwner = raw.employee.userId === me.id;
  const isLineManager = !!viewer.employeeId && raw.employee.managerId === viewer.employeeId;
  if (!isOwner && !isLineManager && !viewer.canManage) return { allowed: false };

  const [row] = await hydrateRows([raw as unknown as RawRequest], me, viewer);

  const year = raw.startDate.getUTCFullYear();
  const [typeOptions, bal] = await Promise.all([
    getLeaveTypeOptions(),
    prisma.leaveBalance.findUnique({
      where: {
        employeeId_leaveTypeId_year: {
          employeeId: raw.employeeId,
          leaveTypeId: raw.leaveTypeId,
          year,
        },
      },
      select: { daysEntitled: true, daysTaken: true },
    }),
  ]);

  const balanceForType = bal
    ? {
        entitled: num(bal.daysEntitled),
        taken: num(bal.daysTaken),
        remaining: num(bal.daysEntitled) - num(bal.daysTaken),
      }
    : null;

  return {
    allowed: true,
    detail: {
      row,
      startInput: toDateInput(raw.startDate),
      endInput: toDateInput(raw.endDate),
      isHalf: num(raw.days) === 0.5 && raw.startDate.getTime() === raw.endDate.getTime(),
      typeOptions,
      balanceForType,
    },
  };
}
