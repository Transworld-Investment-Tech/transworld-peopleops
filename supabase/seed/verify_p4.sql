-- =============================================================================
-- verify_p4.sql  (v0.63.0)  — READ-ONLY. Safe to run any time, any number of
-- times. Confirms OPS-201, OPS-202, OPS-203, TEC-202 are published with 20
-- active questions at 80%, that no firmwide ALL rule was added, and that the
-- role matrix already resolves them to live job profiles. Nothing here writes.
-- =============================================================================

-- 1) Module publish state + question count + pass mark
--    (expect 4 rows, all PUBLISHED, level P, q=20, pass=80).
SELECT m.code, m.level, m.domain, m.status, m.pass_mark,
       count(q.id) FILTER (WHERE q.active) AS active_questions
FROM "learning_modules" m
LEFT JOIN "learning_quiz_questions" q ON q.module_id = m.id
WHERE m.code IN ('OPS-201','OPS-202','OPS-203','TEC-202')
GROUP BY m.code, m.level, m.domain, m.status, m.pass_mark
ORDER BY m.code;

-- 2) Confirm NO firmwide ALL rule for these (expect 0 rows — role-targeted).
SELECT m.code, r.scope, r.requirement
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code IN ('OPS-201','OPS-202','OPS-203','TEC-202')
  AND r.scope = 'ALL';

-- 3) Confirm the role matrix still resolves assignment (expect the live rows:
--    OPS-201 x4, OPS-202 x3, OPS-203 x3, TEC-202 x2 JOB_PROFILE rows).
SELECT m.code, jp.title AS job_profile, r.requirement, r.active
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
JOIN "job_profiles" jp ON jp.id = r.job_profile_id
WHERE m.code IN ('OPS-201','OPS-202','OPS-203','TEC-202')
  AND r.scope = 'JOB_PROFILE'
ORDER BY m.code, jp.title;

-- 4) Catalogue sanity by level (expect after this release: F published 29;
--    P published 16, draft 23; E draft 22).
SELECT level,
       count(*) FILTER (WHERE status = 'PUBLISHED') AS published,
       count(*) FILTER (WHERE status = 'DRAFT')     AS draft
FROM "learning_modules"
WHERE code IS NOT NULL
GROUP BY level
ORDER BY level;
