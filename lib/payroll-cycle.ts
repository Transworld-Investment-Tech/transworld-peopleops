// lib/payroll-cycle.ts — Payroll Control Center read layer (v0.19.0).
//
// The portal NEVER pays anyone. A pay cycle reproduces the monthly control sheet
// as a review-and-confirm cross-check; HumanManager + Remita stay authoritative.
// Flow: open a PayCycle -> carry compensation_profiles into pay_items -> compute
// via lib/payroll.ts against the active tax rule set -> per-row review-and-confirm
// -> exec approval -> control sheet (HTML preview + Excel export) -> lock as evidence.
//
// Reads only. Audited writes live in lib/payroll-cycle-actions.ts. Cross-entity
// references on pay_cycles/pay_items are bare columns (FK in SQL only); Decimals
// are converted with Number() at the edge. Reuses the compensation engine wiring
// (getActiveTaxRuleSet / rulesFrom / computePay) so there is one source of truth
// for the math.
import { prisma } from "@/lib/db";
import { computePay, type ComputePayInput, type PayBreakdown, type TaxRules } from "@/lib/payroll";
import { getActiveTaxRuleSet, rulesFrom, fmtNaira } from "@/lib/compensation";

// ---------------------------------------------------------------------------
// Vocabularies / status presentation
// ---------------------------------------------------------------------------
export const PAY_CYCLE_STATES = [
  { value: "DRAFT", label: "Draft" },
  { value: "IN_REVIEW", label: "In review" },
  { value: "APPROVED", label: "Approved" },
  { value: "GENERATED", label: "Generated" },
  { value: "LOCKED", label: "Locked" },
] as const;

export const REVIEW_STATUSES = [
  { value: "CARRIED_FORWARD", label: "Carried forward" },
  { value: "CHANGED", label: "Changed" },
  { value: "NEW", label: "New" },
  { value: "CONFIRMED", label: "Confirmed" },
] as const;

export function cycleStateBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "DRAFT": return { cls: "b-gry", label: "Draft" };
    case "IN_REVIEW": return { cls: "b-amb", label: "In review" };
    case "APPROVED": return { cls: "b-blu", label: "Approved" };
    case "GENERATED": return { cls: "b-blu", label: "Generated" };
    case "LOCKED": return { cls: "b-grn", label: "Locked" };
    default: return { cls: "b-gry", label: s };
  }
}

export function reviewStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "CONFIRMED": return { cls: "b-grn", label: "Confirmed" };
    case "CHANGED": return { cls: "b-amb", label: "Changed" };
    case "NEW": return { cls: "b-blu", label: "New" };
    case "CARRIED_FORWARD": return { cls: "b-gry", label: "Carried forward" };
    default: return { cls: "b-gry", label: s };
  }
}

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];
export function monthLabel(m: number): string { return MONTHS[m - 1] ?? String(m); }
export function cycleLabel(year: number, month: number): string { return `${monthLabel(month)} ${year}`; }
/** Quarter-end months (Oct, Jan, Apr, Jul) carry the quarterly lump in the firm's pattern. */
export function isQuarterMonth(month: number): boolean { return month === 1 || month === 4 || month === 7 || month === 10; }

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}
function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Adjustments (operator-entered per row): quarterly lump, special/leave
// allowance, unpaid-leave deduction. Stored as JSON on pay_items.adjustments.
// ---------------------------------------------------------------------------
export type AdjustmentKind = "ALLOWANCE" | "DEDUCTION";
export type Adjustment = { label: string; amount: number; kind: AdjustmentKind };

export function parseAdjustments(v: unknown): Adjustment[] {
  if (!Array.isArray(v)) return [];
  const out: Adjustment[] = [];
  for (const a of v as unknown[]) {
    if (a && typeof a === "object") {
      const o = a as Record<string, unknown>;
      const label = typeof o.label === "string" ? o.label : "";
      const amount = num(o.amount);
      const kind: AdjustmentKind = o.kind === "DEDUCTION" ? "DEDUCTION" : "ALLOWANCE";
      if (label && amount) out.push({ label, amount, kind });
    }
  }
  return out;
}
export function adjustmentsNet(adj: Adjustment[]): { allowances: number; deductions: number } {
  let allowances = 0, deductions = 0;
  for (const a of adj) { if (a.kind === "DEDUCTION") deductions += a.amount; else allowances += a.amount; }
  return { allowances, deductions };
}

// ---------------------------------------------------------------------------
// Cycle list
// ---------------------------------------------------------------------------
export type CycleListRow = {
  id: string;
  label: string;
  periodYear: number;
  periodMonth: number;
  status: string;
  itemCount: number;
  totalNet: number | null;
  totalPayable: number | null;
  approvedAt: Date | null;
  lockedAt: Date | null;
  createdAt: Date;
};

export type PayrollHome = {
  cycles: CycleListRow[];
  hasActiveRuleSet: boolean;
  ruleSetName: string | null;
  hasOpenCycle: boolean;          // a non-LOCKED cycle exists (only one at a time)
  suggested: { year: number; month: number; label: string };
};

export async function getPayrollHome(): Promise<PayrollHome> {
  const [cycles, ruleset] = await Promise.all([
    prisma.payCycle.findMany({
      orderBy: [{ periodYear: "desc" }, { periodMonth: "desc" }],
      select: {
        id: true, label: true, periodYear: true, periodMonth: true, status: true,
        totalNet: true, totalPayable: true, approvedAt: true, lockedAt: true, createdAt: true,
        _count: { select: { items: true } },
      },
    }),
    getActiveTaxRuleSet(),
  ]);

  const rows: CycleListRow[] = cycles.map((c) => ({
    id: c.id, label: c.label, periodYear: c.periodYear, periodMonth: c.periodMonth,
    status: c.status, itemCount: c._count.items,
    totalNet: c.totalNet === null ? null : num(c.totalNet),
    totalPayable: c.totalPayable === null ? null : num(c.totalPayable),
    approvedAt: c.approvedAt, lockedAt: c.lockedAt, createdAt: c.createdAt,
  }));

  const hasOpenCycle = rows.some((c) => c.status !== "LOCKED");

  // Suggest the month after the latest cycle, else the current month.
  let sy: number, sm: number;
  if (rows.length) {
    const latest = rows[0];
    sm = latest.periodMonth === 12 ? 1 : latest.periodMonth + 1;
    sy = latest.periodMonth === 12 ? latest.periodYear + 1 : latest.periodYear;
  } else {
    const now = new Date();
    sy = now.getUTCFullYear(); sm = now.getUTCMonth() + 1;
  }

  return {
    cycles: rows,
    hasActiveRuleSet: !!ruleset,
    ruleSetName: ruleset?.name ?? null,
    hasOpenCycle,
    suggested: { year: sy, month: sm, label: cycleLabel(sy, sm) },
  };
}

// ---------------------------------------------------------------------------
// One cycle, fully expanded for the control room + export
// ---------------------------------------------------------------------------
export type PayRow = {
  id: string;
  employeeId: string;
  eeId: string;
  name: string;
  grade: string | null;
  payCategory: string | null;
  // snapshot inputs
  basicSalary: number;
  utilityAllowance: number;
  quarterlyAllowance: number;
  thirteenthMonth: number;
  taxTreatment: string;
  // computed
  grossPay: number;
  employeePension: number;
  nhf: number;
  itf: number;
  taxableIncome: number;
  payeTax: number;
  employerPension: number;
  // adjustments + net
  adjustments: Adjustment[];
  adjustmentAllowances: number;
  adjustmentDeductions: number;
  netPay: number;          // gross + adj allowances - (pension+nhf+itf+paye+adj deductions)
  totalPayable: number;    // net + quarterly (paid separately)
  // review
  reviewStatus: string;
  changeNote: string | null;
  confirmedAt: Date | null;
};

export type CycleTotals = {
  basic: number; utility: number; quarterly: number; thirteenth: number; gross: number;
  employeePension: number; nhf: number; itf: number; paye: number;
  otherDeductions: number;   // pension(EE) + nhf + itf + adj deductions
  totalDeductions: number;   // otherDeductions + paye
  employerPension: number; net: number; totalPayable: number;
  adjustmentAllowances: number;
};

export type CycleView = {
  id: string;
  label: string;
  periodYear: number;
  periodMonth: number;
  status: string;
  isQuarterMonth: boolean;
  isThirteenthMonth: boolean;
  monthType: string;
  flags: { kind: string; message: string }[];
  ruleSetName: string | null;
  approvedAt: Date | null;
  approvedByName: string | null;
  generatedAt: Date | null;
  lockedAt: Date | null;
  rows: PayRow[];
  totals: CycleTotals;
  confirmedCount: number;
  allConfirmed: boolean;
  editable: boolean;   // DRAFT or IN_REVIEW
} | null;

export async function getCycle(cycleId: string): Promise<CycleView> {
  const cycle = await prisma.payCycle.findUnique({
    where: { id: cycleId },
    include: {
      items: {
        include: {
          employee: {
            select: {
              eeId: true, fullName: true, preferredName: true,
              jobProfile: { select: { grade: true } },
              payCategory: { select: { name: true } },
            },
          },
        },
      },
    },
  });
  if (!cycle) return null;

  const ruleset = cycle.taxRuleSetId
    ? await prisma.taxRuleSet.findUnique({ where: { id: cycle.taxRuleSetId }, select: { name: true } })
    : await getActiveTaxRuleSet();

  let approvedByName: string | null = null;
  if (cycle.approvedById) {
    const u = await prisma.user.findUnique({ where: { id: cycle.approvedById }, select: { name: true } });
    approvedByName = u?.name ?? null;
  }

  const items = [...cycle.items].sort((a, b) => {
    const na = Number(a.employee.eeId.replace(/\D/g, "")) || 0;
    const nb = Number(b.employee.eeId.replace(/\D/g, "")) || 0;
    return na - nb;
  });

  const rows: PayRow[] = items.map((it) => {
    const adj = parseAdjustments(it.adjustments);
    const { allowances, deductions } = adjustmentsNet(adj);
    const gross = num(it.grossPay);
    const ee = num(it.employeePension), nhf = num(it.nhf), itf = num(it.itf), paye = num(it.payeTax);
    const quarterly = num(it.quarterlyAllowance);
    const thirteenth = num(it.thirteenthMonth);
    const net = round2(gross + allowances - ee - nhf - itf - paye - deductions);
    return {
      id: it.id,
      employeeId: it.employeeId,
      eeId: it.employee.eeId,
      name: personName(it.employee),
      grade: it.employee.jobProfile?.grade ?? null,
      payCategory: it.employee.payCategory?.name ?? null,
      basicSalary: num(it.basicSalary),
      utilityAllowance: num(it.utilityAllowance),
      quarterlyAllowance: quarterly,
      thirteenthMonth: thirteenth,
      taxTreatment: String(it.taxTreatment),
      grossPay: gross,
      employeePension: ee,
      nhf,
      itf,
      taxableIncome: num(it.taxableIncome),
      payeTax: paye,
      employerPension: num(it.employerPension),
      adjustments: adj,
      adjustmentAllowances: allowances,
      adjustmentDeductions: deductions,
      netPay: net,
      totalPayable: round2(net + quarterly + thirteenth),
      reviewStatus: String(it.reviewStatus),
      changeNote: it.changeNote ?? null,
      confirmedAt: it.confirmedAt,
    };
  });

  const totals = sumRows(rows);
  const confirmedCount = rows.filter((r) => r.reviewStatus === "CONFIRMED").length;

  // Month-type control checks (Ops Manual F2.2 Step 3): the quarterly is additive in
  // quarter-end months only; the thirteenth only in a 13th-month run. Flag any cycle whose
  // structure doesn't match its type (catches the "utility substituted by quarterly" and
  // double-payment failure modes).
  const quarter = isQuarterMonth(cycle.periodMonth);
  const thirteenth = cycle.isThirteenthMonth;
  const monthType = thirteenth
    ? "13th-month run"
    : quarter
      ? "Quarter-end month"
      : "Standard month";
  const eligible = rows.filter((r) => r.grossPay > 0);
  const flags: { kind: string; message: string }[] = [];
  if (quarter) {
    const n = eligible.filter((r) => r.quarterlyAllowance <= 0).length;
    if (n) flags.push({ kind: "WARN", message: `${n} eligible employee(s) have no quarterly payment line in this quarter-end cycle.` });
  } else {
    const n = rows.filter((r) => r.quarterlyAllowance > 0).length;
    if (n) flags.push({ kind: "ERROR", message: `${n} employee(s) carry a quarterly payment in a standard (non-quarter) month — possible double payment.` });
  }
  if (thirteenth) {
    const n = eligible.filter((r) => r.thirteenthMonth <= 0).length;
    if (n) flags.push({ kind: "WARN", message: `${n} eligible employee(s) have no thirteenth-month line in this 13th-month run.` });
  } else {
    const n = rows.filter((r) => r.thirteenthMonth > 0).length;
    if (n) flags.push({ kind: "ERROR", message: `${n} employee(s) carry a thirteenth-month payment outside a 13th-month run.` });
  }

  return {
    id: cycle.id,
    label: cycle.label,
    periodYear: cycle.periodYear,
    periodMonth: cycle.periodMonth,
    status: cycle.status,
    isQuarterMonth: quarter,
    isThirteenthMonth: thirteenth,
    monthType,
    flags,
    ruleSetName: ruleset?.name ?? null,
    approvedAt: cycle.approvedAt,
    approvedByName,
    generatedAt: cycle.generatedAt,
    lockedAt: cycle.lockedAt,
    rows,
    totals,
    confirmedCount,
    allConfirmed: rows.length > 0 && confirmedCount === rows.length,
    editable: cycle.status === "DRAFT" || cycle.status === "IN_REVIEW",
  };
}

function round2(n: number): number { return Math.round((n + Number.EPSILON) * 100) / 100; }

export function sumRows(rows: PayRow[]): CycleTotals {
  const t: CycleTotals = {
    basic: 0, utility: 0, quarterly: 0, thirteenth: 0, gross: 0, employeePension: 0, nhf: 0, itf: 0,
    paye: 0, otherDeductions: 0, totalDeductions: 0, employerPension: 0, net: 0,
    totalPayable: 0, adjustmentAllowances: 0,
  };
  for (const r of rows) {
    t.basic += r.basicSalary; t.utility += r.utilityAllowance; t.quarterly += r.quarterlyAllowance;
    t.thirteenth += r.thirteenthMonth;
    t.gross += r.grossPay; t.employeePension += r.employeePension; t.nhf += r.nhf; t.itf += r.itf;
    t.paye += r.payeTax; t.employerPension += r.employerPension; t.net += r.netPay;
    t.totalPayable += r.totalPayable; t.adjustmentAllowances += r.adjustmentAllowances;
    t.otherDeductions += r.employeePension + r.nhf + r.itf + r.adjustmentDeductions;
  }
  t.totalDeductions = t.otherDeductions + t.paye;
  for (const k of Object.keys(t) as (keyof CycleTotals)[]) t[k] = round2(t[k]);
  return t;
}

// ---------------------------------------------------------------------------
// Eligibility preview for opening a cycle: who carries forward, who is skipped.
// ---------------------------------------------------------------------------
export type OpenPreview = {
  eligible: { employeeId: string; eeId: string; name: string }[];
  skipped: { eeId: string; name: string; reason: string }[];
  hasActiveRuleSet: boolean;
};

export async function getOpenPreview(): Promise<OpenPreview> {
  const [employees, profiles, ruleset] = await Promise.all([
    prisma.employee.findMany({
      where: { status: { notIn: ["EXITED"] } },
      select: { id: true, eeId: true, fullName: true, preferredName: true },
      orderBy: { eeId: "asc" },
    }),
    prisma.compensationProfile.findMany({
      where: { isCurrent: true },
      select: { employeeId: true },
    }),
    getActiveTaxRuleSet(),
  ]);
  const withProfile = new Set(profiles.map((p) => p.employeeId));
  const eligible: OpenPreview["eligible"] = [];
  const skipped: OpenPreview["skipped"] = [];
  for (const e of employees) {
    if (withProfile.has(e.id)) eligible.push({ employeeId: e.id, eeId: e.eeId, name: personName(e) });
    else skipped.push({ eeId: e.eeId, name: personName(e), reason: "No current compensation profile" });
  }
  return { eligible, skipped, hasActiveRuleSet: !!ruleset };
}

// Recompute a single row's breakdown from its snapshot inputs (used by actions).
export function computeRow(
  input: ComputePayInput,
  rules: TaxRules,
): PayBreakdown {
  return computePay(input, rules);
}

export { fmtNaira };
