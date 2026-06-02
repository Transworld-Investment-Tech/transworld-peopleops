// lib/bonus.test.ts — pure unit tests for the bonus engine (no DB).
// Run: npm run bonus:test   (or: npx tsx lib/bonus.test.ts)
import {
  targetMonthsFor,
  isDeferredGrade,
  monthlySalaryFor,
  clampMultiplier,
  effectiveMultiplier,
  computeTargetBonus,
  computeCalculatedBonus,
  poolScalingFactor,
  applyScaling,
  trancheSplit,
  immediateDeferredSplit,
  trancheSchedule,
  round2,
} from "./bonus";

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
function eq(name: string, a: number, b: number, tol = 0.005) {
  ok(`${name} (got ${a}, want ${b})`, Math.abs(a - b) <= tol);
}

// Target months by grade
eq("targetMonths G0", targetMonthsFor("G0"), 0.25);
eq("targetMonths G1", targetMonthsFor("G1"), 0.5);
eq("targetMonths G2", targetMonthsFor("G2"), 0.75);
eq("targetMonths G3", targetMonthsFor("G3"), 0.75);
eq("targetMonths G4", targetMonthsFor("G4"), 1.0);
eq("targetMonths G5", targetMonthsFor("G5"), 1.25);
eq("targetMonths lowercase g5", targetMonthsFor("g5"), 1.25);
eq("targetMonths unknown -> 0", targetMonthsFor("GX"), 0);
eq("targetMonths null -> 0", targetMonthsFor(null), 0);

// Deferred grades
ok("G4 deferred", isDeferredGrade("G4"));
ok("G5 deferred", isDeferredGrade("G5"));
ok("G3 not deferred", !isDeferredGrade("G3"));
ok("null not deferred", !isDeferredGrade(null));

// Monthly salary basis (offer-letter: base + allowance; quarterly excluded)
eq("GROSS basis = basic + utility", monthlySalaryFor("GROSS", 60113.88, 30000), 90113.88);
eq("BASIC basis = basic only", monthlySalaryFor("BASIC", 60113.88, 30000), 60113.88);
eq("Sarah monthly gross", monthlySalaryFor("GROSS", 721366.56 / 12, 360000 / 12), 90113.88);
eq("Daniel monthly gross", monthlySalaryFor("GROSS", 890922.6 / 12, 440000.04 / 12), 110910.22);

// Multiplier clamp + integrity gate
eq("clamp 1.15", clampMultiplier(1.15), 1.15);
eq("clamp 1.5 -> 1.3", clampMultiplier(1.5), 1.3);
eq("clamp -1 -> 0", clampMultiplier(-1), 0);
eq("effective normal", effectiveMultiplier(1.15, false), 1.15);
eq("effective gate -> 0", effectiveMultiplier(1.15, true), 0);
eq("effective over-cap -> 1.3", effectiveMultiplier(2.0, false), 1.3);

// WS6 illustrative example: G3 @ 200,000, 0.75 months, ×1.15 -> 172,500
eq("target bonus G3", computeTargetBonus(0.75, 200000), 150000);
eq("calculated bonus ×1.15", computeCalculatedBonus(150000, 1.15, false), 172500);
eq("calculated bonus gated -> 0", computeCalculatedBonus(150000, 1.15, true), 0);

// Pool reconciliation
eq("factor within pool -> 1", poolScalingFactor(1_000_000, 1_200_000), 1);
eq("factor oversubscribed", poolScalingFactor(1_200_000, 1_000_000), 1_000_000 / 1_200_000);
eq("factor sum 0 -> 1", poolScalingFactor(0, 500_000), 1);
eq("factor pool 0 -> 0", poolScalingFactor(500_000, 0), 0);
eq("applyScaling", applyScaling(172500, poolScalingFactor(1_200_000, 1_000_000)), round2(172500 * (1_000_000 / 1_200_000)));

// Tranche split — non-deferred is a single immediate tranche
const nd = trancheSplit(172500, false);
ok("non-deferred single tranche", nd.length === 1 && nd[0].sequence === 0);
eq("non-deferred amount", nd[0].amount, 172500);

// Tranche split — deferred sums exactly to awarded, residual on last tranche
const d = trancheSplit(1_000_000, true);
ok("deferred has 3 tranches", d.length === 3);
eq("deferred t0 65%", d[0].amount, 650000);
eq("deferred t1 26.25%", d[1].amount, 262500);
eq("deferred t2 8.75%", d[2].amount, 87500);
eq("deferred tranches sum to awarded", round2(d[0].amount + d[1].amount + d[2].amount), 1_000_000);

// Odd amount — residual still reconciles to the kobo
const odd = trancheSplit(33.33, true);
eq("odd tranches sum", round2(odd[0].amount + odd[1].amount + odd[2].amount), 33.33);

// Immediate/deferred split recorded on the award
const sp = immediateDeferredSplit(1_000_000, true);
eq("split immediate", sp.immediate, 650000);
eq("split deferred", sp.deferred, 350000);
const spN = immediateDeferredSplit(172500, false);
eq("non-deferred immediate = all", spN.immediate, 172500);
eq("non-deferred deferred = 0", spN.deferred, 0);

// Schedule — April of awardYear+1, then the next two Aprils
const s0 = trancheSchedule(2026, 0);
ok("schedule seq0 = Apr 2027", s0.month === 4 && s0.year === 2027);
const s2 = trancheSchedule(2026, 2);
ok("schedule seq2 = Apr 2029", s2.month === 4 && s2.year === 2029);

const total = passed + failed;
if (failed === 0) {
  console.log(`bonus engine: ${passed}/${total} checks passed`);
  process.exit(0);
} else {
  console.error(`bonus engine: ${passed}/${total} passed, ${failed} FAILED`);
  process.exit(1);
}
