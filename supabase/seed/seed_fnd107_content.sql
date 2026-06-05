-- =============================================================================
-- seed_fnd107_content.sql -- FND-107 Conflicts of Interest: lesson + 20-question check (v0.43.7 content)
-- Authored FROM POLICY off Conflict of Interest Policy CO-POL-002 v3.0 (Board Edition).
--   Supporting: Code of Ethics CO-POL-001; Gift, Benefit & Hospitality Policy HR-POL-006.
-- Tier A (CCO-owned). Running this seed PUBLISHES the module -- it is the CCO publish gate.
-- DATA, not schema. Run AFTER 0031/0032 + seed_lms_curriculum.sql (which creates the FND-107 shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- Pass mark 80% reaffirmed here; estimated_minutes set to 35.
-- =============================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$We are in the business of trust. A client who phones the dealing desk cannot look over the dealer's shoulder. A widow who comes in to claim her late husband's portfolio cannot police the officer who handles her file. An investor reading a research note cannot test whether the analyst quietly holds the same stock. Everything we do rests on one fragile assumption — that the person on our side of the desk is acting for the client, and not for themselves.

A **conflict of interest** is the precise moment that assumption breaks down. It does not require theft, fraud, or a bad outcome. The damage is done the moment a personal interest — financial, family, social, or professional — begins to compete with the duty you owe the firm and its clients. Everything after that is just the trail of evidence.

The **Conflict of Interest Policy (CO-POL-002)** is how Transworld identifies conflicts before they harm us, manages them where they cannot be avoided, and refuses — calmly and absolutely — to let them compromise anyone who acts in the firm's name. This module walks you through what the Policy requires. It binds everyone, from the newest officer to the Board. By the end you will know what a conflict is, the one habit that protects you, and exactly what to do the moment you are unsure.

## What you'll be able to do

1. Define a conflict of interest and recognize its three states — actual, potential, and perceived.
2. Identify connected persons and explain why a benefit to your family is treated as a benefit to you.
3. Apply the Newspaper Test when no specific rule fits.
4. Disclose a conflict correctly — on Form F-COI-01, in writing, at the right time.
5. Recognize the activities that are restricted, the activities that are absolutely prohibited, and the four ways the firm manages a conflict once it is disclosed.

## Why this matters — the three faces of damage

When a conflict takes hold, damage arrives on three fronts at once.

The **client** is the first and most direct victim — advice biased by an undisclosed interest is a quiet breach of the fiduciary relationship the client paid for. We do not measure a conflict by whether the client noticed it; we measure it by whether the client's interest was placed second to someone else's.

The **firm** is the second, and the damage here is often greater. One discovered conflict can mean a multi-year regulatory investigation, fines, suspension, or the revocation of our dealing licence — and the licence is the firm's lifeblood. It can mean lost clients, lost counterparty trust, civil litigation, and ruined morale among the honest officers whose reputations are contaminated by association. The Nigerian capital market is small. The reputation we have built one transaction at a time can be unbuilt in a single press cycle.

The third victim is **you**. Conflicts that crystallize into breaches of the law carry personal consequences: regulatory sanctions including industry bans, personal fines and disgorgement of profits, criminal prosecution under the ISA 2024 with imprisonment of up to ten years, a permanent record on the SEC and NGX databases that follows you for the rest of your career, and dismissal for cause.

>! **The price of silence is always higher than the price of disclosure.** A conflict disclosed early, in writing, before any decision is taken, is almost never a disciplinary matter — it is the normal course of business. The same conflict, undisclosed and later discovered by Compliance, by Internal Audit, by a regulator, or worst of all by a client, becomes a career-ending event. Same person, same facts, two completely different outcomes. The only variable is disclosure.

Our environment makes this more serious, not less. Risk-based supervision inspections, digital trading records, depository and registrar reconciliations, and beneficial-ownership registers mean that conflicts which once stayed hidden now leave a paper trail. The right response is not to get more creative about hiding conflicts. It is to stop having any to hide.

## What a conflict actually is

A conflict of interest arises whenever a personal, financial, family, social, professional, or other interest of yours — or of someone connected to you — could influence, or could reasonably be perceived to influence, your professional judgment or the discharge of your duties to the firm and its clients.

That definition is deliberately broad, because the harm a conflict does to clients and the firm does not depend on the conflict being a particular shape. It depends only on whether your judgment has ceased to be wholly independent. A conflict exists in three states, and all three are caught by this Policy:

- **Actual** — already crystallized. The interest exists today, the conflicting duty is being discharged today, and the two are in direct competition right now. *Example: a relationship officer who personally owes money to a client whose portfolio he advises on.*
- **Potential** — not yet crystallized but plausibly will. The interest and the duty both exist, but the moment of choice has not yet arrived. *Example: a dealer who personally holds shares in a company the firm has not yet been asked to trade, but might be.*
- **Perceived** — a reasonable outside observer (a client, a regulator, a journalist) could conclude that your judgment may have been influenced, even if you are certain it was not.

>! **Perception is not a lesser category.** The most dangerous mistake a person can make under this Policy is to argue that because their intentions are good, a perceived conflict is not really a conflict. We do not run this firm for the benefit of people who already know and trust our intentions. We run it for clients, regulators, and a market that mostly cannot see our private intentions. A situation that *looks* compromised damages the firm the same way a real one does. Perceived conflicts are disclosed and managed exactly like actual ones.

> **The guiding principle.** If a personal, family, financial, or social interest could influence — or could reasonably be seen to influence — your judgment in your work at Transworld, treat it as a conflict, disclose it in writing, and let Compliance decide how to manage it. **When in doubt, disclose.**

## Connected persons — your family is caught too

This Policy treats a conflict arising through someone connected to you as identical to one arising in you personally. A benefit flowing to a connected person is, in substance, a benefit flowing to you — and connected-party arrangements are the classic way misconduct is moved one step "removed" from the staff member while staying under their control.

Connected persons include your spouse (or anyone living with you as a spouse); your children, including adult, step-, and adopted children; your parents and parents-in-law; your siblings, including half-, step-, and in-law siblings; anyone else living in your household; anyone whose finances you materially control or contribute to; any company or trust in which you or any of those people hold a directorship, beneficial ownership, control position, or trustee role; and any business partner or person with whom you have a current, material, undisclosed financial relationship.

> Where you are unsure whether a relationship makes someone a connected person, err toward disclosure. Compliance decides whether it falls inside the definition — that judgment is not yours to make alone.

## The Newspaper Test

The Code of Ethics gives us one test that applies here equally and is worth committing to memory.

> **The Newspaper Test.** If this situation appeared on the front page of a Nigerian newspaper tomorrow, accurately reported, would I be comfortable with how it looks? If the answer is no — or if it is yes only because I would be able to spend the day defending it — that is a conflict, and it must be disclosed and managed.

The test does not replace the formal definition. It makes it concrete. When the definition feels abstract, ask what a reasonable, uninvolved observer would think if they read about the situation tomorrow.

## The core duty: disclose early, in writing

If a single line could carry this whole Policy, it would be *when in doubt, disclose.* Everything else depends on disclosure happening first — the firm cannot manage a conflict it does not know about, and Compliance cannot advise on a situation it has never heard of.

**When the duty arises.** Immediately, the moment you become aware of the situation. There is no grace period and no "wait and see how it develops." In particular, disclosure is required when you join the firm (for all pre-existing interests, relationships, and outside activities); the instant a new conflict arises during employment; as part of your annual declaration; before any specific decision the conflict could touch, even if you disclosed the underlying interest generally before; and whenever a disclosed conflict changes in nature, scale, or proximity.

**How to disclose.** In writing, on the **Conflict of Interest Disclosure Form (F-COI-01)**, which is available through the Transworld Portal. Deliver it to the **Head of Compliance and Internal Control**, with a copy to your line manager. Where the conflict involves your line manager, or you have reasonable concerns about the normal route, disclose directly to the Managing Director or to the Chair of the Board Audit, Risk and Compliance Committee (BARC). The Whistleblower Policy provides further channels and protections where they are appropriate.

>! **A verbal mention is not a disclosure.** Casual remarks to colleagues and hints to managers do not protect you or the firm, and they do not start the clock on the firm's response. Only a written F-COI-01 does.

Your disclosure should state, at a minimum: your name and role; an honest description of the interest, relationship, or circumstance; the connected persons involved; the firm activities, clients, or decisions that may be affected; your own view of how it should be managed; and the date you first became aware.

**What happens next.** Compliance acknowledges your disclosure within two working days and, within ten working days, determines the management approach (covered below) with the Managing Director — and with the BARC where the conflict is material or involves a senior officer. The decision is recorded in the **Conflict of Interest Register**, which is reviewed quarterly by the BARC and is open to internal and external auditors and to regulators. Until you hear back, take no further action in the affected matter, except what is strictly necessary to avoid immediate harm to a client or the firm — and if you must act, document why, at the time.

> **Disclosure is not an admission of wrongdoing.** Disclosing an interest does not commit the firm to acting on it, and it does not commit you to anything you have not yet done. Staff who disclose in good faith — even where the conflict turns out, on review, to be a serious one — are treated very differently from those who stay silent and are later discovered. Honest disclosure is itself evidence of good character.

## The categories that come up most

The Policy sets specific rules for the conflicts that arise most often in our business. These apply in addition to the general duty to disclose; where a specific rule is stricter, the specific rule governs.

**Personal account dealing.** All personal trading accounts of you and your connected persons must be disclosed to Compliance on joining and in your annual declaration. You may not place a personal trade in a security in which you hold material non-public information; in which the firm has a pending client order (until that order is fully executed and allocated); or in which the firm has issued, or is preparing, a research recommendation (until a reasonable period has passed). Trading and research staff pre-clear personal trades.

>! **Front-running is the line that must not be crossed.** Trading — personally or through a connected person — ahead of a known client order that you expect to move the price is a criminal offense under the ISA 2024: imprisonment of up to ten years, heavy fines, disgorgement of all profits, an industry ban, and personal civil liability to the clients harmed. No business or personal reason justifies the risk. If you ever find yourself considering such a trade, walk away from the screen and call Compliance.

**Outside business and directorships.** You need the **prior written approval of the Managing Director** before accepting any directorship, officer role, advisory role, or board-observer role — paid or unpaid — in any outside organization; before taking on any secondary employment, freelance work, or consultancy; and before starting, acquiring, controlling, or actively running any private business. Approval is not automatic. Roles that compete with the firm's services, or that involve securities or companies we trade or cover, will normally be declined. Purely passive investments — listed shares, real estate held passively, a beneficiary interest in a trust run by an independent trustee — do not need pre-approval but must be declared annually.

**Related-party transactions.** A transaction between the firm and a person connected to you is not, by itself, prohibited — but it is tightly controlled. You must disclose the relationship on F-COI-01 before any commitment is made on the firm's behalf, **recuse** yourself entirely from the decision, negotiation, evaluation, approval, or supervision of it, and let it proceed through normal, independent approval on the same terms as any other supplier. Above **₦5,000,000 per transaction**, or **₦20,000,000 in aggregate per related party in any rolling twelve-month period**, the transaction also requires Managing Director approval and notification to the BARC at its next meeting. The breach is never the family relationship — it is the absence of disclosure, competition, and an independent test of value.

**Gifts, benefits, hospitality, and inducements.** These are governed by the Gift, Benefit and Hospitality Policy (HR-POL-006), which forms part of this Policy. **Personal acceptance of any gift, cash, airtime, bank transfer, mobile money, or other benefit from a client is prohibited — regardless of value. There is no minimum threshold.** Decline it politely and firmly; if the client still wishes to show appreciation, it may go only to the firm's official account, never to you. Notify your line manager and the Head of Operations, and file **Form F-26 within 24 hours**. Any gift or hospitality — even one you declined — is disclosed within 24 hours. Offering or accepting anything that could reasonably be understood as an inducement to act, or to refrain from acting, in a particular way is prohibited and may constitute bribery under Nigerian law. Where the two policies appear to differ, the stricter rule governs.

**Family and personal relationships.** Close personal relationships with clients, counterparties, registrars, depositories, and regulators are not prohibited, but they must be disclosed. The firm will normally arrange for you not to be personally responsible for the account or relationship in question; where that is operationally difficult in a small team, heightened supervision and dual sign-off are applied instead. Romantic or intimate relationships with clients are strongly discouraged; where one arises, you must disclose immediately, and the firm will arrange for the relationship to be managed by another officer.

**Material non-public information (MNPI).** Information that a reasonable investor would consider significant, and that has not yet been released to the market through a proper channel, must never be shared with anyone who lacks a legitimate need to know — and **never** with connected persons, under any circumstances, including casual family conversation. You may not trade the affected securities, personally or through connected persons, until the information is public and a reasonable period has passed. Chinese-wall arrangements between functions are respected absolutely.

>! **Tipping is its own offense.** Telling a relative to "take some off the table" before a downgrade is published is insider dealing and tipping under the ISA 2024 — even if you never trade yourself, and even though it was said casually in a family WhatsApp group. Treat any MNPI you hold like an envelope of physical cash: you do not share it, you do not hint at it, and you do not let conversation drift toward it.

**Procurement and vendor selection.** Decisions above the firm's procurement threshold follow a competitive process with documented evaluation criteria. Any connection you have to a bidder — ownership, family, friendship, prior employment, or any other relationship — must be disclosed in writing before the bidding begins, and you may not sit on the evaluation panel, vote on the award, or influence the decision in any way. Sole-sourcing without competition is permitted only in genuinely urgent or specialist cases, approved by the Managing Director with reasons recorded in writing.

**Recruitment, promotion, and compensation.** If you have any connection to a candidate or staff member, disclose it before the decision process begins; you must not participate in the decision, see the confidential decision papers, or lobby the decision-maker. Hiring a connected person into the firm is permitted, but only with disclosure before recruitment begins, your removal from the hiring decision, and your ongoing separation from any later decision on that person's appraisal, compensation, promotion, or discipline. **Direct reporting lines between connected persons are not permitted**; where a relationship arises after employment that would create one, the firm changes the reporting structure.

**Charitable, political, and community solicitation.** You are free to be active in charitable, religious, civic, and community organizations in your personal capacity, and the firm encourages it. But you may not solicit firm clients or counterparties for donations without the prior written approval of the Head of Compliance, and you may not use firm resources — email, phones, office space, branded materials, or working hours — for outside causes. Political contributions by the firm itself are prohibited, and soliciting a client who is a politically exposed person carries additional KYC and AML scrutiny.

**Personal loans and financial dependence.** Personal loans between you and a client, counterparty, or vendor — interest-bearing or interest-free, secured or unsecured, formal or informal — are prohibited. So are co-investments in private ventures with a client without the Head of Compliance's prior approval, and personal guarantees between you and a client. If you are in genuine financial distress, the right path is Human Resources — staff loans, salary advances, or referrals to regulated lenders. It is never a private loan from a person to whom the firm owes fiduciary duties.

**Board members.** Directors carry statutory disclosure duties under **CAMA 2020 (sections 287–290)**, on top of every obligation in this Policy: declare any interest, direct or indirect, in a contract before the matter is considered, and withdraw from the discussion and the vote on it. Every board pack carries a standing declaration item. Seniority increases scrutiny — it never reduces it.

## How a disclosed conflict is managed

Once you disclose, the firm applies one, or a combination, of four approaches. The choice depends on how material the conflict is and how structurally manageable it is.

- **Avoid** — end the outside activity, decline the related-party transaction, sever the relationship, or in extreme cases remove you from the function. Used where the conflict is so material or so likely to recur that nothing else adequately protects clients and the firm.
- **Manage** — neutralize the conflict through internal structure: recusal, reassignment of the matter to an unconflicted colleague, information barriers (Chinese walls), heightened supervision, dual sign-off, or trade blocks and restricted lists.
- **Disclose to the client** — where the firm still acts, the client is told of the conflict in writing, in plain language, and gives recorded informed consent before the firm proceeds. This is the lowest-protection approach, used only where the others are not available. Vague references to "potential conflicts" are not enough.
- **Decline to act** — where none of the above gives adequate confidence that the firm can serve the client properly, the firm declines. Often that is the only honest answer.

> Every management decision is documented — the F-COI-01, the Compliance assessment and reasoning, the decision and the specific measures applied, any client consent, and any supervisory records — and kept in the Conflict of Interest Register. A well-managed, well-documented conflict is an asset to the firm: evidence of robust governance. A conflict "managed" only in a quiet conversation between two officers, with no written trail, is the opposite.

## The bright lines — what disclosure cannot cure

Most conflicts can be managed once they are disclosed. A few activities are so destructive to clients, to the firm, and to the integrity of the market that they cannot be approved by disclosure, managed by supervision, or reframed as ordinary business. They are off-limits, full stop:

1. **Insider dealing** — trading, advising, procuring, or tipping another person, on the basis of material non-public information, from any source.
2. **Front-running** and related trading abuse, including parallel running and scalping.
3. **Market manipulation** — wash trades, matched trades, pump-and-dump, spoofing, layering, marking the close, and circulating false market information.
4. **Bribery and kickbacks** — in cash, in kind, or through a connected person, including accepting payment from a counterparty in return for routing client business to it.
5. **Misappropriation or misuse of client assets** — using client funds, securities, account access, or information for any purpose other than the client's express instructions.
6. **Operating a competing business** — any unauthorized advisory, brokerage, securities-recommendation, or asset-management activity carried on outside the firm.
7. **Personal loans from clients** — borrowing from a client to whom the firm owes fiduciary duties, in any form.
8. **Unauthorized disclosure** of client or firm information to anyone, inside or outside the firm, who lacks a legitimate need to know.
9. **Misuse of position** — using the firm's name, authority, premises, systems, branding, or resources to advance personal interests or those of a connected person.
10. **Concealment or falsification** of records to obscure a conflict, defeat a control, or frustrate Compliance, Internal Audit, a regulator, or external auditors.

>! **The prohibited list is not exhaustive.** Any conduct that, by its nature, would cause a reasonable person to question the firm's integrity, your independence, or the protection of the client may be treated as prohibited even if it is not specifically listed. The test is not whether the activity appears on a list. The test is whether it is consistent with this Policy and the Code of Ethics.

## Speaking up — a duty, not a choice

A conflict of interest does only as much damage as the silence around it permits. Every member of staff carries a personal duty to raise concerns about potential conflicts — in themselves or in others. This duty is not discretionary, it is not waived by how senior the other person is, and it is not waived by how awkward the conversation will be. Calling out a conflict is an act of loyalty: to the firm, to the colleagues whose careers depend on its reputation, and to the clients we are paid to protect.

You can raise a concern with your line manager (where they are not the subject), the Head of Compliance, the Managing Director, the Chair of the BARC, or through any of the Whistleblower Policy's channels, including anonymous ones. Anyone who reports in good faith is protected absolutely against retaliation — and a good-faith concern is protected even if, on investigation, it turns out to be unfounded.

> The full set of routes, your anonymity rights, and the detail of retaliation protection are covered in the **Whistleblowing & Speaking Up** module (FND-108). The point here is simpler: if you see it, say it. Silence protects problems; speaking up protects the institution.

## Consequences of breach

Breach is taken seriously at every level — and seniority increases, never reduces, the seriousness.

- **Minor** — for example, a late annual declaration with nothing substantive omitted. Outcome: written warning, mandatory training, closer monitoring.
- **Moderate** — for example, a conflict disclosed late but eventually disclosed, or a failure to recuse where no harm resulted. Outcome: formal written warning, suspension from the role, and pay or performance impact.
- **Serious** — for example, an undisclosed conflict that influenced a decision, or an undisclosed related-party transaction or outside business. Outcome: final written warning, demotion or removal from the role, and significant compensation impact.
- **Gross** — front-running, insider dealing, bribery, misappropriation of client assets, a personal loan from a client, falsifying records, or retaliating against a reporter. Outcome: **summary dismissal for cause, reporting to the SEC and NGX, and civil and criminal referral as applicable.**

Beyond discipline, a breach that also breaks the law brings **regulatory** consequences (public censure, personal fines, disgorgement, withdrawal of registration, and permanent disqualification on the SEC's database), **civil** liability to harmed clients (and the firm's insurance does not cover deliberate or grossly negligent breaches — you bear that loss personally), and **criminal** prosecution. The decision to enter a conflicted transaction is taken in a moment; the chain of consequence can shape the next decade.

## Your responsibilities and the annual declaration

Every member of staff is personally responsible for reading and acknowledging this Policy on joining and annually; identifying and disclosing your own conflicts; cooperating with any management measures applied; raising concerns about conflicts involving others; cooperating fully with investigations; and filing an accurate annual declaration.

> **The annual declaration (F-COI-02).** Directors, the Managing Director, officers reporting to the MD, all control-function staff, every dealer, every research analyst, and every relationship officer with direct client relationships file an annual Declaration of Interests on Form F-COI-02, within 30 days of the end of each calendar year. It is a **positive** statement — you file it even if you have nothing to declare ("nil"); a nil return is itself a useful record. Missing the deadline is, by itself, a disciplinary breach. Acknowledgement of the Policy is logged on Form F-22.

## Key takeaways

- A conflict is any interest — yours or a connected person's — that could influence, **or be seen to influence**, your judgment. Perceived counts as much as actual.
- **When in doubt, disclose** — in writing, on **F-COI-01**, the moment you become aware. A verbal mention is not a disclosure.
- A benefit flowing to a **connected person** is treated as a benefit to you.
- Related-party transactions need disclosure and recusal; above **₦5,000,000 / ₦20,000,000** they also need MD approval and BARC notice.
- Outside roles and businesses need **prior written MD approval**; a client gift is **declined** and logged on **F-26 within 24 hours**, with no value threshold.
- **Front-running, insider dealing, tipping, bribery, misappropriation, and loans from clients** are bright lines — often criminal, and disclosure cannot cure them.
- Disclosed conflicts are managed in one of four ways — **Avoid, Manage, Disclose to the client, Decline** — never by silence.

> Whenever you are unsure, **stop and ask Compliance**. Erring on the side of disclosure will never get you in trouble. Hiding will.

## References

- **Conflict of Interest Policy (CO-POL-002), v3.0 — Board Edition** — primary source for this module.
- Companions: **Code of Ethics CO-POL-001** (the Newspaper Test and market integrity) and the **Gift, Benefit and Hospitality Policy HR-POL-006** (gift handling and Form F-26); see also the *Code of Conduct & Ethics* module (FND-103) and the *Whistleblowing & Speaking Up* module (FND-108).
- Forms: **F-COI-01** (Conflict of Interest Disclosure), **F-COI-02** (Annual Declaration of Interests), **F-26** (Gift & Benefit Disclosure), **F-22** (Policy Distribution & Staff Acknowledgement Log).
- Regulatory basis: ISA 2024; SEC Rules; NGX Dealing Members' Rules 2015; CAMA 2020 (ss. 287–290); AML/CFT Act 2022; NCCG 2018; NDPA 2023.
- *Mandatory module · annual refresh. Content owner: Chief Compliance Officer. Tier A — reviewed against CO-POL-002 v3.0 on authoring; re-verify at each annual cycle.*$body$,
    pass_mark = 80,
    estimated_minutes = 35,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-107';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_01$id$, m.id, $p$When does a conflict of interest arise under the Policy?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only when a personal interest has actually caused a bad outcome for a client"}, {"key": "b", "text": "Only when money has changed hands"}, {"key": "c", "text": "Whenever a personal, family, financial, or other interest could influence — or could reasonably be perceived to influence — your professional judgment"}, {"key": "d", "text": "Only when a regulator says so"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The definition is deliberately broad: a conflict exists once your judgment could be, or could reasonably be seen to be, influenced — regardless of outcome or whether money moved.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_02$id$, m.id, $p$Which statement about a *perceived* conflict is correct?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "It is a lesser category and does not need to be disclosed"}, {"key": "b", "text": "It must be disclosed and managed in the same way as an actual conflict"}, {"key": "c", "text": "It only matters if a client complains"}, {"key": "d", "text": "It can be ignored if your intentions are good"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Perception is not a lesser category. A situation that looks compromised harms the firm the same way a real conflict does, so perceived conflicts are disclosed and managed exactly like actual ones.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_03$id$, m.id, $p$Because your intentions are good, a perceived conflict does not need to be disclosed.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. Believing your own intentions are clean is the most dangerous mistake under this Policy. Perceived conflicts must be disclosed and managed like any other.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_04$id$, m.id, $p$Which of the following are connected persons under the Policy? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Your spouse"}, {"key": "b", "text": "An adult child living in another city"}, {"key": "c", "text": "A company in which your spouse holds a controlling stake"}, {"key": "d", "text": "A colleague in another department with no personal or financial relationship to you"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Connected persons include your spouse, your children (including adult children), and any company a connected person controls. An unrelated colleague is not a connected person.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_05$id$, m.id, $p$A benefit that flows to your spouse from a firm vendor is treated, in substance, as a benefit to you.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["t"]$c$::jsonb, $e$True. A benefit flowing to a connected person is treated as a benefit flowing to you — which is exactly why connected-party arrangements are caught by this Policy.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_06$id$, m.id, $p$What is the Newspaper Test?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Whether the activity is technically legal"}, {"key": "b", "text": "Whether your line manager has heard about it"}, {"key": "c", "text": "Whether you would be comfortable if the situation appeared, accurately reported, on the front page of a newspaper tomorrow"}, {"key": "d", "text": "Whether the amount of money involved is small"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$If you would not be comfortable seeing it on tomorrow's front page — or are comfortable only because you could spend the day defending it — treat it as a conflict, disclose it, and manage it.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_07$id$, m.id, $p$When does the duty to disclose a conflict arise?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Immediately, the moment you become aware of the situation"}, {"key": "b", "text": "Only at the annual declaration"}, {"key": "c", "text": "Only once the conflict has become a problem"}, {"key": "d", "text": "Within 30 days of the conflict causing harm"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$The trigger is awareness, not severity or harm. There is no grace period and no 'wait and see' — disclose immediately.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_08$id$, m.id, $p$Mentioning a conflict verbally to your line manager counts as a disclosure under this Policy.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. Casual mentions and hints are not disclosures. Only a written F-COI-01 protects you and the firm and starts the clock on the firm's response.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_09$id$, m.id, $p$Which form is used to disclose a conflict of interest?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "F-26 (Gift & Benefit Disclosure)"}, {"key": "b", "text": "F-22 (Policy Acknowledgement Log)"}, {"key": "c", "text": "F-COI-01 (Conflict of Interest Disclosure)"}, {"key": "d", "text": "F-COI-02 (Annual Declaration of Interests)"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Event-driven conflicts are disclosed in writing on Form F-COI-01, available through the Transworld Portal, to the Head of Compliance with a copy to your line manager.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_10$id$, m.id, $p$Your spouse owns a company that wants to supply the firm. What does the Policy require?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Nothing — family can be trusted to give a fair price"}, {"key": "b", "text": "Disclose the relationship on F-COI-01 before any commitment, recuse yourself from the decision, and let it be approved independently"}, {"key": "c", "text": "Award the contract quietly to avoid embarrassment"}, {"key": "d", "text": "Mention it verbally to a colleague and proceed"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A related-party transaction is permitted, but only with prior written disclosure, full recusal, and independent approval on the same terms as any other supplier. The breach is the absence of disclosure, not the family tie.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_11$id$, m.id, $p$Above what per-transaction value does a related-party transaction also require Managing Director approval and notification to the BARC?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "₦500,000"}, {"key": "b", "text": "₦5,000,000"}, {"key": "c", "text": "₦20,000,000"}, {"key": "d", "text": "₦50,000,000"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Above ₦5,000,000 per transaction — or ₦20,000,000 in aggregate per related party in a rolling twelve months — the transaction needs MD approval and BARC notification.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_12$id$, m.id, $p$Accepting a modest cash 'thank-you' from a grateful client is acceptable as long as it is below the gift threshold.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. Personal acceptance of any gift, cash, or benefit from a client is prohibited regardless of value — there is no minimum threshold. Decline it, redirect any appreciation to the firm's official account, and file F-26 within 24 hours.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_13$id$, m.id, $p$A client insists on giving you a gift you could not avoid receiving. What is the correct handling?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Keep it but mention it to a colleague"}, {"key": "b", "text": "Decline or surrender it, redirect any appreciation to the firm's official account, notify your line manager, and file Form F-26 within 24 hours"}, {"key": "c", "text": "Keep it if it is worth less than ₦5,000"}, {"key": "d", "text": "Share it with the team so no one person benefits"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Decline or surrender the gift, redirect any appreciation only to the firm's account, notify your line manager, and disclose on Form F-26 within 24 hours. Failure to disclose is itself a breach.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_14$id$, m.id, $p$You are offered a non-executive board seat at a private fintech. What must you do before accepting?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Nothing, since it is unpaid or 'just helping a friend'"}, {"key": "b", "text": "Obtain the prior written approval of the Managing Director"}, {"key": "c", "text": "Simply add it to next year's annual declaration"}, {"key": "d", "text": "Tell a colleague and start attending meetings"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Any outside directorship, officer, advisory, or board-observer role — paid or unpaid — needs prior written MD approval. Approval is not automatic and roles touching securities the firm trades are normally declined.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_15$id$, m.id, $p$Telling your sister-in-law to sell a stock before your downgrade note is published is acceptable because you did not trade yourself.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. Tipping — passing material non-public information to a connected person who acts on it — is insider dealing under the ISA 2024 and is an offense whether or not you trade yourself.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_16$id$, m.id, $p$A long-standing client offers you an interest-free personal loan during a family emergency. What does the Policy require?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Accept it quietly since it is interest-free and informal"}, {"key": "b", "text": "Decline it — personal loans from clients are prohibited — and seek help through Human Resources if needed"}, {"key": "c", "text": "Accept it but disclose it next year"}, {"key": "d", "text": "Accept it provided you repay within twelve months"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Personal loans from a client are prohibited in any form. The right path in genuine distress is HR — staff loans, salary advances, or referrals to regulated lenders — never a loan from a client.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_17$id$, m.id, $p$Where the firm continues to act under the 'Disclose to the client' approach, what must it obtain first?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A verbal acknowledgement from the client"}, {"key": "b", "text": "The client's recorded, informed consent in writing, in plain language"}, {"key": "c", "text": "Approval from the counterparty"}, {"key": "d", "text": "Nothing further once the conflict is in the Register"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Disclosure to the client is the lowest-protection approach: the client must be told in plain language and give recorded informed consent before the firm proceeds. Vague references to 'potential conflicts' are not enough.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_18$id$, m.id, $p$Which of the following are absolutely prohibited and cannot be cured by disclosure? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Front-running a client order"}, {"key": "b", "text": "Market manipulation such as wash trading or spoofing"}, {"key": "c", "text": "A related-party vendor contract that was disclosed, recused, and competitively tendered"}, {"key": "d", "text": "Borrowing money from a client"}]$o$::jsonb, $c$["a", "b", "d"]$c$::jsonb, $e$Front-running, market manipulation, and borrowing from a client are absolute prohibitions. A related-party contract that was properly disclosed, recused, and competitively tendered is permitted — that is managing a conflict, not a breach.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_19$id$, m.id, $p$The list of prohibited activities is exhaustive, so anything not on it is automatically allowed.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$False. The prohibited list is not exhaustive. Any conduct that would cause a reasonable person to question the firm's integrity or your independence may be treated as prohibited even if it is not listed.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd107_20$id$, m.id, $p$Which statement about the annual Declaration of Interests (F-COI-02) is correct?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "You only file it if you have something to declare"}, {"key": "b", "text": "It is a positive statement — you file it even if you have nothing to declare ('nil'), and missing the deadline is itself a breach"}, {"key": "c", "text": "It replaces the need to disclose conflicts during the year"}, {"key": "d", "text": "Only directors are required to file it"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The annual declaration is a positive statement filed within 30 days of year-end — a nil return is still required, and missing the deadline is a disciplinary breach. It does not replace event-driven disclosure on F-COI-01 during the year.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-107'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
