-- =============================================================================
-- seed_reg201_content.sql  (v0.60.0)
-- REG-201 AML/CFT program & transaction monitoring: lesson + 20-question check (Proficient, Tier A, FROM POLICY).
-- Authored from the firm's compliance source suite; teaches ISA 2025 (not 2007/2024).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO assignment rule: the role-and-grade matrix (seed_ws7_role_matrix.sql) already
-- maps REG-201 as REQUIRED to its job profiles; this is Proficient/role-targeted
-- content, NOT firmwide-mandatory, so no scope=ALL row is added.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$It is 9:02 on a Tuesday in Lagos and a transfer lands in a client's account. The amount is large, it comes from a name that is not the client's, and there is a polite instruction to buy a thinly traded stock and sell it again within the week. To the eye it is just business. It might be. It might also be the first visible step of someone moving criminal money through Transworld's membership of the Nigerian Exchange. The difference between those two readings is your job. You will not always get certainty — but you are expected to notice, to ask, and to escalate. This module is how.

## What you will be able to do

1. Explain why financial crime defense sits on every desk, not only with Compliance.
2. Apply the risk-based approach — match the depth of due diligence to the risk.
3. Read the red flags and the capital-market typologies that show up in our business.
4. Handle a Politically Exposed Person without freezing and without waving them through.
5. Carry a suspicion from your desk to the MLRO to the NFIU — and know the one thing you must never do.
6. Meet the firm's screening, record-keeping, and reporting obligations.

## Why this is your problem

Transworld is a licensed capital market operator and a dealing member of the Nigerian Exchange. We hold client money and we move it through a regulated market — which is exactly what makes us attractive to someone who needs to make dirty money look clean. Nigeria's framework is not advisory. The **Money Laundering (Prevention and Prohibition) Act 2022** criminalizes laundering, mandates customer due diligence, and — under the apex statute, the **Investments and Securities Act 2025** — the SEC supervises our compliance directly. The Nigerian Financial Intelligence Unit (NFIU) receives our reports. The penalties are not theoretical: a money-laundering offense carries a minimum of seven years' imprisonment for an individual, and the firm itself can be fined ₦25 million or more, on top of the licence consequences that would end the business.

Money laundering runs in three stages worth keeping in your head, because each leaves a different fingerprint. **Placement** puts criminal proceeds into the system — in our world, converting cash into securities. **Layering** moves the money through transactions to break the trail — trades through nominee accounts, funds consolidated from several sources, the market itself used to obscure where value came from. **Integration** returns the now-clean money to the owner as apparently legitimate gains. You are most likely to meet placement and layering, and they are the stages our controls are built to catch.

It helps to know what the law actually prohibits. The MLPPA frames three primary offences: concealing or disguising criminal property, helping another retain or use it, and acquiring or possessing it. You do not need to have stolen anything to be exposed — knowingly assisting the movement of someone else's criminal money is itself the crime, which is precisely why a member of staff who processes a transaction while turning a blind eye is at personal risk. Alongside laundering sit two related concerns the firm screens for: **terrorism financing**, where the worry is not the source of the money but its destination — even small, clean-looking sums routed to a prohibited purpose — and **proliferation financing**, the funding of weapons programs, which is why sanctions screening matters as much as source-of-funds work. The common thread is that you are watching both where money comes from and where it goes.

## The risk-based approach

We do not treat every client the same, and we are not meant to. The principle is **proportion**: the depth of your due diligence rises with the risk the relationship carries. Standard due diligence — verify identity, understand the purpose of the account, know the source of funds — is the floor for everyone. **Enhanced Due Diligence (EDD)** is required where the risk is higher: a Politically Exposed Person, a complex ownership structure, a client from a higher-risk jurisdiction, or a pattern that does not fit the profile you onboarded. EDD means more — senior sign-off to open or continue, deeper source-of-wealth evidence, and closer ongoing monitoring. The discipline is to *decide* the risk tier deliberately and write down why, not to default everyone to the middle.

Ongoing monitoring is the half of due diligence people forget. Onboarding is a photograph; the relationship is a film. A client who was low-risk at account opening can become high-risk the week their transactions stop matching their stated business. Monitoring is how you catch that, and it is continuous, not annual.

## Reading the signals

Red flags are not proof; they are prompts to look harder. Some are about the account — a reluctance to provide identification, an address that keeps changing, beneficial ownership that no one will name. Some are about the transaction — activity with no apparent economic purpose, sudden volume that does not fit the client's profile, funds arriving from or going to unrelated third parties.

A few typologies are specific to a firm like ours, and you should know them by name. **Structuring** (or smurfing) breaks a large sum into several smaller ones to stay just below the ₦5 million reporting threshold — a deliberate attempt to dodge detection that is itself a red flag. **Nominee abuse** uses an account in one name to trade for an unnamed principal who wants to stay invisible. **Wash-style trading** and rapid in-and-out trades in illiquid stocks can be used to manufacture a paper trail that launders the origin of funds. When you see the securities market being used to *obscure* where money came from rather than to invest, that is layering wearing a suit.

Two patterns deserve a closer look because they are easy to wave through. The first is the client whose trading has no apparent economic logic — buying and selling the same illiquid name at a loss, or churning a portfolio in a way that earns nothing but moves money around. Genuine investors are trying to make money; someone using the market to launder is often content to lose a little, because the loss is the price of cleaning the rest. The second is consolidation: funds arriving from several unrelated sources into one account before being moved out as a single clean balance. Each inbound piece might look ordinary; the pattern is the signal. Train yourself to look at the shape of activity over weeks, not just the single transaction in front of you, because the typology lives in the pattern.

## Politically Exposed Persons

A PEP is someone entrusted with a prominent public function — a senior official, a top executive of a state body, or their close associates and family. A PEP is not a criminal by definition, and we do not refuse them on sight. But the role carries a heightened risk of bribery and corruption proceeds, so a PEP relationship always sits in the EDD tier: senior management must approve opening or continuing it, you must establish source of wealth as well as source of funds, and you must monitor the relationship more closely throughout. The error to avoid runs in both directions — neither slamming the door nor nodding the client through because they are important.

## From alert to STR

This is the heart of the program. The legal trigger is **reasonable suspicion** — not proof, not certainty. If, on the facts in front of you, a reasonable person would suspect that funds or a transaction are linked to crime, the threshold is met, and you are obliged to act. You do not investigate it yourself and you do not decide guilt. You raise an internal report to the firm's **Money Laundering Reporting Officer (MLRO)**, promptly and in writing. The MLRO assesses it and, where the suspicion stands, files a **Suspicious Transaction Report (STR)** with the NFIU — the firm's obligation is to file within 24 hours of forming the suspicion. Where a periodic "nil" return is required and there is nothing to report, the firm files that too: silence is not the same as a clean report.

There is one absolute rule, and it has no exceptions: **never tip off**. You must not tell the client, or anyone outside the reporting chain, that a report has been made or is being considered. Tipping off is a criminal offense, it destroys the investigation, and it can put people at risk. If a client asks why their transaction is delayed, you do not improvise an explanation that hints at a report. You route the question to Compliance. Quiet escalation, never a warning.

## Sanctions and currency transactions

Two more obligations run alongside. **Sanctions screening** checks clients and counterparties against the applicable lists — United Nations, the relevant Nigerian designations, and others the firm specifies — at onboarding and on an ongoing basis. A confirmed match is not a judgment call: you freeze, you do not transact, and you report through Compliance. **Currency Transaction Reports (CTRs)** are threshold-based and mechanical — transactions at or above **₦5 million for individuals** and **₦10 million for corporates** are reported within 24 hours regardless of whether anything looks suspicious. A CTR is automatic; an STR is judgment. Do not confuse the two, and never let a client persuade you to split a transaction to keep it under the CTR line — that request is itself a structuring red flag.

## Records and returns

Everything you do here must be provable later. The MLPPA 2022 requires records to be kept for at least five years; Transworld holds transaction records for a minimum of seven. Your CDD evidence, your monitoring decisions, your internal reports, and the basis for a "no report" determination are all retained for regulatory review — because a control you cannot evidence is, to a regulator, a control that did not happen. On top of individual reports, the firm files periodic AML/CFT returns to its supervisors. Your part is to keep the underlying record clean and current so those returns are true.

## A worked example

**Illustration — the "Adaeze" account (entirely hypothetical).** A retail client onboarded a year ago as a modest salary-earner suddenly receives ₦4.8 million from a company she has no stated connection to, instructs you to buy a small-cap stock, and asks to sell within days. Days later a second ₦4.7 million arrives from a different third party with the same instruction. Walk it: the amounts sit just under the ₦5 million CTR line (structuring signal), the third-party sources do not fit her profile (red flag), and the rapid in-out trades in an illiquid name look like layering. You do not confront her, you do not guess. You document what you saw and raise an internal report to the MLRO the same day — and you keep serving her normally so nothing tips her off while the MLRO decides whether an STR is warranted.

## Common traps

- **Waiting for certainty.** The test is reasonable suspicion, not proof. If you wait until you are sure, you have waited too long.
- **Playing detective.** Your job is to escalate to the MLRO, not to investigate or to confront the client.
- **Tipping off by accident.** A helpful-sounding explanation of a delay can be a tip-off. Route the question, don't answer it.
- **Treating monitoring as a one-time event.** Risk changes after onboarding; the film matters more than the photograph.
- **Confusing CTR and STR.** One is an automatic threshold report; the other is a suspicion report. You may owe both, one, or neither.

## Key takeaways

- Financial crime defense is everyone's duty; the law (MLPPA 2022, ISA 2025) makes the firm and you personally accountable.
- Match due diligence to risk; PEPs and anomalies move to EDD with senior sign-off and source-of-wealth checks.
- Know the typologies — structuring, nominees, layering through illiquid trades — and treat red flags as prompts to look harder.
- On reasonable suspicion, report internally to the MLRO promptly; the firm files the STR with the NFIU within 24 hours.
- Never tip off — it is a crime. File CTRs at ₦5m/₦10m automatically. Keep every record provable.

*Reference: AML/CFT/CPF Policy v3.0 and Compliance Manual v3.0 (Transworld). Governing law: Money Laundering (Prevention and Prohibition) Act 2022 and the Investments and Securities Act 2025; reports are filed with the NFIU. This module is a navigation aid; the policies and the law are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'REG-201';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_01$id$, m.id, $p$A transfer arrives in a client account from an unrelated third party, with an instruction to buy and quickly sell an illiquid stock. What is the right first response?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Refuse the trade and tell the client you suspect money laundering"}, {"key": "b", "text": "Process it normally; third-party funding is routine"}, {"key": "c", "text": "Note what you observed and raise an internal report to the MLRO, while continuing to serve the client normally"}, {"key": "d", "text": "Investigate the third party yourself before doing anything"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$You neither confront/refuse on suspicion alone nor wave it through. You escalate internally to the MLRO and avoid tipping off by continuing to serve normally.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_02$id$, m.id, $p$What legal threshold obliges you to act on a possible laundering concern?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Proof beyond reasonable doubt"}, {"key": "b", "text": "Reasonable suspicion"}, {"key": "c", "text": "A confession from the client"}, {"key": "d", "text": "A regulator's instruction"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The trigger is reasonable suspicion — what a reasonable person would suspect on the facts — not proof or certainty.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_03$id$, m.id, $p$Which sequence correctly orders the three stages of money laundering?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Layering, placement, integration"}, {"key": "b", "text": "Placement, layering, integration"}, {"key": "c", "text": "Integration, layering, placement"}, {"key": "d", "text": "Placement, integration, layering"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Placement puts criminal proceeds into the system, layering breaks the trail, integration returns the cleaned money as apparent legitimate gains.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_04$id$, m.id, $p$A client asks you to split a ₦9 million transfer into two payments of ₦4.6m and ₦4.4m. This is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sensible cash-flow management"}, {"key": "b", "text": "structuring \u2014 a red flag, since it keeps each below the \u20a65m CTR threshold"}, {"key": "c", "text": "a normal client preference you should accommodate"}, {"key": "d", "text": "a tax-planning matter for Finance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Splitting to stay under the ₦5 million CTR threshold is structuring (smurfing) — itself a red flag, and never something you accommodate.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_05$id$, m.id, $p$Tipping off a client that a report has been made (or is being considered) is acceptable if you do it tactfully.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Never. Tipping off is an absolute prohibition and a criminal offense; route any client question to Compliance rather than hinting at a report.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_06$id$, m.id, $p$What is the difference between a CTR and an STR?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "They are two names for the same report"}, {"key": "b", "text": "A CTR is an automatic threshold-based report; an STR is a judgment-based suspicion report"}, {"key": "c", "text": "A CTR is filed by Compliance; an STR is filed by the client"}, {"key": "d", "text": "An STR is automatic; a CTR depends on suspicion"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A CTR is mechanical (₦5m individuals / ₦10m corporates, filed regardless of suspicion); an STR rests on reasonable suspicion.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_07$id$, m.id, $p$The CTR reporting thresholds at Transworld are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "\u20a61 million for everyone"}, {"key": "b", "text": "\u20a65 million (individuals) and \u20a610 million (corporates)"}, {"key": "c", "text": "\u20a610 million for everyone"}, {"key": "d", "text": "There is no fixed threshold"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Transactions at or above ₦5 million (individuals) and ₦10 million (corporates) are reported as CTRs within 24 hours.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_08$id$, m.id, $p$A Politically Exposed Person wants to open an account. The correct posture is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "refuse \u2014 PEPs are too risky to onboard"}, {"key": "b", "text": "onboard like any other client to avoid offending them"}, {"key": "c", "text": "apply Enhanced Due Diligence: senior approval, source-of-wealth checks, and closer ongoing monitoring"}, {"key": "d", "text": "ask the PEP to use a nominee account instead"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A PEP is not automatically a criminal, but the heightened corruption risk puts the relationship in the EDD tier with senior sign-off.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_09$id$, m.id, $p$Under the risk-based approach, due diligence should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "identical for every client"}, {"key": "b", "text": "proportionate to the risk the relationship carries"}, {"key": "c", "text": "as light as possible to speed onboarding"}, {"key": "d", "text": "decided solely by the size of the first deposit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The depth of due diligence rises with risk; higher-risk relationships move to Enhanced Due Diligence.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_10$id$, m.id, $p$Ongoing monitoring matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "onboarding checks are enough on their own"}, {"key": "b", "text": "a client's risk can change after onboarding when transactions stop matching their profile"}, {"key": "c", "text": "it is only required for PEPs"}, {"key": "d", "text": "the regulator files it for us"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Onboarding is a photograph; the relationship is a film. Monitoring catches risk that emerges after account opening.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_11$id$, m.id, $p$Who do you report a suspicion to inside the firm?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The client's relationship manager"}, {"key": "b", "text": "The Money Laundering Reporting Officer (MLRO)"}, {"key": "c", "text": "The NFIU directly"}, {"key": "d", "text": "The trading desk head"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Internal suspicions go to the MLRO, who assesses them and files the STR with the NFIU where the suspicion stands.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_12$id$, m.id, $p$Within what window must the firm file an STR with the NFIU after forming a suspicion?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "30 days"}, {"key": "b", "text": "7 days"}, {"key": "c", "text": "24 hours"}, {"key": "d", "text": "There is no time limit"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The firm's obligation is to file the STR with the NFIU within 24 hours of forming the suspicion.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_13$id$, m.id, $p$Using an account in one name to trade for an unnamed principal who wishes to stay invisible is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "normal delegated trading"}, {"key": "b", "text": "nominee abuse \u2014 a laundering typology and a red flag"}, {"key": "c", "text": "only a problem if the amounts are large"}, {"key": "d", "text": "acceptable with a verbal authorization"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A nominee account hiding an unnamed principal is a layering typology and a clear red flag requiring escalation.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_14$id$, m.id, $p$If there is nothing suspicious to report in a period, the firm files nothing at all.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Where a periodic 'nil' return is required, the firm files it; silence is not the same as a clean report.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_15$id$, m.id, $p$A confirmed sanctions-list match on a counterparty means you should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "proceed but flag it for review next quarter"}, {"key": "b", "text": "freeze, do not transact, and report through Compliance"}, {"key": "c", "text": "ask the client to confirm they are not the sanctioned party"}, {"key": "d", "text": "reduce the transaction below the CTR threshold"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A confirmed sanctions match is not a judgment call — you freeze, do not transact, and report through Compliance.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_16$id$, m.id, $p$Nigeria's principal anti-money-laundering statute is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Investments and Securities Act 2025"}, {"key": "b", "text": "Money Laundering (Prevention and Prohibition) Act 2022"}, {"key": "c", "text": "Companies and Allied Matters Act"}, {"key": "d", "text": "NGX Dealing Members' Rules"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The MLPPA 2022 is the principal AML law; ISA 2025 is the apex capital-market statute under which the SEC supervises us.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_17$id$, m.id, $p$How long must AML records be retained?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "One year"}, {"key": "b", "text": "At least five years under the MLPPA, with the firm holding transaction records at least seven"}, {"key": "c", "text": "Only until the relationship ends"}, {"key": "d", "text": "There is no retention requirement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The MLPPA 2022 requires at least five-year retention; Transworld holds transaction records for a minimum of seven years.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_18$id$, m.id, $p$'Layering' in a capital-market context most often looks like...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a single large cash deposit"}, {"key": "b", "text": "trades through nominee accounts or rapid in-and-out trades that obscure the origin of funds"}, {"key": "c", "text": "a client asking for a research report"}, {"key": "d", "text": "a normal dividend payment"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Layering uses transactions — nominees, consolidations, illiquid in-and-out trades — to break the trail between money and its criminal source.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_19$id$, m.id, $p$Your role when you spot a possible laundering pattern is to investigate it fully and confront the client.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$You do not investigate or confront. You document what you saw and escalate to the MLRO, who decides on a report.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg201_20$id$, m.id, $p$Why does financial-crime defense sit on every desk, not only with Compliance?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Because Compliance is short-staffed"}, {"key": "b", "text": "Because front-line staff see the transactions and behavior first, and the law makes the firm and individuals accountable"}, {"key": "c", "text": "Because it is optional for non-Compliance staff"}, {"key": "d", "text": "Because the NGX requires every employee to be an MLRO"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The people closest to the transaction notice first; and the MLPPA 2022 and ISA 2025 make the firm and individuals personally accountable.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'REG-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: REG-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'REG-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: REG-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: REG-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
