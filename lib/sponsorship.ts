// lib/sponsorship.ts — pure qualification-sponsorship engine (WS6 Part 4, v0.24.0).
// No DB, no IO; unit-tested in lib/sponsorship.test.ts (run: npm run sponsorship:test).
// DB reads live in lib/sponsorship-reads.ts; write actions in lib/sponsorship-actions.ts.
//
// The firm's headline benefit: Transworld sponsors the professional qualifications that
// define the craft — CIS (Chartered Institute of Stockbrokers), CFA, ICAN/ACCA, and
// other role-relevant certifications. Sponsorship covers the costs that matter
// (registration, tuition, exam fees) on agreed terms. A modest service commitment (a
// "bond") may attach to significant sponsorships: a reasonable period of continued
// employment, with pro-rated repayment if the person leaves early. (WS6 Part 4.)
//
// There is no stored "exposure" figure: outstanding repayment exposure decays daily, so
// it is derived live from the cost lines and the bonding window — the same discipline as
// compa-ratio / band-position (WS6 Part 1). Crystallized repayment on an early exit is a
// separate, stored concern handled at offboarding (WS4); those columns exist but are not
// driven here.

// ---------------------------------------------------------------------------
// Vocabularies (CHECK-constrained text in the DB; no Postgres enums)
// ---------------------------------------------------------------------------
export const SPONSORSHIP_STATUSES = [
  "PROPOSED",
  "APPROVED",
  "IN_PROGRESS",
  "COMPLETED",
  "WITHDRAWN",
] as const;
export type SponsorshipStatus = (typeof SPONSORSHIP_STATUSES)[number];

export const COST_TYPES = [
  "REGISTRATION",
  "TUITION",
  "EXAM_FEE",
  "MATERIALS",
  "MEMBERSHIP",
  "OTHER",
] as const;
export type CostType = (typeof COST_TYPES)[number];

export const ATTEMPT_OUTCOMES = [
  "SCHEDULED",
  "PASSED",
  "FAILED",
  "DEFERRED",
  "WITHDRAWN",
] as const;
export type AttemptOutcome = (typeof ATTEMPT_OUTCOMES)[number];

export const BONDING_BASES = ["ON_APPROVAL", "ON_COMPLETION"] as const;
export type BondingBasis = (typeof BONDING_BASES)[number];

export const REPAYMENT_STATUSES = [
  "NOT_APPLICABLE",
  "PENDING",
  "WAIVED",
  "REPAYING",
  "SETTLED",
] as const;
export type RepaymentStatus = (typeof REPAYMENT_STATUSES)[number];

// ---------------------------------------------------------------------------
// Display helpers (pure)
// ---------------------------------------------------------------------------
export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
}

export function sponsorshipStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PROPOSED":
      return { cls: "b-gry", label: "Proposed" };
    case "APPROVED":
      return { cls: "b-blu", label: "Approved" };
    case "IN_PROGRESS":
      return { cls: "b-amb", label: "In progress" };
    case "COMPLETED":
      return { cls: "b-grn", label: "Completed" };
    case "WITHDRAWN":
      return { cls: "b-red", label: "Withdrawn" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export function attemptOutcomeBadge(o: string): { cls: string; label: string } {
  switch (o) {
    case "SCHEDULED":
      return { cls: "b-gry", label: "Scheduled" };
    case "PASSED":
      return { cls: "b-grn", label: "Passed" };
    case "FAILED":
      return { cls: "b-red", label: "Failed" };
    case "DEFERRED":
      return { cls: "b-amb", label: "Deferred" };
    case "WITHDRAWN":
      return { cls: "b-gry", label: "Withdrawn" };
    default:
      return { cls: "b-gry", label: o };
  }
}

export function costTypeLabel(t: string): string {
  switch (t) {
    case "REGISTRATION":
      return "Registration";
    case "TUITION":
      return "Tuition";
    case "EXAM_FEE":
      return "Exam fee";
    case "MATERIALS":
      return "Materials";
    case "MEMBERSHIP":
      return "Membership";
    case "OTHER":
      return "Other";
    default:
      return t;
  }
}

export function bondingBasisLabel(b: string): string {
  return b === "ON_COMPLETION" ? "on completion" : "on approval";
}

// ---------------------------------------------------------------------------
// PURE exposure / bonding engine — unit-tested in lib/sponsorship.test.ts
// ---------------------------------------------------------------------------
export function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

/** Total firm outlay still counted toward exposure — sum of non-waived cost lines. */
export function committedCost(costs: { amount: number; waived: boolean }[]): number {
  return round2(
    costs.reduce(
      (sum, c) => (c.waived ? sum : sum + (Number.isFinite(c.amount) ? c.amount : 0)),
      0,
    ),
  );
}

/** Add whole calendar months to a date (clamped to month length, e.g. Jan 31 + 1 = Feb 28). */
export function addMonths(d: Date, months: number): Date {
  const r = new Date(d.getTime());
  const day = r.getUTCDate();
  r.setUTCDate(1);
  r.setUTCMonth(r.getUTCMonth() + months);
  const lastDay = new Date(Date.UTC(r.getUTCFullYear(), r.getUTCMonth() + 1, 0)).getUTCDate();
  r.setUTCDate(Math.min(day, lastDay));
  return r;
}

/** Fraction of the [start, end] window elapsed by asOf, clamped to [0, 1]. */
export function elapsedFraction(start: Date, end: Date, asOf: Date): number {
  const span = end.getTime() - start.getTime();
  if (span <= 0) return 1;
  const f = (asOf.getTime() - start.getTime()) / span;
  if (!Number.isFinite(f)) return 0;
  return Math.min(1, Math.max(0, f));
}

export type ExposureInput = {
  status: string;
  costs: { amount: number; waived: boolean }[];
  bondingMonths: number | null;
  bondingStartBasis: string; // ON_APPROVAL | ON_COMPLETION
  bondingWaived: boolean;
  approvedAt: Date | null;
  completedAt: Date | null;
  asOf?: Date;
};

export type ExposurePhase = "NONE" | "AT_RISK" | "BONDING" | "DISCHARGED";

export type ExposureResult = {
  committed: number;
  exposure: number;
  phase: ExposurePhase;
  windowStart: Date | null;
  windowEnd: Date | null;
  servedFraction: number; // 0..1
};

/**
 * Outstanding repayment exposure, derived live (WS6 Part 4).
 *
 * Policy (signed off v0.24.0):
 *  - No bond (waived, or no/zero bonding months) or WITHDRAWN -> exposure 0.
 *  - Before completion (PROPOSED/APPROVED/IN_PROGRESS): the firm's full committed
 *    outlay to date is at risk — a leaver before they qualify repays it all.
 *  - The bonding window is anchored by bondingStartBasis. Default ON_APPROVAL, so the
 *    window runs from the approval date and INCLUDES the study period; at completion
 *    exposure therefore pro-rates from approval (it steps down to whatever the served
 *    fraction already implies). ON_COMPLETION instead starts the clock at completion.
 *  - During bonding (COMPLETED, asOf within the window): exposure = committed × (1 − f).
 *  - After the window (served in full): exposure 0 (DISCHARGED).
 */
export function exposureFor(input: ExposureInput): ExposureResult {
  const asOf = input.asOf ?? new Date();
  const committed = committedCost(input.costs);
  const months = input.bondingMonths;

  // No commitment to repay against.
  if (
    input.status === "WITHDRAWN" ||
    input.bondingWaived ||
    months === null ||
    months === undefined ||
    months <= 0
  ) {
    return {
      committed,
      exposure: 0,
      phase: "NONE",
      windowStart: null,
      windowEnd: null,
      servedFraction: 1,
    };
  }

  const start =
    input.bondingStartBasis === "ON_COMPLETION" ? input.completedAt : input.approvedAt;

  // Window not yet anchored (e.g. ON_COMPLETION but not completed, or ON_APPROVAL but
  // not yet approved): the full committed outlay is at risk.
  if (!start) {
    return {
      committed,
      exposure: committed,
      phase: "AT_RISK",
      windowStart: null,
      windowEnd: null,
      servedFraction: 0,
    };
  }

  const end = addMonths(start, months);
  const f = elapsedFraction(start, end, asOf);

  // Still in study: full committed amount at risk regardless of any elapsed window.
  if (input.status !== "COMPLETED") {
    return {
      committed,
      exposure: committed,
      phase: "AT_RISK",
      windowStart: start,
      windowEnd: end,
      servedFraction: f,
    };
  }

  // Completed: pro-rate down across the served fraction of the bonding window.
  const exposure = round2(committed * (1 - f));
  return {
    committed,
    exposure,
    phase: f >= 1 ? "DISCHARGED" : "BONDING",
    windowStart: start,
    windowEnd: end,
    servedFraction: f,
  };
}

export function exposurePhaseLabel(phase: ExposurePhase): string {
  switch (phase) {
    case "AT_RISK":
      return "Full amount at risk";
    case "BONDING":
      return "Bond running";
    case "DISCHARGED":
      return "Bond served";
    default:
      return "No bond";
  }
}
