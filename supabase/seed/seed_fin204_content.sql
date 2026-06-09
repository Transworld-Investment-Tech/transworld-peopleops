-- =============================================================================
-- seed_fin204_content.sql  (v0.68.0)
-- FIN-204: Tax & statutory compliance (PAYE, VAT, CIT) -- lesson + 20-question check (Proficient).
-- Authored BUILD+SOURCE (Tier B), CURRENCY-SENSITIVE. Source: WS6 (Compensation, Benefits &
--   Payroll) -- the firm's payroll/statutory framework, held-in-trust principle, compute->approve
--   ->remit->payslip->record cycle, segregation of duties. Current law WEB-VERIFIED at authoring
--   (June 2026): Nigeria Tax Act 2025 + Nigeria Tax Administration Act 2025 (effective 1 Jan 2026);
--   FIRS -> Nigeria Revenue Service (NRS); PAYE to the State IRS (LIRS in Lagos); PIT 0/15/18/21/23/25%;
--   first N800k 0%; rent relief 20% capped N500k (CRA abolished); pension 8%/10%; NHF 2.5%;
--   VAT 7.5% retained; CIT 30% (reducible to 25%), small-co 0% (<=N50m turnover & <=N250m assets)
--   with professional/financial-services firms excluded; 4% development levy. The move from
--   PITA/CITA/VAT Act/FIRS is a real currency divergence from the source suite -> logged DF-11
--   (teach current law, no source edited). ISA-cover 'ISA 2024' -> DF-10.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: FIN-2xx role-targeted via canonical seed_ws7_role_matrix.sql
--   (publish-only; live Head of Finance + reserved finance/CFO profiles). CCO reviews post-publish.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Tax is non-negotiable. The firm has three big tax obligations — PAYE on its people, VAT on what it sells, and company income tax on its profits — alongside a set of statutory deductions it holds in trust for others. None of these bend for a hard month or a cash squeeze. And on the first of January 2026 the ground shifted: the Nigeria Tax Act 2025 and the Nigeria Tax Administration Act 2025 replaced the old, fragmented framework with a single, modern code, and the Federal Inland Revenue Service became the Nigeria Revenue Service (NRS). Anyone working with the firm's tax must be on the new law, not the old one. This module sets out the firm's three taxes, the statutory deductions, the held-in-trust principle that sits beneath them, and the firm's standing rule to confirm specific rates with its payroll and tax advisers as the law continues to settle.

## What you will be able to do

1. Describe the 2026 tax reset — the unified code, the NRS, and which authority collects which tax.
2. Apply the held-in-trust principle and the firm's compute-approve-remit-payslip-record cycle for PAYE.
3. State the headline PAYE structure and the statutory deductions, and where each is remitted.
4. Explain the firm's VAT and company-income-tax positions in outline, and the penalties for getting them wrong.
5. Recognise why this is currency-sensitive and apply the firm's confirm-with-advisers discipline.

## The 2026 reset

The reform consolidated the old separate statutes — personal income tax, companies income tax, value added tax, capital gains tax and others — into the Nigeria Tax Act, with the Nigeria Tax Administration Act setting how tax is administered. Two practical points matter most. First, the Federal Inland Revenue Service is now the Nigeria Revenue Service; federal taxes — company income tax, VAT, withholding tax, stamp duties — are filed with the NRS, and a Joint Revenue Board coordinates the federal and state authorities. Second, and crucially for payroll, PAYE personal income tax is still administered and remitted to the relevant State Internal Revenue Service — for a Lagos firm, that is the Lagos State Internal Revenue Service. The lesson is simple: federal taxes to the NRS, PAYE to the state.

## PAYE and the held-in-trust principle

PAYE is the firm's most constant tax touchpoint, because it runs every month with payroll. The principle beneath it is the one to hold onto: PAYE deducted from a staff member's salary is never the firm's money. It is the employee's tax, held in trust, and the firm's only job is to remit it accurately and on the statutory deadline. Late remittance is treated as a serious breach, and the new law carries stiffer penalties for employers who under-deduct or delay.

The firm's payroll cycle gives this principle its discipline: compute, approve, remit, payslip, record. Gross pay is computed, statutory deductions are calculated, the run is approved under segregation of duties so that the person preparing payroll is not the person who approves it, the deductions are remitted to the right authority by the deadline, payslips are issued, and the run, approvals, and remittance evidence are filed for audit and regulatory inspection. Individual pay data is access-restricted throughout — the rules of pay are open to everyone, but the amounts are private.

Under the new law the headline PAYE structure is more progressive. The first ₦800,000 of chargeable income is taxed at zero, and progressive rates of 15, 18, 21, 23 and 25 percent apply to the bands above it, to a top rate of 25 percent. The old consolidated relief allowance has been abolished and replaced by a rent relief of 20 percent of annual rent paid, capped at ₦500,000. Pension and housing-fund contributions remain deductible before tax. Earners at or below the national minimum wage fall outside the tax net entirely. You do not need to compute payroll by hand to a kobo — payroll software does that — but you do need to know that 2026 runs follow the new bands and the new relief, never the old method.

## The statutory deductions held alongside

Beyond PAYE, the firm holds and remits a set of statutory contributions, all on the same held-in-trust footing. Under the contributory pension regime the employee contributes a minimum of 8 percent and the employer a minimum of 10 percent of pensionable pay, remitted to the employee's pension fund administrator. The National Housing Fund contribution is 2.5 percent of basic salary where applicable. Employee compensation contributions to the relevant scheme and the industrial training levy apply where the firm meets the thresholds. Every one of these is deducted or accrued, held in trust, and remitted on time; late remittance of any of them is treated with the same seriousness as late PAYE.

## VAT in outline

Value added tax remains at 7.5 percent under the new law — a planned increase was dropped. The firm's taxable supplies, principally its brokerage commissions and advisory fees, attract output VAT, which the firm charges, collects, and remits to the NRS on the monthly VAT return; the firm can now recover input VAT on a broader range of its own business costs than before. The reform raised the small-business VAT threshold, exempting firms below a defined annual turnover, so whether the firm must charge VAT depends on its turnover band — a point for the Head of Finance to confirm. Essentials such as basic food, education and medical supplies are zero-rated, but that is not the firm's line of business.

## Company income tax in outline

Company income tax falls on the firm's profits. The standard rate is 30 percent, which the law allows to be reduced toward 25 percent by Presidential order on advice. The reform exempts small companies — those below a defined turnover with limited fixed assets — at a zero rate, but professional and financial-services firms are commonly placed outside that small-company exemption regardless of turnover, so the firm should not assume the zero rate applies to it; this is precisely the kind of question the Head of Finance confirms with the firm's tax advisers. A new development levy of 4 percent on assessable profits now replaces a cluster of older earmarked levies. CIT is filed annually on a self-assessment basis.

## Why this is currency-sensitive

Tax law in Nigeria has just been rewritten, and guidelines are still being issued. The firm's own framework is therefore deliberately principle-based: it commits to full, timely compliance and to confirming the specific rates and thresholds with its payroll and tax advisers as the law settles. Treat every figure in this module as current at the time of authoring and subject to confirmation each cycle — teach and apply the binding Nigerian rule, and verify the number before you rely on it. Nothing here is legal or tax advice; it is the firm's adopted approach.

## Withholding tax: the firm sits on both sides

Withholding tax is easy to overlook because the firm experiences it from two directions. When the firm makes certain payments — rent, professional fees, and similar — it is required to withhold a portion of the payment and remit that to the Nigeria Revenue Service on the payee's behalf; the firm is acting as a collection agent, and the amount withheld is held in trust just as PAYE is. When the firm is itself paid by some counterparties, those counterparties may withhold tax from what they pay the firm; that withheld amount is not lost — it is an advance payment of the firm's own tax and becomes a credit the firm sets against its company income tax. The practical discipline is to remit what the firm withholds on time, and to keep the credit notes for tax withheld from the firm so the advance credit is not forgotten when the annual return is filed.

## VAT, mechanically

VAT is a tax on consumption that the firm collects on the government's behalf, and the monthly mechanic is straightforward in shape. The firm charges output VAT at 7.5 percent on its taxable supplies — its commissions and advisory fees — and it pays input VAT on its own VAT-bearing costs. On the monthly return, the firm offsets the recoverable input VAT against the output VAT it has collected and remits the difference to the NRS; broadened input-VAT recovery under the new law means more of the firm's business costs now carry recoverable VAT than before. The firm never treats the output VAT it has collected as its own income — it is the government's money, passing through the firm, and remitting it late attracts the same penalties as any other late filing.

## Filing, evidence and digital administration

The new administration is digital-first. The Nigeria Revenue Service is moving filing, e-invoicing and verification online, and accurate tax identification numbers for the firm, its staff and its vendors matter more than ever, because the authority increasingly cross-references payroll, bank data and filings against one another. The penalties for getting the basics wrong are concrete: late filing of transaction taxes such as VAT and withholding tax attracts a fixed penalty for the first month of default and a further monthly penalty for each month it continues, on top of interest on unpaid tax. For the firm this reinforces the same habit that runs through this whole module — file on time, keep the evidence, and let the documentation prove compliance. Records of each run, approval and remittance are retained for audit and regulatory inspection precisely so the firm can demonstrate, not merely assert, that it has met its obligations.

## A worked example (hypothetical)

Imagine you are running Transworld's monthly payroll for an analyst. You start from gross pay, deduct the employee's 8 percent pension on pensionable pay and the housing-fund contribution, apply the rent relief the analyst is entitled to, and arrive at chargeable income; payroll software then applies the new bands — zero on the first slice, then the progressive rates — to produce the PAYE figure. You do not hold that PAYE as firm cash for a moment longer than necessary: it is remitted to the Lagos State Internal Revenue Service by the statutory deadline, the pension goes to the analyst's fund administrator, and you file the run, the approval, and the remittance evidence. Separately, the firm's monthly VAT return reports output VAT on the month's commissions to the NRS, net of recoverable input VAT, and once a year the firm files its company income tax return on self-assessment. At every step the discipline is the same: deduct correctly, remit on time, keep the evidence, and confirm any rate you are unsure of with the firm's advisers.

## Common traps

- **Treating PAYE or pension deductions as the firm's cash.** They are held in trust; spending them, or remitting late, is a serious breach with stiffer penalties under the new law.
- **Remitting PAYE to the wrong authority.** PAYE goes to the State Internal Revenue Service; CIT, VAT, WHT and stamp duties go to the NRS.
- **Using the old PITA method in 2026.** The consolidated relief allowance is gone; 2026 runs use the new bands and the rent relief.
- **Assuming the firm gets the small-company 0 percent CIT rate.** Professional and financial-services firms are commonly excluded — confirm with advisers, do not assume.
- **Relying on a remembered rate.** Tax is currency-sensitive and still settling; verify the figure each cycle rather than trusting memory.

## Key takeaways

- From 1 January 2026 the Nigeria Tax Act 2025 unified the code and the FIRS became the NRS; PAYE still goes to the State IRS, federal taxes to the NRS.
- PAYE and statutory deductions are held in trust — deduct correctly, remit on the deadline, keep the evidence; late remittance is a serious breach.
- The new PAYE structure exempts the first ₦800,000, runs to a 25 percent top rate, and replaces the consolidated relief allowance with a capped rent relief; pension is 8 percent employee / 10 percent employer, NHF 2.5 percent.
- VAT stays at 7.5 percent on the firm's taxable supplies; CIT is 30 percent (reducible to 25 percent), with a 4 percent development levy — and the small-company exemption should not be assumed for a financial-services firm.
- Tax is currency-sensitive: teach and apply the binding Nigerian rule, and confirm every specific rate and threshold with the firm's tax advisers each cycle.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FIN-204';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_01$id$, m.id, $p$From 1 January 2026, the firm's tax framework is governed primarily by the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "old Personal Income Tax Act and Companies Income Tax Act, unchanged"}, {"key": "b", "text": "Investments and Securities Act alone"}, {"key": "c", "text": "Nigeria Tax Act 2025 and Nigeria Tax Administration Act 2025, with the FIRS now the Nigeria Revenue Service"}, {"key": "d", "text": "firm's internal handbook only"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The 2025 reform consolidated the code and renamed FIRS as the NRS, effective 1 January 2026.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_02$id$, m.id, $p$PAYE personal income tax is remitted to the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "relevant State Internal Revenue Service (the Lagos State IRS for a Lagos firm)"}, {"key": "b", "text": "Nigeria Revenue Service"}, {"key": "c", "text": "Securities and Exchange Commission"}, {"key": "d", "text": "employee's pension fund administrator"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$PAYE is a state tax — for a Lagos firm it goes to the Lagos State IRS; federal taxes go to the NRS.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_03$id$, m.id, $p$PAYE deducted from a staff member's salary is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the firm's working capital"}, {"key": "b", "text": "the employee's tax, held in trust, to be remitted accurately and on the deadline"}, {"key": "c", "text": "a discretionary contribution"}, {"key": "d", "text": "exempt from remittance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Deducted PAYE is never the firm's money; it is held in trust and remitted on time.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_04$id$, m.id, $p$The firm's payroll cycle, in order, is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "remit, compute, record, approve, payslip"}, {"key": "b", "text": "payslip, record, compute, remit, approve"}, {"key": "c", "text": "approve, payslip, compute, record, remit"}, {"key": "d", "text": "compute, approve, remit, payslip, record"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Gross is computed, the run is approved under segregation of duties, deductions are remitted, payslips issue, and evidence is filed.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_05$id$, m.id, $p$Under the new PAYE structure, the first ₦800,000 of chargeable income is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "taxed at zero percent"}, {"key": "b", "text": "taxed at 25 percent"}, {"key": "c", "text": "taxed at 15 percent"}, {"key": "d", "text": "not counted as income at all"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The first ₦800,000 sits in the 0 percent band; progressive rates apply above it to a 25 percent top rate.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_06$id$, m.id, $p$The old consolidated relief allowance has been...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "increased"}, {"key": "b", "text": "left unchanged"}, {"key": "c", "text": "abolished and replaced by a rent relief of 20 percent of annual rent, capped at ₦500,000"}, {"key": "d", "text": "made mandatory for all staff"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The NTA removes the CRA and substitutes a capped rent relief.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_07$id$, m.id, $p$Under the contributory pension regime, the minimum contributions are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "5 percent employee and 5 percent employer"}, {"key": "b", "text": "8 percent employee and 10 percent employer of pensionable pay"}, {"key": "c", "text": "10 percent employee and 8 percent employer"}, {"key": "d", "text": "nil for both"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The statutory minimum split is 8 percent employee and 10 percent employer, remitted to the PFA.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_08$id$, m.id, $p$The standard VAT rate under the new law is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "0 percent"}, {"key": "b", "text": "15 percent"}, {"key": "c", "text": "10 percent"}, {"key": "d", "text": "7.5 percent, retained after a planned increase was dropped"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$VAT stays at 7.5 percent; the firm charges output VAT on taxable supplies and can recover input VAT.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_09$id$, m.id, $p$The firm's brokerage commissions and advisory fees, for VAT, are treated as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "taxable supplies that attract output VAT, filed monthly to the NRS"}, {"key": "b", "text": "zero-rated essentials"}, {"key": "c", "text": "outside the tax system entirely"}, {"key": "d", "text": "subject to PAYE"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The firm's fee income is a taxable supply; output VAT is charged, collected, and remitted monthly.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_10$id$, m.id, $p$The standard company income tax rate is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "0 percent for all companies"}, {"key": "b", "text": "50 percent"}, {"key": "c", "text": "30 percent, which the law allows to be reduced toward 25 percent by Presidential order"}, {"key": "d", "text": "7.5 percent"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Standard CIT is 30 percent, reducible toward 25 percent by order on advice.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_11$id$, m.id, $p$The firm should treat the small-company 0 percent CIT exemption as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "automatically applying to it"}, {"key": "b", "text": "not to be assumed — professional and financial-services firms are commonly excluded; confirm with advisers"}, {"key": "c", "text": "applying to any firm under any size"}, {"key": "d", "text": "abolished entirely"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Financial-services firms are commonly outside the small-company exemption; the Head of Finance confirms with advisers.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_12$id$, m.id, $p$The new 4 percent development levy on assessable profits...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is an optional donation"}, {"key": "b", "text": "applies only to individuals"}, {"key": "c", "text": "replaces PAYE"}, {"key": "d", "text": "replaces a cluster of older earmarked levies"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The 4 percent development levy consolidates several previous earmarked levies.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_13$id$, m.id, $p$Late remittance of PAYE or statutory deductions is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a serious breach, with stiffer penalties under the new law"}, {"key": "b", "text": "acceptable if the firm is short of cash"}, {"key": "c", "text": "a minor administrative slip"}, {"key": "d", "text": "permitted once per year"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The held-in-trust principle makes late remittance a serious breach; the NTA strengthens penalties.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_14$id$, m.id, $p$Company income tax and VAT are filed with the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "State Internal Revenue Service"}, {"key": "b", "text": "employee's pension fund administrator"}, {"key": "c", "text": "Nigeria Revenue Service"}, {"key": "d", "text": "Securities and Exchange Commission"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Federal taxes — CIT, VAT, WHT, stamp duties — go to the NRS; PAYE goes to the state.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_15$id$, m.id, $p$The National Housing Fund contribution, where applicable, is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "20 percent of gross pay"}, {"key": "b", "text": "2.5 percent of basic salary"}, {"key": "c", "text": "8 percent of pensionable pay"}, {"key": "d", "text": "not a statutory deduction"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$NHF is 2.5 percent of basic salary, held in trust and remitted with the other statutory deductions.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_16$id$, m.id, $p$Segregation of duties in payroll means that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one person does everything for speed"}, {"key": "b", "text": "payroll never needs approval"}, {"key": "c", "text": "the firm skips record-keeping"}, {"key": "d", "text": "the person preparing the run is not the person who approves it"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Separating preparation from approval is a core payroll control.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_17$id$, m.id, $p$Because tax is currency-sensitive and the law is still settling, the firm's standing discipline is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "confirm specific rates and thresholds with its payroll and tax advisers each cycle"}, {"key": "b", "text": "rely on remembered figures from previous years"}, {"key": "c", "text": "stop filing until the law is final"}, {"key": "d", "text": "apply the old PITA method as a safe default"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The firm's framework is principle-based: full timely compliance, with rates confirmed with advisers as the law settles.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_18$id$, m.id, $p$Using the old PITA calculation method for a 2026 payroll run would...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "be fully compliant"}, {"key": "b", "text": "have no consequence"}, {"key": "c", "text": "be non-compliant — 2026 runs must use the new bands and rent relief"}, {"key": "d", "text": "be required by the NRS"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The consolidated relief allowance is gone; the old method makes a 2026 run non-compliant.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_19$id$, m.id, $p$Individual pay data within the payroll process is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "published to all staff"}, {"key": "b", "text": "access-restricted — the rules of pay are open, but the amounts are private"}, {"key": "c", "text": "shared with clients"}, {"key": "d", "text": "posted on the notice board"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The structure of pay is transparent; individual amounts are confidential.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fin204_20$id$, m.id, $p$The unifying message of the firm's tax and statutory compliance is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "tax can wait until cash improves"}, {"key": "b", "text": "rates can be remembered rather than checked"}, {"key": "c", "text": "PAYE and CIT go to the same authority"}, {"key": "d", "text": "the firm deducts correctly, remits on time to the right authority, keeps the evidence, and confirms current rates as the law settles"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Deduct correctly, remit on time to the correct authority, retain evidence, and verify currency-sensitive rates each cycle.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FIN-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'FIN-204';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: FIN-204 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'FIN-204' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: FIN-204 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: FIN-204 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
