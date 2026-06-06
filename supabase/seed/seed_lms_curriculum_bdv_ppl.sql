-- =============================================================================
-- seed_lms_curriculum_bdv_ppl.sql -- Curriculum extension (v0.47.0)
-- Adds the 24 BDV + PPL module shells from LMS Curriculum Source Map v2.0,
-- bringing the catalogue to 89 modules across 10 domains. DATA, not schema.
-- Idempotent (upsert by code). Bodies/questions NOT touched (authored later).
-- All shells ship DRAFT. RUN 0034 FIRST (domain CHECK must admit BDV/PPL).
-- This is the standalone delta; the same rows also live in the regenerated
-- canonical seed_lms_curriculum.sql. Running either yields the same end state.
-- =============================================================================

BEGIN;

INSERT INTO "learning_modules"
  ("id","title","category","summary","status","code","domain","level","is_mandatory","cadence","owner","pass_mark","estimated_minutes","created_at","updated_at")
VALUES
  ($i$lm_bdv101$i$, $t$Business development at Transworld: the role, the mandate & representing the institution$t$, 'Technical & Functional', $s$What the BD role is, the mandate you carry, and what it means to represent Transworld in the market.$s$, 'DRAFT', 'BDV-101', 'BDV', 'F', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv102$i$, $t$Know what you sell: the firm's products, services & financial instruments$t$, 'Technical & Functional', $s$The products, services, and instruments the firm offers — and what each one actually is.$s$, 'DRAFT', 'BDV-102', 'BDV', 'F', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv103$i$, $t$Talking markets in plain language: explaining securities to the layperson$t$, 'Technical & Functional', $s$Explaining markets and securities clearly to clients who aren't specialists.$s$, 'DRAFT', 'BDV-103', 'BDV', 'F', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv104$i$, $t$Prospecting & lead generation: finding and reaching new customers$t$, 'Technical & Functional', $s$Finding, qualifying, and reaching prospective clients.$s$, 'DRAFT', 'BDV-104', 'BDV', 'F', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv201$i$, $t$Consultative selling: discovery, needs analysis & building trust$t$, 'Technical & Functional', $s$Selling by understanding needs first: discovery, analysis, and earning trust.$s$, 'DRAFT', 'BDV-201', 'BDV', 'P', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv202$i$, $t$The sales funnel: pipeline, CRM discipline & managing your numbers$t$, 'Technical & Functional', $s$Running a disciplined pipeline and managing your numbers through the funnel.$s$, 'DRAFT', 'BDV-202', 'BDV', 'P', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv203$i$, $t$Proposals & pitching: winning the business & post-proposal follow-through$t$, 'Technical & Functional', $s$Building proposals, pitching well, and following through to win the business.$s$, 'DRAFT', 'BDV-203', 'BDV', 'P', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv204$i$, $t$Handling objections, negotiation & ethical closing$t$, 'Technical & Functional', $s$Working through objections, negotiating fairly, and closing the right way.$s$, 'DRAFT', 'BDV-204', 'BDV', 'P', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv205$i$, $t$Compliant selling: market conduct, suitability, inducements & what you may say$t$, 'Technical & Functional', $s$The conduct rules around selling: suitability, inducements, and what you may and may not say.$s$, 'DRAFT', 'BDV-205', 'BDV', 'P', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv301$i$, $t$Leading a BD team: targets, coaching the funnel & sales management$t$, 'Technical & Functional', $s$Leading a BD team: setting targets, coaching the funnel, and managing performance.$s$, 'DRAFT', 'BDV-301', 'BDV', 'E', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv302$i$, $t$Strategic origination: HNW, corporate & institutional business development$t$, 'Technical & Functional', $s$Originating high-net-worth, corporate, and institutional business.$s$, 'DRAFT', 'BDV-302', 'BDV', 'E', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_bdv303$i$, $t$Building the BD engine: go-to-market, partnerships, brand & referral ecosystems$t$, 'Technical & Functional', $s$Building the firm's growth engine: go-to-market, partnerships, brand, and referrals.$s$, 'DRAFT', 'BDV-303', 'BDV', 'E', false, NULL, 'FUNCTION_HEAD', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl101$i$, $t$The People Operations function: charter, mandate & the employee lifecycle$t$, 'Technical & Functional', $s$What People Operations is for: its charter, mandate, and the full employee lifecycle.$s$, 'DRAFT', 'PPL-101', 'PPL', 'F', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl102$i$, $t$People data, confidentiality & NDPR for HR$t$, 'Technical & Functional', $s$Handling employee data lawfully and confidentially under the NDPA/NDPR.$s$, 'DRAFT', 'PPL-102', 'PPL', 'F', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl201$i$, $t$Workforce architecture: grades, job families, competencies & role scorecards$t$, 'Technical & Functional', $s$The firm's grades, job families, competencies, and how role scorecards are built.$s$, 'DRAFT', 'PPL-201', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl202$i$, $t$Recruitment & hiring: the ten-stage workflow, structured interviewing & fit-and-proper$t$, 'Technical & Functional', $s$The ten-stage hiring workflow, structured interviewing, and fit-and-proper checks.$s$, 'DRAFT', 'PPL-202', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl203$i$, $t$Onboarding, probation & exit administration$t$, 'Technical & Functional', $s$Administering onboarding, probation, and exits cleanly and on the record.$s$, 'DRAFT', 'PPL-203', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl204$i$, $t$Performance management & the competency-scorecard cycle$t$, 'Technical & Functional', $s$Running the performance cycle and the competency scorecard, end to end.$s$, 'DRAFT', 'PPL-204', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl205$i$, $t$Compensation, benefits & payroll operations$t$, 'Technical & Functional', $s$How pay, benefits, and the payroll cycle are operated and controlled.$s$, 'DRAFT', 'PPL-205', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl206$i$, $t$L&D administration & mandatory-training compliance$t$, 'Technical & Functional', $s$Administering learning and keeping mandatory-training compliance on track.$s$, 'DRAFT', 'PPL-206', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl207$i$, $t$Employee relations: discipline, grievance, anti-harassment & the speak-up interface$t$, 'Technical & Functional', $s$Discipline, grievance, anti-harassment, and the interface with speak-up channels.$s$, 'DRAFT', 'PPL-207', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl208$i$, $t$The People-Ops operating rhythm: running the weekly, monthly, quarterly & annual cadence$t$, 'Technical & Functional', $s$Running the People-Ops cadence across the week, month, quarter, and year.$s$, 'DRAFT', 'PPL-208', 'PPL', 'P', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl301$i$, $t$Leading People Operations: workforce planning, HR strategy & culture stewardship$t$, 'Technical & Functional', $s$Leading People Operations: workforce planning, strategy, and stewarding culture.$s$, 'DRAFT', 'PPL-301', 'PPL', 'E', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ($i$lm_ppl302$i$, $t$HR governance, controls & audit readiness$t$, 'Technical & Functional', $s$HR governance, the controls that bind People-Ops, and staying audit-ready.$s$, 'DRAFT', 'PPL-302', 'PPL', 'E', false, NULL, 'PEOPLE_OPS', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (code) WHERE code IS NOT NULL DO UPDATE SET
  title = EXCLUDED.title, category = EXCLUDED.category, summary = EXCLUDED.summary,
  status = EXCLUDED.status, domain = EXCLUDED.domain, level = EXCLUDED.level,
  is_mandatory = EXCLUDED.is_mandatory, cadence = EXCLUDED.cadence, owner = EXCLUDED.owner,
  pass_mark = EXCLUDED.pass_mark, estimated_minutes = EXCLUDED.estimated_minutes,
  updated_at = CURRENT_TIMESTAMP;

COMMIT;
