-- =============================================================================
-- seed_ppl203_content.sql  (v0.61.0)
-- PPL-203: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
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
SET body = $body$The day someone joins and the day someone leaves are the two moments when the firm is most exposed — and most likely to cut a corner. A new joiner who never quite gets set up drifts for months; a leaver whose access is not revoked on time is a live security and regulatory risk. Between those two days sits probation, the window in which the firm decides, on evidence, whether the hire was right. Onboarding, probation, and exit are the lifecycle's bookends, and administering them cleanly and on the record is squarely your job. This module walks all three, in the order you will run them.

## What you will be able to do

1. Pre-board and onboard a joiner so they are productive and fully documented from week one.
2. Run the six-month probation with its formal 3-month midpoint review.
3. Manage the end-of-probation decision — confirm, extend, or non-confirm — the right way.
4. Offboard a leaver cleanly, with timely access revocation, whatever the reason for leaving.
5. Close the staff-file gap and keep every file complete and inspection-ready.

## Onboarding: from offer to a working week one

Onboarding begins before day one. Pre-boarding is the work between contract signing and start: confirming the start date, preparing the workspace and system access, and gathering the documents that will populate the staff file. The aim is that on day one the new joiner is not chasing a laptop or a login but starting the actual role.

Day One and Week One are owned jointly by you and the line manager. Day one covers the essentials — identity and the firm, the policies that must be acknowledged on the spot (the Employee Handbook, the Code of Ethics, the Personal Account Dealing policy), the systems the person will use, and the people they will work with. Week One milestones turn that into momentum: the role's 30/60/90 goals are set with the manager, the mandatory training assignments are switched on in the portal, and the person knows where to go for what. The onboarding framework exists so this is consistent rather than improvised — every joiner gets the same structured start, and you can show that they did. For a regulated hire, Week One is also when you confirm that the regulatory registration and fit-and-proper evidence collected during recruitment is complete on the file, because a regulated person must not be operating without it.

A clean onboarding is also the moment the staff file starts filling correctly. The signed contract and offer letter, the verified ID, the right-to-work confirmation, the guarantor forms — these are easiest to collect at the start, while goodwill is high and the person is motivated to complete paperwork. Collect them now and you are not chasing them a year later.

The structure that makes onboarding repeatable is the **30/60/90 framework**: at day one the manager and the joiner agree what "good" looks like at thirty, sixty, and ninety days, and those become the goals the probation midpoint is later judged against. Keep the ownership split clear in your own head — you own the process, the documents, the portal record, and the timeline; the line manager owns the role content, the day-to-day direction, and the substantive judgment of whether the person is performing. When the two of you each do your half, the joiner gets both a clean administrative start and a real working role, and the probation that follows has a documented baseline rather than a vague impression.

## Probation: a six-month window, run on evidence

All new employees serve a **six-month probation period**, and you own the probation timeline: every milestone scheduled, executed, and documented. Probation is not a formality that resolves itself on the last day; it is a structured assessment, and the structure is what protects both the employee and the firm.

The centerpiece is the **3-month midpoint review** — a formal, documented meeting, not an informal catch-up. You schedule it at contract signing, targeting the date exactly **90 days from start**. You send the employee and the line manager the Probation Midpoint Review Form **two weeks in advance**, and you confirm the meeting has happened **within five working days** of the scheduled date. The review covers progress against the 30/60/90 goals, the quality and standard of work, professional conduct and alignment with the six Transworld behaviors, any development needs, and any concerns from either side. Both the employee and the line manager sign the completed form, and you file it on the staff file. One rule matters above all here: **if concerns surface at the midpoint, you notify the COO immediately — not at the end of probation.** The midpoint exists precisely so that a struggling hire gets support, or a clear signal, while there is still time to act.

## The end-of-probation decision

The end-of-probation decision belongs to the **COO**, made on the line manager's recommendation and your review. It must be made and **communicated to the employee in writing at least two weeks before the probation end date** — never sprung on the last day. There are three outcomes, and each has its own administration.

- **Confirmation.** You issue the Confirmation Letter from the portal template, update the employee's status to "Confirmed," and file the signed confirmation form.
- **Extension.** You issue the Extension Letter, which specifies the extension period (typically four to eight weeks), the specific goals that must be met, the support available, and the date of the next review. You file it and schedule that review. An extension is not a way to avoid a decision; it is a defined second chance with measurable goals.
- **Non-Confirmation.** This is a **termination**, and you treat it as one. You prepare the Non-Confirmation Letter for the COO's signature; it states that employment is not being confirmed, gives the required notice (**one week during probation**, or payment in lieu), and confirms the employee's right to appeal. **Compliance must be notified, and you confirm with external employment counsel before issuing.** Non-confirmation is the lightest-weight exit the firm has, but it is still an exit and still carries process.

## Exit: the same process, whatever the reason

Employment can end through resignation, non-confirmation of probation, dismissal for capability or conduct, or redundancy. In every case the **same offboarding process applies**, with the timing differing only on whether notice is served or payment in lieu applies. That single, consistent process is what stops exits from becoming improvised and risky.

The offboarding checklist is built around two priorities: capturing what the firm needs to keep, and removing what the leaver must no longer hold — each task on a defined timeline. You issue or acknowledge written notice and confirm the last working day on receipt of the resignation or on the day of the dismissal decision. You prepare the **final pay calculation — salary to the last day plus accrued unused leave — at least five working days before the final payment**. You **notify IT to revoke system access on the last working day, with the notice given at least five working days ahead** so nothing is left to the morning of departure. And you **collect the building-access pass on the last day**. The step that cannot slip is access revocation: for a leaver in a regulated role, or one leaving under conduct concerns, a former employee with live access to client systems is exactly the exposure the regulator expects you to have closed, so the IT notice goes out early and the revocation lands on the last day, not "soon after." The portal record is updated to reflect the exit, and the staff file is completed and retained — a leaver's file is not closed and forgotten; it is finished and kept for the retention period, because regulators audit exits too.

## The staff-file gap: your first-90-days priority

There is one piece of this module that is urgent rather than merely important. At the handover of the current operating manual, the staff files for **18 employee records (13 active, 1 on probation, 4 exited) sat at 0% completion** — named in the manual as the single highest HR risk in the firm. The target is **100% complete files within 90 days** of the People-Ops Officer starting. This is the first thing you build your early weeks around, because an incomplete file is the gap a SEC inspection finds.

A complete staff file contains: the signed employment contract and signed offer letter; a verified ID copy (passport or NIN); right-to-work confirmation; two completed guarantor forms; verified academic and professional certification copies (for all G2-and-above employees and all regulated roles); SEC / NGX registration confirmation (for all regulated roles); a criminal-record-check result; a signed acknowledgement of the current Employee Handbook; and a signed Personal Account Dealing acknowledgement. Some items — the verified ID, the guarantor forms, the regulatory registration — are far easier to collect at onboarding than to retrofit, which is why a disciplined onboarding (above) is also your best defense against the file gap reopening for every future hire. The 90-day completion plan is a campaign, not a wish: you work the gap systematically — typically active employees first (they are the live inspection risk), then those on probation, then exited records — and you track completion on the portal's staff-file dashboard each week until every file reads 100%. Build your early weeks around this; once closed, the weekly dashboard check keeps it closed.

## A worked example

**Illustration — the midpoint that surfaced a concern (entirely hypothetical).** A G1 operations joiner reaches day 90. You scheduled the midpoint review at contract signing, sent the Probation Midpoint Review Form two weeks out, and the meeting happens on schedule. The line manager's assessment is honest: the joiner is conscientious but is missing settlement deadlines, a quality-of-work concern against the 30/60/90 goals. Rather than letting it ride to month six, you notify the COO immediately, as the rule requires, and the manager puts specific support in place. At the end-of-probation point, the COO — on the manager's recommendation and your review — decides on a four-week extension with two named goals, and you issue the Extension Letter at least two weeks before the original end date, file it, and schedule the extension review. Nobody is surprised on the last day, the decision is documented, and the employee has a fair, defined second chance. Throughout, the staff file is filling: contract, offer, ID, guarantor forms, handbook acknowledgement — all collected at onboarding, not chased now.

## Common traps

- **Treating the midpoint as a casual chat.** It is a formal, documented meeting with a signed form filed on the staff file.
- **Sitting on a midpoint concern until the end.** Concerns go to the COO immediately — that is the point of the midpoint.
- **Springing the probation decision on the last day.** The decision is communicated in writing at least two weeks before the end date.
- **Delaying access revocation at exit.** Revoke on the right timeline; a former employee with live access is a regulatory and security exposure.
- **Letting the staff-file gap drift.** 100% complete files within 90 days; collect the hard-to-retrofit items at onboarding.

## Key takeaways

- Onboarding starts before day one (pre-boarding) and runs a consistent Day One / Week One framework; collect file documents while goodwill is high.
- Probation is six months, owned by People Ops, with a formal documented 3-month midpoint review at day 90 (form sent two weeks ahead, meeting confirmed within five working days).
- Midpoint concerns are escalated to the COO immediately; the end-of-probation decision is the COO's, communicated in writing at least two weeks before the end date — confirm, extend (4–8 weeks, named goals), or non-confirm (a termination, with Compliance notified and counsel consulted).
- One offboarding process covers all exit types; access revocation cannot slip, and the staff file is completed and retained, not abandoned.
- Closing the 18-file gap to 100% within 90 days is the operator's first-90-days priority — the highest standing HR risk.

*Reference: HR Operations Manual v1.1, Part D (Chapters D1–D6) and the WS4 Onboarding, Probation & Exit pack (Transworld); event-triggered timing per the People Ops Cadence v1.0. This module is a navigation aid; the manual is the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-203';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_01$id$, m.id, $p$How long is the standard probation period for a new employee at Transworld?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Three months"}, {"key": "b", "text": "Six months"}, {"key": "c", "text": "Twelve months"}, {"key": "d", "text": "There is no fixed period"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$All new employees serve a six-month probation period, and People Ops owns the timeline — every milestone scheduled, executed, and documented.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_02$id$, m.id, $p$The 3-month probation midpoint review is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an informal catch-up over coffee"}, {"key": "b", "text": "a formal, documented meeting with a signed form filed on the staff file"}, {"key": "c", "text": "optional if the manager is satisfied"}, {"key": "d", "text": "a meeting only with the COO present"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The midpoint review is a formal, structured, documented meeting — both employee and manager sign the Probation Midpoint Review Form, which People Ops files on the staff file.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_03$id$, m.id, $p$A concern about a probationer surfaces at the 3-month midpoint review. When do you notify the COO?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "At the end of the probation period"}, {"key": "b", "text": "Immediately \u2014 not at the end of probation"}, {"key": "c", "text": "Only if the manager recommends non-confirmation"}, {"key": "d", "text": "Never; the midpoint is confidential to the manager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$If concerns are identified at the midpoint, People Ops and the COO are notified immediately, so support or a clear signal can be given while there is still time to act.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_04$id$, m.id, $p$Who makes the end-of-probation decision?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops alone"}, {"key": "b", "text": "The line manager alone"}, {"key": "c", "text": "The COO, on the line manager's recommendation and People Ops' review"}, {"key": "d", "text": "The employee, by self-assessment"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The decision belongs to the COO, made on the manager's recommendation and People Ops' review.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_05$id$, m.id, $p$The end-of-probation decision must be communicated to the employee...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "on the last day of probation"}, {"key": "b", "text": "in writing, at least two weeks before the probation end date"}, {"key": "c", "text": "verbally, whenever convenient"}, {"key": "d", "text": "only if the outcome is non-confirmation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The decision is made and communicated in writing at least two weeks before the end date — never sprung on the last day.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_06$id$, m.id, $p$Non-confirmation of probation is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a neutral administrative step with no process"}, {"key": "b", "text": "a termination \u2014 with required notice, right to appeal, Compliance notified, and counsel consulted"}, {"key": "c", "text": "automatically converted into an extension"}, {"key": "d", "text": "decided by the employee"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Non-confirmation is a termination. The Non-Confirmation Letter (COO signature) states employment is not confirmed, gives the required notice, confirms the right to appeal; Compliance is notified and external counsel consulted before issuing.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_07$id$, m.id, $p$A probation extension letter should specify...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "nothing beyond the new end date"}, {"key": "b", "text": "the extension period (typically 4\u20138 weeks), the specific goals to be met, the support available, and the next review date"}, {"key": "c", "text": "a pay cut for the extension period"}, {"key": "d", "text": "that the employee has waived their right to appeal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An extension is a defined second chance: the letter names the period (typically 4–8 weeks), the specific goals, the support, and the next review date — it is not a way to avoid deciding.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_08$id$, m.id, $p$Different exit reasons (resignation, dismissal, redundancy, non-confirmation) each use a completely different offboarding process.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$The same offboarding process applies in all cases; only the timing differs depending on whether notice is served or payment in lieu applies.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_09$id$, m.id, $p$At the handover of the operating manual, the staff-file situation was...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "all files complete"}, {"key": "b", "text": "18 employee records at 0% completion \u2014 named as the single highest HR risk"}, {"key": "c", "text": "a minor housekeeping item"}, {"key": "d", "text": "handled entirely by HumanManager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Staff files for 18 records (13 active, 1 on probation, 4 exited) sat at 0% completion — the single highest HR risk — with a target of 100% within 90 days of the People-Ops Officer starting.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_10$id$, m.id, $p$Which item is required in a complete staff file for ALL employees?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "SEC / NGX registration confirmation"}, {"key": "b", "text": "A signed employment contract"}, {"key": "c", "text": "A professional valuation certificate"}, {"key": "d", "text": "A board resolution"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A signed employment contract is required for all employees (current and exited). SEC/NGX registration is required only for regulated roles.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_11$id$, m.id, $p$SEC / NGX registration confirmation must be on file for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "every employee"}, {"key": "b", "text": "all regulated roles"}, {"key": "c", "text": "only Leadership"}, {"key": "d", "text": "no one \u2014 the regulator holds it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$SEC/NGX registration confirmation is a required staff-file item for all regulated roles.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_12$id$, m.id, $p$The notice period for a non-confirmation during probation is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "three months"}, {"key": "b", "text": "one month"}, {"key": "c", "text": "one week, or payment in lieu"}, {"key": "d", "text": "no notice at all"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Non-confirmation during probation requires one week's notice, or payment in lieu.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_13$id$, m.id, $p$When is the easiest time to collect hard-to-retrofit file items such as verified ID, guarantor forms, and regulatory registration?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "At the annual appraisal"}, {"key": "b", "text": "At onboarding, while goodwill is high and the person is motivated"}, {"key": "c", "text": "Only at exit"}, {"key": "d", "text": "Never \u2014 they are optional"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$These items are easiest to collect at onboarding; a disciplined onboarding is the best defense against the staff-file gap reopening for future hires.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_14$id$, m.id, $p$At exit, which step cannot be allowed to slip, especially for a regulated role or a conduct-related departure?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The farewell email"}, {"key": "b", "text": "Revoking system and building access on the right timeline"}, {"key": "c", "text": "Updating the org chart"}, {"key": "d", "text": "Returning the parking pass within a year"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Access revocation cannot slip — a former employee with live access to client systems is exactly the security and regulatory exposure the regulator expects to be closed.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_15$id$, m.id, $p$Onboarding begins...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "on the employee's first morning"}, {"key": "b", "text": "before day one, with pre-boarding (workspace, access, documents)"}, {"key": "c", "text": "at the end of probation"}, {"key": "d", "text": "only once the contract is countersigned by the board"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Pre-boarding happens between contract signing and start so the joiner is productive on day one rather than chasing a laptop or a login.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_16$id$, m.id, $p$The Probation Midpoint Review Form should be sent to the employee and line manager...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "on the day of the meeting"}, {"key": "b", "text": "two weeks in advance"}, {"key": "c", "text": "after the meeting, to record it"}, {"key": "d", "text": "only if a concern already exists"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$People Ops sends the form two weeks in advance and confirms the meeting has taken place within five working days of the scheduled date.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_17$id$, m.id, $p$On Confirmation at the end of probation, People Ops...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "does nothing \u2014 confirmation is automatic and silent"}, {"key": "b", "text": "issues the Confirmation Letter, updates portal status to 'Confirmed', and files the signed form"}, {"key": "c", "text": "issues a Non-Confirmation Letter to be safe"}, {"key": "d", "text": "waits for the employee to request confirmation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Confirmation means issuing the Confirmation Letter from the portal template, updating status to 'Confirmed', and filing the signed confirmation form.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_18$id$, m.id, $p$A leaver's staff file should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "deleted once they leave"}, {"key": "b", "text": "completed and retained for the retention period \u2014 regulators audit exits too"}, {"key": "c", "text": "handed to the employee"}, {"key": "d", "text": "left as-is, since they have gone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A leaver's file is finished and kept for the retention period. Exits are audited, so the file is completed, not abandoned.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_19$id$, m.id, $p$The 3-month midpoint review targets which date?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "30 days from start"}, {"key": "b", "text": "exactly 90 days from start"}, {"key": "c", "text": "the last day of probation"}, {"key": "d", "text": "the first pay day"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The midpoint review is scheduled at contract signing, targeting the date exactly 90 days from start.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl203_20$id$, m.id, $p$The midpoint review assesses conduct against...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the manager's personal preferences"}, {"key": "b", "text": "the six Transworld behaviors, alongside 30/60/90 goal progress and quality of work"}, {"key": "c", "text": "the compa-ratio"}, {"key": "d", "text": "nothing \u2014 it only covers attendance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The review covers progress against 30/60/90 goals, quality of work, professional conduct and alignment with the six Transworld behaviors, development needs, and any concerns from either side.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
