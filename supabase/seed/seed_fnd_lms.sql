-- =============================================================================
-- seed_fnd_lms.sql — WS7 LMS first content shells (v0.42.0)
--
-- Seeds the eight Foundational (FND) module SHELLS and their firmwide REQUIRED
-- assignment rules, so mandatory auto-assignment and the compliance dashboard are
-- provable the moment the release ships. Lesson BODIES and the real graded
-- questions are authored as a SEPARATE content stream (FND-103 first) and loaded
-- afterward — this seed carries the structure, not the prose.
--
-- DATA, not schema: run this by hand AFTER 0031_ws7_lms.sql. Idempotent
-- (INSERT ... WHERE NOT EXISTS), so it is safe to re-run.
--
-- Sources for authoring (see the LMS Curriculum Source Map): FND-103 Code of
-- Ethics CO-POL-001; FND-104 AML/CFT + KYC v3.0; FND-105 Compliance Manual §12.1;
-- FND-106 Compliance Manual §12.2; FND-107 Conflict of Interest CO-POL-002 v3.0;
-- FND-108 Whistleblower Policy v1.0; FND-109 Compliance Manual §3/§15;
-- FND-101 Employee Handbook + Retreat Report.
-- =============================================================================

BEGIN;

-- ── module shells ────────────────────────────────────────────────────────────
INSERT INTO "learning_modules"
  ("id","title","category","summary","status","code","domain","level","is_mandatory","cadence","owner","pass_mark","created_at","updated_at")
SELECT v.id, v.title, v.category, v.summary, 'PUBLISHED', v.code, 'FND', v.level, true, v.cadence, v.owner, v.pass_mark, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM (VALUES
  ('lm_fnd101','Welcome to Transworld: mission, values & the six behaviors','Onboarding','Who we are, what we value, and the six behaviors every Transworld person is held to.','FND-101','F','ON_JOIN','PEOPLE_OPS', NULL::int),
  ('lm_fnd103','Code of Conduct & Ethics','Compliance & Regulatory','The binding standards of conduct every employee acknowledges — integrity, conflicts, and the line we will not cross.','FND-103','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd104','AML/CFT & KYC Awareness','Compliance & Regulatory','Money-laundering and terrorist-financing risk, customer due diligence, red flags, and your reporting duty.','FND-104','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd105','Data Protection / NDPR','Compliance & Regulatory','Handling personal data lawfully under the NDPA/NDPR — the principles and your day-to-day obligations.','FND-105','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd106','Confidentiality & Information Security','Compliance & Regulatory','Protecting client and firm information — confidentiality duties and the information-security controls that bind you.','FND-106','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd107','Conflicts of Interest','Compliance & Regulatory','What a conflict is, the duty to disclose early in writing, and the activities that are restricted or prohibited.','FND-107','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd108','Whistleblowing & Speaking Up','Compliance & Regulatory','How to raise a concern, the routes available, your anonymity rights, and the absolute protection against retaliation.','FND-108','F','ON_JOIN_ANNUAL','CCO', 80),
  ('lm_fnd109','SEC/NGX Conduct Essentials','Compliance & Regulatory','The regulatory framework we operate under and the market-conduct standards expected of a dealing member.','FND-109','F','ON_JOIN_ANNUAL','CCO', 80)
) AS v(id,title,category,summary,code,level,cadence,owner,pass_mark)
WHERE NOT EXISTS (SELECT 1 FROM "learning_modules" m WHERE m.code = v.code);

-- ── firmwide REQUIRED rules (scope = ALL) ────────────────────────────────────
INSERT INTO "learning_assignment_rules"
  ("id","module_id","scope","grade","job_profile_id","requirement","active","created_at","updated_at")
SELECT 'lr_' || m.id, m.id, 'ALL', NULL, NULL, 'REQUIRED', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m
WHERE m.code IN ('FND-101','FND-102','FND-103','FND-104','FND-105','FND-106','FND-107','FND-108','FND-109','FND-110')
  AND NOT EXISTS (
    SELECT 1 FROM "learning_assignment_rules" r
    WHERE r.module_id = m.id AND r.scope = 'ALL' AND r.grade IS NULL AND r.job_profile_id IS NULL
  );

COMMIT;
