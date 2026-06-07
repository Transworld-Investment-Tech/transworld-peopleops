-- =============================================================================
-- seed_ppl201_content.sql  (v0.61.0)
-- PPL-201: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
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
SET body = $body$It is the first Monday of the quarter and a manager drops a one-line message into your queue: "We need another analyst." That sentence is where workforce architecture begins, and it is your job — not the manager's — to turn it into something the firm can defend: a grade, a job family, a scorecard, a pay band, and a place in the structure that holds together. Get the architecture right and every later decision (what to pay, how to appraise, who gets a raise) has a frame to sit in. Get it loose and you spend the rest of the year arguing about exceptions. This module is the frame.

## What you will be able to do

1. Place any role into the firm's grade framework on the fully-loaded basis.
2. Assign the correct job family and apply the control-function rule that protects independence.
3. Use the 26 competencies and the F/P/E proficiency scale as the firm's single skills vocabulary.
4. Read a compa-ratio and know when it should change how you prioritize a raise.
5. Build and maintain a role scorecard, and run a clean headcount request.

## Grades sit on a fully-loaded basis

Transworld runs six grades, G0 through G5. A grade is not a title and it is not a salary line — it is a band of total cost to the firm, expressed on the **fully-loaded** basis. This matters because Transworld pays more than twelve monthly salaries: the annual cost of an employee is **gross pay multiplied by seventeen** — twelve monthly runs, four quarterly payments, and one thirteenth-month, each equal to one month's gross. To compare a person against their band you convert to a monthly-equivalent: **fully-loaded equals gross times seventeen, divided by twelve, divided by FTE**. That single figure is what the portal puts on the band, and it is the number you reason with. When a manager tells you "she earns four hundred thousand," your first move is to ask whether that is the monthly gross or the fully-loaded figure, because confusing the two will misplace her in the band every time.

Each grade has a band with a minimum, a midpoint, and a maximum. The midpoint is the anchor: it represents a fully competent person performing the role at the everyday standard. The bands overlap deliberately, so a strong performer near the top of G2 can out-earn a new entrant at the bottom of G3 — that is the system working, not a fault to correct.

## Compa-ratio: the one number that signals fairness

The **compa-ratio** is the fully-loaded figure divided by the grade midpoint. A ratio of 1.00 means the person is paid exactly at the midpoint for their grade. The firm's discipline turns on two thresholds. The floor target is **0.80**: anyone sitting below it is flagged in the portal and becomes a priority for the next raise cycle, because paying well under band for sustained work is how you lose good people quietly. The upper awareness line is **1.15**: above it, no further increase proceeds without COO review, because pay has run ahead of the band and the firm needs to decide deliberately whether the role itself has grown. You do not act on a compa-ratio by yourself — you surface it. Your monthly compa review puts the below-0.80 and above-1.15 names in front of the COO with the context, and the decision is recorded in the portal.

A trap worth naming now: the floor is **0.80**, not 0.85. Some older source material and operating notes still carry 0.85; the portal's canonical floor is 0.80 (the priority signal `CR_PRIORITISE`). When the two disagree, the portal wins, and you teach 0.80.

## Five job families — and the rule that protects the firm

Every role belongs to one of five **job families**, and the family does real work: it sets how the role's scorecard is weighted and whether revenue is even allowed to appear as a performance objective.

- **Business Development** — BD officers, client relationship roles, sales, and Marketing & Communications.
- **Investments** — Investment Analysts and Associates, the Head of Investments, and the junior-to-senior rungs of the Analyst band.
- **Control & Operations** — Compliance, Finance, Accounting, Operations, Settlement, and IT: the control and operations backbone.
- **Administration & Corporate Services** — People Operations and HR, Procurement & Vendor Management, and Facilities / Office Administration. This is your own family.
- **Leadership** — the MD, COO, CFO, and any executive or cross-functional leadership role.

Inside Control & Operations sit the roles carrying the **control-function flag** — Compliance, Risk, Internal Controls, Finance, and Accounting. These roles are **never scored on revenue**. Their Results objectives are functional quality and compliance outcomes only. This is a hard rule, not a preference, and it exists to protect control-function independence: a compliance officer whose bonus depends on deal volume cannot be trusted to stop a bad deal. When you build or review a scorecard for a flagged role and find a revenue target on it, you remove it — you do not negotiate it.

The family also drives scorecard weighting across the firm's three appraisal dimensions. A Business Development role leans hard on results — roughly a 55/20/25 split across results, competencies, and values — because winning and keeping clients is the job. An Administration role, which carries no revenue, weights more evenly, around 50/25/25, with the results dimension built from functional quality rather than money. You do not invent these splits per person; the family sets them and the scorecard inherits them.

## Manager track, expert track, and the special case

At **G3**, an employee chooses — with their manager and with you — whether their path runs along the **Manager Track** or the **Expert Track**. This is not a life sentence; it is a direction of travel that shapes which competencies matter and which higher grades are reachable. The split lets the firm reward a brilliant analyst who never wants to manage anyone as richly as it rewards a team leader, instead of forcing everyone through a management bottleneck. The **Investment function** carries its own special banding to reflect the market-facing nature of those roles; when you place an Investments role, check the Investment-specific band rather than assuming the generic grade band applies.

One principle underpins all of this: **grades belong to people, not to titles**. Two people can hold the same title and sit at different grades because grade reflects the person's demonstrated level, not the words on their business card. In the portal this is resolved in exactly one place — a person's own grade if set, otherwise the grade of their job profile. Never re-derive a grade from a title; read it from the person.

## The skills model has three layers

The portal holds the firm's capability model in three layers, and you should be able to name all three because the appraisal scores against them.

**Layer 1 — the 26 functional competencies, in nine categories.** These are not abstractions; they are the concrete skill names used in every scorecard, development plan, and performance record, so that you, the line managers, and the reviewers all speak one language. The nine categories are Client & Advisory (3), Finance & Accounting (3), Investment & Markets (4), Leadership & Governance (3), Operations & Controls (3), Regulatory & Compliance (4), Technology (2), Business Development (2), and Administration (2) — 3+3+4+3+3+4+2+2+2 = 26. No role carries all 26; each scorecard assigns the **four to six most central to the role**, each at a target proficiency level on a three-point scale: **F (Foundation)** is working knowledge for straightforward tasks with guidance; **P (Proficient)** is independent, reliable performance, the everyday standard; **E (Expert)** is deep mastery that sets the standard for others.

**Layer 2 — the six behaviors.** Every employee, in every role, is assessed against the same six: **Mastery & Growth, Integrity Above All, Compliance by Default, Ownership Mentality, Trust Through Documentation, and Lifting Others.** Where competencies vary by role, the behaviors are the firm's universal character standard — and two of them, Integrity Above All and Compliance by Default, carry the Integrity Gate weight you will meet in the performance cycle.

**Layer 3 — the Growth Ladder (PADP).** The Performance and Development Path is five cumulative stages from **G1 "Learn & Deliver" up to G5 "Cast"**, describing how scope and contribution grow with grade. It is reviewed inside the annual cycle as the development conversation, not as a separate exercise.

Brief your managers on one distinction every calibration season, because it trips everyone: a rating of 5 (Outstanding) on a competency set at **Foundation** means the person is exceptionally strong *at Foundation* — it does not mean they have reached Expert. The rating measures performance against the set target level, not the height of the ladder. (A legacy configuration once stored depth on a 1–5 scale; the portal is being corrected to F/P/E, so if you meet an old numeric record, read it as the F/P/E level, not as a fourth scale.)

## Role scorecards and the headcount door

A **role scorecard** is the contract between a role and the firm. It carries the four-to-six target competencies at their F/P/E levels, the six behaviors, and the family-driven weighting across the three appraisal dimensions — **Results, Competencies, and Behaviors**. You build it in a fixed order: draft the Results objectives with the hiring manager (SMART, and for a control function never tied to revenue); select the four-to-six competencies from the 26-competency bank and confirm the expected F/P/E level at the grade; enter it in the portal's Job & Competency module; and have the COO review and confirm before the first cycle opens.

The family sets the weighting, and there is a floor that matters: **Competencies are never weighted below 20%.** Business Development weights roughly 55/20/25 across Results, Competencies, and Behaviors; Leadership is the same 55/20/25 (a superseded version read 60/15/25, which breached the 20% floor and was corrected for the 2026 cycle); Administration & Corporate Services — your own family — is revenue-free at about 50/25/25, with its Results assessed on service quality and functional outcomes rather than money. You do not invent these per person; the family sets them and the scorecard inherits them.

You also **maintain** the scorecard. Results objectives are reviewed and updated at the start of each cycle in January's goal-setting; competencies and behavioral expectations are grade-level constants that do not change annually, though they may be updated if a role changes materially. Every scorecard update needs COO sign-off and must be entered in the portal **before the 28 February goal-sealing deadline**. The portal's Job & Competency module is the operational source of truth for current assignments and target levels.

And the headcount request — the one-line message from the manager — has a door, not an open frame. A new position starts with a **signed Headcount Request** from the requesting manager and **written COO approval** before any advertising begins. That approval is the first artifact in the recruitment record, and no role moves to a job description without it. Your job at this stage is to make the manager specify the grade, family, and target competencies up front, so the architecture is set before the search starts rather than reverse-engineered after a favorite candidate appears.

## A worked example

**Illustration — placing "the new analyst" (entirely hypothetical).** The manager's one-liner becomes real work. You confirm the headcount request is signed and the COO has approved it in writing. You place the role in the **Investments** family and, because the firm's market-facing roles use the special Investment banding, you set the grade against that band — say **G2**, midpoint anchored there. You build the scorecard from five competencies — Equity research & valuation, Market analysis, Trade execution & settlement, plus two cross-cutting ones — each at a **Proficient** target, weighted to the Investments family's profile. When a candidate is later offered ₦520,000 gross, you compute the fully-loaded monthly-equivalent (520,000 × 17 ÷ 12 ≈ ₦736,667 at full FTE) and read it against the G2 band: if that lands at a compa-ratio of, say, 0.78, you note it is below the 0.80 floor and flag it for the COO as a first-year priority rather than quietly underpaying. Nothing here is improvised — every number traces to the band, the family, and the canonical recipe.

## Common traps

- **Confusing monthly gross with fully-loaded.** Always convert (× 17 ÷ 12 ÷ FTE) before reading the band. A raw monthly figure misplaces the person every time.
- **Leaving revenue on a control-function scorecard.** Compliance, Risk, Internal Controls, Finance, and Accounting are never scored on revenue. Remove it; do not negotiate.
- **Reading grade from the title.** Grade belongs to the person. Resolve it from the person's record, not their job title.
- **Teaching the wrong compa floor.** The canonical floor is 0.80, not 0.85. The portal is authoritative.
- **Acting on a compa-ratio alone.** You surface below-0.80 and above-1.15 names to the COO with context; you do not adjust pay unilaterally.

## Key takeaways

- Grades G0–G5 are bands of total cost on the fully-loaded basis (gross × 17 ÷ 12 ÷ FTE); the midpoint is the anchor.
- Compa-ratio = fully-loaded ÷ midpoint; floor 0.80 (priority for raise), upper awareness 1.15 (no rise without COO review).
- Five families set scorecard weighting; the control-function flag (Compliance, Risk, Internal Controls, Finance, Accounting) bars revenue scoring — a hard independence rule.
- The 26 competencies across 9 categories are the firm's single skills vocabulary; scorecards carry 4–6 at an F/P/E target, scored against the target, not the top of the ladder.
- Grade belongs to the person, not the title; a new role starts with a signed headcount request and written COO approval.

*Reference: HR Operations Manual v1.1, Part B (Chapters B1–B5) and the Competency, Scorecard & Reward Framework (Transworld); supporting WS2 Workforce Architecture & Jobs. Pay model and compa thresholds per the canonical reward framework (fully-loaded = gross x 17 / 12 / FTE; floor 0.80; COO-awareness 1.15). This module is a navigation aid; the manual and the framework are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-201';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_01$id$, m.id, $p$A manager sends you a one-line request for a new analyst. As People Ops, what must exist before any advertising begins?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Nothing formal \u2014 a verbal request from a manager is enough to start advertising"}, {"key": "b", "text": "A signed Headcount Request from the requesting manager plus written COO approval"}, {"key": "c", "text": "A shortlisted candidate already in mind"}, {"key": "d", "text": "Board ratification of the role"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every new position starts with a signed Headcount Request and written COO approval before advertising — that approval is the first artifact in the recruitment record.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_02$id$, m.id, $p$An employee's monthly gross is ₦500,000 at full FTE. What is their fully-loaded monthly-equivalent figure used to read the band?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "\u20a6500,000 \u2014 gross and fully-loaded are the same"}, {"key": "b", "text": "\u20a6500,000 \u00d7 12 = \u20a66,000,000"}, {"key": "c", "text": "\u20a6500,000 \u00d7 17 \u00f7 12 \u2248 \u20a6708,333"}, {"key": "d", "text": "\u20a6500,000 \u00f7 17 \u2248 \u20a629,412"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Fully-loaded monthly-equivalent = gross × 17 ÷ 12 ÷ FTE. The annual cost is gross × 17 (12 monthly + 4 quarterly + 1 thirteenth-month).$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_03$id$, m.id, $p$The firm's canonical compa-ratio floor target is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "0.75"}, {"key": "b", "text": "0.80"}, {"key": "c", "text": "0.85"}, {"key": "d", "text": "1.00"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The canonical floor is 0.80 (the priority signal CR_PRIORITISE). Older notes that say 0.85 are superseded — the portal is authoritative.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_04$id$, m.id, $p$A compliance officer's draft scorecard includes a revenue target tied to deal volume. What do you do?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Keep it but cap the weighting at 10%"}, {"key": "b", "text": "Remove it \u2014 control-function roles are never scored on revenue"}, {"key": "c", "text": "Ask the COO to approve the revenue target case by case"}, {"key": "d", "text": "Leave it; revenue alignment motivates everyone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compliance, Risk, Internal Controls, Finance, and Accounting carry the control-function flag and are never scored on revenue. This is a hard independence rule — you remove it, you do not negotiate.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_05$id$, m.id, $p$Compa-ratio is defined as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "monthly gross \u00f7 annual gross"}, {"key": "b", "text": "fully-loaded monthly-equivalent \u00f7 grade midpoint"}, {"key": "c", "text": "grade maximum \u00f7 grade minimum"}, {"key": "d", "text": "basic salary \u00f7 utility allowance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compa-ratio = fully-loaded ÷ grade midpoint. A ratio of 1.00 means the person sits exactly at midpoint for their grade.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_06$id$, m.id, $p$How many job families does Transworld use, and which one is People Operations in?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Three families; People Ops is in Leadership"}, {"key": "b", "text": "Five families; People Ops is in Administration & Corporate Services"}, {"key": "c", "text": "Five families; People Ops is in Control & Operations"}, {"key": "d", "text": "Seven families; People Ops is its own family"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$There are five families. People Operations / HR sits in Administration & Corporate Services, alongside Procurement and Facilities.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_07$id$, m.id, $p$The firm holds how many functional competencies, across how many categories?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "22 competencies across 8 categories"}, {"key": "b", "text": "26 competencies across 9 categories"}, {"key": "c", "text": "30 competencies across 10 categories"}, {"key": "d", "text": "26 competencies across 5 families"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The canonical model is 26 functional competencies organized into nine categories — the single skills vocabulary used in every scorecard and record.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_08$id$, m.id, $p$Grade belongs to the title, so two people with the same job title must be on the same grade.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Grade belongs to the person, not the title. The portal resolves grade from the person's own record (falling back to the job profile), never from the title.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_09$id$, m.id, $p$A competency is set at a Foundation target and the employee scores 5 (Outstanding). What does that mean?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "They have reached Expert level on that competency"}, {"key": "b", "text": "They are exceptionally strong at the Foundation level \u2014 it does not mean Expert"}, {"key": "c", "text": "The rating is invalid because 5 is only for Expert targets"}, {"key": "d", "text": "Their target level should automatically be raised to Expert"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Ratings measure performance against the set target level. Outstanding at Foundation means exceptionally strong at Foundation — not that they have climbed the F/P/E ladder.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_10$id$, m.id, $p$A typical role scorecard assigns how many target competencies?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "All 26"}, {"key": "b", "text": "Exactly 2"}, {"key": "c", "text": "4 to 6"}, {"key": "d", "text": "10 to 12"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$No role carries all 26. Each scorecard assigns the 4 to 6 competencies most central to the role, each at an F/P/E target level.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_11$id$, m.id, $p$At which grade do employees choose between the Manager Track and the Expert Track?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "G0"}, {"key": "b", "text": "G1"}, {"key": "c", "text": "G3"}, {"key": "d", "text": "G5"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$At G3, the employee chooses — with their manager and People Ops — whether to follow the Manager Track or the Expert Track.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_12$id$, m.id, $p$An employee's compa-ratio is 1.22. What is the correct handling?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Process a further raise immediately to keep them happy"}, {"key": "b", "text": "Flag it: above 1.15, no further increase proceeds without COO review"}, {"key": "c", "text": "Cut their pay back to midpoint"}, {"key": "d", "text": "Ignore it \u2014 only low ratios matter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$1.15 is the upper awareness line. Above it, pay has run ahead of band, so no further increase proceeds without deliberate COO review.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_13$id$, m.id, $p$Why does the family determine whether revenue can appear as a Results objective?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Because revenue is hard to measure for some teams"}, {"key": "b", "text": "Because scoring control functions on revenue would compromise their independence"}, {"key": "c", "text": "Because only Leadership is allowed to see revenue figures"}, {"key": "d", "text": "It does not \u2014 every role can be scored on revenue"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The control-function flag bars revenue scoring so that Compliance, Risk, Internal Controls, Finance, and Accounting can stop bad deals without a pay conflict.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_14$id$, m.id, $p$Where is the operational source of truth for a role's current competency assignments and target levels?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The employee's signed contract"}, {"key": "b", "text": "The portal's Job & Competency module"}, {"key": "c", "text": "The payroll system, HumanManager"}, {"key": "d", "text": "The manager's personal notes"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal's Job & Competency module holds current assignments and target levels; the manual reproduces the canonical list so everyone shares the vocabulary.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_15$id$, m.id, $p$Pay bands for adjacent grades overlap, so a strong G2 performer can out-earn a new G3 entrant. This is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a defect you should correct by widening the gap"}, {"key": "b", "text": "the system working as intended"}, {"key": "c", "text": "only allowed for the Investments family"}, {"key": "d", "text": "evidence the G3 entrant is overpaid"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Bands overlap deliberately so depth of performance is rewarded; a strong performer near the top of one grade can exceed a new entrant in the next. That is by design.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_16$id$, m.id, $p$The Investments function uses the generic grade band like every other family.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$The Investment function carries its own special banding to reflect its market-facing nature — check the Investment-specific band when placing those roles.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_17$id$, m.id, $p$A manager says a candidate 'earns 400k'. What is your first question?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Whether that is monthly gross or the fully-loaded figure"}, {"key": "b", "text": "Whether the candidate has a degree"}, {"key": "c", "text": "Whether the figure includes the bonus"}, {"key": "d", "text": "Nothing \u2014 you place them at \u20a6400,000 on the band"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$You cannot read the band until you know whether 400k is monthly gross or fully-loaded. Confusing the two misplaces the person.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_18$id$, m.id, $p$Annual cost of an employee at Transworld is best expressed as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "monthly gross \u00d7 12"}, {"key": "b", "text": "monthly gross \u00d7 13"}, {"key": "c", "text": "monthly gross \u00d7 17 (12 monthly + 4 quarterly + 1 thirteenth-month)"}, {"key": "d", "text": "monthly gross \u00d7 20"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Annual = gross × 17: twelve monthly runs, four quarterly payments, and one thirteenth-month, each equal to one month's gross.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_19$id$, m.id, $p$Which set of roles carries the control-function flag?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Business Development, Marketing, and Sales"}, {"key": "b", "text": "Compliance, Risk, Internal Controls, Finance, and Accounting"}, {"key": "c", "text": "All Leadership roles"}, {"key": "d", "text": "Every role in the Administration family"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The control-function flag attaches to Compliance, Risk, Internal Controls, Finance, and Accounting — the roles whose independence must be protected from revenue incentives.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl201_20$id$, m.id, $p$When you find a below-0.80 compa-ratio during your monthly review, the correct action is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "raise the person's pay yourself to clear the flag"}, {"key": "b", "text": "surface the name to the COO with context as a priority for the next raise cycle, and record it"}, {"key": "c", "text": "delete the flag since pay is HumanManager's job"}, {"key": "d", "text": "tell the employee they are underpaid"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$You do not adjust pay unilaterally. You surface below-0.80 (and above-1.15) names to the COO with context and document the review in the portal.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
