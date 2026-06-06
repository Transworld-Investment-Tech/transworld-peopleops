-- ===========================================================================
-- BDV-103 Talking markets in plain language: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$A great deal of what separates a good business developer from an average one is not market knowledge — it is the ability to make market knowledge **clear** to someone who does not have it. A client who understands what they are buying trusts the firm more, makes better decisions, and complains less. A client who nods along without understanding is a complaint waiting to happen. This module is about the craft of explaining securities and markets in plain language: why it matters, the principles that make an explanation land, and a working glossary of the terms a client will actually ask about. It assumes the market literacy of INV-101 and INV-102 and turns it outward — toward the person across the table. The firm's mantra applies to communication too: **the right way is always the best way**, and the right way is to be understood.

## What you'll be able to do

1. Explain why plain-language communication is a matter of trust and suitability, not just style.
2. Apply the core principles of a clear explanation.
3. Define the common market terms a layperson asks about, in one plain sentence each.
4. Use analogies effectively — and know their limits.
5. Keep an explanation honest: simple without becoming misleading.

## Why plain language matters

There is a trap that every expert falls into, called the **curse of knowledge**: once you understand something, it becomes hard to remember what it was like not to understand it, and you explain as if the other person already knows what you know. In a securities firm this is not just unhelpful — it is a risk. A client can only genuinely **consent** to an investment they understand. If a client agrees to something they did not really grasp, the "agreement" is hollow: it will not survive a loss, and it will not survive scrutiny. Plain language is therefore part of **suitability** and part of **honesty**, not a soft skill bolted on top. The goal is not to make the client an expert; it is to make sure they understand what they are deciding. And there is a quiet commercial truth in it too: the clients who understand what they own are the ones who stay calm when markets wobble, who do not panic-sell at the bottom, and who trust the firm enough to come back. Clarity is not only the honest choice — over time, it is the one that builds the most durable book of business.

## Principles of a clear explanation

A few habits do most of the work:

- **Start from the client's world.** Connect the new idea to something they already know — a savings account, owning property, lending to a friend. Build from the familiar to the unfamiliar.
- **One idea at a time.** Do not explain shares, dividends, yield, and diversification in a single breath. Lay one brick, check it holds, then lay the next.
- **Analogy first, precision second.** Use a plain analogy to give the shape of the idea, then add the accurate detail. The analogy opens the door; the precision keeps you honest.
- **Define jargon or drop it.** If you use a technical word, define it in the same sentence. If you cannot define it simply, you probably do not need it.
- **Check understanding.** Ask the client to tell you back what they understood, or pause and invite questions. Silence is not the same as comprehension.

### The same idea, two ways

Watch the difference. A jargon-heavy explanation of a bond: *"It's a fixed-income instrument with a defined coupon and maturity, offering yield with lower volatility than equities and modest duration risk."* Every word is correct, and almost no first-time client follows it. Now the plain version: *"A bond is basically a loan you make — to a company or the government. They agree to pay you interest along the way and give your money back on a set date. It's steadier than shares: you usually know what you'll get, and the price moves around less — but the return is more modest, and it's not risk-free, because the borrower has to be good for it."* Same content, including the risk. The second version starts from something the client knows (lending), uses no undefined jargon, and keeps the downside in view. That is the whole craft in one comparison: not less accurate — more understood.

## A plain-language glossary

Here are the terms a client most often asks about, each in one clear sentence:

- **Share (equity):** a small piece of ownership in a company; if the company does well, your piece can become more valuable and may pay you a slice of the profits.
- **Bond:** a loan you make to a company or government that agrees to pay you interest and return your money at a set date.
- **Dividend:** a share of a company's profit paid out to its shareholders, usually in cash.
- **Yield:** the income an investment pays, expressed as a percentage of what you paid for it — roughly, the "interest rate" you are earning on it.
- **Portfolio:** the collection of all the investments a person holds, taken together.
- **Diversification:** not putting all your eggs in one basket — spreading money across different investments so that one going wrong does not sink everything.
- **Risk and return:** the basic trade-off of investing — generally, the chance of a higher return comes with a higher chance of loss; safety and high returns rarely come together.
- **Liquidity:** how easily you can turn an investment back into cash without losing value; a listed share is liquid, a building is not.
- **The market / an index:** "the market" is all the buying and selling of securities; an index (like the All-Share Index) is a single number that tracks how the market is moving overall.
- **Broker / Dealing Member:** a licensed firm, like Transworld, that is allowed to buy and sell securities on the exchange on a client's behalf.

> Notice that none of these definitions uses another piece of jargon to explain the first. That is the test of a good plain-language definition: it stands on words the client already owns.

## Analogies that work — and their limits

Analogies are powerful because they import understanding the client already has. A few reliable ones: a **share** is like owning a slice of a business with friends; a **bond** is like lending money to a reliable neighbor who pays you interest; **diversification** is the egg-and-basket idea; **liquidity** is the difference between cash in your pocket and equity in your house. Used well, an analogy can do in ten seconds what a paragraph of definition cannot.

But every analogy breaks if pushed too far, and an honest communicator names the limit. "A share is like part-owning a business with friends — but unlike your friends' business, the price is set by the whole market every day, and it can fall." Drop the analogy the moment it would mislead. The analogy is a bridge to the idea, not the idea itself.

## Keeping it honest

Plain does not mean rosy. The most important discipline in simplifying is to **never simplify the risk away.** It is easy to make an investment sound attractive by leaving out the downside; that is not clarity, it is mis-selling in friendly clothing. Three habits keep simple talk honest. Say **"could," not "will"** — "this could grow over time" is honest; "this will grow" is not. **Include the downside in the same breath as the upside** — "shares can grow more than bonds, and they can also fall more." And **never let a simplification become a guarantee** — the goal is an accurate picture in plain words, not a comfortable one. If the simple version and the true version point in different directions, the simple version is wrong and must be fixed.

## Reading the room

Finally, calibrate to the person. Some clients are sophisticated and will be irritated by over-explanation; others are new and will be lost by a single unexplained term. Listen to the language a client uses about money and meet them there — neither talking down nor talking over. Invite questions explicitly ("what would be useful to go deeper on?"), because the questions a client does not feel safe to ask are exactly the gaps that cause trouble later. The aim throughout is the same: a client who can explain back, in their own words, what they are doing and why.

## The bottom line

Talking markets in plain language is a discipline, not a knack. Start from what the client knows, take one idea at a time, define or drop the jargon, use analogies and name their limits, and keep the simple version honest — risk included. A client who understands is a client who trusts, decides well, and stays. Making the complex clear, without making it false, is one of the most valuable things a business developer can do — and it is, again, simply the right way done well.

---

*Foundational BD module · Tier B · function-head review on each annual cycle. Built to house style as a communication-skills module; pairs with INV-101 and INV-102. Clarity never overrides the honesty and suitability rules.*$body$,
    pass_mark = 80,
    estimated_minutes = 25,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-103';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_01$id$, m.id, $p$What is the 'curse of knowledge'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Knowing too much about regulation"},{"key":"b","text":"Once you understand something, it becomes hard to remember what not understanding it was like, so you explain as if the other person already knows"},{"key":"c","text":"A penalty for failing a quiz"},{"key":"d","text":"A market downturn"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The curse of knowledge is forgetting what it was like not to understand, and explaining as if the listener already shares your knowledge.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_02$id$, m.id, $p$Why is plain-language communication a matter of suitability and honesty, not just style?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is purely cosmetic"},{"key":"b","text":"A client can only genuinely consent to an investment they understand; an agreement they didn't grasp is hollow"},{"key":"c","text":"Regulators reward fancy language"},{"key":"d","text":"It makes meetings shorter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Genuine consent requires understanding; a client who agrees to what they didn't grasp has not really consented, which is a suitability and honesty issue.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_03$id$, m.id, $p$Which are core principles of a clear explanation? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Start from the client's world — build from the familiar"},{"key":"b","text":"Explain one idea at a time"},{"key":"c","text":"Define jargon in the same sentence, or drop it"},{"key":"d","text":"Explain everything at once to save time"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Start from the familiar, one idea at a time, and define-or-drop jargon. Cramming everything at once defeats clarity.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_04$id$, m.id, $p$What is the test of a good plain-language definition?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It uses precise technical terms"},{"key":"b","text":"It stands on words the client already owns — it doesn't use other jargon to explain the term"},{"key":"c","text":"It is at least three sentences long"},{"key":"d","text":"It quotes the Operational Manual"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A good plain definition relies only on words the client already knows, never on more jargon.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_05$id$, m.id, $p$Which is a clear, plain definition of a 'share'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"An equity instrument conferring residual claims on net assets"},{"key":"b","text":"A small piece of ownership in a company; if it does well, your piece can become more valuable and may pay you a slice of the profits"},{"key":"c","text":"A fixed-income security"},{"key":"d","text":"A loan to the government"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A share is a small piece of ownership in a company — explained in words the client already owns.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_06$id$, m.id, $p$In plain terms, what is a 'bond'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Part-ownership of a company"},{"key":"b","text":"A loan you make to a company or government that agrees to pay you interest and return your money at a set date"},{"key":"c","text":"A type of index"},{"key":"d","text":"A guaranteed doubling of your money"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A bond is a loan to a company or government, paying interest and repaying the principal at maturity.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_07$id$, m.id, $p$How would you explain 'diversification' plainly?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Concentrating everything in the best single stock"},{"key":"b","text":"Not putting all your eggs in one basket — spreading money across investments so one going wrong doesn't sink everything"},{"key":"c","text":"Selling everything at once"},{"key":"d","text":"Borrowing to invest"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Diversification is the eggs-and-basket idea: spreading money so a single loss doesn't sink the whole portfolio.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_08$id$, m.id, $p$How would you explain 'liquidity' to a layperson?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"How profitable an investment is"},{"key":"b","text":"How easily you can turn an investment back into cash without losing value — a listed share is liquid, a building is not"},{"key":"c","text":"The dividend a share pays"},{"key":"d","text":"The number of shares in issue"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Liquidity is how easily an investment converts to cash without loss — cash-in-pocket versus equity-in-a-house.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_09$id$, m.id, $p$What is the basic risk-return trade-off, in plain terms?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Higher returns come with no extra risk"},{"key":"b","text":"Generally, the chance of a higher return comes with a higher chance of loss; safety and high returns rarely come together"},{"key":"c","text":"Risk and return are unrelated"},{"key":"d","text":"Lower risk always means higher return"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Higher potential return generally carries higher risk of loss; safety and high returns rarely come together.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_10$id$, m.id, $p$What should you do after explaining an idea to a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Assume they understood if they are silent"},{"key":"b","text":"Check understanding — ask them to tell it back, or pause and invite questions"},{"key":"c","text":"Move quickly to the next idea"},{"key":"d","text":"End the meeting"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Silence is not comprehension; check understanding by asking the client to tell it back or inviting questions.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_11$id$, m.id, $p$An analogy can be pushed as far as you like without misleading the client.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every analogy breaks if pushed too far; an honest communicator names the limit and drops the analogy before it misleads.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_12$id$, m.id, $p$What is the role of an analogy in a good explanation?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It replaces the accurate detail entirely"},{"key":"b","text":"It is a bridge to the idea — give the shape with an analogy, then add the accurate detail"},{"key":"c","text":"It should never be used"},{"key":"d","text":"It guarantees the client will invest"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An analogy gives the shape of an idea; you then add precision. It is a bridge to the idea, not the idea itself.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_13$id$, m.id, $p$What is the single most important discipline when simplifying an investment?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Make it sound as attractive as possible"},{"key":"b","text":"Never simplify the risk away — leaving out the downside is mis-selling in friendly clothing"},{"key":"c","text":"Use as much jargon as possible"},{"key":"d","text":"Promise a guaranteed return"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Simplifying must never remove the risk; omitting the downside to make something sound attractive is mis-selling.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_14$id$, m.id, $p$Which habits keep simple talk honest? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Say 'could,' not 'will'"},{"key":"b","text":"Include the downside in the same breath as the upside"},{"key":"c","text":"Never let a simplification become a guarantee"},{"key":"d","text":"Leave out the risk if it might worry the client"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$'Could' not 'will,' downside-with-upside, and no simplification-as-guarantee keep it honest. Hiding risk does the opposite.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_15$id$, m.id, $p$If the simple version of an explanation and the true version point in different directions, the simple version must be fixed.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$A simplification that contradicts the truth is wrong; clarity must never come at the cost of accuracy.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_16$id$, m.id, $p$How should you calibrate an explanation to different clients?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Use the same level of detail for everyone"},{"key":"b","text":"Listen to the language a client uses about money and meet them there — neither talking down nor over their head"},{"key":"c","text":"Always use the most technical language"},{"key":"d","text":"Always assume the client is a beginner"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Calibrate to the person: a sophisticated client resents over-explanation; a new one is lost by jargon. Meet them where they are.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_17$id$, m.id, $p$Why explicitly invite a client's questions?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To fill time"},{"key":"b","text":"Because the questions a client doesn't feel safe to ask are exactly the gaps that cause trouble later"},{"key":"c","text":"Questions are a sign the explanation failed"},{"key":"d","text":"To avoid having to explain anything"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Unasked questions are unfilled gaps; inviting them surfaces the misunderstandings that would otherwise cause problems later.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_18$id$, m.id, $p$What is the ultimate aim of a plain-language explanation?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To make the client an expert"},{"key":"b","text":"That the client can explain back, in their own words, what they are doing and why"},{"key":"c","text":"To close the sale as fast as possible"},{"key":"d","text":"To impress the client with terminology"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The aim is genuine understanding — a client who can explain back what they are doing and why, not one made into an expert or rushed into a sale.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_19$id$, m.id, $p$Making an investment sound attractive by leaving out the downside is acceptable as long as everything you say is technically true.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Omitting material downside is misleading even if each statement is literally true — it is mis-selling in friendly clothing.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv103_20$id$, m.id, $p$Which terms belong in a layperson's working glossary, defined plainly? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Dividend — a share of a company's profit paid to shareholders"},{"key":"b","text":"Yield — the income an investment pays as a percentage of what you paid"},{"key":"c","text":"Index — a single number tracking how the market is moving overall"},{"key":"d","text":"Broker — a licensed firm allowed to buy and sell securities on the exchange for a client"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$Dividend, yield, index, and broker all belong in the plain glossary, each defined in words the client already owns.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-103'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
