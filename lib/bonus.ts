// lib/bonus.ts — pure bonus engine (WS6 Part 3). No DB, no IO; unit-tested in
// lib/bonus.test.ts (run: npm run bonus:test). The annual bonus is a share of
// profit, distributed by grade and scaled by performance, paid in April once the
// prior year's audited result is published.
//
//   Individual bonus = target months (by grade) × monthly salary × multiplier
//
// "monthly salary" follows the offer-letter definition: annual salary (base +
// allowances) ÷ 12. In comp-profile terms that is basicSalary + utilityAllowance
// (both stored monthly), EXCLUDING the separately-paid quarterly allowance — i.e.
// the GROSS basis. The basis is a per-round setting; the engine itself just takes
// the monthly figure. The multiplier (×0–×1.3) is the calibrated year-end score;
// a serious integrity/compliance breach forces it to ×0.

// Target bonus by grade, in months of salary (WS6 Part 3).
export const BONUS_TARGET_MONTHS: Record<string, number> = {
  G0: 0.25,
  G1: 0.5,
  G2: 0.75,
  G3: 0.75,
  G4: 1.0,
  G5: 1.25,
};

export const MULTIPLIER_MIN = 0;
export const MULTIPLIER_MAX = 1.3;

// Senior grades defer part of the award, with the deferred portion subject to
// clawback. 65% immediate; the remaining 35% is split 75% / 25% over the next two
// Aprils — i.e. 26.25% and 8.75% of the total.
export const DEFERRED_GRADES = new Set(["G4", "G5"]);
export const DEFERRAL_IMMEDIATE = 0.65;
export const DEFERRAL_Y1 = 0.2625; // 0.35 × 0.75
export const DEFERRAL_Y2 = 0.0875; // 0.35 × 0.25

export type SalaryBasis = "BASIC" | "GROSS";

export function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

function gradeKey(grade: string | null | undefined): string {
  return (grade ?? "").toUpperCase().trim();
}

export function targetMonthsFor(grade: string | null | undefined): number {
  return BONUS_TARGET_MONTHS[gradeKey(grade)] ?? 0;
}

export function isDeferredGrade(grade: string | null | undefined): boolean {
  return DEFERRED_GRADES.has(gradeKey(grade));
}

/** Monthly salary for the bonus formula, from a comp-profile snapshot. GROSS =
 * basic + utility (the offer-letter "annual base + allowances" ÷ 12); BASIC =
 * basic only. The quarterly allowance is paid separately and never included. */
export function monthlySalaryFor(
  basis: SalaryBasis,
  basicSalary: number,
  utilityAllowance: number,
): number {
  return basis === "GROSS"
    ? round2(basicSalary + utilityAllowance)
    : round2(basicSalary);
}

export function clampMultiplier(m: number): number {
  if (!Number.isFinite(m)) return 0;
  return Math.min(MULTIPLIER_MAX, Math.max(MULTIPLIER_MIN, m));
}

/** Effective multiplier — the integrity/compliance gate forces ×0 (no bonus,
 * regardless of results). Otherwise the multiplier is clamped to [0, 1.3]. */
export function effectiveMultiplier(multiplier: number, integrityGate: boolean): number {
  if (integrityGate) return 0;
  return clampMultiplier(multiplier);
}

export function computeTargetBonus(targetMonths: number, monthlySalary: number): number {
  return round2(targetMonths * monthlySalary);
}

export function computeCalculatedBonus(
  targetBonus: number,
  multiplier: number,
  integrityGate: boolean,
): number {
  return round2(targetBonus * effectiveMultiplier(multiplier, integrityGate));
}

/** Pool reconciliation. The pool (15% of PBT) and the sum of calculated bonuses
 * must reconcile: if the sum is within the pool, awards pay as calculated
 * (factor 1); if it exceeds the pool, every award scales proportionately so the
 * firm pays only what profit supports. */
export function poolScalingFactor(totalCalculated: number, pool: number): number {
  if (totalCalculated <= 0) return 1;
  if (pool <= 0) return 0;
  if (totalCalculated <= pool) return 1;
  return pool / totalCalculated;
}

export function applyScaling(calculatedBonus: number, scalingFactor: number): number {
  return round2(calculatedBonus * scalingFactor);
}

export type TrancheSplit = {
  sequence: number;
  label: string;
  fraction: number;
  amount: number;
};

/** Split an awarded amount into payment tranches. Senior (G4/G5) awards defer;
 * everyone else is a single immediate tranche. The final tranche absorbs any
 * rounding residual so the tranches always sum to the awarded amount. */
export function trancheSplit(awarded: number, deferred: boolean): TrancheSplit[] {
  const a = round2(awarded);
  if (!deferred) {
    return [{ sequence: 0, label: "Immediate (100%)", fraction: 1, amount: a }];
  }
  const t0 = round2(a * DEFERRAL_IMMEDIATE);
  const t1 = round2(a * DEFERRAL_Y1);
  const t2 = round2(a - t0 - t1); // residual to the final tranche
  return [
    { sequence: 0, label: "Immediate (65%)", fraction: DEFERRAL_IMMEDIATE, amount: t0 },
    { sequence: 1, label: "Deferred +1yr (26.25%)", fraction: DEFERRAL_Y1, amount: t1 },
    { sequence: 2, label: "Deferred +2yr (8.75%)", fraction: DEFERRAL_Y2, amount: t2 },
  ];
}

/** The immediate vs deferred split recorded on the award (deferred = sum of the
 * +1yr and +2yr tranches). */
export function immediateDeferredSplit(
  awarded: number,
  deferred: boolean,
): { immediate: number; deferred: number } {
  if (!deferred) return { immediate: round2(awarded), deferred: 0 };
  const immediate = round2(awarded * DEFERRAL_IMMEDIATE);
  return { immediate, deferred: round2(awarded - immediate) };
}

/** Scheduled (month, year) for a tranche: April of awardYear+1 (immediate), then
 * the following two Aprils for the deferred tranches. */
export function trancheSchedule(awardYear: number, sequence: number): { month: number; year: number } {
  return { month: 4, year: awardYear + 1 + sequence };
}
