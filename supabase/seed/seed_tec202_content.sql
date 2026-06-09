-- =============================================================================
-- seed_tec202_content.sql  (v0.63.0)
-- TEC-202: Data protection in practice — lesson + 20-question check (Proficient).
-- Authored FROM POLICY / BUILD+SOURCE off the firm's own manuals (read-first OCR).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps TEC-202 to live job profiles (verified live, query 3 / verify_p4.sql),
--   so publishing alone surfaces it as assigned work. Publish-only (REG pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Clients trust Transworld with some of the most sensitive information they hold — their identity documents, their bank details, their investment history, their personal contacts. That trust is also a legal obligation. A data breach is not only an operational incident; it is a compliance failure, a regulatory breach, and a betrayal of the client relationship. This module takes data protection out of the realm of "an IT problem" and puts it where it belongs: in the daily work of everyone who touches client or staff personal data. It teaches the principles you apply, the rights you must honour, what to do when something goes wrong, and how long data is kept before it is destroyed.

## What you will be able to do

1. Apply the data-protection principles to your daily handling of personal data.
2. Identify the lawful basis for collecting and using personal data, and avoid purpose drift.
3. Honour data-subject rights and run the breach-response steps.
4. Apply the Record Retention Schedule and dispose of data securely.
5. Meet your obligations when sharing data with vendors or across borders.

## The law you are working under

Data protection in Nigeria is governed by the Nigeria Data Protection Act 2023, supported by the General Application and Implementation Directive issued under it, and overseen by the Nigeria Data Protection Commission. This is the binding regime to apply. Some of the firm's older material still refers to the earlier Nigeria Data Protection Regulation of 2019 and to NITDA as the regulator; those references predate the current law and are superseded — work to the Act and the Commission. The point is not the citation for its own sake. It is that the obligations are statutory, the regulator is active, and getting this wrong has consequences beyond an internal telling-off.

## The principles, applied to your day

The firm sets out data-protection principles that every staff member who handles client or employee personal data must understand and apply. They are not IT rules; they are personal responsibilities. Lawfulness: personal data may be collected and processed only where there is a lawful basis — consent, contractual necessity, a legal obligation, or a legitimate interest — and we do not collect data "just in case." Purpose limitation: data collected for one purpose, such as KYC verification, may not be used for a different one, such as marketing, without fresh consent; always ask whether this is what the client gave us the data for. Data minimisation: we collect only what we genuinely need, and asking for more than necessary is itself a breach. Accuracy: personal data must be kept accurate and up to date, which is both a legal duty and good service. Storage limitation: data is not kept longer than necessary. Integrity and confidentiality: data is protected against unauthorised access, loss, and damage through physical security, digital security, and behavioural security — not sharing client information unnecessarily. Read together, these principles answer most day-to-day questions before they reach Compliance.

It is worth noticing that the principles are not independent rules competing for attention — they reinforce each other. Minimisation makes storage limitation easier, because you are not holding data you never needed. Purpose limitation depends on having named a lawful basis in the first place. Accuracy and integrity together are what let a client trust that the firm both holds the right data and holds it safely. When a situation is genuinely unclear, the most useful move is to walk the six principles in order and see which one the proposed action offends; usually one of them answers the question plainly.

## Lawful basis and the trap of purpose drift

Two of the principles do the heaviest lifting in practice, and they are worth pausing on. First, you need a lawful basis before you collect or use personal data, and "it might be useful one day" is not one of them. For most client data the basis is contractual necessity or a legal obligation such as KYC; for some uses it is consent. Second, and most often where firms slip, is purpose drift: data lawfully collected for one purpose quietly gets used for another. The client gave you their phone number and email to operate their account and meet KYC — using that same contact list to push a new product is a different purpose, and it needs fresh consent. Purpose drift rarely feels like a breach when it happens; it feels like efficiency. That is exactly why it is a trap.

## Information-security controls

Principles are made real by controls. Access to systems and client data is role-based: each staff member has a unique user ID and rights granted to their job, access is reviewed quarterly, and a departing colleague's access is revoked on their last working day. Physical files, paper and digital, are stored in locked, access-controlled locations, and visitor access to operational areas is restricted. The network is protected by firewalls, intrusion prevention, anti-virus, and regular updates. Communications are controlled: confidential client information is not sent over unsecured channels, and sharing client data externally requires the Compliance Officer's approval. These are not abstractions — most real breaches are mundane, an emailed file to the wrong recipient or an unrevoked login, and these controls exist precisely to catch the mundane before it becomes serious.

## When something goes wrong: breach response

Despite good controls, incidents happen, and what matters then is speed and honesty. Any suspected data breach or security incident must be reported immediately to the IT lead and the Compliance Officer; do not investigate quietly, wait to see if it matters, or hope it resolves itself. The firm's manual sets a short reporting window, and the standard you should work to is immediate reporting on discovery — the sooner the Compliance Officer knows, the sooner the firm can contain the incident and assess whether it triggers a regulatory notification under the Act. The Compliance Officer makes the notification assessment, not the person who found the breach; your job is to surface it at once and preserve what you know. The instinct to manage a mistake quietly is the single most damaging response to a breach, because it converts a contained incident into a concealed one.

Practically, surfacing a breach well means a few things done quickly: report it to the IT lead and the Compliance Officer the moment you discover it; write down what you know — what data, whose, how it was exposed, and when you noticed — without speculating; and preserve rather than delete the evidence, because the Compliance Officer needs the facts to assess containment and whether the Act requires the Commission to be notified within its timeline. What you should not do is try to retrieve the situation alone, negotiate with a recipient, or wait to see whether anyone noticed. A breach reported in the first hour is a manageable problem; the same breach discovered later, unreported, is a far larger one — for the clients affected and for the firm.

## Data-subject rights, retention, and disposal

The people whose data you hold have rights, and honouring them is part of the job: a client may ask what data the firm holds about them, ask for it to be corrected, or in defined circumstances ask for it to be erased, and such requests are routed to the Compliance Officer to handle within the timelines the law sets. Running alongside rights is the discipline of retention. The storage-limitation principle is operationalised through the firm's Record Retention Schedule, which specifies how long each category of data is held before secure deletion. Some records, including client and trade records, carry long statutory retention periods; others should be disposed of once their purpose is served. Both ends matter: keeping data past its schedule is a breach of storage limitation, and destroying data the firm is required to retain is its own failure. Disposal is secure — not a recycling bin for paper, not a simple delete for digital — because data carelessly discarded is data breached. The schedule is the answer to "how long do we keep this?"; the answer is never "forever, just in case."

## Vendors and cross-border transfer

Personal data does not stop being your responsibility when it leaves your hands. When the firm shares data with a vendor or service provider — a system host, an outsourced function — that provider must handle it to the same standard, under an arrangement that binds them to protect it, and sharing client data externally goes through the Compliance Officer. Where data is transferred across borders, additional conditions under the Act apply, and this is a question for Compliance rather than a judgement call at the desk. The principle to carry is simple: you remain accountable for personal data you pass on, so you pass it on only where it is protected and approved.

## A worked example

**Illustration — a request and a near-miss (entirely hypothetical).** A client emails asking for a copy of all the personal data the firm holds on them and asks that an old, unused phone number be deleted. You do not answer from your own files; you route the request to the Compliance Officer, who handles it within the statutory timeline, confirming identity first. The same afternoon, a colleague realises they emailed a spreadsheet containing several clients' details to the wrong external address. There is a pull toward quietly asking the recipient to delete it and saying nothing. Instead, the colleague reports it immediately to the IT lead and the Compliance Officer. The Compliance Officer contains the incident, assesses whether it must be notified to the Commission under the Act, and records the response. Separately, a review notices that closed-account files older than the retention schedule are still on the system; they are queued for secure deletion, while the trade records that carry a long statutory retention are kept. Two principles in action — rights honoured, a breach surfaced not buried — and a retention schedule applied at both ends.

## Common traps

- **Treating NDPR 2019 / NITDA as current.** The binding regime is the Nigeria Data Protection Act 2023, its implementation directive, and the Nigeria Data Protection Commission.
- **Collecting "just in case."** Without a lawful basis and a genuine need, collection is a breach; data minimisation is the rule.
- **Purpose drift.** Using KYC contact data for marketing is a different purpose and needs fresh consent.
- **Handling a breach quietly.** Suspected breaches are reported immediately to the IT lead and Compliance; the Compliance Officer assesses regulatory notification.
- **Keeping data forever.** The Record Retention Schedule governs how long each category is held before secure deletion; over-retention is a breach, and disposal must be secure.

## Key takeaways

- Data protection is everyone's responsibility, governed by the Nigeria Data Protection Act 2023, its implementation directive, and the Nigeria Data Protection Commission; older NDPR/NITDA references are superseded.
- Six principles guide daily handling — lawfulness, purpose limitation, data minimisation, accuracy, storage limitation, integrity and confidentiality — and answer most questions before they reach Compliance.
- You need a lawful basis to collect or use data, and purpose drift (KYC data used for marketing) is the most common slip; it needs fresh consent.
- A suspected breach is reported immediately to the IT lead and the Compliance Officer, who assesses regulatory notification; managing a breach quietly is the most damaging response.
- The Record Retention Schedule operationalises storage limitation — keep data no longer than necessary, retain what the law requires, and dispose securely; you remain accountable for data shared with vendors or across borders.

*Reference: the Compliance Manual v3.0, Section 12 (data-protection principles and information-security controls), operationalised here for everyone who handles client or staff personal data. The binding regime is taught as the Nigeria Data Protection Act 2023 with its General Application and Implementation Directive and the Nigeria Data Protection Commission; the source documents' references to the NDPR 2019 and NITDA are superseded and logged for correction, and breach reporting is taught as immediate on discovery. This module operationalises the awareness taught in FND-105; it is a navigation aid, and the Act and the Compliance Manual are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'TEC-202';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_01$id$, m.id, $p$Data protection at the firm is primarily...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an IT department problem"}, {"key": "b", "text": "a personal responsibility for everyone who handles client or staff personal data"}, {"key": "c", "text": "only the Compliance Officer's job"}, {"key": "d", "text": "relevant only to senior management"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The principles are personal responsibilities for every staff member who handles personal data, not IT rules.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_02$id$, m.id, $p$The binding data-protection regime to apply is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the NDPR 2019, overseen by NITDA"}, {"key": "b", "text": "the Nigeria Data Protection Act 2023, its implementation directive, and the Nigeria Data Protection Commission"}, {"key": "c", "text": "there is no Nigerian data-protection law"}, {"key": "d", "text": "the GDPR"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Teach the current regime: the NDPA 2023, its General Application and Implementation Directive, and the NDPC. NDPR 2019 / NITDA references are superseded.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_03$id$, m.id, $p$A lawful basis for processing personal data could be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "'it might be useful one day'"}, {"key": "b", "text": "consent, contractual necessity, a legal obligation, or a legitimate interest"}, {"key": "c", "text": "the data being easy to collect"}, {"key": "d", "text": "a colleague's suggestion"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Personal data may be processed only on a lawful basis — consent, contract, legal obligation, or legitimate interest. 'Just in case' is not a basis.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_04$id$, m.id, $p$Using KYC contact details to market a new product is an example of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "good service"}, {"key": "b", "text": "purpose drift, which needs fresh consent"}, {"key": "c", "text": "data minimisation"}, {"key": "d", "text": "a lawful default"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Data collected for KYC may not be repurposed for marketing without fresh consent — this is purpose drift, the most common slip.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_05$id$, m.id, $p$Data minimisation means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "collecting everything available"}, {"key": "b", "text": "collecting only the data genuinely needed; asking for more than necessary is itself a breach"}, {"key": "c", "text": "deleting all data immediately"}, {"key": "d", "text": "minimising the number of clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$We collect only what we genuinely need; over-collection is itself a compliance breach.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_06$id$, m.id, $p$The storage-limitation principle is operationalised through...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "keeping everything forever"}, {"key": "b", "text": "the Record Retention Schedule, which sets how long each category is held before secure deletion"}, {"key": "c", "text": "the dealing desk's discretion"}, {"key": "d", "text": "the client's preference alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Storage limitation is applied via the Record Retention Schedule: data is kept no longer than necessary, then securely deleted.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_07$id$, m.id, $p$Access to systems and client data is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "shared on a common login"}, {"key": "b", "text": "role-based, with unique IDs, quarterly review, and revocation on a leaver's last working day"}, {"key": "c", "text": "open to all staff"}, {"key": "d", "text": "never reviewed once granted"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Access is role-based with unique user IDs, reviewed quarterly, and revoked on the departing staff member's last day.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_08$id$, m.id, $p$Sharing client data with an external party requires...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no approval"}, {"key": "b", "text": "the Compliance Officer's approval"}, {"key": "c", "text": "only the client's verbal nod"}, {"key": "d", "text": "the dealing clerk's sign-off"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$External sharing of client data requires Compliance Officer approval, and confidential data is not sent over unsecured channels.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_09$id$, m.id, $p$You discover a colleague emailed a file of client data to the wrong external address. You should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "quietly ask the recipient to delete it and say nothing"}, {"key": "b", "text": "report it immediately to the IT lead and the Compliance Officer"}, {"key": "c", "text": "wait to see whether it causes a problem"}, {"key": "d", "text": "handle the regulatory notification yourself"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suspected breaches are reported immediately to the IT lead and Compliance; managing it quietly converts a contained incident into a concealed one.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_10$id$, m.id, $p$Who assesses whether a breach must be notified to the regulator?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the person who found the breach"}, {"key": "b", "text": "the Compliance Officer"}, {"key": "c", "text": "the IT vendor"}, {"key": "d", "text": "the client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer assesses whether the breach triggers a regulatory notification under the Act; your job is to surface it at once.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_11$id$, m.id, $p$The standard for reporting a suspected breach is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "within a month"}, {"key": "b", "text": "immediately on discovery"}, {"key": "c", "text": "at the next team meeting"}, {"key": "d", "text": "only if a client complains"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Report immediately on discovery. The manual's short window is taught as immediate reporting; speed lets Compliance contain and assess the incident.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_12$id$, m.id, $p$A client asks for a copy of all data the firm holds on them. You...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "compile it from your own files and send it"}, {"key": "b", "text": "route the request to the Compliance Officer to handle within the statutory timeline, after identity confirmation"}, {"key": "c", "text": "refuse; clients have no such right"}, {"key": "d", "text": "delete their data instead"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Data-subject access requests are routed to the Compliance Officer, who handles them within the law's timelines after confirming identity.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_13$id$, m.id, $p$Keeping closed-account files beyond the retention schedule is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "prudent"}, {"key": "b", "text": "a breach of the storage-limitation principle"}, {"key": "c", "text": "required by law"}, {"key": "d", "text": "the client's decision"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Over-retention breaches storage limitation; data past its schedule should be securely deleted, while records under statutory retention are kept.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_14$id$, m.id, $p$Disposing of personal data securely means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a paper recycling bin and a simple file delete are fine"}, {"key": "b", "text": "secure destruction appropriate to the medium, because carelessly discarded data is breached data"}, {"key": "c", "text": "leaving it for the cleaners"}, {"key": "d", "text": "emailing it to yourself first"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Secure disposal is required for both paper and digital; data carelessly discarded is data breached.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_15$id$, m.id, $p$When the firm shares personal data with a vendor, the vendor must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "be free to use it however they wish"}, {"key": "b", "text": "handle it to the same standard under an arrangement that binds them to protect it"}, {"key": "c", "text": "keep it indefinitely"}, {"key": "d", "text": "report directly to the client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$You remain accountable for data you pass on; a vendor must be bound to protect it to the same standard, and external sharing goes through Compliance.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_16$id$, m.id, $p$Cross-border transfer of personal data is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a routine desk decision"}, {"key": "b", "text": "subject to additional conditions under the Act and a question for Compliance"}, {"key": "c", "text": "prohibited entirely"}, {"key": "d", "text": "unregulated"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Cross-border transfers carry additional conditions under the Act; route the question to Compliance rather than deciding at the desk.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_17$id$, m.id, $p$'Integrity and confidentiality' as a principle includes...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sharing client data freely to be helpful"}, {"key": "b", "text": "physical, digital, and behavioural security — including not sharing client information unnecessarily"}, {"key": "c", "text": "keeping data only on personal devices"}, {"key": "d", "text": "publishing data for transparency"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Integrity and confidentiality require protecting data through physical security, digital security, and behavioural security, including not over-sharing.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_18$id$, m.id, $p$How does TEC-202 differ from the foundational data-protection module (FND-105)?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is identical"}, {"key": "b", "text": "it operationalises the awareness from FND-105 into day-to-day practice for everyone handling client and firm data"}, {"key": "c", "text": "it covers only HR data"}, {"key": "d", "text": "it is about trading systems"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$FND-105 builds awareness; TEC-202 operationalises it into the practical handling, rights, breach response, and retention everyone must apply.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_19$id$, m.id, $p$A client gave their email to operate their account. Marketing wants to use that list for a campaign. The correct view is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fine — the firm already holds the email"}, {"key": "b", "text": "this is a new purpose requiring fresh consent"}, {"key": "c", "text": "permitted because it is internal"}, {"key": "d", "text": "the dealing desk can decide"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Repurposing account/KYC contact data for marketing is purpose drift and requires fresh consent.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec202_20$id$, m.id, $p$Accuracy as a data-protection principle means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "keeping the most data possible"}, {"key": "b", "text": "keeping personal data accurate and up to date"}, {"key": "c", "text": "accuracy only matters for trades"}, {"key": "d", "text": "data never needs updating"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Accuracy requires personal data to be kept accurate and up to date — both a legal duty and good client service.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'TEC-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: TEC-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'TEC-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: TEC-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: TEC-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
