-- ===========================================================================
-- PPL-102 People data, confidentiality & NDPR for HR: lesson + 20-question check (v0.48.0 content)
-- Authored FROM POLICY off HR Operations Manual v1.1 H3 + Compliance Manual v3.0 §12. Supporting: Code of Ethics Part 8; ICF data controls. HR-function cut of FND-105; current law NDPA 2023/GAID 2025/NDPC (06 Jun 2026).
-- Tier A. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$People Operations holds the most sensitive personal data in the firm. Not just names and bank details, but contracts, pay, performance records, disciplinary and grievance files, health and leave information, and the documents gathered when someone is hired. Every employee hands that data to the firm in trust, and you are its steward and its first line of defense. FND-105 taught the data-protection principles to everyone at an awareness level. This module is the People-Ops cut: how those principles apply to the specific things HR actually does, what makes employee data different, and how you hold, share, retain, and protect it. The standard is simple to state and demanding to live: process personal data lawfully, fairly, transparently, and securely — every time.

## What you'll be able to do

1. State the law that governs employee data and apply the data-protection principles to People-Ops processing.
2. Identify the lawful basis for each HR activity, and recognize and protect special-category data.
3. Uphold employees' data rights and the firm's confidentiality duties over personnel, pay, and regulatory information.
4. Control access to and retention of personnel records, using the portal as the evidence layer and approved processors for payroll.
5. Run the HR data-breach response correctly — report immediately, and let Compliance assess regulator notification.

## The law you operate under

Nigeria's data-protection framework is the **Nigeria Data Protection Act 2023 (NDPA)**, read together with the **General Application and Implementation Directive (GAID 2025)**, which took effect on 19 September 2025. The regulator is the **Nigeria Data Protection Commission (NDPC)**.

>! Currency note (as of June 2026): some of the firm's older documents still cite the NDPR 2019 and name NITDA as the regulator. That position has been overtaken — the NDPA 2023 with the GAID 2025 governs, and the NDPC regulates. Teach and apply the current law; a documentation update is being tracked.

The six principles you met in FND-105 are not abstractions for HR — they are how you handle a payslip, a CV, or a medical note:

- **Lawfulness** — process employee data only where there is a lawful basis.
- **Purpose limitation** — data gathered for one purpose (say, payroll) is not quietly reused for another.
- **Data minimization** — collect only what the task genuinely needs; asking for more is itself a breach.
- **Accuracy** — keep records correct and current.
- **Storage limitation** — keep personnel data only as long as needed, then dispose of it securely.
- **Integrity and confidentiality** — protect the data through physical, digital, and behavioral security.

## A lawful basis for each HR activity

Every time People-Ops processes employee data, there must be a lawful basis for it. In practice the bases map cleanly onto what HR does:

- **Contractual necessity** — processing needed to run the employment relationship: paying salary, administering benefits, managing leave, operating the performance cycle.
- **Legal obligation** — processing the law requires: PAYE and tax filings, pension remittance, statutory records, and the fit-and-proper and regulatory checks the firm must perform.
- **Legitimate interest** — narrow, balanced operational needs, such as workforce planning or securing firm systems, weighed against the employee's rights.
- **Consent** — reserved for genuinely optional processing. Consent is a weak basis in the employment context because of the power imbalance, so it is not the default; rely on contract or legal obligation where those fit, and do not dress up a mandatory process as "consent."

The discipline is to ask, before collecting anything: *what is the basis, and is this the minimum the task needs?* Collecting a candidate's full medical history "for the file" when the role does not require it is not thoroughness — it is a breach of minimization.

Recruitment is where this bites first. A candidate's CV, references, and identity documents are personal data the moment they arrive, processed on the basis of taking steps toward a possible contract. Collect only what the assessment needs; do not gather more "in case." And when a hire is made, the **unsuccessful applicants' data does not simply sit in an inbox forever** — it is retained only for a defined, justifiable period and then disposed of. Background and fit-and-proper checks required for regulated roles rest on legal obligation, not on a candidate's "consent," and the results are held with the same care as any other sensitive record.

## Special-category and sensitive employee data

Some employee data is more sensitive than the rest and demands heightened care: **health and medical information** (including sick-leave certificates and any accommodation needs), **disciplinary and grievance records**, and details touching protected characteristics. Handle this category on a strict need-to-know basis, store it with tighter access than ordinary personnel data, and keep the confidentiality of a grievance or disciplinary matter intact — including the interface with the firm's anti-harassment and speak-up processes, where a leak can cause real harm and deter people from coming forward. Health data gathered for leave or accommodation is used only for that purpose; it does not flow into pay or performance decisions.

>! Need-to-know in practice: a manager may need to know that an employee is on approved medical leave and for how long — they do not need the diagnosis. A grievance is known to those handling it, not to the wider team. When in doubt, share the least that lets the recipient do their job, and confirm with Compliance before widening access to a sensitive file.

## Employees' rights and your confidentiality duties

Employees are data subjects with rights — including the right to be informed about how their data is used, to access the data the firm holds about them, and to have inaccurate data corrected. People-Ops should be able to recognize such a request and route it correctly rather than ignore or mishandle it. When an employee asks what the firm holds on them, that is a request to act on, not to brush aside: log it, confirm the person's identity, involve Compliance on scope and timeline, and respond within the period the law allows. A request that is ignored becomes a complaint to the regulator.

Alongside rights sit your duties. The duty of confidentiality covers personnel matters, **compensation information**, and regulatory material, and it does not lapse when you change roles or leave the firm. Compensation data deserves particular discipline: pay, raises, and bonus outcomes are confidential, and discussing one person's pay with another is a serious confidentiality breach, not office conversation.

## Holding the data: access, retention, and the evidence layer

- **Least privilege on staff files.** Access to personnel records is limited to those who need it for their role. Not everyone in People-Ops needs to see everything; sensitive files carry tighter access still.
- **Retention, not hoarding.** Personnel data is kept for as long as it is needed — to meet legal, tax, and regulatory record-keeping obligations — and then disposed of securely under the Record Retention Schedule. "Keep everything forever" is a storage-limitation breach and a growing liability.
- **The portal as the evidence layer.** The PeopleOps portal is the operational system of record and the firm's evidence vault — the place where staff records and the proof that processes were followed live, under access control and an audit trail. Keeping the record in the portal, rather than in scattered spreadsheets and personal inboxes, is itself a data-protection control.
- **Approved processors only.** Payroll runs through approved third-party systems — HumanManager and Remita are the authoritative payroll platforms, with the portal as the control and evidence layer. Where a third party processes employee data on the firm's behalf — a payroll provider, a benefits administrator, a recruiter — that processing must rest on an appropriate basis and the relationship must require the same standards of protection the firm applies itself.

## When something goes wrong: the HR breach response

A breach of employee data is treated with the same urgency as any other:

- **Report immediately.** Any actual or suspected breach of personal data is reported to Compliance and IT the moment it is discovered. There is no acceptable waiting period.
- **Compliance assesses regulator notification.** The Compliance Officer determines whether the breach must be notified to the NDPC and, if so, ensures it is done within the required timeline. Failure to surface a known breach is itself a regulatory failing.
- **Document it.** The incident and the firm's response are recorded — what happened, what data was involved, who was told, and what was done. The record is part of the control.

## Key takeaways

- The governing law is the **NDPA 2023 with the GAID 2025**, regulated by the **NDPC** — apply current law even where older firm documents lag.
- Every HR processing activity needs a **lawful basis** (usually contract or legal obligation, rarely consent) and must collect only the **minimum** needed.
- **Special-category data** — health, disciplinary, grievance — gets tighter access and strict need-to-know; pay and personnel information are **confidential**, including from other staff.
- Hold data under **least privilege**, keep it in the **portal as the evidence layer**, retain it only as long as needed, and use **approved processors** (HumanManager, Remita) under proper safeguards.
- A breach of employee data is reported **immediately**; Compliance assesses **NDPC** notification; the response is documented.

## References

- **HR Operations Manual v1.1 Chapter H3 (Data Protection & NDPR Policy)**, including H3.4 (Data Breach Response) — primary.
- **Compliance Manual v3.0 §12 (Information Security and Data Protection Compliance)** — primary.
- Supporting: **Code of Ethics CO-POL-001 Part 8**; **Internal Control Framework v3.0 (data controls)**.
- Current law verified 06 June 2026: NDPA 2023; GAID 2025 (effective 19 September 2025); regulator NDPC. The NDPR 2019 is superseded.
- *Mandatory for People-Ops roles · annual refresh. Content owner: Chief Compliance Officer / People-Ops. Tier A.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-102';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_01$id$, m.id, $p$What is the governing data-protection framework the firm must apply today?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The NDPR 2019, administered by NITDA"},{"key":"b","text":"The NDPA 2023 with the GAID 2025, regulated by the NDPC"},{"key":"c","text":"The Labour Act"},{"key":"d","text":"There is no specific data-protection law in Nigeria"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The current framework is the NDPA 2023 read with the GAID 2025 (effective 19 September 2025), regulated by the NDPC. The NDPR 2019 has been superseded.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_02$id$, m.id, $p$Some older firm documents still cite NITDA and the NDPR 2019. When they conflict with current law, you should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Follow the older documents, since they are the firm's own"},{"key":"b","text":"Apply the current law (NDPA 2023 / GAID 2025 / NDPC) and flag the document for update"},{"key":"c","text":"Ignore both and use your judgment"},{"key":"d","text":"Wait until the documents are corrected before acting"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Apply the current law and log the documentation gap for correction; the LMS teaches the current position even where source documents lag.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_03$id$, m.id, $p$Select all that are correct applications of the data-protection principles to HR.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Collect only the minimum employee data the task needs"},{"key":"b","text":"Use data gathered for payroll for that purpose, not quietly for something else"},{"key":"c","text":"Keep personnel data only as long as needed, then dispose of it securely"},{"key":"d","text":"Gather extra information 'for the file' in case it is useful later"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Minimization, purpose limitation, and storage limitation are correct. Collecting extra 'for the file' breaches minimization.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_04$id$, m.id, $p$Consent is the strongest and default lawful basis for processing employee data.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Consent is weak in the employment context because of the power imbalance; rely on contractual necessity or legal obligation where they fit, and do not dress up a mandatory process as consent.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_05$id$, m.id, $p$Paying salary, administering benefits, and running the performance cycle are processing activities best grounded in:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Consent"},{"key":"b","text":"Contractual necessity"},{"key":"c","text":"Legitimate interest"},{"key":"d","text":"No basis is needed for routine HR work"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$These flow from running the employment relationship, so contractual necessity is the natural basis.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_06$id$, m.id, $p$PAYE filings, pension remittance, and fit-and-proper regulatory checks are processed on the basis of:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Consent"},{"key":"b","text":"Legitimate interest"},{"key":"c","text":"Legal obligation"},{"key":"d","text":"Marketing necessity"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$These are required by law or regulation, so the basis is legal obligation — not the employee's consent.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_07$id$, m.id, $p$A hiring manager asks you to keep every unsuccessful applicant's full file indefinitely. The correct approach is to:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Keep them all forever in case a role opens up"},{"key":"b","text":"Retain them only for a defined, justifiable period, then dispose of them securely"},{"key":"c","text":"Delete them the same day the hire is made"},{"key":"d","text":"Move them to a personal drive for safekeeping"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Storage limitation applies to recruitment data too: keep unsuccessful applicants' data only for a defined period with a justifiable reason, then dispose of it securely.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_08$id$, m.id, $p$Select all that count as special-category or sensitive employee data needing heightened care.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Health and medical information, including sick-leave certificates"},{"key":"b","text":"Disciplinary and grievance records"},{"key":"c","text":"Details touching protected characteristics"},{"key":"d","text":"An employee's work email address"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Health, disciplinary/grievance, and protected-characteristic data are sensitive and need tighter handling. A work email address is ordinary contact data.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_09$id$, m.id, $p$A line manager needs to know an employee's medical diagnosis whenever that employee takes approved sick leave.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. A manager may need to know that the employee is on approved leave and for how long — not the diagnosis. Share the least that lets the recipient do their job.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_10$id$, m.id, $p$Discussing one employee's pay or bonus outcome with another employee is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Fine — it is just office conversation"},{"key":"b","text":"A serious confidentiality breach"},{"key":"c","text":"Acceptable if both are at the same grade"},{"key":"d","text":"Allowed if the manager approves"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compensation information is confidential; disclosing one person's pay to another is a serious confidentiality breach, not conversation.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_11$id$, m.id, $p$An employee asks, in writing, for a copy of all the personal data the firm holds about them. You should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Ignore it unless they escalate"},{"key":"b","text":"Recognize it as a data-subject access request: log it, confirm identity, involve Compliance, and respond within the period the law allows"},{"key":"c","text":"Tell them the firm does not do that"},{"key":"d","text":"Hand over everything immediately without checking who is asking"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$This is a data-subject access request. Recognize and route it correctly — log it, verify identity, involve Compliance on scope and timeline, and respond in time. An ignored request can become a regulator complaint.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_12$id$, m.id, $p$Your duty of confidentiality over personnel and pay information ends as soon as you change roles or leave the firm.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The duty of confidentiality survives a change of role and the end of employment.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_13$id$, m.id, $p$Access to personnel records should be:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Open to everyone in People-Ops equally"},{"key":"b","text":"Limited to those who need it for their role, with tighter access on sensitive files"},{"key":"c","text":"Granted to all managers automatically"},{"key":"d","text":"Decided case by case with no standing rule"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Least privilege applies: access is limited to those who need it, and sensitive files carry tighter access still.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_14$id$, m.id, $p$In the firm's setup, which best describes the role of the PeopleOps portal for employee data?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is the authoritative payroll payment system"},{"key":"b","text":"It is the operational system of record and evidence layer — access-controlled, with an audit trail"},{"key":"c","text":"It is an optional backup for spreadsheets"},{"key":"d","text":"It stores only public information"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal is the operational source of truth and evidence vault for staff records and proof that processes were followed; payment itself runs through HumanManager and Remita.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_15$id$, m.id, $p$Keeping all personnel data indefinitely is the safe option because you never know when it will be needed.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Indefinite retention breaches storage limitation and grows the firm's liability; keep data only as long as needed, then dispose of it under the Record Retention Schedule.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_16$id$, m.id, $p$When a third party (e.g., a payroll provider or recruiter) processes employee data on the firm's behalf, that arrangement must:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Be informal — a verbal understanding is enough"},{"key":"b","text":"Rest on an appropriate basis and require the same standards of protection the firm applies itself"},{"key":"c","text":"Allow the third party to use the data for its own purposes"},{"key":"d","text":"Avoid any documentation to stay flexible"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Processors must operate on an appropriate basis and be held to the same protection standards; they may not repurpose the data.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_17$id$, m.id, $p$Which systems are the authoritative payroll platforms, with the portal as the control and evidence layer?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The PeopleOps portal alone"},{"key":"b","text":"HumanManager and Remita"},{"key":"c","text":"Personal spreadsheets"},{"key":"d","text":"The firm's email system"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$HumanManager and Remita are the authoritative payroll systems; the portal is the control and evidence layer, not the payment processor.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_18$id$, m.id, $p$You discover that a spreadsheet of employee bank details was emailed to the wrong external address. You should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Wait to see whether anyone misuses it"},{"key":"b","text":"Report it to Compliance and IT immediately"},{"key":"c","text":"Quietly recall the email and tell no one"},{"key":"d","text":"Handle it yourself without escalating"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An actual or suspected breach of personal data is reported to Compliance and IT immediately; there is no acceptable waiting period.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_19$id$, m.id, $p$Who determines whether an employee-data breach must be notified to the NDPC?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The People-Ops officer who found it"},{"key":"b","text":"The Compliance Officer"},{"key":"c","text":"The affected employee"},{"key":"d","text":"No notification is ever required for HR data"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer assesses whether the breach must be notified to the NDPC and ensures it is done within the required timeline.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl102_20$id$, m.id, $p$After an HR data breach is handled, there is no need to keep a record of what happened.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The incident and the response are documented — what happened, what data was involved, who was told, and what was done. The record is part of the control.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
