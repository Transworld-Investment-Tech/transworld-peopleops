-- seed_ldr202_content.sql — P9 v0.69.0
-- Publishes LDR-202 (lm_ldr202): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_ldr202' AND code = 'LDR-202') THEN
    RAISE EXCEPTION 'LDR-202 shell (lm_ldr202) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'Delegation as a development instrument, not workload relief: what to delegate, the delegation contract, coaching versus instructing, assessing where each person honestly sits on the Growth Ladder, and stretch assignments that build the next rung.',
  body = $tw_p9_ldr202$## Why you delegate

Most new leads think delegation is about their own workload — handing things off so they can get to the important work. That framing produces bad delegation, because it optimizes for the lead's calendar instead of the team's growth.

At Transworld, delegation is a development instrument first. Every person on your team is running two engines — a performance engine and a development engine — and you are the mechanic for both. WS5 puts the manager's job plainly: hold regular one-to-ones rather than saving feedback for reviews; give people time, space, and resources and the room to learn from mistakes; coach toward the next Growth-Ladder rung; and address underperformance early and fairly. Delegation is where most of that actually happens. A well-chosen, well-structured piece of delegated work is a one-to-one, a stretch, and a feedback opportunity rolled into one — and it produces real output for the firm while it teaches.

In a fifteen-person dealing member there is a second, harder truth: if work only happens when one specific person does it, the firm carries key-person risk on a desk-by-desk basis. Delegation is how capability spreads. The retreat called the old Transworld personality-driven, where one or two individuals made every decision; the new Transworld is meant to be system-driven, distributing responsibility on purpose. Your delegation choices are that principle at desk level.

## What to delegate — and what never to

Delegate work that is real. Token tasks teach nothing and insult the person's intelligence. The best candidates are pieces of your own current work that sit one notch above the person's demonstrated level: a reconciliation process they have watched but never owned, a client report they have contributed to but never drafted end to end, the weekly exceptions log, the preparation — not the delivery — of a management update.

Some things are never delegated, however capable the team. Your accountability: you can delegate the doing, never the answering-for. Conduct and disciplinary matters: investigations, hearings, and warnings follow the WS5 procedure and sit with the proper officers, not with a trusted senior on your desk. Your assessment duties: the year-end manager assessment, the calibration inputs, and the ratings conversation are yours personally — an assessment ghost-written by the team's senior is a corrupted assessment. And anything a policy assigns to a named role — approvals on the authorization matrix, control-function sign-offs — stays where the policy puts it, whatever your local convenience.

## The delegation contract

Delegation fails at the handover, almost always because the handover was a sentence when it needed to be a contract. The contract has four parts, and at this firm it lives in writing — a portal note, an email — because what is not documented did not happen.

**The outcome.** Not the task — the outcome. "Run the exceptions log" is a task. "Every exception identified, documented with justification, and routed for approval within its deadline, with the weekly summary ready by Thursday close" is an outcome. The person should be able to recognize success without asking you.

**The boundaries.** What they may decide alone, what needs your sign-off, what must escalate immediately. Boundaries are not distrust; they are the safety rails that make real authority transferable. An unstated boundary is a trap you have set for your own team member.

**The check-in cadence.** Agreed in advance, proportionate to risk and to the person's stage — perhaps fifteen minutes weekly for a new owner, tapering as evidence accumulates. Scheduled check-ins replace hovering. They also create the documented trail of support that year-end assessment and any later capability discussion will rely on.

**The resources.** The access rights, the templates, the policy references, the introduction to the counterpart on the other desk. Delegating an outcome without the resources to reach it is not development; it is a setup. LDR-204 treats this in full.

Then — and this is the discipline most leads fail — let them do it. Inside the boundaries, their way is allowed to differ from your way. If you redo the work after hours, you have converted the contract back into theater, and the person will know.

## Coaching versus instructing

Instruction transfers an answer. Coaching builds the machinery that produces answers. Both are legitimate; the skill is knowing which the moment needs.

Instruct when the matter is rule-bound, urgent, or safety-critical: a settlement deadline, a compliance requirement, an error in a client communication about to go out. There is no virtue in Socratic questioning while a contract note goes wrong. Coach when the situation has room in it — when the person could reach a sound judgment with better questions. The coaching move is to ask before telling: What have you considered? What does the policy say? What would you do if I were not here? Then let the silence work. The first answer is often a test balloon; the second is usually their real thinking.

A thirty-second sketch of the difference. A junior brings you a client letter and asks, "Is this okay to send?" The instructing answer marks it up and hands it back — fast, and the junior learns that you are the quality control. The coaching answer takes one minute longer: "Read it as the client. What would you want answered that isn't?" The junior finds the missing settlement date themselves, fixes it, and — this is the point — checks for it unprompted in every letter afterward. You bought a permanent improvement for sixty seconds. Multiply that across a year of questions and the compounding is the whole argument for coaching.

The one-to-one is where coaching lives. WS5 is explicit that managers hold regular one-to-ones rather than saving feedback for reviews — the cycle's continuous-tracking phase runs March to October precisely so that nothing said at year-end is a surprise. A good one-to-one is the team member's meeting, not yours: their progress, their blockers, their development; your status questions can ride the weekly report instead.

When you do give feedback in these conversations, give it specifically. The firm's standard structure is the SBI model — Situation, Behavior, Impact — which LDR-203 teaches in full alongside the rest of the performance cycle. For now, hold the principle: feedback that names a specific situation and an observable behavior can change behavior; feedback about personality cannot.

## Assessing where each person honestly is

You cannot develop someone from where you wish they were. The Manager PD Guide makes honest stage assessment the foundation of all development support: the Growth Ladder's stages — Learn & Deliver, Collaborate, Lead a Team or Domain, Lead Teams and Functions, Cast Vision — each have observable characteristics, and your job is to assess where each team member genuinely sits, not where their grade says they should be or where they believe they are.

The PD Guide's worked illustration is worth carrying around. Two G2s, identical weighted scores of 3.8, who look equivalent on paper. One performs well at the Collaborate stage when the situation is clear — and defaults to Learn & Deliver behaviors the moment things turn ambiguous or pressured. The other is beginning to demonstrate G3 behaviors unprompted: identifying a systemic inefficiency and fixing it, informally mentoring a junior for months, resolving a complex client situation alone and briefing the manager afterward rather than before. The gap between performs at the stage sometimes and embodies the stage consistently is the gap between a good G2 and a G3-ready G2 — and the two development plans that follow are completely different. One strengthens consistency under pressure; the other formalizes leadership evidence ahead of a serious grade-review conversation.

The most damaging error is the generous one: telling someone they are at the next stage before the evidence supports it. It feels encouraging. It creates a false expectation, guarantees disappointment when the grade review does not arrive on the imagined timeline, and — worst — tells the person the transition is already made, so they stop working on the behaviors that would actually complete it.

## Stretch assignments

A stretch assignment is delegation aimed deliberately at the next rung: work selected because it demands behaviors the person has not yet demonstrated, with support calibrated so that struggle is productive rather than destructive. The Employee Handbook names the firm's on-the-job development tools plainly — stretch assignments, cross-functional project work, job exposure beyond the home desk.

Good stretches at a firm this size are easy to find: representing the desk in a cross-functional onboarding case, owning a recurring report to management, running the team's preparation for an internal audit visit, training a new joiner on a process the person has just mastered. Pair every stretch with the contract — outcome, boundaries, cadence, resources — and name it honestly in the one-to-one: this is a stretch; struggling at first is expected; here is where the support is. A stretch the person does not know is a stretch just feels like being thrown into deep water.

One caution: stretch the work, not the hours. An assignment that simply adds volume teaches endurance, not capability — and at year-end you will have evidence of fatigue rather than growth.

### Worked example (hypothetical)

Emeka leads client operations at a Lagos dealing member. His G2 officer, Bisi, is reliable on routine onboarding but has never owned anything end to end. The desk's monthly client-reporting pack — currently Emeka's own task — is one notch above her level: real, recurring, visible.

He sets the contract in a portal note. Outcome: the pack accurate, complete, and with the Head of Operations two business days before month-end. Boundaries: Bisi decides format improvements alone; any data discrepancy goes to Emeka before the pack moves; anything touching a client complaint escalates immediately. Cadence: twenty minutes every Tuesday for the first two months. Resources: the template, read access to the source reports, and an introduction to the finance officer who owns two of the inputs.

The first month, the pack comes back with a misread of one input. The rescue moment arrives: it would take Emeka forty minutes to fix it himself, the old way. Instead he uses the Tuesday check-in to coach — What does the source report actually say? Where would you verify it? — and Bisi finds and corrects the error herself, a day late but hers. He notes the episode and the correction in the portal. By month three the pack is early, Bisi has improved the format, and Emeka's weekly report to his own manager records a desk capability that did not exist a quarter ago. At year-end, the documented arc — contract, check-ins, error, correction, ownership — is exactly the evidence a development conversation needs.

## Common traps

The trusted-lieutenant trap: routing every stretch to your one proven person, which overloads them and starves everyone else's development. The boomerang trap: accepting work back the moment it gets hard — each rescue teaches the team that struggle summons the lead. The invisible-contract trap: delegating verbally and discovering at year-end that none of the development you supported exists on the record. The instruction habit: answering every question because answering is faster — faster today, dependence forever. And the equivalence trap: reading identical scores as identical readiness, when stage evidence — not the number — is what distinguishes them.

## Key takeaways

Delegate to develop, not merely to unload — and never delegate your accountability, your assessment duties, or what policy assigns elsewhere. Make every handover a written contract: outcome, boundaries, cadence, resources — then let people work inside it, their way. Coach where there is room for judgment; instruct where there is not; hold the one-to-one rhythm so feedback is continuous, not annual. Assess each person's Growth-Ladder stage honestly — embodied consistently, not performed occasionally — and never promise the next stage ahead of the evidence. Choose stretches that demand next-rung behaviors with support attached, and document the arc, because the development you cannot evidence is development the firm cannot see.

---

*Sources: HR WS5 Performance & Discipline Pack, Part 1; HR WS7 Learning & Development Pack, Part 2; Transworld Manager Performance & Development Guide v1.0, Part 6 (development support; stage assessment); Employee Handbook v2.1 (on-the-job development). Worked examples are hypothetical.*$tw_p9_ldr202$,
  estimated_minutes = 18,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_ldr202';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_ldr202_01', 'lm_ldr202', 'What is the primary purpose of delegation at Transworld?', 'SINGLE', '[{"key": "a", "text": "Reducing the lead''s workload so they can focus on senior tasks"}, {"key": "b", "text": "Development \u2014 building team capability while producing real output"}, {"key": "c", "text": "Testing employees before disciplinary decisions"}, {"key": "d", "text": "Distributing blame for risky decisions"}]'::jsonb, '["b"]'::jsonb, 'Delegation is a development instrument first; framing it as workload relief optimizes the lead''s calendar instead of the team''s growth.', 1, true),
  ('q_ldr202_02', 'lm_ldr202', 'Which of the following may a lead legitimately delegate?', 'SINGLE', '[{"key": "a", "text": "Their year-end manager assessments of team members"}, {"key": "b", "text": "A disciplinary investigation into a team member"}, {"key": "c", "text": "Preparation of a recurring management report they currently produce themselves"}, {"key": "d", "text": "An approval that the authorization matrix assigns to their role by name"}]'::jsonb, '["c"]'::jsonb, 'Real work one notch above the person''s demonstrated level is ideal. Assessments, disciplinary matters, and policy-assigned approvals are never delegated.', 2, true),
  ('q_ldr202_03', 'lm_ldr202', 'Why can a lead never delegate accountability?', 'SINGLE', '[{"key": "a", "text": "Because the portal has no field for transferring it"}, {"key": "b", "text": "Because accountability transfers automatically only at G4"}, {"key": "c", "text": "Because team members cannot be trusted with it"}, {"key": "d", "text": "Because you can delegate the doing but never the answering-for"}]'::jsonb, '["d"]'::jsonb, 'The work can move; the responsibility for its outcome stays with the lead, who answers for it regardless of who performed it.', 3, true),
  ('q_ldr202_04', 'lm_ldr202', 'What are the four parts of the delegation contract?', 'SINGLE', '[{"key": "a", "text": "Outcome, boundaries, check-in cadence, resources"}, {"key": "b", "text": "Task list, deadline, penalty, reward"}, {"key": "c", "text": "Goal, rating, multiplier, bonus"}, {"key": "d", "text": "Briefing, training, testing, certification"}]'::jsonb, '["a"]'::jsonb, 'A handover needs a defined outcome, decision boundaries, an agreed check-in rhythm, and the resources to succeed — in writing.', 4, true),
  ('q_ldr202_05', 'lm_ldr202', 'What distinguishes an outcome from a task in a delegation contract?', 'SINGLE', '[{"key": "a", "text": "Outcomes are always quarterly while tasks are weekly"}, {"key": "b", "text": "An outcome describes recognizable success \u2014 the person can know they have succeeded without asking the lead"}, {"key": "c", "text": "Tasks are written down while outcomes are verbal"}, {"key": "d", "text": "Outcomes apply only to G3 and above"}]'::jsonb, '["b"]'::jsonb, '''Run the exceptions log'' is a task; a defined standard of completeness, documentation, and timeliness is an outcome the owner can self-verify.', 5, true),
  ('q_ldr202_06', 'lm_ldr202', 'Why must the delegation contract be in writing at Transworld?', 'SINGLE', '[{"key": "a", "text": "Because verbal agreements are prohibited by the Handbook"}, {"key": "b", "text": "Because the SEC requires copies of all delegation records"}, {"key": "c", "text": "Because of the firm''s documentation discipline \u2014 what is not documented did not happen"}, {"key": "d", "text": "Because written contracts trigger automatic pay adjustments"}]'::jsonb, '["c"]'::jsonb, 'The development arc — contract, check-ins, support — must exist on the record to count as evidence at year-end.', 6, true),
  ('q_ldr202_07', 'lm_ldr202', 'What is the proper role of boundaries in delegated work?', 'SINGLE', '[{"key": "a", "text": "They signal which employees are not yet trusted"}, {"key": "b", "text": "They are safety rails that make real authority transferable \u2014 defining what is decided alone, what needs sign-off, what escalates"}, {"key": "c", "text": "They exist mainly to protect the lead at calibration"}, {"key": "d", "text": "They should be left unstated so the person learns judgment"}]'::jsonb, '["b"]'::jsonb, 'Boundaries are not distrust. An unstated boundary is a trap set for your own team member.', 7, true),
  ('q_ldr202_08', 'lm_ldr202', 'When is instructing — rather than coaching — the right move?', 'SINGLE', '[{"key": "a", "text": "Whenever the person is below G3"}, {"key": "b", "text": "Whenever the lead is short of time that week"}, {"key": "c", "text": "Never; coaching is always preferred at Transworld"}, {"key": "d", "text": "When the matter is rule-bound, urgent, or safety-critical, such as an error about to reach a client"}]'::jsonb, '["d"]'::jsonb, 'There is no virtue in Socratic questioning while a contract note goes wrong. Coach where there is room for judgment; instruct where there is not.', 8, true),
  ('q_ldr202_09', 'lm_ldr202', 'What is the essential coaching move described in the module?', 'SINGLE', '[{"key": "a", "text": "Ask before telling, then let the silence work"}, {"key": "b", "text": "Demonstrate the task once, then test the person"}, {"key": "c", "text": "Provide a written manual and schedule an exam"}, {"key": "d", "text": "Praise publicly and correct privately"}]'::jsonb, '["a"]'::jsonb, 'Questions like ''What have you considered? What would you do if I were not here?'' build the machinery that produces answers, rather than transferring one answer.', 9, true),
  ('q_ldr202_10', 'lm_ldr202', 'According to WS5, how should feedback be timed across the year?', 'SINGLE', '[{"key": "a", "text": "Concentrated in the year-end appraisal for maximum impact"}, {"key": "b", "text": "Continuously, through regular one-to-ones \u2014 not saved up for reviews"}, {"key": "c", "text": "Only at the July mid-year review"}, {"key": "d", "text": "Quarterly, in writing, copied to People Ops"}]'::jsonb, '["b"]'::jsonb, 'Managers hold regular one-to-ones rather than saving feedback for reviews; nothing at year-end should be a surprise.', 10, true),
  ('q_ldr202_11', 'lm_ldr202', 'Whose meeting is a good one-to-one?', 'SINGLE', '[{"key": "a", "text": "The lead''s \u2014 it exists to collect status updates"}, {"key": "b", "text": "People Ops'' \u2014 it is a compliance checkpoint"}, {"key": "c", "text": "The team member''s \u2014 their progress, blockers, and development; status can ride the weekly report"}, {"key": "d", "text": "The client''s \u2014 it reviews client feedback"}]'::jsonb, '["c"]'::jsonb, 'Status questions belong in the weekly report. The one-to-one is for the person''s progress, blockers, and growth.', 11, true),
  ('q_ldr202_12', 'lm_ldr202', 'Per the Manager PD Guide, what is the foundation of supporting someone''s development?', 'SINGLE', '[{"key": "a", "text": "Setting their goals slightly above their grade"}, {"key": "b", "text": "Honestly assessing where they genuinely sit on the Growth Ladder \u2014 not where their grade or their self-image says"}, {"key": "c", "text": "Matching them with a mentor at G4 or above"}, {"key": "d", "text": "Enrolling them in every available LMS module"}]'::jsonb, '["b"]'::jsonb, 'You cannot develop someone from where you wish they were. Stage assessment against observable characteristics comes first.', 12, true),
  ('q_ldr202_13', 'lm_ldr202', 'Two G2s have identical weighted scores of 3.8. What, per the PD Guide''s illustration, can still separate them?', 'SINGLE', '[{"key": "a", "text": "Their seniority in years at the firm"}, {"key": "b", "text": "Their attendance records"}, {"key": "c", "text": "The number of LMS modules each has completed"}, {"key": "d", "text": "Growth-Ladder stage evidence \u2014 one performs the stage when things are clear, the other embodies it consistently and shows next-stage behaviors"}]'::jsonb, '["d"]'::jsonb, 'The gap between ''performs at the stage sometimes'' and ''embodies the stage consistently'' is the gap between a good G2 and a G3-ready G2.', 13, true),
  ('q_ldr202_14', 'lm_ldr202', 'Why is telling someone they are at the next stage before the evidence supports it so damaging?', 'SINGLE', '[{"key": "a", "text": "It creates false expectations, guarantees disappointment, and often makes them stop working on the behaviors that would get them there"}, {"key": "b", "text": "It obliges the firm to initiate an immediate grade review"}, {"key": "c", "text": "It violates the calibration confidentiality rule"}, {"key": "d", "text": "It automatically raises their year-end rating"}]'::jsonb, '["a"]'::jsonb, 'The generous error is the damaging one: the person believes the transition is made and stops building it.', 14, true),
  ('q_ldr202_15', 'lm_ldr202', 'What defines a stretch assignment?', 'SINGLE', '[{"key": "a", "text": "Any task that increases the person''s weekly hours"}, {"key": "b", "text": "Any assignment the person has refused once before"}, {"key": "c", "text": "A rotation into a different job family for six months"}, {"key": "d", "text": "Work that demands behaviors from the next rung, with support calibrated so struggle is productive"}]'::jsonb, '["d"]'::jsonb, 'A stretch targets next-rung behaviors deliberately, with the contract and support attached — and the person told honestly that it is a stretch.', 15, true),
  ('q_ldr202_16', 'lm_ldr202', 'Why should a stretch assignment be named as a stretch to the person receiving it?', 'SINGLE', '[{"key": "a", "text": "Because the portal requires a stretch flag for tracking"}, {"key": "b", "text": "Because unnamed stretches earn no development credit at calibration"}, {"key": "c", "text": "Because a stretch the person does not know is a stretch just feels like being thrown into deep water"}, {"key": "d", "text": "Because People Ops must approve all stretch assignments in advance"}]'::jsonb, '["c"]'::jsonb, 'Naming it sets the expectation that early struggle is normal and points to where the support is.', 16, true),
  ('q_ldr202_17', 'lm_ldr202', 'In the worked example, what did Emeka do at the ''rescue moment'' when Bisi''s pack contained an error?', 'SINGLE', '[{"key": "a", "text": "Fixed it himself in forty minutes and told her afterward"}, {"key": "b", "text": "Escalated the error to the Head of Operations"}, {"key": "c", "text": "Withdrew the delegation and resumed producing the pack"}, {"key": "d", "text": "Used the scheduled check-in to coach her to find and correct it herself, then documented the episode"}]'::jsonb, '["d"]'::jsonb, 'Resisting the rescue converted the error into development — a day late, but hers — and the portal note made the arc evidence.', 17, true),
  ('q_ldr202_18', 'lm_ldr202', 'What is the ''boomerang trap''?', 'SINGLE', '[{"key": "a", "text": "Accepting delegated work back the moment it gets hard, teaching the team that struggle summons the lead"}, {"key": "b", "text": "Delegating the same task to two people at once"}, {"key": "c", "text": "Rotating assignments too frequently for anyone to learn"}, {"key": "d", "text": "Returning feedback without reading the work"}]'::jsonb, '["a"]'::jsonb, 'Each rescue trains the team to hand difficulty upward. The check-in is for coaching through difficulty, not absorbing it.', 18, true),
  ('q_ldr202_19', 'lm_ldr202', 'What is the ''trusted-lieutenant trap''?', 'SINGLE', '[{"key": "a", "text": "Routing every stretch to the one proven person, overloading them and starving everyone else''s development"}, {"key": "b", "text": "Promoting a deputy without Board approval"}, {"key": "c", "text": "Allowing a senior team member to run one-to-ones"}, {"key": "d", "text": "Trusting a team member''s self-assessment at year-end"}]'::jsonb, '["a"]'::jsonb, 'Concentrating development opportunities on one person creates fatigue at the top and stagnation everywhere else.', 19, true),
  ('q_ldr202_20', 'lm_ldr202', 'How does delegation at desk level serve the firm''s retreat commitment to being ''system-driven''?', 'SINGLE', '[{"key": "a", "text": "It reduces salary costs by shifting work to junior grades"}, {"key": "b", "text": "It removes the need for one-to-ones once contracts exist"}, {"key": "c", "text": "It spreads capability so work no longer depends on one specific person, reducing key-person risk"}, {"key": "d", "text": "It centralizes every decision with the lead for consistency"}]'::jsonb, '["c"]'::jsonb, 'The old personality-driven firm depended on one or two individuals; deliberate delegation distributes responsibility and capability on purpose.', 20, true)
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
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_ldr202' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_ldr202';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'LDR-202: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'LDR-202: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
