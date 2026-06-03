"use server";
// lib/payroll-cycle-actions.ts — Payroll Control Center write actions (v0.19.0).
//
// The portal never pays anyone. These actions reproduce the monthly control sheet
// as a review-and-confirm cross-check and lock it as evidence. Segregation of duties:
// payroll.manage prepares (open/adjust/confirm/submit); payroll.approve approves and
// locks (a separate role — FINANCE prepares, EXEC approves). Every mutation is gated
// + audited. Cross-entity ids stay bare; nothing here pays or files anything.
//
// "use server" rule: this module exports only async functions plus the FormState type.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { getActiveTaxRuleSet, rulesFrom } from "@/lib/compensation";
import { computePay, type ComputePayInput } from "@/lib/payroll";
import { cycleLabel, isQuarterMonth, type Adjustment } from "@/lib/payroll-cycle";

export type FormState = { ok: boolean; error?: string; message?: string };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}
function round2(n: number): number { return Math.round((n + Number.EPSILON) * 100) / 100; }

function inputFrom(p: {
  basicSalary: number; utilityAllowance: number; quarterlyAllowance: number;
  taxTreatment: string; flatTaxRate: number | null; annualRentPaid: number | null;
  pensionApplicable: boolean; nhfApplicable: boolean; itfApplicable: boolean;
}): ComputePayInput {
  const t = p.taxTreatment === "EXEMPT" || p.taxTreatment === "FLAT_RATE" ? p.taxTreatment : "PAYE";
  return {
    basicSalary: p.basicSalary, utilityAllowance: p.utilityAllowance, quarterlyAllowance: p.quarterlyAllowance,
    taxTreatment: t, flatTaxRate: p.flatTaxRate, annualRentPaid: p.annualRentPaid,
    pensionApplicable: p.pensionApplicable, nhfApplicable: p.nhfApplicable, itfApplicable: p.itfApplicable,
  };
}

// ---------------------------------------------------------------------------
// Open a cycle: snapshot current compensation profiles into pay_items, compute
// each breakdown against the active rule set, capture last period for variance.
// ---------------------------------------------------------------------------
const openSchema = z.object({
  year: z.coerce.number().int().min(2020).max(2100),
  month: z.coerce.number().int().min(1).max(12),
});

export async function openCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const parsed = openSchema.safeParse({ year: formData.get("year"), month: formData.get("month") });
  if (!parsed.success) return { ok: false, error: "Enter a valid month and year." };
  const { year, month } = parsed.data;

  // Only one open (non-locked) cycle at a time.
  const open = await prisma.payCycle.findFirst({ where: { status: { not: "LOCKED" } }, select: { id: true, label: true } });
  if (open) return { ok: false, error: `A cycle is already open (${open.label}). Lock or finish it before opening another.` };

  const existing = await prisma.payCycle.findUnique({ where: { periodYear_periodMonth: { periodYear: year, periodMonth: month } }, select: { id: true } });
  if (existing) return { ok: false, error: `A cycle for ${cycleLabel(year, month)} already exists.` };

  const ruleset = await getActiveTaxRuleSet();
  if (!ruleset) return { ok: false, error: "No active tax rule set. Activate one under Compensation → Tax rules first." };
  const rules = rulesFrom(ruleset);

  const profiles = await prisma.compensationProfile.findMany({
    where: { isCurrent: true },
    select: {
      employeeId: true, basicSalary: true, utilityAllowance: true, quarterlyAllowance: true,
      taxTreatment: true, flatTaxRate: true, annualRentPaid: true, pensionApplicable: true, nhfApplicable: true,
      employee: { select: { status: true, payCategoryId: true } },
    },
  });
  const active = profiles.filter((p) => p.employee.status !== "EXITED");
  if (active.length === 0) return { ok: false, error: "No active employees with a compensation profile to carry forward." };

  // Prior cycle (most recent by period) for the variance baseline.
  const prior = await prisma.payCycle.findFirst({
    where: { OR: [{ periodYear: { lt: year } }, { periodYear: year, periodMonth: { lt: month } }] },
    orderBy: [{ periodYear: "desc" }, { periodMonth: "desc" }],
    select: { id: true },
  });
  const priorItems = prior
    ? await prisma.payItem.findMany({ where: { payCycleId: prior.id }, select: { employeeId: true, grossPay: true, netPay: true, payeTax: true, employerPension: true } })
    : [];
  const priorByEmp = new Map(priorItems.map((p) => [p.employeeId, p] as const));

  const quarter = isQuarterMonth(month);

  const created = await prisma.$transaction(async (tx) => {
    const cycle = await tx.payCycle.create({
      data: { label: cycleLabel(year, month), periodMonth: month, periodYear: year, status: "DRAFT", taxRuleSetId: ruleset.id, carriedForwardFromId: prior?.id ?? null },
      select: { id: true },
    });
    for (const p of active) {
      const monthlyUtility = num(p.utilityAllowance);
      // Canonical pay structure (Ops Manual F2.0): utility is paid EVERY month, never
      // suppressed. The quarterly payment is additive in quarter-end months and equals one
      // month's gross (basic + utility) — not the old stored quarterly component.
      const utility = monthlyUtility;
      const bd = computePay(
        inputFrom({
          basicSalary: num(p.basicSalary), utilityAllowance: utility, quarterlyAllowance: 0,
          taxTreatment: String(p.taxTreatment), flatTaxRate: p.flatTaxRate === null ? null : num(p.flatTaxRate),
          annualRentPaid: p.annualRentPaid === null ? null : num(p.annualRentPaid),
          pensionApplicable: p.pensionApplicable, nhfApplicable: p.nhfApplicable, itfApplicable: true,
        }),
        rules,
      );
      const quarterly = quarter ? bd.monthlyGross : 0;
      const prev = priorByEmp.get(p.employeeId);
      await tx.payItem.create({
        data: {
          payCycleId: cycle.id, employeeId: p.employeeId, payCategoryId: p.employee.payCategoryId ?? null,
          basicSalary: num(p.basicSalary), utilityAllowance: utility, quarterlyAllowance: quarterly, thirteenthMonth: 0,
          taxTreatment: bd.taxTreatment, grossPay: bd.monthlyGross, employeePension: bd.pensionEmployee,
          nhf: bd.nhf, itf: bd.itf, taxableIncome: bd.annualTaxableIncome, payeTax: bd.paye,
          netPay: bd.netPay, employerPension: bd.pensionEmployer, reviewStatus: prev ? "CARRIED_FORWARD" : "NEW",
          adjustments: undefined,
          previousValues: prev
            ? { grossPay: num(prev.grossPay), netPay: num(prev.netPay), payeTax: num(prev.payeTax), employerPension: num(prev.employerPension) }
            : undefined,
        },
      });
    }
    return cycle;
  });

  await writeAudit({ actorId: me.id, action: "paycycle.open", entityType: "pay_cycle", entityId: created.id, metadata: { year, month, count: active.length, ruleSet: ruleset.name } });
  revalidatePath("/payroll");
  revalidatePath(`/payroll/${created.id}`);
  return { ok: true, message: `Opened ${cycleLabel(year, month)} with ${active.length} staff.` };
}

// ---------------------------------------------------------------------------
// Per-row review: confirm as-is, or adjust (recompute) then confirm.
// ---------------------------------------------------------------------------
async function loadEditableItem(payItemId: string) {
  const item = await prisma.payItem.findUnique({
    where: { id: payItemId },
    include: { payCycle: { select: { id: true, status: true } } },
  });
  if (!item) return { error: "Pay item not found." as const };
  if (item.payCycle.status !== "DRAFT" && item.payCycle.status !== "IN_REVIEW")
    return { error: "This cycle is no longer editable." as const };
  return { item };
}

export async function confirmRowAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const payItemId = String(formData.get("payItemId") ?? "");
  const r = await loadEditableItem(payItemId);
  if ("error" in r) return { ok: false, error: r.error };
  await prisma.payItem.update({
    where: { id: payItemId },
    data: { reviewStatus: "CONFIRMED", confirmedById: me.id, confirmedAt: new Date() },
  });
  await writeAudit({ actorId: me.id, action: "payitem.confirm", entityType: "pay_item", entityId: payItemId, metadata: null });
  revalidatePath(`/payroll/${r.item.payCycle.id}`);
  return { ok: true };
}

export async function reopenRowAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const payItemId = String(formData.get("payItemId") ?? "");
  const r = await loadEditableItem(payItemId);
  if ("error" in r) return { ok: false, error: r.error };
  await prisma.payItem.update({
    where: { id: payItemId },
    data: { reviewStatus: "CARRIED_FORWARD", confirmedById: null, confirmedAt: null },
  });
  await writeAudit({ actorId: me.id, action: "payitem.reopen", entityType: "pay_item", entityId: payItemId, metadata: null });
  revalidatePath(`/payroll/${r.item.payCycle.id}`);
  return { ok: true };
}

const adjustSchema = z.object({
  payItemId: z.string().min(1),
  basicSalary: z.coerce.number().min(0),
  utilityAllowance: z.coerce.number().min(0),
  quarterlyAllowance: z.coerce.number().min(0),
  itfApplicable: z.coerce.boolean(),
  changeNote: z.string().max(500).optional(),
  adjustmentsJson: z.string().optional(),
});

export async function adjustRowAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const parsed = adjustSchema.safeParse({
    payItemId: formData.get("payItemId"),
    basicSalary: formData.get("basicSalary"),
    utilityAllowance: formData.get("utilityAllowance"),
    quarterlyAllowance: formData.get("quarterlyAllowance"),
    itfApplicable: formData.get("itfApplicable") === "on" || formData.get("itfApplicable") === "true",
    changeNote: formData.get("changeNote") ?? undefined,
    adjustmentsJson: formData.get("adjustmentsJson") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Check the figures entered." };
  const d = parsed.data;
  const r = await loadEditableItem(d.payItemId);
  if ("error" in r) return { ok: false, error: r.error };
  const item = r.item;

  let adjustments: Adjustment[] = [];
  if (d.adjustmentsJson) {
    try {
      const raw = JSON.parse(d.adjustmentsJson) as unknown;
      if (Array.isArray(raw)) {
        adjustments = raw
          .map((a) => {
            const o = (a ?? {}) as Record<string, unknown>;
            const amount = num(o.amount);
            return { label: String(o.label ?? "").slice(0, 120), amount, kind: o.kind === "DEDUCTION" ? "DEDUCTION" : "ALLOWANCE" } as Adjustment;
          })
          .filter((a) => a.label && a.amount);
      }
    } catch {
      return { ok: false, error: "Adjustments were not valid." };
    }
  }

  const ruleset = await getActiveTaxRuleSet();
  if (!ruleset) return { ok: false, error: "No active tax rule set." };
  const rules = rulesFrom(ruleset);
  const bd = computePay(
    inputFrom({
      basicSalary: d.basicSalary, utilityAllowance: d.utilityAllowance, quarterlyAllowance: d.quarterlyAllowance,
      taxTreatment: String(item.taxTreatment), flatTaxRate: null, annualRentPaid: null,
      pensionApplicable: true, nhfApplicable: true, itfApplicable: d.itfApplicable,
    }),
    rules,
  );
  // Net reflects adjustments: + allowances, - deductions.
  let addAllow = 0, addDed = 0;
  for (const a of adjustments) { if (a.kind === "DEDUCTION") addDed += a.amount; else addAllow += a.amount; }
  const netPay = round2(bd.monthlyGross + addAllow - bd.pensionEmployee - bd.nhf - bd.itf - bd.paye - addDed);

  // Snapshot prior computed values once (first change), keep existing if already set.
  const existingPrev = item.previousValues ?? undefined;

  await prisma.payItem.update({
    where: { id: d.payItemId },
    data: {
      basicSalary: d.basicSalary, utilityAllowance: d.utilityAllowance, quarterlyAllowance: d.quarterlyAllowance,
      grossPay: bd.monthlyGross, employeePension: bd.pensionEmployee, nhf: bd.nhf, itf: bd.itf,
      taxableIncome: bd.annualTaxableIncome, payeTax: bd.paye, netPay, employerPension: bd.pensionEmployer,
      adjustments: adjustments.length ? (adjustments as unknown as object) : undefined,
      changeNote: d.changeNote?.trim() || null,
      previousValues: (existingPrev ?? undefined) as never,
      reviewStatus: "CONFIRMED", confirmedById: me.id, confirmedAt: new Date(),
    },
  });
  await writeAudit({ actorId: me.id, action: "payitem.adjust", entityType: "pay_item", entityId: d.payItemId, metadata: { basic: d.basicSalary, utility: d.utilityAllowance, quarterly: d.quarterlyAllowance, itf: d.itfApplicable, adjustments: adjustments.length, note: d.changeNote ?? null } });
  revalidatePath(`/payroll/${item.payCycle.id}`);
  return { ok: true, message: "Row updated and confirmed." };
}

// ---------------------------------------------------------------------------
// Submit for approval (operator) -> approve (exec, separate role) -> lock.
// ---------------------------------------------------------------------------
export async function submitForApprovalAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, include: { items: { select: { reviewStatus: true } } } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be submitted for approval." };
  const unconfirmed = cycle.items.filter((i) => i.reviewStatus !== "CONFIRMED").length;
  if (unconfirmed > 0) return { ok: false, error: `${unconfirmed} row(s) still need to be reviewed and confirmed.` };
  await prisma.payCycle.update({ where: { id: cycleId }, data: { status: "IN_REVIEW" } });
  await writeAudit({ actorId: me.id, action: "paycycle.submit", entityType: "pay_cycle", entityId: cycleId, metadata: { rows: cycle.items.length } });
  revalidatePath(`/payroll/${cycleId}`);
  revalidatePath("/payroll");
  return { ok: true, message: "Submitted for executive approval." };
}

export async function approveCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.approve");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, include: { items: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "IN_REVIEW") return { ok: false, error: "Only a cycle in review can be approved." };

  // Snapshot totals from the confirmed rows.
  let totalGross = 0, totalNet = 0, totalEmployer = 0, totalQuarterly = 0, totalThirteenth = 0, totalPayable = 0;
  for (const it of cycle.items) {
    totalGross += num(it.grossPay); totalNet += num(it.netPay); totalEmployer += num(it.employerPension);
    totalQuarterly += num(it.quarterlyAllowance); totalThirteenth += num(it.thirteenthMonth);
    totalPayable += num(it.netPay) + num(it.quarterlyAllowance) + num(it.thirteenthMonth);
  }
  await prisma.payCycle.update({
    where: { id: cycleId },
    data: {
      status: "APPROVED", approvedById: me.id, approvedAt: new Date(), generatedAt: new Date(),
      totalGross: round2(totalGross), totalNet: round2(totalNet), totalEmployerPension: round2(totalEmployer),
      totalQuarterly: round2(totalQuarterly), totalThirteenth: round2(totalThirteenth), totalPayable: round2(totalPayable),
    },
  });
  await writeAudit({ actorId: me.id, action: "paycycle.approve", entityType: "pay_cycle", entityId: cycleId, metadata: { totalNet: round2(totalNet), totalPayable: round2(totalPayable) } });
  revalidatePath(`/payroll/${cycleId}`);
  revalidatePath("/payroll");
  return { ok: true, message: "Approved. The control sheet is ready to export, then lock as evidence." };
}

export async function setCycleThirteenthMonthAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const raw = String(formData.get("on") ?? "");
  const on = raw === "true" || raw === "on" || raw === "1";
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, select: { status: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT" && cycle.status !== "IN_REVIEW") {
    return { ok: false, error: "Only a draft or in-review cycle can be marked as a 13th-month run." };
  }
  // The 13th month equals one month's gross (basic + utility). People Ops marks the cycle
  // per the HR calendar; this sets/clears the additive line for every employee.
  const items = await prisma.payItem.findMany({ where: { payCycleId: cycleId }, select: { id: true, grossPay: true } });
  let totalThirteenth = 0;
  for (const it of items) {
    const amt = on ? num(it.grossPay) : 0;
    totalThirteenth += amt;
    await prisma.payItem.update({ where: { id: it.id }, data: { thirteenthMonth: amt } });
  }
  await prisma.payCycle.update({
    where: { id: cycleId },
    data: { isThirteenthMonth: on, totalThirteenth: round2(totalThirteenth) },
  });
  await writeAudit({ actorId: me.id, action: "paycycle.set_thirteenth", entityType: "pay_cycle", entityId: cycleId, metadata: { on } });
  revalidatePath(`/payroll/${cycleId}`);
  return {
    ok: true,
    message: on
      ? "Marked as the 13th-month run — a thirteenth-month line (one month's gross) was added for every employee."
      : "13th-month run cleared.",
  };
}

export async function lockCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.approve");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, select: { status: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "APPROVED") return { ok: false, error: "Only an approved cycle can be locked." };
  await prisma.payCycle.update({ where: { id: cycleId }, data: { status: "LOCKED", lockedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "paycycle.lock", entityType: "pay_cycle", entityId: cycleId, metadata: null });
  revalidatePath(`/payroll/${cycleId}`);
  revalidatePath("/payroll");
  return { ok: true, message: "Locked as evidence. This cycle is now permanently read-only." };
}

export async function deleteDraftCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("payroll.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, select: { status: true, label: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be discarded." };
  await prisma.payCycle.delete({ where: { id: cycleId } }); // items cascade
  await writeAudit({ actorId: me.id, action: "paycycle.delete", entityType: "pay_cycle", entityId: cycleId, metadata: { label: cycle.label } });
  revalidatePath("/payroll");
  return { ok: true, message: "Draft discarded." };
}

// ── React 19 single-arg form-action wrappers (for <form action={...}> buttons) ──
// useActionState uses the (prev, formData) versions above; these are for plain
// row/footer buttons that don't need inline error state.
export async function confirmRow(formData: FormData): Promise<void> { await confirmRowAction({ ok: true }, formData); }
export async function reopenRow(formData: FormData): Promise<void> { await reopenRowAction({ ok: true }, formData); }
export async function submitForApproval(formData: FormData): Promise<void> { await submitForApprovalAction({ ok: true }, formData); }
export async function approveCycle(formData: FormData): Promise<void> { await approveCycleAction({ ok: true }, formData); }
export async function lockCycle(formData: FormData): Promise<void> { await lockCycleAction({ ok: true }, formData); }
export async function deleteDraftCycle(formData: FormData): Promise<void> { await deleteDraftCycleAction({ ok: true }, formData); }
