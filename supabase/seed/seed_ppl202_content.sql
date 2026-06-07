-- =============================================================================
-- seed_ppl202_content.sql  (v0.61.0)
-- PPL-202: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches the calendar-year cycle and the canonical pay/compa model (floor 0.80).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl2xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A hire is the most expensive decision the firm makes without a board paper. Get it right and you have added capability for years; get it wrong and you carry the cost — and the risk — until you can unwind it. At a SEC-regulated dealing member, hiring is not only a quality question, it is a regulatory one: some of the people you bring in must be fit and proper before they ever touch a client or a trade. Your defense against a bad hire is not instinct. It is a workflow that no one is allowed to skip, run the same way every time, with a document filed at every step. This module is that workflow.

## What you will be able to do

1. Run the ten-stage hiring workflow in order, with the right artifact filed at each stage.
2. Build and chair a structured interview that produces comparable, defensible scores.
3. Complete verification and the fit-and-proper checks that the regulator expects.
4. Issue offers and contracts from the approved templates, signed by the right authority.
5. Keep recruitment internal-first and free of language that excludes protected groups.

## The principles before the process

Two ideas govern everything below. The first is **internal-first**: before the firm looks outside, it considers whether someone already here can grow into the role. This is not a formality — it is how you build careers and retain people, and it is the reason the development plans you maintain feed directly into who gets considered when a vacancy opens. The second is the **regulatory frame**: Transworld is a capital market operator, so certain roles are "sponsored individuals" or otherwise regulated, and the people in them must satisfy fit-and-proper requirements. A fit-and-proper test applies to any role involving client-facing activity, order execution, or compliance oversight. That obligation does not begin on the first day of work; it shapes who you may offer the role to in the first place, which is why verification sits inside the hiring workflow rather than after it. Both principles point the same way: hiring is a controlled process, and your discipline at each step is what makes the firm's decisions defensible to a regulator months or years later.

## The ten-stage hiring workflow

Every hire at Transworld follows this ten-stage workflow. **No stage may be skipped.** Each stage generates documentation that is filed in the recruitment record for the role and, for the successful candidate, ultimately in their staff file. Run it in order, every time.

1. **Headcount Approval.** You receive a signed Headcount Request from the requesting manager, and the COO confirms approval in writing. *Filed: the approved Headcount Request form.* Without this, nothing else starts.
2. **Position Description.** You draft or update the Position Description with the hiring manager. It must carry the role title, grade, job family, key responsibilities, required competencies, essential and desirable qualifications, reporting line, and salary range. The COO reviews and approves. *Filed: the approved PD.*
3. **Advertising.** You place the role on approved channels — the company website, LinkedIn, professional boards, and the referral network as appropriate. Every advertisement uses the approved template language: clear, inclusive, and free of anything that could discourage applications from a protected group. *Filed: a copy of every ad, with dates.*
4. **Application Screening.** You receive and screen all applications against the PD criteria and prepare a shortlist of three to five for the hiring manager. Every screening decision is recorded. *Filed: the Candidate Screening Log and all applications received.*
5. **Structured Interview.** A panel of at least two people — typically the hiring manager plus you or a senior peer — interviews using the Structured Interview Guide. Each interviewer scores each candidate independently. *Filed: completed scoresheets for every candidate interviewed.*
6. **Skills / Practical Assessment.** For technical roles (Investment Analyst, Operations, Compliance, Finance), a practical assessment is run against a task and rubric the hiring manager approved in advance. *Filed: the task, the completed assessments, and the scores.*
7. **Reference Checks.** You contact a minimum of two professional references for the preferred candidate, taken verbally against the standard reference-check script. *Filed: completed reference-check forms.*
8. **Verification Checks.** You complete every item on the Candidate Verification Checklist — the fit-and-proper and credential work covered below. *Filed: the completed checklist with evidence attached.*
9. **Offer.** You prepare the offer letter from the portal template, confirm the salary with the COO, and issue it. The offer is made verbatim from the approved template — no verbal variations. *Filed: the issued offer letter, date-stamped.*
10. **Contract Signing & Start Confirmation.** On acceptance you issue the full employment contract, signed by the candidate and, on behalf of Transworld, by the **COO for G0–G3** or the **MD for G4 and above**. *Filed: the signed contract, confirmed start date, and updated portal record.*

The discipline is the order and the filing. A regulator or auditor reviewing a hire is reading the recruitment record, and a missing scoresheet or an undated advert is a control that, to them, did not happen.

## Structured interviewing: why and how

The reason interviews are structured is simple and unglamorous: unstructured interviews mostly measure how much the panel likes the candidate, which is not the job. A structured interview asks every candidate the same core questions, in the same shape, and scores each answer against a defined standard, so that you are comparing candidates rather than impressions. The panel is at least two people — typically the hiring manager plus you or a senior peer — and, this is the part people quietly erode, **each interviewer scores independently before the panel confers**. If the panel debates first and scores second, you have lost the independence that makes the scores worth anything.

The question set has a fixed three-part shape. First, **role and technical** questions drawn from the role-specific bank. Second, **behaviors** — one question per behavior, adapted to the role, mapping to the firm's six (Mastery & Growth, Integrity Above All, Compliance by Default, Ownership Mentality, Trust Through Documentation, Lifting Others). Third, **Regulatory & Compliance**, which is **mandatory for every role**, because at a dealing member even a non-front-office hire must understand the firm's obligations. The core question bank gives you tested prompts for each dimension — for Integrity, "tell me about a time you were asked to do something that felt ethically uncomfortable"; for Compliance by Default, "how do you keep up to date with regulatory changes, and give an example of a compliance improvement you initiated"; for the Regulatory dimension, "what do you understand about Transworld's obligations as an NGX dealing member?" The scoring rubric is agreed before the interviews begin, not reverse-engineered to fit the candidate you liked, and the decision is made from the independent scores, not the room's mood.

## Verification and fit-and-proper

Verification is where hiring meets compliance. The Candidate Verification Checklist runs before an offer is firm, and it covers identity, the right to work, claimed qualifications and professional memberships, and the regulatory status of the individual. Each item is evidenced, not asserted: you confirm identity against a verified ID document (passport or NIN), you confirm the right to work, you check claimed academic and professional certifications against the issuing bodies for G2-and-above and all regulated roles, you obtain a criminal-record-check result, and for regulated roles you confirm SEC / NGX registration. For regulated roles, the **fit-and-proper** assessment is the heart of it: the firm must satisfy itself that the person is honest, competent, and financially sound enough to hold the role, and that they are not disqualified by a regulator. This connects directly to the firm's sponsored-individual obligations — the detail of which lives in REG-204 — and it is the reason you never let a regulated role start before verification is complete. Reference checks (Stage 7) and verification (Stage 8) are not the same thing: references test reputation and performance; verification tests facts and regulatory status. You owe both. And every cleared item is exactly what later populates the new hire's staff file, so doing verification thoroughly at Stage 8 is also how you start that file complete.

## Offers, contracts, and the clauses that bite later

The offer is issued **verbatim from the approved template**, with the salary confirmed by the COO. Improvised verbal promises — an extra week of leave, a faster review, a guaranteed bonus — are exactly how disputes are born, so you make the offer in writing and on template, and you route any request for a variation back through the proper approval rather than agreeing it on a call. The contract then carries the clauses the firm relies on: notice, probation, confidentiality, the regulatory obligations of the role, intellectual-property and personal-account-dealing undertakings, and — for the grades where it applies — the bonus and deferral terms, including any bad-leaver forfeiture. A clause the firm intends to enforce later, such as forfeiture of a deferred bonus by a bad leaver, only bites if it is written into the signed contract; a policy that lives only in a manual will not hold. So your filing discipline at Stage 10 is not bureaucracy — it is the firm's enforceability. The contract is signed by the candidate and, on Transworld's behalf, by the COO for G0–G3 or the MD for G4 and above, and only once it is signed and the start date confirmed do you update the portal record and hand the joiner over to onboarding. A handshake or an email is not a contract; the signed document, filed, is what protects both sides.

## A worked example

**Illustration — the Operations hire who interviewed best (entirely hypothetical).** A hiring manager runs an Operations search, and after the structured interviews the panel's independent scores put Candidate B narrowly ahead of Candidate A, even though the manager "clicked" with A. You hold the line on the scores rather than the chemistry, and B proceeds to the practical assessment (Stage 6), which B passes cleanly. At reference checks (Stage 7), one referee is lukewarm but specific, and at verification (Stage 8) you discover a claimed certification that the issuing body cannot confirm. You do not wave it through because B interviewed well — you pause the offer, put the discrepancy to the candidate in writing, and only proceed if it is satisfactorily resolved. The offer, when it goes, is issued verbatim from the template with the COO-confirmed salary, and the contract is signed by the COO because the role is G2. Every step left an artifact; if anyone ever asks why B was hired, the record answers.

## Common traps

- **Skipping a stage to move fast.** No stage may be skipped. Speed comes from running the workflow well, not from cutting it.
- **Letting the panel confer before scoring.** Independent scores first, discussion second — otherwise the structure is decorative.
- **Treating references as verification.** References test reputation; verification tests facts and regulatory status. You owe both, separately.
- **Starting a regulated role before fit-and-proper is complete.** Verification sits inside the workflow precisely so this never happens.
- **Making a verbal variation to the offer.** Offers are verbatim from template; route variations through approval, never agree them on a call.

## Key takeaways

- Hiring is a ten-stage workflow, run in order, with a filed artifact at every stage; no stage may be skipped.
- Recruitment is internal-first, and every advert uses inclusive, approved template language.
- Structured interviews use a fixed question structure with at least two interviewers scoring independently before conferring.
- Verification and fit-and-proper are completed before an offer is firm — regulated roles never start uncleared (see REG-204).
- Offers and contracts are issued from approved templates; the contract carries the clauses (including bad-leaver forfeiture) the firm will rely on later. Contracts are signed by the COO (G0–G3) or MD (G4+).

*Reference: HR Operations Manual v1.1, Part C (Chapters C1–C5) and the WS3 Recruitment & Hiring Toolkit (Transworld); fit-and-proper and sponsored-individual detail in REG-204 and the Compliance source suite. This module is a navigation aid; the manual and the toolkit are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-202';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_01$id$, m.id, $p$How many stages are in the Transworld hiring workflow, and may any be skipped?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Five stages; the last two may be skipped for internal hires"}, {"key": "b", "text": "Ten stages; no stage may be skipped"}, {"key": "c", "text": "Ten stages; advertising may be skipped for referrals"}, {"key": "d", "text": "Seven stages; the practical assessment is optional for all roles"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every hire follows the ten-stage workflow in order, and no stage may be skipped — each generates a filed artifact.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_02$id$, m.id, $p$Which is the FIRST stage of the hiring workflow?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Advertising the role"}, {"key": "b", "text": "Headcount Approval \u2014 signed request plus written COO approval"}, {"key": "c", "text": "Drafting the Position Description"}, {"key": "d", "text": "Structured interview"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Stage 1 is Headcount Approval: a signed Headcount Request and written COO approval, filed as the first artifact. Nothing starts without it.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_03$id$, m.id, $p$During structured interviews, when should interviewers record their scores?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "After the panel discusses and agrees a consensus view"}, {"key": "b", "text": "Independently, each interviewer scoring before the panel confers"}, {"key": "c", "text": "Only the hiring manager scores; others observe"}, {"key": "d", "text": "Scores are optional if the choice is obvious"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each interviewer scores independently before the panel confers. Conferring first destroys the independence that makes the scores meaningful.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_04$id$, m.id, $p$Reference checks and verification checks are the same thing.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$References test reputation and performance; verification tests facts and regulatory status (identity, right to work, qualifications, fit-and-proper). You owe both, separately.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_05$id$, m.id, $p$A contract for a G2 hire is signed on behalf of Transworld by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the Chairman"}, {"key": "b", "text": "the COO"}, {"key": "c", "text": "the MD"}, {"key": "d", "text": "the hiring manager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The COO signs for grades G0–G3; the MD signs for G4 and above.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_06$id$, m.id, $p$The minimum number of professional references taken for the preferred candidate is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "none"}, {"key": "b", "text": "one"}, {"key": "c", "text": "two"}, {"key": "d", "text": "five"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$At Stage 7 you contact a minimum of two professional references, taken against the standard reference-check script.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_07$id$, m.id, $p$A candidate interviews brilliantly, but verification cannot confirm a certification they claimed. You should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "proceed with the offer \u2014 the interview is what matters"}, {"key": "b", "text": "pause the offer, put the discrepancy to the candidate in writing, and only proceed if resolved"}, {"key": "c", "text": "drop the candidate immediately with no further contact"}, {"key": "d", "text": "ask the hiring manager to vouch for the certificate"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Verification tests facts. A discrepancy pauses the offer; you raise it in writing and proceed only if satisfactorily resolved — a strong interview does not override it.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_08$id$, m.id, $p$Why must job adverts use the approved template language?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "To make them cheaper to place"}, {"key": "b", "text": "To keep them clear, inclusive, and free of language that could discourage protected groups"}, {"key": "c", "text": "Because LinkedIn requires it"}, {"key": "d", "text": "To hide the salary range"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Approved template language keeps adverts clear and inclusive, with nothing that could discourage applications from any protected group. A copy of every ad is filed with dates.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_09$id$, m.id, $p$Recruitment at Transworld is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "external-only, to bring in fresh perspectives"}, {"key": "b", "text": "internal-first \u2014 considering existing staff before looking outside"}, {"key": "c", "text": "decided entirely by the hiring manager's preference"}, {"key": "d", "text": "based on whoever applies first"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The internal-first principle means the firm considers whether someone already here can grow into the role before searching externally.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_10$id$, m.id, $p$For a regulated role, when must the fit-and-proper assessment be complete?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Within the first 90 days of employment"}, {"key": "b", "text": "Before the offer is firm \u2014 verification sits inside the workflow"}, {"key": "c", "text": "Only if a regulator requests it"}, {"key": "d", "text": "At the first annual appraisal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Verification (Stage 8), including fit-and-proper for regulated roles, is completed before an offer is firm; a regulated role never starts uncleared.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_11$id$, m.id, $p$A candidate asks for an extra week of annual leave during a phone call. What do you do?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Agree it verbally to close the hire quickly"}, {"key": "b", "text": "Route the request through proper approval; the offer itself is issued verbatim from the template"}, {"key": "c", "text": "Add it informally and note it later"}, {"key": "d", "text": "Refuse to discuss anything until the contract is signed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Offers are made verbatim from the approved template with COO-confirmed salary. Variations go through approval, never agreed on a call — verbal promises breed disputes.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_12$id$, m.id, $p$Which document must be filed at the Advertising stage?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The signed contract"}, {"key": "b", "text": "A copy of every advertisement placed, with dates"}, {"key": "c", "text": "The candidate's references"}, {"key": "d", "text": "The practical assessment rubric"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Stage 3 files a copy of all ads placed, with dates — part of the recruitment record an auditor reads.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_13$id$, m.id, $p$The shortlist prepared for the hiring manager at the screening stage should contain roughly...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "every applicant"}, {"key": "b", "text": "one candidate"}, {"key": "c", "text": "three to five candidates"}, {"key": "d", "text": "at least fifteen candidates"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Stage 4 screens all applications against the PD and prepares a shortlist of three to five for the hiring manager, with decisions recorded on the Screening Log.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_14$id$, m.id, $p$A bad-leaver bonus-forfeiture term will only be enforceable if it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "mentioned in the staff handbook"}, {"key": "b", "text": "written into the signed employment contract"}, {"key": "c", "text": "agreed verbally at the interview"}, {"key": "d", "text": "posted on the firm intranet"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A clause the firm intends to enforce — like deferred-bonus forfeiture by a bad leaver — must be in the signed contract; a manual-only policy will not hold.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_15$id$, m.id, $p$Who reviews and approves the Position Description before advertising?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The candidate"}, {"key": "b", "text": "The COO"}, {"key": "c", "text": "The board"}, {"key": "d", "text": "No one \u2014 People Ops finalizes it alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$At Stage 2, People Ops drafts the PD with the hiring manager and the COO reviews and approves it before the role is advertised.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_16$id$, m.id, $p$The practical / skills assessment (Stage 6) is run for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no roles \u2014 it has been retired"}, {"key": "b", "text": "technical roles such as Investment Analyst, Operations, Compliance, and Finance"}, {"key": "c", "text": "only Leadership roles"}, {"key": "d", "text": "every candidate who applies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A practical assessment, against a manager-approved task and rubric, is run for technical roles — Investment Analyst, Operations, Compliance, Finance.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_17$id$, m.id, $p$Verification of a regulated individual connects most directly to which area?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The firm's marketing strategy"}, {"key": "b", "text": "The firm's sponsored-individual / fit-and-proper obligations (REG-204)"}, {"key": "c", "text": "The payroll calendar"}, {"key": "d", "text": "The leave policy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Fit-and-proper verification connects to the firm's sponsored-individual obligations, the detail of which is covered in REG-204 and the Compliance suite.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_18$id$, m.id, $p$The scoring rubric for a structured interview should be agreed...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "after the interviews, to fit the strongest candidate"}, {"key": "b", "text": "before the interviews begin"}, {"key": "c", "text": "only if candidates dispute the result"}, {"key": "d", "text": "by the candidate and the panel together"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The rubric is agreed before interviews begin, not reverse-engineered afterward to fit a preferred candidate.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_19$id$, m.id, $p$A regulator reviewing a past hire is essentially reading...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the hiring manager's memory of the process"}, {"key": "b", "text": "the recruitment record \u2014 the filed artifacts from each stage"}, {"key": "c", "text": "the candidate's social media"}, {"key": "d", "text": "the payroll schedule"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The recruitment record is the evidence. A missing scoresheet or undated advert reads, to a regulator, as a control that did not happen.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl202_20$id$, m.id, $p$The salary in an offer letter is confirmed by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the hiring manager alone"}, {"key": "b", "text": "the COO"}, {"key": "c", "text": "the candidate's expectation"}, {"key": "d", "text": "the previous post-holder's pay automatically"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$At Stage 9 you prepare the offer from the portal template and confirm the salary with the COO before issuing it.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
