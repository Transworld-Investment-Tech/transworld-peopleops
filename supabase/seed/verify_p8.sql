-- =============================================================================
-- verify_p8.sql  (v0.68.0)  --  READ-ONLY post-deploy confirmation for P8 (FIN-201..204).
-- No writes. Run each block in the Supabase SQL Editor after the four content seeds.
-- =============================================================================

-- 1) The four modules: each PUBLISHED, pass_mark 80, with 20 active questions.
SELECT m.code, m.level, m.status, m.pass_mark,
       count(q.id) FILTER (WHERE q.active) AS active_questions
FROM learning_modules m
LEFT JOIN learning_quiz_questions q ON q.module_id = m.id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204')
GROUP BY m.code, m.level, m.status, m.pass_mark
ORDER BY m.code;
-- WANT: 4 rows, each status PUBLISHED, pass_mark 80, active_questions 20.

-- 2) Zero firmwide ALL rules for FIN-2xx (role-targeted, not firmwide-mandatory).
SELECT count(*) AS fin_firmwide_all_rules
FROM learning_assignment_rules r
JOIN learning_modules m ON m.id = r.module_id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204') AND r.scope = 'ALL';
-- WANT: 0

-- 3) Catalogue snapshot (canonical: code IS NOT NULL): published / draft by level.
SELECT m.level,
       count(*) FILTER (WHERE m.status = 'PUBLISHED') AS published,
       count(*) FILTER (WHERE m.status = 'DRAFT')     AS draft
FROM learning_modules m
WHERE m.code IS NOT NULL
GROUP BY m.level
ORDER BY m.level;
-- WANT after P8: F published 29, draft 0; P published 32, draft 7; E published 0, draft 22.

-- 4) Total published (canonical count).
SELECT count(*) AS published_total
FROM learning_modules
WHERE code IS NOT NULL AND status = 'PUBLISHED';
-- WANT: 61

-- 5) FIN-2xx answer-key balance sanity (server-side correct jsonb): 5/5/5/5 per module.
SELECT m.code, (q.correct ->> 0) AS correct_key, count(*) AS n
FROM learning_quiz_questions q
JOIN learning_modules m ON m.id = q.module_id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204') AND q.active
GROUP BY m.code, (q.correct ->> 0)
ORDER BY m.code, correct_key;
-- WANT: each module shows a=5, b=5, c=5, d=5.

-- 6) FIN-2xx matrix rows with the enrolling profile (live PUBLISHED vs reserved DRAFT).
SELECT m.code, jp.title AS job_profile_title, jp.status AS profile_status, r.requirement
FROM learning_assignment_rules r
JOIN learning_modules m  ON m.id = r.module_id
JOIN job_profiles jp ON jp.id = r.job_profile_id
WHERE m.code IN ('FIN-201','FIN-202','FIN-203','FIN-204')
ORDER BY m.code, jp.status, jp.title;
