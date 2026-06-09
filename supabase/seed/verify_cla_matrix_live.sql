-- =============================================================================
-- verify_cla_matrix_live.sql  (v0.64.0)  — READ-ONLY. RUN THIS BEFORE PUBLISH.
-- Pre-publish gate: confirms the LIVE role matrix already carries CLA-201/202/203
-- and that every matrix row resolves to a real, current job profile. If any
-- expected code returns ZERO rows here, do NOT rely on publish-only — ship a
-- targeted matrix seed first (the PPL-2xx/3xx lesson). Nothing here writes.
-- =============================================================================
SELECT m.code,
       jp.id          AS job_profile_id,
       jp.title       AS job_profile,
       r.requirement,
       r.active
FROM "learning_assignment_rules" r
JOIN "learning_modules" m  ON m.id = r.module_id
JOIN "job_profiles"     jp ON jp.id = r.job_profile_id
WHERE m.code IN ('CLA-201','CLA-202','CLA-203')
  AND r.scope = 'JOB_PROFILE'
ORDER BY m.code, r.requirement DESC, jp.title;
