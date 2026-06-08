-- =============================================================================
-- seed_ppl205_content.sql  (v0.62.0)
-- PPL-205: lesson + 20-question check (Proficient, Tier B, FROM POLICY).
-- Authored from the HR Operations Manual v1.1 + People Ops Cadence v1.0 + WS packs.
-- Teaches the standard pay structure, the monthly control cycle, and the 0.80 compa floor.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule (Proficient/role-targeted). Role assignment is added by
-- seed_ppl3xx_role_matrix.sql (jp_peopleops_officer / REQUIRED).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Payroll is the one HR process where a mistake is measured in naira and noticed the same day. It is also the process where the portal earns its keep. The portal does not pay anyone — HumanManager is the system of record and Remita moves the money — but the portal is the independent control layer that proves the payroll was right before it ran. Your job in this module is the whole compensation operation: the pay structure you must protect, the monthly control cycle you run to a fixed calendar, the governance that keeps any one person from authorizing pay alone, and the raise, bonus, benefit, and leave administration that sits around it.

## What you will be able to do

1. State Transworld's standard pay structure precisely and protect the rules that must never break.
2. Run the monthly payroll control cycle end to end, to its fixed deadlines.
3. Apply dual authorization, the three reconciliations, and the evidence-filing discipline.
4. Administer raises, the bonus pool and the senior deferral ledger, and statutory and discretionary benefits.
5. Monitor compa-ratio against the canonical 0.80 floor and flag correctly.

## The standard pay structure — get this exactly right

Before you touch a payroll run, you and Finance must share one unambiguous picture of how Transworld pays. Monthly gross pay is basic salary plus utility allowance — basic is roughly two-thirds, utility roughly one-third. That monthly gross is the figure used in every bonus calculation, every compa-ratio, and all band-positioning work. On top of the twelve monthly payments sit two annual additions: a quarterly payment equal to one full month's gross, paid in January, April, July, and October; and a thirteenth-month payment equal to one full month's gross, paid once a year in the month confirmed on the annual HR calendar. Across a year that is twelve monthly grosses, four quarterly payments, and one thirteenth month — a fully-loaded annual cost of gross times seventeen. The portal expresses the same fact on a monthly-equivalent basis as gross times seventeen divided by twelve.

Three rules must never be broken, because each is a known failure mode. First, utility is paid every single month — all twelve, every year, no exceptions. It is not a benefit that cycles on and off. Second, the quarterly payment is paid in addition to the regular monthly pay, never instead of it. In January, April, July, and October an employee receives their normal monthly pay plus one extra month's gross on top. A system that quietly substitutes the quarterly for the utility — paying utility only eight times instead of twelve — is in error, and the Step-3 cross-check exists specifically to catch it. Third, the thirteenth month is an annual payment, not a monthly accrual; it appears only in the month it is paid, and you notify Finance in advance.

## The monthly control cycle

The cycle is the dominant monthly task and it runs to hard dates; build the whole month around them. By the 20th you prepare the payroll input memo: review the portal compensation profiles for every active employee, confirm joiners, leavers, and approved salary changes since last cycle, and state whether the month is a standard month or a quarter-end month. In quarter-end months the quarterly payment is shown as a separate additive line, never folded into an existing component; where the thirteenth month falls, it is a further additive line. By the 22nd Finance runs the payroll in HumanManager from your memo and returns the draft schedule. By the 24th you run the control cross-check: every line — name, grade, gross salary, deductions — is checked against the portal compensation profile. In a quarter-end month you specifically confirm the quarterly appears as an additive line and not as a replacement for utility; if it has replaced utility, that is a payroll error and payment does not proceed until it is corrected. By the 25th the reconciled schedule is dual-authorized. By the 27th Finance submits to Remita and payment reaches staff on the 28th. By the 30th you file the evidence. If the 28th falls on a weekend or holiday, plan the adjusted schedule at the start of the month so payment lands on the last working day before it.

## Governance: dual authorization, reconciliation, evidence

Two signatures are required on the printed control sheet — the COO and the CFO. This is segregation of duties: no single person can authorize payroll alone, a basic internal-control requirement for a regulated firm. If one of them is unavailable on the authorization date, the MD may substitute for one — but never for both, and the MD may never be the sole authorizer. If a second authorizer cannot be reached, payment waits. There is no exception.

You reconcile three things every month and document each: the portal compensation profiles against the HumanManager figures; the active headcount in the portal against the headcount on the schedule; and any leave-without-pay deductions against approved leave records. Any unexplained variance of one thousand naira or more per employee is investigated before authorization. After payment, the Evidence Vault holds the signed control sheet, the HumanManager schedule, the portal profile export used for the cross-check, and your input memo. These are retained for a minimum of seven years; they are the monthly audit trail an inspection will ask for.

## Raises, bonus, and the senior deferral ledger

Raises are firm-wide and milestone-driven. You track year-to-date revenue against the milestones the RemCom set, using the monthly management accounts the CFO gives you — People Ops does not see the management accounts directly. When the CFO confirms a milestone is hit, you prepare the Raise Recommendation, the COO presents it to the RemCom, and only after RemCom approval do you communicate anything to staff. Never signal a raise before approval: a verbal hint that turns out wrong becomes a claim you cannot manage. On approval you issue Raise Letters and update HumanManager and the portal simultaneously, effective the first of the month after confirmation.

The bonus runs on its own timeline and is paid in April against audited numbers. In February you prepare the indicative RemCom pack from the CFO's estimate of full-year profit before tax. After the audit signs off around 30 March the CFO confirms the audited figure, and the pool is fixed at fifteen percent of audited profit before tax — if that figure is zero or negative, the pool is zero and no discretionary bonus is paid. Each individual bonus is target months times monthly gross times the calibrated scorecard multiplier; if the individual amounts sum above the pool you reduce proportionally from the highest multipliers down and document it. For G4 and G5 employees part of the award is deferred: sixty-five percent is paid immediately and thirty-five percent is deferred, released seventy-five percent at the first April and twenty-five percent at the second. You keep a Deferred Bonus Ledger per senior employee recording the award, the split, the schedule, the actual releases, and any clawback. Clawback is triggered by dismissal for gross misconduct, a material misrepresentation that inflated a prior award, a regulatory enforcement arising from the performance year, or any case the RemCom judges warrants it; bonus-forfeiture for bad leavers is only enforceable if it sits in the signed employment contract, so confirm the contract before relying on it. Every Bonus Letter you prepare states the employee's name and grade, the performance period, the scorecard rating and multiplier, the target months, the monthly gross at calculation, the gross and net bonus, the payment date, and — for G4 and G5 — the deferral split and release dates; the letter is confidential, and employees are told explicitly not to share the amounts. The annual deferred release runs each February: you review the ledger for tranches due in April, confirm the employee is still employed or is a good leaver who retains the tranche, confirm no clawback event has triggered, and include the releasing tranches in the April RemCom pack, because the RemCom approves all deferred releases, not only new bonuses.

## Benefits and leave

Statutory deductions are processed by Finance each month and you cross-check the rates: pension under the Pension Reform Act 2014 (employer ten percent, employee eight percent of monthly gross); the National Housing Fund (employee two-and-a-half percent of basic salary only, not allowances); NSITF (employer one percent of total monthly payroll); and PAYE on the active LIRS and FIRS schedules. Statutory rates and deadlines change — confirm them with the CFO and the tax adviser annually, because late remittance brings penalties and regulatory risk. Discretionary benefits sit in a Benefits Register you maintain and the COO approves; a new or changed benefit needs COO approval and a month's written notice, and a contractual benefit cannot be removed without the employee's consent and a contract amendment. Leave runs through the portal self-service module: the manager approves or declines within three working days, you monitor eligibility and patterns, approved leave deducts automatically, and you reconcile balances against HumanManager monthly and at the 31 December close.

## Compa-ratio in operations

Compa-ratio is fully-loaded pay divided by the grade midpoint, and the canonical floor is 0.80. Each month you run the portal's compa report and flag to the COO anyone below 0.80 as a priority for the next raise cycle, and anyone above 1.15 as needing COO review before any further increase. A companion operating note still cites 0.85 as the trigger; teach and apply 0.80 — it is the canonical floor in the portal and the framework — and treat the 0.85 reference as a document fix to be cleared, not a competing rule.

## A worked example

**Illustration — the quarter that nearly went wrong (entirely hypothetical).** It is April, a quarter-end month, and a fictional G2 employee earns 600,000 naira monthly gross — 400,000 basic, 200,000 utility. Your input memo by the 20th shows the standard monthly line of 600,000 plus a separate additive quarterly line of 600,000: a gross of 1,200,000 for the month. Finance runs it and the draft schedule comes back on the 22nd showing 600,000 total — basic 400,000 plus a "quarterly" 200,000 where the utility should be. At the Step-3 cross-check on the 24th you catch it: the quarterly has replaced the utility instead of being added on top, exactly the failure F2.0 warns about. You flag it to Finance, payment does not proceed, and the corrected schedule shows the full 1,200,000. Separately, you run the compa report: this employee's fully-loaded pay sits at a 0.78 compa-ratio against the grade midpoint, so you flag them to the COO as below the 0.80 floor and a priority for the next raise. Dual authorization follows on the 25th, Remita pays on the 28th, and the signed control sheet is in the Evidence Vault by the 30th.

## Common traps

- **Letting the quarterly replace the utility.** It is always additive; substitution means utility paid eight months not twelve. The Step-3 cross-check exists to catch this.
- **Signaling a raise before RemCom approval.** Never communicate anything until the RemCom has approved; an early hint becomes an unmanageable claim.
- **A single authorizer.** Both COO and CFO sign; the MD may replace one, never both, and never authorizes alone. Payment waits if a second authorizer is unavailable.
- **Paying a bonus from unaudited numbers.** The pool is fifteen percent of audited profit before tax, paid in April; zero or negative profit means a zero pool.
- **Using 0.85 as the compa floor.** The canonical floor is 0.80; the 0.85 in the companion note is a document fix, not a rule.

## Key takeaways

- Monthly gross is basic plus utility; the year is gross times seventeen (twelve monthly, four quarterly, one thirteenth month); fully-loaded monthly-equivalent is gross times seventeen over twelve.
- Utility is paid all twelve months; the quarterly and thirteenth month are additive, never substitutive — the known failure mode the cross-check catches.
- The cycle runs to fixed dates (20th input, 22nd run, 24th cross-check, 25th dual auth, 28th paid, 30th filed); dual authorization needs COO and CFO, MD may cover one not both.
- Raises follow the revenue trigger and need RemCom approval before any communication; the bonus is fifteen percent of audited profit, paid in April, with a 65/35 deferral for G4/G5.
- Statutory rates (pension 10/8, NHF 2.5% of basic, NSITF 1%, PAYE) are cross-checked monthly; compa-ratio is monitored against the canonical 0.80 floor.

*Reference: HR Operations Manual v1.1, Part F (Chapters F1-F8) and F2.0 the standard pay structure; the monthly cadence per the People Ops Cadence v1.0; statutory bases — Pension Reform Act 2014, National Housing Fund, NSITF, and the active LIRS/FIRS PAYE schedules. The fully-loaded model and the 0.80 compa floor are canonical (the companion 0.85 reference is logged for correction). This module is a navigation aid; the manual and the canonical framework are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'PPL-205';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_01$id$, m.id, $p$What is Transworld's monthly gross pay?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Basic salary only"}, {"key": "b", "text": "Basic salary plus utility allowance"}, {"key": "c", "text": "Basic plus utility plus the quarterly payment"}, {"key": "d", "text": "One twelfth of the annual fully-loaded cost"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Monthly gross is basic plus utility. It is the figure used in all bonus calculations, compa-ratio assessments, and band-positioning work.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_02$id$, m.id, $p$In which months is the quarterly payment made?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "March, June, September, December"}, {"key": "b", "text": "January, April, July, October"}, {"key": "c", "text": "Only in December"}, {"key": "d", "text": "Every month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The quarterly payment, equal to one month's gross, is paid in January, April, July, and October, in addition to regular monthly pay.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_03$id$, m.id, $p$The quarterly payment is paid...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "instead of the utility allowance in that month"}, {"key": "b", "text": "in addition to the regular monthly pay, never instead of it"}, {"key": "c", "text": "only to G4 and G5 staff"}, {"key": "d", "text": "as a deduction from the thirteenth month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The quarterly is additive: in quarter-end months the employee gets normal monthly pay plus one extra month's gross on top. Substituting it for the utility is a known payroll error.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_04$id$, m.id, $p$Utility allowance is paid...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "in eight months of the year"}, {"key": "b", "text": "every month, all twelve, without exception"}, {"key": "c", "text": "only in non-quarter-end months"}, {"key": "d", "text": "once a year with the thirteenth month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Utility is paid every single month. A system that pays utility only eight times because the quarterly displaced it is in error.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_05$id$, m.id, $p$On a fully-loaded annual basis, total pay equals monthly gross times...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "12"}, {"key": "b", "text": "13"}, {"key": "c", "text": "17"}, {"key": "d", "text": "15"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Twelve monthly grosses, four quarterly payments, and one thirteenth month sum to gross times seventeen; the monthly-equivalent is gross times seventeen over twelve.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_06$id$, m.id, $p$By which date is the payroll control cross-check (Step 3) completed each month?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the 20th"}, {"key": "b", "text": "the 22nd"}, {"key": "c", "text": "the 24th"}, {"key": "d", "text": "the 28th"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Input memo by the 20th, HumanManager run by the 22nd, control cross-check by the 24th, dual authorization by the 25th, payment on the 28th, evidence filed by the 30th.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_07$id$, m.id, $p$Who must sign the payroll control sheet?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops alone"}, {"key": "b", "text": "the COO and the CFO"}, {"key": "c", "text": "the MD alone"}, {"key": "d", "text": "any two staff members"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Dual authorization requires both the COO and the CFO. This is segregation of duties; no single person can authorize payroll alone.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_08$id$, m.id, $p$If the CFO is unavailable on the authorization date...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the COO may authorize alone"}, {"key": "b", "text": "the MD may substitute for one authorizer, but never for both, and never authorizes alone"}, {"key": "c", "text": "People Ops authorizes in their place"}, {"key": "d", "text": "the payment proceeds without a second signature"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The MD may substitute for one of the COO or CFO, but not both, and may not be the sole authorizer. If a second authorizer cannot be reached, payment waits.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_09$id$, m.id, $p$What variance per employee triggers investigation before authorization?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any amount above zero"}, {"key": "b", "text": "an unexplained variance of \u20a61,000 or more"}, {"key": "c", "text": "\u20a610,000 or more"}, {"key": "d", "text": "only variances flagged by Finance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Any unexplained variance of one thousand naira or more per employee requires investigation before the payroll is authorized.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_10$id$, m.id, $p$A milestone-driven raise may be communicated to employees...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "as soon as the CFO confirms the milestone"}, {"key": "b", "text": "only after RemCom approval"}, {"key": "c", "text": "verbally in advance to manage expectations"}, {"key": "d", "text": "whenever the line manager chooses"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Never communicate a raise before RemCom approval. A premature signal that approval later changes becomes an unmanageable claim.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_11$id$, m.id, $p$The bonus pool is calculated as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "15% of audited profit before tax"}, {"key": "b", "text": "15% of revenue"}, {"key": "c", "text": "10% of audited profit before tax"}, {"key": "d", "text": "a fixed amount set each January"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The pool is fifteen percent of audited profit before tax. If that figure is zero or negative, the pool is zero and no discretionary bonus is paid.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_12$id$, m.id, $p$An individual bonus amount equals...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "monthly gross times 12"}, {"key": "b", "text": "target months times monthly gross times the calibrated scorecard multiplier"}, {"key": "c", "text": "a flat percentage of the pool"}, {"key": "d", "text": "the prior year's bonus plus inflation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each individual bonus is target months times monthly gross times the calibrated scorecard multiplier; if the sum exceeds the pool, reduce proportionally from the highest multipliers and document it.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_13$id$, m.id, $p$For a G4 or G5 employee, the bonus deferral split is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "50% immediate, 50% deferred"}, {"key": "b", "text": "65% immediate, 35% deferred (released 75% in year one, 25% in year two)"}, {"key": "c", "text": "100% immediate"}, {"key": "d", "text": "35% immediate, 65% deferred"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Sixty-five percent is paid immediately and thirty-five percent deferred, released seventy-five percent at the first April and twenty-five percent at the second.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_14$id$, m.id, $p$A bad-leaver bonus-forfeiture clause is enforceable only if...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "People Ops decides to apply it"}, {"key": "b", "text": "it appears in the signed employment contract"}, {"key": "c", "text": "the bonus letter mentions it"}, {"key": "d", "text": "the employee verbally agrees at exit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Bonus-forfeiture for bad leavers must be written into the signed employment contract to be enforceable; confirm the contract before relying on it.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_15$id$, m.id, $p$The National Housing Fund employee contribution is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "2.5% of monthly gross"}, {"key": "b", "text": "2.5% of basic salary only"}, {"key": "c", "text": "8% of monthly gross"}, {"key": "d", "text": "1% of total payroll"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$NHF is two-and-a-half percent of basic salary only, not of total allowances.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_16$id$, m.id, $p$Under the Pension Reform Act 2014, the monthly pension contributions are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "employer 8%, employee 10% of gross"}, {"key": "b", "text": "employer 10%, employee 8% of monthly gross"}, {"key": "c", "text": "employer 5%, employee 5% of gross"}, {"key": "d", "text": "employer 1% of payroll only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Employer ten percent and employee eight percent of monthly gross. NSITF, separately, is the employer's one percent of total monthly payroll.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_17$id$, m.id, $p$A manager declines a leave request. By when must they respond, and on what basis?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "within three working days, stating an operational reason; never for discriminatory or retaliatory reasons"}, {"key": "b", "text": "within ten working days, no reason required"}, {"key": "c", "text": "only after People Ops approval"}, {"key": "d", "text": "whenever convenient, for any reason"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The line manager approves or declines within three working days; a decline must state the operational reason and may never be discriminatory or retaliatory.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_18$id$, m.id, $p$The canonical compa-ratio floor is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "0.75"}, {"key": "b", "text": "0.80"}, {"key": "c", "text": "0.85"}, {"key": "d", "text": "1.00"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The canonical floor is 0.80. A companion operating note still cites 0.85; teach and apply 0.80 and treat the 0.85 reference as a document fix.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_19$id$, m.id, $p$A quarter-end draft schedule shows the quarterly amount in place of the utility allowance. You should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "authorize it \u2014 the totals are close enough"}, {"key": "b", "text": "treat it as a payroll error, flag it to Finance, and hold payment until corrected"}, {"key": "c", "text": "adjust the portal profile to match the schedule"}, {"key": "d", "text": "pay it and reconcile next month"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The quarterly must be additive, not substitutive. This is a payroll error; flag it to Finance with reference to the pay structure and do not authorize until corrected.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_ppl205_20$id$, m.id, $p$Payroll evidence must be retained in the Evidence Vault for a minimum of...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "one year"}, {"key": "b", "text": "three years"}, {"key": "c", "text": "seven years"}, {"key": "d", "text": "indefinitely, with no minimum"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The signed control sheet, the HumanManager schedule, the portal profile export, and the input memo are retained for a minimum of seven years as the monthly audit trail.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'PPL-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;


-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'PPL-205';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: PPL-205 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'PPL-205' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: PPL-205 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: PPL-205 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
