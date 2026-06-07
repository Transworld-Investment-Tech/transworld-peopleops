-- =============================================================================
-- seed_reg203_content.sql  (v0.60.0)
-- REG-203 Risk management fundamentals: lesson + 20-question check (Proficient, Tier A, FROM POLICY).
-- Authored from the firm's compliance source suite; teaches ISA 2025 (not 2007/2024).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO assignment rule: the role-and-grade matrix (seed_ws7_role_matrix.sql) already
-- maps REG-203 as REQUIRED to its job profiles; this is Proficient/role-targeted
-- content, NOT firmwide-mandatory, so no scope=ALL row is added.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Every business you will ever work in runs on risk. A firm that took none would earn nothing; a firm that ignored its risks would not last a year. The interesting question is never "how do we remove risk?" — you cannot — but "are we managing our risks, or are they managing us?" At Transworld, managing them is not left to instinct or to one heroic person. It is a system: a way of finding risks, sizing them, deciding what to do about each one, and checking that the decision held. This module teaches you that system so you can use it on your own desk, not just read about it in a framework.

## What you will be able to do

1. Explain why risk is managed and priced, never simply eliminated.
2. Place any risk, and any person, within the Three Lines of Defence.
3. Run a risk through the assessment cycle — identify, score, treat, monitor.
4. Read and maintain the Risk Register the way it is meant to be used.
5. Connect a risk to the control that answers it, and know where audit picks up.

## Risk is managed, not eliminated

The Firm's control philosophy starts from an honest premise: risk is the raw material of the business, and the job is to take the right risks knowingly and to control the wrong ones deliberately. So we do not chase a risk-free firm — that firm does not exist and would not be worth owning. We chase a firm that knows its risks, has decided what to do about each, and can show its work. The word that recurs is *deliberate*. An accepted risk that someone consciously accepted, documented, and is watching is well managed. The same risk, unnoticed, is a problem waiting to surface.

In a brokerage, the risks are not abstract. There is **market risk** in the positions the firm and its clients hold; **operational risk** in trade processing, settlement, and the systems that carry them; **compliance and conduct risk** in how the firm treats clients and the market; **liquidity and capital risk** in whether the firm can meet its obligations; and **reputational risk** that quietly underwrites all the others, because a firm trusted by clients and regulators survives mistakes that would sink a distrusted one. The same four-step discipline applies to every one of these, which is why learning the method matters more than memorizing any single risk.

## The Three Lines of Defence

The cleanest way to see how the firm manages risk is the **Three Lines of Defence** — a model that answers a single question, "who is responsible for this risk?", three times over.

**The first line is the business itself** — the people who own and run the activity. The trading desk, operations, client-facing staff: they create the risk in the course of doing their jobs, and they own it first. The first line is where most risk is actually managed, because it is where the work happens. If you execute trades, you are the first line of defence against execution and settlement risk, every day. This is the most important and most overlooked point in the whole model: the first line is not "the junior line." It is where control either happens or does not. A policy written by the second line and a test run by the third line cannot save a firm whose front line does not own its risks in real time.

**The second line is oversight** — Compliance and Risk. They do not run the business; they set the policies, monitor adherence, challenge the first line, and report independently. The second line's value is exactly that it is not the same people who own the revenue, so it can ask the uncomfortable question. When the second line and the first line disagree, that friction is the model working as designed, not a breakdown — it is the built-in check against a business that would otherwise mark its own homework.

**The third line is assurance** — internal audit. It is independent of both the business and the oversight functions, and it gives the Board and senior management an objective view of whether the first two lines are actually working. The three lines are not a hierarchy of importance; they are three different vantage points, and a control gap usually shows up as confusion about which line owns a risk.

## The assessment cycle

The engine of the system is a four-step cycle the firm runs on a calendar.

**Identify.** At the start of each financial year — by **31 January** — the Internal Control Officer leads a structured identification of the risks that could stop the firm meeting its objectives. New risks are added through the year as the business changes; identification is not a once-a-year box but an annual reset of a living list.

**Score.** Each risk is sized on two dimensions — **Likelihood** (how probable) and **Impact** (how damaging) — each rated on a defined scale, and the two combine into an overall rating. Scoring forces a conversation that vague worry never does: a risk that is catastrophic but near-impossible is treated differently from one that is minor but constant, and the score makes that explicit. The discipline of putting a number on each dimension also strips out the loudest-voice problem — a risk does not get attention because someone is anxious about it, but because its likelihood and impact earn it. Two risks that "feel" equally worrying often score very differently once you separate how likely each is from how much damage each would do, and that separation is the point.

**Treat.** Every risk is assigned a treatment strategy — the four Ts in plain terms. **Mitigate** (put in or strengthen a control to reduce likelihood or impact), **Accept** (consciously tolerate it, usually for a low-scored risk, and say so), **Transfer** (shift it to someone better placed to bear it, such as through insurance), or **Avoid** (stop doing the activity that creates it). The point of naming a treatment is that "we are worried about this" is not a plan; "we mitigate this with control X, owned by Y" is.

**Monitor.** The Risk Register is reviewed **quarterly** by the Internal Control Officer and presented to the Board's Risk and Compliance Committee. Scores move as the world moves; treatments that stopped working get reopened. Monitoring is what keeps the register honest rather than a document that was true once.

## The Risk Register

The Risk Register is where all of this lives — one place that records each risk, its owner, its likelihood and impact scores, its treatment, the control that answers it, and its review status. Used well, it is not a compliance artifact filed and forgotten; it is the firm's working memory of what could go wrong and what is being done about it. When you raise a new risk on your desk, it belongs on the register with an owner and a treatment, not in your head. The register is also the bridge between risk and control: every meaningful risk should be answerable to a named control, and every key control should trace back to a risk it exists to manage.

## Controls answer risks

A control is the firm's deliberate response to a risk. The Key Control Library catalogs the important ones — segregation of incompatible duties so no single person both initiates and approves, authorization limits, reconciliations, fit-and-proper screening at recruitment, and so on. Controls come in two broad shapes worth distinguishing: **preventive** controls stop a bad outcome before it happens (an authorization limit that blocks an over-large payment), and **detective** controls catch it after the fact (a reconciliation that surfaces a discrepancy). A healthy control environment uses both, because no preventive control is perfect and no detective control is timely on its own.

Two qualities separate a real control from a control on paper. First, a control has an **owner** — a named person responsible for operating it, so that "the reconciliation gets done" is somebody's explicit job, not a hopeful assumption. Second, a control leaves **evidence** that it ran — a signed authorization, a completed and reviewed reconciliation, a screening record on file — because a control you cannot prove operated is, to an auditor, indistinguishable from one that did not. The firm's strongest single control is the oldest one: separating duties so that the person who can initiate a transaction is never the same person who can approve it. Concentrate both in one pair of hands and you have built the conditions for fraud no matter how honest that individual is; segregate them and each acts as a check on the other.

## Where audit picks up

Internal audit — the third line — is not part of running the business or overseeing it day to day; that independence is the source of its value. The **Internal Audit Program** sets a risk-based plan: audit goes where the risk is highest, tests whether the controls the first and second lines rely on actually operate, and reports findings to the Board with management's agreed remediation. Risk management and audit are partners, not rivals — risk management decides and operates the controls; audit gives an honest, independent verdict on whether they work.

A useful way to hold the distinction: the second line asks "are we doing the right things, and are our policies sound?"; the third line asks "are we actually doing what we said, and do the controls truly work in practice?" Audit earns its independence by reporting to the Board rather than to the managers whose work it examines — so that an inconvenient finding cannot simply be overruled by the person it embarrasses. For you in the first line, an audit is not an exam to fear but a free second opinion on whether your controls would hold under pressure; the findings are how weaknesses get fixed before a regulator or a real loss finds them first.

## A worked example

**Illustration — a settlement-fail risk (entirely hypothetical).** Suppose the firm identifies the risk that a trade fails to settle on time, causing a financial and reputational hit. Run the cycle. *Identify:* it goes on the register, owned by Operations. *Score:* likelihood moderate, impact high, giving a high overall rating that earns attention. *Treat:* mitigate — a preventive control (pre-trade checks on available securities and funds) plus a detective control (a daily settlement reconciliation). *Monitor:* reviewed quarterly, with the score revisited when the settlement cycle itself changes. *Lines:* Operations (first) runs the controls, Risk and Compliance (second) monitor and challenge, and internal audit (third) tests independently that the reconciliation truly runs and truly catches fails. One risk, scored, treated, owned, and assured — that is the whole system in miniature.

## Common traps

- **Chasing a risk-free firm.** The goal is risks taken knowingly and controlled deliberately, not zero risk.
- **Worry without a treatment.** "We're concerned about X" is not management; a named treatment and control owner is.
- **Confusing the three lines.** When no one is sure which line owns a risk, that confusion is the gap.
- **A register that is true once.** Without the quarterly review, scores go stale and treatments quietly fail.
- **Mistaking audit for oversight.** Audit's independence is the point; it tests the controls, it does not run them.

## Key takeaways

- Risk is managed and priced, not eliminated; deliberate acceptance is good management, unnoticed risk is not.
- The Three Lines of Defence answer "who owns this risk?" — business (first), oversight (second), audit (third).
- Run every risk through identify → score (likelihood × impact) → treat (mitigate/accept/transfer/avoid) → monitor (quarterly).
- The Risk Register is the firm's living memory; every key risk has an owner, a treatment, and a control.
- Controls are preventive and detective; internal audit independently tests that they work.

*Reference: Internal Control Framework v3.0 (Transworld) — governance, risk assessment, the Risk Register, and the Key Control Library — with Compliance Manual v3.0 §19 and the Internal Audit Program v1.0. This module is a navigation aid; the ICF and those documents are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'REG-203';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_01$id$, m.id, $p$The firm's stance toward risk is best summarized as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "eliminate all risk"}, {"key": "b", "text": "take the right risks knowingly and control the wrong ones deliberately"}, {"key": "c", "text": "ignore risk to focus on revenue"}, {"key": "d", "text": "transfer every risk to insurers"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A risk-free firm earns nothing and cannot exist; the goal is deliberate, knowing management — not elimination.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_02$id$, m.id, $p$Which question does the Three Lines of Defence model answer, three times over?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "How much profit will we make?"}, {"key": "b", "text": "Who is responsible for this risk?"}, {"key": "c", "text": "When is the next audit?"}, {"key": "d", "text": "What is the firm's strategy?"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each line is a different vantage point on responsibility for risk: business, oversight, and assurance.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_03$id$, m.id, $p$In the Three Lines model, the trading desk and operations are the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "second line"}, {"key": "b", "text": "third line"}, {"key": "c", "text": "first line \u2014 they own the risk they create"}, {"key": "d", "text": "outside the model"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The business that creates and runs the activity owns the risk first; most risk is managed in the first line.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_04$id$, m.id, $p$Compliance and Risk sit in which line of defence?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "First"}, {"key": "b", "text": "Second \u2014 oversight, policy, monitoring, and challenge"}, {"key": "c", "text": "Third"}, {"key": "d", "text": "They are not part of the model"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The second line sets policy, monitors, and challenges the first line — valuable precisely because it does not own the revenue.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_05$id$, m.id, $p$Internal audit is the third line. Its defining feature is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it runs the trading desk"}, {"key": "b", "text": "its independence from both the business and oversight, giving an objective verdict"}, {"key": "c", "text": "it sets the firm's policies"}, {"key": "d", "text": "it approves payments"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Audit's independence is the source of its value; it tests whether the first two lines actually work.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_06$id$, m.id, $p$The annual risk identification is led by the Internal Control Officer by what date?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "31 March"}, {"key": "b", "text": "30 June"}, {"key": "c", "text": "31 January"}, {"key": "d", "text": "31 December"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Structured risk identification resets at the start of the financial year, by 31 January, and the list stays living through the year.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_07$id$, m.id, $p$Risks are scored on which two dimensions?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Cost and revenue"}, {"key": "b", "text": "Likelihood and impact"}, {"key": "c", "text": "Speed and size"}, {"key": "d", "text": "Owner and reviewer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each risk is rated for likelihood (how probable) and impact (how damaging), which combine into an overall rating.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_08$id$, m.id, $p$Which set correctly lists the four treatment strategies (the 'four Ts')?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Mitigate, accept, transfer, avoid"}, {"key": "b", "text": "Measure, audit, report, file"}, {"key": "c", "text": "Buy, hold, sell, hedge"}, {"key": "d", "text": "Identify, score, monitor, escalate"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Every risk gets a deliberate treatment: mitigate, accept, transfer, or avoid.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_09$id$, m.id, $p$Consciously tolerating a low-scored risk, documenting it, and watching it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "poor risk management"}, {"key": "b", "text": "the 'accept' treatment \u2014 good management when deliberate"}, {"key": "c", "text": "the same as ignoring it"}, {"key": "d", "text": "only allowed for high-scored risks"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A deliberately accepted, documented, monitored risk is well managed; the same risk unnoticed is a problem waiting to surface.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_10$id$, m.id, $p$How often is the Risk Register reviewed and presented to the Board's Risk and Compliance Committee?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Annually"}, {"key": "b", "text": "Quarterly"}, {"key": "c", "text": "Monthly"}, {"key": "d", "text": "Only after an incident"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Internal Control Officer reviews the register quarterly and presents it to the Risk and Compliance Committee.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_11$id$, m.id, $p$'We are worried about this risk' is, on its own, adequate risk management.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Worry is not a plan. Management requires a named treatment and a control owner — 'we mitigate this with control X, owned by Y.'$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_12$id$, m.id, $p$A preventive control differs from a detective control in that it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "catches a problem after it happens"}, {"key": "b", "text": "stops a bad outcome before it happens"}, {"key": "c", "text": "is always automated"}, {"key": "d", "text": "is owned by audit"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Preventive controls (e.g., an authorization limit) stop the outcome; detective controls (e.g., a reconciliation) catch it afterward.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_13$id$, m.id, $p$A daily settlement reconciliation that surfaces a discrepancy is an example of a...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "preventive control"}, {"key": "b", "text": "detective control"}, {"key": "c", "text": "transfer of risk"}, {"key": "d", "text": "risk acceptance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A reconciliation catches problems after the fact, making it a detective control; a healthy environment uses both types.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_14$id$, m.id, $p$Segregation of duties (so no single person both initiates and approves) is primarily a...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "detective control"}, {"key": "b", "text": "preventive control"}, {"key": "c", "text": "reporting requirement"}, {"key": "d", "text": "risk transfer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Separating incompatible duties prevents a bad outcome before it can occur — a classic preventive control in the Key Control Library.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_15$id$, m.id, $p$The Risk Register is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a compliance artifact to file and forget"}, {"key": "b", "text": "the firm's living memory of what could go wrong and what is being done about it"}, {"key": "c", "text": "a list audit keeps for itself"}, {"key": "d", "text": "a record only senior management may see"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Used well, the register is a working instrument linking each risk to an owner, a treatment, and a control.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_16$id$, m.id, $p$When you identify a new risk on your own desk, it should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "stay in your head until it materializes"}, {"key": "b", "text": "be raised onto the Risk Register with an owner and a treatment"}, {"key": "c", "text": "be reported only at year-end"}, {"key": "d", "text": "be handled by audit alone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$New risks belong on the register with an owner and a treatment, not in someone's head.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_17$id$, m.id, $p$Risk management and internal audit are...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "rivals competing for control"}, {"key": "b", "text": "partners \u2014 risk management operates the controls; audit independently verdicts whether they work"}, {"key": "c", "text": "the same function"}, {"key": "d", "text": "both part of the first line"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Risk management decides and runs controls; audit gives an honest, independent verdict on their effectiveness.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_18$id$, m.id, $p$A risk that is catastrophic but near-impossible should be treated the same as one that is minor but constant.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Scoring on likelihood and impact exists precisely so different risk shapes get different, proportionate treatment.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_19$id$, m.id, $p$Confusion over which line of defence owns a particular risk usually signals...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a well-controlled environment"}, {"key": "b", "text": "a control gap"}, {"key": "c", "text": "that the risk can be ignored"}, {"key": "d", "text": "that audit has failed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$When no one is sure which line owns a risk, that ambiguity is itself the gap that needs closing.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg203_20$id$, m.id, $p$Every key control in the library should ideally...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "exist independently of any risk"}, {"key": "b", "text": "trace back to a risk it exists to manage"}, {"key": "c", "text": "be owned by the Board directly"}, {"key": "d", "text": "be reviewed only when it fails"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The register is the bridge: every meaningful risk has a control, and every key control answers a risk.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'REG-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: REG-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'REG-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: REG-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: REG-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
