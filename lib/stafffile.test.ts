import assert from "node:assert";
import {
  STAFF_FILE_SLOTS,
  SLOT_META,
  slotLabel,
  gradeRank,
  isG2Plus,
  requiredSlotsFor,
  computeCompleteness,
  completenessBadge,
  averagePct,
  DEFAULT_THRESHOLD_PCT,
  type EmployeeFacts,
} from "./stafffile";

let pass = 0;
function t(name: string, fn: () => void) {
  fn();
  pass += 1;
  // eslint-disable-next-line no-console
  console.log("ok -", name);
}

const ALL = new Set(STAFF_FILE_SLOTS as readonly string[]);

t("catalog has all 16 D6.2 slots with metadata", () => {
  assert.equal(STAFF_FILE_SLOTS.length, 16);
  for (const s of STAFF_FILE_SLOTS) assert.ok(SLOT_META[s].label.length > 0);
});

t("gradeRank / isG2Plus", () => {
  assert.equal(gradeRank("G0"), 0);
  assert.equal(gradeRank("G5"), 5);
  assert.equal(gradeRank("PT"), -1);
  assert.equal(gradeRank(null), -1);
  assert.equal(isG2Plus("G1"), false);
  assert.equal(isG2Plus("G2"), true);
  assert.equal(isG2Plus("G4"), true);
  assert.equal(isG2Plus("PT"), false);
});

t("slotLabel falls back to the key", () => {
  assert.equal(slotLabel("CONTRACT"), "Signed employment contract");
  assert.equal(slotLabel("NOPE"), "NOPE");
});

t("G1 active non-regulated: core 'ALL' slots, no quals/SEC/exit", () => {
  const f: EmployeeFacts = { grade: "G1", isRegulated: false, status: "ACTIVE", hasCaseRecords: false };
  const req = new Set(requiredSlotsFor(f));
  // ALL slots present
  for (const s of ["CONTRACT","OFFER_LETTER","ID_VERIFIED","RIGHT_TO_WORK","GUARANTOR",
                   "CRIMINAL_CHECK","HANDBOOK_ACK","PAD_ACK","CONFIDENTIALITY_ACK"]) {
    assert.ok(req.has(s as never), `expected ${s} required`);
  }
  // confirmed -> probation forms + perf reviews required
  assert.ok(req.has("PROBATION_MIDPOINT" as never));
  assert.ok(req.has("PROBATION_OUTCOME" as never));
  assert.ok(req.has("PERF_REVIEWS" as never));
  // not G2+ and not regulated -> no quals / SEC
  assert.ok(!req.has("QUALIFICATIONS" as never));
  assert.ok(!req.has("SEC_NGX_REG" as never));
  // not exited, no case records
  assert.ok(!req.has("EXIT_DOCS" as never));
  assert.ok(!req.has("CASE_RECORDS" as never));
});

t("G3 active: qualifications required (G2+), still no SEC unless regulated", () => {
  const f: EmployeeFacts = { grade: "G3", isRegulated: false, status: "ACTIVE", hasCaseRecords: false };
  const req = new Set(requiredSlotsFor(f));
  assert.ok(req.has("QUALIFICATIONS" as never));
  assert.ok(!req.has("SEC_NGX_REG" as never));
});

t("regulated G1: qualifications AND SEC/NGX required", () => {
  const f: EmployeeFacts = { grade: "G1", isRegulated: true, status: "ACTIVE", hasCaseRecords: false };
  const req = new Set(requiredSlotsFor(f));
  assert.ok(req.has("QUALIFICATIONS" as never));
  assert.ok(req.has("SEC_NGX_REG" as never));
});

t("current PROBATION: probation forms + perf reviews NOT yet required", () => {
  const f: EmployeeFacts = { grade: "G1", isRegulated: false, status: "PROBATION", hasCaseRecords: false };
  const req = new Set(requiredSlotsFor(f));
  assert.ok(!req.has("PROBATION_MIDPOINT" as never));
  assert.ok(!req.has("PROBATION_OUTCOME" as never));
  assert.ok(!req.has("PERF_REVIEWS" as never));
  // but the engagement core is still required
  assert.ok(req.has("CONTRACT" as never));
});

t("EXITED: exit docs required, probation forms required, perf reviews not", () => {
  const f: EmployeeFacts = { grade: "G2", isRegulated: false, status: "EXITED", hasCaseRecords: false };
  const req = new Set(requiredSlotsFor(f));
  assert.ok(req.has("EXIT_DOCS" as never));
  assert.ok(req.has("PROBATION_MIDPOINT" as never)); // post-probation includes exited
  assert.ok(!req.has("PERF_REVIEWS" as never)); // confirmed-only
});

t("CASE_RECORDS only when hasCaseRecords", () => {
  const base: EmployeeFacts = { grade: "G1", isRegulated: false, status: "ACTIVE", hasCaseRecords: false };
  assert.ok(!requiredSlotsFor(base).includes("CASE_RECORDS"));
  assert.ok(requiredSlotsFor({ ...base, hasCaseRecords: true }).includes("CASE_RECORDS"));
});

t("completeness math: empty file = 0%", () => {
  const f: EmployeeFacts = { grade: "G1", isRegulated: false, status: "ACTIVE", hasCaseRecords: false };
  const c = computeCompleteness(f, new Set<string>());
  assert.equal(c.satisfiedCount, 0);
  assert.equal(c.pct, 0);
  assert.equal(c.complete, false);
  assert.equal(c.missing.length, c.requiredCount);
});

t("completeness math: full file = 100% complete", () => {
  const f: EmployeeFacts = { grade: "G3", isRegulated: true, status: "ACTIVE", hasCaseRecords: true };
  const c = computeCompleteness(f, ALL);
  assert.equal(c.pct, 100);
  assert.equal(c.complete, true);
  assert.equal(c.missing.length, 0);
});

t("completeness math: rounding + threshold", () => {
  const f: EmployeeFacts = { grade: "G1", isRegulated: false, status: "ACTIVE", hasCaseRecords: false };
  const req = requiredSlotsFor(f);
  // satisfy all but one
  const sat = new Set<string>(req.slice(0, req.length - 1));
  const c = computeCompleteness(f, sat);
  const expected = Math.round(((req.length - 1) / req.length) * 100);
  assert.equal(c.pct, expected);
  assert.equal(c.complete, expected >= DEFAULT_THRESHOLD_PCT);
});

t("badge tone tracks threshold", () => {
  assert.equal(completenessBadge(95).cls, "b-grn");
  assert.equal(completenessBadge(70).cls, "b-amb");
  assert.equal(completenessBadge(20).cls, "b-red");
});

t("averagePct two-decimal mean", () => {
  assert.equal(averagePct([]), 0);
  assert.equal(averagePct([100, 0]), 50);
  assert.equal(averagePct([100, 50, 0]), 50);
  assert.equal(averagePct([33, 33, 34]), 33.33);
});

// eslint-disable-next-line no-console
console.log(`\n${pass} staff-file engine tests passed.`);
