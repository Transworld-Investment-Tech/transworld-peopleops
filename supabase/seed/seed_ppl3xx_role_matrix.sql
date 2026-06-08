-- =============================================================================
-- seed_ppl3xx_role_matrix.sql  (v0.62.0)
-- Maps the PPL operator track P3 (PPL-205..208) to the People-Ops Officer job
-- profile as REQUIRED, so the newly published modules resolve as assigned work
-- (not orphaned in the library). PPL-205..208 were absent from the role matrix
-- (v0.61.0 only added PPL-201..204); this closes that gap with the same
-- JOB_PROFILE/REQUIRED pattern used by seed_ppl2xx_role_matrix.sql.
-- DATA, not schema. Idempotent (NOT EXISTS guard; deterministic rule ids). The
-- People-Ops Officer is a reserved DRAFT profile with no holder yet, so this
-- enrols nobody today and switches on automatically when the role is filled.
-- Run any time AFTER seed_lms_curriculum.sql; safe to re-run.
-- =============================================================================
BEGIN;

-- Ensure the reserved People-Ops Officer profile exists (no-op on live; matches
-- the canonical seed_ws7_role_matrix.sql Part A definition exactly).
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_peopleops_officer', 'People-Ops Officer', 'G3', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_peopleops_officer' OR lower(title) = lower('People-Ops Officer'));

-- PPL operator track P3: REQUIRED for the People-Ops Officer.
WITH want (job_profile_id, code, requirement) AS (
  VALUES
  ('jp_peopleops_officer', 'PPL-205', 'REQUIRED'),
  ('jp_peopleops_officer', 'PPL-206', 'REQUIRED'),
  ('jp_peopleops_officer', 'PPL-207', 'REQUIRED'),
  ('jp_peopleops_officer', 'PPL-208', 'REQUIRED')
)
INSERT INTO learning_assignment_rules (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_' || substr(md5(w.job_profile_id || ':' || m.id || ':JOB_PROFILE'), 1, 18),
       m.id, 'JOB_PROFILE', NULL, w.job_profile_id, w.requirement, true, now(), now()
FROM want w
JOIN learning_modules m ON m.code = w.code
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules r
  WHERE r.module_id = m.id AND r.scope = 'JOB_PROFILE'
    AND COALESCE(r.grade,'') = '' AND COALESCE(r.job_profile_id,'') = w.job_profile_id
);

-- fail-loud guard: expect exactly 4 JOB_PROFILE/REQUIRED rules for the
-- People-Ops Officer across PPL-205..208.
DO $guard$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n
  FROM learning_assignment_rules r
  JOIN learning_modules m ON m.id = r.module_id
  WHERE m.code IN ('PPL-205','PPL-206','PPL-207','PPL-208')
    AND r.scope = 'JOB_PROFILE'
    AND r.requirement = 'REQUIRED'
    AND r.job_profile_id = 'jp_peopleops_officer';
  IF n <> 4 THEN RAISE EXCEPTION 'Guard: expected 4 PPL P3 People-Ops rules (got %)', n; END IF;
END
$guard$;

COMMIT;
