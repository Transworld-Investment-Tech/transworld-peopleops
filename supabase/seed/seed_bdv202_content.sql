-- =============================================================================
-- seed_bdv202_content.sql  (v0.67.0)
-- BDV-202: The sales funnel: pipeline, CRM discipline & managing your numbers — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B) to the house style; mapped onto the firm portal/account-opening + confidentiality + NDPA 2023. ESR v1.1 row BDV-202.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: BDV-2xx are role-targeted via seed_bdv2xx_role_matrix.sql
--   (BDV-2xx were ABSENT from the canonical matrix; this batch ships that seed + a
--   canonical patch). Confirm live: verify_p7.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Winning client business is not a single event; it is a process with a shape. Some people you speak to will never become clients, some will become clients quickly, and most sit somewhere in between, moving forward a step at a time or quietly going cold. The sales funnel is simply the name for that process made visible: the stages a prospect passes through from first contact to a funded, active account, and the discipline of knowing, at any moment, who is where and what happens next. A business developer who cannot answer "what is in your pipeline and what are you doing about it" is not managing their work; they are reacting to whoever happens to call. This module is about turning that reaction into a managed process, and about doing it on the firm's own systems, where client information is a firm record and not a private notebook.

## What you will be able to do

1. Describe the stages of a sales pipeline at a firm like Transworld and what moves a prospect between them.
2. Keep customer-relationship records as a control, not as after-the-fact admin.
3. Map the generic funnel onto the firm's own portal and account-opening process.
4. Forecast honestly from a pipeline without sandbagging or inflating it.
5. Manage your numbers by managing the activity that produces them — without gaming the record.

## What a pipeline actually is

A pipeline is the set of prospects you are working, sorted by how far along they are. The exact labels matter less than the idea, but a sensible set of stages for this firm runs roughly: a **lead** is anyone you have identified as a possible client; a **qualified prospect** is a lead you have spoken to and confirmed has both a genuine need and the means to act; a prospect in **discovery and proposal** is one whose needs you are working through and to whom you have made, or are preparing, a specific recommendation; an account in **onboarding** is a client who has agreed and is going through account opening, KYC and documentation; and a **funded, active** account is the finished article — open, compliant and trading. Each stage is narrower than the last, because prospects drop out at every step, which is why the shape is a funnel and not a pipe.

The value of naming the stages is that it tells you what to do next for each prospect rather than leaving you with an undifferentiated list of names. A lead needs qualifying; a qualified prospect needs discovery; a proposal needs following up; an onboarding client needs their paperwork chased through compliance. Knowing the stage tells you the action.

## CRM discipline as a control, not admin

A customer-relationship record exists so that the firm — not just you — knows the state of every client and prospect relationship. Treated as an afterthought, it becomes a graveyard of stale entries that no one trusts. Treated as a discipline, it becomes a control: a reliable, current picture of the book that survives your absence, your annual leave and, eventually, your departure. The habits that make the difference are unglamorous. Every meaningful contact is logged promptly while the detail is fresh. Every active prospect carries a clear next action and a date. Stages are kept honest — a prospect you have not reached in two months is not "in discovery," it is cold, and pretending otherwise corrupts the forecast. The test of a good record is simple: if you were unreachable tomorrow, could a colleague pick up your book and know exactly where each relationship stands and what to do next? If not, the record is not yet doing its job.

This discipline is also a conduct matter, and it is worth being clear about why. The information in the system — who the clients are, what they hold, what they have discussed with you — belongs to the firm and its clients, not to you. It is protected by the confidentiality duties in the Compliance Manual and by data-protection law, and it may not be copied, removed or taken to a competitor when you leave. A clean, current CRM is the firm's asset and the client's protection, never a personal contact list you happen to keep on the firm's screen.

## Mapping the funnel onto the firm's systems

The generic funnel becomes real when it is mapped onto how this firm actually opens and runs accounts. The portal and the firm's records are the system of record; the funnel stages should line up with concrete, checkable events there rather than living only in your head. The decisive transition — from prospect to client — is the account-opening process set out in the Operational Manual, with its own steps and fees: an individual account carries an opening fee of ₦10,000 and a corporate or estate account ₦50,000, and the account is not a real client until KYC is complete, the risk classification is approved and the account is funded. That gives you objective checkpoints. A name with no contact logged is a lead, not a prospect. A "client" whose account-opening documents are still outstanding is in onboarding, not funded. Anchoring the funnel to these real events keeps your pipeline honest because the stages are tied to things that either happened or did not, and it keeps the firm's records and your view of the book in agreement. A further benefit of keeping the funnel on the firm's systems rather than in your own head is that it becomes visible to the people who need to see it. A manager reviewing the book, a colleague covering your leave, the compliance function checking that onboarding is being done properly — each depends on a pipeline that lives where the firm can see it, kept current and honest. A private pipeline, however well you manage it personally, is invisible to the firm and vanishes when you do, which is exactly why client and pipeline records belong on the firm's systems and not in a notebook only you can read.

## Forecasting honestly

A pipeline lets you forecast, and the temptation runs in both directions. The optimist inflates: every prospect is "about to close," and the forecast becomes a wish list that collapses at month end. The pessimist sandbags: real opportunities are left out so that beating the number looks easy, which starves the firm of the information it needs to plan. Honest forecasting sits between the two. It weights prospects by how far along they genuinely are — an early lead is worth little in a forecast, a signed onboarding client almost everything — and it is revised as facts change rather than defended once stated. The purpose of a forecast is not to look good; it is to give the firm a true picture so it can plan resourcing, cash and effort. A forecast you have shaded to flatter yourself has failed at the one thing it is for.

## Managing your numbers without gaming them

The numbers that matter divide into two kinds. **Activity** measures what you do: conversations had, qualifications done, proposals made, follow-ups completed. **Outcomes** measure what results: accounts opened, assets brought in, relationships retained. The relationship between them is the heart of pipeline management, because activity is the part you control directly and outcomes are what activity eventually produces. If outcomes are thin, the diagnosis is usually upstream in the activity — too few qualified prospects entering the top of the funnel, or proposals not followed through — and the fix is to work the funnel, not to stare at the result.

The danger is managing the metric instead of the work. An activity target met by logging hollow "contacts," a conversion rate flattered by quietly deleting the prospects who said no, a stage advanced on the record without anything real having changed — each makes the number look better and the book worse, and each corrupts the forecast everyone else relies on. The professional measures honestly, works the activity that genuinely moves prospects forward, and lets the outcomes follow. Gaming the record is not a shortcut to performance; it is the destruction of the one tool that tells you and the firm the truth about the business.

## Working the top of the funnel

Because the funnel narrows at every stage, the single most common reason a pipeline runs dry is not poor closing but too little entering the top. Prospecting and qualification are the unglamorous engine of the whole process, and they reward steady, deliberate effort more than occasional bursts. Prospecting is the work of finding people who might genuinely benefit from what the firm offers — through referrals from satisfied clients, through your own network, through the firm's standing in the market — and it is most productive when it is a habit rather than a panic at month end. Qualification is the discipline of deciding, early and honestly, which of those leads is worth your time: a prospect with a real need and the means to act deserves your effort, while one who has neither is a polite conversation, not a pipeline entry, and recording them as the latter only flatters the numbers.

Segmenting your effort follows naturally from this. Not every qualified prospect warrants the same intensity; a prospect whose needs are large and whose fit is strong earns more of your time than one whose potential is marginal, and a clear-eyed view of where your effort will actually convert is part of managing a book well. The point is not to chase every name with equal energy but to put your limited time where it does the most good, for the client and for the firm. A business developer who works the top of the funnel deliberately — prospecting as a routine, qualifying honestly, segmenting effort sensibly — rarely faces the empty-pipeline panic, because the funnel is being fed continuously rather than refilled in emergencies. The numbers at the bottom are simply the delayed result of the discipline at the top.

## A worked example

**Illustration — reading a thin month (entirely hypothetical).** The figures are invented for teaching. A business developer ends a quiet month with only one new funded account and is tempted to pad the record to make the pipeline look fuller. Worked honestly, the pipeline tells a more useful story: of twenty leads at the start of the month, eight were qualified, three reached proposal, and one funded — a shape that is narrow at the top, not broken at the bottom. The problem is not closing ability; it is too few qualified prospects entering the funnel. The right response is to lift activity at the top — more prospecting, faster qualification — not to inflate the later stages on the record. Padding the pipeline would have hidden the real diagnosis, produced a forecast the firm could not trust, and left next month just as thin. Reading the honest funnel pointed straight at the fix.

## Common traps

- **Treating the CRM as admin.** A stale record no one trusts is worse than none; logged promptly, it is a control and a firm asset.
- **Letting cold prospects sit in active stages.** A prospect not contacted in months is cold; mislabelling it corrupts the forecast.
- **Inflating or sandbagging the forecast.** Both deprive the firm of the true picture the forecast exists to provide.
- **Gaming activity metrics.** Hollow logged "contacts" or deleted rejections flatter the number and damage the book.
- **Treating client data as personal property.** Client and pipeline records are firm records under confidentiality and data-protection duties — never a private contact list to take away.

## Key takeaways

- The sales funnel makes the winning process visible: stages from lead to funded, active account, each narrower than the last.
- A CRM kept current and honest is a control and a firm asset — the test is whether a colleague could pick up your book tomorrow.
- Anchor funnel stages to real events in the firm's systems, especially the account-opening process (₦10,000 individual / ₦50,000 corporate), so the pipeline stays honest.
- Forecast by weighting prospects by genuine stage and revising with the facts; a flattering forecast has failed its only purpose.
- Manage outcomes by managing activity, and never game the record — client and pipeline data belong to the firm and its clients under confidentiality and data-protection duties.

*Build mode: BUILD — a general professional craft taught to the house style and mapped onto the firm's own systems; this module teaches no binding investment-conduct rule beyond the firm's confidentiality and data-protection duties. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: HubSpot Academy — Sales Hub (pipeline, stages, reporting), READ-REF (generic funnel mapped onto the firm portal; no text reproduced). The binding Transworld authorities are the account-opening process of the Operational Manual, the confidentiality standards of the Compliance Manual, and the data-protection duties under the NDPA 2023. Related portal training: TEC-101. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row BDV-202.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-202';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_01$id$, m.id, $p$A sales funnel is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the stages a prospect passes through from first contact to a funded, active account"}, {"key": "b", "text": "a single closing event"}, {"key": "c", "text": "a list of products"}, {"key": "d", "text": "the firm's price list"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The funnel makes the winning process visible as stages, each narrower than the last.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_02$id$, m.id, $p$The process is shaped like a funnel rather than a pipe because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "every lead becomes a client"}, {"key": "b", "text": "prospects drop out at each stage, so each stage is narrower than the last"}, {"key": "c", "text": "it has only one stage"}, {"key": "d", "text": "clients move backwards"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Attrition at every step narrows the funnel from many leads to few funded accounts.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_03$id$, m.id, $p$A prospect you have not contacted in two months should be recorded as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "in discovery"}, {"key": "b", "text": "funded and active"}, {"key": "c", "text": "cold — mislabelling it corrupts the forecast"}, {"key": "d", "text": "a qualified prospect"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Keeping stages honest is part of CRM discipline; a long-silent prospect is cold, not active.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_04$id$, m.id, $p$The practical test of a good customer-relationship record is whether...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it contains the most names"}, {"key": "b", "text": "it flatters your conversion rate"}, {"key": "c", "text": "it is updated once a year"}, {"key": "d", "text": "a colleague could pick up your book tomorrow and know where each relationship stands"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A CRM is a control only if it survives your absence and tells a colleague the next action.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_05$id$, m.id, $p$Client and pipeline information held in the firm's system...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "belongs to the firm and its clients and is protected by confidentiality and data-protection duties"}, {"key": "b", "text": "is the salesperson's personal property"}, {"key": "c", "text": "may be taken to a competitor on departure"}, {"key": "d", "text": "is exempt from data-protection law"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The data is a firm and client asset under the Compliance Manual and NDPA 2023 — never a private contact list.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_06$id$, m.id, $p$Under the Operational Manual, the account-opening fee for an individual account is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "₦50,000"}, {"key": "b", "text": "₦10,000"}, {"key": "c", "text": "nothing"}, {"key": "d", "text": "₦100,000"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An individual account opening fee is ₦10,000; a corporate or estate account is ₦50,000.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_07$id$, m.id, $p$Anchoring funnel stages to real events in the firm's systems keeps the pipeline honest because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it hides cold prospects"}, {"key": "b", "text": "it inflates the forecast"}, {"key": "c", "text": "the stages are tied to things that either happened or did not"}, {"key": "d", "text": "it removes the need for records"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Objective checkpoints (contact logged, KYC complete, account funded) keep your view and the firm's records in agreement.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_08$id$, m.id, $p$A 'client' whose account-opening documents are still outstanding should be recorded as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "funded and active"}, {"key": "b", "text": "a cold lead"}, {"key": "c", "text": "lost"}, {"key": "d", "text": "in onboarding, not funded"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Until KYC is complete, the risk classification approved and the account funded, the account is in onboarding.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_09$id$, m.id, $p$Honest forecasting from a pipeline means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "weighting prospects by genuine stage and revising as facts change"}, {"key": "b", "text": "marking every prospect as about to close"}, {"key": "c", "text": "leaving real opportunities out to beat the number easily"}, {"key": "d", "text": "never revising the figure once stated"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A weighted, regularly revised forecast gives the firm a true picture to plan with.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_10$id$, m.id, $p$Sandbagging a forecast (leaving real opportunities out) is harmful because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "is always more accurate"}, {"key": "b", "text": "starves the firm of the information it needs to plan"}, {"key": "c", "text": "is required by the Operational Manual"}, {"key": "d", "text": "improves client suitability"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Understating the pipeline deprives the firm of the true picture the forecast exists to provide.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_11$id$, m.id, $p$'Activity' metrics differ from 'outcome' metrics in that activity measures...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "assets brought in"}, {"key": "b", "text": "accounts retained"}, {"key": "c", "text": "what you do — conversations, qualifications, proposals, follow-ups"}, {"key": "d", "text": "the firm's share price"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Activity is the controllable input; outcomes (accounts opened, assets in) are what activity produces.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_12$id$, m.id, $p$If outcomes are thin, the usual diagnosis is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client's fault"}, {"key": "b", "text": "bad luck only"}, {"key": "c", "text": "too much documentation"}, {"key": "d", "text": "upstream in the activity — too few qualified prospects or proposals not followed through"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Thin results usually trace to the activity that feeds the funnel; the fix is to work the funnel.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_13$id$, m.id, $p$Quietly deleting prospects who said 'no' to flatter a conversion rate is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "gaming the record, which corrupts the forecast and damages the book"}, {"key": "b", "text": "good hygiene"}, {"key": "c", "text": "required for accuracy"}, {"key": "d", "text": "a forecasting best practice"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Managing the metric instead of the work destroys the tool that tells the firm the truth.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_14$id$, m.id, $p$In the worked example, the honest funnel (20 leads, 8 qualified, 3 proposals, 1 funded) showed the problem was...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "poor closing ability"}, {"key": "b", "text": "too few qualified prospects entering the top of the funnel"}, {"key": "c", "text": "excessive documentation"}, {"key": "d", "text": "an unsuitable product"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The shape was narrow at the top; the fix is more prospecting and faster qualification, not padding later stages.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_15$id$, m.id, $p$A 'qualified prospect' differs from a mere 'lead' because the prospect...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "has paid the opening fee"}, {"key": "b", "text": "is already funded"}, {"key": "c", "text": "has been spoken to and confirmed to have a genuine need and the means to act"}, {"key": "d", "text": "has never been contacted"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Qualification confirms need and means; a lead is only a possible client you have identified.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_16$id$, m.id, $p$The purpose of a sales forecast is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "make the salesperson look good"}, {"key": "b", "text": "guarantee the firm's results"}, {"key": "c", "text": "replace the CRM"}, {"key": "d", "text": "give the firm a true picture so it can plan resourcing, cash and effort"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A forecast shaded to flatter has failed its only purpose; it exists to inform planning.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_17$id$, m.id, $p$Logging a meaningful client contact promptly, while detail is fresh, is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a CRM discipline that turns the record into a reliable control"}, {"key": "b", "text": "unnecessary admin"}, {"key": "c", "text": "a breach of confidentiality"}, {"key": "d", "text": "only for managers"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Prompt, accurate logging keeps the record current and trustworthy — a control, not afterthought.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_18$id$, m.id, $p$Knowing which stage a prospect is in is useful mainly because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sets the product price"}, {"key": "b", "text": "tells you the next action — qualify, run discovery, follow up, or chase paperwork"}, {"key": "c", "text": "guarantees the sale"}, {"key": "d", "text": "removes the need to forecast"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Each stage implies a specific next step; the stage is what tells you what to do.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_19$id$, m.id, $p$When a business developer leaves the firm, the client records they kept...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "may be copied and taken with them"}, {"key": "b", "text": "become their personal property"}, {"key": "c", "text": "remain firm and client assets and must not be removed or taken to a competitor"}, {"key": "d", "text": "are deleted automatically"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Confidentiality and data-protection duties mean the records stay with the firm; they are not a personal list.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv202_20$id$, m.id, $p$The professional way to improve outcomes is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "delete the prospects who declined"}, {"key": "b", "text": "mark every stage as advanced"}, {"key": "c", "text": "stare at the result and hope"}, {"key": "d", "text": "work the activity that genuinely moves prospects forward and let outcomes follow"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Outcomes are managed by managing the controllable activity, measured honestly — not by gaming the record.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-202'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'BDV-202';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: BDV-202 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'BDV-202' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: BDV-202 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: BDV-202 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
