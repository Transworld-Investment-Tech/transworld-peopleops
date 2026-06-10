-- seed_fnd2xx_role_matrix.sql — P9 v0.69.0
-- Closes the FND-2xx matrix gap (the PPL/BDV pattern): 20 JOB_PROFILE rows (14 REQUIRED / 6 RECOMMENDED)
-- mapping FND-201 (lm_fnd201) and FND-202 (lm_fnd202) per the approved P9 mapping.
-- Deterministic ids: 'lar_' || first 18 hex of md5(module_id || ':' || job_profile_id).
-- Idempotent via NOT EXISTS on (module_id, job_profile_id). Fail-loud verification at the end.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_fnd201' AND code = 'FND-201')
     OR NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_fnd202' AND code = 'FND-202') THEN
    RAISE EXCEPTION 'FND-201/FND-202 shells not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_1d7648f469027bd987', 'lm_fnd201', 'JOB_PROFILE', NULL, 'cmpssxs6s0005vbm1fupr2cez', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'cmpssxs6s0005vbm1fupr2cez'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_34f926d5c984c13fb9', 'lm_fnd201', 'JOB_PROFILE', NULL, 'cmpssxtep0007vbm1jdkgdk5a', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'cmpssxtep0007vbm1jdkgdk5a'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_1da0722a0dad94df04', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_procurement_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_procurement_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_b1eee4ff66d9fd1b0d', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_marketing_comms', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_marketing_comms'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_241a0e108d336cb34a', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_accounting_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_accounting_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_55e333be20d0dfff58', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_finance_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_finance_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_2fb0b4872b1cc623dd', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_bd_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_bd_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_b056f33c712006113c', 'lm_fnd201', 'JOB_PROFILE', NULL, 'cmpssxssk0006vbm115c0xb73', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'cmpssxssk0006vbm115c0xb73'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_c5b6d64ac7ca2bdd9e', 'lm_fnd201', 'JOB_PROFILE', NULL, 'jp_office_admin', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd201' AND job_profile_id = 'jp_office_admin'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_c9ad3cd54660c16905', 'lm_fnd202', 'JOB_PROFILE', NULL, 'cmpssxs6s0005vbm1fupr2cez', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'cmpssxs6s0005vbm1fupr2cez'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_c563ae782dcce914ac', 'lm_fnd202', 'JOB_PROFILE', NULL, 'cmpssxtep0007vbm1jdkgdk5a', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'cmpssxtep0007vbm1jdkgdk5a'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_4556d1e2f90b07b597', 'lm_fnd202', 'JOB_PROFILE', NULL, 'cmpssxssk0006vbm115c0xb73', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'cmpssxssk0006vbm115c0xb73'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_ea76ab74567875f25b', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_inv_associate', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_inv_associate'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_b57e6c52d44ff080a8', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_bd_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_bd_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_49d8e92ffd4af90379', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_marketing_comms', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_marketing_comms'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_44f8ec0992fce96a15', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_peopleops_officer', 'REQUIRED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_peopleops_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_66889f50322ab23b0f', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_procurement_officer', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_procurement_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_605215ee4eb98e8696', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_accounting_officer', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_accounting_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_0eb5d50ac3e8ccdbcb', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_finance_officer', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_finance_officer'
);

INSERT INTO learning_assignment_rules
  (id, module_id, scope, grade, job_profile_id, requirement, active, created_at, updated_at)
SELECT 'lar_2a99ff896294e8fef5', 'lm_fnd202', 'JOB_PROFILE', NULL, 'jp_office_admin', 'RECOMMENDED', true, now(), now()
WHERE NOT EXISTS (
  SELECT 1 FROM learning_assignment_rules
  WHERE module_id = 'lm_fnd202' AND job_profile_id = 'jp_office_admin'
);

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM learning_assignment_rules
  WHERE module_id IN ('lm_fnd201','lm_fnd202') AND scope = 'JOB_PROFILE' AND active;
  IF n < 20 THEN
    RAISE EXCEPTION 'FND-2xx matrix: expected at least 20 active JOB_PROFILE rows, found %', n;
  END IF;
END $$;

COMMIT;
