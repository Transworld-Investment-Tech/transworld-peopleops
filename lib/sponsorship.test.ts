// lib/sponsorship.test.ts — pure unit tests for the sponsorship engine (no DB).
// Run: npm run sponsorship:test   (or: npx tsx lib/sponsorship.test.ts)
import {
  round2,
  committedCost,
  addMonths,
  elapsedFraction,
  exposureFor,
} from "./sponsorship";

let passed = 0;
let failed = 0;

function ok(name: string, cond: boolean) {
  if (cond) {
    passed++;
  } else {
    failed++;
    console.error(`  \u2717 ${name}`);
  }
}
function eq(name: string, a: number, b: number, tol = 0.01) {
  ok(`${name} (got ${a}, want ${b})`, Math.abs(a - b) <= tol);
}

const DAY = 24 * 60 * 60 * 1000;
function daysFromNow(n: number): Date {
  return new Date(Date.now() + n * DAY);
}

// --- committedCost: sums non-waived lines only -----------------------------
eq("committed sums lines", committedCost([{ amount: 150000, waived: false }, { amount: 50000, waived: false }]), 200000);
eq("committed skips waived", committedCost([{ amount: 150000, waived: false }, { amount: 50000, waived: true }]), 150000);
eq("committed empty -> 0", committedCost([]), 0);

// --- addMonths: calendar months, clamped to month length -------------------
ok("addMonths +12 keeps day", addMonths(new Date(Date.UTC(2026, 0, 15)), 12).toISOString().slice(0, 10) === "2027-01-15");
ok("addMonths Jan31 +1 -> Feb28", addMonths(new Date(Date.UTC(2026, 0, 31)), 1).toISOString().slice(0, 10) === "2026-02-28");

// --- elapsedFraction: clamps to [0,1] --------------------------------------
const s = new Date(Date.UTC(2026, 0, 1));
const e = new Date(Date.UTC(2027, 0, 1)); // ~365 days
eq("elapsed half", elapsedFraction(s, e, new Date(Date.UTC(2026, 6, 2))), 0.5, 0.01);
eq("elapsed before -> 0", elapsedFraction(s, e, new Date(Date.UTC(2025, 0, 1))), 0);
eq("elapsed after -> 1", elapsedFraction(s, e, new Date(Date.UTC(2028, 0, 1))), 1);
eq("elapsed zero span -> 1", elapsedFraction(s, s, s), 1);

const COSTS = [
  { amount: 300000, waived: false },
  { amount: 100000, waived: false },
]; // committed 400,000

// --- No bond cases ---------------------------------------------------------
const waived = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: true, approvedAt: daysFromNow(-30), completedAt: daysFromNow(-1),
});
eq("waived bond -> exposure 0", waived.exposure, 0);
ok("waived bond -> phase NONE", waived.phase === "NONE");
eq("waived bond -> committed still computed", waived.committed, 400000);

const noMonths = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: null, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: false, approvedAt: daysFromNow(-30), completedAt: daysFromNow(-1),
});
eq("null months -> exposure 0", noMonths.exposure, 0);

const withdrawn = exposureFor({
  status: "WITHDRAWN", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: false, approvedAt: daysFromNow(-30), completedAt: null,
});
eq("withdrawn -> exposure 0", withdrawn.exposure, 0);

// --- In study: full committed at risk --------------------------------------
const inProgressApproval = exposureFor({
  status: "IN_PROGRESS", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: false, approvedAt: daysFromNow(-200), completedAt: null,
});
eq("in-progress (ON_APPROVAL) full at risk", inProgressApproval.exposure, 400000);
ok("in-progress phase AT_RISK", inProgressApproval.phase === "AT_RISK");

const inProgressCompletion = exposureFor({
  status: "IN_PROGRESS", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_COMPLETION",
  bondingWaived: false, approvedAt: daysFromNow(-200), completedAt: null,
});
eq("in-progress (ON_COMPLETION) full at risk, no window yet", inProgressCompletion.exposure, 400000);
ok("in-progress (ON_COMPLETION) window null", inProgressCompletion.windowStart === null);

// --- ON_COMPLETION: full at completion, decays after ------------------------
const completedNowOC = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_COMPLETION",
  bondingWaived: false, approvedAt: daysFromNow(-400), completedAt: daysFromNow(0),
});
eq("ON_COMPLETION at completion -> full", completedNowOC.exposure, 400000, 100);
ok("ON_COMPLETION at completion -> BONDING", completedNowOC.phase === "BONDING");

// Completed 12 months ago, 24-month bond from completion -> ~50% remaining.
const completedHalfOC = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_COMPLETION",
  bondingWaived: false, approvedAt: daysFromNow(-800), completedAt: daysFromNow(-365),
});
eq("ON_COMPLETION half-served -> ~200k", completedHalfOC.exposure, 200000, 3000);

// Bond fully served.
const servedOC = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 12, bondingStartBasis: "ON_COMPLETION",
  bondingWaived: false, approvedAt: daysFromNow(-800), completedAt: daysFromNow(-400),
});
eq("ON_COMPLETION served -> 0", servedOC.exposure, 0);
ok("ON_COMPLETION served -> DISCHARGED", servedOC.phase === "DISCHARGED");

// --- ON_APPROVAL step-down: window includes study time ----------------------
// Approved 365 days ago, 24-month (730-day) bond from APPROVAL, completing today.
// Fraction elapsed at completion ~= 365/730 = 0.5, so exposure steps to ~200k.
const stepDown = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 24, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: false, approvedAt: daysFromNow(-365), completedAt: daysFromNow(0),
});
eq("ON_APPROVAL step-down at completion ~200k", stepDown.exposure, 200000, 4000);
ok("ON_APPROVAL step-down phase BONDING", stepDown.phase === "BONDING");

// ON_APPROVAL where study outran the whole bond -> served (0) at completion.
const outran = exposureFor({
  status: "COMPLETED", costs: COSTS, bondingMonths: 12, bondingStartBasis: "ON_APPROVAL",
  bondingWaived: false, approvedAt: daysFromNow(-500), completedAt: daysFromNow(0),
});
eq("ON_APPROVAL study outran bond -> 0", outran.exposure, 0);
ok("ON_APPROVAL outran -> DISCHARGED", outran.phase === "DISCHARGED");

// --- rounding to the kobo ---------------------------------------------------
eq("round2", round2(199999.999), 200000);

const total = passed + failed;
if (failed === 0) {
  console.log(`sponsorship engine: ${passed}/${total} checks passed`);
  process.exit(0);
} else {
  console.error(`sponsorship engine: ${passed}/${total} passed, ${failed} FAILED`);
  process.exit(1);
}
