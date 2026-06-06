-- ===========================================================================
-- BDV-101 BD at Transworld: role, mandate & representing the institution: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Business development is how the firm grows — how new clients are found, relationships are built, and the institution's reach is extended. But at a regulated firm whose product is trust, growth is never "sales at any cost." A business developer carries Transworld's name and reputation into every meeting, call, and event; what they say and how they behave becomes, in that moment, what the firm is. This module sets out what business development means at Transworld: the mandate, what it means to represent the institution, and the ethical guardrails that make growth sustainable rather than reckless. It is the foundation on which the more technical BD modules build. The firm's mantra is the whole of it: **the right way is always the best way.**

## What you'll be able to do

1. State the business-development mandate at Transworld and how it connects to the firm's pillars.
2. Explain what it means to represent the institution — and why every interaction reflects the firm.
3. Explain why "the product is trust," and what that demands of a business developer.
4. Apply the core conduct rules: honesty, suitability, and never pressuring or misleading a client.
5. State who may speak for the firm publicly, and the rules on gifts and inducements.

## The mandate

The business-development mandate is to **grow the firm's client base and revenue — ethically, sustainably, and in the client's genuine interest.** Two of the firm's five pillars sit directly behind it: **Growth-Oriented** (the firm intends to expand, not stand still) and **Ethical Profitability** (it intends to do so honestly, earning profit the right way). Those two pillars are deliberately paired. Growth pursued without ethics is the fastest way to lose the trust the firm depends on; ethics without growth leaves the institution stagnant. The BD function holds both at once. A business developer who brings in a client through misrepresentation has not grown the firm — they have planted a liability that will surface later as a complaint, a lost client, or a regulatory finding.

> Growth at Transworld is measured not only by clients won, but by clients *kept*. A relationship opened honestly and served well is worth more than three opened on a promise the firm cannot keep.

## You represent the institution

When you are doing business development, you are not acting as yourself — you are **Transworld** in the eyes of the person across the table. The Code of Ethics is explicit that staff represent the firm not only in the office but at client premises, at industry events, and in any external setting where they are associated with the firm, during and outside working hours where the conduct touches the firm's business or reputation. The firm's reputation in the market is described as **an asset that every member of staff shares responsibility for protecting** — and reputation is built slowly and lost quickly.

This has practical force. The way you speak about competitors, the promises you make, the way you treat a counterparty or a junior colleague at an event, the things you post online — all of it attaches to the firm. A business developer is, in effect, the firm's face. That is a privilege and a weight at the same time.

## The product is trust

The firm's own framing, from its conflict-of-interest policy, is that **trust is the only product it actually sells.** The shares already exist in the market; the systems that route orders already exist; the research could in principle be written by anyone. What distinguishes a broker the market is willing to deal with is the belief that the people inside the firm act honestly, with independent judgment, and in the interests of those they serve. For a business developer, this reframes the whole job. You are not persuading someone to buy a product on a shelf. You are asking them to trust an institution with their financial life. That trust is earned by competence and honesty, and it is the actual thing being offered.

## The conduct rules that make BD sustainable

The Code of Ethics turns this into concrete obligations. A business developer must hold to all of them:

- **Absolute honesty.** Never make a false, misleading, or deceptive statement in any form; never omit information a reasonable person would consider material; never let someone believe something you know to be false, even through silence. A sale built on a half-truth is a breach, not a win.
- **Suitability before recommendation.** Advice and recommendations must be suitable for the specific client's needs, risk appetite, and financial circumstances. You must never pressure, mislead, or exploit a client to secure a transaction or a commission. Recommending an unsuitable product for personal gain is one of the most serious breaches a member of staff can commit — and may be a **criminal offense under the ISA 2024**.
- **Disclose and document.** Disclose material information, including risks and any conflicts of interest; document significant client interactions, instructions, and advice. If it was not documented, the firm cannot prove it happened.
- **Competence.** Maintain the knowledge your role requires and hold any registrations it requires. You cannot honestly sell what you do not understand.

>! The commission you might earn on a single unsuitable sale is never worth the cost of making it. The client is harmed, the firm is exposed, and under the ISA 2024 the individual can face criminal liability. There is no version of the math in which it pays.

## Who may speak for the firm

Representing the firm in a sales conversation is not the same as speaking *for* the firm publicly. The Code of Ethics reserves public statements on behalf of Transworld to the **Managing Director and persons expressly designated in writing by the MD** — this covers media interviews, press releases, published articles, and regulatory submissions. Beyond that, you must **not make investment recommendations or market commentary in a personal capacity without explicit Compliance approval**, and anyone who publicly discusses specific securities or strategies (on social media, a podcast, a blog, or at a public event) may be required by the SEC to hold appropriate registrations and make disclosures. The safe rule for a business developer: represent the firm honestly to a client, but do not become its public voice or a public stock commentator without authorization.

## Gifts, inducements, and bribery

Relationships in BD involve hospitality, and there are firm lines. Personal monetary appreciation from a client must be **declined and redirected to the company account**, the line manager notified, and the gift form (F-26) completed within 24 hours. Bribes are never offered or accepted — an approach is declined, documented, and reported to Compliance. The principle is simple: nothing of value should ever quietly change a decision that ought to be made on the merits. Hospitality that creates, or appears to create, an obligation is a conflict, and conflicts are disclosed to Compliance, not managed privately.

## Business development does not work alone

A business developer opens the door, but does not control everything beyond it — and should never promise as if they did. A client you win still has to be onboarded through full KYC, and the Compliance Officer must approve the file before the account is activated; you cannot promise to "skip the paperwork" or guarantee an account that has not cleared those checks. Orders the client places run through the firm's operational controls — the mandate, the pre-trade checklist, settlement — exactly like any other. This is not friction to be worked around; it is the machinery that makes the firm worth trusting in the first place. The most effective business developers treat compliance and operations as partners who protect the relationship, and they set client expectations honestly: what the firm can do, how it does it, and what the client will need to provide. Promising a client something the firm's controls will not allow is not winning business — it is setting up a broken promise.

## The bottom line

Business development at Transworld is the work of growing an institution whose product is trust. The mandate is real — the firm intends to grow — but it is bounded by honesty, suitability, and the knowledge that you carry the firm's reputation wherever you represent it. Win clients the right way: honestly, suitably, and for the long term. A book of business built that way compounds; one built on pressure and half-truths unwinds. The right way is always the best way — and in business development, it is also the only way that lasts.

---

*Foundational BD module · Tier B · function-head review on each annual cycle. Built on the Code of Ethics, the Employee Handbook, and the firm's pillars; conduct rules track the Code of Ethics and ISA 2024.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-101';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_01$id$, m.id, $p$What is the business-development mandate at Transworld?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To grow the client base and revenue by any means that works"},{"key":"b","text":"To grow the firm's client base and revenue ethically, sustainably, and in the client's genuine interest"},{"key":"c","text":"To maximize commission on each sale regardless of suitability"},{"key":"d","text":"To avoid winning new clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The mandate is ethical, sustainable growth in the client's genuine interest — not sales at any cost.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_02$id$, m.id, $p$Which two firm pillars sit most directly behind the BD mandate? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Growth-Oriented"},{"key":"b","text":"Ethical Profitability"},{"key":"c","text":"Reckless Expansion"},{"key":"d","text":"Compliance Avoidance"}]$o$::jsonb, $c$["a","b"]$c$::jsonb, $e$Growth-Oriented and Ethical Profitability are deliberately paired — growth pursued honestly.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_03$id$, m.id, $p$A client won through misrepresentation still counts as genuine growth for the firm.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A client won by misrepresentation is a liability that surfaces later as a complaint, a lost client, or a regulatory finding — not growth.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_04$id$, m.id, $p$When you are doing business development, whom do you represent?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Only yourself"},{"key":"b","text":"The whole institution — you are Transworld in the eyes of the person across the table"},{"key":"c","text":"Only your department"},{"key":"d","text":"The client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$In a BD interaction you represent the entire firm; what you say and do becomes, in that moment, what the firm is.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_05$id$, m.id, $p$How does the Code of Ethics describe the firm's reputation in the market?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The sole responsibility of the marketing team"},{"key":"b","text":"An asset that every member of staff shares responsibility for protecting"},{"key":"c","text":"Unimportant compared with revenue"},{"key":"d","text":"Owned only by the Managing Director"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Reputation is described as a shared asset every staff member is responsible for protecting — built slowly, lost quickly.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_06$id$, m.id, $p$The firm says 'the product is trust.' For a business developer, what does this mean?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"You are persuading someone to buy a product off a shelf"},{"key":"b","text":"You are asking a client to trust an institution with their financial life; that trust is earned by competence and honesty"},{"key":"c","text":"Trust is irrelevant to sales"},{"key":"d","text":"You should promise guaranteed returns"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$BD is not shelf-selling; it is asking a client to trust the firm with their financial life — trust earned by competence and honesty.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_07$id$, m.id, $p$What must happen before recommending any investment product to a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"An adequate suitability assessment of the client's needs, risk appetite, and circumstances"},{"key":"b","text":"Approval from the client's bank"},{"key":"c","text":"Nothing — recommend whatever pays the most commission"},{"key":"d","text":"A public announcement"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Recommendations must be suitable for the specific client; an adequate suitability assessment must precede any recommendation.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_08$id$, m.id, $p$Recommending an unsuitable product for personal gain may constitute a criminal offense under the ISA 2024.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Recommending an unsuitable product for personal gain is one of the most serious breaches a staff member can commit and may be criminal under the ISA 2024.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_09$id$, m.id, $p$Which behaviors does 'absolute honesty' require of a business developer? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Never making false, misleading, or deceptive statements"},{"key":"b","text":"Never omitting information a reasonable person would consider material"},{"key":"c","text":"Never letting someone believe something you know to be false, even through silence"},{"key":"d","text":"Stretching the truth if it helps close a sale"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Absolute honesty forbids false/misleading statements, material omissions, and letting a falsehood stand — stretching the truth is a breach.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_10$id$, m.id, $p$A client offers you a personal cash gift after you open their account. What must you do?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Accept it quietly"},{"key":"b","text":"Decline it, redirect it to the company account, notify your line manager, and complete the gift form (F-26) within 24 hours"},{"key":"c","text":"Keep it but tell a colleague"},{"key":"d","text":"Split it with the operations team"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Personal monetary appreciation is declined and redirected to the company account, the line manager notified, and F-26 completed within 24 hours.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_11$id$, m.id, $p$Who may make public statements on behalf of Transworld (media, press releases, published articles)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Any business developer"},{"key":"b","text":"Only the Managing Director and persons expressly designated in writing by the MD"},{"key":"c","text":"Any staff member with a social media account"},{"key":"d","text":"The client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Public statements on behalf of the firm are reserved to the MD and persons designated in writing by the MD.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_12$id$, m.id, $p$Can a business developer post personal investment recommendations or market commentary online without approval?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Yes, freely"},{"key":"b","text":"No — personal investment recommendations or market commentary require explicit Compliance approval, and public discussion of securities may require SEC registration"},{"key":"c","text":"Yes, as long as they don't name the firm"},{"key":"d","text":"Only on weekends"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Personal market commentary or recommendations require Compliance approval; publicly discussing specific securities may require SEC registration and disclosures.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_13$id$, m.id, $p$Hospitality or a gift that creates, or appears to create, an obligation is a conflict that should be disclosed to Compliance rather than managed privately.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Nothing of value should quietly change a decision made on the merits; such conflicts are disclosed to Compliance, not handled privately.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_14$id$, m.id, $p$How is the firm's growth ultimately best measured?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Only by the number of clients won"},{"key":"b","text":"By clients kept as well as won — a relationship opened honestly and served well is worth more than several opened on a promise the firm cannot keep"},{"key":"c","text":"By commission earned in the first month"},{"key":"d","text":"By the number of public statements made"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Growth is measured by clients kept, not just won; an honestly opened, well-served relationship outweighs ones opened on hollow promises.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_15$id$, m.id, $p$A prospective client asks you to 'skip the paperwork' so they can start trading today. What is the right response?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Agree, to win the business"},{"key":"b","text":"Explain that full KYC and Compliance approval are required before an account is activated; you cannot promise around the firm's controls"},{"key":"c","text":"Open the account and complete KYC later"},{"key":"d","text":"Tell them another firm will do it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$BD opens the door but cannot bypass controls; KYC and Compliance approval precede activation, and you must set expectations honestly.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_16$id$, m.id, $p$Why should a business developer treat Compliance and Operations as partners? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Their controls are the machinery that makes the firm worth trusting"},{"key":"b","text":"Promising around the controls sets up a broken promise"},{"key":"c","text":"They protect the client relationship the BD worked to win"},{"key":"d","text":"They exist only to slow the BD down"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Controls make the firm trustworthy and protect the relationship; promising around them backfires. They are partners, not obstacles.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_17$id$, m.id, $p$Why can't you honestly sell what you do not understand?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"You can — understanding is optional"},{"key":"b","text":"Because competence is an ethical obligation; misrepresenting or misexplaining a product you don't understand breaches honesty and suitability"},{"key":"c","text":"Because the client will not ask questions"},{"key":"d","text":"Because the MD forbids learning"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Staff must maintain the knowledge their role requires; you cannot honestly recommend or explain a product you do not understand.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_18$id$, m.id, $p$What does it mean that a business developer represents the firm 'outside the office' too?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Only office conduct matters"},{"key":"b","text":"Conduct at client premises, at industry events, and online — during and outside working hours where it touches the firm's business or reputation — also reflects on the firm"},{"key":"c","text":"Personal life is entirely separate in every case"},{"key":"d","text":"The rules apply only during meetings"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Code applies at client premises, events, and external settings, in and out of hours, where conduct touches the firm's business or reputation.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_19$id$, m.id, $p$The commission on a single unsuitable sale can be worth making if it is large enough.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The client is harmed, the firm is exposed, and the individual can face criminal liability under the ISA 2024 — there is no version of the math in which it pays.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv101_20$id$, m.id, $p$Beyond honesty and suitability, what else does a business developer owe in client dealings? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Disclose material information, including risks and conflicts"},{"key":"b","text":"Document significant client interactions, instructions, and advice"},{"key":"c","text":"Maintain the competence and registrations the role requires"},{"key":"d","text":"Pressure the client when a deal is slow to close"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Disclosure, documentation, and competence are all required; pressuring a client is expressly prohibited.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
