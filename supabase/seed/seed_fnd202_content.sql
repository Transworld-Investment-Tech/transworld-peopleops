-- seed_fnd202_content.sql — P9 v0.69.0
-- Publishes FND-202 (lm_fnd202): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_fnd202' AND code = 'FND-202') THEN
    RAISE EXCEPTION 'FND-202 shell (lm_fnd202) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'Writing as a control at a regulated firm: the anatomy of a client-ready email, the 24-hour acknowledgment and status-update habits from the Operational Manual, tone under pressure, channel and classification discipline, and the before-you-send checklist.',
  body = $tw_p9_fnd202$## Writing is a control

At a regulated dealing member, everything you write is a record. The email you send a client at 4:50 p.m. on a Friday can be read later by the client's lawyer, the firm's compliance officer, an NGX examiner, or a court — each of them taking your sentences at face value, with none of the context in your head. That is not a reason to fear writing. It is the reason to treat writing as what it is here: a control, a brand, and a craft.

The Operational Manual makes the stakes explicit in its chapter on client communications: a prompt, professional email response is one of the most visible demonstrations of the firm's standards, and clear communication builds trust, reduces complaints, and supports a positive regulatory record. Read that sequence again — trust, complaints, regulatory record. Your writing sits on all three. And the Manual's standard for it binds everyone, not just client-facing roles: maintain professional tone, correct grammar, and accurate information in all replies — assigned, in the procedure itself, to all staff.

This module teaches the craft behind that standard. It pairs naturally with the documentation discipline of FND-110: that module taught you that what is not documented did not happen; this one teaches you to make what you document worth the record it becomes.

## The anatomy of a client-ready email

A client-ready email is one the client can act on in a single reading, and the firm can stand behind in any later reading. Build it in five parts.

**A subject line that files itself.** State the matter and the reference: "Your account opening — reference TW/2026/0143 — one document outstanding." The Manual's procedure requires a reference number where applicable for every acknowledged request; the subject line is where it lives. A client — or a colleague, or an examiner — searching for this thread in eight months should find it on the first try.

**The point, first.** Open with the sentence the reader needs: what has happened, what you need, or what will happen next. Background follows the point; it never precedes it. Burying the conclusion in paragraph three is the most common failure in professional writing, and the most expensive — busy readers act on what they read first.

**Plain language.** The Handbook's client communication standards lead with it: be clear and accurate — plain language, no jargon, factually correct. Write "your shares were sold today and the money will reach your account within one business day of settlement," not a paragraph of market plumbing. Jargon does not make the firm look expert; it makes the client call to ask what you meant, which doubles the work and halves the trust.

**One clear ask.** If you need something, say exactly what, from whom, by when, and how to send it — once, plainly, near the end where requests are expected. Three asks scattered through five paragraphs reliably produce one answered and two forgotten.

**A committed next step.** Close with what happens next and when — and only commit to dates the process can actually keep. An email with no next step leaves the client wondering; an email with an optimistic one manufactures the firm's next apology.

## The 24-hour rule and the status-update habit

The Manual's inbox procedure sets the rhythm of client correspondence, and its numbers are worth memorizing because clients experience them directly. The firm's official client service inbox is monitored throughout business hours every working day. Every client request is acknowledged within 24 hours, with a reference number where applicable. A complete resolution or status update follows within 1–3 business days. And for complex requests, the procedure is explicit about the habit that separates good firms from frustrating ones: send regular progress updates so the client is never left wondering.

Notice what the acknowledgment is and is not. It is not the answer — it is the receipt: we have your request, here is its reference, here is when you will hear from us. The Handbook applies the same discipline internally and externally: be responsive — reply within one business day, even just to acknowledge receipt. Silence is the one response that is always wrong. A client who knows their matter is moving forgives almost any reasonable timeline; a client in silence escalates, and an escalation born of silence is a complaint the firm earned.

Two supporting habits complete the rhythm. Ask early: if a request is unclear, the procedure says to seek clarification promptly — a same-day clarifying question beats three days of work on the wrong task. And archive everything: all client emails and firm responses are archived in the CRM or secure email archive, because the thread is the record, and the record is the firm's memory and its defense.

## Tone under pressure

The real test of professional writing is not the routine confirmation; it is the email you write when something has gone wrong — a complaint, an error, a delay the firm caused. The Manual's complaints procedure sets the written standard: a clear, factual, professionally worded response, with a resolution or specific next steps and timelines.

Unpack "factual." Under pressure, write what is known and verified — dates, amounts, references, what the records show. Do not speculate about causes you have not confirmed, do not assign blame to colleagues or systems in writing, and do not characterize ("a complete breakdown," "totally unacceptable") when you can describe ("the instruction dated 14 March was processed on 18 March"). Speculation and blame in a client email become facts in someone else's file.

Unpack "professionally worded." The Handbook's standard is a respectful tone in all interactions, including difficult ones. The angriest message you receive deserves the calmest reply you can write — not because the anger is right, but because your reply will outlive the moment. Acknowledge the client's experience without conceding facts not yet established: "I understand this delay has been frustrating" concedes nothing; "you're right, we completely failed you" concedes everything, before the investigation has even run. Where the firm has erred and the error is established, say so plainly and move immediately to the remedy — a factual apology with a fix attached is the strongest sentence in the genre.

And never reply angry. Draft if you must, then leave it. An intemperate reply is permanent; the satisfaction of sending it lasts about a minute.

## Internal writing: briefs, escalations, file notes

The same craft serves your colleagues. The Handbook sets the internal channel rule: email is for formal communications requiring documentation — respond within 24 business hours. So write internal email like it will be relied on, because it will be.

An escalation to your lead carries four things: the situation in one sentence, what you have already done, the specific decision or help you need, and the deadline attached. "Flagging some issues with the Adekunle file" is not an escalation; it is anxiety forwarded. A brief for a manager leads with the recommendation, then the reasons — managers read conclusions first for the same reason clients do. And the file note is the quiet workhorse of the regulated firm: who, what, when, what was agreed, what happens next, written the same day while memory is fresh. The retreat's instruction was direct — if you are speaking to a client, the firm must know; the system says document, write it down.

## Channels and classification

Where you write is as governed as what you write. The Handbook's channel rules are short and absolute: email is the formal, documented channel; instant messaging is for quick coordination — never use it for confidential information; document sharing happens only on company-approved platforms. The practical line for a fifteen-person firm where everyone has everyone's phone number: the convenience of a chat message is real, but anything substantive about a client, a transaction, or a decision belongs in email or the portal, where the record lives. If a chat conversation turns substantive, move it — "let me confirm this by email" — and let the email be the record.

Behind the channel rule sits the classification scheme, which tells you who may receive what you are writing. Public information is approved for external distribution. Internal Use is for employees only. Confidential is shared only with employees who need it for their work — client lists, internal financial data. Restricted material — individual client financial data, employee personal data — moves only to specifically named authorized individuals. Before you attach a file or forward a thread, classify what is in it; the fastest way to convert a well-written email into an incident is to send it to the wrong audience. The Handbook closes the loop with security: encrypted channels and identity verification for sensitive communications — if you are not certain the address belongs to your client, verify before the account details travel.

## The before-you-send checklist

The firm believes in checklists for repetitive critical processes — and sending written communication is exactly that. Six checks, ten seconds:

Accuracy — every figure, date, name, and account reference verified against the record, not memory. Completeness — the reader can act without a follow-up question. Clarity — point first, plain language, one ask. Tone — would you be content for the compliance officer, or the client's lawyer, to read this cold? Audience — right recipients, right classification, attachments checked. Record — reference number present, thread archived where the procedure requires.

### Worked example (hypothetical)

A client, Mr. Adeyemi, writes in irritation: his sale proceeds have not arrived and "your people keep telling me different things."

The weak reply — and it gets drafted in firms everywhere — reads: "Dear Sir, sorry for the issues. The ops team had some problems with the settlement but it should hopefully be sorted soon. Apologies for the inconvenience." Every failure in one breath: no reference, no facts, blame assigned to colleagues, speculation ("should hopefully"), no next step, and a tone that confirms the client's suspicion that nobody is in charge.

The client-ready version: subject "Your sale proceeds — reference TW/2026/0287 — status and next step." Then: acknowledgment of his messages and the frustration of receiving differing information; the verified facts — the sale executed on the 12th, settlement completed on the 13th under the Exchange's cycle, and the transfer instruction to his bank issued on the morning of the 14th; the precise status — the funds left the firm's account on the 14th and the bank's processing typically completes within one business day; one committed next step — "I will confirm to you by 3:00 p.m. tomorrow whether your bank has received value, and I am your single point of contact on this matter"; and the archive copy filed against the reference. Nothing is conceded that is not established, no colleague is blamed, the client knows exactly what happens next — and the thread, read cold by anyone, shows a firm in control of its own process.

## Common traps

The jargon screen — writing to sound expert instead of to be understood. The buried lede — the answer in paragraph three, the deadline in paragraph five. The scattered ask — three requests, one answered. The optimistic promise — committing to dates the process cannot keep, manufacturing the next apology. The angry send — permanence purchased for a minute of satisfaction. The wrong channel — substantive client matters decided in chat, where the record is not. And the blame leak — colleagues or systems faulted in writing, in a document the client now owns.

## Key takeaways

At this firm, writing is a control: every message is a record that builds trust, prevents complaints, and supports the regulatory standing — or undermines all three. Build client emails in five parts: a self-filing subject with the reference, the point first, plain language, one clear ask, a committed next step. Live the Manual's rhythm — acknowledge within 24 hours, resolve or update within 1–3 business days, and never leave a client wondering. Under pressure, write only what is verified, characterize nothing, blame no one, and reply calm or not yet. Keep substance in documented channels, classified to its audience. And run the ten-second checklist — because the standard of professional tone, correct grammar, and accurate information belongs, by procedure, to all staff. That includes you, on your busiest day, in your shortest reply.

---

*Sources: Transworld Operational & Procedure Manual v3.0, §21 (Sending and Receiving Client Communications) and §22 (written complaint responses); Employee Handbook v2.1, Chapter 25 (communication standards, information classification, client communication standards); Transworld Company Retreat Report 2026 (documentation discipline). Worked examples are hypothetical.*$tw_p9_fnd202$,
  estimated_minutes = 18,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_fnd202';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_fnd202_01', 'lm_fnd202', 'Why is writing described as ''a control'' at Transworld?', 'SINGLE', '[{"key": "a", "text": "Because every message is a record that can later be read by compliance, examiners, or a court at face value"}, {"key": "b", "text": "Because all outgoing email requires the compliance officer''s pre-approval"}, {"key": "c", "text": "Because written work is graded in the performance cycle"}, {"key": "d", "text": "Because the portal limits message length"}]'::jsonb, '["a"]'::jsonb, 'Everything written at a regulated firm is a record; the reader later may have none of the context in your head.', 1, true),
  ('q_fnd202_02', 'lm_fnd202', 'Per the Operational Manual, what does a prompt, professional email response demonstrate and support?', 'SINGLE', '[{"key": "a", "text": "The IT department''s server quality"}, {"key": "b", "text": "The firm''s standards \u2014 building trust, reducing complaints, and supporting a positive regulatory record"}, {"key": "c", "text": "The sender''s eligibility for client-facing roles"}, {"key": "d", "text": "Compliance with the leave policy"}]'::jsonb, '["b"]'::jsonb, 'The Manual ties written communication directly to trust, complaints, and the regulatory record.', 2, true),
  ('q_fnd202_03', 'lm_fnd202', 'Who does the Manual''s standard of ''professional tone, correct grammar, and accurate information'' apply to?', 'SINGLE', '[{"key": "a", "text": "Client relationship officers only"}, {"key": "b", "text": "Staff at G3 and above"}, {"key": "c", "text": "The compliance function"}, {"key": "d", "text": "All staff"}]'::jsonb, '["d"]'::jsonb, 'The inbox procedure assigns that standard explicitly to all staff — not only client-facing roles.', 3, true),
  ('q_fnd202_04', 'lm_fnd202', 'Within what time must every client request be acknowledged, and what should the acknowledgment include where applicable?', 'SINGLE', '[{"key": "a", "text": "48 hours, with an apology for the delay"}, {"key": "b", "text": "Within 24 hours, with a reference number where applicable"}, {"key": "c", "text": "Same hour, with a full resolution"}, {"key": "d", "text": "One week, with a meeting invitation"}]'::jsonb, '["b"]'::jsonb, 'The procedure: acknowledge every client request within 24 hours and provide a reference number where applicable.', 4, true),
  ('q_fnd202_05', 'lm_fnd202', 'What is the acknowledgment, in essence?', 'SINGLE', '[{"key": "a", "text": "The firm''s formal legal position on the matter"}, {"key": "b", "text": "An optional courtesy for premium clients"}, {"key": "c", "text": "The receipt \u2014 confirmation the request is held, its reference, and when the client will hear next; not the answer itself"}, {"key": "d", "text": "A draft of the final resolution for client comment"}]'::jsonb, '["c"]'::jsonb, 'Acknowledgment is the receipt, not the answer — it tells the client their matter is in the system and moving.', 5, true),
  ('q_fnd202_06', 'lm_fnd202', 'What does the Manual require after acknowledgment?', 'SINGLE', '[{"key": "a", "text": "Resolution within 30 days in all cases"}, {"key": "b", "text": "Escalation of every request to management"}, {"key": "c", "text": "Nothing further unless the client follows up"}, {"key": "d", "text": "A complete resolution or status update within 1\u20133 business days"}]'::jsonb, '["d"]'::jsonb, 'The rhythm is acknowledge within 24 hours, then resolve or update within 1–3 business days.', 6, true),
  ('q_fnd202_07', 'lm_fnd202', 'For complex requests, what habit does the procedure prescribe?', 'SINGLE', '[{"key": "a", "text": "Regular progress updates so the client is never left wondering"}, {"key": "b", "text": "Weekly summary letters by registered post"}, {"key": "c", "text": "Transferring the matter to the MD''s office"}, {"key": "d", "text": "A single update at resolution to avoid confusion"}]'::jsonb, '["a"]'::jsonb, 'The procedure is explicit: send regular progress updates — silence is the one response that is always wrong.', 7, true),
  ('q_fnd202_08', 'lm_fnd202', 'A client request is ambiguous. What does the procedure say to do?', 'SINGLE', '[{"key": "a", "text": "Proceed on the most likely interpretation to save time"}, {"key": "b", "text": "Ask for clarification promptly \u2014 a same-day question beats days of work on the wrong task"}, {"key": "c", "text": "Decline the request until it is resubmitted clearly"}, {"key": "d", "text": "Forward it to compliance for interpretation"}]'::jsonb, '["b"]'::jsonb, 'The procedure requires prompt clarification when additional information is needed.', 8, true),
  ('q_fnd202_09', 'lm_fnd202', 'Why must client emails and the firm''s responses be archived in the CRM or secure email archive?', 'SINGLE', '[{"key": "a", "text": "To measure staff productivity by email volume"}, {"key": "b", "text": "To free up inbox storage quotas"}, {"key": "c", "text": "Because the thread is the record \u2014 the firm''s memory and its defense"}, {"key": "d", "text": "Because clients may request deletion at any time"}]'::jsonb, '["c"]'::jsonb, 'Archiving is in the procedure because the correspondence trail is the firm''s evidentiary record.', 9, true),
  ('q_fnd202_10', 'lm_fnd202', 'Where should the most important sentence of a professional email sit?', 'SINGLE', '[{"key": "a", "text": "First \u2014 the point precedes the background, never follows it"}, {"key": "b", "text": "Last, as a conclusion the reader builds toward"}, {"key": "c", "text": "In the attachment, with the email as a cover note"}, {"key": "d", "text": "In the subject line only"}]'::jsonb, '["a"]'::jsonb, 'Busy readers act on what they read first; burying the conclusion is the most common and expensive failure.', 10, true),
  ('q_fnd202_11', 'lm_fnd202', 'Per the Handbook''s client communication standards, what does ''clear and accurate'' mean?', 'SINGLE', '[{"key": "a", "text": "Technical terminology to demonstrate expertise"}, {"key": "b", "text": "Plain language, no jargon, factually correct"}, {"key": "c", "text": "Short messages under fifty words"}, {"key": "d", "text": "Formal legal phrasing throughout"}]'::jsonb, '["b"]'::jsonb, 'Jargon doesn''t make the firm look expert; it makes the client call to ask what you meant.', 11, true),
  ('q_fnd202_12', 'lm_fnd202', 'Why should an email carry one clear ask rather than several scattered requests?', 'SINGLE', '[{"key": "a", "text": "The portal rejects emails with multiple questions"}, {"key": "b", "text": "Multiple asks require manager approval"}, {"key": "c", "text": "Clients are billed per request answered"}, {"key": "d", "text": "Scattered asks reliably produce one answered and the rest forgotten"}]'::jsonb, '["d"]'::jsonb, 'One plain ask — what, from whom, by when, how — placed where requests are expected, gets answered.', 12, true),
  ('q_fnd202_13', 'lm_fnd202', 'What is the danger of an optimistic committed date in a client email?', 'SINGLE', '[{"key": "a", "text": "It manufactures the firm''s next apology when the process cannot keep it"}, {"key": "b", "text": "It obliges the firm to pay compensation automatically"}, {"key": "c", "text": "It shortens the regulatory limitation period"}, {"key": "d", "text": "It must be countersigned by the COO"}]'::jsonb, '["a"]'::jsonb, 'Commit only to dates the process can keep; the alternative converts today''s reassurance into tomorrow''s broken promise.', 13, true),
  ('q_fnd202_14', 'lm_fnd202', 'What is the written standard for responding to a complaint?', 'SINGLE', '[{"key": "a", "text": "A sympathetic personal message from the most senior officer"}, {"key": "b", "text": "A holding reply until the client withdraws the complaint"}, {"key": "c", "text": "A clear, factual, professionally worded response with a resolution or specific next steps and timelines"}, {"key": "d", "text": "A standard template with no case-specific content"}]'::jsonb, '["c"]'::jsonb, 'The Manual''s complaints standard: clear, factual, professionally worded, with resolution or next steps and timelines.', 14, true),
  ('q_fnd202_15', 'lm_fnd202', 'Under pressure, what does writing ''factually'' exclude?', 'SINGLE', '[{"key": "a", "text": "Dates, amounts, and reference numbers"}, {"key": "b", "text": "Speculating about unconfirmed causes, assigning blame in writing, and characterizing instead of describing"}, {"key": "c", "text": "Any acknowledgment of the client''s frustration"}, {"key": "d", "text": "Mentioning the settlement cycle"}]'::jsonb, '["b"]'::jsonb, 'Write what is known and verified. Speculation and blame in a client email become facts in someone else''s file.', 15, true),
  ('q_fnd202_16', 'lm_fnd202', 'Which sentence acknowledges a client''s experience without conceding unestablished facts?', 'SINGLE', '[{"key": "a", "text": "''You''re right, we completely failed you.''"}, {"key": "b", "text": "''Our operations team clearly mishandled this.''"}, {"key": "c", "text": "''This was probably a system error on our side.''"}, {"key": "d", "text": "''I understand this delay has been frustrating.''"}]'::jsonb, '["d"]'::jsonb, 'Acknowledge the experience; concede facts only once established. The other options admit causes or blame before any investigation.', 16, true),
  ('q_fnd202_17', 'lm_fnd202', 'What is the rule for the angry reply you are tempted to send?', 'SINGLE', '[{"key": "a", "text": "Send it only to internal recipients"}, {"key": "b", "text": "Send it, then recall it within an hour"}, {"key": "c", "text": "Draft if you must, then leave it \u2014 an intemperate reply is permanent; the satisfaction lasts a minute"}, {"key": "d", "text": "Have a colleague send it on your behalf"}]'::jsonb, '["c"]'::jsonb, 'Reply calm or not yet. Your reply will outlive the moment that provoked it.', 17, true),
  ('q_fnd202_18', 'lm_fnd202', 'What four things should an escalation to your lead contain?', 'SINGLE', '[{"key": "a", "text": "The situation in one sentence, what you have already done, the specific decision or help needed, and the deadline"}, {"key": "b", "text": "The full email thread, the org chart, your job description, and a meeting request"}, {"key": "c", "text": "An apology, a root-cause analysis, a remediation plan, and a budget"}, {"key": "d", "text": "The client''s history, the desk''s metrics, your goals, and the policy text"}]'::jsonb, '["a"]'::jsonb, '''Flagging some issues with the file'' is anxiety forwarded, not an escalation. Give situation, action taken, ask, deadline.', 18, true),
  ('q_fnd202_19', 'lm_fnd202', 'Per the Handbook''s channel rules, which statement is correct?', 'SINGLE', '[{"key": "a", "text": "Instant messaging may carry confidential information if deleted afterward"}, {"key": "b", "text": "Any platform is acceptable if the client prefers it"}, {"key": "c", "text": "Email is for formal communications requiring documentation; instant messaging is for quick coordination and never for confidential information"}, {"key": "d", "text": "Document sharing may use personal cloud drives for speed"}]'::jsonb, '["c"]'::jsonb, 'Email is the documented formal channel; IM is coordination only — and substantive matters that start in chat should move to email.', 19, true),
  ('q_fnd202_20', 'lm_fnd202', 'An email contains an individual client''s account balance. Under the classification scheme, how does it move?', 'SINGLE', '[{"key": "a", "text": "Internal Use \u2014 any employee may receive it"}, {"key": "b", "text": "Public \u2014 balances are market information"}, {"key": "c", "text": "Confidential \u2014 any client-facing employee may receive it"}, {"key": "d", "text": "Restricted \u2014 only to specifically named authorized individuals, with sensitive communications secured and identity verified"}]'::jsonb, '["d"]'::jsonb, 'Individual client financial data is Restricted: named authorized recipients only, with encryption and identity verification for sensitive sends.', 20, true)
ON CONFLICT (id) DO UPDATE SET
  module_id = EXCLUDED.module_id,
  prompt = EXCLUDED.prompt,
  type = EXCLUDED.type,
  options = EXCLUDED.options,
  correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation,
  sort_order = EXCLUDED.sort_order,
  active = EXCLUDED.active,
  updated_at = CURRENT_TIMESTAMP;

DO $$
DECLARE qn integer; st text;
BEGIN
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_fnd202' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_fnd202';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'FND-202: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'FND-202: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
