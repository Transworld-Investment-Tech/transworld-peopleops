-- =============================================================================
-- seed_bdv204_content.sql  (v0.67.0)
-- BDV-204: Handling objections, negotiation & ethical closing — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B) to the house style; bounded by CLA-203 suitability + Compliance Manual §§10/15. ESR v1.1 row BDV-204.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: BDV-2xx are role-targeted via seed_bdv2xx_role_matrix.sql
--   (BDV-2xx were ABSENT from the canonical matrix; this batch ships that seed + a
--   canonical patch). Confirm live: verify_p7.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$The end of a sale is where character shows. A client raises a doubt, hesitates over the fee, or pushes for something the firm should not give them, and in that moment the salesperson either serves the client or serves their own target. Handling objections, negotiating terms and closing are real skills, and they can be done with great competence. But at a regulated investment firm they sit inside a boundary that does not move: nothing in the closing conversation may override suitability, and no technique that works by pressure or inducement is permitted, however effective it would be. This module teaches the skills and the boundary together, because one without the other is either useless or dangerous.

## What you will be able to do

1. Treat objections as information that improves the recommendation, not as obstacles to overcome.
2. Reframe a client's concern honestly, without resorting to a misleading claim.
3. Negotiate the things that are genuinely negotiable while protecting the things that are not.
4. Close ethically — asking for the business without pressure or inducement.
5. Recognize when the right answer is to let "no" mean no and walk away from an unsuitable sale.

## Objections are information

An objection is the client telling you what stands between them and a decision, which is useful rather than unwelcome. The reflexive response is to argue it away; the professional response is to understand it first. Objections usually fall into a few types. Some are about understanding — the client has not grasped a part of the recommendation, and the answer is a clearer explanation, not a stronger push. Some are about fit — the recommendation does not quite match the need, in which case the objection is correct and the recommendation should change. Some are about trust — the client is not yet sure of you or the firm, and the answer is evidence and patience, not pressure. And some are about price. The skill is to find out which kind you are facing before responding, usually by asking a question back: "tell me what is making you hesitate." A salesperson who answers an objection they have not understood is guessing, and often answers a question the client did not ask.

Hearing an objection as information has a further benefit: sometimes the client is right. A concern that the recommendation does not really fit the timeframe, or carries more risk than they want, may be a genuine suitability signal that the proposal needs to change. The seller whose only mode is to overcome objections will steamroll past exactly the warning that should have stopped them. The best handling of objections begins before the meeting. If you understand the client from discovery, you can usually anticipate the concerns they are likely to raise — about fees, about risk, about tying up money they may need — and prepare honest, clear answers in advance rather than improvising under pressure. Anticipation is not scripting a rebuttal for every possible doubt; it is knowing your client and your recommendation well enough that few objections surprise you, so that when one comes you can meet it calmly and truthfully. The salesperson caught flat-footed by an obvious objection either guesses or pushes, and both are worse than the prepared, honest answer they could have had ready.

## Reframing honestly

To reframe an objection is to address the real concern behind it in a way that puts it in proportion — and the word that matters is *honestly*. If a client worries that markets are volatile, an honest reframe explains how a suitable, diversified holding manages that volatility and over what horizon, while acknowledging that volatility is real and cannot be wished away. A dishonest reframe tells the client not to worry because the investment "always recovers," which is both false and a conduct breach. The line is simple to state and must be held under pressure: you may put a concern in context, but you may never answer it with a claim that is untrue or that implies a certainty the market does not offer. The most persuasive reframe is usually the honest one anyway, because clients can sense the difference between being reassured and being managed.

## Negotiation inside the boundary

Some things in a deal are negotiable and some are not, and knowing which is which is the whole of ethical negotiation. Genuinely negotiable, within the firm's policies, are matters like the structure of an engagement, service levels, or the scope of what the firm will do — the ordinary give and take of agreeing how two parties will work together. Not negotiable, ever, are the things that protect the client and the market: the suitability of the recommendation, the honesty and completeness of disclosure, the transparency of fees, and the client's priority over the firm's own interests. A client may push to have a risk downplayed, a fee obscured, or an unsuitable product approved because they want it; the answer to each is a courteous, firm no. Negotiation is trading on the negotiable, not bargaining away the protections. A deal reached by conceding on suitability or disclosure is not a win the firm wants; it is a future complaint with a signature on it.

Fee transparency deserves a specific word, because it is a common pressure point. A client who feels a fee is high is entitled to a clear explanation of what it pays for and an honest discussion of options. What they are not entitled to, and what you may not offer, is a fee made to look smaller than it is, or hidden in a structure they will not understand. Transparency is not a tactic to be deployed when convenient; it is a fixed condition of every conversation.

## Closing ethically

Closing has an undeserved reputation, because in the popular imagination it means manipulation — the high-pressure tactic, the artificial deadline, the trick that gets a signature. Ethical closing is simpler and, done well, more effective: it is asking clearly for the business once the client understands the recommendation and it genuinely suits them. There is nothing wrong with asking for a decision, summarizing why the recommendation fits, or agreeing the next step. What is forbidden is pressure and inducement: the manufactured urgency ("you must decide today or lose this"), the personal sweetener offered to tip the decision, the wearing-down of a reluctant client until they give in. These are not merely distasteful; they breach the firm's conduct standards, and an inducement offered or accepted to close a sale runs straight into the firm's gift and conflict rules.

The decisive principle is that a close can never override a suitability failure. If the recommendation does not suit the client, no amount of skilful closing makes it suitable; it makes an unsuitable sale, which is the thing the entire advisory framework exists to prevent. So the order of operations is fixed: establish that the recommendation suits the client, make sure they understand it, then ask for the business. Reverse that order — close first and rationalize suitability afterward — and you have abandoned the boundary.

## When "no" must mean no

Sometimes the honest outcome of all this skill is that the client declines, or that you decline on their behalf. A client who, after a clear explanation, still does not want to proceed is entitled to that decision, and continuing to press them past a genuine "no" is pressure selling. More pointedly, there are sales you should refuse to close even when the client is willing: the client set on a concentrated, unsuitable bet, the client who wants a product that does not fit their profile, the client pushing you to do something the rules forbid. Walking away from an unsuitable sale costs you a transaction and protects the client, the firm and your own standing. In a referral market it is rarely even a real loss, because the client who was told the truth, including the truth they did not want to hear, is the one who comes back and sends others.

## The psychology of the close, used honestly

There are recognized closing techniques, and the honest test of any of them is whether it helps a client decide something that genuinely suits them or merely pressures them into a signature. The legitimate ones share a feature: they assist a decision the client is ready to make. Summarizing why the recommendation fits the need you established is a close, and a fair one, because it helps the client see the logic whole. Proposing a concrete next step — opening the account, scheduling the paperwork — is a close, and a fair one, because most people welcome a clear path once they have decided. Even asking directly, whether to proceed, is a fair close, because a clear question deserves a clear answer and respects the client's competence to give one.

The manipulative techniques share the opposite feature: they work by overriding the client's judgment rather than serving it. The false deadline manufactures urgency that does not exist. The persistent re-ask wears a reluctant client down until refusal becomes weary assent. The personal sweetener buys a decision that the merits did not earn. Each of these can produce a signature, and each is forbidden, because the firm does not want signatures it had to extract; it wants clients who chose, understanding what they chose. Silence belongs on the honest side of this line: after you ask for the business, letting the client think in peace is a courtesy, not a tactic, and the urge to fill the pause with one more reason is usually the urge to push.

The simplest way to stay on the right side is to ask yourself, before any closing move, whether you would be comfortable if the client could see exactly what you were doing and why. A fair close survives that test easily — there is nothing to hide in helping someone act on a decision that suits them. A manipulative one does not, because its whole mechanism depends on the client not noticing it. Closing, done honestly, is not a dark art; it is the unembarrassed business of helping a well-advised client take the step they came to take.

## A worked example

**Illustration — the fee objection and the unsuitable push (entirely hypothetical).** The client and details are invented for teaching. A client likes a recommended balanced fund but objects that the annual fee is too high. You handle the objection honestly: you explain exactly what the fee pays for, compare it fairly with the alternatives, and let the client weigh it — you do not obscure the fee or pretend it is lower than it is. Satisfied, the client then pushes in a different direction, asking you instead to put their whole sum into a single high-flying stock a friend recommended, well outside the risk profile they agreed in discovery. This is where the boundary holds. You do not close the easy sale the client is now asking for; you explain, courteously and firmly, that a single concentrated position does not suit their stated objectives and risk tolerance, and you decline to recommend it. You have handled the negotiable objection well and refused to bargain away the non-negotiable protection. The honest fee discussion may win the suitable sale; refusing the unsuitable one is the part that keeps the client safe and the firm clean.

## Common traps

- **Answering an objection you have not understood.** Find out whether it is about understanding, fit, trust or price before responding.
- **The dishonest reframe.** Putting a concern in context is fine; answering it with "it always recovers" is false and a conduct breach.
- **Bargaining away the non-negotiable.** Suitability, disclosure, fee transparency and client priority are never on the table.
- **Pressure and inducement closing.** Manufactured urgency or a personal sweetener breaches conduct and gift/conflict rules.
- **Closing past a suitability failure.** No close makes an unsuitable recommendation suitable; establish suitability first, then ask.

## Key takeaways

- Objections are information; identify whether each is about understanding, fit, trust or price, and remember the client is sometimes right.
- Reframe honestly — put concerns in proportion without any untrue or certainty-implying claim.
- Negotiate the genuinely negotiable; never bargain away suitability, disclosure, fee transparency or client priority.
- Close by asking clearly for the business once the recommendation suits and the client understands — never by pressure or inducement.
- A close can never override a suitability failure; letting "no" mean no, and walking away from an unsuitable sale, protects the client, the firm and you.

*Build mode: BUILD — a general professional craft taught to the house style, bounded by the firm's conduct rules. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: HubSpot Academy — objection-handling and closing (READ-REF); SPIN Selling and The Challenger Sale referenced for concept only (copyrighted works, not reproduced). The binding Transworld authorities for the conduct boundary are the suitability discipline of CLA-203, the fair-dealing and client-priority standards of the Compliance Manual (§15 and §10), and the gift and conflict rules covered in BDV-205. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row BDV-204.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-204';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_01$id$, m.id, $p$The professional way to treat a client objection is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "understand it first as information, since it tells you what stands between the client and a decision"}, {"key": "b", "text": "argue it away immediately"}, {"key": "c", "text": "ignore it and ask for the close"}, {"key": "d", "text": "offer a discount"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$An objection reveals the real barrier; understanding it improves the recommendation rather than being an obstacle.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_02$id$, m.id, $p$An objection that the recommendation does not match the client's timeframe may actually be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "irrelevant"}, {"key": "b", "text": "a genuine suitability signal that the proposal should change"}, {"key": "c", "text": "a reason to close harder"}, {"key": "d", "text": "a request for a sweetener"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Sometimes the client is right; a fit objection can be a warning the recommendation needs to change.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_03$id$, m.id, $p$Reframing an objection about market volatility honestly means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "saying the investment 'always recovers'"}, {"key": "b", "text": "promising no losses"}, {"key": "c", "text": "explaining how a suitable, diversified holding manages volatility while acknowledging it is real"}, {"key": "d", "text": "ignoring the concern"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$An honest reframe puts the concern in proportion without any false or certainty-implying claim.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_04$id$, m.id, $p$Which of these is genuinely negotiable within the firm's policies?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the suitability of the recommendation"}, {"key": "b", "text": "the honesty of disclosure"}, {"key": "c", "text": "the client's priority over the firm"}, {"key": "d", "text": "the structure of an engagement or the scope of service"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Engagement structure and service scope are negotiable; suitability, disclosure and client priority are not.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_05$id$, m.id, $p$Fee transparency in a negotiation is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a fixed condition of every conversation, not a tactic deployed when convenient"}, {"key": "b", "text": "optional for sophisticated clients"}, {"key": "c", "text": "something to obscure if the fee is high"}, {"key": "d", "text": "negotiable like any term"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A client may discuss a fee, but it may never be hidden or made to look smaller than it is.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_06$id$, m.id, $p$Ethical closing is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "manufacturing urgency to force a decision"}, {"key": "b", "text": "asking clearly for the business once the client understands and the recommendation suits them"}, {"key": "c", "text": "offering a personal sweetener"}, {"key": "d", "text": "wearing down a reluctant client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Asking for a decision is fine; pressure and inducement are forbidden.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_07$id$, m.id, $p$A manufactured deadline ('you must decide today or lose this') is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "good closing practice"}, {"key": "b", "text": "required for urgency"}, {"key": "c", "text": "pressure that breaches the firm's conduct standards"}, {"key": "d", "text": "a form of disclosure"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Artificial urgency is a pressure tactic prohibited by the conduct standards.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_08$id$, m.id, $p$The decisive principle governing closing is that a close can never...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "be asked for"}, {"key": "b", "text": "follow a clear explanation"}, {"key": "c", "text": "summarize the recommendation"}, {"key": "d", "text": "override a suitability failure"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$No amount of skilful closing makes an unsuitable recommendation suitable.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_09$id$, m.id, $p$The fixed order of operations before asking for the business is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "establish suitability, ensure understanding, then ask for the business"}, {"key": "b", "text": "ask first, rationalize suitability later"}, {"key": "c", "text": "close, then explain the risks"}, {"key": "d", "text": "offer an inducement, then assess fit"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Suitability and understanding come first; reversing the order abandons the boundary.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_10$id$, m.id, $p$Continuing to press a client who has clearly declined after a full explanation is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "good persistence"}, {"key": "b", "text": "pressure selling, which is not permitted"}, {"key": "c", "text": "required by the firm"}, {"key": "d", "text": "a disclosure obligation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A genuine 'no' must be allowed to mean no; pressing past it is pressure selling.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_11$id$, m.id, $p$A client willing to put their entire sum into a single unsuitable stock should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sold the stock since they asked"}, {"key": "b", "text": "given an inducement to proceed"}, {"key": "c", "text": "courteously and firmly declined, because it does not suit their profile"}, {"key": "d", "text": "pressured into a bigger position"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$You refuse to close an unsuitable sale even when the client is willing; the boundary holds.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_12$id$, m.id, $p$Identifying which 'type' an objection is matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "all objections need the same answer"}, {"key": "b", "text": "price is the only real objection"}, {"key": "c", "text": "it lets you ignore the client"}, {"key": "d", "text": "an objection about understanding needs a clearer explanation, while one about fit may mean the recommendation should change"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Understanding, fit, trust and price objections call for different responses; answering blind is guessing.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_13$id$, m.id, $p$The most persuasive reframe of a client concern is usually...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the honest one, because clients sense the difference between being reassured and being managed"}, {"key": "b", "text": "the one that promises certainty"}, {"key": "c", "text": "the one that hides the risk"}, {"key": "d", "text": "the one with an artificial deadline"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Honesty persuades; clients detect manipulation, and a false reassurance is also a conduct breach.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_14$id$, m.id, $p$An inducement offered or accepted to close a sale runs straight into the firm's...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "leave policy"}, {"key": "b", "text": "gift and conflict rules"}, {"key": "c", "text": "payroll rules"}, {"key": "d", "text": "best execution sample"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A sweetener to tip a decision engages the gift/benefit and conflict-of-interest rules (covered in BDV-205).$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_15$id$, m.id, $p$In the worked example, the salesperson handles the fee objection by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "pretending the fee is lower than it is"}, {"key": "b", "text": "refusing to discuss it"}, {"key": "c", "text": "explaining what the fee pays for and comparing it fairly with alternatives"}, {"key": "d", "text": "waiving suitability to win the sale"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$An honest fee discussion explains and compares transparently without obscuring the cost.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_16$id$, m.id, $p$Walking away from an unsuitable sale in a referral market is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "always a pure loss"}, {"key": "b", "text": "a breach of duty to the firm"}, {"key": "c", "text": "required only for large clients"}, {"key": "d", "text": "rarely a real loss, since the client told the truth tends to return and refer others"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Refusing an unsuitable sale protects everyone and, in a referral market, usually pays off.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_17$id$, m.id, $p$A salesperson who answers an objection they have not understood is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "guessing, and often answering a question the client did not ask"}, {"key": "b", "text": "being efficient"}, {"key": "c", "text": "following best practice"}, {"key": "d", "text": "disclosing risk"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Without first identifying the concern, the response addresses the wrong thing.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_18$id$, m.id, $p$Negotiation, done ethically, is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "bargaining away the protections to win the deal"}, {"key": "b", "text": "trading on the genuinely negotiable while protecting the non-negotiable"}, {"key": "c", "text": "conceding on disclosure when convenient"}, {"key": "d", "text": "downplaying risk on request"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Ethical negotiation gives and takes on terms like scope and service, never on suitability or disclosure.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_19$id$, m.id, $p$A deal reached by conceding on suitability or disclosure is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a clean win for the firm"}, {"key": "b", "text": "an efficient close"}, {"key": "c", "text": "a future complaint with a signature on it"}, {"key": "d", "text": "required by client demand"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Bargaining away the protections produces an unsuitable or undisclosed sale that will return as a complaint.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv204_20$id$, m.id, $p$The overall lesson uniting objections, negotiation and closing at a regulated firm is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any technique that works is permitted"}, {"key": "b", "text": "pressure is acceptable for reluctant clients"}, {"key": "c", "text": "suitability can be settled after the close"}, {"key": "d", "text": "real skill operates only inside a boundary that suitability, disclosure and client priority do not cross"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The skills are legitimate only within the conduct boundary; one without the other is useless or dangerous.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'BDV-204';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: BDV-204 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'BDV-204' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: BDV-204 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: BDV-204 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
