-- =============================================================================
-- seed_fin201_content.sql  (v0.68.0)
-- FIN-201: Management & statutory reporting -- lesson + 20-question check (Proficient).
-- Authored BUILD+SOURCE (Tier B). Binding sources: Compliance Manual v3.0 §11 / §11.1
--   (the Regulatory Reporting Calendar + returns table), Operational Manual v3.0 §29
--   (budget variance feeds), §31.3 (accounting records + reconciliation). Management-
--   accounting concept localised to the firm. Current law: ISA 2025 (source 'ISA 2024'
--   logged DF-10; no source edited). ESR v1.1. CCO reviews post-publish.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: FIN-2xx are role-targeted via the canonical seed_ws7_role_matrix.sql
--   (already maps FIN-201..204 to the live Head of Finance + reserved finance/accounting/
--   CFO profiles -- publish-only, the REG/OPS/CLA/INV pattern). Confirm live: verify_fin_matrix_live.sql / verify_p8.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Reporting is how the firm tells the truth about itself, in numbers, to the people who need it. There are two audiences, and you must never confuse them. The first is internal — management and the Board, who need timely figures to steer the firm: are we making money, are we within budget, is our capital adequate, where is the risk building. The second is external — the regulators, who require the firm to file specific returns, in a specific form, by a specific date, as a condition of keeping its dealing licence. A firm can be operationally sound and still fail here, simply by filing late or filing wrong. This module shows you how the firm produces both families of report — management reporting to decide, and statutory and regulatory reporting to comply — and how the two are built from the same disciplined accounting records.

## What you will be able to do

1. Distinguish management reporting from statutory and regulatory reporting, and explain who each is for.
2. Describe the monthly management pack and how it is built from reconciled accounting records.
3. Read the firm's Regulatory Reporting Calendar — the major returns, their recipients, frequencies, and responsible officers.
4. Apply the escalation rule when a return is at risk, and the role of the Regulatory Reporting Log.
5. Explain why capital adequacy reporting matters and why a late filing is itself a breach.

## Two families of reporting

Management reports are written for decisions. They are produced on the firm's own rhythm — monthly is the working standard — and they answer management's questions: how did revenue compare with budget, what is the cash position, is the firm within its regulatory capital floor, what is trending the wrong way. Nobody outside the firm sees them, which means their value is entirely in whether they are accurate, timely, and honest about bad news.

Statutory and regulatory reports are written for compliance. They are not optional and not on your rhythm — the recipient sets the form and the deadline, and the firm files whether or not the news is good. Statutory reporting is what the law and the firm's incorporation require: the annual audited financial statements prepared under IFRS and signed off by the external auditor, the company's filings, and the tax returns covered in the firm's tax module. Regulatory reporting is what the firm's market regulators require because it is a licensed dealing member — the returns to the NGX, the SEC, and, on the financial-crime side, the NFIU.

The discipline that makes all of this possible sits in the accounting records. The firm's financial policy is plain: every monetary transaction must be reflected accurately and completely in the records, and the accounts must be reconciled against every business relationship on a daily, weekly, monthly, and annual basis. Reconciliation is not housekeeping you do when there is time — it is the foundation that lets you report. If the books are not reconciled, every report built on them is suspect. Garbage in, garbage filed.

## The monthly management pack

The management pack is the firm's monthly self-portrait. At its core is the profit-and-loss compared against budget: actual brokerage commissions, advisory fees, and other income set beside what the budget projected, with the variances explained. The firm's budget process requires exactly this — actual income and expenditure compared against budget monthly and quarterly, with a written variance report explaining significant deviations and recommending corrective action. Management reporting is where that variance report lives.

Alongside the profit-and-loss sits the cash and liquidity position, a view of receivables and payables, and the capital-adequacy snapshot — a running check that the firm's regulatory capital remains above the required floor, because the firm is obliged to operate within its means and within capital-adequacy requirements at all times. A good pack does not merely present numbers; it flags the one or two things management must act on this month.

## The Regulatory Reporting Calendar

The firm runs its regulatory filing off a single instrument: the Regulatory Reporting Calendar, maintained by the Compliance Officer, refreshed at the start of each year and reviewed every month. Every reporting obligation under every applicable rule is logged on it, with the responsible officer, the due date, and the data inputs needed from other departments identified well in advance. The Compliance Officer sends preparation reminders to responsible officers at least two weeks before each deadline, so that the data is gathered before the clock runs out rather than after.

The major returns the firm files include the Monthly Activity Report to the NGX, owned by the Head of Operations, covering total trades, securities, values, and client counts. The Capital Adequacy or Net Capital Return goes to the SEC and NGX, monthly or quarterly, owned jointly by the CFO and the Compliance Officer, reporting capital, liabilities, and the regulatory capital ratio. The AML/CFT Compliance Return is quarterly to the SEC. The PEP Monthly Return goes to the SEC and NFIU. Currency Transaction Reports and Suspicious Transaction Reports go to the NFIU as qualifying transactions and suspicions arise. The Annual AML/CFT Report and the Annual Policy and Governance Returns go to the SEC. The Annual Audited Financial Statements go to the SEC and NGX, owned by the CFO with the external auditor. The Client Asset Report — segregated client assets and the reconciliation confirmation — goes to the NGX quarterly, owned by the Head of Operations and CFO. The Complaints Report goes to the NGX and SEC as required.

You do not need to memorise every line, but you must understand the shape: many recipients, many frequencies, many owners, one calendar that holds them together. The statutory backdrop to all of it is the Investments and Securities Act 2025, which frames the firm's obligations as a capital-market operator.

## When a return is at risk

Sometimes a filing will be in danger of slipping — a data input is late, a system is down, the number is contested. The rule is firm: any return that cannot be filed on time must be escalated to the Managing Director no less than five business days before the deadline, so that a decision can be made about whether to seek a regulatory extension. Filing for an extension is always better than filing late without notice. And every filing is recorded in the Regulatory Reporting Log — date filed, filing officer, and any issues encountered — so the firm can prove its record to a regulator on demand.

## Management accounts and audited accounts are not the same thing

It is worth being precise about two terms that are often blurred. Management accounts are the internal figures the firm prepares for itself, monthly, quickly, to steer the business — they trade a little precision for timeliness, and no outside party audits them. The audited financial statements are the formal, year-end accounts prepared under International Financial Reporting Standards, examined and signed by the external auditor, and filed with the regulators. They trade speed for rigour and assurance. The two should reconcile to one another — the year's management figures should land close to the audited result — but they serve different purposes and answer to different standards. A common error is to treat a monthly management number as if it carried the authority of an audited figure, or to wait for audited certainty before giving management the timely view it needs to act. Both numbers are legitimate; each is fit for its own purpose.

## Reading the brokerage revenue

For a dealing firm, the single most important line management watches is brokerage commission, because it is the firm's lifeblood and it moves with the market. A useful management pack does not just show the total — it breaks the commission down enough to tell a story: how much came from which desk or relationship, whether a handful of active clients are carrying the month, and how the value of trades compares with the same month last year. Read alongside the NGX activity that drives it, the commission analysis tells management whether a soft month is the whole market being quiet or the firm losing share, which are very different problems with very different responses. Advisory fees are reported beside commission as the steadier, mandate-driven stream. The discipline is to present the revenue so that management can see not only what happened but why, because the why is what they can act on.

## What the capital-adequacy snapshot is really saying

The capital-adequacy or net-capital figure deserves more than a glance, because it is the number that protects the licence. As a regulated dealing member, the firm must hold regulatory capital above a defined floor at all times; the Net Capital Return is how the firm evidences that to the SEC and NGX, and the monthly management snapshot is the firm's own early warning that it is not drifting toward the floor. If planned spending, a drawdown, or a run of weak months would erode capital toward the minimum, management must see it in time to act — to defer spend, to hold distributions, or to raise capital. Reporting capital adequacy is therefore not a box-ticking return; it is the firm watching the one constraint it cannot breach and stay in business.

## A worked example (hypothetical)

Imagine it is the first week of the month at Transworld and you are closing the prior month. You assemble the management pack: the profit-and-loss shows commission income eight percent below budget. You do not bury it — you write the variance note, attributing the shortfall to a quiet two weeks on the NGX and recommending no corrective spend, since the budget already anticipated market softness. You prepare the inputs the Head of Operations needs for the NGX Monthly Activity Report and the figures the CFO needs for the Net Capital Return, and you confirm the books were reconciled at month-end before any of these numbers left the building.

Mid-week, the Compliance Officer notices that the data feed for one quarterly return is stuck behind a vendor delay and the filing is now at risk. Because the deadline is seven business days away, there is still time: the Compliance Officer escalates to the Managing Director with five clear business days to spare, the firm decides to request a short extension, and the whole sequence — the risk, the escalation, the decision — is captured in the Regulatory Reporting Log. Nothing was filed late, and the firm can show exactly how it handled the risk.

## Reporting is a shared responsibility

One last point ties the module together: reporting is not the Compliance Officer's burden alone, even though the Compliance Officer owns the calendar. Each return draws data inputs from across the firm — the Head of Operations supplies trading and client-asset figures, the CFO supplies the financial and capital numbers, and the Accounts function supplies the reconciled records everything rests on. When one person is late with an input, the whole return is at risk, which is why the calendar identifies the responsible officer and the data needed from each department well in advance. Treat a request for your numbers as a deadline in its own right; the firm's clean filing record is built from many people delivering their part on time.

## Common traps

- **Treating a late regulatory filing as a small thing.** A missed deadline is itself a compliance breach, even when the underlying numbers are perfectly correct. Persistent lateness tells a regulator that compliance is not embedded in the firm's culture.
- **Confusing management and statutory deadlines.** The management pack runs on the firm's rhythm; regulatory returns run on the regulator's. Do not let an internal close slip a statutory filing.
- **Reporting off unreconciled books.** If the daily, weekly, and monthly reconciliations have not been done, the report is unreliable before you start.
- **Skipping the two-week preparation window.** Gathering data the day before a deadline is how returns go late.
- **Letting a return slip silently.** If a filing is at risk, the five-business-day escalation to the MD is mandatory — silence is not an option.

## Key takeaways

- Reporting serves two masters: management, to decide, and regulators, to comply. Keep them distinct.
- The monthly management pack — profit-and-loss versus budget, the variance note, cash, and the capital-adequacy snapshot — is built from reconciled records.
- The Compliance Officer's Regulatory Reporting Calendar holds every return, owner, frequency, and due date, with two-week prep reminders.
- A return at risk is escalated to the MD at least five business days out; every filing is captured in the Regulatory Reporting Log.
- A late filing is a breach in its own right. File accurately, file on time, every time.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FIN-201';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_01$id$, m.id, $p$Management reporting and regulatory reporting differ chiefly in that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "they are identical and interchangeable"}, {"key": "b", "text": "management reporting is internal and for decisions, while regulatory reporting is external and mandatory on the regulator's timetable"}, {"key": "c", "text": "management reporting is filed with the SEC"}, {"key": "d", "text": "regulatory reporting is optional"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Management reports steer the firm internally; regulatory returns are mandatory filings on the regulator's form and deadline.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_02$id$, m.id, $p$The firm's financial policy requires the accounts to be reconciled...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only at year-end"}, {"key": "b", "text": "only when an auditor asks"}, {"key": "c", "text": "against all business relationships on a daily, weekly, monthly, and annual basis"}, {"key": "d", "text": "whenever there is spare time"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Reconciliation on a daily/weekly/monthly/annual basis is the foundation that makes reliable reporting possible.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_03$id$, m.id, $p$A monthly management pack that shows commission income below budget should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "state the variance plainly with a note explaining it and any corrective action"}, {"key": "b", "text": "omit the shortfall to avoid alarming the Board"}, {"key": "c", "text": "be delayed until the number recovers"}, {"key": "d", "text": "be filed with the NGX instead"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The value of a management pack is honesty about bad news; significant variances are explained, not hidden.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_04$id$, m.id, $p$The Regulatory Reporting Calendar is maintained by the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "external auditor only"}, {"key": "b", "text": "Managing Director alone"}, {"key": "c", "text": "Head of Operations"}, {"key": "d", "text": "Compliance Officer, updated at the start of each year and reviewed monthly"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The Compliance Officer owns the calendar, refreshing it annually and reviewing it every month.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_05$id$, m.id, $p$When a regulatory return is at risk of being late, the firm must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "file it late and apologise afterwards"}, {"key": "b", "text": "escalate to the Managing Director no less than five business days before the deadline"}, {"key": "c", "text": "quietly skip the filing"}, {"key": "d", "text": "wait for the regulator to ask"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A five-business-day escalation to the MD lets the firm decide whether to seek an extension — better than filing late without notice.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_06$id$, m.id, $p$The Annual Audited Financial Statements are an example of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an internal management report seen by no one outside"}, {"key": "b", "text": "a report the firm may choose not to prepare"}, {"key": "c", "text": "statutory/regulatory reporting, prepared under IFRS and signed by the external auditor"}, {"key": "d", "text": "a marketing document"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The audited financials are statutory, IFRS-based, externally audited, and filed with the SEC and NGX.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_07$id$, m.id, $p$A late regulatory filing is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a compliance breach in its own right, even when the underlying numbers are correct"}, {"key": "b", "text": "harmless if the figures are accurate"}, {"key": "c", "text": "a management matter with no regulatory consequence"}, {"key": "d", "text": "acceptable if it happens only occasionally"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Missing a deadline is itself a breach and signals to regulators that compliance is not embedded.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_08$id$, m.id, $p$The Capital Adequacy / Net Capital Return primarily reports...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "staff training records"}, {"key": "b", "text": "client complaint volumes"}, {"key": "c", "text": "total trades and client counts"}, {"key": "d", "text": "the firm's capital, liabilities, and regulatory capital ratio"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The Net Capital Return evidences that the firm holds capital above its regulatory floor.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_09$id$, m.id, $p$The Monthly Activity Report to the NGX is owned by the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "external auditor"}, {"key": "b", "text": "Head of Operations"}, {"key": "c", "text": "Managing Director's secretary"}, {"key": "d", "text": "newest analyst"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Head of Operations owns the NGX Monthly Activity Report covering trades, securities, values, and client counts.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_10$id$, m.id, $p$Every filing the firm makes is recorded in the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "staff handbook"}, {"key": "b", "text": "client onboarding pack"}, {"key": "c", "text": "Regulatory Reporting Log, with date filed, filing officer, and any issues"}, {"key": "d", "text": "marketing calendar"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Reporting Log gives the firm provable evidence of its filing record on demand.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_11$id$, m.id, $p$Preparation reminders for filings are sent by the Compliance Officer...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "at least two weeks before each deadline"}, {"key": "b", "text": "the morning the return is due"}, {"key": "c", "text": "only after a return is missed"}, {"key": "d", "text": "once a year"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Two-week reminders ensure data is gathered well before the clock runs out.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_12$id$, m.id, $p$Reporting off books that have not been reconciled is dangerous because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "reconciliation is irrelevant to reporting"}, {"key": "b", "text": "it speeds up the close"}, {"key": "c", "text": "regulators prefer unreconciled data"}, {"key": "d", "text": "every report built on unreliable records is itself unreliable"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Reconciliation is the foundation; garbage in means garbage filed.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_13$id$, m.id, $p$The statutory backdrop framing the firm's obligations as a capital-market operator is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Companies Income Tax Act"}, {"key": "b", "text": "Investments and Securities Act 2025"}, {"key": "c", "text": "National Housing Fund Act"}, {"key": "d", "text": "Pension Reform Act"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The ISA 2025 frames the firm's market-operator obligations (source 'ISA 2024' is logged as DF-10).$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_14$id$, m.id, $p$The Client Asset Report filed quarterly to the NGX confirms...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the firm's marketing spend"}, {"key": "b", "text": "director remuneration"}, {"key": "c", "text": "segregated client assets and the reconciliation confirmation"}, {"key": "d", "text": "staff leave balances"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Client Asset Report evidences that client assets are segregated and reconciled.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_15$id$, m.id, $p$The monthly variance report that explains deviations from budget belongs in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "management reporting, where decisions are made"}, {"key": "b", "text": "the NFIU suspicious-transaction file"}, {"key": "c", "text": "the client's account statement"}, {"key": "d", "text": "the external audit opinion"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Variance analysis and corrective-action recommendations are core management reporting.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_16$id$, m.id, $p$If an internal month-end close slips, the firm must still...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "let regulatory returns slip with it"}, {"key": "b", "text": "cancel the affected returns"}, {"key": "c", "text": "treat regulatory deadlines as flexible"}, {"key": "d", "text": "protect regulatory filing deadlines, which run on the regulator's timetable"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Regulatory deadlines are independent of the firm's internal rhythm and must be protected.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_17$id$, m.id, $p$Currency Transaction Reports and Suspicious Transaction Reports are filed with the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "external auditor"}, {"key": "b", "text": "NFIU, as qualifying transactions and suspicions arise"}, {"key": "c", "text": "firm's bank manager"}, {"key": "d", "text": "Board only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$CTRs and STRs go to the NFIU on the relevant trigger, not on a fixed calendar slot alone.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_18$id$, m.id, $p$Capital-adequacy reporting matters because the firm is obliged to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "maximise leverage at all times"}, {"key": "b", "text": "hide its capital position from regulators"}, {"key": "c", "text": "operate within its means and keep regulatory capital above the required floor"}, {"key": "d", "text": "distribute all capital as bonuses"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The firm must remain within capital-adequacy requirements; the Net Capital Return evidences it.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_19$id$, m.id, $p$The single instrument that holds every return, owner, frequency, and due date together is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Regulatory Reporting Calendar"}, {"key": "b", "text": "employee handbook"}, {"key": "c", "text": "trade blotter"}, {"key": "d", "text": "client risk profile"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The calendar is the one place every reporting obligation is logged and tracked.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin201_20$id$, m.id, $p$The unifying message of management and statutory reporting is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only internal reports matter"}, {"key": "b", "text": "only regulators' reports matter"}, {"key": "c", "text": "reports may be filed late if numbers are right"}, {"key": "d", "text": "reliable, reconciled records serve both decisions and compliance — accurate and on time, every time"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Both families rest on disciplined records; the firm reports accurately and punctually to management and regulators alike.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'FIN-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: FIN-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FIN-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FIN-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: FIN-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
