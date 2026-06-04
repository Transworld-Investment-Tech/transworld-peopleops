-- =============================================================================
-- 0029_ws4_depth.sql — WS4 depth (v0.41.0)
-- Three new tables for the probation clock + the offboarding mirror. All are
-- brand-new (empty), so the CHECK constraints are plain (no self-guard needed).
-- Cross-references to EXISTING tables are bare FK constraints (no Prisma
-- @relation): plan_id -> onboarding_plans (CASCADE), employee_id -> employees
-- (RESTRICT, the subject), staff_document_id -> staff_documents (SET NULL).
-- The one NEW-to-NEW pair (offboarding_tasks -> offboarding_cases) is the only
-- Prisma-managed relation. No new enum; no column added to any existing table.
-- Idempotent: IF NOT EXISTS throughout. Run BEFORE the push.
-- =============================================================================

-- ── probation_reviews ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "probation_reviews" (
  "id"                TEXT PRIMARY KEY,
  "plan_id"           TEXT NOT NULL,
  "employee_id"       TEXT NOT NULL,
  "ee_id"             TEXT NOT NULL,
  "employee_name"     TEXT NOT NULL,
  "kind"              TEXT NOT NULL,
  "outcome"           TEXT,
  "scheduled_for"     TIMESTAMP(3),
  "held_on"           TIMESTAMP(3),
  "extension_until"   TIMESTAMP(3),
  "staff_document_id" TEXT,
  "decided_by_id"     TEXT,
  "decided_by_name"   TEXT,
  "note"              TEXT,
  "created_at"        TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"        TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "probation_reviews_kind_chk"
    CHECK ("kind" IN ('MIDPOINT','FINAL')),
  CONSTRAINT "probation_reviews_outcome_chk"
    CHECK ("outcome" IS NULL OR "outcome" IN
      ('PENDING','ON_TRACK','CONCERNS','CONFIRM','EXTEND','NON_CONFIRM'))
);

DO $$ BEGIN
  ALTER TABLE "probation_reviews"
    ADD CONSTRAINT "probation_reviews_plan_id_fkey"
    FOREIGN KEY ("plan_id") REFERENCES "onboarding_plans"("id") ON DELETE CASCADE;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  ALTER TABLE "probation_reviews"
    ADD CONSTRAINT "probation_reviews_employee_id_fkey"
    FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  ALTER TABLE "probation_reviews"
    ADD CONSTRAINT "probation_reviews_staff_document_id_fkey"
    FOREIGN KEY ("staff_document_id") REFERENCES "staff_documents"("id") ON DELETE SET NULL;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE INDEX IF NOT EXISTS "probation_reviews_plan_id_idx" ON "probation_reviews"("plan_id");
CREATE INDEX IF NOT EXISTS "probation_reviews_employee_id_idx" ON "probation_reviews"("employee_id");

-- ── offboarding_cases ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "offboarding_cases" (
  "id"                   TEXT PRIMARY KEY,
  "employee_id"          TEXT NOT NULL,
  "ee_id"                TEXT NOT NULL,
  "employee_name"        TEXT NOT NULL,
  "user_id"              TEXT,
  "exit_type"            TEXT NOT NULL,
  "status"               TEXT NOT NULL DEFAULT 'OPEN',
  "notice_received_at"   TIMESTAMP(3),
  "last_working_day"     TIMESTAMP(3),
  "reason"               TEXT,
  "note"                 TEXT,
  "access_revoked_at"    TIMESTAMP(3),
  "access_revoked_by_id" TEXT,
  "exit_interview_done"  BOOLEAN NOT NULL DEFAULT false,
  "final_pay_settled"    BOOLEAN NOT NULL DEFAULT false,
  "regulatory_notified"  BOOLEAN NOT NULL DEFAULT false,
  "closed_at"            TIMESTAMP(3),
  "closed_by_id"         TEXT,
  "created_at"           TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"           TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "offboarding_cases_exit_type_chk"
    CHECK ("exit_type" IN
      ('RESIGNATION','NON_CONFIRMATION','DISMISSAL','REDUNDANCY','RETIREMENT','END_OF_TERM')),
  CONSTRAINT "offboarding_cases_status_chk"
    CHECK ("status" IN ('OPEN','CLEARING','CLOSED'))
);

DO $$ BEGIN
  ALTER TABLE "offboarding_cases"
    ADD CONSTRAINT "offboarding_cases_employee_id_fkey"
    FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE INDEX IF NOT EXISTS "offboarding_cases_employee_id_idx" ON "offboarding_cases"("employee_id");
CREATE INDEX IF NOT EXISTS "offboarding_cases_status_idx" ON "offboarding_cases"("status");

-- ── offboarding_tasks (NEW-to-NEW child of offboarding_cases) ─────────────────
CREATE TABLE IF NOT EXISTS "offboarding_tasks" (
  "id"         TEXT PRIMARY KEY,
  "case_id"    TEXT NOT NULL,
  "label"      TEXT NOT NULL,
  "category"   TEXT NOT NULL,
  "status"     TEXT NOT NULL DEFAULT 'PENDING',
  "done_at"    TIMESTAMP(3),
  "sort_order" INTEGER NOT NULL DEFAULT 0,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "offboarding_tasks_category_chk"
    CHECK ("category" IN ('SYSTEM','PHYSICAL','REGULATORY')),
  CONSTRAINT "offboarding_tasks_status_chk"
    CHECK ("status" IN ('PENDING','DONE','NA'))
);

DO $$ BEGIN
  ALTER TABLE "offboarding_tasks"
    ADD CONSTRAINT "offboarding_tasks_case_id_fkey"
    FOREIGN KEY ("case_id") REFERENCES "offboarding_cases"("id") ON DELETE CASCADE;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE INDEX IF NOT EXISTS "offboarding_tasks_case_id_idx" ON "offboarding_tasks"("case_id");
