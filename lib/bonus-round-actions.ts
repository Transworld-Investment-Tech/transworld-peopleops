"use server";
// lib/bonus-round-actions.ts — Bonus model write actions (v0.20.1, WS6 Part 3).
//
// Segregation of duties mirrors payroll: bonus.manage prepares (open / set
// multipliers / confirm / submit / discard); bonus.approve approves + locks (the
// Remuneration Committee, a separate role). Every mutation is gated + audited.
// The portal records and reconciles the award; it never pays — payment is made in
// April via the firm's payroll/payment systems. Cross-entity ids stay bare.
//
// "use server" rule: this module exports only async functions plus the FormState type.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  targetMonthsFor,
  isDeferredGrade,
  monthlySalaryFor,
  computeTargetBonus,
  computeCalculatedBonus,
  poolScalingFactor,
  applyScaling,
  immediateDeferredSplit,
  trancheSplit,
  trancheSchedule,
  round2,
  type SalaryBasis,
} from "@/lib/bonus";

export type FormState = { ok: boolean; error?: string; message?: string };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}
function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Open a round: snapshot eligible employees into bonus_awards at a default ×1.0.
// ---------------------------------------------------------------------------
const openSchema = z.object({
  awardYear: z.coerce.number().int().min(2020).max(2100),
  pbt: z.coerce.number().min(0),
  poolRate: z.coerce.number().min(0).max(1),
  salaryBasis: z.enum(["BASIC", "GROSS"]),
  appraisalCycleId: z.string().optional(),
});

export async function openRoundAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const parsed = openSchema.safeParse({
    awardYear: formData.get("awardYear"),
    pbt: formData.get("pbt"),
    poolRate: formData.get("poolRate"),
    salaryBasis: formData.get("salaryBasis"),
    appraisalCycleId: formData.get("appraisalCycleId") || undefined,
  });
  if (!parsed.success) return { ok: false, error: "Check the award year, PBT and pool rate." };
  const { awardYear, pbt, poolRate, salaryBasis, appraisalCycleId } = parsed.data;

  const open = await prisma.bonusRound.findFirst({ where: { status: { not: "LOCKED" } }, select: { label: true } });
  if (open) return { ok: false, error: `A bonus round is already open (${open.label}). Lock or finish it first.` };

  const existing = await prisma.bonusRound.findUnique({ where: { awardYear }, select: { id: true } });
  if (existing) return { ok: false, error: `A round for FY${awardYear} already exists.` };

  const profiles = await prisma.compensationProfile.findMany({
    where: { isCurrent: true },
    select: {
      basicSalary: true,
      utilityAllowance: true,
      employee: {
        select: {
          id: true, status: true, eeId: true, fullName: true, preferredName: true,
          jobProfile: { select: { grade: true } },
        },
      },
    },
  });
  const eligible = profiles.filter((p) => p.employee.status !== "EXITED" && !!p.employee.jobProfile?.grade);
  if (eligible.length === 0) return { ok: false, error: "No eligible employees (active, with a current compensation profile and a graded job profile)." };

  // Appraisal ratings (reference only) for the chosen cycle, if given.
  let ratingByEmp = new Map<string, string | null>();
  if (appraisalCycleId) {
    const appr = await prisma.appraisal.findMany({
      where: { cycleId: appraisalCycleId },
      select: { employeeId: true, overallRating: true },
    });
    ratingByEmp = new Map(appr.map((a) => [a.employeeId, a.overallRating ?? null] as const));
  }

  const basis = salaryBasis as SalaryBasis;
  const poolAmount = round2(pbt * poolRate);

  const created = await prisma.$transaction(async (tx) => {
    const round = await tx.bonusRound.create({
      data: {
        awardYear,
        label: `FY${awardYear} Bonus`,
        status: "DRAFT",
        pbt,
        poolRate,
        poolAmount,
        salaryBasis: basis,
        scalingFactor: 1,
        paymentMonth: 4,
        paymentYear: awardYear + 1,
        appraisalCycleId: appraisalCycleId ?? null,
      },
      select: { id: true },
    });
    for (const p of eligible) {
      const grade = p.employee.jobProfile!.grade as string;
      const monthlySalary = monthlySalaryFor(basis, num(p.basicSalary), num(p.utilityAllowance));
      const targetMonths = targetMonthsFor(grade);
      const targetBonus = computeTargetBonus(targetMonths, monthlySalary);
      const calculatedBonus = computeCalculatedBonus(targetBonus, 1.0, false);
      await tx.bonusAward.create({
        data: {
          bonusRoundId: round.id,
          employeeId: p.employee.id,
          eeId: p.employee.eeId,
          employeeName: personName(p.employee),
          grade,
          targetMonths,
          monthlySalary,
          targetBonus,
          multiplier: 1.0,
          integrityGate: false,
          appraisalRating: ratingByEmp.get(p.employee.id) ?? null,
          calculatedBonus,
          awardedBonus: 0,
          deferred: isDeferredGrade(grade),
          immediateAmount: 0,
          deferredAmount: 0,
          reviewStatus: "PENDING",
        },
      });
    }
    return round;
  });

  await writeAudit({ actorId: me.id, action: "bonusround.open", entityType: "bonus_round", entityId: created.id, metadata: { awardYear, pbt, poolRate, poolAmount, basis, count: eligible.length } });
  revalidatePath("/bonus");
  revalidatePath(`/bonus/${created.id}`);
  return { ok: true, message: `Opened FY${awardYear} with ${eligible.length} staff. Pool: ₦${poolAmount.toLocaleString("en-US")}.` };
}

// ---------------------------------------------------------------------------
// Edit the round inputs (PBT / pool rate) while editable -> recompute the pool.
// ---------------------------------------------------------------------------
const inputsSchema = z.object({
  roundId: z.string().min(1),
  pbt: z.coerce.number().min(0),
  poolRate: z.coerce.number().min(0).max(1),
});

export async function setRoundInputsAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const parsed = inputsSchema.safeParse({ roundId: formData.get("roundId"), pbt: formData.get("pbt"), poolRate: formData.get("poolRate") });
  if (!parsed.success) return { ok: false, error: "Enter a valid PBT and pool rate." };
  const { roundId, pbt, poolRate } = parsed.data;
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, select: { status: true } });
  if (!round) return { ok: false, error: "Round not found." };
  if (round.status !== "DRAFT" && round.status !== "IN_REVIEW") return { ok: false, error: "This round is no longer editable." };
  const poolAmount = round2(pbt * poolRate);
  await prisma.bonusRound.update({ where: { id: roundId }, data: { pbt, poolRate, poolAmount } });
  await writeAudit({ actorId: me.id, action: "bonusround.inputs", entityType: "bonus_round", entityId: roundId, metadata: { pbt, poolRate, poolAmount } });
  revalidatePath(`/bonus/${roundId}`);
  return { ok: true, message: `Pool updated to ₦${poolAmount.toLocaleString("en-US")}.` };
}

// ---------------------------------------------------------------------------
// Per-row review: set the multiplier + integrity gate (and confirm).
// ---------------------------------------------------------------------------
async function loadEditableAward(awardId: string) {
  const award = await prisma.bonusAward.findUnique({
    where: { id: awardId },
    include: { bonusRound: { select: { id: true, status: true } } },
  });
  if (!award) return { error: "Award not found." as const };
  if (award.bonusRound.status !== "DRAFT" && award.bonusRound.status !== "IN_REVIEW")
    return { error: "This round is no longer editable." as const };
  return { award };
}

const multiplierSchema = z.object({
  awardId: z.string().min(1),
  multiplier: z.coerce.number().min(0).max(1.3),
  integrityGate: z.coerce.boolean(),
  note: z.string().max(500).optional(),
});

export async function setMultiplierAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const parsed = multiplierSchema.safeParse({
    awardId: formData.get("awardId"),
    multiplier: formData.get("multiplier"),
    integrityGate: formData.get("integrityGate") === "on" || formData.get("integrityGate") === "true",
    note: formData.get("note") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Multiplier must be between 0 and 1.3." };
  const d = parsed.data;
  const r = await loadEditableAward(d.awardId);
  if ("error" in r) return { ok: false, error: r.error };
  const targetBonus = num(r.award.targetBonus);
  const calculatedBonus = computeCalculatedBonus(targetBonus, d.multiplier, d.integrityGate);
  await prisma.bonusAward.update({
    where: { id: d.awardId },
    data: {
      multiplier: d.multiplier,
      integrityGate: d.integrityGate,
      calculatedBonus,
      reviewStatus: "CONFIRMED",
      confirmedById: me.id,
      confirmedAt: new Date(),
      note: d.note?.trim() || null,
    },
  });
  await writeAudit({ actorId: me.id, action: "bonusaward.set", entityType: "bonus_award", entityId: d.awardId, metadata: { multiplier: d.multiplier, integrityGate: d.integrityGate, calculatedBonus, note: d.note ?? null } });
  revalidatePath(`/bonus/${r.award.bonusRound.id}`);
  return { ok: true, message: "Award updated and confirmed." };
}

export async function confirmRowAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const awardId = String(formData.get("awardId") ?? "");
  const r = await loadEditableAward(awardId);
  if ("error" in r) return { ok: false, error: r.error };
  await prisma.bonusAward.update({ where: { id: awardId }, data: { reviewStatus: "CONFIRMED", confirmedById: me.id, confirmedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "bonusaward.confirm", entityType: "bonus_award", entityId: awardId, metadata: null });
  revalidatePath(`/bonus/${r.award.bonusRound.id}`);
  return { ok: true };
}

export async function reopenRowAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const awardId = String(formData.get("awardId") ?? "");
  const r = await loadEditableAward(awardId);
  if ("error" in r) return { ok: false, error: r.error };
  await prisma.bonusAward.update({ where: { id: awardId }, data: { reviewStatus: "PENDING", confirmedById: null, confirmedAt: null } });
  await writeAudit({ actorId: me.id, action: "bonusaward.reopen", entityType: "bonus_award", entityId: awardId, metadata: null });
  revalidatePath(`/bonus/${r.award.bonusRound.id}`);
  return { ok: true };
}

// ---------------------------------------------------------------------------
// Submit -> approve (reconcile + generate tranches) -> lock.
// ---------------------------------------------------------------------------
export async function submitForApprovalAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const roundId = String(formData.get("roundId") ?? "");
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, include: { awards: { select: { reviewStatus: true } } } });
  if (!round) return { ok: false, error: "Round not found." };
  if (round.status !== "DRAFT") return { ok: false, error: "Only a draft round can be submitted." };
  const unconfirmed = round.awards.filter((a) => a.reviewStatus !== "CONFIRMED").length;
  if (unconfirmed > 0) return { ok: false, error: `${unconfirmed} award(s) still need to be reviewed and confirmed.` };
  await prisma.bonusRound.update({ where: { id: roundId }, data: { status: "IN_REVIEW" } });
  await writeAudit({ actorId: me.id, action: "bonusround.submit", entityType: "bonus_round", entityId: roundId, metadata: { awards: round.awards.length } });
  revalidatePath(`/bonus/${roundId}`);
  revalidatePath("/bonus");
  return { ok: true, message: "Submitted for Remuneration Committee approval." };
}

export async function approveRoundAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.approve");
  const roundId = String(formData.get("roundId") ?? "");
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, include: { awards: true } });
  if (!round) return { ok: false, error: "Round not found." };
  if (round.status !== "IN_REVIEW") return { ok: false, error: "Only a round in review can be approved." };

  const poolAmount = num(round.poolAmount);
  const totalCalculated = round2(round.awards.reduce((s, a) => s + num(a.calculatedBonus), 0));
  const factor = poolScalingFactor(totalCalculated, poolAmount);

  let totalAwarded = 0;
  await prisma.$transaction(async (tx) => {
    // Regenerate tranches cleanly (idempotent if re-approved from IN_REVIEW).
    await tx.bonusTranche.deleteMany({ where: { bonusRoundId: roundId } });
    for (const a of round.awards) {
      const awarded = applyScaling(num(a.calculatedBonus), factor);
      const split = immediateDeferredSplit(awarded, a.deferred);
      totalAwarded += awarded;
      await tx.bonusAward.update({
        where: { id: a.id },
        data: { awardedBonus: awarded, immediateAmount: split.immediate, deferredAmount: split.deferred },
      });
      const tranches = trancheSplit(awarded, a.deferred);
      for (const t of tranches) {
        const sched = trancheSchedule(round.awardYear, t.sequence);
        await tx.bonusTranche.create({
          data: {
            bonusAwardId: a.id,
            bonusRoundId: roundId,
            employeeId: a.employeeId,
            sequence: t.sequence,
            label: t.label,
            amount: t.amount,
            scheduledMonth: sched.month,
            scheduledYear: sched.year,
            status: "SCHEDULED",
          },
        });
      }
    }
    await tx.bonusRound.update({
      where: { id: roundId },
      data: {
        status: "APPROVED",
        approvedById: me.id,
        approvedAt: new Date(),
        scalingFactor: factor,
        totalCalculated: round2(totalCalculated),
        totalAwarded: round2(totalAwarded),
      },
    });
  });

  await writeAudit({ actorId: me.id, action: "bonusround.approve", entityType: "bonus_round", entityId: roundId, metadata: { totalCalculated: round2(totalCalculated), totalAwarded: round2(totalAwarded), scalingFactor: factor, withinPool: totalCalculated <= poolAmount } });
  revalidatePath(`/bonus/${roundId}`);
  revalidatePath("/bonus");
  return { ok: true, message: factor < 1 ? `Approved. Awards scaled to ${(factor * 100).toFixed(1)}% to fit the pool.` : "Approved. Awards fit within the pool." };
}

export async function lockRoundAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.approve");
  const roundId = String(formData.get("roundId") ?? "");
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, select: { status: true } });
  if (!round) return { ok: false, error: "Round not found." };
  if (round.status !== "APPROVED") return { ok: false, error: "Only an approved round can be locked." };
  await prisma.bonusRound.update({ where: { id: roundId }, data: { status: "LOCKED", lockedAt: new Date() } });
  await writeAudit({ actorId: me.id, action: "bonusround.lock", entityType: "bonus_round", entityId: roundId, metadata: null });
  revalidatePath(`/bonus/${roundId}`);
  revalidatePath("/bonus");
  return { ok: true, message: "Locked as evidence. This round is now permanently read-only." };
}

export async function deleteDraftRoundAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const roundId = String(formData.get("roundId") ?? "");
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, select: { status: true, label: true } });
  if (!round) return { ok: false, error: "Round not found." };
  if (round.status !== "DRAFT") return { ok: false, error: "Only a draft round can be discarded." };
  await prisma.bonusRound.delete({ where: { id: roundId } }); // awards + tranches cascade
  await writeAudit({ actorId: me.id, action: "bonusround.delete", entityType: "bonus_round", entityId: roundId, metadata: { label: round.label } });
  revalidatePath("/bonus");
  return { ok: true, message: "Draft discarded." };
}

// ── single-arg form-action wrappers (for <form action={...}> buttons) ──
export async function confirmRow(formData: FormData): Promise<void> { await confirmRowAction({ ok: true }, formData); }
export async function reopenRow(formData: FormData): Promise<void> { await reopenRowAction({ ok: true }, formData); }
export async function submitForApproval(formData: FormData): Promise<void> { await submitForApprovalAction({ ok: true }, formData); }
export async function approveRound(formData: FormData): Promise<void> { await approveRoundAction({ ok: true }, formData); }
export async function lockRound(formData: FormData): Promise<void> { await lockRoundAction({ ok: true }, formData); }
export async function deleteDraftRound(formData: FormData): Promise<void> { await deleteDraftRoundAction({ ok: true }, formData); }
