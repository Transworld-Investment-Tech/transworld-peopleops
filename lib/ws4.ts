// =============================================================================
// lib/ws4.ts — pure engine for WS4 depth (probation clock + offboarding mirror
// + sponsorship-repayment crystallization-on-exit).
//
// CONTENT/LOGIC ONLY. The one allowed import is the pure `exposureFor` from
// lib/sponsorship.ts (itself import-free). No React, no Prisma, no server bits,
// so lib/ws4.test.ts runs under `tsx` with no database.
//
// Canonical sources (confirmed from the documents, not memory):
//  - Probation: HR Operations Manual D4 (6-month period; 3-month midpoint
//    review; end-of-probation decision communicated >= 2 weeks before the end
//    date) + WS4 pack Part 2 (Confirm / Extend / Exit).
//  - Exit types + access revocation: Ops Manual D5 + WS4 pack Part 3.
//  - Clawback-on-exit: Ops Manual G4.3 — post-completion pro-rata, mid-study is
//    a COO-review case (no formula), and no clawback on redundancy / medical /
//    retirement. The math itself is `exposureFor` (lib/sponsorship.ts); this
//    module only decides WHICH exit triggers it and how to label the result.
// =============================================================================

import { exposureFor, type ExposureResult } from "./sponsorship";

// ── Probation clock ─────────────────────────────────────────────────────────

/** WS4/Ops-Manual standard probation length, in months, for a new hire. */
export const STANDARD_PROBATION_MONTHS = 6;

/** Decision communicated this many days before the end date (Ops Manual D4.3). */
export const FINAL_DECISION_LEAD_DAYS = 14;

export const PROBATION_REVIEW_KINDS = ["MIDPOINT", "FINAL"] as const;
export type ProbationReviewKind = (typeof PROBATION_REVIEW_KINDS)[number];

// MIDPOINT uses ON_TRACK / CONCERNS; FINAL uses CONFIRM / EXTEND / NON_CONFIRM.
// PENDING is the unset state for a scheduled-but-not-held review.
export const PROBATION_OUTCOMES = [
  "PENDING",
  "ON_TRACK",
  "CONCERNS",
  "CONFIRM",
  "EXTEND",
  "NON_CONFIRM",
] as const;
export type ProbationOutcome = (typeof PROBATION_OUTCOMES)[number];

export const MIDPOINT_OUTCOMES: ProbationOutcome[] = ["ON_TRACK", "CONCERNS"];
export const FINAL_OUTCOMES: ProbationOutcome[] = ["CONFIRM", "EXTEND", "NON_CONFIRM"];

export type ProbationMilestones = {
  startDate: Date | null;
  endsOn: Date | null; // start + months (probation end)
  midpointOn: Date | null; // halfway point — the 3-month review for a 6-month window
  finalDueBy: Date | null; // endsOn - FINAL_DECISION_LEAD_DAYS (decide by this date)
};

function addMonthsUTC(d: Date, months: number): Date {
  const r = new Date(d);
  r.setUTCMonth(r.getUTCMonth() + months);
  return r;
}

function addDaysUTC(d: Date, days: number): Date {
  return new Date(d.getTime() + days * 86400000);
}

/**
 * Derive the probation milestone dates from the start date + stored length.
 * Milestones are DERIVED (no stored milestone columns); the review rows record
 * what actually happened. `months` is whatever the plan stores (we default the
 * UI to 6, but read whatever is there).
 */
export function probationMilestones(
  startDate: Date | null,
  months: number
): ProbationMilestones {
  if (!startDate || !Number.isFinite(months) || months <= 0) {
    return { startDate: startDate ?? null, endsOn: null, midpointOn: null, finalDueBy: null };
  }
  const endsOn = addMonthsUTC(startDate, months);
  // Halfway by elapsed time — for a 6-month window this lands at ~3 months,
  // matching the Ops Manual's "3-month midpoint review".
  const midpointOn = new Date(startDate.getTime() + (endsOn.getTime() - startDate.getTime()) / 2);
  const finalDueBy = addDaysUTC(endsOn, -FINAL_DECISION_LEAD_DAYS);
  return { startDate, endsOn, midpointOn, finalDueBy };
}

export type ProbationPhase =
  | "NOT_STARTED"
  | "RUNNING"
  | "MIDPOINT_DUE"
  | "FINAL_DUE"
  | "OVERDUE"
  | "CONCLUDED";

export type ReviewFact = { kind: string; outcome: string | null };

/** True once a FINAL review carries a terminal outcome (confirm/extend/non-confirm). */
export function isConcluded(reviews: ReviewFact[]): boolean {
  return reviews.some(
    (r) => r.kind === "FINAL" && r.outcome != null && FINAL_OUTCOMES.includes(r.outcome as ProbationOutcome)
  );
}

function hasHeldMidpoint(reviews: ReviewFact[]): boolean {
  return reviews.some(
    (r) => r.kind === "MIDPOINT" && r.outcome != null && r.outcome !== "PENDING"
  );
}

/**
 * Where the probation clock sits as of `asOf`, given the milestones and what
 * reviews have happened. Drives the prompts People Ops sees.
 */
export function probationPhase(
  asOf: Date,
  m: ProbationMilestones,
  reviews: ReviewFact[]
): ProbationPhase {
  if (!m.startDate || !m.endsOn) return "NOT_STARTED";
  if (isConcluded(reviews)) return "CONCLUDED";
  if (asOf.getTime() >= m.endsOn.getTime()) return "OVERDUE";
  if (m.finalDueBy && asOf.getTime() >= m.finalDueBy.getTime()) return "FINAL_DUE";
  if (m.midpointOn && asOf.getTime() >= m.midpointOn.getTime() && !hasHeldMidpoint(reviews))
    return "MIDPOINT_DUE";
  return "RUNNING";
}

export function probationPhaseLabel(p: ProbationPhase): string {
  switch (p) {
    case "NOT_STARTED": return "Not started";
    case "RUNNING": return "On probation";
    case "MIDPOINT_DUE": return "Midpoint review due";
    case "FINAL_DUE": return "Final decision due";
    case "OVERDUE": return "Decision overdue";
    case "CONCLUDED": return "Probation concluded";
  }
}

export function probationPhaseBadge(p: ProbationPhase): { cls: string; label: string } {
  const label = probationPhaseLabel(p);
  switch (p) {
    case "CONCLUDED": return { cls: "b-grn", label };
    case "RUNNING": return { cls: "b-blu", label };
    case "MIDPOINT_DUE": return { cls: "b-amb", label };
    case "FINAL_DUE": return { cls: "b-amb", label };
    case "OVERDUE": return { cls: "b-red", label };
    default: return { cls: "b-gry", label };
  }
}

export function probationOutcomeLabel(o: string | null | undefined): string {
  switch (o) {
    case "ON_TRACK": return "On track";
    case "CONCERNS": return "Concerns raised";
    case "CONFIRM": return "Confirm";
    case "EXTEND": return "Extend";
    case "NON_CONFIRM": return "Do not confirm";
    case "PENDING": return "Pending";
    default: return "—";
  }
}

export function probationOutcomeBadge(o: string | null | undefined): { cls: string; label: string } {
  const label = probationOutcomeLabel(o);
  switch (o) {
    case "CONFIRM": return { cls: "b-grn", label };
    case "ON_TRACK": return { cls: "b-grn", label };
    case "EXTEND": return { cls: "b-amb", label };
    case "CONCERNS": return { cls: "b-amb", label };
    case "NON_CONFIRM": return { cls: "b-red", label };
    default: return { cls: "b-gry", label };
  }
}

// ── Offboarding (exit) ───────────────────────────────────────────────────────

export const EXIT_TYPES = [
  "RESIGNATION",
  "NON_CONFIRMATION",
  "DISMISSAL",
  "REDUNDANCY",
  "RETIREMENT",
  "END_OF_TERM",
] as const;
export type ExitType = (typeof EXIT_TYPES)[number];

export const OFFBOARDING_STATUSES = ["OPEN", "CLEARING", "CLOSED"] as const;
export type OffboardingStatus = (typeof OFFBOARDING_STATUSES)[number];

export const OFFBOARDING_TASK_CATEGORIES = ["SYSTEM", "PHYSICAL", "REGULATORY"] as const;
export type OffboardingTaskCategory = (typeof OFFBOARDING_TASK_CATEGORIES)[number];

export const OFFBOARDING_TASK_STATUSES = ["PENDING", "DONE", "NA"] as const;
export type OffboardingTaskStatus = (typeof OFFBOARDING_TASK_STATUSES)[number];

export function exitTypeLabel(t: string): string {
  switch (t) {
    case "RESIGNATION": return "Resignation";
    case "NON_CONFIRMATION": return "End of probation (not confirmed)";
    case "DISMISSAL": return "Dismissal (conduct / capability)";
    case "REDUNDANCY": return "Redundancy";
    case "RETIREMENT": return "Retirement";
    case "END_OF_TERM": return "End of fixed term / contract";
    default: return t;
  }
}

export function offboardingStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "OPEN": return { cls: "b-amb", label: "Open" };
    case "CLEARING": return { cls: "b-blu", label: "Clearing" };
    case "CLOSED": return { cls: "b-grn", label: "Closed" };
    default: return { cls: "b-gry", label: s };
  }
}

export type OffboardingTaskSeed = {
  label: string;
  category: OffboardingTaskCategory;
  sortOrder: number;
};

/**
 * The WS4 access-&-asset revocation checklist (WS4 pack Part 3). The
 * regulatory-notification item is included only for regulated roles, and the
 * elevated-rights reassignment item only when the leaver's account holds
 * SUPER_ADMIN / elevated rights (so the list reads true for the person).
 */
export function defaultOffboardingTasks(
  exitType: string,
  isRegulated: boolean,
  holdsElevatedRights: boolean
): OffboardingTaskSeed[] {
  const sys: string[] = [
    "PeopleOps portal account deactivated",
    "Email and file access revoked",
    "Trading / Naya and market-system access revoked",
    "Removed from payment / banking authorities",
    "Client-data and remote access disabled",
  ];
  if (holdsElevatedRights) {
    sys.push("Shared passwords changed; SUPER_ADMIN / elevated rights reassigned");
  }
  const phys: string[] = [
    "Laptop / devices returned",
    "ID card, access keys / fobs returned",
    "Company property / documents returned",
  ];
  const reg: string[] = ["Handover signed off by the manager"];
  if (isRegulated) {
    reg.unshift("Sponsored-individual / regulatory status notified (CCO)");
  }
  // Exit interviews are not conducted for dismissals (Ops Manual D5.2).
  if (exitType !== "DISMISSAL") reg.push("Exit interview completed");
  reg.push("Final pay and entitlements settled");
  reg.push("Staff file closed and retained per policy");

  const out: OffboardingTaskSeed[] = [];
  let i = 0;
  for (const label of sys) out.push({ label, category: "SYSTEM", sortOrder: i++ });
  for (const label of phys) out.push({ label, category: "PHYSICAL", sortOrder: i++ });
  for (const label of reg) out.push({ label, category: "REGULATORY", sortOrder: i++ });
  return out;
}

// ── Sponsorship-repayment crystallization on exit (Ops Manual G4.3) ───────────

// The two existing repayment-status values this engine sets (the full vocab —
// NOT_APPLICABLE / PENDING / WAIVED / REPAYING / SETTLED — lives in
// lib/sponsorship.ts; crystallization only ever lands on the first three).
export type CrystallizedRepayment = {
  repaymentStatus: "NOT_APPLICABLE" | "PENDING" | "WAIVED";
  repaymentAmount: number | null; // null = COO-review (mid-study) — no formula
  reason: string;
  exposure: ExposureResult; // the derived figures, for display + the audit note
};

/** Exit types that NEVER trigger clawback (Ops Manual G4.3). */
export const NO_CLAWBACK_EXITS: ExitType[] = ["REDUNDANCY", "RETIREMENT"];

export type ClawbackInput = {
  exitType: string;
  // Whatever the live sponsorship row carries — passed straight to exposureFor.
  costs: { amount: number; waived: boolean }[];
  bondingMonths: number | null;
  bondingStartBasis: string;
  bondingWaived: boolean;
  status: string; // sponsorship status (PROPOSED/APPROVED/IN_PROGRESS/COMPLETED/WITHDRAWN)
  approvedAt: Date | null;
  completedAt: Date | null;
  /** As-of date for the exposure calc — the leaver's last working day. */
  asOf: Date;
  /** Medical-incapacity departure — a no-clawback case (Ops Manual G4.3). */
  medicalIncapacity?: boolean;
};

/**
 * Decide the repayment crystallization for ONE sponsorship at exit. The number
 * itself comes from `exposureFor`; this function applies the exit-type policy
 * around it.
 *
 *  - Redundancy / retirement / medical incapacity → WAIVED (firm investment).
 *  - Otherwise read the exposure phase:
 *      NONE / DISCHARGED  → NOT_APPLICABLE (nothing owed).
 *      IN_STUDY w/ costs  → PENDING, amount null — mid-study COO-review case.
 *      BONDING            → PENDING, amount = pro-rated exposure.
 */
export function clawbackOnExit(input: ClawbackInput): CrystallizedRepayment {
  const exposure = exposureFor({
    status: input.status,
    costs: input.costs,
    bondingMonths: input.bondingMonths,
    bondingStartBasis: input.bondingStartBasis,
    bondingWaived: input.bondingWaived,
    approvedAt: input.approvedAt,
    completedAt: input.completedAt,
    asOf: input.asOf,
  });

  const noClawback =
    NO_CLAWBACK_EXITS.includes(input.exitType as ExitType) || !!input.medicalIncapacity;

  if (noClawback) {
    if (exposure.committed <= 0) {
      return { repaymentStatus: "NOT_APPLICABLE", repaymentAmount: null, reason: "No sponsorship cost committed.", exposure };
    }
    return {
      repaymentStatus: "WAIVED",
      repaymentAmount: null,
      reason: `No clawback on ${exitTypeLabel(input.exitType).toLowerCase()} (Ops Manual G4.3) — treated as a firm investment.`,
      exposure,
    };
  }

  switch (exposure.phase) {
    case "NONE":
      return { repaymentStatus: "NOT_APPLICABLE", repaymentAmount: null, reason: "No active bond (waived, withdrawn, or no bonding period).", exposure };
    case "DISCHARGED":
      return { repaymentStatus: "NOT_APPLICABLE", repaymentAmount: null, reason: "Bond fully served — the 12-month window has elapsed.", exposure };
    case "IN_STUDY":
      if (exposure.committed <= 0) {
        return { repaymentStatus: "NOT_APPLICABLE", repaymentAmount: null, reason: "No sponsorship cost committed yet.", exposure };
      }
      return {
        repaymentStatus: "PENDING",
        repaymentAmount: null, // no formula mid-study
        reason: "Mid-study departure — COO determines the recovery amount case by case (Ops Manual G4.3). No automatic formula.",
        exposure,
      };
    case "BONDING":
      return {
        repaymentStatus: "PENDING",
        repaymentAmount: exposure.exposure,
        reason: `Pro-rata clawback: ${(1 - exposure.servedFraction) >= 0 ? Math.round((1 - exposure.servedFraction) * 100) : 0}% of committed cost remains within the 12-month window (Ops Manual G4.3).`,
        exposure,
      };
  }
}

export function repaymentStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PENDING": return { cls: "b-amb", label: "Repayment pending" };
    case "WAIVED": return { cls: "b-gry", label: "Waived" };
    case "REPAYING": return { cls: "b-blu", label: "Repaying" };
    case "SETTLED": return { cls: "b-grn", label: "Settled" };
    default: return { cls: "b-gry", label: "Not applicable" };
  }
}

// ── Shared date helper (display) ──────────────────────────────────────────────
export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}
