// lib/bonus-ledger.ts — Phase B deferral-ledger pure helpers (v0.21.0, WS6 Part 3).
//
// No DB and no prisma import — pure functions, unit-tested by lib/bonus-ledger.test.ts
// (npm run bonus-ledger:test). The deferral ledger acts on the tranches a LOCKED
// round already recorded: it marks them paid, reclaims them (partial or full),
// forfeits a bad leaver's unpaid tranches, and reinstates under Board discretion.
// These helpers carry the arithmetic so the read layer and actions stay thin.

export type TrancheStatus = "SCHEDULED" | "PAID" | "CLAWED_BACK" | "FORFEITED";
export type EventType = "PAID" | "CLAWBACK" | "FORFEIT" | "REINSTATE";

export function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

/** Total reclaimed against a tranche = sum of CLAWBACK event amounts. */
export function clawbackTotal(events: { eventType: string; amount: number }[]): number {
  return round2(
    events
      .filter((e) => e.eventType === "CLAWBACK")
      .reduce((s, e) => s + (Number(e.amount) || 0), 0),
  );
}

/** Net value of a tranche after status + clawbacks. A FORFEITED or fully
 *  CLAWED_BACK tranche is worth 0; otherwise it is the original amount less any
 *  partial clawbacks, never below 0. */
export function trancheNet(amount: number, status: string, clawed: number): number {
  if (status === "FORFEITED" || status === "CLAWED_BACK") return 0;
  return round2(Math.max(0, amount - clawed));
}

/** Resulting status after applying a clawback of `newClawback`. Once cumulative
 *  clawback reaches the full amount the tranche becomes CLAWED_BACK; a partial
 *  clawback leaves a SCHEDULED / PAID tranche in place (its net simply drops). */
export function statusAfterClawback(
  amount: number,
  priorClawed: number,
  newClawback: number,
  currentStatus: string,
): { status: string; clawed: number } {
  const clawed = round2(priorClawed + newClawback);
  if (clawed >= round2(amount) - 0.0001) return { status: "CLAWED_BACK", clawed: round2(amount) };
  return { status: currentStatus, clawed };
}

/** A tranche is "due" in a given April once it is still SCHEDULED for that year. */
export function isDueInYear(
  t: { status: string; scheduledYear: number },
  year: number,
): boolean {
  return t.status === "SCHEDULED" && t.scheduledYear === year;
}

/** Clamp a requested clawback to the available net (>0, <= net). */
export function clampClawback(requested: number, net: number): number {
  if (!Number.isFinite(requested) || requested <= 0) return 0;
  return round2(Math.min(requested, net));
}
