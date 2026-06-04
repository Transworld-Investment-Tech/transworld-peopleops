-- 0027_ws3_depth.sql  (v0.39.0 — WS3 depth)
-- Ten-stage hiring pipeline + staff-file completeness (Ops Manual D6.2) + the
-- persisted completeness-snapshot trend. Document-expiry alerts + the
-- notification spine are v0.39.1 (this migration does NOT touch notifications).
--
-- Conventions: no new Postgres enums (CHECK-constrained text); ADD COLUMN IF
-- NOT EXISTS; CHECKs added via guarded DO blocks (Postgres has no ADD
-- CONSTRAINT IF NOT EXISTS); cross-refs to EXISTING tables are bare FK columns
-- (no Prisma @relation); user refs SET NULL, the subject candidate CASCADE
-- (the EmployeeDependent precedent). Ids are app-generated cuid (no DB default).
--
-- Safe to run more than once.

BEGIN;

-- ============================================================================
-- A) job_openings  — Stages 1-3 (requisition / budget approval / role pack)
-- ============================================================================
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS reason                    text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS business_case             text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS must_haves                text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS is_control_function       boolean NOT NULL DEFAULT false;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS raised_by_id              text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS raised_by_name            text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS raised_at                 timestamp(3);
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS budget_band               text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS cfo_approved_by_id        text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS cfo_approved_by_name      text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS cfo_approved_at           timestamp(3);
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS md_approved_by_id         text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS md_approved_by_name       text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS md_approved_at            timestamp(3);
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS role_pack_confirmed_by_id   text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS role_pack_confirmed_by_name text;
ALTER TABLE public.job_openings ADD COLUMN IF NOT EXISTS role_pack_confirmed_at      timestamp(3);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'job_openings_reason_check') THEN
    ALTER TABLE public.job_openings
      ADD CONSTRAINT job_openings_reason_check
      CHECK (reason IS NULL OR reason IN ('NEW','REPLACEMENT','GROWTH'));
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'job_openings_raised_by_fk') THEN
    ALTER TABLE public.job_openings
      ADD CONSTRAINT job_openings_raised_by_fk
      FOREIGN KEY (raised_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'job_openings_cfo_fk') THEN
    ALTER TABLE public.job_openings
      ADD CONSTRAINT job_openings_cfo_fk
      FOREIGN KEY (cfo_approved_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'job_openings_md_fk') THEN
    ALTER TABLE public.job_openings
      ADD CONSTRAINT job_openings_md_fk
      FOREIGN KEY (md_approved_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'job_openings_rolepack_fk') THEN
    ALTER TABLE public.job_openings
      ADD CONSTRAINT job_openings_rolepack_fk
      FOREIGN KEY (role_pack_confirmed_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
END $$;

-- ============================================================================
-- B) candidates  — Stage 7 (selection decision + CCO sign-off)
-- ============================================================================
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS selection_rationale   text;
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS selected_by_id        text;
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS selected_by_name      text;
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS selected_at           timestamp(3);
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS cco_signoff_by_id     text;
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS cco_signoff_by_name   text;
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS cco_signoff_at        timestamp(3);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidates_selected_by_fk') THEN
    ALTER TABLE public.candidates
      ADD CONSTRAINT candidates_selected_by_fk
      FOREIGN KEY (selected_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidates_cco_signoff_fk') THEN
    ALTER TABLE public.candidates
      ADD CONSTRAINT candidates_cco_signoff_fk
      FOREIGN KEY (cco_signoff_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Widen the candidate stage vocabulary to the eleven canonical stages, but
-- ONLY if every existing row already complies — a failing CHECK would abort
-- the whole migration, so we guard it. If any row sits outside the set the
-- constraint is skipped (a NOTICE is raised) and stage stays validated in the
-- action layer instead. (No existing CHECK on candidates.stage today.)
DO $$
DECLARE
  bad int;
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidates_stage_check') THEN
    RAISE NOTICE 'candidates_stage_check already present — skipping.';
  ELSE
    SELECT count(*) INTO bad FROM public.candidates
     WHERE stage NOT IN ('SOURCED','SCREENING','ASSESSMENT','SHORTLISTED','INTERVIEW',
                          'SELECTED','CHECKS','OFFER','HIRED','REJECTED','WITHDRAWN');
    IF bad = 0 THEN
      ALTER TABLE public.candidates
        ADD CONSTRAINT candidates_stage_check
        CHECK (stage IN ('SOURCED','SCREENING','ASSESSMENT','SHORTLISTED','INTERVIEW',
                         'SELECTED','CHECKS','OFFER','HIRED','REJECTED','WITHDRAWN'));
      RAISE NOTICE 'candidates_stage_check added.';
    ELSE
      RAISE NOTICE 'candidates.stage has % row(s) outside the canonical set — CHECK NOT added; action-layer validation applies.', bad;
    END IF;
  END IF;
END $$;

-- ============================================================================
-- C) staff_documents  — D6.2 staff-file slot classifier
-- ============================================================================
ALTER TABLE public.staff_documents ADD COLUMN IF NOT EXISTS file_slot text;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'staff_documents_file_slot_check') THEN
    ALTER TABLE public.staff_documents
      ADD CONSTRAINT staff_documents_file_slot_check
      CHECK (file_slot IS NULL OR file_slot IN (
        'CONTRACT','OFFER_LETTER','ID_VERIFIED','RIGHT_TO_WORK','GUARANTOR',
        'QUALIFICATIONS','SEC_NGX_REG','CRIMINAL_CHECK','HANDBOOK_ACK','PAD_ACK',
        'CONFIDENTIALITY_ACK','PROBATION_MIDPOINT','PROBATION_OUTCOME',
        'PERF_REVIEWS','CASE_RECORDS','EXIT_DOCS'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS staff_documents_file_slot_idx ON public.staff_documents (file_slot);

-- ============================================================================
-- D) employees  — explicit regulated-role flag (drives D6.2 applicability)
-- ============================================================================
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS is_regulated_role boolean NOT NULL DEFAULT false;

-- ============================================================================
-- E) candidate_stage_events  (NEW) — the per-stage gate trail
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.candidate_stage_events (
  id              text PRIMARY KEY,
  candidate_id    text NOT NULL REFERENCES public.candidates(id) ON DELETE CASCADE,
  candidate_name  text,
  stage           text NOT NULL,
  cleared_at      timestamp(3) NOT NULL DEFAULT now(),
  cleared_by_id   text REFERENCES public.users(id) ON DELETE SET NULL,
  cleared_by_name text,
  artifact_doc_id text REFERENCES public.staff_documents(id) ON DELETE SET NULL,
  note            text,
  created_at      timestamp(3) NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidate_stage_events_stage_check') THEN
    ALTER TABLE public.candidate_stage_events
      ADD CONSTRAINT candidate_stage_events_stage_check
      CHECK (stage IN ('SOURCED','SCREENING','ASSESSMENT','SHORTLISTED','INTERVIEW',
                       'SELECTED','CHECKS','OFFER','HIRED','REJECTED','WITHDRAWN'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS candidate_stage_events_candidate_idx
  ON public.candidate_stage_events (candidate_id);

-- ============================================================================
-- F) candidate_checks  (NEW) — Stage 8 verification checklist (gates -> OFFER)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.candidate_checks (
  id              text PRIMARY KEY,
  candidate_id    text NOT NULL REFERENCES public.candidates(id) ON DELETE CASCADE,
  candidate_name  text,
  check_type      text NOT NULL,
  applicable      boolean NOT NULL DEFAULT true,
  status          text NOT NULL DEFAULT 'PENDING',
  cleared_at      timestamp(3),
  cleared_by_id   text REFERENCES public.users(id) ON DELETE SET NULL,
  cleared_by_name text,
  evidence_doc_id text REFERENCES public.staff_documents(id) ON DELETE SET NULL,
  note            text,
  created_at      timestamp(3) NOT NULL DEFAULT now(),
  updated_at      timestamp(3) NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidate_checks_type_check') THEN
    ALTER TABLE public.candidate_checks
      ADD CONSTRAINT candidate_checks_type_check
      CHECK (check_type IN ('IDENTITY','QUALIFICATIONS','PROFESSIONAL_MEMBERSHIP',
                            'REGULATORY_LICENSING','FIT_AND_PROPER','REFERENCES',
                            'GUARANTOR','BACKGROUND_SCREENING','MEDICAL',
                            'DATA_PROTECTION_CONSENT'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidate_checks_status_check') THEN
    ALTER TABLE public.candidate_checks
      ADD CONSTRAINT candidate_checks_status_check
      CHECK (status IN ('PENDING','CLEARED','WAIVED','FAILED'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'candidate_checks_unique') THEN
    ALTER TABLE public.candidate_checks
      ADD CONSTRAINT candidate_checks_unique UNIQUE (candidate_id, check_type);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS candidate_checks_candidate_idx
  ON public.candidate_checks (candidate_id);

-- ============================================================================
-- G) staff_file_snapshots  (NEW) — immutable completeness trend ("X of N")
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.staff_file_snapshots (
  id                   text PRIMARY KEY,
  taken_at             timestamp(3) NOT NULL DEFAULT now(),
  scope                text NOT NULL DEFAULT 'ACTIVE',
  population_count     integer NOT NULL,
  complete_count       integer NOT NULL,
  threshold_pct        integer NOT NULL DEFAULT 90,
  avg_completeness_pct numeric(5,2) NOT NULL DEFAULT 0,
  note                 text,
  taken_by_id          text REFERENCES public.users(id) ON DELETE SET NULL,
  taken_by_name        text,
  created_at           timestamp(3) NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'staff_file_snapshots_scope_check') THEN
    ALTER TABLE public.staff_file_snapshots
      ADD CONSTRAINT staff_file_snapshots_scope_check
      CHECK (scope IN ('ALL','ACTIVE','ACTIVE_AND_PROBATION'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS staff_file_snapshots_taken_at_idx
  ON public.staff_file_snapshots (taken_at);

COMMIT;
