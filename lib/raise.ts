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

// Legacy per-component payment counts from the old 12-month reading. Retained only for
// reference; annualTotal now uses the canonical 17-month gross basis (see below).
export const BASIC_MONTHS_PER_YEAR = 12;
export const UTILITY_MONTHS_PER_YEAR = 8; // 12 − 4 quarter months (legacy)
export const QUARTERLY_PAYMENTS_PER_YEAR = 4;
// Canonical: 12 monthly + 4 quarterly + 1 thirteenth, each = one month's gross.
export const MONTHS_PER_YEAR_TOTAL = 17;

// Fully-loaded conversion (Ops Manual B1.2/B1.3). The firm pays ~17 months of monthly
// gross per year (12 monthly + 4 quarterly + 1 thirteenth), so the fully-loaded
// monthly-equivalent of a monthly gross is gross × 17 ÷ 12. Salary bands are stored on
// this fully-loaded basis, so every band / compa-ratio comparison must convert gross to
// fully-loaded first — and divide a part-timer by their FTE to normalize to a full-time
// rate — before comparing. See fullyLoaded() and rawMaxForFte() below.
export const FULLY_LOADED_FACTOR = 17 / 12;

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

/** Annual total compensation = monthly gross × 17 (Ops Manual / Handbook canonical pay
 * structure: 12 monthly + 4 quarterly + 1 thirteenth, each equal to one month's gross =
 * basic + utility). The stored quarterly component is vestigial and is NOT used here; the
 * third argument is accepted for call-site compatibility but ignored. */
export function annualTotal(basic: number, utility: number, _quarterly = 0): number {
  return round2((basic + utility) * MONTHS_PER_YEAR_TOTAL);
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

/** Fully-loaded, FTE-normalized monthly-equivalent of a monthly gross (Ops Manual B1.3):
 * gross × (17/12) ÷ FTE. A non-positive/!finite FTE is treated as 1.0 (full time). This
 * is the value compared against the (fully-loaded) salary bands and midpoints. */
export function fullyLoaded(grossMonthly: number, fte: number = 1): number {
  const f = Number.isFinite(fte) && fte > 0 ? fte : 1;
  return round2((grossMonthly * FULLY_LOADED_FACTOR) / f);
}

/** Inverse of fullyLoaded for the band maximum: the raw monthly-gross figure whose
 * fully-loaded FTE-normalized value equals a (fully-loaded) band max. Feeding this to
 * capToMax caps raw gross at the point the fully-loaded rate hits the band max —
 * identical to capping the fully-loaded value, but returning the raw components the
 * payroll control room stores. Null when there is no band max. */
export function rawMaxForFte(bandMax: number | null, fte: number = 1): number | null {
  if (bandMax === null || bandMax <= 0) return null;
  const f = Number.isFinite(fte) && fte > 0 ? fte : 1;
  return round2((bandMax / FULLY_LOADED_FACTOR) * f);
}

/** Where a monthly gross sits against the grade band. With no band defined for the grade,
 * there is nothing to flag (WITHIN). Bands are stored on the fully-loaded basis, so the
 * caller passes the fully-loaded FTE-normalized value (see fullyLoaded). */
export function bandFlagFor(grossMonthly: number, band: Band | null): BandFlag {
  if (!band) return "WITHIN";
  if (grossMonthly < band.min) return "BELOW_MIN";
  if (grossMonthly > band.max) return "ABOVE_MAX";
  if (grossMonthly > band.midpoint) return "ABOVE_MID";
  return "WITHIN";
}

/** Compa-ratio = fully-loaded gross ÷ grade midpoint (null when no midpoint). The caller
 * passes the fully-loaded FTE-normalized gross (see fullyLoaded); the midpoint is the
 * fully-loaded band midpoint, so numerator and denominator share one basis. */
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
