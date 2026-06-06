-- ===========================================================================
-- FND-101 Welcome to Transworld: mission, values & the six behaviors -- lesson only (v0.46.0 content)
-- Tier C, ADAPT. Sources: WS1 Part 3 (mission/vision/promises/asks) + WS2 Layer 3 (six behaviors);
--   supporting Employee Handbook v2.1 + Retreat Report 2026. Owner: People Operations.
-- Lesson-only: no graded check; pass_mark stays NULL. Publishes on run.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish (lesson-only; pass_mark stays NULL)
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
    estimated_minutes = 15,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-101';

COMMIT;
