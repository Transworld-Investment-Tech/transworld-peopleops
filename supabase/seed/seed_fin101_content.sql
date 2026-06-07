-- seed_fin101_content.sql
-- Transworld PeopleOps Portal -- Batch 4 (v0.51.0) LMS content -- FIN-101
-- Idempotent: module UPDATE by code + questions upsert ON CONFLICT (id). Run in the Supabase SQL Editor.
BEGIN;

UPDATE "learning_modules"
SET body=$body$# Financial accounting fundamentals

Every naira that moves through Transworld leaves a trace. A client funds an account, the firm earns a commission, a vendor is paid, a settlement cheque is released — each of these is a transaction, and each one is recorded. Accounting is simply the discipline of capturing those traces faithfully and turning them into a picture that managers, the Board, regulators, and auditors can trust. You do not need to be an accountant to work here, but you do need to understand the language the firm's numbers are written in. This module teaches that language from the ground up.

> Why this matters to everyone, not just Finance: when you understand how the firm keeps its books, you can read a commission report, follow a discussion about the firm's capital position, and tell the difference between money that belongs to the firm and money that belongs to clients. That literacy protects you, your clients, and the institution.

---

## What accounting is for

Accounting does two jobs. First, it is a **faithful record** — a complete, orderly history of what the firm owns, what it owes, and how it has performed. Second, it is a **language for decisions** — a standard way of summarizing that record so that very different people can reach the same understanding of the same facts. The Chairman, the CFO, an external auditor, and the SEC can all look at the same set of financial statements and read them the same way, because the rules for preparing them are shared and public.

In Nigeria, those shared rules are the International Financial Reporting Standards (IFRS), which the country adopted with effect from 1 January 2012. The Financial Reporting Council of Nigeria (FRC) has the statutory authority to issue and enforce accounting standards, and a regulated dealing member such as Transworld reports under IFRS. Separately, the Companies and Allied Matters Act requires every company to keep proper accounting records that explain its transactions and disclose its financial position with reasonable accuracy. Keeping good books is therefore not optional housekeeping — it is a legal duty and a regulatory expectation.

---

## The accounting equation

The whole of accounting rests on one short statement of balance:

> **Assets = Liabilities + Equity**

An **asset** is something the firm controls that has value — cash in the bank, office equipment, amounts clients owe the firm, the firm's own investments. A **liability** is something the firm owes — a supplier invoice not yet paid, salaries due, tax payable. **Equity** is what is left for the owners after every liability is settled — the owners' original capital plus profits the firm has retained over time.

The equation must always balance, because every naira of asset has a source: it was either provided by someone the firm owes (a liability) or by the owners (equity). If Transworld holds ₦50,000,000 in assets and owes ₦12,000,000 to others, then ₦38,000,000 belongs to the owners. There is no third possibility.

This balance is not a coincidence that bookkeepers chase; it is built into how transactions are recorded.

---

## Double-entry: every transaction has two sides

The reason the equation never breaks is **double-entry bookkeeping**. Every transaction is recorded in at least two places, so that the books stay in balance. One side is called a **debit** and the other a **credit**. The words are just labels for left and right — they do not mean "good" and "bad."

Consider three simple events at a small firm, each in naira:

- The owners put ₦10,000,000 of capital into the business. Cash (an asset) rises by ₦10,000,000; equity rises by ₦10,000,000. The equation still balances.
- The firm buys office computers for ₦2,000,000 cash. One asset (equipment) rises by ₦2,000,000; another asset (cash) falls by ₦2,000,000. Total assets are unchanged.
- The firm earns ₦3,000,000 in advisory fees, received in cash. Cash rises by ₦3,000,000; equity rises by ₦3,000,000 because the firm is now worth more to its owners. That increase in equity is what we call **income**.

In every case, the two sides move together and the equation holds. This is the quiet engine running underneath every accounting system, including the ledgers you will meet in the next module.

Putting those three events together, the firm now holds ₦11,000,000 in cash (₦10,000,000 in, less ₦2,000,000 for computers, plus ₦3,000,000 in fees) and ₦2,000,000 in equipment — ₦13,000,000 of assets in total. It owes nothing to outsiders, so liabilities are zero. Equity is the ₦10,000,000 the owners put in plus the ₦3,000,000 profit earned, which is ₦13,000,000. Assets of ₦13,000,000 equal liabilities of nil plus equity of ₦13,000,000. The picture balances not because anyone forced it to, but because every entry was recorded on both sides.

---

## The five elements

IFRS describes everything in the books using five elements. Three of them sit on the equation above: **assets**, **liabilities**, and **equity**. Two more describe performance over time:

- **Income** — increases in equity from earning revenue (commissions, advisory fees, interest), not from the owners putting in more money.
- **Expenses** — decreases in equity from running the business (salaries, rent, levies, depreciation), not from paying money back to the owners.

Income minus expenses over a period is **profit** (or, if negative, **loss**). Profit increases equity; loss reduces it. This is the bridge between how the firm performed and what the firm is worth.

---

## The financial statements

Accounting summarizes the record into a small set of statements. Four matter:

**1. The statement of financial position** (often called the balance sheet) is a photograph taken on one date. It lists the firm's assets, liabilities, and equity at that moment and shows the accounting equation in full. It answers: *what does the firm own and owe right now?*

**2. The statement of profit or loss** (the income statement) covers a stretch of time — a month, a quarter, a year. It lists income earned and expenses incurred over that period and arrives at profit or loss. It answers: *how did the firm perform?*

**3. The statement of cash flows** tracks the actual movement of cash over the period, grouped into operating, investing, and financing activities. **Operating** activities are the day-to-day running of the business — fees collected, salaries and levies paid. **Investing** activities are the buying and selling of long-term assets, such as the computers in our example. **Financing** activities are dealings with the owners and lenders — capital introduced, loans raised or repaid. It answers: *where did cash come from, and where did it go?* This statement exists because profit and cash are not the same thing — a firm can be profitable on paper and still run short of cash if clients are slow to pay.

**4. The statement of changes in equity** explains how equity moved from the start of the period to the end — profit added, dividends taken out, fresh capital introduced.

> These statements interlock. The profit from the income statement increases retained earnings inside equity on the balance sheet. The closing cash on the cash-flow statement equals the cash figure on the balance sheet. A change in any one ripples through the others. That is why a single transaction recorded incorrectly can distort the whole set.

---

## Accrual versus cash

There are two ways to decide *when* to record income and expenses. The **cash basis** records them only when money actually changes hands. The **accrual basis** records income when it is earned and expenses when they are incurred, regardless of when cash moves. IFRS requires the accrual basis, and for good reason.

Imagine Transworld completes an advisory engagement in December and earns a ₦4,000,000 fee, but the client pays in January. On the cash basis, December would show nothing and January would show ₦4,000,000 — even though all the work was done in December. The accrual basis records the ₦4,000,000 as income in December, when it was earned, and shows the unpaid amount as a **receivable** (an asset) until the client pays. The accrual picture is truer: it matches income to the period in which the firm actually did the work, and it matches expenses to the periods that benefited from them.

This is why understanding accrual matters even outside Finance. A strong month of commission *earned* is not the same as cash *collected*, and reading the two as if they were identical leads to bad decisions.

---

## Why this matters at a securities firm

A dealing member carries an extra layer of discipline. The firm handles **client money** that never belongs to it — funds held to settle trades, amounts owed to clients after a sale. That money is recorded as a liability the moment it arrives, because the firm owes it to the client; it is never treated as the firm's income. For example, if a client deposits ₦5,000,000 to buy shares, the firm's cash rises by ₦5,000,000 and an equal liability — "client funds payable" — is recorded at the same time. The firm is not ₦5,000,000 richer; it is simply holding money it must apply on the client's instruction. Keeping client assets clearly separate from the firm's own assets is both an accounting principle and a regulatory one, and the books are where that separation is proven.

Accounting also frames the firm's most important strategic numbers. The regulatory minimum capital that a broker-dealer must maintain is, at heart, an equity-and-assets question: it asks whether the firm holds enough of its own resources to stand behind its obligations. When leadership discusses the firm's capital position, they are reading the statement of financial position. Understanding the equation lets you follow that conversation instead of being a spectator to it.

---

## Key takeaways

- Accounting is both a faithful record and a shared language; in Nigeria that language is IFRS, adopted from 2012 and overseen by the FRC, and keeping proper books is a legal duty under company law.
- The accounting equation — **Assets = Liabilities + Equity** — always balances, because double-entry records every transaction on two sides.
- Five elements describe the books: assets, liabilities, and equity (what the firm is worth) plus income and expenses (how it performed); income minus expenses is profit, which feeds equity.
- The four statements interlock: the balance sheet is a snapshot, the income statement a period of performance, the cash-flow statement the movement of cash, and the statement of changes in equity the bridge between them.
- The accrual basis records income when earned and expenses when incurred — a truer picture than cash, and the reason "earned" and "collected" must never be confused.
- At a securities firm, client money is a liability, never income, and the firm's capital position is read straight off the statement of financial position.

> Reference: This module teaches general financial-accounting fundamentals consistent with IFRS as adopted in Nigeria (effective 1 January 2012, overseen by the Financial Reporting Council of Nigeria) and the record-keeping duties of the Companies and Allied Matters Act. Authored 6 June 2026.
$body$,
    pass_mark=80,
    estimated_minutes=22,
    status='PUBLISHED',
    updated_at=CURRENT_TIMESTAMP
WHERE code='FIN-101';

-- Fail loud if the module shell is absent (run seed_lms_curriculum.sql first).
DO $guard$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE code='FIN-101') THEN
    RAISE EXCEPTION 'Module FIN-101 not found -- run seed_lms_curriculum.sql first';
  END IF;
END $guard$;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_01$id$, m.id, $p$What is the accounting equation?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Assets = Liabilities + Equity"}, {"key": "b", "text": "Assets = Income - Expenses"}, {"key": "c", "text": "Equity = Assets + Liabilities"}, {"key": "d", "text": "Profit = Assets - Cash"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Assets = Liabilities + Equity; it always balances because every asset has a source.$e$, 1, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_02$id$, m.id, $p$Which best describes an asset?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Something the firm owes to others"}, {"key": "b", "text": "Something the firm controls that has value"}, {"key": "c", "text": "The owners' share after liabilities"}, {"key": "d", "text": "Money paid back to the owners"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An asset is a resource the firm controls that has value, such as cash, equipment, or receivables.$e$, 2, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_03$id$, m.id, $p$Equity represents:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Everything the firm owns"}, {"key": "b", "text": "Amounts owed to suppliers"}, {"key": "c", "text": "What is left for the owners after every liability is settled"}, {"key": "d", "text": "Total income for the period"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Equity is the residual: owners' capital plus retained profit, after all liabilities.$e$, 3, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_04$id$, m.id, $p$In double-entry bookkeeping, every transaction is recorded on at least two sides.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Double-entry records each transaction with a debit and a credit, keeping the equation in balance.$e$, 4, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_05$id$, m.id, $p$In accounting, the terms 'debit' and 'credit' essentially mean:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Good and bad"}, {"key": "b", "text": "Income and expense"}, {"key": "c", "text": "Left and right — labels for the two sides of an entry"}, {"key": "d", "text": "Asset and liability"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Debit and credit are just labels for the two sides of every entry; they do not mean good or bad.$e$, 5, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_06$id$, m.id, $p$Income is best described as:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Any cash received, including new capital from owners"}, {"key": "b", "text": "An increase in equity from earning revenue, not from owner contributions"}, {"key": "c", "text": "A decrease in equity from running the business"}, {"key": "d", "text": "Money owed to the firm by clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Income increases equity through earning revenue; owner contributions are not income.$e$, 6, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_07$id$, m.id, $p$If income exceeds expenses for a period, the resulting profit:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Reduces equity"}, {"key": "b", "text": "Increases equity"}, {"key": "c", "text": "Has no effect on equity"}, {"key": "d", "text": "Is recorded as a liability"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Profit (income minus expenses) increases equity; a loss reduces it.$e$, 7, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_08$id$, m.id, $p$Which statement is a snapshot of the firm's position on a single date?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Statement of profit or loss"}, {"key": "b", "text": "Statement of cash flows"}, {"key": "c", "text": "Statement of financial position (balance sheet)"}, {"key": "d", "text": "Statement of changes in equity"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The statement of financial position is a photograph of assets, liabilities, and equity on one date.$e$, 8, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_09$id$, m.id, $p$Which statement covers a period of time and shows how the firm performed?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The statement of financial position"}, {"key": "b", "text": "The statement of profit or loss (income statement)"}, {"key": "c", "text": "The chart of accounts"}, {"key": "d", "text": "The trial balance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The income statement reports income and expenses over a period to arrive at profit or loss.$e$, 9, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_10$id$, m.id, $p$The statement of cash flows groups cash movements into which three activities?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Income, expenses, and equity"}, {"key": "b", "text": "Operating, investing, and financing"}, {"key": "c", "text": "Assets, liabilities, and equity"}, {"key": "d", "text": "Daily, monthly, and annual"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Cash flows are classified as operating, investing, and financing activities.$e$, 10, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_11$id$, m.id, $p$Under the accrual basis, income is recorded when:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Cash is received"}, {"key": "b", "text": "It is earned, regardless of when cash is received"}, {"key": "c", "text": "The financial year ends"}, {"key": "d", "text": "The owners decide to recognize it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Accrual accounting records income when earned and expenses when incurred, not when cash moves.$e$, 11, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_12$id$, m.id, $p$Transworld earns a ₦4,000,000 advisory fee in December but the client pays in January. Under the accrual basis, the income is recorded in:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "January, when cash is received"}, {"key": "b", "text": "December, when it was earned"}, {"key": "c", "text": "Split equally across both months"}, {"key": "d", "text": "Whenever the auditor confirms it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The fee is earned in December, so it is recorded then; the unpaid amount sits as a receivable until paid.$e$, 12, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_13$id$, m.id, $p$How is client money held by the firm recorded?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "As income of the firm"}, {"key": "b", "text": "As equity belonging to the owners"}, {"key": "c", "text": "As a liability, because the firm owes it to the client"}, {"key": "d", "text": "It is not recorded until the trade settles"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Client money is a liability the moment it arrives; it is never treated as the firm's income.$e$, 13, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_14$id$, m.id, $p$A firm can be profitable on paper yet still run short of cash.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Profit and cash differ; that is why the cash-flow statement exists alongside the income statement.$e$, 14, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_15$id$, m.id, $p$Which THREE elements appear on the statement of financial position?$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Assets"}, {"key": "b", "text": "Liabilities"}, {"key": "c", "text": "Equity"}, {"key": "d", "text": "Income"}, {"key": "e", "text": "Expenses"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Assets, liabilities, and equity sit on the balance sheet; income and expenses describe performance over a period.$e$, 15, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_16$id$, m.id, $p$Select all statements that are true about how the financial statements connect.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Profit from the income statement increases retained earnings within equity"}, {"key": "b", "text": "Closing cash on the cash-flow statement equals the cash figure on the balance sheet"}, {"key": "c", "text": "The balance sheet covers a period of time rather than a single date"}, {"key": "d", "text": "A change in one statement can ripple through the others"}]$o$::jsonb, $c$["a", "b", "d"]$c$::jsonb, $e$The statements interlock; the balance sheet is a single-date snapshot, not a period, so (c) is false.$e$, 16, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_17$id$, m.id, $p$In Nigeria, Transworld prepares its financial statements under:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "US GAAP"}, {"key": "b", "text": "IFRS, adopted from 2012 and overseen by the Financial Reporting Council of Nigeria"}, {"key": "c", "text": "Rules set individually by each firm"}, {"key": "d", "text": "NGX trading rules"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Nigeria adopted IFRS effective 1 January 2012; the FRC has statutory authority over accounting standards.$e$, 17, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_18$id$, m.id, $p$Keeping proper accounting records is a legal duty, not optional housekeeping.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Company law requires proper records that explain transactions and disclose the firm's position.$e$, 18, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_19$id$, m.id, $p$If the firm holds ₦50,000,000 in assets and owes ₦12,000,000 to others, equity is:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "₦62,000,000"}, {"key": "b", "text": "₦12,000,000"}, {"key": "c", "text": "₦38,000,000"}, {"key": "d", "text": "Cannot be determined"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Equity = Assets − Liabilities = ₦50,000,000 − ₦12,000,000 = ₦38,000,000.$e$, 19, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_fin101_20$id$, m.id, $p$Buying office equipment for cash increases the firm's total assets.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$One asset (equipment) rises while another (cash) falls by the same amount, so total assets are unchanged.$e$, 20, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='FIN-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

COMMIT;
