-- =============================================================================
-- verify_fin_matrix_live.sql  (v0.68.0)  --  READ-ONLY pre-publish matrix gate for P8.
-- Confirms the canonical role matrix ALREADY carries FIN-201..204 BEFORE we publish,
-- and shows which job profiles (live vs reserved DRAFT) will enrol. No writes.
-- Publish-only pattern (REG/OPS/CLA/INV) holds iff every FIN-2xx code below resolves to
-- >= 1 JOB_PROFILE rule AND there is NO scope='ALL' FIN row. If any code shows
-- job_profile_rules = 0, STOP -- it is the PPL/BDV gap and needs a targeted matrix seed.
-- Run each block in the Supabase SQL Editor.
-- =============================================================================

-- A) Per-code coverage. WANT: job_profile_rules >= 1, firmwide_all_rules = 0 for all four.
SELECT m.code,
       count(*) FILTER (WHERE r.scope = 'JOB_PROFILE') AS job_profile_rules,
       count(*) FILTER (WHERE r.scope = 'ALL')         AS firmwide_all_rules
FROM learning_modules m
LEFT JOIN learning_assignment_rules r ON r.module_id = m.id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204')
GROUP BY m.code
ORDER BY m.code;

-- B) Every FIN-2xx rule with the enrolling profile and its status (live PUBLISHED vs reserved DRAFT).
--    The live Head of Finance (a PUBLISHED profile) enrols its current holder on publish.
SELECT m.code,
       r.requirement,
       r.scope,
       jp.id        AS job_profile_id,
       jp.title     AS job_profile_title,
       jp.status    AS profile_status
FROM learning_assignment_rules r
JOIN learning_modules m  ON m.id = r.module_id
LEFT JOIN job_profiles jp ON jp.id = r.job_profile_id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204')
ORDER BY m.code, r.requirement, jp.status, jp.title;

-- C) Live (PUBLISHED) profiles carrying any FIN-2xx rule -- these enrol staff now.
SELECT DISTINCT jp.id, jp.title, jp.status
FROM learning_assignment_rules r
JOIN learning_modules m  ON m.id = r.module_id
JOIN job_profiles jp ON jp.id = r.job_profile_id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204')
  AND jp.status = 'PUBLISHED'
ORDER BY jp.title;
