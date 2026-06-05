-- =============================================================================
-- 0031_ws7_lms.sql — WS7 full LMS (v0.42.0)
--
-- Deepens the Learning spine into a real learning system:
--   1. learning_modules  += catalog fields (code/domain/level/is_mandatory/
--      cadence/owner/pass_mark) and a widened status CHECK (adds ARCHIVED).
--   2. learning_assignment_rules (NEW) — the role/grade assignment matrix.
--   3. learning_quiz_questions   (NEW) — the gradable knowledge-check bank.
--   4. learning_records  += recurrence (period) + evidence/attestation + waiver
--      audit + graded-check result columns, and the unique key swaps from
--      (module_id, employee_id) to (module_id, employee_id, period).
--
-- Conventions: no new Postgres enums (all CHECK-constrained text + two jsonb);
-- cross-refs to EXISTING tables are bare FK constraints (no Prisma @relation);
-- idempotent (IF NOT EXISTS / guarded DO blocks). learning_records is POPULATED,
-- so its new CHECK + unique swap are self-guarded (backfill first, then swap).
-- Run BEFORE the push.
-- =============================================================================

BEGIN;

-- ── 1. learning_modules: catalog fields ──────────────────────────────────────
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "code"         TEXT;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "domain"       TEXT;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "level"        TEXT;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "is_mandatory" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "cadence"      TEXT;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "owner"        TEXT;
ALTER TABLE "learning_modules" ADD COLUMN IF NOT EXISTS "pass_mark"    INTEGER;

-- widen status CHECK to add ARCHIVED (drop old, add new)
ALTER TABLE "learning_modules" DROP CONSTRAINT IF EXISTS "learning_modules_status_check";
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_status_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_status_check"
      CHECK (status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED'));
  END IF;
END $$;

-- new value-vocabulary CHECKs (all NULL-permitting; existing rows are NULL)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_domain_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_domain_check"
      CHECK (domain IS NULL OR domain IN ('FND','CLA','FIN','INV','LDR','OPS','REG','TEC'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_level_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_level_check"
      CHECK (level IS NULL OR level IN ('F','P','E'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_cadence_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_cadence_check"
      CHECK (cadence IS NULL OR cadence IN ('ON_JOIN','ANNUAL','ON_JOIN_ANNUAL','PERIODIC','ON_RENEWAL'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_owner_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_owner_check"
      CHECK (owner IS NULL OR owner IN ('CCO','PEOPLE_OPS','FUNCTION_HEAD'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_modules_pass_mark_check') THEN
    ALTER TABLE "learning_modules" ADD CONSTRAINT "learning_modules_pass_mark_check"
      CHECK (pass_mark IS NULL OR (pass_mark >= 0 AND pass_mark <= 100));
  END IF;
END $$;

-- unique module code where set (partial unique index; tolerates many NULLs)
CREATE UNIQUE INDEX IF NOT EXISTS "learning_modules_code_key"
  ON "learning_modules" ("code") WHERE "code" IS NOT NULL;

-- ── 2. learning_assignment_rules (NEW) — the role/grade matrix ────────────────
CREATE TABLE IF NOT EXISTS "learning_assignment_rules" (
  "id"             TEXT PRIMARY KEY,
  "module_id"      TEXT NOT NULL,
  "scope"          TEXT NOT NULL,
  "grade"          TEXT,
  "job_profile_id" TEXT,
  "requirement"    TEXT NOT NULL,
  "active"         BOOLEAN NOT NULL DEFAULT true,
  "created_by_id"  TEXT,
  "created_at"     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "learning_assignment_rules_scope_check"
    CHECK (scope IN ('ALL','GRADE','JOB_PROFILE')),
  CONSTRAINT "learning_assignment_rules_grade_check"
    CHECK (grade IS NULL OR grade IN ('G0','G1','G2','G3','G4','G5','PT')),
  CONSTRAINT "learning_assignment_rules_requirement_check"
    CHECK (requirement IN ('REQUIRED','RECOMMENDED')),
  CONSTRAINT "learning_assignment_rules_scope_target_check"
    CHECK (
      (scope = 'ALL'         AND grade IS NULL AND job_profile_id IS NULL) OR
      (scope = 'GRADE'       AND grade IS NOT NULL) OR
      (scope = 'JOB_PROFILE' AND job_profile_id IS NOT NULL)
    )
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_assignment_rules_module_id_fkey') THEN
    ALTER TABLE "learning_assignment_rules" ADD CONSTRAINT "learning_assignment_rules_module_id_fkey"
      FOREIGN KEY ("module_id") REFERENCES "learning_modules"("id") ON DELETE CASCADE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_assignment_rules_job_profile_id_fkey') THEN
    ALTER TABLE "learning_assignment_rules" ADD CONSTRAINT "learning_assignment_rules_job_profile_id_fkey"
      FOREIGN KEY ("job_profile_id") REFERENCES "job_profiles"("id") ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_assignment_rules_created_by_id_fkey') THEN
    ALTER TABLE "learning_assignment_rules" ADD CONSTRAINT "learning_assignment_rules_created_by_id_fkey"
      FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL;
  END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS "learning_assignment_rules_target_key"
  ON "learning_assignment_rules" ("module_id", "scope", COALESCE("grade", ''), COALESCE("job_profile_id", ''));
CREATE INDEX IF NOT EXISTS "learning_assignment_rules_module_idx" ON "learning_assignment_rules" ("module_id");
CREATE INDEX IF NOT EXISTS "learning_assignment_rules_scope_idx"  ON "learning_assignment_rules" ("scope");

-- ── 3. learning_quiz_questions (NEW) — the gradable knowledge-check bank ──────
CREATE TABLE IF NOT EXISTS "learning_quiz_questions" (
  "id"          TEXT PRIMARY KEY,
  "module_id"   TEXT NOT NULL,
  "prompt"      TEXT NOT NULL,
  "type"        TEXT NOT NULL,
  "options"     JSONB NOT NULL,
  "correct"     JSONB NOT NULL,
  "explanation" TEXT,
  "sort_order"  INTEGER NOT NULL DEFAULT 0,
  "active"      BOOLEAN NOT NULL DEFAULT true,
  "created_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "learning_quiz_questions_type_check"
    CHECK (type IN ('SINGLE','MULTI','TRUE_FALSE'))
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_quiz_questions_module_id_fkey') THEN
    ALTER TABLE "learning_quiz_questions" ADD CONSTRAINT "learning_quiz_questions_module_id_fkey"
      FOREIGN KEY ("module_id") REFERENCES "learning_modules"("id") ON DELETE CASCADE;
  END IF;
END $$;
CREATE INDEX IF NOT EXISTS "learning_quiz_questions_module_idx" ON "learning_quiz_questions" ("module_id");

-- ── 4. learning_records: recurrence + evidence + graded result (POPULATED) ───
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "period"          TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "rule_id"         TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "evidence_doc_id" TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "evidence_note"   TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "attested_by_id"  TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "attested_at"     TIMESTAMP(3);
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "waived_by_id"    TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "waived_reason"   TEXT;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "waived_at"       TIMESTAMP(3);
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "passed"          BOOLEAN;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "attempt_count"   INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "learning_records" ADD COLUMN IF NOT EXISTS "last_attempt_at" TIMESTAMP(3);

-- backfill recurrence key on existing rows, then make it NOT NULL + CHECK
UPDATE "learning_records" SET "period" = 'JOIN' WHERE "period" IS NULL;
ALTER TABLE "learning_records" ALTER COLUMN "period" SET DEFAULT 'JOIN';
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'learning_records' AND column_name = 'period' AND is_nullable = 'YES') THEN
    ALTER TABLE "learning_records" ALTER COLUMN "period" SET NOT NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_period_check') THEN
    ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_period_check"
      CHECK (period = 'JOIN' OR period ~ '^[0-9]{4}$');
  END IF;
END $$;

-- self-guarded unique swap: (module_id, employee_id) -> (module_id, employee_id, period)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_module_id_employee_id_key') THEN
    ALTER TABLE "learning_records" DROP CONSTRAINT "learning_records_module_id_employee_id_key";
  END IF;
END $$;
CREATE UNIQUE INDEX IF NOT EXISTS "learning_records_module_id_employee_id_period_key"
  ON "learning_records" ("module_id", "employee_id", "period");

-- bare FKs for the new reference columns
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_rule_id_fkey') THEN
    ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_rule_id_fkey"
      FOREIGN KEY ("rule_id") REFERENCES "learning_assignment_rules"("id") ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_evidence_doc_id_fkey') THEN
    ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_evidence_doc_id_fkey"
      FOREIGN KEY ("evidence_doc_id") REFERENCES "documents"("id") ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_attested_by_id_fkey') THEN
    ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_attested_by_id_fkey"
      FOREIGN KEY ("attested_by_id") REFERENCES "users"("id") ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'learning_records_waived_by_id_fkey') THEN
    ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_waived_by_id_fkey"
      FOREIGN KEY ("waived_by_id") REFERENCES "users"("id") ON DELETE SET NULL;
  END IF;
END $$;

COMMIT;
