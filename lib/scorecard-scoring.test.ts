// lib/scorecard-scoring.test.ts — pure unit tests. Run: npm run scorecard:test
import { parseRating, dimensionAverage, multiplierFor, scoreAppraisal } from "./scorecard-scoring";

let passed = 0;
let failed = 0;
function ok(name: string, cond: boolean) {
  if (cond) passed++;
  else { failed++; console.error(`  \u2717 ${name}`); }
}
function eq(name: string, a: number | null, b: number | null, tol = 0.001) {
  ok(`${name} (got ${a}, want ${b})`, a === b || (a !== null && b !== null && Math.abs(a - b) <= tol));
}

// parseRating
eq("parse '4'", parseRating("4"), 4);
eq("parse 5", parseRating(5), 5);
eq("parse empty -> null", parseRating(""), null);
eq("parse 0 -> null (out of range)", parseRating(0), null);
eq("parse 6 -> null", parseRating("6"), null);

// dimensionAverage: weighted
eq("dim simple avg", dimensionAverage([{ kind: "X", rating: "4" }, { kind: "X", rating: "2" }]), 3);
eq("dim weighted avg", dimensionAverage([{ kind: "X", rating: 5, weight: 3 }, { kind: "X", rating: 1, weight: 1 }]), 4); // (15+1)/4
eq("dim skips unrated", dimensionAverage([{ kind: "X", rating: "4" }, { kind: "X", rating: null }]), 4);
eq("dim none rated -> null", dimensionAverage([{ kind: "X", rating: null }]), null);

// multiplierFor bands
eq("band 4.7 -> 1.3", multiplierFor(4.7), 1.3);
eq("band 4.2 -> 1.15", multiplierFor(4.2), 1.15);
eq("band 3.7 -> 1.0", multiplierFor(3.7), 1.0);
eq("band 3.2 -> 0.8", multiplierFor(3.2), 0.8);
eq("band 2.5 -> 0.5", multiplierFor(2.5), 0.5);
eq("band 1.5 -> 0.0", multiplierFor(1.5), 0.0);

// scoreAppraisal: Investments family (50/25/25)
const inv = scoreAppraisal(
  [
    { kind: "OUTCOME", rating: "4" },
    { kind: "OUTCOME", rating: "4" },
    { kind: "COMPETENCY", rating: "5" },
    { kind: "BEHAVIOR", rating: "4", label: "Integrity Above All" },
    { kind: "BEHAVIOR", rating: "4", label: "Mastery & Growth" },
  ],
  "INVESTMENTS",
);
// results 4, competencies 5, behaviors 4 -> 0.5*4 + 0.25*5 + 0.25*4 = 2 + 1.25 + 1 = 4.25
eq("investments overall", inv.overall, 4.25);
eq("investments multiplier (4.25 -> 1.15)", inv.multiplier, 1.15);
ok("investments no gate", inv.integrityGate === false);

// Leadership family (55/20/25)
const lead = scoreAppraisal(
  [
    { kind: "OUTCOME", rating: "5" },
    { kind: "COMPETENCY", rating: "3" },
    { kind: "BEHAVIOR", rating: "4", label: "Lifting Others" },
  ],
  "LEADERSHIP",
);
// 0.55*5 + 0.20*3 + 0.25*4 = 2.75 + 0.6 + 1.0 = 4.35 -> 1.15
eq("leadership overall", lead.overall, 4.35);
eq("leadership multiplier", lead.multiplier, 1.15);

// Integrity gate forces 0 regardless of strong scores
const gated = scoreAppraisal(
  [
    { kind: "OUTCOME", rating: "5" },
    { kind: "COMPETENCY", rating: "5" },
    { kind: "BEHAVIOR", rating: "1", label: "Compliance by Default" },
  ],
  "INVESTMENTS",
);
eq("gated multiplier -> 0", gated.multiplier, 0);
ok("gate flagged", gated.integrityGate === true);

// Missing dimension renormalizes (no competencies rated)
const noComp = scoreAppraisal(
  [
    { kind: "OUTCOME", rating: "4" },
    { kind: "BEHAVIOR", rating: "4", label: "Ownership Mentality" },
  ],
  "INVESTMENTS",
);
// results 4 (w .5), behaviors 4 (w .25) -> renormalized over .75 -> 4.0
eq("renormalized overall", noComp.overall, 4.0);
eq("renormalized multiplier", noComp.multiplier, 1.15);

// No rated items -> neutral 1.0, no gate
const empty = scoreAppraisal([{ kind: "OUTCOME", rating: null }], "INVESTMENTS");
eq("empty overall null", empty.overall, null);
eq("empty multiplier neutral", empty.multiplier, 1.0);

// RESULT kind also counts as Results
const rk = scoreAppraisal([{ kind: "RESULT", rating: "3" }], "INVESTMENTS");
eq("RESULT kind counted", rk.overall, 3);
eq("RESULT multiplier", rk.multiplier, 0.8);

const total = passed + failed;
if (failed === 0) { console.log(`scorecard scoring: ${passed}/${total} checks passed`); process.exit(0); }
else { console.error(`scorecard scoring: ${passed}/${total} passed, ${failed} FAILED`); process.exit(1); }
