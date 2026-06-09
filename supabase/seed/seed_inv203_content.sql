-- =============================================================================
-- seed_inv203_content.sql  (v0.65.0)
-- INV-203: Writing the research note & making a recommendation — lesson + 20-question check (Proficient).
-- Authored BUILD+SOURCE (Tier B); anchored to the Employee Handbook (voice) + COI/IPT policies; Reg BI concept localized to the Nigerian suitability rule. ESR v1.1 row INV-203.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row: the canonical role matrix already
--   maps INV-203 to live job profiles (Investment Analyst PUBLISHED + reserved roles;
--   confirm live: verify_p6.sql). Publish-only (the REG/OPS/CLA pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$INV-202 ended with a number and a promise: the four planks that turn a value into a call. This module is where you build the note that carries it. A valuation that never becomes a clear, suitable, defensible recommendation is wasted work — the portfolio manager cannot act on a fair-value figure alone, and the client certainly cannot. Writing the note is not the clerical end of research; it is where research becomes advice, and advice is governed.

## What you will be able to do

1. Structure a research note that a portfolio manager or a client can actually act on.
2. Turn a valuation into a recommendation across the four planks — gap, catalyst, risks, conviction.
3. Apply the suitability overlay so a recommendation fits the client, not just the model.
4. Stay inside the conduct rules — no material non-public information, conflicts disclosed, independence kept.
5. Write in the Transworld house voice: clear, honest about uncertainty, and defensible out loud.

## The recommendation itself

The call at the end of the note should be unambiguous. A recommendation is a clear action — buy, hold or sell, or whatever scale the firm uses — paired with a target price and a time horizon over which you expect the thesis to play out. "The stock looks interesting" is not a recommendation; "buy, with a twelve-month target of X, on the expectation that the margin recovery closes the gap" is. The target and horizon are not decoration: they are what make the call accountable later, because a recommendation with a stated target and timeframe can be judged against what actually happened, while a vague positive sentiment cannot. Be willing, too, to recommend doing nothing. A hold on a fairly valued company is a real and often correct call, and a sell — closing or avoiding a position — is just as much a service to the client as a buy. Analysts who only ever say "buy" are not analysts; they are cheerleaders, and a client learns quickly to ignore them.

## The note's job

A research note exists to drive a decision, so write it in that order. Lead with the conclusion — the bottom line up front — not a slow build to a reveal on the last page. A reader in a hurry should learn your call, your target and your conviction in the first paragraph, then read on for why. From there the structure is predictable for a reason: a tight thesis that says what you believe and why it differs from the market's view, the valuation that supports it, the risks that could break it, the catalysts that might prove it, and the recommendation with a target price and a time horizon. Predictable structure is a courtesy to the reader and a discipline on the writer — it makes it obvious when a plank is missing, because an empty section is harder to hide than a missing sentence.

A good note is also honest about its own weight. Where a conclusion rests on a single fragile assumption, say so in the body rather than letting the reader discover it. Where the evidence is thin, a smaller, hedged claim is worth more than a confident one that cannot survive scrutiny. The note is not a sales document; it is the firm's reasoning, written down so that someone else can act on it and, later, judge whether the reasoning was sound.

## The four planks

INV-202 named them; here is how each one earns its place in the note. The gap is the distance between price and value — without it there is nothing to act on, and a stock trading at fair value is a hold, however good the company. The catalyst is what might close that gap and roughly when; a cheap stock that stays cheap forever makes no one any money, so name the event or trend — results, a capacity expansion, a regulatory change, a re-rating — that you expect to change the story. The risks are the honest list of what would prove you wrong, written plainly and near the top, not buried in a final paragraph nobody reads. And conviction is your confidence in the whole chain, which should translate directly into how large a position the call justifies: a high-conviction idea earns a larger weight than a marginal one. A number alone is not a recommendation; the four planks are what turn it into one, and a note missing any of them is incomplete.

## Suitability: a recommendation is always to someone

This is where research meets advice, and where the conduct regime takes over. CLA-203 established the Nigerian suitability obligation: under the SEC framework and the firm's Operational Manual risk-profile process, a recommendation must fit the client's objectives, risk tolerance, time horizon, liquidity needs and circumstances. The best-interest idea travels from the US Regulation Best Interest concept, but the binding rule for us is the Nigerian suitability and conduct set — so teach and apply that, not the foreign rule. Concept travels; rules do not.

The practical consequence is sharp: the same "buy" can be right for one client and wrong for another. A long-horizon, growth-seeking institution and a capital-preservation retiree are not served by the same recommendation, however good the underlying analysis, because suitability is about the fit between the idea and the person, not the quality of the idea in the abstract. Know, too, which act you are performing. A general research view published to the desk is not the same as a personal recommendation made to a specific client; the second carries the full suitability obligation, and you must have the client's profile in front of you before you make it. Blurring the two — treating a house research view as if it were advice tailored to whoever happens to read it — is exactly the failure the suitability rule exists to prevent.

## Conduct: the lines you do not cross

Three lines matter most. The first is material non-public information. Under the Investments and Securities Act 2025, trading or recommending on the strength of material information that is not public is market abuse — a criminal exposure, not an edge. Build your view from lawfully obtained public information and honest analysis; the legitimate analytical advantage comes from assembling many public pieces better than others do, not from a single private one. If you ever find yourself holding what looks like material non-public information, you stop, you do not act or recommend on it, and you escalate to Compliance rather than writing around it.

The second is conflicts. The firm's Conflict of Interest Policy v3.0 requires that relevant conflicts — a personal holding in the name you are covering, a banking or advisory relationship between the firm and the issuer, a proprietary position — are disclosed, and a research note discloses the ones that bear on it so the reader can weigh the view accordingly. The third is independence and client priority: the recommendation must reflect your analysis, not sales pressure or the firm's own book, and the client's interest comes first, absolutely, ahead of the firm's proprietary trading, as the Investment and Proprietary Trading Policy v3.0 requires. A recommendation written to move inventory the firm wants to offload is not research; it is a conflict acted upon. Independence is also why research is kept at arm's length from the rest of the firm's commercial relationships: where the firm is advising or financing an issuer, the analyst covering that name must not be steered by those interests, and the note must disclose the relationship so the reader can judge the view on its merits rather than taking it on trust.

## The house voice

Write the way Transworld research reads. Lead with the bottom line. Use plain language a client could follow, not jargon that hides a thin argument behind technical fog. Publish a range and a target, never a false point of decimal precision — a target of ₦47.38 implies a confidence no honest valuation has. Say explicitly what would change your mind — the disconfirming evidence you are watching for — because a call with no exit condition is an opinion, not analysis, and naming the trigger turns the recommendation into something testable. And label, date and sign the note: it is a chain of reasoning someone else, including a client, an internal reviewer, or in time a regulator, must be able to audit. The voice is confident where the evidence earns it and candid where it does not, and that candour is what makes the confident parts credible.

## A worked example

**Illustration — turning the "Lagos Staples Plc" model into a call (entirely hypothetical).** The company and figures are invented for teaching; this is not a recommendation. The model from INV-202 put intrinsic value roughly 40% above the current price — that is the gap, and it is large enough to act on. The catalyst: a planned capacity expansion and an expected margin recovery over the coming year, which is what you expect the market to re-rate around. The risks, stated near the top rather than buried: the naira discount-rate assumption, input-cost inflation eating the margin recovery, and one revenue assumption drawn from a weak source that you flag openly. Conviction is moderate — the gap is real but the margin recovery is not yet proven — so the call justifies a measured position rather than a maximum one. Then the overlay that turns analysis into advice: the recommendation is suitable for a balanced or growth mandate but not for a capital-preservation client who cannot wear the volatility; the analyst has checked for and disclosed any conflict; and the view rests entirely on public information. A number became a call — qualified, suitable and defensible out loud. Notice what the note did that the model alone could not: it named the catalyst and the horizon, put the risks where the reader would see them, sized the conviction into a measured position, and tested the idea against a specific client's profile before it was ever offered as advice. That is the whole distance between a valuation and a recommendation, and it is the work this module exists to teach.

## Common traps

- **A number without a call.** "₦52 fair value" is not actionable; the four planks are what make it a recommendation.
- **Burying the risks.** If you would not say it to the client's face, lead with it, not footnote it.
- **Writing to a pre-chosen target.** Reverse-engineering the analysis to justify a price you already picked is advocacy, not research.
- **Forgetting suitability.** A right call for the wrong client is a wrong recommendation.
- **Acting on a whisper.** Material non-public information is a criminal exposure, never an edge — stop and escalate.

## Key takeaways

- A research note exists to drive a decision; lead with the thesis and structure for action.
- The four planks turn a value into a call: the gap, the catalyst, the risks, and your conviction.
- A recommendation is always to someone — apply the Nigerian suitability obligation from CLA-203 and the Operational Manual; the best-interest concept travels, but the binding rule is Nigerian.
- Stay inside conduct: no material non-public information under ISA 2025, conflicts disclosed under the Conflict of Interest Policy v3.0, and client priority absolute.
- Write to the house voice — clear, honest about uncertainty, and defensible out loud.

*Build mode: BUILD+SOURCE — a professional craft taught to the house style and anchored to a partial internal source. House style and voice: the Employee Handbook and the Internal Control Framework v3.0. Where this module touches firm mandates, the governing authorities are the Conflict of Interest Policy v3.0 and the Investment and Proprietary Trading Policy v3.0, with suitability per CLA-203 and the Operational Manual risk-profile process. The best-interest framing is the US SEC Regulation Best Interest concept (SEC-CONDUCT, GOV-PUBLIC) localized to the Nigerian suitability rule; current law: the Investments and Securities Act 2025. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row INV-203.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-203';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_01$id$, m.id, $p$A research note should be written so that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the call, target and conviction appear up front, then the reasoning"}, {"key": "b", "text": "the conclusion is revealed only on the last page"}, {"key": "c", "text": "there is no recommendation"}, {"key": "d", "text": "the risks are omitted"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Lead with the bottom line — a hurried reader should learn the call, target and conviction first, then read on for why.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_02$id$, m.id, $p$The four planks that turn a valuation into a recommendation are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "buy, hold, sell, target"}, {"key": "b", "text": "the gap between price and value, the catalyst, the risks, and conviction"}, {"key": "c", "text": "revenue, margin, growth, debt"}, {"key": "d", "text": "price, volume, sector, date"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$INV-202's bridge: a number becomes a call only with the gap, a catalyst, the risks, and your level of conviction.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_03$id$, m.id, $p$Why does a recommendation need a catalyst?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it does not"}, {"key": "b", "text": "to raise the target"}, {"key": "c", "text": "a cheap stock that stays cheap forever makes no one money — name what closes the gap and roughly when"}, {"key": "d", "text": "to avoid disclosing risk"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The catalyst is the event or trend expected to close the price-to-value gap; without one the call has no timeframe to act on.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_04$id$, m.id, $p$The Nigerian suitability obligation means a recommendation must fit the client's...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "favourite sector only"}, {"key": "b", "text": "nationality"}, {"key": "c", "text": "account number"}, {"key": "d", "text": "objectives, risk tolerance, horizon, liquidity needs and circumstances"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Suitability (per CLA-203, the SEC framework and the Operational Manual risk-profile process) requires the recommendation to fit the client's full profile.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_05$id$, m.id, $p$The same 'buy' is right for a growth institution but wrong for a capital-preservation retiree. This shows...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a recommendation is always to someone — suitability, not just the model, governs it"}, {"key": "b", "text": "the analysis was wrong"}, {"key": "c", "text": "retirees cannot be clients"}, {"key": "d", "text": "institutions need no suitability"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$However good the analysis, a recommendation must suit the specific client; a right call for the wrong client is a wrong recommendation.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_06$id$, m.id, $p$The best-interest concept in this module comes from US Regulation Best Interest, but the binding rule for Transworld is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "US Reg BI itself"}, {"key": "b", "text": "the Nigerian suitability and conduct set"}, {"key": "c", "text": "no rule at all"}, {"key": "d", "text": "the analyst's preference"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Concept travels, rules do not: teach and apply the Nigerian suitability and conduct rule, with Reg BI only as the conceptual framing.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_07$id$, m.id, $p$If you come to hold what looks like material non-public information, you should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "trade on it quickly"}, {"key": "b", "text": "write the note around it"}, {"key": "c", "text": "stop and escalate to Compliance"}, {"key": "d", "text": "share it with the client"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Under ISA 2025, acting or recommending on material non-public information is market abuse; stop and escalate rather than using it.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_08$id$, m.id, $p$Relevant conflicts — a personal holding, a banking relationship, a prop position — must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "concealed"}, {"key": "b", "text": "resolved by trading more"}, {"key": "c", "text": "ignored if small"}, {"key": "d", "text": "disclosed, per the Conflict of Interest Policy v3.0"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The COI Policy v3.0 requires relevant conflicts to be disclosed, and a research note discloses those that bear on it.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_09$id$, m.id, $p$Where the client's interest and the firm's proprietary book conflict...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client's interest comes first, absolutely"}, {"key": "b", "text": "the firm's book comes first"}, {"key": "c", "text": "it is a toss-up"}, {"key": "d", "text": "the larger position wins"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Client priority is absolute under the Investment and Proprietary Trading Policy v3.0; the recommendation reflects analysis, not the firm's own positions.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_10$id$, m.id, $p$A general research view to the desk versus a personal recommendation to a specific client...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "are identical acts"}, {"key": "b", "text": "differ — the personal recommendation carries the full suitability obligation"}, {"key": "c", "text": "are both unregulated"}, {"key": "d", "text": "never involve suitability"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Know which act you are performing; a recommendation to a named client requires their profile in front of you and carries suitability in full.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_11$id$, m.id, $p$Where should the risks that could prove you wrong appear in a note?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "buried in a footnote"}, {"key": "b", "text": "omitted to keep it positive"}, {"key": "c", "text": "stated plainly and near the top"}, {"key": "d", "text": "only if a client asks"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$If you would not say it to the client's face, lead with it; honest, prominent risk disclosure is part of the house voice.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_12$id$, m.id, $p$Conviction in a recommendation should translate into...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the font size"}, {"key": "b", "text": "the number of pages"}, {"key": "c", "text": "nothing"}, {"key": "d", "text": "the position size the call justifies"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Conviction is your confidence in the call, and it should map to how large a position the recommendation supports.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_13$id$, m.id, $p$'Writing to a pre-chosen target' — reverse-engineering analysis to justify a price you already picked — is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "advocacy, not research"}, {"key": "b", "text": "good discipline"}, {"key": "c", "text": "required by the house style"}, {"key": "d", "text": "the suitability test"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Starting from a desired target and working backward is advocacy; research forms the view first, then states the call.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_14$id$, m.id, $p$The 'bottom line up front' style means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "hiding the conclusion"}, {"key": "b", "text": "a reader learns your call, target and conviction in the first paragraph"}, {"key": "c", "text": "writing only a summary"}, {"key": "d", "text": "omitting valuation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Leading with the conclusion respects a busy reader and disciplines the writer to make the call explicit immediately.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_15$id$, m.id, $p$Saying explicitly 'what would change your mind' in a note matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it weakens the note"}, {"key": "b", "text": "regulators forbid it"}, {"key": "c", "text": "a call with no exit condition is an opinion, not analysis"}, {"key": "d", "text": "clients dislike it"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Naming the disconfirming evidence you are watching for turns an opinion into an auditable, falsifiable analytical call.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_16$id$, m.id, $p$Labeling, dating and signing a note matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is decorative"}, {"key": "b", "text": "it sets the price"}, {"key": "c", "text": "it replaces the analysis"}, {"key": "d", "text": "the note is a chain of reasoning a colleague, or a regulator, must be able to audit later"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A research note is auditable evidence of advice given; it must be attributable and time-stamped.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_17$id$, m.id, $p$A note that states a fair value but gives no recommendation has failed because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the reader cannot act on a value alone — the four planks make it actionable"}, {"key": "b", "text": "it is too long"}, {"key": "c", "text": "fair value is illegal"}, {"key": "d", "text": "it lacks a chart"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A number is not a call; without gap, catalyst, risks and conviction the PM or client has nothing to act on.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_18$id$, m.id, $p$Independence in research means the recommendation reflects...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sales pressure"}, {"key": "b", "text": "your analysis, not sales pressure or the firm's book"}, {"key": "c", "text": "the largest client's wishes"}, {"key": "d", "text": "the prop desk's position"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Independence requires the call to follow the analysis, insulated from sales targets and the firm's own positions.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_19$id$, m.id, $p$Suitability connects INV-203 back to which earlier module?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "FND-101"}, {"key": "b", "text": "OPS-202"}, {"key": "c", "text": "CLA-203, the suitability and risk-profile anchor"}, {"key": "d", "text": "PPL-201"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$CLA-203 established the Nigerian suitability obligation and the Operational Manual risk-profile process that INV-203 applies to recommendations.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv203_20$id$, m.id, $p$Acting on a market 'whisper' or rumour as if it were an edge is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "smart trading"}, {"key": "b", "text": "required diligence"}, {"key": "c", "text": "the house voice"}, {"key": "d", "text": "a path to material-non-public-information exposure and market abuse — not an edge"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A whisper is not analysis and may be MNPI; the disciplined response is public information, honest analysis, and escalation when in doubt.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'INV-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: INV-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'INV-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: INV-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: INV-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
