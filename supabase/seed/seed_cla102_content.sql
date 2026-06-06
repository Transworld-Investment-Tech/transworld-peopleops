-- ===========================================================================
-- CLA-102 Who our clients are: customers vs. clients: lesson + 20-question check (v0.49.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$There is a quiet but important difference between a **customer** and a **client**, and it sits at the center of how Transworld sees its work. A customer buys a product and the relationship ends at the counter: a transaction, complete in itself. A client entrusts something of value — in our case, their financial future — and expects a continuing relationship built on judgment, care, and trust. The firm's own words are unambiguous: *we are not a trading firm; we are trusted partners in our clients' financial lives.* This module explains who our clients are, what the customer-versus-client distinction means for how you work, and why it matters to every employee — including those who never speak to a client directly. The firm's mantra runs underneath all of it: **the right way is always the best way.**

## What you'll be able to do

1. Explain the difference between a customer and a client, and why Transworld serves clients.
2. Describe the main client categories the firm serves and what each expects.
3. Describe the firm's service models and how the relationship differs across them.
4. Explain client classification and the rule that it never lowers the standard of service.
5. Connect your own role — whatever it is — to the client who ultimately receives your work.

## Customer or client?

The two words are often used loosely, but the distinction is real and worth holding onto.

A **customer** relationship is transactional. The customer wants a specific thing, pays for it, receives it, and the obligation is discharged. Think of buying a ticket or a meal: once delivered, neither party owes the other anything further. Quality still matters, but the relationship is built around the **transaction**.

A **client** relationship is continuing and built on **trust**. A client places something they care about — their savings, their retirement, an estate, an institution's reserves — in the firm's hands and relies on the firm's honesty and judgment over time. The obligation does not end when a single order is filled; it persists across the life of the relationship. As the firm's conflict-of-interest policy puts it, **trust is the only product we actually sell** — the shares already exist, the systems to route orders already exist; what distinguishes a broker the market will deal with is the belief that the people inside it act honestly and in the interests of those they serve.

> Transworld serves **clients**, not merely customers. That single choice of word shapes everything downstream: we measure ourselves not by whether a transaction completed, but by whether the client's interest was genuinely served.

## The distinction, made concrete

Picture two moments. In the first, a walk-in wants to buy a specific stock today, places the order, and you execute it correctly. The transaction is clean and the obligation is met. That is the **customer** frame — and even here the firm's standards apply in full.

Now picture the second. A retiree has moved the bulk of their savings to the firm and asks the firm to help make it last. There is no single transaction that discharges this. It calls for understanding their goals and risk appetite, advising honestly even when the honest answer is "do less," reviewing the portfolio as circumstances change, and being transparent when something goes wrong. That is the **client** frame — a relationship measured over years, not at a counter. The firm is built for the second kind of relationship. When the two frames seem to conflict — when doing the quick, transactional thing would not serve the client's longer interest — the client relationship is the one that governs.

## Who our clients are

The firm serves two broad categories of client, and knowing what each expects is part of serving them well:

- **Individual clients** — high-net-worth individuals, professionals, retirees, young investors, and small-business owners. What they expect: personalized advice, transparency, trust, and consistent long-term performance.
- **Institutional clients** — corporations, pension funds, foundations, endowments, and educational institutions. What they expect: rigorous compliance, transparent reporting, dedicated management, and institutional-grade solutions.

The two have different needs and different levels of sophistication, but they share the same underlying expectation: that the firm acts in their interest, competently and honestly.

## How we serve them

The relationship also varies by the service model the client chooses — and the firm's role shifts accordingly:

- **Self-Managed Accounts.** The client directs their own investments, supported by the firm's platform, research tools, and customer service. We provide the infrastructure; the client makes the decisions.
- **Specially Managed Accounts.** The client prefers a fully managed approach. The firm's investment professionals actively manage the portfolio against agreed goals, risk appetite, and time horizon, with regular reviews and transparent reporting.
- **Advisory Services.** Expert guidance across retirement planning, estate planning, tax-efficient investing, risk management, and insurance — helping clients make fully informed decisions at every stage of life.

The depth of the firm's discretion differs across these — most in a specially managed account, least in a self-managed one — but the duty of care does not. A self-managed client who relies on the firm's research is owed the same honesty as a client whose portfolio the firm runs end to end.

## Client classification — and what it never does

For the purpose of order execution, clients are also **classified** — broadly, as **retail** or **professional/institutional**. Retail clients (most individual account holders) receive the highest, most prescriptive level of care, with total financial consideration — price plus costs — treated as the paramount factor, and full disclosure of execution arrangements. Professional or institutional clients are owed the same standard in principle, but the weighting of execution factors may be adjusted through documented agreement to fit their needs. Each client's classification is recorded in the file and reviewed annually as part of the KYC refresh.

>! One rule about classification is absolute: a client's classification may **never** be used to justify a *lower* standard of service or execution. Classification affects **how** the standard is applied — it never lowers it. Every client, retail or institutional, deserves the most favorable outcome achievable in the circumstances.

This connects directly to a principle you will meet again in operations: **client priority**. The firm's own (proprietary) positions never come before a client's order. When the firm's interest and a client's interest could compete, the client comes first — that is what a trust relationship requires.

## Why this matters to every employee

It is tempting to think the customer-versus-client distinction only concerns the people who sit across from clients — the relationship officers and advisors. It does not. The quality of every employee's work, however far from the client-facing side, ultimately reaches the people who trust the firm with their financial futures. A settlement processed accurately, a record filed correctly, a payment made on time, a system kept running, a report produced cleanly — each of these is a link in the chain that ends at a client. A weak link anywhere is felt eventually by someone who placed their trust in the firm.

This is also why the firm frames its commitments the way it does. Among the five pillars agreed at the firm's February 2026 retreat are **Becoming Trusted** and being **Customer-Led** — not as slogans, but as operating commitments. To be customer-led is to start from the question, in any decision, of what genuinely serves the client. To become trusted is to behave, consistently and over time, in a way that earns and keeps that trust.

## What a client relationship asks of you, day to day

The distinction is not abstract — it shows up in ordinary choices:

- **Put the client's interest first**, even when a faster or more convenient path would serve the firm or yourself. Where interests could compete, the client comes first.
- **Be transparent.** A client relationship cannot survive on hidden costs, vague answers, or quiet errors. Disclose, explain, and correct openly.
- **Do the unglamorous work accurately.** The reconciliation, the filing, the record, the contract note — these are where trust is actually kept or broken.
- **Escalate honestly.** If something looks wrong for the client, raise it through the proper channel rather than letting it pass.
- **Treat client information as a trust.** Personal and financial data is held in confidence and protected — handling it carelessly is itself a breach of the relationship.

None of these requires a client-facing title. They are simply what it means to work inside a firm whose product is trust.

## The bottom line

A customer buys something and leaves. A client stays, and trusts. Transworld is in the business of clients — of continuing relationships in which people and institutions rely on the firm's judgment and integrity with money that matters to them. Whatever your role, you are part of how the firm keeps faith with those clients. Hold the distinction in mind, and the standard it implies follows naturally: serve the client's interest, every time, and do it the right way — because the right way is always the best way.

---

*Foundational client module · Tier B · function-head review on each annual cycle. Built on the Employee Handbook, Operational Manual, and Best Execution Policy; reviewed against firm materials.*$body$,
    pass_mark = 80,
    estimated_minutes = 25,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'CLA-102';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_01$id$, m.id, $p$What is the core difference between a customer and a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A customer pays more than a client"},{"key":"b","text":"A customer relationship is transactional and ends at delivery; a client relationship is continuing and built on trust"},{"key":"c","text":"A client only ever uses self-managed accounts"},{"key":"d","text":"There is no real difference"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A customer relationship is transactional and complete at delivery; a client relationship continues over time and rests on trust and judgment.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_02$id$, m.id, $p$How does the firm describe what it fundamentally is?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A trading firm focused on transaction volume"},{"key":"b","text":"Trusted partners in clients' financial lives, not merely a trading firm"},{"key":"c","text":"A technology vendor"},{"key":"d","text":"A retail shop"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm states it is not a trading firm but trusted partners in clients' financial lives.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_03$id$, m.id, $p$The conflict-of-interest policy says the firm sells, more than anything else:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Shares"},{"key":"b","text":"Research"},{"key":"c","text":"Trust"},{"key":"d","text":"Order-routing technology"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Trust is the only product the firm actually sells — the shares and systems already exist; what distinguishes the firm is the belief that its people act honestly and in clients' interests.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_04$id$, m.id, $p$Which categories of client does the firm serve? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Individual clients (HNWIs, professionals, retirees, young investors, small-business owners)"},{"key":"b","text":"Institutional clients (corporations, pension funds, foundations, endowments, educational institutions)"},{"key":"c","text":"Only foreign governments"},{"key":"d","text":"Only other brokers"}]$o$::jsonb, $c$["a","b"]$c$::jsonb, $e$The firm serves individual and institutional clients; both expect the firm to act in their interest competently and honestly.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_05$id$, m.id, $p$In a Self-Managed Account, what is the firm's role?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The firm makes all investment decisions for the client"},{"key":"b","text":"The firm provides the platform, research tools, and customer service; the client makes the decisions"},{"key":"c","text":"The firm guarantees returns"},{"key":"d","text":"The firm does nothing"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In a self-managed account the client directs their own investments and the firm provides the infrastructure and support.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_06$id$, m.id, $p$In a Specially Managed Account, what is the firm's role?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The client makes every decision alone"},{"key":"b","text":"The firm's professionals actively manage the portfolio against agreed goals, risk appetite, and time horizon, with regular reviews"},{"key":"c","text":"The firm only provides research, no management"},{"key":"d","text":"The account is dormant"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In a specially managed account, the firm actively manages the portfolio against agreed objectives with transparent reporting.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_07$id$, m.id, $p$For order execution, clients are broadly classified as:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Gold and silver"},{"key":"b","text":"Retail and professional/institutional"},{"key":"c","text":"Domestic and foreign only"},{"key":"d","text":"New and returning"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Clients are classified broadly as retail or professional/institutional, which affects how the execution standard is applied.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_08$id$, m.id, $p$A client's classification may be used to justify a lower standard of service or execution.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Classification affects how the standard is applied — it never lowers it. Every client deserves the most favorable outcome achievable.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_09$id$, m.id, $p$Which client category typically receives the most prescriptive disclosures, with total financial consideration treated as paramount?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Professional clients"},{"key":"b","text":"Retail clients"},{"key":"c","text":"Institutional clients"},{"key":"d","text":"No client receives disclosures"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Retail clients receive the highest, most prescriptive level of care, with total consideration (price plus costs) treated as paramount.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_10$id$, m.id, $p$How does the principle of 'client priority' apply when the firm's own positions could compete with a client's order?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The firm's proprietary positions come first"},{"key":"b","text":"The client comes first; proprietary positions never come before a client's order"},{"key":"c","text":"Whichever is larger comes first"},{"key":"d","text":"The Dealer decides case by case"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client priority means the firm's proprietary positions never come before a client's order — the client comes first.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_11$id$, m.id, $p$The customer-versus-client distinction only matters to client-facing staff like relationship officers.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$It matters to every employee — the quality of all work, however far from the desk, ultimately reaches the client who trusts the firm.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_12$id$, m.id, $p$A settlement processed accurately and a record filed correctly are best understood as:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Irrelevant to the client relationship"},{"key":"b","text":"Links in a chain that ends at a client who placed their trust in the firm"},{"key":"c","text":"Purely internal matters with no client impact"},{"key":"d","text":"Optional tasks"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every accurate piece of back-office work is a link in the chain that ends at the client; a weak link anywhere is felt by someone who trusted the firm.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_13$id$, m.id, $p$Which of the firm's five pillars relate most directly to the client relationship? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Becoming Trusted"},{"key":"b","text":"Customer-Led"},{"key":"c","text":"Ignoring feedback"},{"key":"d","text":"Avoiding clients"}]$o$::jsonb, $c$["a","b"]$c$::jsonb, $e$Becoming Trusted and being Customer-Led are the pillars most directly about the client relationship — operating commitments, not slogans.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_14$id$, m.id, $p$What does it mean, in practice, to be 'Customer-Led'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To start from what genuinely serves the client in any decision"},{"key":"b","text":"To let the client run the firm's operations"},{"key":"c","text":"To prioritize the firm's profit over the client"},{"key":"d","text":"To reduce client contact"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Being customer-led means starting from the question of what genuinely serves the client in any decision.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_15$id$, m.id, $p$Which behaviors does a client relationship ask of you day to day? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Put the client's interest first where interests could compete"},{"key":"b","text":"Be transparent — disclose, explain, and correct openly"},{"key":"c","text":"Do the unglamorous work accurately"},{"key":"d","text":"Treat client information as a trust and protect it"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$All four — client-first, transparency, accuracy in unglamorous work, and protecting client information — are what a trust relationship asks of every employee.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_16$id$, m.id, $p$Across self-managed, specially managed, and advisory relationships, what stays constant?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The firm's level of discretion"},{"key":"b","text":"The duty of care owed to the client"},{"key":"c","text":"The fees charged"},{"key":"d","text":"The number of reviews"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm's discretion varies by service model, but the duty of care does not — a self-managed client relying on the firm's research is owed the same honesty as a fully managed one.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_17$id$, m.id, $p$How is each client's classification maintained over time?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Set once at onboarding and never revisited"},{"key":"b","text":"Recorded in the client file and reviewed annually as part of the KYC refresh"},{"key":"c","text":"Decided by the client each trade"},{"key":"d","text":"Published publicly"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Classification is recorded in the file and reviewed annually as part of the KYC refresh, updated if the client's circumstances change.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_18$id$, m.id, $p$When a quick transactional action would not serve a client's longer-term interest, the client relationship is the consideration that governs.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The firm is built for client relationships; where the transactional and relationship frames conflict, the client relationship governs.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_19$id$, m.id, $p$What do individual clients principally expect from the firm?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The lowest possible fees and nothing else"},{"key":"b","text":"Personalized advice, transparency, trust, and consistent long-term performance"},{"key":"c","text":"Anonymous, hands-off service"},{"key":"d","text":"Guaranteed profits"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Individual clients expect personalized advice, transparency, trust, and consistent long-term performance.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla102_20$id$, m.id, $p$What do institutional clients principally expect from the firm?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Rigorous compliance, transparent reporting, dedicated management, and institutional-grade solutions"},{"key":"b","text":"Casual, informal handling"},{"key":"c","text":"No reporting"},{"key":"d","text":"Retail-only products"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Institutional clients expect rigorous compliance, transparent reporting, dedicated management, and institutional-grade solutions.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
