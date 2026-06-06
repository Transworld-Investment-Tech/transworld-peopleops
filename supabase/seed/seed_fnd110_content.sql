-- ===========================================================================
-- FND-110 Documentation discipline ('what is not documented did not happen') -- lesson only (v0.46.0 content)
-- Tier B, FROM POLICY. Sources: ICF v3.0 §1 + Operational Manual v3.0 §19;
--   supporting WS2 Behavior 5 + WS1 Part 2 §8 + Retreat Report + Compliance Manual. Owner: CCO (function review).
-- Lesson-only: no graded check; pass_mark stays NULL. Publishes on run.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish (lesson-only; pass_mark stays NULL)
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
    estimated_minutes = 15,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-110';

COMMIT;
