-- ===========================================================================
-- OPS-101 Operations fundamentals & the trade lifecycle: lesson + 20-question check (v0.49.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$A trade is the moment securities change hands — the point at which a client's instruction becomes a binding transaction on the market. But the execution itself is only the visible tip of a long, disciplined process. Behind every clean trade sits a chain of controls: a written mandate, a set of pre-trade checks, a second pair of eyes, an execution, a settlement, a contract note, and a record that survives for years. Operations is the function that holds that chain together. This module walks the trade from the instruction that begins it to the record that closes it, names the officer accountable at each step, and fixes the absolute rules that never bend. The firm's mantra runs through all of it: **the right way is always the best way.**

## What you'll be able to do

1. Describe the full trade lifecycle — from client instruction to settled, recorded transaction — and name the officer accountable at each stage.
2. State the absolute operational controls: no mandate, no trade; cleared funds before a buy; segregation of duties; client priority over proprietary positions.
3. Explain what makes a mandate valid, how long it lasts, and why a phone call alone is never enough.
4. Walk the path of an order through NAYA, the Group Head's review, and execution on the NGX.
5. State the current settlement cycle, the contract-note obligation, and the retention period for trade records.

## What "operations" is — and the control mindset

Operations is the firm's spine: the discipline of turning client instructions into accurate, authorized, fully documented transactions. It is not back-office paperwork to be rushed through. Every control in this module exists because its absence has, somewhere, cost a firm money, a client their assets, or a license its standing. An NGX regulatory inspection of the firm's own files is the reason much of this rulebook is written as firmly as it is. Approach each step as a control, not a formality.

Four rules are **absolute** — they apply to every trade, without exception:

- **No mandate, no trade.** Every trade must be supported by a valid written buy or sell mandate from the client. This is not a guideline; it is the line that separates an authorized transaction from an unauthorized one.
- **No empty-account purchases.** No buy order may be placed on an account without sufficient cleared funds, confirmed by the Accounts Department before the order is placed.
- **Segregation of duties.** The person entering the jobbing instruction and the person executing the trade must not be the same individual. A second pair of hands is a control against error and fraud alike.
- **Client priority.** Proprietary (house) trades are clearly segregated from client orders on every system and record, and **client orders always take priority** over the firm's own positions.

## Where a trade begins: the mandate

Every trade begins with a **mandate** — the written authority from a client to buy or sell. The mandate must specify the **security**, the **quantity**, and the **price instruction** (a limit price, or "market"). The rules on mandates are exact:

- **Written only.** A phone conversation is never, on its own, a valid mandate. Where a client instructs by phone, the Client Relationship Officer must obtain written confirmation before the order is executed.
- **Electronic mandates.** Email instructions are acceptable, but must be backed by a scanned, signed mandate; the CRO collects the original signed copy within **48 hours**.
- **All mandates filed.** Originals, printed soft copies, and emails are all filed. Soft copies are printed and countersigned by the Compliance Officer.
- **Validity is limited.** A mandate is valid for **10 working days**. If it is not executed in that window, the client must expressly reconfirm before re-entry.
- **Processing timeline.** All orders are processed within **48 hours** of receipt.

>! A stale or unsigned mandate is not a minor administrative gap. Executing against an expired mandate, or acting on a verbal instruction without written confirmation, is the kind of finding that turns up in an audit as an *unauthorized trade* — with the firm carrying the liability.

## Pre-trade checks: the gate before execution

Before any order is submitted to the floor, the Operations Officer or Dealer confirms a fixed set of checks — account active and KYC current, a valid signed mandate on file, funds or shares available, the order within the dealer's limit, the jobbing entry approved, and no AML or compliance concern. These are the firm's first line of defense against execution errors and client harm. The seven-point checklist is the subject of its own module, **OPS-102**; here it is enough to know that no order reaches the market until every check is passed and recorded.

## Order entry and execution

Once the pre-trade checks pass, the order is entered as a **jobbing instruction on the NAYA trading platform**, exactly as the client specified — same security, same quantity, same price instruction. No parameter may be changed without explicit, documented client instruction.

The jobbing entry then goes to the **Group Head for review and approval** before it is forwarded to the Authorised Dealer. This approval is **not a formality**: it is a genuine second-eye review that catches obvious errors, confirms the pre-trade checks were done, and sanity-checks the order against current market conditions. Only **CIS-certified personnel** execute trades on the NGX (the sole exception is a client trading for themselves through an authorized e-trading portal). For a **market order**, the Dealer executes promptly at the prevailing price; for a **limit order**, the Dealer holds until the market reaches or improves on the client's limit.

> A fundamental rule of the dealing desk: the Dealer's job is to **serve the client's instruction, not to second-guess it.** If a Dealer has a genuine concern — the order looks inconsistent with the client's profile, say, or the price makes it unusual — that concern is **escalated to the Compliance Officer**. It is never used as a private reason to simply not execute the order.

Orders are handled **promptly and in the sequence received**. The firm does not deliberately delay a client order — not to watch the market, not to favor a house position, not for any reason. Deliberate delay is a serious breach.

## Settlement: completing the transaction

**Settlement** is where the transaction completes: the buyer's account is debited, the seller is credited, and securities move in the CSCS. The settlement cycle is a regulatory and reputational imperative, and it has changed — twice, recently.

>! **Current settlement cycle (verified 6 June 2026): T+1.** The Nigerian market moved from T+3 to **T+2** on 28 November 2025, and then to **T+1 effective 1 June 2026**. A trade now settles **one business day after the trade date** — securities and funds move the next business day. Older internal manuals still print T+2 or T+3 in places; the current cycle is **T+1**.

Around settlement, a few rules matter operationally: payment instructions and settlement cheques are prepared within **48 hours** of the trade date; every settlement cheque is made out **in the client's name** (never to a third party); direct bank transfers require the **Compliance Officer's approval** before the account is settled; and the Accounts Department reconciles its bank statement against the daily trade settlement, cash book, and CSCS statements **daily**, with the Head of Accounts presenting the daily cash position to the CFO. Clients on **CSCS Direct Settlement** receive proceeds straight from CSCS but still receive a contract note. A trade that fails to settle on time is escalated immediately to the Compliance Officer and the Head of Operations.

## The contract note

A **contract note** is the official confirmation of a completed transaction — both a client-service document and a legal record. Every contract note must carry: the client's name and CSCS account number, the security traded, the number of units, the transaction date and NGX deal reference, the execution price per unit, the total transaction value, the brokerage commission, the statutory charges itemized (stamp duty, NGX levy, SEC fee, CSCS charges), the net amount payable or receivable, and the settlement date.

>! **Issuance timing (verified 6 June 2026): same day as execution.** Under the rules accompanying the T+1 transition, brokers issue contract notes on the **same day** the trade is executed — tighter than the older "within 24 hours" wording still found in the Operational Manual. Any error on a contract note is corrected immediately: the original is retained on file and a corrected note reissued with a clear annotation.

## Putting it together: a buy order, end to end

It helps to see the whole chain in one pass. A client wants to buy shares:

1. **Instruction.** The client gives a buy instruction — company name, number of shares, a price limit or "market," and any special conditions (Client / CRO).
2. **Account & funds.** The CRO confirms the account is active and that sufficient cleared funds are available (CRO / Accounts).
3. **Jobbing entry.** The instruction is entered on NAYA and the **Group Head approves** it before it goes to the floor (Operations / Group Head).
4. **Execution.** The Dealer submits the order to the NGX, seeking the best available price (Dealer).
5. **Tracking.** Order status is tracked until fully executed or cancelled (Operations).
6. **Confirmation.** On execution, a trade confirmation goes to the client — shares purchased, price, total cost (Operations / CRO).
7. **Settlement.** Shares are credited to the client's CSCS account on **T+1** (Settlement Officer).
8. **Contract note.** A contract note is generated and dispatched the **same day** (Operations).
9. **Records.** Everything is retained for **at least seven years** (Operations / Compliance).

A sell order mirrors this, with one substitution at step 2: instead of confirming cleared funds, the firm confirms the **shares are held in the client's CSCS account** in the required quantity.

## Records: the chain that proves the trade

A trade you cannot evidence is, for regulatory purposes, a trade you cannot defend. The firm retains — for a minimum of **seven years** — the client mandate, the completed pre-execution checklist, the NAYA jobbing record, the NGX execution record, the contract note, any aggregation/allocation record, and the execution-quality reviews. Executed trades are matched daily to NGX confirmations and CSCS statements, and a signed daily reconciliation is produced. This is the chain that lets the firm — and an auditor, or a regulator, or the client — trace any single trade from the instruction that authorized it to the cash and securities that settled it.

---

*Foundational operations module · Tier B · function-head (Head of Operations) review on each annual cycle. Settlement cycle and contract-note timing are market-rule-dependent — verify currency at each refresh.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'OPS-101';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_01$id$, m.id, $p$In one sentence, what is a 'trade'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The marketing of a security to a prospective client"},{"key":"b","text":"The moment a client's buy or sell instruction becomes a binding transaction and securities change hands"},{"key":"c","text":"The opening of a client account"},{"key":"d","text":"The quarterly reconciliation of client balances"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A trade is the execution of a buy or sell instruction — the point at which ownership of securities changes hands.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_02$id$, m.id, $p$A valid written mandate is required for every trade, without exception.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$No mandate, no trade. This rule is absolute.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_03$id$, m.id, $p$A client phones in a buy instruction. What must happen before the order is executed?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Nothing — a recorded phone call is a valid mandate"},{"key":"b","text":"Written confirmation must be obtained; a phone call alone is never a valid mandate"},{"key":"c","text":"The Dealer executes and documents the call afterward"},{"key":"d","text":"The MD must approve the call verbally"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A phone conversation is never, on its own, a valid mandate. Written confirmation is required before execution.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_04$id$, m.id, $p$For how long is a client mandate valid before it must be expressly reconfirmed?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"24 hours"},{"key":"b","text":"5 working days"},{"key":"c","text":"10 working days"},{"key":"d","text":"30 calendar days"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A mandate is valid for 10 working days; if unexecuted in that window, the client must expressly reconfirm before re-entry.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_05$id$, m.id, $p$An email instruction backed by a scanned signature is acceptable. Within what period must the CRO collect the original signed mandate?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"48 hours"},{"key":"b","text":"7 days"},{"key":"c","text":"On the settlement date"},{"key":"d","text":"It is never required if a scan exists"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Email mandates are acceptable but must be backed by a scanned signed copy, with the original collected within 48 hours.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_06$id$, m.id, $p$Before a buy order is placed, who confirms that sufficient cleared funds are available?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The client"},{"key":"b","text":"The Accounts Department"},{"key":"c","text":"The NGX"},{"key":"d","text":"The CSCS"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No empty-account purchases: cleared funds must be confirmed by the Accounts Department before the order is placed.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_07$id$, m.id, $p$On the NAYA platform, who must approve the jobbing entry before it is forwarded for execution?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The client"},{"key":"b","text":"The Group Head"},{"key":"c","text":"The external auditor"},{"key":"d","text":"No approval is needed once pre-trade checks pass"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The jobbing entry is submitted to the Group Head for a genuine second-eye review and approval before it goes to the Authorised Dealer.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_08$id$, m.id, $p$The Group Head's approval of a jobbing entry is a formality that does not require any real review.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$It is a genuine second-eye review — it checks for obvious errors, confirms pre-trade checks were completed, and tests the order against market conditions.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_09$id$, m.id, $p$A Dealer believes a client's instruction looks inconsistent with the client's profile. What is the correct action?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Quietly decline to execute the order"},{"key":"b","text":"Modify the order to something more suitable"},{"key":"c","text":"Escalate the concern to the Compliance Officer; do not simply refuse to execute"},{"key":"d","text":"Execute immediately and say nothing"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Dealer serves the instruction, not second-guesses it. Genuine concerns are escalated to the Compliance Officer — never used as a private reason not to execute.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_10$id$, m.id, $p$What is the current securities settlement cycle in the Nigerian market (verified June 2026)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"T+3"},{"key":"b","text":"T+2"},{"key":"c","text":"T+1"},{"key":"d","text":"Same day (T+0)"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The market moved T+3 → T+2 (28 Nov 2025) → T+1 effective 1 June 2026. A trade now settles one business day after the trade date.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_11$id$, m.id, $p$Under the current rules, when must a contract note be issued to the client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Within 48 hours of execution"},{"key":"b","text":"On the same day the trade is executed"},{"key":"c","text":"On the settlement date"},{"key":"d","text":"At the end of the quarter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Under the rules accompanying the T+1 transition, contract notes are issued the same day as execution — tighter than the older 'within 24 hours' wording in the manual.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_12$id$, m.id, $p$Which of the following are absolute operational controls that apply to every trade? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"No mandate, no trade"},{"key":"b","text":"No empty-account purchases"},{"key":"c","text":"Segregation of duties between entry and execution"},{"key":"d","text":"Client orders take priority over proprietary positions"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$All four are absolute: a valid mandate, cleared funds before a buy, separation of the person entering from the person executing, and client priority over the house book.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_13$id$, m.id, $p$Who may execute trades on the NGX on the firm's behalf?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Any member of staff"},{"key":"b","text":"Only CIS-certified personnel (the sole exception being a client self-directing via an authorized e-trading portal)"},{"key":"c","text":"Only the MD"},{"key":"d","text":"The Accounts Officer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Trades are executed only by CIS-certified personnel; the one exception is a client trading for themselves via an authorized e-trading portal.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_14$id$, m.id, $p$For a sell order, what replaces the 'cleared funds' check used on a buy order?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Confirming the shares are held in the client's CSCS account in the required quantity"},{"key":"b","text":"Confirming the client's email address"},{"key":"c","text":"Confirming the MD's approval"},{"key":"d","text":"Nothing — sell orders need no pre-check"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$On a sell, the firm confirms the specified shares are held in the client's CSCS account in the required quantity.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_15$id$, m.id, $p$How does the firm treat the sequence in which client orders are executed?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Largest orders first"},{"key":"b","text":"Promptly and in the sequence received; no deliberate delay for any reason"},{"key":"c","text":"Proprietary positions first, then client orders"},{"key":"d","text":"Whenever the market looks most favorable to the firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Orders are executed promptly and in the order received. Deliberate delay — to watch the market or favor a house position — is a serious breach.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_16$id$, m.id, $p$For how long must trade records (mandate, checklist, jobbing record, execution record, contract note) be retained?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"1 year"},{"key":"b","text":"3 years"},{"key":"c","text":"At least 7 years"},{"key":"d","text":"Until the account is closed"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Trade records are retained for a minimum of seven years.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_17$id$, m.id, $p$Which items must appear on a contract note? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Client name and CSCS account number"},{"key":"b","text":"Security, units, execution price and NGX deal reference"},{"key":"c","text":"Brokerage commission and itemized statutory charges"},{"key":"d","text":"The net amount payable or receivable and the settlement date"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$A contract note carries the client/CSCS details, the security and trade specifics, commission and itemized statutory charges, and the net amount plus settlement date.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_18$id$, m.id, $p$Which of these correctly describe settlement-stage controls? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Settlement cheques are made out in the client's name, never to a third party"},{"key":"b","text":"Direct bank transfers require the Compliance Officer's approval before settlement"},{"key":"c","text":"Accounts reconciles bank, trade settlement, cash book and CSCS statements daily"},{"key":"d","text":"Late or failed settlements may be left unreported until quarter-end"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Cheques are in the client's name; direct transfers need Compliance approval; reconciliation is daily. Failed settlements are escalated immediately, not held to quarter-end.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_19$id$, m.id, $p$The person who enters the jobbing instruction and the person who executes the trade may be the same individual, to save time.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Segregation of duties is absolute: the person entering the jobbing instruction and the person executing must not be the same individual.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops101_20$id$, m.id, $p$Which steps come, in order, immediately after a buy order is executed on the NGX? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"A trade confirmation is sent to the client"},{"key":"b","text":"Shares are credited to the client's CSCS account on T+1"},{"key":"c","text":"A contract note is generated and dispatched the same day"},{"key":"d","text":"Records are retained for at least seven years"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$After execution: client confirmation, settlement to CSCS on T+1, same-day contract note, and seven-year retention.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
