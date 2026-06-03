"use server";
// lib/raise-cycle-actions.ts — Raise mechanism write actions (WS6 Part 2, v0.22.0).
//
// Segregation of duties mirrors payroll/bonus and honors Ops Manual F4: People Ops
// prepares the recommendation (compensation.manage); the Remuneration Committee
// approves it (compensation.approve) — and approval is what applies the new figures
// to each compensation profile. No self-approval: the approver must be someone other
// than the person who prepared/submitted the cycle, enforced here on the server.
// Every mutation is gated + audited. The portal never pays — it updates the standing
// compensation inputs the control room reads; HumanManager + Remita stay
// authoritative. Cross-entity ids (employee, users, applied profile) stay bare.
//
// "use server" rule: this module exports only async functions plus the FormState type.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  raiseComponents,
  annualTotal,
  monthlyGross,
  bandFlagFor,
  capToMax,
  fullyLoaded,
  rawMaxForFte,
  round2,
  type Band,
  type CompComponents,
} from "@/lib/raise";

export type FormState = { ok: boolean; error?: string; message?: string };

// ---------------------------------------------------------------------------
// Parsing helpers (mirror lib/compensation-actions.ts)
// ---------------------------------------------------------------------------
function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}
function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function parseDate(v?: string | null): Date | null {
  const s = (v ?? "").trim();
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
function parseMoney(v?: string | null): number | null {
  const s = (v ?? "").replace(/[₦,\s]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? n : null;
}
/** Whole-number percent string -> fraction, 4dp (fits Decimal(6,4)). "5" -> 0.05. */
function parsePercentToFraction(v?: string | null): number | null {
  const s = (v ?? "").replace(/[%\s,]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  if (!Number.isFinite(n)) return null;
  return Math.round((n / 100) * 10000) / 10000;
}
function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Materialize raise_items for every active employee with a current profile.
// Snapshots old components, computes new (raised by pct), evaluates band flag.
// Carries forward per-employee flags (included / excludeReason / cap / note) when a
// previous set of items is supplied (used by recompute/refresh).
// ---------------------------------------------------------------------------
type CarriedFlags = { included: boolean; excludeReason: string | null; capApplied: boolean; note: string | null };

async function buildItems(
  pct: number,
  carry?: Map<string, CarriedFlags>,
): Promise<
  | { ok: true; items: Array<Record<string, unknown>> }
  | { ok: false; error: string }
> {
  const [profiles, bands] = await Promise.all([
    prisma.compensationProfile.findMany({
      where: { isCurrent: true },
      select: {
        basicSalary: true,
        utilityAllowance: true,
        quarterlyAllowance: true,
        employee: {
          select: {
            id: true, status: true, eeId: true, fullName: true, preferredName: true, fte: true,
            jobProfile: { select: { grade: true } },
          },
        },
      },
    }),
    prisma.salaryBand.findMany({ select: { grade: true, minAmount: true, midpoint: true, maxAmount: true } }),
  ]);

  const eligible = profiles.filter((p) => p.employee.status !== "EXITED");
  if (eligible.length === 0) {
    return { ok: false, error: "No eligible employees (active, with a current compensation profile)." };
  }

  const bandByGrade = new Map<string, Band>();
  for (const b of bands) {
    bandByGrade.set(b.grade.toUpperCase().trim(), {
      min: num(b.minAmount), midpoint: num(b.midpoint), max: num(b.maxAmount),
    });
  }

  const items = eligible.map((p) => {
    const e = p.employee;
    const grade = e.jobProfile?.grade ?? null;
    const fte = e.fte != null ? num(e.fte) : 1;
    const band = grade ? bandByGrade.get(grade.toUpperCase().trim()) ?? null : null;
    const old: CompComponents = {
      basic: num(p.basicSalary),
      utility: num(p.utilityAllowance),
      quarterly: num(p.quarterlyAllowance),
    };
    const flags = carry?.get(e.id) ?? { included: true, excludeReason: null, capApplied: false, note: null };

    let next = raiseComponents(old, pct);
    let capApplied = false;
    if (flags.capApplied) {
      const capped = capToMax(next, rawMaxForFte(band ? band.max : null, fte));
      next = capped.components;
      capApplied = capped.capApplied;
    }

    const oldAnnual = annualTotal(old.basic, old.utility, old.quarterly);
    const newAnnual = annualTotal(next.basic, next.utility, next.quarterly);
    const newGross = monthlyGross(next.basic, next.utility);

    return {
      employeeId: e.id,
      eeId: e.eeId,
      employeeName: personName(e),
      grade,
      oldBasic: old.basic,
      oldUtility: old.utility,
      oldQuarterly: old.quarterly,
      oldAnnualTotal: oldAnnual,
      newBasic: next.basic,
      newUtility: next.utility,
      newQuarterly: next.quarterly,
      newAnnualTotal: newAnnual,
      annualIncrease: round2(newAnnual - oldAnnual),
      bandMin: band ? band.min : null,
      bandMid: band ? band.midpoint : null,
      bandMax: band ? band.max : null,
      bandFlag: bandFlagFor(fullyLoaded(newGross, fte), band),
      included: flags.included,
      excludeReason: flags.excludeReason,
      capApplied,
      note: flags.note,
    };
  });

  return { ok: true, items };
}

// ---------------------------------------------------------------------------
// Open a raise cycle: define the milestone + percentage and carry every active
// employee into raise_items at that percentage. One non-LOCKED cycle at a time.
// ---------------------------------------------------------------------------
const openSchema = z.object({
  milestoneLabel: z.string().trim().min(1, "Name the milestone"),
  revenueTarget: z.number().min(0),
  raisePercent: z.number().min(0).max(1),
  effectiveDate: z.date(),
});

export async function openCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const parsed = openSchema.safeParse({
    milestoneLabel: nz(String(formData.get("milestoneLabel") ?? "")) ?? "",
    revenueTarget: parseMoney(String(formData.get("revenueTarget") ?? "")) ?? NaN,
    raisePercent: parsePercentToFraction(String(formData.get("raisePercent") ?? "")) ?? NaN,
    effectiveDate: parseDate(String(formData.get("effectiveDate") ?? "")) ?? new Date(NaN),
  });
  if (!parsed.success) return { ok: false, error: "Check the milestone, revenue target, percentage and effective date." };
  const { milestoneLabel, revenueTarget, raisePercent, effectiveDate } = parsed.data;
  if (raisePercent <= 0) return { ok: false, error: "Enter a raise percentage greater than zero." };

  const open = await prisma.raiseCycle.findFirst({ where: { status: { not: "LOCKED" } }, select: { label: true } });
  if (open) return { ok: false, error: `A raise cycle is already open (${open.label}). Lock or discard it before opening another.` };

  const revenueObserved = parseMoney(String(formData.get("revenueObserved") ?? ""));
  const built = await buildItems(raisePercent);
  if (!built.ok) return { ok: false, error: built.error };

  const pctLabel = `${round2(raisePercent * 100)}%`;
  const created = await prisma.$transaction(async (tx) => {
    const cycle = await tx.raiseCycle.create({
      data: {
        label: `${pctLabel} raise — ${milestoneLabel}`,
        status: "DRAFT",
        milestoneLabel,
        revenueTarget,
        raisePercent,
        revenueObserved: revenueObserved,
        effectiveDate,
        preparedById: me.id,
      },
      select: { id: true },
    });
    for (const it of built.items) {
      await tx.raiseItem.create({ data: { raiseCycleId: cycle.id, ...(it as object) } as never });
    }
    return cycle;
  });

  await writeAudit({
    actorId: me.id,
    action: "raisecycle.open",
    entityType: "raise_cycle",
    entityId: created.id,
    metadata: { milestoneLabel, revenueTarget, raisePercent, count: built.items.length },
  });
  revalidatePath("/compensation/raises");
  redirect(`/compensation/raises/${created.id}`);
}

// ---------------------------------------------------------------------------
// Edit the cycle inputs while editable. Changing the percentage recomputes every
// item's new figures from its stored old snapshot.
// ---------------------------------------------------------------------------
const inputsSchema = z.object({
  cycleId: z.string().min(1),
  milestoneLabel: z.string().trim().min(1),
  revenueTarget: z.number().min(0),
  raisePercent: z.number().min(0).max(1),
  effectiveDate: z.date(),
});

export async function setCycleInputsAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const parsed = inputsSchema.safeParse({
    cycleId: String(formData.get("cycleId") ?? ""),
    milestoneLabel: nz(String(formData.get("milestoneLabel") ?? "")) ?? "",
    revenueTarget: parseMoney(String(formData.get("revenueTarget") ?? "")) ?? NaN,
    raisePercent: parsePercentToFraction(String(formData.get("raisePercent") ?? "")) ?? NaN,
    effectiveDate: parseDate(String(formData.get("effectiveDate") ?? "")) ?? new Date(NaN),
  });
  if (!parsed.success) return { ok: false, error: "Check the milestone, target, percentage and effective date." };
  const d = parsed.data;
  if (d.raisePercent <= 0) return { ok: false, error: "Enter a raise percentage greater than zero." };

  const cycle = await prisma.raiseCycle.findUnique({ where: { id: d.cycleId }, select: { status: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle's inputs can be edited." };

  const revenueObserved = parseMoney(String(formData.get("revenueObserved") ?? ""));
  const revenueConfirmed = parseMoney(String(formData.get("revenueConfirmed") ?? ""));
  const confirmedNote = nz(String(formData.get("confirmedNote") ?? ""));

  const pctLabel = `${round2(d.raisePercent * 100)}%`;
  await prisma.$transaction(async (tx) => {
    await tx.raiseCycle.update({
      where: { id: d.cycleId },
      data: {
        label: `${pctLabel} raise — ${d.milestoneLabel}`,
        milestoneLabel: d.milestoneLabel,
        revenueTarget: d.revenueTarget,
        raisePercent: d.raisePercent,
        effectiveDate: d.effectiveDate,
        revenueObserved,
        revenueConfirmed,
        confirmedNote,
      },
    });
    // Recompute each item's new figures from its existing old snapshot at the new pct.
    const items = await tx.raiseItem.findMany({ where: { raiseCycleId: d.cycleId } });
    const fteEmps = await tx.employee.findMany({
      where: { id: { in: items.map((i) => i.employeeId) } },
      select: { id: true, fte: true },
    });
    const fteByEmp = new Map(fteEmps.map((e) => [e.id, e.fte != null ? num(e.fte) : 1] as const));
    for (const it of items) {
      const fte = fteByEmp.get(it.employeeId) ?? 1;
      const old: CompComponents = { basic: num(it.oldBasic), utility: num(it.oldUtility), quarterly: num(it.oldQuarterly) };
      let next = raiseComponents(old, d.raisePercent);
      let capApplied = false;
      if (it.capApplied) {
        const capped = capToMax(next, rawMaxForFte(it.bandMax === null ? null : num(it.bandMax), fte));
        next = capped.components;
        capApplied = capped.capApplied;
      }
      const newAnnual = annualTotal(next.basic, next.utility, next.quarterly);
      await tx.raiseItem.update({
        where: { id: it.id },
        data: {
          newBasic: next.basic,
          newUtility: next.utility,
          newQuarterly: next.quarterly,
          newAnnualTotal: newAnnual,
          annualIncrease: round2(newAnnual - num(it.oldAnnualTotal)),
          capApplied,
          bandFlag: bandFlagFor(fullyLoaded(monthlyGross(next.basic, next.utility), fte), it.bandMin === null ? null : {
            min: num(it.bandMin), midpoint: num(it.bandMid), max: num(it.bandMax),
          }),
        },
      });
    }
  });

  await writeAudit({
    actorId: me.id, action: "raisecycle.inputs", entityType: "raise_cycle", entityId: d.cycleId,
    metadata: { raisePercent: d.raisePercent, revenueTarget: d.revenueTarget, revenueObserved, revenueConfirmed },
  });
  revalidatePath(`/compensation/raises/${d.cycleId}`);
  return { ok: true, message: "Cycle updated." };
}

// ---------------------------------------------------------------------------
// Refresh items from CURRENT compensation profiles (re-snapshot old + recompute new),
// preserving per-employee include/exclude/cap/note. Use if profiles changed.
// ---------------------------------------------------------------------------
export async function recomputeItemsAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.raiseCycle.findUnique({ where: { id: cycleId }, select: { status: true, raisePercent: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be refreshed." };

  const existing = await prisma.raiseItem.findMany({ where: { raiseCycleId: cycleId } });
  const carry = new Map<string, CarriedFlags>(
    existing.map((it) => [it.employeeId, {
      included: it.included, excludeReason: it.excludeReason ?? null, capApplied: it.capApplied, note: it.note ?? null,
    }]),
  );
  const built = await buildItems(num(cycle.raisePercent), carry);
  if (!built.ok) return { ok: false, error: built.error };

  await prisma.$transaction(async (tx) => {
    await tx.raiseItem.deleteMany({ where: { raiseCycleId: cycleId } });
    for (const it of built.items) {
      await tx.raiseItem.create({ data: { raiseCycleId: cycleId, ...(it as object) } as never });
    }
  });

  await writeAudit({ actorId: me.id, action: "raisecycle.recompute", entityType: "raise_cycle", entityId: cycleId, metadata: { count: built.items.length } });
  revalidatePath(`/compensation/raises/${cycleId}`);
  return { ok: true, message: "Refreshed from current compensation profiles." };
}

// ---------------------------------------------------------------------------
// Per-item review: include/exclude, cap to band max, note.
// ---------------------------------------------------------------------------
const itemSchema = z.object({
  itemId: z.string().min(1),
  included: z.boolean(),
  cap: z.boolean(),
  excludeReason: z.string().max(300).optional(),
  note: z.string().max(500).optional(),
});

export async function setItemAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const parsed = itemSchema.safeParse({
    itemId: String(formData.get("itemId") ?? ""),
    included: formData.get("included") === "on" || formData.get("included") === "true",
    cap: formData.get("cap") === "on" || formData.get("cap") === "true",
    excludeReason: formData.get("excludeReason") ?? undefined,
    note: formData.get("note") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Could not save the row." };
  const d = parsed.data;

  const item = await prisma.raiseItem.findUnique({
    where: { id: d.itemId },
    include: { raiseCycle: { select: { id: true, status: true, raisePercent: true } } },
  });
  if (!item) return { ok: false, error: "Row not found." };
  if (item.raiseCycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be edited." };

  const fteEmp = await prisma.employee.findUnique({ where: { id: item.employeeId }, select: { fte: true } });
  const fte = fteEmp?.fte != null ? num(fteEmp.fte) : 1;
  const old: CompComponents = { basic: num(item.oldBasic), utility: num(item.oldUtility), quarterly: num(item.oldQuarterly) };
  let next = raiseComponents(old, num(item.raiseCycle.raisePercent));
  let capApplied = false;
  if (d.cap) {
    const capped = capToMax(next, rawMaxForFte(item.bandMax === null ? null : num(item.bandMax), fte));
    next = capped.components;
    capApplied = capped.capApplied;
  }
  const newAnnual = annualTotal(next.basic, next.utility, next.quarterly);

  await prisma.raiseItem.update({
    where: { id: d.itemId },
    data: {
      included: d.included,
      excludeReason: d.included ? null : (d.excludeReason?.trim() || null),
      capApplied,
      note: d.note?.trim() || null,
      newBasic: next.basic,
      newUtility: next.utility,
      newQuarterly: next.quarterly,
      newAnnualTotal: newAnnual,
      annualIncrease: round2(newAnnual - num(item.oldAnnualTotal)),
      bandFlag: bandFlagFor(fullyLoaded(monthlyGross(next.basic, next.utility), fte), item.bandMin === null ? null : {
        min: num(item.bandMin), midpoint: num(item.bandMid), max: num(item.bandMax),
      }),
    },
  });

  await writeAudit({ actorId: me.id, action: "raiseitem.set", entityType: "raise_item", entityId: d.itemId, metadata: { included: d.included, cap: capApplied } });
  revalidatePath(`/compensation/raises/${item.raiseCycle.id}`);
  return { ok: true, message: "Row updated." };
}

// ---------------------------------------------------------------------------
// Submit for approval (DRAFT -> IN_REVIEW). Requires the milestone to be confirmed
// hit (a confirmed revenue figure) and at least one included employee.
// ---------------------------------------------------------------------------
export async function submitForApprovalAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.raiseCycle.findUnique({
    where: { id: cycleId },
    include: { items: { select: { included: true } } },
  });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be submitted." };
  if (cycle.revenueConfirmed === null) return { ok: false, error: "Enter the CFO-confirmed revenue figure (the milestone must be confirmed hit) before submitting." };
  const included = cycle.items.filter((i) => i.included).length;
  if (included === 0) return { ok: false, error: "At least one employee must be included." };

  await prisma.raiseCycle.update({
    where: { id: cycleId },
    data: { status: "IN_REVIEW", submittedById: me.id, submittedAt: new Date() },
  });
  await writeAudit({ actorId: me.id, action: "raisecycle.submit", entityType: "raise_cycle", entityId: cycleId, metadata: { included } });
  revalidatePath(`/compensation/raises/${cycleId}`);
  revalidatePath("/compensation/raises");
  return { ok: true, message: "Submitted for COO review and Remuneration Committee approval." };
}

// ---------------------------------------------------------------------------
// Approve (IN_REVIEW -> APPROVED) — the Remuneration Committee sign-off, which
// applies the new figures to each included employee's compensation profile.
// No self-approval: approver must differ from the preparer/submitter.
// ---------------------------------------------------------------------------
export async function approveCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.approve");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.raiseCycle.findUnique({ where: { id: cycleId }, include: { items: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "IN_REVIEW") return { ok: false, error: "Only a cycle in review can be approved." };

  if (me.id === cycle.submittedById || me.id === cycle.preparedById) {
    return {
      ok: false,
      error: "Segregation of duties: a raise must be approved by someone other than the person who prepared and submitted it. Sign in as a Remuneration Committee / Executive approver.",
    };
  }

  const included = cycle.items.filter((i) => i.included);
  if (included.length === 0) return { ok: false, error: "Nothing to approve — no included employees." };

  let totalAnnualIncrease = 0;
  let totalNewAnnual = 0;
  let appliedCount = 0;

  await prisma.$transaction(async (tx) => {
    for (const it of included) {
      const current = await tx.compensationProfile.findFirst({
        where: { employeeId: it.employeeId, isCurrent: true },
        select: {
          id: true, taxTreatment: true, flatTaxRate: true, annualRentPaid: true,
          pensionApplicable: true, nhfApplicable: true,
        },
      });
      if (!current) continue; // no current profile to version — skip safely

      await tx.compensationProfile.updateMany({
        where: { employeeId: it.employeeId, isCurrent: true },
        data: { isCurrent: false },
      });
      const created = await tx.compensationProfile.create({
        data: {
          employeeId: it.employeeId,
          effectiveDate: cycle.effectiveDate,
          basicSalary: num(it.newBasic),
          utilityAllowance: num(it.newUtility),
          quarterlyAllowance: num(it.newQuarterly),
          // Carry the tax-efficiency structure forward unchanged — a raise only
          // moves the pay amounts.
          taxTreatment: current.taxTreatment,
          flatTaxRate: current.flatTaxRate,
          annualRentPaid: current.annualRentPaid,
          pensionApplicable: current.pensionApplicable,
          nhfApplicable: current.nhfApplicable,
          isCurrent: true,
        },
        select: { id: true },
      });
      await tx.raiseItem.update({ where: { id: it.id }, data: { appliedProfileId: created.id } });
      totalAnnualIncrease += num(it.annualIncrease);
      totalNewAnnual += num(it.newAnnualTotal);
      appliedCount++;
    }

    await tx.raiseCycle.update({
      where: { id: cycleId },
      data: {
        status: "APPROVED",
        approvedById: me.id,
        approvedAt: new Date(),
        appliedAt: new Date(),
        totalEmployees: appliedCount,
        totalAnnualIncrease: round2(totalAnnualIncrease),
        totalNewAnnual: round2(totalNewAnnual),
      },
    });
  });

  await writeAudit({
    actorId: me.id,
    action: "raisecycle.approve",
    entityType: "raise_cycle",
    entityId: cycleId,
    metadata: {
      applied: appliedCount,
      raisePercent: num(cycle.raisePercent),
      totalAnnualIncrease: round2(totalAnnualIncrease),
      effectiveDate: cycle.effectiveDate,
      preparedById: cycle.preparedById,
      submittedById: cycle.submittedById,
    },
  });
  revalidatePath(`/compensation/raises/${cycleId}`);
  revalidatePath("/compensation/raises");
  revalidatePath("/compensation");
  return { ok: true, message: `Approved and applied to ${appliedCount} compensation profile(s), effective ${cycle.effectiveDate.toLocaleDateString("en-US")}.` };
}

// ---------------------------------------------------------------------------
// Lock (APPROVED -> LOCKED) — seal the cycle as permanent read-only evidence.
// ---------------------------------------------------------------------------
export async function lockCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.approve");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.raiseCycle.findUnique({ where: { id: cycleId }, select: { status: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "APPROVED") return { ok: false, error: "Only an approved cycle can be locked." };
  await prisma.raiseCycle.update({ where: { id: cycleId }, data: { status: "LOCKED", lockedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "raisecycle.lock", entityType: "raise_cycle", entityId: cycleId, metadata: null });
  revalidatePath(`/compensation/raises/${cycleId}`);
  revalidatePath("/compensation/raises");
  return { ok: true, message: "Locked as evidence. This raise cycle is now permanently read-only." };
}

// ---------------------------------------------------------------------------
// Discard a draft cycle (DRAFT only). Items cascade.
// ---------------------------------------------------------------------------
export async function deleteDraftCycleAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const cycleId = String(formData.get("cycleId") ?? "");
  const cycle = await prisma.raiseCycle.findUnique({ where: { id: cycleId }, select: { status: true, label: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (cycle.status !== "DRAFT") return { ok: false, error: "Only a draft cycle can be discarded." };
  await prisma.raiseCycle.delete({ where: { id: cycleId } }); // items cascade
  await writeAudit({ actorId: me.id, action: "raisecycle.delete", entityType: "raise_cycle", entityId: cycleId, metadata: { label: cycle.label } });
  revalidatePath("/compensation/raises");
  redirect("/compensation/raises");
}

// ── single-arg form-action wrappers (for <form action={...}> buttons) ──
export async function submitForApproval(formData: FormData): Promise<void> { await submitForApprovalAction({ ok: true }, formData); }
export async function approveCycle(formData: FormData): Promise<void> { await approveCycleAction({ ok: true }, formData); }
export async function lockCycle(formData: FormData): Promise<void> { await lockCycleAction({ ok: true }, formData); }
export async function deleteDraftCycle(formData: FormData): Promise<void> { await deleteDraftCycleAction({ ok: true }, formData); }
export async function recomputeItems(formData: FormData): Promise<void> { await recomputeItemsAction({ ok: true }, formData); }
