-- ===========================================================================
-- INV-101 Capital markets & the NGX: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Transworld exists because of the capital market — it is the arena in which the firm does its work and earns its keep. Yet many people who join a brokerage have only a hazy sense of what "the market" actually is: who runs it, what trades on it, and how a client's order in Lagos becomes a settled holding of shares. This module draws the map. It explains what a capital market is for, what an exchange does, how the **Nigerian Exchange (NGX)** is organized, who regulates it, and exactly where Transworld sits in the picture. You do not need to become a market analyst — but by the end you should be able to explain, to a client or a new colleague, what market we operate in and how it works. The firm's mantra runs underneath: **the right way is always the best way.**

## What you'll be able to do

1. Explain what a capital market is for, and the difference between the primary and secondary markets.
2. Describe what an exchange does and why it matters.
3. Describe how the NGX is structured — the group, the boards, and what trades on it.
4. Name the key institutions of the Nigerian market and what each one does.
5. State exactly where Transworld sits in the market as an SEC-licensed NGX Dealing Member.

## What a capital market is for

A capital market is the system through which **savings are turned into investment**. On one side are people and institutions with money to invest; on the other are companies and governments that need capital to grow, build, and operate. The market connects the two. A company that needs to fund expansion can raise money by issuing **shares** (selling part-ownership) or **bonds** (borrowing on agreed terms); an investor who buys those securities puts their savings to work in the hope of a return. Done well, this is one of the engines of a national economy — it is how a good business with no cash meets the saver with cash and no business to run.

There are two halves to this, and the distinction matters:

- **The primary market** is where securities are *created and first sold* — an Initial Public Offering (IPO), a bond issue, a rights issue. This is the moment capital actually moves from investors to the issuer.
- **The secondary market** is where securities *already issued are traded* between investors. The issuer is not directly involved; ownership simply passes from one investor to another. Most of what happens on an exchange day to day is secondary-market trading.

> Why does the secondary market matter if the issuer already has its money? Because **liquidity** — the ability to sell when you want to — is what makes investors willing to buy in the first place. Few people would buy a share they could never sell. A healthy secondary market is what makes the primary market possible.

A simple example ties the two together. Suppose a Nigerian company lists on the NGX and sells new shares to raise capital for a factory — that sale is the **primary market**, and the cash goes to the company. A year later, an investor who bought those shares decides to sell, and another investor buys them through a broker on the exchange — that trade is the **secondary market**, and the cash passes between the two investors, not to the company. The company raised its capital once; the shares can now change hands many times. Brokers like Transworld operate mainly in that secondary market, executing the buying and selling of already-listed securities for clients.

## What an exchange does

An **exchange** is the organized, regulated marketplace where securities are listed and traded. It does several things at once: it provides a central place for buyers and sellers to meet; it enforces listing standards so investors can trust what they are buying; it drives **price discovery** (the continuous setting of a fair market price through supply and demand); and it creates the transparency and order that let a market function without each party having to trust the other personally. An exchange replaces "do I trust this stranger?" with "do I trust the rules of this market?" — and that is a far easier thing to provide at scale.

## The Nigerian Exchange (NGX)

Transworld trades on the **Nigerian Exchange (NGX)** — historically the Nigerian Stock Exchange, founded in Lagos in 1960–61, the oldest exchange in West Africa. In **2021 it demutualized**, converting from a member-owned, not-for-profit body into a shareholder-owned, profit-making company, **Nigerian Exchange Group Plc (NGX Group)**. The group now operates through three subsidiaries, and the separation is deliberate:

- **Nigerian Exchange Limited (NGX)** — the operating exchange, where securities are listed and traded.
- **NGX Regulation Limited (NGX RegCo)** — the independent regulation company that supervises the market and its participants, kept structurally separate from the commercial exchange.
- **NGX Real Estate Limited (NGX RelCo)** — the group's property arm.

The NGX is a **multi-asset exchange** — it is not only a stock market. It trades **equities** (company shares), **fixed-income securities** (Federal Government of Nigeria bonds and Treasury Bills, state and corporate bonds, plus Sukuk and Green Bonds), **Exchange-Traded Products (ETPs/ETFs)**, and **index futures** (an early derivatives segment). Equity listings are organized into boards by company size and standard: the **Premium Board** (the largest companies, meeting the most stringent governance, capitalization, and liquidity criteria), the **Main Board** (large and mid-cap companies across sectors), the **Growth Board** (smaller, high-growth companies), and the **Alternative Securities Market (ASeM)** for emerging businesses. Trading runs on the exchange's electronic platform, **X-Gen**, with the trading day currently running **9:00 a.m. to 4:00 p.m. (West Africa Time)**, extended in April 2026 from the older shorter session.

>! Currency note (verified June 2026): the Nigerian market now settles on a **T+1** cycle — a trade settles one business day after the trade date — having moved from T+3 to T+2 (Nov 2025) and then to T+1 (June 2026). Older internal manuals still print T+2 or T+3; T+1 is current.

## Indices: reading the market's temperature

An **index** is a single number that summarizes the movement of a basket of securities, so the market's overall direction can be tracked at a glance. The NGX's benchmark is the **All-Share Index (ASI)** — a value-weighted index of listed equities, formulated in **January 1984 with a base value of 100**. When commentators say "the market was up today," they usually mean the ASI rose. The NGX also publishes narrower indices — for example sectoral indices (banking, consumer goods), and size/governance indices (NGX 30, NGX 50, Premium) — that let an investor track a slice of the market rather than the whole. An index is a thermometer, not a thing you can buy directly; but it is the common language in which market performance is discussed.

## The institutions of the market

A working market needs more than an exchange. Four institutions matter most:

- **SEC (Securities and Exchange Commission)** — the **apex regulator** of the Nigerian capital market. It licenses operators (including Transworld), makes the rules, supervises conduct, sets capital requirements, and enforces. Its authority derives from the **Investments and Securities Act 2024**.
- **NGX / NGX RegCo** — the exchange and its independent regulation arm, governing how listing and trading are conducted and supervising dealing members.
- **CSCS (Central Securities Clearing System)** — the market's clearing, settlement, and custody backbone. When a trade settles, the CSCS moves securities between accounts and holds them in electronic (dematerialized) form. A client's shareholding lives in their CSCS account.
- **CBN (Central Bank of Nigeria)** — engaged where banking, foreign exchange, and payments intersect the securities business; with the Debt Management Office, the source of the government instruments traded on the fixed-income market.

These bodies divide the work: the SEC sets and enforces the rules, the NGX runs and polices the trading venue, and the CSCS clears and safeguards what was traded.

## Where Transworld sits

Transworld is a **market intermediary** — specifically, a firm **licensed by the SEC** and a **Dealing Member of the NGX**. That standing is what allows the firm to execute trades on the exchange on behalf of clients; an ordinary investor cannot trade on the NGX directly, so they act through a licensed broker like Transworld. The firm's job is to stand between the client and the market: taking instructions, executing them on the NGX, settling through the CSCS, and keeping the records that prove it was all done properly. Everything in the operations modules — the mandate, the pre-trade checklist, settlement, the contract note — is the machinery by which the firm performs this intermediary role honestly and well.

## Why this matters to you

You may never place a trade yourself. But understanding the market gives meaning to the work: a settlement you process moves real securities through the CSCS; a KYC file you complete is what lets a client enter a regulated market at all; an accurate record is part of how the firm keeps its license to operate on the NGX. Knowing the map turns isolated tasks into a coherent whole — and lets you speak about the firm's world with the confidence a client expects.

---

*Foundational markets module · Tier B · function-head review on each annual cycle. NGX structure and market-rule facts change — verify currency (boards, settlement cycle, trading hours, indices) at each refresh.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-101';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_01$id$, m.id, $p$At its simplest, what does a capital market do?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It prints currency for the government"},{"key":"b","text":"It turns savings into investment by connecting those with money to invest to those who need capital"},{"key":"c","text":"It sets interest rates for banks"},{"key":"d","text":"It collects taxes"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A capital market connects investors with savings to companies and governments that need capital — turning savings into investment.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_02$id$, m.id, $p$What is the difference between the primary and secondary markets?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The primary market is where securities are first created and sold; the secondary market is where already-issued securities are traded between investors"},{"key":"b","text":"The primary market is for bonds and the secondary is for shares"},{"key":"c","text":"They are two names for the same thing"},{"key":"d","text":"The primary market is only for foreign investors"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The primary market is where securities are created and first sold (e.g. an IPO); the secondary market is where existing securities change hands between investors.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_03$id$, m.id, $p$In a primary-market transaction, where does the cash go?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To the issuing company or government raising capital"},{"key":"b","text":"To the broker only"},{"key":"c","text":"To the exchange"},{"key":"d","text":"To another investor"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$In the primary market the cash moves from investors to the issuer (the company or government raising capital).$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_04$id$, m.id, $p$Why does a healthy secondary market matter even though the issuer already has its money?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It does not matter at all"},{"key":"b","text":"Because liquidity — the ability to sell when you want — is what makes investors willing to buy in the first place"},{"key":"c","text":"Because it pays dividends to the exchange"},{"key":"d","text":"Because it sets tax rates"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Liquidity makes the primary market possible: few would buy a security they could never sell.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_05$id$, m.id, $p$What does an exchange do? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Provides a central, regulated place for buyers and sellers to meet"},{"key":"b","text":"Enforces listing standards"},{"key":"c","text":"Drives price discovery through supply and demand"},{"key":"d","text":"Guarantees every investor a profit"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$An exchange provides a regulated marketplace, enforces listing standards, and drives price discovery. It does not guarantee profits.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_06$id$, m.id, $p$What happened to the Nigerian Exchange in 2021?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It closed"},{"key":"b","text":"It demutualized — converting from a member-owned not-for-profit body into a shareholder-owned company, NGX Group Plc"},{"key":"c","text":"It merged with the CBN"},{"key":"d","text":"It moved to Abuja"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In 2021 the exchange demutualized, becoming the shareholder-owned, profit-making Nigerian Exchange Group Plc.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_07$id$, m.id, $p$Which are subsidiaries of NGX Group? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Nigerian Exchange Limited (the operating exchange)"},{"key":"b","text":"NGX Regulation Limited (NGX RegCo)"},{"key":"c","text":"NGX Real Estate Limited (NGX RelCo)"},{"key":"d","text":"The Central Bank of Nigeria"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$NGX Group operates through three subsidiaries: NGX (the exchange), NGX RegCo (independent regulation), and NGX RelCo (real estate). The CBN is a separate body.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_08$id$, m.id, $p$Why is NGX RegCo kept structurally separate from the operating exchange?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"For tax reasons only"},{"key":"b","text":"So that market regulation is independent of the commercial exchange"},{"key":"c","text":"Because it is in a different city"},{"key":"d","text":"It is not separate"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$NGX RegCo is the independent regulation company, deliberately separated from the commercial exchange to keep supervision independent.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_09$id$, m.id, $p$The NGX is a multi-asset exchange. Which of these trade on it? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Equities (company shares)"},{"key":"b","text":"Fixed-income securities (FGN bonds, T-Bills, corporate and state bonds, Sukuk, Green Bonds)"},{"key":"c","text":"Exchange-Traded Products (ETPs/ETFs)"},{"key":"d","text":"Index futures"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$The NGX trades equities, fixed income, ETPs/ETFs, and index futures — it is a multi-asset exchange, not only a stock market.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_10$id$, m.id, $p$Which equity listing board is reserved for the largest companies meeting the most stringent governance, capitalization, and liquidity criteria?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Growth Board"},{"key":"b","text":"The ASeM"},{"key":"c","text":"The Premium Board"},{"key":"d","text":"The Main Board"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Premium Board is the elite category for the largest companies meeting the most stringent standards.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_11$id$, m.id, $p$Which board is intended for smaller, high-growth companies?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Premium Board"},{"key":"b","text":"The Growth Board"},{"key":"c","text":"The fixed-income board"},{"key":"d","text":"There is no such board"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Growth Board serves smaller, high-growth companies; ASeM also serves emerging businesses.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_12$id$, m.id, $p$What is the NGX All-Share Index (ASI)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A tradable security you can buy directly"},{"key":"b","text":"A value-weighted benchmark index of listed equities, formulated in January 1984 with a base value of 100"},{"key":"c","text":"The total number of listed companies"},{"key":"d","text":"A type of bond"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The ASI is the benchmark value-weighted index of listed equities, formulated in January 1984 with a base value of 100 — a measure, not a tradable instrument.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_13$id$, m.id, $p$An index such as the ASI is something an investor can buy directly on the exchange.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An index is a measure of the market's movement — a thermometer — not a security you buy directly.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_14$id$, m.id, $p$Which body is the apex regulator of the Nigerian capital market?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The NGX"},{"key":"b","text":"The CSCS"},{"key":"c","text":"The Securities and Exchange Commission (SEC)"},{"key":"d","text":"The CBN"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The SEC is the apex regulator — it licenses operators, makes the rules, supervises conduct, and enforces, under the ISA 2024.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_15$id$, m.id, $p$What is the role of the CSCS in the market?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It sets monetary policy"},{"key":"b","text":"Clearing, settlement, and custody — it moves securities between accounts and holds them in dematerialized form"},{"key":"c","text":"It licenses brokers"},{"key":"d","text":"It publishes the ASI"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The CSCS is the clearing, settlement, and custody backbone; a client's shareholding is held in their CSCS account.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_16$id$, m.id, $p$What is the current securities settlement cycle on the Nigerian market (verified June 2026)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"T+3"},{"key":"b","text":"T+2"},{"key":"c","text":"T+1"},{"key":"d","text":"T+5"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The market settles on T+1 as of June 2026, having moved T+3 → T+2 (Nov 2025) → T+1 (June 2026).$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_17$id$, m.id, $p$How does Transworld's standing allow it to trade on the NGX?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Any company may trade on the NGX directly"},{"key":"b","text":"It is licensed by the SEC and is a Dealing Member of the NGX, acting as an intermediary for clients who cannot trade directly"},{"key":"c","text":"It owns the NGX"},{"key":"d","text":"It is exempt from regulation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Transworld is SEC-licensed and an NGX Dealing Member; ordinary investors cannot trade on the NGX directly, so they act through a licensed broker.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_18$id$, m.id, $p$An ordinary individual investor can place trades directly on the NGX without going through a licensed broker.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Investors trade through a licensed Dealing Member like Transworld; they cannot access the NGX directly.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_19$id$, m.id, $p$How does the market divide its work among institutions? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"The SEC sets and enforces the rules"},{"key":"b","text":"The NGX runs and polices the trading venue"},{"key":"c","text":"The CSCS clears and safeguards what was traded"},{"key":"d","text":"A single body does all three"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$The work is divided: SEC (rules and enforcement), NGX (the venue), CSCS (clearing and custody) — not one body.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv101_20$id$, m.id, $p$On which electronic platform does NGX trading run, and what are the current trading hours?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"X-Gen, 9:00 a.m. to 4:00 p.m. WAT"},{"key":"b","text":"NAYA, 24 hours"},{"key":"c","text":"CSCS, 9:30 a.m. to 2:30 p.m."},{"key":"d","text":"Bloomberg, 8:00 a.m. to 5:00 p.m."}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$NGX trading runs on the X-Gen platform; the trading day currently runs 9:00 a.m. to 4:00 p.m. WAT, extended in April 2026.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
