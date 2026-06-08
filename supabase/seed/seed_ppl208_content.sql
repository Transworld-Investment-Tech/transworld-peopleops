-- =============================================================================
-- seed_ppl208_content.sql  (v0.62.0)
-- PPL-208: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches the weekly/monthly/quarterly/annual cadence on the calendar-year cycle.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl3xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Everything else in the People-Ops curriculum is a process; this module is the rhythm that runs them. The role does not work as a list of tasks done once — it works as a repeating cadence, week after week, month after month, quarter after quarter, with a fixed set of annual milestones underneath. The manual tells you how to do each task; the cadence tells you when, and in what order, so nothing falls through. Master the rhythm and the year runs itself; lose it and tasks pile up until something — a payroll deadline, a sealed goal, a training compliance rate — breaks. This module is that operating rhythm, end to end, on the firm's calendar year.

## What you will be able to do

1. Run the weekly checks that keep the portal and the people processes current.
2. Build each month around the fixed payroll deadlines and complete the no-fixed-date monthly tasks.
3. Execute the quarterly tasks, including the RemCom cycle and the quarter-end payroll check.
4. Deliver the annual milestones on the calendar-year performance cycle.
5. Handle event-triggered tasks and keep the Evidence Vault complete.

## The rhythm as a discipline

The portal is your constant companion and the system of record for every task in the cadence; populate your own calendar with every deadline at the start of the year, and make sure the COO knows your schedule, because several tasks need their sign-off. When you first take the role, one task is urgent above all others: the staff-file completion drive — eighteen files to a ninety-day target, completed before any SEC inspection finds them incomplete. Everything else is important; that one is urgent, and it runs alongside the ordinary rhythm rather than pausing it.

## Weekly: the checks that never skip

Six things recur every working week, and they take minutes if the portal is kept current and far longer if you let them accumulate, so build them into a fixed slot. Check the staff-file completeness dashboard for new gaps — missing documents, expired certifications, unsigned policies — and chase each toward eighteen of eighteen complete. Check the LMS mandatory-training dashboard and remind anyone approaching a deadline who has not started, escalating to the line manager when the deadline is within five working days. Review the leave queue for requests pending manager approval beyond three working days, and for missing documentation. Check that every active employee is submitting weekly performance progress reports, flagging non-submitters to their manager — this is a performance obligation, not optional. Respond to outstanding HR queries to the standard of same-day acknowledgment and resolution within two working days for straightforward matters. And check for any new joiner, leaver, or role change since last week, initiating the right event process for each.

## Monthly: build the month around payroll

The payroll control cycle is the dominant monthly task, with hard deadlines at fixed points you cannot move: input preparation by the 20th, the HumanManager run by the 22nd, the control cross-check by the 24th, dual authorization by the 25th, payment on the 28th, and evidence filed by the 30th. If a deadline falls on a weekend or holiday, move it to the last working day before it and plan the adjusted schedule at the start of the month. Around those dates sit the no-fixed-date monthly tasks: reconcile portal leave balances against HumanManager and flag unusual patterns; receive the monthly management-accounts summary from the CFO and track year-to-date revenue against the raise milestones; check the performance continuous-tracking phase is healthy and that managers are engaging, flagging any manager who has not looked at their team's reports for more than two weeks; check the deferred bonus ledger for any release falling due, which must be included in the cycle as an additional line and presented to the RemCom before payment; prepare and submit the monthly People Ops report to the COO covering headcount, payroll status, leave, training completion, and open matters; and run the compa-ratio report. On compa-ratio, flag to the COO anyone below the canonical 0.80 floor as a priority for the next raise and anyone above 1.15 as needing review before a further increase — a companion note still cites 0.85, but teach and apply 0.80.

## Quarterly: the RemCom cycle and the quarter-end check

Quarterly tasks group by month, and two anchors define the year — the RemCom meets in the first quarter for the bonus and in the third quarter for raise milestones, so prepare ahead of both — while every quarter also carries the quarter-end payroll verification that the additive quarterly payment was processed correctly, not substituted for utility. In the first quarter you verify the January additive quarterly payment, distribute the year's mandatory training assignments and publish the training and HR calendars, reset leave entitlements, and in February prepare the indicative RemCom bonus pack from the CFO's profit estimate, then in March finalize the pool once the audited figure is confirmed. The second quarter pays bonuses in the first half of April with the senior deferral entries and any due prior-year tranches, verifies the April quarter-end payment, and runs the year-end appraisal window, the calibration session with the Integrity Gate, the rating communications, and the opening of the new cycle. The third quarter confirms goals are sealed, issues mid-year review reminders, verifies the July quarter-end payment, runs the August sponsorship review, and holds the September RemCom on raise milestones with minutes circulated within five working days. The fourth quarter reviews the curriculum map with Compliance, verifies the October quarter-end payment, runs the mid-year review window to its 31 December deadline with escalation of non-completions to the COO by 15 December, reconciles annual leave balances at 31 December with carry-over decisions communicated by 15 January, and begins preparing the following January.

## Annual: the calendar-year cycle

Underneath the quarters runs the firm's performance cycle, and it is the calendar year, January to December, with fixed dates. Goals are set in January and sealed by 28 February — a sealed goal is immutable evidence and the baseline the year is judged against. Continuous weekly tracking runs all year. The mid-cycle review falls in July, by 31 July. The year-end self-assessment and manager assessment are due by 31 December. Calibration runs February to March of the following year under the COO, with the Integrity Gate forcing a zero bonus multiplier for any failure on integrity or compliance. The bonus is paid in April against the prior year's audited financials. Hold this firmly, because some companion material — including the cadence document's own annual table — still carries the legacy June-to-May rhythm, with year-end appraisals in April and May, the cycle reopening in June, and goals sealed in July. That is superseded. The portal and the PD Guides are canonical: teach the calendar year, with goals sealed 28 February, mid-cycle in July, year-end due 31 December, and bonus in April. Where you meet the old June-May dates in a companion document, treat them as a document fix to be cleared, not a competing schedule.

## Event-triggered: when something happens

Not every task runs on a calendar. A new hire triggers the pre-boarding checklist, Day 1 activation, the thirty-, sixty-, and ninety-day points, the probation midpoint review at month three, and the end-of-probation decision communicated at least two weeks before the probation end date — never on the last day. A leaver triggers the notice acknowledgment, the final-pay calculation including accrued leave and, for G4 and G5, the good-leaver-versus-bad-leaver determination that governs deferred bonus, the IT access revocation confirmed in writing, the collection of company property, the exit interview, and the archiving of the staff file for a minimum of seven years. A performance concern routes to coaching and a PIP if it is capability, or to investigation and the disciplinary process if it is conduct. A grievance or whistleblower report runs its own timed process. A raise milestone triggers the recommendation, RemCom approval before any communication, and simultaneous updates to HumanManager and the portal. Each event carries the same obligation to be executed correctly and on time, with its manual chapter as the instruction set.

## The Evidence Vault

The thread running through every cycle is evidence. The payroll cycle produces a signed control sheet; calibration produces a signed record; policy revisions produce fresh acknowledgments; sponsorships produce ledger entries and approval letters. All of it is filed in the portal, which is both the system of record and the audit trail, with payroll evidence retained for at least seven years. A cadence run well is not just tasks completed on time — it is a complete, retrievable evidence trail that an inspection can follow without gaps. The discipline here is to file as you go rather than at the end: the control sheet goes to the Vault by the 30th, the calibration record within two working days of the session, the policy acknowledgment when it is signed. Evidence collected at the moment of the event is reliable; evidence reconstructed months later, ahead of an inspection, is exactly the gap an inspection finds.

## A worked example

**Illustration — a week in mid-April (entirely hypothetical).** It is the second week of April, and four rhythms overlap. The weekly checks still run — staff files, LMS reminders, the leave queue, progress reports, queries, joiner/leaver scans. April is a quarter-end month, so the monthly payroll cycle carries the additive-quarterly verification: at the cross-check you confirm the quarterly appears as a separate line on top of normal pay, not in place of utility. April is also bonus month, so within the first fifteen days the approved bonuses are paid through Remita alongside payroll, the senior deferral entries are recorded, and any prior-year deferred tranche due this April is released — each confirmed as RemCom-approved. And the year-end appraisal window is open, so you are issuing appraisal instructions and preparing the calibration pack. You sequence them around the fixed payroll dates because those cannot move: the 20th-to-30th payroll spine anchors the month, and the bonus run and appraisal work fit around it. By the 30th the signed control sheet and the bonus evidence are in the Evidence Vault.

## Common traps

- **Letting weekly tasks accumulate.** They take minutes if done weekly and hours if deferred; keep a fixed weekly slot.
- **Not building the month around the four payroll dates.** The payroll spine cannot move; everything else fits around the 20th, 24th, 25th, and 28th.
- **Teaching the June-May / July-seal cycle.** The cycle is the calendar year with goals sealed 28 February; the old June-May dates in companion material are superseded.
- **Using 0.85 as the compa floor.** The canonical floor is 0.80; the 0.85 in the cadence note is a document fix, not a rule.
- **Leaving evidence unfiled.** Every cycle produces evidence for the Vault; an incomplete trail is an audit risk.

## Key takeaways

- The role runs as a rhythm: weekly checks, a monthly cycle built around fixed payroll dates, quarterly tasks, and annual milestones.
- The first-join priority is the staff-file completion drive — eighteen files, ninety-day target; the portal is the system of record throughout.
- The RemCom anchors the year in Q1 (bonus) and Q3 (raises); every quarter carries the additive quarter-end payroll check.
- The performance cycle is the calendar year — goals sealed 28 February, mid-cycle July, year-end due 31 December, calibration February-March, bonus April; the legacy June-May rhythm is superseded.
- Event-triggered tasks (joiners, leavers, performance, grievance/whistleblower, raises) run off-calendar but to the same standard; every cycle feeds the Evidence Vault, retained seven years.

*Reference: the People Ops Cadence v1.0 (whole) and HR Operations Manual v1.1, Chapters A4 (annual calendar), A5 (the portal as system of record), and F2 (payroll cycle); the Evidence Vault per the Internal Control Framework. The calendar-year performance cycle and the 0.80 compa floor are canonical (the cadence document's June-May rhythm and 0.85 reference are logged for correction). This module is a navigation aid; the manual and the canonical framework are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-208';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_01$id$, m.id, $p$Which of these is a WEEKLY People-Ops task?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "finalizing the bonus pool"}, {"key": "b", "text": "checking the staff-file completeness and LMS completion dashboards"}, {"key": "c", "text": "running the calibration session"}, {"key": "d", "text": "reconciling annual leave at year-end"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Weekly tasks include checking the staff-file and LMS dashboards, the leave queue, progress-report submission, HR queries, and joiner/leaver/role-change scans.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_02$id$, m.id, $p$A leave request has sat pending manager approval beyond which threshold prompts you to chase it?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one working day"}, {"key": "b", "text": "three working days"}, {"key": "c", "text": "ten working days"}, {"key": "d", "text": "one month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Managers must approve or decline within three working days; in your weekly leave-queue check you chase anything pending beyond that.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_03$id$, m.id, $p$Weekly performance progress reports are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "optional"}, {"key": "b", "text": "a performance obligation; you flag non-submitters to their manager"}, {"key": "c", "text": "required only during probation"}, {"key": "d", "text": "submitted quarterly"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Continuous tracking via weekly reports is a performance obligation, not optional; you flag non-submitters to their line manager each week.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_04$id$, m.id, $p$The HR-query service standard is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "acknowledge within a week"}, {"key": "b", "text": "same-day acknowledgment and resolution within two working days for straightforward matters"}, {"key": "c", "text": "resolve all queries within the hour"}, {"key": "d", "text": "there is no standard"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The standard is same-day acknowledgment and resolution within two working days for straightforward matters; anything complex goes to the COO.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_05$id$, m.id, $p$The monthly People Ops report to the COO covers...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only payroll status"}, {"key": "b", "text": "headcount, payroll status, leave summary, mandatory-training completion, and open HR matters"}, {"key": "c", "text": "individual salaries"}, {"key": "d", "text": "only training completion"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The monthly report covers headcount, payroll status and anomalies, leave, mandatory-training completion rates, and any open matters needing a COO decision.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_06$id$, m.id, $p$In monthly compa-ratio monitoring, you flag to the COO anyone whose compa-ratio is below...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "0.75"}, {"key": "b", "text": "the canonical 0.80 floor"}, {"key": "c", "text": "1.00"}, {"key": "d", "text": "1.15"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Flag anyone below the canonical 0.80 floor as a priority for the next raise (and anyone above 1.15 for review). The cadence note's 0.85 is a document fix; apply 0.80.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_07$id$, m.id, $p$The payroll spine the whole month is built around runs...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the 1st to the 10th"}, {"key": "b", "text": "input by the 20th, run by the 22nd, cross-check by the 24th, dual auth by the 25th, payment on the 28th, evidence by the 30th"}, {"key": "c", "text": "whenever Finance is ready"}, {"key": "d", "text": "only in quarter-end months"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The fixed payroll deadlines (20th input, 22nd run, 24th cross-check, 25th dual auth, 28th payment, 30th evidence) cannot move; build the month around them.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_08$id$, m.id, $p$The RemCom meets to approve the bonus and the raise milestones in which quarters?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Q2 (bonus) and Q4 (raises)"}, {"key": "b", "text": "Q1 (bonus) and Q3 (raises)"}, {"key": "c", "text": "Q1 for both"}, {"key": "d", "text": "only Q4"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The RemCom meets in Q1 for the bonus and Q3 for raise milestones; prepare ahead of both.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_09$id$, m.id, $p$Every quarter carries one common payroll-specific task:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "changing the pay structure"}, {"key": "b", "text": "verifying the additive quarterly payment was processed correctly, not substituted for utility"}, {"key": "c", "text": "recalculating the bonus pool"}, {"key": "d", "text": "issuing raise letters"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In January, April, July, and October you verify the quarterly payment appears as an additive line, not as a substitute for the utility allowance.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_10$id$, m.id, $p$Goals must be sealed in the portal by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the end of July (when the new cycle opens)"}, {"key": "b", "text": "28 February"}, {"key": "c", "text": "31 December"}, {"key": "d", "text": "the calibration session"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$On the canonical calendar-year cycle, goals are sealed by 28 February. The cadence document's July seal reflects the superseded June-May rhythm.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_11$id$, m.id, $p$September's RemCom Q3 task is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "finalize the bonus pool"}, {"key": "b", "text": "review raise milestones, and prepare a Raise Recommendation if a milestone was hit, with minutes circulated within five working days"}, {"key": "c", "text": "run calibration"}, {"key": "d", "text": "reset leave balances"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In September the RemCom reviews raise milestones; if one is hit you prepare the recommendation and obtain approval before any communication, and circulate minutes within five working days.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_12$id$, m.id, $p$The performance cycle at Transworld runs on...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a June-to-May year"}, {"key": "b", "text": "the calendar year, January to December"}, {"key": "c", "text": "the April-to-March bonus year"}, {"key": "d", "text": "each employee's hire anniversary"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The cycle is the calendar year. The portal and PD Guides are canonical; the cadence document's June-May annual table is superseded and logged as a document fix.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_13$id$, m.id, $p$The mid-cycle (mid-year) review falls in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "April"}, {"key": "b", "text": "July (by 31 July)"}, {"key": "c", "text": "September"}, {"key": "d", "text": "December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$On the calendar-year cycle the mid-cycle review is in July, by 31 July.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_14$id$, m.id, $p$The bonus is paid in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "December, against forecasts"}, {"key": "b", "text": "April, against the prior year's audited financials"}, {"key": "c", "text": "February, against estimates"}, {"key": "d", "text": "whenever the pool is ready"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The bonus is paid in April against the prior year's audited financials — the firm does not pay against unaudited numbers.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_15$id$, m.id, $p$An end-of-probation decision must be communicated...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "on the last day of probation"}, {"key": "b", "text": "in writing at least two weeks before the probation end date"}, {"key": "c", "text": "only if the employee asks"}, {"key": "d", "text": "at the next appraisal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The end-of-probation decision (Confirmation, Extension, or Non-Confirmation) is communicated in writing at least two weeks before the probation end date — never on the last day.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_16$id$, m.id, $p$For a G4/G5 leaver, the final-pay process must determine...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "nothing beyond salary to the last day"}, {"key": "b", "text": "good-leaver versus bad-leaver status, which governs the deferred bonus"}, {"key": "c", "text": "a new bonus award"}, {"key": "d", "text": "the next raise milestone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$For G4/G5 leavers you determine good-leaver versus bad-leaver status and process the deferred bonus accordingly, alongside salary to the last day plus accrued leave.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_17$id$, m.id, $p$A raise milestone is hit. Before communicating anything to staff you must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "issue letters immediately"}, {"key": "b", "text": "obtain RemCom approval, then update HumanManager and the portal simultaneously on the effective date"}, {"key": "c", "text": "tell managers verbally first"}, {"key": "d", "text": "wait for year-end"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The CFO confirms the milestone; you prepare the recommendation and obtain RemCom approval before any communication, then update HumanManager and the portal simultaneously.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_18$id$, m.id, $p$On first joining the role, the urgent priority above all else is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the calibration session"}, {"key": "b", "text": "the staff-file completion drive \u2014 eighteen files, ninety-day target"}, {"key": "c", "text": "publishing the bonus pool"}, {"key": "d", "text": "the EU-region migration"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The single highest-priority first task is the staff-file completion drive: eighteen files, ninety-day target, before any SEC inspection finds them incomplete.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_19$id$, m.id, $p$What feeds the Evidence Vault, and how long is payroll evidence retained?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only payroll sheets; one year"}, {"key": "b", "text": "payroll control sheets, calibration records, acknowledgments and ledgers; payroll evidence at least seven years"}, {"key": "c", "text": "nothing is retained"}, {"key": "d", "text": "only items the COO requests; three years"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every cycle feeds the Vault — control sheets, calibration records, acknowledgments, ledger entries — and payroll evidence is retained a minimum of seven years as the audit trail.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl208_20$id$, m.id, $p$If a payroll deadline falls on a weekend or public holiday, you...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "skip that month's step"}, {"key": "b", "text": "move it to the last working day before it and plan the adjusted schedule at the start of the month"}, {"key": "c", "text": "delay payment to the following month"}, {"key": "d", "text": "let Finance decide ad hoc"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Move the deadline forward to the last working day before it, and plan the adjusted schedule at the start of the month so payment still lands on time.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-208'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;


-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-208';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-208 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-208' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-208 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-208 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
