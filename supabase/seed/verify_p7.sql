-- =============================================================================
-- verify_p7.sql  (v0.67.0) — READ-ONLY. Confirms the BDV-201..205 deploy.
-- Run in the Supabase SQL Editor after the content seeds + the matrix seed.
-- =============================================================================

-- 1) The five modules: PUBLISHED, pass_mark 80, 20 active questions each
SELECT m.code, m.level, m.status, m.pass_mark,
       count(q.*) FILTER (WHERE q.active) AS active_questions
FROM learning_modules m
LEFT JOIN learning_quiz_questions q ON q.module_id = m.id
WHERE m.code LIKE 'BDV-2%'
GROUP BY m.code, m.level, m.status, m.pass_mark
ORDER BY m.code;

-- 2) Matrix rows for BDV-2xx, by profile + requirement (expect 20: 10 REQ / 10 REC)
SELECT COALESCE(jp.title, r.job_profile_id) AS profile, m.code, r.requirement, r.active
FROM learning_assignment_rules r
JOIN learning_modules m ON m.id = r.module_id
LEFT JOIN job_profiles jp ON jp.id = r.job_profile_id
WHERE m.code LIKE 'BDV-2%' AND r.scope = 'JOB_PROFILE'
ORDER BY profile, m.code;

-- 3) Confirm NO firmwide ALL rule sneaked in for BDV-2xx (expect 0 rows)
SELECT m.code, r.scope, r.requirement
FROM learning_assignment_rules r
JOIN learning_modules m ON m.id = r.module_id
WHERE m.code LIKE 'BDV-2%' AND r.scope = 'ALL';

-- 4) Catalogue tally by level among coded modules (expect F 29 / P 28 published)
SELECT level, status, count(*)
FROM learning_modules
WHERE code IS NOT NULL
GROUP BY level, status
ORDER BY level, status;
