-- =============================================================================
-- seed_bdv203_content.sql  (v0.67.0)
-- BDV-203: Proposals & pitching: winning the business & follow-through — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B) to the house style; fair/clear/not-misleading; Operational Manual §21 + Compliance Manual §15. ESR v1.1 row BDV-203.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: BDV-2xx are role-targeted via seed_bdv2xx_role_matrix.sql
--   (BDV-2xx were ABSENT from the canonical matrix; this batch ships that seed + a
--   canonical patch). Confirm live: verify_p7.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A proposal is the moment a conversation becomes a commitment. Everything before it — the prospecting, the discovery, the trust slowly built — exists to earn the right to make a recommendation the client will act on. Get the proposal wrong and the work is wasted; get it wrong in the other direction, by overpromising, and you do worse than waste the work, because you create a client who was sold something that cannot be delivered. This module is about making proposals that win business honestly: how to structure one, how to pitch it, the firm and regulatory standard that every word of it must meet, and the follow-through that turns a "yes" into a funded account and a "not yet" into a future one.

## What you will be able to do

1. Structure a proposal that leads with the client's need and shows the fit, the specifics and the risks.
2. Pitch with clarity rather than flourish, so the client understands what they are agreeing to.
3. Apply the fair, clear and not-misleading standard to everything you present.
4. Follow through after a proposal under the firm's client-communications discipline.
5. Keep the proposal and what was said as firm records.

## Anatomy of a proposal that wins honestly

A good proposal is built in the client's order, not the firm's. It opens by restating the need you uncovered in discovery, in the client's own terms, so they can see they were understood: this is what you told me you are trying to achieve, this is your timeframe, this is how much risk you are comfortable with. Only then does it present the recommendation, framed as the answer to that need rather than as a product the firm happens to sell. It is specific about what the client would actually be buying — the instrument, the costs and fees, what happens to their money and when they can access it — because vagueness here is where misunderstandings and later complaints are born. And, crucially, it states the risks with the same clarity as the benefits. A proposal that lists upside in bold and buries the downside is not balanced, and an unbalanced proposal is a defective one however attractive it looks.

The discipline of leading with the need does real work. It keeps the recommendation tethered to the suitability picture, so the proposal is demonstrably built for this client; it makes the pitch persuasive without exaggeration, because a recommendation that visibly answers a stated need sells itself; and it produces a document the firm can defend, because the logic from need to recommendation is written down in plain sight.

## Pitching: clarity over flourish

Pitching is the spoken version of the proposal, and the temptation is to perform. Resist it. The client is about to commit money, and what persuades a sensible person in that position is not a polished flourish but the sense that they fully understand what they are agreeing to and that nothing has been hidden. Pitch in plain language. Explain the recommendation, then explain the risks, then check the client has genuinely followed — not by asking "does that make sense?", which invites a polite yes, but by inviting their questions and answering them straight. A client who understands a modest recommendation will act on it; a client dazzled into a bigger one they do not understand will hesitate, or act and then resent it. Clarity is not the cautious choice that costs you sales; it is the choice that wins the sales worth having.

## The fair, clear and not-misleading standard

Everything you put in front of a client — a proposal, a pitch, a slide, a message — must be fair, clear and not misleading. This is not house preference; it is the conduct standard the firm operates under, and it has teeth. In practice it means several concrete things. You may not promise or guarantee a return, because investment returns are not certain and implying otherwise is misleading on its face. You may not present past performance as if it predicts the future, or headline a good historical figure while omitting that it could just as easily reverse. You must give risks genuine prominence, not relegate them to small print. And you must not cherry-pick the flattering facts and suppress the inconvenient ones, because a statement that is technically true but engineered to leave a false impression is still misleading. The firm's standards of conduct put it simply: integrity means never overstating what a product can deliver. The same idea is familiar in mature markets — the principle that marketing and pitch material must be fair, balanced and not misleading is, for instance, the spirit of conduct rules elsewhere — but the binding rule here is the firm's own conduct standard under Nigerian regulation, and that is the one you must meet.

## Following through

Most proposals are not accepted on the spot, and the follow-through is where business is actually won or quietly lost. Following through means doing what you said you would do, when you said you would do it: sending the promised information, answering the outstanding question, checking back at the agreed time rather than vanishing or pestering. The firm's discipline for client communications, set out in the Operational Manual, governs how this is done — communications are handled promptly and professionally, and material exchanges are recorded rather than left to memory. A prospect who said "let me think" and then heard nothing concludes the firm was not serious; a prospect who is followed up cleanly, on the timetable you agreed, sees a firm that does what it promises before they are even a client, which is the most persuasive evidence of all. Follow-through is also where a "no" is handled with grace, because the prospect who declines today, treated well, is the referral or the client of next year. When the answer is yes, follow-through changes gear but does not stop. A client who has agreed still has to be carried through account opening, KYC and funding — the onboarding stage of the funnel — and the same reliability that won the business is what turns an agreement into a funded, active account rather than a signature that stalls in paperwork. Chasing the documents through compliance, keeping the client informed while it happens, and confirming when the account is live are all part of the follow-through; the proposal is not truly won until the account is open and trading. A prospect lost in the gap between yes and funded is as lost as one who said no, and far more frustrating, because the hard part had already been done. Following through to the funded account is therefore not an administrative afterthought but the final, decisive stage of winning the business.

## Keeping the record

A proposal is a firm record, and so is the material substance of what you said when you pitched it. This matters for the same reason discovery notes matter: if a client later says they were told something they were not, or were not told something they should have been, the record is what establishes the truth. Keep the proposal you sent. Note the material points of the conversation around it. Record the follow-up communications. None of this is bureaucracy for its own sake; it is the evidence that the proposal met the standard, that the risks were disclosed, and that the client agreed to what was actually recommended. A clean record protects the client, the firm and you.

## Tailoring the proposal to the audience

A proposal is written for a particular reader, and an individual client and a corporate one are very different readers. An individual is often deciding alone, with their own money and their own anxieties, and the proposal that serves them is plain, personal and unhurried: it speaks to their stated goal, explains the recommendation in language they will actually follow, and gives them space to ask. A corporate or institutional client decides differently — through a process, often with several people involved, a mandate to satisfy and a record to keep — so the proposal that serves them is more structured and more explicit about how the recommendation fits their stated objectives and constraints, because it may be read by people who were not in the room. Knowing which kind of reader you are writing for, and shaping the proposal accordingly, is part of the craft; a brilliant individual pitch dropped on a corporate committee, or a dense institutional document handed to a first-time individual investor, both miss.

It helps to know what a weak proposal looks like, because the failures are consistent. A weak proposal leads with the product rather than the need, so the reader cannot see why it is for them. It is vague about costs and access, leaving unanswered the very questions a careful reader most wants answered. It is unbalanced, with the benefits vivid and the risks faint. And it overreaches, implying more certainty than the firm can honestly offer, which a sophisticated reader spots immediately and a trusting one discovers later. A strong proposal is the mirror image: need first, recommendation as the answer, specifics laid out plainly, risks given real weight, and not a word that overstates.

None of this changes the standard the words must meet, which is the same for every audience — fair, clear and not misleading — but it changes how you meet it. The corporate reader and the individual reader are owed the same honesty; they simply need it delivered in the form each can act on. Matching the proposal to its audience is therefore not a presentational nicety but part of serving the client well: a recommendation the reader cannot follow, however suitable, has not really been communicated, and a proposal that is not understood is not yet doing its job.

## A worked example

**Illustration — the tempting headline (entirely hypothetical).** The client and figures are invented for teaching. You are preparing a proposal for a corporate client with cash to deploy, and a particular fund returned thirty percent last year. The tempting pitch leads with that number in bold: "this fund returned 30% last year." It is a true figure, but presented this way it is misleading, because it implies a repeat the fund cannot promise and buries the risk that the same fund could fall as far. The compliant proposal does it differently. It restates the client's actual need — deploy surplus cash for a defined period at a risk level the client accepted in discovery — recommends a fund that fits that need, and presents the historical return honestly: as one past year, explicitly not a forecast, alongside the real risks and the costs. The recommendation is followed up on the agreed date with the promised supporting detail, and the proposal and the conversation are kept on file. The honest version is less dazzling and far more likely to produce a client who stays, and it is the only version the firm's conduct standard allows.

## Common traps

- **Leading with the product, not the need.** A proposal that opens with what the firm sells, rather than what the client wants, is unmoored from suitability.
- **Unbalanced presentation.** Upside in bold and risk in small print is a defective proposal, however attractive.
- **Promising or guaranteeing returns.** Returns are not certain; implying otherwise is misleading and breaches conduct standards.
- **Treating past performance as a forecast.** A good historical figure is one past year, not a prediction.
- **Vanishing after the pitch.** No follow-through tells the prospect the firm is not serious; clean follow-up wins the business worth having.

## Key takeaways

- Build the proposal in the client's order: restate the need, then the fitting recommendation, then the specifics and the risks.
- Pitch in plain language and confirm real understanding; clarity wins the sales worth having.
- Every proposal and pitch must be fair, clear and not misleading — no guaranteed returns, no past performance dressed as a forecast, risks given genuine prominence.
- Follow through on the timetable you agreed, under the firm's client-communications discipline, and handle a "no" with grace.
- Keep the proposal and the material conversation as firm records — the evidence that the standard was met and the risks disclosed.

*Build mode: BUILD — a general professional craft taught to the house style; the binding conduct content is the firm's own. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: HubSpot Academy — proposal and presentation practice (READ-REF); the fair, balanced and not-misleading standard for communications associated with the business — the spirit of US FINRA Rule 2210 (READ-REF, concept only) — localized to the Nigerian rule. The binding Transworld authorities are the client-communications discipline of the Operational Manual (§21) and the fair-dealing and integrity standards of the Compliance Manual (§15). Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row BDV-203.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-203';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_01$id$, m.id, $p$A proposal that wins business honestly is built in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client's order: restate the need, then the fitting recommendation, then specifics and risks"}, {"key": "b", "text": "the firm's order: product first"}, {"key": "c", "text": "whatever order is quickest"}, {"key": "d", "text": "random order"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Leading with the client's need keeps the recommendation tethered to suitability and persuades without exaggeration.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_02$id$, m.id, $p$A proposal that lists upside in bold and buries the downside in small print is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "balanced and acceptable"}, {"key": "b", "text": "defective, however attractive it looks"}, {"key": "c", "text": "the firm's preferred format"}, {"key": "d", "text": "required for clarity"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Risks must be given genuine prominence; an unbalanced proposal fails the fair, clear and not-misleading standard.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_03$id$, m.id, $p$Confirming a client has genuinely understood a pitch is best done by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "asking 'does that make sense?'"}, {"key": "b", "text": "speaking faster"}, {"key": "c", "text": "inviting their questions and answering them straight"}, {"key": "d", "text": "skipping the risks"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$'Does that make sense?' invites a polite yes; inviting questions tests real understanding.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_04$id$, m.id, $p$Under the firm's conduct standard, promising or guaranteeing an investment return is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fine if you believe it"}, {"key": "b", "text": "required to win business"}, {"key": "c", "text": "acceptable for low-risk products"}, {"key": "d", "text": "misleading on its face, because returns are not certain"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Investment returns are uncertain; implying certainty breaches the fair, clear and not-misleading standard.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_05$id$, m.id, $p$Presenting a fund's strong past year as if it predicts the future is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "misleading — past performance is one past year, not a forecast"}, {"key": "b", "text": "a fair, balanced presentation"}, {"key": "c", "text": "required by the Operational Manual"}, {"key": "d", "text": "acceptable if the figure is true"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A true historical figure dressed as a prediction leaves a false impression and is misleading.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_06$id$, m.id, $p$The firm's discipline for client communications, including follow-through, is set out in the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Best Execution Policy"}, {"key": "b", "text": "Operational Manual (client communications)"}, {"key": "c", "text": "employee leave policy"}, {"key": "d", "text": "payroll manual"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Operational Manual §21 governs prompt, professional, recorded client communications.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_07$id$, m.id, $p$A statement that is technically true but engineered to leave a false impression is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully compliant"}, {"key": "b", "text": "fair and balanced"}, {"key": "c", "text": "still misleading"}, {"key": "d", "text": "required disclosure"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Cherry-picking flattering facts to mislead breaches the standard even when each fact is true.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_08$id$, m.id, $p$A prospect who said 'let me think' and then hears nothing from you is likely to conclude...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the firm respects their time"}, {"key": "b", "text": "the proposal was excellent"}, {"key": "c", "text": "they should refer friends"}, {"key": "d", "text": "the firm was not serious"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Silence after a pitch signals a lack of seriousness; clean follow-up wins business and referrals.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_09$id$, m.id, $p$A proposal and the material substance of the pitch around it should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "kept as firm records — the evidence the standard was met and risks disclosed"}, {"key": "b", "text": "discarded once sent"}, {"key": "c", "text": "kept only if the client complains"}, {"key": "d", "text": "stored on a personal device"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The record establishes what was recommended and disclosed; it protects the client, the firm and you.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_10$id$, m.id, $p$Being specific about instrument, costs, fees and access in a proposal matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it lengthens the document"}, {"key": "b", "text": "vagueness is where misunderstandings and later complaints are born"}, {"key": "c", "text": "clients prefer not to know fees"}, {"key": "d", "text": "it guarantees the sale"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Precision on what the client is buying prevents the misunderstandings that vagueness creates.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_11$id$, m.id, $p$The fair, balanced and not-misleading idea familiar from conduct rules elsewhere (e.g. FINRA Rule 2210) is used here as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the binding rule that overrides Nigerian regulation"}, {"key": "b", "text": "a reason to ignore the firm's standard"}, {"key": "c", "text": "a concept; the binding rule is the firm's own conduct standard under Nigerian regulation"}, {"key": "d", "text": "an exemption from disclosure"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Concept travels, rules do not — the external standard is illustrative; the firm's Nigerian-regulated standard binds.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_12$id$, m.id, $p$Pitching with clarity rather than flourish tends to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "cost the firm every sale"}, {"key": "b", "text": "confuse sensible clients"}, {"key": "c", "text": "breach conduct rules"}, {"key": "d", "text": "win the sales worth having, because the client understands and trusts what they agree to"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A client who fully understands a modest recommendation acts on it; one dazzled into a bigger one hesitates or resents it.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_13$id$, m.id, $p$Following through after a proposal means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "doing what you said, when you said it — sending information and checking back on the agreed timetable"}, {"key": "b", "text": "pestering the client daily"}, {"key": "c", "text": "never contacting them again"}, {"key": "d", "text": "changing the recommendation each week"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Reliable, agreed-timetable follow-up is the most persuasive evidence a firm does what it promises.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_14$id$, m.id, $p$In the worked example, the compliant way to present a fund that returned 30% last year is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "headline '30% last year' in bold"}, {"key": "b", "text": "present it as one past year, explicitly not a forecast, alongside the real risks and costs"}, {"key": "c", "text": "omit the figure entirely"}, {"key": "d", "text": "promise a repeat"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The honest presentation states the historical return without implying a repeat and shows the risks.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_15$id$, m.id, $p$Leading a proposal with the client's stated need (rather than the product) helps produce...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an unbalanced pitch"}, {"key": "b", "text": "a guaranteed return"}, {"key": "c", "text": "a document the firm can defend, with the logic from need to recommendation written down"}, {"key": "d", "text": "less suitable advice"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The need-first structure ties the recommendation to suitability and makes the proposal defensible.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_16$id$, m.id, $p$Handling a prospect's 'no' with grace matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is required to close today"}, {"key": "b", "text": "it lets you delete the record"}, {"key": "c", "text": "it guarantees a future sale"}, {"key": "d", "text": "the prospect who declines today, treated well, may be next year's referral or client"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$In a referral market a well-handled decline preserves future business and reputation.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_17$id$, m.id, $p$Risks in a proposal should be given...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the same clarity and prominence as the benefits"}, {"key": "b", "text": "a footnote in small print"}, {"key": "c", "text": "no mention to avoid alarming the client"}, {"key": "d", "text": "less weight than past returns"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Balanced presentation gives risks genuine prominence; relegating them makes the proposal defective.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_18$id$, m.id, $p$The firm's standards of conduct state that integrity means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "closing every sale"}, {"key": "b", "text": "never overstating what a product can deliver"}, {"key": "c", "text": "headlining the best historical return"}, {"key": "d", "text": "guaranteeing outcomes to win trust"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Compliance Manual §15 ties integrity directly to never overstating a product's capability.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_19$id$, m.id, $p$Recording the material points of a pitch conversation is justified mainly because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is bureaucracy for its own sake"}, {"key": "b", "text": "clients enjoy paperwork"}, {"key": "c", "text": "if a client later disputes what was said, the record establishes the truth"}, {"key": "d", "text": "it replaces the proposal"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The record is the evidence of what was recommended and disclosed if anything is later questioned.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv203_20$id$, m.id, $p$The overall lesson of compliant proposing and pitching is that the honest version is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "always the bigger sale today"}, {"key": "b", "text": "optional for sophisticated clients"}, {"key": "c", "text": "a breach of conduct rules"}, {"key": "d", "text": "less dazzling but more likely to keep the client, and the only version the firm's standard allows"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Honest, balanced proposals win durable clients and are the only kind the conduct standard permits.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'BDV-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: BDV-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'BDV-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: BDV-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: BDV-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
