-- =============================================================================
-- seed_reg202_content.sql  (v0.60.0)
-- REG-202 Regulatory reporting & filings: lesson + 20-question check (Proficient, Tier A, FROM POLICY).
-- Authored from the firm's compliance source suite; teaches ISA 2025 (not 2007/2024).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO assignment rule: the role-and-grade matrix (seed_ws7_role_matrix.sql) already
-- maps REG-202 as REQUIRED to its job profiles; this is Proficient/role-targeted
-- content, NOT firmwide-mandatory, so no scope=ALL row is added.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A regulator almost never watches you work. They do not sit on the trading floor or read your emails as you send them. What they see is what you file — the returns, the reports, the renewals that reach the SEC, the Exchange, and the NFIU on a schedule. To the regulator, those filings *are* the firm. A business that runs beautifully but files late and incompletely looks, from the outside, like a business that is out of control. This module is about making the outside match the inside: filing what is due, when it is due, with an evidence trail that proves you did.

## What you will be able to do

1. Explain why regulatory reporting is a condition of the licence, not an afterthought.
2. Describe the firm's reporting calendar — periodic, annual, and event-driven filings.
3. Apply the ownership and four-eyes discipline that keeps a return accurate before it goes out.
4. Build the evidence trail that proves a filing was made.
5. Escalate correctly when a filing is at risk of being late or wrong.

## Reporting is a condition of the licence

Transworld operates because the SEC, under the **Investments and Securities Act 2025**, registered it to — and that registration comes with continuing obligations, not just an entry fee. Many of those obligations are reports. The Exchange expects periodic submissions from its dealing members; the SEC expects regulatory returns and an annual renewal of registration; the NFIU expects AML/CFT returns. A missed or false filing is not a clerical slip — it is a breach of the terms on which the firm is allowed to trade, and regulators treat persistent reporting failures as a sign of deeper weakness. The reputational read matters as much as the penalty: reliable filers are trusted; unreliable ones get inspected.

It is worth being honest about why this can feel thankless. Reporting produces nothing you can sell; a perfect quarter of filings wins no new clients and earns no fee. But that is the wrong frame. Filings are the firm's licence to keep earning everything else — they are the rent paid on the authority to trade at all. A single serious reporting failure can cost the firm more, in penalty and in regulatory attention, than a quarter of good filings ever "made." So the work is not overhead to be minimized; it is risk-control to be done right, on time, every time, precisely because the downside is so asymmetric.

## The reporting calendar

The firm keeps a **regulatory reporting calendar** for exactly this reason — so that nothing depends on someone remembering. Think of the obligations in three rhythms.

**Periodic returns** recur on a fixed cadence — monthly, quarterly, half-yearly, or annual — to the Exchange, the SEC, and the NFIU. Each has a defined due date, a defined owner, and a defined format. The discipline is to work backward from the due date: a return due on the 10th is prepared and reviewed by the 7th, not assembled on the 10th.

Make this concrete. As a dealing member, the firm owes the Exchange regular submissions on its trading and financial position; as a registered operator it owes the SEC periodic regulatory returns; under the AML framework it owes the NFIU its AML/CFT returns; and as a Nigerian company it has filings to the corporate registry. You do not need to memorize every form — that is what the calendar is for — but you should carry the mental map that the firm reports up several channels at once, on different clocks, and that a quiet month on one channel does not mean a quiet month on the others. The most common failure is not a hard return that someone got wrong; it is an easy return that nobody realized was due.

**The annual renewal** is the one every capital market operator must not miss: registration is **renewed annually, not later than 31 January** each year. Letting renewal lapse is among the most serious filing failures there is, because it goes to the firm's very authority to operate. It is calendared a season ahead, with the documentation gathered in good time rather than scrambled at the deadline. Treat it as the immovable fixture of the firm's compliance year: everything else can, in a crisis, be re-sequenced, but a lapsed registration is not a late return — it is a firm that has, on paper, stopped being authorized. The work of assembling renewal documents begins in the final quarter of the prior year, not in January.

**Event-driven filings** are triggered by something happening rather than by the clock — a change in directors or sponsored individuals, a material incident, a breach that must be reported, a corporate action. These are the easiest to miss precisely because they are not on a recurring date. The rule is simple: when a reportable event occurs, the reporting clock starts that day, and the owner files within the window the relevant rule sets.

## Ownership and the four-eyes rule

Every return has a named **owner** — the person accountable for its accuracy and timeliness — and that ownership is recorded, not assumed. But no significant filing leaves the building on one pair of eyes. The **four-eyes rule** means a second competent person reviews the return before submission: the owner prepares, a reviewer checks the numbers against source, and only then is it submitted. The reviewer is not a rubber stamp; their job is to catch the transposed figure, the stale template, the omitted line before the regulator does. Where a filing is also a compliance return, the Compliance function is in that review chain by design.

This is also where cover for absence matters. A return does not become optional because its owner is on leave; the calendar names a backup, and the four-eyes discipline holds regardless of who is at the keyboard.

A word on what the reviewer is actually checking, because "review" can become a reflex signature if you let it. The reviewer ties the headline numbers back to a source — the ledger, the trade records, the bank statement — rather than re-reading the same spreadsheet the preparer typed. They confirm the template is the current one the regulator expects, not last quarter's. They check that every required field is populated and that the figures are internally consistent. A reviewer who only confirms the form "looks right" has added nothing; a reviewer who reconciles it to source has caught the error that an inspection would otherwise have found. The preparer cannot see their own blind spot — that is the whole reason the second pair of eyes exists, and why the firm never treats the review as optional even when the deadline is tight.

## Evidence: the filing you cannot prove

There is a principle that runs through this whole firm: *what is not documented did not happen.* It applies with full force to filings. It is not enough to have submitted a return — you must be able to show, later and to a regulator, that you submitted it, when, by whom, and what it contained. That means keeping the acknowledgment or submission receipt, the final version of what was filed, and the record of who prepared and reviewed it. The portal's evidence layer exists to hold this trail so that a filing is reconstructable months later without a frantic search. A return filed on time but unprovable is, in an inspection, treated as a return not filed.

The test to apply is simple and unforgiving: if an inspector asked you tomorrow to prove that last quarter's return went in on time and said what it should have said, could you, in minutes, produce the receipt, the exact version filed, and the name of the reviewer? If the honest answer is "I think so" or "it's in an email somewhere," the evidence trail has already failed. Build the habit of filing the proof at the same moment you file the return — the receipt saved, the final copy locked, the reviewer noted — so the record is complete while it is fresh rather than reconstructed under pressure.

## When a filing slips

Sometimes, despite the calendar, a return is going to be late or you discover an error in one already sent. The wrong response is to hide it and hope. The right response is to escalate immediately to your manager and to Compliance, so the firm can decide how to handle it — file as soon as possible, correct a prior submission, and, where required, notify the regulator of the issue proactively. Regulators distinguish sharply between a firm that self-identifies and reports a problem and one that conceals it until found. Honest, prompt escalation protects the firm; silence compounds a small problem into a serious one.

The instinct to cover a slip is human and exactly backwards. A late filing, owned and explained, is a manageable lapse; a late filing discovered by an inspector who then finds it was known and hidden is a conduct problem that calls the firm's whole control culture into question. The same logic applies to an error found after submission: a prompt, voluntary correction reads as a firm that polices itself, while a quietly amended internal copy and an untouched regulator's version reads as concealment. Make the rule reflexive — the moment you know a filing is at risk, it stops being your private problem and becomes the firm's to manage in the open.

## A worked example

**Illustration — the quarter-end gap (entirely hypothetical).** A quarterly return to the Exchange is due on the 10th. On the 6th, the analyst who owns it goes on emergency leave with the draft half-finished. Walk the controls that still get it filed correctly: the calendar already names a backup owner, who picks up the draft; the four-eyes reviewer checks the completed return against the source ledgers; it is submitted on the 9th — a day early by design — and the submission acknowledgment is saved to the evidence layer with a note of who prepared and reviewed it. Nobody had to remember the deadline, because the system did; nobody filed on a single pair of eyes; and the firm can prove all of it later. Notice what made the difference: not heroics, but three ordinary controls — a calendar that owns the date, a named backup, and a review against source — each doing a small job so that one person's absence never became the firm's failure. That is what "in control" looks like from the inside.

## Common traps

- **Treating the calendar as a reminder, not a control.** The calendar owns the deadlines so that no individual's memory is the point of failure.
- **One pair of eyes.** A return that goes out without review goes out with whatever error the preparer could not see in their own work.
- **Filing without keeping proof.** No receipt, no final copy, no reviewer record — to an inspector, that filing is unproven.
- **Letting an owner's absence excuse a deadline.** The obligation belongs to the firm; the backup is already named.
- **Hiding a slip.** Self-reporting a late or erroneous filing is far less damaging than being found to have concealed it.

## Key takeaways

- Filings are a condition of the licence under ISA 2025; to a regulator, your filings are the firm.
- Work the calendar in three rhythms — periodic, the 31 January annual renewal, and event-driven — backward from each due date.
- Every return has a named owner and passes the four-eyes review before submission; absence is covered, not an excuse.
- Keep the evidence — receipt, final copy, reviewer record — because an unprovable filing is treated as no filing.
- If a filing will be late or wrong, escalate at once; self-reporting protects the firm.

*Reference: Compliance Manual v3.0 §11 (regulatory reporting calendar) and the AML/CFT/CPF Policy v3.0 (AML returns). Governing framework: the Investments and Securities Act 2025 and SEC/NGX rules. This module is a navigation aid; the Compliance Manual and the rules are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'REG-202';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_01$id$, m.id, $p$From a regulator's vantage point, why do filings matter so much?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "They are a formality with no real consequence"}, {"key": "b", "text": "A regulator rarely watches you work, so your filings are how the firm is seen and judged"}, {"key": "c", "text": "They replace the need for internal controls"}, {"key": "d", "text": "They are only relevant during an inspection"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Regulators see filings, not day-to-day work; reliable, accurate filings are how the firm demonstrates it is in control.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_02$id$, m.id, $p$Regulatory reporting is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an optional courtesy to the regulator"}, {"key": "b", "text": "a continuing condition of the firm's licence under ISA 2025"}, {"key": "c", "text": "a one-time requirement at registration"}, {"key": "d", "text": "a marketing exercise"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Registration under ISA 2025 carries continuing obligations; many are reports, and missing them breaches the terms of the licence.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_03$id$, m.id, $p$The firm's registration must be renewed annually no later than...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "31 December"}, {"key": "b", "text": "31 March"}, {"key": "c", "text": "31 January"}, {"key": "d", "text": "30 June"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Annual renewal of registration is due not later than 31 January each year — among the most serious filings to never miss.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_04$id$, m.id, $p$The three rhythms of the reporting calendar are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "daily, weekly, monthly"}, {"key": "b", "text": "periodic returns, the annual renewal, and event-driven filings"}, {"key": "c", "text": "internal, external, and informal"}, {"key": "d", "text": "mandatory, optional, and recommended"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Obligations recur periodically, renew annually, or are triggered by events; the calendar tracks all three.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_05$id$, m.id, $p$Event-driven filings are the easiest to miss because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "they are unimportant"}, {"key": "b", "text": "they are triggered by something happening rather than by a recurring date"}, {"key": "c", "text": "they are filed automatically by the regulator"}, {"key": "d", "text": "they have no deadline"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Because they are not on a recurring date, event-driven filings depend on someone recognizing the trigger; the clock starts the day the event occurs.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_06$id$, m.id, $p$The four-eyes rule on a significant return means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the owner submits it alone, quickly"}, {"key": "b", "text": "a second competent person reviews it against source before submission"}, {"key": "c", "text": "four people must each sign it"}, {"key": "d", "text": "the regulator reviews it before you file"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The owner prepares; a reviewer checks against source to catch errors before the regulator does. The reviewer is not a rubber stamp.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_07$id$, m.id, $p$A return's owner goes on leave the week before its deadline. The deadline...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is automatically extended"}, {"key": "b", "text": "becomes optional until they return"}, {"key": "c", "text": "still stands; the calendar names a backup and four-eyes holds regardless"}, {"key": "d", "text": "passes to the regulator"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The obligation belongs to the firm, not the individual; a backup is named and the review discipline is unchanged.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_08$id$, m.id, $p$Which best captures the firm's evidence principle as applied to filings?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Filing it is enough; proof is unnecessary"}, {"key": "b", "text": "What is not documented did not happen \u2014 keep the receipt, the final copy, and the reviewer record"}, {"key": "c", "text": "Only the regulator keeps proof"}, {"key": "d", "text": "Evidence is only needed if challenged"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A filing you cannot prove — receipt, final version, reviewer record — is treated, in an inspection, as no filing.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_09$id$, m.id, $p$A return filed on time but with no submission receipt or saved copy is, in an inspection...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully acceptable"}, {"key": "b", "text": "treated as if it was not filed"}, {"key": "c", "text": "a minor issue with no consequence"}, {"key": "d", "text": "the regulator's problem to prove"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Without provable evidence, an on-time filing is treated as unproven — effectively not filed.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_10$id$, m.id, $p$You discover an error in a return already submitted last month. The right action is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "say nothing and hope it goes unnoticed"}, {"key": "b", "text": "escalate to your manager and Compliance and correct it, notifying the regulator where required"}, {"key": "c", "text": "quietly fix the internal copy only"}, {"key": "d", "text": "wait for the regulator to find it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Self-identifying and correcting — and proactively notifying where required — protects the firm; concealment compounds the problem.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_11$id$, m.id, $p$Regulators distinguish sharply between a firm that self-reports a problem and one that conceals it.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["t"]$c$::jsonb, $e$Self-reporting a late or erroneous filing is far less damaging than being found to have hidden it.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_12$id$, m.id, $p$Working a deadline 'backward' means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "filing after the due date when convenient"}, {"key": "b", "text": "preparing and reviewing ahead of the due date so it is never assembled at the last minute"}, {"key": "c", "text": "asking the regulator to move the date"}, {"key": "d", "text": "filing only the easy parts first"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A return due on the 10th is prepared and reviewed by the 7th — built backward from the deadline, not assembled on it.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_13$id$, m.id, $p$Which bodies are typical recipients of the firm's regulatory filings?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only the firm's auditors"}, {"key": "b", "text": "The SEC, the Nigerian Exchange, and the NFIU"}, {"key": "c", "text": "Only the firm's clients"}, {"key": "d", "text": "The trading desk"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Periodic and event-driven filings go to the SEC, the Exchange (for dealing members), and the NFIU for AML returns.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_14$id$, m.id, $p$Every regulatory return at the firm should have...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no particular owner; it is a shared task"}, {"key": "b", "text": "a named, recorded owner accountable for accuracy and timeliness"}, {"key": "c", "text": "only an owner if it is annual"}, {"key": "d", "text": "an owner chosen at random each cycle"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Ownership is recorded, not assumed — one named person is accountable, with a backup in the calendar.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_15$id$, m.id, $p$Persistent reporting failures are read by regulators mainly as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a harmless administrative quirk"}, {"key": "b", "text": "a sign of deeper weakness, prompting closer scrutiny"}, {"key": "c", "text": "evidence the firm is too busy trading"}, {"key": "d", "text": "a reason to reduce oversight"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Unreliable filing signals weak control; reliable filers are trusted, unreliable ones get inspected.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_16$id$, m.id, $p$The portal's evidence layer is used in reporting to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "replace the regulator's records"}, {"key": "b", "text": "hold the trail \u2014 receipts, final copies, reviewer records \u2014 so filings are reconstructable later"}, {"key": "c", "text": "submit filings automatically"}, {"key": "d", "text": "calculate the firm's tax"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The evidence layer preserves the proof of each filing so it can be reconstructed months later without a frantic search.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_17$id$, m.id, $p$A monthly return due on the 10th should ideally be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "started and finished on the 10th"}, {"key": "b", "text": "prepared and reviewed by around the 7th, then submitted ahead of the deadline"}, {"key": "c", "text": "filed on the 11th if the 10th is busy"}, {"key": "d", "text": "skipped if nothing changed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Building in review time before the due date is the discipline that prevents last-minute errors and late filings.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_18$id$, m.id, $p$Letting the annual renewal lapse is a minor issue easily fixed later.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Renewal goes to the firm's very authority to operate; a lapse is among the most serious filing failures and is calendared a season ahead.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_19$id$, m.id, $p$The reviewer in the four-eyes process is essentially a rubber stamp.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$The reviewer's job is to catch the transposed figure, stale template, or omitted line before the regulator does — substantive, not cosmetic.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg202_20$id$, m.id, $p$AML/CFT returns are part of the reporting calendar and are owed to the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "firm's external lawyers"}, {"key": "b", "text": "NFIU (the Financial Intelligence Unit), as supervised under the AML framework"}, {"key": "c", "text": "trading counterparties"}, {"key": "d", "text": "firm's clients directly"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$AML/CFT returns are filed with the NFIU; keeping the underlying records clean is what makes those returns true.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'REG-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: REG-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'REG-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: REG-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: REG-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
