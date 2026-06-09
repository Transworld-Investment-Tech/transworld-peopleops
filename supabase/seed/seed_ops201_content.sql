-- =============================================================================
-- seed_ops201_content.sql  (v0.63.0)
-- OPS-201: Trade execution, settlement & the CSCS — lesson + 20-question check (Proficient).
-- Authored FROM POLICY / BUILD+SOURCE off the firm's own manuals (read-first OCR).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps OPS-201 to live job profiles (verified live, query 3 / verify_p4.sql),
--   so publishing alone surfaces it as assigned work. Publish-only (REG pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A client calls in a sell order before the market opens in Lagos. From that instruction, a chain runs: the order is checked, entered for execution on the floor of the Nigerian Exchange, matched, confirmed to the client, and finally settled — shares moving out of one CSCS account and cash moving toward another. Operations is the team that runs that chain end to end, and the firm's reputation rides on every link of it. This module walks the chain from a valid instruction to settled cash and shares, names the controls at each step, and teaches the settlement rules as they stand today.

## What you will be able to do

1. Walk a client order from instruction to settled cash and shares, naming the control at each step.
2. Apply the firm's best-execution duty and recognise when it has been breached.
3. Explain the role of the CSCS and dematerialisation in the settlement chain.
4. Issue a contract note that is complete, correct, and dispatched on time.
5. Recognise a failed or erroneous trade and route it correctly.

## From instruction to the floor

Nothing reaches the market on a verbal say-so. Execution begins only when there is a valid, written client mandate on file and the pre-trade checklist is complete — the account is active, KYC and suitability are in order, and, for a sell, the shares are actually present in the client's CSCS account. The order is then entered as a jobbing entry on NAYA, the firm's trading platform, for execution on the floor of the Exchange. A second person matters here: the Group Head reviews and approves the jobbing entry before it is sent, so that no single person both raises and releases an order. The Jobbing Book is updated before the market opens each day and is the official record of what the desk intends to do. Execution is not the end of the job; it is the middle of it.

The pre-trade checklist is not a formality to rush through. It is the firm's main preventive control over order handling, and it runs to a fixed set of mandate-verification points: that the account is active and onboarding complete, that the instruction matches a valid written mandate, that suitability has been confirmed for the client, that the client has the cash for a purchase or the shares in CSCS for a sale, that there is no compliance flag on the account, and that the order is recorded accurately before release. A failure on any point stops the order — you do not release now and reconcile later, because once an order is on the floor it can be matched in seconds, and a matched trade cannot be un-executed. The discipline of completing the checklist before release is what keeps an avoidable error from becoming an irreversible one.

## Best execution is a duty, not a courtesy

When you execute a client order you owe that client best execution. In practice this means executing promptly — unnecessary delay is itself a breach — and seeking the most favourable terms reasonably available, taking price, cost, speed, and the likelihood of execution and settlement into account. Where an execution departs from the standard approach, you document the rationale; an undocumented departure is indistinguishable from a careless one. Best execution is not a goodwill gesture. It is a regulatory obligation under the NGX Dealing Members' Rules and the SEC's fair-dealing standards, and the client's order always takes priority over any proprietary position the firm might hold. The moment the desk's own book comes before a client's order, the firm has crossed a line that both compliance and internal control will find. This is also why best-execution decisions are sampled monthly: the duty is not satisfied by good intentions on the day but by a record that, reviewed after the fact, shows the client was served first and fairly.

## The CSCS and dematerialisation

Listed shares in Nigeria are held electronically, not as paper certificates, and the Central Securities Clearing System (CSCS) is the depository where those electronic holdings live. Every client trades against a CSCS account opened in their own name; for a sale, the Settlement Officer debits the shares from that account, and for a purchase the shares are credited to it. Where a client still holds physical certificates, those must first be dematerialised — verified with the registrar and converted into electronic form in the CSCS — before they can be traded. Verification and dematerialisation are not paperwork for its own sake: a sell instruction against shares that are not actually in the client's CSCS account, or not yet dematerialised, cannot settle, and discovering that after execution is a failure, not an inconvenience. The same logic applies to corporate actions and registrar records — a holding that looks present on a statement but is encumbered, pledged, or mismatched against the registrar will not settle cleanly, which is why the pre-trade check looks at the actual CSCS position rather than the client's word for it.

## The contract note

A contract note is the official confirmation of every completed transaction. It is at once a client-service document and a legal record, and it must be accurate, complete, and issued on time. Every contract note carries the client's name and CSCS account exactly as registered, the security and quantity, the price, and the itemised statutory charges — stamp duty, the NGX transaction levy, the SEC fee, and CSCS charges, each shown separately rather than rolled into one figure. It also shows the settlement date. Under the Exchange's current T+1 settlement cycle, the contract note is prepared and dispatched the same day the trade executes; the firm's older manual still refers to a 24-hour window and a T+3 settlement date, but those reflect the previous regime and are superseded — teach and apply same-day issuance under T+1. Any error on a contract note is corrected immediately, with the original retained on file and a corrected note issued. Contract notes are legal documents, and failure to dispatch them promptly is a breach of the NGX Dealing Members' Rules; the Head of Operations is accountable for their quality. The itemisation matters because each charge has a different recipient and a different basis — stamp duty and the regulatory fees are statutory, the CSCS charge is the depository's, and a client is entitled to see exactly what they paid and to whom. A contract note that buries these in one figure is not just untidy; it fails the transparency the client and the regulator expect.

## Settlement and the daily reconciliation

Settlement is where the trade becomes real for the client. On the current T+1 cycle, the obligations of the trade fall due the working day after execution rather than three days later as the legacy manual describes. Payment instructions are prepared and routed to authorised signatories on the firm's deadline, every settlement cheque is made out in the client's own name — never to a third party — and where a proxy collects a cheque they must produce a signed letter of authority and valid identification, with the cheque marked for the client's account only. Clients who opt for CSCS Direct Settlement receive their proceeds directly from the CSCS without the funds passing through the firm, and they still receive a contract note. Underneath all of this runs the discipline that catches errors before they become losses: the Accounts function reconciles the bank statement against the daily trade settlement record, the cash book, and the CSCS statements every single day, and the daily cash position goes to the CFO. A reconciliation done daily takes minutes and surfaces a break while it is still small; a reconciliation deferred is how a small difference becomes an unexplained one. When the four records do not tie out, the difference is not written off — it is investigated and escalated to the Head of Accounts the same day, because an unexplained difference between the bank, the trade record, and the CSCS is precisely the early signal that something has gone wrong in the settlement chain.

## When a trade fails or goes wrong

Not every trade runs clean. A trade can fail to settle because the shares were not there, the cash did not arrive, or a detail was wrong; a trade can be executed in error — the wrong client, the wrong stock, the wrong quantity, the wrong side. The firm's Error Trade Policy and Best Execution Policy govern what happens next, and the one rule that matters above all is that an error is never quietly fixed off the books. An erroneous or failed trade is escalated immediately to the Head of Operations and, where there is a market-conduct or compliance dimension, to the Compliance Officer, and every step of the correction leaves a trace. The instinct to make a problem disappear before anyone notices is exactly the instinct that turns a correctable error into a regulatory breach.

## A worked example

**Illustration — a Tuesday sell order (entirely hypothetical).** A client instructs the desk to sell 50,000 units of a listed stock. Before anything else, the CRO confirms the written mandate is on file and the pre-trade checklist passes, including that the 50,000 units are actually in the client's CSCS account. The Operations Officer raises the jobbing entry on NAYA; the Group Head reviews and approves it before it goes to the floor. The order executes on Wednesday's session. Because the firm runs T+1, the contract note is prepared and dispatched the same day, showing the 50,000 units, the price, and the itemised stamp duty, NGX levy, SEC fee, and CSCS charges, with settlement falling on the next working day. The Settlement Officer debits the shares from the client's CSCS account; the client has chosen CSCS Direct Settlement, so the proceeds reach them directly from the CSCS, and the firm still issues the contract note. That evening the Accounts team reconciles the bank statement, the trade settlement record, the cash book, and the CSCS statement, and the position ties out. Nothing dramatic happened — which is exactly what a well-run settlement chain looks like.

## Common traps

- **Acting on a verbal instruction.** No order is raised without a valid written mandate and a complete pre-trade checklist.
- **Assuming T+3 or a next-day contract note.** The current cycle is T+1 and the contract note goes the same day; the manual's T+3 / 24-hour language is superseded.
- **Selling shares not in the CSCS account.** A sell against shares that are absent or not yet dematerialised cannot settle — check before execution, not after.
- **Putting the firm's book before the client.** Client orders always take priority over proprietary positions.
- **Quietly fixing an error trade.** Failed and erroneous trades are escalated and documented; an off-book correction is a breach.

## Key takeaways

- Execution runs on a controlled chain: written mandate and pre-trade checks, a jobbing entry on NAYA, Group Head approval, execution, contract note, and settlement.
- Best execution is a regulatory duty — prompt execution, favourable terms, documented departures — and client orders always come before the firm's own.
- Shares live electronically in the CSCS; physical certificates must be dematerialised before they can be traded, and a sale debits the client's CSCS account.
- The contract note is a legal record with itemised statutory charges, issued the same day under T+1; the Head of Operations owns its quality.
- Settlement is protected by the daily reconciliation of bank, trade, cash book, and CSCS; failed or erroneous trades are escalated and documented, never fixed off the books.

*Reference: the Operational & Procedure Manual v3.0 — order types and the best-execution obligation, the contract-note requirements, jobbing on NAYA, verification and dematerialisation, and the settlement rules — together with the Best Execution Policy and the Error Trade Policy. Settlement is taught on the Exchange's current T+1 cycle with same-day contract notes; the manual's T+3 settlement date and 24-hour contract-note window reflect the previous regime and are logged for correction. This module is a navigation aid; the manuals and the NGX Dealing Members' Rules are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'OPS-201';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_01$id$, m.id, $p$An order may be entered for execution only once...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a senior trader gives a verbal go-ahead"}, {"key": "b", "text": "there is a valid written client mandate on file and the pre-trade checklist is complete"}, {"key": "c", "text": "the client has called twice"}, {"key": "d", "text": "the market has opened"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Execution begins only on a valid written mandate with a complete pre-trade checklist (active account, KYC/suitability, and for a sell the shares present in CSCS).$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_02$id$, m.id, $p$Who approves a jobbing entry before it is sent to the floor?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no one; the Operations Officer releases it"}, {"key": "b", "text": "the Group Head, so one person does not both raise and release the order"}, {"key": "c", "text": "the client"}, {"key": "d", "text": "the external auditor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Group Head reviews and approves the jobbing entry before it goes to the floor — segregation between raising and releasing an order.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_03$id$, m.id, $p$Best execution at the firm means, among other things...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "executing whenever convenient"}, {"key": "b", "text": "executing promptly on the most favourable terms reasonably available, with any departure documented"}, {"key": "c", "text": "always matching the firm's proprietary price"}, {"key": "d", "text": "delaying to find a better price for the firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Best execution requires prompt execution on favourable terms; unnecessary delay is a breach, and any departure from the standard approach is documented.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_04$id$, m.id, $p$When a client order and a proprietary position compete, which takes priority?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the proprietary position"}, {"key": "b", "text": "the client order, always"}, {"key": "c", "text": "whichever is larger"}, {"key": "d", "text": "the Group Head decides case by case"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client orders always take priority over the firm's proprietary positions; reversing that ordering is a conduct breach.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_05$id$, m.id, $p$Where do a client's listed shares actually sit?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "as paper certificates in the firm's safe"}, {"key": "b", "text": "electronically in the client's CSCS account"}, {"key": "c", "text": "in the firm's proprietary account"}, {"key": "d", "text": "with the NGX trading floor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Listed shares are dematerialised and held electronically in the client's CSCS account at the Central Securities Clearing System.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_06$id$, m.id, $p$A client wants to sell shares they still hold as a physical certificate. First, you must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "execute the sale and sort out the certificate later"}, {"key": "b", "text": "dematerialise the certificate — verify with the registrar and convert it to electronic form in CSCS — before trading"}, {"key": "c", "text": "refuse the order outright"}, {"key": "d", "text": "mark the trade as CSCS Direct Settlement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Physical certificates must be verified with the registrar and dematerialised into the CSCS before the shares can be traded and settle.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_07$id$, m.id, $p$Statutory charges on a contract note should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "combined into a single fee line"}, {"key": "b", "text": "itemised separately — stamp duty, NGX transaction levy, SEC fee, and CSCS charges"}, {"key": "c", "text": "omitted to keep the note simple"}, {"key": "d", "text": "estimated and reconciled later"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The contract note itemises stamp duty, the NGX transaction levy, the SEC fee, and CSCS charges separately, alongside the client name and CSCS account, security, quantity, and price.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_08$id$, m.id, $p$Under the current settlement cycle, a contract note is prepared and dispatched...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "within three working days"}, {"key": "b", "text": "the same day the trade executes"}, {"key": "c", "text": "whenever Operations has capacity"}, {"key": "d", "text": "only on client request"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$On the current T+1 cycle the contract note goes the same day. The manual's 24-hour / T+3 language reflects the superseded regime.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_09$id$, m.id, $p$The firm currently settles trades on which cycle?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "T+3"}, {"key": "b", "text": "T+1"}, {"key": "c", "text": "T+0 (same day)"}, {"key": "d", "text": "T+5"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Exchange's current cycle is T+1; the legacy T+3 references in the manual are superseded and logged for correction.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_10$id$, m.id, $p$An error on an issued contract note should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ignored if small"}, {"key": "b", "text": "corrected immediately, with the original retained on file and a corrected note issued"}, {"key": "c", "text": "fixed by overwriting the original"}, {"key": "d", "text": "left for the annual audit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Errors are corrected immediately; the original is retained and a corrected note issued — the audit trail is preserved.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_11$id$, m.id, $p$Every settlement cheque must be made out to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "whoever collects it"}, {"key": "b", "text": "the client's own name; no cheques to third parties"}, {"key": "c", "text": "the introducing broker"}, {"key": "d", "text": "the firm, for onward transfer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Cheques are made out only in the client's name. A proxy collecting one must produce a signed letter of authority and valid ID, with the cheque marked for the client's account only.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_12$id$, m.id, $p$A client on CSCS Direct Settlement...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "receives proceeds directly from CSCS and still receives a contract note"}, {"key": "b", "text": "does not receive a contract note"}, {"key": "c", "text": "must collect a cheque from the firm"}, {"key": "d", "text": "settles on T+3 instead of T+1"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$CSCS Direct Settlement clients receive proceeds directly from the CSCS without funds passing through the firm, and they still receive a contract note.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_13$id$, m.id, $p$How often does the Accounts function reconcile the bank statement against the trade settlement record, cash book, and CSCS statements?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "monthly"}, {"key": "b", "text": "daily, with the cash position reported to the CFO"}, {"key": "c", "text": "only at quarter-end"}, {"key": "d", "text": "when a break is suspected"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The reconciliation is daily, and the daily cash position is reported to the CFO; a daily reconciliation surfaces breaks while they are small.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_14$id$, m.id, $p$Why is the daily reconciliation a control, not just bookkeeping?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it satisfies the external auditor only"}, {"key": "b", "text": "it surfaces settlement breaks while they are still small and explainable"}, {"key": "c", "text": "it replaces the contract note"}, {"key": "d", "text": "it sets the day's prices"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A daily reconciliation catches a break early; a deferred one lets a small difference grow into an unexplained loss.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_15$id$, m.id, $p$A trade was executed for the wrong client. The correct action is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "quietly reverse it before anyone notices"}, {"key": "b", "text": "escalate immediately under the Error Trade Policy and document every step of the correction"}, {"key": "c", "text": "leave it and adjust at year-end"}, {"key": "d", "text": "ask the client to keep it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Erroneous trades are escalated to the Head of Operations (and Compliance where conduct is implicated) under the Error Trade Policy, and corrected on the record — never off the books.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_16$id$, m.id, $p$The Jobbing Book is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an informal trader's notebook"}, {"key": "b", "text": "the official record of the desk's orders, updated before the market opens each day"}, {"key": "c", "text": "the client's personal statement"}, {"key": "d", "text": "the contract-note register"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Jobbing Book (or Sheet) is the official record of orders entered on NAYA and is updated before the market opens each trading day.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_17$id$, m.id, $p$Who is accountable for contract-note quality?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client"}, {"key": "b", "text": "the Head of Operations"}, {"key": "c", "text": "the external registrar"}, {"key": "d", "text": "the dealing clerk alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Head of Operations is responsible for the quality and timely dispatch of contract notes.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_18$id$, m.id, $p$Best execution is grounded in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "internal preference only"}, {"key": "b", "text": "a regulatory obligation under the NGX Dealing Members' Rules and SEC fair-dealing standards"}, {"key": "c", "text": "the client's verbal agreement"}, {"key": "d", "text": "the firm's marketing policy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Best execution is a regulatory requirement under the NGX Dealing Members' Rules and the SEC's fair-dealing standards, not a discretionary courtesy.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_19$id$, m.id, $p$Unnecessary delay in executing a client order is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "acceptable if the market is volatile"}, {"key": "b", "text": "a breach of the best-execution obligation"}, {"key": "c", "text": "always the client's risk"}, {"key": "d", "text": "permitted up to T+3"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Prompt execution is part of best execution; unnecessary delay is itself a breach.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops201_20$id$, m.id, $p$A sell order is raised, but the shares are not yet in the client's CSCS account. The result is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the trade settles normally"}, {"key": "b", "text": "the trade cannot settle — the shortfall must be resolved before execution, not after"}, {"key": "c", "text": "CSCS will create the shares"}, {"key": "d", "text": "settlement simply moves to T+3"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A sale against shares that are absent or not yet dematerialised cannot settle; the pre-trade check exists to catch this before execution.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'OPS-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: OPS-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'OPS-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: OPS-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: OPS-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
