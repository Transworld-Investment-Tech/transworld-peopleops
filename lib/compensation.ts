// lib/compensation.ts — Compensation control-room read layer + presentation
// helpers. Read-only here; audited writes live in lib/compensation-actions.ts.
//
// This module never pays anyone. It reproduces a *provisional* pay breakdown as a
// cross-check (HumanManager + Remita stay authoritative) using the pure engine in
// lib/payroll.ts, fed entirely by the active TaxRuleSet (nothing hardcoded).
//
// Cross-entity references for the new models (comp_change_requests) are bare
// columns — requester/decider users and the applied profile are resolved by id
// at the edge, and Prisma Decimals are converted to numbers with Number().
import { prisma } from "@/lib/db";
import {
  computePay,
  type ComputePayInput,
  type PayBreakdown,
  type TaxRules,
  type TaxBandInput,
  type TaxTreatmentValue,
} from "@/lib/payroll";

// ---------------------------------------------------------------------------
// Vocabularies
// ---------------------------------------------------------------------------
export const TAX_TREATMENTS = [
  { value: "PAYE", label: "PAYE (banded)" },
  { value: "EXEMPT", label: "Tax exempt" },
  { value: "FLAT_RATE", label: "Flat rate" },
] as const;

export const REQUEST_STATUSES = [
  { value: "PENDING", label: "Pending" },
  { value: "APPROVED", label: "Approved" },
  { value: "REJECTED", label: "Rejected" },
] as const;

// ---------------------------------------------------------------------------
// Formatting + badges
// ---------------------------------------------------------------------------
/** Format a number as Naira (no currency-code clutter). dp = decimal places. */
export function fmtNaira(n: number | null | undefined, dp = 0): string {
  if (n === null || n === undefined || Number.isNaN(n)) return "—";
  return "₦" + n.toLocaleString("en-US", { minimumFractionDigits: dp, maximumFractionDigits: dp });
}

/** Format a stored fraction (e.g. 0.10) as a percent string (e.g. "10%"). */
export function fmtPct(fraction: number | null | undefined): string {
  if (fraction === null || fraction === undefined || Number.isNaN(fraction)) return "—";
  const pct = fraction * 100;
  const rounded = Math.round(pct * 100) / 100;
  return `${rounded}%`;
}

export function treatmentBadge(t: string): { cls: string; label: string } {
  switch (t) {
    case "PAYE":
      return { cls: "b-blu", label: "PAYE" };
    case "EXEMPT":
      return { cls: "b-gry", label: "Exempt" };
    case "FLAT_RATE":
      return { cls: "b-amb", label: "Flat rate" };
    default:
      return { cls: "b-gry", label: t };
  }
}

export function requestStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PENDING":
      return { cls: "b-amb", label: "Pending" };
    case "APPROVED":
      return { cls: "b-grn", label: "Approved" };
    case "REJECTED":
      return { cls: "b-red", label: "Rejected" };
    default:
      return { cls: "b-gry", label: s };
  }
}

// ---------------------------------------------------------------------------
// Decimal helpers (Prisma Decimal | number | null -> number)
// ---------------------------------------------------------------------------
function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  return Number(v);
}
function numOrNull(v: unknown): number | null {
  if (v === null || v === undefined) return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
}
function asTreatment(v: unknown): TaxTreatmentValue {
  const s = String(v ?? "PAYE");
  return s === "EXEMPT" || s === "FLAT_RATE" ? s : "PAYE";
}

// ---------------------------------------------------------------------------
// Tax rule sets
// ---------------------------------------------------------------------------
type RuleSetRow = {
  id: string;
  name: string;
  effectiveFrom: Date;
  exemptThresholdAnnual: unknown;
  pensionEmployeeRate: unknown;
  pensionEmployerRate: unknown;
  nhfRate: unknown;
  rentReliefRate: unknown;
  rentReliefCapAnnual: unknown;
  pensionOnBasicOnly: boolean;
  payeOnBasicOnly: boolean;
  employerPensionOnGross: boolean;
  itfRate: unknown;
  isActive: boolean;
  bands: { id: string; sequence: number; lowerBound: unknown; upperBound: unknown; rate: unknown }[];
};

/** Convert a TaxRuleSet (with bands) into the plain numeric TaxRules the engine wants. */
export function rulesFrom(ruleset: RuleSetRow): TaxRules {
  const bands: TaxBandInput[] = [...ruleset.bands]
    .sort((a, b) => a.sequence - b.sequence)
    .map((bd) => ({
      sequence: bd.sequence,
      lowerBound: num(bd.lowerBound),
      upperBound: numOrNull(bd.upperBound),
      rate: num(bd.rate),
    }));
  return {
    exemptThresholdAnnual: num(ruleset.exemptThresholdAnnual),
    pensionEmployeeRate: num(ruleset.pensionEmployeeRate),
    pensionEmployerRate: num(ruleset.pensionEmployerRate),
    nhfRate: num(ruleset.nhfRate),
    rentReliefRate: num(ruleset.rentReliefRate),
    rentReliefCapAnnual: num(ruleset.rentReliefCapAnnual),
    pensionOnBasicOnly: ruleset.pensionOnBasicOnly,
    payeOnBasicOnly: ruleset.payeOnBasicOnly,
    employerPensionOnGross: ruleset.employerPensionOnGross,
    itfRate: num(ruleset.itfRate),
    bands,
  };
}

export async function getActiveTaxRuleSet(): Promise<RuleSetRow | null> {
  return prisma.taxRuleSet.findFirst({
    where: { isActive: true },
    include: { bands: { orderBy: { sequence: "asc" } } },
    orderBy: { effectiveFrom: "desc" },
  });
}

export async function getTaxRuleSets(): Promise<RuleSetRow[]> {
  return prisma.taxRuleSet.findMany({
    include: { bands: { orderBy: { sequence: "asc" } } },
    orderBy: [{ isActive: "desc" }, { effectiveFrom: "desc" }],
  });
}

// ---------------------------------------------------------------------------
// Profile -> engine input -> breakdown
// ---------------------------------------------------------------------------
type ProfileLike = {
  basicSalary: unknown;
  utilityAllowance: unknown;
  quarterlyAllowance: unknown;
  taxTreatment: unknown;
  flatTaxRate: unknown;
  annualRentPaid: unknown;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
};

export function inputFromProfile(p: ProfileLike): ComputePayInput {
  return {
    basicSalary: num(p.basicSalary),
    utilityAllowance: num(p.utilityAllowance),
    quarterlyAllowance: num(p.quarterlyAllowance),
    taxTreatment: asTreatment(p.taxTreatment),
    flatTaxRate: numOrNull(p.flatTaxRate),
    annualRentPaid: numOrNull(p.annualRentPaid),
    pensionApplicable: p.pensionApplicable,
    nhfApplicable: p.nhfApplicable,
  };
}

export function breakdownFor(p: ProfileLike, rules: TaxRules): PayBreakdown {
  return computePay(inputFromProfile(p), rules);
}

// ---------------------------------------------------------------------------
// Shared profile / request view shapes
// ---------------------------------------------------------------------------
export type ProfileView = {
  id: string;
  effectiveDate: Date;
  basicSalary: number;
  utilityAllowance: number;
  quarterlyAllowance: number;
  taxTreatment: string;
  flatTaxRate: number | null;
  annualRentPaid: number | null;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
  isCurrent: boolean;
};

function toProfileView(p: {
  id: string;
  effectiveDate: Date;
  basicSalary: unknown;
  utilityAllowance: unknown;
  quarterlyAllowance: unknown;
  taxTreatment: unknown;
  flatTaxRate: unknown;
  annualRentPaid: unknown;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
  isCurrent: boolean;
}): ProfileView {
  return {
    id: p.id,
    effectiveDate: p.effectiveDate,
    basicSalary: num(p.basicSalary),
    utilityAllowance: num(p.utilityAllowance),
    quarterlyAllowance: num(p.quarterlyAllowance),
    taxTreatment: String(p.taxTreatment),
    flatTaxRate: numOrNull(p.flatTaxRate),
    annualRentPaid: numOrNull(p.annualRentPaid),
    pensionApplicable: p.pensionApplicable,
    nhfApplicable: p.nhfApplicable,
    isCurrent: p.isCurrent,
  };
}

export type CompFields = {
  basicSalary: number;
  utilityAllowance: number;
  quarterlyAllowance: number;
  taxTreatment: string;
  flatTaxRate: number | null;
  annualRentPaid: number | null;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
};

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Register (one row per non-exited employee)
// ---------------------------------------------------------------------------
export type RegisterRow = {
  employeeId: string;
  eeId: string;
  name: string;
  role: string | null;
  grade: string | null;
  payCategory: string | null;
  hasProfile: boolean;
  treatment: string | null;
  basic: number | null;
  gross: number | null;
  paye: number | null;
  net: number | null;
  pendingRequest: boolean;
};

export type CompensationRegister = {
  rows: RegisterRow[];
  hasActiveRuleSet: boolean;
  missingProfiles: { eeId: string; name: string }[];
  pendingCount: number;
};

export async function getCompensationRegister(): Promise<CompensationRegister> {
  const [employees, profiles, ruleset, pending] = await Promise.all([
    prisma.employee.findMany({
      where: { status: { not: "EXITED" } },
      select: {
        id: true,
        eeId: true,
        fullName: true,
        preferredName: true,
        jobProfile: { select: { title: true, grade: true } },
        payCategory: { select: { name: true } },
      },
      orderBy: { eeId: "asc" },
    }),
    prisma.compensationProfile.findMany({
      where: { isCurrent: true },
      select: {
        id: true,
        employeeId: true,
        effectiveDate: true,
        basicSalary: true,
        utilityAllowance: true,
        quarterlyAllowance: true,
        taxTreatment: true,
        flatTaxRate: true,
        annualRentPaid: true,
        pensionApplicable: true,
        nhfApplicable: true,
        isCurrent: true,
      },
    }),
    getActiveTaxRuleSet(),
    prisma.compChangeRequest.findMany({
      where: { status: "PENDING" },
      select: { employeeId: true },
    }),
  ]);

  const rules = ruleset ? rulesFrom(ruleset) : null;
  const byEmp = new Map(profiles.map((p) => [p.employeeId, p] as const));
  const pendingSet = new Set(pending.map((r) => r.employeeId));

  const rows: RegisterRow[] = employees.map((e) => {
    const p = byEmp.get(e.id);
    if (!p) {
      return {
        employeeId: e.id,
        eeId: e.eeId,
        name: personName(e),
        role: e.jobProfile?.title ?? null,
        grade: e.jobProfile?.grade ?? null,
        payCategory: e.payCategory?.name ?? null,
        hasProfile: false,
        treatment: null,
        basic: null,
        gross: null,
        paye: null,
        net: null,
        pendingRequest: pendingSet.has(e.id),
      };
    }
    const view = toProfileView(p);
    const basic = view.basicSalary;
    const gross = basic + view.utilityAllowance;
    const bd = rules ? breakdownFor(view, rules) : null;
    return {
      employeeId: e.id,
      eeId: e.eeId,
      name: personName(e),
      role: e.jobProfile?.title ?? null,
      grade: e.jobProfile?.grade ?? null,
      payCategory: e.payCategory?.name ?? null,
      hasProfile: true,
      treatment: view.taxTreatment,
      basic,
      gross: bd ? bd.monthlyGross : gross,
      paye: bd ? bd.paye : null,
      net: bd ? bd.netPay : null,
      pendingRequest: pendingSet.has(e.id),
    };
  });

  const missingProfiles = rows
    .filter((r) => !r.hasProfile)
    .map((r) => ({ eeId: r.eeId, name: r.name }));

  return {
    rows,
    hasActiveRuleSet: !!ruleset,
    missingProfiles,
    pendingCount: pendingSet.size,
  };
}

/** Just the pending count — for the tabs badge, cheaply. */
export async function getPendingRequestCount(): Promise<number> {
  return prisma.compChangeRequest.count({ where: { status: "PENDING" } });
}

// ---------------------------------------------------------------------------
// One employee's compensation (detail page)
// ---------------------------------------------------------------------------
export type RequestView = {
  id: string;
  status: string;
  reason: string | null;
  effectiveDate: Date;
  requestedAt: Date;
  decidedAt: Date | null;
  decisionNote: string | null;
  requestedById: string | null;
  requestedBy: string | null;
  decidedBy: string | null;
  selfApproved: boolean;
  fields: CompFields;
};

export type EmployeeCompensation = {
  employee: { id: string; eeId: string; name: string };
  role: string | null;
  grade: string | null;
  payCategory: string | null;
  current: ProfileView | null;
  versions: ProfileView[];
  hasActiveRuleSet: boolean;
  breakdown: PayBreakdown | null;
  pending: RequestView | null;
  pendingPreview: PayBreakdown | null;
};

async function resolveUserNames(ids: (string | null | undefined)[]): Promise<Map<string, string>> {
  const want = Array.from(new Set(ids.filter((x): x is string => !!x)));
  if (want.length === 0) return new Map();
  const users = await prisma.user.findMany({
    where: { id: { in: want } },
    select: { id: true, name: true },
  });
  return new Map(users.map((u) => [u.id, u.name] as const));
}

export async function getEmployeeCompensation(
  employeeId: string
): Promise<EmployeeCompensation | null> {
  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { title: true, grade: true } },
      payCategory: { select: { name: true } },
    },
  });
  if (!employee) return null;

  const [profiles, ruleset, pendingRow] = await Promise.all([
    prisma.compensationProfile.findMany({
      where: { employeeId },
      orderBy: [{ isCurrent: "desc" }, { effectiveDate: "desc" }, { createdAt: "desc" }],
      select: {
        id: true,
        effectiveDate: true,
        basicSalary: true,
        utilityAllowance: true,
        quarterlyAllowance: true,
        taxTreatment: true,
        flatTaxRate: true,
        annualRentPaid: true,
        pensionApplicable: true,
        nhfApplicable: true,
        isCurrent: true,
        createdAt: true,
      },
    }),
    getActiveTaxRuleSet(),
    prisma.compChangeRequest.findFirst({
      where: { employeeId, status: "PENDING" },
      orderBy: { requestedAt: "desc" },
    }),
  ]);

  const versions = profiles.map(toProfileView);
  const current = versions.find((v) => v.isCurrent) ?? null;
  const rules = ruleset ? rulesFrom(ruleset) : null;
  const breakdown = current && rules ? breakdownFor(current, rules) : null;

  let pending: RequestView | null = null;
  let pendingPreview: PayBreakdown | null = null;
  if (pendingRow) {
    const names = await resolveUserNames([pendingRow.requestedById, pendingRow.decidedById]);
    const fields: CompFields = {
      basicSalary: num(pendingRow.basicSalary),
      utilityAllowance: num(pendingRow.utilityAllowance),
      quarterlyAllowance: num(pendingRow.quarterlyAllowance),
      taxTreatment: String(pendingRow.taxTreatment),
      flatTaxRate: numOrNull(pendingRow.flatTaxRate),
      annualRentPaid: numOrNull(pendingRow.annualRentPaid),
      pensionApplicable: pendingRow.pensionApplicable,
      nhfApplicable: pendingRow.nhfApplicable,
    };
    pending = {
      id: pendingRow.id,
      status: pendingRow.status,
      reason: pendingRow.reason,
      effectiveDate: pendingRow.effectiveDate,
      requestedAt: pendingRow.requestedAt,
      decidedAt: pendingRow.decidedAt,
      decisionNote: pendingRow.decisionNote,
      requestedById: pendingRow.requestedById ?? null,
      requestedBy: pendingRow.requestedById ? names.get(pendingRow.requestedById) ?? null : null,
      decidedBy: pendingRow.decidedById ? names.get(pendingRow.decidedById) ?? null : null,
      selfApproved: false,
      fields,
    };
    if (rules) pendingPreview = computePay(fieldsToInput(fields), rules);
  }

  return {
    employee: { id: employee.id, eeId: employee.eeId, name: personName(employee) },
    role: employee.jobProfile?.title ?? null,
    grade: employee.jobProfile?.grade ?? null,
    payCategory: employee.payCategory?.name ?? null,
    current,
    versions,
    hasActiveRuleSet: !!ruleset,
    breakdown,
    pending,
    pendingPreview,
  };
}

function fieldsToInput(f: CompFields): ComputePayInput {
  return {
    basicSalary: f.basicSalary,
    utilityAllowance: f.utilityAllowance,
    quarterlyAllowance: f.quarterlyAllowance,
    taxTreatment: asTreatment(f.taxTreatment),
    flatTaxRate: f.flatTaxRate,
    annualRentPaid: f.annualRentPaid,
    pensionApplicable: f.pensionApplicable,
    nhfApplicable: f.nhfApplicable,
  };
}

// ---------------------------------------------------------------------------
// Salary bands
// ---------------------------------------------------------------------------
export type SalaryBandView = {
  id: string;
  grade: string;
  label: string;
  min: number;
  midpoint: number;
  max: number;
  staff: number;
};

export async function getSalaryBands(): Promise<SalaryBandView[]> {
  const [bands, employees] = await Promise.all([
    prisma.salaryBand.findMany({ orderBy: [{ sortOrder: "asc" }, { grade: "desc" }] }),
    prisma.employee.findMany({
      where: { status: { not: "EXITED" } },
      select: { jobProfile: { select: { grade: true } } },
    }),
  ]);

  const staffByGrade = new Map<string, number>();
  for (const e of employees) {
    const g = e.jobProfile?.grade;
    if (!g) continue;
    staffByGrade.set(g, (staffByGrade.get(g) ?? 0) + 1);
  }

  return bands.map((b) => ({
    id: b.id,
    grade: b.grade,
    label: b.label,
    min: num(b.minAmount),
    midpoint: num(b.midpoint),
    max: num(b.maxAmount),
    staff: staffByGrade.get(b.grade) ?? 0,
  }));
}

// ---------------------------------------------------------------------------
// Change requests (list / requests page)
// ---------------------------------------------------------------------------
export type ChangeRequestRow = {
  id: string;
  status: string;
  reason: string | null;
  effectiveDate: Date;
  requestedAt: Date;
  decidedAt: Date | null;
  decisionNote: string | null;
  requestedById: string | null;
  requestedBy: string | null;
  decidedBy: string | null;
  selfApproved: boolean;
  employee: { id: string; eeId: string; name: string; role: string | null; grade: string | null };
  proposed: CompFields;
  current: CompFields | null;
};

export async function getCompChangeRequests(status?: string): Promise<ChangeRequestRow[]> {
  const where =
    status && status !== "ALL" && (REQUEST_STATUSES as readonly { value: string }[]).some((s) => s.value === status)
      ? { status }
      : {};

  const requests = await prisma.compChangeRequest.findMany({
    where,
    orderBy: [{ requestedAt: "desc" }],
  });
  if (requests.length === 0) return [];

  const empIds = Array.from(new Set(requests.map((r) => r.employeeId)));
  const [employees, currentProfiles, userNames] = await Promise.all([
    prisma.employee.findMany({
      where: { id: { in: empIds } },
      select: {
        id: true,
        eeId: true,
        fullName: true,
        preferredName: true,
        jobProfile: { select: { title: true, grade: true } },
      },
    }),
    prisma.compensationProfile.findMany({
      where: { employeeId: { in: empIds }, isCurrent: true },
      select: {
        employeeId: true,
        basicSalary: true,
        utilityAllowance: true,
        quarterlyAllowance: true,
        taxTreatment: true,
        flatTaxRate: true,
        annualRentPaid: true,
        pensionApplicable: true,
        nhfApplicable: true,
      },
    }),
    resolveUserNames(requests.flatMap((r) => [r.requestedById, r.decidedById])),
  ]);

  const empById = new Map(employees.map((e) => [e.id, e] as const));
  const curByEmp = new Map(
    currentProfiles.map((p) => [
      p.employeeId,
      {
        basicSalary: num(p.basicSalary),
        utilityAllowance: num(p.utilityAllowance),
        quarterlyAllowance: num(p.quarterlyAllowance),
        taxTreatment: String(p.taxTreatment),
        flatTaxRate: numOrNull(p.flatTaxRate),
        annualRentPaid: numOrNull(p.annualRentPaid),
        pensionApplicable: p.pensionApplicable,
        nhfApplicable: p.nhfApplicable,
      } as CompFields,
    ])
  );

  return requests.map((r) => {
    const e = empById.get(r.employeeId);
    return {
      id: r.id,
      status: r.status,
      reason: r.reason,
      effectiveDate: r.effectiveDate,
      requestedAt: r.requestedAt,
      decidedAt: r.decidedAt,
      decisionNote: r.decisionNote,
      requestedById: r.requestedById ?? null,
      requestedBy: r.requestedById ? userNames.get(r.requestedById) ?? null : null,
      decidedBy: r.decidedById ? userNames.get(r.decidedById) ?? null : null,
      selfApproved: !!r.requestedById && r.requestedById === r.decidedById,
      employee: {
        id: r.employeeId,
        eeId: e?.eeId ?? "—",
        name: e ? personName(e) : "Unknown",
        role: e?.jobProfile?.title ?? null,
        grade: e?.jobProfile?.grade ?? null,
      },
      proposed: {
        basicSalary: num(r.basicSalary),
        utilityAllowance: num(r.utilityAllowance),
        quarterlyAllowance: num(r.quarterlyAllowance),
        taxTreatment: String(r.taxTreatment),
        flatTaxRate: numOrNull(r.flatTaxRate),
        annualRentPaid: numOrNull(r.annualRentPaid),
        pensionApplicable: r.pensionApplicable,
        nhfApplicable: r.nhfApplicable,
      },
      current: curByEmp.get(r.employeeId) ?? null,
    };
  });
}
