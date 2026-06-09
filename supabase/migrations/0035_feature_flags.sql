-- =============================================================================
-- 0035_feature_flags.sql -- Super-Admin feature-flag switch table (v0.66.0).
-- Backs the My Pay soft-launch toggle: a flag with no row, or enabled=false,
-- hides the feature; the app read layer defaults every flag OFF.
--
-- The 0022 lesson: `key` is bounded by a CHECK; widen it in the SAME release
-- that introduces a new flag key. The constraint is DROP + re-ADD so a re-run
-- (or a future widening) is clean.
--
-- Schema only. Idempotent. No data written here (the my_pay row is seeded by
-- supabase/seed/seed_feature_flags.sql). Apply in the Supabase SQL Editor
-- BEFORE pushing the v0.66.0 code. Migrations 0034 -> 0035.
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS "feature_flags" (
  "key"        text PRIMARY KEY,
  "enabled"    boolean NOT NULL DEFAULT false,
  "updated_by" text,
  "updated_at" timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE "feature_flags" DROP CONSTRAINT IF EXISTS "feature_flags_key_check";

ALTER TABLE "feature_flags" ADD CONSTRAINT "feature_flags_key_check"
  CHECK ("key" IN ('my_pay'));

COMMIT;
