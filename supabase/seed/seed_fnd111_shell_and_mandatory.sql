-- =============================================================================
-- seed_fnd111_shell_and_mandatory.sql  (Release A, v0.58.0)
-- Run by hand in the Supabase SQL Editor. DATA, not schema. Idempotent.
--   PART 1: create the FND-111 catalogue shell (DRAFT; affects no one yet).
--   PART 2: flip FND-102 + FND-110 to mandatory (the "Mandatory" label) + cadence.
--   PART 3: add the firmwide ALL/REQUIRED rule for FND-102 + FND-110
--           (this enrols ALL staff — they become "required, not complete").
-- Mirrors the existing firmwide-rule pattern in seed_fnd_lms.sql.
-- FND-111 gets its everyone-rule + PUBLISH in Release B (content), not here.
-- =============================================================================
BEGIN;

-- ── PART 1 — FND-111 shell (new row, DRAFT). NOT EXISTS = no clobber on re-run.
INSERT INTO "learning_modules"
  ("id","title","category","summary","status","code","domain","level",
   "is_mandatory","cadence","owner","pass_mark","estimated_minutes","created_at","updated_at")
SELECT $i$lm_fnd111$i$,
       $t$Owning your performance & development: navigating the Transworld P&D cycle$t$,
       'Leadership & Professional',
       $s$How to own your goals, self-assessment, and growth across the firm's annual Performance & Development cycle — what to do at each stage, on joining and every year.$s$,
       'DRAFT', 'FND-111', 'FND', 'F', true, 'ON_JOIN_ANNUAL', 'PEOPLE_OPS', 80, 20,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "learning_modules" WHERE code = 'FND-111');

-- ── PART 2 — make FND-102 + FND-110 mandatory (label) + set cadence.
UPDATE "learning_modules"
   SET is_mandatory = true, cadence = 'ON_JOIN', updated_at = CURRENT_TIMESTAMP
 WHERE code = 'FND-102';
UPDATE "learning_modules"
   SET is_mandatory = true, cadence = 'ON_JOIN_ANNUAL', updated_at = CURRENT_TIMESTAMP
 WHERE code = 'FND-110';

-- ── PART 3 — firmwide everyone-rule for FND-102 + FND-110 (enrols all staff).
INSERT INTO "learning_assignment_rules"
  ("id","module_id","scope","grade","job_profile_id","requirement","active","created_at","updated_at")
SELECT 'lr_' || m.id, m.id, 'ALL', NULL, NULL, 'REQUIRED', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m
WHERE m.code IN ('FND-102','FND-110')
  AND NOT EXISTS (
    SELECT 1 FROM "learning_assignment_rules" r
    WHERE r.module_id = m.id AND r.scope = 'ALL' AND r.grade IS NULL AND r.job_profile_id IS NULL
  );

-- ── fail-loud guard ──────────────────────────────────────────────────────────
DO $guard$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM "learning_modules"
    WHERE code IN ('FND-102','FND-110') AND is_mandatory = true;
  IF n <> 2 THEN RAISE EXCEPTION 'Guard: FND-102/110 mandatory flip failed (got %)', n; END IF;

  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FND-111';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FND-111 shell missing (got %)', n; END IF;

  SELECT count(*) INTO n FROM "learning_assignment_rules" r
    JOIN "learning_modules" m ON m.id = r.module_id
    WHERE m.code IN ('FND-102','FND-110')
      AND r.scope = 'ALL' AND r.grade IS NULL AND r.job_profile_id IS NULL;
  IF n <> 2 THEN RAISE EXCEPTION 'Guard: FND-102/110 everyone-rule missing (got %)', n; END IF;
END
$guard$;

COMMIT;
