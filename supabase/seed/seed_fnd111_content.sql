-- =============================================================================
-- seed_fnd111_content.sql  (Release B, v0.59.0)
-- FND-111 Owning your performance & development: lesson + 20-question check.
-- Authored from the Employee Performance & Development Guide v1.1. Tier C, FROM POLICY.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql + the FND-111 shell (v0.58.0).
-- Idempotent: body UPDATE + question upsert by id + firmwide everyone-rule (NOT EXISTS).
-- Publishes FND-111 and switches on its firmwide REQUIRED assignment (enrols all staff).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Two things happen to you every year at Transworld, and both of them change the money in your bank account. The first is your appraisal — an honest assessment of how you performed this year. The second is your development — the deliberate work you do to grow into the person who performs even better next year. Most people treat these as separate events on a calendar. They are not. They are two halves of one connected system, and learning to navigate that system well is one of the most valuable professional habits you can build here.

This module is your map. You take it when you join and once a year after that, because the cycle resets every January and a quick refresher before goal-setting season is time well spent. By the end you will know exactly what happens, when it happens, and — most importantly — what *you* are expected to do at each turn.

## What you will be able to do

1. Explain the two engines — appraisal and development — and how each one reaches your pay.
2. Name the five key moments of the calendar-year cycle and your action at each.
3. Describe how your scorecard becomes a rating, a multiplier, and an April bonus.
4. State what the Integrity Gate is, what triggers it, and what it does.
5. Set and seal strong goals and keep an evidence trail through the year.
6. Use the PeopleOps portal as the live home of your performance and development.

## The two engines

Think of a bicycle with two pedals. One moves you forward right now; the other builds the momentum that keeps you moving faster over time. **Engine 1 is your appraisal.** At the end of each year your performance is assessed, the assessment produces a score, the score becomes a bonus multiplier, and the multiplier feeds the formula — your grade, your monthly salary, the firm's profit — that produces your April bonus. Engine 1 pays out every spring for the year that just ended.

**Engine 2 is your development plan.** It runs quietly through the current year, building the skills and behaviors that determine how well you perform *next* year — which produces next year's score, multiplier, and bonus. Engine 2 does not pay out now. It pays out roughly two Aprils later, and it compounds: every year you invest seriously in your development is a deposit that earns interest. Ignoring your development plan is not a neutral choice — it is a quiet decision to accept smaller future bonuses. The people whose earnings grow fastest are simply the ones who understood this early.

## The cycle at a glance

The performance cycle runs from **January 1 to December 31** — the calendar year. That is deliberate: the firm's profit, which funds the bonus pool, is measured over the same months, so you are assessed over exactly the period in which the firm earns. Eight months of work sit between the bookends, but the year really turns on **five moments**:

- **January — goals open.** You meet your manager to set performance goals and development priorities for the year. Come prepared; a goal thought through in January is worth ten written in a rush.
- **February — goals sealed.** By month-end your goals are reviewed, agreed, and locked in the portal. Sealed goals are the benchmark for your whole year.
- **July — mid-year review.** A formal conversation about progress. This is your chance to course-correct if something has drifted off track.
- **November–December — self-assessment.** You write the most important document of your year: an honest review of your own performance across all three scorecard dimensions.
- **April — bonus paid.** The prior year's audited profit is confirmed, the pool is set, calibration finalizes ratings, the Board Remuneration Committee approves, and your bonus arrives.

If you remember only two dates, remember **February (sealing)** and **December (self-assessment)**. Prepare well for both and everything in between becomes manageable.

## How you are scored

Your year-end score has three dimensions. **Results** is what you delivered against your goals. **Competencies** is what you know and can do. **Behaviors** is how you worked — the way you carried yourself while getting the results. These combine into a single weighted average; the exact weights depend on your role and family — a revenue-generating role leans more on Results, a control function leans away from it — but every scorecard uses the same three dimensions.

That weighted average maps to a rating, the rating sets a **bonus multiplier**, and the multiplier is applied to your bonus formula. The mechanism rewards precision: a small difference in score is a real difference in naira, and those differences accumulate every April. This is exactly why building a steady evidence trail through the year matters — it is what lets your manager rate you accurately rather than from memory.

## The Integrity Gate

There is one circumstance in which your bonus multiplier goes to **zero** regardless of every other number on your scorecard. If you are rated **1 — Unsatisfactory — on either of two behaviors, Integrity Above All or Compliance by Default**, the Integrity Gate fires and your multiplier is set to **×0.00**. Your bonus is ₦0 no matter how strong your Results, Competencies, or other Behaviors were.

Why so severe? Because Transworld is a regulated dealing member of the Nigerian Exchange Group. We hold clients' money and transact in a regulated market, so honesty and following the rules sit above commercial performance, full stop. The gate is **not** for honest mistakes — a single procedural slip or a trade that needed correcting is not a gate event. It fires only when a *pattern* of conduct falls into the Unsatisfactory band. The decision is made in calibration and confirmed by the COO; it can be appealed through the formal grievance process, though the bar to overturn it is high. A rating of 1 on either behavior is also treated as a serious employment matter in its own right, separate from the bonus.

## January and February: set strong goals, then seal them

January is, quietly, the most important month of your year — because the quality of your January planning sets the quality of your December outcome. Write **four to six goals**, weighted roughly two-thirds performance (what you will deliver for the business) and one-third development (what you will build in yourself). Make each one **SMART** — specific, measurable, achievable, relevant, and time-bound — with a clear success criterion. "Improve my reconciliation work" is not a goal; "take over the monthly reconciliation from my manager by April and run it independently from May" is.

By the end of February your goals are **sealed** in the portal — a deliberate technical lock that prevents anyone, you or your manager, from editing the text. Sealing protects trust in both directions: no raising the bar after a strong year, no softening it after a weak one. If a goal becomes genuinely irrelevant because of a real external change — a regulatory shift, a strategy change, a change of role — you use the **Amendment** process (My Performance → Goals → Request Amendment); amendments are append-only, the original text is preserved, and your manager and People Ops must approve. You cannot quietly soften a goal in November because you are not going to hit it.

## Through the year: evidence, one-on-ones, the mid-year

The single habit that protects you is the **weekly progress report** in the portal. It takes minutes and it builds the evidence trail your December self-assessment and your rating rest on — so that the year is judged on a documented record, not on whatever happened to be memorable. Use your one-on-ones for both performance and development, not just task updates. And treat the **July mid-year review** as your most underused tool: six months in, check whether you are on track, whether anything has changed, and course-correct while there is still time. Through August to October, keep the reports going and keep updating your development plan as you complete actions.

## November and December: assess yourself, then talk

In November and December you write your **year-end self-assessment** — an honest rating of yourself across all three dimensions, measured against the goals you sealed in February and backed by the evidence you have been collecting. It is the most important document you write all year, and it directly shapes the rating conversation with your manager. In that December conversation, if you agree with the assessment, confirm it; if you disagree, make a calm, evidence-based case. Final ratings are settled in calibration and reach you in March. Then the appraisal feeds straight back into next January's development plan — the gap it reveals becomes next year's priority, and the cycle begins again.

## The second engine: owning your development

Your development plan has a formal name — the **PADP, the Performance and Development Path**. It is not a form you file and forget; it is a working document that names where you are on the **Growth Ladder**, where you are going, the gaps in between, and the concrete actions to close them. The Growth Ladder runs **G1 (Learn & Deliver) → G2 (Collaborate) → G3 (Lead a team or domain) → G4 (Lead functions) → G5 (Cast vision)**, and it is *not* the same as your pay grade or your job title: your grade sets your pay band, your title describes the job you currently do, and the Ladder describes your professional development. At G3 the path splits into two equally valued, equally paid tracks — **Manager** (leading and developing people) and **Expert** (deep specialist mastery).

For each development priority — choose a **maximum of three** — a good plan has four parts: **Priority** (what and why now), **Action** (the specific observable thing you will do), **Support** (what you need from your manager or the firm), and **Timeline** (when, and how you will know it worked). And there are four ways to develop any priority, strongest when combined: **on-the-job** work, **formal learning** (including LMS modules like this one), **coaching** from a more experienced colleague, and **qualification sponsorship** for a formal certification.

## Where it all lives

Every part of this cycle lives in the PeopleOps portal — goals, weekly reports, your development plan, your self-assessment, your ratings. It is not a cabinet you open once a year; it is the live record of your year, and keeping it current is your responsibility, not People Ops'. Own the cycle and it works for you. Ignore it and, sooner or later, it works against you.

*Reference: Employee Performance & Development Guide (Employees) v1.1. This module is a navigation aid; the Guide is the governing document.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-111';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_01$id$, m.id, $p$What are the firm's 'two engines'?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Your salary and your utility allowance"}, {"key": "b", "text": "Your appraisal and your development plan"}, {"key": "c", "text": "The Results and Behaviors scores"}, {"key": "d", "text": "Two separate bonus pools"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Engine 1 is your appraisal (this year's performance to pay); Engine 2 is your development plan (future performance to pay).$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_02$id$, m.id, $p$When does the development engine reach your pay?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "In this April's bonus"}, {"key": "b", "text": "Roughly two Aprils later, and it compounds"}, {"key": "c", "text": "Only when you are promoted"}, {"key": "d", "text": "It does not affect pay"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Development builds the skills that lift next year's performance, which feeds the bonus about two Aprils away — and compounds year on year.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_03$id$, m.id, $p$The Transworld performance cycle runs over which period?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "June 1 to May 31"}, {"key": "b", "text": "The calendar year, January 1 to December 31"}, {"key": "c", "text": "A rolling 12 months from your start date"}, {"key": "d", "text": "A fiscal year set fresh each year"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The cycle is the calendar year, aligned to the firm's profit measurement so you are assessed over the period the firm earns.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_04$id$, m.id, $p$By when must your goals be sealed in the portal?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "End of January"}, {"key": "b", "text": "End of February"}, {"key": "c", "text": "End of July"}, {"key": "d", "text": "End of December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Goals are reviewed, agreed, and sealed by the end of February; they then govern the whole year.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_05$id$, m.id, $p$Once your goals are sealed, you or your manager can freely edit them at any time.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Sealing locks the goal text. Changes need the formal, append-only Amendment process approved by your manager and People Ops.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_06$id$, m.id, $p$Which two deadlines matter most in your year?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "January goal-opening and April bonus"}, {"key": "b", "text": "Goal-sealing (February) and self-assessment (December)"}, {"key": "c", "text": "July mid-year and November"}, {"key": "d", "text": "March calibration and December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$If you prepare well for February sealing and December self-assessment, everything between them becomes manageable.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_07$id$, m.id, $p$The main purpose of the July mid-year review is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "decide your bonus"}, {"key": "b", "text": "course-correct if something has drifted off track"}, {"key": "c", "text": "set next year's goals"}, {"key": "d", "text": "finalize your year-end rating"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The mid-year is your chance to check progress and course-correct while there is still time to act.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_08$id$, m.id, $p$When do you write your year-end self-assessment?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "January"}, {"key": "b", "text": "July"}, {"key": "c", "text": "November\u2013December"}, {"key": "d", "text": "March"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$You assess your own full-year performance across all three dimensions in November–December.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_09$id$, m.id, $p$Your bonus is paid in April and depends on...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "your manager's decision alone"}, {"key": "b", "text": "the firm's audited profit, calibration, and Board Remuneration Committee approval"}, {"key": "c", "text": "your January goals only"}, {"key": "d", "text": "your grade only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The April bonus follows confirmation of audited profit, finalized ratings in calibration, and RemCom approval.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_10$id$, m.id, $p$The three scorecard dimensions are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Results, Competencies, Behaviors"}, {"key": "b", "text": "Sales, Speed, Service"}, {"key": "c", "text": "Profit, People, Process"}, {"key": "d", "text": "Goals, Grades, Growth"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Every scorecard uses Results (what you delivered), Competencies (what you know and can do), and Behaviors (how you worked).$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_11$id$, m.id, $p$How does your score become a bonus?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A flat amount is paid to everyone"}, {"key": "b", "text": "The weighted average sets a rating, the rating sets a multiplier, and the multiplier is applied to your bonus formula"}, {"key": "c", "text": "Your manager picks an amount"}, {"key": "d", "text": "Only Results count"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The three dimensions combine into a weighted average, which maps to a rating, then a multiplier applied to your bonus formula.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_12$id$, m.id, $p$The Integrity Gate fires when you are rated 1 (Unsatisfactory) on...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any single competency"}, {"key": "b", "text": "your Results"}, {"key": "c", "text": "either Integrity Above All or Compliance by Default"}, {"key": "d", "text": "three or more behaviors"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A rating of 1 on either Integrity Above All or Compliance by Default triggers the gate.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_13$id$, m.id, $p$If the Integrity Gate fires, your bonus multiplier becomes...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "reduced by 10%"}, {"key": "b", "text": "\u00d70.00 \u2014 your bonus is \u20a60 regardless of every other score"}, {"key": "c", "text": "unchanged"}, {"key": "d", "text": "capped at \u00d70.80"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The gate sets the multiplier to ×0.00, so the bonus is ₦0 no matter how strong the other scores are.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_14$id$, m.id, $p$A single honest compliance error automatically triggers the Integrity Gate.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$The gate is not for honest mistakes. It fires only when a pattern of conduct falls into the Unsatisfactory band.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_15$id$, m.id, $p$An Integrity Gate decision is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "set by your manager alone and final"}, {"key": "b", "text": "made in calibration, confirmed by the COO, and appealable through the grievance process"}, {"key": "c", "text": "automatic and cannot be appealed"}, {"key": "d", "text": "decided by Finance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$It is decided in calibration and confirmed by the COO; it can be appealed via the grievance process, though the bar to overturn is high.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_16$id$, m.id, $p$How many goals should you set, and in what balance?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Exactly three, all performance"}, {"key": "b", "text": "Four to six, roughly two-thirds performance and one-third development"}, {"key": "c", "text": "Ten, split evenly"}, {"key": "d", "text": "As many as your manager asks for"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Set four to six goals, weighted about two-thirds performance and one-third development.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_17$id$, m.id, $p$A development goal is something you deliver for the business this year.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$That describes a performance goal. A development goal is what you build in yourself for future performance.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_18$id$, m.id, $p$The weekly progress report mainly...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is administrative busywork"}, {"key": "b", "text": "builds the evidence trail your December self-assessment and rating rest on"}, {"key": "c", "text": "replaces the appraisal"}, {"key": "d", "text": "is only for your manager to complete"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The weekly report is the habit that protects you — it documents your year so judgments rest on a record, not memory.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_19$id$, m.id, $p$The Growth Ladder (G1–G5) is the same thing as your pay grade.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$They are different: your grade sets your pay band, your title is the job you do, and the Growth Ladder describes your professional development stage.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd111_20$id$, m.id, $p$In the P&D cycle, the PeopleOps portal is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a cabinet you open once a year"}, {"key": "b", "text": "the live home of your goals, weekly reports, plan, and self-assessment \u2014 which you keep current"}, {"key": "c", "text": "only used by People Ops"}, {"key": "d", "text": "optional"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal is the live record of your year; keeping it current is your responsibility, not People Ops'.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) firmwide everyone-rule for FND-111 (enrols all staff now that it is published)
INSERT INTO "learning_assignment_rules"
  ("id","module_id","scope","grade","job_profile_id","requirement","active","created_at","updated_at")
SELECT 'lr_' || m.id, m.id, 'ALL', NULL, NULL, 'REQUIRED', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-111'
  AND NOT EXISTS (SELECT 1 FROM "learning_assignment_rules" r
    WHERE r.module_id = m.id AND r.scope = 'ALL' AND r.grade IS NULL AND r.job_profile_id IS NULL);

-- 4) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'FND-111';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: FND-111 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FND-111' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FND-111 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: FND-111 expected 20 active questions (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_assignment_rules" r
    WHERE r.module_id = mid AND r.scope = 'ALL' AND r.grade IS NULL AND r.job_profile_id IS NULL;
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FND-111 everyone-rule missing (got %)', n; END IF;
END
$guard$;

COMMIT;
