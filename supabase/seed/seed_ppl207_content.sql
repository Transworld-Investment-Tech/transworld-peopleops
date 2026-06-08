-- =============================================================================
-- seed_ppl207_content.sql  (v0.62.0)
-- PPL-207: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches the capability/conduct split, discipline, grievance, whistleblower, and anti-harassment.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl3xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Employee relations is where the firm's fairness is tested one case at a time. Get the process right and a difficult situation ends cleanly, with the firm protected and the person treated with dignity; get it wrong and the same facts become an unfair-dismissal claim, a retaliation finding, or a regulator's question. The work is not about being tough or being soft — it is about routing each matter to the correct process and running that process to the letter. This module covers the whole employee-relations toolkit: capability versus conduct, the disciplinary procedure, grievances, the whistleblower channel, and the anti-harassment policy.

## What you will be able to do

1. Route a concern correctly between capability (a PIP) and conduct (the disciplinary procedure).
2. Run a fair PIP and a defensible progressive-disciplinary process built on a documented investigation.
3. Handle suspected gross misconduct and the grievance procedure with independence and confidentiality.
4. Operate the whistleblower channel, protect reporters, and route regulatory matters to Compliance.
5. Apply the anti-harassment, bullying, and equal-opportunity policy.

## The first decision: capability or conduct

Almost everything starts with one question — is this a capability matter or a conduct matter? Capability is when an employee is genuinely trying but not meeting the standard; the cause is skill or ability, not willingness. That goes to a Performance Improvement Plan. Conduct is a breach of policy, professional standards, regulatory obligation, or the Code of Conduct; that goes to the disciplinary procedure. The distinction is not a formality — the processes, the remedies, and the employee's rights all differ — so make the call deliberately and route accordingly. Mixing them, running a disciplinary process for what is really a skills gap or putting a misconduct case through a PIP, is itself a process failure.

## The PIP: structured support, not punishment

A PIP is appropriate when the shortfall is capability, informal coaching has already been tried, and the employee is trying. It is not disciplinary action — it is structured support, and it must be documented, fair, and genuinely achievable. The process runs in stages. First, an informal coaching phase of at least two to four weeks: the line manager gives specific written feedback and holds at least one documented coaching session. If that resolves things, the matter closes with a brief note. If not, the manager notifies you and you prepare the PIP document from the portal template, specifying the standard not being met, specific measurable targets, a timeline of thirty to ninety days, the support provided, and review dates. At the PIP meeting the manager presents it, you attend, the employee responds and the response is recorded, and both parties sign to acknowledge receipt — not necessarily agreement, but that they have received and understood it. At least one formal review meeting is held during the period. At the end, the manager and you jointly assess: targets fully met closes the PIP with written confirmation; partially met may extend with revised targets or move to discipline if the shortfall is material, with the COO deciding; not met progresses to a formal capability dismissal, which the COO and you prepare, the MD approves, and external counsel confirms before issuing. One rule governs the whole tool: a PIP must never be a pretext for dismissal. If a manager begins a PIP intending to dismiss regardless of outcome, that is unfair process and legal risk — escalate it to the COO immediately.

## Progressive discipline: investigate first, then escalate

The disciplinary procedure addresses conduct, and it escalates in stages. An informal discussion handles a minor first concern: the manager raises it privately within two working days, documents a brief dated file note, and copies it to the staff file through you, with no formal warning. A verbal warning is the first formal step where an informal discussion did not resolve matters or the first instance is serious: the manager meets the employee with you present, a Verbal Warning letter issues through the portal template countersigned by the COO, and it is retained for twelve months. A written warning is jointly prepared by the manager and you for COO approval; it states the concern, the required standard, the improvement period of typically three to six months, and the consequence of further breach, the employee may respond in writing within five working days, and it is filed for eighteen months. A final written warning follows where a written warning has not produced change or a single incident is serious enough, with escalated language that further breach may result in dismissal, MD sign-off, and filing for twenty-four months — or permanently for conduct involving regulatory obligations. Dismissal is prepared by the MD and you, with Compliance involved where regulatory conduct is implicated, external counsel confirming before issue, and the employee's right to appeal preserved.

The non-negotiable foundation is the investigation. For anything beyond a straightforward informal discussion, a brief investigation precedes any formal warning or dismissal: it establishes the facts, is conducted by someone not involved in the incident, gives the employee a chance to provide their account before any decision, and produces a written investigation summary. Do not issue a written warning or anything above it without a documented investigation summary that you have reviewed. The summary is the foundation of any formal decision; without it the decision is exposed.

## Gross misconduct

Some conduct is serious enough to break the progression. Suspected gross misconduct — theft, fraud, violence, a deliberate regulatory breach, insider trading, gross insubordination — may justify suspending the employee on full pay while an investigation runs. Suspension is a protective measure, not a punishment, and it should last no longer than the investigation needs. If the investigation confirms gross misconduct the employee is invited to a disciplinary hearing before any dismissal decision, the decision rests with the MD, and Compliance must be notified of any case involving a potential regulatory conduct breach. The full-pay element matters: it keeps the suspension protective rather than punitive and avoids prejudging the outcome.

## Grievances: independence and confidentiality

A grievance is a complaint an employee raises, and your role is to coordinate while guaranteeing independence — the investigator must not be involved in the subject matter, and where the grievance involves People Ops itself or its conduct, the COO or an external investigator takes it. The process is timed: you acknowledge receipt in writing within two working days and confirm a timeline of fifteen working days to complete the investigation and communicate findings, extendable by agreement where the matter is complex. You appoint an appropriate investigator, who speaks to the employee, the person named, and any witnesses, documenting each interview with a summary shared for accuracy. The investigator produces a written Finding — substantiated, not substantiated, or partially substantiated — with a recommended action, which you review before it is communicated. The employee may appeal within five working days, heard by the COO if uninvolved or the MD. Strict confidentiality runs throughout: the person named is told a grievance has been raised and given the chance to respond, but is not given the grievance letter or the identities of witnesses.

## The whistleblower channel

The whistleblower channel is separate from the grievance procedure and exists for reports of suspected illegal activity — fraud, theft, market manipulation, insider trading — regulatory breaches, deliberate falsification of records, serious ethical violations, or any conduct that would be a criminal offence. It offers anonymous reporting and escalates to the Board where appropriate, bypassing line management entirely if needed. Reports route to People Ops for non-anonymous matters, to the Compliance Officer for regulatory matters, to the COO or MD for matters involving People Ops or Compliance, and directly to the Chairman through the anonymous channel for matters involving the MD or COO. Anonymous reports are accepted in writing only, so a proper record exists without identifying the reporter, who receives a reference number. After a report you acknowledge within two working days, the appropriate authority assesses where it belongs, and investigation is proportionate to the seriousness — serious allegations go to Compliance and, where needed, an external investigator. You are not the investigator for whistleblower matters with regulatory implications; Compliance leads those. The reporter's identity is protected to the maximum extent possible, no adverse employment action may be taken against a good-faith reporter, and any suspected retaliation is itself treated as gross misconduct. You maintain a confidential Whistleblower Register, which is a Board-level document — it goes to the Board Audit, Risk and Compliance Committee annually, not to management.

## Anti-harassment, bullying, and equal opportunity

The firm is committed to a workplace free from harassment, bullying, and unlawful discrimination, and the policy applies in every context — the office, client sites, company events, travel, and digital communications including messaging and social media. Harassment is unwelcome conduct related to a personal characteristic that creates an intimidating, hostile, degrading, humiliating, or offensive environment; sexual harassment is unwelcome conduct of a sexual nature, including any link between professional benefit and sexual compliance; bullying is persistent or serious behavior that undermines dignity; and discrimination includes treating someone less favorably on a protected characteristic, applying a facially neutral policy with a disproportionate adverse effect, or failing to make reasonable adjustments for a disability. You manage the formal complaint process, ensure investigations are fair and confidential, maintain records, and report trends to the COO; managers model respectful behavior and escalate; the COO and MD set the tone and approve outcomes at the written-warning level and above. One nuance protects fairness both ways: a false or malicious complaint made in bad faith is itself a breach, but the threshold for bad faith is high — an unsuccessful complaint is not automatically a bad-faith one.

## A worked example

**Illustration — one report, three possible doors (entirely hypothetical).** A fictional employee sends you a written report alleging that their line manager has been making demeaning comments and has steered a transaction in a way that looks like a regulatory breach. Your first job is routing. The demeaning-comments element is a potential harassment or grievance matter; the regulatory-breach element belongs in the whistleblower channel. Because the manager is the subject, you cannot let that manager — or yourself, if you are too close — investigate; you ensure independence, with the COO taking the people element and Compliance leading the regulatory element, because a whistleblower matter with regulatory implications is Compliance's to investigate, not yours. You acknowledge receipt within two working days, give the reporter a reference and protect their identity, and open the Whistleblower Register entry for the regulatory strand. The named manager is told a concern has been raised and given a chance to respond, but is not shown the report or told who the witnesses are. No adverse action touches the reporter; if it did, that retaliation would itself be gross misconduct. Each strand runs its own correct process to its own finding.

## Common traps

- **Running a PIP to engineer a dismissal.** A PIP must be genuine support; a PIP begun intending to dismiss is unfair process — escalate to the COO.
- **Issuing a written warning with no investigation.** No written warning or above issues without a documented, reviewed investigation summary.
- **People Ops investigating a regulatory whistleblower matter.** Compliance leads whistleblower matters with regulatory implications; you do not.
- **Breaching reporter or grievance confidentiality.** Protect reporter identity and witness identities; the named person responds but does not see the letter or witnesses.
- **Treating an unsuccessful complaint as bad faith.** The bad-faith threshold is high; an unsuccessful complaint is not automatically malicious.

## Key takeaways

- Route first: capability goes to a PIP (structured support), conduct goes to the disciplinary procedure; the processes and rights differ.
- A PIP is documented, fair, and achievable, with the employee signing for receipt; it must never be a pretext for dismissal.
- Discipline escalates informal discussion, verbal, written, final written, dismissal — each built on a documented investigation; warnings have set retention periods and approval levels.
- Gross misconduct allows suspension on full pay as a protective measure; the MD decides, and Compliance is notified for regulatory conduct.
- Grievances run with independence and confidentiality on a fifteen-working-day timeline; the whistleblower channel is separate, Compliance leads regulatory matters, the register is a Board document, and reporters are protected.

*Reference: HR Operations Manual v1.1, Chapters E7 (PIP), E8 (disciplinary), E9 (grievance), E10 (whistleblower), and H5 (anti-harassment, bullying & equal opportunity); WS5 Performance & Discipline; the Whistleblower Policy and the Code of Ethics. This module is a navigation aid; the manual, the Whistleblower Policy, and Compliance are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-207';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_01$id$, m.id, $p$An employee is genuinely trying but not meeting the standard; the cause is a skills gap. This is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a conduct matter for the disciplinary procedure"}, {"key": "b", "text": "a capability matter for a PIP"}, {"key": "c", "text": "a grievance"}, {"key": "d", "text": "a whistleblower matter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Capability — trying but falling short on skill or ability — goes to a Performance Improvement Plan, not the disciplinary procedure.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_02$id$, m.id, $p$A PIP is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the first stage of disciplinary action"}, {"key": "b", "text": "structured support; documented, fair, and genuinely achievable, and never a pretext for dismissal"}, {"key": "c", "text": "an automatic route to dismissal"}, {"key": "d", "text": "a confidential governance record"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A PIP is structured support, not disciplinary action. It must be documented, fair, and achievable, and must never be used as a pretext for dismissal.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_03$id$, m.id, $p$At the PIP meeting, the employee signs the document to indicate...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "agreement with every element"}, {"key": "b", "text": "receipt and understanding, not necessarily agreement"}, {"key": "c", "text": "a waiver of any appeal"}, {"key": "d", "text": "acceptance of dismissal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Both parties sign to acknowledge receipt and understanding — not necessarily agreement with every element. The employee's response is recorded.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_04$id$, m.id, $p$A manager begins a PIP intending to dismiss regardless of outcome. You should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "support it to speed up the exit"}, {"key": "b", "text": "escalate to the COO immediately \u2014 this is unfair process and legal risk"}, {"key": "c", "text": "shorten the PIP timeline"}, {"key": "d", "text": "convert it to a disciplinary process quietly"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A PIP begun as a pretext for dismissal is unfair process and exposes the firm to legal risk. If you suspect this, escalate to the COO immediately.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_05$id$, m.id, $p$The disciplinary procedure addresses...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "capability shortfalls"}, {"key": "b", "text": "conduct \u2014 breaches of policy, professional standards, regulatory obligations, or the Code of Conduct"}, {"key": "c", "text": "development planning"}, {"key": "d", "text": "pay disputes only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Discipline addresses conduct; capability shortfalls use the PIP process. The distinction matters because processes, remedies, and rights differ.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_06$id$, m.id, $p$Before issuing a written warning or anything above it, you must have...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the employee's written consent"}, {"key": "b", "text": "a documented investigation summary, conducted by someone uninvolved and reviewed by People Ops"}, {"key": "c", "text": "approval from the Chairman"}, {"key": "d", "text": "three prior verbal warnings"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$No written warning or above issues without a documented investigation summary — the foundation of any formal disciplinary decision.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_07$id$, m.id, $p$A Final Written Warning requires sign-off from...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the line manager alone"}, {"key": "b", "text": "the MD"}, {"key": "c", "text": "People Ops alone"}, {"key": "d", "text": "the employee"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A Final Written Warning carries escalated consequence language and requires MD sign-off; it is filed for 24 months, or permanently for regulatory conduct.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_08$id$, m.id, $p$A Written Warning is filed on the staff file for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "12 months"}, {"key": "b", "text": "18 months"}, {"key": "c", "text": "24 months"}, {"key": "d", "text": "permanently in all cases"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A Written Warning is filed for 18 months; a Verbal Warning for 12 months; a Final Written Warning for 24 months (or permanently for regulatory conduct).$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_09$id$, m.id, $p$In suspected gross misconduct, the employee may be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "dismissed immediately without investigation"}, {"key": "b", "text": "suspended on full pay as a protective measure while an investigation runs"}, {"key": "c", "text": "suspended without pay"}, {"key": "d", "text": "demoted on the spot"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suspension on full pay is a protective measure, not a punishment. It lasts no longer than the investigation needs; the MD makes the dismissal decision after a hearing.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_10$id$, m.id, $p$Who decides a dismissal for gross misconduct, and who must be notified for regulatory conduct?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops decides; no one need be notified"}, {"key": "b", "text": "the MD decides; Compliance must be notified of any potential regulatory conduct breach"}, {"key": "c", "text": "the line manager decides; the Chairman is notified"}, {"key": "d", "text": "the COO decides alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The MD makes the gross-misconduct dismissal decision, and Compliance must be notified of any case involving a potential regulatory conduct breach.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_11$id$, m.id, $p$A grievance is received. You must acknowledge it within...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "two working days, with findings communicated within 15 working days"}, {"key": "b", "text": "ten working days"}, {"key": "c", "text": "one month"}, {"key": "d", "text": "the next quarter"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$You acknowledge receipt within two working days and confirm a 15-working-day timeline to investigate and communicate findings, extendable by agreement for complex matters.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_12$id$, m.id, $p$Where a grievance involves People Ops or its own conduct, the investigation is led by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops, as normal"}, {"key": "b", "text": "the COO or an external investigator"}, {"key": "c", "text": "the named person"}, {"key": "d", "text": "the employee who complained"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$People Ops does not investigate grievances involving itself; the COO or an external investigator takes those, preserving independence.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_13$id$, m.id, $p$During a grievance, the person named in it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "receives a copy of the grievance letter and the witness names"}, {"key": "b", "text": "is told a grievance was raised and may respond, but is not given the letter or witness identities"}, {"key": "c", "text": "is excluded from the process entirely"}, {"key": "d", "text": "chooses the investigator"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Strict confidentiality applies: the named person is told a grievance has been raised and may respond, but does not receive the letter or the identities of witnesses.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_14$id$, m.id, $p$The whistleblower channel is for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "routine pay and leave disputes"}, {"key": "b", "text": "suspected illegal activity, regulatory breaches, falsification, serious ethics violations, or criminal conduct"}, {"key": "c", "text": "performance disagreements"}, {"key": "d", "text": "requests for development support"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The whistleblower channel is separate from grievances and exists for serious matters — illegal activity, regulatory breach, falsification, serious ethics, or criminal conduct.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_15$id$, m.id, $p$For a whistleblower matter with regulatory implications, the investigation is led by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops"}, {"key": "b", "text": "Compliance, and where necessary an external investigator"}, {"key": "c", "text": "the line manager"}, {"key": "d", "text": "the reporter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$People Ops is not the investigator for whistleblower matters with regulatory implications; Compliance leads, with an external investigator where necessary.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_16$id$, m.id, $p$A matter involving the MD or COO is reported via the anonymous channel to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the COO"}, {"key": "b", "text": "the Chairman"}, {"key": "c", "text": "People Ops"}, {"key": "d", "text": "the line manager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Matters involving the MD or COO route directly to the Chairman via the anonymous channel, bypassing the people they concern.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_17$id$, m.id, $p$The Whistleblower Register is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a management report shared monthly with the COO"}, {"key": "b", "text": "a confidential Board-level document, sent to the Board Audit, Risk and Compliance Committee annually"}, {"key": "c", "text": "published to all staff"}, {"key": "d", "text": "discarded after each report closes"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The register is a confidential Board-level document; it goes to the Board Audit, Risk and Compliance Committee annually, not to management.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_18$id$, m.id, $p$The anti-harassment policy applies...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only in the physical office during working hours"}, {"key": "b", "text": "in all work contexts, including client sites, events, travel, and digital communications and social media"}, {"key": "c", "text": "only to managers"}, {"key": "d", "text": "only to permanent staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The policy applies to all employees at all grades in all contexts, including the office, client sites, events, travel, and digital communications including messaging and social media.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_19$id$, m.id, $p$Failing to make reasonable adjustments for an employee with a disability is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "permitted if it is inconvenient"}, {"key": "b", "text": "a form of discrimination under the policy"}, {"key": "c", "text": "a capability matter"}, {"key": "d", "text": "only an issue if raised formally"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Discrimination includes failing to make reasonable adjustments for a disability, alongside less-favorable treatment and indirect discrimination.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl207_20$id$, m.id, $p$An unsuccessful harassment complaint is automatically a bad-faith complaint.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. A false or malicious bad-faith complaint is itself a breach, but the threshold for bad faith is high — an unsuccessful complaint is not automatically a bad-faith one.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-207'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;


-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-207';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-207 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-207' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-207 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-207 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
