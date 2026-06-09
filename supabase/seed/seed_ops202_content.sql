-- =============================================================================
-- seed_ops202_content.sql  (v0.63.0)
-- OPS-202: Process documentation & building checklists — lesson + 20-question check (Proficient).
-- Authored FROM POLICY / BUILD+SOURCE off the firm's own manuals (read-first OCR).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps OPS-202 to live job profiles (verified live, query 3 / verify_p4.sql),
--   so publishing alone surfaces it as assigned work. Publish-only (REG pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$You already know how to follow a checklist; this module is about building one that holds up as a control. The difference matters more than it first appears. A checklist that someone follows by habit, with no owner, no evidence, and no escalation route, is not a control — it is a hopeful list. Internal audit treats it as a finding. A control that is documented to a standard, owned by a named person, and tested independently is something the firm can rely on and an inspector can verify. This module teaches the firm's standard for documenting a control, how to turn a control objective into operable check steps, and how to keep a procedure alive once it exists.

## What you will be able to do

1. Explain why documented process is itself a control, not administrative overhead.
2. Document a control to the firm's twelve-element standard.
3. Turn a control objective into clear, operable check steps.
4. Version, own, and maintain a procedure as conditions change.
5. Recognise a poorly documented control and the audit risk it carries.

## Why documented process is a control

The firm's Internal Control Framework holds a principle that reframes everything in this module: a control that happened but left no evidence is treated as a control that did not happen. Evidence is the signed checklist, the report, the system log, the reconciliation, the approval email, the minute. This is why documentation is not paperwork bolted onto the real work — it is what makes the work auditable, repeatable, and defensible. When a process lives only in one person's head, it leaves with that person, varies with their mood, and cannot be tested. When it is documented, it can be performed consistently by anyone in the role, reviewed independently, and improved deliberately. Documentation is how a good intention becomes a dependable control.

There is a second, quieter benefit. A firm of fifteen people carries real key-person risk: when a process lives only in one head, the firm is one resignation or one illness away from losing it. Documented procedures are how a small firm makes itself resilient — the work survives the person, a new joiner can be brought up to the standard quickly, and the COO or an examiner can see how a thing is actually done without having to ask the one person who knows. In a firm this size, documentation is not bureaucracy the firm can ill afford; it is exactly the discipline that lets a small team operate to the standard of a much larger one.

## The twelve-element standard

A control is not adequately documented merely because a policy mentions it or a checklist contains a tick box. The Internal Control Framework sets a standard: for each key control, the process owner must be able to identify twelve elements before the control is considered properly defined. They are the control objective (what risk or error does this prevent or detect), the risk addressed (which category from the Risk Register), the control activity (what happens, step by step), the control owner (who performs or oversees it), the reviewer or oversight owner (who independently challenges it), the frequency (real-time, daily, weekly, monthly, quarterly, annual, or event-driven), the system or manual source (which system, form, or document is used), the evidence retained (what is filed, for how long, and where), the exception criteria (what triggers an escalation), the escalation route (who is notified, within what timeframe), the related policy or procedure, and the testing approach (how and how often it is tested independently). This is the same standard internal audit uses to test whether a control is adequately designed. A control missing any element is, at minimum, a Medium-risk finding; a control missing the evidence, owner, or escalation elements is treated as a High-risk finding. Those three — evidence, owner, escalation — are the load-bearing elements, and they are the ones people most often leave out.

It helps to see why each of the twelve earns its place. The objective and the risk addressed keep the control honest — a control with no clear risk is a habit, not a control. The activity, the owner, and the reviewer make it operable and independent. The frequency and the system source make it schedulable and repeatable. The evidence retained makes it provable; the exception criteria and escalation route make it safe when something goes wrong; the related policy ties it to the rulebook; and the testing approach lets the third line confirm it works. Read together, the twelve are not a bureaucratic wish-list — they are the minimum a process owner needs to be able to say, with a straight face, "this control is designed, owned, and testable."

## From a control objective to operable steps

Documenting a control well starts at the objective and works outward. Name the risk first: what could go wrong, and would this control prevent it (stop it happening) or detect it (catch it after the fact)? Then write the activity as steps a competent colleague could follow cold, each one an observable action rather than an intention — "the Settlement Officer confirms the units are present in the client's CSCS account before the jobbing entry is released," not "ensure shares are available." Make every step produce or reference evidence, because a step that leaves no trace cannot be shown to have happened. Name who does it and who independently checks it; the two must be different people wherever segregation is possible. State what an exception looks like and where it goes. A good checklist is simply this discipline rendered short enough to use at the desk: each line a concrete action, in the order they happen, with the evidence and the escalation built in.

A few things separate a checklist that works from one that merely exists. It is ordered the way the work actually flows, so following it top to bottom is following the process. It has a clear stop rule — a point at which, if a check fails, you do not proceed but escalate. It records who completed it and when, because a signed checklist is itself the evidence the control happened. And it is short: a checklist that tries to capture every contingency becomes a document people skim rather than use, which is worse than a shorter one they actually run. The art is to carry the full twelve-element rigour in the documented control behind it, and expose only the operable steps on the checklist in front of the operator.

## A worked build: the mandate-verification control

Take a control the firm already runs — the seven-point mandate verification before a trade — and document it to the standard. The objective is to prevent the firm executing a trade on an invalid or unauthorised instruction. The risk addressed is operational and conduct risk around order handling. The activity is the seven checks performed in sequence before the jobbing entry is released; the owner is the Operations Officer; the reviewer is the Group Head, who approves the entry; the frequency is real-time, on every order; the source is the mandate on file and the pre-trade checklist; the evidence retained is the signed checklist filed in the portal; the exception criterion is any check that fails or any mismatch with the mandate; the escalation route is to the Head of Operations before execution; the related policy is the Operational Manual's pre-trade requirements; and the testing approach is the monthly trade sample and the quarterly audit. Documented this way, the control is not a slogan — it is a defined, ownable, testable thing, and the day-to-day checklist is just its first ten elements made short enough to run before the market opens. Notice what the exercise surfaces: if you cannot name the reviewer, you have found a segregation gap; if you cannot point to the retained evidence, you have found a High-risk finding waiting to happen; if the escalation route is "tell someone," you have not finished. Documenting an existing control to the standard is often how its weaknesses are discovered — which is the point.

## Keeping a procedure alive

A procedure is not finished when it is written; it is finished when it is maintained. The Framework expects controls to be reviewed after incidents, rule changes, audit findings, or significant process changes, and deficiencies to be tracked to verifiable closure. In practice this means every procedure carries a version and an owner, so there is one current copy and one person accountable for it, and superseded versions are retained rather than deleted. When the settlement cycle changes, when a system is replaced, when an audit finds a gap, the owner updates the document, re-issues it, and records what changed and why. A procedure that is written once and never touched drifts quietly away from how the work is actually done, and the gap between the document and the practice is exactly what an inspection finds. The Key Control Library in the Framework is both the reference for how each control area should be documented and the checklist a process owner uses to keep their own area current.

## A worked example

**Illustration — documenting a reconciliation control (entirely hypothetical).** An Operations Officer is asked to document the daily settlement reconciliation, which until now has lived in one colleague's routine. Following the standard, they write the objective (detect settlement breaks before they crystallise into losses), name it a detective control, and identify the risk from the Register. They write the activity as four steps — pull the bank statement, the trade settlement record, the cash book, and the CSCS statement; match them; investigate any difference; report the daily cash position to the CFO — each producing evidence. They name the Accounts Officer as owner and the Head of Accounts as reviewer, set the frequency as daily, point to the systems used, specify that the signed reconciliation and the cash-position note are filed in the portal, define an exception as any unexplained difference, and set the escalation route to the Head of Accounts the same day. They add the testing approach: the monthly review by Internal Control. They give it a version number and their name as owner. What was one person's habit is now a control the firm can rely on, hand to a new joiner, and prove to an inspector.

## Common traps

- **"The policy mentions it," so it must be controlled.** A mention is not documentation; the control needs all twelve elements.
- **A tick box with no owner or evidence.** Missing the owner, evidence, or escalation element is a High-risk finding, not a detail.
- **Writing steps as intentions.** "Ensure shares are available" is not a step; "confirm the units are in the CSCS account before release" is.
- **The same person performing and checking.** Where segregation is possible, the doer and the reviewer must differ.
- **Writing a procedure once and never revisiting it.** Controls are reviewed after incidents, rule changes, and audit findings; an unmaintained procedure drifts from reality.

## Key takeaways

- Documented process is a control: a control that left no evidence is treated as one that did not happen.
- The firm's twelve-element standard defines an adequately documented control; missing any element is at least a Medium finding, and missing evidence, owner, or escalation is a High finding.
- Build a control from its objective outward — name the risk, write observable steps, attach evidence, separate doer from reviewer, define the exception and escalation.
- A good checklist is the standard rendered short enough to use at the desk, each line a concrete action in order.
- Procedures carry a version and an owner and are reviewed after incidents, rule changes, audit findings, and process changes; the Key Control Library is the reference and the self-check.

*Reference: the Internal Control Framework v3.0 — the control philosophy (evidence-based control), the twelve-element control-documentation standard, and the Key Control Library — together with the pre-trade and mandate-verification requirements of the Operational & Procedure Manual v3.0. This module builds on the foundational checklist habits of FND-110 by teaching how to design, document, own, and maintain controls. The Framework is the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'OPS-202';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_01$id$, m.id, $p$This module differs from the foundational checklist module (FND-110) because it is about...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "following an existing checklist"}, {"key": "b", "text": "building, documenting, owning, and maintaining controls"}, {"key": "c", "text": "memorising the Operational Manual"}, {"key": "d", "text": "data entry speed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$FND-110 teaches using checklists; OPS-202 teaches designing, documenting, owning, and maintaining controls.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_02$id$, m.id, $p$The Internal Control Framework principle behind this module is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "controls should be informal to stay flexible"}, {"key": "b", "text": "a control that left no evidence is treated as a control that did not happen"}, {"key": "c", "text": "only IT can own controls"}, {"key": "d", "text": "documentation is optional for small firms"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Evidence-based control: a control that happened but left no trace is treated as not having happened. Evidence makes work auditable, repeatable, and defensible.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_03$id$, m.id, $p$How many elements must a process owner be able to identify for a control to be properly documented?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "four"}, {"key": "b", "text": "twelve"}, {"key": "c", "text": "seven"}, {"key": "d", "text": "twenty"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Framework's standard requires twelve elements for each key control.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_04$id$, m.id, $p$Which three elements, if missing, make a control a HIGH-risk finding?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "frequency, source, related policy"}, {"key": "b", "text": "evidence retained, control owner, escalation route"}, {"key": "c", "text": "objective, activity, testing approach"}, {"key": "d", "text": "reviewer, risk addressed, exception criteria"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Missing any element is at least a Medium finding; missing the evidence, owner, or escalation elements is treated as High risk — they are the load-bearing three.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_05$id$, m.id, $p$A control that 'prevents a risk happening' versus one that 'catches it after the fact' is the distinction between...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "manual and automated"}, {"key": "b", "text": "preventive and detective"}, {"key": "c", "text": "first-line and second-line"}, {"key": "d", "text": "internal and external"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Preventive controls stop a risk occurring; detective controls catch it after the fact. Naming which one you are documenting sharpens the objective.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_06$id$, m.id, $p$A well-written control step reads like...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "'ensure shares are available'"}, {"key": "b", "text": "'the Settlement Officer confirms the units are in the client's CSCS account before the jobbing entry is released'"}, {"key": "c", "text": "'be careful with settlement'"}, {"key": "d", "text": "'follow best practice'"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Steps are observable actions a colleague could follow cold, each producing or referencing evidence — not intentions like 'ensure' or 'be careful'.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_07$id$, m.id, $p$Why must each documented step produce or reference evidence?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "to make the document longer"}, {"key": "b", "text": "because a step that leaves no trace cannot be shown to have happened"}, {"key": "c", "text": "to satisfy the client"}, {"key": "d", "text": "it is not necessary"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Evidence is what allows the control to be tested and proven; a step with no trace is, for control purposes, unperformed.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_08$id$, m.id, $p$In documenting the mandate-verification control, who is the owner and who is the reviewer?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "both are the Operations Officer"}, {"key": "b", "text": "the Operations Officer owns it; the Group Head reviews and approves"}, {"key": "c", "text": "the client owns it; Compliance reviews"}, {"key": "d", "text": "there is no reviewer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Operations Officer performs the seven checks (owner); the Group Head approves the jobbing entry (independent reviewer), keeping doer and checker separate.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_09$id$, m.id, $p$Wherever segregation is possible, the person who performs a control and the person who checks it should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the same, for efficiency"}, {"key": "b", "text": "different people"}, {"key": "c", "text": "both external"}, {"key": "d", "text": "chosen at random each time"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The doer and the reviewer must differ where segregation is possible; this independence is part of an adequately designed control.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_10$id$, m.id, $p$The 'frequency' element answers...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "how much the control costs"}, {"key": "b", "text": "whether it runs real-time, daily, weekly, monthly, quarterly, annually, or event-driven"}, {"key": "c", "text": "who owns the control"}, {"key": "d", "text": "which system is used"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Frequency specifies the cadence of the control — from real-time through to event-driven.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_11$id$, m.id, $p$A checklist used at the desk is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a replacement for the documented control"}, {"key": "b", "text": "the twelve-element standard rendered short enough to use, each line a concrete action in order"}, {"key": "c", "text": "an informal aide-memoire with no status"}, {"key": "d", "text": "a marketing document"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The operable checklist is the documented control's first elements made short enough to run in practice — concrete actions in sequence, with evidence and escalation built in.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_12$id$, m.id, $p$When should a documented control be reviewed?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "never, once written"}, {"key": "b", "text": "after incidents, rule changes, audit findings, or significant process changes"}, {"key": "c", "text": "only every five years"}, {"key": "d", "text": "only if the owner leaves"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Framework expects review after incidents, rule changes, audit findings, and significant process or business changes, with deficiencies tracked to closure.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_13$id$, m.id, $p$Each procedure should carry...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no identifying information"}, {"key": "b", "text": "a version number and a named owner, with superseded versions retained"}, {"key": "c", "text": "the client's signature"}, {"key": "d", "text": "only the date it was first written"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A version and an owner give one current copy and one accountable person; superseded versions are retained rather than deleted.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_14$id$, m.id, $p$Why is an unmaintained procedure a risk?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it uses too much storage"}, {"key": "b", "text": "it drifts from how the work is actually done, and the gap is what an inspection finds"}, {"key": "c", "text": "it cannot be printed"}, {"key": "d", "text": "it is automatically deleted"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A procedure written once and never revisited drifts from practice; the gap between document and reality is precisely what an inspection surfaces.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_15$id$, m.id, $p$The Key Control Library in the Framework serves as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a list of staff names"}, {"key": "b", "text": "both the reference for how each control area should be documented and a self-check for process owners"}, {"key": "c", "text": "the payroll register"}, {"key": "d", "text": "the client database"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Section 6 applies the twelve-element standard to each control area, so it is both a reference and a compliance checklist for the owner of that area.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_16$id$, m.id, $p$'The policy mentions this control' means the control is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully documented"}, {"key": "b", "text": "not necessarily documented; documentation requires the twelve elements"}, {"key": "c", "text": "exempt from testing"}, {"key": "d", "text": "owned by the Board"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A mention in a policy is not documentation; the control still needs all twelve elements to be considered properly defined.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_17$id$, m.id, $p$Internal audit uses the twelve-element standard to test...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "staff punctuality"}, {"key": "b", "text": "whether a control is adequately designed"}, {"key": "c", "text": "client satisfaction"}, {"key": "d", "text": "the firm's share price"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The twelve-element standard is the basis on which internal audit tests control design adequacy.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_18$id$, m.id, $p$Documenting a process that lived only in one colleague's head primarily achieves...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "slower work"}, {"key": "b", "text": "a control that can be performed consistently, reviewed independently, handed to a new joiner, and proven to an inspector"}, {"key": "c", "text": "duplication for its own sake"}, {"key": "d", "text": "nothing of value"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Documentation turns personal habit into a dependable, testable, transferable control with an audit trail.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_19$id$, m.id, $p$The 'escalation route' element specifies...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "who is notified, and within what timeframe, when an exception occurs"}, {"key": "b", "text": "the control's cost"}, {"key": "c", "text": "which clients are affected"}, {"key": "d", "text": "the control's version number"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The escalation route names who is notified and the timeframe; it is one of the three load-bearing elements whose absence is a High-risk finding.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops202_20$id$, m.id, $p$A control built using only internal documents and house craft (no externally licensed material) reflects this module's build mode, which is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "FROM POLICY only"}, {"key": "b", "text": "BUILD+SOURCE — house craft plus the Operational Manual and the Internal Control Framework"}, {"key": "c", "text": "ADAPT from a textbook"}, {"key": "d", "text": "reproduced from a third-party manual"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$OPS-202 is BUILD+SOURCE: authored from house craft plus the firm's own Operational Manual and Internal Control Framework, with no externally licensed source.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'OPS-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: OPS-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'OPS-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: OPS-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: OPS-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
