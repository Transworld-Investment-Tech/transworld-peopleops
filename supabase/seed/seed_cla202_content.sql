-- =============================================================================
-- seed_cla202_content.sql  (v0.64.0)
-- CLA-202: Enhanced Due Diligence & complex onboarding — lesson + 20-question check (Proficient).
-- Authored FROM POLICY (Tier A) off the firm's own policies (read-first OCR; anchors confirmed).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps CLA-202 to live job profiles (confirm live: verify_p5.sql / matrix query).
--   Publish-only (the REG/OPS pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Standard onboarding is enough for most clients. This module is about the ones it is not enough for — the politically exposed person, the corporate hiding behind a nominee, the offshore parent, the client whose money moves in patterns their declared profile cannot explain. For these, the file escalates from ordinary customer due diligence to Enhanced Due Diligence (EDD), and the Compliance Officer must approve the account before it is activated. A clean note on scope first: this module is the client-facing onboarding view — how the relationship officer recognises and works a complex case. The firm's AML/CFT programme and transaction monitoring as a whole belong to the compliance-function module REG-201; here we lean on that programme only as the reason EDD exists, and do not repeat it.

## What you will be able to do

1. Place a new client in the three-tier KYC framework and assign a risk classification.
2. Recognise every mandatory EDD trigger and the action each one demands.
3. Trace beneficial ownership through corporate, nominee, and trust structures to natural persons.
4. Explain why an inactive-account re-activation is an EDD event, and handle the extra data lawfully.
5. Know where the AML programme connects — STRs, tipping off, sanctions — without owning it.

## The three-tier framework and the risk classification

Every client is placed in one of the SEC's three KYC tiers by the documentation provided and the transaction limits that apply: Tier 1 is basic, Tier 2 standard, and Tier 3 full. Tiering, though, is not the same as risk. At onboarding every client is also assigned a risk classification that governs the depth of due diligence, the frequency of KYC review, and the intensity of monitoring for the whole relationship. A salary-employed Nigerian resident with a modest, regular profile is low risk — Tier 1 or low Tier 2, reviewed every thirty-six months. A self-employed client or a corporate with some ownership complexity is medium — Tier 2, reviewed every twenty-four months. A PEP, a client from a high-risk jurisdiction, a corporate with opaque ownership, or a high-value investor is high — Tier 3 with full EDD, reviewed every twelve months. The classification is recorded in the client file and the system, and the Compliance Officer reviews and approves it; it is not a label the relationship officer sets alone. The classification is the engine of a risk-based approach: diligence is proportionate, so you neither under-diligence a high-risk client to save time nor smother a plainly low-risk one in paperwork that adds no protection. It also drives the refresh cycle — high-risk files are reviewed every twelve months, medium every twenty-four, low every thirty-six — so a client who looked low-risk at onboarding but whose behaviour changes is re-rated rather than left on an outdated label. Risk classification is therefore not a one-time stamp but a living judgement that the file must keep earning.

## The mandatory EDD triggers

EDD is not discretionary. When any of the following is present, the standard process automatically escalates and the Compliance Officer must approve the account before activation. A **politically exposed person** — or the family member or close associate of one — requires senior-management approval, source-of-wealth documentation, enhanced monitoring with monthly transaction review, a monthly PEP return to the NFIU, and an annual enhanced review. A client from, or with significant connections to, a **high-risk jurisdiction** (FATF grey- or black-listed) requires additional identity verification, an explanation of the source of funds flowing through that jurisdiction, and Compliance Officer approval. A **corporate with complex or opaque ownership** requires full beneficial-ownership tracing to natural persons, identity and BVN verification for each ultimate beneficial owner, and Compliance sign-off on the ownership-structure map. A client whose **transactions are inconsistent with their declared profile** requires a written explanation, Compliance review, an updated risk assessment, and possibly a suspicious-transaction report. An **inactive-account re-activation after three or more years** triggers the full re-engagement procedure. A **high-value client** — Tier 3 with expected volumes above ₦10 million per month — requires source-of-wealth documentation, a tax clearance certificate, and regular monitoring. And a **trust or nominee arrangement** requires identifying the actual beneficial owner, verifying that the nominee is legally authorised, and separate identity and BVN verification for the beneficial owner.

## Seeing through the structure

The hardest skill in complex onboarding is refusing to stop at the first name on the form. Beneficial ownership means the natural person who ultimately owns or controls the client — never a holding company, never a nominee. Tracing means following the layers until you reach human beings, verifying each with identification and a Bank Verification Number checked through the NIBSS portal, and recording the ownership map for the Compliance Officer to sign off. The same discipline distinguishes two ideas people blur: source of funds is where the money for this transaction came from; source of wealth is how the client accumulated their overall assets. For a high-value or PEP file you need both, and a tax clearance certificate is one of the documents that evidences source of wealth. None of this is box-ticking. An NGX inspection of the Firm's files found expired identification, missing utility bills, and absent BVN verification across every file reviewed, which is exactly why the KYC Deficiency Correction Programme now runs a structured remediation against a completeness score — and why a thin EDD file is treated as a live risk, not a paperwork gap.

## The documents that prove identity

EDD sits on top of ordinary identification, and the inspection showed that even the ordinary layer cannot be assumed. Across every file reviewed it found four recurring gaps: expired or absent government-issued photo identification, missing proof of address, no BVN portal-verification evidence — the single most common deficiency — and missing utility bills. The standard file therefore requires a valid government-issued photo identification, a proof of address such as a utility bill no older than three months, a source-of-funds declaration, and BVN verification evidenced from the NIBSS portal with a screenshot or system record. The KYC Completeness Score measures each file against that checklist, and the KYC Deficiency Correction Programme works the existing client base in priority order — Critical, then High, then Standard — until every file is complete. For an EDD client the bar is higher still, but it begins here: you cannot build enhanced diligence on a foundation of missing basics, and a verbal assurance that a document "exists somewhere" is not verification.

## Re-activation is an onboarding event

It is tempting to treat a returning client as an old friend, but a dormant account being re-activated after three or more years is, for due-diligence purposes, a new onboarding. The client's circumstances, the regulatory landscape, and the money-laundering typologies have all moved on, and a dormant account is a known vehicle for laundering precisely because it draws little attention. The Inactive Accounts Policy therefore routes re-activation through the full re-engagement procedure with enhanced due diligence, and the file does not move until Compliance is satisfied.

## Where the AML programme connects

EDD lives inside the firm's AML/CFT framework, governed by the Money Laundering (Prevention and Prohibition) Act 2022 and the Terrorism (Prevention and Prohibition) Act 2022. You do not run that programme from the onboarding desk, but you must know its edges. When something does not add up, you escalate, and a suspicious-transaction report is filed to the Nigerian Financial Intelligence Unit by the compliance function — and you never tip off the client that a report has been made or contemplated; the prohibition on tipping off is absolute. Sanctions screening happens at onboarding against the applicable lists, and a positive hit stops the account. Record-keeping is long: EDD files are retained for seven years from the end of the client relationship.

It helps to know the shapes the law is watching for. Money laundering moves in three stages — placement of illicit funds into the system, layering to disguise their origin, and integration back into the legitimate economy — and the onboarding desk is the Firm's first and best chance to refuse the placement. Two reporting duties sit beside the STR. A Currency Transaction Report is filed for cash transactions at or above ₦5 million for individuals and ₦10 million for corporates; and a client who deliberately breaks activity into amounts just below those thresholds is structuring, which is itself a red flag rather than a convenience. Recognising these patterns at onboarding — alongside profile-inconsistent activity, reluctance to provide ownership detail, and unexplained third-party funding — is the whole point of EDD: the time to ask the hard questions is before the account is live, not after the money has moved.

## Handling the extra data lawfully

EDD asks clients for unusually sensitive information — sources of wealth, ownership structures, identity documents for third parties. That data is governed by the Nigeria Data Protection Act 2023 and the General Application and Implementation Directive 2025, supervised by the Nigeria Data Protection Commission. You collect it on a lawful basis (here, legal obligation), you collect only what the EDD requirement actually needs, you keep it secure, and you retain it under the schedule rather than indefinitely. Strong KYC and strong data protection are not in tension; both are simply respect for the client expressed as discipline.

## A worked example

**Illustration — a corporate with a hidden owner (entirely hypothetical).** A company applies to open a Tier 3 trading account, expecting ₦30 million of monthly activity. The shareholder on the form is another company, itself owned by a nominee, with a parent registered offshore. Two triggers fire at once — opaque corporate ownership and high value — so the file escalates to EDD and cannot be activated on the relationship officer's say-so. The officer traces ownership through each layer to the natural persons who ultimately control the company, verifies each with identification and BVN through the NIBSS portal, and builds the ownership-structure map. Source-of-wealth documentation and a tax clearance certificate are obtained for the high-value dimension; the offshore link is checked against the jurisdiction's risk and the sanctions lists. The Compliance Officer reviews the map, approves the risk classification, and only then is the account activated — with enhanced monitoring and a twelve-month review set. The personal data gathered along the way is held on a legal-obligation basis under the NDPA and retained, not hoarded.

## Common traps

- **Stopping at the registered shareholder.** Beneficial ownership means tracing to natural persons; a holding company or nominee is never the answer.
- **Activating before Compliance approval.** Every EDD trigger requires Compliance Officer approval before the account goes live.
- **Tipping off.** Never signal to a client that a suspicious-transaction report has been made or considered; the prohibition is absolute.
- **Treating a re-activation as low risk.** A dormant account waking after three years is an EDD event, not a clerical update.
- **Confusing source of funds with source of wealth.** Funds is where this money came from; wealth is how the client built their assets — high-risk files need both.

## Key takeaways

- Every client is tiered (1/2/3) and risk-classified (low/medium/high) at onboarding; the classification drives review frequency and is approved by the Compliance Officer.
- EDD triggers are mandatory: PEPs, high-risk jurisdictions, opaque ownership, profile-inconsistent activity, three-year re-activations, high value above ₦10 million per month, and trust or nominee arrangements — each with a defined action and Compliance approval before activation.
- Beneficial ownership is traced to natural persons, each verified by identity and BVN via the NIBSS portal, with the ownership map signed off by Compliance.
- A dormant-account re-activation after three or more years is an EDD event; STR filing to the NFIU, the absolute no-tipping-off rule, and sanctions screening are the AML edges the onboarding desk must respect.
- Extra EDD data is handled under the NDPA 2023 and GAID 2025 (regulator: the NDPC) — lawful basis, minimisation, security, and retention; EDD files are kept seven years from the end of the relationship.

*Reference: the KYC Policy v3.0 (the three-tier framework, risk classification, the EDD mandatory-trigger table, beneficial ownership, BVN verification, and the KYC Deficiency Correction Programme) and the AML/CFT Policy v3.0 (red flags, the STR route to the NFIU, the prohibition on tipping off, sanctions screening, and record-keeping), with the Inactive Accounts Policy v3.0 on re-activation EDD. The firm's AML programme and transaction monitoring as a whole are covered in REG-201; this module is the onboarding view. Regulatory references are taught to current law — the Investments and Securities Act 2025 (source documents citing 'ISA 2024' are logged for correction), the Money Laundering (Prevention and Prohibition) Act 2022, and data handling under the Nigeria Data Protection Act 2023 with the GAID 2025 (regulator: NDPC). These policies and statutes are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'CLA-202';

-- 2) twenty graded questions (80%% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_01$id$, m.id, $p$EDD is mandatory and, when triggered, the account may be activated only after...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the relationship officer signs"}, {"key": "b", "text": "Compliance Officer approval"}, {"key": "c", "text": "the client pays a fee"}, {"key": "d", "text": "one year passes"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every EDD trigger requires Compliance Officer approval before the account is activated.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_02$id$, m.id, $p$A salary-employed Nigerian resident with a modest, regular profile is typically classified as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "high risk, Tier 3, twelve-month review"}, {"key": "b", "text": "low risk, Tier 1 or low Tier 2, thirty-six-month review"}, {"key": "c", "text": "prohibited"}, {"key": "d", "text": "a PEP"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Such a client is low risk — Tier 1 or low Tier 2 — with a thirty-six-month KYC review frequency.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_03$id$, m.id, $p$Which of these is a mandatory EDD trigger?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a client who emails frequently"}, {"key": "b", "text": "a politically exposed person or their family member or close associate"}, {"key": "c", "text": "a client who prefers phone calls"}, {"key": "d", "text": "a client under thirty"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A PEP — or the family member or close associate of a PEP — is a mandatory EDD trigger.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_04$id$, m.id, $p$For a PEP, the required actions include...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no extra steps"}, {"key": "b", "text": "senior-management approval, source-of-wealth documentation, enhanced monthly monitoring, and a monthly PEP return to the NFIU"}, {"key": "c", "text": "closing the account"}, {"key": "d", "text": "a discount on fees"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$PEP files require senior-management approval, source-of-wealth evidence, monthly transaction review, a monthly NFIU PEP return, and annual enhanced review.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_05$id$, m.id, $p$Beneficial ownership means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the registered holding company"}, {"key": "b", "text": "the natural person who ultimately owns or controls the client"}, {"key": "c", "text": "the nominee on the form"}, {"key": "d", "text": "the account officer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Beneficial ownership is the natural person who ultimately owns or controls the client — never a holding company or nominee.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_06$id$, m.id, $p$Bank Verification Numbers are verified through...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a verbal confirmation from the client"}, {"key": "b", "text": "the NIBSS portal, with a screenshot or system record on file"}, {"key": "c", "text": "social media"}, {"key": "d", "text": "the client's employer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$BVN must be verified via the NIBSS portal, with screenshot or system-generated evidence on the file — a recurring NGX finding was missing BVN evidence.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_07$id$, m.id, $p$Source of funds differs from source of wealth in that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "they are identical"}, {"key": "b", "text": "funds is where this transaction's money came from; wealth is how the client accumulated overall assets"}, {"key": "c", "text": "wealth applies only to corporates"}, {"key": "d", "text": "funds applies only to PEPs"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Source of funds concerns the money behind a transaction; source of wealth concerns how overall assets were accumulated — high-risk files need both.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_08$id$, m.id, $p$A high-value client is one with expected transaction volumes above...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "₦100,000 per month"}, {"key": "b", "text": "₦10 million per month"}, {"key": "c", "text": "₦1 billion per month"}, {"key": "d", "text": "there is no threshold"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A Tier 3 client with expected volumes above ₦10 million per month is high-value, requiring source-of-wealth documentation, tax clearance, and monitoring.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_09$id$, m.id, $p$Re-activating an account dormant for three or more years is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a clerical update needing no checks"}, {"key": "b", "text": "an EDD event routed through the full re-engagement procedure"}, {"key": "c", "text": "prohibited"}, {"key": "d", "text": "handled by the client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A three-year-plus re-activation carries elevated AML/CFT risk and is handled as an EDD event with full re-engagement.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_10$id$, m.id, $p$When something does not add up, a suspicious-transaction report is filed to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the NGX"}, {"key": "b", "text": "the Nigerian Financial Intelligence Unit (NFIU)"}, {"key": "c", "text": "the client's bank"}, {"key": "d", "text": "the press"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$STRs are filed to the NFIU; the onboarding desk escalates, and the compliance function files.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_11$id$, m.id, $p$The prohibition on tipping off means you must never...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ask the client for documents"}, {"key": "b", "text": "signal to the client that a suspicious-transaction report has been made or contemplated"}, {"key": "c", "text": "update the risk classification"}, {"key": "d", "text": "verify BVN"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Tipping off is absolutely prohibited: never tell or signal to a client that an STR has been made or is being considered.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_12$id$, m.id, $p$For a corporate with opaque ownership, the required action is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "accept the first shareholder named"}, {"key": "b", "text": "full beneficial-ownership tracing to natural persons, ID and BVN for each UBO, and Compliance sign-off on the ownership map"}, {"key": "c", "text": "no verification"}, {"key": "d", "text": "a single phone call"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Opaque corporate ownership requires tracing to natural persons, verifying each UBO by ID and BVN, and Compliance sign-off on the ownership-structure map.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_13$id$, m.id, $p$The current AML statute governing the firm's programme is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Money Laundering (Prohibition) Act 2011"}, {"key": "b", "text": "Money Laundering (Prevention and Prohibition) Act 2022"}, {"key": "c", "text": "Companies and Allied Matters Act"}, {"key": "d", "text": "there is none"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The current statute is the Money Laundering (Prevention and Prohibition) Act 2022, alongside the Terrorism (Prevention and Prohibition) Act 2022.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_14$id$, m.id, $p$The extra personal data collected during EDD is governed by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no particular law"}, {"key": "b", "text": "the Nigeria Data Protection Act 2023 and GAID 2025, supervised by the NDPC"}, {"key": "c", "text": "the NDPR 2019 only"}, {"key": "d", "text": "foreign data law"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$EDD data is handled under the NDPA 2023 and the GAID 2025, supervised by the Nigeria Data Protection Commission.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_15$id$, m.id, $p$EDD files must be retained for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one year"}, {"key": "b", "text": "seven years from the end of the client relationship"}, {"key": "c", "text": "indefinitely"}, {"key": "d", "text": "until the next audit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$EDD files are retained for seven years from the end of the client relationship.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_16$id$, m.id, $p$A trust or nominee arrangement requires the firm to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "accept the nominee as the owner"}, {"key": "b", "text": "identify the actual beneficial owner, verify the nominee is legally authorised, and obtain separate ID and BVN for the beneficial owner"}, {"key": "c", "text": "skip verification"}, {"key": "d", "text": "refer the client elsewhere"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Trust/nominee arrangements require identifying the real beneficial owner, confirming the nominee's authority, and separate ID and BVN for the beneficial owner.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_17$id$, m.id, $p$This module's scope, relative to REG-201, is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the full AML programme and transaction monitoring"}, {"key": "b", "text": "the client-facing EDD and complex-onboarding view, leaning on the AML programme but not owning it"}, {"key": "c", "text": "payroll controls"}, {"key": "d", "text": "best execution"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$CLA-202 is the onboarding view; REG-201 owns the firm's AML programme and transaction monitoring, which this module references but does not repeat.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_18$id$, m.id, $p$A client's transactions are inconsistent with their declared profile. The correct response is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ignore it if amounts are small"}, {"key": "b", "text": "obtain a written explanation, have Compliance review, update the risk assessment, and consider an STR"}, {"key": "c", "text": "close the account silently"}, {"key": "d", "text": "tell the client an STR is coming"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Profile-inconsistent activity requires a written explanation, Compliance review, an updated risk assessment, and possible STR filing — without tipping off.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_19$id$, m.id, $p$Sanctions screening at onboarding...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is optional for corporates"}, {"key": "b", "text": "is run against the applicable lists, and a positive hit stops the account"}, {"key": "c", "text": "applies only to PEPs"}, {"key": "d", "text": "happens after activation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Sanctions screening is performed at onboarding against the applicable lists; a positive match stops the account.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla202_20$id$, m.id, $p$Regulatory references in this module are taught to which securities statute?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ISA 2024"}, {"key": "b", "text": "the current Investments and Securities Act 2025"}, {"key": "c", "text": "the 1999 Act"}, {"key": "d", "text": "no statute applies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The current statute is the Investments and Securities Act 2025; 'ISA 2024' references in source documents are superseded and logged for correction.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'CLA-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: CLA-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'CLA-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: CLA-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: CLA-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
