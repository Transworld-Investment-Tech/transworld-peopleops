-- ===========================================================================
-- seed_fnd101_content.sql -- FND-101 Welcome to Transworld: lesson + 10-question check (v0.46.1 content)
-- Tier C, ADAPT (People Operations). Sources: WS1 Part 3 + WS2 Layer 3.
-- v0.46.1: a 10-question server-graded check (80% pass) was ADDED to this previously lesson-only
--   module. Owner-reviewed; Tier C/B -> NO CCO hard gate; publishes on run.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Welcome to Transworld. This first module is short and matters more than its length suggests: it tells you what kind of firm you have joined, what we are trying to build together, and the handful of behaviors we ask of every single person here — from the newest intern to the Chairman.

## Who we are

Transworld Investment and Securities Limited is an SEC-regulated investment and securities firm, operating in Nigeria's capital markets since 1988 and based in Lagos. We are a lean team. That is a feature, not an apology: it means every person's work is visible and matters, and there is nowhere for good or poor effort to hide.

## What we are building

Our vision is to be **the firm that turns young, ambitious people into complete capital-markets professionals** — masters of their craft, trusted by clients, known for professionalism and integrity, and at the forefront of Nigeria's next generation of capital markets. Not narrow specialists who can do one thing, but rounded professionals: sharp in the markets, trusted by clients, sound in judgment, and straight in character.

Our mission is simpler still: **we invest in our people — we train them to be the best, pay them among the best, and grow what they earn as the firm grows.** Everything else in this module is just what it takes to keep that sentence honest, on both sides.

## What we promise you

These are commitments you can hold us to, not sentiments:

1. **We will train you to be among the best.** Real development, not box-ticking — including funding the qualifications that matter in this profession. Getting better at your craft is part of the job here.
2. **We will pay you among the highest in the market.** Fair bands, set openly, that rise as you prove yourself, with a bonus funded from real profit when the firm does well.
3. **When the firm grows, you grow with it.** The growth you help create becomes everyone's raise — the same percentage, top to bottom. We rise together or not at all.
4. **We will be fair, and we will be clear.** Clear grades, clear scorecards, clear process. You will always know where you stand and how to climb — no favorites, no mystery.
5. **We will treat you as a career, not a cost.** You can become a master of your craft without being forced to manage people to earn more — the expert path pays as well as the manager path.

## What we ask of you

A compact has two sides. In return we ask you to aim higher than your paycheck:

1. **Master your craft.** Be the person who knows the answer — or goes and finds it. "Good enough" is not the standard here.
2. **Be someone people can trust.** In this business integrity is not a soft value — it is the product. Do the right thing when no one is watching, especially when it costs you.
3. **Create value, don't just fill a seat.** Bring solutions, not just problems. Leave everything you touch better than you found it.
4. **Solve hard things.** Take ownership of the problem in front of you instead of passing it up or around.
5. **Lift the people beside you.** Teach what you know; make the team stronger than your own scorecard.

## The six behaviors

Those promises and asks crystallize into six behaviors expected of every role, at every grade — assessed alongside your technical skills:

1. **Mastery & Growth** — relentlessly improve your craft and capacity; how fast you learn matters as much as what you produce today.
2. **Integrity Above All** — do the right thing, the right way, always, especially when it costs. The right way is always the best way.
3. **Compliance by Default** — compliance is built into how you work, never assembled when an inspector knocks. Aim to be ahead of the regulator.
4. **Ownership Mentality** — treat this as our company; create value, run toward hard problems, and leave things better than you found them.
5. **Trust Through Documentation** — communicate proactively and document diligently. *What is not documented did not happen* — trust is built on a reliable record.
6. **Lifting Others** — empower and develop the people around you; give them time, space, and resources.

> Read the six behaviors as a description of a colleague you would want beside you. That is the bar — and it is the same for everyone.

## What this is not

We will be straight about the limits. We are not promising the easiest job in the market, and we are not promising raises in years the firm does not grow. Reward follows results: meet your goals and you earn your full bonus; fall short and it shrinks; the rules are the same for everyone. What we promise is that the rewards are real, the rules are identical for all, and the upside is genuinely shared. Grow the firm, and you grow with it. Welcome aboard.

## References

- **WS1 Foundation & Governance, Part 3 — Our People: Mission, Vision & Strategy** (the vision, mission, promises, and asks) — primary source.
- **WS2 Workforce Architecture & Jobs, Part 3, Layer 3 — Behavioral Expectations** (the six behaviors) — primary source.
- Supporting: Employee Handbook v2.1 (culture voice); Transworld Retreat Report 2026 (tone and ownership mindset).
- *Foundational induction module · content owner: People Operations. Tier C — adapted from the firm's own canonical material.*$body$,
    pass_mark = 80,
    estimated_minutes = 15,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-101';

-- 2. the 10-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_01$id$, m.id, $p$What is Transworld's mission, as stated in this module?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "To become the largest broker on the NGX"}, {"key": "b", "text": "To invest in our people — train them to be the best, pay them among the best, and grow what they earn as the firm grows"}, {"key": "c", "text": "To minimize payroll costs"}, {"key": "d", "text": "To avoid all regulatory scrutiny"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The mission is to invest in our people: train them to be the best, pay them among the best, and grow what they earn as the firm grows.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_02$id$, m.id, $p$Under the promise 'when the firm grows, you grow with it', the annual raise is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The same percentage for everyone, top to bottom"}, {"key": "b", "text": "Larger for senior staff"}, {"key": "c", "text": "Negotiated individually in secret"}, {"key": "d", "text": "Guaranteed every year regardless of results"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The growth everyone helps create becomes everyone's raise — the same percentage for everyone, top to bottom. We rise together or not at all.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_03$id$, m.id, $p$At Transworld you must move into people management to reach senior pay.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. You can become a master of your craft without managing people — the expert path pays as well as the manager path. We treat people as a career, not a cost.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_04$id$, m.id, $p$Which of these are among the firm's six behaviors? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Integrity Above All"}, {"key": "b", "text": "Trust Through Documentation"}, {"key": "c", "text": "Compliance by Default"}, {"key": "d", "text": "Cut corners when busy"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$The six behaviors are Mastery & Growth, Integrity Above All, Compliance by Default, Ownership Mentality, Trust Through Documentation, and Lifting Others. Cutting corners is the opposite of what the firm asks.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_05$id$, m.id, $p$'The right way is always the best way' best expresses which behavior?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Lifting Others"}, {"key": "b", "text": "Integrity Above All"}, {"key": "c", "text": "Mastery & Growth"}, {"key": "d", "text": "Ownership Mentality"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Integrity Above All — do the right thing, the right way, always, especially when it costs. The right way is always the best way.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_06$id$, m.id, $p$The behaviour 'Compliance by Default' means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Compliance is assembled only when an inspector arrives"}, {"key": "b", "text": "Compliance is built into how you work — aim to be ahead of the regulator"}, {"key": "c", "text": "Compliance applies only to senior staff"}, {"key": "d", "text": "Compliance is optional if results are strong"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compliance by Default means it is built into everyday work, never assembled when an inspector knocks — and we aim to be ahead of the regulator.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_07$id$, m.id, $p$Which is one of the things the firm asks of you?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Master your craft and run toward hard problems"}, {"key": "b", "text": "Keep your knowledge to yourself for advantage"}, {"key": "c", "text": "Do the minimum to keep your seat"}, {"key": "d", "text": "Avoid documenting your work"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The asks include master your craft, be someone people can trust, create value, solve hard things, and lift the people beside you.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_08$id$, m.id, $p$The firm promises raises every year regardless of how the firm performs.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The firm is explicit that it does not promise raises in years it does not grow. Reward follows results, and the rules are the same for everyone.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_09$id$, m.id, $p$'Lifting Others' as a behaviour asks you to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Compete so your scorecard always beats the team's"}, {"key": "b", "text": "Empower and develop the people around you; make the team stronger than your own scorecard"}, {"key": "c", "text": "Delegate all your own work"}, {"key": "d", "text": "Only help people more senior than you"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Lifting Others means empowering and developing the people around you and making the team stronger than your own scorecard — giving people time, space, and resources.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd101_10$id$, m.id, $p$The promises in this module are best understood as:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Aspirations the firm may or may not honour"}, {"key": "b", "text": "Commitments you can hold the firm to, with rules identical for everyone"}, {"key": "c", "text": "Rules that apply only to new joiners"}, {"key": "d", "text": "Marketing for clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$They are commitments you can hold the firm to, not sentiments — and the rules are identical for all, with the upside genuinely shared.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
