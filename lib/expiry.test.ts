import assert from "node:assert";
import {
  daysUntil,
  expiryBucket,
  severityForExpiry,
  gapSeverity,
  dedupeKeyForExpiry,
  dedupeKeyForGap,
  severityBadge,
  categoryLabel,
  expiryPhrase,
  NOTIFICATION_CATEGORIES,
  SEVERITIES,
  NOTIFICATION_STATUSES,
} from "./expiry";

let pass = 0;
function t(name: string, fn: () => void) {
  fn();
  pass += 1;
  // eslint-disable-next-line no-console
  console.log("ok -", name);
}

const NOW = new Date("2026-06-04T09:00:00.000Z");

t("vocab constants", () => {
  assert.ok(NOTIFICATION_CATEGORIES.includes("DOC_EXPIRY"));
  assert.ok(NOTIFICATION_CATEGORIES.includes("STAFF_FILE_GAP"));
  assert.deepEqual([...SEVERITIES], ["INFO", "WARNING", "CRITICAL"]);
  assert.deepEqual([...NOTIFICATION_STATUSES], ["OPEN", "DISMISSED", "RESOLVED"]);
});

t("daysUntil counts whole calendar days", () => {
  assert.equal(daysUntil(new Date("2026-06-04T23:00:00Z"), NOW), 0);
  assert.equal(daysUntil(new Date("2026-06-05T01:00:00Z"), NOW), 1);
  assert.equal(daysUntil(new Date("2026-06-03T23:00:00Z"), NOW), -1);
  assert.equal(daysUntil(new Date("2026-09-02T00:00:00Z"), NOW), 90);
  assert.equal(daysUntil(new Date("2026-07-04T00:00:00Z"), NOW), 30);
});

t("expiryBucket thresholds", () => {
  assert.equal(expiryBucket(-1), "EXPIRED");
  assert.equal(expiryBucket(0), "30");
  assert.equal(expiryBucket(30), "30");
  assert.equal(expiryBucket(31), "90");
  assert.equal(expiryBucket(90), "90");
  assert.equal(expiryBucket(91), null);
  assert.equal(expiryBucket(365), null);
});

t("severityForExpiry mapping", () => {
  assert.equal(severityForExpiry("EXPIRED"), "CRITICAL");
  assert.equal(severityForExpiry("30"), "WARNING");
  assert.equal(severityForExpiry("90"), "INFO");
});

t("gapSeverity", () => {
  assert.equal(gapSeverity(0), "CRITICAL");
  assert.equal(gapSeverity(49), "CRITICAL");
  assert.equal(gapSeverity(50), "WARNING");
  assert.equal(gapSeverity(89), "WARNING");
});

t("dedupe keys are stable + bucket-scoped", () => {
  assert.equal(dedupeKeyForExpiry("doc1", "30"), "exp:doc1:30");
  assert.equal(dedupeKeyForExpiry("doc1", "EXPIRED"), "exp:doc1:EXPIRED");
  assert.notEqual(dedupeKeyForExpiry("doc1", "30"), dedupeKeyForExpiry("doc1", "90"));
  assert.equal(dedupeKeyForGap("emp9"), "gap:emp9");
});

t("badges + labels", () => {
  assert.equal(severityBadge("CRITICAL").cls, "b-red");
  assert.equal(severityBadge("WARNING").cls, "b-amb");
  assert.equal(severityBadge("INFO").cls, "b-blu");
  assert.equal(categoryLabel("DOC_EXPIRY"), "Document expiry");
  assert.equal(categoryLabel("STAFF_FILE_GAP"), "Staff-file gap");
});

t("expiryPhrase reads naturally", () => {
  assert.equal(expiryPhrase(0), "expires today");
  assert.equal(expiryPhrase(1), "expires in 1 day");
  assert.equal(expiryPhrase(14), "expires in 14 days");
  assert.equal(expiryPhrase(-1), "expired 1 day ago");
  assert.equal(expiryPhrase(-5), "expired 5 days ago");
});

// eslint-disable-next-line no-console
console.log(`\n${pass} expiry engine tests passed.`);
