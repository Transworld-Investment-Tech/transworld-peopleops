"use server";
// lib/bonus-deferrals-actions.ts — Bonus model Phase B write actions (v0.21.0, WS6 Part 3).
//
// The cross-year deferral ledger. Segregation mirrors the rest of the bonus
// module: FINANCE (bonus.manage) records that a due tranche was PAID in April;
// EXEC = Remuneration Committee / Board (bonus.approve) handles the discretionary
// calls — clawback (partial or full), bad-leaver forfeiture, and Board-discretion
// reinstatement. Every action is gated, validated, and audited, and also writes a
// structured bonus_tranche_events row so the ledger keeps a full history.
//
// The portal NEVER pays — these are review-and-confirm records of decisions made
// in HumanManager / Remita. Only tranche status / paidAt transitions post-lock;
// the round's sealed financial snapshot (awarded totals, scaling) is never touched.
//
// "use server" rule: this module exports only async functions plus the FormState type.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { clawbackTotal, trancheNet, statusAfterClawback, clampClawback, round2 } from "@/lib/bonus-ledger";

export type FormState = { ok: boolean; error?: string; message?: string };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}

function revalidateLedger() {
  revalidatePath("/bonus/deferrals");
  revalidatePath("/bonus");
  revalidatePath("/my-bonus");
}

// A tranche plus the context needed to act on it. Any action requires its round
// to be LOCKED — the ledger only operates on sealed evidence.
async function loadTranche(trancheId: string) {
  const t = await prisma.bonusTranche.findUnique({
    where: { id: trancheId },
    select: {
      id: true,
      bonusAwardId: true,
      bonusRoundId: true,
      employeeId: true,
      amount: true,
      status: true,
      bonusAward: { select: { bonusRound: { select: { status: true } } } },
    },
  });
  if (!t) return { error: "Tranche not found." as const };
  if (t.bonusAward.bonusRound.status !== "LOCKED")
    return { error: "Only tranches from a locked round can be settled." as const };
  return { t };
}

async function clawedSoFar(trancheId: string): Promise<number> {
  const events = await prisma.bonusTrancheEvent.findMany({
    where: { bonusTrancheId: trancheId, eventType: "CLAWBACK" },
    select: { eventType: true, amount: true },
  });
  return clawbackTotal(events.map((e) => ({ eventType: e.eventType, amount: num(e.amount) })));
}

// ---------------------------------------------------------------------------
// Mark paid — a due (SCHEDULED) tranche becomes PAID (FINANCE / bonus.manage).
// ---------------------------------------------------------------------------
const markPaidSchema = z.object({ trancheId: z.string().min(1) });

export async function markPaidAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const parsed = markPaidSchema.safeParse({ trancheId: formData.get("trancheId") });
  if (!parsed.success) return { ok: false, error: "Missing tranche." };
  const r = await loadTranche(parsed.data.trancheId);
  if ("error" in r) return { ok: false, error: r.error };
  if (r.t.status !== "SCHEDULED") return { ok: false, error: "Only a scheduled tranche can be marked paid." };

  const clawed = await clawedSoFar(r.t.id);
  const net = trancheNet(num(r.t.amount), "SCHEDULED", clawed);
  await prisma.$transaction(async (tx) => {
    await tx.bonusTranche.update({ where: { id: r.t.id }, data: { status: "PAID", paidAt: new Date() } });
    await tx.bonusTrancheEvent.create({
      data: {
        bonusTrancheId: r.t.id,
        bonusAwardId: r.t.bonusAwardId,
        bonusRoundId: r.t.bonusRoundId,
        employeeId: r.t.employeeId,
        eventType: "PAID",
        amount: net,
        actorId: me.id,
      },
    });
  });
  await writeAudit({ actorId: me.id, action: "bonustranche.paid", entityType: "bonus_tranche", entityId: r.t.id, metadata: { amount: net } });
  revalidateLedger();
  return { ok: true, message: "Marked paid." };
}

// ---------------------------------------------------------------------------
// Settle all due in a given April (FINANCE / bonus.manage) — bulk mark-paid.
// ---------------------------------------------------------------------------
const settleSchema = z.object({ year: z.coerce.number().int().min(2020).max(2100) });

export async function settleYearAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.manage");
  const parsed = settleSchema.safeParse({ year: formData.get("year") });
  if (!parsed.success) return { ok: false, error: "Missing year." };
  const year = parsed.data.year;

  const due = await prisma.bonusTranche.findMany({
    where: { status: "SCHEDULED", scheduledYear: year, bonusAward: { bonusRound: { status: "LOCKED" } } },
    select: { id: true, bonusAwardId: true, bonusRoundId: true, employeeId: true, amount: true },
  });
  if (due.length === 0) return { ok: false, error: `Nothing due in April ${year}.` };

  const ids = due.map((d) => d.id);
  const events = await prisma.bonusTrancheEvent.findMany({
    where: { bonusTrancheId: { in: ids }, eventType: "CLAWBACK" },
    select: { bonusTrancheId: true, eventType: true, amount: true },
  });
  const clawedBy = new Map<string, number>();
  for (const e of events) clawedBy.set(e.bonusTrancheId, round2((clawedBy.get(e.bonusTrancheId) ?? 0) + num(e.amount)));

  let total = 0;
  await prisma.$transaction(async (tx) => {
    const now = new Date();
    for (const d of due) {
      const net = trancheNet(num(d.amount), "SCHEDULED", clawedBy.get(d.id) ?? 0);
      total += net;
      await tx.bonusTranche.update({ where: { id: d.id }, data: { status: "PAID", paidAt: now } });
      await tx.bonusTrancheEvent.create({
        data: {
          bonusTrancheId: d.id,
          bonusAwardId: d.bonusAwardId,
          bonusRoundId: d.bonusRoundId,
          employeeId: d.employeeId,
          eventType: "PAID",
          amount: net,
          actorId: me.id,
        },
      });
    }
  });
  await writeAudit({ actorId: me.id, action: "bonustranche.settle_year", entityType: "bonus_round", entityId: String(year), metadata: { year, count: due.length, total: round2(total) } });
  revalidateLedger();
  return { ok: true, message: `Settled ${due.length} tranche${due.length === 1 ? "" : "s"} due in April ${year}.` };
}

// ---------------------------------------------------------------------------
// Clawback — reduce a SCHEDULED tranche or reclaim a PAID one, partial or full
// (EXEC = RemCo / Board, bonus.approve).
// ---------------------------------------------------------------------------
const clawbackSchema = z.object({
  trancheId: z.string().min(1),
  amount: z.coerce.number().positive(),
  reason: z.string().max(500).optional(),
  boardOverride: z.coerce.boolean(),
});

export async function clawbackAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.approve");
  const parsed = clawbackSchema.safeParse({
    trancheId: formData.get("trancheId"),
    amount: formData.get("amount"),
    reason: formData.get("reason") ?? undefined,
    boardOverride: formData.get("boardOverride") === "on" || formData.get("boardOverride") === "true",
  });
  if (!parsed.success) return { ok: false, error: "Enter a clawback amount greater than 0." };
  const d = parsed.data;
  const r = await loadTranche(d.trancheId);
  if ("error" in r) return { ok: false, error: r.error };
  if (r.t.status !== "SCHEDULED" && r.t.status !== "PAID")
    return { ok: false, error: "Only a scheduled or paid tranche can be clawed back." };

  const prior = await clawedSoFar(r.t.id);
  const amount = num(r.t.amount);
  const net = trancheNet(amount, r.t.status, prior);
  const reclaim = clampClawback(d.amount, net);
  if (reclaim <= 0) return { ok: false, error: "Nothing left to claw back on this tranche." };

  const next = statusAfterClawback(amount, prior, reclaim, r.t.status);
  await prisma.$transaction(async (tx) => {
    await tx.bonusTranche.update({ where: { id: r.t.id }, data: { status: next.status } });
    await tx.bonusTrancheEvent.create({
      data: {
        bonusTrancheId: r.t.id,
        bonusAwardId: r.t.bonusAwardId,
        bonusRoundId: r.t.bonusRoundId,
        employeeId: r.t.employeeId,
        eventType: "CLAWBACK",
        amount: reclaim,
        boardOverride: d.boardOverride,
        reason: d.reason?.trim() || null,
        actorId: me.id,
      },
    });
  });
  await writeAudit({ actorId: me.id, action: "bonustranche.clawback", entityType: "bonus_tranche", entityId: r.t.id, metadata: { amount: reclaim, resultingStatus: next.status, boardOverride: d.boardOverride, reason: d.reason ?? null } });
  revalidateLedger();
  const full = next.status === "CLAWED_BACK";
  return { ok: true, message: full ? "Tranche fully clawed back." : `Clawed back ₦${reclaim.toLocaleString("en-US")}.` };
}

// ---------------------------------------------------------------------------
// Leaver treatment (EXEC = RemCo / Board, bonus.approve).
//   GOOD leaver: unpaid tranches stay on schedule — recorded, no status change.
//   BAD  leaver: unpaid (SCHEDULED) tranches are FORFEITED. Clawback survives
//                (already-paid / clawed tranches are never touched).
// ---------------------------------------------------------------------------
const leaverSchema = z.object({
  employeeId: z.string().min(1),
  classification: z.enum(["GOOD", "BAD"]),
  reason: z.string().max(500).optional(),
});

export async function forfeitLeaverAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.approve");
  const parsed = leaverSchema.safeParse({
    employeeId: formData.get("employeeId"),
    classification: formData.get("classification"),
    reason: formData.get("reason") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Choose good or bad leaver." };
  const d = parsed.data;

  const scheduled = await prisma.bonusTranche.findMany({
    where: { employeeId: d.employeeId, status: "SCHEDULED", bonusAward: { bonusRound: { status: "LOCKED" } } },
    select: { id: true, bonusAwardId: true, bonusRoundId: true, employeeId: true, amount: true },
  });

  if (d.classification === "GOOD") {
    await writeAudit({ actorId: me.id, action: "bonusleaver.good", entityType: "employee", entityId: d.employeeId, metadata: { unpaidTranches: scheduled.length, reason: d.reason ?? null } });
    revalidateLedger();
    return { ok: true, message: `Recorded as a good leaver — ${scheduled.length} unpaid tranche${scheduled.length === 1 ? "" : "s"} stay on schedule.` };
  }

  if (scheduled.length === 0) {
    await writeAudit({ actorId: me.id, action: "bonusleaver.bad", entityType: "employee", entityId: d.employeeId, metadata: { forfeited: 0, reason: d.reason ?? null } });
    revalidateLedger();
    return { ok: true, message: "Recorded as a bad leaver — no unpaid tranches to forfeit." };
  }

  const ids = scheduled.map((s) => s.id);
  const events = await prisma.bonusTrancheEvent.findMany({
    where: { bonusTrancheId: { in: ids }, eventType: "CLAWBACK" },
    select: { bonusTrancheId: true, eventType: true, amount: true },
  });
  const clawedBy = new Map<string, number>();
  for (const e of events) clawedBy.set(e.bonusTrancheId, round2((clawedBy.get(e.bonusTrancheId) ?? 0) + num(e.amount)));

  let forfeited = 0;
  await prisma.$transaction(async (tx) => {
    for (const s of scheduled) {
      const net = trancheNet(num(s.amount), "SCHEDULED", clawedBy.get(s.id) ?? 0);
      forfeited += net;
      await tx.bonusTranche.update({ where: { id: s.id }, data: { status: "FORFEITED" } });
      await tx.bonusTrancheEvent.create({
        data: {
          bonusTrancheId: s.id,
          bonusAwardId: s.bonusAwardId,
          bonusRoundId: s.bonusRoundId,
          employeeId: s.employeeId,
          eventType: "FORFEIT",
          amount: net,
          reason: d.reason?.trim() || null,
          actorId: me.id,
        },
      });
    }
  });
  await writeAudit({ actorId: me.id, action: "bonusleaver.bad", entityType: "employee", entityId: d.employeeId, metadata: { forfeited: round2(forfeited), count: scheduled.length, reason: d.reason ?? null } });
  revalidateLedger();
  return { ok: true, message: `Bad leaver — forfeited ${scheduled.length} unpaid tranche${scheduled.length === 1 ? "" : "s"} (₦${round2(forfeited).toLocaleString("en-US")}).` };
}

// ---------------------------------------------------------------------------
// Reinstate — Board-discretion override of a forfeiture (FORFEITED -> SCHEDULED).
// (EXEC = RemCo / Board, bonus.approve.)
// ---------------------------------------------------------------------------
const reinstateSchema = z.object({
  trancheId: z.string().min(1),
  reason: z.string().max(500).optional(),
});

export async function reinstateAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("bonus.approve");
  const parsed = reinstateSchema.safeParse({
    trancheId: formData.get("trancheId"),
    reason: formData.get("reason") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Missing tranche." };
  const r = await loadTranche(parsed.data.trancheId);
  if ("error" in r) return { ok: false, error: r.error };
  if (r.t.status !== "FORFEITED") return { ok: false, error: "Only a forfeited tranche can be reinstated." };

  await prisma.$transaction(async (tx) => {
    await tx.bonusTranche.update({ where: { id: r.t.id }, data: { status: "SCHEDULED" } });
    await tx.bonusTrancheEvent.create({
      data: {
        bonusTrancheId: r.t.id,
        bonusAwardId: r.t.bonusAwardId,
        bonusRoundId: r.t.bonusRoundId,
        employeeId: r.t.employeeId,
        eventType: "REINSTATE",
        amount: num(r.t.amount),
        boardOverride: true,
        reason: parsed.data.reason?.trim() || null,
        actorId: me.id,
      },
    });
  });
  await writeAudit({ actorId: me.id, action: "bonustranche.reinstate", entityType: "bonus_tranche", entityId: r.t.id, metadata: { boardOverride: true, reason: parsed.data.reason ?? null } });
  revalidateLedger();
  return { ok: true, message: "Reinstated to schedule (Board discretion)." };
}

// ── single-arg form-action wrappers (for <form action={...}> buttons) ──
export async function markPaid(formData: FormData): Promise<void> { await markPaidAction({ ok: true }, formData); }
export async function settleYear(formData: FormData): Promise<void> { await settleYearAction({ ok: true }, formData); }
