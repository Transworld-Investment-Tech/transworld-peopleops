// lib/scorecard-scoring.ts — pure scorecard scoring engine (WS2 slice b).
// Turns an appraisal's rated items into a single weighted-average score, then the bonus
// multiplier, applying the integrity gate. No DB, no IO; unit-tested in
// lib/scorecard-scoring.test.ts (run: npm run scorecard:test).
//
// Three dimensions, weighted by job family (Ops Manual / Handbook):
//   Results = OUTCOME / RESULT items · Competencies = COMPETENCY items · Behaviors = BEHAVIOR items
// Within a dimension: weighted average of rated items (item weight, default 1). A dimension
// with no rated items is dropped and the remaining family weights are renormalized.
// The overall 1–5 maps to a banded multiplier; a rating of 1 on the "Integrity Above All" or
// "Compliance by Default" behavior forces the multiplier to ×0 regardless.

export type Family =
  | "BUSINESS_DEVELOPMENT"
  | "INVESTMENTS"
  | "CONTROL_OPERATIONS"
  | "ADMIN_CORPORATE_SERVICES"
  | "LEADERSHIP";

export const FAMILY_WEIGHTS: Record<Family, { results: number; competencies: number; behaviors: number }> = {
  LEADERSHIP: { results: 0.55, competencies: 0.2, behaviors: 0.25 },
  BUSINESS_DEVELOPMENT: { results: 0.55, competencies: 0.2, behaviors: 0.25 },
  INVESTMENTS: { results: 0.5, competencies: 0.25, behaviors: 0.25 },
  CONTROL_OPERATIONS: { results: 0.5, competencies: 0.25, behaviors: 0.25 },
  ADMIN_CORPORATE_SERVICES: { results: 0.5, competencies: 0.25, behaviors: 0.25 },
};
const DEFAULT_WEIGHTS = { results: 0.5, competencies: 0.25, behaviors: 0.25 };

export function familyWeights(family: string | null | undefined) {
  return (family && (FAMILY_WEIGHTS as Record<string, typeof DEFAULT_WEIGHTS>)[family]) || DEFAULT_WEIGHTS;
}

const RESULT_KINDS = new Set(["OUTCOME", "RESULT"]);
const GATE_BEHAVIORS = new Set(["integrity above all", "compliance by default"]);

export type ScoreItem = {
  kind: string;
  rating: string | number | null | undefined;
  weight?: number | null;
  label?: string | null;
};

/** Parse a 1–5 rating; returns null when unrated or out of range. */
export function parseRating(r: string | number | null | undefined): number | null {
  if (r === null || r === undefined || r === "") return null;
  const n = typeof r === "number" ? r : Number(String(r).trim());
  if (!Number.isFinite(n) || n < 1 || n > 5) return null;
  return n;
}

/** Weighted average of the rated items in a dimension; null if none are rated. */
export function dimensionAverage(items: ScoreItem[]): number | null {
  let sum = 0;
  let wsum = 0;
  for (const it of items) {
    const r = parseRating(it.rating);
    if (r === null) continue;
    const w = it.weight && it.weight > 0 ? it.weight : 1;
    sum += r * w;
    wsum += w;
  }
  if (wsum === 0) return null;
  return Math.round((sum / wsum) * 1000) / 1000;
}

/** Banded multiplier from the overall 1–5 score (Handbook 12.3). */
export function multiplierFor(avg: number): number {
  if (avg >= 4.5) return 1.3;
  if (avg >= 4.0) return 1.15;
  if (avg >= 3.5) return 1.0;
  if (avg >= 3.0) return 0.8;
  if (avg >= 2.0) return 0.5;
  return 0.0;
}

export type ScoreResult = {
  results: number | null;
  competencies: number | null;
  behaviors: number | null;
  overall: number | null;
  multiplier: number;
  integrityGate: boolean;
};

export type DimensionWeights = { results: number; competencies: number; behaviors: number };

/** Score an appraisal's items for an employee in the given family. When
 *  `overrideWeights` is provided (a complete triple from the role's scorecard),
 *  it replaces the family default; renormalization over present dimensions is
 *  unchanged. */
export function scoreAppraisal(
  items: ScoreItem[],
  family: string | null | undefined,
  overrideWeights?: DimensionWeights | null,
): ScoreResult {
  const results = dimensionAverage(items.filter((i) => RESULT_KINDS.has(i.kind)));
  const competencies = dimensionAverage(items.filter((i) => i.kind === "COMPETENCY"));
  const behaviors = dimensionAverage(items.filter((i) => i.kind === "BEHAVIOR"));

  // Integrity gate: a 1 on Integrity Above All or Compliance by Default.
  const integrityGate = items.some(
    (i) =>
      i.kind === "BEHAVIOR" &&
      i.label != null &&
      GATE_BEHAVIORS.has(i.label.trim().toLowerCase()) &&
      parseRating(i.rating) === 1,
  );

  const fw = overrideWeights ?? familyWeights(family);
  const dims = [
    { score: results, w: fw.results },
    { score: competencies, w: fw.competencies },
    { score: behaviors, w: fw.behaviors },
  ].filter((d) => d.score !== null) as { score: number; w: number }[];

  let overall: number | null = null;
  if (dims.length > 0) {
    const totalW = dims.reduce((a, d) => a + d.w, 0);
    overall = Math.round((dims.reduce((a, d) => a + d.score * d.w, 0) / totalW) * 1000) / 1000;
  }

  const multiplier = integrityGate ? 0 : overall === null ? 1.0 : multiplierFor(overall);
  return { results, competencies, behaviors, overall, multiplier, integrityGate };
}
