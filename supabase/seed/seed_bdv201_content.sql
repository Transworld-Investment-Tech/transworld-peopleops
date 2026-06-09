-- =============================================================================
-- seed_bdv201_content.sql  (v0.67.0)
-- BDV-201: Consultative selling: discovery, needs analysis & building trust — lesson + 20-question check (Proficient).
-- Authored BUILD+SOURCE (Tier B) to the house style; tied to CLA-203 suitability + Handbook voice. ESR v1.1 row BDV-201.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: BDV-2xx are role-targeted via seed_bdv2xx_role_matrix.sql
--   (BDV-2xx were ABSENT from the canonical matrix; this batch ships that seed + a
--   canonical patch). Confirm live: verify_p7.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A sale that begins with a pitch is already in trouble. The salesperson who walks into a client conversation talking — about the firm, the product, the returns — has decided what the client needs before learning a single thing about them. Consultative selling is the opposite discipline. It begins with questions, not claims, and it treats the first conversation as a chance to understand a person rather than a chance to close a deal. At a regulated investment firm this is not merely a nicer way to sell; it is the only way to sell that produces recommendations the firm can stand behind. What you discover in that first conversation is not just rapport — it is the raw material of suitability, the evidence that whatever you eventually recommend was built for this client and no one else.

## What you will be able to do

1. Explain why a consultative approach outperforms a pitch-led one, especially in a regulated firm.
2. Run a structured discovery conversation that surfaces a client's real objectives, horizon, risk tolerance and constraints.
3. Turn what you hear into the suitability inputs the firm relies on, building on the discipline taught in CLA-203.
4. Treat the discovery conversation as the documented basis for any later recommendation.
5. Build trust without overstating, and recognize when honesty means slowing a sale down.

## Sell less by asking more

The instinct under pressure is to talk. A prospect raises a doubt and the untrained salesperson answers it with a feature; the prospect goes quiet and the salesperson fills the silence with another claim. This feels like selling, but it is guessing out loud. The consultative seller does something that feels counter-intuitive at first: they talk less and ask more. They ask what the money is for, when it is needed, what keeps the client up at night, what a good outcome would look like in three years. They listen to the answers without rushing to a product, because the product is the last thing to decide, not the first.

Asking more works for a simple reason. A recommendation is only as good as the understanding it rests on, and you cannot understand a client you have not let speak. The questions also do quiet work on trust: a client who has been genuinely heard is far more likely to act on advice than one who has been talked at, because they can see the advice was shaped around them. In a small market like Lagos, where reputation travels by word of mouth and a single mistreated client can cost a dozen referrals, the patient approach is also the commercially smarter one over any horizon longer than a single transaction.

## The discovery conversation

Discovery is structured curiosity. It moves, roughly, through a few stages. You open by setting the client at ease and explaining, plainly, that you will ask a number of questions before suggesting anything, because that is how the firm works. You then explore the client's situation: their income and obligations, what they already hold, what they have tried before and how it went. You move to their goals, pressing gently past the vague: "growth" is not a goal, but "enough for a house deposit in two years" is, and "income to supplement my pension from next year" is. You explore the emotional side honestly, because risk tolerance lives there — how did they feel the last time an investment fell, and what would they do if this one fell twenty percent in a bad quarter. Finally you summarize back what you have heard and let the client correct you, which both checks your understanding and shows them they were listening to.

Two habits separate good discovery from an interview that goes nowhere. The first is the follow-up question: when a client says they want "safety," you do not nod and move on, you ask what safety means to them, because for one client it means no capital loss and for another it means a steady income, and those point to very different portfolios. The second is comfort with silence. After you ask a real question, the most useful thing you can do is stop talking and let the client think; the pause that feels awkward to you is the client doing the work you need them to do.

## From what you hear to a suitability picture

Everything you gather in discovery sorts into the suitability inputs you met in CLA-203, and it is worth naming them so the conversation has a destination. **Objectives** are what the money is for and the return needed to get there. **Time horizon** is when the client will need it, which shapes how much short-term volatility they can absorb. **Risk tolerance** is their willingness to bear a bad year, and **risk capacity** is their financial ability to bear one — a distinction that matters, because a client can be willing to take a risk they cannot actually afford, and the adviser's job is to notice the gap. **Liquidity needs** capture money that may be wanted at short notice and therefore should not be locked away. **Constraints** are anything the client sets — ethical exclusions, an existing concentration, a fixed deadline. A discovery conversation that ends without a clear picture on each of these has not finished, however pleasant it was.

The point of sorting it this way is that the firm's whole advisory process runs on these inputs. The risk-profile process set out in the Operational Manual and taught in CLA-203 takes exactly this information and turns it into a risk classification, and the recommendation that follows must be consistent with it. Discovery is where that information is actually captured. Done well, it makes the rest of the process honest; done carelessly, it produces a tidy form that bears no relation to the client in front of you.

## Discovery is the suitability evidence

Here is the part a sales-trained mind can miss. In a regulated firm, the discovery conversation is not a soft preliminary that happens before the "real" work of recommending. It *is* the foundation of the real work, and it has to be written down. The notes you take, the risk-profile record you complete, the summary the client confirms — these are the evidence that any later recommendation had a suitable basis. If a client one day complains that they were sold something unsuitable, the firm's defence is precisely this record: here is what we asked, here is what the client told us, here is why the recommendation fitted. A recommendation with no documented discovery behind it is indefensible no matter how sensible it looked at the time.

This reframes the discipline. Capturing the suitability inputs accurately is not box-ticking that slows the sale; it is the sale being done properly. The firm cannot lawfully recommend a product to a client whose objectives, horizon and risk profile it has not established, so the consultative seller who runs good discovery is not being slow — they are being the only kind of salesperson the firm is allowed to deploy.

## Building trust without overselling

Trust is built by being right about small things and honest about hard ones. You build it by doing what you said you would do, by returning calls, by explaining a product's risks as plainly as its benefits, and above all by never overstating what an investment can deliver. The single fastest way to destroy trust — and to breach the firm's standards of conduct — is to promise or imply a return that is not certain, because markets do not offer certainty and the client will eventually discover that you knew it. The Compliance Manual is blunt on this point: integrity means never overstating what a product can deliver. The consultative seller has an advantage here, because they have spent the conversation listening rather than promising, and a recommendation that visibly fits what the client said needs no exaggeration to be persuasive.

Sometimes building trust means slowing a sale down or declining it. A client who arrives certain they want the highest-returning thing available, when discovery reveals they need the money in eighteen months, does not need to be sold an equity fund; they need to be told, kindly and clearly, that their horizon points somewhere safer. Losing that sale, or shrinking it, is the trustworthy move, and in a referral market it is usually the profitable one too.

## Rapport without interrogation

A discovery conversation should feel like a conversation, not a form being administered. The same questions can land as warm interest or as an interrogation depending entirely on how they are asked, and the difference decides whether the client opens up or closes down. Three habits keep it human. The first is to explain why you are asking before you begin: a client who understands that the questions exist to get them the right advice answers them freely, where a client fired questions at with no context becomes guarded. The second is to follow the client's lead rather than marching through a checklist; if they mention a worry, explore it then, while it is live, rather than parking it to reach a later question. The third is to give the client room to talk about what matters to them even when it is not strictly on your list, because the unprompted aside — the school fees coming up, the business they hope to start, the parent they are supporting — is often where the real objectives and constraints surface.

There is a trust dividend in doing this well that pays out long after the first meeting. A client who felt genuinely heard at the outset extends you the benefit of the doubt later, when markets are difficult or a recommendation needs revisiting, because the relationship was built on understanding rather than on a transaction. That patience is worth more in a long client relationship than any clever product, and it is the natural product of discovery done as a conversation between two people rather than as a questionnaire. The aim throughout is not to extract data efficiently; it is to understand a person well enough to advise them honestly, and to leave them confident that the advice, when it comes, was built around them.

## A worked example

**Illustration — a walk-in who "wants the best return" (entirely hypothetical).** The client and details are invented for teaching. A prospective client comes in and opens with, "I have two million naira, put it somewhere with the best return." The pitch-led response is to reach for the highest-returning product on the shelf. The consultative response is to ask questions first. Through discovery you learn the money is the deposit for a flat the client hopes to buy in about eighteen months, that they have never invested before, and that they would be deeply shaken to see the balance fall. Those answers settle it: a short horizon, low risk capacity for this specific goal, and low risk tolerance all point away from equities and toward capital preservation — money-market and short-dated government instruments. You explain why, in plain terms, and you record the conversation as the suitability basis. The client may have wanted to be sold growth; what they needed was their deposit intact when the flat is ready. Recommending the equity fund would have won a bigger sale today and a complaint in eighteen months. The discovery conversation is what told you the difference — and the written record is what would protect both the client and the firm if anyone ever asked.

## Common traps

- **Pitching before discovering.** Leading with the product decides the client's needs for them and produces unsuitable recommendations.
- **Accepting vague goals.** "Growth" or "safety" are starting points for a follow-up question, not answers to write down.
- **Confusing willingness with capacity.** A client may be willing to take a risk they cannot afford; the gap is the adviser's to catch.
- **Treating notes as optional.** Undocumented discovery leaves any later recommendation indefensible.
- **Overstating to win the sale.** Implying a certain return breaches the firm's conduct standards and destroys trust the moment reality intervenes.

## Key takeaways

- Consultative selling leads with questions, not claims; in a regulated firm it is the only approach that yields defensible recommendations.
- Good discovery surfaces objectives, horizon, risk tolerance and capacity, liquidity needs and constraints — the CLA-203 suitability inputs.
- The discovery conversation, written down, is the suitability evidence the firm relies on; capturing it accurately is the sale done properly, not a delay.
- Trust is built by listening, doing what you said, and never overstating what a product can deliver.
- Slowing or declining an unsuitable sale is the trustworthy move and, in a referral market, usually the profitable one.

*Build mode: BUILD+SOURCE — a general professional craft taught to the house style and tied to the firm's own suitability discipline. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: HubSpot Academy — Inbound Sales (discovery and needs analysis), READ-REF (method adapted, no text reproduced); the needs-based, best-interest framing of US SEC Regulation Best Interest (GOV-PUBLIC concept), localized to the Nigerian rule. The binding Transworld authorities are the suitability discipline of CLA-203 (and the Operational Manual risk-profile process it rests on) and the conduct standards of the Compliance Manual and the Employee Handbook v2.1. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row BDV-201.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-201';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_01$id$, m.id, $p$Consultative selling differs from a pitch-led approach because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "begins with questions to understand the client before recommending anything"}, {"key": "b", "text": "leads with the firm's best product"}, {"key": "c", "text": "skips discovery to save time"}, {"key": "d", "text": "promises the highest available return"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Consultative selling opens with structured curiosity; the product is the last thing decided, not the first.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_02$id$, m.id, $p$In a regulated firm, what you learn in a discovery conversation is primarily...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "optional background colour"}, {"key": "b", "text": "the raw material of suitability and the basis for any recommendation"}, {"key": "c", "text": "a substitute for the risk-profile process"}, {"key": "d", "text": "irrelevant once a product is chosen"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Discovery produces the suitability inputs the firm must establish before it may lawfully recommend anything.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_03$id$, m.id, $p$A client says they want 'safety'. The consultative seller should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "write 'low risk' and move to a product"}, {"key": "b", "text": "recommend treasury bills immediately"}, {"key": "c", "text": "ask what safety means to them, since it differs by client"}, {"key": "d", "text": "ignore the comment"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$'Safety' may mean no capital loss to one client and steady income to another — a follow-up question is essential.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_04$id$, m.id, $p$Which pair of suitability inputs is the adviser specifically warned not to confuse?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "objectives and constraints"}, {"key": "b", "text": "horizon and liquidity"}, {"key": "c", "text": "income and obligations"}, {"key": "d", "text": "risk tolerance (willingness) and risk capacity (financial ability)"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A client can be willing to take a risk they cannot afford; spotting that gap is the adviser's job.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_05$id$, m.id, $p$Why must the discovery conversation be documented?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the notes and confirmed risk profile are the evidence a recommendation had a suitable basis"}, {"key": "b", "text": "documentation sets the product's price"}, {"key": "c", "text": "it replaces the need to listen"}, {"key": "d", "text": "regulators never look at it"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$If a client later alleges an unsuitable sale, the documented discovery is the firm's defence and the client's protection.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_06$id$, m.id, $p$A recommendation with no documented discovery behind it is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fine if it looked sensible"}, {"key": "b", "text": "indefensible, regardless of how reasonable it seemed at the time"}, {"key": "c", "text": "preferred for speed"}, {"key": "d", "text": "required by the Handbook"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Without a recorded suitability basis the firm cannot show the recommendation fitted the client.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_07$id$, m.id, $p$The fastest way to destroy trust and breach the firm's conduct standards is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ask too many questions"}, {"key": "b", "text": "summarize the client's goals back to them"}, {"key": "c", "text": "promise or imply a return that is not certain"}, {"key": "d", "text": "document the conversation"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The Compliance Manual is explicit: integrity means never overstating what a product can deliver.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_08$id$, m.id, $p$A client insists on the highest-returning product, but discovery shows they need the money in 18 months. The trustworthy response is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sell the equity fund as requested"}, {"key": "b", "text": "promise the equities will recover in time"}, {"key": "c", "text": "split the money 50/50 to compromise"}, {"key": "d", "text": "explain that the short horizon points to capital preservation, even if it shrinks the sale"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$A short horizon and low capacity for this goal point away from equities; honesty here protects the client and the firm.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_09$id$, m.id, $p$'Risk capacity' refers to a client's...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "financial ability to bear a bad year"}, {"key": "b", "text": "emotional willingness to bear a bad year"}, {"key": "c", "text": "preferred sector"}, {"key": "d", "text": "brokerage account number"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Capacity is the ability to absorb loss; tolerance is the willingness — the two can diverge.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_10$id$, m.id, $p$Comfort with silence matters in discovery because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it pressures the client to buy"}, {"key": "b", "text": "the pause lets the client think and do the work the adviser needs"}, {"key": "c", "text": "it fills time"}, {"key": "d", "text": "it avoids follow-up questions"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$After a real question, stopping talking lets the client reflect; the awkward pause is productive.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_11$id$, m.id, $p$The firm's risk-profile process (Operational Manual, taught in CLA-203) takes discovery inputs and...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "ignores them"}, {"key": "b", "text": "sets the share price"}, {"key": "c", "text": "turns them into a risk classification the recommendation must be consistent with"}, {"key": "d", "text": "sells them to third parties"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Discovery feeds the risk classification; the recommendation that follows must match it.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_12$id$, m.id, $p$Capturing suitability inputs accurately is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "box-ticking that slows the sale"}, {"key": "b", "text": "optional if the client trusts you"}, {"key": "c", "text": "a marketing exercise"}, {"key": "d", "text": "the sale being done properly, since the firm cannot recommend without it"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The firm may not lawfully recommend to a client whose profile it has not established; good discovery is the job, not a delay.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_13$id$, m.id, $p$A useful habit that separates good discovery from a dead-end interview is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the follow-up question that presses past vague answers"}, {"key": "b", "text": "reciting product features"}, {"key": "c", "text": "avoiding emotional topics"}, {"key": "d", "text": "ending as quickly as possible"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Following up on 'safety' or 'growth' surfaces what the client actually means.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_14$id$, m.id, $p$'Enough for a house deposit in two years' is a better stated goal than 'growth' because it...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "sounds more ambitious"}, {"key": "b", "text": "gives a concrete objective and horizon the adviser can act on"}, {"key": "c", "text": "guarantees a return"}, {"key": "d", "text": "avoids documentation"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A specific objective and timeframe are actionable suitability inputs; 'growth' is not.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_15$id$, m.id, $p$Building trust with a client is achieved mainly by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "promising market-beating returns"}, {"key": "b", "text": "talking more than the client"}, {"key": "c", "text": "doing what you said, explaining risks plainly, and never overstating"}, {"key": "d", "text": "offering a personal gift"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Trust comes from reliability and honesty about risk, not from claims or inducements.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_16$id$, m.id, $p$In the worked example, recommending the equity fund to the deposit-saver would most likely have produced...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a perfectly suitable outcome"}, {"key": "b", "text": "a guaranteed gain"}, {"key": "c", "text": "no record-keeping obligation"}, {"key": "d", "text": "a bigger sale today and a complaint in eighteen months"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$The horizon mismatch made equities unsuitable; the discovery conversation revealed the right course.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_17$id$, m.id, $p$Which is NOT one of the suitability inputs discovery should establish?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the salesperson's monthly commission target"}, {"key": "b", "text": "time horizon"}, {"key": "c", "text": "liquidity needs"}, {"key": "d", "text": "risk tolerance"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Objectives, horizon, tolerance, capacity, liquidity and constraints are the client's inputs — the seller's target is not one of them.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_18$id$, m.id, $p$Summarizing back what you heard at the end of discovery serves to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fill silence"}, {"key": "b", "text": "check your understanding and show the client they were heard"}, {"key": "c", "text": "commit the client to a purchase"}, {"key": "d", "text": "replace the written record"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The summary verifies accuracy and reinforces trust; it does not replace documentation.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_19$id$, m.id, $p$In a small referral market like Lagos, the patient consultative approach is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "always slower and less profitable"}, {"key": "b", "text": "irrelevant to reputation"}, {"key": "c", "text": "usually the commercially smarter choice over any horizon longer than one transaction"}, {"key": "d", "text": "a breach of conduct rules"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Reputation travels by word of mouth; mistreating clients costs referrals, so patience pays.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv201_20$id$, m.id, $p$The central message of consultative selling at a regulated firm is that...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the best pitch wins"}, {"key": "b", "text": "discovery is a soft preliminary before the real work"}, {"key": "c", "text": "certainty of return is what clients buy"}, {"key": "d", "text": "what you discover, documented, is the suitable basis the recommendation must rest on"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Discovery is the foundation of a defensible recommendation, not a warm-up to it.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'BDV-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: BDV-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'BDV-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: BDV-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: BDV-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
