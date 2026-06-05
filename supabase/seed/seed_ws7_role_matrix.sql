-- =============================================================================
-- seed_ws7_role_matrix.sql  (v0.43.1)
-- WS7 role-and-grade assignment matrix (canonical: WS7 L&D pack p.14).
--   Part A: 8 reserved future roles as DRAFT job_profiles (idempotent).
--   Part B: 164 JOB_PROFILE assignment rules across all 20 roles (idempotent).
-- The 8 firmwide FND mandatory rules (ALL/REQUIRED) are seeded elsewhere and
-- are intentionally NOT touched here. Rules resolve module_id by stable code,
-- so they are immune to module-id scheme. Deterministic rule ids + a NOT EXISTS
-- guard matching the unique (module_id, scope, grade'', job_profile_id) make
-- re-runs a no-op. Run by hand; ships in the zip.
-- =============================================================================
BEGIN;

-- ── Part A: 8 DRAFT job profiles ────────────────────────────────────────────
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_inv_associate', 'Investment Associate', 'G3', 'DRAFT'::"JdStatus", 'INVESTMENTS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_inv_associate' OR lower(title) = lower('Investment Associate'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_finance_officer', 'Finance Officer', 'G2', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_finance_officer' OR lower(title) = lower('Finance Officer'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_accounting_officer', 'Accounting Officer', 'G2', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_accounting_officer' OR lower(title) = lower('Accounting Officer'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_peopleops_officer', 'People-Ops Officer', 'G3', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_peopleops_officer' OR lower(title) = lower('People-Ops Officer'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_head_accounting', 'Head of Accounting / Controller', 'G3', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', true, 'MANAGER',
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_head_accounting' OR lower(title) = lower('Head of Accounting / Controller'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_head_investments', 'Head of Investments', 'G3', 'DRAFT'::"JdStatus", 'INVESTMENTS', false, 'MANAGER',
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_head_investments' OR lower(title) = lower('Head of Investments'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_cfo', 'CFO', 'G4', 'DRAFT'::"JdStatus", 'CONTROL_OPERATIONS', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_cfo' OR lower(title) = lower('CFO'));
INSERT INTO job_profiles (id, title, grade, status, family, is_control_function, track, description, created_at, updated_at)
SELECT 'jp_bd_officer', 'Business Development Officer', 'G3', 'DRAFT'::"JdStatus", 'BUSINESS_DEVELOPMENT', false, NULL,
       'Reserved future role (created v0.43.1). Training is pre-mapped and switches on automatically when someone is assigned this profile. Set department, rung and confirm track/control-function at hire.'
       , now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_profiles WHERE id = 'jp_bd_officer' OR lower(title) = lower('Business Development Officer'));

-- ── Part B: 164 JOB_PROFILE rules (REQUIRED + RECOMMENDED) ───────────────────
WITH want (job_profile_id, code, requirement) AS (
  VALUES
  ('cmpssxssk0006vbm115c0xb73', 'CLA-101', 'REQUIRED'),
  ('cmpssxssk0006vbm115c0xb73', 'CLA-102', 'REQUIRED'),
  ('cmpssxssk0006vbm115c0xb73', 'CLA-201', 'RECOMMENDED'),
  ('cmpssxssk0006vbm115c0xb73', 'LDR-101', 'RECOMMENDED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'CLA-101', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'CLA-102', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'CLA-201', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'CLA-202', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'CLA-203', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'OPS-101', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'LDR-101', 'REQUIRED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'OPS-201', 'RECOMMENDED'),
  ('cmpssxs6s0005vbm1fupr2cez', 'LDR-201', 'RECOMMENDED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-101', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-102', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-201', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-202', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-203', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-204', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'LDR-101', 'REQUIRED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'CLA-203', 'RECOMMENDED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'INV-301', 'RECOMMENDED'),
  ('cmpssxtep0007vbm1jdkgdk5a', 'LDR-201', 'RECOMMENDED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-101', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-102', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-201', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-202', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-203', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-204', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'LDR-201', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'LDR-202', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'LDR-203', 'REQUIRED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-301', 'RECOMMENDED'),
  ('cmpssxu0l0008vbm19utadz2a', 'FIN-302', 'RECOMMENDED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-101', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-102', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-201', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-202', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-203', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'LDR-201', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'LDR-202', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'LDR-203', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'LDR-204', 'REQUIRED'),
  ('cmpssxrl40004vbm1rkcnkjy7', 'OPS-301', 'RECOMMENDED'),
  ('cmpssxv89000avbm17r2bi18z', 'OPS-101', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'OPS-203', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'REG-101', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'REG-202', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'REG-203', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'LDR-101', 'REQUIRED'),
  ('cmpssxv89000avbm17r2bi18z', 'OPS-302', 'RECOMMENDED'),
  ('cmpssxv89000avbm17r2bi18z', 'LDR-201', 'RECOMMENDED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-101', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-102', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-201', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-202', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-301', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'TEC-302', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'LDR-101', 'REQUIRED'),
  ('cmpssxvud000bvbm1st2egdp5', 'LDR-201', 'RECOMMENDED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-101', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-201', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-202', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-203', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-204', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-301', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-302', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'REG-303', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'LDR-301', 'REQUIRED'),
  ('cmpssxumd0009vbm1jl2l535v', 'LDR-303', 'RECOMMENDED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-101', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-102', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-201', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-202', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-203', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-301', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'OPS-302', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'LDR-301', 'REQUIRED'),
  ('cmpssxqzb0003vbm1xy7h7b6v', 'LDR-303', 'RECOMMENDED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'INV-101', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'INV-102', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'OPS-101', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'OPS-102', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'OPS-201', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'CLA-203', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'LDR-201', 'REQUIRED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'INV-301', 'RECOMMENDED'),
  ('cmpssxqdm0002vbm1s6rbxmcy', 'LDR-301', 'RECOMMENDED'),
  ('cmpssxp650000vbm1g8e0k6aw', 'LDR-302', 'REQUIRED'),
  ('cmpssxp650000vbm1g8e0k6aw', 'LDR-303', 'REQUIRED'),
  ('cmpssxprt0001vbm140cw1mux', 'LDR-301', 'REQUIRED'),
  ('cmpssxprt0001vbm140cw1mux', 'LDR-302', 'REQUIRED'),
  ('cmpssxprt0001vbm140cw1mux', 'LDR-303', 'REQUIRED'),
  ('jp_inv_associate', 'INV-101', 'REQUIRED'),
  ('jp_inv_associate', 'INV-102', 'REQUIRED'),
  ('jp_inv_associate', 'INV-201', 'REQUIRED'),
  ('jp_inv_associate', 'INV-202', 'REQUIRED'),
  ('jp_inv_associate', 'INV-203', 'REQUIRED'),
  ('jp_inv_associate', 'INV-204', 'REQUIRED'),
  ('jp_inv_associate', 'INV-301', 'REQUIRED'),
  ('jp_inv_associate', 'INV-302', 'REQUIRED'),
  ('jp_inv_associate', 'LDR-101', 'REQUIRED'),
  ('jp_inv_associate', 'LDR-201', 'REQUIRED'),
  ('jp_inv_associate', 'INV-303', 'RECOMMENDED'),
  ('jp_inv_associate', 'LDR-202', 'RECOMMENDED'),
  ('jp_finance_officer', 'FIN-101', 'REQUIRED'),
  ('jp_finance_officer', 'FIN-102', 'REQUIRED'),
  ('jp_finance_officer', 'FIN-201', 'REQUIRED'),
  ('jp_finance_officer', 'FIN-203', 'REQUIRED'),
  ('jp_finance_officer', 'FIN-204', 'REQUIRED'),
  ('jp_finance_officer', 'LDR-101', 'REQUIRED'),
  ('jp_finance_officer', 'FIN-202', 'RECOMMENDED'),
  ('jp_accounting_officer', 'FIN-101', 'REQUIRED'),
  ('jp_accounting_officer', 'FIN-102', 'REQUIRED'),
  ('jp_accounting_officer', 'FIN-201', 'REQUIRED'),
  ('jp_accounting_officer', 'FIN-204', 'REQUIRED'),
  ('jp_accounting_officer', 'LDR-101', 'REQUIRED'),
  ('jp_accounting_officer', 'FIN-203', 'RECOMMENDED'),
  ('jp_peopleops_officer', 'OPS-202', 'REQUIRED'),
  ('jp_peopleops_officer', 'REG-204', 'REQUIRED'),
  ('jp_peopleops_officer', 'TEC-202', 'REQUIRED'),
  ('jp_peopleops_officer', 'LDR-201', 'REQUIRED'),
  ('jp_peopleops_officer', 'LDR-202', 'REQUIRED'),
  ('jp_peopleops_officer', 'LDR-203', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-101', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-102', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-201', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-204', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-302', 'REQUIRED'),
  ('jp_head_accounting', 'LDR-201', 'REQUIRED'),
  ('jp_head_accounting', 'LDR-202', 'REQUIRED'),
  ('jp_head_accounting', 'LDR-203', 'REQUIRED'),
  ('jp_head_accounting', 'FIN-301', 'RECOMMENDED'),
  ('jp_head_investments', 'INV-101', 'REQUIRED'),
  ('jp_head_investments', 'INV-102', 'REQUIRED'),
  ('jp_head_investments', 'INV-201', 'REQUIRED'),
  ('jp_head_investments', 'INV-202', 'REQUIRED'),
  ('jp_head_investments', 'INV-203', 'REQUIRED'),
  ('jp_head_investments', 'INV-204', 'REQUIRED'),
  ('jp_head_investments', 'INV-301', 'REQUIRED'),
  ('jp_head_investments', 'INV-302', 'REQUIRED'),
  ('jp_head_investments', 'INV-303', 'REQUIRED'),
  ('jp_head_investments', 'LDR-201', 'REQUIRED'),
  ('jp_head_investments', 'LDR-202', 'REQUIRED'),
  ('jp_head_investments', 'LDR-203', 'REQUIRED'),
  ('jp_cfo', 'FIN-101', 'REQUIRED'),
  ('jp_cfo', 'FIN-102', 'REQUIRED'),
  ('jp_cfo', 'FIN-201', 'REQUIRED'),
  ('jp_cfo', 'FIN-202', 'REQUIRED'),
  ('jp_cfo', 'FIN-203', 'REQUIRED'),
  ('jp_cfo', 'FIN-204', 'REQUIRED'),
  ('jp_cfo', 'FIN-301', 'REQUIRED'),
  ('jp_cfo', 'FIN-302', 'REQUIRED'),
  ('jp_cfo', 'LDR-301', 'REQUIRED'),
  ('jp_cfo', 'LDR-303', 'REQUIRED'),
  ('jp_bd_officer', 'CLA-101', 'REQUIRED'),
  ('jp_bd_officer', 'CLA-102', 'REQUIRED'),
  ('jp_bd_officer', 'CLA-201', 'REQUIRED'),
  ('jp_bd_officer', 'CLA-202', 'REQUIRED'),
  ('jp_bd_officer', 'CLA-203', 'REQUIRED'),
  ('jp_bd_officer', 'LDR-101', 'REQUIRED'),
  ('jp_bd_officer', 'INV-201', 'RECOMMENDED'),
  ('jp_bd_officer', 'CLA-301', 'RECOMMENDED'),
  ('jp_bd_officer', 'LDR-201', 'RECOMMENDED')
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

-- Expected: up to 8 profiles + 164 rules (139 required, 25 recommended) on first run.
COMMIT;
