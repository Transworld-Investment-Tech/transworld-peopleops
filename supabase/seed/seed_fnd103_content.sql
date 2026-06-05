-- =============================================================================
-- seed_fnd103_content.sql -- FND-103 Code of Conduct & Ethics: lesson + 20-question check (v0.42.x content)
-- Authored from Code of Ethics CO-POL-001 v1.0 (March 2026). Tier A (CCO-owned).
-- DATA, not schema. Run AFTER 0031 + seed_fnd_lms.sql. Idempotent (upsert by id).
-- Pass mark 80%% already set on the module by seed_fnd_lms.sql; reaffirmed here.
-- =============================================================================

BEGIN;

-- 1. lesson body + ensure published with the graded-check pass mark
UPDATE "learning_modules"
SET body = $body$We are in the business of trust. Clients hand us their capital and their financial futures; regulators hand us a licence to operate in Nigeria's capital markets; the investing public trusts that everyone in those markets behaves with integrity. That trust is never automatic. It is built one honest transaction, one careful conversation, one correct decision at a time — and it is lost far more easily than it is earned.

The **Code of Ethics and Professional Conduct (CO-POL-001)** is how Transworld protects that trust. This module walks you through what the Code requires of you. The Code is not a set of suggestions or aspirations — every provision is a **binding obligation**, and it applies to everyone, from the newest officer to the most senior director. By the end, you should know what the standard is, where the bright lines are, and — just as important — what to do the moment you are unsure.

## What you will be able to do

1. Explain who the Code binds and why your obligation under it is personal and cannot be delegated.
2. Recognize the firm's core values and apply the "front-page test" when no specific rule fits.
3. Identify the bright-line prohibitions — insider trading, market manipulation, bribery, and misappropriation of client assets — and the consequences of crossing them.
4. Know the right first action whenever you are uncertain: stop, and seek guidance from Compliance.

## The Code binds everyone — and the obligation is personal

The Code applies, without exception, to **all staff at every level**, to directors and Board members, to interns and secondees, and to any agent, contractor, or third party acting on the firm's behalf or with access to its systems, client data, or market information. It governs your conduct in the office, at a client's premises, at an industry event, and anywhere else you are connected with Transworld — including outside working hours where your conduct touches the firm's business or reputation.

Crucially, compliance is a **personal obligation that you cannot delegate**. *"I was only following instructions"* is **not** a defence to an ethics breach. If anyone — however senior — instructs you to do something you believe breaches the Code, the law, or a regulatory requirement, you must decline and report it to the Head of Compliance or the Managing Director. Refusing an unethical instruction is your right; retaliating against someone who refuses one is itself a serious offence.

The Code sits at the **top of the firm's policy hierarchy**. Every other policy — the Compliance Manual, AML/CFT, KYC, Whistleblower, Gift & Benefit — operates beneath it. Where a specific policy and the Code seem to differ, the **more restrictive standard applies.**

**Annual acknowledgement.** Everyone within scope must read the Code and sign the Annual Acknowledgement at the start of each calendar year. New joiners sign within **five (5) working days** of starting. Your signed acknowledgement is kept on file and is available to internal audit and to any regulator.

## The nine values — and the test that never fails you

Everything in the Code flows from nine core values: **Integrity, Client First, Excellence, Independence, Accountability, Teamwork, Confidentiality, Respect, and Compliance.** When you hit an ethical question that no specific rule answers, return to the values and ask which choice best reflects all nine.

And when even that feels uncertain, use the front-page test:

> **The front-page test.** Before any action that gives you pause, ask: "If this appeared on the front page of a newspaper tomorrow, would I be proud of it?" If the answer is anything other than an unequivocal yes — stop, and seek guidance. Doing nothing and asking for help is always the right first move.

## Honesty, every day

You must be **completely honest** in every dealing — with clients, colleagues, regulators, and counterparties. In practice that means never making a false or misleading statement; never omitting information a reasonable person would consider material; making sure every record or report you prepare or sign is accurate and complete; and **correcting any error the moment you discover it**, even when that is uncomfortable. Letting someone believe something you know to be false — even through silence — is a breach.

When advising clients, recommend only what is **suitable** for that client's needs, risk appetite, and circumstances. Recommending an unsuitable product for personal gain is one of the most serious breaches you can commit and may be a criminal offence under the ISA 2024.

## Conflicts of interest: disclose early, in writing

A conflict of interest arises whenever a personal, financial, or family interest *could* influence — or could reasonably be *seen* to influence — your professional judgment. Examples: a financial interest in a client or competitor; a close relationship with a supplier or regulator; secondary employment; or approving a transaction you benefit from.

Your duty is simple: **disclose all actual, potential, or perceived conflicts promptly in writing to the Head of Compliance** — when you join, the moment a new one arises, and at each annual acknowledgement. *Do not wait for a conflict to "become a problem."* Early disclosure protects both you and the firm. Separately, you must get **prior written approval from the Managing Director** before taking any outside directorship, secondary employment, or business venture, and personal-account trades in NGX-listed securities must be pre-approved by Compliance.

> This is the Code's summary of conflicts. The full framework — conflict categories, management measures, and the disclosure forms — lives in the dedicated **Conflicts of Interest** module (FND-107) and the Conflict of Interest Policy (CO-POL-002).

## Market integrity: the bright lines

A fair, transparent market is the foundation of everything we do, and Nigerian law makes attacks on it **criminal offences**.

**Insider trading is absolutely prohibited — for everyone, at all times.** That means trading, or helping anyone else trade, on the basis of **material non-public information (MNPI)**: information a reasonable investor would consider significant (undisclosed earnings, a pending merger, a regulatory approval, a dividend decision) that has not yet been released to the market through a proper channel. Receiving MNPI — from any source — never makes you free to act on it. **Tipping** (passing MNPI to someone else) is equally serious: you do **not** need to trade yourself to be guilty.

>! **Criminal offence.** Under the ISA 2024, insider trading carries imprisonment of up to ten (10) years, heavy fines, industry disqualification, and disgorgement of all profits. No commercial advantage is worth that risk.

**Market manipulation is equally forbidden** — including **wash trading** (trades with no real change of ownership to fake activity), **spoofing** (large orders you never intend to execute), **front-running** (trading ahead of a client's order), **painting the tape** (a series of trades to move a price artificially), and spreading false information about a security.

>! **If you receive information that may be material and non-public:** stop. Do not trade. Do not share it. Consult the Head of Compliance immediately.

## The client comes first

Our clients place their financial wellbeing in our hands — a relationship of trust, not just a transaction. Before any service, the required **KYC** must be complete and current. When executing orders, seek **best execution** — the best available terms on price, speed, and likelihood — and never route an order to serve the firm's or your own interest at the client's expense. Treat all clients **fairly and equally**; never let a personal relationship produce preferential treatment that disadvantages others.

>! **Zero tolerance.** Client assets must always be held separately from the firm's own. Misappropriating client assets — borrowing, using, lending, or pledging them without explicit authorization — is a criminal offence, grounds for immediate dismissal, and will be referred to the SEC and law enforcement.

## Bribery and corruption: zero tolerance

Transworld has a **zero-tolerance** stance on bribery and corruption in any form — bribes given or received, kickbacks, and **facilitation payments** (small unofficial payments to speed up a routine process) are all prohibited, regardless of value or apparent benefit. The prohibition is especially strict for **public officials**, including employees of the SEC, NGX, CBN, and NFIU. Watch for warning signs: an unusually high fee with no commercial logic, demands for payment in cash or to an odd account, or pressure to overlook an irregular transaction. If anyone approaches you with what may be a corrupt proposition, **decline immediately, document it, and report it to Compliance** — and never try to manage it alone.

## Confidentiality, data, and AML — in brief

You owe a **strict duty of confidentiality** over all client and firm information, and that duty **continues after you leave the firm**, with no time limit. A suspected **personal data breach** must be reported to IT and Compliance **within 24 hours**. And every staff member — whatever the role — has **AML/CFT obligations**: report any suspicious activity to the Money Laundering Reporting Officer (MLRO) immediately; **suspicion alone is enough** to trigger the duty, you do not need proof; and **never "tip off"** a client that a report has been or may be made — tipping off is itself a criminal offence. (These areas have their own dedicated modules — AML/CFT & KYC, Data Protection, and Confidentiality & Information Security — that go deeper.)

## Conduct, gifts, resources, and your public voice

Treat everyone with **dignity and respect**; harassment, bullying, discrimination, and any physical or aggressive confrontation are serious disciplinary matters. **Personal acceptance of gifts, cash, airtime, or any benefit from clients is prohibited**, regardless of value — politely decline, redirect the client to the firm's official account, notify your line manager, and file Form **F-26 within 24 hours**. Use company assets only for legitimate business. And remember that **only the Managing Director, or those expressly designated in writing by the MD**, may speak publicly for the firm — never share confidential information or make market commentary in a personal capacity without Compliance approval.

## Speaking up is protected

If you see something wrong, **say something.** Reporting genuine concerns is both an obligation and a protected right — it is not disloyalty; it is how we protect clients, colleagues, and the firm. You can report to the Head of Compliance/MLRO, the Managing Director, the Chairman or Board Audit, Risk & Compliance Committee, or directly to the SEC.

> **You are protected.** Retaliation against anyone who makes a genuine whistleblowing report results in summary dismissal of the person responsible. Reporting in good faith cannot be used against you.

---

## When things go wrong

Breaches are handled by their severity. **Category A (minor)** — a genuine, low-impact error, promptly disclosed — typically means a written warning and retraining. **Category B (serious)** — repeated or deliberate breaches, failure to disclose, or conduct causing harm — can mean a final warning, suspension, or demotion. **Category C (gross misconduct)** — insider trading, manipulation, fraud, bribery, misappropriation, a deliberate data breach, or retaliation against a whistleblower — means **summary dismissal and referral to the SEC, NFIU, or EFCC**, with criminal prosecution where applicable. Remember: where a breach follows an instruction, **both** the person who gave it and the person who followed it can be disciplined.

## Key takeaways

- The Code binds everyone and your obligation is **personal** — *"I was following instructions"* is never a defence.
- When no rule fits, use the **nine values** and the **front-page test**.
- **Insider trading and tipping, market manipulation, bribery, and misappropriation of client assets** are bright-line, often criminal, offences.
- **Disclose conflicts early, in writing, to Compliance**; get **MD approval** before any outside business.
- Report suspicious activity to the **MLRO** on suspicion alone, and **never tip off**.
- A data breach is a **24-hour** report; a client gift is **declined** and logged on **F-26 within 24 hours**.

> Whenever you are unsure, **stop and ask Compliance** — that is always the right first move.

## References

- **Code of Ethics & Professional Conduct (CO-POL-001), v1.0, March 2026** — primary source for this module.
- Companion: Compliance Manual v3.0 (§15 Standards of Conduct); Conflict of Interest Policy CO-POL-002 v3.0 (see the *Conflicts of Interest* module, FND-107).
- Regulatory basis: ISA 2024; SEC Rules; NGX Dealing Members' Rules 2015; AML/CFT Act 2022; NDPA 2023; NCCG 2018.
- *Mandatory module · annual refresh. Content owner: Chief Compliance Officer. Last reviewed against CO-POL-001 on authoring; re-verify at each annual cycle.*
$body$,
    pass_mark = 80,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-103';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_01$id$, m.id, $p$Who is bound by the Code of Ethics and Professional Conduct?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only permanent employees"}, {"key": "b", "text": "Only client-facing staff and dealing representatives"}, {"key": "c", "text": "All staff at every level, directors, interns, and any contractor or agent acting for the firm"}, {"key": "d", "text": "Everyone except the Board of Directors"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Code applies without exception to all staff, directors, Board members, interns, secondees, and any agent or contractor acting on the firm's behalf.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_02$id$, m.id, $p$'I was only following instructions' is a valid defence to a breach of the Code.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Compliance is a personal, non-delegable obligation. You must decline an unethical instruction and report it; following orders is no defence.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_03$id$, m.id, $p$Within what time must a new joiner complete the Annual Code Acknowledgement?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "24 hours"}, {"key": "b", "text": "5 working days"}, {"key": "c", "text": "30 days"}, {"key": "d", "text": "Before the next calendar year"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$New joiners sign within five (5) working days of starting; everyone re-signs at the start of each calendar year.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_04$id$, m.id, $p$Where a specific policy appears to conflict with the Code, which standard applies?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The specific policy always wins"}, {"key": "b", "text": "The Code always wins outright"}, {"key": "c", "text": "The more restrictive standard applies"}, {"key": "d", "text": "Whichever the line manager chooses"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Code sits atop the policy hierarchy; where any policy and the Code differ, the more restrictive standard applies.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_05$id$, m.id, $p$Which of the following are among Transworld's nine core values? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Integrity"}, {"key": "b", "text": "Client First"}, {"key": "c", "text": "Profitability"}, {"key": "d", "text": "Independence"}, {"key": "e", "text": "Speed-to-market"}]$o$::jsonb, $c$["a", "b", "d"]$c$::jsonb, $e$The nine values are Integrity, Client First, Excellence, Independence, Accountability, Teamwork, Confidentiality, Respect, and Compliance. Profitability and speed-to-market are not among them.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_06$id$, m.id, $p$The 'front-page test' asks you to consider whether...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the action is technically legal"}, {"key": "b", "text": "you would be proud if the action appeared on the front page of a newspaper tomorrow"}, {"key": "c", "text": "your manager approved it"}, {"key": "d", "text": "the client agreed in writing"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$If you would not be unequivocally proud to see it on tomorrow's front page, stop and seek guidance.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_07$id$, m.id, $p$It is acceptable to trade on material non-public information as long as you did not obtain it illegally.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Receiving MNPI from any source never makes you free to act on it. Insider trading is prohibited regardless of how the information reached you.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_08$id$, m.id, $p$Under the ISA 2024, insider trading can carry imprisonment of up to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "1 year"}, {"key": "b", "text": "5 years"}, {"key": "c", "text": "10 years"}, {"key": "d", "text": "there is no custodial penalty"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Insider trading is a criminal offence carrying up to ten (10) years' imprisonment, plus fines, disqualification, and disgorgement of profits.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_09$id$, m.id, $p$Which of the following are prohibited forms of market manipulation? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Wash trading"}, {"key": "b", "text": "Spoofing"}, {"key": "c", "text": "Best execution"}, {"key": "d", "text": "Front-running"}, {"key": "e", "text": "Painting the tape"}]$o$::jsonb, $c$["a", "b", "d", "e"]$c$::jsonb, $e$Wash trading, spoofing, front-running, and painting the tape are all prohibited. Best execution is an obligation owed to clients, not manipulation.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_10$id$, m.id, $p$You must trade yourself to be guilty of a market-abuse offence.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Tipping — passing MNPI to another person — is an offence whether or not you or they go on to trade.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_11$id$, m.id, $p$You receive information that may be material and non-public. What should you do?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Trade quickly before it becomes public"}, {"key": "b", "text": "Share it only with your immediate team"}, {"key": "c", "text": "Stop, do not trade, do not share it, and consult the Head of Compliance"}, {"key": "d", "text": "Wait 24 hours, then trade"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Stop, do not trade, do not share, and consult Compliance. Doing nothing and seeking guidance is always the right first step.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_12$id$, m.id, $p$How must a conflict of interest be disclosed?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Verbally to a colleague"}, {"key": "b", "text": "Promptly, in writing, to the Head of Compliance"}, {"key": "c", "text": "Only if it later becomes an actual problem"}, {"key": "d", "text": "At your exit interview"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$All actual, potential, or perceived conflicts must be disclosed promptly in writing to the Head of Compliance.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_13$id$, m.id, $p$You should wait until a conflict of interest actually becomes a problem before disclosing it.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$The duty to disclose arises the moment you become aware of the potential conflict — early disclosure protects you and the firm.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_14$id$, m.id, $p$Before accepting an outside directorship or secondary employment, you must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "simply inform your line manager"}, {"key": "b", "text": "obtain prior written approval from the Managing Director"}, {"key": "c", "text": "do nothing — outside roles are your private business"}, {"key": "d", "text": "get the client's consent"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Outside directorships, secondary employment, and business ventures require prior written approval from the Managing Director.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_15$id$, m.id, $p$Borrowing or using client assets without explicit authorization is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "acceptable if repaid quickly"}, {"key": "b", "text": "a minor breach handled by a warning"}, {"key": "c", "text": "a criminal offence and grounds for immediate dismissal, with referral to the SEC and law enforcement"}, {"key": "d", "text": "permitted with line-manager approval"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Client assets must always be segregated. Misappropriation carries zero tolerance: criminal offence, immediate dismissal, and regulatory/law-enforcement referral.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_16$id$, m.id, $p$A small unofficial payment to a government clerk to speed up a routine approval is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "acceptable because it is small"}, {"key": "b", "text": "acceptable if documented"}, {"key": "c", "text": "a prohibited facilitation payment that must be declined and reported"}, {"key": "d", "text": "acceptable for non-Nigerian officials only"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Facilitation payments are prohibited regardless of size. Decline, document the approach, and report it to Compliance.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_17$id$, m.id, $p$A client insists on personally thanking you with a cash gift. What must you do? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Decline personal receipt politely but firmly"}, {"key": "b", "text": "Accept it if it is below a small threshold"}, {"key": "c", "text": "Redirect the client to the firm's official corporate account"}, {"key": "d", "text": "Notify your line manager and complete Form F-26 within 24 hours"}]$o$::jsonb, $c$["a", "c", "d"]$c$::jsonb, $e$Personal acceptance of any gift or cash from a client is prohibited regardless of value. Decline, redirect to the corporate account, notify your manager, and file F-26 within 24 hours.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_18$id$, m.id, $p$A suspected personal-data breach must be reported to IT and Compliance within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "1 hour"}, {"key": "b", "text": "24 hours"}, {"key": "c", "text": "7 days"}, {"key": "d", "text": "the next monthly report"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suspected personal-data breaches must be reported to IT and the Head of Compliance within 24 hours of discovery.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_19$id$, m.id, $p$A genuine suspicion — without proof — is enough to trigger your duty to report a suspicious transaction.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["t"]$c$::jsonb, $e$You do not need certainty. A genuine suspicion is sufficient; report it to the MLRO, who decides whether to file an STR.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd103_20$id$, m.id, $p$You receive an inspection notice or document request from a regulator. What must you do first?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Respond directly and promptly yourself"}, {"key": "b", "text": "Report it to the Head of Compliance before making any response"}, {"key": "c", "text": "Forward it to the client"}, {"key": "d", "text": "File it and wait for a reminder"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Any regulatory contact must be reported to the Head of Compliance immediately and before any response is made.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;