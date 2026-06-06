-- ===========================================================================
-- CLA-101 Client onboarding & the KYC process: lesson + 20-question check (v0.49.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Know Your Client — KYC — is the bedrock of everything the firm does with a client. It is the process by which Transworld establishes who a client genuinely is, understands their financial situation and objectives, and assesses the risk they present. Done well, it protects the client, protects the firm, and protects the integrity of the market. Done badly, it is the single most common source of regulatory findings against brokerage firms — and the firm knows this from direct experience: an NGX regulatory inspection sampled ten of the firm's client files and found a deficiency in **every single one**. This module walks the onboarding of a client from first contact to an activated account: the regulatory basis, the three-tier framework, the documents required, the independent compliance gate, and the completeness score that tells you at a glance whether a file is sound. The firm's mantra holds throughout: **the right way is always the best way.**

## What you'll be able to do

1. State why KYC matters and name the laws and regulators that require it.
2. Classify an individual client into the correct tier and state what each tier permits.
3. List the individual KYC documents and say what is acceptable and what is not.
4. Explain the Compliance Officer's independent role in approving a file before activation.
5. Read a KYC Completeness Score and take the right action for each band.

## Why KYC — the legal basis

KYC is not a house preference. It is required by a stack of overlapping law and regulation, and where any of them is stricter than firm policy, **the stricter requirement prevails**:

- **Investments and Securities Act 2024** — requires every capital market operator to verify a client's identity **before** establishing a business relationship. No account may be opened, and no service provided, without completed KYC.
- **SEC AML/CFT Rules and the Money Laundering (Prevention and Prohibition) Act 2022** — mandate **Customer Due Diligence (CDD)** for all clients, and **Enhanced Due Diligence (EDD)** for high-risk clients, politically exposed persons, and dormant accounts reactivating after extended inactivity.
- **NFIU Guidelines** — require **BVN verification via the NIBSS portal** for every individual client, with a screenshot or system-generated confirmation retained in the file.
- **CSCS Rules** — every CSCS account registration requires verified identity documentation. A CSCS account without a supporting KYC file is a regulatory breach.
- **Nigeria Data Protection Act 2023** — governs how the personal data gathered during KYC is collected, stored, and processed. The data-protection regulator is the **NDPC** (the Nigeria Data Protection Commission).

>! A currency note for staff: data protection in Nigeria is now governed by the **NDPA 2023** and supervised by the **NDPC**. Some older internal documents still refer to the NDPR 2019 and to NITDA; both have been overtaken. Treat client KYC data as personal data protected under the NDPA.

## The three-tier KYC framework

The SEC requires every operator to classify clients into one of **three tiers**, with the level of verification proportionate to the financial exposure the relationship creates. Think of the tiers as a progression of trust: more complete documentation unlocks higher transaction limits and a broader range of services.

- **Tier 1 — Basic.** Minimum identity documents only. Daily transaction and withdrawal limits of about ₦20,000; monthly about ₦200,000. Advanced products are not available. Basic CDD; review every 36 months.
- **Tier 2 — Standard.** Full KYC including BVN plus an alternative ID. Daily transaction limit about ₦40,000 (daily withdrawal about ₦50,000); monthly about ₦400,000. Limited access to advanced products. Standard CDD; review every 24 months.
- **Tier 3 — Premium.** Full KYC plus NIN, BVN, and government photo ID. Transaction and withdrawal limits subject to risk review with no fixed cap; full range of products with suitability sign-off; a dedicated relationship manager. Full CDD including a source-of-funds declaration and PEP screening; review every 12 months.

Every client is **tier-classified at account opening**, and the classification is recorded in the system. A client may **never** be offered services that exceed their tier's limits — a CRO who processes a transaction above a client's tier limit is in breach of this Policy and of the SEC's Rules.

## Moving between tiers

A client is always placed in **the tier that matches the documentation they have provided**. They may be **upgraded** at any time by providing the additional documents the higher tier requires. They may **not be downgraded** without the Compliance Officer's approval — with one exception that matters in practice: where a client's documents have **expired and not been renewed**, their limits are **automatically restricted** to the level appropriate to their remaining valid documentation.

> Work through the example: a Tier 3 client whose means of identification expires and is not renewed does not become "a Tier 3 client with an expired ID." They become a client who **no longer meets Tier 3 documentation requirements**. The CRO must immediately contact the client and **suspend trading** until updated documentation is provided.

## The individual client documents

For an individual client, CDD requires a specific set of documents. Know what is acceptable — and what is not:

- **Government-issued photo ID.** A valid, unexpired National ID (NIN) card, International Passport, Driver's Licence, or Voter's Card. The original is sighted and a certified copy retained. A verbal NIN number alone, or a photocopy with no physical card sighted, is **not** acceptable.
- **Proof of address.** A utility bill (PHCN, water, DSTV) or a bank statement **not older than three months**.
- **Bank Verification Number (BVN).** Verified via the NIBSS portal; a screenshot or system confirmation is retained on file. This is a hard NFIU requirement, not an optional extra.
- **Source-of-funds declaration.** A written declaration explaining the source of the funds to be invested; for high-value accounts, supporting documentation is required.
- **Risk-profile questionnaire.** Establishes the client's investment objectives, risk tolerance, and financial situation — the basis for judging whether a product is suitable.

A corporate, estate, or joint account adds further requirements (for example, valid identification for **every** signatory) — the NGX inspection specifically found corporate accounts trading with no valid ID for multiple signatories. The principle is the same: every required document, present, valid, and on file.

## The compliance gate: who approves a file

There is a clean division of labor. The **CRO collects** the documents and completes the onboarding checklist. The **Compliance Officer reviews and approves** the completed KYC file **before any account is activated**. In that review, the Compliance Officer checks that all required documents are present, valid, and unexpired; that BVN verification was completed and recorded; that the client was screened against PEP and sanctions lists; that the risk profile is documented and the product offered is appropriate to it; and that the CRO has completed every step of the onboarding checklist.

>! The Compliance Officer has the authority to **refuse activation** where a file is incomplete or a client's circumstances raise concerns that cannot be resolved. This authority is exercised **independently — it is not subject to management override.** No business begins without complete KYC; clients who persistently fail to provide required information are not served.

## The KYC Completeness Score

The Completeness Score gives every CRO and manager an at-a-glance view of whether a file is sound. Each required document is checked for being present, current, and in the correct format:

- **100% — Green.** All documents present, valid, and current. No immediate action; schedule the next periodic review per the tier timetable.
- **80–99% — Amber.** One document missing, expiring within 90 days, or needing a minor update. The CRO contacts the client within **5 working days** and resolves within **30 working days**.
- **Below 80% — Red.** Two or more documents missing, expired, or materially deficient. Transaction limits are **immediately suspended** to the minimum tier for which valid documents exist; the CRO contacts the client within **2 working days**; the Head of Operations is notified; resolve within **15 working days**.
- **0% — Red, Critical.** No valid KYC documents on file at all. The account is **suspended immediately**, the Compliance Officer is notified, and no transactions are permitted until at least a Tier 1 file is established. The KYC Deficiency Correction Programme is activated.

## Risk, EDD, and the periodic review

Every new client is assigned a **risk classification at onboarding** — Low, Medium, High, or PEP — recorded in the file and the system. This is not a label; it sets the depth of due diligence, the frequency of KYC review, and the intensity of transaction monitoring. **Enhanced Due Diligence is mandatory** for high-risk clients, politically exposed persons, and inactive accounts being reactivated after extended dormancy. Thereafter, each client gets a **periodic review** scheduled to their risk tier (every 12, 24, or 36 months), so the file never silently goes stale.

One last rule that bridges into AML: if a client's activity raises a suspicion, you report it to the Compliance Officer only — you must **never tip off the client** that a concern or report exists. Onboarding done to this standard is how the firm earns the right to act for a client at all.

---

*Foundational client module · Tier B · function-head review on each annual cycle. KYC requirements track SEC/NFIU/CSCS rules and the NDPA — verify currency at each refresh.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'CLA-101';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_01$id$, m.id, $p$What did the NGX regulatory inspection find when it sampled ten of the firm's client files?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"All ten were fully compliant"},{"key":"b","text":"A deficiency in every single file"},{"key":"c","text":"Deficiencies in only the corporate files"},{"key":"d","text":"That KYC was not required"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every one of the ten sampled files had at least one deficiency — the starting point for the firm's strengthened KYC discipline.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_02$id$, m.id, $p$Under the Investments and Securities Act 2024, when must a client's identity be verified?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Within 30 days of the first trade"},{"key":"b","text":"Before establishing a business relationship — no account or service without completed KYC"},{"key":"c","text":"Only for Tier 3 clients"},{"key":"d","text":"At the first periodic review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The ISA 2024 requires identity verification before a business relationship begins; no account may be opened or service provided without completed KYC.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_03$id$, m.id, $p$Which regulator supervises data protection over the personal data gathered during KYC?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"NITDA, under the NDPR 2019"},{"key":"b","text":"The NDPC, under the Nigeria Data Protection Act 2023"},{"key":"c","text":"The NGX"},{"key":"d","text":"The CSCS"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Data protection is governed by the NDPA 2023 and supervised by the NDPC; the older NDPR 2019 / NITDA references have been overtaken.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_04$id$, m.id, $p$How many tiers does the SEC three-tier KYC framework define, and what determines a client's tier?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Two tiers, determined by account balance"},{"key":"b","text":"Three tiers, determined by the documentation provided and the applicable transaction limits"},{"key":"c","text":"Four tiers, determined by the client's age"},{"key":"d","text":"Three tiers, determined by the CRO's discretion"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$There are three tiers; a client is placed in the tier matching the documentation provided, which carries proportionate transaction limits.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_05$id$, m.id, $p$A client is classified at Tier 1. May the firm process a transaction above the Tier 1 limit because the client is trustworthy?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Yes, at the CRO's discretion"},{"key":"b","text":"No — a client may never be offered services exceeding their tier's limits; doing so breaches the Policy and SEC Rules"},{"key":"c","text":"Yes, if the MD verbally approves"},{"key":"d","text":"Yes, once per month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Services may never exceed a client's tier limits. A CRO who processes a transaction above the limit is in breach of the Policy and the SEC's Rules.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_06$id$, m.id, $p$How does a client move UP a tier?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Automatically after 12 months"},{"key":"b","text":"By providing the additional documentation the higher tier requires"},{"key":"c","text":"By increasing their transaction volume"},{"key":"d","text":"Only with NGX approval"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A client may be upgraded at any time by providing the additional documents required for the higher tier.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_07$id$, m.id, $p$A Tier 3 client's photo ID expires and is not renewed. What is the correct treatment?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They remain a Tier 3 client with an expired ID"},{"key":"b","text":"Their limits are automatically restricted to their remaining valid documentation; the CRO contacts them and suspends trading until updated"},{"key":"c","text":"Nothing changes until the next 12-month review"},{"key":"d","text":"The account is closed permanently"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Expired, unrenewed documents auto-restrict limits to the remaining valid documentation. The client no longer meets Tier 3 requirements; the CRO contacts them and suspends trading until updated.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_08$id$, m.id, $p$A client may be downgraded from a higher tier to a lower one freely, without the Compliance Officer's approval.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Downgrades require the Compliance Officer's approval — except the automatic restriction that follows expired, unrenewed documents.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_09$id$, m.id, $p$Which documents are required for an individual client's KYC? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Valid government-issued photo ID"},{"key":"b","text":"Proof of address no older than three months"},{"key":"c","text":"BVN verified via NIBSS, with confirmation retained"},{"key":"d","text":"A written source-of-funds declaration"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$All four are required, alongside a risk-profile questionnaire.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_10$id$, m.id, $p$Which of these is an ACCEPTABLE form of photo identification?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A verbal NIN number provided over the phone"},{"key":"b","text":"A photocopy of an ID with no physical card sighted"},{"key":"c","text":"A valid, unexpired International Passport, with the original sighted and a certified copy retained"},{"key":"d","text":"An expired Voter's Card"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A valid, unexpired passport (or NIN card, driver's licence, voter's card) with the original sighted and a certified copy retained is acceptable. Verbal numbers, unsighted photocopies, and expired IDs are not.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_11$id$, m.id, $p$How recent must a proof-of-address document be?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"No older than three months"},{"key":"b","text":"No older than two years"},{"key":"c","text":"Any date is acceptable"},{"key":"d","text":"Issued within the last week"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A utility bill or bank statement used as proof of address must be no older than three months.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_12$id$, m.id, $p$What must be retained on file as evidence of BVN verification?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Nothing — a verbal confirmation is enough"},{"key":"b","text":"A screenshot or system-generated confirmation from the NIBSS portal"},{"key":"c","text":"Only the BVN number written on the form"},{"key":"d","text":"A letter from the client's bank manager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$BVN is verified via the NIBSS portal, and a screenshot or system confirmation must be retained in the client file.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_13$id$, m.id, $p$Who collects the KYC documents, and who approves the completed file before the account is activated?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Compliance Officer collects; the CRO approves"},{"key":"b","text":"The CRO collects; the Compliance Officer reviews and approves before activation"},{"key":"c","text":"The client collects; the MD approves"},{"key":"d","text":"The NGX collects and approves"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The CRO collects the documents; the Compliance Officer reviews and approves the completed file before any account is activated.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_14$id$, m.id, $p$The Compliance Officer's authority to refuse account activation is subject to management override.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer exercises this authority independently; it is not subject to management override.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_15$id$, m.id, $p$In approving a KYC file, what does the Compliance Officer check? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"All required documents are present, valid, and unexpired"},{"key":"b","text":"BVN verification was completed and recorded"},{"key":"c","text":"The client was screened against PEP and sanctions lists"},{"key":"d","text":"The risk profile is documented and the product offered is appropriate"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$The Compliance Officer verifies documents, BVN, PEP/sanctions screening, the documented risk profile and product suitability, and that the onboarding checklist is complete.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_16$id$, m.id, $p$A KYC Completeness Score of 'Below 80% — Red' triggers what immediate action?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"No action until the next scheduled review"},{"key":"b","text":"Transaction limits immediately suspended to the minimum tier for which valid documents exist; CRO contacts client within 2 working days; Head of Operations notified"},{"key":"c","text":"The account is closed"},{"key":"d","text":"The client is upgraded to Tier 3"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Below 80% (two or more documents missing/expired/deficient) immediately suspends limits to the minimum valid tier; the CRO contacts the client within 2 working days and the Head of Operations is notified.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_17$id$, m.id, $p$A score of '0% — Critical' (no valid KYC documents at all) requires:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Account suspended immediately, Compliance Officer notified, no transactions until at least a Tier 1 file is established, KDCP activated"},{"key":"b","text":"A 30-working-day grace period"},{"key":"c","text":"Routing the account to Tier 2"},{"key":"d","text":"A verbal warning only"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$At 0% the account is suspended immediately, the Compliance Officer is notified, no transactions are permitted until a minimum Tier 1 file exists, and the KYC Deficiency Correction Programme is activated.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_18$id$, m.id, $p$Enhanced Due Diligence (EDD) is mandatory for which clients? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"High-risk clients"},{"key":"b","text":"Politically exposed persons (PEPs)"},{"key":"c","text":"Inactive accounts being reactivated after extended dormancy"},{"key":"d","text":"Every Tier 1 client by default"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$EDD is mandatory for high-risk clients, PEPs, and dormant accounts being reactivated. Tier 1 clients receive Basic CDD, not automatic EDD.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_19$id$, m.id, $p$How often is a periodic KYC review scheduled?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The same fixed interval for every client"},{"key":"b","text":"Based on the client's risk classification — every 12, 24, or 36 months"},{"key":"c","text":"Only when the client requests it"},{"key":"d","text":"Never, once the account is open"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Periodic reviews are scheduled to the client's risk tier — every 12 months (Tier 3 / higher risk), 24 months (Tier 2), or 36 months (Tier 1).$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla101_20$id$, m.id, $p$A CSCS account may exist without a supporting KYC file as long as the client has traded before.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A CSCS account without a supporting KYC file is a regulatory breach; every CSCS registration requires verified identity documentation.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
