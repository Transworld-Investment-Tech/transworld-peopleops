-- ===========================================================================
-- OPS-102 The seven-point mandate verification checklist: lesson + 20-question check (v0.49.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Most execution errors are not exotic. They are ordinary failures of verification: a trade placed on an account with no cleared funds, a sell order against shares the client does not hold, an order entered against a mandate that expired last week. The pre-trade checklist exists to catch every one of these before the order reaches the market. It is the firm's **first line of defense** against execution errors and client harm — seven checks, every one of which must be confirmed before any order is submitted to the floor. OPS-101 placed this checklist inside the trade lifecycle; this module takes each of the seven points in turn, tells you exactly what to verify, and tells you what to do when a check fails. The firm's mantra applies with full force here: **the right way is always the best way.**

## What you'll be able to do

1. Recite the seven pre-trade checks from memory and apply them to a live order.
2. State, for each check, precisely what must be verified.
3. State, for each check, what you must do when it fails — and who is notified.
4. Distinguish the funding check on a buy order from the securities check on a sell order.
5. Treat the completed checklist as filed evidence, not a disposable formality.

## Why a checklist, and why seven

A checklist is not a sign of distrust or a lack of skill. In every field where mistakes are costly and irreversible — aviation, surgery, and securities dealing among them — the most experienced professionals work to a checklist precisely *because* they are experienced. Expertise makes a person fast and confident, and speed and confidence are exactly the conditions under which a routine step gets skipped. The checklist removes the routine step from memory and from mood, and makes it a fixed, visible act that either happened or did not.

The seven points are not arbitrary. Each one corresponds to a way a trade can go wrong: an inactive or under-documented account (point 1), an unauthorized order (point 2), a purchase the client cannot pay for (point 3), a sale of shares the client does not hold (point 4), a trade beyond the Dealer's authority (point 5), an unreviewed order going to the floor (point 6), and a transaction that should have been stopped on compliance grounds (point 7). An NGX inspection of brokerage files is part of why these controls are written as firmly as they are — files were found with missing documents and trades that could not be tied cleanly to instructions. The checklist is the firm's answer: every order, every time, all seven.

## The seven points

Before any order is submitted to the floor, the Operations Officer or Dealer must confirm **all seven** of the following. Memorize them in order:

1. The client's account is **active** and **KYC is current**.
2. A **valid, signed mandate** is on file **for this specific order**.
3. For **buy** orders: **sufficient cleared funds** have been confirmed by the Accounts Department.
4. For **sell** orders: the specified **shares are held in the client's CSCS account** in the required quantity.
5. The order is **within the approved dealing limit** for the executing Dealer.
6. The **jobbing entry has been entered on NAYA and approved by the Group Head**.
7. The transaction raises **no AML or regulatory compliance concern**.

Each of these is now taken in turn.

## Point 1 — Account active, KYC current

**Verify:** the client's account is active — not dormant, suspended, or restricted — and the KYC file is current, with no expired documents and no compliance holds.

**If it fails:** the order is **halted**. The Compliance Officer is notified, and the client is told the reason for the delay. An order is never forced through on an account whose KYC has lapsed; an expired ID or a missing document means the client no longer meets the documentation standard their tier requires, and trading is suspended until it is put right.

## Point 2 — A valid, signed mandate for this specific order

**Verify:** a valid, signed mandate exists **for this order** — specifying the security, the quantity, and the price instruction — and is within its 10-working-day validity window.

**If it fails:** **no trade may be executed.** The CRO must obtain the mandate before the order proceeds. A mandate for a different order, a mandate that has expired, or a verbal instruction with no written backing is not a valid mandate. This is the operational expression of the absolute rule: **no mandate, no trade.**

>! Watch for the subtle failure: a signed mandate is on file, but it is for a different security or a different quantity than the order in front of you. A mandate authorizes *one* order. It is not a standing license to trade the account.

## Point 3 — Buy orders: cleared funds confirmed

**Verify:** for a buy order, sufficient **cleared funds** are available in the client's account, confirmed by the **Accounts Department**.

**If it fails:** the order is **halted** and the client is contacted. No order may be placed on an empty account or against uncleared funds. "Cleared" matters: a payment that has been promised, or a cheque that has not yet cleared, is not cleared funds.

## Point 4 — Sell orders: shares held in CSCS

**Verify:** for a sell order, the specified **shares are held in the client's CSCS account** in the **required quantity**.

**If it fails:** the order is **halted** and the client is contacted. Selling shares a client does not hold in the required quantity is not an administrative slip — it exposes the firm to a failed settlement and the client to a transaction that cannot complete. Points 3 and 4 are the two sides of the same coin: confirm the *funds* on a buy, confirm the *securities* on a sell.

## Point 5 — Within the Dealer's approved limit

**Verify:** the order falls **within the approved dealing limit** for the Dealer who will execute it. The firm operates an authority matrix that sets the trade size each Dealer may execute without further approval.

**If it fails:** the order requires **additional sign-off** before placement — in practice, MD approval for a trade exceeding the Dealer's limit. The system flags out-of-limit instructions automatically, and an out-of-limit trade placed without approval is escalated immediately to the Compliance Officer.

## Point 6 — Jobbing entry approved by the Group Head

**Verify:** the order has been entered as a **jobbing instruction on NAYA** and **approved by the Group Head** before it is forwarded for execution.

**If it fails:** the order does not go to the floor. The Group Head's review is a genuine second pair of eyes — it confirms the order is entered exactly as instructed, that the earlier checks were completed, and that the order makes sense in current market conditions. An order that has not cleared this review is not ready to execute.

## Point 7 — No AML or regulatory concern

**Verify:** the transaction raises **no AML, CFT, or regulatory compliance concern** — nothing about the order, the account, or the pattern of activity that should give a reasonable officer pause.

**If it fails:** the concern is reported to the **Compliance Officer only**. Crucially, you must **not alert the client**, and you must not discuss the matter with colleagues outside the compliance process. Tipping off a client that their transaction has raised a concern is itself a serious offense. The Compliance Officer decides how to proceed.

## Worked example: a buy and a sell, side by side

Suppose a client wants to **buy 10,000 units** of a listed equity at market. You run the seven points: the account is active and KYC current (1); a signed mandate for *this* security and quantity, dated yesterday, is on file (2); Accounts confirms cleared funds sufficient for the purchase and charges (3); points 4 does not apply to a buy, so you move on; the order is inside your dealing limit (5); you enter the jobbing instruction on NAYA and the Group Head approves it (6); nothing about the account or order raises a compliance concern (7). All seven confirmed — the order goes to the floor.

Now suppose a different client wants to **sell 5,000 units**. The checklist is the same, with one substitution. Points 1, 2, 5, 6 and 7 are run identically. But at the funding stage you do **not** check cleared funds — you check that **5,000 units are actually held in the client's CSCS account** (point 4). If only 3,000 are held, the check **fails**: the order is halted and the client is contacted before anything is submitted. The discipline is identical; only the funding-versus-securities test differs between a buy and a sell.

## The checklist is evidence

Passing the seven checks is not enough on its own — the firm must be able to **prove** they were passed. The completed pre-execution checklist is filed with the trade record and retained for at least seven years. When an auditor or regulator examines a trade, the checklist is the document that shows the controls operated. Two supporting disciplines reinforce it: **segregation of duties**, so the person entering the jobbing instruction is not the person who executes it; and the principle that a Dealer with a concern **escalates** rather than quietly declining or modifying an order. Run the seven points on every order, record that you did, and the single most common source of execution error closes off.

---

*Foundational operations module · Tier B · function-head (Head of Operations) review on each annual cycle. The seven-point checklist is the canonical pre-trade gate; confirm against the Operational Manual at each refresh.*$body$,
    pass_mark = 80,
    estimated_minutes = 25,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'OPS-102';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_01$id$, m.id, $p$How many pre-trade checks must be confirmed before any order is submitted to the floor?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Three"},{"key":"b","text":"Five"},{"key":"c","text":"Seven"},{"key":"d","text":"As many as the Dealer judges necessary"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$There are seven pre-trade checks, and all seven must be confirmed before any order goes to the floor.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_02$id$, m.id, $p$Which of the following are among the seven pre-trade checks? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Account active and KYC current"},{"key":"b","text":"A valid signed mandate for this specific order"},{"key":"c","text":"The order is within the Dealer's approved limit"},{"key":"d","text":"The transaction raises no AML or regulatory concern"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$All four are among the seven points, alongside funds-on-buy, shares-on-sell, and Group Head approval of the NAYA jobbing entry.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_03$id$, m.id, $p$Point 1 requires you to confirm the account is active and that KYC is current. If the client's KYC has lapsed, you should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Execute the order and ask the client to renew KYC later"},{"key":"b","text":"Halt the order, notify the Compliance Officer, and tell the client the reason for the delay"},{"key":"c","text":"Reduce the order size to compensate"},{"key":"d","text":"Refer the order to the MD for override"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A lapsed KYC means the order is halted; the Compliance Officer is notified and the client is told why.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_04$id$, m.id, $p$A signed mandate is on file, but it specifies a different security than the order in front of you. Is point 2 satisfied?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Yes — any signed mandate on the account is sufficient"},{"key":"b","text":"No — a mandate authorizes one order; it is not a standing license to trade the account"},{"key":"c","text":"Yes, provided the quantity matches"},{"key":"d","text":"Only if the client is a Tier 3 client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Point 2 requires a valid signed mandate for this specific order. A mandate for a different security does not authorize this trade.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_05$id$, m.id, $p$On a BUY order, what does point 3 require you to confirm, and who confirms it?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Sufficient cleared funds, confirmed by the Accounts Department"},{"key":"b","text":"Shares held in CSCS, confirmed by the client"},{"key":"c","text":"The Dealer's limit, confirmed by the MD"},{"key":"d","text":"The KYC tier, confirmed by the NGX"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$On a buy, point 3 requires sufficient cleared funds, confirmed by the Accounts Department, before placement.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_06$id$, m.id, $p$On a SELL order, what replaces the cleared-funds check?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Confirming the shares are held in the client's CSCS account in the required quantity"},{"key":"b","text":"Confirming the client's email address"},{"key":"c","text":"Confirming the contract note has been issued"},{"key":"d","text":"Nothing — sells skip the funding check entirely"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$On a sell, you confirm the specified shares are held in the client's CSCS account in the required quantity (point 4).$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_07$id$, m.id, $p$A purchase may be placed on an account against funds that have not yet cleared, as long as payment has been promised.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No order may be placed against uncleared funds. A promise to pay, or an uncleared cheque, is not cleared funds.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_08$id$, m.id, $p$An order exceeds the executing Dealer's approved dealing limit. What does point 5 require?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Dealer proceeds, since limits are advisory"},{"key":"b","text":"Additional sign-off (in practice, MD approval) before placement"},{"key":"c","text":"The order is cancelled permanently"},{"key":"d","text":"The client must lower the order"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Out-of-limit trades require additional sign-off (MD approval) before placement; the system flags them, and an out-of-limit trade placed without approval is escalated to Compliance.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_09$id$, m.id, $p$Point 6 requires that the jobbing entry has been entered on NAYA and approved by whom?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The client"},{"key":"b","text":"The Group Head"},{"key":"c","text":"The Accounts Officer"},{"key":"d","text":"The external auditor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Point 6 requires the NAYA jobbing entry to be approved by the Group Head — a genuine second-eye review — before the order is forwarded for execution.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_10$id$, m.id, $p$Point 7 concerns AML and regulatory concerns. If a transaction raises a concern, you must:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Tell the client so they can explain"},{"key":"b","text":"Report it to the Compliance Officer only, without alerting the client"},{"key":"c","text":"Discuss it openly with colleagues to get a second opinion"},{"key":"d","text":"Execute the trade and note it in the blotter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A concern is reported to the Compliance Officer only. Alerting the client — tipping off — is a serious offense.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_11$id$, m.id, $p$Tipping off a client that their transaction has raised a compliance concern is acceptable if done politely.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Tipping off is never acceptable. Concerns go to the Compliance Officer only; the client is not alerted.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_12$id$, m.id, $p$Why does the firm require a pre-trade checklist even from experienced dealers?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Because experience makes routine steps more likely to be skipped under speed and confidence"},{"key":"b","text":"Because regulators require dealers to be inexperienced"},{"key":"c","text":"Because the checklist replaces the need for a mandate"},{"key":"d","text":"Because it speeds up execution"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$In high-stakes fields, the most experienced professionals use checklists precisely because speed and confidence are when a routine step gets skipped.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_13$id$, m.id, $p$When a pre-trade check FAILS, which responses are correct depending on the check? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Halt the order"},{"key":"b","text":"Notify the Compliance Officer where the failure is a KYC or compliance concern"},{"key":"c","text":"Contact the client where funds or shares are insufficient"},{"key":"d","text":"Quietly proceed if you are confident the issue is minor"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$A failed check halts the order; depending on the point, the Compliance Officer is notified and/or the client is contacted. Quietly proceeding is never correct.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_14$id$, m.id, $p$What is the relationship between points 3 and 4?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They are the funding check for a buy and the securities check for a sell — two sides of the same coin"},{"key":"b","text":"They are identical and only one needs to be run"},{"key":"c","text":"Point 4 applies only to corporate clients"},{"key":"d","text":"Both apply to every order regardless of direction"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Point 3 (cleared funds) applies on a buy; point 4 (shares in CSCS) applies on a sell. Confirm the funds on a buy, the securities on a sell.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_15$id$, m.id, $p$After all seven checks pass, what must the firm be able to do later?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Nothing further — passing the checks is the end of the obligation"},{"key":"b","text":"Prove the checks were passed, via the completed checklist filed with the trade record"},{"key":"c","text":"Delete the checklist to save storage"},{"key":"d","text":"Re-run the checks every quarter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The completed pre-execution checklist is filed as evidence and retained, so the firm can prove the controls operated when a trade is examined.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_16$id$, m.id, $p$Which disciplines reinforce the pre-trade checklist? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Segregation of duties between entry and execution"},{"key":"b","text":"Escalating concerns rather than quietly declining or modifying an order"},{"key":"c","text":"Retaining the completed checklist as filed evidence"},{"key":"d","text":"Allowing one officer to both enter and execute to save time"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Segregation of duties, escalation over quiet refusal, and retaining the checklist all reinforce the checks. Combining entry and execution in one person defeats segregation.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_17$id$, m.id, $p$If a sell order is for 5,000 units but only 3,000 are held in the client's CSCS account, the order should be halted.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Point 4 fails: the required quantity is not held. The order is halted and the client is contacted before anything is submitted.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_18$id$, m.id, $p$What is the correct description of the checklist's role?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A disposable formality completed after execution"},{"key":"b","text":"The firm's first line of defense against execution errors and client harm"},{"key":"c","text":"A document only required for Tier 3 clients"},{"key":"d","text":"An optional aid for new staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The pre-trade checklist is the firm's first line of defense against execution errors and client harm — run on every order.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_19$id$, m.id, $p$Each of the seven points guards against a specific failure. Which pairings are correct? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Point 2 guards against an unauthorized order"},{"key":"b","text":"Point 3 guards against a purchase the client cannot pay for"},{"key":"c","text":"Point 6 guards against an unreviewed order reaching the floor"},{"key":"d","text":"Point 7 guards against a transaction that should have been stopped on compliance grounds"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$Each point maps to a concrete failure mode: authorization, funding, supervisory review, and compliance, among the seven.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops102_20$id$, m.id, $p$A Dealer is confident an order is fine and is in a hurry. What does the checklist require?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Skip the checks this once, given the Dealer's confidence"},{"key":"b","text":"Run all seven checks anyway — every order, every time"},{"key":"c","text":"Run only the checks that seem relevant"},{"key":"d","text":"Ask the client which checks to run"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The rule is every order, every time, all seven. Confidence and speed are exactly the conditions under which a step is wrongly skipped.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
