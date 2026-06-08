-- =============================================================================
-- verify_ppl_p3.sql  (v0.62.0)  — READ-ONLY. Safe to run any time, any number
-- of times. Confirms PPL-205..208 are published with 20 active questions at 80%,
-- that no firmwide ALL rule was added, and that the role matrix now resolves
-- them as REQUIRED for the People-Ops Officer. Nothing here writes or deletes.
-- =============================================================================

-- 1) Module publish state + question count + pass mark (expect 4 rows, all
--    PUBLISHED, level P, domain PPL, q=20, pass=80).
SELECT m.code,
       m.level,
       m.domain,
       m.status,
       m.pass_mark,
       count(q.id) FILTER (WHERE q.active) AS active_questions
FROM "learning_modules" m
LEFT JOIN "learning_quiz_questions" q ON q.module_id = m.id
WHERE m.code IN ('PPL-205','PPL-206','PPL-207','PPL-208')
GROUP BY m.code, m.level, m.domain, m.status, m.pass_mark
ORDER BY m.code;

-- 2) Confirm NO firmwide ALL rule was added for these (expect 0 rows — they are
--    Proficient / role-targeted, never firmwide-mandatory).
SELECT m.code, r.scope, r.requirement
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code IN ('PPL-205','PPL-206','PPL-207','PPL-208')
  AND r.scope = 'ALL';

-- 3) Confirm the role matrix now resolves assignment: PPL-205..208 each mapped
--    JOB_PROFILE / REQUIRED to the People-Ops Officer (expect 4 rows, 1 each).
SELECT m.code,
       r.scope,
       r.requirement,
       r.job_profile_id,
       count(*) AS rules
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code IN ('PPL-205','PPL-206','PPL-207','PPL-208')
  AND r.scope = 'JOB_PROFILE'
  AND r.job_profile_id = 'jp_peopleops_officer'
GROUP BY m.code, r.scope, r.requirement, r.job_profile_id
ORDER BY m.code;

-- 4) Catalogue sanity by level (expect, after this release: level F published 29,
--    level P published 12; remaining P drafts 27; E drafts 22).
SELECT level,
       count(*) FILTER (WHERE status = 'PUBLISHED') AS published,
       count(*) FILTER (WHERE status = 'DRAFT')     AS draft
FROM "learning_modules"
WHERE code IS NOT NULL
GROUP BY level
ORDER BY level;

-- 5) Full People-Ops Officer PPL operator track (expect 8 rows, PPL-201..208,
--    all JOB_PROFILE / REQUIRED — confirms P2 + P3 together).
SELECT m.code, r.requirement
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code LIKE 'PPL-2%'
  AND r.scope = 'JOB_PROFILE'
  AND r.job_profile_id = 'jp_peopleops_officer'
ORDER BY m.code;
