-- ===========================================================================
-- BDV-102 Know what you sell: products, services & instruments: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$You cannot sell honestly what you do not understand. A business developer who cannot explain, in plain language, what the firm offers and what each instrument actually is will eventually either mislead a client or lose one. This module is the menu: the **services** Transworld provides, the **account types** a client can hold, and the **financial instruments** that can be traded through the firm — described simply, accurately, and without hype. It also draws a clear line between what the firm offers *clients* and what the firm does with its *own* money, because a BD person should be able to speak accurately about both. The firm's mantra governs every product conversation: **the right way is always the best way** — which means describing what we offer truthfully, and never promising what no one can.

## What you'll be able to do

1. Describe the firm's three client service models and the firm's role in each.
2. Name the account types a client can hold.
3. Explain, in plain terms, the main instruments clients can trade and their broad risk character.
4. Explain how the firm handles its own money, and why client orders always come first.
5. Apply the rule that what you sell must be described accurately and matched to the client's suitability.

## The services we offer clients

Transworld is a licensed broker, but it offers more than execution. There are three service models, and the firm's role differs across them:

- **Self-Managed Accounts.** The client directs their own investments, supported by the firm's platform, research tools, and customer service. The firm provides the infrastructure; the client makes the decisions. Best for clients who want control and have the confidence to use it.
- **Specially Managed Accounts.** The client prefers a fully managed approach. The firm's investment professionals actively manage the portfolio against agreed goals, risk appetite, and time horizon, with regular reviews and transparent reporting. Best for clients who want expertise to run their portfolio for them.
- **Advisory Services.** Expert guidance across retirement planning, estate planning, tax-efficient investing, risk management, and insurance — helping clients make fully informed decisions at every stage of life.

Underpinning all three is the core brokerage function: executing buy and sell orders on the NGX on the client's behalf, settling them, and keeping the records. The right model for a client depends on how much control they want and how much they want the firm to do — a question of fit, not of which earns the most. A useful way to frame it for a prospect: a self-managed client is driving the car with the firm providing the vehicle and the map; a specially managed client is being driven by a professional to a destination they set; an advisory client is getting expert directions but choosing their own route. Part of doing business development well is hearing, in how a client talks about their money, which of those they actually want — and recommending that, even when a different model would earn the firm more.

## Account types

A client's relationship is held in an account, and there are four basic types: **Individual** (one person in their personal capacity), **Corporate** (a company or other entity), **Estate** (assets of a deceased person's estate), and **Joint** (two or more holders). Individual accounts are further classified into **three KYC tiers** (Basic, Standard, Premium) that set documentation requirements and transaction limits — the detail lives in the client-onboarding module (CLA-101). For BD purposes, the point is that the account type and tier shape what a client can do, and you should never promise a client a level of access their documentation does not support.

## The instruments clients can trade

These are the building blocks. In plain terms:

- **Equities (shares).** Part-ownership of a listed company. The return comes from price appreciation and dividends; the risk is that the price can fall, sometimes sharply. Equities are the higher-risk, higher-potential-return end of the menu.
- **Federal Government (FGN) bonds and Treasury Bills.** Lending to the Federal Government for a fixed period at a set return. T-Bills are short-term and highly liquid; FGN bonds run longer. Government-backed, these are the lower-risk end — the return is more modest but far more predictable.
- **State and corporate bonds.** Lending to a state government or a company. Higher return than FGN paper to compensate for higher credit risk; quality varies with the issuer, which is why credit ratings matter.
- **Sukuk and Green Bonds.** Sukuk are Shariah-compliant fixed-income instruments; Green Bonds fund environmental projects. Both behave broadly like bonds for the investor.
- **Exchange-Traded Products (ETPs/ETFs).** A single security that holds a basket of underlying assets, giving diversification in one trade.

> The honest way to describe any instrument is by its **risk-return character**, not by a promised outcome. "Equities can grow more but can also fall" is true; "this share will rise" is not. Every instrument carries risk, and the client is entitled to hear it plainly.

### A worked match

Consider two clients. The first is 63, recently retired, and needs steady income with little tolerance for losing capital. The second is 29, earning well, and wants long-term growth and can ride out volatility. The same menu serves both — differently. The retiree's needs point toward the income-and-stability end: Treasury Bills and investment-grade bonds, perhaps within a specially managed account so the firm runs it to a conservative mandate. The younger client's profile supports a larger equity allocation for long-term growth, perhaps in a self-managed or advisory relationship. Neither is "better"; each is *right for that client*. The error to avoid is steering both toward whatever happens to pay the firm most, or pushing equities on the retiree because the market is rising. Suitability is the discipline of letting the client's profile — not your incentives — choose from the menu.

## Matching instrument to client

Knowing the instruments is half the job; the other half is **suitability** — matching what you offer to the client's needs, risk appetite, and circumstances. A retiree seeking stable income and a young investor seeking long-term growth should not be steered into the same thing. As the conduct rules require, advice and recommendations must be suitable for the specific client, and recommending something unsuitable for personal gain is among the most serious breaches a staff member can commit. The menu exists so you can find the *right* fit — not so you can sell the most lucrative line regardless of fit.

## The firm's own money — and why clients come first

A business developer should be able to answer, accurately, "what does Transworld do with its own money?" The firm keeps this conservative and clearly separate from client activity:

- The firm invests its **own surplus operational funds** prudently — primarily in **Treasury Bills, investment-grade bonds, and placements with tier-1/tier-2 licensed banks** — to earn stable returns and maintain liquidity. It does **not** hold equities in this investment portfolio.
- The firm maintains a **proprietary trading** framework — trading securities for its own account — but treats it cautiously: it is **not currently an active or material part of the firm's business**, it runs under strict Board-approved limits, and any equity position sits in that tightly controlled book, never the investment portfolio.
- Speculative and exotic instruments — **cryptocurrency, derivatives, structured products, short-selling** — are **prohibited for the firm's own account without specific Board approval**.

Above all, one rule is absolute: **client orders always take priority over the firm's proprietary positions.** No proprietary trade may delay, disadvantage, or conflict with a client order. Transworld is, in its own words, **first and foremost a client broker** — proprietary activity is an occasional, controlled supplement, never the main event. A BD person can say this with confidence: the firm's own dealing never competes with the client's.

## Don't oversell

The discipline that ties this module together is restraint. Describe each service and instrument accurately, including its risks. Never guarantee a return — no one honestly can. Never promise access a client's account tier does not allow. And never recommend a product because it pays the firm or you more, rather than because it fits the client. The menu is wide enough to serve almost any client well; the skill is matching honestly, not maximizing a single sale.

## The bottom line

Knowing what you sell — the three service models, the account types, the instruments and their real risk character, and the firm's own conservative, client-first posture — is what lets a business developer have an honest, confident conversation with a prospect. Understand the menu, describe it truthfully, match it to the client, and let the firm's controls do their work. That is how product knowledge becomes trust, and trust is the thing the firm actually sells.

---

*Foundational BD module · Tier B · function-head review on each annual cycle. Built on the Employee Handbook (services), the Operational Manual (account/instrument types), and the Investment & Proprietary Trading Policy (the firm's own posture).*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-102';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_01$id$, m.id, $p$Why must a business developer understand what the firm sells?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is not necessary to understand the products"},{"key":"b","text":"Because you cannot sell honestly what you do not understand — you will eventually mislead or lose a client"},{"key":"c","text":"Only to pass this quiz"},{"key":"d","text":"So you can promise higher returns"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Product knowledge is an honesty requirement: without it you will eventually misrepresent a product or lose a client.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_02$id$, m.id, $p$What are the firm's three client service models? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Self-Managed Accounts"},{"key":"b","text":"Specially Managed Accounts"},{"key":"c","text":"Advisory Services"},{"key":"d","text":"Anonymous Accounts"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$The three models are Self-Managed, Specially Managed, and Advisory.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_03$id$, m.id, $p$In a Self-Managed Account, what is the firm's role?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The firm makes the investment decisions"},{"key":"b","text":"The firm provides the platform, research, and support; the client makes the decisions"},{"key":"c","text":"The firm guarantees returns"},{"key":"d","text":"The account is dormant"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In a self-managed account, the firm provides infrastructure and support while the client directs their own investments.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_04$id$, m.id, $p$In a Specially Managed Account, what is the firm's role?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The client makes all decisions unaided"},{"key":"b","text":"The firm's professionals actively manage the portfolio against agreed goals, risk appetite, and time horizon"},{"key":"c","text":"The firm only files paperwork"},{"key":"d","text":"No management occurs"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In a specially managed account, the firm actively manages the portfolio to agreed objectives with regular reviews.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_05$id$, m.id, $p$Which are valid account types at the firm? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Individual"},{"key":"b","text":"Corporate"},{"key":"c","text":"Estate"},{"key":"d","text":"Joint"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$The four basic account types are Individual, Corporate, Estate, and Joint.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_06$id$, m.id, $p$What are equities (shares), and what is their broad risk character?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Loans to the government; the lowest-risk instrument"},{"key":"b","text":"Part-ownership of a listed company; higher potential return but the price can fall, sometimes sharply"},{"key":"c","text":"A fixed-interest deposit with a bank"},{"key":"d","text":"A guaranteed-return product"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Equities are part-ownership of a company — higher potential return (price gains and dividends) but with real downside risk.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_07$id$, m.id, $p$How would you accurately describe FGN Treasury Bills to a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"High-risk speculative instruments"},{"key":"b","text":"Short-term lending to the Federal Government — government-backed, highly liquid, lower-risk with a modest but predictable return"},{"key":"c","text":"A type of equity"},{"key":"d","text":"A guaranteed way to double your money"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$T-Bills are short-term, government-backed, highly liquid instruments at the lower-risk end of the menu.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_08$id$, m.id, $p$Why do state and corporate bonds typically offer a higher return than FGN bonds?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They are government-guaranteed"},{"key":"b","text":"To compensate for higher credit risk — which is why credit ratings matter"},{"key":"c","text":"They are equities in disguise"},{"key":"d","text":"There is no difference in return"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$State and corporate bonds carry more credit risk than FGN paper, so they pay more; quality varies by issuer, hence credit ratings.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_09$id$, m.id, $p$What is an Exchange-Traded Product (ETP/ETF)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A single security holding a basket of underlying assets, giving diversification in one trade"},{"key":"b","text":"A short-term government loan"},{"key":"c","text":"A private company's unlisted shares"},{"key":"d","text":"A cryptocurrency"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$An ETP/ETF is one security that holds a basket of assets, offering diversification in a single trade.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_10$id$, m.id, $p$What is the honest way to describe any instrument to a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"By a promised outcome ('this will rise')"},{"key":"b","text":"By its risk-return character, including the downside — every instrument carries risk"},{"key":"c","text":"By guaranteeing the best case"},{"key":"d","text":"By comparing it only to its best historical year"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Describe instruments by their risk-return character, plainly including risk — never as a promised outcome.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_11$id$, m.id, $p$A retiree wants steady income and low risk to capital. Which fit is most suitable?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A concentrated equity position for maximum growth"},{"key":"b","text":"Income-and-stability instruments such as Treasury Bills and investment-grade bonds, perhaps in a conservatively managed account"},{"key":"c","text":"Whatever pays the firm the most"},{"key":"d","text":"Cryptocurrency"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A retiree's profile points to stable, lower-risk income instruments — suitability lets the client's profile choose, not the firm's incentives.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_12$id$, m.id, $p$It is acceptable to steer a client into whichever product pays the firm the most, regardless of fit.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Recommendations must be suitable for the client; steering by the firm's incentives rather than the client's needs is a serious breach.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_13$id$, m.id, $p$How does the firm invest its OWN surplus operational funds?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Mostly in equities for maximum growth"},{"key":"b","text":"Conservatively — primarily Treasury Bills, investment-grade bonds, and placements with tier-1/tier-2 licensed banks; it does not hold equities in this portfolio"},{"key":"c","text":"In cryptocurrency"},{"key":"d","text":"In client accounts"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm invests its own surplus conservatively in T-Bills, investment-grade bonds, and bank placements, and does not hold equities in its investment portfolio.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_14$id$, m.id, $p$What is the firm's current stance on proprietary trading (trading for its own account)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is the firm's primary business activity"},{"key":"b","text":"It is cautious and not currently an active or material part of the business; any positions run under strict Board-approved limits"},{"key":"c","text":"It is unlimited and unsupervised"},{"key":"d","text":"It is prohibited entirely with no framework"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Proprietary trading is deliberately cautious, not currently active or material, and bounded by strict Board-approved limits.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_15$id$, m.id, $p$Client orders always take priority over the firm's proprietary positions.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$This is absolute: no proprietary trade may delay, disadvantage, or conflict with a client order. The firm is first and foremost a client broker.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_16$id$, m.id, $p$Which instruments are prohibited for the firm's own account without specific Board approval? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Cryptocurrency / digital assets"},{"key":"b","text":"Derivatives"},{"key":"c","text":"Structured products and short-selling"},{"key":"d","text":"Treasury Bills"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Crypto, derivatives, structured products, and short-selling are prohibited for the firm's own account without Board approval; T-Bills are a permitted, core holding.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_17$id$, m.id, $p$Can you promise a client a return on an investment?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Yes, if you are confident"},{"key":"b","text":"No — no one can honestly guarantee a return; every instrument carries risk"},{"key":"c","text":"Yes, on bonds only"},{"key":"d","text":"Yes, for Tier 3 clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Guaranteeing a return is dishonest; every instrument carries risk and outcomes cannot be promised.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_18$id$, m.id, $p$A client wants a level of access their account tier's documentation does not support. What may you promise?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Promise the access anyway to win the business"},{"key":"b","text":"You may not promise access the account type and tier do not support; the tier shapes what the client can do"},{"key":"c","text":"Promise it and fix the documents later"},{"key":"d","text":"Refer them to a competitor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Account type and tier shape what a client can do; never promise a level of access the client's documentation does not support.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_19$id$, m.id, $p$Which are part of the discipline of 'don't oversell'? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Describe each service and instrument accurately, including risks"},{"key":"b","text":"Never guarantee a return"},{"key":"c","text":"Never promise access a client's tier does not allow"},{"key":"d","text":"Recommend the highest-paying product regardless of fit"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Accurate description, no guarantees, and no over-promised access are the discipline; recommending by pay rather than fit is the opposite.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv102_20$id$, m.id, $p$The firm holds equities as a core part of its own investment portfolio.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm does not hold equities in its investment portfolio; equities are restricted to the tightly controlled proprietary framework.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
