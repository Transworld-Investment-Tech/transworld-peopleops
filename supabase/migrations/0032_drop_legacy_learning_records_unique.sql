-- =============================================================================
-- 0032_drop_legacy_learning_records_unique.sql  (v0.43.1)
-- Fixes the WS7 recurrence regression. The original learning_records unique was
-- created in 0005 under a hand-written name (learning_records_module_employee_key)
-- on (module_id, employee_id). The 0031 swap tried to drop the *Prisma-default*
-- name (learning_records_module_id_employee_id_key), which never existed here, so
-- the old 2-column unique survived and forbade more than one period per
-- (module, employee) — making a knowledge-check submit for a new period raise a
-- unique violation (the production 500). This drops the stray constraint by its
-- real name. Idempotent; safe to re-run. The correct 3-column unique
-- (learning_records_module_id_employee_id_period_key) from 0031 is left intact.
-- Run BEFORE the push. Already applied by hand in production on 2026-06-05;
-- carried here so a fresh rebuild matches production.
-- =============================================================================
BEGIN;

ALTER TABLE "learning_records"
  DROP CONSTRAINT IF EXISTS "learning_records_module_employee_key";

COMMIT;
