-- seed_tec101_content.sql
-- Transworld PeopleOps Portal -- Batch 4 (v0.51.0) LMS content -- TEC-101
-- Idempotent: module UPDATE by code + questions upsert ON CONFLICT (id). Run in the Supabase SQL Editor.
BEGIN;

UPDATE "learning_modules"
SET body=$body$# Using the PeopleOps portal & the firm's systems

Almost everything you do at Transworld that touches your employment — your profile, your goals, your leave, your training, your documents — runs through the PeopleOps portal. This module is your practical orientation: what the portal is, what it is deliberately *not*, how your access works, and the handful of operating rules that keep it trustworthy. By the end you should be able to find your way around with confidence and understand why the portal behaves the way it does.

> The portal is live in your browser. There is nothing to install. Every active employee has a login linked to their own employee record — setting that up is a Day 1 task for every new joiner, no exceptions. If you cannot sign in, that is the first thing to raise with People Ops.

---

## What the portal is — and is not

The PeopleOps portal is Transworld's **HR control room and evidence layer**. It is the firm's system of record for employee profiles and staff files, compensation profiles and the payroll control cross-check, performance goals and appraisals, leave, learning and development, recruitment, onboarding, and the documents the firm generates and signs.

It is **not a payroll system**. This is the single most important thing to understand about it. The portal does not process or pay salaries or bonuses. **HumanManager and Remita remain the authoritative systems** that calculate and pay staff. What the portal does is reproduce the monthly payroll *control sheet* — the cross-check that confirms what should be paid — and hold the evidence that the firm runs its people processes correctly. Think of it as the room where decisions are recorded and checked, not the machine that moves money.

The portal exists because Transworld committed, at its February 2026 retreat, to move from informal, improvised people management to a structured and documented system — and because that system is designed to be operated by a single People Ops officer. A small team cannot afford scattered records and half-remembered decisions; the portal concentrates the whole employee lifecycle in one place, with an audit trail, so that one person can run it and anyone with the right access can see the current, accurate state at a glance.

> A useful mental model from the HR Operations Manual: the manual is the operating brain that tells you *how, why, when, and who*; the portal is the system of record that tells you *what*. The two work together. The portal does not replace the manual, and the manual does not replace the portal.

---

## Your access depends on your role

The portal applies **least-privilege access**: you see and do only what your role allows. There are four roles.

- **Super Admin (Chairman)** — full access to every module, all data, and configuration, and can override any workflow.
- **HR / People Ops Officer** — full operational access to all HR modules; can generate and send all HR documents; cannot change compensation band structures without COO approval.
- **Line Manager** — access to their own team's performance, goals, leave requests, and onboarding tasks. A line manager **cannot** see pay details for anyone who is not their direct report.
- **Employee** — self-service access to their own profile, own goals and weekly reports, own leave requests, own development plan, and own documents. An employee cannot see any other employee's data.

This is not about secrecy for its own sake. It is how the firm protects personal and pay data, stays consistent with its data-protection obligations, and ensures that sensitive information is available to those who need it and no one else.

When you sign in, what you see is shaped by that role. Your home view surfaces the things that need your attention — goals awaiting action, a leave request in progress, a training module due — and the navigation only shows the modules you are entitled to use. If a colleague describes a screen you cannot find, it is usually because their role grants access that yours does not, not because anything is broken.

---

## A tour of what you will actually use

**Your profile and staff file.** Your record holds your personal details, role, grade, and the documents that make up your staff file. Keeping it current matters: staff-file completeness is tracked in the portal, and the firm's target is a complete file for every employee. Check that your own details are right and respond promptly when People Ops requests a missing document.

**Performance and goals.** Your goals for the cycle are set and agreed in the portal, then **sealed**. The performance cycle runs on the calendar year: goals are set early in the year, there is a mid-cycle review in July, and self-assessments and manager assessments are completed at year-end, due by 31 December. You will also file weekly reports and see your competency scorecard here.

**Leave.** You request leave in the portal; the request routes to your line manager for approval, and your balances are tracked automatically. There is no separate paper form for formal leave.

**Learning and development.** The Learning module is where your assigned and mandatory training lives — including this very lesson. Modules are graded with a knowledge check, and a passed check is recorded against your record as completion evidence. Your development plan (PADP) is here too, reviewed alongside performance at mid-year and year-end.

**Documents.** Offer letters, confirmation letters, warning and PIP letters, and other formal HR documents are produced through the portal's template library. The firm does not issue handwritten or informal letters for formal HR matters — if it is a formal employment document, it comes from the portal.

**Compensation and the payroll control cross-check.** Depending on your role, you may see compensation information. The compensation profiles in the portal feed the monthly payroll control cross-check — the control-sheet comparison that confirms pay before it is processed in HumanManager. Remember the rule above: the portal checks; HumanManager and Remita pay.

**Recruitment and onboarding (for those who run them).** If you hire or manage joiners, the portal carries the recruitment pipeline — vacancies, candidates, and the stages each candidate moves through — and the onboarding checklists that turn a signed offer into a fully set-up employee. A line manager sees the onboarding tasks for their own incoming team members; People Ops coordinates the pipeline end to end. The point is that hiring leaves a complete, reviewable trail rather than living in scattered emails and spreadsheets.

---

## The operating rules that keep the portal trustworthy

A small set of rules, drawn from the HR Operations Manual, governs how everyone uses the portal. They are worth knowing even if your role only touches a few of them.

- **Every active employee must have a login** linked to their employee record — provisioned on Day 1.
- **Staff-file completeness is pursued actively.** People Ops checks the completeness dashboard regularly and chases outstanding documents until every file is complete.
- **Sealed goals are immutable.** Once goals are sealed they cannot be edited. Any mid-cycle adjustment is **append-only**: an amendment is added and the original is left untouched. This is an immutability feature, not a limitation — it preserves an honest record of what was agreed and when.
- **Compensation changes are synchronized.** Any salary change is updated in the portal at the **same time** it is processed in HumanManager — not before, not after — so the control record and the payroll system never drift apart.
- **Formal documents go through the template library**, never around it.
- **The audit trail is a compliance artifact.** Portal records are not deleted or overwritten. If something is wrong, you **add a correction note** — you never erase the original. An erased record is destroyed evidence; an annotated correction is a transparent history.

> Notice how the last rule echoes the firm's bookkeeping discipline: correct by annotation, never by overwriting. The same principle runs through the portal, the books, and contract notes. The firm treats its records as evidence, and you do not edit evidence — you add to it.

---

## The firm's other core systems

The portal is the HR control room, but it sits alongside the systems that run the rest of the firm. **HumanManager and Remita** are the payroll and payment systems of record — they, not the portal, calculate and pay salaries. The firm's trading and operations run on the **NAYA trading platform** and the operational records described in the Operational Manual. And your everyday tools — email, shared files, your devices — are governed by the firm's IT Acceptable Use rules.

Because you handle personal data, client information, and your own credentials across all of these, basic security discipline applies everywhere: keep your login to yourself, never share credentials, treat bank and personal details as confidential, and handle data in line with the firm's data-protection obligations. The depth of that subject — passwords, phishing, safe data handling — is the focus of the cyber-hygiene module (TEC-102); treat this orientation as the starting point, not the whole story.

---

## When you need help

The portal includes an in-app **Help layer** with guidance on its pages and workflows — use it when you are unsure how something works. For anything it does not answer, People Ops is the first point of contact for HR-process questions, and IT for access or technical problems. If you spot something that looks wrong in a record, do not try to fix it by working around the system; raise it so it can be corrected properly, with a correction note and a clean trail.

---

## Key takeaways

- The portal is Transworld's HR control room and evidence layer — the system of record for profiles, performance, leave, learning, documents, and the payroll control cross-check. It is **not** a payroll system: HumanManager and Remita pay staff.
- Access follows least-privilege across four roles — Super Admin, HR/People Ops, Line Manager, Employee — so you see only what your role allows; managers cannot see pay for non-reports, and employees see only their own data.
- The performance cycle is calendar-year: goals early in the year, mid-cycle review in July, self- and manager assessments due 31 December. Sealed goals are immutable; adjustments are append-only amendments.
- Compensation changes are updated in the portal at the same time as HumanManager; formal documents come from the template library; the audit trail is never overwritten — corrections are added as notes.
- The portal sits alongside HumanManager, Remita, NAYA, and your everyday IT tools; protect your credentials and data everywhere, and look to TEC-102 for cyber-hygiene depth.
- Use the in-app Help layer first; raise access issues with People Ops or IT, and never work around the system to "fix" a record.

> Reference: Built from the Transworld PeopleOps portal itself and the App & Working Instructions (APP_INSTRUCTIONS v0.2.0), anchored to HR Operations Manual v1.1, Chapter A5 (the portal day-to-day operating guide). Authored 6 June 2026.
$body$,
    pass_mark=80,
    estimated_minutes=20,
    status='PUBLISHED',
    updated_at=CURRENT_TIMESTAMP
WHERE code='TEC-101';

-- Fail loud if the module shell is absent (run seed_lms_curriculum.sql first).
DO $guard$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE code='TEC-101') THEN
    RAISE EXCEPTION 'Module TEC-101 not found -- run seed_lms_curriculum.sql first';
  END IF;
END $guard$;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_01$id$, m.id, $p$The PeopleOps portal is best described as:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The firm's payroll and payment system"}, {"key": "b", "text": "Transworld's HR control room and evidence layer"}, {"key": "c", "text": "The NGX trading platform"}, {"key": "d", "text": "A public-facing client website"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal is the HR control room and evidence layer — the system of record for HR processes.$e$, 1, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_02$id$, m.id, $p$The portal processes and pays salaries and bonuses.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The portal does not pay anyone; it reproduces the payroll control sheet and holds evidence. HumanManager and Remita pay.$e$, 2, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_03$id$, m.id, $p$Which systems remain the authoritative payroll and payment systems?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "The portal and NAYA"}, {"key": "b", "text": "HumanManager and Remita"}, {"key": "c", "text": "Email and shared drives"}, {"key": "d", "text": "The CSCS"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$HumanManager and Remita calculate and pay staff; the portal only checks.$e$, 3, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_04$id$, m.id, $p$The portal applies which access model?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Everyone sees everything"}, {"key": "b", "text": "Least-privilege access by role"}, {"key": "c", "text": "Access decided ad hoc by IT each day"}, {"key": "d", "text": "Only the Chairman has access"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Access follows least-privilege: you see and do only what your role allows.$e$, 4, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_05$id$, m.id, $p$A Line Manager's access to pay details covers:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "All employees in the firm"}, {"key": "b", "text": "Their own direct reports only — not other employees"}, {"key": "c", "text": "No employees at all"}, {"key": "d", "text": "Only employees in other departments"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A line manager cannot see pay details for anyone who is not their direct report.$e$, 5, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_06$id$, m.id, $p$An Employee's self-service access lets them see:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Any colleague's profile and pay"}, {"key": "b", "text": "Only their own profile, goals, leave, development plan, and documents"}, {"key": "c", "text": "The whole firm's compensation register"}, {"key": "d", "text": "Other teams' performance ratings"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Employees have self-service access to their own data only; they cannot see other employees' data.$e$, 6, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_07$id$, m.id, $p$When must a new joiner's portal login be provisioned?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "After their first month"}, {"key": "b", "text": "On Day 1 — it is a Day 1 task with no exceptions"}, {"key": "c", "text": "Only if they request it"}, {"key": "d", "text": "At the end of probation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every active employee must have a login linked to their record, provisioned on Day 1.$e$, 7, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_08$id$, m.id, $p$Once performance goals are sealed in the portal, they:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Can be freely edited at any time"}, {"key": "b", "text": "Are immutable; any adjustment is added as an append-only amendment"}, {"key": "c", "text": "Are deleted and rewritten each quarter"}, {"key": "d", "text": "Become visible to all staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Sealed goals cannot be edited; adjustments are append-only amendments, preserving an honest record.$e$, 8, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_09$id$, m.id, $p$The performance cycle in the portal runs on:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "A June-to-May cycle"}, {"key": "b", "text": "The calendar year"}, {"key": "c", "text": "A rolling 18-month cycle"}, {"key": "d", "text": "Each employee's hire-date anniversary"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The performance cycle is calendar-year, with a mid-cycle review in July.$e$, 9, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_10$id$, m.id, $p$The mid-cycle performance review takes place in:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "March"}, {"key": "b", "text": "July"}, {"key": "c", "text": "October"}, {"key": "d", "text": "December"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The mid-cycle review window is July.$e$, 10, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_11$id$, m.id, $p$Year-end self-assessments and manager assessments are due by:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "30 June"}, {"key": "b", "text": "31 December"}, {"key": "c", "text": "28 February"}, {"key": "d", "text": "15 April"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Self- and manager assessments are completed at year-end, due 31 December.$e$, 11, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_12$id$, m.id, $p$When is a salary change updated in the portal relative to HumanManager?$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Before it is processed in HumanManager"}, {"key": "b", "text": "At the same time it is processed in HumanManager"}, {"key": "c", "text": "A month after HumanManager"}, {"key": "d", "text": "Only at year-end"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A salary change is updated in the portal at the same time it is processed in HumanManager — not before, not after.$e$, 12, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_13$id$, m.id, $p$Formal HR documents (offer, confirmation, warning, PIP letters) are produced:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "By hand, as needed"}, {"key": "b", "text": "Through the portal's template library"}, {"key": "c", "text": "By each manager in their own format"}, {"key": "d", "text": "By an external printer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Formal documents come from the portal template library; the firm does not issue handwritten or informal letters.$e$, 13, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_14$id$, m.id, $p$If a portal record contains an error, the correct action is to:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "Delete the record"}, {"key": "b", "text": "Overwrite it with the right value"}, {"key": "c", "text": "Add a correction note — never overwrite the original"}, {"key": "d", "text": "Ignore it until year-end"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The audit trail is a compliance artifact: you add a correction note and never overwrite or delete.$e$, 14, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_15$id$, m.id, $p$The portal is the system of record (the 'what'), while the HR Operations Manual is the operating brain (the 'how, why, when, and who').$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The portal tells you what; the manual tells you how, why, when, and who. They work together.$e$, 15, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_16$id$, m.id, $p$Which of the following are the four portal access roles?$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Super Admin"}, {"key": "b", "text": "HR / People Ops Officer"}, {"key": "c", "text": "Line Manager"}, {"key": "d", "text": "Employee"}, {"key": "e", "text": "External Auditor"}]$o$::jsonb, $c$["a", "b", "c", "d"]$c$::jsonb, $e$The four roles are Super Admin, HR/People Ops, Line Manager, and Employee; there is no External Auditor role.$e$, 16, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_17$id$, m.id, $p$The staff-file completeness target tracked in the portal is:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "A complete file for every employee"}, {"key": "b", "text": "Files only for senior staff"}, {"key": "c", "text": "Files only for new joiners"}, {"key": "d", "text": "No target is set"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Completeness is tracked and pursued toward a complete file for every employee.$e$, 17, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_18$id$, m.id, $p$Select all of the following that the portal is the system of record for.$p$, $t$MULTI$t$,
       $o$[{"key": "a", "text": "Employee profiles and staff files"}, {"key": "b", "text": "Performance goals and appraisals"}, {"key": "c", "text": "Leave requests and learning records"}, {"key": "d", "text": "Processing and paying salaries"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$The portal records profiles, performance, leave, and learning; it does not process or pay salaries.$e$, 18, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_19$id$, m.id, $p$For depth on passwords, phishing, and safe data handling, you should look to:$p$, $t$SINGLE$t$,
       $o$[{"key": "a", "text": "This module (TEC-101)"}, {"key": "b", "text": "The cyber-hygiene module (TEC-102)"}, {"key": "c", "text": "The Operational Manual settlement rules"}, {"key": "d", "text": "The bonus policy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Cyber-hygiene depth is the focus of TEC-102; this module is the orientation.$e$, 19, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active, created_at, updated_at)
SELECT $id$q_tec101_20$id$, m.id, $p$It is acceptable to share your portal login with a colleague when they need quick access.$p$, $t$TRUE_FALSE$t$,
       $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Never share credentials; each person uses their own login, which protects data and preserves an accurate audit trail.$e$, 20, true,
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM learning_modules m WHERE m.code='TEC-101'
ON CONFLICT (id) DO UPDATE SET
  prompt=EXCLUDED.prompt, type=EXCLUDED.type, options=EXCLUDED.options,
  correct=EXCLUDED.correct, explanation=EXCLUDED.explanation,
  sort_order=EXCLUDED.sort_order, active=EXCLUDED.active, updated_at=CURRENT_TIMESTAMP;

COMMIT;
