-- =============================================================================
-- 0030_offboarding_status_cancel.sql — WS4 follow-on (v0.41.1)
-- Widen offboarding_cases.status to allow 'CANCELLED' (a cancelled or
-- erroneously-opened exit). This is a CHECK widen on a now-POPULATED column, so
-- it self-guards: drop the old constraint, add the superset. A widen never
-- rejects an existing row, and DROP IF EXISTS + re-ADD is idempotent.
-- No new table, no new column, no new enum, no Prisma schema change (status is
-- plain text in the model; the vocabulary lives only in this CHECK).
-- =============================================================================
ALTER TABLE "offboarding_cases" DROP CONSTRAINT IF EXISTS "offboarding_cases_status_chk";
ALTER TABLE "offboarding_cases" ADD CONSTRAINT "offboarding_cases_status_chk"
  CHECK ("status" IN ('OPEN','CLEARING','CLOSED','CANCELLED'));
