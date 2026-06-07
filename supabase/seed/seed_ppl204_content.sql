-- =============================================================================
-- seed_ppl204_content.sql  (v0.61.0)
-- PPL-204: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches the calendar-year cycle and the canonical pay/compa model (floor 0.80).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl2xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Performance management is where the firm's promises to its people get kept or broken. Done well, it tells everyone honestly where they stand, channels the bonus pool to the work that earned it, and protects the firm from rating drift and favoritism. Done loosely, it becomes a once-a-year ritual that rewards whoever has the most generous manager. You do not own anyone's rating, but you own the cycle: the calendar, the calibration, the record. This module is the cycle, run on the calendar year, end to end.

## What you will be able to do

1. Run the annual performance cycle on the firm's calendar-year rhythm, milestone by milestone.
2. Drive goal-setting and the weekly continuous-tracking discipline.
3. Administer the mid-year and year-end reviews on time.
4. Prepare and run a defensible calibration session, including the Integrity Gate.
5. Keep ratings confidential until they are final, and file the calibration record correctly.

## The cycle runs on the calendar year

Transworld's performance cycle follows the **calendar year**, January to December, and the dates are fixed. Build your year around them.

- **January — goal-setting.** Each employee agrees objectives with their manager for the year ahead.
- **28 February — goal-sealing.** Goals are sealed in the portal. A sealed goal agreement is immutable evidence; it is the baseline the whole year is judged against, which is why the seal date is hard.
- **All year — continuous tracking.** Employees submit weekly performance progress reports; managers review and respond. This is a performance obligation, not optional, and your weekly job is to flag non-submitters to their line manager and escalate persistent non-submission to the COO.
- **July (by 31 July) — mid-year review.** A formal checkpoint against the sealed goals.
- **November–December (due 31 December) — year-end appraisal.** Employee self-assessment and manager assessment are both completed and submitted.
- **February–March of the following year — calibration.** Managers calibrate ratings across the firm under the COO.
- **April — bonus.** The bonus is paid in April against the prior year's audited financials.

Two notes save confusion. First, the cycle is the calendar year even though some older source material still carries June–May remnants; the portal and the PD Guides are canonical, and you teach January–December. Second, the bonus is paid in April, after the financials are audited — the firm does not pay a bonus against unaudited numbers.

## Goals and the weekly discipline

Good goals are specific, measurable against the role, and sealed on time. Each employee drafts **four to six goals** in the portal's My Performance module, and every goal must be **SMART** — Specific, Measurable, Achievable, Relevant to the scorecard and the department's objectives, and Time-bound within the cycle. Each goal maps to one of the three scorecard dimensions — primarily Results, but a goal can sit under Competencies or Behaviors. The line manager reviews within five working days and approves, requests changes, or returns with comments; goals that fail the SMART test are redrafted before submission.

The sealing on **28 February** matters more than people realize: once a goal is sealed the portal's immutability feature locks the text, and neither the employee nor the manager can edit it. It is the fixed reference for mid-year and year-end, and it cannot be quietly rewritten in December to match what actually happened. A genuine mid-cycle change — a role change, an organizational change — is handled as an **Amendment**: a new goal is appended to the record alongside the original, and the original sealed goal is never deleted or edited. The sealed goal record is a trust artifact, the basis for the year-end conversation, and anyone trying to adjust goals retrospectively outside the amendment route is undermining exactly that. Your part is to make sure every active employee has sealed goals by the deadline and to chase the stragglers before the seal closes.

The continuous-tracking phase is the part of the cycle most firms neglect and Transworld does not. Weekly progress reports keep performance visible all year, so that the year-end conversation is a summary of a known story rather than a surprise. Each week you check that reports are being submitted and that managers are engaging; a manager who has not looked at their team's reports for more than two weeks gets flagged. This weekly rhythm is also your early-warning system: a sudden drop in a strong performer's output shows up here long before appraisal.

## Mid-year and year-end

The **mid-year review** in July is a formal checkpoint, not a casual one. You issue manager guidance in the first week of July, track completion, and escalate any manager who has not completed their reviews by 25 July. It is the moment to correct course while there is still half a year to act — to reset a goal through the amendment route if the business has genuinely changed, to put support around a struggling performer, or simply to confirm that a strong year is on track. Because the weekly progress reports have kept performance visible all along, neither the mid-year nor the year-end should ever surprise anyone; if a conversation produces a shock, the continuous-tracking discipline has quietly failed, and that is itself something to fix.

The year-end conversation is also where the **development path (PADP)** is reviewed: alongside the rating, the manager and employee look at the employee's PADP stage for their grade and agree the top two or three development priorities for the next cycle. Performance management at Transworld is therefore two things at once — an honest backward-looking judgment that funds reward, and a forward-looking development plan that grows the person. Keeping both in view is what stops the cycle from collapsing into a once-a-year score.

The **year-end appraisal** runs from early November, with both the employee's self-assessment and the manager's assessment due by **31 December**. The manager rates each target competency on the F/P/E scale and each of the **six behaviors — Mastery & Growth, Integrity Above All, Compliance by Default, Ownership Mentality, Trust Through Documentation, and Lifting Others — on a 1–5 scale**, based on observable conduct rather than assumptions about attitude. The portal then calculates the weighted average using the scorecard's three dimension weights — **Results, Competencies, and Behaviors** — where Competencies are never weighted below 20% (Business Development and Leadership sit at roughly 55/20/25, the revenue-free Administration family at about 50/25/25), and the manager confirms the output against a manual sanity check. That weighted rating drives a **proposed bonus multiplier**, which is why the appraisal is not an end in itself but the input to reward; for G4 and G5 employees, part of any bonus runs through the deferral ledger rather than being paid in full in April. One rule governs the whole appraisal: **do not discuss a preliminary rating with the employee before calibration.** A rating shared and then changed in calibration erodes trust; the rating is not final until calibration is complete.

## Calibration: making a 3 mean the same everywhere

Calibration exists because, without it, two people with identical performance can get different ratings purely because one manager is generous and another is severe. Calibration makes the scale mean the same thing across the firm — so that a 3 from one manager is a 3 from another — and keeps the distribution defensible and consistent with how the bonus pool is funded.

You prepare and administer it. You build the **Calibration Pack**: one row per active employee showing name, grade, job family, manager, the preliminary scorecard rating from the year-end assessment, and the proposed bonus multiplier. You circulate it to all managers and the COO **one week before** the session. The session is **chaired by the COO**, all line managers attend, and you attend as administrator and note-taker. The session reviews each proposed rating: ratings of 4 or 5 require supporting evidence of genuinely exceptional work, not merely competent; ratings of 2 or 1 require a documented development action — a PIP initiated or planned, or a disciplinary process underway for conduct-related low ratings. Calibrated ratings are agreed by consensus, but where a manager strongly disagrees, the **COO makes the final call**, and that decision is final.

### The Integrity Gate

Within calibration sits a hard stop. The **Integrity Gate**: any employee with a preliminary rating of **1 on either "Integrity Above All" or "Compliance by Default"** has their **bonus multiplier set to ×0.0** by the session chair, regardless of every other score. This is **non-negotiable**. The firm is a regulated capital-market operator; it cannot pay a performance bonus to someone who failed on integrity or compliance, however strong their results. The manager applies the same check at appraisal — confirming the multiplier is set to ×0.0 before submitting — and the chair confirms it in the session. There is no averaging around it.

After the session you record all calibrated ratings in the **Calibration Record**, which is **signed by the COO** and filed as a governance document, and you update the portal ratings **within two working days**. Calibration records are confidential governance documents that must not be shared with employees. If an employee asks about the process, you explain only that ratings are reviewed for consistency before being finalized — you never describe another employee's rating or the content of calibration discussions.

## A worked example

**Illustration — the strong year, the failed gate (entirely hypothetical).** An investment-side employee has an outstanding results year — the manager's preliminary appraisal puts the competency and results scores at a 4. But during the year the employee was found to have bypassed a compliance control, and the manager has rated "Compliance by Default" at 1 on observable conduct. You build the Calibration Pack with that preliminary rating visible. In the session, the COO applies the Integrity Gate: the ×0.0 multiplier is set, regardless of the strong results, because the gate is non-negotiable. The employee's other scores are not averaged against the failure — the bonus multiplier is zero. A documented development or disciplinary action is recorded against the low compliance rating. You note the consensus, the COO signs the Calibration Record, you update the portal within two working days, and you say nothing to the employee about the calibration discussion. The system did exactly what it is built to do: rewarded the work, but refused to pay for an integrity failure.

## Common traps

- **Letting goals seal late.** The 28 February seal is the year's baseline; chase stragglers before it closes.
- **Treating weekly tracking as optional.** It is a performance obligation and your early-warning system; flag non-submitters and disengaged managers.
- **Sharing a preliminary rating before calibration.** The rating is not final until calibration; sharing early erodes trust.
- **Averaging around the Integrity Gate.** A 1 on Integrity Above All or Compliance by Default forces ×0.0 — non-negotiable, regardless of other scores.
- **Disclosing calibration content.** The Calibration Record is confidential; explain only that ratings are reviewed for consistency.

## Key takeaways

- The performance cycle runs on the calendar year: goals set in January and sealed 28 February, weekly tracking all year, mid-year by 31 July, year-end due 31 December, calibration February–March, bonus in April against audited financials.
- Sealed goals are immutable baselines; weekly progress reports keep performance visible and act as an early-warning system.
- Year-end rates competencies on F/P/E and the six behaviors 1–5 on observable conduct; preliminary ratings are never shared before calibration.
- Calibration (COO-chaired, People Ops administering) makes the scale consistent and funds the bonus pool defensibly; 4/5 need evidence, 2/1 need a documented action.
- The Integrity Gate forces a ×0.0 bonus multiplier for a rating of 1 on Integrity Above All or Compliance by Default — non-negotiable; the Calibration Record is COO-signed, confidential, and reflected in the portal within two working days.

*Reference: HR Operations Manual v1.1, Part E (Chapters E1–E5) and WS5 Performance & Discipline + the Competency, Scorecard & Reward Framework (Transworld); cycle milestones per the People Ops Cadence v1.0; the calendar-year cycle and dates per the Performance & Development Guides (canonical). This module is a navigation aid; the manual and the PD Guides are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-204';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_01$id$, m.id, $p$Transworld's performance cycle runs on which calendar?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "June to May"}, {"key": "b", "text": "The calendar year, January to December"}, {"key": "c", "text": "April to March (the bonus year)"}, {"key": "d", "text": "A rolling 12 months from each employee's hire date"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The cycle runs on the calendar year, January–December. The portal and PD Guides are canonical; older June–May remnants are superseded.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_02$id$, m.id, $p$By what date are goals sealed in the portal?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "31 January"}, {"key": "b", "text": "28 February"}, {"key": "c", "text": "31 March"}, {"key": "d", "text": "1 April"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Goals are sealed by 28 February. A sealed goal agreement is immutable evidence and the baseline the year is judged against.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_03$id$, m.id, $p$The Integrity Gate means that an employee with a preliminary rating of 1 on Integrity Above All or Compliance by Default has their bonus multiplier set to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "\u00d70.5"}, {"key": "b", "text": "\u00d70.0, regardless of other scores"}, {"key": "c", "text": "the firm average"}, {"key": "d", "text": "\u00d71.0, but with a warning"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Integrity Gate is non-negotiable: a 1 on either Integrity Above All or Compliance by Default forces a ×0.0 bonus multiplier, regardless of every other score.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_04$id$, m.id, $p$Who chairs the calibration session?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops"}, {"key": "b", "text": "The COO"}, {"key": "c", "text": "The most senior line manager"}, {"key": "d", "text": "The Chairman"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The COO chairs the calibration session; all line managers attend and People Ops attends as administrator and note-taker.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_05$id$, m.id, $p$Why does calibration exist?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "To speed up the appraisal paperwork"}, {"key": "b", "text": "To make a rating mean the same across the firm and keep the distribution defensible and consistent with bonus funding"}, {"key": "c", "text": "To let employees challenge their managers"}, {"key": "d", "text": "To replace the year-end appraisal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Without calibration, identical performance can get different ratings by manager generosity. Calibration makes a 3 from one manager equal a 3 from another and keeps the distribution defensible.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_06$id$, m.id, $p$When is the bonus paid, and against what?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "December, against forecast figures"}, {"key": "b", "text": "April, against the prior year's audited financials"}, {"key": "c", "text": "January, against unaudited management accounts"}, {"key": "d", "text": "Whenever the RemCom chooses"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The bonus is paid in April against the prior year's audited financials — the firm does not pay against unaudited numbers.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_07$id$, m.id, $p$A manager wants to share a preliminary rating with their employee before calibration. You advise...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "go ahead \u2014 transparency is best"}, {"key": "b", "text": "do not \u2014 the rating is not final until calibration; sharing early erodes trust"}, {"key": "c", "text": "share it only if the rating is high"}, {"key": "d", "text": "share the whole calibration pack with the team"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Preliminary ratings are not discussed before calibration. A rating shared and then changed in calibration creates confusion and erodes trust.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_08$id$, m.id, $p$The mid-year review must be completed by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "30 June"}, {"key": "b", "text": "31 July"}, {"key": "c", "text": "30 September"}, {"key": "d", "text": "31 December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The mid-year review is held in July (by 31 July); People Ops issues guidance in the first week of July and escalates any manager not done by 25 July.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_09$id$, m.id, $p$What does the Calibration Pack contain, per employee row?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only the employee's name and rating"}, {"key": "b", "text": "Name, grade, job family, manager, preliminary scorecard rating, and proposed bonus multiplier"}, {"key": "c", "text": "Salary history and bank details"}, {"key": "d", "text": "The employee's self-assessment text only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each row shows name, grade, job family, manager, the preliminary scorecard rating from the year-end assessment, and the proposed bonus multiplier; circulated one week before the session.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_10$id$, m.id, $p$A rating of 4 or 5 (Exceeds / Outstanding) in calibration requires...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no justification \u2014 the manager's word is enough"}, {"key": "b", "text": "supporting evidence of genuinely exceptional work, not merely competent"}, {"key": "c", "text": "the employee's written consent"}, {"key": "d", "text": "a second interview"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Ratings of 4 or 5 require supporting evidence describing what was genuinely exceptional — not just competent performance.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_11$id$, m.id, $p$Weekly performance progress reports are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "optional and informal"}, {"key": "b", "text": "a performance obligation; non-submitters are flagged and persistent non-submission escalated to the COO"}, {"key": "c", "text": "only required during probation"}, {"key": "d", "text": "submitted once a quarter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Continuous tracking via weekly reports is a performance obligation, not optional. People Ops flags non-submitters to managers and escalates persistent cases to the COO.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_12$id$, m.id, $p$Where a manager strongly disagrees with the calibration consensus, the final decision rests with...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a vote of all managers"}, {"key": "b", "text": "the COO, whose decision is final"}, {"key": "c", "text": "People Ops"}, {"key": "d", "text": "the employee"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Calibrated ratings are agreed by consensus, but where a manager strongly disagrees the COO makes the final call, and that decision is final.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_13$id$, m.id, $p$After calibration, the Calibration Record is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "emailed to all staff for transparency"}, {"key": "b", "text": "signed by the COO, filed as a governance document, and kept confidential; portal ratings updated within two working days"}, {"key": "c", "text": "discarded once ratings are entered"}, {"key": "d", "text": "given to each employee for their file"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Calibration Record is signed by the COO and filed as a confidential governance document; portal ratings are updated within two working days. It is never shared with employees.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_14$id$, m.id, $p$Behaviors are rated on a 1–5 scale based on...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the manager's sense of the employee's attitude and intent"}, {"key": "b", "text": "observable conduct \u2014 specific examples of what the employee actually did or did not do"}, {"key": "c", "text": "the employee's self-rating only"}, {"key": "d", "text": "the compa-ratio"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Behavior ratings must be based on observable conduct — specific examples — not assumptions about attitude or intent.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_15$id$, m.id, $p$A sealed goal agreement can be quietly rewritten in December to match what actually happened.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$A sealed goal is immutable evidence — the fixed reference for mid-year and year-end. It cannot be rewritten after sealing.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_16$id$, m.id, $p$An employee asks you to explain how their rating was decided in calibration. You should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "walk them through the whole calibration discussion"}, {"key": "b", "text": "explain only that ratings are reviewed for consistency before being finalized, without describing others' ratings or the discussion"}, {"key": "c", "text": "share the Calibration Pack"}, {"key": "d", "text": "refuse to acknowledge that calibration exists"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Calibration records are confidential. You explain only that ratings are reviewed for consistency before being finalized — never describing other employees' ratings or the content of discussions.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_17$id$, m.id, $p$The year-end self-assessment and manager assessment are both due by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "30 November"}, {"key": "b", "text": "31 December"}, {"key": "c", "text": "28 February"}, {"key": "d", "text": "the calibration session"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The year-end appraisal runs from early November with both the self-assessment and the manager assessment due by 31 December.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_18$id$, m.id, $p$A rating of 2 or 1 (Below Expectations / Unsatisfactory) in calibration requires...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "nothing further"}, {"key": "b", "text": "a documented development action \u2014 a PIP initiated or planned, or a disciplinary process for conduct-related low ratings"}, {"key": "c", "text": "automatic dismissal"}, {"key": "d", "text": "a pay rise to motivate improvement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Low ratings require a documented development action: a PIP has been or will be initiated, or a disciplinary process is underway for conduct-related low ratings.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_19$id$, m.id, $p$An employee has outstanding results (4s) but was rated 1 on Compliance by Default for bypassing a control. The bonus multiplier is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "averaged out to roughly \u00d70.7 given the strong results"}, {"key": "b", "text": "set to \u00d70.0 by the Integrity Gate, regardless of the strong results"}, {"key": "c", "text": "left at \u00d71.0 because results dominate"}, {"key": "d", "text": "decided by the employee's manager alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Integrity Gate is non-negotiable and is not averaged: a 1 on Compliance by Default (or Integrity Above All) forces a ×0.0 multiplier regardless of other scores.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl204_20$id$, m.id, $p$The portal calculates the appraisal's weighted average using...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an equal weight for every dimension"}, {"key": "b", "text": "the scorecard's dimension weights (which the family sets); the manager confirms it against a manual sanity check"}, {"key": "c", "text": "the employee's grade only"}, {"key": "d", "text": "the bonus pool size"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal applies the scorecard's dimension weights automatically; the manager confirms the output matches a manual calculation as a sanity check.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-204';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-204 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-204' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-204 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-204 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
