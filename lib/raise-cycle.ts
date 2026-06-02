// lib/raise-cycle.ts — Raise mechanism read layer (WS6 Part 2, v0.22.0).
//
// A raise cycle reproduces Ops Manual F4 as a review-and-confirm artifact: the Board
// sets a revenue milestone and a firm-wide percentage -> People Ops tracks the gap as
// the CFO reports revenue -> when a milestone is confirmed hit, the recommendation is
// prepared (every active employee, old vs new on every pay component, band flags) ->
// COO review (the IN_REVIEW state) -> Remuneration Committee approval, which applies
// the new figures to each compensation profile -> lock as evidence. Reads only;
// audited writes live in lib/raise-cycle-actions.ts.
//
// The portal never pays anyone — it updates the standing compensation inputs the
// control room reads, so the next payroll cycle picks up the raise automatically.
import { prisma } from "@/lib/db";
import { annualTotal, monthlyGross, gapToTarget, progressToTarget, round2 } from "@/lib/raise";
import { fmtNaira, fmtPct } from "@/lib/compensation";

export { fmtNaira, fmtPct };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}

export function raiseStateBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "DRAFT": return { cls: "b-gry", label: "Draft" };
    case "IN_REVIEW": return { cls: "b-amb", label: "In review" };
    case "APPROVED": return { cls: "b-blu", label: "Approved" };
    case "LOCKED": return { cls: "b-grn", label: "Locked" };
    default: return { cls: "b-gry", label: s };
  }
}

export function bandFlagBadge(f: string): { cls: string; label: string } {
  switch (f) {
    case "ABOVE_MAX": return { cls: "b-red", label: "Above max" };
    case "ABOVE_MID": return { cls: "b-amb", label: "Above mid" };
    case "BELOW_MIN": return { cls: "b-red", label: "Below min" };
    default: return { cls: "b-gry", label: "Within band" };
  }
}

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];
export function monthLabel(m: number): string { return MONTHS[m - 1] ?? String(m); }

/** First day of the month after a given date — the default raise effective date. */
export function firstOfNextMonth(from = new Date()): Date {
  return new Date(Date.UTC(from.getUTCFullYear(), from.getUTCMonth() + 1, 1));
}

// ---------------------------------------------------------------------------
// Home / list
// ---------------------------------------------------------------------------
export type CycleListRow = {
  id: string;
  label: string;
  milestoneLabel: string;
  status: string;
  raisePercent: number;
  revenueTarget: number;
  effectiveDate: Date;
  itemCount: number;
  totalAnnualIncrease: number | null;
  lockedAt: Date | null;
  createdAt: Date;
};

export type OpenGap = {
  id: string;
  label: string;
  milestoneLabel: string;
  revenueTarget: number;
  revenueObserved: number | null;
  gap: number;
  progress: number;
};

export type RaiseHome = {
  cycles: CycleListRow[];
  hasOpenCycle: boolean;
  openGap: OpenGap | null;
  eligibleCount: number;
  suggestedEffective: Date;
};

export async function getRaiseHome(): Promise<RaiseHome> {
  const [cycles, profiles] = await Promise.all([
    prisma.raiseCycle.findMany({
      orderBy: [{ createdAt: "desc" }],
      select: {
        id: true, label: true, milestoneLabel: true, status: true, raisePercent: true,
        revenueTarget: true, revenueObserved: true, effectiveDate: true,
        totalAnnualIncrease: true, lockedAt: true, createdAt: true,
        _count: { select: { items: true } },
      },
    }),
    prisma.compensationProfile.findMany({
      where: { isCurrent: true },
      select: { employee: { select: { status: true } } },
    }),
  ]);

  const rows: CycleListRow[] = cycles.map((c) => ({
    id: c.id, label: c.label, milestoneLabel: c.milestoneLabel, status: c.status,
    raisePercent: num(c.raisePercent), revenueTarget: num(c.revenueTarget),
    effectiveDate: c.effectiveDate, itemCount: c._count.items,
    totalAnnualIncrease: c.totalAnnualIncrease === null ? null : num(c.totalAnnualIncrease),
    lockedAt: c.lockedAt, createdAt: c.createdAt,
  }));

  const open = cycles.find((c) => c.status !== "LOCKED");
  const hasOpenCycle = !!open;
  const openGap: OpenGap | null = open
    ? {
        id: open.id,
        label: open.label,
        milestoneLabel: open.milestoneLabel,
        revenueTarget: num(open.revenueTarget),
        revenueObserved: open.revenueObserved === null ? null : num(open.revenueObserved),
        gap: gapToTarget(num(open.revenueTarget), num(open.revenueObserved)),
        progress: progressToTarget(num(open.revenueTarget), num(open.revenueObserved)),
      }
    : null;

  const eligibleCount = profiles.filter((p) => p.employee.status !== "EXITED").length;

  return { cycles: rows, hasOpenCycle, openGap, eligibleCount, suggestedEffective: firstOfNextMonth() };
}

// ---------------------------------------------------------------------------
// One cycle, fully expanded
// ---------------------------------------------------------------------------
export type ItemRow = {
  id: string;
  employeeId: string;
  eeId: string;
  name: string;
  grade: string | null;
  included: boolean;
  excludeReason: string | null;
  capApplied: boolean;
  oldBasic: number;
  oldUtility: number;
  oldQuarterly: number;
  oldAnnualTotal: number;
  newBasic: number;
  newUtility: number;
  newQuarterly: number;
  newAnnualTotal: number;
  annualIncrease: number;
  oldGross: number;
  newGross: number;
  bandMin: number | null;
  bandMid: number | null;
  bandMax: number | null;
  bandFlag: string;
  appliedProfileId: string | null;
  note: string | null;
};

export type CycleTotals = {
  includedCount: number;
  excludedCount: number;
  totalAnnualIncrease: number;
  totalNewAnnual: number;
  totalOldAnnual: number;
  aboveMax: number;
  aboveMid: number;
  belowMin: number;
};

export type CycleView = {
  id: string;
  label: string;
  milestoneLabel: string;
  status: string;
  raisePercent: number;
  revenueTarget: number;
  revenueObserved: number | null;
  revenueConfirmed: number | null;
  gap: number;
  progress: number;
  effectiveDate: Date;
  confirmedNote: string | null;
  editable: boolean; // DRAFT or IN_REVIEW
  preparedByName: string | null;
  submittedByName: string | null;
  approvedByName: string | null;
  approvedAt: Date | null;
  appliedAt: Date | null;
  lockedAt: Date | null;
  rows: ItemRow[];
  totals: CycleTotals;
} | null;

async function resolveUserNames(ids: (string | null | undefined)[]): Promise<Map<string, string>> {
  const want = Array.from(new Set(ids.filter((x): x is string => !!x)));
  if (want.length === 0) return new Map();
  const users = await prisma.user.findMany({ where: { id: { in: want } }, select: { id: true, name: true } });
  return new Map(users.map((u) => [u.id, u.name] as const));
}

export async function getCycle(cycleId: string): Promise<CycleView> {
  const cycle = await prisma.raiseCycle.findUnique({
    where: { id: cycleId },
    include: { items: true },
  });
  if (!cycle) return null;

  const names = await resolveUserNames([cycle.preparedById, cycle.submittedById, cycle.approvedById]);

  const items = [...cycle.items].sort((a, b) => {
    const na = Number(a.eeId.replace(/\D/g, "")) || 0;
    const nb = Number(b.eeId.replace(/\D/g, "")) || 0;
    return na - nb;
  });

  const rows: ItemRow[] = items.map((it) => {
    const oldGross = monthlyGross(num(it.oldBasic), num(it.oldUtility));
    const newGross = monthlyGross(num(it.newBasic), num(it.newUtility));
    return {
      id: it.id,
      employeeId: it.employeeId,
      eeId: it.eeId,
      name: it.employeeName,
      grade: it.grade ?? null,
      included: it.included,
      excludeReason: it.excludeReason ?? null,
      capApplied: it.capApplied,
      oldBasic: num(it.oldBasic),
      oldUtility: num(it.oldUtility),
      oldQuarterly: num(it.oldQuarterly),
      oldAnnualTotal: num(it.oldAnnualTotal),
      newBasic: num(it.newBasic),
      newUtility: num(it.newUtility),
      newQuarterly: num(it.newQuarterly),
      newAnnualTotal: num(it.newAnnualTotal),
      annualIncrease: num(it.annualIncrease),
      oldGross,
      newGross,
      bandMin: it.bandMin === null ? null : num(it.bandMin),
      bandMid: it.bandMid === null ? null : num(it.bandMid),
      bandMax: it.bandMax === null ? null : num(it.bandMax),
      bandFlag: it.bandFlag,
      appliedProfileId: it.appliedProfileId ?? null,
      note: it.note ?? null,
    };
  });

  const incl = rows.filter((r) => r.included);
  const totals: CycleTotals = {
    includedCount: incl.length,
    excludedCount: rows.length - incl.length,
    totalAnnualIncrease: round2(incl.reduce((s, r) => s + r.annualIncrease, 0)),
    totalNewAnnual: round2(incl.reduce((s, r) => s + r.newAnnualTotal, 0)),
    totalOldAnnual: round2(incl.reduce((s, r) => s + r.oldAnnualTotal, 0)),
    aboveMax: incl.filter((r) => r.bandFlag === "ABOVE_MAX").length,
    aboveMid: incl.filter((r) => r.bandFlag === "ABOVE_MID").length,
    belowMin: incl.filter((r) => r.bandFlag === "BELOW_MIN").length,
  };

  return {
    id: cycle.id,
    label: cycle.label,
    milestoneLabel: cycle.milestoneLabel,
    status: cycle.status,
    raisePercent: num(cycle.raisePercent),
    revenueTarget: num(cycle.revenueTarget),
    revenueObserved: cycle.revenueObserved === null ? null : num(cycle.revenueObserved),
    revenueConfirmed: cycle.revenueConfirmed === null ? null : num(cycle.revenueConfirmed),
    gap: gapToTarget(num(cycle.revenueTarget), num(cycle.revenueObserved)),
    progress: progressToTarget(num(cycle.revenueTarget), num(cycle.revenueObserved)),
    effectiveDate: cycle.effectiveDate,
    confirmedNote: cycle.confirmedNote ?? null,
    editable: cycle.status === "DRAFT" || cycle.status === "IN_REVIEW",
    preparedByName: cycle.preparedById ? names.get(cycle.preparedById) ?? null : null,
    submittedByName: cycle.submittedById ? names.get(cycle.submittedById) ?? null : null,
    approvedByName: cycle.approvedById ? names.get(cycle.approvedById) ?? null : null,
    approvedAt: cycle.approvedAt,
    appliedAt: cycle.appliedAt,
    lockedAt: cycle.lockedAt,
    rows,
    totals,
  };
}
