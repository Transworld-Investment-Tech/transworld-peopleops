// lib/bonus-deferrals.ts — Bonus model Phase B read layer (v0.21.0, WS6 Part 3).
//
// The deferral ledger reads the tranches that LOCKED bonus rounds recorded and
// reports their lifecycle: what is due in a given April, each person's rolling
// deferred balance, and a firmwide rollup by status. Net amounts fold in any
// partial clawbacks (recorded as bonus_tranche_events). Reads only — the audited
// writes live in lib/bonus-deferrals-actions.ts. The portal records and
// reconciles; payment is made in April via the firm's payroll/payment systems.
import { prisma } from "@/lib/db";
import { fmtNaira } from "@/lib/compensation";
import { clawbackTotal, trancheNet, round2 } from "@/lib/bonus-ledger";

export { fmtNaira };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];
export function monthLabel(m: number): string {
  return MONTHS[m - 1] ?? String(m);
}

export function trancheStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PAID": return { cls: "b-grn", label: "Paid" };
    case "CLAWED_BACK": return { cls: "b-red", label: "Clawed back" };
    case "FORFEITED": return { cls: "b-red", label: "Forfeited" };
    default: return { cls: "b-blu", label: "Scheduled" };
  }
}

export type LedgerTranche = {
  id: string;
  employeeId: string;
  eeId: string;
  name: string;
  grade: string;
  deferred: boolean;
  awardYear: number;
  roundLabel: string;
  sequence: number;
  label: string;
  amount: number; // original snapshot amount (immutable)
  clawed: number; // total reclaimed so far
  net: number; // amount net of clawbacks; 0 if forfeited / fully clawed
  scheduledMonth: number;
  scheduledYear: number;
  status: string;
  paidAt: Date | null;
};

export type EmployeeBalance = {
  employeeId: string;
  eeId: string;
  name: string;
  grade: string;
  scheduledNet: number; // unpaid, still on schedule
  paidNet: number; // paid (net of any clawback)
  clawedTotal: number;
  forfeitedAmount: number;
  tranches: LedgerTranche[];
};

export type DeferralsView = {
  hasLockedRounds: boolean;
  years: number[]; // distinct scheduled years across all tranches
  focusYear: number;
  dueThisYear: LedgerTranche[]; // SCHEDULED tranches scheduled for focusYear
  dueTotal: number; // sum of net for dueThisYear
  rollup: { scheduledNet: number; paidNet: number; clawed: number; forfeited: number };
  employees: EmployeeBalance[];
};

export async function getDeferrals(requestedYear?: number): Promise<DeferralsView> {
  const tranches = await prisma.bonusTranche.findMany({
    where: { bonusAward: { bonusRound: { status: "LOCKED" } } },
    select: {
      id: true,
      employeeId: true,
      sequence: true,
      label: true,
      amount: true,
      scheduledMonth: true,
      scheduledYear: true,
      status: true,
      paidAt: true,
      bonusAward: {
        select: {
          eeId: true,
          employeeName: true,
          grade: true,
          deferred: true,
          bonusRound: { select: { awardYear: true, label: true } },
        },
      },
    },
    orderBy: [{ scheduledYear: "asc" }, { sequence: "asc" }],
  });

  if (tranches.length === 0) {
    const fy = requestedYear ?? new Date().getUTCFullYear();
    return {
      hasLockedRounds: false,
      years: [],
      focusYear: fy,
      dueThisYear: [],
      dueTotal: 0,
      rollup: { scheduledNet: 0, paidNet: 0, clawed: 0, forfeited: 0 },
      employees: [],
    };
  }

  // Clawback events for net computation.
  const ids = tranches.map((t) => t.id);
  const events = await prisma.bonusTrancheEvent.findMany({
    where: { bonusTrancheId: { in: ids } },
    select: { bonusTrancheId: true, eventType: true, amount: true },
  });
  const evByTranche = new Map<string, { eventType: string; amount: number }[]>();
  for (const e of events) {
    const arr = evByTranche.get(e.bonusTrancheId) ?? [];
    arr.push({ eventType: e.eventType, amount: num(e.amount) });
    evByTranche.set(e.bonusTrancheId, arr);
  }

  const rows: LedgerTranche[] = tranches.map((t) => {
    const a = t.bonusAward;
    const amount = num(t.amount);
    const clawed = clawbackTotal(evByTranche.get(t.id) ?? []);
    return {
      id: t.id,
      employeeId: t.employeeId,
      eeId: a.eeId,
      name: a.employeeName,
      grade: a.grade,
      deferred: a.deferred,
      awardYear: a.bonusRound.awardYear,
      roundLabel: a.bonusRound.label,
      sequence: t.sequence,
      label: t.label,
      amount,
      clawed,
      net: trancheNet(amount, t.status, clawed),
      scheduledMonth: t.scheduledMonth,
      scheduledYear: t.scheduledYear,
      status: t.status,
      paidAt: t.paidAt,
    };
  });

  const years = Array.from(new Set(rows.map((r) => r.scheduledYear))).sort((a, b) => a - b);

  // Focus year: the requested one if it has tranches; else the nearest year that
  // still has SCHEDULED tranches; else the latest year present.
  const scheduledYears = Array.from(
    new Set(rows.filter((r) => r.status === "SCHEDULED").map((r) => r.scheduledYear)),
  ).sort((a, b) => a - b);
  let focusYear: number;
  if (requestedYear && years.includes(requestedYear)) {
    focusYear = requestedYear;
  } else if (scheduledYears.length) {
    focusYear = scheduledYears[0];
  } else {
    focusYear = years[years.length - 1];
  }

  const dueThisYear = rows.filter((r) => r.status === "SCHEDULED" && r.scheduledYear === focusYear);
  const dueTotal = round2(dueThisYear.reduce((s, r) => s + r.net, 0));

  const rollup = {
    scheduledNet: round2(rows.filter((r) => r.status === "SCHEDULED").reduce((s, r) => s + r.net, 0)),
    paidNet: round2(rows.filter((r) => r.status === "PAID").reduce((s, r) => s + r.net, 0)),
    clawed: round2(rows.reduce((s, r) => s + r.clawed, 0)),
    forfeited: round2(rows.filter((r) => r.status === "FORFEITED").reduce((s, r) => s + r.amount, 0)),
  };

  // Group by employee.
  const empMap = new Map<string, EmployeeBalance>();
  for (const r of rows) {
    let e = empMap.get(r.employeeId);
    if (!e) {
      e = {
        employeeId: r.employeeId,
        eeId: r.eeId,
        name: r.name,
        grade: r.grade,
        scheduledNet: 0,
        paidNet: 0,
        clawedTotal: 0,
        forfeitedAmount: 0,
        tranches: [],
      };
      empMap.set(r.employeeId, e);
    }
    e.tranches.push(r);
    e.clawedTotal = round2(e.clawedTotal + r.clawed);
    if (r.status === "SCHEDULED") e.scheduledNet = round2(e.scheduledNet + r.net);
    else if (r.status === "PAID") e.paidNet = round2(e.paidNet + r.net);
    else if (r.status === "FORFEITED") e.forfeitedAmount = round2(e.forfeitedAmount + r.amount);
  }
  const employees = Array.from(empMap.values()).sort((a, b) => {
    const na = Number(a.eeId.replace(/\D/g, "")) || 0;
    const nb = Number(b.eeId.replace(/\D/g, "")) || 0;
    return na - nb;
  });

  return {
    hasLockedRounds: true,
    years,
    focusYear,
    dueThisYear,
    dueTotal,
    rollup,
    employees,
  };
}
