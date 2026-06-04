import assert from "node:assert";
import {
  STANDARD_PROBATION_MONTHS,
  FINAL_DECISION_LEAD_DAYS,
  PROBATION_REVIEW_KINDS,
  PROBATION_OUTCOMES,
  MIDPOINT_OUTCOMES,
  FINAL_OUTCOMES,
  probationMilestones,
  probationPhase,
  probationPhaseBadge,
  probationOutcomeBadge,
  isConcluded,
  EXIT_TYPES,
  OFFBOARDING_STATUSES,
  OFFBOARDING_TASK_CATEGORIES,
  exitTypeLabel,
  offboardingStatusBadge,
  defaultOffboardingTasks,
  clawbackOnExit,
  repaymentStatusBadge,
  NO_CLAWBACK_EXITS,
  type ReviewFact,
} from "./ws4";

let pass = 0;
function t(name: string, fn: () => void) {
  fn();
  pass += 1;
  // eslint-disable-next-line no-console
  console.log("ok -", name);
}

const D = (s: string) => new Date(`${s}T00:00:00.000Z`);

// ── constants / vocab ────────────────────────────────────────────────────────
t("standard probation is 6 months, lead is 14 days", () => {
  assert.equal(STANDARD_PROBATION_MONTHS, 6);
  assert.equal(FINAL_DECISION_LEAD_DAYS, 14);
});

t("review-kind + outcome vocab partitions correctly", () => {
  assert.deepEqual([...PROBATION_REVIEW_KINDS], ["MIDPOINT", "FINAL"]);
  assert.equal(PROBATION_OUTCOMES.length, 6);
  for (const o of MIDPOINT_OUTCOMES) assert.ok(PROBATION_OUTCOMES.includes(o));
  for (const o of FINAL_OUTCOMES) assert.ok(PROBATION_OUTCOMES.includes(o));
  // midpoint + final outcomes are disjoint
  for (const o of FINAL_OUTCOMES) assert.ok(!MIDPOINT_OUTCOMES.includes(o));
});

// ── probation milestones ─────────────────────────────────────────────────────
t("milestones: 6-month window puts midpoint near 3 months, final 14d before end", () => {
  const m = probationMilestones(D("2026-01-01"), 6);
  assert.equal(m.endsOn?.toISOString().slice(0, 10), "2026-07-01");
  // midpoint is the time-halfway point (~early April)
  assert.ok(m.midpointOn! > D("2026-03-25") && m.midpointOn! < D("2026-04-10"));
  // final due 14 days before the end
  assert.equal(m.finalDueBy?.toISOString().slice(0, 10), "2026-06-17");
});

t("milestones: null / non-positive months → all null", () => {
  assert.equal(probationMilestones(null, 6).endsOn, null);
  assert.equal(probationMilestones(D("2026-01-01"), 0).endsOn, null);
});

// ── probation phase machine ──────────────────────────────────────────────────
const M6 = probationMilestones(D("2026-01-01"), 6);
const noReviews: ReviewFact[] = [];

t("phase NOT_STARTED with no start date", () => {
  assert.equal(probationPhase(D("2026-02-01"), probationMilestones(null, 6), noReviews), "NOT_STARTED");
});

t("phase RUNNING early in the window", () => {
  assert.equal(probationPhase(D("2026-02-01"), M6, noReviews), "RUNNING");
});

t("phase MIDPOINT_DUE once past midpoint and no held midpoint", () => {
  assert.equal(probationPhase(D("2026-04-15"), M6, noReviews), "MIDPOINT_DUE");
});

t("a held midpoint clears MIDPOINT_DUE back to RUNNING", () => {
  const held: ReviewFact[] = [{ kind: "MIDPOINT", outcome: "ON_TRACK" }];
  assert.equal(probationPhase(D("2026-04-15"), M6, held), "RUNNING");
});

t("phase FINAL_DUE in the 14-day lead window", () => {
  assert.equal(probationPhase(D("2026-06-20"), M6, noReviews), "FINAL_DUE");
});

t("phase OVERDUE past the end date with no decision", () => {
  assert.equal(probationPhase(D("2026-07-05"), M6, noReviews), "OVERDUE");
});

t("phase CONCLUDED once a FINAL outcome is recorded (any as-of)", () => {
  for (const o of FINAL_OUTCOMES) {
    const r: ReviewFact[] = [{ kind: "FINAL", outcome: o }];
    assert.equal(probationPhase(D("2026-07-05"), M6, r), "CONCLUDED");
    assert.equal(isConcluded(r), true);
  }
  assert.equal(isConcluded([{ kind: "FINAL", outcome: "PENDING" }]), false);
  assert.equal(isConcluded([{ kind: "MIDPOINT", outcome: "ON_TRACK" }]), false);
});

t("phase badges map to expected tones", () => {
  assert.equal(probationPhaseBadge("CONCLUDED").cls, "b-grn");
  assert.equal(probationPhaseBadge("OVERDUE").cls, "b-red");
  assert.equal(probationPhaseBadge("MIDPOINT_DUE").cls, "b-amb");
  assert.equal(probationPhaseBadge("RUNNING").cls, "b-blu");
  assert.equal(probationOutcomeBadge("CONFIRM").cls, "b-grn");
  assert.equal(probationOutcomeBadge("NON_CONFIRM").cls, "b-red");
  assert.equal(probationOutcomeBadge("EXTEND").cls, "b-amb");
});

// ── exit vocab ───────────────────────────────────────────────────────────────
t("six exit types, four statuses, three task categories", () => {
  assert.equal(EXIT_TYPES.length, 6);
  assert.deepEqual([...OFFBOARDING_STATUSES], ["OPEN", "CLEARING", "CLOSED", "CANCELLED"]);
  assert.deepEqual([...OFFBOARDING_TASK_CATEGORIES], ["SYSTEM", "PHYSICAL", "REGULATORY"]);
  assert.equal(exitTypeLabel("NON_CONFIRMATION"), "End of probation (not confirmed)");
  assert.equal(offboardingStatusBadge("CLOSED").cls, "b-grn");
  assert.equal(offboardingStatusBadge("CANCELLED").label, "Cancelled");
});

// ── offboarding checklist generation ─────────────────────────────────────────
t("default checklist: regulated + elevated adds the CCO + SUPER_ADMIN items", () => {
  const reg = defaultOffboardingTasks("RESIGNATION", true, true);
  const labels = reg.map((x) => x.label);
  assert.ok(labels.some((l) => l.includes("regulatory status notified")));
  assert.ok(labels.some((l) => l.includes("SUPER_ADMIN")));
  assert.ok(labels.includes("Exit interview completed"));
  // categories are well-formed and sortOrder is contiguous
  reg.forEach((x, i) => {
    assert.ok(OFFBOARDING_TASK_CATEGORIES.includes(x.category));
    assert.equal(x.sortOrder, i);
  });
});

t("default checklist: non-regulated + no elevated drops those two items", () => {
  const plain = defaultOffboardingTasks("RESIGNATION", false, false);
  const labels = plain.map((x) => x.label);
  assert.ok(!labels.some((l) => l.includes("regulatory status notified")));
  assert.ok(!labels.some((l) => l.includes("SUPER_ADMIN")));
});

t("dismissal drops the exit-interview item (D5.2)", () => {
  const dis = defaultOffboardingTasks("DISMISSAL", false, false);
  assert.ok(!dis.map((x) => x.label).includes("Exit interview completed"));
  // but a resignation keeps it
  assert.ok(defaultOffboardingTasks("RESIGNATION", false, false).map((x) => x.label).includes("Exit interview completed"));
});

t("portal-deactivation + staff-file-closed items always present", () => {
  const x = defaultOffboardingTasks("RETIREMENT", false, false).map((t) => t.label);
  assert.ok(x.includes("PeopleOps portal account deactivated"));
  assert.ok(x.includes("Staff file closed and retained per policy"));
  assert.ok(x.includes("Final pay and entitlements settled"));
});

// ── clawback-on-exit matrix (Ops Manual G4.3) ────────────────────────────────
const COSTS = [{ amount: 480000, waived: false }];
const completedHalfAgo = {
  // completed exactly 6 months before the exit → half the 12-month window served
  status: "COMPLETED",
  costs: COSTS,
  bondingMonths: 12,
  bondingStartBasis: "ON_COMPLETION",
  bondingWaived: false,
  approvedAt: D("2025-01-01"),
  completedAt: D("2026-01-01"),
  asOf: D("2026-07-01"),
};

t("no-clawback exits are redundancy + retirement", () => {
  assert.deepEqual([...NO_CLAWBACK_EXITS].sort(), ["REDUNDANCY", "RETIREMENT"]);
});

t("BONDING + resignation → PENDING with pro-rated amount", () => {
  const r = clawbackOnExit({ ...completedHalfAgo, exitType: "RESIGNATION" });
  assert.equal(r.repaymentStatus, "PENDING");
  // ~half the 12-month window served (calendar-day span, not exactly 0.5):
  // the crystallized amount is exactly the engine's exposure figure, near ₦240k.
  assert.equal(r.repaymentAmount, r.exposure.exposure);
  assert.ok(r.repaymentAmount! > 235000 && r.repaymentAmount! < 245000, `got ${r.repaymentAmount}`);
  assert.equal(r.exposure.phase, "BONDING");
});

t("BONDING + redundancy → WAIVED, no amount", () => {
  const r = clawbackOnExit({ ...completedHalfAgo, exitType: "REDUNDANCY" });
  assert.equal(r.repaymentStatus, "WAIVED");
  assert.equal(r.repaymentAmount, null);
});

t("BONDING + retirement → WAIVED", () => {
  assert.equal(clawbackOnExit({ ...completedHalfAgo, exitType: "RETIREMENT" }).repaymentStatus, "WAIVED");
});

t("medical incapacity flag → WAIVED even on a resignation", () => {
  const r = clawbackOnExit({ ...completedHalfAgo, exitType: "RESIGNATION", medicalIncapacity: true });
  assert.equal(r.repaymentStatus, "WAIVED");
});

t("mid-study (IN_STUDY) + resignation → PENDING, amount null (COO review)", () => {
  const r = clawbackOnExit({
    exitType: "RESIGNATION",
    status: "IN_PROGRESS",
    costs: COSTS,
    bondingMonths: 12,
    bondingStartBasis: "ON_COMPLETION",
    bondingWaived: false,
    approvedAt: D("2026-01-01"),
    completedAt: null,
    asOf: D("2026-06-01"),
  });
  assert.equal(r.repaymentStatus, "PENDING");
  assert.equal(r.repaymentAmount, null);
  assert.equal(r.exposure.phase, "IN_STUDY");
  assert.match(r.reason, /COO/);
});

t("discharged (window elapsed) → NOT_APPLICABLE", () => {
  const r = clawbackOnExit({
    exitType: "RESIGNATION",
    status: "COMPLETED",
    costs: COSTS,
    bondingMonths: 12,
    bondingStartBasis: "ON_COMPLETION",
    bondingWaived: false,
    approvedAt: D("2023-01-01"),
    completedAt: D("2024-01-01"),
    asOf: D("2026-07-01"),
  });
  assert.equal(r.repaymentStatus, "NOT_APPLICABLE");
  assert.equal(r.exposure.phase, "DISCHARGED");
});

t("waived bond → NOT_APPLICABLE (NONE)", () => {
  const r = clawbackOnExit({
    exitType: "RESIGNATION",
    status: "COMPLETED",
    costs: COSTS,
    bondingMonths: 12,
    bondingStartBasis: "ON_COMPLETION",
    bondingWaived: true,
    approvedAt: D("2026-01-01"),
    completedAt: D("2026-02-01"),
    asOf: D("2026-03-01"),
  });
  assert.equal(r.repaymentStatus, "NOT_APPLICABLE");
  assert.equal(r.exposure.phase, "NONE");
});

t("no committed cost on a no-clawback exit → NOT_APPLICABLE not WAIVED", () => {
  const r = clawbackOnExit({
    exitType: "REDUNDANCY",
    status: "COMPLETED",
    costs: [{ amount: 100000, waived: true }],
    bondingMonths: 12,
    bondingStartBasis: "ON_COMPLETION",
    bondingWaived: false,
    approvedAt: D("2026-01-01"),
    completedAt: D("2026-02-01"),
    asOf: D("2026-03-01"),
  });
  assert.equal(r.repaymentStatus, "NOT_APPLICABLE");
});

t("repayment badges", () => {
  assert.equal(repaymentStatusBadge("PENDING").cls, "b-amb");
  assert.equal(repaymentStatusBadge("WAIVED").cls, "b-gry");
  assert.equal(repaymentStatusBadge("SETTLED").cls, "b-grn");
  assert.equal(repaymentStatusBadge("REPAYING").cls, "b-blu");
  assert.equal(repaymentStatusBadge("NOT_APPLICABLE").cls, "b-gry");
});

// eslint-disable-next-line no-console
console.log(`\n${pass} WS4 engine tests passed.`);
