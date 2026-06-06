-- ===========================================================================
-- seed_fnd110_content.sql -- FND-110 Documentation discipline: lesson + 10-question check (v0.46.1 content)
-- Tier B, FROM POLICY (CCO function review). Sources: ICF v3.0 §1 + Operational Manual v3.0 §19.
-- v0.46.1: a 10-question server-graded check (80% pass) was ADDED to this previously lesson-only
--   module. Owner-reviewed; Tier C/B -> NO CCO hard gate; publishes on run.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$There is a single sentence that does more to protect Transworld than almost any control we own: **what is not documented did not happen.** It is one of the firm's six behaviors — Trust Through Documentation — and it is also the operating principle behind our internal controls. This module explains what it means, why it matters in a regulated firm, and the documentation habits expected of everyone.

## Why documentation is a control, not paperwork

In a regulated broker-dealer, trust is built on a reliable record. The Internal Control Framework states the principle bluntly: every key control must leave a trace, and **a control that happened but left no evidence is treated as a control that did not happen.** Evidence is not bureaucracy — it is the proof that the right thing was actually done. It includes signed checklists, reports, system logs, reconciliations, approval emails, and committee minutes. When a regulator inspects, an auditor tests, or a dispute arises, the record is what speaks for you. A perfectly performed task with no evidence cannot be relied on; a modest task with a clear trail can.

>! Documentation is the control. The question is never "did I do it?" but "can I show I did it?" If the answer is no, the work is, for control purposes, incomplete.

## The habits this asks of you

- **Document as you go, not later.** Capture the decision, the approval, and the date when they happen — memory and reconstruction are not evidence.
- **Record who, what, and when.** A useful record answers who did it, what was done, and when. Approvals belong in writing — an email or a portal action, not a corridor conversation.
- **Keep the trail where it belongs.** File records securely in the right place (the portal, the client file, the Evidence Vault) so they can be produced on request, not hunted for.
- **Communicate proactively.** Tell people what they need to know before they have to ask; a documented heads-up is itself part of the record.

## Separation of duties — and the audit trail that backs it

Good documentation underpins another control principle: **segregation of duties** — no single person should initiate, approve, execute, record, and reconcile the same transaction end to end. Where the firm is too lean to separate every step, compensating controls apply — management review, dual sign-off, independent reconciliation — and these *must be documented*. At Transworld the portal supports this directly: where a leader transacts on their own record, the system stamps it as self-approved for the audit log. The action is permitted, but it is visible — and the **audit trail is the control.** Visibility, not prohibition, is how a lean firm stays honest.

## Client records and how long we keep them

Client records are the firm's institutional memory and a regulatory requirement; complete, accurate, secure records underpin every compliance obligation and provide the audit trail regulators expect. The Operational Manual sets the standards: accuracy (corrected only through an authorized update process), secure storage (locked cabinets for physical files; access-controlled systems for digital), restricted access with an access log, and defined retention. The headline retention rule is a **minimum of seven years** — client account documents seven years from closure, trade mandates and contract notes seven years from the transaction or issue date, AML/KYC records seven years after the relationship ends — while board and management approvals are kept **permanently** and regulatory correspondence for **ten years**. The Compliance Officer maintains the full Record Retention Schedule.

> When in doubt about whether to keep a record, keep it, file it properly, and check the Retention Schedule — under-retention is the riskier mistake.

## Putting it together

Documentation discipline is where the firm's culture and its controls meet. The behavior — *what is not documented did not happen* — is not a slogan; it is the daily practice that lets a small, regulated firm prove it did the right thing, protect its people in a dispute, and pass an inspection without a scramble. Every checklist you complete, every approval you capture, every record you file properly is a small deposit in the firm's reservoir of trust.

## Key takeaways

- **What is not documented did not happen** — a control with no evidence is treated as one that did not occur.
- Evidence means **signed checklists, logs, reconciliations, approval emails, and minutes** — captured as you go.
- A good record answers **who, what, and when**; approvals belong in writing.
- **Segregation of duties** is backed by documentation; where steps can't be separated, compensating controls are applied **and documented** — and the **audit trail is the control**.
- Client records are kept a **minimum of seven years** (approvals permanently; regulatory correspondence ten years); the Compliance Officer holds the Retention Schedule.

## References

- **Internal Control Framework v3.0, §1 (Purpose, Scope & Control Philosophy — the evidence-based control principle)** — primary source.
- **Operational & Procedure Manual v3.0, §19 (Client Record Management & Retention)** — primary source.
- Supporting: **WS2, Behavior 5 — Trust Through Documentation**; **WS1 Part 2, §8 (separation of duties; the audit trail as control)**; the Transworld Retreat Report 2026 (origin of the documentation principle); Compliance Manual v3.0.
- *Foundational module · content owner: Chief Compliance Officer (function review). Tier B — authored from policy. Lesson-only.*$body$,
    pass_mark = 80,
    estimated_minutes = 15,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-110';

-- 2. the 10-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_01$id$, m.id, $p$According to the Internal Control Framework, a key control that happened but left no evidence is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Still fully effective"}, {"key": "b", "text": "Treated as a control that did not happen"}, {"key": "c", "text": "Acceptable if a manager remembers it"}, {"key": "d", "text": "Only a problem during audits"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every key control must leave a trace. A control that happened but left no evidence is treated as a control that did not happen.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_02$id$, m.id, $p$Which of these count as evidence of a control? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Signed checklists and reconciliations"}, {"key": "b", "text": "System logs and approval emails"}, {"key": "c", "text": "Committee minutes"}, {"key": "d", "text": "An unrecorded verbal agreement in the corridor"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Evidence includes signed checklists, reports, system logs, reconciliations, approval emails, and committee minutes. A verbal, unrecorded agreement is not evidence.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_03$id$, m.id, $p$The recommended documentation habit is to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Reconstruct records from memory at year-end"}, {"key": "b", "text": "Document as you go — capture the decision, approval, and date when they happen"}, {"key": "c", "text": "Wait until an inspection is announced"}, {"key": "d", "text": "Let someone else document it later"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Document as you go, not later — memory and reconstruction are not evidence.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_04$id$, m.id, $p$A useful record answers:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only what was done"}, {"key": "b", "text": "Who did it, what was done, and when — with approvals in writing"}, {"key": "c", "text": "Only who approved it"}, {"key": "d", "text": "Nothing in particular, as long as a file exists"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A good record answers who, what, and when; approvals belong in writing — an email or a portal action, not a corridor conversation.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_05$id$, m.id, $p$Segregation of duties means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "One trusted person should handle a transaction end to end"}, {"key": "b", "text": "No single person should initiate, approve, execute, record, and reconcile the same transaction end to end"}, {"key": "c", "text": "Only senior staff may record transactions"}, {"key": "d", "text": "Duties never need to be separated in a small firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No single person should initiate, approve, execute, record, and reconcile the same transaction end to end.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_06$id$, m.id, $p$When the firm is too lean to separate every step of a process, the firm must:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Ignore the control"}, {"key": "b", "text": "Apply compensating controls — management review, dual sign-off, or independent reconciliation — and document them"}, {"key": "c", "text": "Wait until it can hire more staff"}, {"key": "d", "text": "Let one person do everything without a record"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Where segregation is not possible, compensating controls (management review, dual sign-off, independent reconciliation) must be applied and documented.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_07$id$, m.id, $p$When a leader transacts on their own record in the portal, the system:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Blocks it entirely"}, {"key": "b", "text": "Stamps it as self-approved for the audit log — permitted but visible"}, {"key": "c", "text": "Hides it from the audit log"}, {"key": "d", "text": "Emails the whole firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal stamps such actions as self-approved for the audit log. The action is permitted but visible — the audit trail is the control.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_08$id$, m.id, $p$The minimum retention period for client records is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "1 year"}, {"key": "b", "text": "3 years"}, {"key": "c", "text": "7 years"}, {"key": "d", "text": "No minimum"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Client records are kept a minimum of seven years (longer where a specific regulatory obligation requires it).$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_09$id$, m.id, $p$Under the Record Retention Schedule, which is retained the longest?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Contract notes — 7 years from issue"}, {"key": "b", "text": "AML/KYC records — 7 years after the relationship ends"}, {"key": "c", "text": "Board and management approvals — permanently"}, {"key": "d", "text": "Complaint records — 7 years from closure"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Board and management approvals are kept permanently; regulatory correspondence is kept for ten years; most client records for a minimum of seven years.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd110_10$id$, m.id, $p$Who maintains the firm's Record Retention Schedule?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Each employee for their own records"}, {"key": "b", "text": "The Compliance Officer"}, {"key": "c", "text": "The external auditor"}, {"key": "d", "text": "The IT Lead"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer maintains the full Record Retention Schedule.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-110'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
