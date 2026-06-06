-- ===========================================================================
-- BDV-104 Prospecting & lead generation: lesson + 20-question check (v0.50.0 content)
-- Tier B. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Nothing in business development happens until there is someone to develop business with. **Prospecting** — the work of finding and reaching potential clients — sits at the very top of the BD job, and it is the part most people find hardest, because it involves initiative, rejection, and persistence. This module is a foundational guide to prospecting and lead generation: where good leads come from, how to tell a real opportunity from a waste of time, how to reach out in a way that earns a hearing, and how to do all of it within the firm's rules. The deeper mechanics of pipelines and CRM discipline come in later modules; here the aim is to get the foundations right. As always, the firm's mantra governs: **the right way is always the best way** — and in prospecting, the right way is also the way that protects the firm's name.

## What you'll be able to do

1. Explain what prospecting is and the difference between a lead and a qualified prospect.
2. Name the main sources of good leads and why referrals are the strongest.
3. Qualify a lead against need, ability, authority, and fit.
4. Make a professional first approach that leads with value rather than a hard pitch.
5. Prospect within the firm's honesty, data-protection, and compliance rules.

## What prospecting is

Prospecting is simply the disciplined search for future clients. A **lead** is a potential client — a name and a reason to think they might one day do business with the firm. A **prospect** is a lead you have *qualified*: someone for whom there is a plausible fit between what they need and what the firm offers. Turning leads into prospects, and prospects into clients, is the core motion of business development. Most leads will never become clients, and that is normal — prospecting is a numbers game played with judgment, not a guarantee. The skill is to generate enough good leads, qualify them honestly, and invest your effort where a real fit exists.

## Where good leads come from

Leads come from several sources, and they are not equal in quality:

- **Referrals from satisfied clients** — the strongest of all. A client who introduces a friend has lent you their trust; the new lead arrives already half-persuaded. This is the compounding reward of serving existing clients well, and it is why client service and prospecting are connected, not separate.
- **Centres of influence** — professionals whose clients overlap with the firm's: accountants, lawyers, employers running staff schemes. A relationship with a trusted referrer can produce a steady flow of qualified leads.
- **Networking and events** — industry gatherings, professional associations, community and alumni networks. The goal at an event is not to close business on the spot but to begin relationships worth following up.
- **Existing-client expansion** — an existing client with more to invest, or a new need (an estate, a child's account), is one of the easiest and most overlooked sources of new business.
- **Inbound enquiries** — people who approach the firm through its website, advertising, or reputation. These are warm by definition and deserve a prompt, professional response.
- **Your own network** — people you already know, approached honestly and without pressure.

> The pattern is clear: the best leads are warm — they come with some trust already attached. Cold approaches to strangers are the hardest and lowest-yield, which is why building referral relationships is the highest-leverage prospecting a business developer can do.

## Qualifying a lead

Not every lead deserves your time, and chasing unqualified ones is the most common way a business developer wastes effort. Qualify against four simple questions:

- **Need.** Is there a plausible reason this person would want what the firm offers — savings to invest, a goal to fund, a portfolio to manage?
- **Ability.** Do they have the means to invest in a way that makes the relationship viable for both sides?
- **Authority.** Are you talking to the person who can actually decide — or a gatekeeper who cannot?
- **Fit.** Does what the firm genuinely offers suit this person? A lead the firm cannot serve well is not a real prospect, however willing they are.

A lead that passes these is a prospect worth pursuing. A lead that fails them is better acknowledged and set aside than chased — your time is the scarce resource, and honesty about fit protects both you and the client.

## Making the approach

How you first reach a prospect sets the tone for everything after. A few principles:

- **Research first.** Know something real about the person or their situation before you reach out. A generic blast signals that they are one of hundreds; a relevant, specific opening signals that you actually thought about them.
- **Lead with value, not a pitch.** The first contact should offer something useful — a relevant insight, an answer to a question, a genuine introduction — not an immediate hard sell. You are asking for a conversation, not a commitment.
- **Be clear about who you are.** Identify yourself, the firm, and why you are reaching out. Misrepresenting who you are or why you are calling is both dishonest and a breach of conduct.
- **Aim for the next step, not the whole deal.** A good first approach earns a meeting or a follow-up, not a signed account. Make the next step small and easy to say yes to.
- **Be professionally persistent, not a pest.** Reasonable follow-up is part of the job; pestering someone who has clearly declined is not. The line is respect.

### A good approach versus a poor one

Suppose a satisfied client refers a colleague who has just received a lump sum and is unsure what to do with it. A poor approach: a generic message — "Hi, I'm from Transworld, we offer great investment products, can we set up a call to discuss your portfolio?" It names no shared context, leads with a pitch, and asks for a commitment. A good approach: "Hi [name], [referrer] mentioned you'd recently come into some funds and might be thinking through your options — they thought a short conversation might be useful. I'm [name] at Transworld; I'd be glad to walk through how people in a similar position tend to think about it, with no obligation. Would a brief call next week suit?" The second names the warm source, leads with usefulness rather than a sale, identifies who you are, and asks only for a small next step. Same goal; entirely different odds of a "yes" — and entirely different first impression of the firm.

## Prospecting within the rules

Prospecting does not happen outside the firm's compliance world — it is the front of it. Several rules apply from the first contact:

- **Honesty from the first word.** Everything in the conduct rules applies to prospecting: no false or misleading statements, no promises the firm cannot keep, no overstating returns. The relationship's integrity starts at hello.
- **You cannot bypass onboarding.** A keen prospect still becomes a client only through full KYC and Compliance approval. Never promise to skip or speed past the controls to win someone over.
- **Respect data-protection rules.** Contact data is personal data protected under the Nigeria Data Protection Act 2023. Collect and use prospect information lawfully and for legitimate purposes; do not misuse lists or contact people in ways the rules do not allow.
- **Gifts and inducements still apply.** The rules on declining personal gifts and never offering inducements apply to winning business just as they do to serving it.

>! A prospect is not yet a client, but the firm's reputation is already on the line. Every approach — courteous or pushy, honest or exaggerated — is the market's first impression of Transworld. Prospect as though the firm's name depends on it, because it does.

## Track what you do

Finally, prospecting is only effective if it is **organized**. Record your leads, where they came from, their qualification status, and every follow-up — so nothing falls through the cracks and you can see what is working. The portal and the firm's tools support this, and the discipline of pipeline and CRM management is developed further in later BD modules. For now, the habit is simple: capture every lead and every next action, and never rely on memory.

## The bottom line

Prospecting is the disciplined, ethical search for the firm's future clients. Cultivate warm sources — above all, referrals earned by serving existing clients well — qualify honestly against need, ability, authority, and fit, approach with research and value rather than a hard pitch, and do all of it inside the firm's honesty and compliance rules. Respect a "no," track every lead, and remember that each approach is the firm's first impression. Done this way, prospecting fills the pipeline without ever costing the firm the trust it runs on.

---

*Foundational BD module · Tier B · function-head review on each annual cycle. Built to house style; pipeline and CRM mechanics are developed in later BD modules. The firm's honesty, data-protection, and onboarding rules apply from the first contact.*$body$,
    pass_mark = 80,
    estimated_minutes = 25,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'BDV-104';

-- 2. graded knowledge check (20 questions)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_01$id$, m.id, $p$What is the difference between a 'lead' and a 'prospect'?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They are the same thing"},{"key":"b","text":"A lead is a potential client; a prospect is a lead you have qualified — someone for whom there is a plausible fit"},{"key":"c","text":"A prospect has already signed; a lead has not"},{"key":"d","text":"A lead is an existing client"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A lead is a potential client; a prospect is a qualified lead, where a plausible fit exists between need and what the firm offers.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_02$id$, m.id, $p$It is normal for most leads never to become clients.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Prospecting is a numbers game played with judgment; most leads will not convert, and that is expected.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_03$id$, m.id, $p$Which is the strongest source of leads, and why?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Cold calls to strangers, because there are many of them"},{"key":"b","text":"Referrals from satisfied clients, because the new lead arrives with trust already attached"},{"key":"c","text":"Unsolicited mass emails, because they are cheap"},{"key":"d","text":"Random walk-ins"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Referrals are strongest: a satisfied client lends you their trust, so the lead arrives already half-persuaded.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_04$id$, m.id, $p$What connection does the module draw between client service and prospecting?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They are entirely separate activities"},{"key":"b","text":"Serving existing clients well generates referrals — the strongest leads — so service and prospecting are connected"},{"key":"c","text":"Good service reduces leads"},{"key":"d","text":"Prospecting should replace client service"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Well-served clients refer others; the compounding reward of good service is warm, qualified leads.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_05$id$, m.id, $p$What is a 'centre of influence' as a lead source?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A competitor firm"},{"key":"b","text":"A professional whose clients overlap with the firm's — e.g. an accountant or lawyer — who can refer qualified leads"},{"key":"c","text":"A government regulator"},{"key":"d","text":"A social media influencer only"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Centres of influence are trusted professionals (accountants, lawyers, employers) whose clients overlap with the firm's and who can produce a steady flow of qualified referrals.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_06$id$, m.id, $p$What is the realistic goal of attending a networking event?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"To close signed business on the spot"},{"key":"b","text":"To begin relationships worth following up"},{"key":"c","text":"To collect as many business cards as possible and never follow up"},{"key":"d","text":"To pitch every person in the room"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$At an event the goal is to begin relationships worth following up — not to close on the spot.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_07$id$, m.id, $p$Against which questions should you qualify a lead? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Need — is there a plausible reason they'd want what the firm offers?"},{"key":"b","text":"Ability — do they have the means to make the relationship viable?"},{"key":"c","text":"Authority — are they the person who can actually decide?"},{"key":"d","text":"Fit — does what the firm genuinely offers suit them?"}]$o$::jsonb, $c$["a","b","c","d"]$c$::jsonb, $e$Qualify against need, ability, authority, and fit. A lead that passes is a real prospect; one that fails is better set aside.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_08$id$, m.id, $p$What should you do with a lead that clearly fails qualification?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Chase it hardest, since it is a challenge"},{"key":"b","text":"Acknowledge it and set it aside — your time is the scarce resource, and honesty about fit protects both sides"},{"key":"c","text":"Promise them anything to convert them"},{"key":"d","text":"Pass them to a competitor"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Chasing unqualified leads wastes your scarce time; set them aside honestly. A lead the firm can't serve well is not a real prospect.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_09$id$, m.id, $p$Which principles make a good first approach? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Research the person first so your opening is relevant"},{"key":"b","text":"Lead with value rather than an immediate hard pitch"},{"key":"c","text":"Be clear about who you are and why you're reaching out"},{"key":"d","text":"Push for a signed account in the first contact"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Research, lead with value, and be clear who you are. Aim for a small next step, not a signed account, in the first contact.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_10$id$, m.id, $p$What should a good first approach aim to secure?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A signed account immediately"},{"key":"b","text":"A small, easy next step — a meeting or follow-up — not the whole deal"},{"key":"c","text":"A personal gift from the prospect"},{"key":"d","text":"Nothing in particular"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A good first approach earns a meeting or follow-up; make the next step small and easy to say yes to.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_11$id$, m.id, $p$Where is the line between professional persistence and being a pest?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"There is no line; persistence is always good"},{"key":"b","text":"Respect — reasonable follow-up is part of the job, but pestering someone who has clearly declined is not"},{"key":"c","text":"Persistence should stop after one contact"},{"key":"d","text":"You should never follow up"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Reasonable follow-up is part of the job; pestering someone who has clearly declined crosses the line. The line is respect.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_12$id$, m.id, $p$Does the duty of honesty apply during prospecting, before someone is even a client?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"No — honesty only applies once they sign"},{"key":"b","text":"Yes — no false or misleading statements, no promises the firm can't keep, from the first word"},{"key":"c","text":"Only in writing"},{"key":"d","text":"Only for large prospects"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The conduct rules apply from the first contact; the relationship's integrity starts at hello.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_13$id$, m.id, $p$To win over a keen prospect, you may promise to skip or speed past KYC and Compliance approval.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A prospect becomes a client only through full KYC and Compliance approval; you can never promise to bypass the controls.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_14$id$, m.id, $p$How are a prospect's contact details treated under the rules?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"As public information you may use freely"},{"key":"b","text":"As personal data protected under the Nigeria Data Protection Act 2023 — collected and used lawfully and for legitimate purposes"},{"key":"c","text":"As the firm's property to sell"},{"key":"d","text":"As irrelevant to compliance"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Contact data is personal data under the NDPA 2023; it must be collected and used lawfully and for legitimate purposes.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_15$id$, m.id, $p$Because a prospect is not yet a client, the firm's reputation is not at stake during prospecting.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every approach is the market's first impression of the firm; the reputation is on the line from the first contact.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_16$id$, m.id, $p$Why are warm leads generally better than cold approaches?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"They are cheaper to buy"},{"key":"b","text":"They come with some trust already attached, making them higher-yield than cold approaches to strangers"},{"key":"c","text":"They require no qualification"},{"key":"d","text":"They are guaranteed to convert"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Warm leads arrive with trust attached and convert better; cold approaches to strangers are the hardest, lowest-yield prospecting.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_17$id$, m.id, $p$Why should you research a prospect before reaching out?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is not necessary"},{"key":"b","text":"A relevant, specific opening signals you actually thought about them; a generic blast signals they're one of hundreds"},{"key":"c","text":"To find personal information to pressure them with"},{"key":"d","text":"To avoid having to identify yourself"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Research lets you open with relevance, which signals genuine attention; a generic message signals the opposite.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_18$id$, m.id, $p$Why should you track every lead and follow-up?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"It is optional busywork"},{"key":"b","text":"So nothing falls through the cracks and you can see what is working — never rely on memory"},{"key":"c","text":"Only to satisfy the regulator"},{"key":"d","text":"To avoid talking to prospects"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Capturing every lead, its source, status, and next action keeps opportunities from being lost and shows what's working — memory is not a system.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_19$id$, m.id, $p$Which are legitimate, higher-quality lead sources? Select all that apply.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Referrals from satisfied clients"},{"key":"b","text":"Existing-client expansion (more to invest, a new need)"},{"key":"c","text":"Inbound enquiries through the firm's website or reputation"},{"key":"d","text":"Misusing a purchased contact list in ways the rules don't allow"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Referrals, existing-client expansion, and inbound enquiries are quality, legitimate sources. Misusing contact lists breaches data-protection rules.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_bdv104_20$id$, m.id, $p$A prospect clearly declines further contact. What does respect require?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Keep calling until they change their mind"},{"key":"b","text":"Respect the 'no' — do not pester someone who has clearly declined"},{"key":"c","text":"Pass their details to several colleagues to try"},{"key":"d","text":"Offer them a gift to reconsider"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Respect a clear 'no'; persisting after someone has declined crosses from persistence into pestering and damages the firm's name.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'BDV-104'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
