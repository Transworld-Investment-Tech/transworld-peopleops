// lib/raise.ts — pure raise engine (WS6 Part 2). No DB, no IO; unit-tested in
// lib/raise.test.ts (run: npm run raise:test).
//
// A raise at Transworld is FIRM-WIDE and UNIFORM, not performance-linked: a single
// percentage applied across every band when the Board confirms a revenue milestone
// is met. That uniformity is what keeps it control-function-safe — no individual's
// pay is tied to revenue they personally produce.
//
// The headline is ANNUAL TOTAL COMPENSATION. Per the offer letters, that is the sum
// of basic over twelve months plus all allowances paid over the year. How it is
// split between basic and allowance, and whether an allowance is paid monthly or
// quarterly, is structuring for tax efficiency — not the substance. So a raise lifts
// every stored component by the same percentage; the annual total therefore rises by
// exactly that percentage and the tax-efficient structure is preserved untouched.
//
// Firm pay pattern (see lib/payroll-cycle.ts isQuarterMonth = Jan/Apr/Jul/Oct):
// in the four quarter months the quarterly lump is paid and the monthly utility line
// is suppressed; the other eight months pay monthly utility. So over a year:
//   annual total = basic × 12 + utility × 8 + quarterly × 4
// The portal never pays anyone — HumanManager + Remita stay authoritative. A raise
// here only updates the standing compensation inputs the control room reads, so the
// next payroll cycle picks up the new figures.

export const RAISE_PCT_MIN = 0;
export const RAISE_PCT_MAX = 1; // 100% — a sanity ceiling, not an expected value

// Months per year each component is actually paid, under the firm pattern above.
export const BASIC_MONTHS_PER_YEAR = 12;
export const UTILITY_MONTHS_PER_YEAR = 8; // 12 − 4 quarter months
export const QUARTERLY_PAYMENTS_PER_YEAR = 4;

export type BandFlag = "WITHIN" | "ABOVE_MID" | "ABOVE_MAX" | "BELOW_MIN";

export type CompComponents = {
  basic: number;
  utility: number;
  quarterly: number;
};

export type Band = {
  min: number;
  midpoint: number;
  max: number;
};

export function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

/** Clamp a raise fraction into [0, 1]. Non-finite -> 0. */
export function clampPercent(p: number): number {
  if (!Number.isFinite(p)) return 0;
  return Math.min(RAISE_PCT_MAX, Math.max(RAISE_PCT_MIN, p));
}

/** Lift a single component by the raise fraction, to the kobo. */
export function raiseAmount(amount: number, pct: number): number {
  const p = clampPercent(pct);
  return round2(amount * (1 + p));
}

/** Monthly gross = basic + utility (the firm's compa-ratio / band basis;
 * the quarterly allowance is paid separately and is not part of monthly gross). */
export function monthlyGross(basic: number, utility: number): number {
  return round2(basic + utility);
}

/** Annual total compensation under the firm pay pattern (the headline figure). */
export function annualTotal(basic: number, utility: number, quarterly: number): number {
  return round2(
    basic * BASIC_MONTHS_PER_YEAR +
      utility * UTILITY_MONTHS_PER_YEAR +
      quarterly * QUARTERLY_PAYMENTS_PER_YEAR,
  );
}

/** Apply the cycle's percentage uniformly to every component. The structure
 * (each component's share) is preserved because all three scale by the same factor,
 * so the annual total rises by exactly the percentage. */
export function raiseComponents(old: CompComponents, pct: number): CompComponents {
  return {
    basic: raiseAmount(old.basic, pct),
    utility: raiseAmount(old.utility, pct),
    quarterly: raiseAmount(old.quarterly, pct),
  };
}

/** Where a (post-raise) monthly gross sits against the grade band. With no band
 * defined for the grade, there is nothing to flag (WITHIN). Bands are stored on the
 * monthly-gross basis, matching the existing compa-ratio definition. */
export function bandFlagFor(grossMonthly: number, band: Band | null): BandFlag {
  if (!band) return "WITHIN";
  if (grossMonthly < band.min) return "BELOW_MIN";
  if (grossMonthly > band.max) return "ABOVE_MAX";
  if (grossMonthly > band.midpoint) return "ABOVE_MID";
  return "WITHIN";
}

/** Compa-ratio = monthly gross ÷ grade midpoint (null when no midpoint). */
export function compaRatio(grossMonthly: number, midpoint: number | null | undefined): number | null {
  if (!midpoint || midpoint <= 0) return null;
  return Math.round((grossMonthly / midpoint) * 1000) / 1000;
}

/** Optional per-item cap: hold an employee at their band maximum (monthly gross),
 * scaling all three components by the same factor so the structure is preserved.
 * Returns the (possibly) capped components and whether the cap actually bit. If the
 * post-raise gross is already within max, the cap is a no-op. */
export function capToMax(
  components: CompComponents,
  bandMax: number | null,
): { components: CompComponents; capApplied: boolean } {
  if (bandMax === null || bandMax <= 0) return { components, capApplied: false };
  const gross = components.basic + components.utility;
  if (gross <= bandMax) return { components, capApplied: false };
  const factor = bandMax / gross;
  return {
    components: {
      basic: round2(components.basic * factor),
      utility: round2(components.utility * factor),
      quarterly: round2(components.quarterly * factor),
    },
    capApplied: true,
  };
}

/** Gap from an observed revenue figure to the milestone target (>= 0; 0 once met). */
export function gapToTarget(target: number, observed: number): number {
  return round2(Math.max(0, target - observed));
}

/** Fraction of the milestone reached by an observed figure (clamped 0..1). */
export function progressToTarget(target: number, observed: number): number {
  if (target <= 0) return 1;
  return Math.min(1, Math.max(0, observed / target));
}
