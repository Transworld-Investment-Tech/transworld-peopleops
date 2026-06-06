-- ===========================================================================
-- FND-109 SEC/NGX Conduct Essentials: lesson + 20-question check (v0.46.0 content)
-- Authored FROM POLICY off Compliance Manual v3.0 §3 + §10 (market conduct) + §15.
--   Supporting: Operational Manual v3.0 §1; Code of Ethics CO-POL-001.
--   §10 market conduct is taught at awareness level (CCO-approved fold-in); REG modules carry the depth.
-- Tier A (CCO-owned). Running this seed PUBLISHES the module -- it is the CCO publish gate.
--   DO NOT RUN until the CCO has reviewed and approved the content.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Transworld operates in one of Africa's most developed capital markets, under a comprehensive and evolving rulebook. You do not need to memorize every regulation — but every member of staff should know the key rules that govern the firm, the most serious conduct lines you must never cross, and the standards of behavior expected of everyone who carries the firm's name. The firm's mantra captures the spirit: **the right way is always the best way.** This module gives you the conduct essentials.

## What you'll be able to do

1. Name the main regulators and the key instruments that govern Transworld, and apply the "stricter rule prevails" principle.
2. Recognize the serious market-conduct offenses — insider trading, market manipulation, and breaches of client priority — at an awareness level.
3. Describe the six standards of conduct and connect them to the firm's values.
4. Know when, and to whom, to escalate a conduct question.

## The rulebook you operate under

Several instruments and regulators shape the firm's obligations:

- **Investments and Securities Act 2024 (ISA 2024)** — SEC. The foundational statute for the capital market; governs licensing, conduct, and the obligations of all operators.
- **SEC Rules and Regulations** — SEC. Detailed rules on KYC, AML/CFT, client classification, investment advice, capital adequacy, reporting, and conduct of business.
- **NGX Dealing Members' Rules 2015** and the **NGX Minimum Operating Standards (MOS)** — NGX. Govern dealing conduct, client priority, order handling, the compliance-officer requirement, governance, staffing, and reporting.
- **AML/CFT Act 2022** — NFIU/SEC. Requires an AML/CFT/CPF program, CTR/STR filing, CDD/EDD, sanctions screening, and annual training.
- **Nigeria Data Protection Act 2023 (NDPA)** — NDPC/NITDA. Governs personal data of clients and staff.
- **CAMA 2020** (CAC) and the **Nigerian Code of Corporate Governance 2018 (NCCG)** (FRC) — corporate structure, directorship, and governance standards for boards and management.
- **CSCS Rules** — the firm's obligations as a participant in the Central Securities Clearing System.

> **When rules conflict, the stricter requirement prevails.** If an internal limit is more lenient than a regulatory rule, you follow the rule. The Compliance Officer maintains the Regulatory Calendar and notifies management when rules change.

Compliance is **not** the Compliance Officer's job alone. It runs from the Board to the newest intern — the Compliance Officer sets standards, monitors, and escalates, but the responsibility to do the right thing in every transaction belongs to everyone. Compliance with the firm's rules is a condition of employment, and the right move when you are unsure is to ask the Compliance Officer *before* you act, not after.

## Market conduct — the lines you never cross

Market-conduct breaches are among the most serious a broking firm can commit, because they damage the very market the firm depends on. At an awareness level, know these:

- **Insider trading.** Trading in a security using material, non-public information — information not available to the market that would likely move the price if known. It is a criminal offense under ISA 2024. The rule is simple: if you hold information about a company that has not been publicly announced and that could affect its price, you do not trade in that security and you do not pass the information to anyone who might. Unsure whether something counts as inside information? Ask the Compliance Officer — the answer is final.
- **Market manipulation.** Any practice that creates an artificial or misleading price or trading volume — wash trading (trading with yourself to fake volume), front-running (trading ahead of a client's order to profit from the move it will cause), or spreading false rumors. All forms are prohibited and expose the firm and the individual to prosecution and loss of authorization.
- **Client priority — the absolute rule.** Client orders always take priority over the firm's own proprietary interest. No firm trade is placed ahead of a client order in the same security, and client orders are never delayed so the firm's book can be positioned first. This is checked in surveillance, and any breach is escalated immediately.
- **Best execution.** The firm must take reasonable steps to obtain the best result for client orders; execution quality is monitored, and systematic failure is a compliance failure, not just an operational one.

>! These are awareness essentials for everyone — not just dealers. The deeper surveillance techniques live in the regulatory (REG) modules; what matters from day one is the rule: do not trade on inside information, never put the firm ahead of the client, and ask before you act.

## The six standards of conduct

Every member of staff is expected to demonstrate the same standards, drawn from the Compliance Manual and the Code of Ethics (whose values are Integrity, Independence, Client First, Excellence, and Accountability):

- **Integrity** — honesty in all dealings; never overstating a product, never concealing a mistake, never signing off on something you have not actually checked.
- **Professionalism** — skill, care, accountability; meeting deadlines, returning communications, taking responsibility for the quality of your work.
- **Confidentiality** — protecting client and company information; not discussing client affairs in public or accessing what you do not need.
- **Conflict avoidance** — identifying and disclosing where your personal interests might conflict with the firm's or a client's.
- **Fair dealing** — treating all clients equitably; the same process for every client, every time, regardless of account size or relationship.
- **Speaking up** — if something does not look right, you say something through the firm's confidential channel; using it is always the right thing to do.

These also live in the firm's everyday behaviors — *Integrity Above All* and *Compliance by Default* ("aim to be ahead of the regulator") — so conduct is not a separate compliance exercise but how the work is done.

## Key takeaways

- Know the main regulators — **SEC, NGX, NFIU, NDPC, FRC, CAC** — and the headline instruments; when rules conflict, the **stricter rule prevails**.
- Compliance runs **Board to intern**; ask the Compliance Officer **before** you act.
- Never **trade on inside information** or tip others; all forms of **market manipulation** are prohibited.
- **Client priority is absolute** — the client's order always comes before the firm's own.
- Live the **six standards**: integrity, professionalism, confidentiality, conflict avoidance, fair dealing, speaking up.

## References

- **Compliance Manual v3.0, §3 (Regulatory and Legal Framework)**, **§10 (Market Conduct)**, and **§15 (Standards of Conduct and Ethics)** — primary sources.
- Supporting: **Operational & Procedure Manual v3.0, §1 (Introduction & guiding principles)**; **Code of Ethics & Professional Conduct CO-POL-001**.
- Regulatory basis: ISA 2024; SEC Rules; NGX Dealing Members' Rules 2015 & MOS; AML/CFT Act 2022; NDPA 2023; NCCG 2018; CAMA 2020; CSCS Rules.
- *Mandatory module · annual refresh + induction. Content owner: Chief Compliance Officer. Tier A. Market-conduct content (Compliance Manual §10) is taught here at an awareness level by design; the regulatory (REG) modules carry the surveillance depth. Verify regulatory currency at each annual cycle.*$body$,
    pass_mark = 80,
    estimated_minutes = 35,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-109';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_01$id$, m.id, $p$Which body is the primary securities regulator in Nigeria?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The Central Bank of Nigeria"}, {"key": "b", "text": "The Securities and Exchange Commission (SEC)"}, {"key": "c", "text": "The Federal Inland Revenue Service"}, {"key": "d", "text": "The Corporate Affairs Commission"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The SEC is the primary securities regulator, administering the ISA 2024 and the SEC Rules. The NGX is the exchange-level regulator.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_02$id$, m.id, $p$If an internal limit is more lenient than a regulatory rule, you should follow:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The internal limit, since it is the firm's own"}, {"key": "b", "text": "Whichever is easier"}, {"key": "c", "text": "The stricter requirement — the regulatory rule"}, {"key": "d", "text": "Neither until a manager decides"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$When requirements conflict, the stricter requirement prevails — here, the regulatory rule.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_03$id$, m.id, $p$Insider trading is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Trading quickly on public news"}, {"key": "b", "text": "Trading using material, non-public information"}, {"key": "c", "text": "Any trade by a member of staff"}, {"key": "d", "text": "Trading on a holiday"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Insider trading is trading in a security using material, non-public information — a criminal offense under ISA 2024.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_04$id$, m.id, $p$You learn, through a client relationship, of an unannounced deal that will likely move a company's share price. You may:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Trade in that company before the announcement"}, {"key": "b", "text": "Tell a friend so they can trade"}, {"key": "c", "text": "Neither trade nor pass on the information; ask Compliance if unsure"}, {"key": "d", "text": "Trade only a small amount"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$You must not trade on the information or tip anyone who might. If unsure whether it is inside information, ask the Compliance Officer — the answer is final.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_05$id$, m.id, $p$Trading ahead of a client's order to profit from the price move it will cause is called:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Best execution"}, {"key": "b", "text": "Front-running — a form of market manipulation"}, {"key": "c", "text": "Client priority"}, {"key": "d", "text": "Wash trading"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Front-running is trading ahead of a client order to profit from the resulting move — a prohibited form of market manipulation.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_06$id$, m.id, $p$Under the client-priority rule:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The firm's proprietary trade may go first if it is small"}, {"key": "b", "text": "Client orders always take priority over the firm's own interest"}, {"key": "c", "text": "Priority depends on account size"}, {"key": "d", "text": "The dealer decides case by case"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client priority is absolute: no firm trade is placed ahead of a client order in the same security, and client orders are never delayed for the firm's book.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_07$id$, m.id, $p$Compliance is only the Compliance Officer's responsibility.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Compliance runs from the Board to the newest intern; the Compliance Officer sets standards and monitors, but doing the right thing is everyone's job.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_08$id$, m.id, $p$When you are unsure whether something is permitted, the right time to ask the Compliance Officer is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "After you have acted"}, {"key": "b", "text": "Before you act"}, {"key": "c", "text": "Only if a client complains"}, {"key": "d", "text": "At the annual review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Ask before you act, not after. Compliance is a resource, and acting first and explaining later is the wrong order.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_09$id$, m.id, $p$Which is an example of market manipulation? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Wash trading to create fake volume"}, {"key": "b", "text": "Front-running a client order"}, {"key": "c", "text": "Spreading false rumors to move a price"}, {"key": "d", "text": "Executing a client's instruction promptly and fairly"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Wash trading, front-running, and spreading false information are all manipulation. Executing a client's order properly is exactly what you should do.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_10$id$, m.id, $p$'The right way is always the best way' is best described as:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A marketing slogan"}, {"key": "b", "text": "The firm's conduct mantra — how everyone is expected to behave"}, {"key": "c", "text": "A rule that applies only to dealers"}, {"key": "d", "text": "Advice for clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$It is the firm's conduct mantra, describing how every person is expected to show up — the foundation under every other rule.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_11$id$, m.id, $p$Which standard requires never signing off on something you have not actually checked?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Confidentiality"}, {"key": "b", "text": "Integrity"}, {"key": "c", "text": "Fair dealing"}, {"key": "d", "text": "Professionalism"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Integrity means honesty in all dealings — never overstating, never concealing a mistake, never signing off on something unchecked.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_12$id$, m.id, $p$Treating every client through the same process regardless of account size reflects:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Fair dealing"}, {"key": "b", "text": "Confidentiality"}, {"key": "c", "text": "Conflict avoidance"}, {"key": "d", "text": "Speaking up"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Fair dealing means treating all clients equitably — the same process for every client, every time.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_13$id$, m.id, $p$Which regulator administers AML/CFT obligations alongside the SEC?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The NFIU"}, {"key": "b", "text": "The NGX"}, {"key": "c", "text": "The FRC"}, {"key": "d", "text": "The CAC"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The AML/CFT Act 2022 is administered by the NFIU (with the SEC), requiring an AML/CFT/CPF program, CTR/STR filing, CDD/EDD, and annual training.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_14$id$, m.id, $p$Best execution means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Executing the firm's trades first"}, {"key": "b", "text": "Taking reasonable steps to obtain the best result for client orders"}, {"key": "c", "text": "Executing the largest orders only"}, {"key": "d", "text": "Trading as fast as possible regardless of price"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Best execution is the obligation to obtain the best result for client orders; execution quality is monitored and systematic failure is a compliance failure.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_15$id$, m.id, $p$The NGX Dealing Members' Rules 2015 govern:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Personal income tax"}, {"key": "b", "text": "Dealing conduct, client priority, order handling, and market conduct on the exchange"}, {"key": "c", "text": "Company incorporation"}, {"key": "d", "text": "Data protection"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The NGX Dealing Members' Rules govern dealing conduct, client priority, order handling, the compliance-officer requirement, and market conduct.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_16$id$, m.id, $p$Disclosing a situation where your personal interest could clash with a client's is part of which standard?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Professionalism"}, {"key": "b", "text": "Conflict avoidance"}, {"key": "c", "text": "Fair dealing"}, {"key": "d", "text": "Integrity"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Conflict avoidance means identifying and disclosing where personal interests might conflict with the firm's or a client's.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_17$id$, m.id, $p$'Compliance by Default' as a firm behavior means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Compliance is assembled only when an inspector arrives"}, {"key": "b", "text": "Compliance is built into how you work — aim to be ahead of the regulator"}, {"key": "c", "text": "Compliance applies only to senior staff"}, {"key": "d", "text": "Compliance is optional if results are strong"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compliance by Default means it is built into everyday work — never assembled when an inspector knocks — and the firm aims to be ahead of the regulator.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_18$id$, m.id, $p$Who maintains the Regulatory Calendar and flags rule changes to management?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Each department head"}, {"key": "b", "text": "The Compliance Officer"}, {"key": "c", "text": "The external auditor"}, {"key": "d", "text": "The MD personally"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer maintains the Regulatory Calendar and notifies management when regulations are issued or amended.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_19$id$, m.id, $p$Market-conduct rules such as client priority apply only to the dealing desk.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. These are awareness essentials for everyone. The rule — do not trade on inside information, never put the firm ahead of the client — applies firm-wide.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd109_20$id$, m.id, $p$The Code of Ethics values that underpin the standards of conduct are:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Speed, Volume, Profit, Reach, Scale"}, {"key": "b", "text": "Integrity, Independence, Client First, Excellence, Accountability"}, {"key": "c", "text": "Secrecy, Loyalty, Obedience"}, {"key": "d", "text": "Growth at any cost"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Code of Ethics values are Integrity, Independence, Client First, Excellence, and Accountability — the foundation of the six standards of conduct.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-109'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
