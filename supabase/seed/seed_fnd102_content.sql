-- ===========================================================================
-- seed_fnd102_content.sql -- FND-102 How the firm works: lesson + 10-question check (v0.46.1 content)
-- Tier C, ADAPT (People Operations). Sources: WS2 Parts 1-3 + WS1 Part 2 + HR Ops A/B.
-- v0.46.1: a 10-question server-graded check (80% pass) was ADDED to this previously lesson-only
--   module. Owner-reviewed; Tier C/B -> NO CCO hard gate; publishes on run.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Now that you know what kind of firm Transworld is, this module shows you how it is put together — the families of work, the grades people occupy, the two ways a career grows, and the ladder of contribution behind it. Understanding the architecture helps you see where you fit and how you climb.

## Three building blocks

Every role is described by three things working together:

- **Family** — *what kind of work* it is.
- **Track** — *how a person grows* in it: Manager or Expert.
- **Grade** — *the scope and reward* of the role, on a single ladder from G0 to G5.

We kept the G0–G5 grades the firm already ran on and overlaid families and a dual track on top, rather than renumbering everything.

## The five families

- **Business Development** — winning and growing the firm's book of business; this family also includes Marketing & Communications.
- **Investments** — the research and investment engine: analysts and associates who research markets, value securities, and shape advisory decisions.
- **Control & Operations** — the operational backbone and the largest family: the control functions (compliance, risk, internal control, finance, accounting) and operations & execution (dealing, client operations, the field force, technology).
- **Administration & Corporate Services** — the administrative backbone: People Operations, Procurement & Vendor Management, and Facilities / Office Administration.
- **Leadership** — whole-firm leadership: the MD, COO, CFO, and cross-functional executive roles.

> **Control-function independence.** Compliance, risk, internal control, and the finance/accounting line are paid on their own functional objectives — never on desk or trading revenue. This protects their independence and is a rule the firm takes seriously.

## Two career tracks — Manager and Expert

People grow in one of two directions, and both reach senior pay. The **Manager track** grows by leading people; the **Expert track** grows by mastery — becoming so good at the craft that the firm pays you like a leader without asking you to manage anyone. Through G0–G2 everyone shares a common foundation; from G3 upward the tracks diverge, and either path can reach G4 and G5. It is your **grade — not your track — that sets the pay band**, which is exactly what lets expertise pay as well as management.

## The grades

| Grade | Level | What sets it apart |
|---|---|---|
| G0 | Intern / NYSC | Learning; closely supervised |
| G1 | Entry / Support | Executes defined tasks under guidance |
| G2 | Associate | Handles routine work independently |
| G3 | Senior / Specialist | Autonomous; owns an area. The tracks split here. |
| G4 | Manager or Principal | Runs a team/function, or is a firm-wide expert |
| G5 | Head / Executive | Shapes firm direction; whole-firm scope |

Each grade carries a fully-loaded pay band, and a grade can also hold Junior / Mid / Senior **rungs** that mark progress through its range without being separate grades (used by the Investment roles today). Most of the team sits below the midpoint of their grade — room for pay to rise within grade as people prove themselves and the firm grows.

## The Growth Ladder (PADP)

The proficiency of a single skill measures depth; the Growth Ladder measures something different — the **scope of contribution and leadership** each grade represents. It is the firm's Personal Assessment & Development Path, and it is cumulative: each rung adds to everything below it.

- **G1 — Learn & Deliver:** learn fast and get things done well; this is where future leaders are first spotted.
- **G2 — Collaborate:** work well across people, teams, and functions.
- **G3 — Lead a Team:** the first true leadership rung; the Manager/Expert tracks split here.
- **G4 — Lead Teams / a Function:** lead multiple teams or a whole function while still performing at a high level.
- **G5 — Cast Vision:** set direction for the whole organization.

>! The hardest step is **G2 → G3 — the move from doer to developer.** Up to G2 you grow by doing; from G3 you grow by getting people to do. On the Expert track the same rungs are read as *leadership through mastery and influence* rather than line management — a master analyst and a department head can sit at the same grade and the same pay.

## How decisions and people are governed

Transworld is run as a lean but properly-governed firm. People operations is owned by a single **People-Ops Officer** who *administers and advises* but does not approve their own pay, hiring budgets, or strategy — approvals sit above administration, with the COO, MD, and the Board Remuneration Committee. Compliance and conduct matters route to the **Chief Compliance Officer**, who holds an independent line to the Board, so a concern is never bottled up inside the function it concerns. The escalation ladder is simple: **Employee → Line Manager → People-Ops → COO → MD → Board / Chairman**, with a parallel control line straight to the CCO for compliance and conduct.

## The 26 competencies

Behind the families sits a catalog of **26 functional competencies across nine categories** — Client & Advisory; Finance & Accounting; Investment & Markets; Leadership & Governance; Operations & Controls; Regulatory & Compliance; Technology; Business Development; and Administration. Each role holds a defined set at a target depth — Foundational, Proficient, or Expert — that rises with grade and with how central the skill is to the role. Together with the six behaviors and the Growth Ladder, this is how the firm defines what "good" looks like for every person.

## Key takeaways

- Every role = **family + track + grade.**
- **Five families:** Business Development, Investments, Control & Operations, Administration & Corporate Services, Leadership.
- **Two tracks** — Manager and Expert — both reach senior pay; **grade sets the band**, not track.
- **Grades G0–G5**, with optional Junior/Mid/Senior rungs.
- The **Growth Ladder** runs Learn & Deliver → Collaborate → Lead a Team → Lead a Function → Cast Vision; the **G2→G3 doer-to-developer** step is the hardest.
- Governance is lean but real: administration is separate from approval, and Compliance has an independent line to the Board.

## References

- **WS2 Workforce Architecture & Jobs, Parts 1–3** (families, tracks, grades, role inventory, Growth Ladder, competency model) — primary source.
- **WS1 Foundation & Governance, Part 2 — HR Unit Design & Governance Pack** (operating model, escalation ladder, Remuneration Committee) — primary source.
- **HR Operations Manual v1.1, Parts A–B** (function and workforce architecture) — primary source.
- Supporting: **WS7 Learning & Development, Part 2 — the Grade-Based Growth Path**; the live portal structure.
- *Foundational induction module · content owner: People Operations. Tier C — adapted from the firm's own canonical material. Note: the compa-ratio floor is 0.80 (per the portal/canonical model); WS2 still prints 0.85 — logged as an open doc-fix.*$body$,
    pass_mark = 80,
    estimated_minutes = 20,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-102';

-- 2. the 10-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_01$id$, m.id, $p$Every role at Transworld is described by which three things?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Title, salary, and office"}, {"key": "b", "text": "Family, track, and grade"}, {"key": "c", "text": "Department, age, and tenure"}, {"key": "d", "text": "Manager, location, and shift"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every role = family (what kind of work) + track (how a person grows) + grade (scope and reward, G0–G5).$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_02$id$, m.id, $p$Which of these is one of the firm's five job families?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Administration & Corporate Services"}, {"key": "b", "text": "Logistics"}, {"key": "c", "text": "Manufacturing"}, {"key": "d", "text": "Retail"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The five families are Business Development, Investments, Control & Operations, Administration & Corporate Services, and Leadership.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_03$id$, m.id, $p$What sets a person's pay band — their track or their grade?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Their track (Manager vs Expert)"}, {"key": "b", "text": "Their grade"}, {"key": "c", "text": "Their family"}, {"key": "d", "text": "Their length of service"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Grade — not track — sets the pay band. That is what lets expertise pay as well as management.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_04$id$, m.id, $p$On the two career tracks:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only the Manager track reaches senior pay"}, {"key": "b", "text": "Both the Manager and Expert tracks reach senior pay"}, {"key": "c", "text": "Only the Expert track reaches senior pay"}, {"key": "d", "text": "Neither reaches senior pay without an MBA"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Both tracks reach senior pay: the Manager track grows by leading people; the Expert track grows by mastery.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_05$id$, m.id, $p$On the Growth Ladder, the grade where the Manager and Expert tracks split is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "G1 — Learn & Deliver"}, {"key": "b", "text": "G2 — Collaborate"}, {"key": "c", "text": "G3 — Lead a Team"}, {"key": "d", "text": "G5 — Cast Vision"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$From G3 upward the tracks diverge. G3 is the first true leadership rung — 'Lead a Team'.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_06$id$, m.id, $p$Which step on the Growth Ladder is described as the hardest?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "G1 → G2"}, {"key": "b", "text": "G2 → G3 — the move from doer to developer"}, {"key": "c", "text": "G3 → G4"}, {"key": "d", "text": "G4 → G5"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$G2 → G3 is the hardest — the move from doer to developer. Up to G2 you grow by doing; from G3 you grow by getting people to do.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_07$id$, m.id, $p$Control functions (compliance, risk, internal control, finance, accounting) are paid on desk or trading revenue.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Control functions are paid on their own functional objectives, never on desk or trading revenue — this protects their independence.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_08$id$, m.id, $p$The firm's escalation ladder runs:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Employee → Line Manager → People-Ops → COO → MD → Board / Chairman"}, {"key": "b", "text": "Employee → CEO directly"}, {"key": "c", "text": "Employee → external regulator first"}, {"key": "d", "text": "There is no defined ladder"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The ladder is Employee → Line Manager → People-Ops → COO → MD → Board/Chairman, with a parallel control line straight to the CCO for compliance and conduct.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_09$id$, m.id, $p$On the Growth Ladder, G5 represents:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Learn & Deliver"}, {"key": "b", "text": "Collaborate"}, {"key": "c", "text": "Lead a Team"}, {"key": "d", "text": "Cast Vision — setting direction for the whole organization"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$G5 is 'Cast Vision' — setting direction and casting vision for the whole organization.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd102_10$id$, m.id, $p$The firm's competency catalog contains:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "10 competencies across 3 categories"}, {"key": "b", "text": "26 competencies across nine categories"}, {"key": "c", "text": "50 competencies across twelve categories"}, {"key": "d", "text": "No defined competencies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$There are 26 functional competencies across nine categories, each held to a target depth (Foundational / Proficient / Expert).$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
