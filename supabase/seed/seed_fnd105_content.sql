-- ===========================================================================
-- FND-105 Data Protection / NDPR: lesson + 20-question check (v0.46.0 content)
-- Authored FROM POLICY off Compliance Manual v3.0 §12.1 + HR Operations Manual v1.1 H3.
-- GAP: no standalone Board-edition NDPR policy -- the CCO must accept publishing without one.
-- Tier A (CCO-owned). Running this seed PUBLISHES the module -- it is the CCO publish gate.
--   DO NOT RUN until the CCO has reviewed and approved the content.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Every client who opens an account with Transworld hands us something personal and valuable: their identity documents, their bank details, their investment history, their home address, their family information. Every member of staff hands us the same. They do this because they trust us to look after it — and the law backs that trust with hard obligations. The Nigeria Data Protection Act 2023 (NDPA) is the governing statute; the Nigeria Data Protection Regulation (NDPR) is the regulation beneath it, supervised by the regulator, the NDPC/NITDA. Together they set the rules for how personal data is collected, used, stored, and protected. A data breach is never "just" an operational slip — it is a compliance failure, a regulatory breach, and a betrayal of the person whose data we lost.

This module is for everyone, because everyone at Transworld handles personal data — a Field Officer collecting a KYC form, a Client Services Officer updating an address, People Ops holding staff files, an analyst with a client list. Data protection is not an IT setting you can leave to someone else. It is a personal responsibility you carry every time you touch someone's information.

>! Personal data is anything that identifies a living person — a name, a phone number, a BVN, an account number, a photograph. Protecting it is part of your job, not an extra.

## What you'll be able to do

1. State the legal basis for data protection at Transworld and who supervises it.
2. Apply the six data-protection principles to your everyday work.
3. Recognize a lawful basis for processing and resist using data for a new purpose without one.
4. Explain how long records are kept and why "just in case" collection is itself a breach.
5. Respond correctly to a suspected data breach and know the notification deadline that follows.

## The six principles, in plain terms

The Compliance Manual and the HR Operations Manual set out the same six principles. Learn them as habits, not rules to recite:

- **Lawfulness, fairness, transparency.** Collect and use data only where you have a lawful basis — consent, a contract, a legal obligation, or a legitimate interest — and be open with people about how their data is used. We do not collect data "just in case."
- **Purpose limitation.** Data given to us for one purpose may not be reused for an unrelated one without fresh consent. The test is simple: *is this what the client gave us this data for?* KYC documents collected to open an account are not a marketing list.
- **Data minimization.** Collect only what you genuinely need. Asking for more than necessary is itself a compliance breach.
- **Accuracy.** Keep data accurate and current; correct errors promptly through the proper, authorized update process. Accuracy is both a legal duty and good client service.
- **Storage limitation.** Keep data only as long as necessary. The Record Retention Schedule, maintained by the Compliance Officer, sets how long each category is held before secure deletion — staff files for seven years after exit, client records per SEC/NGX requirements.
- **Integrity and confidentiality.** Protect data against unauthorized access, loss, and damage through physical security (locked cabinets), digital security (access controls, encryption), and behavioral security (not sharing client information unnecessarily).

> **Accountability.** Beyond the six, the firm must be able to *demonstrate* it follows them. Compliance is Transworld's designated data-protection function — when in doubt about a data question, the Compliance Officer is who you ask.

## Lawful basis and purpose, at your desk

Most of the data we hold rests on contract (we need it to run the client's account) or legal obligation (KYC/AML and SEC record-keeping require it). The discipline that protects you day to day is purpose: before you use a piece of client or staff data, ask what it was collected for. Pulling a client's phone number from an account file to pitch an unrelated product, or sharing a colleague's salary information you saw while doing payroll, both fail the purpose test — even though you were authorized to see the data for its original purpose.

## Employee data

Your own data is protected by the same rules. Transworld processes staff data for legitimate HR purposes — managing the employment relationship, payroll and benefits, performance management, regulatory obligations such as AML/KYC and SEC licensing records, and legal proceedings where necessary. It is not shared with third parties without a lawful basis, and access within the firm is restricted to People Ops, the COO, your direct line manager, and Compliance where relevant.

## When something goes wrong — speed is the control

A data breach is any actual or suspected loss, unauthorized access, or exposure of personal data — a lost laptop, an email sent to the wrong client, a file left where it should not be. The rule is the same wherever you read it: **report it immediately.** Tell Compliance and IT on the same day you discover it; the firm's information-security standard expects the first internal alert within two hours. Compliance then assesses the breach and decides whether it must be reported to the regulator under the NDPR's **72-hour** notification requirement. Failing to report a breach you knew about is itself a regulatory breach — so the worst thing you can do is stay quiet and hope.

>! Do not investigate or "fix" a suspected breach yourself, and do not wait until you are sure it is serious. Report it. Containment and assessment are Compliance and IT's job; your job is speed.

## Key takeaways

- The **NDPA 2023** is the governing law, with the **NDPR** beneath it, supervised by the NDPC/NITDA. A breach is a compliance failure, not just an IT incident.
- Learn the **six principles** as habits: lawful basis, purpose limitation, minimization, accuracy, storage limitation, integrity & confidentiality.
- Never collect "just in case," and never reuse data for a new purpose without a fresh lawful basis.
- Records are kept only as long as necessary — **staff files seven years post-exit**, client records per SEC/NGX; the Compliance Officer holds the Retention Schedule.
- Suspect a breach? **Report it the same day** to Compliance and IT (first alert within two hours); the regulator must be notified within **72 hours** where required.

## References

- **Compliance Manual v3.0, §12.1 (Data Protection Principles)** — primary source.
- **HR Operations Manual v1.1, Chapter H3 (Data Protection & NDPR Policy)** — primary source.
- Regulatory basis: Nigeria Data Protection Act 2023 (NDPA); Nigeria Data Protection Regulation (NDPR); NDPC/NITDA.
- *Mandatory module · annual refresh + induction. Content owner: Chief Compliance Officer. Tier A. Authoring note (for the CCO): Transworld has no standalone Board-edition NDPR policy; this module is authored from Compliance Manual §12.1 and HR Operations Manual H3 — publishing requires the CCO to accept that gap. The internal first-alert window differs between sources (Compliance Manual §12.2: within 2 hours; HR Ops H3.4: same day) — logged as an open doc-fix; both are taught here as "immediately."*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-105';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_01$id$, m.id, $p$Which law is the governing statute for data protection at Transworld?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The Cybercrimes Act alone"}, {"key": "b", "text": "The Nigeria Data Protection Act 2023 (NDPA)"}, {"key": "c", "text": "The Companies and Allied Matters Act"}, {"key": "d", "text": "There is no Nigerian data-protection law"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The NDPA 2023 is the governing statute, with the NDPR as the regulation beneath it, supervised by the NDPC/NITDA.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_02$id$, m.id, $p$A client gives you documents to open an account. Months later, marketing wants to use that contact list for a campaign. This is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Fine — the firm already holds the data"}, {"key": "b", "text": "Fine if the client does not object"}, {"key": "c", "text": "A breach of purpose limitation without fresh consent"}, {"key": "d", "text": "Allowed because it is the same client"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Data collected for one purpose (KYC/account opening) may not be reused for an unrelated purpose (marketing) without a fresh lawful basis. The test is what the client gave us the data for.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_03$id$, m.id, $p$Collecting more client information than you actually need is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Good practice — better to have it"}, {"key": "b", "text": "Itself a compliance breach (data minimization)"}, {"key": "c", "text": "Acceptable if stored securely"}, {"key": "d", "text": "Only a problem for IT"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Data minimization means collecting only what is genuinely needed. Asking for more than necessary is itself a breach.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_04$id$, m.id, $p$Within what time must a reportable breach be notified to the regulator under the NDPR?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "24 hours"}, {"key": "b", "text": "48 hours"}, {"key": "c", "text": "72 hours"}, {"key": "d", "text": "7 days"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Where a breach requires regulatory notification, the NDPR sets a 72-hour window. Compliance makes the assessment and notifies.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_05$id$, m.id, $p$You discover a suspected data breach. What should you do first?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Investigate it yourself to confirm it is real"}, {"key": "b", "text": "Wait to see whether it is serious"}, {"key": "c", "text": "Report it to Compliance and IT the same day"}, {"key": "d", "text": "Delete the affected file"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Report immediately — same day, with the firm's standard expecting a first alert within two hours. Do not investigate or fix it yourself; containment is Compliance and IT's job.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_06$id$, m.id, $p$'Personal data' under the NDPA includes:$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "A client's BVN"}, {"key": "b", "text": "A staff member's home address"}, {"key": "c", "text": "A client's photograph"}, {"key": "d", "text": "An anonymized market statistic with no individual identified"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Personal data is anything that identifies a living person — BVN, address, photograph all qualify. Truly anonymized aggregate data does not identify anyone.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_07$id$, m.id, $p$Data protection at Transworld is mainly the IT department's responsibility.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. The six principles are personal responsibilities for everyone who handles personal data — not an IT setting to delegate.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_08$id$, m.id, $p$How long are staff files retained after an employee exits?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "1 year"}, {"key": "b", "text": "3 years"}, {"key": "c", "text": "7 years"}, {"key": "d", "text": "Indefinitely"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Staff files are retained for seven years post-exit; client records follow SEC/NGX requirements. The Compliance Officer maintains the Retention Schedule.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_09$id$, m.id, $p$Keeping client data 'just in case it is useful later' is consistent with the principles.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Lawfulness and minimization both rule out 'just in case' collection — there must be a lawful basis and a genuine need.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_10$id$, m.id, $p$Which is a lawful basis for processing personal data?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Curiosity"}, {"key": "b", "text": "Consent, contract, legal obligation, or legitimate interest"}, {"key": "c", "text": "The data being easy to obtain"}, {"key": "d", "text": "A manager's verbal say-so without a reason"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The lawful bases are consent, contractual necessity, legal obligation, and legitimate interest.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_11$id$, m.id, $p$Who maintains the Record Retention Schedule that sets how long each data category is held?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Each employee for their own files"}, {"key": "b", "text": "The IT Lead"}, {"key": "c", "text": "The Compliance Officer"}, {"key": "d", "text": "The external auditor"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Compliance Officer maintains the Record Retention Schedule and is the firm's designated data-protection function.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_12$id$, m.id, $p$You realize you emailed a client's statement to the wrong client. The correct response is to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Hope the recipient deletes it and say nothing"}, {"key": "b", "text": "Report it the same day to Compliance and IT"}, {"key": "c", "text": "Wait a week to see if anyone complains"}, {"key": "d", "text": "Ask the wrong recipient to keep it confidential and move on"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$This is a suspected breach. Report it immediately to Compliance and IT; Compliance assesses whether NDPR notification is required.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_13$id$, m.id, $p$Accuracy as a data-protection principle means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Data may never be changed once recorded"}, {"key": "b", "text": "Data must be kept accurate and current, corrected through the proper authorized process"}, {"key": "c", "text": "Only Compliance can hold accurate data"}, {"key": "d", "text": "Accuracy applies only to financial figures"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Personal data must be kept accurate and up to date, with corrections made through the proper update process with documented authorization.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_14$id$, m.id, $p$Access to employee personal data within Transworld is restricted to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Anyone who asks"}, {"key": "b", "text": "People Ops, the COO, the employee's line manager, and Compliance where relevant"}, {"key": "c", "text": "The whole leadership team automatically"}, {"key": "d", "text": "Only the employee themselves"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Employee data access is restricted to People Ops, the COO, the direct line manager, and Compliance where relevant, and is not shared with third parties without a lawful basis.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_15$id$, m.id, $p$Which regulator supervises data protection in Nigeria?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The SEC"}, {"key": "b", "text": "The NGX"}, {"key": "c", "text": "The NDPC / NITDA"}, {"key": "d", "text": "The CBN"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Data protection is supervised by the NDPC/NITDA under the NDPA and NDPR.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_16$id$, m.id, $p$Failing to report a breach you knew about is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Acceptable if the breach was small"}, {"key": "b", "text": "Itself a regulatory breach"}, {"key": "c", "text": "Only an issue if a client complains"}, {"key": "d", "text": "A matter for IT alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Failing to report a known breach within the required timeline is itself a regulatory breach.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_17$id$, m.id, $p$'Integrity and confidentiality' protection of data covers which kinds of measures?$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Physical security such as locked cabinets"}, {"key": "b", "text": "Digital security such as access controls and encryption"}, {"key": "c", "text": "Behavioral security — not sharing client information unnecessarily"}, {"key": "d", "text": "Leaving files on a shared desk for convenience"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$The principle covers physical, digital, and behavioral security. Leaving files exposed defeats all three.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_18$id$, m.id, $p$A colleague asks for a client's details for something unrelated to that client's account. You should:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Share it — you are both staff"}, {"key": "b", "text": "Apply purpose limitation and decline unless there is a lawful basis"}, {"key": "c", "text": "Share it only if they are senior to you"}, {"key": "d", "text": "Share a copy but ask them to delete it later"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Being authorized to see data for one purpose does not permit reuse for another. Without a lawful basis, decline.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_19$id$, m.id, $p$Who can answer a data-protection question you are unsure about?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "No one — you must decide alone"}, {"key": "b", "text": "The Compliance Officer, the firm's designated data-protection function"}, {"key": "c", "text": "Only the external regulator"}, {"key": "d", "text": "Any colleague who is free"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compliance is the designated data-protection function — ask before you act.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd105_20$id$, m.id, $p$The best one-line summary of breach handling is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Investigate quietly, then decide whether to tell anyone"}, {"key": "b", "text": "Report immediately; let Compliance and IT contain and assess"}, {"key": "c", "text": "Fix it yourself to save time"}, {"key": "d", "text": "Only escalate confirmed breaches"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Speed is the control: report immediately and let Compliance and IT contain and assess. Suspected breaches count.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-105'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
