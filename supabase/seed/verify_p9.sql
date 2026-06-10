-- verify_p9.sql — read-only verification for P9 v0.69.0 (LDR-201..204 + FND-201/202)

SELECT m.code, m.status, m.pass_mark, m.is_mandatory, m.estimated_minutes,
       length(m.body) AS body_chars, count(q.id) AS questions
FROM learning_modules m
LEFT JOIN learning_quiz_questions q ON q.module_id = m.id AND q.active
WHERE m.code IN ('LDR-201','LDR-202','LDR-203','LDR-204','FND-201','FND-202')
GROUP BY m.id, m.code, m.status, m.pass_mark, m.is_mandatory, m.estimated_minutes
ORDER BY m.code;

SELECT m.code, q.correct->>0 AS answer_key, count(*) AS n
FROM learning_quiz_questions q
JOIN learning_modules m ON m.id = q.module_id
WHERE m.code IN ('LDR-201','LDR-202','LDR-203','LDR-204','FND-201','FND-202') AND q.active
GROUP BY m.code, q.correct->>0
ORDER BY m.code, answer_key;

SELECT m.code, r.scope, r.requirement, count(*) AS rules
FROM learning_assignment_rules r
JOIN learning_modules m ON m.id = r.module_id
WHERE m.code IN ('LDR-201','LDR-202','LDR-204','LDR-203','FND-201','FND-202') AND r.active
GROUP BY m.code, r.scope, r.requirement
ORDER BY m.code, r.scope, r.requirement;

SELECT count(*) AS firmwide_all_rules_for_p9_should_be_zero
FROM learning_assignment_rules r
JOIN learning_modules m ON m.id = r.module_id
WHERE m.code IN ('LDR-201','LDR-202','LDR-203','LDR-204','FND-201','FND-202')
  AND r.scope = 'ALL';

SELECT level, status, count(*) AS modules
FROM learning_modules
WHERE code IS NOT NULL
GROUP BY level, status
ORDER BY level, status;
