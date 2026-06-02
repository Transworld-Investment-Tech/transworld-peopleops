// lib/raise.test.ts — pure unit tests for the raise engine (no DB).
// Run: npm run raise:test   (or: npx tsx lib/raise.test.ts)
import {
  round2,
  clampPercent,
  raiseAmount,
  monthlyGross,
  annualTotal,
  raiseComponents,
  bandFlagFor,
  compaRatio,
  capToMax,
  gapToTarget,
  progressToTarget,
} from "./raise";

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

// Percent clamp
eq("clamp 0.05", clampPercent(0.05), 0.05);
eq("clamp -0.1 -> 0", clampPercent(-0.1), 0);
eq("clamp 2 -> 1", clampPercent(2), 1);
eq("clamp NaN -> 0", clampPercent(NaN), 0);

// Single-component raise, to the kobo
eq("raise 93333.33 @5%", raiseAmount(93333.33, 0.05), 98000.0);
eq("raise 0 @5% -> 0", raiseAmount(0, 0.05), 0);
eq("raise @0% no change", raiseAmount(74243.55, 0), 74243.55);

// Annual total under the firm pattern (basic×12 + utility×8 + quarterly×4),
// reconciled against the offer letters.
// Eunice Ezekiel: ₦1,680,000 total = ₦1,119,999.96 base + ₦560,000.04 allowances.
// Structured so monthly take-home is constant ₦140,000 (utility = quarterly = 46,666.67).
eq("Eunice annual total", annualTotal(93333.33, 46666.67, 46666.67), 1_680_000, 0.5);
// Daniel Ezeh: ₦1,330,922.64 total = ₦890,922.60 base + ₦440,000.04 allowances.
eq("Daniel annual total", annualTotal(74243.55, 36666.67, 36666.67), 1_330_922.64, 1.0);
// Sarah Amartey: ₦1,081,366.56 total = ₦721,366.56 base + ₦360,000.00 allowances.
eq("Sarah annual total", annualTotal(60113.88, 30000, 30000), 1_081_366.56, 1.0);

// Monthly gross excludes quarterly
eq("monthly gross", monthlyGross(93333.33, 46666.67), 140000);

// A 5% raise lifts every component and the annual total by exactly 5%, structure kept
const oldC = { basic: 93333.33, utility: 46666.67, quarterly: 46666.67 };
const newC = raiseComponents(oldC, 0.05);
eq("new basic", newC.basic, 98000.0);
eq("new utility", newC.utility, 49000.0);
eq("new quarterly", newC.quarterly, 49000.0);
const oldAnnual = annualTotal(oldC.basic, oldC.utility, oldC.quarterly);
const newAnnual = annualTotal(newC.basic, newC.utility, newC.quarterly);
eq("annual total +5%", newAnnual, round2(oldAnnual * 1.05), 0.5);
ok("ratio basic:utility preserved", Math.abs(newC.basic / newC.utility - oldC.basic / oldC.utility) < 1e-6);

// Band flags (bands on monthly-gross basis)
const band = { min: 100000, midpoint: 150000, max: 200000 };
ok("below min", bandFlagFor(90000, band) === "BELOW_MIN");
ok("within", bandFlagFor(140000, band) === "WITHIN");
ok("above mid", bandFlagFor(170000, band) === "ABOVE_MID");
ok("above max", bandFlagFor(220000, band) === "ABOVE_MAX");
ok("no band -> within", bandFlagFor(999999, null) === "WITHIN");

// Compa-ratio
eq("compa-ratio", compaRatio(170000, 150000) ?? -1, 1.133, 0.001);
ok("compa-ratio null midpoint", compaRatio(170000, 0) === null);

// Cap to band max — scales all components proportionally, preserves structure
const capped = capToMax({ basic: 150000, utility: 75000, quarterly: 75000 }, 200000);
ok("cap applied", capped.capApplied === true);
eq("capped gross = max", capped.components.basic + capped.components.utility, 200000, 0.5);
ok(
  "cap preserves basic:utility ratio",
  Math.abs(capped.components.basic / capped.components.utility - 2) < 1e-6,
);
const notCapped = capToMax({ basic: 90000, utility: 45000, quarterly: 45000 }, 200000);
ok("cap no-op within max", notCapped.capApplied === false);
const noBand = capToMax({ basic: 150000, utility: 75000, quarterly: 75000 }, null);
ok("cap no-op when no band", noBand.capApplied === false);

// Gap + progress to milestone
eq("gap to target", gapToTarget(500_000_000, 430_000_000), 70_000_000);
eq("gap met -> 0", gapToTarget(500_000_000, 520_000_000), 0);
eq("progress", progressToTarget(500_000_000, 430_000_000), 0.86, 0.001);
eq("progress capped at 1", progressToTarget(500_000_000, 600_000_000), 1);

const total = passed + failed;
if (failed === 0) {
  console.log(`raise engine: ${passed}/${total} checks passed`);
  process.exit(0);
} else {
  console.error(`raise engine: ${passed}/${total} passed, ${failed} FAILED`);
  process.exit(1);
}
