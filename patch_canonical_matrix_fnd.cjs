#!/usr/bin/env node
/* patch_canonical_matrix_fnd.cjs — P9 v0.69.0
 * Folds the 20 FND-2xx rows (14 REQUIRED / 6 RECOMMENDED, 11 profiles) into the
 * canonical seed_ws7_role_matrix.sql want-list, immediately after the BDV-2xx block
 * added by v0.67.0. Idempotent and fail-loud.
 *
 * Usage: node patch_canonical_matrix_fnd.cjs ~/transworld-peopleops/supabase/seed/seed_ws7_role_matrix.sql
 */
const fs = require("fs");

const file = process.argv[2];
if (!file) {
  console.error("FAIL: pass the path to seed_ws7_role_matrix.sql as the first argument");
  process.exit(1);
}
if (!fs.existsSync(file)) {
  console.error(`FAIL: file not found: ${file}`);
  process.exit(1);
}
let text = fs.readFileSync(file, "utf8");

const ROWS = [
  ["cmpssxs6s0005vbm1fupr2cez", "FND-201", "REQUIRED"],
  ["cmpssxtep0007vbm1jdkgdk5a", "FND-201", "REQUIRED"],
  ["jp_procurement_officer", "FND-201", "REQUIRED"],
  ["jp_marketing_comms", "FND-201", "REQUIRED"],
  ["jp_accounting_officer", "FND-201", "REQUIRED"],
  ["jp_finance_officer", "FND-201", "REQUIRED"],
  ["jp_bd_officer", "FND-201", "REQUIRED"],
  ["cmpssxssk0006vbm115c0xb73", "FND-201", "RECOMMENDED"],
  ["jp_office_admin", "FND-201", "RECOMMENDED"],
  ["cmpssxs6s0005vbm1fupr2cez", "FND-202", "REQUIRED"],
  ["cmpssxtep0007vbm1jdkgdk5a", "FND-202", "REQUIRED"],
  ["cmpssxssk0006vbm115c0xb73", "FND-202", "REQUIRED"],
  ["jp_inv_associate", "FND-202", "REQUIRED"],
  ["jp_bd_officer", "FND-202", "REQUIRED"],
  ["jp_marketing_comms", "FND-202", "REQUIRED"],
  ["jp_peopleops_officer", "FND-202", "REQUIRED"],
  ["jp_procurement_officer", "FND-202", "RECOMMENDED"],
  ["jp_accounting_officer", "FND-202", "RECOMMENDED"],
  ["jp_finance_officer", "FND-202", "RECOMMENDED"],
  ["jp_office_admin", "FND-202", "RECOMMENDED"],
];

// Idempotency: fully patched -> exit 0; partially patched -> fail loud.
const present = ROWS.filter(
  ([jp, code, req]) => text.includes(`('${jp}', '${code}', '${req}')`)
).length;
if (present === ROWS.length) {
  console.log("Already patched: all 20 FND-2xx rows present. No changes made.");
  process.exit(0);
}
if (present > 0) {
  console.error(`FAIL: ${present}/20 FND-2xx rows already present (partial state). Inspect the file manually.`);
  process.exit(1);
}
if (text.includes("'FND-201'") || text.includes("'FND-202'")) {
  console.error("FAIL: FND-201/FND-202 appear in the file but not in the expected row format. Inspect manually.");
  process.exit(1);
}

// Structural guard: the want-list header must exist.
if (!/WITH want \(job_profile_id, code, requirement\) AS \(/.test(text)) {
  console.error("FAIL: want-list header not found; file structure differs from the verified layout.");
  process.exit(1);
}

// Anchor: the final BDV tuple (last row of the v0.67.0 block, no trailing comma).
const ANCHOR = "('cmpssxrl40004vbm1rkcnkjy7', 'BDV-205', 'REQUIRED')";
const first = text.indexOf(ANCHOR);
if (first === -1) {
  console.error("FAIL: BDV-205 anchor row not found; cannot locate insertion point.");
  process.exit(1);
}
if (text.indexOf(ANCHOR, first + 1) !== -1) {
  console.error("FAIL: BDV-205 anchor row appears more than once; refusing to guess.");
  process.exit(1);
}

const indent = "  ";
const block = ROWS.map(([jp, code, req]) => `${indent}('${jp}', '${code}', '${req}')`);
const insertion = ANCHOR + ",\n" + block.join(",\n");
text = text.replace(ANCHOR, insertion);

// Changelog: append the v0.69.0 line directly after the v0.67.0 entry.
const CHANGELOG_ANCHOR = /(-- v0\.67\.0: \+ BDV-2xx => \+20 rules.*)/;
const CHANGELOG_LINE = "-- v0.69.0: + FND-2xx => +20 rules (14 required, 6 recommended) across 11 profiles.";
if (CHANGELOG_ANCHOR.test(text)) {
  text = text.replace(CHANGELOG_ANCHOR, `$1\n${CHANGELOG_LINE}`);
} else {
  text = text.trimEnd() + "\n" + CHANGELOG_LINE + "\n";
}

// Post-checks before writing.
const fnd201 = (text.match(/'FND-201'/g) || []).length;
const fnd202 = (text.match(/'FND-202'/g) || []).length;
if (fnd201 !== 9 || fnd202 !== 11) {
  console.error(`FAIL: post-check expected 9 x FND-201 and 11 x FND-202 rows, found ${fnd201}/${fnd202}. Nothing written.`);
  process.exit(1);
}
const badJoin = /\)\s*\(\s*'/.test(text.replace(/\n/g, " "));
if (badJoin) {
  console.error("FAIL: post-check found adjacent tuples without a comma. Nothing written.");
  process.exit(1);
}

fs.writeFileSync(file, text);
console.log(`Patched ${file}: +20 FND-2xx rows after the BDV block; changelog updated.`);
