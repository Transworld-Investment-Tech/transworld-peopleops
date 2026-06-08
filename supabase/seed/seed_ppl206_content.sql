-- =============================================================================
-- seed_ppl206_content.sql  (v0.62.0)
-- PPL-206: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches LMS administration, the two-layer mandatory model, and sponsorship clawback.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl3xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Learning at Transworld is not a perk; for a regulated capital-market operator it is a control. If a licensed dealer misses a continuing-education deadline, or an all-staff data-protection refresh goes uncompleted, the gap is a compliance failure before it is a development one. You are the system administrator for that control. This module is the L&D operation: publishing the year's training plan, running the LMS, enforcing mandatory-training compliance to one hundred percent, administering development paths and qualification sponsorship, and keeping the curriculum current as the rules change.

## What you will be able to do

1. Publish and run the Annual Training Calendar and administer the LMS as system administrator.
2. Enforce mandatory-training compliance by role to one hundred percent, escalating correctly.
3. Distinguish the two layers that make a module genuinely mandatory in the portal.
4. Administer the development path (PADP) and run qualification sponsorship with its clawback.
5. Maintain the curriculum map and push regulatory content updates on time.

## The L&D operating frame

In January you publish the Annual Training Calendar on the portal's Learning & Development module and share it with every line manager. It covers the mandatory compliance training and its deadlines, scheduled group sessions, any approved external conference or certification activity, and the self-directed catalogue. You are the LMS administrator: you keep the mandatory content current — especially regulatory content where the law moves — assign the right modules to each employee, track completion, and record external training that happens outside the system as an attendance record with date, duration, and evidence. The portal LMS is the system of record for all of it.

## Mandatory training: who needs what, and the two layers

Some modules are required of everyone; others are role-specific. AML/CFT awareness, data protection, a securities-regulations overview, the personal-account-dealing refresher, and IT security and phishing awareness are all-staff. Health-and-safety induction is for all new joiners. Market conduct and conflicts of interest is for investment and business-development staff and everyone at G3 and above. SEC continuing professional development is for licensed staff. Role-specific compliance training is assigned as Compliance designates. One hundred percent completion is not optional: an employee who has not completed mandatory training by its deadline is in breach of their employment obligations, and Compliance must be told immediately if any licensed employee misses a CPD deadline.

A subtlety of the portal matters here. "Mandatory" is two layers, not one. The is_mandatory flag drives the visible "Mandatory" pill on a module — but the pill alone does not make the module due for anyone. What actually enrols people is an assignment rule: a firm-wide rule that puts the module on every active employee, or a role-targeted rule that maps it to a job profile. When you need a module to be genuinely mandatory for everyone, you set the flag and a cadence and you confirm the firm-wide assignment rule is in place. Setting the pill and assuming enforcement is the classic mistake; always confirm the rule.

The AML/CFT awareness module deserves particular attention because it carries a regulatory training-register obligation: completion is not only an LMS record but evidence the firm can produce to a regulator that its staff were trained against money-laundering and terrorist-financing risk. Keep that register current and reconciled with the LMS completion data, and treat an AML/CFT gap as a compliance exposure rather than an administrative one. The same seriousness applies to the personal-account-dealing refresher and the market-conduct module, which protect the firm against the conduct risks a dealing member is most exposed to.

On regulatory currency, teach the law as it stands. Data-protection training is taught under the Nigeria Data Protection Act 2023 and the 2025 General Application and Implementation Directive, with the regulator being the Nigeria Data Protection Commission — older material still naming the 2019 regulation is superseded. Securities-law content is taught under the Investments and Securities Act 2025, the enacted statute, where companion documents still cite the 2024 bill. The principle is constant: concept travels, the binding rule is the current Nigerian one. When the law moves between annual reviews, you do not wait for the next cycle — you update the affected module and re-assign it with a deadline as soon as the change takes effect.

## Tracking, reminders, and escalation

You review the LMS completion dashboard every week. Anyone approaching a deadline who has not started gets a reminder; if the deadline is within five working days you escalate to the line manager, and continued non-completion goes to the COO. A licensed-staff CPD miss is escalated to Compliance immediately, not at week's end, because it carries regulatory consequences the firm cannot sit on. When an employee completes training outside the LMS — a conference, an external course — you record it manually as an attendance record so the completion history stays whole. The weekly rhythm is what keeps completion at one hundred percent rather than letting a quiet backlog build to a deadline crisis: a reminder sent on the day a module is assigned, and again with a week to run, costs nothing and prevents the escalation entirely. Where a module was activated for a new joiner on Day 1, you confirm in the first-week check that it has actually been started, not merely assigned.

## Development paths (PADP)

The development path is reviewed inside the performance cycle, at the mid-year review and the year-end appraisal — it is part of the performance conversation, not a separate process. Your role is to make sure every employee has a documented plan in the portal, that it is reviewed and updated at each formal review point, and to flag to the COO anyone who has sat at the same grade for more than two years without documented development progress. A development plan lists the current stage for the grade, the top two or three priorities for the cycle, the agreed actions — training, a stretch assignment, coaching, an external qualification — the timeline, and who supports it. Keep one distinction clean: a development plan is not a performance improvement plan. The plan is forward-looking and positive; it describes where the person is going, not where they fell short. An employee on a PIP may also have a development plan, but the two documents are kept separate.

## Qualification sponsorship and its clawback

Transworld sponsors qualifications that are directly relevant to the current role or to an agreed career path — SEC-recognized qualifications, CISI qualifications, ICAN and ACCA for Finance staff, relevant master's degrees, and others the COO approves case by case. The process is fixed: the employee applies at least a month before the enrollment deadline with the qualification, provider, duration, cost, start date, and a relevance statement; the line manager confirms support in writing; you assess against the eligibility criteria and the year's L&D budget; the COO approves or declines within ten working days of a complete application; and on approval you record it on the LMS and in the Sponsorship Ledger and note the clawback obligation on the staff file.

The clawback protects the firm's investment, and its mechanics must be exact. The twelve-month protection window starts on the confirmed completion date — the date the awarding body confirms the qualification is awarded, not the approval date, the exam date, or the date the employee tells you. If the employee leaves within twelve months of that completion date, the amount repayable is the months remaining to the twelve-month anniversary divided by twelve, times the total sponsorship cost — fees, exam registration, materials, and any approved study leave paid at full salary. Two things make this enforceable and correct: the clawback obligation must appear in the sponsorship approval letter, signed by the employee before any fees are committed — never commit funds before the signed letter is on file — and the portal records the completion date and calculates the window from it. Clawback does not apply for redundancy, medical incapacity, or retirement; anything that does not clearly fall into those three goes to the COO and, where needed, external counsel before final pay is issued. If someone resigns mid-study, the firm may recover fees already paid on a reasonable basis the COO determines — there is no automatic formula for that case.

## Maintaining the curriculum map

The curriculum map is the firm's documented learning pathway by grade and family — what is expected, available, and required. You review it annually in the fourth quarter with Compliance: are the mandatory modules current and reflective of the latest regulation, have new competency gaps surfaced in calibration or development reviews, are there new qualifications worth adding, has the LMS content been refreshed where needed. The reviewed map and the next year's training calendar are published by 15 January. Any material change to mandatory requirements — a new regulatory requirement, say — is communicated to all staff immediately, with the updated module activated at the same time rather than waiting for the annual cycle.

## A worked example

**Illustration — a licensed joiner's first week, and a clawback (entirely hypothetical).** A fictional licensed business-development officer starts on the first of the month. On Day 1 you activate their mandatory modules in the LMS: the all-staff set (AML/CFT, data protection under the 2023 Act, securities-regulations overview, the PAD refresher, IT security), the H&S induction for a new joiner, market conduct and conflicts of interest because they are investment/BD staff, and SEC CPD because they are licensed — each with its deadline. Your weekly dashboard review shows two modules unstarted with the deadline four working days out, so you escalate to the line manager; because one is the licensed CPD module you also notify Compliance the same day. Eighteen months later the firm sponsors a CISI qualification for the same person at a total cost of 480,000 naira. They complete it, and four months after the confirmed completion date they resign. Eight of the twelve protection months remain, so the clawback is eight divided by twelve times 480,000 — 320,000 naira — recovered from final pay where sufficient, enforceable because the obligation was in the signed approval letter on file before any fees were committed.

## Common traps

- **Treating the "Mandatory" pill as enforcement.** The pill is the flag; what makes a module due is the assignment rule. Confirm the firm-wide or role rule is in place.
- **Committing sponsorship funds before the signed letter.** The clawback is only enforceable if the obligation is in the signed approval letter on file before any fees are committed.
- **Calculating clawback from the approval date.** The twelve-month window runs from the confirmed completion date the awarding body sets, recorded in the portal.
- **Sitting on a licensed CPD miss.** Escalate a licensed-staff CPD miss to Compliance immediately, not at week's end.
- **Teaching superseded law.** Data protection is the 2023 Act plus the 2025 directive under the NDPC; securities law is the 2025 Act. Teach the current binding rule.

## Key takeaways

- You are the LMS administrator: publish the January training calendar, assign role-correct mandatory modules, track completion weekly, and record external training.
- Mandatory means two layers — the is_mandatory pill and the assignment rule that actually enrols people; one hundred percent completion is a compliance obligation, and licensed CPD misses go to Compliance immediately.
- Development plans are forward-looking and kept separate from PIPs; flag anyone two years at grade without documented progress.
- Sponsorship clawback runs twelve months from the confirmed completion date, pro-rata on total cost, enforceable only via the signed approval letter before any fees commit; redundancy, medical incapacity, and retirement are carve-outs.
- Review the curriculum map each Q4 with Compliance and publish by 15 January; push regulatory updates immediately, teaching the current Nigerian rule.

*Reference: HR Operations Manual v1.1, Part G (Chapters G1-G5); the LMS two-layer enforcement model and the WS7 learning architecture; mandatory cadence per the People Ops Cadence v1.0. Current law taught: Nigeria Data Protection Act 2023 and the 2025 General Application and Implementation Directive (regulator: NDPC), and the Investments and Securities Act 2025 (companion documents citing the 2019 regulation or the 2024 bill are logged for correction). This module is a navigation aid; the manual and Compliance are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-206';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_01$id$, m.id, $p$As LMS administrator, when do you publish the Annual Training Calendar?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "at the start of each year, in January"}, {"key": "b", "text": "at mid-year, in July"}, {"key": "c", "text": "only when a regulation changes"}, {"key": "d", "text": "at each employee's hire anniversary"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The calendar is published in January on the portal's L&D module and shared with every line manager.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_02$id$, m.id, $p$Which training is required of ALL staff?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "SEC continuing professional development"}, {"key": "b", "text": "AML/CFT awareness, data protection, securities-regulations overview, the PAD refresher, and IT security"}, {"key": "c", "text": "market conduct and conflicts of interest only"}, {"key": "d", "text": "health-and-safety induction only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$AML/CFT, data protection, securities-regulations overview, the personal-account-dealing refresher, and IT security/phishing are all-staff. CPD is for licensed staff; H&S induction is for new joiners.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_03$id$, m.id, $p$Required completion of mandatory training is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a target of 80%"}, {"key": "b", "text": "one hundred percent; non-completion by the deadline is a breach of employment obligations"}, {"key": "c", "text": "optional for senior staff"}, {"key": "d", "text": "only enforced before an inspection"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$One hundred percent completion is not optional; an employee who misses a mandatory deadline is in breach of their employment obligations.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_04$id$, m.id, $p$In the portal, what actually makes a module due for everyone?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the is_mandatory flag (the \u201cMandatory\u201d pill) on its own"}, {"key": "b", "text": "a firm-wide assignment rule that enrols all active staff"}, {"key": "c", "text": "publishing the module"}, {"key": "d", "text": "adding it to the catalogue"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Mandatory is two layers: the is_mandatory flag drives the pill, but a firm-wide assignment rule is what actually enrols people. Confirm the rule, never rely on the pill alone.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_05$id$, m.id, $p$A licensed employee misses a CPD deadline. You...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "note it for the weekly summary"}, {"key": "b", "text": "notify Compliance immediately"}, {"key": "c", "text": "wait to see if they complete it late"}, {"key": "d", "text": "remove the requirement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A licensed-staff CPD miss carries regulatory consequences; Compliance must be notified immediately, not at week's end.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_06$id$, m.id, $p$How often do you review the LMS completion dashboard?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "weekly"}, {"key": "b", "text": "monthly"}, {"key": "c", "text": "quarterly"}, {"key": "d", "text": "only at year-end"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$You review the dashboard weekly, send reminders to those approaching deadlines, and escalate to the line manager when a deadline is within five working days.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_07$id$, m.id, $p$When a deadline is within five working days and a module is unstarted, escalation goes to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the Chairman"}, {"key": "b", "text": "the line manager, then the COO if still not completed"}, {"key": "c", "text": "the employee's family"}, {"key": "d", "text": "no one \u2014 you simply record it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Within five working days you escalate to the line manager; continued non-completion escalates to the COO.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_08$id$, m.id, $p$Which law and regulator govern data-protection training today?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the 2019 data protection regulation, regulator NITDA"}, {"key": "b", "text": "the Nigeria Data Protection Act 2023 and the 2025 directive, regulator the NDPC"}, {"key": "c", "text": "the GDPR, regulator the EU"}, {"key": "d", "text": "there is no governing law"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Teach the current law: the Nigeria Data Protection Act 2023 and the 2025 General Application and Implementation Directive, with the NDPC as regulator. The 2019 regulation is superseded.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_09$id$, m.id, $p$A development plan (PADP) and a performance improvement plan (PIP) are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the same document"}, {"key": "b", "text": "kept separate; the development plan is forward-looking, the PIP addresses a shortfall"}, {"key": "c", "text": "mutually exclusive \u2014 an employee can never have both"}, {"key": "d", "text": "both confidential governance records"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A development plan is forward-looking and positive; a PIP addresses a shortfall. An employee may have both, but the documents are kept separate.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_10$id$, m.id, $p$You flag to the COO any employee who has been at their current grade for more than...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "six months without a pay rise"}, {"key": "b", "text": "two years without documented development progress"}, {"key": "c", "text": "five years"}, {"key": "d", "text": "one year, automatically"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Flag anyone who has been at the same grade for more than two years without documented evidence of development progress.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_11$id$, m.id, $p$The qualification-sponsorship clawback window starts on...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the approval date"}, {"key": "b", "text": "the confirmed completion date set by the awarding body"}, {"key": "c", "text": "the date of the final exam"}, {"key": "d", "text": "the date the employee resigns"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The twelve-month window runs from the confirmed completion date the awarding body sets — not the approval, exam, or notification date — recorded in the portal.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_12$id$, m.id, $p$What makes a sponsorship clawback obligation contractually enforceable?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a note in the LMS"}, {"key": "b", "text": "the obligation appearing in the sponsorship approval letter, signed by the employee before any fees are committed"}, {"key": "c", "text": "a verbal agreement with the COO"}, {"key": "d", "text": "the staff handbook"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The clawback is only enforceable if its obligation is in the approval letter, signed before any fees are committed. Never commit funds before the signed letter is on file.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_13$id$, m.id, $p$Sponsorship costing ₦480,000 is completed; the employee resigns four months later. The clawback is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "\u20a6480,000 in full"}, {"key": "b", "text": "(8 \u00f7 12) \u00d7 \u20a6480,000 = \u20a6320,000"}, {"key": "c", "text": "(4 \u00f7 12) \u00d7 \u20a6480,000 = \u20a6160,000"}, {"key": "d", "text": "nothing \u2014 the qualification was completed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Eight of the twelve protection months remain, so the clawback is eight-twelfths of the total cost: ₦320,000, recovered from final pay where sufficient.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_14$id$, m.id, $p$Clawback does NOT apply where the employee leaves due to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "resignation to join a competitor"}, {"key": "b", "text": "redundancy, medical incapacity, or retirement"}, {"key": "c", "text": "dismissal for misconduct"}, {"key": "d", "text": "any voluntary resignation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Clawback is waived for redundancy, medical incapacity, and retirement. Anything not clearly in those three goes to the COO and, where needed, external counsel.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_15$id$, m.id, $p$The COO must decide a complete sponsorship application within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "two working days"}, {"key": "b", "text": "ten working days of receipt of the complete application"}, {"key": "c", "text": "one month"}, {"key": "d", "text": "the next quarter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The COO approves or declines within ten working days of receiving the complete application, and the decision is communicated to the employee in writing.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_16$id$, m.id, $p$When is the curriculum map reviewed, and with whom?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "in Q4, with Compliance, then published by 15 January"}, {"key": "b", "text": "in January, by People Ops alone"}, {"key": "c", "text": "only when an employee complains"}, {"key": "d", "text": "never \u2014 it is fixed at launch"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The map is reviewed annually in Q4 with Compliance and published with the next year's training calendar by 15 January.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_17$id$, m.id, $p$A new regulatory requirement lands mid-year. You...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "wait for the next annual cycle"}, {"key": "b", "text": "communicate it to all staff immediately and activate the updated module at the same time"}, {"key": "c", "text": "add it only to new joiners' plans"}, {"key": "d", "text": "leave it to Compliance to handle alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Material changes to mandatory requirements are communicated to all staff immediately, with the updated module activated at the same time rather than waiting for the annual cycle.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_18$id$, m.id, $p$Training completed outside the LMS (a conference or external course) is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ignored \u2014 only LMS modules count"}, {"key": "b", "text": "recorded manually as an attendance record with date, duration, and evidence"}, {"key": "c", "text": "counted only if Compliance attended"}, {"key": "d", "text": "added to the firm-wide mandatory list"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$External training is recorded manually in the LMS as an attendance record with date, duration, and evidence of completion, so the history stays whole.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_19$id$, m.id, $p$Securities-law training is taught under which statute?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the Investments and Securities Act 2025"}, {"key": "b", "text": "the 2024 bill, because the documents cite it"}, {"key": "c", "text": "the US Securities Act"}, {"key": "d", "text": "whichever the trainer prefers"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Teach the enacted statute — the Investments and Securities Act 2025 — even where companion documents still cite the 2024 bill. Concept travels; the binding rule is the current Nigerian one.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl206_20$id$, m.id, $p$Setting a module's “Mandatory” pill is enough to enrol all staff in it.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. The pill is only the flag; a firm-wide assignment rule is what actually enrols people. Always confirm the rule is in place.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-206'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;


-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-206';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-206 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-206' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-206 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-206 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
