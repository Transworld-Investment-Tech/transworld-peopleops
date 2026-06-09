-- =============================================================================
-- seed_fin202_content.sql  (v0.68.0)
-- FIN-202: Budgeting, forecasting & planning -- lesson + 20-question check (Proficient).
-- Authored FROM POLICY (Tier B). Binding source: Operational Manual v3.0 §29 (Budget
--   Preparation and Monitoring / Budget Process) + CAPEX rules; capital-adequacy framing.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: FIN-2xx role-targeted via canonical seed_ws7_role_matrix.sql
--   (publish-only; live Head of Finance + reserved finance/CFO profiles). CCO reviews post-publish.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A budget is the firm's financial plan written down before the year begins. It is one of the most important management tools the firm has, because it aligns resources with strategy, gives early warning when something is drifting, and keeps the firm operating within its means and within its regulatory capital requirements. A firm without a budget is flying without instruments — it discovers it has overspent only when the cash runs short. A firm with a well-prepared and actively monitored budget sees the problem coming a quarter ahead and has time to act. This module walks you through how Transworld builds its budget, who approves it, how it is monitored through the year, and the hard rules around spending that is not in the plan.

## What you will be able to do

1. Describe what the firm's annual budget covers and how the revenue line is forecast.
2. Explain the approval path — Management review, then Board approval before the financial year begins.
3. Apply the monthly and quarterly monitoring cycle and write a variance note that recommends action.
4. State the rule on unbudgeted spending and the discipline around capital expenditure.
5. Explain the mid-year review and the link between the budget and capital adequacy.

## What the annual budget covers

The annual budget is prepared to cover three things: projected income, operating expenses, and capital expenditure. For Transworld, projected income is dominated by brokerage commissions and advisory fees, with other smaller streams alongside. Operating expenses are the running costs of the firm — salaries, rent, technology, regulatory fees, professional services. Capital expenditure is spending on fixed assets that last beyond the year, such as systems and equipment. A budget that captures all three gives management a complete picture of where money is expected to come from and where it will go.

## Forecasting a market-driven revenue line

The hardest line to forecast is the top line, because brokerage commission is market-driven. When the NGX is active and clients are trading, commission income rises; when the market is quiet, it falls, and there is little the firm can do about the weather. The discipline, then, is to forecast conservatively and to think in scenarios — a base case, a soft case, and a strong case — so that the firm's cost commitments are sized against a realistic, not an optimistic, revenue picture. Advisory fees are somewhat steadier and can be planned against the firm's known mandate pipeline. The point of conservative forecasting is not pessimism; it is making sure the firm can meet its obligations even if the market disappoints. In practice you build the commission forecast from its drivers rather than guessing a single total: the expected level of market activity, the firm's share of it, the average commission rate, and any known wins or losses of significant clients. Building it this way means that when the actual number diverges, you can see which driver moved — was the whole market quieter, or did the firm's share slip — which is far more useful to management than a bare miss against a round number.

## The approval path

A budget is not real until it is approved. The firm's process is sequential: the budget is prepared, reviewed by Management, and approved by the Board before the start of the financial year. That sequence matters. Board approval before the year begins means the firm enters the year with an agreed plan and an agreed spending authority — nobody is improvising. Spending should not begin against a budget that has not yet been approved, because an unapproved budget is just a proposal.

## Monitoring through the year

A budget that is filed and forgotten is useless. The firm monitors it continuously: actual income and expenditure are compared against budget every month and every quarter. Where there are significant deviations, a variance report is prepared monthly that explains the deviation and recommends corrective action. A good variance note does three things — it states the size and direction of the variance, it explains the cause honestly, and it proposes what management should do, which may legitimately be nothing if the deviation was anticipated. Monitoring turns the budget from a static document into a live control that catches problems early.

## Spending that is not in the plan

The firm's rule on unbudgeted spending is strict and simple: no unbudgeted expenditure may be incurred without prior Management approval, documented in writing. The two parts both matter — the approval must be prior, not after the money is spent, and it must be in writing, not a corridor conversation. This is what stops a budget from quietly leaking through a hundred small unplanned outlays.

Capital expenditure carries its own discipline because the sums are larger and the assets last. Every capital request must be business-justified, included in the annual budget, and approved by Management before any purchase. No unbudgeted capital expenditure may be incurred without prior Management approval. So a capital item that was foreseen sits in the approved budget already; a capital item that arises unexpectedly must clear the prior-written-approval bar before anyone commits the firm.

## The mid-year review

Markets and circumstances change, so the firm does not treat the budget as frozen for twelve months. A formal budget review is conducted at mid-year, and revised projections are presented to Management and the Board. The mid-year review is the firm's chance to recognise reality — to revise the revenue forecast if the market has run hot or cold, to re-phase spending, and to confirm the firm is still within its means. It is not an excuse to abandon discipline; it is a structured, governed reset.

## The capital-adequacy link

Behind the whole budget sits the firm's obligation to maintain regulatory capital above its required floor. Budgeting is not only about profit — it is about ensuring that planned spending and any planned drawdowns never push the firm below its capital-adequacy requirement. A plan that would breach the capital floor is not a plan the firm can adopt, however attractive the growth it promises.

## Understanding variances

Monitoring is only as good as the way you read the variances, so it helps to think about them in two dimensions. The first is direction: a variance is favourable when actual results are better than budget — income higher, or costs lower — and adverse when they are worse. Favourable is not automatically good news and adverse is not automatically bad; a favourable cost variance caused by deferring necessary maintenance is storing up a problem, and an adverse revenue variance caused by a quiet market may need no action at all. The second dimension is cause: a revenue shortfall can come from lower volume (fewer trades) or lower price (thinner margins), and the response differs depending on which it is. Above all, separate the controllable from the uncontrollable. The firm cannot control whether the NGX is busy, but it can control whether it overspends into a soft market. A good variance note names the direction, isolates the cause, distinguishes what the firm can influence from what it cannot, and recommends action proportionate to all three.

## The planning cadence

Budgeting is an annual event with a rhythm, not a single late-year scramble. Preparation begins well before the financial year, drawing on the firm's strategy and the current year's actuals; departments contribute their expected income and costs; the draft is consolidated, challenged, and refined; Management reviews it; and the Board approves it before the year begins. Through the year the budget is monitored monthly and quarterly, the mid-year review provides a governed reset, and the cycle then feeds the next year's preparation. Treating budgeting as a continuous discipline rather than a once-a-year form means each year's plan learns from the last, and the firm is never operating without an agreed financial map.

## Cash is not the same as profit

One subtlety repays attention: a firm can be profitable on paper and still run short of cash, because income and the receipt of income do not always arrive together, and large outflows can cluster. For that reason the budget is read alongside a view of cash — when money is expected in, when obligations fall due, and whether the firm will have enough liquid funds at each point to meet them. A capital expenditure that is fully justified and fully budgeted can still cause a cash pinch if it lands in a quiet month, which is exactly why timing, not just totals, belongs in the plan. Planning for cash, not only profit, is what keeps the firm comfortably solvent and within its capital floor across the year.

## A worked example (hypothetical)

Imagine you are helping build Transworld's budget for next year. On the revenue side you take a conservative base case for brokerage commissions, informed by this year's actuals and a soft view of market activity, and you add the advisory fees the firm can reasonably expect from its known mandate pipeline. On the cost side you build operating expenses line by line and you place one capital item — a planned systems upgrade — into the capital-expenditure section, business-justified, so that it is pre-approved when the time comes. Management reviews the draft, and the Board approves it before the financial year begins.

Two quarters in, brokerage volumes are running below the base case, and the monthly comparison shows commission income materially under budget. You write the variance note: the shortfall is market-driven, costs are tracking to plan, and you recommend deferring discretionary spend rather than cutting committed costs. Separately, an unplanned capital need appears — a server must be replaced sooner than expected. Because it was not in the budget, you do not let anyone order it on a verbal nod; the request goes up for prior Management approval in writing, is approved, and is documented. At mid-year, the formal review revises the revenue projection down to reflect the soft market and re-confirms the firm remains comfortably within its capital floor.

## Whose budget is it

A budget only works as a control if people treat it as their own commitment rather than a number imposed on them. The Board owns the budget in the sense that it approves the plan and holds Management accountable for delivering against it; Management owns the execution, reviewing the monthly comparison and acting on variances; and every budget-holder owns their line, expected to operate within it and to flag early when they cannot. This shared ownership is what turns an approved document into a living discipline. When a budget-holder sees a cost heading for an overrun, the right move is not to quietly absorb it elsewhere or to spend first and explain later, but to raise it through the variance process and, where it is genuinely unbudgeted, to seek the prior written Management approval the rules require. A budget that everyone treats as theirs catches problems early; a budget that no one owns leaks quietly until year-end.

## Common traps

- **Spending before Board approval.** The budget is a proposal until the Board approves it before the financial year; committing the firm earlier is improvising.
- **Incurring unbudgeted spend without prior written Management approval.** Both parts are required — prior, and in writing.
- **Treating the budget as a filing exercise.** A budget that is not monitored monthly and quarterly cannot warn you of anything.
- **Optimistic revenue forecasting.** Sizing costs against a hopeful top line is how a firm overcommits; forecast the commission line conservatively.
- **Skipping the mid-year review or using it to abandon discipline.** The review is a governed reset presented to Management and the Board, not a free pass.

## Key takeaways

- The annual budget covers projected income, operating expenses, and capital expenditure, and is built before the year begins.
- Forecast the market-driven commission line conservatively and in scenarios.
- The path is prepare, Management review, then Board approval before the financial year starts.
- Monitor monthly and quarterly, with a written variance note that explains deviations and recommends action.
- No unbudgeted spend — operating or capital — without prior written Management approval; review formally at mid-year; never breach the capital floor.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FIN-202';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_01$id$, m.id, $p$The firm's annual budget is built to cover...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "brokerage commissions only"}, {"key": "b", "text": "staff salaries only"}, {"key": "c", "text": "projected income, operating expenses, and capital expenditure"}, {"key": "d", "text": "client portfolios"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A complete budget captures income, operating expenses, and capital expenditure.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_02$id$, m.id, $p$Because brokerage commission income is market-driven, the firm should forecast it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "conservatively and in scenarios, so costs are sized against a realistic top line"}, {"key": "b", "text": "at the most optimistic level to motivate the desk"}, {"key": "c", "text": "by ignoring market conditions"}, {"key": "d", "text": "as a fixed, guaranteed amount"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Conservative, scenario-based forecasting keeps the firm able to meet obligations even if the market disappoints.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_03$id$, m.id, $p$The budget approval path at the firm is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "approved by a single officer with no review"}, {"key": "b", "text": "prepared, reviewed by Management, then approved by the Board before the financial year begins"}, {"key": "c", "text": "approved after the year ends"}, {"key": "d", "text": "approved by the external auditor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Board approval before the financial year means the firm enters the year with an agreed plan and spending authority.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_04$id$, m.id, $p$Spending against a budget that the Board has not yet approved is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully authorised"}, {"key": "b", "text": "required by policy"}, {"key": "c", "text": "encouraged to save time"}, {"key": "d", "text": "improvising — an unapproved budget is only a proposal"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Until Board approval, the budget is a proposal and confers no spending authority.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_05$id$, m.id, $p$Actual income and expenditure are compared against budget...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "monthly and quarterly, with a monthly variance report on significant deviations"}, {"key": "b", "text": "only at year-end"}, {"key": "c", "text": "never, once approved"}, {"key": "d", "text": "only when the auditor visits"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Continuous monthly/quarterly monitoring turns the budget into a live control.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_06$id$, m.id, $p$A good variance note...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "hides the deviation"}, {"key": "b", "text": "only states the number with no explanation"}, {"key": "c", "text": "states the variance, explains the cause honestly, and recommends action (which may be none if anticipated)"}, {"key": "d", "text": "always recommends emergency cost cuts"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Size and direction, honest cause, and a recommendation — sometimes correctly to do nothing.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_07$id$, m.id, $p$Unbudgeted expenditure may be incurred...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "freely, if it seems reasonable"}, {"key": "b", "text": "only with prior Management approval, documented in writing"}, {"key": "c", "text": "after the money is spent, with retrospective sign-off"}, {"key": "d", "text": "on a verbal agreement"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The approval must be prior and in writing — both parts matter.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_08$id$, m.id, $p$A foreseen capital item should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "bought without any approval"}, {"key": "b", "text": "hidden from the budget"}, {"key": "c", "text": "charged to a client"}, {"key": "d", "text": "business-justified and included in the annual budget, with Management approval before purchase"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Planned CAPEX sits in the approved budget, justified, and approved before purchase.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_09$id$, m.id, $p$An unplanned, urgent capital need that was not in the budget must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "clear prior written Management approval before the firm is committed"}, {"key": "b", "text": "be ordered immediately on a verbal nod"}, {"key": "c", "text": "be ignored"}, {"key": "d", "text": "be paid for from client funds"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$No unbudgeted CAPEX without prior Management approval; urgency does not waive the rule.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_10$id$, m.id, $p$The mid-year review is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an excuse to abandon budget discipline"}, {"key": "b", "text": "an informal chat with no output"}, {"key": "c", "text": "a formal, governed review with revised projections presented to Management and the Board"}, {"key": "d", "text": "a year-end audit"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The mid-year review is a structured reset, not a free pass.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_11$id$, m.id, $p$Behind the budget sits the firm's obligation to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "maximise borrowing"}, {"key": "b", "text": "keep regulatory capital above its required floor and operate within its means"}, {"key": "c", "text": "spend the entire budget regardless of income"}, {"key": "d", "text": "avoid all capital expenditure"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A plan that would breach the capital-adequacy floor cannot be adopted.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_12$id$, m.id, $p$The primary purpose of a budget, as a management tool, is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "impress the external auditor"}, {"key": "b", "text": "replace the firm's accounting records"}, {"key": "c", "text": "set staff bonuses"}, {"key": "d", "text": "align resources with strategy and give early warning of financial drift"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The budget aligns resources with strategy and warns of problems a quarter ahead.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_13$id$, m.id, $p$Operating expenses in the budget include items such as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "salaries, rent, technology, regulatory fees, and professional services"}, {"key": "b", "text": "client securities holdings"}, {"key": "c", "text": "suspicious-transaction reports"}, {"key": "d", "text": "the audited financial statements"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Operating expenses are the running costs of the firm.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_14$id$, m.id, $p$Advisory fees, compared with brokerage commissions, are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "entirely unforecastable"}, {"key": "b", "text": "always larger"}, {"key": "c", "text": "somewhat steadier and can be planned against the known mandate pipeline"}, {"key": "d", "text": "not part of income"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Advisory fees are more plannable than market-driven commission income.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_15$id$, m.id, $p$If, two quarters in, commission income is materially below the base case for market reasons, a sound recommendation is often to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "cut committed costs immediately and indiscriminately"}, {"key": "b", "text": "defer discretionary spend while explaining the market-driven shortfall in the variance note"}, {"key": "c", "text": "ignore the variance"}, {"key": "d", "text": "stop filing returns"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A market-driven shortfall calls for measured action — deferring discretionary spend, not panic cuts.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_16$id$, m.id, $p$The discipline that stops a budget leaking through many small unplanned outlays is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "abolishing the budget"}, {"key": "b", "text": "approving everything after the fact"}, {"key": "c", "text": "hiding small costs"}, {"key": "d", "text": "the prior-written-Management-approval requirement for any unbudgeted spend"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Prior written approval prevents quiet leakage through unplanned spending.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_17$id$, m.id, $p$Scenario thinking in revenue forecasting means building...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a base case, a soft case, and a strong case so cost commitments are sized realistically"}, {"key": "b", "text": "only the strongest possible case"}, {"key": "c", "text": "no forecast at all"}, {"key": "d", "text": "a single guaranteed figure"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Scenarios let the firm size commitments against a realistic, not hopeful, picture.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_18$id$, m.id, $p$A budget that is approved and then never monitored...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is the ideal approach"}, {"key": "b", "text": "automatically prevents overspending"}, {"key": "c", "text": "cannot warn management of anything and defeats the purpose"}, {"key": "d", "text": "satisfies the regulator"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Without monthly/quarterly monitoring the budget is a dead document.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_19$id$, m.id, $p$Capital expenditure differs from operating expenditure mainly in that it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "never approved"}, {"key": "b", "text": "spending on fixed assets that last beyond the year, carrying its own approval discipline"}, {"key": "c", "text": "the same as a salary"}, {"key": "d", "text": "charged to clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$CAPEX buys longer-lived assets and carries the business-justified, budgeted, pre-approved discipline.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin202_20$id$, m.id, $p$The unifying message of budgeting and planning is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "budgets are optional once written"}, {"key": "b", "text": "optimism should drive the numbers"}, {"key": "c", "text": "spending needs no approval"}, {"key": "d", "text": "a budget is a live, governed plan — built before the year, monitored through it, never breaching the capital floor"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The budget is a living control: prepared, Board-approved, monitored, reviewed mid-year, and always within capital limits.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'FIN-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: FIN-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FIN-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FIN-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: FIN-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
