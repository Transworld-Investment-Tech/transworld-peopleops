#!/usr/bin/env node
// patch_canonical_matrix_bdv.cjs (v0.67.0)
// Idempotent, fail-loud patch of supabase/seed/seed_ws7_role_matrix.sql:
// appends the 20 BDV-2xx rows to the canonical `want` VALUES list so a future
// full reseed carries them (the live deploy uses seed_bdv2xx_role_matrix.sql).
// Usage: node patch_canonical_matrix_bdv.cjs /path/to/transworld-peopleops
const fs = require("fs");
const path = require("path");
const repo = process.argv[2];
if (!repo) { console.error("Usage: node patch_canonical_matrix_bdv.cjs <repo path>"); process.exit(1); }
if (repo.includes("transworld-portal")) { console.error("Refusing: wrong repo (transworld-portal)"); process.exit(1); }
const f = path.join(repo, "supabase", "seed", "seed_ws7_role_matrix.sql");
if (!fs.existsSync(f)) { console.error("Not found: " + f); process.exit(1); }
let s = fs.readFileSync(f, "utf8");

const ROWS = [
  ["jp_bd_officer","BDV-201","REQUIRED"],["jp_bd_officer","BDV-202","REQUIRED"],
  ["jp_bd_officer","BDV-203","REQUIRED"],["jp_bd_officer","BDV-204","REQUIRED"],
  ["jp_bd_officer","BDV-205","REQUIRED"],
  ["jp_marketing_comms","BDV-201","RECOMMENDED"],["jp_marketing_comms","BDV-202","REQUIRED"],
  ["jp_marketing_comms","BDV-203","RECOMMENDED"],["jp_marketing_comms","BDV-204","RECOMMENDED"],
  ["jp_marketing_comms","BDV-205","REQUIRED"],
  ["cmpssxs6s0005vbm1fupr2cez","BDV-201","REQUIRED"],["cmpssxs6s0005vbm1fupr2cez","BDV-202","RECOMMENDED"],
  ["cmpssxs6s0005vbm1fupr2cez","BDV-203","RECOMMENDED"],["cmpssxs6s0005vbm1fupr2cez","BDV-204","RECOMMENDED"],
  ["cmpssxs6s0005vbm1fupr2cez","BDV-205","REQUIRED"],
  ["cmpssxrl40004vbm1rkcnkjy7","BDV-201","RECOMMENDED"],["cmpssxrl40004vbm1rkcnkjy7","BDV-202","RECOMMENDED"],
  ["cmpssxrl40004vbm1rkcnkjy7","BDV-203","RECOMMENDED"],["cmpssxrl40004vbm1rkcnkjy7","BDV-204","RECOMMENDED"],
  ["cmpssxrl40004vbm1rkcnkjy7","BDV-205","REQUIRED"],
];

if (s.includes("'jp_bd_officer', 'BDV-205'")) {
  console.log("No-op: BDV-2xx rows already present in canonical matrix.");
  process.exit(0);
}
const ANCHOR = "  ('jp_peopleops_officer', 'PPL-208', 'REQUIRED')\n)";
const n = s.split(ANCHOR).length - 1;
if (n !== 1) { console.error("Anchor found " + n + " times (expected 1); aborting."); process.exit(1); }
const block = ROWS.map(r => "  ('" + r[0] + "', '" + r[1] + "', '" + r[2] + "')").join(",\n");
const replacement = "  ('jp_peopleops_officer', 'PPL-208', 'REQUIRED'),\n" + block + "\n)";
s = s.replace(ANCHOR, replacement);
// additive note on the Expected comment, if present
s = s.replace(
  "-- Expected: up to 8 profiles + 172 rules (147 required, 25 recommended) on first run.",
  "-- Expected: up to 8 profiles + 172 rules (147 required, 25 recommended) on first run.\n-- v0.67.0: + BDV-2xx => +20 rules (10 required, 10 recommended) across 4 profiles."
);
fs.writeFileSync(f, s);
console.log("Patched canonical matrix: +20 BDV-2xx rows appended to want list.");
