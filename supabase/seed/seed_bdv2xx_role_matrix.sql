-- =============================================================================
-- seed_bdv2xx_role_matrix.sql  (v0.67.0)
-- Maps BDV-201..205 to live/reserved job profiles. BDV-2xx were ABSENT from the
--   canonical seed_ws7_role_matrix.sql (same gap pattern as PPL-2xx/3xx), so this
--   targeted seed is REQUIRED for publish-only to assign the modules to anyone.
-- Profiles: jp_bd_officer (BD Officer, reserved), jp_marketing_comms (Marketing &
--   Comms, reserved), Client Services (LIVE), Head of Operations (LIVE).
-- BDV-205 (compliant selling) is REQUIRED for all four; others REQUIRED where core.
-- Idempotent: deterministic rule ids + NOT EXISTS guard => re-runs are a no-op.
-- Run by hand (SQL Editor). The canonical seed is patched to match (see
--   patch_canonical_matrix_bdv.cjs).
-- =============================================================================
BEGIN;

WITH want (job_profile_id, code, requirement) AS (
  VALUES
  ('jp_bd_officer', 'BDV-201', 'REQUIRED'),
  ('jp_bd_officer', 'BDV-202', 'REQUIRED'),
  ('jp_bd_officer', 'BDV-203', 'REQUIRED'),
  ('jp_bd_officer', 'BDV-204', 'REQUIRED'),
  ('jp_bd_officer', 'BDV-205', 'REQUIRED'),
  ('jp_marketing_comms', 'BDV-201', 'RECOMMENDED'),
  ('jp_marketing_comms', 'BDV-202', 'REQUIRED'),
  ('jp_marketing_comms', 'BDV-203', 'RECOMMENDED'),
  ('jp_marketing_comms', 'BDV-204', 'RECOMMENDED'),
  ('jp_marketing_comms', 'BDV-205', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'BDV-201', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'BDV-202', 'RECOMMENDED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'BDV-203', 'RECOMMENDED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'BDV-204', 'RECOMMENDED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'BDV-205', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'BDV-201', 'RECOMMENDED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'BDV-202', 'RECOMMENDED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'BDV-203', 'RECOMMENDED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'BDV-204', 'RECOMMENDED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'BDV-205', 'REQUIRED')
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

-- fail-loud guard: exactly 20 BDV-2xx JOB_PROFILE rules across the 4 profiles
DO $guard$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n
  FROM learning_assignment_rules r
  JOIN learning_modules m ON m.id = r.module_id
  WHERE m.code LIKE 'BDV-2%' AND r.scope = 'JOB_PROFILE'
    AND r.job_profile_id IN ('jp_bd_officer','jp_marketing_comms','cmpssxs6s0005vbm1fupr2cez','cmpssxrl40004vbm1rkcnkjy7');
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: expected 20 BDV-2xx JOB_PROFILE rules (got %)', n; END IF;
END
$guard$;

COMMIT;
