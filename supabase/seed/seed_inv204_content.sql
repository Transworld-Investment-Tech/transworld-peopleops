-- =============================================================================
-- seed_inv204_content.sql  (v0.65.0)
-- INV-204: Portfolio construction & management basics — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B) to the house style; localized to the Nigerian opportunity set + IPT Policy v3.0 / CLA-203 suitability. ESR v1.1 row INV-204.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row: the canonical role matrix already
--   maps INV-204 to live job profiles (Investment Analyst PUBLISHED + reserved roles;
--   confirm live: verify_p6.sql). Publish-only (the REG/OPS/CLA pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A single great stock pick is not a portfolio, and client money is never managed one idea at a time. When a client entrusts the firm with their savings, what they are buying is not your best idea — it is a whole, sensibly assembled collection of holdings that fits who they are. Portfolio construction is the discipline of building that collection on purpose. It is the least glamorous and most consequential part of investment management, because the decisions made here drive most of what the client actually experiences.

## What you will be able to do

1. Explain why diversification is the one genuinely free improvement in investing.
2. Reason in plain language about risk, return, correlation, and the idea of an efficient frontier.
3. Build an asset allocation across the Nigerian opportunity set.
4. Match a portfolio to a client's risk profile, building on the suitability discipline from CLA-203.
5. Run the ongoing disciplines — rebalancing and monitoring — inside the firm's conduct boundaries.

## Time horizon and the shape of risk over a life

Risk tolerance is not only a matter of temperament; it is a matter of time. A client with twenty years before they need the money can ride out a bad equity year and let the recovery come, so a long horizon supports a heavier weight in growth assets. A client who needs to draw the money next year cannot, because a sharp fall just before they spend it is a permanent loss, not a temporary one — so a short horizon pulls the allocation toward stability and liquidity. This is why the same person's portfolio should sensibly change shape as their horizon shortens: the heavy-equity mix that suited them at thirty is the wrong mix at sixty-five, and a good adviser revisits the allocation as the client moves through life rather than setting it once. Liquidity needs sit alongside horizon in the same way. Money the client may need at short notice has no business in a thinly traded NGX name that could take days to sell at a fair price; it belongs in cash or money-market holdings, even at the cost of some expected return, because the job of that slice of the portfolio is to be there when it is needed, not to maximize the headline yield.

## Why portfolios, not picks

There are two kinds of risk in any single holding. Some risk is specific to the company — a factory fire, a failed product, a fraud, a key customer lost. Some risk is common to the whole market — a rate rise, a devaluation, a recession, a policy shock. The specific risk is the one you can get rid of for free, simply by not putting all your money in one place. Combine holdings whose fortunes do not move in lockstep, and the bad surprises in one are offset by ordinary or good outcomes in the others; the specific risks partly cancel out while the expected return of the whole does not. That is why diversification is so often called the only free lunch in finance: it lowers risk without a matching cut in expected return.

What diversification cannot remove is the market risk that moves everything together — and that residual is precisely the risk the client is genuinely paid to bear. This distinction does real work in practice. It tells you that adding the twentieth bank stock to a portfolio already full of banks does almost nothing, because their specific risks are correlated, while adding an asset that behaves differently — a government bond, a different sector — actually reduces risk. Diversification is not "owning a lot of things"; it is owning things that do not all suffer at the same time.

## Risk, return and the frontier

Three ideas carry the whole subject, and you can hold them without any mathematics. The first is that return and risk travel together: a higher expected return is the compensation for accepting a wider range of possible outcomes, and any claim of high return with no risk should be treated as either a misunderstanding or a fraud. The second is correlation — how closely two assets move together — which is the lever diversification pulls; assets that move differently combine into a smoother whole, and the lower their correlation, the greater the benefit of holding both. The third is the efficient frontier: the intuition that for any level of risk a client is willing to take, there is a best achievable expected return, and a well-built portfolio sits on or near that line rather than below it. A portfolio that takes a lot of risk for a mediocre return is sitting below the frontier, and the analyst's job is to move it back up. You will not derive the frontier on the desk, but you should be able to explain to a client, in plain words, why a sensible mix of assets beats betting everything on the one asset with the highest headline return.

## The Nigerian opportunity set

Theory is universal; the menu is local, and the menu is what you actually allocate across. NGX-listed equities offer growth and the highest long-run expected return, with real volatility and liquidity that varies sharply between the most-traded names and the thinly traded ones — a point that matters when a client may need to sell. Federal Government of Nigeria bonds and treasury bills are the naira anchor, the closest thing to a risk-free instrument in the set; even so, in a high-inflation year their real return can be thin or negative despite a healthy nominal yield, and an honest adviser says so rather than presenting the headline rate as a sure gain. Corporate bonds add yield for credit risk, money-market funds provide liquidity and capital stability for near-term needs, and collective investment schemes give a client diversified exposure in a single holding. Offshore exposure exists but only within regulatory limits. The central lesson of portfolio theory holds here as everywhere: the asset-allocation decision — how much sits in equities versus fixed income versus cash — drives far more of the eventual outcome than the choice of any individual security within those buckets.

## Matching the portfolio to the client

This is where CLA-203 comes back in. A portfolio is built for a specific client, not lifted from a single house model and pressed onto everyone who walks through the door. The suitability inputs are exactly the ones the risk-profile process captures: objectives, risk tolerance, time horizon, liquidity needs and any constraints the client sets. A capital-preservation retiree who needs income next year and a thirty-year-old saving for a goal two decades away should not hold the same allocation, even if both are told the equity market looks attractive, because their capacity and willingness to bear a bad year are completely different. The allocation is the expression of the profile; when the profile and the portfolio disagree, it is the portfolio that is wrong, however clever its individual components. Documenting that link — recording why this allocation fits this client — is both good practice and the evidence the firm relies on if the recommendation is ever questioned.

## Managing it over time

A portfolio is not set once and forgotten. As prices move, the weights drift away from the targets you chose — a strong equity run quietly turns a balanced portfolio into an aggressive one without anyone deciding to take more risk. Rebalancing brings it back to target, and it has a useful built-in discipline: to return to target you trim what has run hot and add to what has lagged, a systematic sell-high, buy-low behaviour that runs against the human instinct to chase winners. Around that sits ongoing monitoring against the client's goals and any change in their circumstances — a new dependant, a changed time horizon, a shift in risk appetite — each of which can require the allocation to be revisited.

Over all of it sits the conduct boundary. Client portfolios are not the proprietary book; the Investment and Proprietary Trading Policy v3.0 keeps the two firmly apart, the client's interest comes first absolutely, and where a single trade is allocated across several client accounts it must be allocated fairly — no cherry-picking the good fills for favoured accounts, and never trading the firm's or staff's own positions ahead of the client. Sound portfolio management is as much a conduct discipline as an analytical one. The same discipline applies to how often you trade: needless turnover generates costs and, where the firm earns on transactions, can shade into churning a client's account for the firm's benefit, which the client-priority rule forbids outright. The well-managed portfolio is traded when the allocation or the client's circumstances call for it, not for the sake of activity.

## A worked example

**Illustration — a balanced naira portfolio for "Mr Adewale" (entirely hypothetical).** The client and figures are invented for teaching. Mr Adewale is fifty, with a ten-year horizon and a moderate risk tolerance: comfortable with some volatility in pursuit of growth, but not willing to risk his capital heavily. His profile points to a balanced allocation — illustratively, a little under half in a diversified basket of NGX equities for growth, a substantial allocation to FGN bonds and treasury bills for stability and income, and a slice in a money-market fund for liquidity and any near-term needs. The equity portion is itself diversified across sectors rather than concentrated in one or two names, so a bad year in one industry does not sink the whole. The portfolio is reviewed and rebalanced to those targets annually, which trims whatever has run ahead and tops up whatever has lagged; the suitability assessment that justifies the mix is documented; and the whole is kept entirely separate from any proprietary position. The allocation was chosen to fit Mr Adewale, not to chase the highest possible return — which is the entire point.

## Common traps

- **Confusing a portfolio with a pile of favourite stocks.** A collection of your best ideas in one sector is concentration, not diversification.
- **Chasing last year's winners.** Buying what has already run is the opposite of the rebalancing discipline.
- **Home bias and single-name concentration.** Over-weighting one familiar NGX name, and ignoring how thinly some names trade, reintroduces the specific risk you were paid to remove.
- **Imposing one house allocation on every client.** A model portfolio that ignores the individual profile is a suitability failure.
- **Blurring client portfolios with the prop book.** The two are kept apart on purpose, and client priority is absolute.

## Key takeaways

- Diversification is the only free lunch — combine assets that do not move together to shed specific risk without sacrificing expected return.
- Asset allocation across the Nigerian opportunity set drives most of the risk-return outcome, more than individual security selection.
- The efficient-frontier intuition: for any level of risk a client accepts, there is a best achievable return — aim for it.
- Build the portfolio for the client using the CLA-203 suitability inputs, not a one-size house model.
- Rebalance and monitor with discipline, inside the conduct boundaries — client priority is absolute, allocation is fair, and client money is never the proprietary book.

*Build mode: BUILD — a general professional craft taught to the house style; this module teaches no binding Transworld policy. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: MIT OpenCourseWare 15.401 Finance Theory I (OPEN-ADAPT, CC BY-NC-SA) for portfolio theory, supported by Aswath Damodaran, NYU Stern (OPEN-ADAPT) for the asset-allocation framing, localized to the Nigerian opportunity set and the firm's advisory boundaries. Where this module touches firm mandates, the governing authorities are the Investment and Proprietary Trading Policy v3.0 and the suitability discipline of CLA-203. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row INV-204.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-204';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_01$id$, m.id, $p$Diversification is called 'the only free lunch' because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "lowers risk without a matching cut in expected return"}, {"key": "b", "text": "guarantees a profit"}, {"key": "c", "text": "removes all risk"}, {"key": "d", "text": "raises returns with no downside"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Combining holdings that do not move together cancels specific risk while expected return is broadly preserved — risk reduced for free.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_02$id$, m.id, $p$Which risk can diversification NOT remove?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a single factory fire"}, {"key": "b", "text": "market risk that moves everything together"}, {"key": "c", "text": "one company's fraud"}, {"key": "d", "text": "a failed product at one firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Diversification sheds company-specific risk; the residual market risk that moves everything is the risk the client is paid to bear.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_03$id$, m.id, $p$Correlation matters to portfolio construction because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it sets the share price"}, {"key": "b", "text": "it is the discount rate"}, {"key": "c", "text": "assets that move differently combine into a smoother whole"}, {"key": "d", "text": "it has no effect"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Correlation — how closely assets move together — is the lever diversification pulls; low correlation smooths the combined outcome.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_04$id$, m.id, $p$The 'efficient frontier' intuition is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the highest-return asset is always best"}, {"key": "b", "text": "risk and return are unrelated"}, {"key": "c", "text": "cash is always optimal"}, {"key": "d", "text": "for any level of risk a client accepts, there is a best achievable expected return"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The frontier captures the best return achievable at each level of risk; a good portfolio sits on or near it, not below.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_05$id$, m.id, $p$Which decision drives most of a portfolio's risk-return outcome?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the asset-allocation decision across equities, fixed income and cash"}, {"key": "b", "text": "the choice of a single stock"}, {"key": "c", "text": "the brokerage used"}, {"key": "d", "text": "the day of the week traded"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Portfolio theory and practice agree: asset allocation matters far more to the outcome than individual security selection.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_06$id$, m.id, $p$In the Nigerian opportunity set, the closest thing to a naira 'risk-free' anchor is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "NGX small-cap equities"}, {"key": "b", "text": "FGN bonds and treasury bills"}, {"key": "c", "text": "a single corporate bond"}, {"key": "d", "text": "offshore equities"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Federal Government of Nigeria bonds and treasury bills are the naira anchor — though their real return can be thin in a high-inflation year.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_07$id$, m.id, $p$An honest adviser notes that FGN treasury bills in a high-inflation year may...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "always beat inflation"}, {"key": "b", "text": "carry equity-level risk"}, {"key": "c", "text": "deliver a thin or negative real return despite a positive nominal yield"}, {"key": "d", "text": "be unavailable to clients"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A positive nominal yield can still be a poor real return when inflation is high — a point suitability-minded advice raises.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_08$id$, m.id, $p$A portfolio is built for...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the house's single model applied to everyone"}, {"key": "b", "text": "the analyst's own preferences"}, {"key": "c", "text": "whichever stock is hottest"}, {"key": "d", "text": "the specific client's objectives, risk tolerance, horizon and liquidity needs"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The allocation expresses the client's profile (CLA-203 suitability inputs); one-size-fits-all is a suitability failure.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_09$id$, m.id, $p$When a client's profile and their portfolio disagree, the correct conclusion is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the portfolio is wrong, however clever its components"}, {"key": "b", "text": "the profile is wrong"}, {"key": "c", "text": "ignore both"}, {"key": "d", "text": "raise the equity weight"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The portfolio exists to express the profile; if they disagree, the portfolio must change to fit the client.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_10$id$, m.id, $p$Rebalancing a drifted portfolio back to its targets has the effect of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "buying more of what has run hot"}, {"key": "b", "text": "trimming what has run hot and adding to what has lagged — a sell-high, buy-low discipline"}, {"key": "c", "text": "chasing last year's winners"}, {"key": "d", "text": "abandoning the targets"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Bringing weights back to target sells the outperformers and buys the laggards, an automatic counter-cyclical discipline.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_11$id$, m.id, $p$Client portfolios and the firm's proprietary book must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "managed together for efficiency"}, {"key": "b", "text": "netted against each other"}, {"key": "c", "text": "kept firmly apart, with client priority absolute"}, {"key": "d", "text": "merged at year-end"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Investment and Proprietary Trading Policy v3.0 keeps client portfolios separate from the prop book; client priority is absolute.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_12$id$, m.id, $p$Allocating a block trade across several client accounts must be done...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "to favour the largest client"}, {"key": "b", "text": "after the firm's own account is filled"}, {"key": "c", "text": "randomly with no record"}, {"key": "d", "text": "fairly — no cherry-picking the best fills for favoured accounts"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Fair allocation forbids cherry-picking fills and front-running; client accounts are treated even-handedly.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_13$id$, m.id, $p$'Chasing last year's winners' is a trap because it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the opposite of rebalancing — buying what has already run"}, {"key": "b", "text": "the rebalancing discipline"}, {"key": "c", "text": "required by suitability"}, {"key": "d", "text": "how diversification works"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Return-chasing buys assets after they have appreciated, the reverse of the trim-the-hot, add-to-the-cold rebalancing discipline.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_14$id$, m.id, $p$Over-weighting one familiar NGX name reintroduces...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "market risk only"}, {"key": "b", "text": "the company-specific risk that diversification was meant to remove"}, {"key": "c", "text": "no risk"}, {"key": "d", "text": "the risk-free rate"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Home bias and single-name concentration bring back the idiosyncratic risk a diversified portfolio is built to shed.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_15$id$, m.id, $p$A collection of an analyst's ten favourite tech-sector stocks is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a well-diversified portfolio"}, {"key": "b", "text": "the efficient frontier"}, {"key": "c", "text": "concentration risk, not diversification"}, {"key": "d", "text": "a balanced allocation"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Many holdings in one sector are still concentrated; diversification needs assets whose fortunes do not move together.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_16$id$, m.id, $p$Mr Adewale (50, ten-year horizon, moderate risk) is best served by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an all-equity, single-stock bet"}, {"key": "b", "text": "100% treasury bills"}, {"key": "c", "text": "whatever returned most last year"}, {"key": "d", "text": "a balanced allocation across diversified NGX equities, FGN bonds/T-bills and a money-market slice"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$His profile points to a balanced, diversified allocation chosen to fit him — not a concentrated bet or a return chase.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_17$id$, m.id, $p$Documenting the suitability assessment behind a portfolio matters because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is the evidence the allocation was built for the client's profile"}, {"key": "b", "text": "is optional decoration"}, {"key": "c", "text": "sets the share price"}, {"key": "d", "text": "replaces rebalancing"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The documented suitability assessment is the auditable evidence that the portfolio expresses the client's profile.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_18$id$, m.id, $p$Asset allocation versus security selection — the larger driver of outcomes is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "security selection"}, {"key": "b", "text": "asset allocation"}, {"key": "c", "text": "neither — only luck"}, {"key": "d", "text": "the brokerage fee"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$How much sits in each asset class drives far more of the risk-return result than which individual securities are chosen within them.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_19$id$, m.id, $p$The conduct overlay on managing client portfolios includes...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "trading the firm's positions ahead of the client"}, {"key": "b", "text": "cherry-picking good fills"}, {"key": "c", "text": "client priority, fair allocation, and separation from the prop book"}, {"key": "d", "text": "ignoring the client's circumstances"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Ongoing management sits inside the conduct boundary: client first, allocations fair, and client money never the proprietary book.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv204_20$id$, m.id, $p$The central lesson of portfolio theory for the Nigerian opportunity set is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "pick one great stock and hold it"}, {"key": "b", "text": "cash always wins"}, {"key": "c", "text": "correlation can be ignored"}, {"key": "d", "text": "a sensible, diversified allocation beats betting everything on the highest-headline-return asset"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Theory is universal even if the menu is local: a diversified allocation across the Nigerian set beats a concentrated high-return bet.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'INV-204';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: INV-204 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'INV-204' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: INV-204 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: INV-204 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
