-- =============================================================================
-- seed_cla203_content.sql  (v0.64.0)
-- CLA-203: Suitability & the basics of investment advisory — lesson + 20-question check (Proficient).
-- Authored BUILD+SOURCE (Tier B) off the firm's own policies (read-first OCR; anchors confirmed).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row added: the canonical role matrix
--   already maps CLA-203 to live job profiles (confirm live: verify_p5.sql / matrix query).
--   Publish-only (the REG/OPS pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$There is a line a broker must never cross without thinking: the line between taking an order and giving advice. The moment you suggest what a client should buy, sell, or hold, you have entered the territory of suitability — and suitability is not a courtesy, it is a regulatory obligation under the SEC's rules. This module builds the foundation of investment advisory at Transworld: what suitability is, how the Firm assesses it, how you move from a client's profile to a defensible recommendation, and how that connects to the duty to execute in the client's best interest. It is the anchor that later business-development training builds on, so it is worth getting exactly right. The concept of acting in a client's best interest is universal — care obligations appear in conduct regimes the world over — but the binding rule here is Nigerian, and Nigerian rule is what we teach.

## What you will be able to do

1. Explain what suitability is and why it is a regulatory obligation, not optional good service.
2. Conduct and use the risk-profile assessment the Operational Manual requires.
3. Move from a client's approved profile to a recommendation that matches it — and refuse one that does not.
4. Connect suitability (what to recommend) with best execution (how to execute it).
5. Apply the client-priority principle that ranks client interests above the Firm's own positions.

## Advice, not order-taking

Start with the boundary, because everything else depends on it. When a client simply instructs the Firm to buy or sell a named security and the Firm acts on that instruction without recommending it, that is execution-only — the Firm still owes best execution, but it has not advised. The moment an officer suggests what a client should buy, sell, or hold, or steers a hesitant client toward a choice, the Firm is giving advice and the suitability obligation attaches in full. The danger is the grey middle, where an officer slides from taking an order into shaping it without ever deciding which they are doing. The discipline is to know, in every conversation, whether you are executing or advising, and to apply suitability the instant the second begins. The care obligation behind this — that a firm advising a client must act in that client's best interest — is a principle conduct regimes share the world over; here it is given force by the Nigerian SEC's suitability rules and the Firm's own policies, and it is the Nigerian rule that binds.

## What suitability is

Suitability is the principle that any investment service or recommendation must fit the particular client in front of you — their objectives, their means, their tolerance for loss, and their understanding. The Operational Manual states it as both best practice and regulatory expectation under the SEC's suitability obligations: the Firm must assess every new client's suitability before providing any investment service. The reason is simple once said aloud. A product that is excellent for one client can be ruinous for another. A high-volatility small-cap might suit a young, knowledgeable, aggressive investor with income to spare and be entirely wrong for a retiree preserving capital. Suitability is the discipline of never confusing the two.

## The risk-profile assessment

The assessment is concrete, and the Operational Manual lists what it must capture. First, the client's investment objectives — capital growth, income, preservation, or speculation. Second, the client's financial situation — income, assets, liabilities, and liquidity needs — because a recommendation a client cannot afford to see fall is not suitable however attractive. Third, the client's risk tolerance — conservative, moderate, or aggressive — the honest answer to how much loss they could bear without abandoning the plan. Fourth, the client's investment knowledge and experience, because a sophisticated instrument handed to an inexperienced client is itself a risk. The Client Relationship Officer completes the risk-profile questionnaire with the client, and — importantly — the Compliance Officer reviews and approves the resulting risk classification. The officer gathers; Compliance signs off. The assessment is then reviewed whenever the client's circumstances change, and at least annually for active clients, because a profile set once and never revisited slowly stops describing the person.

## From profile to recommendation

A risk profile is only useful if it actually governs what you offer. The rule the Manual draws is firm: the products and services offered to a client must be consistent with the client's approved risk profile, and the Firm must never execute trades in instruments that are clearly unsuitable for a client's stated objectives and risk tolerance. This places a real duty on the relationship officer — not merely to match recommendations to the profile, but to flag any client instruction that appears inconsistent with it. That last point surprises people. If a conservative-profile client insists on a speculative position, the answer is not a silent click. It is a conversation: explain the mismatch, document it, and where the client still wishes to proceed against advice, ensure that decision is informed and recorded. Suitability does not strip clients of autonomy; it ensures that when they take a risk, they take it with their eyes open and the Firm's caution on the record.

Two disciplines make all of this real rather than rhetorical. The first is documentation: the risk profile, the recommendation, its rationale, and any against-advice decision are written down, because suitability that exists only in an officer's memory cannot protect either the client or the Firm. The second is the review cadence — the profile is revisited whenever the client's circumstances change, and at least annually for active clients — so the advice keeps pace with the person. A profile set once and never revisited slowly stops describing the client, and advice built on a stale profile is unsuitable however careful it felt at the time.

## Suitability and best execution: the two halves

Suitability decides *what* a client should do; best execution governs *how* the Firm does it once decided. The Best Execution Policy frames the Firm's duty plainly: anyone who entrusts an order is relying on the Firm to act in their best interest, and best execution is the obligation to take all reasonable steps to achieve the best possible result. The Firm weighs the execution factors — price, cost, speed, likelihood of execution and settlement, and the size and nature of the order — to deliver that result. The two halves are sequential and inseparable. A perfectly executed trade in an unsuitable instrument is still a failure of care, because suitability was wrong before execution began. A suitable recommendation executed carelessly — at a poor price, with avoidable cost — is also a failure of care. Good advisory work requires both: the right decision, executed the right way.

## Handling the order fairly

Best execution becomes concrete in how an order is handled once it reaches the desk. The duty applies whenever the Firm executes or places an order on a client's behalf, and within the NGX system the Firm's attention falls on the quality of order handling — the timing, the routing, and the decision of how and when to aggregate or phase a large order. Where the Firm bundles several clients' orders together, fairness is governed by fixed rules so that aggregation never quietly advantages one client or the Firm. Partial fills are allocated pro-rata to each client's original order size; every client in an aggregated trade receives the same average execution price, so no one pays a better or worse price merely for being bundled; the Firm's own proprietary interest is allocated last, after every client allocation is satisfied; and the allocation method must be fixed before execution, never chosen afterwards — there is no cherry-picking of the good fills. These rules are the operational form of the client-priority principle: where interests could collide, the client's is protected by design rather than by trust.

## Conflicts in execution

The advisory relationship is tested most where the Firm has an interest of its own, so the Best Execution Policy names the conflicts that matter in execution and how each is contained. The proprietary-trading conflict — where the Firm holds its own position in a security a client is trading — is managed by the absolute client-priority rule, by segregation of duties so the person managing the proprietary book has no discretion over the timing or handling of client orders, and by the Compliance Officer's monthly review of proprietary and client execution records. The staff personal-account conflict — where a dealing officer holds a personal position in a security a client is trading — is managed by the Personal Account Dealing Policy, under which every personal trade by regulated staff requires pre-clearance by the Compliance Officer; trading ahead of a client order is prohibited outright, as are market manipulation and insider dealing. Where a residual conflict cannot be wholly removed, it is disclosed to the client. The principle is consistent: a conflict is not a secret to be managed quietly but a risk to be controlled, evidenced, and where necessary disclosed.

## The client always comes first

Underneath both halves is a single principle the Investment and Proprietary Trading Policy states without qualification: client orders always take absolute priority over the Firm's own proprietary positions. No proprietary trade may be executed in a way that delays, disadvantages, or conflicts with a client order. This is the bedrock of advisory trust. A client who suspects the Firm trades ahead of them, or steers them toward products that serve the Firm rather than the client, will not stay — and should not. Managing that conflict of interest is not a soft value; it is the condition on which the advisory relationship exists at all. When in doubt, the client's interest is the tie-breaker, every time.

## A worked example

**Illustration — the retiree and the small-cap (entirely hypothetical).** A recently retired client, profiled as conservative with a primary objective of capital preservation and limited investment experience, reads about a fast-rising small-cap and asks the Firm to place a large share of his savings into it. The instruction is clearly inconsistent with his approved profile, so the relationship officer does not simply execute. The officer explains the mismatch between a speculative, volatile position and a preservation objective, sets out the realistic downside against the client's liquidity needs, and offers alternatives consistent with the profile. The conversation, the advice given, and the client's eventual decision are documented. If the client, fully informed, still wishes to proceed against advice with a smaller portion, that decision is recorded with the suitability caution on file; the profile is also revisited, since a sudden appetite for speculation may signal his circumstances or objectives have changed. Either way, when the trade is placed it is executed under the best-execution duty — the right care applied to both the *what* and the *how*.

## Common traps

- **Order-taking dressed up as advice.** The moment you recommend, suitability applies; do not give advice while pretending you only took an instruction.
- **Letting enthusiasm override the profile.** A client's excitement does not make an unsuitable instrument suitable; explain, document, and protect the client.
- **Treating the questionnaire as a one-time form.** Profiles are reviewed on any change in circumstances and at least annually for active clients.
- **Confusing best execution with suitability.** Suitability is *what* to do; best execution is *how* to do it — both are required, neither substitutes for the other.
- **Putting the Firm's position first.** Client orders always rank above the Firm's proprietary trades; the client's interest is the tie-breaker.

## Key takeaways

- Suitability is a regulatory obligation under the SEC's rules: assess every client before providing any investment service.
- The assessment captures objectives, financial situation, risk tolerance, and knowledge and experience; the CRO completes the questionnaire and the Compliance Officer approves the classification, reviewed on change and at least annually.
- Recommendations must match the approved profile; the Firm must never execute clearly unsuitable trades, and the officer must flag inconsistent instructions and document informed client decisions.
- Suitability decides what; best execution — all reasonable steps weighing price, cost, speed, and likelihood — governs how; both are needed for genuine care.
- Client orders always take absolute priority over the Firm's proprietary positions; managing that conflict is the condition of the advisory relationship.

*Reference: the Operational Manual v3.0 section 2.3 (Client Suitability and Risk Profiling — objectives, financial situation, risk tolerance, knowledge and experience; the CRO questionnaire and Compliance approval; the duty not to execute clearly unsuitable trades), the Best Execution Policy v3.0 (acting in the client's best interest; the execution factors), and the Investment and Proprietary Trading Policy v3.0 (the absolute priority of client orders over proprietary positions). The general concept of the advisory care obligation draws on open public conduct material (the U.S. SEC's best-interest guidance is used for concept only), but the binding suitability rule taught here is the Nigerian SEC obligation. The Firm's policies and the SEC's rules are the governing authority.$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'CLA-203';

-- 2) twenty graded questions (80%% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_01$id$, m.id, $p$Suitability is best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "an optional courtesy to good clients"}, {"key": "b", "text": "a regulatory obligation: any service or recommendation must fit the particular client"}, {"key": "c", "text": "a marketing technique"}, {"key": "d", "text": "a tax rule"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suitability is a regulatory obligation under the SEC's rules — the Firm must assess every client before providing any investment service.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_02$id$, m.id, $p$The suitability assessment must capture which four areas?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "name, address, phone, email"}, {"key": "b", "text": "investment objectives, financial situation, risk tolerance, and knowledge and experience"}, {"key": "c", "text": "favourite stocks, hobbies, age, employer"}, {"key": "d", "text": "only the amount to invest"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Operational Manual requires objectives, financial situation, risk tolerance, and investment knowledge and experience.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_03$id$, m.id, $p$Who completes the risk-profile questionnaire, and who approves the classification?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client completes it; no approval is needed"}, {"key": "b", "text": "the CRO completes it with the client; the Compliance Officer reviews and approves the classification"}, {"key": "c", "text": "the Board completes and approves it"}, {"key": "d", "text": "an external auditor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The CRO completes the questionnaire with the client, and the Compliance Officer reviews and approves the resulting risk classification.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_04$id$, m.id, $p$Products and services offered to a client must be...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "whatever the Firm wants to sell"}, {"key": "b", "text": "consistent with the client's approved risk profile"}, {"key": "c", "text": "the highest-commission products"}, {"key": "d", "text": "chosen at random"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Offerings must be consistent with the client's approved risk profile; the Firm must never execute clearly unsuitable trades.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_05$id$, m.id, $p$How often is a suitability assessment reviewed?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "never after onboarding"}, {"key": "b", "text": "whenever the client's circumstances change, and at least annually for active clients"}, {"key": "c", "text": "once every ten years"}, {"key": "d", "text": "only when the client complains"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The assessment is reviewed on any change in circumstances and at least annually for active clients.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_06$id$, m.id, $p$A conservative-profile client instructs a large speculative purchase. The officer should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "execute silently"}, {"key": "b", "text": "explain the mismatch, offer suitable alternatives, document the advice, and record an informed decision if the client still proceeds"}, {"key": "c", "text": "refuse all contact"}, {"key": "d", "text": "report the client to the SEC"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The officer must flag the inconsistency, advise, and document; suitability protects the client without removing autonomy when the client is fully informed.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_07$id$, m.id, $p$Suitability and best execution relate as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the same thing"}, {"key": "b", "text": "suitability is what to recommend; best execution is how to execute it"}, {"key": "c", "text": "best execution replaces suitability"}, {"key": "d", "text": "neither matters"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suitability decides what a client should do; best execution governs how the Firm carries it out — both are required.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_08$id$, m.id, $p$Best execution is the obligation to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "get the fastest fill regardless of cost"}, {"key": "b", "text": "take all reasonable steps to achieve the best possible result for the client"}, {"key": "c", "text": "favour the Firm's positions"}, {"key": "d", "text": "execute only large orders"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Best Execution Policy defines it as taking all reasonable steps to achieve the best possible result for the client.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_09$id$, m.id, $p$Which of these is an execution factor the Firm weighs?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client's nationality"}, {"key": "b", "text": "price, cost, speed, and likelihood of execution and settlement"}, {"key": "c", "text": "the officer's mood"}, {"key": "d", "text": "the day of the week"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Execution factors include price, cost, speed, likelihood of execution and settlement, and the size and nature of the order.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_10$id$, m.id, $p$The Investment and Proprietary Trading Policy states that client orders...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "rank below the Firm's proprietary positions"}, {"key": "b", "text": "always take absolute priority over the Firm's proprietary positions"}, {"key": "c", "text": "are optional"}, {"key": "d", "text": "may be delayed for firm trades"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client orders always take absolute priority; no proprietary trade may delay, disadvantage, or conflict with a client order.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_11$id$, m.id, $p$A perfectly executed trade in an unsuitable instrument is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "fully acceptable"}, {"key": "b", "text": "still a failure of care, because suitability was wrong before execution began"}, {"key": "c", "text": "the client's fault only"}, {"key": "d", "text": "best execution at its finest"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Good execution cannot cure an unsuitable recommendation — both the what and the how must be right.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_12$id$, m.id, $p$Risk tolerance is best understood as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the client's age"}, {"key": "b", "text": "how much loss the client can bear without abandoning the plan (conservative, moderate, aggressive)"}, {"key": "c", "text": "the client's income alone"}, {"key": "d", "text": "the Firm's appetite for risk"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Risk tolerance is the client's honest capacity to bear loss — conservative, moderate, or aggressive.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_13$id$, m.id, $p$The difference between order-taking and advice matters because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "there is no difference"}, {"key": "b", "text": "the moment you recommend what to buy, sell, or hold, suitability obligations apply"}, {"key": "c", "text": "advice is always cheaper"}, {"key": "d", "text": "orders are illegal"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Suitability attaches the moment you give a recommendation; you cannot give advice while pretending you merely took an order.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_14$id$, m.id, $p$Why must a client's financial situation be assessed?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "to set fees"}, {"key": "b", "text": "because a recommendation a client cannot afford to see fall is not suitable, however attractive"}, {"key": "c", "text": "to deny service"}, {"key": "d", "text": "it need not be assessed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Financial situation — income, assets, liabilities, liquidity — bounds what is genuinely suitable for the client.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_15$id$, m.id, $p$Investment knowledge and experience matter because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "they do not"}, {"key": "b", "text": "a sophisticated instrument handed to an inexperienced client is itself a risk"}, {"key": "c", "text": "only wealthy clients understand investing"}, {"key": "d", "text": "experience replaces a risk profile"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Knowledge and experience are part of suitability; complexity unsuited to the client's understanding is a risk in itself.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_16$id$, m.id, $p$When a client proceeds against advice after being fully informed, the Firm should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "pretend the advice was never given"}, {"key": "b", "text": "record the decision with the suitability caution on file and revisit the profile"}, {"key": "c", "text": "execute without any record"}, {"key": "d", "text": "close the account"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An informed against-advice decision is documented with the caution on file, and the profile is revisited for possible change.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_17$id$, m.id, $p$Managing the conflict between the Firm's positions and the client's interest is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a soft, optional value"}, {"key": "b", "text": "the condition on which the advisory relationship exists at all"}, {"key": "c", "text": "the SEC's job, not the Firm's"}, {"key": "d", "text": "irrelevant to retention"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Client priority over proprietary positions is the bedrock of advisory trust — the relationship depends on it.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_18$id$, m.id, $p$In this module, the binding suitability rule taught is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the U.S. SEC best-interest rule"}, {"key": "b", "text": "the Nigerian SEC suitability obligation"}, {"key": "c", "text": "a FINRA rule"}, {"key": "d", "text": "there is no binding rule"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The care concept is universal, but the binding rule taught is the Nigerian SEC suitability obligation — concept travels, rules do not.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_19$id$, m.id, $p$This module is the foundation for later training in...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "payroll administration"}, {"key": "b", "text": "consultative selling and business development (e.g., BDV-201)"}, {"key": "c", "text": "data-centre operations"}, {"key": "d", "text": "building maintenance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$CLA-203 is the suitability anchor that consultative-selling and business-development modules build upon.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_cla203_20$id$, m.id, $p$The single tie-breaker when the Firm's interest and the client's interest conflict is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "whichever earns more commission"}, {"key": "b", "text": "the client's interest, every time"}, {"key": "c", "text": "the larger trade"}, {"key": "d", "text": "the Firm's proprietary book"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$When in doubt, the client's interest is the tie-breaker; client orders always rank above the Firm's own positions.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'CLA-203'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'CLA-203';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: CLA-203 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'CLA-203' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: CLA-203 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: CLA-203 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
