-- seed_ldr201_content.sql — P9 v0.69.0
-- Publishes LDR-201 (lm_ldr201): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_ldr201' AND code = 'LDR-201') THEN
    RAISE EXCEPTION 'LDR-201 shell (lm_ldr201) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'The hardest move on the Growth Ladder: from growing by doing to growing by getting people to get things done. What changes at G3, the Expert-track variant, your first 90 days leading, and the failure modes that catch new leads.',
  body = $tw_p9_ldr201$## The transition nobody trains you for

You earned your way here by being good at the work. Your trades settled clean, your files were complete, your numbers reconciled, your clients were looked after. Then the firm asked you to lead — and the skills that got you here quietly stopped being the skills the job rewards.

At the firm's 2026 retreat, the leadership told the story of a capable, well-liked operations lead — call him Felix; he is a hypothetical composite, not a real colleague. Felix had what the facilitators called a caring temperament. When a client problem surfaced, his instinct was to personally solve it. When a junior colleague struggled with a reconciliation, Felix quietly did it himself after hours. Every problem on his desk got fixed — by Felix. And his team never grew, because the problems never reached them long enough to teach them anything. The coaching he received at that retreat was direct: leadership is not about getting things done yourself. It is about getting people to get things done. The biggest transition Felix needed to make was from doer to developer.

That sentence is the whole module. As the retreat put it: a leader is not the person who knows how to get things done, but the person who knows how to get people to get things done. Everything below is the practical working-out of that line for a newly promoted lead at a Lagos dealing member of roughly fifteen people, where there is no slack layer of middle management to hide in. If you lead here, you lead in plain sight.

## The deliberate path: the Growth Ladder behind the shift

Transworld did not invent this transition under pressure; it adopted it on purpose. The Chairman has described the progression program he experienced earlier in his career at a major multinational — a mapped, patient expectation that an employee moves from learner in the first eighteen months, to individual contributor by year two, to team collaborator by year four, to team leader by year six, and onward toward executive leadership. The lesson he drew was not about hierarchy. It was about intentional growth and the patience required to cultivate it.

The firm's version is the Growth Ladder (PADP), and Workstream 7 places your transition precisely on it. At G1 you Learn and Deliver. At G2 you Collaborate — you can do the core work independently, and your development turns to working across desks and functions. Then comes G3, which WS7 names without apology as the doer-to-developer shift: the hardest and most important move on the path. Up to G2, a person grows by doing. From G3, they grow by getting people to do.

Notice what this means for how the firm reads you. Your G2 record — speed, accuracy, personal output — proved you understand the craft. Your G3 record will be read differently: did the people around you get better, did the work of the unit improve, did standards hold when you were not in the room? You are no longer the engine. You are the mechanic for everyone else's engines, while your own keeps running.

## What actually changes at G3

Three things change at once, and new leads usually notice only the first.

**Your output is now your team's outcomes.** When you were a G2 analyst, a strong week was measurable in your own deliverables. As a lead, a week in which you personally produced brilliant work while your team drifted is a bad week. The unit's settlement discipline, the unit's documentation completeness, the unit's client responsiveness — these are now your numbers. You will be assessed on them at year-end, and your team's calibrated ratings will say more about your leadership than your own task list does.

**Your time allocation inverts.** A G2 spends most hours producing and a few coordinating. A G3 lead spends a growing share of hours on one-to-ones, reviewing weekly progress reports, unblocking work, giving feedback, and planning — and a shrinking share producing directly. This feels wrong at first. It feels like you are doing less. You are not; you are doing different work whose results show up in other people's columns.

**Your words acquire weight.** A casual remark from a peer is a remark; the same remark from a lead is an instruction, a signal, or a worry, depending on the listener. New leads consistently underestimate this. Precision in what you ask for, and in what you praise, becomes part of the job.

## The Expert track: leading through mastery

Not everyone at G3 manages people, and Transworld's architecture is explicit about this. The firm runs two tracks that both reach senior pay: the Manager track grows by leading people; the Expert track grows by mastery — becoming so good at the craft that the firm pays you like a leader without asking you to manage anyone. Through G0–G2 everyone shares a common foundation; from G3 the tracks diverge, and either path can reach G4 and G5.

On the Expert track, WS7 reads G3 as leadership through mastery: owning a domain and setting the standard others follow, rather than line management. An Expert-track G3 still makes the doer-to-developer shift — but the "developing" runs through the standard you set, the methods you document, the colleagues who learn by working beside you, and the way the firm's practice in your domain improves because you own it. If juniors quietly route their hard questions to you, you are already leading. The module applies to you too; only the instrument differs.

## Your first 90 days leading

The temptation in week one is to change things — to show energy, to fix what annoyed you as a team member. Resist it. Your first 90 days are for reading the team you have inherited, inside the systems the firm already runs.

Start with the portal. Read every team member's sealed goals for the current cycle before you change anything: those goals were agreed in February and will govern their year-end assessments, so they are the contract you have inherited. Read each person's recent weekly progress reports — several weeks back, not just the latest. The reports tell you who writes with evidence and who writes in vague reassurances, who raises concerns and who goes silent, long before any meeting does.

Then meet every person, one to one, with no agenda beyond understanding: what they own, where they are blocked, what they want to grow into. You are assessing, quietly, where each person genuinely sits on the Growth Ladder — not where their grade says they should sit. Do not promise anything in these meetings, least of all grade reviews.

There is one more first-90-days reality at a firm of fifteen: you are almost certainly now leading former peers — people who shared lunch and grievances with you last quarter. Do not pretend nothing changed; the team finds that evasive. Name it once, plainly, in the one-to-ones: the friendship stands, the role changed, and you will sometimes make calls a friend would not make. Then prove it through evenness — the fastest way to lose a team of former peers is visible favoritism toward the colleagues you were closest to, and the second fastest is overcorrecting into harshness against them to prove your independence. Even-handedness, applied boringly and consistently, settles the question within a quarter. Special handling in either direction keeps it open all year.

Only after that do you earn the right to adjust. If a goal has been overtaken by events, there is a formal mid-cycle amendment process — use it; do not let goals rot silently. And keep your own two engines running: your performance goals and your development plan do not pause because you got promoted.

## The failure modes

Three patterns account for most failed transitions, and all three feel virtuous from the inside.

**Hero mode.** The Felix pattern: every hard problem comes to you, you solve it, everyone is grateful, nobody grows. The test is brutal and simple — what happens when you take leave? If the answer is that the desk wobbles, you have built dependence, not a team.

**The double job.** You keep your full G2 workload and add management on top. For a month it looks heroic. Then your one-to-ones get cancelled, your feedback turns late and vague, weekly reports go unread, and by November you are facing year-end assessments with no evidence trail. Producing is comfortable; leading is the job. Shed enough of the doing to do the leading properly.

**Abdication dressed as delegation.** The opposite failure: handing work over with no outcome defined, no boundaries, no check-ins — then expressing disappointment when it comes back wrong. Delegation is a structured contract (LDR-202 covers it in depth). Dumping is not delegating, and "I empowered them" is not a defense when the client letter goes out wrong.

### Worked example (hypothetical)

Adaeze is promoted to lead a three-person operations desk at a Lagos dealing member in March. Her first month, she does what made her excellent at G2: she personally re-checks every settlement instruction, redrafts her juniors' client emails before they go out, and stays late clearing the backlog herself. The desk's output looks fine. Then she takes one week of leave in May, and the desk misses a contract-note deadline and sends a client an unchecked email with a wrong account number.

The miss forces the reset. Adaeze rereads her team's sealed goals and their weekly reports and realizes one junior, Chidi, has been flagging for weeks that he has never been walked through the exceptions process — she had simply been absorbing the exceptions herself. She sets a delegation contract with Chidi for the exceptions log: the outcome defined, the boundaries written down, a fifteen-minute review every Wednesday. She stops rewriting emails and starts annotating them instead, returning drafts with specific feedback. Her own production drops by a third; her one-to-ones happen every week without fail.

By the July mid-year review, Chidi runs the exceptions log alone with a clean record, and Adaeze's own report to her manager is no longer a list of tasks she completed — it is an account of what her desk can now do that it could not do in March. That sentence is the G3 sentence.

## Common traps

The promise trap: telling a strong G2 they are "basically G3 already." You have just created an expectation the grade-review process may not honor, and removed their incentive to build the remaining evidence. The popularity trap: optimizing your first months for being liked, deferring every hard conversation — the cost compounds, and LDR-203's evidence standard will expose it at year-end. The mirror trap: developing only the people who work the way you do, and misreading different styles as weaker ones. And the visibility trap: assuming your manager can see your leadership work — if your coaching, delegation contracts, and feedback are not reflected in the portal record, at year-end they did not happen.

## Key takeaways

The move to G3 is the hardest on the Growth Ladder because it asks you to stop growing by doing and start growing by getting people to get things done. Your output becomes your team's outcomes; your evidence becomes their growth. The Expert track makes the same shift through mastery and standard-setting rather than line management. Spend your first 90 days reading — sealed goals, weekly reports, one-to-ones — before changing anything. And watch for the three failure modes that feel like virtue: hero mode, the double job, and abdication dressed as delegation. The firm is deliberately patient about this transition. Be patient with yourself, but be honest about whether the people around you are growing — because that, now, is the work.

---

*Sources: Transworld Company Retreat Report 2026 (A New Culture of Leadership — From Doer to Developer); HR WS7 Learning & Development Pack, Part 2 — The Grade-Based Growth Path; HR WS5 Performance & Discipline Pack, Part 1; HR WS2 Workforce Architecture (career tracks). Worked examples are hypothetical.*$tw_p9_ldr201$,
  estimated_minutes = 18,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_ldr201';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_ldr201_01', 'lm_ldr201', 'According to the firm''s Growth Ladder, what fundamentally changes about how a person grows when they move from G2 to G3?', 'SINGLE', '[{"key": "a", "text": "They stop growing by doing and start growing by getting people to get things done"}, {"key": "b", "text": "They move from salaried work to performance-based pay"}, {"key": "c", "text": "They stop needing a development plan of their own"}, {"key": "d", "text": "They begin reporting directly to the Board"}]'::jsonb, '["a"]'::jsonb, 'WS7 Part 2 names G3 the doer-to-developer shift: up to G2 a person grows by doing; from G3 they grow by getting people to do.', 1, true),
  ('q_ldr201_02', 'lm_ldr201', 'The retreat''s definition of a leader is best captured by which statement?', 'SINGLE', '[{"key": "a", "text": "The person with the deepest technical knowledge on the desk"}, {"key": "b", "text": "The person who knows how to get people to get things done"}, {"key": "c", "text": "The person who has served longest at the firm"}, {"key": "d", "text": "The person who personally handles the hardest client problems"}]'::jsonb, '["b"]'::jsonb, 'The retreat''s formulation: a leader is not the person who knows how to get things done, but the person who knows how to get people to get things done.', 2, true),
  ('q_ldr201_03', 'lm_ldr201', 'In the hypothetical Felix story, what was the core problem with his ''caring temperament''?', 'SINGLE', '[{"key": "a", "text": "He delegated too aggressively and overloaded juniors"}, {"key": "b", "text": "He refused to work beyond his contracted hours"}, {"key": "c", "text": "By personally solving every problem, he prevented his team from growing"}, {"key": "d", "text": "He escalated routine issues to management too quickly"}]'::jsonb, '["c"]'::jsonb, 'Felix''s instinct to fix everything himself meant problems never stayed with his team long enough to teach them anything — dependence, not development.', 3, true),
  ('q_ldr201_04', 'lm_ldr201', 'How should a new G3 lead''s performance primarily be read at year-end?', 'SINGLE', '[{"key": "a", "text": "By the volume of work they personally produced"}, {"key": "b", "text": "By how rarely their team needed one-to-ones"}, {"key": "c", "text": "By the number of hours they worked beyond their team"}, {"key": "d", "text": "By their team''s outcomes \u2014 whether the unit''s work and people improved"}]'::jsonb, '["d"]'::jsonb, 'At G3 your output is your team''s outcomes; the unit''s discipline, completeness, and growth are your numbers.', 4, true),
  ('q_ldr201_05', 'lm_ldr201', 'On the Expert track, what does G3 leadership look like at Transworld?', 'SINGLE', '[{"key": "a", "text": "Owning a domain and setting the standard others follow, without line management"}, {"key": "b", "text": "Managing a small team of two as a trial before real management"}, {"key": "c", "text": "Rotating through every desk in the firm"}, {"key": "d", "text": "Moving into a compliance role automatically"}]'::jsonb, '["a"]'::jsonb, 'WS7 reads Expert-track G3 as leadership through mastery — owning a domain and setting the standard — rather than managing people.', 5, true),
  ('q_ldr201_06', 'lm_ldr201', 'What do the firm''s two career tracks have in common?', 'SINGLE', '[{"key": "a", "text": "Both require managing people from G3 upward"}, {"key": "b", "text": "Both can reach G4 and G5, and grade \u2014 not track \u2014 sets the pay band"}, {"key": "c", "text": "Both end at G3 unless the Board approves an exception"}, {"key": "d", "text": "Both require professional qualification sponsorship"}]'::jsonb, '["b"]'::jsonb, 'WS2: the Manager and Expert tracks diverge at G3, either can reach G4/G5, and grade sets the pay band — which is what lets expertise pay as well as management.', 6, true),
  ('q_ldr201_07', 'lm_ldr201', 'The progression story the Chairman shared from his earlier career was used at the retreat to make which point?', 'SINGLE', '[{"key": "a", "text": "Large firms promote faster than small ones"}, {"key": "b", "text": "Technical training matters more than leadership training"}, {"key": "c", "text": "Growth should be intentional and patiently cultivated along a mapped progression"}, {"key": "d", "text": "Every employee should reach executive level within six years"}]'::jsonb, '["c"]'::jsonb, 'The lesson was not hierarchy but intentional growth — a deliberate, patient map from learner to leader, which the firm''s Growth Ladder (PADP) mirrors.', 7, true),
  ('q_ldr201_08', 'lm_ldr201', 'What is the FIRST thing a newly appointed lead should do with the portal in their first 90 days?', 'SINGLE', '[{"key": "a", "text": "Re-open goal-setting and replace the team''s goals with their own priorities"}, {"key": "b", "text": "Read every team member''s sealed goals and recent weekly progress reports before changing anything"}, {"key": "c", "text": "Archive the previous manager''s records to start clean"}, {"key": "d", "text": "Submit grade-review requests for their strongest performers"}]'::jsonb, '["b"]'::jsonb, 'The sealed goals are the inherited contract governing year-end assessment, and weeks of progress reports reveal the team faster than any meeting.', 8, true),
  ('q_ldr201_09', 'lm_ldr201', 'A new lead discovers a team member''s sealed goal has been overtaken by events. What is the right response?', 'SINGLE', '[{"key": "a", "text": "Quietly ignore the goal at year-end"}, {"key": "b", "text": "Delete the goal from the portal"}, {"key": "c", "text": "Tell the employee to keep working on it regardless"}, {"key": "d", "text": "File a formal mid-cycle amendment so the change is documented"}]'::jsonb, '["d"]'::jsonb, 'Goals are not silently rewritten or ignored; a formal mid-cycle amendment documents the change so year-end assessment stays fair.', 9, true),
  ('q_ldr201_10', 'lm_ldr201', 'Why does ''hero mode'' fail as a leadership style?', 'SINGLE', '[{"key": "a", "text": "It builds team dependence on the lead, which is exposed the moment the lead is away"}, {"key": "b", "text": "It costs too much in overtime payments"}, {"key": "c", "text": "It violates the firm''s delegation policy outright"}, {"key": "d", "text": "It produces work that is technically below standard"}]'::jsonb, '["a"]'::jsonb, 'Solving everything yourself keeps output looking fine while the team never grows — the test is what happens when you take leave.', 10, true),
  ('q_ldr201_11', 'lm_ldr201', 'What is the ''double job'' failure mode?', 'SINGLE', '[{"key": "a", "text": "Holding a second employment outside the firm"}, {"key": "b", "text": "Managing two teams at the same time"}, {"key": "c", "text": "Keeping a full individual workload while adding management on top, until the leading work collapses"}, {"key": "d", "text": "Splitting time between the Manager and Expert tracks"}]'::jsonb, '["c"]'::jsonb, 'Producing is comfortable, so new leads keep doing it — and one-to-ones, feedback, and report reviews quietly die, leaving no evidence trail by year-end.', 11, true),
  ('q_ldr201_12', 'lm_ldr201', 'What distinguishes genuine delegation from abdication?', 'SINGLE', '[{"key": "a", "text": "Delegation only goes to employees at G2 and above"}, {"key": "b", "text": "Delegation has a defined outcome, boundaries, and check-ins; abdication hands work over with none of these"}, {"key": "c", "text": "Abdication is always in writing while delegation is verbal"}, {"key": "d", "text": "Delegation requires People Ops approval"}]'::jsonb, '["b"]'::jsonb, 'Delegation is a structured contract. Handing work over with no outcome, boundaries, or check-ins is dumping — and ''I empowered them'' is not a defense.', 12, true),
  ('q_ldr201_13', 'lm_ldr201', 'Why is telling a strong G2 they are ''basically G3 already'' a trap?', 'SINGLE', '[{"key": "a", "text": "It breaches the confidentiality of calibration"}, {"key": "b", "text": "Grade discussions may only happen in December"}, {"key": "c", "text": "It obliges the firm to backdate their pay"}, {"key": "d", "text": "It creates an expectation the grade-review process may not honor and removes their incentive to build remaining evidence"}]'::jsonb, '["d"]'::jsonb, 'Premature promises generate disappointment and often cause the person to stop working on the very behaviors that would get them there.', 13, true),
  ('q_ldr201_14', 'lm_ldr201', 'In the worked example, what signal finally exposed Adaeze''s hero-mode pattern?', 'SINGLE', '[{"key": "a", "text": "A client formally complained about her tone"}, {"key": "b", "text": "Her desk missed a deadline and sent an unchecked client email while she was on leave"}, {"key": "c", "text": "People Ops flagged her overtime records"}, {"key": "d", "text": "Her own year-end rating fell below expectations"}]'::jsonb, '["b"]'::jsonb, 'The desk wobbled the moment she was away — the classic test that distinguishes a developed team from a dependent one.', 14, true),
  ('q_ldr201_15', 'lm_ldr201', 'After her reset, how did Adaeze handle her juniors'' client email drafts?', 'SINGLE', '[{"key": "a", "text": "She annotated drafts with specific feedback instead of rewriting them herself"}, {"key": "b", "text": "She continued rewriting them but logged each rewrite"}, {"key": "c", "text": "She routed all drafts to the compliance officer"}, {"key": "d", "text": "She stopped reviewing drafts entirely to force independence"}]'::jsonb, '["a"]'::jsonb, 'Annotating with specific feedback develops the writer; silently rewriting develops nobody. Note she did not swing to the opposite failure of no review at all.', 15, true),
  ('q_ldr201_16', 'lm_ldr201', 'What changed about Adaeze''s mid-year report to her own manager after the reset?', 'SINGLE', '[{"key": "a", "text": "It became a longer list of tasks she had personally completed"}, {"key": "b", "text": "It focused on budget savings from reduced overtime"}, {"key": "c", "text": "It became an account of what her desk could now do that it could not do before"}, {"key": "d", "text": "It was delegated to her most senior junior to write"}]'::jsonb, '["c"]'::jsonb, 'That is the G3 sentence: the lead''s evidence is the team''s new capability, not the lead''s personal output.', 16, true),
  ('q_ldr201_17', 'lm_ldr201', 'Why do a new lead''s casual remarks need more care than a peer''s?', 'SINGLE', '[{"key": "a", "text": "All of a lead''s remarks are recorded in the portal automatically"}, {"key": "b", "text": "Remarks from leads are reviewed at calibration"}, {"key": "c", "text": "Leads are subject to a stricter social media policy"}, {"key": "d", "text": "A lead''s words carry weight \u2014 listeners hear instructions, signals, or worries where a peer''s remark is just a remark"}]'::jsonb, '["d"]'::jsonb, 'Position changes how words land. Precision in what you ask for and what you praise becomes part of the job.', 17, true),
  ('q_ldr201_18', 'lm_ldr201', 'What does the ''mirror trap'' describe?', 'SINGLE', '[{"key": "a", "text": "Copying another manager''s style without adapting it"}, {"key": "b", "text": "Reviewing your own performance more generously than your team''s"}, {"key": "c", "text": "Promoting people who most resemble previous leaders"}, {"key": "d", "text": "Developing only people who work the way you do, and misreading different styles as weaker ones"}]'::jsonb, '["d"]'::jsonb, 'Leads naturally rate working styles like their own more highly; the trap is mistaking difference for weakness and developing only your reflections.', 18, true),
  ('q_ldr201_19', 'lm_ldr201', 'Why must a lead''s coaching and delegation work be reflected in the portal record?', 'SINGLE', '[{"key": "a", "text": "Because work that is not documented effectively did not happen when year-end evidence is weighed"}, {"key": "b", "text": "Because the portal automatically schedules one-to-ones"}, {"key": "c", "text": "Because undocumented coaching is a disciplinary offense"}, {"key": "d", "text": "Because clients can request copies of leadership records"}]'::jsonb, '["a"]'::jsonb, 'The firm''s documentation discipline applies to leadership work too: at year-end, the evidence trail in the portal is what exists.', 19, true),
  ('q_ldr201_20', 'lm_ldr201', 'What happens to a new lead''s own two engines — performance and development — on promotion?', 'SINGLE', '[{"key": "a", "text": "They are suspended for the first year of leadership"}, {"key": "b", "text": "They merge into the team''s collective goals"}, {"key": "c", "text": "They keep running: the lead''s own goals and development plan continue alongside responsibility for the team''s"}, {"key": "d", "text": "They transfer to the lead''s own manager to maintain"}]'::jsonb, '["c"]'::jsonb, 'Promotion adds the mechanic''s duty for everyone else''s engines; it does not switch off your own.', 20, true)
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
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_ldr201' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_ldr201';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'LDR-201: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'LDR-201: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
