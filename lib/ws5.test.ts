import assert from "node:assert";
import {
  retentionMonthsFor,
  expiresAt,
  addWorkingDays,
  approvalPermForStage,
  approverRoleForStage,
  isActiveSanction,
  stageLabel,
} from "./ws5";

let pass = 0;
function t(name: string, fn: () => void) {
  fn();
  pass += 1;
  // eslint-disable-next-line no-console
  console.log("ok -", name);
}

t("retention by stage (non-regulatory)", () => {
  assert.equal(retentionMonthsFor("VERBAL_WARNING", false), 12);
  assert.equal(retentionMonthsFor("WRITTEN_WARNING", false), 18);
  assert.equal(retentionMonthsFor("FINAL_WRITTEN_WARNING", false), 24);
  assert.equal(retentionMonthsFor("INFORMAL_DISCUSSION", false), null);
  assert.equal(retentionMonthsFor("DISMISSAL", false), null);
});

t("regulatory final warning is permanent", () => {
  assert.equal(retentionMonthsFor("FINAL_WRITTEN_WARNING", true), null);
});

t("expiresAt adds months; permanent => null", () => {
  const issued = new Date("2026-01-15T00:00:00.000Z");
  const e = expiresAt(issued, 18);
  assert.ok(e);
  assert.equal(e!.toISOString().slice(0, 10), "2027-07-15");
  assert.equal(expiresAt(issued, null), null);
});

t("addWorkingDays skips weekends", () => {
  // Fri 2026-06-05 + 2 working days => Tue 2026-06-09
  const fri = new Date("2026-06-05T00:00:00.000Z");
  assert.equal(addWorkingDays(fri, 2).toISOString().slice(0, 10), "2026-06-09");
  // + 15 working days
  assert.equal(addWorkingDays(fri, 15).toISOString().slice(0, 10), "2026-06-26");
});

t("approval perm + role per stage", () => {
  assert.equal(approvalPermForStage("INFORMAL_DISCUSSION"), null);
  assert.equal(approvalPermForStage("VERBAL_WARNING"), "discipline.approve");
  assert.equal(approvalPermForStage("WRITTEN_WARNING"), "discipline.approve");
  assert.equal(approvalPermForStage("FINAL_WRITTEN_WARNING"), "discipline.dismiss");
  assert.equal(approvalPermForStage("DISMISSAL"), "discipline.dismiss");
  assert.equal(approverRoleForStage("WRITTEN_WARNING"), "COO");
  assert.equal(approverRoleForStage("DISMISSAL"), "CHAIRMAN");
  assert.equal(approverRoleForStage("INFORMAL_DISCUSSION"), null);
});

t("isActiveSanction: dated vs permanent", () => {
  const asOf = new Date("2026-06-04T00:00:00.000Z");
  assert.equal(isActiveSanction(new Date("2026-12-01"), asOf), true);
  assert.equal(isActiveSanction(new Date("2026-01-01"), asOf), false);
  assert.equal(isActiveSanction(null, asOf), true); // permanent regulatory
});

t("stageLabel", () => {
  assert.equal(stageLabel("FINAL_WRITTEN_WARNING"), "Final written warning");
  assert.equal(stageLabel(null), "—");
});

// eslint-disable-next-line no-console
console.log(`\n${pass}/${pass} WS5 engine tests passed.`);
