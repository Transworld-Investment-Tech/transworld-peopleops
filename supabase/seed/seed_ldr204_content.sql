-- seed_ldr204_content.sql — P9 v0.69.0
-- Publishes LDR-204 (lm_ldr204): body + 20-question check at pass mark 80.
-- Idempotent. Run AFTER seed_lms_curriculum.sql. Fail-loud: any check failure aborts the transaction.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM learning_modules WHERE id = 'lm_ldr204' AND code = 'LDR-204') THEN
    RAISE EXCEPTION 'LDR-204 shell (lm_ldr204) not found - run seed_lms_curriculum.sql first';
  END IF;
END $$;

UPDATE learning_modules SET
  summary = 'The firm''s enabling philosophy: when you put people in positions, give them resources, space, and time. The measurement layer that keeps enabling honest — and the boundary where enabling ends and capability management begins.',
  body = $tw_p9_ldr204$## The three things you owe your team

At the firm's 2026 retreat, the leadership distilled its philosophy of enabling a team into a formulation that has since become house language. Drawing on a creation allusion that moved the room, the point was made that three things were created together at the beginning: time, space, and resources — and that as leaders, when we put people in positions, we must give them all three. Resources meant tools, policies, and guidelines. Space meant room to operate, try, and even fail. Time meant patience — accepting that mistakes are inevitable on the path to mastery.

It is a deceptively simple test, and most leadership failures at a small firm fail it on at least one element. The lead who assigns an outcome without access rights has withheld resources. The lead who delegates and then hovers, approving every keystroke, has withheld space. The lead who expects month-two mastery of a craft that takes a year has withheld time. This module works through each element, then adds the two pieces that keep enabling honest: the measurement layer, and the boundary where enabling ends.

The frame behind all of it is the retreat's larger commitment: the old Transworld was personality-driven — one or two individuals made every decision, gave every instruction, carried every burden. The new Transworld is to be system-driven — empowering individuals, distributing responsibility, and investing in human capital. Enabling a team is what system-driven looks like one desk at a time.

## Resources: tools, policies, and guidelines

Resources are the most concrete element and the most commonly half-delivered. When you put someone in a position — a new role, a delegated outcome, a stretch assignment — walk their workspace before you walk away:

**Tools.** The system access, the portal permissions, the templates, the working files. A settlements officer who must request a colleague's login to view the register has not been resourced; she has been set up. At this firm the portal is the team's operating system — goals, weekly reports, learning, records — and a team member without the right access to it is excluded from the system the firm runs on.

**Policies.** The written rules of the work: the Operational Manual sections that govern the process, the compliance requirements that bound it, the checklists that encode it. Policy clarity is a resource. A person operating on desk folklore — "this is how we've always done it" — is operating without resources, however experienced the folklore's source. Point people to the document, not the memory of the document.

**Guidelines.** The judgment layer between policy and situation: worked examples, escalation thresholds, the house style for client letters, the precedent file. Guidelines are how a lead transfers judgment without transferring every decision.

The test of resourcing is the under-resourced goal: if a team member misses an outcome because the tools, access, or policy clarity were never provided, that is a manager failure wearing an employee's name. Find it before the year-end assessment does.

## Space: room to operate, try, and fail

Space is delegated authority made real. It is the difference between supervision and surveillance: supervision sets the outcome, the boundaries, and the check-in rhythm, then lets the person work; surveillance re-inspects every intermediate step, which converts delegation into dictation with extra steps.

Giving space means accepting that inside the boundaries, their way may differ from your way — slower at first, differently sequenced, occasionally better. It also means budgeting for failure. The retreat's language was deliberate: room to operate, try, and even fail. A team that has never been allowed a recoverable mistake has never been allowed to learn; it has only been allowed to execute. The craft of the lead is sizing the failure budget: a junior's first client report can fail safely in draft; a settlement instruction cannot fail at all. Give wide space where failure is recoverable and tight boundaries where it is not — and tell the person which zone they are standing in.

Space has a documentation corollary at this firm. Authority that exists only in conversation evaporates under pressure — the first time something goes wrong, an undocumented "you can decide that" becomes "I never said that." Put delegated authority in writing, in the portal note or the delegation contract, so the space you granted survives scrutiny.

## Time: patience on the path to mastery

Time is the element leaders find hardest, because the firm's pace argues against it daily. The retreat's point stands anyway: mistakes are inevitable on the path to mastery, and patience is not indulgence — it is the realistic price of capability.

The Growth Ladder is built on that patience. The progression the Chairman described from his own early career mapped roughly eighteen months as a learner before independent contribution was even expected, with years between rungs after that. The firm watches how fast someone learns more than it demands instant output at G1, and it treats the doer-to-developer transition at G3 as a move measured in seasons, not sprints. Your calibration of time should match: a person three weeks into an inherited process is not late to mastery; they are early on the curve.

Practically, giving time means three things. Set learning-curve expectations explicitly when you hand work over — "the first two cycles will be slow and we will review each one" — so that early struggle reads as planned, not alarming. Protect the time you promised: a stretch assignment with no hours behind it is a stretch in name only. And resist the rescue reflex during the curve; LDR-202's boomerang trap is mostly a failure of patience.

## The measurement layer: enabling without measuring is hoping

Resources, space, and time without measurement is abdication with good intentions. The retreat was blunt about the other half: what you don't measure, you cannot improve — if you want to improve something, you have to be measuring it. Enabling and measuring are not in tension; measurement is what makes generous space safe.

Two instruments carry the load at this firm. The first is the weekly reporting rhythm: the retreat introduced a weekly client-operations report in which the team documents the week's account-creation requests, onboarding completions, KYC gaps, transfers, and ticket resolution — each metric carrying a target direction, green for on-track and red for below. The design principle travels to any desk: a few simple entries, compiled into a weekly summary, with every number pointed at a target. The portal's weekly progress reports serve the same function at the individual level. A lead who reads these instruments weekly can give a team enormous space, because drift announces itself in days, not quarters.

The second is the checklist. Drawing parallels from healthcare and aviation — nurses run checklists for every patient encounter, pilots before every takeoff — the retreat committed the firm's critical, repetitive processes to actionable checklists: every mandate received triggering a multi-point verification of KYC, instruction, and price limits, among others. Over time checklists become muscle memory, eliminating the costly errors of omission that plagued past operations. For the lead, the checklist is an enabling device, not a bureaucratic one: it lets you hand a critical process to a developing team member precisely because the process, not the person's experience, carries the safety.

## The boundary: enabling is not indulgence

Every element above assumes the person responds to enablement. The retreat did not flinch from the case where they do not, introducing the concept of dead wood: team members who do not contribute, resist innovation, and dampen the effectiveness of those around them — like a single dead piece of firewood that can quench a fire which would otherwise spread from log to log. The consensus was clear and unsentimental: dead wood must be removed to protect the system, the dream, and the livelihoods of everyone who depends on the organization's success.

For the line lead, the operational translation is sequencing, not harshness. First, enable fully and document it: resources delivered, space defined, time allowed, measurement running. The measurement layer is what makes the next judgment honest — it distinguishes a person on a learning curve (numbers improving) from a person declining to climb (numbers flat, feedback resisted, support consumed without change). When the second pattern holds despite genuine enablement, the matter leaves the enabling toolkit and enters capability management: the structured underperformance process in WS5 Part 2, with its defined support, checkpoints, and documentation — and, where conduct rather than capability is the issue, the disciplinary track instead. The lead's protection in that process is the same documentation discipline as everywhere else: the record that you resourced, spaced, timed, and measured is what shows the firm — and any later review — that the failure was not yours to fix.

Carrying a non-responder indefinitely is not kindness. It taxes the colleagues who absorb the slack, teaches the team that standards are negotiable, and — the retreat's image — risks quenching the fire of the people around them.

### Worked example (hypothetical)

Halima, Head of Operations at a Lagos dealing member, inherits a struggling settlements officer, Kunle, whose error rate is the desk's worst. Her predecessor's diagnosis was character: "he's just careless." Halima runs the three-element audit instead.

Resources: Kunle has been working from an outdated checklist photocopied years ago, and lacks read access to the custodian's confirmation portal — he has been reconciling blind, asking colleagues to check screens for him. She fixes the access the same week and rebuilds the checklist against the current Operational Manual section. Space: her predecessor re-inspected every instruction Kunle prepared, so Kunle had stopped self-checking — inspection was someone else's job. Halima sets boundaries instead: routine instructions are his alone, flagged categories come to her, and a fifteen-minute Thursday review replaces the daily hover. Time: she tells him plainly that she expects two months of improving — not perfect — numbers, reviewed weekly against the desk's error metric, which now sits on the weekly summary with a target direction.

Eight weeks later the error rate has halved and keeps falling; the curve, once resourced and spaced, was a curve after all. The documentation of the arc — access fixed, checklist rebuilt, boundaries written, weekly numbers — also means that had the numbers stayed flat, the WS5 conversation that followed would have been clean: enablement proven, response absent. Either way, Halima's record is the system working.

## Common traps

The half-resource trap: granting the outcome but not the access, then reading the resulting failure as incompetence. The surveillance trap: calling it delegation while re-approving every step — you have kept the work and added a witness. The false-patience trap: giving time without measurement, so that a flat line and a learning curve look identical for a year. The hero-rescue trap: spending your patience budget on doing it yourself, which is impatience wearing a helpful face. And the indefinite-carry trap: confusing enablement with exemption, and protecting one non-responder at the cost of the team around them.

## Key takeaways

When you put someone in a position, give them all three: resources — tools, policies, guidelines; space — room to operate, try, and fail, with boundaries written down; and time — explicit learning-curve expectations and the patience to honor them. Pair generosity with measurement: weekly numbers with target directions, and checklists that let critical processes carry their own safety. Read the instruments weekly so drift announces itself early. And hold the boundary: when full, documented enablement meets no response, the matter moves to the firm's capability process — because protecting one unresponsive person at the expense of the team is not leadership, and the system you are building exists to outlast any single person, including you.

---

*Sources: Transworld Company Retreat Report 2026 (A New Culture of Leadership — Time, Space, and Resources; Dealing with Dead Wood; The Machinery of Excellence — checklists and weekly measurement); HR WS7 Learning & Development Pack, Part 2; HR WS5 Performance & Discipline Pack, Part 2 (capability boundary). Worked examples are hypothetical.*$tw_p9_ldr204$,
  estimated_minutes = 18,
  pass_mark = 80,
  status = 'PUBLISHED',
  updated_at = now()
WHERE id = 'lm_ldr204';

INSERT INTO learning_quiz_questions
  (id, module_id, prompt, type, options, correct, explanation, sort_order, active)
VALUES
  ('q_ldr204_01', 'lm_ldr204', 'Per the retreat''s formulation, what three things must a leader give anyone they put in a position?', 'SINGLE', '[{"key": "a", "text": "A title, a target, and a deadline"}, {"key": "b", "text": "Time, space, and resources"}, {"key": "c", "text": "Salary, training, and supervision"}, {"key": "d", "text": "Authority, autonomy, and anonymity"}]'::jsonb, '["b"]'::jsonb, 'The retreat''s formulation: when we put people in positions, we must give them all three — time, space, and resources.', 1, true),
  ('q_ldr204_02', 'lm_ldr204', 'How did the retreat define ''resources''?', 'SINGLE', '[{"key": "a", "text": "Headcount and budget only"}, {"key": "b", "text": "The bonus pool allocated to the desk"}, {"key": "c", "text": "Tools, policies, and guidelines"}, {"key": "d", "text": "Office equipment and furniture"}]'::jsonb, '["c"]'::jsonb, 'Resources meant tools, policies, and guidelines — the concrete and the written equipment of the position.', 2, true),
  ('q_ldr204_03', 'lm_ldr204', 'What does ''space'' mean in the firm''s enabling philosophy?', 'SINGLE', '[{"key": "a", "text": "A dedicated physical workstation for each role"}, {"key": "b", "text": "Freedom from any check-ins or reporting"}, {"key": "c", "text": "Time off between major assignments"}, {"key": "d", "text": "Room to operate, try, and even fail \u2014 delegated authority made real within boundaries"}]'::jsonb, '["d"]'::jsonb, 'Space is room to operate, try, and even fail — authority inside written boundaries, not the absence of structure.', 3, true),
  ('q_ldr204_04', 'lm_ldr204', 'What does ''time'' mean in this framework?', 'SINGLE', '[{"key": "a", "text": "Patience \u2014 accepting that mistakes are inevitable on the path to mastery"}, {"key": "b", "text": "Strict deadlines that force rapid learning"}, {"key": "c", "text": "Flexible working hours"}, {"key": "d", "text": "The probation period defined in the Handbook"}]'::jsonb, '["a"]'::jsonb, 'Time meant patience: mastery has a curve, and mistakes along it are expected, not anomalous.', 4, true),
  ('q_ldr204_05', 'lm_ldr204', 'A team member misses an outcome because they were never given access to the system the work requires. How should this be read?', 'SINGLE', '[{"key": "a", "text": "As an employee performance failure for the year-end record"}, {"key": "b", "text": "As grounds for a disciplinary investigation"}, {"key": "c", "text": "As a manager failure \u2014 an under-resourced goal wearing an employee''s name"}, {"key": "d", "text": "As evidence the goal was too ambitious"}]'::jsonb, '["c"]'::jsonb, 'The resourcing test: if tools, access, or policy clarity were never provided, the failure belongs to the manager who withheld them.', 5, true),
  ('q_ldr204_06', 'lm_ldr204', 'Why should people be pointed to the policy document rather than desk folklore?', 'SINGLE', '[{"key": "a", "text": "Folklore is usually wrong about deadlines"}, {"key": "b", "text": "Policy clarity is a resource \u2014 a person operating on ''how we''ve always done it'' is operating without resources"}, {"key": "c", "text": "Reading policies is a mandatory training requirement"}, {"key": "d", "text": "Documents are easier to memorize than verbal instructions"}]'::jsonb, '["b"]'::jsonb, 'However experienced the folklore''s source, the written rule is the resource; the memory of it is not.', 6, true),
  ('q_ldr204_07', 'lm_ldr204', 'What distinguishes supervision from surveillance?', 'SINGLE', '[{"key": "a", "text": "Supervision is done by G4+ leads while surveillance is automated"}, {"key": "b", "text": "Surveillance applies only during probation"}, {"key": "c", "text": "Supervision is weekly while surveillance is monthly"}, {"key": "d", "text": "Supervision sets outcome, boundaries, and a check-in rhythm, then lets the person work; surveillance re-inspects every intermediate step"}]'::jsonb, '["d"]'::jsonb, 'Re-approving every keystroke converts delegation into dictation with extra steps — the work stays yours, with a witness.', 7, true),
  ('q_ldr204_08', 'lm_ldr204', 'How should a lead size the ''failure budget'' when giving space?', 'SINGLE', '[{"key": "a", "text": "Wide space where failure is recoverable, tight boundaries where it is not \u2014 and tell the person which zone they are in"}, {"key": "b", "text": "No failures permitted in the first year, generous allowance afterward"}, {"key": "c", "text": "Equal tolerance across all tasks for fairness"}, {"key": "d", "text": "Failure budgets are set by People Ops, not the lead"}]'::jsonb, '["a"]'::jsonb, 'A draft client report can fail safely; a settlement instruction cannot. The craft is matching space to recoverability — explicitly.', 8, true),
  ('q_ldr204_09', 'lm_ldr204', 'Why should delegated authority be put in writing?', 'SINGLE', '[{"key": "a", "text": "Because the portal blocks undocumented delegations"}, {"key": "b", "text": "Because verbal authority evaporates under pressure \u2014 an undocumented ''you can decide that'' becomes ''I never said that'' when something goes wrong"}, {"key": "c", "text": "Because written delegations qualify for overtime pay"}, {"key": "d", "text": "Because auditors must co-sign all delegations"}]'::jsonb, '["b"]'::jsonb, 'The space you grant must survive scrutiny; documentation is what keeps it real after the first incident.', 9, true),
  ('q_ldr204_10', 'lm_ldr204', 'What does giving ''time'' look like in practice when handing over new work?', 'SINGLE', '[{"key": "a", "text": "Removing all deadlines until mastery is reached"}, {"key": "b", "text": "Extending probation by the length of the learning curve"}, {"key": "c", "text": "Setting learning-curve expectations explicitly \u2014 for example, ''the first two cycles will be slow and we will review each one''"}, {"key": "d", "text": "Scheduling the work outside business hours initially"}]'::jsonb, '["c"]'::jsonb, 'Explicit curve-setting makes early struggle read as planned rather than alarming — and protects the patience you promised.', 10, true),
  ('q_ldr204_11', 'lm_ldr204', 'Which retreat principle keeps generous enabling honest?', 'SINGLE', '[{"key": "a", "text": "What you don''t measure, you cannot improve"}, {"key": "b", "text": "Trust, but only within job families"}, {"key": "c", "text": "Compliance by default"}, {"key": "d", "text": "The customer is always right"}]'::jsonb, '["a"]'::jsonb, 'Resources, space, and time without measurement is abdication with good intentions; measurement is what makes wide space safe.', 11, true),
  ('q_ldr204_12', 'lm_ldr204', 'What design did the retreat''s weekly client-operations report establish?', 'SINGLE', '[{"key": "a", "text": "A narrative essay on the week''s challenges"}, {"key": "b", "text": "A few simple entries compiled into a weekly summary, with each metric carrying a target direction \u2014 green on-track, red below"}, {"key": "c", "text": "A monthly dashboard reviewed quarterly by the Board"}, {"key": "d", "text": "An anonymous team-morale survey"}]'::jsonb, '["b"]'::jsonb, 'Deliberately simple, frequent, and target-directed — so drift announces itself in days, not quarters.', 12, true),
  ('q_ldr204_13', 'lm_ldr204', 'What was the retreat''s basis for committing critical processes to checklists?', 'SINGLE', '[{"key": "a", "text": "A regulator''s directive following inspection"}, {"key": "b", "text": "Cost savings from reduced training"}, {"key": "c", "text": "Parallels from healthcare and aviation \u2014 checklists become muscle memory and eliminate errors of omission"}, {"key": "d", "text": "A software vendor''s recommendation"}]'::jsonb, '["c"]'::jsonb, 'Nurses run checklists per patient encounter, pilots before takeoff; the firm applies the same discipline to repetitive critical processes.', 13, true),
  ('q_ldr204_14', 'lm_ldr204', 'Why is a checklist an enabling device rather than a bureaucratic one for a team lead?', 'SINGLE', '[{"key": "a", "text": "It reduces the number of one-to-ones required"}, {"key": "b", "text": "It transfers liability from the lead to the checklist''s author"}, {"key": "c", "text": "It shortens the working day for the team"}, {"key": "d", "text": "It lets a critical process be handed to a developing team member, because the process \u2014 not the person''s experience \u2014 carries the safety"}]'::jsonb, '["d"]'::jsonb, 'The checklist encodes the safety, which is exactly what makes early delegation of critical work responsible.', 14, true),
  ('q_ldr204_15', 'lm_ldr204', 'What does the ''dead wood'' concept describe?', 'SINGLE', '[{"key": "a", "text": "Obsolete processes that should be retired"}, {"key": "b", "text": "Team members who do not contribute, resist innovation, and dampen the effectiveness of those around them"}, {"key": "c", "text": "Roles left vacant for more than ninety days"}, {"key": "d", "text": "Files past their retention period"}]'::jsonb, '["b"]'::jsonb, 'The retreat''s image: a single dead piece of firewood can quench a fire that would otherwise spread from log to log.', 15, true),
  ('q_ldr204_16', 'lm_ldr204', 'What must precede any conclusion that a struggling team member is a non-responder rather than a learner?', 'SINGLE', '[{"key": "a", "text": "Full, documented enablement \u2014 resources delivered, space defined, time allowed, measurement running"}, {"key": "b", "text": "A confidential vote of the rest of the team"}, {"key": "c", "text": "Two consecutive year-end ratings of 1"}, {"key": "d", "text": "Approval from the Board''s remuneration committee"}]'::jsonb, '["a"]'::jsonb, 'The measurement layer is what makes the judgment honest: improving numbers mean a curve; flat numbers despite genuine enablement mean the matter moves on.', 16, true),
  ('q_ldr204_17', 'lm_ldr204', 'When genuine enablement meets no response, where does the matter go?', 'SINGLE', '[{"key": "a", "text": "Straight to termination by the line lead"}, {"key": "b", "text": "To an informal warning kept off the record"}, {"key": "c", "text": "To the structured capability process in WS5 Part 2 \u2014 or the disciplinary track if the issue is conduct rather than capability"}, {"key": "d", "text": "To a transfer between desks as a fresh start"}]'::jsonb, '["c"]'::jsonb, 'Enabling has a boundary: sustained non-response despite documented support enters the firm''s defined underperformance process.', 17, true),
  ('q_ldr204_18', 'lm_ldr204', 'In the worked example, what did Halima''s three-element audit of Kunle reveal?', 'SINGLE', '[{"key": "a", "text": "A conduct issue requiring the disciplinary procedure"}, {"key": "b", "text": "That the previous lead''s diagnosis was correct"}, {"key": "c", "text": "That the role itself should be eliminated"}, {"key": "d", "text": "Missing resources (outdated checklist, no portal access) and withheld space (constant re-inspection) \u2014 not carelessness"}]'::jsonb, '["d"]'::jsonb, 'The ''careless'' employee had been reconciling blind on a stale checklist under daily hover; once resourced and spaced, the curve appeared.', 18, true),
  ('q_ldr204_19', 'lm_ldr204', 'Why did Halima''s documentation of the enablement arc matter even though Kunle improved?', 'SINGLE', '[{"key": "a", "text": "It qualified her for a leadership bonus"}, {"key": "b", "text": "It was required to restore Kunle''s portal access"}, {"key": "c", "text": "It satisfied a quarterly internal audit request"}, {"key": "d", "text": "Had the numbers stayed flat, the record of proven enablement would have made the WS5 capability conversation clean"}]'::jsonb, '["d"]'::jsonb, 'The documented arc protects everyone: it shows the firm — and any later review — whether the failure was the system''s or the person''s.', 19, true),
  ('q_ldr204_20', 'lm_ldr204', 'Why is indefinitely carrying a non-responding team member not kindness?', 'SINGLE', '[{"key": "a", "text": "It taxes the colleagues absorbing the slack, teaches the team that standards are negotiable, and risks quenching the others'' fire"}, {"key": "b", "text": "It violates the leave policy"}, {"key": "c", "text": "It inflates the desk''s bonus multiplier unfairly"}, {"key": "d", "text": "It prevents the firm from hiring interns"}]'::jsonb, '["a"]'::jsonb, 'Protection of one unresponsive person comes at the team''s expense — the retreat''s firewood image makes the cost vivid.', 20, true)
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
  SELECT count(*) INTO qn FROM learning_quiz_questions WHERE module_id = 'lm_ldr204' AND active;
  SELECT status INTO st FROM learning_modules WHERE id = 'lm_ldr204';
  IF qn <> 20 THEN
    RAISE EXCEPTION 'LDR-204: expected 20 active questions, found %', qn;
  END IF;
  IF st <> 'PUBLISHED' THEN
    RAISE EXCEPTION 'LDR-204: status is %, expected PUBLISHED', st;
  END IF;
END $$;

COMMIT;
