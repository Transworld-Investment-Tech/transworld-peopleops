-- =============================================================================
-- 0034_widen_learning_domain_check.sql -- Widen learning_modules.domain CHECK
-- to admit the two new curriculum domains: BDV (Business Development & Sales)
-- and PPL (People Operations & HR). Brings the allowed set to all 10 domains.
--
-- The 0022 lesson: a new vocabulary value must be admitted by its CHECK in the
-- SAME release that introduces it. The original constraint (0031) was added
-- under an IF NOT EXISTS guard, so it must be DROPPED and re-ADDED to widen.
--
-- Schema only. NULL-permitting (unchanged). Idempotent. No data written.
-- Apply in the Supabase SQL Editor BEFORE running the curriculum seed.
-- Table/row counts unchanged; migrations 0033 -> 0034.
-- =============================================================================

BEGIN;

ALTER TABLE "learning_modules" DROP CONSTRAINT IF EXISTS "learning_modules_domain_check";

ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_domain_check"
  CHECK (domain IS NULL OR domain IN
    ('FND','CLA','FIN','INV','LDR','OPS','REG','TEC','BDV','PPL'));

COMMIT;
