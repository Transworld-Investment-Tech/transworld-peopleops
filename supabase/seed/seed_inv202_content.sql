-- =============================================================================
-- seed_inv202_content.sql  (v0.65.0)
-- INV-202: Valuation methods & building a research model — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B); body is the canonical worked exemplar; questions rendered to the live SINGLE-MCQ format. ESR v1.1 row INV-202.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row: the canonical role matrix already
--   maps INV-202 to live job profiles (Investment Analyst PUBLISHED + reserved roles;
--   confirm live: verify_p6.sql). Publish-only (the REG/OPS/CLA pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$It is a few minutes before the market opens in Lagos. A portfolio manager pulls up your research note on a listed company, reads your number, and decides whether to commit real client money — or hold it back. That is what a valuation is for. It is not an academic exercise and it is not a spreadsheet for its own sake. It is the document on which someone acts.

The market hands you a price every second of every trading day. A valuation is something different: your own independent estimate of what the business is worth, formed deliberately enough that you would act on the gap between the two. If your value simply tracks the price, you have added nothing. The whole point is to know when the market is wrong, and by how much. Because the number has consequences, we hold it to a standard at Transworld: every figure you publish must trace back to an assumption, and every assumption must be one you can defend out loud, to a client, without flinching. Value is not discovered, it is estimated — the goal is never the illusion of precision; it is an honest range you understand well enough to stand behind.

## What you will be able to do

1. Explain the three families of valuation and judge when each one earns its place.
2. Walk a discounted-cash-flow valuation through its five honest steps, naming the assumption doing the heavy lifting at each one.
3. Keep a valuation internally consistent in a high-inflation naira environment, and price in country risk.
4. Read a set of trading multiples without being fooled by them.
5. Lay out a research model a colleague can pick up cold — and carry its number toward a defensible recommendation.

## Three roads to value

There are three broad ways to value a company, and a serious analyst chooses deliberately rather than by habit.

Intrinsic value is the honest road: what is the business worth, based on the cash it can be expected to generate over its life? This is discounted cash flow. It is the slow and most demanding road, because it forces you to take a view on the future, but it is the only method that values the company itself rather than the mood of the market around it.

Relative value is the fast road: what is the market paying today for companies like this one? This is valuation by multiples — price-to-earnings, enterprise-value-to-EBITDA, price-to-book. It is quick and grounded in real prices, but it borrows the market's current mood, including its mistakes. If every comparable firm is overpriced, your "fairly valued" company is overpriced too.

Contingent value is the rare road: some assets are worth something mainly because of optionality — a mineral licence not yet mined, undeveloped land. Their value behaves like a financial option. You will reach for this rarely, but knowing it exists keeps you from forcing a DCF onto an asset that does not fit it. The craft is in the triangulation: anchor on an intrinsic estimate and sanity-check it against multiples, and when the two roads disagree, do not paper over the gap — that gap is often the most interesting thing you will write.

## Intrinsic value in five honest steps

A discounted cash flow can look intimidating in a spreadsheet. Underneath, it is five questions asked in order, and at each step one assumption does most of the work — learn to spot it, because that is where your scrutiny belongs.

First, forecast the cash flows. Decide first whose cash you are valuing. Free cash flow to the firm is the cash available to everyone who funded the business, debt and equity alike; free cash flow to equity is what is left for shareholders after lenders are paid. The choice dictates everything downstream, so do not mix it. The load-bearing assumption here is revenue growth and operating margin — the top of the model drives all that follows.

Second, decide how fast it grows, and why. Growth is not a wish; it is bought with reinvestment. Loosely, growth equals how much of its profit a firm reinvests multiplied by the return it earns on that investment. A company growing quickly while investing almost nothing should make you suspicious, and no firm out-grows its economy forever — so fade the rate toward a mature level. The load-bearing assumption is the growth rate and how it fades.

Third, choose the discount rate. Money in the future is worth less than money today, and riskier futures are worth less still. The cost of equity builds up from a risk-free rate plus the stock's sensitivity to the market times an equity risk premium; the weighted-average cost of capital blends that with the after-tax cost of debt by weight. Match the rate to the cash flow: free cash flow to the firm is discounted at the weighted-average cost of capital to give enterprise value; free cash flow to equity is discounted at the cost of equity to give equity value. The load-bearing assumption is the risk premium.

Fourth, estimate the terminal value. You cannot forecast forever, so you capture everything beyond your explicit horizon in one figure — either a perpetuity-growth calculation or an exit multiple applied to a mature year. Keep any assumed perpetual growth at or below the long-run nominal growth of the economy. The terminal value is often the majority of the answer, which is exactly why it is dangerous; the load-bearing assumption is the terminal growth rate.

Fifth, cross-check and stress it. Change your key inputs one at a time and watch the answer move. If a one-percent shift in the discount rate swings your value by forty percent, you do not have a valuation — you have a guess wearing a suit, and you must say so in the note. This step has no load-bearing assumption of its own; it exists to expose the others.

## Valuing in naira: currency and country risk

This is where models built for other markets quietly break. The cardinal rule is consistency: if your cash flows are in naira, discount them at a naira rate that already embeds naira inflation; if you build in dollars, project dollar cash flows and discount at a dollar rate. Never put naira cash flows over a dollar discount rate. In a high-inflation environment nominal growth and nominal discount rates rise together — keep them moving in step, or the valuation drifts.

Country risk is the second adjustment. A naira investment carries risks a comparable US one does not, so the cost of equity should carry a country risk premium on top of the mature-market premium, sized from the sovereign's borrowing spread or the relative volatility of the local market. Skip it and you will systematically overvalue, pricing a Lagos company as if it sat in a low-risk economy. Most borrowed templates fail precisely here, by importing a foreign discount rate onto local cash flows, and the failure is invisible until someone asks why your "cheap" stock is cheap.

## Relative valuation without getting fooled

Multiples are seductive because they are fast and feel objective. They are neither as simple nor as objective as they look. Before you trust any multiple, ask three questions. Comparable to what? A multiple is only as good as its peer group, and firms in one industry differ wildly in growth, risk and profitability — the very things that justify a higher or lower multiple. Driven by what? Every multiple has a fundamental engine — price-to-earnings by growth and risk, enterprise-value-to-EBITDA by margins and reinvestment, price-to-book by return on equity — and if you cannot name the driver, you are guessing, not analyzing. Telling what story? Enterprise-value-to-EBITDA strips out financing and tax to compare operating businesses on a like footing, useful when two firms carry very different debt; price-to-book suits asset-heavy firms like banks; price-to-earnings is familiar but distorted by leverage and one-off items.

A caution for our market: comparable sets on the NGX are often thin, and some peers trade rarely enough that their last price is stale. When the local set is too weak to trust, you have three honest options — use the company's own historical multiple range as the benchmark, take a global sector multiple and adjust it down for country risk and growth differences, or relate the multiple to its fundamental driver directly. Whichever you choose, disclose the adjustment in the note rather than burying it.

## Building the model so a colleague can follow it

A model is not for you alone. It will be reviewed, reused and updated by someone who was not in your head when you built it, so build it so they can follow it cold.

Lay it out in one direction — inputs, then engine, then outputs. Keep assumptions on their own tab, feed them into the calculation engine, and surface results on a clean output sheet; never tangle the three, because when inputs and formulas share the same cells no reviewer can tell what you assumed from what you computed. The three statements feed one engine, and in a sound model they tie and reconcile. Watch for the one place they bite back: circularity. Interest expense depends on debt, debt depends on the cash you have, cash depends on net income, and net income depends on interest — a loop. Handle it deliberately, with an iterative-calculation switch or a simple average-debt convention; never let a silent circular reference decide your valuation for you.

Follow the house colour convention without exception: blue for inputs you typed, black for formulas, green for links that pull from another sheet. A reviewer should see in seconds what is assumption and what is arithmetic, and no hard-coded number should hide inside a formula — every assumption lives on the assumptions tab, named and sourced. Build the stress test in from the start: give every model a bear, base and bull case and a sensitivity table on the two inputs that actually move the answer, usually growth and the discount rate. A valuation that produces a single confident number and no range is hiding its uncertainty rather than measuring it. Then label everything, date it, and put your name on it — a model is a chain of reasoning someone else must be able to audit.

## A worked example

**Illustration — "Lagos Staples Plc" (entirely hypothetical).** The company and every figure are invented for teaching; this is not a recommendation. Lagos Staples is a consumer-goods maker with revenue of ₦80 billion. We project revenue growing 12% next year, fading to 4% by year five, on an operating margin near 15%. Because the cash flows are in naira, we discount them at a naira weighted-average cost of capital of 18% — a rate that already embeds naira inflation and a country risk premium for Nigeria. Beyond year five we assume cash flows grow forever at 4%, comfortably below long-run nominal economic growth. Discounting the five forecast years and adding a terminal value gives an illustrative enterprise value; net off debt and divide by shares to reach a per-share estimate. Then sanity-check the implied EV/EBITDA against peers. Notice what carried the answer: the growth path and the 18% discount rate — which is exactly why those two inputs get the hardest scrutiny and a sensitivity table of their own.

## From model to recommendation

A valuation answers "what is it worth?" A recommendation answers a harder question: "what should we do, and why now?" The bridge has four planks — the gap between price and value, the catalyst that might close it, the risks that could prove you wrong, and your level of conviction. A number alone is not a call. The note that carries the call is the subject of the next module, INV-203.

## Common traps

- **False precision.** A target of ₦47.38 implies a confidence no honest valuation has; publish a range.
- **Garbage in.** A beautiful model on bad inputs is a beautiful wrong answer; the elegance hides the error.
- **Currency mismatch.** Naira cash flows over a dollar discount rate is the most common way a borrowed model misvalues a local company.
- **Anchoring to price.** Reverse-engineering assumptions until your value matches today's price is describing the market back to itself, not valuing.
- **The terminal tail wagging the dog.** When most of the value sits beyond the forecast horizon, your real bet is one perpetual-growth assumption — test it hard.
- **Double-counting risk.** Cutting the cash flows for a risk and also raising the discount rate for the same risk charges twice.

## Key takeaways

- Anchor on intrinsic value, sanity-check with multiples, and let the gap between them be your story.
- Match the discount rate to the cash flow and keep currency consistent — naira cash flows, naira rate, country risk priced in.
- Make every assumption visible and defensible; scrutinize the two that move the answer most — growth and the discount rate.
- Keep inputs, engine and outputs separate, colour-code by the house convention, and tame circularity on purpose.
- Publish a range, not a false point; honesty about uncertainty is a feature, not a weakness.

*Build mode: BUILD — a general professional craft taught to the house style; this module teaches no binding Transworld policy. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: Aswath Damodaran, NYU Stern (OPEN-ADAPT), supported by MIT OpenCourseWare 15.401 Finance Theory I (OPEN-ADAPT, CC BY-NC-SA) and, for a data lab, the SEC EDGAR APIs (GOV-PUBLIC). Authored original to the house voice; no text reproduced from any source. Reviewed by: Head of Research (functional accuracy). See External Source Register v1.1, row INV-202.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-202';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_01$id$, m.id, $p$A colleague says 'the DCF gave us exactly ₦52.40, so that is what the stock is worth.' The best correction is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "value is an estimate, not a discovered fact; reframe it as a defensible range"}, {"key": "b", "text": "agree — the model is precise"}, {"key": "c", "text": "raise the discount rate until it matches price"}, {"key": "d", "text": "delete the model"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Value is estimated, not discovered; the honest output is a range you can defend, never a false point of precision.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_02$id$, m.id, $p$You value a firm using free cash flow to the firm. Which discount rate, and what does it give?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "cost of equity, giving equity value"}, {"key": "b", "text": "the weighted-average cost of capital, giving enterprise value"}, {"key": "c", "text": "the risk-free rate, giving book value"}, {"key": "d", "text": "any rate — it does not matter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$FCFF is discounted at WACC to give enterprise value; FCFE is discounted at the cost of equity to give equity value — never mix them.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_03$id$, m.id, $p$A model shows 18% revenue growth for five years with reinvestment near zero. This should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "reassure you"}, {"key": "b", "text": "be ignored"}, {"key": "c", "text": "make you uneasy — growth is bought with reinvestment"}, {"key": "d", "text": "raise the terminal value automatically"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Growth is funded by reinvestment; fast growth with almost no investment is internally inconsistent and a warning sign.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_04$id$, m.id, $p$Building the cost of equity for a Lagos-listed company, which component would you add that you might omit for a US firm?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "nothing different"}, {"key": "b", "text": "a lower risk-free rate"}, {"key": "c", "text": "a negative premium"}, {"key": "d", "text": "a country (Nigeria) risk premium"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A naira investment carries country risk a comparable US one does not; add a country risk premium or you will systematically overvalue.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_05$id$, m.id, $p$An analyst discounts naira cash flows with a US-dollar WACC of 9%. The likely effect is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "systematic overvaluation from a currency/inflation mismatch"}, {"key": "b", "text": "a correct valuation"}, {"key": "c", "text": "undervaluation only"}, {"key": "d", "text": "no effect"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Naira cash flows embed naira inflation; discounting them at a low dollar rate mismatches inflation and overstates value — the classic borrowed-model error.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_06$id$, m.id, $p$Why must terminal growth stay at or below the long-run nominal growth of the economy?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it need not — any number works"}, {"key": "b", "text": "otherwise the firm eventually out-grows the whole economy, which is impossible"}, {"key": "c", "text": "to lower the discount rate"}, {"key": "d", "text": "to match the share price"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A perpetual growth rate above the economy implies the firm becomes larger than the economy — an impossibility that inflates the valuation.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_07$id$, m.id, $p$Terminal value is 85% of your total value. The lesson is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the forecast years matter most"}, {"key": "b", "text": "the model is automatically correct"}, {"key": "c", "text": "your scrutiny belongs on the terminal assumption — it is carrying the answer"}, {"key": "d", "text": "delete the terminal value"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$When most of the value sits beyond the horizon, the real bet is one perpetual-growth assumption, and that is where the hardest scrutiny goes.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_08$id$, m.id, $p$A one-percent rise in the discount rate cuts your value by 30%. Before publishing you should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "publish a single confident number"}, {"key": "b", "text": "hide the sensitivity"}, {"key": "c", "text": "anchor to today's price"}, {"key": "d", "text": "disclose the sensitivity and present a range"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$High sensitivity is not necessarily an error, but it must be disclosed and the value presented as a range, not a false point.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_09$id$, m.id, $p$Applying a US consumer-staples P/E of 22x to a faster-growing, higher-risk NGX firm is flawed because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the multiple was set by a deeper market with different growth and risk — adjust or disclose"}, {"key": "b", "text": "multiples never differ across markets"}, {"key": "c", "text": "P/E is always wrong"}, {"key": "d", "text": "NGX firms cannot be valued"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A multiple is only as good as its peer group; a foreign multiple must be adjusted for country risk and growth differences, or disclosed.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_10$id$, m.id, $p$Which fundamental mainly justifies EV/EBITDA?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "dividend yield"}, {"key": "b", "text": "operating margins and reinvestment"}, {"key": "c", "text": "the auditor's name"}, {"key": "d", "text": "the share count"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each multiple has an engine: P/E is driven by growth and risk, EV/EBITDA by margins and reinvestment, P/B by return on equity.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_11$id$, m.id, $p$Why is EV/EBITDA often preferred to P/E when two firms carry very different debt?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it ignores the companies"}, {"key": "b", "text": "it is always higher"}, {"key": "c", "text": "it strips out financing and tax to compare operating businesses on a like footing"}, {"key": "d", "text": "it requires no peer group"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$EV/EBITDA compares enterprise-level operating performance before financing, so it is fairer across firms with different leverage.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_12$id$, m.id, $p$Your intrinsic value is 40% above price, but multiples say roughly fairly valued. In the note you should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "hide one of the two"}, {"key": "b", "text": "average them silently"}, {"key": "c", "text": "anchor to price"}, {"key": "d", "text": "explain the disagreement — the gap is often the most interesting thing you write"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$When the intrinsic and relative roads disagree, do not paper over it; that gap is where your analysis and the market diverge.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_13$id$, m.id, $p$You find a hard-coded number inside a formula on the engine sheet. This is a problem because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "no reviewer can tell assumption from arithmetic — move it to the assumptions tab, named and sourced"}, {"key": "b", "text": "it speeds the model up"}, {"key": "c", "text": "it is required by the house convention"}, {"key": "d", "text": "it improves accuracy"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Every assumption must live on the assumptions tab; numbers buried in formulas break the inputs/engine/outputs discipline.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_14$id$, m.id, $p$The circularity in a three-statement model arises because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the model has no errors"}, {"key": "b", "text": "interest depends on debt, debt on cash, cash on net income, and net income on interest"}, {"key": "c", "text": "of currency mismatch only"}, {"key": "d", "text": "of the colour convention"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Interest expense, debt, cash and net income form a loop; handle it deliberately with iterative calculation or an average-debt convention.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_15$id$, m.id, $p$Under the house colour convention, green cells mean...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "inputs you typed"}, {"key": "b", "text": "formulas"}, {"key": "c", "text": "links that pull from another sheet"}, {"key": "d", "text": "errors"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Blue is typed inputs, black is formulas, green is links from another sheet — so a reviewer sees assumption versus arithmetic at a glance.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_16$id$, m.id, $p$The four planks that turn a valuation into a recommendation are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "price, volume, sector, date"}, {"key": "b", "text": "revenue, margin, growth, debt"}, {"key": "c", "text": "buy, hold, sell, target"}, {"key": "d", "text": "the gap, the catalyst, the risks, and your conviction"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A number alone is not a call; the bridge to a recommendation is the gap, a catalyst, the risks, and conviction.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_17$id$, m.id, $p$A polished model rests on a key revenue assumption from an unreliable source. The lesson is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "elegance hides the error — garbage in, beautiful wrong answer out"}, {"key": "b", "text": "polish fixes weak inputs"}, {"key": "c", "text": "sources do not matter"}, {"key": "d", "text": "never build models"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A beautiful model on bad inputs is a beautiful wrong answer; presentation cannot rescue a weak assumption — disclose and test it.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_18$id$, m.id, $p$When the local NGX comparable set is too thin to trust, an acceptable approach is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "invent peers"}, {"key": "b", "text": "use the company's own historical multiple range, or a country-risk-adjusted global multiple — and disclose it"}, {"key": "c", "text": "abandon valuation"}, {"key": "d", "text": "copy a US multiple unadjusted"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Thin local sets call for the firm's own historical range or an adjusted global multiple, with the adjustment disclosed rather than buried.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_19$id$, m.id, $p$Cutting cash flows for a risk and also raising the discount rate for the same risk is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "prudent"}, {"key": "b", "text": "required"}, {"key": "c", "text": "double-counting — charge each risk once"}, {"key": "d", "text": "impossible"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Each risk needs one home, in the cash flows or in the rate; charging it in both places double-counts and understates value.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv202_20$id$, m.id, $p$Why give every model a bear, base and bull case from the start?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "to produce one confident number"}, {"key": "b", "text": "to slow the work down"}, {"key": "c", "text": "the convention forbids it"}, {"key": "d", "text": "a single number hides uncertainty; the range measures it"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A valuation that produces a single confident number with no range is hiding its uncertainty rather than measuring it.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'INV-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: INV-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'INV-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: INV-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: INV-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
