-- ===========================================================================
-- INV-102 Market data & basic analysis: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Markets speak in numbers. A share price ticks up; volume spikes; an index closes higher; a company's earnings come in ahead of expectations. To work confidently around the market — and to talk to clients without bluffing — you need to read these numbers and know roughly what they mean. This module is a plain-language introduction to **market data** (the everyday figures the market produces) and **basic analysis** (the two broad ways investors try to make sense of them). It is not a course in stock-picking, and it does not turn you into an analyst or licensed adviser. Its aim is literacy: to let you understand a market report, read a price quote, and follow a conversation about a stock without getting lost. The firm's mantra applies even to numbers: **the right way is always the best way** — which here means never overstating what the data can tell you.

## What you'll be able to do

1. Read the core pieces of market data: price, volume, bid/ask, open/high/low/close, and market capitalization.
2. Interpret common market-report terms: gainers and losers, market breadth, turnover, and an index move.
3. Explain, in plain terms, the difference between fundamental and technical analysis.
4. Recognize a few basic valuation measures — P/E, EPS, and dividend yield — and what they roughly indicate.
5. State the honesty rule: data informs judgment; it does not predict the future, and you must not stray beyond your competence or registration.

## The core market data

Every traded security throws off a stream of numbers. The essentials:

- **Price** — the last price at which the security traded. It is a fact about the past second, not a promise about the next.
- **Bid and ask** — the **bid** is the highest price a buyer is currently willing to pay; the **ask** (or offer) is the lowest price a seller is willing to accept. The gap between them is the **spread**. A trade happens when a buyer and seller meet in the middle.
- **Volume** — the number of units (shares) traded over a period. High volume signals strong interest; a big price move on thin volume is less meaningful than the same move on heavy volume.
- **Open, High, Low, Close (OHLC)** — the first price of the session, the highest and lowest reached, and the last. Together they summarize a day's trading in four numbers.
- **Market capitalization** — the total market value of a company's shares: share price multiplied by the number of shares in issue. It is the market's running estimate of what the whole company is worth, and it is how companies are sorted into "large-cap," "mid-cap," and "small-cap."

> A useful habit: never read a single number in isolation. A price means little without volume; a day's close means little without the trend around it; a company's size means little without its sector. Context is most of interpretation.

### Worked example: reading one quote

Suppose a stock shows: last price ₦24.50, bid ₦24.45, ask ₦24.55, volume 1.2 million, open ₦24.00, high ₦24.80, low ₦23.90. Read it like this. The shares last changed hands at ₦24.50, and right now a buyer will pay ₦24.45 while a seller wants ₦24.55 — a ten-kobo spread, so a trade would settle somewhere between. The stock opened at ₦24.00 and is up on the day, having ranged between ₦23.90 and ₦24.80. And 1.2 million shares have traded, which tells you the move came on real activity rather than a single small trade. None of this tells you what the stock will do next — but you can now describe, accurately, what it has done. That is the whole skill: state what the numbers say, and nothing more.

## Reading a market report

A typical end-of-day NGX report is a digest of the data above. A few terms recur:

- **The index move** — usually the All-Share Index (ASI), reported as points and a percentage. "The ASI rose 0.33%" is a one-line summary of the whole equity market's direction that day.
- **Gainers and losers** — the securities that rose and fell most, often capped by a daily price-movement limit. These tell you where the day's action was.
- **Market breadth** — how many securities advanced versus declined. Breadth tells you whether a move was broad (most stocks up) or narrow (a few heavyweights carrying the index). A rising index with negative breadth is a weaker signal than it first appears.
- **Volume and value (turnover)** — total units traded and the naira value of that trading. Turnover shows how much money actually changed hands — the market's activity level for the day.
- **Deals** — the number of individual transactions, another gauge of activity.

Put together, a report answers three questions: which way did the market go, how broadly, and how actively.

## Where the data comes from

The same figures reach you through several channels, and it is worth knowing which to trust. The **authoritative source** for NGX prices, the ASI, and official daily statistics is the exchange itself (and the data vendors it licenses); the firm's own trading and back-office systems carry the data relevant to client accounts and executed trades; and the financial press and market-data websites repackage the official numbers for a general audience. For anything that matters — a client's holding, a contract-note price, a settlement figure — rely on the firm's systems and official exchange data, not a secondhand headline. Secondhand sources are fine for a sense of the day; they are not evidence.

## Two ways to analyze a security

Investors who try to judge whether a security is worth buying generally use one or both of two broad approaches. You do not need to practice either at an expert level — but you should know the difference.

**Fundamental analysis** asks: *what is this company actually worth, and is the price fair?* It looks at the business itself — revenue, profit, debt, growth, the quality of management, the health of the sector and the wider economy — and forms a view of intrinsic value, then compares that to the market price. A fundamental investor buys when they believe a security is worth more than its price.

**Technical analysis** asks a different question: *what is the price doing, and what might it do next?* It largely ignores the underlying business and studies the price and volume history — trends, patterns, support and resistance levels — on the theory that price behavior tends to repeat. A technical trader is reading the chart, not the balance sheet.

> Neither approach is magic, and serious investors often combine them. The honest framing for a client is that analysis improves the *quality of a decision* — it does not remove risk or foresee the future. Anyone who promises certainty is either mistaken or misleading.

## A few basic measures

A handful of ratios come up constantly. In plain terms:

- **Earnings per share (EPS)** — a company's profit divided by its number of shares. It tells you how much profit the company earned for each share you own.
- **Price-to-earnings (P/E) ratio** — the share price divided by EPS. Roughly, it tells you how many years of current earnings you are paying for. A high P/E can mean the market expects strong growth — or that the share is expensive; a low P/E can mean a bargain — or a troubled company. The ratio raises a question; it does not answer it.
- **Dividend yield** — the annual dividend per share divided by the share price, as a percentage. It tells you the income return a share pays at its current price, before any capital gain or loss.

These are starting points, not verdicts. A ratio is only meaningful next to a peer, a sector average, or the same company's history.

## The honesty rule

Reading data well comes with a duty to represent it honestly. Three lines you do not cross. First, **data describes the past and present; it does not predict the future** — a stock that rose for ten days is not "due" to rise on the eleventh. Second, **do not give investment advice or specific recommendations unless you hold the role and registration to do so** — at Transworld, public market commentary and personal recommendations require the appropriate authorization, and a casual "you should buy this" from someone not licensed to give it is both a conduct breach and a risk to the client. Third, **never present a possibility as a certainty** — "this could rise if conditions hold" is honest; "this will double" is not. The market literacy this module builds is meant to make you *more* careful with numbers, not more confident than the evidence allows.

## Bringing it together

Market data is the raw language of the firm's world; basic analysis is two grammars for making sense of it. Knowing what a price, a volume, a P/E, or an index move means lets you read a report, follow a client conversation, and understand the activity flowing through the firm — without ever overstating what the numbers can do. Curiosity about the market is an asset; humility about prediction is a discipline. Hold both.

---

*Foundational markets module · Tier B · function-head review on each annual cycle. Built to house style as general market literacy; not investment advice. Specific recommendations require the appropriate role and registration.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-102';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_01$id$, m.id, $p$What does the 'bid' price represent?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The lowest price a seller will accept"},{"key":"b","text":"The highest price a buyer is currently willing to pay"},{"key":"c","text":"The last traded price"},{"key":"d","text":"The opening price"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The bid is the highest price a buyer is currently willing to pay; the ask is the lowest a seller will accept.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_02$id$, m.id, $p$The gap between the bid and the ask is called the:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Spread"},{"key":"b","text":"Yield"},{"key":"c","text":"Turnover"},{"key":"d","text":"Index"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The difference between the bid and the ask is the spread.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_03$id$, m.id, $p$Why is a large price move on heavy volume more meaningful than the same move on thin volume?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Volume has no bearing on meaning"},{"key":"b","text":"Heavy volume signals the move came on real, broad activity rather than a single small trade"},{"key":"c","text":"Thin volume always means the price is wrong"},{"key":"d","text":"High volume guarantees the price will keep rising"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Volume gauges interest; a move on heavy volume reflects real activity, while a move on thin volume is a weaker signal. It guarantees nothing about the future.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_04$id$, m.id, $p$What does 'OHLC' summarize?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Owner, holder, lender, custodian"},{"key":"b","text":"The open, high, low, and close prices of a session"},{"key":"c","text":"Order, hold, limit, cancel"},{"key":"d","text":"Only the closing price"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$OHLC is the open, high, low, and close — four numbers summarizing a session's trading.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_05$id$, m.id, $p$How is a company's market capitalization calculated?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Share price multiplied by the number of shares in issue"},{"key":"b","text":"Total revenue minus expenses"},{"key":"c","text":"The dividend divided by the price"},{"key":"d","text":"The number of shares traded today"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Market cap is share price times the number of shares in issue — the market's running estimate of the whole company's value.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_06$id$, m.id, $p$In a market report, what does 'market breadth' tell you?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The naira value of all trades"},{"key":"b","text":"How many securities advanced versus declined — whether a move was broad or narrow"},{"key":"c","text":"The widest spread of the day"},{"key":"d","text":"The number of listed companies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Breadth compares advancers to decliners; a rising index with negative breadth is a weaker signal than it first appears.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_07$id$, m.id, $p$What does 'turnover' (value traded) in a market report measure?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The number of listed companies"},{"key":"b","text":"The naira value of trading — how much money actually changed hands"},{"key":"c","text":"The index level"},{"key":"d","text":"The dividend paid"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Turnover is the naira value of the day's trading — the market's activity level in money terms.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_08$id$, m.id, $p$Fundamental analysis primarily asks:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"What is the price doing, and what might it do next?"},{"key":"b","text":"What is this company actually worth, and is the price fair?"},{"key":"c","text":"How many shares traded today?"},{"key":"d","text":"Which broker is cheapest?"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Fundamental analysis studies the business — revenue, profit, debt, growth — to estimate intrinsic value versus the market price.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_09$id$, m.id, $p$Technical analysis primarily:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Studies the business's financial statements"},{"key":"b","text":"Studies price and volume history — trends and patterns — largely setting aside the underlying business"},{"key":"c","text":"Relies only on dividend yield"},{"key":"d","text":"Is the same as fundamental analysis"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Technical analysis reads the chart — price and volume history, trends, patterns — rather than the balance sheet.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_10$id$, m.id, $p$Fundamental and technical analysis are mutually exclusive; a serious investor must choose only one.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Serious investors often combine the two approaches; they are not mutually exclusive.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_11$id$, m.id, $p$What does Earnings Per Share (EPS) tell you?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The dividend a share pays"},{"key":"b","text":"A company's profit divided by its number of shares — profit earned per share"},{"key":"c","text":"The share price"},{"key":"d","text":"The number of shares traded"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$EPS is profit divided by the number of shares — how much profit the company earned for each share.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_12$id$, m.id, $p$The price-to-earnings (P/E) ratio is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The share price divided by EPS — roughly how many years of current earnings you are paying for"},{"key":"b","text":"The dividend divided by the price"},{"key":"c","text":"Revenue minus costs"},{"key":"d","text":"Volume divided by price"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$P/E is share price divided by EPS; a high P/E can signal growth expectations or an expensive share — it raises a question rather than answering it.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_13$id$, m.id, $p$Dividend yield is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The annual dividend per share divided by the share price, as a percentage"},{"key":"b","text":"The total profit of the company"},{"key":"c","text":"The number of dividends paid this year"},{"key":"d","text":"The same as the P/E ratio"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Dividend yield is the annual dividend per share divided by the share price — the income return at the current price.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_14$id$, m.id, $p$A single financial ratio, on its own, gives a clear verdict on whether a stock is a good buy.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A ratio is only meaningful next to a peer, a sector average, or the company's own history; it raises a question rather than delivering a verdict.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_15$id$, m.id, $p$A stock has risen for ten consecutive days. What is the honest reading?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is 'due' to rise again on day eleven"},{"key":"b","text":"Past movement describes what has happened; it does not predict what will happen next"},{"key":"c","text":"It is certain to fall on day eleven"},{"key":"d","text":"It must be a fundamentally strong company"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Data describes the past and present; it does not predict the future. A run of gains implies nothing certain about the next day.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_16$id$, m.id, $p$Which statements honor the honesty rule when discussing data? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"'This could rise if current conditions hold' (framed as a possibility)"},{"key":"b","text":"'This will definitely double' (stated as certainty)"},{"key":"c","text":"Declining to give a specific recommendation when you are not registered to do so"},{"key":"d","text":"Describing accurately what the numbers show"}]$o$::jsonb, $c$["a","c","d"]$c$::jsonb, $e$Honest practice frames possibilities as possibilities, avoids unregistered recommendations, and describes data accurately. Stating certainty is not honest.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_17$id$, m.id, $p$At Transworld, who may make specific investment recommendations or public market commentary?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Anyone who has read this module"},{"key":"b","text":"Only those who hold the appropriate role and registration, with the required authorization"},{"key":"c","text":"Any staff member, informally"},{"key":"d","text":"No one, ever"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Specific recommendations and public commentary require the appropriate role, registration, and authorization — a casual 'you should buy this' from someone unlicensed is a conduct breach and a risk to the client.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_18$id$, m.id, $p$Why should you never read a single market number in isolation?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Because numbers are unreliable"},{"key":"b","text":"Because context — volume behind a price, the trend around a close, the sector behind a company's size — is most of interpretation"},{"key":"c","text":"Because the exchange forbids it"},{"key":"d","text":"There is no reason; single numbers are sufficient"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A price needs its volume, a close needs its trend, a size needs its sector. Context is most of interpretation.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_19$id$, m.id, $p$Which of these are core pieces of market data? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Price and volume"},{"key":"b","text":"Bid and ask"},{"key":"c","text":"Open, high, low, close"},{"key":"d","text":"Market capitalization"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$Price, volume, bid/ask, OHLC, and market capitalization are all core market data.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv102_20$id$, m.id, $p$A good end-of-day market report answers which questions? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Which way did the market go (the index move)?"},{"key":"b","text":"How broadly (market breadth)?"},{"key":"c","text":"How actively (volume, turnover, deals)?"},{"key":"d","text":"Which stock is guaranteed to rise tomorrow?"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$A report tells you direction, breadth, and activity. No report can guarantee tomorrow's movement.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
