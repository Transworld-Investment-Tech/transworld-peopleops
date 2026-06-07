-- seed_ppl101_content.sql
-- Transworld PeopleOps Portal -- Batch 4 (v0.51.0) LMS content -- PPL-101
-- Idempotent: module UPDATE by code + questions upsert ON CONFLICT (id). Run in the Supabase SQL Editor.
BEGIN;

UPDATE "learning_modules"
SET body=$body$# The People Operations function: charter, mandate & the employee lifecycle

Every organization manages its people somehow. The question is whether it does so by improvisation or by design. At its February 2026 retreat, Transworld's leadership made a clear choice: the firm would move from informal, improvised people management to a structured, documented, and consistently applied HR framework. The People Operations function exists to deliver and sustain that framework. This module explains what People Ops is for, what it does and does not do, who approves what, the annual rhythm it runs on, and the portal it runs through — so that wherever you sit in the firm, you understand the machinery and where you fit within it.

> People Ops is not a back-office overhead. It is the engine that protects the firm's regulatory standing, ensures employees are treated fairly and consistently, and builds the institutional capability that clients and regulators expect from a professional dealing member. Its outputs — policies, processes, records, and decisions — are the documented evidence that Transworld manages its people lawfully and fairly.

---

## Why People Operations exists

As a regulated dealing member of the NGX, Transworld is held to a standard. Regulators expect documented processes; clients expect professionalism; employees expect fairness. People Ops is how the firm meets all three at once. It does not operate as a standalone silo: it works under the authority of the **Chief Operating Officer**, partners closely with **Compliance** on every conduct and regulatory matter, and serves every department in the firm. The People-Ops Officer reports to the COO and attends the Board Remuneration Committee as its secretary.

The function's value is in its consistency. When recruitment, pay, performance, and discipline are run the same way every time, against written standards, the firm is protected from the two great risks of informal HR: unfairness to individuals and exposure to the regulator. The records People Ops keeps are the proof, after the fact, that the firm acted properly.

---

## The mandate — and its boundaries

The People-Ops Officer is responsible for the end-to-end execution of the firm's HR processes. On any given day that includes maintaining complete and current staff files, running the monthly payroll control process, managing the recruitment pipeline, administering the performance cycle, processing leave, administering learning and development and mandatory-training compliance, maintaining the PeopleOps portal, handling employee-relations matters under the supervision of the COO and Compliance, and preparing reports for the COO and the Board Remuneration Committee.

Just as important is what People Ops does **not** do. Clarity about boundaries prevents errors:

- **It does not process or pay salaries.** HumanManager and Remita remain the authoritative payroll and payment systems. The portal is a control layer, not a payment system.
- **It does not make unilateral employment decisions at G3 and above** — those require COO or MD approval.
- **It does not run disciplinary investigations alone** where regulatory conduct is implicated — Compliance is involved.
- **It does not give legal advice** — employment-law questions go to external counsel.
- **It does not approve its own leave or expenses** — the COO approves them.

> These boundaries are not limits on competence; they are controls. A function that records, recommends, and executes must not also be the sole approver of its own actions, or the firm loses the separation that makes its decisions trustworthy.

---

## Who approves what — the authority matrix

Every HR action at Transworld has a defined authority level. No offer, contract change, disciplinary outcome, termination, or salary adjustment is valid without the appropriate approver's sign-off, documented in writing. The authority matrix is the single reference for who can authorize what. A few of its key lines:

- **New hires** — G0 to G2 are approved by the COO on a People Ops recommendation; G3 by the MD on a COO recommendation; **G4 and G5 by the Board / Chairman, and this cannot be delegated.**
- **Offer letters and contracts** — issued by People Ops for G0–G2, the COO for G3, the MD for G4 and above.
- **Pay** — salary within band at hire is approved by the COO for G0–G3 and the MD for G4+; a within-cycle, non-raise adjustment is approved by the MD for all grades.
- **Firm-wide raises** and the **bonus pool** are approved by the **Board Remuneration Committee**.
- **Individual bonus payments** — the COO for G0–G3, the MD for G4+.
- **Discipline** climbs a ladder: a verbal warning (line manager, documented by People Ops), a written warning (COO, on recommendation), dismissal for capability (MD, with COO and People Ops recommendation), and dismissal for **gross misconduct (MD, with Compliance sign-off).**

The governing rule sits beneath all of these: People Ops must never issue an employment document on verbal instruction alone. No offer, contract, warning, or termination is valid without the appropriate authority sign-off in writing.

---

## Oversight: the Board Remuneration Committee

The most sensitive decisions — what people are paid — are governed by the **Board Remuneration Committee (RemCom)**. Its existence ensures that pay decisions are made with proper oversight, free from individual conflicts of interest, and in compliance with the NCCG 2018 principle that executives do not set their own remuneration.

Its composition reflects that purpose. The **Chairman** chairs the committee; one **Non-Executive Director** brings independence; the **Managing Director** is the executive member; the **CFO** provides financial oversight; and the **People-Ops Officer serves as secretary** — preparing papers, recording minutes, but **not voting**. A strict **recusal rule** applies: any member whose own compensation is under discussion must step out of that item, including the Chairman and the MD when their own pay is reviewed.

RemCom's responsibilities include approving the **annual bonus pool — calculated as 15% of audited profit before tax — before April payment**, approving individual bonus allocations for G4 and G5, approving the raise milestones and percentages before they are published to staff, approving G4/G5 appointments and terminations, and reviewing the Compensation Framework. It meets at minimum twice a year — in March/April to approve the bonus pool and payment, and in Q3 to review the raise mechanism — with additional meetings as material decisions require. Quorum is three members including at least one NED or the Chairman, and minutes are signed by the Chair within five working days.

---

## The annual rhythm is the employee lifecycle

People Ops runs on a predictable annual calendar, and that calendar is really the employee lifecycle in motion — attract, hire, onboard, develop, reward, and, when the time comes, exit. The performance cycle follows the **calendar year**.

- **January** — mandatory training assignments go out for the year and the compliance tracker is updated; leave entitlements are confirmed and sick-leave balances reset; the new performance cycle opens and goal-setting activates in the portal.
- **By 28 February** — the **goal-sealing deadline**: all employee goals are reviewed, agreed, and sealed; any goal unsealed by this date requires COO approval.
- **February to March** — RemCom papers are prepared for the April bonus (pool calculation, draft allocations by grade); the audited PBT is confirmed with the CFO and the pool finalized; individual bonus letters are prepared.
- **1–15 April** — bonuses are paid and letters distributed; senior (G4/G5) deferral entries are processed in the portal, with prior-year tranches released on schedule.
- **June** — the updated Employee Handbook is reissued if revised, and acknowledgement signatures are collected from all staff.
- **July** — the **mid-cycle review window**: People Ops issues guidance in the first week, all mid-year reviews are completed and documented in the portal by 31 July, and any manager who has not completed by 25 July is escalated.
- **August** — qualification-sponsorship review, flagging any clawback risk.
- **September** — the RemCom Q3 meeting reviews the raise mechanism and sets cycle milestones.
- **October** — the curriculum map is reviewed and mandatory-training content updated for new regulatory requirements.
- **November to December** — the year-end window: employees submit self-assessments and managers complete their assessments, all **due by 31 December**; leave balances are confirmed and lapsing balances zeroed.
- **February to March (following year)** — the calibration session, facilitated by People Ops with the COO, where final ratings are agreed and recorded before the April bonus.

Running underneath all of this are two ongoing rhythms: the **monthly payroll control cycle around the 28th**, and the **per-event** processes — hires, probations, exits, disciplinary and grievance matters — handled as they arise.

---

## The portal: a control room, not a payroll system

People Ops executes all of this through the **PeopleOps portal**, the firm's HR control room and evidence layer. It is the system of record for employee profiles and staff files, compensation profiles and the payroll control cross-check, performance goals and appraisals, leave, learning and development, recruitment, and onboarding, and it houses the document generation and signing layer. It is emphatically **not** a payroll system — HumanManager and Remita process and pay salaries.

Access follows four roles — Super Admin, HR/People Ops, Line Manager, and Employee — each seeing only what it should. A handful of operating rules keep the record trustworthy: every active employee has a login from Day 1; staff-file completeness is tracked and pursued toward a complete file for every employee; sealed performance goals are immutable, with any adjustment added as an append-only amendment; compensation changes are updated in the portal at the same time they are processed in HumanManager; formal documents are produced only through the template library; and the audit trail is treated as a compliance artifact — errors are corrected with a note, never overwritten.

> The portal does not replace this framework. As the HR Operations Manual puts it, the portal is the system of record and evidence layer, while the manual is the operating brain: the portal tells you *what*, and the manual tells you *how, why, when, and who*.

---

## Key takeaways

- People Ops exists to deliver the firm's structured HR framework; it reports to the COO, partners Compliance, serves every department, and its records are the firm's evidence that it manages people lawfully and fairly.
- Its mandate is end-to-end HR execution, but it does **not** pay salaries, make unilateral G3+ decisions, investigate conduct without Compliance, give legal advice, or approve its own leave or expenses.
- Every HR action has a defined approver: hires G0–G2 (COO), G3 (MD), G4/G5 (Board/Chairman, non-delegable); raises and the bonus pool sit with RemCom; nothing is valid without written sign-off, and never on verbal instruction alone.
- RemCom governs pay under the NCCG 2018 principle that executives do not set their own remuneration: Chairman chairs, one NED, the MD and CFO, with People Ops as non-voting secretary; it approves the bonus pool (15% of audited PBT), G4/G5 allocations, and raise milestones, with a strict recusal rule.
- The annual calendar is the employee lifecycle on a calendar-year cycle: goal-sealing by 28 February, mid-cycle review by 31 July, year-end assessments due 31 December, calibration in February–March, and bonuses in April, with monthly payroll control around the 28th.
- People Ops runs through the portal — a control room and evidence layer, not a payroll system — under least-privilege access and rules that keep sealed records immutable and the audit trail intact.

> Reference: HR Operations Manual v1.1, Part A — Chapter A1 (People Ops charter and reporting), A2 (authority matrix), A3 (Board Remuneration Committee terms of reference), A4 (the annual HR calendar), and A5 (the portal operating guide); supported by the People Ops Cadence v1.0 and Compliance Manual §13. Authored 6 June 2026.
$body$,
    pass_mark=80,
    estimated_minutes=22,
    status='PUBLISHED',
    updated_at=CURRENT_TIMESTAMP
WHERE code='PPL-101';

-- Fail loud if the module shell is absent (run seed_lms_curriculum.sql first).
DO $guard$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE code='PPL-101') THEN
    RAISE EXCEPTION 'Module PPL-101 not found -- run seed_lms_curriculum.sql first';
  END IF;
END $guard$;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_01$id$, m.id, $p$The People-Ops Officer reports to:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The Managing Director directly"}, {"key": "b", "text": "The Chief Operating Officer (COO)"}, {"key": "c", "text": "The Board Chairman"}, {"key": "d", "text": "The CFO"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$People Ops operates under the authority of the COO, supported functionally by Compliance.$e$, 1, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_02$id$, m.id, $p$At the Board Remuneration Committee, the People-Ops Officer serves as:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "A voting member"}, {"key": "b", "text": "The chair"}, {"key": "c", "text": "Secretary — attends and prepares papers but does not vote"}, {"key": "d", "text": "An external adviser"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$People Ops is the non-voting secretary: prepares papers, records minutes, but does not vote.$e$, 2, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_03$id$, m.id, $p$Select all of the following that People Operations does NOT do.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Process or pay salaries"}, {"key": "b", "text": "Give legal advice"}, {"key": "c", "text": "Approve its own leave or expenses"}, {"key": "d", "text": "Maintain staff files"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$People Ops does not pay salaries, give legal advice, or approve its own leave; maintaining staff files is a core duty.$e$, 3, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_04$id$, m.id, $p$New hires at G4 and G5 are approved by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The COO"}, {"key": "b", "text": "People Ops"}, {"key": "c", "text": "The Board / Chairman, and this cannot be delegated"}, {"key": "d", "text": "The line manager"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$G4 and G5 hires are a Board/Chairman decision that cannot be delegated.$e$, 4, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_05$id$, m.id, $p$New hires at G0 to G2 are approved by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The COO, on a People Ops recommendation"}, {"key": "b", "text": "The Board / Chairman"}, {"key": "c", "text": "People Ops alone"}, {"key": "d", "text": "The CFO"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$G0–G2 hires are approved by the COO on a People Ops recommendation.$e$, 5, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_06$id$, m.id, $p$Firm-wide raises and the bonus pool are approved by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The COO"}, {"key": "b", "text": "The Board Remuneration Committee"}, {"key": "c", "text": "People Ops"}, {"key": "d", "text": "Each line manager for their team"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Firm-wide raise activation and bonus pool approval sit with the Board Remuneration Committee.$e$, 6, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_07$id$, m.id, $p$The annual bonus pool is calculated as:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "10% of revenue"}, {"key": "b", "text": "15% of audited profit before tax (PBT)"}, {"key": "c", "text": "A fixed naira amount set each year"}, {"key": "d", "text": "25% of net assets"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$RemCom approves the bonus pool calculated as 15% of audited PBT before the April payment.$e$, 7, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_08$id$, m.id, $p$Dismissal for gross misconduct requires:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "People Ops alone"}, {"key": "b", "text": "The line manager's decision"}, {"key": "c", "text": "The MD, with Compliance sign-off"}, {"key": "d", "text": "A simple majority of the team"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Dismissal for gross misconduct is decided by the MD, with Compliance sign-off, escalating to the Chairman.$e$, 8, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_09$id$, m.id, $p$People Ops may issue an employment document on a verbal instruction alone.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No offer, contract, warning, or termination is valid without the appropriate authority sign-off in writing.$e$, 9, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_10$id$, m.id, $p$The Board Remuneration Committee is chaired by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The Managing Director"}, {"key": "b", "text": "The Chairman"}, {"key": "c", "text": "The CFO"}, {"key": "d", "text": "The People-Ops Officer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Chairman chairs the RemCom; the MD and CFO are members and a NED brings independence.$e$, 10, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_11$id$, m.id, $p$Select all statements about the Board Remuneration Committee that are correct.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "It is chaired by the Chairman"}, {"key": "b", "text": "People Ops is its non-voting secretary"}, {"key": "c", "text": "Quorum is three members including at least one NED or the Chairman"}, {"key": "d", "text": "The MD sets his own remuneration"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$The Chairman chairs, People Ops is non-voting secretary, and quorum is three including a NED or the Chairman; no one sets their own pay.$e$, 11, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_12$id$, m.id, $p$The RemCom recusal rule means:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Members may never discuss pay"}, {"key": "b", "text": "Any member whose own compensation is under discussion steps out of that item"}, {"key": "c", "text": "Only the NED may vote on pay"}, {"key": "d", "text": "The secretary decides contested items"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A member whose own pay is being discussed must recuse from that item — including the Chairman and MD for their own pay.$e$, 12, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_13$id$, m.id, $p$The RemCom's governance basis is the NCCG 2018 principle that:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Executives set their own remuneration efficiently"}, {"key": "b", "text": "Executives do not set their own remuneration"}, {"key": "c", "text": "Pay must always rise each year"}, {"key": "d", "text": "Only the Board may employ staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$RemCom exists so pay is decided with oversight and executives do not set their own remuneration.$e$, 13, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_14$id$, m.id, $p$The goal-sealing deadline in the annual calendar is:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "31 January"}, {"key": "b", "text": "28 February"}, {"key": "c", "text": "30 June"}, {"key": "d", "text": "31 December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$All goals must be reviewed, agreed, and sealed by 28 February; any unsealed goal then needs COO approval.$e$, 14, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_15$id$, m.id, $p$The mid-cycle review window is:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "April, completed by 30 April"}, {"key": "b", "text": "July, completed and documented by 31 July"}, {"key": "c", "text": "September, completed by 30 September"}, {"key": "d", "text": "There is no mid-cycle review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Mid-year reviews run in July and must be completed and documented in the portal by 31 July.$e$, 15, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_16$id$, m.id, $p$Year-end self-assessments and manager assessments are due by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "31 December"}, {"key": "b", "text": "28 February"}, {"key": "c", "text": "15 April"}, {"key": "d", "text": "31 July"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The year-end assessment window closes on 31 December.$e$, 16, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_17$id$, m.id, $p$Bonuses are paid in:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "December"}, {"key": "b", "text": "January"}, {"key": "c", "text": "April (1–15 April)"}, {"key": "d", "text": "July"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Bonuses are paid 1–15 April against the prior year's audited financials, with deferral entries processed then.$e$, 17, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_18$id$, m.id, $p$The monthly payroll control cycle runs around the:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "1st of the month"}, {"key": "b", "text": "15th of the month"}, {"key": "c", "text": "28th of the month"}, {"key": "d", "text": "Last day of the quarter"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The payroll control cycle — prepare input, cross-check, obtain dual auth, file evidence — runs around the 28th.$e$, 18, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_19$id$, m.id, $p$The PeopleOps portal is a payroll system that pays salaries.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal is a control room and evidence layer; HumanManager and Remita process and pay salaries.$e$, 19, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_ppl101_20$id$, m.id, $p$The performance cycle follows:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The calendar year (January–December)"}, {"key": "b", "text": "A June-to-May year"}, {"key": "c", "text": "Each employee's hire anniversary"}, {"key": "d", "text": "A rolling quarter"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The cycle is calendar-year: goals in January, mid-cycle in July, year-end in November–December.$e$, 20, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='PPL-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

COMMIT;
