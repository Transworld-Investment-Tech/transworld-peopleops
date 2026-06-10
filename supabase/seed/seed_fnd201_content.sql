-- seed_fnd201_content.sql — P9 v0.69.0
-- Publishes FND-201 (lm_fnd201): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_fnd201' AND code = 'FND-201') THEN
    RAISE EXCEPTION 'FND-201 shell (lm_fnd201) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'What G2 means at Transworld: independent on the core work, so development turns to working across desks, teams, and functions. The firm as one system, the trade lifecycle as a relay, reliability as currency, and how to work with control functions without friction.',
  body = $tw_p9_fnd201$## The shift G2 asks of you

At G1 the firm asked you to learn the craft and deliver: execute defined tasks well, under guidance, while absorbing how the firm works and its rules. By G2 you have crossed a real line — the grade framework defines G2 as the Associate level: routine work done independently. Nobody needs to stand behind you for the core of your job anymore.

Which raises the question this module answers: if independence is achieved, what is G2 development for? The Growth Ladder's answer is one word — Collaborate. At G2, development turns to working well across people, teams, and functions, and to deepening the craft toward higher proficiency. The Employee Handbook compresses it to a phrase: work effectively across functions. And WS7 adds the stakes: G2 is the launch pad for the biggest transition on the ladder — because the doer-to-developer move at G3 is built almost entirely out of cross-functional muscles you grow now.

So this module is not about doing your tasks better. It is about becoming the kind of colleague whose work travels well — across desks, through handoffs, into other people's deadlines — in a firm small enough that every handoff has a face.

## The firm as one system

To work across the firm you need its map. Transworld organizes its roughly fifteen people into five job families — Leadership; Investments; Control & Operations; Business Development; and Administration & Corporate Services — with two career tracks rising through them: the Manager track, which grows by leading people, and the Expert track, which grows by mastery. Through G0–G2 everyone shares a common foundation; the tracks diverge from G3.

One structural rule matters for daily cross-functional work: control-function independence. Compliance, risk, internal control, and the finance and accounting line answer through reporting lines deliberately separate from the revenue-generating desks they check. That separation is not bureaucracy; it is what makes the firm's numbers and conduct credible to regulators, auditors, and clients. You will feel it as a G2 whenever a control colleague declines to simply take your word for something — more on that below.

The practical consequence of a five-family, fifteen-person firm is that there is no department big enough to hide in. Almost nothing you produce is consumed inside your own desk. Your output is somebody else's input, usually within hours.

## The relay: how work actually crosses desks

Take the firm's core product — a client trading securities on the NGX — and watch how many hands it passes through.

Business Development brings the prospect in. Client onboarding and KYC make the prospect a client the firm may lawfully serve — identity verified, documentation complete, risk assessed. The dealing desk executes the mandate on the Exchange. Settlement and operations ensure the trade completes — instructions matched, the contract note out, cash and securities where they should be. Finance accounts for it all and reconciles the records. Compliance and internal control check the whole chain, before and after.

Every arrow in that chain is a handoff, and every G2 in the firm sits on at least one of them. The Client Services officer's onboarding file quality determines whether the dealing desk can act on a mandate without delay. The dealing clerk's instruction accuracy determines whether settlement runs clean. The operations officer's records determine whether finance reconciles in hours or days. The relay metaphor is exact: a baton dropped at any exchange is dropped for the whole team, and in a regulated market the dropped baton is not just slow — it can be a breach, a client complaint, or a query from the Exchange.

Working across functions, then, starts with knowing your handoffs cold: who consumes what you produce, in what form, by when — and whose output you consume, so you can tell them the same.

## Reliability as currency

The retreat's discussion of trust gave the firm its sharpest framing of what makes a G2 valuable: trust is built in patterns, not moments. A colleague who consistently fails to follow through on small commitments creates a pattern of distrust that eventually excludes them from meaningful responsibility. Conversely, a team member who documents every client interaction, communicates proactively, and follows through on promises builds a pattern that makes them an indispensable extension of the system.

Read that last phrase again — an extension of the system. That is the G2 destination. When colleagues on other desks can build their plans on your word, you have become infrastructure, and infrastructure is what gets entrusted with bigger things.

The pattern is built from small, repeated behaviors. Answer when you said you would, or say early that you cannot. Close loops: a task someone handed you is not done until they know it is done. And document — the retreat was pointed about this: if you are speaking to a client and not telling the firm, you are failing at communication; the system says document, write it down. Documentation discipline (the subject of FND-110) is also a cross-functional behavior: the file note you write today is what lets a colleague on another desk act tomorrow without finding you first.

## Cross-functional etiquette

A few crafts make the difference between a G2 who is easy to work with and one who is quietly routed around.

**Ask well.** When you need something from another desk, bring a complete request: what you need, why, by when, and what you have already checked. "Can you send me the thing for the client" costs the other person a clarifying round-trip; a precise request costs them nothing but the work itself. Respect their deadlines as you would your own — their month-end is not less real than yours.

**Hand off in writing.** Verbal handoffs evaporate. A handoff is an email or portal note stating what is being passed, its current state, what remains, and any deadline attached. The recipient should be able to act without calling you — and if you both disappear on leave, the work should still be legible to whoever picks it up.

**Receive well, too.** Cross-functional skill runs in both directions. When work lands on you from another desk, confirm receipt the same day, restate in one line what you understand you now own and by when — misunderstandings are cheapest at minute one — and tell the sender when they will hear from you. A G2 who receives work crisply trains the whole firm to hand off properly, because good handoffs are answered in kind. And if what lands on you is incomplete, say so immediately and specifically, rather than working around the gap and resenting it; the sender usually does not know.

**Escalate early, not loudly.** Discovering at the deadline that you are blocked helps nobody. The moment you can see a handoff will be late or a dependency is missing, say so to the person waiting — with a revised time and what you are doing about it. Early bad news is a professional courtesy; late bad news is a pattern of distrust forming.

**Disagree at the desk, align in front of others.** Cross-functional friction is normal — priorities genuinely conflict. Argue it out directly with the colleague concerned, escalate jointly to your leads if you cannot resolve it, and never relitigate a settled question in front of a client or in a wider forum.

## Working with control functions without friction

At some point — probably this week — compliance, internal control, or finance will ask you for something: evidence for a transaction, a correction to a record, a hold on something you wanted to move fast. The unproductive G2 response is to treat this as obstruction. The accurate response is to recognize what is happening: the firm checking itself, which is the firm protecting you.

Three habits make these interactions smooth. First, give control colleagues documents, not assurances — their job is precisely not to take your word for it, so the fastest path through any check is the evidence itself. Second, never take a query personally: a question about a transaction is a question about a record, not an accusation. Third, when a control finding lands on something you own, fix it visibly and quickly — a G2 who responds to findings with speed and without defensiveness is building exactly the pattern of trust described above, with the colleagues whose opinion of your reliability travels furthest.

## Preparing for the divergence

G2 is where the firm starts watching for what comes next. From G3 the tracks split — leading a team on the Manager track, or owning a domain on the Expert track — and the evidence for either is gathered at G2, mostly in cross-functional form: the complex case you coordinated across three desks, the junior you informally helped onboard, the process gap you spotted between two functions and fixed, the standing you built with the control functions. The Manager PD Guide draws the distinction your manager will be applying: performing the Collaborate stage when things are clear is good G2 work; embodying it consistently — including when things are ambiguous and pressured — is what G3-readiness looks like. You do not need to choose a track yet. You need to be building the evidence that gives you the choice.

### Worked example (hypothetical)

Chiamaka is a G2 Client Services officer. A new corporate client's onboarding stalls: the KYC file needs a director's verification document the client keeps promising, the dealing desk has a mandate waiting, and finance has flagged that the funding arrived before the account is fully open.

The G1 version of Chiamaka would process her own checklist and wait. Instead she runs the relay. She maps who is holding what: the missing document (client), the mandate (dealing desk, blocked by her), the flagged funds (finance, waiting on the same file). She emails the client a precise list of the outstanding item with a deadline, copies her lead, and logs the contact in the file. She tells the dealing desk the same day — early, not at the deadline — that the mandate cannot proceed yet and gives the expected date. She asks compliance, with the file in front of them, whether anything else will be needed for this client type, so the next round-trip is the last one. When the document arrives, her handoff note to the dealing desk states the file's status, the verification completed, and the one condition finance attached.

Nothing in that story is heroic. Every step is small, written, early, and complete — and three desks experienced the same thing: Chiamaka's work travels well. That, repeated for a year, is a Collaborate-stage record. The version where she identified the recurring gap in corporate onboarding and proposed the fix is the G3-readiness record.

## Common traps

The silo trap: optimizing your own checklist while your handoffs starve — being individually excellent and systemically useless. The verbal-handoff trap: work passed in conversation, deniable and illegible within a day. The deadline-surprise trap: sitting on bad news until it is everyone's emergency. The control-friction trap: treating compliance queries as insults and acquiring a reputation that follows you further than any single file. And the visibility trap: doing genuinely collaborative work that never reaches the record — at this firm, the undocumented favor is real kindness but invisible evidence.

## Key takeaways

G2 means the core work is yours alone — so development turns outward, to working across people, teams, and functions, on the way to the ladder's biggest transition. Know the firm's map: five families, two tracks, control functions deliberately independent. Know your handoffs cold, because in a fifteen-person relay your output is someone's input within hours. Build the pattern — small commitments kept, loops closed, everything documented — that makes you an extension of the system. Practice the etiquette: ask completely, hand off in writing, escalate early, give control functions evidence rather than assurances. And remember what G2 is the launch pad for: the cross-functional record you build now is the evidence that opens both tracks at G3.

---

*Sources: HR WS2 Workforce Architecture & Jobs (families, tracks, grade definitions, control-function independence); Employee Handbook v2.1 (Growth Ladder; communication standards); HR WS5 Performance & Discipline Pack, Part 1; HR WS7 Learning & Development Pack, Part 2 — The Grade-Based Growth Path. Worked examples are hypothetical.*$tw_p9_fnd201$,
  estimated_minutes = 18,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_fnd201';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_fnd201_01', 'lm_fnd201', 'How does the firm''s grade framework define G2?', 'SINGLE', '[{"key": "a", "text": "Learning the craft under close supervision"}, {"key": "b", "text": "The Associate level \u2014 routine work done independently"}, {"key": "c", "text": "Autonomous ownership of a whole area"}, {"key": "d", "text": "Running a team or function"}]'::jsonb, '["b"]'::jsonb, 'G2 is the Associate level: routine work independently. Independence on the core work is what frees development to turn outward.', 1, true),
  ('q_fnd201_02', 'lm_fnd201', 'Once a G2 can do the core work independently, what does development turn to?', 'SINGLE', '[{"key": "a", "text": "Preparing for professional qualification exams"}, {"key": "b", "text": "Maximizing individual output volume"}, {"key": "c", "text": "Shadowing the Leadership family"}, {"key": "d", "text": "Working well across people, teams, and functions, while deepening the craft"}]'::jsonb, '["d"]'::jsonb, 'The Growth Ladder''s G2 stage is Collaborate: cross-functional effectiveness plus deeper proficiency.', 2, true),
  ('q_fnd201_03', 'lm_fnd201', 'Why does WS7 call G2 ''the launch pad for the biggest transition''?', 'SINGLE', '[{"key": "a", "text": "Because G2 is when salary bands widen most"}, {"key": "b", "text": "Because the doer-to-developer move at G3 is built largely out of cross-functional capability grown at G2"}, {"key": "c", "text": "Because G2 employees may transfer between job families freely"}, {"key": "d", "text": "Because probation ends at G2"}]'::jsonb, '["b"]'::jsonb, 'The G3 shift — leading a team or owning a domain — rests on the collaborative muscles and evidence developed at G2.', 3, true),
  ('q_fnd201_04', 'lm_fnd201', 'How is Transworld''s workforce structured?', 'SINGLE', '[{"key": "a", "text": "Five job families with two career tracks \u2014 Manager and Expert \u2014 diverging from G3"}, {"key": "b", "text": "Three divisions, each with its own grade scale"}, {"key": "c", "text": "A single pool with no formal families"}, {"key": "d", "text": "Front office and back office only"}]'::jsonb, '["a"]'::jsonb, 'Five families (Leadership; Investments; Control & Operations; Business Development; Administration & Corporate Services), two tracks, common foundation through G0–G2.', 4, true),
  ('q_fnd201_05', 'lm_fnd201', 'What is the purpose of control-function independence?', 'SINGLE', '[{"key": "a", "text": "To reduce the firm''s headcount costs"}, {"key": "b", "text": "To let control staff skip the performance cycle"}, {"key": "c", "text": "To keep the firm''s numbers and conduct credible \u2014 checkers answer through reporting lines separate from the desks they check"}, {"key": "d", "text": "To give compliance authority over bonuses"}]'::jsonb, '["c"]'::jsonb, 'Compliance, risk, internal control, and the finance line report separately from revenue desks; that separation is what makes the checking credible.', 5, true),
  ('q_fnd201_06', 'lm_fnd201', 'Which functions does the control-function independence rule cover?', 'SINGLE', '[{"key": "a", "text": "Dealing and execution"}, {"key": "b", "text": "Business development and marketing"}, {"key": "c", "text": "Client services and reception"}, {"key": "d", "text": "Compliance, risk, internal control, and the finance/accounting line"}]'::jsonb, '["d"]'::jsonb, 'WS2 applies the independence rule to the checking functions — not to dealing/execution or operations.', 6, true),
  ('q_fnd201_07', 'lm_fnd201', 'In the trade-lifecycle relay, which desk''s work makes a prospect someone the firm may lawfully serve?', 'SINGLE', '[{"key": "a", "text": "Onboarding and KYC \u2014 identity verified, documentation complete, risk assessed"}, {"key": "b", "text": "The dealing desk, by executing the first mandate"}, {"key": "c", "text": "Finance, by receiving the first funding"}, {"key": "d", "text": "Business development, by signing the prospect"}]'::jsonb, '["a"]'::jsonb, 'BD brings the prospect in; KYC and onboarding make them a client the firm can lawfully act for — the gate the rest of the relay depends on.', 7, true),
  ('q_fnd201_08', 'lm_fnd201', 'Why is a dropped handoff more serious at a regulated dealing member than ordinary slowness?', 'SINGLE', '[{"key": "a", "text": "It always triggers an automatic fine"}, {"key": "b", "text": "It can become a breach, a client complaint, or a query from the Exchange \u2014 not just a delay"}, {"key": "c", "text": "It voids the firm''s insurance"}, {"key": "d", "text": "It must be reported to the Board within 24 hours"}]'::jsonb, '["b"]'::jsonb, 'In a regulated market the relay''s failures have regulatory and client consequences beyond lost time.', 8, true),
  ('q_fnd201_09', 'lm_fnd201', 'What is the first practical step of working across functions?', 'SINGLE', '[{"key": "a", "text": "Scheduling standing meetings with every desk"}, {"key": "b", "text": "Requesting read access to all firm systems"}, {"key": "c", "text": "Knowing your handoffs cold \u2014 who consumes your output, in what form, by when, and whose output you consume"}, {"key": "d", "text": "Rotating through each job family for a week"}]'::jsonb, '["c"]'::jsonb, 'Cross-functional work starts at your own arrows in the relay: inputs and outputs, owners and deadlines.', 9, true),
  ('q_fnd201_10', 'lm_fnd201', 'Per the retreat''s framing, how is trust built at the firm?', 'SINGLE', '[{"key": "a", "text": "Through seniority and tenure"}, {"key": "b", "text": "Through one visible high-stakes success"}, {"key": "c", "text": "Through social rapport across desks"}, {"key": "d", "text": "In patterns \u2014 repeated, reliable behaviors \u2014 not in single moments"}]'::jsonb, '["d"]'::jsonb, 'Trust accumulates through repeated follow-through; a pattern of missed small commitments eventually excludes a person from meaningful responsibility.', 10, true),
  ('q_fnd201_11', 'lm_fnd201', 'What happens to a colleague who consistently fails to follow through on small commitments?', 'SINGLE', '[{"key": "a", "text": "They create a pattern of distrust that eventually excludes them from meaningful responsibility"}, {"key": "b", "text": "Nothing, provided the large commitments are kept"}, {"key": "c", "text": "They are moved to the Expert track"}, {"key": "d", "text": "They receive additional supervision budget"}]'::jsonb, '["a"]'::jsonb, 'The retreat was explicit: small-commitment reliability is the unit from which trust — and exclusion — is built.', 11, true),
  ('q_fnd201_12', 'lm_fnd201', 'What does it mean to become ''an extension of the system''?', 'SINGLE', '[{"key": "a", "text": "Being granted administrator rights in the portal"}, {"key": "b", "text": "Colleagues can build their plans on your word \u2014 your documented, reliable behavior makes you infrastructure"}, {"key": "c", "text": "Working across two job families simultaneously"}, {"key": "d", "text": "Having your role written into the Operational Manual"}]'::jsonb, '["b"]'::jsonb, 'The retreat''s phrase for the G2 destination: documentation, proactive communication, and follow-through make a person indispensable to the system.', 12, true),
  ('q_fnd201_13', 'lm_fnd201', 'Why is documentation a cross-functional behavior and not just personal hygiene?', 'SINGLE', '[{"key": "a", "text": "Because the file note you write today lets a colleague on another desk act tomorrow without finding you first"}, {"key": "b", "text": "Because undocumented work is unpaid"}, {"key": "c", "text": "Because the portal locks accounts with missing notes"}, {"key": "d", "text": "Because clients can subpoena personal notebooks"}]'::jsonb, '["a"]'::jsonb, 'Documentation makes work legible across desks and absences — the relay keeps moving without a phone call.', 13, true),
  ('q_fnd201_14', 'lm_fnd201', 'What makes a request to another desk ''asked well''?', 'SINGLE', '[{"key": "a", "text": "Marking it urgent and copying the COO"}, {"key": "b", "text": "Keeping it short \u2014 one line at most"}, {"key": "c", "text": "It is complete: what you need, why, by when, and what you have already checked"}, {"key": "d", "text": "Delivering it in person rather than in writing"}]'::jsonb, '["c"]'::jsonb, 'A complete request costs the other person only the work itself; a vague one costs a clarifying round-trip first.', 14, true),
  ('q_fnd201_15', 'lm_fnd201', 'What must a written handoff contain?', 'SINGLE', '[{"key": "a", "text": "Only the deadline \u2014 the rest is in the system"}, {"key": "b", "text": "What is being passed, its current state, what remains, and any deadline \u2014 so the recipient can act without calling you"}, {"key": "c", "text": "A full history of the work since inception"}, {"key": "d", "text": "Sign-off from both desks'' leads"}]'::jsonb, '["b"]'::jsonb, 'The test of a handoff: the recipient can act on it alone, and the work stays legible even if both parties go on leave.', 15, true),
  ('q_fnd201_16', 'lm_fnd201', 'You can see that a dependency will make your handoff late. When do you tell the desk waiting on you?', 'SINGLE', '[{"key": "a", "text": "At the deadline, with apologies"}, {"key": "b", "text": "Only if they ask for a status update"}, {"key": "c", "text": "After your lead approves the message"}, {"key": "d", "text": "The moment you can see it \u2014 with a revised time and what you are doing about it"}]'::jsonb, '["d"]'::jsonb, 'Early bad news is professional courtesy; late bad news is a pattern of distrust forming.', 16, true),
  ('q_fnd201_17', 'lm_fnd201', 'What is the fastest path through a query from compliance or internal control?', 'SINGLE', '[{"key": "a", "text": "A confident verbal assurance from the record owner"}, {"key": "b", "text": "Escalating the query to your lead to answer"}, {"key": "c", "text": "The evidence itself \u2014 documents, not assurances, since their job is precisely not to take your word for it"}, {"key": "d", "text": "Requesting the query in writing and responding within five days"}]'::jsonb, '["c"]'::jsonb, 'Control colleagues check records. Giving them the record directly is both the fastest route and the trust-building one.', 17, true),
  ('q_fnd201_18', 'lm_fnd201', 'A control finding lands on a record you own. What response builds the right pattern?', 'SINGLE', '[{"key": "a", "text": "Fix it visibly and quickly, without defensiveness"}, {"key": "b", "text": "Contest the finding first to protect your year-end rating"}, {"key": "c", "text": "Wait for your manager to assign the fix formally"}, {"key": "d", "text": "Fix it quietly and avoid mentioning it again"}]'::jsonb, '["a"]'::jsonb, 'Speed and non-defensiveness with control functions builds reliability with the colleagues whose opinion travels furthest.', 18, true),
  ('q_fnd201_19', 'lm_fnd201', 'Per the Manager PD Guide''s distinction, what does G3-readiness look like from a G2 seat?', 'SINGLE', '[{"key": "a", "text": "Performing the Collaborate stage whenever circumstances are clear"}, {"key": "b", "text": "Completing all Proficient-level LMS modules"}, {"key": "c", "text": "Requesting a grade review after twelve months"}, {"key": "d", "text": "Embodying the Collaborate stage consistently \u2014 including when things are ambiguous and pressured"}]'::jsonb, '["d"]'::jsonb, 'Performing the stage sometimes is good G2 work; embodying it consistently under pressure is the readiness evidence.', 19, true),
  ('q_fnd201_20', 'lm_fnd201', 'In the worked example, what made Chiamaka''s handling of the stalled onboarding a Collaborate-stage record?', 'SINGLE', '[{"key": "a", "text": "She escalated the entire matter to the COO on day one"}, {"key": "b", "text": "She completed the client''s missing document herself"}, {"key": "c", "text": "Every step was small, written, early, and complete \u2014 three desks experienced work that travels well"}, {"key": "d", "text": "She processed her own checklist and waited for the client"}]'::jsonb, '["c"]'::jsonb, 'Mapping the relay, precise written contacts, early notice to the blocked desk, and a complete handoff note — none heroic, all systemic.', 20, true)
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
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_fnd201' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_fnd201';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'FND-201: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'FND-201: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
