-- =============================================================================
-- verify_reg_p1.sql  (v0.60.0)  — READ-ONLY. Safe to run any time, any number
-- of times. Confirms REG-201..204 are published with 20 active questions at 80%,
-- and that the role-and-grade matrix already resolves assignment for them.
-- Nothing here writes, updates, or deletes.
-- =============================================================================

-- 1) Module publish state + question count + pass mark (expect 4 rows, all PUBLISHED, q=20, pass=80)
SELECT m.code,
       m.level,
       m.domain,
       m.status,
       m.pass_mark,
       count(q.id) FILTER (WHERE q.active) AS active_questions
FROM "learning_modules" m
LEFT JOIN "learning_quiz_questions" q ON q.module_id = m.id
WHERE m.code IN ('REG-201','REG-202','REG-203','REG-204')
GROUP BY m.code, m.level, m.domain, m.status, m.pass_mark
ORDER BY m.code;

-- 2) Confirm NO firmwide ALL rule was added for these (expect 0 rows — they are
--    Proficient / role-targeted, never firmwide-mandatory).
SELECT m.code, r.scope, r.requirement
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code IN ('REG-201','REG-202','REG-203','REG-204')
  AND r.scope = 'ALL';

-- 3) Confirm the role-and-grade matrix already resolves assignment (expect the
--    pre-seeded JOB_PROFILE/REQUIRED rules: REG-201 x1, REG-202/203/204 x2 each).
SELECT m.code,
       r.scope,
       r.requirement,
       count(*) AS rules
FROM "learning_assignment_rules" r
JOIN "learning_modules" m ON m.id = r.module_id
WHERE m.code IN ('REG-201','REG-202','REG-203','REG-204')
GROUP BY m.code, r.scope, r.requirement
ORDER BY m.code, r.scope;

-- 4) Catalogue sanity: published level-F (expect 29) + newly published REG P (expect 4).
SELECT level,
       count(*) FILTER (WHERE status = 'PUBLISHED') AS published,
       count(*) FILTER (WHERE status = 'DRAFT')     AS draft
FROM "learning_modules"
WHERE code IS NOT NULL
GROUP BY level
ORDER BY level;
