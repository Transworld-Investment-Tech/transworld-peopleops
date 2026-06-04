// lib/bonus-round.ts — Bonus model read layer (v0.20.1, WS6 Part 3).
//
// The annual bonus round reproduces WS6 Part 3 as a review-and-confirm artifact:
// open a round for an award year -> enter PBT -> pool = 15% of PBT -> carry every
// eligible employee with their grade, monthly salary, target months and a default
// ×1.0 multiplier -> per-row review (set multiplier, integrity gate) -> pool
// reconciliation (scale proportionately if oversubscribed) -> exec/RemCo approve
// (snapshot totals + scaling, generate the G4/G5 tranche schedule) -> lock as
// evidence. Reads only; audited writes live in lib/bonus-round-actions.ts.
import { prisma } from "@/lib/db";
import { personGrade } from "@/lib/jobframework";
import {
  poolScalingFactor,
  applyScaling,
  immediateDeferredSplit,
  isDeferredGrade,
  round2,
} from "@/lib/bonus";
import { fmtNaira } from "@/lib/compensation";

export { fmtNaira };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}

export function bonusStateBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "DRAFT": return { cls: "b-gry", label: "Draft" };
    case "IN_REVIEW": return { cls: "b-amb", label: "In review" };
    case "APPROVED": return { cls: "b-blu", label: "Approved" };
    case "LOCKED": return { cls: "b-grn", label: "Locked" };
    default: return { cls: "b-gry", label: s };
  }
}
export function awardStatusBadge(s: string): { cls: string; label: string } {
  return s === "CONFIRMED"
    ? { cls: "b-grn", label: "Confirmed" }
    : { cls: "b-gry", label: "Pending" };
}
export function trancheStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PAID": return { cls: "b-grn", label: "Paid" };
    case "CLAWED_BACK": return { cls: "b-red", label: "Clawed back" };
    case "FORFEITED": return { cls: "b-red", label: "Forfeited" };
    default: return { cls: "b-blu", label: "Scheduled" };
  }
}

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];
export function monthLabel(m: number): string { return MONTHS[m - 1] ?? String(m); }

// ---------------------------------------------------------------------------
// Round list / home
// ---------------------------------------------------------------------------
export type RoundListRow = {
  id: string;
  label: string;
  awardYear: number;
  status: string;
  awardCount: number;
  poolAmount: number;
  totalAwarded: number | null;
  paymentMonth: number;
  paymentYear: number;
  lockedAt: Date | null;
  createdAt: Date;
};

export type AppraisalCycleOption = { id: string; name: string };

export type BonusHome = {
  rounds: RoundListRow[];
  hasOpenRound: boolean;
  suggestedYear: number;
  appraisalCycles: AppraisalCycleOption[];
};

export async function getBonusHome(): Promise<BonusHome> {
  const [rounds, cycles] = await Promise.all([
    prisma.bonusRound.findMany({
      orderBy: [{ awardYear: "desc" }],
      select: {
        id: true, label: true, awardYear: true, status: true, poolAmount: true,
        totalAwarded: true, paymentMonth: true, paymentYear: true, lockedAt: true, createdAt: true,
        _count: { select: { awards: true } },
      },
    }),
    prisma.appraisalCycle.findMany({ orderBy: { createdAt: "desc" }, select: { id: true, name: true } }),
  ]);

  const rows: RoundListRow[] = rounds.map((r) => ({
    id: r.id, label: r.label, awardYear: r.awardYear, status: r.status,
    awardCount: r._count.awards, poolAmount: num(r.poolAmount),
    totalAwarded: r.totalAwarded === null ? null : num(r.totalAwarded),
    paymentMonth: r.paymentMonth, paymentYear: r.paymentYear,
    lockedAt: r.lockedAt, createdAt: r.createdAt,
  }));

  const hasOpenRound = rows.some((r) => r.status !== "LOCKED");
  const latestYear = rows.length ? rows[0].awardYear : new Date().getUTCFullYear() - 1;
  const suggestedYear = rows.length ? latestYear + 1 : new Date().getUTCFullYear();

  return {
    rounds: rows,
    hasOpenRound,
    suggestedYear,
    appraisalCycles: cycles,
  };
}

// ---------------------------------------------------------------------------
// One round, fully expanded
// ---------------------------------------------------------------------------
export type AwardRow = {
  id: string;
  employeeId: string;
  eeId: string;
  name: string;
  grade: string;
  deferred: boolean;
  monthlySalary: number;
  targetMonths: number;
  targetBonus: number;
  multiplier: number;
  integrityGate: boolean;
  appraisalRating: string | null;
  calculatedBonus: number;
  awardedBonus: number; // live preview while editable; snapshot once approved
  immediateAmount: number;
  deferredAmount: number;
  reviewStatus: string;
  note: string | null;
};

export type TrancheRow = {
  id: string;
  eeId: string;
  name: string;
  sequence: number;
  label: string;
  amount: number;
  scheduledMonth: number;
  scheduledYear: number;
  status: string;
};

export type RoundTotals = {
  targetBonus: number;
  calculated: number;
  awarded: number;
  immediate: number;
  deferred: number;
};

export type Reconciliation = {
  pbt: number;
  poolRate: number;
  poolAmount: number;
  totalCalculated: number;
  scalingFactor: number;
  withinPool: boolean;
  headroom: number; // pool - calculated (negative when oversubscribed)
};

export type RoundView = {
  id: string;
  label: string;
  awardYear: number;
  status: string;
  salaryBasis: string;
  paymentMonth: number;
  paymentYear: number;
  appraisalCycleId: string | null;
  approvedAt: Date | null;
  approvedByName: string | null;
  lockedAt: Date | null;
  editable: boolean; // DRAFT or IN_REVIEW
  rows: AwardRow[];
  totals: RoundTotals;
  reconciliation: Reconciliation;
  confirmedCount: number;
  allConfirmed: boolean;
  tranches: TrancheRow[];
} | null;

export async function getRound(roundId: string): Promise<RoundView> {
  const round = await prisma.bonusRound.findUnique({
    where: { id: roundId },
    include: {
      awards: true,
      // tranches hang off awards; gather them separately below for display order
    },
  });
  if (!round) return null;

  let approvedByName: string | null = null;
  if (round.approvedById) {
    const u = await prisma.user.findUnique({ where: { id: round.approvedById }, select: { name: true } });
    approvedByName = u?.name ?? null;
  }

  const awards = [...round.awards].sort((a, b) => {
    const na = Number(a.eeId.replace(/\D/g, "")) || 0;
    const nb = Number(b.eeId.replace(/\D/g, "")) || 0;
    return na - nb;
  });

  const pbt = num(round.pbt);
  const poolRate = num(round.poolRate);
  const poolAmount = num(round.poolAmount);
  const editable = round.status === "DRAFT" || round.status === "IN_REVIEW";

  const totalCalculated = round2(awards.reduce((s, a) => s + num(a.calculatedBonus), 0));
  // While editable, the scaling factor and awarded amounts are a live preview;
  // once APPROVED they are read from the snapshot stored on the round/awards.
  const livePreviewFactor = poolScalingFactor(totalCalculated, poolAmount);
  const factor = editable ? livePreviewFactor : num(round.scalingFactor);

  const rows: AwardRow[] = awards.map((a) => {
    const calculated = num(a.calculatedBonus);
    const deferred = a.deferred;
    const awarded = editable ? applyScaling(calculated, factor) : num(a.awardedBonus);
    const split = editable ? immediateDeferredSplit(awarded, deferred) : {
      immediate: num(a.immediateAmount), deferred: num(a.deferredAmount),
    };
    return {
      id: a.id,
      employeeId: a.employeeId,
      eeId: a.eeId,
      name: a.employeeName,
      grade: a.grade,
      deferred,
      monthlySalary: num(a.monthlySalary),
      targetMonths: num(a.targetMonths),
      targetBonus: num(a.targetBonus),
      multiplier: num(a.multiplier),
      integrityGate: a.integrityGate,
      appraisalRating: a.appraisalRating ?? null,
      calculatedBonus: calculated,
      awardedBonus: awarded,
      immediateAmount: split.immediate,
      deferredAmount: split.deferred,
      reviewStatus: a.reviewStatus,
      note: a.note ?? null,
    };
  });

  const totals: RoundTotals = {
    targetBonus: round2(rows.reduce((s, r) => s + r.targetBonus, 0)),
    calculated: totalCalculated,
    awarded: round2(rows.reduce((s, r) => s + r.awardedBonus, 0)),
    immediate: round2(rows.reduce((s, r) => s + r.immediateAmount, 0)),
    deferred: round2(rows.reduce((s, r) => s + r.deferredAmount, 0)),
  };

  const reconciliation: Reconciliation = {
    pbt, poolRate, poolAmount, totalCalculated, scalingFactor: factor,
    withinPool: totalCalculated <= poolAmount,
    headroom: round2(poolAmount - totalCalculated),
  };

  const confirmedCount = rows.filter((r) => r.reviewStatus === "CONFIRMED").length;

  // Tranches (present once approved/locked)
  const trancheRecords = await prisma.bonusTranche.findMany({
    where: { bonusRoundId: roundId },
    orderBy: [{ employeeId: "asc" }, { sequence: "asc" }],
  });
  const nameByEmp = new Map(rows.map((r) => [r.employeeId, { eeId: r.eeId, name: r.name }] as const));
  const tranches: TrancheRow[] = trancheRecords.map((t) => {
    const who = nameByEmp.get(t.employeeId);
    return {
      id: t.id,
      eeId: who?.eeId ?? t.employeeId,
      name: who?.name ?? t.employeeId,
      sequence: t.sequence,
      label: t.label,
      amount: num(t.amount),
      scheduledMonth: t.scheduledMonth,
      scheduledYear: t.scheduledYear,
      status: t.status,
    };
  });

  return {
    id: round.id,
    label: round.label,
    awardYear: round.awardYear,
    status: round.status,
    salaryBasis: round.salaryBasis,
    paymentMonth: round.paymentMonth,
    paymentYear: round.paymentYear,
    appraisalCycleId: round.appraisalCycleId ?? null,
    approvedAt: round.approvedAt,
    approvedByName,
    lockedAt: round.lockedAt,
    editable,
    rows,
    totals,
    reconciliation,
    confirmedCount,
    allConfirmed: rows.length > 0 && confirmedCount === rows.length,
    tranches,
  };
}

// ---------------------------------------------------------------------------
// Eligibility preview for opening a round
// ---------------------------------------------------------------------------
export type OpenPreview = {
  eligible: { employeeId: string; eeId: string; name: string; grade: string }[];
  skipped: { eeId: string; name: string; reason: string }[];
};

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

export async function getOpenPreview(): Promise<OpenPreview> {
  const profiles = await prisma.compensationProfile.findMany({
    where: { isCurrent: true },
    select: {
      employee: {
        select: {
          id: true, status: true, eeId: true, fullName: true, preferredName: true, grade: true,
          jobProfile: { select: { grade: true } },
        },
      },
    },
  });
  const eligible: OpenPreview["eligible"] = [];
  const skipped: OpenPreview["skipped"] = [];
  for (const p of profiles) {
    const e = p.employee;
    if (e.status === "EXITED") continue;
    const grade = personGrade(e.grade, e.jobProfile?.grade);
    if (!grade) {
      skipped.push({ eeId: e.eeId, name: personName(e), reason: "No grade on job profile" });
      continue;
    }
    eligible.push({ employeeId: e.id, eeId: e.eeId, name: personName(e), grade });
  }
  eligible.sort((a, b) => (Number(a.eeId.replace(/\D/g, "")) || 0) - (Number(b.eeId.replace(/\D/g, "")) || 0));
  return { eligible, skipped };
}
