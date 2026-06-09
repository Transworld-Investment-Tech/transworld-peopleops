-- =============================================================================
-- seed_ops203_content.sql  (v0.63.0)
-- OPS-203: Internal controls & the control environment — lesson + 20-question check (Proficient).
-- Authored FROM POLICY / BUILD+SOURCE off the firm's own manuals (read-first OCR).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps OPS-203 to live job profiles (verified live, query 3 / verify_p4.sql),
--   so publishing alone surfaces it as assigned work. Publish-only (REG pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Most people meet internal control as a set of checks they have to perform. This module steps back to show the structure those checks live inside — the control environment, the lines of defence, and the way compliance and internal control fit together — so that you understand not just what you do, but why the firm is built the way it is. A broker-dealer that handles client money and client securities cannot rely on good intentions. It relies on a deliberate architecture in which controls are designed correctly, operated by named people, and tested independently. That architecture is the subject of this module.

## What you will be able to do

1. Explain what the control environment is and why it is the foundation of internal control.
2. Describe the Three Lines of Defence and identify who sits in each.
3. Apply segregation of duties, and use compensating controls when segregation is not possible.
4. Distinguish preventive, detective, and corrective controls.
5. Explain how the compliance and internal control functions interlock, and how deficiencies are tracked to closure.

## The control environment

The control environment is the foundation of the whole framework. It is the tone, culture, and structural conditions within which every other control operates, and it depends on visible leadership commitment, clearly defined authority, and a genuine culture of accountability — not policy documents on a shelf. Several things make up that environment at the firm: a written Code of Ethics that every employee acknowledges on joining and refreshes annually; a Board-approved organisational chart and authority matrix that define roles, reporting lines, and approval limits, with no individual holding incompatible roles such as trade execution and settlement together; fit-and-proper recruitment, where regulated roles are filled by qualified people screened against SEC and NGX requirements before any offer; active Board and management oversight, with the Board meeting at least quarterly; and a confidential whistleblowing channel with protection against retaliation. None of these is a "control" you tick off on a given trade. Together they are the soil everything else grows in — and a firm with weak soil cannot grow strong controls no matter how many checklists it writes.

A point worth drawing out: the authority matrix is where much of the control environment becomes concrete. It sets approval limits for payments, trade authorisations, contractual commitments, and regulatory submissions, and it deliberately keeps incompatible roles apart — trade execution separated from settlement, payment initiation separated from payment approval. When the matrix is respected, segregation happens by design rather than by goodwill; when it is bypassed "just this once," the control environment has already started to erode, regardless of how many downstream checks exist.

## The Three Lines of Defence

Effective internal control needs clear ownership at every level, and the firm organises that ownership into three lines. The first line is the business and operations owners — the Head of Operations, the Head of Trading, the Finance Lead, the Technology Lead — who design and operate the day-to-day controls in their own processes, maintain records, and resolve first-level exceptions. They run the process and own its controls. The second line is the Compliance Officer and the Internal Control or Risk Officer, who set policy standards, monitor adherence, perform thematic reviews, challenge breaches, and report to management and the Board. They do not run the process; they set the standard and check it. The third line is internal audit or internal control assurance, which independently assesses whether controls are well designed and operating effectively and tracks remediation to closure, reporting functionally to the Board Audit, Risk and Compliance Committee. Above all three sits the Board, which approves the framework, sets the tone at the top, and reviews significant incidents and remediation. The principle that holds the model together is independence of review: first-line operators may perform controls, but second and third lines must independently challenge them, and no function may audit itself.

## Segregation of duties and compensating controls

A single principle prevents a large share of operational fraud and error: no one individual should initiate, approve, execute, record, and reconcile the same transaction end to end. This is segregation of duties, and it is why the person who raises a payment is not the person who approves it, and the person who executes a trade is not the one who settles it. In a firm of fifteen people, perfect segregation is not always possible, and the Framework anticipates this: where segregation cannot be achieved because of staffing, compensating controls must be applied and documented — management review, dual sign-off, or independent reconciliation. The key word is documented. A staffing constraint is an acceptable reason to compensate; it is never an acceptable reason to leave a gap unaddressed. Alongside segregation sits client-asset protection — client money and securities are kept segregated from the firm's own at all times — and timely escalation, the discipline of moving exceptions, breaches, and unreconciled differences quickly to management, the Board, and where required the regulator.

## Preventive, detective, and corrective controls

Controls do different jobs, and knowing which job a control does helps you design and rely on it. A preventive control stops an error or breach from happening in the first place — the mandate check before a trade, the approval limit that blocks an unauthorised payment, the access right that is never granted. A detective control catches something that has already happened — the daily reconciliation that surfaces a settlement break, the monthly trade sample that finds a conduct issue, the exception report. A corrective control puts things right and stops a recurrence — the error-trade process, the remediation action that closes an audit finding. A healthy control set is not all of one kind. Preventive controls reduce how often things go wrong; detective controls ensure that when something slips through it is found quickly; corrective controls turn a single failure into a lasting fix. Designing a process means deciding, for each risk, which combination you need.

## How compliance and internal control interlock

The compliance function and the internal control function are distinct but deeply interconnected, and confusing them is a common error. A useful way to hold the difference: internal control asks "are our controls designed correctly and operating as intended?" while compliance asks "are we meeting our external obligations to regulators, clients, and the law?" Both questions are necessary. A firm with excellent controls but poor regulatory compliance will face enforcement; a firm with good compliance records but weak controls is sitting on a risk that has not yet crystallised. Where a control exists to meet a specific regulatory requirement — the mandate-verification check before a trade is a clean example — it falls within both frameworks at once. In practice the Compliance Officer and the Internal Control Officer maintain a joint monitoring programme covering all key risk areas, ensuring there is no gap between what is required and what is checked, and they jointly prepare the quarterly Compliance and Control Pack for the Board Audit, Risk and Compliance Committee. The Internal Control Officer is the custodian of the Risk Register — the living record of the firm's risks and their controls — which is reviewed quarterly and presented to the Board committee.

The joint monitoring programme is not abstract: it maps named risk areas to the monitoring each function performs and the output that goes to the Board. Client onboarding and KYC draws a monthly sample review from compliance and an annual control-design audit from internal control. Trade execution draws a monthly trade-sample best-execution review and a quarterly audit of jobbing procedures and access controls. AML/CFT draws transaction monitoring and filing-accuracy checks alongside an annual programme audit. Settlement draws monthly bank reconciliation checks and quarterly testing. For each, the programme makes explicit which control is watching which obligation, so there is no quiet gap between what the rules require and what the firm actually checks — and that, more than any single control, is what an examiner is looking for.

## Testing, deficiencies, and closure

Designing a control is not the same as knowing it works. The third line tests controls against the firm's documentation standard and reports where a control is poorly designed or not operating. Every key control has a named owner, a defined frequency, and a required evidence output, and the Internal Control Officer maintains a live Control Register; each function head performs a quarterly self-assessment attesting that the controls in their area operated as intended. Where testing finds a weakness, it goes into the Deficiency Register and is tracked to verifiable closure — not noted and forgotten. This is the loop that makes the whole architecture self-correcting: controls are designed, operated, evidenced, tested, and where they fall short, remediated and re-tested. A firm that tests and closes is one that learns; a firm that finds and forgets is one that will meet the same failure again, larger.

## A worked example

**Illustration — one trade through three lines (entirely hypothetical).** A client buy order is executed. In the first line, the Operations Officer performs the mandate and pre-trade checks, the Group Head approves the jobbing entry, the Settlement Officer settles it, and the Accounts team reconciles the day's settlement — each step a control the business owns and evidences. In the second line, the Compliance Officer's monthly 10% trade sample picks up this trade and checks best execution and mandate compliance; the Internal Control Officer's monitoring confirms the reconciliation was performed and signed. In the third line, the quarterly internal audit of jobbing procedures and access controls tests whether the design held across the period. Suppose the audit finds that, on a busy day, one jobbing entry was released without the Group Head's approval — a segregation breach. It goes into the Deficiency Register, the Head of Operations agrees a remediation (a system control that blocks release without approval), and the fix is tracked to closure and re-tested next quarter. One trade, three lines, a deficiency caught and closed — the architecture working as designed.

## Common traps

- **Confusing the three lines.** The first line runs and owns controls; the second sets standards and monitors; the third independently tests. No function audits itself.
- **Thinking compliance "owns" all controls.** First-line business owners own and operate their controls; compliance sets the standard and monitors.
- **Treating a control as done because it was performed.** A control must also be designed correctly, evidenced, and tested — performance alone is not assurance.
- **Leaving a segregation gap unaddressed.** Where staffing prevents segregation, a documented compensating control is required; a gap is not.
- **Finding a deficiency and forgetting it.** Deficiencies go into the Register and are tracked to verifiable closure and re-test.

## Key takeaways

- The control environment — Code of Ethics, authority matrix, fit-and-proper hiring, Board oversight, whistleblowing — is the foundation every other control depends on.
- The Three Lines of Defence separate those who run controls (first), those who set standards and monitor (second), and those who independently test (third), under Board oversight; no function audits itself.
- Segregation of duties prevents one person controlling a transaction end to end; where staffing prevents it, a documented compensating control is required.
- Controls are preventive, detective, or corrective; a healthy process combines them deliberately for each risk.
- Compliance asks whether external obligations are met and internal control asks whether controls work; they interlock through the joint monitoring programme, the Risk Register, and the quarterly Board pack, with deficiencies tracked to closure.

*Reference: the Internal Control Framework v3.0 — the control philosophy and principles, the Three Lines of Defence, the control environment, the Risk Register, and the Control and Deficiency Registers — together with the Compliance Manual v3.0 (how compliance and internal control work together, and the joint monitoring programme) and the Internal Audit Program v1.0 (independent testing and remediation). Regulatory references are taught to the current Investments and Securities Act 2025; older "ISA 2024" references in the source documents are logged for correction. The frameworks are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'OPS-203';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_01$id$, m.id, $p$The control environment is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the list of daily checks on a trade"}, {"key": "b", "text": "the tone, culture, and structural conditions in which all other controls operate"}, {"key": "c", "text": "the firm's IT network"}, {"key": "d", "text": "the external auditor's workplan"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The control environment is the foundation — leadership tone, defined authority, and a culture of accountability — within which every other control operates.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_02$id$, m.id, $p$Which of these is part of the control environment?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a single trade reconciliation"}, {"key": "b", "text": "the Code of Ethics, the authority matrix, fit-and-proper hiring, Board oversight, and whistleblowing"}, {"key": "c", "text": "the day's share prices"}, {"key": "d", "text": "a client's contract note"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$These structural elements make up the control environment; they are the conditions in which specific controls operate, not controls on a single transaction.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_03$id$, m.id, $p$In the Three Lines of Defence, the FIRST line is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "internal audit"}, {"key": "b", "text": "the business and operations owners who design and operate day-to-day controls"}, {"key": "c", "text": "the Compliance Officer"}, {"key": "d", "text": "the Board"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The first line is business and operations owners (Heads of Operations, Trading, Finance, Technology) who run processes and own their controls.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_04$id$, m.id, $p$The SECOND line of defence is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the dealing clerks"}, {"key": "b", "text": "the Compliance Officer and the Internal Control / Risk Officer, who set standards and monitor"}, {"key": "c", "text": "internal audit"}, {"key": "d", "text": "the external registrar"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The second line sets policy standards, monitors adherence, challenges breaches, and reports to management and the Board.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_05$id$, m.id, $p$The THIRD line of defence...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "executes client trades"}, {"key": "b", "text": "independently assesses control design and operating effectiveness and tracks remediation to closure"}, {"key": "c", "text": "approves payments"}, {"key": "d", "text": "sets the firm's strategy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The third line (internal audit / control assurance) independently tests controls and tracks remediation, reporting functionally to the Board Audit, Risk and Compliance Committee.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_06$id$, m.id, $p$'No function may audit itself' expresses the principle of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "data minimisation"}, {"key": "b", "text": "independence of review"}, {"key": "c", "text": "client-asset protection"}, {"key": "d", "text": "best execution"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Independence of review: first-line operators may perform controls, but second and third lines independently challenge them, and no function audits itself.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_07$id$, m.id, $p$Segregation of duties means no one person should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "work in operations"}, {"key": "b", "text": "initiate, approve, execute, record, and reconcile the same transaction end to end"}, {"key": "c", "text": "hold a CSCS account"}, {"key": "d", "text": "attend Board meetings"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Segregation prevents one individual controlling a transaction from start to finish — which is where a large share of fraud and error originates.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_08$id$, m.id, $p$In a small firm where full segregation is not possible, you must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "accept the gap as unavoidable"}, {"key": "b", "text": "apply and document compensating controls such as management review, dual sign-off, or independent reconciliation"}, {"key": "c", "text": "stop performing the activity"}, {"key": "d", "text": "ask the client to approve"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Where staffing prevents segregation, documented compensating controls are required; a staffing constraint justifies compensation, never an unaddressed gap.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_09$id$, m.id, $p$A control that STOPS an error from happening in the first place is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "detective"}, {"key": "b", "text": "preventive"}, {"key": "c", "text": "corrective"}, {"key": "d", "text": "optional"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Preventive controls (e.g., the mandate check, an approval limit) stop an error or breach before it occurs.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_10$id$, m.id, $p$The daily reconciliation that surfaces a settlement break is an example of a...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "preventive control"}, {"key": "b", "text": "detective control"}, {"key": "c", "text": "corrective control"}, {"key": "d", "text": "compensating control only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A detective control catches something that has already happened; the daily reconciliation finds breaks after the fact.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_11$id$, m.id, $p$The error-trade process and a remediation that closes an audit finding are examples of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "preventive controls"}, {"key": "b", "text": "corrective controls"}, {"key": "c", "text": "detective controls"}, {"key": "d", "text": "control environment elements"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Corrective controls put things right and prevent recurrence — the error-trade process and remediation actions.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_12$id$, m.id, $p$Internal control asks one question; compliance asks another. Which pairing is correct?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "internal control: 'are we profitable?'; compliance: 'are we busy?'"}, {"key": "b", "text": "internal control: 'are our controls designed correctly and operating?'; compliance: 'are we meeting our external obligations to regulators, clients, and the law?'"}, {"key": "c", "text": "both ask only about profit"}, {"key": "d", "text": "internal control: 'are clients happy?'; compliance: 'is the share price up?'"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Internal control asks whether controls are well designed and operating; compliance asks whether external obligations are met. Both are necessary.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_13$id$, m.id, $p$The mandate-verification check before a trade falls within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "neither framework"}, {"key": "b", "text": "both the compliance and the internal control frameworks at once"}, {"key": "c", "text": "only marketing policy"}, {"key": "d", "text": "only the Board's remit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Where a control meets a specific regulatory requirement, it sits within both frameworks simultaneously — the mandate check is the clean example.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_14$id$, m.id, $p$Who is the custodian of the Risk Register?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client"}, {"key": "b", "text": "the Internal Control Officer"}, {"key": "c", "text": "the external auditor"}, {"key": "d", "text": "the dealing desk"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Internal Control Officer maintains the Risk Register, which is reviewed quarterly and presented to the Board committee.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_15$id$, m.id, $p$The Compliance Officer and Internal Control Officer jointly prepare, each quarter...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the payroll run"}, {"key": "b", "text": "the Compliance and Control Pack for the Board Audit, Risk and Compliance Committee"}, {"key": "c", "text": "the marketing plan"}, {"key": "d", "text": "client contract notes"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$They maintain a joint monitoring programme and jointly prepare the quarterly Compliance and Control Pack for the BARC.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_16$id$, m.id, $p$When testing finds a control weakness, it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "noted informally and forgotten"}, {"key": "b", "text": "recorded in the Deficiency Register and tracked to verifiable closure, then re-tested"}, {"key": "c", "text": "ignored if the owner disagrees"}, {"key": "d", "text": "escalated only at year-end"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Deficiencies go into the Register and are tracked to verifiable closure and re-test — the loop that makes the architecture self-correcting.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_17$id$, m.id, $p$Each function head performs, each quarter, a...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "client survey"}, {"key": "b", "text": "self-assessment attesting that the controls in their area operated as intended"}, {"key": "c", "text": "price forecast"}, {"key": "d", "text": "new hire"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Function heads complete a quarterly self-assessment/attestation that their key controls operated as intended; the IC Officer maintains the live Control Register.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_18$id$, m.id, $p$A control that was performed but is poorly designed and never tested is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully assured"}, {"key": "b", "text": "not assurance — a control must be designed correctly, evidenced, and tested, not merely performed"}, {"key": "c", "text": "exempt from audit"}, {"key": "d", "text": "the Board's responsibility alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Performance alone is not assurance; the control must also be well designed, evidenced, and independently tested.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_19$id$, m.id, $p$Client money and securities must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "pooled with the firm's own assets for efficiency"}, {"key": "b", "text": "segregated from the firm's proprietary assets at all times"}, {"key": "c", "text": "held by the dealing desk"}, {"key": "d", "text": "used to cover firm shortfalls when needed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client-asset protection requires client money and securities to be segregated from proprietary assets at all times and handled only for authorised purposes.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ops203_20$id$, m.id, $p$Regulatory references in this module are taught to which statute?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ISA 2024"}, {"key": "b", "text": "the current Investments and Securities Act 2025"}, {"key": "c", "text": "there is no governing Act"}, {"key": "d", "text": "the 1999 Act"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The current statute is the Investments and Securities Act 2025; older 'ISA 2024' references in source documents are superseded and logged for correction.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'OPS-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'OPS-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: OPS-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'OPS-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: OPS-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: OPS-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
