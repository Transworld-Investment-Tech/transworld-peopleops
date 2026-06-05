-- =============================================================================
-- seed_fnd104_content.sql -- FND-104 AML/CFT & KYC Awareness: lesson + 20-question check (v0.43.2 content)
-- Authored FROM POLICY: AML/CFT/CPF Policy v3.0 + KYC Policy v3.0 (March 2026). Tier A (CCO-owned).
-- DATA, not schema. Run AFTER 0031/0032 + seed_lms_curriculum.sql (which seeds the FND-104 shell).
-- Idempotent (module UPDATE by code; questions upsert by id). Pass mark 80, estimated 30 min.
-- =============================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated minutes
UPDATE "learning_modules"
SET body = $body$We are a stockbroking firm, and that makes us a target. The capital market is attractive to criminals for one simple reason: it can turn cash into securities, generate returns that look like honest profit, and move money across accounts and institutions in ways that are hard to trace. A criminal who deposits dirty money into a trading account, buys and sells for a while, and withdraws the "proceeds" has — if we are not careful — used Transworld to wash their money clean. And the law does not care that we did not know. A firm that lets this happen becomes an **unwitting but legally liable** participant in a crime.

That is why anti-money-laundering and counter-terrorist-financing (AML/CFT) is not the Compliance Officer's job alone. It is **your** job, every day, in every client interaction. This module explains the two crimes we are guarding against, the warning signs you must recognize, why our Know Your Client (KYC) standard exists, and the two duties you can never set aside: **report a suspicion**, and **never tip a client off**.

## What you will be able to do

1. Explain money laundering and terrorism financing in plain terms, and recognize where in a transaction suspicious activity tends to appear.
2. Spot the common red flags — and apply the firm's mantra: **when in doubt, report**.
3. Explain *why* KYC protects both the client and the firm, and apply the standard that a document which does not establish what it is meant to establish is not KYC at all.
4. Recognize a Politically Exposed Person — including their family and close associates — and understand that we serve PEPs with extra care and mandatory reporting, not refusal.

## The two crimes, in plain terms

**Money laundering** is the process of making "dirty" money look "clean." It usually moves through three stages, though in practice they overlap:

- **Placement** — getting illegal cash into the financial system. This is the riskiest stage for the criminal. Watch for cash deposits, or funding an account through many third-party transfers each kept just under a reporting threshold (called **structuring** or **smurfing**).
- **Layering** — hiding the trail. Rapid buying and selling with no real investment logic, cross-broker transfers, nominee accounts, or converting funds to foreign currency or crypto.
- **Integration** — the money re-emerges looking legitimate: "investment gains" withdrawn from a trading account, or "profits" used to buy property.

Under Nigerian law, money laundering covers three core acts: **concealing, converting, or transferring** property you know or suspect came from crime; **being concerned in an arrangement** that helps someone else handle it; and **acquiring, using, or possessing** it. There are also two secondary offences that fall directly on staff: **failing to disclose** a suspicion you have formed, and **tipping off**.

**Terrorism financing** is different in one crucial way: the money does **not** have to come from crime. It can be raised from legitimate business income, savings, or donations. The offence is not where the money comes from — it is **what it is used for**. So you cannot assume a client is safe just because their funds look clean. (Closely related is proliferation financing — funding weapons of mass destruction — which our framework treats with the same seriousness.)

>! **The stakes are real.** Under the AML/CFT Act 2022, an individual convicted of money laundering faces a minimum of seven years' imprisonment; terrorism-financing offences can carry life. The firm faces fines of ₦25 million or more, and the SEC, NGX, or NFIU can suspend or revoke our license — every client relationship and every job here depends on it. And remember: **ignorance is not a defense.** If you fail to take the steps a reasonable person in your position would have taken, you can be personally liable even if you did not know.

## Red flags you should recognize

You are not expected to be an investigator. You are expected to *notice* — and to escalate. Common warning signs include a client who is reluctant to provide KYC information or gives inconsistent answers; transactions that don't fit what we know about the client; amounts deliberately kept just below reporting thresholds; sudden, rapid movement of funds in and out with no economic logic; and instructions to send money to new or unexpected destinations.

> **When in doubt, report.** You never have to decide on your own whether something is "suspicious enough." Raise it with the Compliance Officer and let her judge. Reporting a concern that turns out to be nothing costs us nothing. Staying silent about something that mattered can be a crime.

## KYC is not a necessary evil — it is the foundation

Let us be direct, because this is where we have struggled. KYC is too often treated as paperwork to rush through before the "real" work begins. That is exactly backwards. Without complete, current, and genuine KYC, **we do not know who our clients are** — and a firm that does not know its clients cannot protect them, cannot protect itself, and cannot meet its most basic regulatory obligations. This is not theoretical: an NGX inspection reviewed ten of our client files and found **every single one deficient.** That is the gap we are closing, and every one of us owns a piece of it.

So insist on KYC, and insist on it properly. A few standards to hold without exception:

- **A document must actually establish what it is for.** A utility bill that does not show the client's residential address is **not** proof of address — it is not KYC. A verbal ID number is not identification. Collect the right document, in the right form.
- **An expired document is the same as no document.** When a client's ID expires, their account is restricted until it is renewed — no exceptions.
- **Tiers match documentation.** The SEC three-tier framework places every client by the documents they provide: **Tier 1** (basic ID, lowest limits, reviewed every 36 months), **Tier 2** (fuller KYC plus BVN, higher limits, every 24 months), and **Tier 3** (full KYC — NIN + BVN + government photo ID, highest limits, reviewed every **12 months**). A client can never be given service beyond their tier's limits.
- **The KYC Completeness Score is your dashboard.** 100% is green; 80–99% is amber (a gap to close); **below 80% is red** and limits are suspended to the level the valid documents support; **0% means no valid documents and no transactions at all.**
- For corporate clients, identify the **ultimate beneficial owners** — anyone owning or controlling **5% or more**.

## Politically Exposed Persons — pay attention here

In our environment it is easy to look at a prominent politician, or their spouse or business partner, and see simply a "successful," "big" client to be welcomed. **That instinct is precisely the risk.** A person in public office is a public servant entrusted with public resources — and that position can create opportunities for corrupt enrichment, or can be exploited by others. None of this assumes guilt; the vast majority of PEPs are entirely legitimate. But the risk is real enough that the law requires us to treat these relationships with extra care.

A **Politically Exposed Person** is not just a politician. Internationally and under our rules, a PEP is anyone who holds or has held a prominent public function — **and** their **immediate family** (spouse, children and their spouses, parents, siblings) — **and** their **close associates** (business partners and trusted associates who might transact on their behalf). It covers domestic officials, foreign officials, and senior officials of international bodies. A **former** PEP is still treated as a PEP for **at least twelve months** after leaving office, and longer if the Compliance Officer judges the risk warrants it.

Two things must be crystal clear:

1. **A PEP is not someone we refuse.** We can and do serve PEPs. What changes is the level of care — Enhanced Due Diligence, verifying source of funds *and* source of wealth, adverse-media checks, **senior management approval** before the relationship begins, and closer ongoing monitoring.
2. **We are required by regulation to report their transactions.** PEP accounts are monitored monthly, and the firm files a monthly PEP return with the SEC and NFIU. This is not optional and it is not a judgment call.

> If you are not certain whether a client — or someone connected to them — is a PEP, treat the question the same way you treat everything in this module: **when in doubt, report it** to the Compliance Officer.

## Dormant accounts and the duty to use your judgment

Some of the highest risk sits in accounts that have been quiet for years and then suddenly come alive. A criminal knows a long-dormant account attracts less attention. So when an account that has not traded for **three or more years** reactivates, standard documents are not enough — because the real question is not only "who are you?" but "are you the same person who opened this account?"

That means we go further. We require current KYC documents **plus genuine evidence of the prior relationship** — an original or verified previous contract note, payment voucher, correspondence, account statement, or share certificate. **A photo of a document taken on a phone is not acceptable.** And where your judgment says the situation warrants it, going further can mean **commissioning a physical visit and an in-person meeting** to confirm the client is genuine. Do not wait to be told — if a long-dormant account stirs, **flag it and start the extended process yourself.** Trading stays suspended until it is complete.

## Your two non-negotiable duties

>! **Duty one — report suspicion.** You do not need proof. You do not need to be sure a crime occurred. "Reasonable suspicion" is a deliberately low bar: a genuine, reasonable belief that something is not right. Suspicion alone triggers your duty. Tell the Compliance Officer — our Money Laundering Reporting Officer (MLRO) — the **same business day**, using an internal report. She decides whether to file a Suspicious Transaction Report (STR) with the NFIU, which must go in within **24 hours** of the suspicion being formed. Filing in good faith carries legal immunity, so there is no downside to reporting and a potentially criminal downside to staying silent.

A quick distinction worth remembering: a **CTR** (Currency Transaction Report) is automatic and triggered purely by **amount** — at or above **₦5 million** for an individual or **₦10 million** for a corporate client, in cash, filed within 7 days (even if the transaction was only attempted). An **STR** is triggered by **suspicion**, with **no minimum amount** — a ₦10,000 transaction that looks wrong must be reported just as a ₦100 million one would.

>! **Duty two — never tip off.** Once a suspicion has been formed or an STR filed, **no one** — not the CRO, not the Managing Director, not the Chairman — may say or do anything that signals to the client that they are under suspicion. Do not hint a report exists; do not start asking pointed questions about their funds in a way that gives it away. **Keep interacting with the client completely normally.** Tipping off is itself a criminal offence under the AML/CFT Act 2022. If acting normally feels impossible, tell the Compliance Officer immediately.

## Sanctions, in brief

Every client is screened at onboarding, and existing clients are re-screened regularly, against the major sanctions lists (UN, OFAC, EU/UK, the NFIU watchlist, and the EFCC list). If a screening produces a possible match — a "hit" — the transaction is **suspended and escalated to the Compliance Officer within two hours**. She determines whether it is a genuine match (in which case the account is frozen and reported) or a false positive (documented and released). Your part is simple: if the system flags a possible match, stop and escalate — never wave it through.

---

## Key takeaways

- AML/CFT is **everyone's** job, and **ignorance is not a defense**.
- Money laundering moves through **placement, layering, and integration**; terrorism financing is about **how money is used**, not where it came from.
- KYC is the **foundation**, not paperwork — a document that does not establish what it is meant to (a utility bill with no address) **is not KYC**, and an **expired document is no document**.
- A **PEP includes family and close associates**; we **serve** PEPs with **enhanced care and mandatory reporting**, never blanket refusal.
- A **dormant account waking up** demands extended KYC — genuine evidence of prior ownership, and a **physical visit** where judgment calls for it.
- **Reasonable suspicion is a low bar**; report to the **MLRO** on suspicion alone, and **never tip off** — both are criminal lines.

> Whatever the situation, the mantra holds: **when in doubt, report.**

## References

- **AML/CFT/CPF Policy v3.0** and **KYC Policy v3.0** (March 2026, Board Approval Edition) — primary sources for this module.
- Companion: Compliance Manual v3.0 (AML/KYC procedures); Operational & Procedure Manual v3.0.
- Regulatory basis: Money Laundering (Prevention and Prohibition) Act 2022; Terrorism (Prevention and Prohibition) Act 2022; ISA 2024; SEC AML/CFT Rules; NFIU Guidelines; FATF 40 Recommendations.
- *Mandatory module · on joining and annual refresh. Content owner: Chief Compliance Officer. Re-verify against the source policies at each annual cycle.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-104';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_01$id$, m.id, $p$Whose responsibility is AML/CFT compliance at Transworld?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only the Compliance Officer and the MLRO"}, {"key": "b", "text": "Only client-facing staff such as CROs and dealing clerks"}, {"key": "c", "text": "All staff at every level, together with management and the Board"}, {"key": "d", "text": "Only senior management"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$AML/CFT is everyone's job — all staff, management, and the Board. It is not the Compliance team's responsibility alone.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_02$id$, m.id, $p$The three stages of money laundering, in order, are:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Placement, layering, integration"}, {"key": "b", "text": "Integration, layering, placement"}, {"key": "c", "text": "Deposit, trade, withdraw"}, {"key": "d", "text": "Raising, moving, using"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Money laundering typically moves through placement (getting cash in), layering (hiding the trail), then integration (the funds re-emerge looking legitimate).$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_03$id$, m.id, $p$Terrorism financing only involves money obtained from crime.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Terrorism financing can use entirely legitimate funds. The offence is what the money is used for, not where it came from.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_04$id$, m.id, $p$Which of the following are money-laundering red flags? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Structuring deposits to keep each one just below a reporting threshold"}, {"key": "b", "text": "Rapid buying and selling with no apparent investment logic"}, {"key": "c", "text": "A client who is reluctant to provide KYC information or gives inconsistent answers"}, {"key": "d", "text": "A client who provides a valid, unexpired national ID"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Structuring, illogical rapid trading, and reluctance to provide KYC are all red flags. Providing valid, current identification is normal and expected.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_05$id$, m.id, $p$'Structuring' (also called 'smurfing') means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Investing through a structured product"}, {"key": "b", "text": "Breaking a large sum into several smaller transfers kept below the reporting threshold"}, {"key": "c", "text": "Organizing a client's portfolio by risk level"}, {"key": "d", "text": "Filing a transaction report in stages"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Structuring (smurfing) is splitting funds into multiple smaller transactions, each kept under the reporting threshold, to avoid detection.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_06$id$, m.id, $p$Ignorance of AML/CFT obligations is a valid legal defense.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Ignorance is not a defense. You can be personally liable if you failed to take the steps a reasonable person in your position would have taken.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_07$id$, m.id, $p$A utility bill that does not show the client's residential address is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Acceptable as long as it shows the client's name"}, {"key": "b", "text": "Acceptable for Tier 1 clients only"}, {"key": "c", "text": "Not acceptable as proof of address — it is not KYC and must be replaced"}, {"key": "d", "text": "Acceptable if it is less than three months old"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Proof of address must actually establish the address. A bill without the residential address does not meet the KYC standard, whatever else it shows.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_08$id$, m.id, $p$An expired means of identification on a client's file should be treated as:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Valid for another 90 days"}, {"key": "b", "text": "The same as no document — transaction limits are suspended until it is renewed"}, {"key": "c", "text": "Acceptable for long-standing clients"}, {"key": "d", "text": "A minor issue to fix at the next annual review"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An expired document is the same as no document. The account is restricted to the level its valid documents support until a current ID is provided.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_09$id$, m.id, $p$Under the SEC three-tier framework, which tier requires the fullest documentation and a 12-month review?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Tier 1"}, {"key": "b", "text": "Tier 2"}, {"key": "c", "text": "Tier 3"}, {"key": "d", "text": "All tiers are reviewed every 12 months"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Tier 3 (full KYC: NIN + BVN + government photo ID) carries the highest limits and the most frequent review — every 12 months.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_10$id$, m.id, $p$A KYC Completeness Score below 80% means:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The file is complete; simply schedule the next periodic review"}, {"key": "b", "text": "One document needs a minor update within 30 days"}, {"key": "c", "text": "Two or more documents are missing, expired, or deficient — limits are suspended and the client is contacted urgently"}, {"key": "d", "text": "The account must be closed"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Below 80% is red: two or more documents are deficient, so limits drop to the valid-document level and the client is contacted urgently.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_11$id$, m.id, $p$A corporate client's ultimate beneficial owner is an individual who owns or controls:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Any shares at all"}, {"key": "b", "text": "5% or more of the entity"}, {"key": "c", "text": "25% or more of the entity"}, {"key": "d", "text": "A majority — over 50%"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Under our KYC standard, a beneficial owner is anyone owning or controlling 5% or more of a corporate client; complex ownership requires enhanced scrutiny.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_12$id$, m.id, $p$Which statement best describes who is a PEP (Politically Exposed Person)?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only currently serving politicians"}, {"key": "b", "text": "Anyone who holds or has held a prominent public function — and their immediate family and close associates"}, {"key": "c", "text": "Only foreign government officials"}, {"key": "d", "text": "Anyone who is wealthy and well-connected"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A PEP includes current and former holders of prominent public functions, plus their immediate family and close associates who might transact on their behalf.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_13$id$, m.id, $p$Because a client is a PEP, Transworld must refuse to do business with them.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$We do serve PEPs. What changes is the level of care: Enhanced Due Diligence, senior management approval, closer monitoring, and mandatory reporting.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_14$id$, m.id, $p$For a PEP client, the firm must: (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Apply Enhanced Due Diligence and verify source of funds and source of wealth"}, {"key": "b", "text": "Obtain senior management approval before the relationship begins"}, {"key": "c", "text": "Report their transactions, including the monthly PEP return to the SEC and NFIU"}, {"key": "d", "text": "Treat them exactly like a low-risk client to avoid causing offense"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$PEPs require EDD, senior management approval, and mandatory reporting. They must never be handled as ordinary low-risk clients.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_15$id$, m.id, $p$A former PEP continues to be treated as a PEP for:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "30 days after leaving office"}, {"key": "b", "text": "At least twelve months after leaving the position, and longer if the risk warrants it"}, {"key": "c", "text": "No additional time once they leave office"}, {"key": "d", "text": "Exactly five years, without exception"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A former PEP is treated as a PEP for a minimum of twelve months after leaving, extended if the Compliance Officer judges the risk warrants it.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_16$id$, m.id, $p$A client whose account has been dormant for 3+ years suddenly returns to trade. What is required?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Process the trade normally — the account passed KYC when it was opened"}, {"key": "b", "text": "A quick phone call to confirm the client still wants to trade"}, {"key": "c", "text": "Enhanced re-engagement — current documents plus genuine evidence of prior ownership, possibly a physical visit; trading stays suspended until complete"}, {"key": "d", "text": "Immediate closure of the account"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A reactivating dormant account needs enhanced re-engagement: current KYC plus genuine proof of prior ownership (and a physical visit where judgment calls for it). Trading stays suspended until complete.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_17$id$, m.id, $p$Acceptable evidence of prior ownership for a reactivating dormant account is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A photo of an old document taken on a phone"}, {"key": "b", "text": "The client's verbal assurance"}, {"key": "c", "text": "An original or verified previous contract note, statement, or correspondence from the firm"}, {"key": "d", "text": "A social media profile in the client's name"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Acceptable evidence is an original or verified prior contract note, statement, payment voucher, or correspondence — not a phone photo or a verbal claim.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_18$id$, m.id, $p$You must have proof that a crime occurred before reporting a suspicion.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Reasonable suspicion is a low bar — a genuine, reasonable belief that something is not right. Suspicion alone triggers the duty to report; you do not need proof.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_19$id$, m.id, $p$What is the key difference between a CTR and an STR?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A CTR is for corporate clients and an STR is for individuals"}, {"key": "b", "text": "A CTR is automatic, triggered by amount (₦5m individual / ₦10m corporate); an STR is triggered by suspicion, with no minimum amount"}, {"key": "c", "text": "A CTR is filed with the SEC and an STR with the NGX"}, {"key": "d", "text": "There is no real difference between them"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A CTR is automatic and amount-driven (₦5m individual / ₦10m corporate in cash). An STR is suspicion-driven with no minimum amount.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd104_20$id$, m.id, $p$After a suspicion has been reported, it is fine to gently ask the client a few extra questions about their funds so they can clear it up.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$That risks tipping off — a criminal offence. Keep interacting completely normally and leave the handling to the Compliance Officer.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;


COMMIT;
