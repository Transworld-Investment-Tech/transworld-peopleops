-- =============================================================================
-- seed_bdv205_content.sql  (v0.67.0)
-- BDV-205: Compliant selling: market conduct, suitability, inducements & what you may say — lesson + 20-question check (Proficient).
-- Authored FROM POLICY (Tier A); Code of Ethics CO-POL-001 + CoI CO-POL-002 + Gift/Benefit/Hospitality HR-POL-006 + Compliance Manual §§10/15 + Complaint Mgmt; ISA 2025 (DF-10). CCO post-publish review. ESR v1.1 row BDV-205.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule: BDV-2xx are role-targeted via seed_bdv2xx_role_matrix.sql
--   (BDV-2xx were ABSENT from the canonical matrix; this batch ships that seed + a
--   canonical patch). Confirm live: verify_p7.sql.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Everything else in business development is technique; this is the law of the thing. You can be a brilliant prospector, a skilled questioner and a persuasive presenter, and still end your career — and damage the firm — in an afternoon, by saying something you may not say, recommending something that does not suit, accepting something you must decline, or trading on something you should not know. Compliant selling is the set of fixed rules inside which all the selling happens. They are not the firm's preferences; they are binding obligations under Nigerian law and the firm's own policies, and they do not bend for a big client or a hard month. This module sets out four pillars — market conduct, suitability, inducements, and what you may say — and the firm expects every person who represents it in front of a client to know them cold.

## What you will be able to do

1. State the market-conduct rules that bind anyone who sells: no insider dealing, no manipulation, and the absolute priority of the client.
2. Apply the suitability obligation at the point of sale.
3. Apply the firm's inducement and gift rules, including the duty to decline and disclose.
4. Recognize what you may and may not say to a client, and disclose conflicts early and in writing.
5. Know what to do, and whom to tell, when something goes wrong.

## Pillar one — market conduct

Market conduct is about the integrity of the market itself, and the Compliance Manual treats breaches here as among the most serious a stockbroking firm can commit. Three rules bind the person who sells. The first is the prohibition on **insider dealing**: you may not trade, or advise a client to trade, on the basis of material non-public information — price-sensitive information that the market does not have. This is a criminal offence under the Investments and Securities Act (ISA) 2025, and the rule is simple in practice: if you hold information about a company that has not been announced and that could move its price, you do not act on it, you do not pass it on, and if you are unsure whether what you hold counts, you ask the Compliance Officer before doing anything. The second rule prohibits **market manipulation** — any practice that creates an artificial or misleading price or trading volume, such as trading designed to fake activity, trading ahead of a client's order to profit from the move it will cause, or spreading false information to influence prices. The third, and the one a salesperson meets most often, is **client priority as the absolute rule**: client orders always take precedence over the firm's own proprietary interest. A client's instruction may never be delayed so the firm's own book can be positioned first, and the firm's interest never trumps the client's. In a selling role these rules show up as hard limits on what you may promise, what information you may use, and whose interest comes first — and the answer to the last is always the client's.

## Pillar two — suitability at the point of sale

The suitability obligation, which you met in CLA-203, is not an advisory nicety that lives only in the formal advice process; it binds the moment of sale. You may not recommend a product that does not fit the client's objectives, time horizon, risk tolerance, risk capacity and circumstances — full stop, and regardless of whether the client asks for it, whether it pays the firm more, or whether it would close a slow month. Client First, one of the firm's core values, is not a slogan; it is the rule that decides every close. Where a client wants something unsuitable, the compliant path is to explain why it does not fit and to decline to recommend it, not to find a way to write it up. The suitability assessment is documented because it is both the right way to advise and the evidence the firm relies on if a recommendation is ever questioned. A sale made against suitability is a breach even if the client was delighted at the time.

## Pillar three — inducements and gifts

This is where good intentions and Nigerian business custom can collide with a hard rule, so it must be stated plainly. Under the firm's Gift, Benefit and Hospitality Policy, the **personal receipt of gifts from clients is prohibited at all value levels — there is no minimum threshold below which a gift is acceptable.** It does not matter whether the gift is small, whether it is offered warmly as thanks, or through what channel it arrives: cash, a bank transfer, mobile money, or goods are all caught. The reason is that a personal benefit flowing from a client to the person who advises or serves them is an inducement — it bends, or appears to bend, the advice toward the giver — and the firm removes the problem entirely by forbidding personal receipt rather than trying to police a "reasonable" amount.

The required response is a fixed two-step. First, **decline**: politely and firmly refuse personal receipt, explaining that the firm's policy does not permit it. Second, **disclose**: complete the Gift and Benefit Disclosure Form (F-26) and submit it to Compliance within 24 hours, recording what was offered, by whom, and the action taken. Declining without disclosing is not enough, because the disclosure is what protects you and creates the record. The same logic runs through the Conflict of Interest Policy: a conflict — including any personal interest that could bend your advice — must be disclosed early and in writing, before any decision is taken, because, as that policy puts it, the price of silence is always higher than the price of disclosure. A conflict disclosed early is almost never a disciplinary matter; the same conflict hidden and later discovered almost always is. Offering an inducement is equally forbidden: you may not sweeten a client's decision with a personal benefit any more than you may accept one.

## Pillar four — what you may say

The firm's standards of conduct set the boundary of speech in a single line: integrity means never overstating what a product can deliver. From that flow the concrete limits. You may not promise or guarantee a return, because no investment return is certain and implying certainty is misleading. You may not present a product as safer, or more rewarding, than it is. You must give risks genuine prominence alongside benefits, and you must not engineer a true-but-misleading impression by selecting only the flattering facts. You must treat all clients fairly — the same honest process for every client, not preferential treatment for the large account or the personal friend. And you must disclose conflicts as you go, in writing. Mature markets capture the same idea in their best-interest and fair-communication rules — the US notions of acting in the client's best interest and keeping communications fair, balanced and not misleading are the same instinct — but those are reference concepts only; the binding rule is the firm's own conduct standard under Nigerian regulation, and that is the one your words must meet.

## When something goes wrong

Even careful people meet situations that go sideways: a client complains that they were misled, a colleague crosses a line, or you realize after the fact that something was said or done that should not have been. The firm's expectation is that you surface it, not bury it. A client complaint is handled through the Complaint Management Policy, with its acknowledged timelines, rather than managed quietly to make it disappear. Conduct concerns — including anything touching insider information, manipulation, or pressure on suitability — go to the Compliance Officer, who has the authority and whose judgment on a conduct question is final. Where a concern involves the Compliance Officer or cannot be raised normally, the whistleblowing mechanism allows it to go directly to the BARC Chair or the Chairman, confidentially and without retaliation. Speaking up is, in the words of the firm's own standards, always the right thing to do.

## Why these rules are absolute

It is fair to ask why these rules admit no exceptions, when so much else in business is a matter of judgment. The answer is that the firm's permission to operate depends on them. Transworld trades on the Nigerian Exchange and is licensed and supervised by the Securities and Exchange Commission, and that license rests on the firm conducting itself honestly in the market and toward its clients. A serious conduct breach is not a private matter between a salesperson and one client; it is a threat to the firm's authorization, its standing with the regulators, and the livelihoods of everyone who works there. The Compliance Manual is explicit that market-conduct breaches are among the gravest a stockbroking firm can commit, and the consequences — criminal liability for the individual, penalties and reputational damage for the firm, loss of regulatory authorization at the extreme — are out of all proportion to whatever a single rule-breaking sale might have earned.

That is why there is no large-client exception and no hard-month exception. The temptation to bend a rule is always strongest exactly when the stakes feel high — the large mandate that hinges on a promise you should not make, the slow quarter that an unsuitable sale would rescue — and that is precisely when the rule does its most important work. A rule that applied only when it was convenient would protect nothing. The discipline, then, is to treat these obligations as fixed points you navigate around rather than as obstacles to argue with, and to bring the hard cases to the Compliance Officer early rather than resolving them quietly in your own favour. The salesperson who internalizes that the rules are the condition of the firm's existence, not a constraint on its business, is the one the firm can trust in front of a client — and trustworthiness in front of a client is, in the end, the entire job.

## A worked example

**Illustration — the guarantee and the envelope (entirely hypothetical).** The client and details are invented for teaching. A prospective client, "Mrs Okoro," wants to invest a substantial sum and says she will proceed only if you can assure her of a thirty percent return within the year; as the conversation warms, she slides an envelope of cash across the desk as a token of thanks for looking after her. The compliant path runs through all four pillars at once. On what you may say: you cannot and do not guarantee thirty percent, or any return — you explain, plainly, that no honest firm can promise that, and you set out a suitable recommendation with its real risks. On suitability: you size and shape the recommendation to her actual objectives and risk profile, not to the return she has demanded. On inducements: you decline the envelope then and there, explain that firm policy forbids personal receipt of any client gift at any value, and complete the F-26 disclosure to Compliance within 24 hours. On market conduct and client priority: nothing about the eventual order is positioned behind the firm's own interest. The sale you might make is the suitable one Mrs Okoro can be properly advised into; the things she asked for — a guarantee and a gift — are precisely the things you must refuse. Refusing them is not losing the client; it is the only way to keep her, and the firm, on the right side of the line.

## Common traps

- **Treating suitability as advisory-only.** It binds at the point of sale; a delighted client does not cure an unsuitable recommendation.
- **Assuming a small gift is fine.** There is no de minimis — personal receipt of any client gift, by any channel, is prohibited; decline and disclose on F-26 within 24 hours.
- **Declining a gift but not disclosing it.** The disclosure is what creates the record and protects you; both steps are required.
- **Implying certainty.** "Guaranteed," "always recovers," "can't lose" — each overstates what a product can deliver and is misleading.
- **Hiding a conflict to avoid awkwardness.** Disclosed early in writing, it is almost never disciplinary; hidden and discovered, it almost always is.

## Key takeaways

- Market conduct binds every seller: no insider dealing (a criminal offence under ISA 2025), no manipulation, and client priority is absolute.
- Suitability binds at the point of sale; you may not recommend the unsuitable however much the client wants it or the firm earns from it.
- Personal receipt of client gifts is prohibited at all value levels — decline, then disclose on Form F-26 within 24 hours; disclose conflicts early and in writing.
- What you may say is bounded by integrity: never overstate, never guarantee, give risks genuine prominence, treat all clients fairly.
- When something goes wrong, surface it — through Complaint Management, the Compliance Officer, or the whistleblowing channel — never bury it.

*Build mode: FROM POLICY (Tier A) — this module teaches binding Transworld policy and current Nigerian law. Binding sources: Code of Ethics CO-POL-001; Conflict of Interest Policy CO-POL-002 v3.0; Gift, Benefit and Hospitality Policy HR-POL-006 v1.0; Compliance Manual v3.0 (§10 Market Conduct and §15 Standards of Conduct and Ethics); Complaint Management Policy v3.0. External material — the US SEC best-interest concept and FINRA fair-communication/suitability rules — is GOV-PUBLIC reference only; the binding rule is internal and Nigerian. Current law taught: insider dealing and market manipulation under the Investments and Securities Act (ISA) 2025 (the source documents' "ISA 2024" is a known currency divergence, logged as DF-10; no source edited). House style: Internal Control Framework v3.0. Standard: External Source Register v1.1 (row BDV-205). Reviewed post-publish by the CCO. Authored original to the house voice; no text reproduced from any source.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-205';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_01$id$, m.id, $p$Trading, or advising a client to trade, on material non-public information is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "insider dealing — a criminal offence under the Investments and Securities Act (ISA) 2025"}, {"key": "b", "text": "permitted if the client benefits"}, {"key": "c", "text": "allowed for small orders"}, {"key": "d", "text": "a matter of personal discretion"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Insider dealing is prohibited and criminal; if unsure whether information counts, ask the Compliance Officer first.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_02$id$, m.id, $p$Under the firm's market-conduct rules, client orders...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "may be delayed so the firm's book is positioned first"}, {"key": "b", "text": "always take priority over the firm's own proprietary interest"}, {"key": "c", "text": "rank below proprietary trades"}, {"key": "d", "text": "may be reordered to favour large clients"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client priority is the absolute rule; the firm's interest never trumps the client's instruction.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_03$id$, m.id, $p$The suitability obligation at the point of sale means you may not recommend an unsuitable product...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "unless the client insists"}, {"key": "b", "text": "unless it pays the firm more"}, {"key": "c", "text": "at all — regardless of the client's wish, the firm's earnings, or a slow month"}, {"key": "d", "text": "unless it closes the sale today"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Suitability binds the moment of sale; a client's request does not make an unsuitable recommendation permissible.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_04$id$, m.id, $p$Under the Gift, Benefit and Hospitality Policy, personal receipt of a client gift is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fine if below a set value"}, {"key": "b", "text": "fine if offered as genuine thanks"}, {"key": "c", "text": "fine if it arrives as mobile money"}, {"key": "d", "text": "prohibited at all value levels, through any channel"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$There is no de minimis; cash, transfer, mobile money or goods are all caught, regardless of intent.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_05$id$, m.id, $p$The required response to an offered client gift is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "decline personal receipt, then disclose on Form F-26 to Compliance within 24 hours"}, {"key": "b", "text": "accept it and say nothing"}, {"key": "c", "text": "decline it and take no further step"}, {"key": "d", "text": "keep it if it is small"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Both steps are required: declining alone is insufficient; the F-26 disclosure creates the protecting record.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_06$id$, m.id, $p$A conflict of interest should be disclosed...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "only if discovered by Compliance"}, {"key": "b", "text": "early and in writing, before any decision is taken"}, {"key": "c", "text": "at year-end"}, {"key": "d", "text": "never, to avoid awkwardness"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Conflict of Interest Policy: disclose early in writing — the price of silence is always higher than the price of disclosure.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_07$id$, m.id, $p$The firm's standards of conduct express the boundary of what you may say as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "close every sale"}, {"key": "b", "text": "guarantee outcomes to build trust"}, {"key": "c", "text": "integrity means never overstating what a product can deliver"}, {"key": "d", "text": "headline the best historical return"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Compliance Manual §15 ties integrity directly to never overstating a product's capability.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_08$id$, m.id, $p$Guaranteeing a client a specific investment return is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "acceptable for low-risk products"}, {"key": "b", "text": "required to win the business"}, {"key": "c", "text": "fine if you believe it"}, {"key": "d", "text": "misleading, because no investment return is certain"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Implying certainty of return overstates what the product can deliver and breaches the conduct standard.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_09$id$, m.id, $p$Market manipulation includes...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "trading designed to fake volume, front-running a client order, or spreading false information"}, {"key": "b", "text": "recommending a suitable diversified portfolio"}, {"key": "c", "text": "disclosing a conflict"}, {"key": "d", "text": "declining an unsuitable sale"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Any practice creating an artificial or misleading price or volume is prohibited manipulation.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_10$id$, m.id, $p$A sale made against suitability where the client was delighted at the time is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully compliant"}, {"key": "b", "text": "still a breach"}, {"key": "c", "text": "acceptable if documented"}, {"key": "d", "text": "a model outcome"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client satisfaction does not cure an unsuitable recommendation; suitability is a binding obligation.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_11$id$, m.id, $p$If you are unsure whether information you hold is material non-public information, you should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "trade cautiously on it"}, {"key": "b", "text": "share it only with one client"}, {"key": "c", "text": "ask the Compliance Officer before doing anything; their judgment is final"}, {"key": "d", "text": "assume it is public"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$On a conduct question the Compliance Officer's judgment is final; ask before acting.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_12$id$, m.id, $p$Treating all clients fairly means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "favouring the largest account"}, {"key": "b", "text": "preferential terms for personal friends"}, {"key": "c", "text": "a different process per client"}, {"key": "d", "text": "the same honest process for every client"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Fair dealing requires equitable treatment, not preference based on account size or relationship.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_13$id$, m.id, $p$Offering a client a personal sweetener to tip their decision is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an inducement, equally forbidden as accepting one"}, {"key": "b", "text": "good closing practice"}, {"key": "c", "text": "permitted if disclosed later"}, {"key": "d", "text": "required for large deals"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$You may neither accept nor offer a personal inducement; both bend, or appear to bend, the decision.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_14$id$, m.id, $p$In the worked example, when Mrs Okoro demands a guaranteed 30% return, the compliant response is to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "guarantee 30% to win the business"}, {"key": "b", "text": "explain that no honest firm can promise that, and set out a suitable recommendation with its real risks"}, {"key": "c", "text": "imply the return is likely"}, {"key": "d", "text": "accept her envelope as thanks"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$You cannot guarantee any return; you advise suitably and disclose the genuine risks.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_15$id$, m.id, $p$In the worked example, the cash envelope offered as thanks should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "accepted since it is a token"}, {"key": "b", "text": "accepted if under a threshold"}, {"key": "c", "text": "declined, with the offer disclosed on Form F-26 to Compliance within 24 hours"}, {"key": "d", "text": "kept quietly"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Personal receipt is prohibited at any value; decline and disclose via F-26 within 24 hours.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_16$id$, m.id, $p$A client complaint that the firm misled them should be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "managed quietly to make it disappear"}, {"key": "b", "text": "ignored"}, {"key": "c", "text": "settled with a personal gift"}, {"key": "d", "text": "handled through the Complaint Management Policy and its timelines"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Complaints follow the Complaint Management Policy; they are surfaced and handled, not buried.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_17$id$, m.id, $p$Where a conduct concern involves the Compliance Officer, it may be raised...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "directly with the BARC Chair or the Chairman, confidentially and without retaliation"}, {"key": "b", "text": "only with the Compliance Officer"}, {"key": "c", "text": "nowhere"}, {"key": "d", "text": "with the client"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The whistleblowing mechanism routes such concerns to the BARC Chair or Chairman, protected from retaliation.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_18$id$, m.id, $p$Selecting only the flattering facts to leave a client with a false impression is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fair and balanced"}, {"key": "b", "text": "misleading, even if each fact is true"}, {"key": "c", "text": "required disclosure"}, {"key": "d", "text": "permitted in a pitch"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A true-but-engineered impression still misleads and breaches the fair, clear and not-misleading standard.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_19$id$, m.id, $p$US best-interest and fair-communication rules (SEC/FINRA) are used in this module as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the binding rule overriding Nigerian law"}, {"key": "b", "text": "an exemption from the firm's policies"}, {"key": "c", "text": "reference concepts; the binding rule is the firm's own conduct standard under Nigerian regulation"}, {"key": "d", "text": "optional guidance to ignore"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Concept travels, rules do not — the external standards illustrate; the firm's Nigerian-regulated standard binds.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv205_20$id$, m.id, $p$The unifying message of compliant selling is that the firm's conduct rules...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "bend for a big client"}, {"key": "b", "text": "relax in a hard month"}, {"key": "c", "text": "are mere preferences"}, {"key": "d", "text": "are binding obligations that hold regardless of the client or the pressure"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Market conduct, suitability, inducement and speech rules are fixed obligations the seller must know cold.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-205'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'BDV-205';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: BDV-205 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'BDV-205' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: BDV-205 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: BDV-205 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
