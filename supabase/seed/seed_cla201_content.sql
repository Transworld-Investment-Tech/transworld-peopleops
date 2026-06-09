-- =============================================================================
-- seed_cla201_content.sql  (v0.64.0)
-- CLA-201: Client relationship management & retention — lesson + 20-question check (Proficient).
-- Authored FROM POLICY (Tier B) off the firm's own policies (read-first OCR; anchors confirmed).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps CLA-201 to live job profiles (confirm live: verify_p5.sql / matrix query).
--   Publish-only (the REG/OPS pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Most of what determines whether a client stays with Transworld for ten years or leaves within one is decided in two unglamorous places: how you handle the day something goes wrong, and whether you notice when a client quietly stops trading. Neither is about charm. Both are about discipline — logging, timelines, follow-through — and both are anchored in the Firm's own recent history. The NGX Risk-Based Supervision inspection of our complaint register for 2015 to 2025 found a pattern no broker wants to read about itself: unauthorised sales of client securities, unresolved inter-member transfer issues, and thirteen cases still outstanding, some dating back to 2015. This module treats that finding as what it really is — a retention failure as much as a compliance one — and shows you the machinery the Firm now runs so it never repeats.

## What you will be able to do

1. Run a complaint through the Service Tracker against the right clocks.
2. Classify a complaint by urgency and recognise the highest-priority category.
3. Use the Client Request Register and inbox discipline so nothing falls through the cracks.
4. Apply the Pre-Inactive Outreach Programme and distinguish inactive from dormant accounts.
5. See complaint handling and account retention as one continuous relationship discipline.

## The complaint as a retention moment

A complaint is not an attack; it is a client telling you they still care enough to ask for a fix. Handle it well and the relationship usually survives, often stronger. Handle it badly and you confirm the client's worst fear. The Complaint Management Policy v3.0 runs every case through the Service Tracker, and the steps are deliberately mechanical so that goodwill is never the thing keeping a case alive. You log the case immediately on receipt. You send an acknowledgement within twenty-four hours — no exceptions — so the client knows a human has the matter. You update the status at every milestone, and you contact the client proactively every three working days even when there is no news, because silence is what turns a complaint into a grievance. You escalate when the case needs more than the Client Relationship Officer can give. And you close the case properly, with the resolution recorded.

Over all of this sits one hard number: the ten working day rule. The SEC Rules Relating to the Complaints Management Framework of the Nigerian Capital Market require resolution within ten working days, and the Policy treats that as a ceiling, not a target — with a substantive update due to the client by the fifth working day. "We are looking into it" is not a substantive update, and letting that clock run quietly is precisely how thirteen cases became years old.

## Triage: not every complaint is equal

The Policy runs a colour-coded urgency framework because a delayed dividend query and an allegation of an unauthorised trade are not the same animal. The highest-priority category is the unauthorised-trade complaint — a client saying securities were bought or sold without their mandate. That is the exact failure the RBS inspection surfaced, it carries direct regulatory and legal exposure, and it goes straight to the top of the queue with immediate escalation to Compliance and Management. Every complaint, whatever its colour, is recorded in the Complaint Register, and the Service Tracker turns those individual entries into systemic intelligence: monthly and quarterly trend reports show recurring issues, and a complaint summary goes into the Board's quarterly report. A single complaint is a service event; a pattern of complaints is a control warning.

## Clearing the backlog and the hardest transfers

Two parts of the Policy exist precisely because of the RBS finding. The first is the De-Aging Programme, the structured campaign to clear legacy cases like the thirteen outstanding complaints, and it runs in three phases against the clock. Within thirty days of the Policy's adoption, every legacy case is identified, loaded into the Service Tracker, assigned to a named officer, and priority-classified by the Head of Operations. Within forty-five days, every legacy client is contacted personally by the Head of Operations or a senior officer and told their case has been reassigned and is now actively managed, with a specific named contact and phone number. And within sixty days, the specific obstacle to each resolution — a missing document, a third-party delay, a regulatory process — is identified, assigned an action and a target date, and pursued with daily effort. A case does not age quietly under the De-Aging Programme; it is owned and driven to closure.

The second is the dedicated framework for inter-member transfer complaints — the category that, alongside unauthorised trades, dominated the inspection findings. Because these transfers depend on another broker, they are the cases most likely to stall, so the Policy sets hard service standards. Documents are reviewed for completeness within seventy-two hours; transfer forms are submitted to the CSCS or receiving house within seven working days of complete documents and payment; active follow-up runs every three working days, never accepting silence from the receiving party as progress; the target completion is fourteen working days; and there is a hard ceiling — any transfer outstanding longer than twenty-one working days is a Critical escalation, with a formal written demand to the receiving house and the Compliance Officer, the Managing Director, and the Board Audit, Risk and Compliance Committee notified and the client briefed the same day. The lesson from the backlog is that the cases you do not actively drive are the ones that become years old.

## The operational backbone

Behind the complaint framework sits the everyday machinery of the Operational Manual. Section 20 requires that every client request — a mandate, an account update, a dematerialisation, a complaint — is recorded in the Client Request Register with the date received, the client and account, the type of request, the assigned officer and expected completion date, and progress to closure. The tracking rules echo the complaint clocks: acknowledge within twenty-four hours, assign a named responsible officer, update at each milestone and proactively flag delays, and have Operations and Compliance review the Register weekly to escalate overdue items. Section 21 governs the official client-service inbox — monitored throughout business hours, every request acknowledged within twenty-four hours with a reference number, a full resolution or status update inside one to three business days, and all correspondence archived in the CRM. Section 22 sets the complaints procedure proper, and its final step is the one people forget under pressure: follow up with the client to confirm they are satisfied with the resolution. A case is not closed because you sent a reply; it is closed because the client agrees it is.

## The proactive engagement standard

The thread running through all of this is a shift from reactive to proactive. Initial receipt is everyone's job, not just the relationship officer's: any staff member who receives a complaint — by phone, email, in person, or through the official inbox — must capture it and route it into the system the same day, because a complaint that is heard but never logged is the most dangerous kind. From there the Proactive Engagement Standard asks the Firm to anticipate rather than wait — to contact clients before they chase, to flag delays before the client notices them, and to treat every interaction as a chance to demonstrate the standard. The same proactivity feeds the regulator relationship: complaint statistics are submitted quarterly with the Firm's regulatory returns, an annual review is included in the Board report, and where a regulator asks, all records are produced within forty-eight hours. Handled this way, complaints and account-care stop being damage control and become the clearest evidence the Firm has of how it treats the people who trust it with their money.

## Preventing the drift: the inactive account

Retention is not only about rescuing relationships that have gone wrong. The quieter loss is the client who simply stops trading and is never called. Read the Inactive Accounts Policy's title carefully — "Management of Clients' Inactive Accounts" — and then read its actual purpose, stated plainly in the document: the primary aim is to prevent clients from becoming inactive in the first place. That is the Pre-Inactive Outreach Programme. The system flags accounts approaching inactivity well before the threshold, and the relationship officer reaches out — a call, a portfolio review, a reason to re-engage — while the relationship is still warm. The PIOP is not a one-off campaign but a rolling weekly discipline. Every Friday, each officer reviews their portfolio in the system, notes any client who has moved into Group 3 (At Risk) or Group 4 (Pre-Inactive), logs every contact from the prior week in the Service Tracker with a date, summary, and outcome, and schedules the week ahead — at least one contact a week for each Pre-Inactive client and one every two weeks for each At Risk client, each with a specific, relevant reason to reach out rather than a generic check-in. And where a client has already slipped, the re-activation procedure pairs that personal outreach with an incentive framework — for example a fee waiver or a referral incentive — to give a fading relationship a concrete reason to return.

The thresholds matter, and the Firm's history with them is instructive. Under the NGX Rules on Management of Clients' Inactive Accounts, an account that has not traded for three years (thirty-six months) is inactive. The RBS inspection found that the Firm had been wrongly treating one year as the threshold; the Policy corrects this firmly to the NGX three-year standard, with a full Board-approval framework. An account that remains inactive for a further twelve months — forty-eight months or more without trading — is classified as dormant, which triggers additional regulatory obligations and special management. Every inactive account is captured in the Inactive Accounts Register and monitored, and the Policy provides a re-activation procedure with an incentive framework to bring clients back. Crucially, re-activation is not a clerical event: a dormant account being woken up carries elevated AML/CFT risk, so re-engagement is integrated with enhanced due diligence — a point developed in the companion module on EDD.

## A worked example

**Illustration — one client, two failures avoided (entirely hypothetical).** A client who has not traded in eighteen months emails to say a stock was sold from their account that they never authorised. Two clocks start at once. The Client Request Register and Complaint Register both capture the case immediately; an acknowledgement goes out within twenty-four hours with a reference number. Because it alleges an unauthorised trade, it is the highest-priority colour and is escalated to Compliance and Management the same day — not parked for investigation. The officer reviews the mandates and transaction logs, sends the client a substantive written update by the fifth working day, and resolves the matter inside the ten-day ceiling, then follows up to confirm the client is satisfied. Separately, the PIOP flag that should have fired at the eighteen-month mark is reviewed: had the client been called proactively, the drift might have been caught earlier. One case, two lessons — the complaint resolved on the clock, and the retention gap that let the client go quiet in the first place addressed.

## Common traps

- **Treating acknowledgement as resolution.** A twenty-four-hour acknowledgement starts the relationship; the ten-working-day resolution finishes it.
- **Letting the clock run on "we're looking into it."** A substantive update is due by day five; vague holding replies are how cases age into years.
- **Down-classifying an unauthorised-trade complaint.** It is the highest priority and escalates to Compliance and Management immediately — never routine.
- **Closing a case without the client's agreement.** Step one of closure is confirming the client is satisfied, not sending a reply.
- **Assuming a quiet client is a happy client.** Silence is the early signal of attrition; the PIOP exists to act on it before the three-year line.

## Key takeaways

- The NGX RBS finding reframes complaint and account neglect as a retention failure; the Service Tracker and the registers exist so discipline, not goodwill, keeps every case alive.
- Acknowledge within twenty-four hours, update substantively by day five, resolve within the ten-working-day SEC ceiling, and confirm satisfaction before closing.
- Unauthorised-trade complaints are the highest priority and escalate to Compliance and Management immediately.
- The Operational Manual's Client Request Register, inbox discipline (resolution in one to three business days), and weekly Operations–Compliance review are the everyday backbone of relationship management.
- Inactive means no trade for three years; dormant means a further twelve months; the Pre-Inactive Outreach Programme aims to prevent inactivity, and re-activation is integrated with enhanced due diligence.

*Reference: the Complaint Management Policy v3.0 (the NGX RBS finding, the Service Tracker, the urgency framework, the ten-working-day rule, the Complaint Register and reporting schedule, the De-Aging Programme) and the Inactive Accounts Policy v3.0 (the Pre-Inactive Outreach Programme, the three-year inactive and forty-eight-month dormant thresholds, the Inactive Accounts Register, re-activation and the AML/CFT integration), with the Operational Manual v3.0 sections 20 to 22 (Client Request Register and tracking, inbox management, complaints handling). These policies are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'CLA-201';

-- 2) twenty graded questions (80%% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_01$id$, m.id, $p$The Service Tracker requires a complaint to be acknowledged within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ten working days"}, {"key": "b", "text": "twenty-four hours of receipt"}, {"key": "c", "text": "the same calendar month"}, {"key": "d", "text": "one hour"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Acknowledgement is due within twenty-four hours of receipt — no exceptions — so the client knows the matter is in hand.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_02$id$, m.id, $p$Under the SEC Complaints Management Framework, the resolution ceiling is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ten working days, with a substantive update by day five"}, {"key": "b", "text": "thirty calendar days"}, {"key": "c", "text": "whenever convenient"}, {"key": "d", "text": "three working days"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The SEC Rules require resolution within ten working days; the Policy treats this as a ceiling with a substantive update due by the fifth working day.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_03$id$, m.id, $p$Which complaint category is the highest priority?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a dividend query"}, {"key": "b", "text": "an address-change request"}, {"key": "c", "text": "an unauthorised-trade complaint"}, {"key": "d", "text": "a statement re-print request"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Unauthorised-trade complaints — the exact failure the RBS inspection surfaced — are the highest priority and escalate to Compliance and Management immediately.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_04$id$, m.id, $p$The NGX RBS inspection of the Firm's complaint register found...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no issues"}, {"key": "b", "text": "thirteen outstanding cases, some dating to 2015, including unauthorised sales of client securities"}, {"key": "c", "text": "only minor formatting errors"}, {"key": "d", "text": "that complaints were resolved too quickly"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The inspection found unauthorised sales of client securities, unresolved inter-member transfers, and thirteen cases still outstanding, some since 2015.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_05$id$, m.id, $p$Proactive client contact during an open complaint should occur at least every...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "thirty days"}, {"key": "b", "text": "three working days, even when there is no news"}, {"key": "c", "text": "six months"}, {"key": "d", "text": "only at closure"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Service Tracker requires proactive contact every three working days because silence is what turns a complaint into a grievance.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_06$id$, m.id, $p$A complaint case is properly closed when...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a reply has been sent"}, {"key": "b", "text": "the file is archived"}, {"key": "c", "text": "the client confirms satisfaction with the resolution"}, {"key": "d", "text": "ten days have passed"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Closure requires following up to confirm the client is satisfied — sending a reply is not the same as resolving the matter.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_07$id$, m.id, $p$Every client request must be recorded in the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Client Request Register, with assigned officer and expected completion date"}, {"key": "b", "text": "dealing ticket only"}, {"key": "c", "text": "personal notebook of the officer"}, {"key": "d", "text": "monthly payroll sheet"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Operational Manual section 20 requires all client requests to be logged in the Client Request Register with the assigned officer and expected completion date.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_08$id$, m.id, $p$Under inbox management (Operational Manual section 21), a full resolution or status update is expected within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one to three business days"}, {"key": "b", "text": "one hour"}, {"key": "c", "text": "one month"}, {"key": "d", "text": "ten working days"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Section 21 requires a complete resolution or status update within one to three business days, with the inbox monitored throughout business hours.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_09$id$, m.id, $p$Under the NGX Rules, an account is 'inactive' when it has not traded for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one year"}, {"key": "b", "text": "three years (thirty-six months)"}, {"key": "c", "text": "six months"}, {"key": "d", "text": "ten years"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The NGX Rules set inactivity at three years; the RBS inspection found the Firm wrongly using one year, which the Policy corrects.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_10$id$, m.id, $p$An account becomes 'dormant' when it has been inactive for a further...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one month"}, {"key": "b", "text": "twelve months (i.e., forty-eight months or more without trading)"}, {"key": "c", "text": "ten years"}, {"key": "d", "text": "one week"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Dormancy is reached when an account has been inactive for a further twelve months — forty-eight months or more — triggering additional regulatory obligations.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_11$id$, m.id, $p$The primary purpose of the Inactive Accounts Policy is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "close accounts quickly"}, {"key": "b", "text": "prevent clients from becoming inactive in the first place"}, {"key": "c", "text": "transfer balances to the Firm"}, {"key": "d", "text": "reduce paperwork"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Policy states plainly that its primary purpose is to prevent inactivity, delivered through the Pre-Inactive Outreach Programme.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_12$id$, m.id, $p$The Pre-Inactive Outreach Programme (PIOP) works by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "waiting for the client to call"}, {"key": "b", "text": "flagging accounts approaching inactivity and reaching out while the relationship is still warm"}, {"key": "c", "text": "charging a dormancy fee"}, {"key": "d", "text": "escalating to the SEC"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The PIOP flags accounts before the threshold so the relationship officer can re-engage proactively.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_13$id$, m.id, $p$Re-activating a dormant account requires special care because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is purely clerical"}, {"key": "b", "text": "it carries elevated AML/CFT risk and is integrated with enhanced due diligence"}, {"key": "c", "text": "it is forbidden"}, {"key": "d", "text": "it needs no checks"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A dormant account being woken up carries elevated AML/CFT risk, so re-activation is integrated with enhanced due diligence.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_14$id$, m.id, $p$Overdue items in the Client Request Register are caught by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an annual audit only"}, {"key": "b", "text": "a weekly Operations and Compliance review that escalates them"}, {"key": "c", "text": "the client noticing"}, {"key": "d", "text": "no defined process"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Section 20's tracking rules require Operations and Compliance to review the Register weekly and escalate overdue items.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_15$id$, m.id, $p$Monthly and quarterly complaint trend reports exist to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fill time"}, {"key": "b", "text": "turn individual complaints into systemic intelligence and feed the Board's quarterly report"}, {"key": "c", "text": "replace the Complaint Register"}, {"key": "d", "text": "be filed and ignored"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Tracker generates monthly and quarterly trend reports so recurring issues become systemic intelligence reported to the Board.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_16$id$, m.id, $p$A client emails alleging an unauthorised sale. The correct first actions are to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "investigate quietly for a month before logging"}, {"key": "b", "text": "log it immediately, acknowledge within twenty-four hours, and escalate to Compliance and Management the same day"}, {"key": "c", "text": "close it as resolved"}, {"key": "d", "text": "wait for the client to call again"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An unauthorised-trade allegation is logged immediately, acknowledged within twenty-four hours, and escalated to Compliance and Management at once.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_17$id$, m.id, $p$Which statement best captures the retention philosophy of this module?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "complaints are an attack to be deflected"}, {"key": "b", "text": "a complaint handled well can strengthen a relationship; silence and drift quietly lose clients"}, {"key": "c", "text": "quiet clients are the most loyal"}, {"key": "d", "text": "retention is purely a marketing function"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Complaints handled well strengthen relationships, while neglect and silence drive attrition — handling and retention are one discipline.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_18$id$, m.id, $p$Where a complaint involves regulatory matters or significant sums, the officer must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "resolve it alone"}, {"key": "b", "text": "escalate to Management or Compliance"}, {"key": "c", "text": "ignore it"}, {"key": "d", "text": "refund the client immediately without review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Section 22 requires escalation to Management or Compliance where a complaint involves regulatory matters, significant sums, or needs management authority.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_19$id$, m.id, $p$Client correspondence and Firm responses must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "deleted after reply"}, {"key": "b", "text": "archived in the CRM system or secure email archive"}, {"key": "c", "text": "kept on a personal phone"}, {"key": "d", "text": "printed and discarded"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Inbox management requires all client emails and Firm responses to be archived in the CRM or a secure email archive.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla201_20$id$, m.id, $p$The De-Aging Programme in the Complaint Management Policy exists to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "age cases deliberately"}, {"key": "b", "text": "resolve legacy cases such as the thirteen outstanding complaints"}, {"key": "c", "text": "delay new complaints"}, {"key": "d", "text": "reduce staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The De-Aging Programme is the structured initiative to clear the legacy backlog of outstanding cases the RBS inspection identified.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'CLA-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: CLA-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'CLA-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: CLA-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: CLA-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
