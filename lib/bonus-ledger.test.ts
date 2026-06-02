// lib/bonus-ledger.test.ts — pure tests for the Phase B deferral-ledger helpers.
// Run: npx tsx lib/bonus-ledger.test.ts   (or: npm run bonus-ledger:test)
import {
  round2, clawbackTotal, trancheNet, statusAfterClawback, isDueInYear, clampClawback,
} from "./bonus-ledger";

let passed = 0;
let failed = 0;
function ok(name: string, cond: boolean) {
  if (cond) { passed++; } else { failed++; console.error("  FAIL:", name); }
}
function eq(name: string, a: number | string, b: number | string) {
  ok(`${name} (${a} === ${b})`, a === b);
}

// clawbackTotal
eq("clawbackTotal sums only CLAWBACK", clawbackTotal([
  { eventType: "PAID", amount: 100 },
  { eventType: "CLAWBACK", amount: 30 },
  { eventType: "CLAWBACK", amount: 20 },
  { eventType: "FORFEIT", amount: 10 },
]), 50);
eq("clawbackTotal empty", clawbackTotal([]), 0);

// trancheNet
eq("net of scheduled, no clawback", trancheNet(100000, "SCHEDULED", 0), 100000);
eq("net of paid with partial clawback", trancheNet(100000, "PAID", 25000), 75000);
eq("net of forfeited is 0", trancheNet(100000, "FORFEITED", 0), 0);
eq("net of fully clawed is 0", trancheNet(100000, "CLAWED_BACK", 100000), 0);
eq("net never below 0", trancheNet(100, "PAID", 250), 0);

// statusAfterClawback
const a1 = statusAfterClawback(100000, 0, 40000, "PAID");
eq("partial clawback keeps status", a1.status, "PAID");
eq("partial clawback accumulates", a1.clawed, 40000);
const a2 = statusAfterClawback(100000, 40000, 60000, "PAID");
eq("clawback reaching full -> CLAWED_BACK", a2.status, "CLAWED_BACK");
eq("full clawback clamps clawed to amount", a2.clawed, 100000);
const a3 = statusAfterClawback(100000, 0, 100000, "SCHEDULED");
eq("full clawback of scheduled -> CLAWED_BACK", a3.status, "CLAWED_BACK");

// isDueInYear
ok("scheduled due in its year", isDueInYear({ status: "SCHEDULED", scheduledYear: 2027 }, 2027));
ok("not due in another year", !isDueInYear({ status: "SCHEDULED", scheduledYear: 2028 }, 2027));
ok("paid is not due", !isDueInYear({ status: "PAID", scheduledYear: 2027 }, 2027));

// clampClawback
eq("clamp to net", clampClawback(999999, 50000), 50000);
eq("clamp keeps in-range", clampClawback(20000, 50000), 20000);
eq("clamp rejects <=0", clampClawback(-5, 50000), 0);

// round2
eq("round2 65% of 53750", round2(53750 * 0.65), 34937.5);

console.log(`bonus-ledger: ${passed}/${passed + failed} passed`);
if (failed > 0) process.exit(1);
