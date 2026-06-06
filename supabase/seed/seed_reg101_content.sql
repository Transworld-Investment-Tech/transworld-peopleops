-- ===========================================================================
-- REG-101 The regulatory landscape: SEC, NGX & the rulebook: lesson + 20-question check (v0.48.0 content)
-- Authored FROM POLICY off Compliance Manual v3.0 §3 + Operational Manual v3.0 §1. Supporting: Code of Ethics Part 2; Conflict of Interest §9. Regulatory facts web-verified 06 Jun 2026 (ISA 2024; SEC Circular 26-1; NDPA 2023/GAID 2025).
-- Tier A. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Transworld does not operate in the capital market by right. It operates by **license** — and that license comes with a framework of law, regulation, and supervision that defines what the firm may do, who is allowed to do it, how much capital it must hold, and what happens when the lines are crossed. FND-109 introduced this rulebook at a glance. This module is the map in depth: the regulators and what each one actually controls, what our authorization requires us to maintain, how we are inspected, and the chain of consequence that follows a serious breach. You will not memorize every regulation — but when you finish, you will know the shape of the framework you work inside, and where to look the moment a question arises. The firm's mantra holds throughout: **the right way is always the best way.**

## What you'll be able to do

1. Identify the regulators that govern Transworld — SEC, NGX, CSCS, NFIU, CBN, CAC, FRC, and NDPC — and state what each one controls.
2. Connect the key instruments (ISA 2024, SEC Rules, NGX Dealing Members' Rules + MOS, AML/CFT Act 2022, NDPA 2023, CAMA 2020, NCCG 2018, CSCS Rules) to a concrete firm obligation.
3. Explain Transworld's standing as an SEC-licensed firm and NGX Dealing Member, and what that authorization requires the firm — and you — to maintain.
4. Describe how the firm is supervised and how its obligations are tracked and met.
5. Trace the four-fold chain of consequence that follows a serious breach, and apply the principle that the stricter rule always prevails.

## The regulators — and what each one controls

Several bodies have authority over different parts of what the firm does. Know who controls what:

- **SEC (Securities and Exchange Commission)** — the **apex regulator** of the Nigerian capital market. The SEC licenses operators, makes the rules, supervises conduct, sets capital requirements, and enforces. It is our primary regulator, and its authority over the firm is comprehensive.
- **NGX (Nigerian Exchange)** — the exchange we trade on. Transworld is a **Dealing Member**, which subjects the firm and its registered representatives to the NGX Dealing Members' Rules and Minimum Operating Standards, and to NGX surveillance and inspection.
- **CSCS (Central Securities Clearing System)** — clearing, settlement, and custody. Staff in post-trade roles must observe CSCS rules on settlement timelines, failed trades, and the segregation of client assets from the firm's own.
- **NFIU (Nigerian Financial Intelligence Unit)** — receives the firm's currency- and suspicious-transaction reports and supervises AML/CFT obligations alongside the SEC.
- **CBN / BOFIA** — engaged wherever banking, foreign-exchange, and payment activities intersect the securities business.
- **CAC (Corporate Affairs Commission)** — the firm's corporate existence under CAMA 2020: directors' duties, statutory filings, and proper records.
- **FRC (Financial Reporting Council)** — the Nigerian Code of Corporate Governance 2018, which sets standards for the board, the audit committee, and management.
- **NDPC (Nigeria Data Protection Commission)** — the data-protection regulator under the Nigeria Data Protection Act 2023, governing the personal data of clients and staff.

>! Currency note (as of June 2026): the NDPC — not NITDA — regulates data protection under the NDPA 2023. Some older internal documents still name NITDA and the NDPR 2019; both have been overtaken. The data-protection modules carry the detail.

## The rulebook — the binding instruments

These are the instruments that bind the firm. FND-109 listed them; here is what each one actually requires of us:

- **Investments and Securities Act 2024 (ISA 2024)** — administered by the **SEC**. The foundational statute for the capital market, signed in March 2025 and repealing the 2007 Act. It governs licensing, conduct of business, capital adequacy, and investor protection, and it expanded the SEC's oversight to reach digital assets.
- **SEC Rules and Regulations (Consolidated)** — **SEC**. The operating detail beneath the Act: KYC, AML/CFT, client classification, investment advice, capital adequacy, reporting, and conduct-of-business standards.
- **NGX Dealing Members' Rules 2015 + Minimum Operating Standards (MOS)** — **NGX**. Dealing conduct, **client priority**, order handling, the compliance-officer requirement, governance, minimum staffing, and reporting.
- **AML/CFT — Money Laundering (Prevention and Prohibition) Act 2022** — **NFIU / SEC**. An AML/CFT/CPF program, CDD and EDD, sanctions screening, CTR/STR filing, and annual staff training.
- **Nigeria Data Protection Act 2023 (with the GAID 2025)** — **NDPC**. Lawful, fair, secure processing of personal data. The GAID took effect 19 September 2025; the NDPR 2019 it replaced is no longer extant law.
- **CAMA 2020 (CAC)** and **NCCG 2018 (FRC)** — corporate structure, directors' obligations, and the governance standards that bind the board and management.
- **CSCS Rules** — the firm's obligations as a participant in the clearing system, including client-asset segregation.

> When two requirements conflict — for example, where an internal limit is more lenient than a regulatory rule — **the stricter requirement prevails**, always. The Compliance Officer maintains a Regulatory Calendar that tracks every deadline across all of these instruments and notifies management when rules change.

## Our standing: licensed and supervised

Transworld was established in 1988 and is **licensed by the SEC** and a **Dealing Member of the NGX**, offering stockbroking, asset management, investment advisory, and portfolio management. That standing is not a one-time grant — it is **conditional and continuing**. To keep it, the firm must maintain fit-and-proper management, adequate capital, a functioning compliance function, and accurate, on-time reporting. Let those conditions slip and the authorization itself is at risk.

The framework reaches individuals too. Anyone performing a regulated dealing role must hold and **maintain their own SEC/NGX registration** and remain fit-and-proper. Your individual registration is yours to protect — it does not survive serious misconduct.

Capital is one of those license conditions, and it is changing materially. Under **SEC Circular No. 26-1 (16 January 2026)**, the minimum capital for a **broker-dealer rose from ₦300 million to ₦2 billion**, with a compliance deadline of **30 June 2027**. The depth of capital strategy belongs to the finance modules; what matters here is the principle: **capital adequacy is a condition of the license, not merely a finance matter.**

## How we are watched: supervision, examination & reporting

Regulation is not paperwork filed and forgotten — the firm is actively supervised.

- **NGX Risk-Based Supervision (RBS).** The NGX subjects Dealing Members to periodic inspections that assess the quality of operations, the firm's compliance culture, and its risk management. This is live, not theoretical: the firm's current Operational Manual was itself prepared for board approval in direct response to an RBS inspection exit meeting.
- **The Regulatory Calendar.** The Compliance Officer tracks every filing deadline and return across all applicable instruments, documents each filing, and alerts management when new rules are issued or existing ones change.
- **The standing rule.** When a situation is not clearly covered by the firm's procedures, **stop, consult the Compliance Officer, and seek guidance before proceeding.** Asking before you act is the cheapest control the firm has — and the right move is always to ask before, not after.

## When the rules are broken: the chain of consequence

A serious breach does not produce a single consequence. It produces a **chain** that can unfold over years:

- **Disciplinary** — internal action up to and including dismissal.
- **Regulatory** — public censure by the SEC or NGX (published on the regulator's website), financial penalties levied on the firm and on the individual, suspension or withdrawal of registration, disgorgement of profits, permanent disqualification, and inclusion on the **SEC's database of disqualified persons** — a list consulted by every employer in the regulated market.
- **Civil** — claims by clients against the firm and against the individual. The firm's insurance does **not** cover losses caused by deliberate or grossly negligent breaches; a staff member who causes such loss should expect to bear it personally.
- **Criminal** — insider dealing, market manipulation, and falsification of records are criminal offenses under Nigerian law.

> The decision to cross a line is taken in a moment. Its consequences can shape the next decade of a person's life. The firm has no interest in punishing people — it has a profound interest in protecting clients, protecting itself, and protecting the market that lets the business exist.

## "The stricter rule prevails"

When an internal limit is more lenient than a regulatory rule, you follow the **rule**. When two requirements conflict, the **stricter** governs. And compliance is **not** the Compliance Officer's job alone — it runs from the Board to the newest intern. The Compliance Officer sets standards, monitors, and escalates; the responsibility to do the right thing in every transaction belongs to everyone.

## Key takeaways

- The firm operates by **license**, granted and supervised by the **SEC**, and trades as a **Dealing Member** of the **NGX**.
- **ISA 2024** is the foundational statute; beneath it sit the SEC Rules, NGX Dealing Members' Rules + MOS, AML/CFT Act 2022, NDPA 2023, CAMA 2020, NCCG 2018, and CSCS Rules.
- The license is **conditional and continuing** — fit-and-proper management, **adequate capital** (broker-dealer minimum now ₦2bn by 30 June 2027), a working compliance function, and accurate reporting.
- The firm is supervised through **NGX RBS** inspections; the **Regulatory Calendar** tracks every obligation; when unsure, **consult the Compliance Officer before acting.**
- A serious breach triggers a four-fold chain — **disciplinary, regulatory, civil, criminal** — and **the stricter rule always prevails.**

## References

- **Compliance Manual v3.0 §3 (Regulatory and Legal Framework)**, §11 (Regulatory Reporting Calendar) — primary.
- **Operational & Procedure Manual v3.0 §1 (Introduction; NGX RBS)** — supporting.
- **Code of Ethics CO-POL-001 Part 2**; **Conflict of Interest Policy CO-POL-002 §9 (consequences)**.
- External instruments verified 06 June 2026: ISA 2024 (signed March 2025, repealing ISA 2007); SEC Circular No. 26-1 (16 January 2026); NDPA 2023 with GAID 2025 (NDPC).
- *Mandatory for compliance/regulatory roles · annual refresh. Content owner: Chief Compliance Officer. Tier A. Verify regulatory currency at each annual cycle.*$body$,
    pass_mark = 80,
    estimated_minutes = 35,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'REG-101';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_01$id$, m.id, $p$Which body is Transworld's apex regulator in the capital market?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Central Bank of Nigeria"},{"key":"b","text":"The Securities and Exchange Commission (SEC)"},{"key":"c","text":"The Nigerian Exchange (NGX)"},{"key":"d","text":"The Corporate Affairs Commission"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The SEC is the apex regulator of the capital market — it licenses operators, makes the rules, supervises, sets capital requirements, and enforces.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_02$id$, m.id, $p$As a Dealing Member, the firm's dealing conduct, client priority, and order handling are governed primarily by whose rules?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The SEC alone"},{"key":"b","text":"The NGX (Dealing Members' Rules and MOS)"},{"key":"c","text":"The Corporate Affairs Commission"},{"key":"d","text":"The Financial Reporting Council"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$As a Dealing Member, the firm and its registered representatives are subject to the NGX Dealing Members' Rules 2015 and the Minimum Operating Standards.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_03$id$, m.id, $p$The personal data of clients and staff is regulated by:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"NITDA"},{"key":"b","text":"The Nigeria Data Protection Commission (NDPC)"},{"key":"c","text":"The NFIU"},{"key":"d","text":"The CBN"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Under the NDPA 2023 the regulator is the NDPC. NITDA administered the older NDPR 2019, which has been superseded.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_04$id$, m.id, $p$Select all correct regulator-to-mandate pairings.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"CSCS → settlement, custody, and client-asset segregation"},{"key":"b","text":"NFIU → currency and suspicious transaction reports"},{"key":"c","text":"CAC → corporate registration and directors' filings under CAMA"},{"key":"d","text":"FRC → market-trade surveillance"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$CSCS, NFIU, and CAC are paired correctly. The FRC sets governance standards (NCCG 2018); it does not run trade surveillance — that is the NGX.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_05$id$, m.id, $p$Compliance is solely the Compliance Officer's responsibility; other staff are not accountable for it.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Compliance runs from the Board to the newest intern. The Compliance Officer sets standards, monitors, and escalates, but the duty to act correctly belongs to everyone.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_06$id$, m.id, $p$The foundational capital-market statute, which repealed the 2007 Act, is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"CAMA 2020"},{"key":"b","text":"The Investments and Securities Act 2024 (ISA 2024)"},{"key":"c","text":"NCCG 2018"},{"key":"d","text":"The AML/CFT Act 2022"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$ISA 2024 is the foundational statute for the capital market; it was signed in March 2025 and repealed the 2007 Act.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_07$id$, m.id, $p$The rule that client orders take priority over the firm's own trades is set out in:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The SEC Rules only"},{"key":"b","text":"The NGX Dealing Members' Rules 2015"},{"key":"c","text":"The CSCS Rules"},{"key":"d","text":"CAMA 2020"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client priority is a core obligation of Dealing Members under the NGX Dealing Members' Rules 2015.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_08$id$, m.id, $p$The duty to file CTRs/STRs and to conduct CDD and EDD arises under:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The AML/CFT Act 2022"},{"key":"b","text":"The NDPA 2023"},{"key":"c","text":"NCCG 2018"},{"key":"d","text":"The CSCS Rules"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The AML/CFT (Money Laundering Prevention and Prohibition) Act 2022 requires the AML/CFT/CPF program, CDD/EDD, sanctions screening, CTR/STR filing, and annual training.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_09$id$, m.id, $p$Which obligations flow from the SEC Rules and Regulations? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"KYC and client classification"},{"key":"b","text":"Capital adequacy"},{"key":"c","text":"Conduct-of-business standards"},{"key":"d","text":"Choice of the firm's external auditor"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$KYC, client classification, capital adequacy, and conduct of business all flow from the SEC Rules. The choice of external auditor is a governance matter, not an SEC Rules obligation.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_10$id$, m.id, $p$The NDPR 2019 remains the firm's governing data-protection instrument.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The governing framework is the NDPA 2023 together with the GAID 2025; the NDPR 2019 ceased to be extant law from 19 September 2025.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_11$id$, m.id, $p$Under SEC Circular 26-1 (January 2026), the minimum capital for a broker-dealer is now:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"₦300 million"},{"key":"b","text":"₦600 million"},{"key":"c","text":"₦1 billion"},{"key":"d","text":"₦2 billion (by 30 June 2027)"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The broker-dealer minimum rose from ₦300 million to ₦2 billion, with a compliance deadline of 30 June 2027.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_12$id$, m.id, $p$A person performing a regulated dealing role must:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Rely on the firm's license alone"},{"key":"b","text":"Hold and maintain their own SEC/NGX registration and remain fit-and-proper"},{"key":"c","text":"Register only once, at hire, with no ongoing obligation"},{"key":"d","text":"Register only if they manage other people"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Individuals in regulated dealing roles must hold and maintain their own registration and remain fit-and-proper; the registration does not survive serious misconduct.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_13$id$, m.id, $p$Maintaining adequate capital is purely a finance concern with no bearing on the firm's license.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Capital adequacy is a condition of the license — fall below the minimum and the authorization itself is at risk.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_14$id$, m.id, $p$NGX's periodic inspection of a member's operations, compliance culture, and risk management is called:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The external audit"},{"key":"b","text":"Risk-Based Supervision (RBS)"},{"key":"c","text":"The Regulatory Calendar"},{"key":"d","text":"The MOS review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$NGX Risk-Based Supervision (RBS) subjects Dealing Members to periodic inspections of operations, compliance culture, and risk management.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_15$id$, m.id, $p$Who maintains the Regulatory Calendar and notifies management when rules change?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The Managing Director"},{"key":"b","text":"The Compliance Officer"},{"key":"c","text":"The external auditor"},{"key":"d","text":"The Board secretary"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer maintains the Regulatory Calendar, tracks every deadline, and notifies management when rules are issued or amended.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_16$id$, m.id, $p$If a situation is not clearly covered by the firm's procedures, you should use your own judgment and proceed without consulting Compliance.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. When a situation is not clearly covered, stop, consult the Compliance Officer, and seek guidance before proceeding.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_17$id$, m.id, $p$Being placed on the SEC's database of disqualified persons means:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A temporary suspension that lapses automatically"},{"key":"b","text":"A bar from roles requiring SEC/NGX registration, visible to every employer in the market"},{"key":"c","text":"A financial penalty only"},{"key":"d","text":"An internal warning"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The database of disqualified persons bars an individual from registered roles and is consulted by all employers in the regulated capital market.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_18$id$, m.id, $p$Where an internal limit is more lenient than a regulatory rule, you:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Follow the internal limit, since it is the firm's own"},{"key":"b","text":"Follow the stricter regulatory rule"},{"key":"c","text":"Ask the client which to apply"},{"key":"d","text":"Average the two"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The stricter requirement prevails — here, the regulatory rule.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_19$id$, m.id, $p$A serious breach can produce which categories of consequence? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Disciplinary"},{"key":"b","text":"Regulatory"},{"key":"c","text":"Civil"},{"key":"d","text":"Criminal"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$A serious breach produces a chain: disciplinary, regulatory, civil, and criminal consequences, which can unfold over years.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg101_20$id$, m.id, $p$The firm's insurance will cover an individual's losses arising from a deliberate or grossly negligent breach.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The firm's insurance does not, as a matter of policy, cover losses caused by deliberate or grossly negligent breaches; the individual should expect to bear them personally.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-101'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
