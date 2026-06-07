-- seed_fin102_content.sql
-- Transworld PeopleOps Portal -- Batch 4 (v0.51.0) LMS content -- FIN-102
-- Idempotent: module UPDATE by code + questions upsert ON CONFLICT (id). Run in the Supabase SQL Editor.
BEGIN;

UPDATE "learning_modules"
SET body=$body$# Bookkeeping, ledgers & reconciliation basics

The previous module showed *why* the books always balance. This one is about *how* they are kept day to day — the journals and ledgers that capture every transaction, and the discipline of reconciliation that proves the records are right. Bookkeeping is unglamorous work, but at a regulated dealing member it is foundational: it is how the firm demonstrates that client money is intact, that the firm's own position is accurately stated, and that nothing has been recorded carelessly or concealed. When the firm says "what is not documented did not happen," the books are where that conviction lives.

> You may never post a journal entry yourself. But understanding how the records are built and checked tells you why Accounts asks for a signed voucher before paying, why a correction is annotated rather than erased, and why the daily cash position is taken so seriously.

---

## From transaction to statement: the flow

Bookkeeping moves information along a defined path, and each step has a name:

1. **Source document** — the evidence a transaction happened: an invoice, a contract note, a bank advice, a payment voucher. No entry is made without one.
2. **Journal** — the book of first entry, where each transaction is recorded in date order with its two sides (a debit and a credit) and a reference to the source document.
3. **Ledger** — the set of accounts. Each account (cash, commission income, salaries, client funds payable) gathers all the entries that affect it. Moving an entry from the journal into the relevant ledger accounts is called **posting**.
4. **Trial balance** — a list of every ledger account and its balance, with debits in one column and credits in the other.
5. **Financial statements** — the balance sheet, income statement, and cash-flow statement, assembled from the trial balance.

The path runs in one direction, and every figure in the final statements can be traced back along it to a source document. That traceability is the whole point: an auditor, the CFO, or the regulator can follow any number on a financial statement all the way back to the piece of paper that created it.

---

## The chart of accounts

Before anything can be posted, the firm needs an organized list of the accounts it will use. This is the **chart of accounts** — a structured directory grouped into the familiar categories: assets, liabilities, equity, income, and expenses. A well-designed chart keeps similar things together (all the bank accounts, all the income lines) and gives each account a stable code, so the same transaction is always recorded in the same place. Consistency here is what makes month-to-month comparison meaningful: if commission income is posted to one account in January and a different one in February, the numbers stop telling a coherent story.

---

## The trial balance is a check, not a proof

Because every transaction is recorded with equal debits and credits, the total of all debit balances in the ledger should equal the total of all credit balances. The **trial balance** is where that equality is tested. If the two columns agree, the books are arithmetically consistent.

> Be careful here: a balanced trial balance proves only that the debits and credits are equal in total. It does **not** prove the books are correct. If a whole transaction was missed, or posted to the wrong account, or entered as the right amount on the wrong side and then offset by a second error, the trial balance can still balance while the records are wrong. Catching those deeper errors is the job of reconciliation.

---

## Subsidiary ledgers and client balances

Some accounts are too important and too detailed to leave as a single line. **Client balances** are the clearest example: the firm must know, at any moment, exactly how much it holds for each individual client. So the general ledger carries one summary figure for total client funds, while a **subsidiary ledger** holds the detail — one running balance per client. The two must always agree: the sum of the individual client balances must equal the control total in the general ledger. Keeping that relationship intact is one of the most important things a securities firm's books must do, because it is the proof that no client's money has been lost, mixed up, or quietly borrowed.

---

## Reconciliation: matching the books to reality

A ledger is the firm's own record. Reconciliation is the act of comparing that record against an **independent** record of the same thing — a bank statement, a CSCS statement, a counterparty's confirmation — and explaining every difference until none is left unexplained. It is the single most powerful control in bookkeeping, because it catches the errors a trial balance cannot: omissions, duplicates, postings to the wrong account, and, occasionally, fraud.

Transworld's Operational Manual sets the firm's reconciliation rhythm, and it is demanding by design:

- **Daily.** The Accounts Department reconciles its bank statement against the daily trade settlement record, the cash book, and CSCS statements every day. The Head of Accounts then presents the daily cash position to the CFO each day. This means errors are caught within twenty-four hours, not at month-end when the trail has gone cold. It also means the CFO always knows, with confidence, how much cash the firm truly holds and how much of it is client money that must not be touched — a question that cannot wait for a monthly close.
- **Across all relationships.** The firm's accounts must be reconciled against all business relationships on a daily, weekly, monthly, and annual basis. Reconciliation is not a single event but a layered routine, each layer catching what the others might miss.
- **Client balances, at least quarterly.** A general reconciliation of all client balances must be conducted at least once per quarter, and updated in-house client account statements are sent to all active clients on a quarterly basis. This is the periodic proof that the subsidiary ledger of client balances still ties to reality and to the control total.
- **In naira, with currency discipline.** All accounts are maintained in Nigerian naira. Where a foreign-currency transaction occurs, the applicable exchange rate is recorded and any exchange gain or loss is disclosed separately, so that currency movements never hide inside another figure.

When the firm's record and the independent record do not match, the difference is not ignored — it is investigated and classified. Most differences are **timing differences** (a cheque issued and recorded by the firm but not yet cleared by the bank) and resolve themselves. Others are genuine **errors** in one record or the other, which must be corrected. A small number are **omissions** — a transaction in one record and missing from the other. Every reconciling item must be identified, explained, and cleared.

A short example shows the logic. Suppose the cash book shows a closing balance of ₦8,200,000, while the bank statement shows ₦8,650,000. The difference of ₦450,000 is not a problem to be argued away — it is a question to be answered. On investigation: a ₦500,000 settlement cheque was issued to a client and recorded in the cash book but has not yet cleared the bank (a timing difference), and ₦50,000 of bank charges appear on the statement but were never recorded in the cash book (an omission). Adjust for the uncleared cheque and post the missing charges, and the two records agree. Nothing was hidden; every naira is now explained. That is a completed reconciliation — not when the numbers happen to match, but when every difference has a documented reason.

---

## Controls around the books

Good bookkeeping is protected by controls, not just by careful arithmetic. Two from the Operational Manual deserve emphasis.

First, **payment controls**. No officer may process a payment against a voucher unless the voucher is properly signed, authorized, and approved by all required signatories; all computations have been checked and found correct; and all supporting documents are in place and certified. Money does not leave the firm on a verbal say-so or an unsupported instruction — it leaves only against a complete, authorized, evidenced voucher.

Second, **the discipline of correction**. When an error is found, the original record is retained and a corrected version is issued with a clear annotation showing what was changed and why. The firm applies this everywhere, from contract notes to the portal's audit trail: you add a correction, you never overwrite the original. An erased mistake is a destroyed piece of evidence; an annotated correction is a transparent record of what happened.

> These two habits — pay only against authorized, checked, evidenced vouchers, and correct by annotation rather than erasure — are what separate a trustworthy set of books from a merely tidy one.

---

## The habits that keep books trustworthy

A few principles run through everything above:

- **Record promptly and completely.** A transaction recorded a week late, or left out because it seemed minor, is the seed of a reconciliation that will not balance.
- **Always work from a source document.** If there is no invoice, voucher, advice, or confirmation, there is no entry.
- **Separate duties where you can.** The person who records a transaction should not be the only person who checks it. Independent review is how small firms compensate for small teams.
- **Reconcile on the firm's rhythm, not when convenient.** The daily, weekly, monthly, quarterly, and annual cadence exists so that nothing accumulates unchecked.
- **Never overwrite.** Correct by annotation, retain the original, and leave a clean trail.

These are not bureaucratic preferences. They are how the firm earns and keeps the trust of clients, regulators, and auditors — the practical face of the firm's belief that proper, timely record-keeping is the foundation of institutional trust.

---

## Key takeaways

- Bookkeeping moves each transaction along a fixed path: source document, journal, ledger, trial balance, financial statements — and every final figure can be traced back to the document that created it.
- The chart of accounts gives each transaction a consistent home; consistency is what makes the numbers comparable over time.
- A balanced trial balance proves only arithmetic equality, not correctness — deeper errors are caught by reconciliation.
- Client balances are held in a subsidiary ledger whose total must always equal the general-ledger control figure; that agreement is the proof client money is intact.
- Reconciliation matches the firm's records against independent records and explains every difference; Transworld reconciles daily against the bank, cash book, and CSCS, across all relationships on a daily-to-annual cadence, and reconciles all client balances at least quarterly, in naira.
- Payments move only against fully authorized, checked, and supported vouchers; corrections are made by annotation, never by overwriting.

> Reference: Built on general bookkeeping practice consistent with IFRS as adopted in Nigeria, anchored to the Transworld Operational & Procedure Manual v3.0 — Settlement Rules (daily reconciliation), Issuance Rules (quarterly client-balance reconciliation), and Financial Policy and Payment Controls (§31). Authored 6 June 2026.
$body$,
    pass_mark=80,
    estimated_minutes=22,
    status='PUBLISHED',
    updated_at=CURRENT_TIMESTAMP
WHERE code='FIN-102';

-- Fail loud if the module shell is absent (run seed_lms_curriculum.sql first).
DO $guard$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE code='FIN-102') THEN
    RAISE EXCEPTION 'Module FIN-102 not found -- run seed_lms_curriculum.sql first';
  END IF;
END $guard$;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_01$id$, m.id, $p$What is the correct order of the bookkeeping flow?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Ledger → journal → source document → trial balance → statements"}, {"key": "b", "text": "Source document → journal → ledger → trial balance → financial statements"}, {"key": "c", "text": "Trial balance → ledger → journal → statements → source document"}, {"key": "d", "text": "Journal → source document → statements → ledger → trial balance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each transaction moves from source document to journal, ledger, trial balance, then the financial statements.$e$, 1, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_02$id$, m.id, $p$The journal is best described as:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The set of accounts where balances accumulate"}, {"key": "b", "text": "The book of first entry, recording transactions in date order"}, {"key": "c", "text": "A list of every account and its balance"}, {"key": "d", "text": "The final financial statement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The journal is the book of first entry, recording each transaction in date order with its two sides.$e$, 2, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_03$id$, m.id, $p$'Posting' refers to:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Sending statements to clients"}, {"key": "b", "text": "Moving entries from the journal into the relevant ledger accounts"}, {"key": "c", "text": "Filing source documents"}, {"key": "d", "text": "Preparing the cash-flow statement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Posting is moving each journal entry into the ledger accounts it affects.$e$, 3, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_04$id$, m.id, $p$The chart of accounts is:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "A schedule of client payment dates"}, {"key": "b", "text": "An organized, structured list of the accounts the firm uses"}, {"key": "c", "text": "The firm's bank statement"}, {"key": "d", "text": "A record of staff training"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The chart of accounts is the structured directory of accounts, grouped by asset, liability, equity, income, and expense.$e$, 4, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_05$id$, m.id, $p$A balanced trial balance proves that the books are correct.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$It proves only arithmetic equality of debits and credits; omissions or wrong-account postings can still hide.$e$, 5, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_06$id$, m.id, $p$Individual client balances are held in a subsidiary ledger whose total must:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Exceed the general-ledger control figure"}, {"key": "b", "text": "Equal the general-ledger control figure"}, {"key": "c", "text": "Be reconciled only at year-end"}, {"key": "d", "text": "Be kept separately from the general ledger and never compared"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The sum of individual client balances must equal the general-ledger control total — the proof client money is intact.$e$, 6, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_07$id$, m.id, $p$Reconciliation means:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Adding up all the debits in the ledger"}, {"key": "b", "text": "Comparing the firm's record against an independent record and explaining every difference"}, {"key": "c", "text": "Preparing the income statement"}, {"key": "d", "text": "Approving a payment voucher"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Reconciliation matches the firm's record to an independent one and resolves every difference.$e$, 7, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_08$id$, m.id, $p$Per the Operational Manual, the Accounts Department reconciles the bank statement against the daily trade settlement, cash book, and CSCS statements:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Monthly"}, {"key": "b", "text": "Quarterly"}, {"key": "c", "text": "Daily"}, {"key": "d", "text": "Annually"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$This reconciliation is performed daily, so errors are caught within twenty-four hours.$e$, 8, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_09$id$, m.id, $p$The Head of Accounts presents the daily cash position to:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The CFO, every day"}, {"key": "b", "text": "The Board, once a quarter"}, {"key": "c", "text": "The client, on request"}, {"key": "d", "text": "The NGX"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The Head of Accounts presents the daily cash position to the CFO each day.$e$, 9, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_10$id$, m.id, $p$A general reconciliation of all client balances must be conducted at least:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Once per year"}, {"key": "b", "text": "Once per quarter"}, {"key": "c", "text": "Once per month"}, {"key": "d", "text": "Only when a client complains"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Operational Manual requires a general reconciliation of all client balances at least once per quarter.$e$, 10, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_11$id$, m.id, $p$In what currency are the firm's accounts maintained?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "US dollars"}, {"key": "b", "text": "Nigerian naira (NGN), with any FX gain or loss disclosed separately"}, {"key": "c", "text": "Whatever currency the client uses"}, {"key": "d", "text": "A blended basket of currencies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Accounts are maintained in naira; foreign-currency transactions record the rate and disclose gain or loss separately.$e$, 11, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_12$id$, m.id, $p$A cheque the firm has issued and recorded, but which the bank has not yet cleared, is an example of a:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Timing difference"}, {"key": "b", "text": "Fraudulent entry"}, {"key": "c", "text": "Permanent error"}, {"key": "d", "text": "Tax liability"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$It is a timing difference: recorded by the firm but not yet reflected by the bank; it resolves when the cheque clears.$e$, 12, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_13$id$, m.id, $p$Select all of the following that are types of reconciling item.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Timing differences"}, {"key": "b", "text": "Errors in one of the records"}, {"key": "c", "text": "Omissions"}, {"key": "d", "text": "Profit"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Differences are classified as timing differences, errors, or omissions; profit is not a reconciling item.$e$, 13, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_14$id$, m.id, $p$Per the firm's payment controls, an officer may process a payment against a voucher only if:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "A manager gives a verbal instruction"}, {"key": "b", "text": "It is properly signed, authorized, and approved, computations are checked, and supporting documents are certified"}, {"key": "c", "text": "The amount is below ₦100,000"}, {"key": "d", "text": "It is the end of the month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Money leaves only against a complete, authorized, checked, and evidenced voucher.$e$, 14, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_15$id$, m.id, $p$When an error is found in the records, the original entry should be erased and replaced.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The original is retained and a corrected version is issued with a clear annotation — you never overwrite.$e$, 15, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_16$id$, m.id, $p$The principle 'what is not documented did not happen' reflects which firm value?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Legacy Over Profit"}, {"key": "b", "text": "Documentation Is Trust"}, {"key": "c", "text": "Empowerment Over Control"}, {"key": "d", "text": "Live Long, Not Live Fast"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Documentation Is Trust holds that proper, timely record-keeping is the foundation of institutional trust.$e$, 16, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_17$id$, m.id, $p$Select all of the following that are sound bookkeeping habits.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Record transactions promptly and completely"}, {"key": "b", "text": "Always work from a source document"}, {"key": "c", "text": "Reconcile on the firm's set cadence"}, {"key": "d", "text": "Overwrite errors so the books look clean"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Prompt recording, working from source documents, and reconciling on cadence are sound; overwriting destroys evidence.$e$, 17, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_18$id$, m.id, $p$The firm reconciles its accounts against all business relationships on which cadence?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Only annually"}, {"key": "b", "text": "Daily, weekly, monthly, and annually"}, {"key": "c", "text": "Only when the auditor visits"}, {"key": "d", "text": "Every two years"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Reconciliation against all business relationships is a layered routine: daily, weekly, monthly, and annual.$e$, 18, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_19$id$, m.id, $p$No bookkeeping entry should be made without a source document.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Every entry must be supported by a source document such as an invoice, voucher, advice, or confirmation.$e$, 19, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin102_20$id$, m.id, $p$A reconciliation is considered complete when:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The two balances happen to be equal by chance"}, {"key": "b", "text": "Every difference between the records has a documented explanation"}, {"key": "c", "text": "The trial balance balances"}, {"key": "d", "text": "The month has ended"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A reconciliation is complete only when every difference is identified, explained, and cleared.$e$, 20, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-102'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

COMMIT;
