-- =============================================================================
-- seed_fin203_content.sql  (v0.68.0)
-- FIN-203: Treasury & cash management -- lesson + 20-question check (Proficient).
-- Authored FROM POLICY (Tier B). Binding source: Operational Manual v3.0 §7 (Client
--   Deposits), §31.1 (Approval Structure), §31.2 (Payment Controls), §31.3 (Financial
--   Policy: accounting records, daily/weekly/monthly/annual reconciliation, NGN base,
--   FX rate disclosure). Client-money stewardship is the spine.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: FIN-2xx role-targeted via canonical seed_ws7_role_matrix.sql
--   (publish-only; live Head of Finance + reserved finance/CFO profiles). CCO reviews post-publish.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Treasury is the stewardship of money — the firm's own cash, and, far more sensitively, the money that belongs to clients. Of everything the firm does, nothing is watched more closely by the regulator and the public than how it handles client funds, because mishandling client money is the fastest way to destroy trust and lose the licence on which the whole business depends. Client money is held in trust; it is never the firm's to use. This module sets out how Transworld takes in client funds through controlled channels, how payments are authorised and made, how the firm keeps and reconciles its records, and the small number of rules that protect both the client's money and your own good name.

## What you will be able to do

1. Apply the rules for receiving client funds through traceable bank channels only.
2. Walk the deposit process and apply the cheque-clearing and confirmation rules.
3. Apply the payment-voucher controls and read the firm's authorisation matrix.
4. Explain the reconciliation cadence, the naira base, and how foreign-exchange transactions are recorded.
5. Recognise the liquidity discipline that keeps the firm able to meet its obligations.

## Client money comes first

The firm's first treasury rule is about where client funds may flow. All client funds must move through official, traceable bank channels. The firm does not accept direct cash payments to any member of staff, the client relationship officer, or any agent, under any circumstances. Clients deposit into Transworld's designated client bank account with the firm's appointed bankers, or transfer electronically to that account and provide a transfer advice or confirmation to the Accounts Department.

Three further rules protect the money. First, cheques: a receipt is issued immediately on presentation, but the client's internal account is credited only after the cheque clears and value is confirmed. You never credit a client's account against an uncleared cheque. Second, confirmation: the Accounts Department confirms the amount has actually reached the firm's bank account before any receipt is issued or any internal account is credited. Third, third parties: funds may only move to and from the account linked to the client's KYC file; payments to third-party accounts require documented client instruction and Compliance Officer approval. And because clients must be able to see their position, updated in-house client account statements are sent to all active clients quarterly.

## The deposit process

The deposit process is a short, controlled chain. The client deposits cash or transfers electronically to Transworld's designated client bank account. The client then presents the teller slip, deposit receipt, or transfer confirmation to the Accounts Department. The Accounts Officer verifies that the stated amount has actually been credited to the firm's account. Only on confirmation is an official receipt issued to the client. The client's in-house account is then credited — and for cheques, only after clearing — and the credit is recorded both in the client's account on the firm's system and in the cash book. The principle behind every step is the same: no member of staff may collect client funds on behalf of the firm, and any deposit not made to the firm's designated bank account is not a valid deposit and will not be recognised.

## Authorising and making payments

Money leaving the firm is controlled just as tightly as money coming in. No officer may process a payment against a voucher unless the voucher is properly signed, authorised, and approved by all required signatories; all computations have been checked and are correct; and all relevant attachments and supporting documents are in place and certified. A payment that fails any one of these tests is held, not processed.

Behind the voucher sits the firm's authorisation matrix. The Compliance Officer is the first approver for all standard transactions and signs in conjunction with any other required approver. An exception or deferral requires the Compliance Officer plus one approving officer who accepts personal responsibility for regularisation; a waiver requires the Compliance Officer plus two. The Compliance Officer can be overruled only by two Executive Directors acting together or by a formal Board Resolution. High-value transactions above the defined limits in the Authority Matrix require Management or Board sign-off. The matrix exists so that no single person can move the firm's money alone, and so that every approval is owned by someone accountable.

## Records, reconciliation, and the naira base

Good treasury rests on good records. The firm's financial policy requires that all monetary transactions are reflected accurately and completely in the accounting records, and that the firm's accounts are reconciled against all business relationships on a daily, weekly, monthly, and annual basis. Daily reconciliation is the early-warning system: it is how a discrepancy is caught the day it appears, while the trail is fresh, rather than weeks later when it is cold. All accounts are maintained in Nigerian naira. Where a foreign-exchange transaction occurs, the applicable exchange rate must be recorded, and any exchange gain or loss must be separately disclosed — so the firm's naira position is never quietly distorted by currency movements hidden inside another figure.

## Liquidity discipline

Treasury is also about having enough cash in the right place at the right time. The firm must hold sufficient liquid funds to meet its obligations as they fall due, and it must do so without ever dipping into client money to plug a firm-side gap — the segregation between client funds and firm funds is absolute. Liquidity planning, drawn from the budget and the cash position in the management pack, is what keeps the firm solvent and within its capital-adequacy floor between income cycles.

## Why segregation of client money is sacred

It is worth being explicit about why the client-money rules are so unbending. When a client deposits funds with the firm, the money does not become the firm's; it belongs to the client until it is used on the client's instruction. If the firm ever blurred that line — lending itself client money to cover a firm shortfall, or letting client and firm balances mingle so that no one could say whose money was whose — it would be exposing clients to the firm's own risk and breaking the most basic promise a custodian makes. This is why the firm files a quarterly Client Asset Report to the NGX confirming that client assets are segregated and reconciled, and why a clean reconciliation of client balances is not optional. The rule that funds move only to and from the client's KYC-linked account, and never as cash to a staff member, exists to keep an unbroken, auditable line between every naira and the client it belongs to.

## Bank mandates and the designated account

The firm's relationship with its appointed bankers is part of treasury control, not just plumbing. Client funds sit in a designated client bank account, distinct from the firm's own operating accounts, and each account operates under a mandate that names who may authorise what — mirroring the firm's internal authorisation matrix at the bank itself. Keeping the designated client account separate, and keeping the bank mandate aligned with the firm's approval structure, is what makes segregation real rather than merely a line in a policy. When a payment instruction goes to the bank, the bank's mandate is the last line of defence ensuring it carries the approvals the firm requires.

## What a reconciliation actually does

Because reconciliation is mentioned so often, it is worth saying plainly what it is. To reconcile is to compare two independent records of the same money — the firm's cash book against the bank statement, or the firm's record of a client's balance against the supporting documents — and to account for every difference between them. Some differences are timing: a cheque presented but not yet cleared, or a transfer recorded by the firm before the bank shows it. Those are explained and carried. Other differences are genuine breaks that must be investigated and resolved, never simply written off; an unexplained difference parked in a suspense account and forgotten is how small problems become large ones. Doing this daily means a break is caught while its cause is still traceable. Reconciliation, done properly, is the firm continuously proving that its records and the real money agree.

## A worked example (hypothetical)

Imagine a client sends Transworld an electronic transfer in the morning and brings a cheque for a further amount in the afternoon. You handle the transfer correctly: the Accounts Officer confirms the funds have reached the designated client account before issuing the receipt and crediting the in-house account. The cheque you handle differently: you issue a receipt for presentation, but you do not credit the client's account until the cheque clears and value is confirmed, because crediting against an uncleared cheque is exactly the mistake the rule forbids.

Later, a payment voucher reaches you missing one of the required signatures. You hold it — a voucher that is not approved by all required signatories cannot be processed, however routine the payment looks. The next morning, the daily bank reconciliation throws up a small difference between the cash book and the bank statement. Because the reconciliation is daily, the trail is fresh: you trace the difference to the afternoon cheque, which has not yet cleared, confirm the records correctly reflect an uncredited item, and document it. Nothing was lost, because the controls did exactly what they are for — and because client money and firm money were never allowed to touch.

## The firm's own cash

Treasury is mostly about client money, but the firm's own cash deserves the same discipline on a smaller scale. The firm's operating accounts fund its running costs, and the same principles apply: payments leave only against a properly authorised voucher, balances are reconciled on the firm's cadence, and any petty cash is held tightly, supported by receipts, and replenished against evidence rather than topped up loosely. The reason to hold firm cash to a high standard is not only good housekeeping; it is that weak control over the firm's own money is exactly the gap through which an error or a fraud reaches client money next. A firm that is sloppy with its operating float has no credible claim to be rigorous with client funds. Keeping both to the same standard — authorised, reconciled, evidenced — is what makes the segregation between them dependable rather than merely declared.

## Common traps

- **Crediting a client's account against an uncleared cheque.** Issue the receipt, but credit only after the cheque clears and value is confirmed.
- **Accepting cash to a staff member, CRO, or agent.** Client funds flow only through the designated bank account; a hand-to-hand deposit is not a valid deposit.
- **Paying a third-party account without documented instruction and Compliance approval.** Funds move only to and from the KYC-linked account otherwise.
- **Processing a payment against an unsigned or incomplete voucher.** All signatures, correct computations, and certified attachments are required, or the payment is held.
- **One person both approving and paying, or skipping the daily reconciliation.** Segregation and daily reconciliation are the controls that catch errors early.

## Key takeaways

- Client money is held in trust and flows only through the firm's designated bank account — never cash to staff, never against an uncleared cheque, never to a third party without instruction and Compliance approval.
- The deposit process credits the client only after the firm confirms the funds have arrived; quarterly statements keep clients informed.
- No payment is made against a voucher unless it is fully signed, computed, and supported; the authorisation matrix puts the Compliance Officer first and lets no one move money alone.
- Records are reconciled daily, weekly, monthly, and annually; accounts are kept in naira, with FX rates recorded and gains or losses separately disclosed.
- Keep enough liquidity to meet obligations, and never let client funds and firm funds touch.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FIN-203';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_01$id$, m.id, $p$Client funds may be received by the firm...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "as cash handed to the relationship officer"}, {"key": "b", "text": "only through official, traceable bank channels into the designated client account"}, {"key": "c", "text": "into any staff member's personal account"}, {"key": "d", "text": "in any convenient way"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$All client funds flow through traceable bank channels; no direct cash to any staff member, CRO, or agent.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_02$id$, m.id, $p$A client's internal account may be credited for a cheque deposit...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "immediately on presentation"}, {"key": "b", "text": "before the cheque is even received"}, {"key": "c", "text": "only after the cheque clears and value is confirmed"}, {"key": "d", "text": "at the client's request"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A receipt is issued on presentation, but crediting waits until the cheque clears — never credit against an uncleared cheque.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_03$id$, m.id, $p$Before any receipt is issued or any internal account credited, the Accounts Department must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "confirm the amount has actually reached the firm's bank account"}, {"key": "b", "text": "ask the client to sign a waiver"}, {"key": "c", "text": "notify the NGX"}, {"key": "d", "text": "credit first and confirm later"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Confirmation that funds have arrived precedes any receipt or internal credit.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_04$id$, m.id, $p$Payments to a third-party account (not the client's KYC-linked account) require...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "nothing special"}, {"key": "b", "text": "only the client's verbal say-so"}, {"key": "c", "text": "the relationship officer's discretion"}, {"key": "d", "text": "documented client instruction and Compliance Officer approval"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Funds move only to and from the KYC-linked account unless there is documented instruction plus Compliance approval.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_05$id$, m.id, $p$A deposit handed directly to a staff member rather than to the designated bank account is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a valid deposit if witnessed"}, {"key": "b", "text": "not a valid deposit and will not be recognised"}, {"key": "c", "text": "acceptable for small amounts"}, {"key": "d", "text": "recorded as firm income"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No staff member may collect client funds; only deposits to the designated account are valid.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_06$id$, m.id, $p$An officer may process a payment against a voucher only when...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the amount looks routine"}, {"key": "b", "text": "one signatory has approved it"}, {"key": "c", "text": "it is signed and approved by all required signatories, computations are checked, and attachments are certified"}, {"key": "d", "text": "the client is in a hurry"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A payment voucher must pass all three tests — full approval, correct computations, certified support — or it is held.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_07$id$, m.id, $p$In the firm's authorisation matrix, the first approver for standard transactions is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Compliance Officer, signing with any other required approver"}, {"key": "b", "text": "newest analyst"}, {"key": "c", "text": "client"}, {"key": "d", "text": "external auditor"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The Compliance Officer is first approver for standard transactions.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_08$id$, m.id, $p$The Compliance Officer's approval can be overruled only by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any single Executive Director"}, {"key": "b", "text": "the relationship officer"}, {"key": "c", "text": "a majority of staff"}, {"key": "d", "text": "two Executive Directors acting together or a formal Board Resolution"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Override requires two EDs together or a Board Resolution — no single person can simply overrule Compliance.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_09$id$, m.id, $p$The firm's accounts are reconciled against all business relationships on a...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "yearly basis only"}, {"key": "b", "text": "daily, weekly, monthly, and annual basis"}, {"key": "c", "text": "random basis"}, {"key": "d", "text": "never"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Multi-frequency reconciliation, with daily as the early-warning layer, underpins treasury.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_10$id$, m.id, $p$Daily reconciliation is valuable mainly because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "replaces the annual audit"}, {"key": "b", "text": "is required only for client cheques"}, {"key": "c", "text": "catches a discrepancy the day it appears, while the trail is fresh"}, {"key": "d", "text": "lets the firm skip monthly reconciliation"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Catching differences early, while the trail is fresh, is the point of daily reconciliation.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_11$id$, m.id, $p$All of the firm's accounts are maintained in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Nigerian naira, with FX transactions recording the applicable rate"}, {"key": "b", "text": "US dollars"}, {"key": "c", "text": "whatever currency the client prefers"}, {"key": "d", "text": "a mix with no record of rates"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Accounts are kept in naira; FX transactions record the rate and disclose gains or losses separately.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_12$id$, m.id, $p$A foreign-exchange gain or loss must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "hidden inside another figure"}, {"key": "b", "text": "ignored"}, {"key": "c", "text": "treated as client money"}, {"key": "d", "text": "separately disclosed"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$FX gains or losses are disclosed separately so the naira position is not quietly distorted.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_13$id$, m.id, $p$Client money and firm money in treasury management must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "pooled for convenience"}, {"key": "b", "text": "kept absolutely segregated — firm gaps are never plugged with client funds"}, {"key": "c", "text": "used interchangeably"}, {"key": "d", "text": "combined at month-end"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Segregation between client and firm funds is absolute.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_14$id$, m.id, $p$Updated in-house client account statements are sent to active clients...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only on request"}, {"key": "b", "text": "once at account opening"}, {"key": "c", "text": "quarterly"}, {"key": "d", "text": "never"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Active clients receive quarterly statements so they can see their position.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_15$id$, m.id, $p$Liquidity discipline means the firm holds...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sufficient liquid funds to meet obligations as they fall due, without touching client money"}, {"key": "b", "text": "as little cash as possible"}, {"key": "c", "text": "all its cash in foreign currency"}, {"key": "d", "text": "client funds as working capital"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The firm keeps enough liquidity to meet obligations and never uses client money to do so.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_16$id$, m.id, $p$A payment voucher that arrives missing a required signature should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "processed because it looks routine"}, {"key": "b", "text": "processed and corrected later"}, {"key": "c", "text": "signed by whoever is available"}, {"key": "d", "text": "held until properly approved by all required signatories"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$An incomplete voucher is held, not processed, however routine the payment seems.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_17$id$, m.id, $p$High-value transactions above the limits in the Authority Matrix require...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no additional approval"}, {"key": "b", "text": "Management or Board sign-off, as applicable"}, {"key": "c", "text": "only the client's consent"}, {"key": "d", "text": "the relationship officer alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$High-value items escalate to Management or Board per the Authority Matrix.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_18$id$, m.id, $p$In the worked example, the morning electronic transfer and the afternoon cheque are treated differently because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "transfers are riskier than cheques"}, {"key": "b", "text": "cheques are credited instantly"}, {"key": "c", "text": "the cheque is credited only after it clears, while the confirmed transfer can be credited once funds arrive"}, {"key": "d", "text": "both are credited before funds arrive"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The transfer is credited on confirmed arrival; the cheque waits to clear — the core cheque rule.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_19$id$, m.id, $p$The authorisation matrix exists so that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no single person can move the firm's money alone and every approval is owned by someone accountable"}, {"key": "b", "text": "payments are faster with fewer checks"}, {"key": "c", "text": "the Compliance Officer is bypassed"}, {"key": "d", "text": "clients approve firm payments"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The matrix enforces shared, accountable approval and prevents unilateral movement of money.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin203_20$id$, m.id, $p$The unifying principle of the firm's treasury function is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "client and firm money may mix when convenient"}, {"key": "b", "text": "cash may be received by hand"}, {"key": "c", "text": "reconciliation is optional"}, {"key": "d", "text": "client money is held in trust and protected by controlled channels, full authorisation, and disciplined reconciliation"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Stewardship of client money — through controlled channels, full authorisation, segregation, and reconciliation — is the heart of treasury.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'FIN-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: FIN-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FIN-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FIN-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: FIN-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
