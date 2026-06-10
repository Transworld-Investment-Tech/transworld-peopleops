-- seed_ldr203_content.sql — P9 v0.69.0
-- Publishes LDR-203 (lm_ldr203): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_ldr203' AND code = 'LDR-203') THEN
    RAISE EXCEPTION 'LDR-203 shell (lm_ldr203) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'The manager''s side of the calendar-year performance cycle, end to end: goal-sealing by February 28, weekly reports and SBI feedback through the year, the evidence-first year-end assessment, the rating standards, and calibration. Pairs with FND-111.',
  body = $tw_p9_ldr203$## The two-engine responsibility

Every employee at Transworld runs two engines: a performance engine — the goals, the scorecard, the delivery — and a development engine — the growth toward the next Growth-Ladder rung. You have your own two engines running. As a line manager, you are also the mechanic for everyone else's. Running only one engine for your team — chasing delivery while development rusts, or coaching warmly while goals drift — is a failure of the manager role. The Manager PD Guide is built on that premise, and this module is its working summary, paired with FND-111, which teaches the same cycle from the employee's seat. Read together, they are the firm's contract: the employee owns their cycle; you run it fairly.

## The cycle at a glance

The performance cycle runs the calendar year, January 1 to December 31 — deliberately the same year as the firm's audited financials and the NGX reporting year, so the performance period being assessed matches exactly the profit period that determines the bonus pool. People Ops administers the cycle; the COO is the escalation point; you, the manager, do the substantive work. The phases:

**Goal setting — January to February 28.** The portal opens January 1. Every team member drafts goals; you guide, challenge, and approve; everything is sealed in the portal by February 28. This is a hard deadline, not a soft one.

**Continuous tracking — March to October.** Employees submit weekly progress reports in the portal; you read them, respond, give feedback, and keep your evidence log. People Ops checks submission monthly and flags non-submitters.

**Mid-year review — July, complete by July 31.** A structured conversation against the sealed goals, documented in the portal. People Ops issues guidance in the first week of July and escalates any manager still incomplete by July 25.

**Year-end appraisal — November to December 31.** Employee self-assessments and your manager assessments, both submitted by December 31.

**Calibration — February to March of the following year.** Managers meet, chaired with People Ops facilitation, to align standards; final ratings are recorded and communicated by end of March.

**Outcomes — April.** Confirmed ratings feed the bonus administration that pays in April, against a pool the Board's remuneration committee approves.

Hold the shape in your head: everything you do from January forward is building toward an assessment you can defend with evidence in November and at calibration in February.

## January and February: goals worth a year

The Guide's instruction for goal-setting is six words: guide without dictating, challenge without discouraging. The goals are the employee's — they draft, they own — but you are accountable for their quality, because the goals sealed in February will govern the year-end assessment. Weak goals set in January make fair year-end assessment impossible: vague goals can neither be exceeded nor missed, only argued about.

Press for goals that are specific enough to be evidenced, ambitious enough to matter, and connected to what the desk and the firm actually need this year. A useful challenge question from the Guide: will this person be more capable at year-end than they were in January? If the goal set cannot answer that, the development engine is missing from it.

Then enforce the deadline. By February 28, every team member's goals must be sealed in the portal. Employees without sealed goals have no benchmark for their year-end results — which is unfair to them, not just untidy for you. Any team member who has not submitted by mid-February needs a direct conversation, not a reminder email. Chasing is People Ops' job; the conversation is yours.

Goals are sealed, not frozen. When reality genuinely changes — a desk reorganized, a product discontinued, a regulatory change redrawing the work — file a formal mid-cycle amendment, documenting the change clearly. At year-end, the assessment runs against the amended goal. What you must never do is let a dead goal sit silently while everyone privately agrees to ignore it; silent agreements are exactly what calibration cannot see.

## March to November: the habits that decide December

The year-end assessment is not written in November. It is accumulated March through October, in two habits.

**Work the weekly reports.** The weekly progress report is the most powerful continuous management tool in the portal — your real-time window into whether goals are on track, development is progressing, and problems are still small. But it only works if you respond. An employee who submits detailed, evidence-rich reports and hears nothing will rationally let quality decay; one who gets a specific, engaged reply — even brief — keeps reporting properly and knows you are paying attention. The Guide's standard: for a strong report, acknowledge the specific achievement by name, answer the question raised, add one piece of targeted feedback — five minutes. For a vague report, ask one specific question that invites detail.

**Keep an evidence log.** A private, running note — in the portal or your own document — recording specific events worth referencing at year-end: the client save in April, the documentation lapse in June, the unprompted process fix in August. Memory is an impression machine; the log is what lets your November assessment cite facts.

The July mid-year review is these habits made formal: a documented conversation against the sealed goals — what is on track, what is off, what help is needed, and what the development engine has produced so far. Five months have passed since sealing; things change in five months. The mid-year is also where amendment conversations naturally surface. Complete it by July 31; document it in the portal.

## Feedback that changes behavior: SBI

Most feedback fails for one of three reasons: too vague to act on, too personal to be received well, or too late to be relevant. The firm's standard structure is the SBI model — Situation, Behavior, Impact — the simplest reliable structure for feedback specific enough to act on.

Name the **Situation** precisely: in Tuesday's client call with the pension administrator — not "lately." Describe the **Behavior** observably: you quoted the settlement timeline without checking the custodian's cut-off — not "you were careless," which is a character verdict, not an observation. State the **Impact**: the client planned against a date we then had to walk back, and the desk spent Thursday repairing it. Then stop, and let the conversation happen. SBI works in both directions — it carries praise as well as correction, and praise delivered with SBI precision teaches exactly what to repeat. Timeliness completes it: feedback in the week of the event changes behavior; feedback in December changes nothing about June.

## November and December: evidence first, impression second

By the time the year-end window opens in November, you should already know what you will write — because you have been reading weekly reports, holding one-to-ones, and logging evidence all year. The Guide names the common failure pattern bluntly: managers decide the rating from a general impression first, then assemble whatever evidence supports it. The discipline is the reverse — evidence first, impression second. Compare what actually happened against what was agreed in the sealed goals, read your log, read their reports and self-assessment, and let the rating emerge from the record.

The rating standards are firm-wide, and People Ops briefs every manager on them before the window opens:

**5 — Outstanding.** Genuinely exceptional and clearly differentiating: outcomes significantly beyond agreed targets and behaviors that set a standard others should aspire to. The top 5–10% of the firm. If your whole team is rated 5, your standards are too low.

**4 — Exceeds Expectations.** Consistently above the role's requirements — above target, strong competency development, the firm's behaviors modeled reliably. A strong rating, not a reward for doing the job well.

**3 — Meets Expectations.** The full requirements of the role, at the standard expected for the grade. A good result for an experienced, confirmed employee; the majority of the firm in a normal year.

**2 — Below Expectations.** Short of the required standard in one or more significant areas; a development plan initiated. A 2 must never be a surprise — the employee should have heard about the shortfall during the year, in SBI terms, when it could still be fixed.

**1 — Unsatisfactory.** Significantly below standard across the role; formal improvement action under way or being initiated. Factual, not punitive.

Two boundary notes. A 2 does not automatically mean a PIP — a 2 can reflect a shortfall that coaching and a development plan address; the PIP is for sustained underperformance that feedback has not corrected, and it follows its own defined process under Part E. And a PIP already running does not suspend the cycle: the person still has goals, still reports, and still receives a year-end rating.

## Calibration and the multiplier

Calibration exists for one reason: a 3 from one manager must mean the same as a 3 from another. In February–March, managers present their proposed ratings with evidence; the session — coordinated by People Ops with the COO — tests them against a common standard and against peers at the same grade. Arrive with your evidence log and expect to be challenged; a rating you cannot evidence is a rating you will lose. Calibration is not your assessment being overruled — it is the same standard being applied to everyone, which is the only thing that makes ratings worth anything.

Confirmed ratings then drive the scorecard's pay link: each rating band carries a bonus multiplier in the scorecard mechanics — the Meets Expectations band, for instance, applies a ×0.80 multiplier to the bonus calculation. Be precise with that number when you explain outcomes: it is the Meets-band bonus multiplier, and it has nothing to do with the compa-ratio floor used in pay-band positioning, which is a separate compensation concept from a different framework. Conflating the two in a ratings conversation is a small error that costs large credibility. Your job in the April conversation is to explain the rating with evidence and the mechanics accurately — and the rating should be the least surprising sentence of the employee's year.

### Worked example (hypothetical)

Ngozi manages Tobi, a G2 analyst. In February they sharpen his drafted goals — one is unevidenceable ("improve client service") and gets rebuilt around response times and documented saves — and seal by the 26th. Through the year Ngozi answers his weekly reports with specifics and logs events: a strong client recovery in April (praised in SBI form that week), a missed documentation step in June (corrected in SBI form that week, with the fix verified in July). The mid-year review in July confirms two goals on track, one amended formally after a product change.

In November, Ngozi writes the assessment from the record: targets exceeded on two goals, met on the amended one, the June lapse noted alongside its correction, competency growth evidenced from the reports. She proposes a 4. At calibration in February she is challenged to compare Tobi against other G2s; her log holds, and the 4 is confirmed. In the March conversation, Tobi hears nothing he has not heard during the year — which is the whole system working.

## Common traps

The impression-first assessment — deciding the number, then shopping for evidence. The surprise 2 — a below-expectations rating the employee hears for the first time in December, which indicts the manager's year more than the employee's. The recency trap — letting October outweigh March because memory does. The uniform team — everyone rated 4 to keep the peace, which calibration will dismantle along with your credibility. The silent dead goal — ignored by mutual understanding instead of formally amended. And the multiplier confusion — explaining pay outcomes with the wrong 0.80.

## Key takeaways

The cycle is the calendar year, and its dates are hard: sealed goals by February 28, mid-year by July 31, assessments by December 31, calibration to the same standard in February–March, outcomes in April. The assessment is accumulated, not composed: respond to weekly reports, log evidence, deliver SBI feedback in the week it matters. Rate evidence-first against the firm-wide standards, where 3 is the honest majority and 5 is rare. Bring evidence to calibration and accept its discipline — it is what makes a rating mean something. And measure yourself by one sentence: at year-end, nothing you say should be a surprise.

---

*Sources: Transworld Manager Performance & Development Guide v1.0 (Parts 1–5, 6.5 and Appendix E — SBI); HR Operations Manual v1.1, Part E (E1 cycle administration, E3 mid-year, E4 calibration, E5 rating standards, E6 scorecard, E7 PIP boundary); HR WS5 Performance & Discipline Pack. Pairs with FND-111 (employee side). Worked examples are hypothetical.*$tw_p9_ldr203$,
  estimated_minutes = 20,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_ldr203';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_ldr203_01', 'lm_ldr203', 'What period does the Transworld performance cycle cover, and why?', 'SINGLE', '[{"key": "a", "text": "January 1 to December 31 \u2014 aligned with the firm''s audited financials and NGX reporting year, so the assessed period matches the profit period that determines the bonus pool"}, {"key": "b", "text": "June to May, to avoid the year-end audit season"}, {"key": "c", "text": "April to March, matching the government fiscal year"}, {"key": "d", "text": "A rolling twelve months from each employee''s hire date"}]'::jsonb, '["a"]'::jsonb, 'The calendar-year cycle is deliberate: the performance period assessed matches exactly the profit period that funds the bonus pool.', 1, true),
  ('q_ldr203_02', 'lm_ldr203', 'What is the goal-sealing deadline, and how firm is it?', 'SINGLE', '[{"key": "a", "text": "March 31, extendable by the manager"}, {"key": "b", "text": "February 28 \u2014 a hard deadline; unsealed goals leave the employee with no benchmark for year-end assessment"}, {"key": "c", "text": "January 31, with a grace period to April"}, {"key": "d", "text": "Whenever the mid-year review takes place"}]'::jsonb, '["b"]'::jsonb, 'By February 28 every team member''s goals must be sealed in the portal. It is explicitly not a soft deadline.', 2, true),
  ('q_ldr203_03', 'lm_ldr203', 'What is the manager''s stance during goal-setting, per the Guide?', 'SINGLE', '[{"key": "a", "text": "Write the goals personally to guarantee quality"}, {"key": "b", "text": "Stay out of it entirely \u2014 goals are the employee''s business"}, {"key": "c", "text": "Guide without dictating, challenge without discouraging"}, {"key": "d", "text": "Copy the previous year''s goals and adjust the numbers"}]'::jsonb, '["c"]'::jsonb, 'The goals are the employee''s to draft and own; the manager guides and challenges, and is accountable for their quality.', 3, true),
  ('q_ldr203_04', 'lm_ldr203', 'Why do weak goals sealed in February make fair year-end assessment impossible?', 'SINGLE', '[{"key": "a", "text": "The portal rejects assessments against weak goals"}, {"key": "b", "text": "Weak goals automatically convert to a rating of 3"}, {"key": "c", "text": "Calibration excludes any employee with vague goals"}, {"key": "d", "text": "Vague goals can neither be exceeded nor missed \u2014 only argued about"}]'::jsonb, '["d"]'::jsonb, 'The sealed goals are the benchmark; if they cannot be evidenced against, December becomes argument instead of assessment.', 4, true),
  ('q_ldr203_05', 'lm_ldr203', 'A team member''s sealed goal is overtaken mid-year by a genuine business change. What is the correct handling?', 'SINGLE', '[{"key": "a", "text": "File a formal mid-cycle amendment documenting the change; year-end runs against the amended goal"}, {"key": "b", "text": "Quietly agree with the employee to ignore that goal at year-end"}, {"key": "c", "text": "Unseal and rewrite the goal without documentation"}, {"key": "d", "text": "Rate the goal as met automatically in compensation"}]'::jsonb, '["a"]'::jsonb, 'Goals are sealed, not frozen — but changes go through the formal amendment. Silent dead goals are what calibration cannot see.', 5, true),
  ('q_ldr203_06', 'lm_ldr203', 'When must the mid-year review be completed, and what triggers escalation?', 'SINGLE', '[{"key": "a", "text": "By June 30; escalation if not done by June 15"}, {"key": "b", "text": "By July 31; People Ops escalates any manager still incomplete by July 25"}, {"key": "c", "text": "By August 31; escalation only if the employee complains"}, {"key": "d", "text": "Any time before November; no escalation applies"}]'::jsonb, '["b"]'::jsonb, 'Guidance issues in the first week of July; completion is due by July 31 with escalation of stragglers from July 25.', 6, true),
  ('q_ldr203_07', 'lm_ldr203', 'Per the Guide, what happens when a manager never responds to an employee''s detailed weekly progress reports?', 'SINGLE', '[{"key": "a", "text": "Nothing \u2014 reports are a compliance record, not a conversation"}, {"key": "b", "text": "People Ops takes over responding on the manager''s behalf"}, {"key": "c", "text": "The reporting requirement lapses for that employee"}, {"key": "d", "text": "Report quality decays \u2014 the employee reasonably concludes nobody is reading them"}]'::jsonb, '["d"]'::jsonb, 'Engaged, specific responses sustain quality reporting; silence teaches the employee that effort is wasted.', 7, true),
  ('q_ldr203_08', 'lm_ldr203', 'What is the Guide''s recommended response to a strong weekly report?', 'SINGLE', '[{"key": "a", "text": "A formal written commendation copied to People Ops"}, {"key": "b", "text": "Acknowledge the specific achievement by name, answer any question raised, add one piece of targeted feedback \u2014 about five minutes"}, {"key": "c", "text": "No response, to avoid inflating expectations"}, {"key": "d", "text": "Forward it to the COO as evidence"}]'::jsonb, '["b"]'::jsonb, 'Brief but specific engagement keeps the reporting channel alive and adds a coaching touch each week.', 8, true),
  ('q_ldr203_09', 'lm_ldr203', 'What is the purpose of the manager''s private evidence log?', 'SINGLE', '[{"key": "a", "text": "To satisfy the internal audit program''s sampling requirements"}, {"key": "b", "text": "To track attendance for payroll"}, {"key": "c", "text": "To record specific events through the year so the November assessment can cite facts rather than impressions"}, {"key": "d", "text": "To collect material for disciplinary hearings"}]'::jsonb, '["c"]'::jsonb, 'Memory is an impression machine; the running log of specific events is what makes an evidence-first assessment possible.', 9, true),
  ('q_ldr203_10', 'lm_ldr203', 'In the SBI model, which element is ''you quoted the settlement timeline without checking the custodian''s cut-off''?', 'SINGLE', '[{"key": "a", "text": "Situation"}, {"key": "b", "text": "Impact"}, {"key": "c", "text": "Intent"}, {"key": "d", "text": "Behavior"}]'::jsonb, '["d"]'::jsonb, 'It is the observable behavior — what the person did — as distinct from the situation (the call) and the impact (the walked-back date).', 10, true),
  ('q_ldr203_11', 'lm_ldr203', 'Why is ''you were careless'' poor feedback under SBI?', 'SINGLE', '[{"key": "a", "text": "It is a character verdict, not an observable behavior \u2014 too personal to be received and too vague to act on"}, {"key": "b", "text": "It is too short to be logged in the portal"}, {"key": "c", "text": "Carelessness can only be raised at the mid-year review"}, {"key": "d", "text": "SBI prohibits any negative feedback"}]'::jsonb, '["a"]'::jsonb, 'SBI replaces character judgments with named situations, observable behaviors, and stated impacts.', 11, true),
  ('q_ldr203_12', 'lm_ldr203', 'What is the common year-end failure pattern the Guide warns against?', 'SINGLE', '[{"key": "a", "text": "Submitting assessments before the employee''s self-assessment"}, {"key": "b", "text": "Deciding the rating from general impression first, then assembling evidence to support it"}, {"key": "c", "text": "Writing assessments longer than the portal field allows"}, {"key": "d", "text": "Rating development separately from performance"}]'::jsonb, '["b"]'::jsonb, 'The discipline is the reverse: evidence first, impression second — compare what happened against the sealed goals and the log.', 12, true),
  ('q_ldr203_13', 'lm_ldr203', 'Per the rating standards, who should receive a 5 — Outstanding?', 'SINGLE', '[{"key": "a", "text": "Anyone who exceeded at least one goal"}, {"key": "b", "text": "All confirmed employees with clean disciplinary records"}, {"key": "c", "text": "Roughly the top 5\u201310% of the firm \u2014 genuinely exceptional, clearly differentiating performance and standard-setting behaviors"}, {"key": "d", "text": "Whoever the desk votes as most valuable"}]'::jsonb, '["c"]'::jsonb, 'E5.2: if every employee in a team is rated 5, the manager''s standards are too low.', 13, true),
  ('q_ldr203_14', 'lm_ldr203', 'What does a rating of 3 — Meets Expectations represent at Transworld?', 'SINGLE', '[{"key": "a", "text": "A warning rating one step above a PIP"}, {"key": "b", "text": "The full requirements of the role at the grade''s expected standard \u2014 a good result, and the firm''s majority in a normal year"}, {"key": "c", "text": "An administrative placeholder pending calibration"}, {"key": "d", "text": "The minimum rating eligible for any bonus"}]'::jsonb, '["b"]'::jsonb, 'A 3 is the honest majority outcome and a good result for an experienced, confirmed employee — not a disappointment.', 14, true),
  ('q_ldr203_15', 'lm_ldr203', 'Why must a rating of 2 never be a surprise?', 'SINGLE', '[{"key": "a", "text": "Because surprise ratings are voided by the portal"}, {"key": "b", "text": "Because People Ops pre-announces all ratings below 3"}, {"key": "c", "text": "Because a 2 requires the employee''s written consent"}, {"key": "d", "text": "Because the employee should have received feedback about the shortfall during the year, when it could still be fixed"}]'::jsonb, '["d"]'::jsonb, 'A surprise 2 indicts the manager''s year of silence more than the employee''s performance.', 15, true),
  ('q_ldr203_16', 'lm_ldr203', 'Does a year-end rating of 2 automatically require a PIP?', 'SINGLE', '[{"key": "a", "text": "Yes \u2014 every 2 opens a PIP within five business days"}, {"key": "b", "text": "Yes, unless the COO waives it"}, {"key": "c", "text": "No \u2014 a 2 can be addressed by coaching and a development plan; the PIP is for sustained underperformance that feedback has not corrected"}, {"key": "d", "text": "No \u2014 PIPs were replaced by the disciplinary procedure"}]'::jsonb, '["c"]'::jsonb, 'The PIP has its own defined trigger and process under Part E; a 2 initiates a development response, not automatically a PIP.', 16, true),
  ('q_ldr203_17', 'lm_ldr203', 'An employee is on a PIP when the year-end window opens. What happens to their cycle?', 'SINGLE', '[{"key": "a", "text": "It continues \u2014 they keep goals, keep reporting, and still receive a year-end rating"}, {"key": "b", "text": "It is suspended until the PIP concludes"}, {"key": "c", "text": "They are rated 1 automatically"}, {"key": "d", "text": "Their assessment transfers to People Ops"}]'::jsonb, '["a"]'::jsonb, 'A running PIP does not suspend the cycle; the person remains inside it and is rated on the record.', 17, true),
  ('q_ldr203_18', 'lm_ldr203', 'What is the purpose of calibration?', 'SINGLE', '[{"key": "a", "text": "To let senior management adjust ratings to fit the bonus pool"}, {"key": "b", "text": "To audit managers'' portal usage"}, {"key": "c", "text": "To ensure a 3 from one manager means the same as a 3 from another \u2014 the same standard applied to everyone"}, {"key": "d", "text": "To give employees a forum to appeal their ratings"}]'::jsonb, '["c"]'::jsonb, 'Calibration tests proposed ratings against a common standard and against grade peers; it is what makes ratings comparable and credible.', 18, true),
  ('q_ldr203_19', 'lm_ldr203', 'In scorecard mechanics, what does the ×0.80 figure attached to the Meets Expectations band represent?', 'SINGLE', '[{"key": "a", "text": "The bonus multiplier applied in the bonus calculation for that rating band \u2014 a different concept from the compa-ratio floor used in pay-band positioning"}, {"key": "b", "text": "The compa-ratio floor of the employee''s pay band"}, {"key": "c", "text": "The proportion of goals that must be met for a 3"}, {"key": "d", "text": "The maximum salary increase percentage for the year"}]'::jsonb, '["a"]'::jsonb, 'The ×0.80 here is the Meets-band bonus multiplier. Conflating it with the compensation framework''s compa-ratio floor is a costly explanation error.', 19, true),
  ('q_ldr203_20', 'lm_ldr203', 'When do confirmed ratings turn into pay outcomes?', 'SINGLE', '[{"key": "a", "text": "Immediately upon the manager submitting the assessment in December"}, {"key": "b", "text": "At the July mid-year review"}, {"key": "c", "text": "In January, with the new goal-setting round"}, {"key": "d", "text": "In April \u2014 calibrated ratings feed the bonus administration, against a pool approved by the Board''s remuneration committee"}]'::jsonb, '["d"]'::jsonb, 'The sequence is assessment (by Dec 31) → calibration (Feb–Mar) → communication (by end March) → bonus payment in April.', 20, true)
ON CONFLICT (id) DO UPDATE SET
  module_id = EXCLUDED.module_id,
  prompt = EXCLUDED.prompt,
  type = EXCLUDED.type,
  options = EXCLUDED.options,
  correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation,
  sort_order = EXCLUDED.sort_order,
  active = EXCLUDED.active,
  updated_at = CURRENT_TIMESTAMP;

DO $$
DECLARE qn integer; st text;
BEGIN
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_ldr203' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_ldr203';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'LDR-203: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'LDR-203: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
