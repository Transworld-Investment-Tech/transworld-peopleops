-- =============================================================================
-- seed_fnd108_content.sql -- FND-108 Whistleblowing & Speaking Up: lesson + 20-question check (v0.45.1 content)
-- Authored FROM POLICY off Whistleblower Policy v1.0 (First Board Adoption, March 2026).
--   Supporting: Compliance Manual v3.0.
-- Tier A (CCO-owned). Running this seed PUBLISHES the module -- it is the CCO publish gate.
--   DO NOT RUN until the CCO has reviewed and approved the content.
-- DATA, not schema. Run AFTER 0031/0032 + seed_lms_curriculum.sql (which creates the FND-108 shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- Pass mark 80% reaffirmed here; estimated_minutes set to 30.
-- NOTE (doc-sync, for the CCO): this lesson reflects current operational reality on two points the
--   v1.0 policy text predates -- (a) the corrected reporting email whistleblower@transworldltd.com.ng,
--   and (b) the portal "Report a Concern" page (with the senior-management and anonymity toggles).
--   Both are logged as open doc-fixes against the Whistleblower Policy for its next review.
-- =============================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Every firm has two possible futures. In one, problems surface early — someone sees something wrong and says so, it is looked into, and it is put right before it can grow. In the other, problems stay buried, because the people who see them are afraid to speak, and they surface only once they have become a crisis that harms clients, the firm, and the very people who stayed silent. The difference between those two futures is not luck. It is whether the people inside the firm feel safe enough to speak up — and whether there is a system that takes them seriously and protects them when they do.

The **Whistleblower Policy** is that system. It was born at the Transworld Executive Retreat, from the Board's recognition that an institution's true character is revealed not in good times but in its hardest moments. It answers two questions plainly. *Are you safe to speak up?* Yes. *Will you be taken seriously?* Yes. This module walks you through what the Policy gives you and what it asks of you: what you can report, how to report it, the protection you carry when you do, and what happens next.

>! **The Board's pledge.** "If you see something wrong, say something. Silence protects problems. Speaking up protects the institution. And at Transworld, speaking up protects you." — The Board of Directors.

## What you'll be able to do

1. Recognize the full range of concerns you can — and should — report.
2. Use the portal's **Report a Concern** page and choose the right channel for any situation.
3. Send a concern about senior management to an independent authority, and report anonymously, when you need to.
4. Explain the absolute protection against retaliation, what counts as retaliation, and what happens to anyone who retaliates.
5. Describe what happens after a report — the investigation process, the timelines, and the fairness owed to everyone involved.

## Who is protected — everyone

This Policy protects everyone, without distinction: every Board member, executive, permanent employee, contract staff member, intern, and consultant, plus the vendors, clients, and third parties who have a concern about the firm's conduct. Misconduct does not respect hierarchy, and neither does this Policy. A concern raised by the most junior member of staff about the most senior member of management is treated with the same seriousness and given the same protection as any other concern. No one at Transworld is above the standards this Policy upholds.

## What you can — and should — report

The standard for reporting is not certainty that a wrong has occurred. It is a **reasonable concern that something may be wrong**. You do not need proof, you do not need to have witnessed the conduct directly, and you do not need to be certain. The categories below are comprehensive but not exhaustive — if something troubles you and does not fit neatly, report it anyway and let the process determine its significance.

- **Financial misconduct and fraud** — misappropriation or theft, manipulation of records, unauthorized transactions, embezzlement, expense fraud, asset misuse, false accounting.
- **Market conduct and regulatory breaches** — insider trading or market manipulation, front-running, AML/CFT violations, KYC failures, breach of client mandates, falsified regulatory returns, undisclosed conflicts of interest.
- **Corruption, bribery, and abuse of power** — bribery, corrupt procurement, abuse of position, facilitation payments (treated as bribery and prohibited), unmanaged conflicts of interest.
- **Sexual harassment and gender-based misconduct** — verbal, physical, or visual harassment, quid pro quo demands, a hostile work environment, retaliation for rejection. There is no minimum threshold of severity.
- **Abuse of power and unfair treatment** — using authority or seniority in ways that are unauthorized, unfair, or harmful, including pressure, intimidation, or interference in an investigation.
- **Policy deviations by senior management** — selective application of the rules, bypassing approvals, exceeding delegated authority, or applying different standards to oneself than to others.
- **Workplace misconduct and discrimination** — discrimination, bullying, victimization, unfair dismissal, psychological harm.
- **Operational and information-security misconduct** — circumventing controls, falsifying records, unauthorized access to or disclosure of data, misuse of IT systems, concealing errors or breaches, obstructing an audit.

>! **You do not need proof.** The bar for reporting is a genuine, reasonable concern — nothing more. Your job is to report it; the investigation team's job is to find the facts. If you wait until you are certain, the moment to prevent harm may already have passed.

## How to report — the portal comes first

Reporting should be as easy as possible, and the easiest channel is built right into this portal. The most important thing is simply that you use one of the channels below.

**The Report a Concern page — your primary channel.** From the portal sidebar, open **Report a Concern**. Choose a category, describe what you saw or believe happened — you don't need proof, but specifics help an investigation — and submit. Two options on that form matter:

- **"This involves senior management."** Tick it and your report routes directly to the **Chairman / BARC Chair**, *not* the Compliance Officer — so a concern about the most senior people reaches an independent authority without passing through anyone it may concern.
- **"Report anonymously."** Tick it and your identity is **not recorded**. You still receive a **case reference** so you can follow up on progress.

Used together, these two options mean any member of staff — however junior — can raise a concern about anyone — however senior — **anonymously**, and have it land directly at board level. That is a deliberate, powerful protection built into the firm's own system, not an afterthought.

**Other channels**, if you would rather not use the portal: the **Compliance Officer / AMLRO** (standard concerns); your **line manager or Head of Operations** (operational or workplace issues, where they are not involved); the dedicated **whistleblower email**, whistleblower@transworldltd.com.ng; a **sealed letter** to the BARC Chair or the Board Chairman (senior-management concerns); the **physical sealed box** at reception (fully offline and anonymous); or an **external regulator** — SEC, NGX Regulation, or the NFIU — where internal channels are exhausted or the concern is a systemic regulatory breach.

> **Anonymity — your right, and its limits.** You have the right to report anonymously, and anonymous reports are investigated to the fullest extent reasonably possible. The firm will not try to identify an anonymous reporter except where legally required or to protect someone from imminent harm. The trade-off: a report with specific detail — dates, names, amounts — almost always leads to a more effective investigation than a vague one. If you can report with your identity, the protection in this Policy makes that the stronger choice; if anonymity is what you need to feel safe, use it.

> **Report a Concern, or Raise a Grievance?** Use **Report a Concern** for misconduct — fraud, a regulatory breach, harassment, abuse of power. Use **Raise a Grievance** when the concern is about how *you personally* have been treated at work and you want People Ops to resolve it. When in doubt, Report a Concern.

## When the concern involves senior management

The Compliance Officer does **not** handle reports about senior management. Any concern about a Head of Department, an Executive Director, the Managing Director, the Compliance Officer, or a Board member must reach an authority independent of the subject. In the portal, the **"This involves senior management"** toggle does exactly that — it routes your report straight to the **Chairman / BARC Chair**. Off the portal, the same routing comes from a sealed letter to the BARC Chair or the Board Chairman.

>! **This escalation is mandatory, not discretionary.** It is a structural protection that keeps an investigation independent of the person being investigated — so no one, at any level, is beyond independent scrutiny.

## Your protection against retaliation

This is the heart of the Policy. A person who acts in good faith suffers **no adverse professional consequences whatsoever**. Protected actions include making a report through any channel; participating in an investigation; providing evidence; **refusing to take part in conduct you believe violates the Policy, even when instructed to do so by someone more senior**; supporting a colleague who is considering a report; and raising questions about how the firm's policies are applied.

Retaliation is any adverse action taken because of a protected action — dismissal, demotion, denial of promotion or a pay rise, a reassignment, or a negative review tied to the report; hostile workplace treatment; threats or intimidation; disclosing a reporter's identity; or interfering with an investigation. The test is deliberately broad: not whether the adverse action was explicitly linked to the report, but whether a reasonable person could conclude it was taken **because of, or influenced by**, the report.

>! **The guarantee is absolute.** Confirmed retaliation against a whistleblower is a disciplinary matter of the highest severity, with **summary dismissal as the standard consequence** — no exception for seniority or length of service. Your identity is shared only with those who have a genuine need to know, investigation records are accessible only to the investigating officer, the BARC Chair, and the Managing Director, and all personal information is handled in line with the NDPA 2023.

## What happens after you report

Every report is investigated promptly, objectively, and thoroughly. Where you provide contact details, you receive an acknowledgement within **5 working days** and a case reference number. An investigating officer is appointed who is **independent of both the subject and the reporter**; for senior-management concerns this may be an external investigator. The target resolution window is **30–60 working days**, and you are updated if it will take longer. You will always be told whether the concern was upheld.

Fairness runs both ways. Being named as the subject of a report does not establish guilt — until the investigation reaches its findings, the subject is presumed to have acted properly, is told of the allegation at the appropriate stage, and has the chance to respond.

## Good faith, false reports, and the support around you

The protection is for **good faith — not perfect accuracy**. A report that turns out, after investigation, to have been mistaken is fully protected. Only a report the reporter *knew to be false* and made *to harm someone* is an offense — and that bar is deliberately high, so it never becomes an excuse to discourage genuine concerns. Support is available throughout: acknowledgement and progress updates, confidentiality, confidential HR support, the right to seek independent legal advice, and welfare checks during a live investigation.

> If you have a genuine concern and you are unsure whether your evidence is strong enough — **report it anyway**. You are protected.

## Key takeaways

- **Speaking up is strength, not disloyalty.** Silence protects problems; speaking up protects the institution — and protects you.
- The standard to report is a **genuine, reasonable concern**. You do not need proof.
- The portal's **Report a Concern** page is your primary channel. Tick **"This involves senior management"** to route to the Chairman / BARC Chair, and **"Report anonymously"** to keep your identity off the record (you still get a case reference).
- A junior person can report on the most senior person, **anonymously, straight to board level** — by design.
- Reporting in good faith is **absolutely protected**. Retaliation is a matter of the highest severity, with summary dismissal as the standard outcome.
- After you report: acknowledgement within **5 working days**, an independent investigator, a **30–60 working-day** target, and you are always told the outcome.
- Protection is for **good faith, not perfect accuracy** — a mistaken report made honestly is fully protected.

> Whenever you are unsure — **report it**. The whistleblower email is whistleblower@transworldltd.com.ng, and the Report a Concern page is one click away in the portal.

## References

- **Whistleblower Policy v1.0 (First Board Adoption, March 2026)** — primary source for this module.
- Supporting: **Compliance Manual v3.0**; see also the *Code of Conduct & Ethics* module (FND-103) and the *Conflicts of Interest* module (FND-107).
- Channels: the portal **Report a Concern** page; **whistleblower@transworldltd.com.ng**; the Compliance Officer / AMLRO; the BARC Chair and Board Chairman (sealed letter); the physical sealed box at reception; and the external regulators (SEC, NGX, NFIU).
- Regulatory basis: NCCG 2018; ISA 2024; SEC Rules; NGX Dealing Members' Rules 2015; Labour Act (Cap L1 LFN 2004); AML/CFT Act 2022; NDPA 2023.
- *Mandatory module · annual refresh + induction. Content owner: Chief Compliance Officer. Tier A — reviewed against Whistleblower Policy v1.0 on authoring. Two operational items (the reporting email and the portal Report a Concern channel) go beyond the v1.0 text and are logged as open doc-fixes for the Policy's next review; re-verify at each annual cycle.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-108';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_01$id$, m.id, $p$What standard must be met before you report a concern under the Policy?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "You must have documentary proof"}, {"key": "b", "text": "You must have personally witnessed the conduct"}, {"key": "c", "text": "A genuine, reasonable concern that something may be wrong"}, {"key": "d", "text": "You must be certain a wrong has occurred"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The standard is a genuine, reasonable concern — not proof, not certainty, and not first-hand knowledge. Your job is to report it; the investigation team's job is to find the facts.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_02$id$, m.id, $p$A colleague submits claims for personal costs as business expenses. This is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A private matter, not reportable"}, {"key": "b", "text": "Financial misconduct — reportable under the Policy"}, {"key": "c", "text": "Reportable only if it exceeds a set amount"}, {"key": "d", "text": "An HR issue outside this Policy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Expense fraud — claiming personal costs as business expenses — is financial misconduct and is reportable. There is no monetary threshold.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_03$id$, m.id, $p$Which of the following is a reportable market-conduct concern?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Front-running client orders"}, {"key": "b", "text": "Taking an approved lunch break"}, {"key": "c", "text": "Disagreeing with a manager's strategy"}, {"key": "d", "text": "Requesting annual leave"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Front-running — trading ahead of a client order to profit from the price movement it will cause — is a market-conduct breach and is reportable. The others are ordinary workplace matters.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_04$id$, m.id, $p$A facilitation payment — a small payment to speed up a routine process — is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Acceptable if it is described as 'standard'"}, {"key": "b", "text": "Acceptable for government processes"}, {"key": "c", "text": "Treated as a form of bribery and prohibited"}, {"key": "d", "text": "Permitted up to a small limit"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Facilitation payments are treated as a form of bribery and are prohibited, regardless of how routine or 'standard' they are said to be.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_05$id$, m.id, $p$There is a minimum severity threshold before sexual harassment can be reported under this Policy.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. There is no minimum threshold of severity — every instance of sexual harassment is a reportable concern.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_06$id$, m.id, $p$You submit a standard concern through the portal's Report a Concern page without ticking any box. Where does it route?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The Board Chairman"}, {"key": "b", "text": "The Compliance Officer"}, {"key": "c", "text": "An external regulator"}, {"key": "d", "text": "It is not routed to anyone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A standard report goes to the Compliance Officer. You only change that by ticking 'This involves senior management', which routes it to the Chairman / BARC Chair instead.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_07$id$, m.id, $p$To send your concern directly to the Chairman / BARC Chair instead of the Compliance Officer, you:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Email every director individually"}, {"key": "b", "text": "Tick 'This involves senior management' on the Report a Concern form"}, {"key": "c", "text": "Wait for the annual awareness session"}, {"key": "d", "text": "Post it on the office noticeboard"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The 'This involves senior management' toggle on the Report a Concern form routes the report straight to the Chairman / BARC Chair, bypassing the Compliance Officer.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_08$id$, m.id, $p$What is the firm's dedicated whistleblower email address?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "whistleblower@transworldgroup.com"}, {"key": "b", "text": "whistleblower@transworldltd.com.ng"}, {"key": "c", "text": "hr@transworldltd.com.ng"}, {"key": "d", "text": "There is no email channel"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The dedicated whistleblower email is whistleblower@transworldltd.com.ng, monitored by the Compliance Officer and the BARC Chair.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_09$id$, m.id, $p$When is the external regulatory channel (SEC, NGX, NFIU) the appropriate route?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "For any concern, as the first step"}, {"key": "b", "text": "Where internal channels have been exhausted without resolution, or the concern is a systemic regulatory breach"}, {"key": "c", "text": "Only for workplace disputes"}, {"key": "d", "text": "Never — external reporting is prohibited"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The external regulatory channel is for cases where internal channels have been exhausted without resolution, or where the concern is a systemic regulatory breach.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_10$id$, m.id, $p$You report a concern in good faith, and your manager later denies you a promotion because of it. This is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Acceptable management discretion"}, {"key": "b", "text": "Retaliation — a disciplinary matter of the highest severity"}, {"key": "c", "text": "Only an issue if you can prove the intent in writing"}, {"key": "d", "text": "Outside the scope of this Policy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Denying a promotion because of a protected report is retaliation, treated as a disciplinary matter of the highest severity — with summary dismissal as the standard consequence.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_11$id$, m.id, $p$Which of the following is a protected action under this Policy?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Refusing to take part in conduct you believe violates the Policy, even when instructed by someone senior"}, {"key": "b", "text": "Fabricating evidence to strengthen a report"}, {"key": "c", "text": "Disclosing another reporter's identity"}, {"key": "d", "text": "Pressuring a colleague to withdraw a report"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Refusing to participate in conduct you believe breaches the Policy — even on instruction from someone more senior — is a protected action. The others are themselves misconduct.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_12$id$, m.id, $p$What is the standard consequence for confirmed retaliation against a whistleblower?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A verbal warning"}, {"key": "b", "text": "A note on file"}, {"key": "c", "text": "Disciplinary action up to and including summary dismissal, with no exception for seniority"}, {"key": "d", "text": "Mandatory training only"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Confirmed retaliation carries disciplinary action up to and including summary dismissal — the standard consequence — with no exception for seniority or length of service.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_13$id$, m.id, $p$What is the test for whether something counts as retaliation?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Whether the action was explicitly stated to be punishment for the report"}, {"key": "b", "text": "Whether a reasonable person could conclude the adverse action was taken because of, or influenced by, the report"}, {"key": "c", "text": "Whether the reporter complains a second time"}, {"key": "d", "text": "Whether a manager admits to it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The test is deliberately broad: it is enough that a reasonable person could conclude the adverse action was taken because of, or influenced by, the protected report.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_14$id$, m.id, $p$On the Report a Concern form, ticking 'Report anonymously' means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Your report is deleted after submission"}, {"key": "b", "text": "Your identity is not recorded, and you still receive a case reference to follow up"}, {"key": "c", "text": "You must give your name to a manager first"}, {"key": "d", "text": "The report cannot be investigated"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Anonymous reporting means your identity is not recorded, while you still receive a case reference to follow up on progress. Anonymous reports are investigated to the fullest extent reasonably possible.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_15$id$, m.id, $p$In what circumstances may the firm attempt to identify an anonymous reporter?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Whenever management is curious"}, {"key": "b", "text": "Only where it is legally required, or to protect someone from imminent harm"}, {"key": "c", "text": "At any manager's request"}, {"key": "d", "text": "For every report, as a matter of routine"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm will not try to identify an anonymous reporter except in the rare cases where it is legally required or necessary to protect a person from imminent harm.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_16$id$, m.id, $p$Who does NOT handle reports that involve senior management?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The BARC Chair"}, {"key": "b", "text": "The Board Chairman"}, {"key": "c", "text": "The Compliance Officer"}, {"key": "d", "text": "An independent external investigator"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Compliance Officer does not handle senior-management concerns. They route to the BARC Chair and, where appropriate, the Board Chairman, to keep the investigation independent of the subject.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_17$id$, m.id, $p$Can a junior staff member raise a concern about the Managing Director or a Board member anonymously and have it reach board level?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "No — only managers can report on senior people"}, {"key": "b", "text": "No — anonymous reports about directors are not allowed"}, {"key": "c", "text": "Yes — ticking both 'Report anonymously' and 'This involves senior management' (or a sealed letter to the Chairman) sends it to the Chairman / BARC Chair without revealing identity"}, {"key": "d", "text": "Yes, but only if delivered in person"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Yes — by design. Ticking both toggles on the portal (or sending a sealed letter to the Chairman) routes the concern to the Chairman / BARC Chair while keeping the reporter's identity off the record.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_18$id$, m.id, $p$Once you submit a report and provide contact details, within how long do you receive acknowledgement?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Within 24 hours"}, {"key": "b", "text": "Within 5 working days"}, {"key": "c", "text": "Within 30 days"}, {"key": "d", "text": "There is no set timeframe"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Reporters who provide contact details receive an acknowledgement within 5 working days, along with a case reference number.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_19$id$, m.id, $p$Being named as the subject of a whistleblower report means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Guilt has been established"}, {"key": "b", "text": "The person is presumed to have acted properly until the investigation reaches its findings"}, {"key": "c", "text": "Immediate suspension is automatic"}, {"key": "d", "text": "The report is automatically upheld"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Fairness runs both ways. The subject of a report is presumed to have acted properly until findings are reached, is told of the allegation at the appropriate stage, and has the chance to respond.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd108_20$id$, m.id, $p$A report you made in good faith turns out, after investigation, to have been mistaken. You are:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Subject to discipline for being wrong"}, {"key": "b", "text": "Fully protected — the protection is for good faith, not perfect accuracy"}, {"key": "c", "text": "Protected only if you apologize"}, {"key": "d", "text": "Required to repay the cost of the investigation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A good-faith report is fully protected even if it turns out to be mistaken. Only a report the reporter knew to be false and made to harm someone is an offense, and that bar is deliberately high.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-108'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
