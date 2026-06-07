-- =============================================================================
-- seed_reg204_content.sql  (v0.60.0)
-- REG-204 Fit-and-proper & sponsored-individual obligations: lesson + 20-question check (Proficient, Tier A, FROM POLICY).
-- Authored from the firm's compliance source suite; teaches ISA 2025 (not 2007/2024).
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO assignment rule: the role-and-grade matrix (seed_ws7_role_matrix.sql) already
-- maps REG-204 as REQUIRED to its job profiles; this is Proficient/role-targeted
-- content, NOT firmwide-mandatory, so no scope=ALL row is added.
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$A licence to operate in Nigeria's capital market is not granted to a building or a logo. It is granted to a firm on the strength of the people inside it — named individuals whom the regulator has examined, tested, and personally vouched for. Take those people away and the licence is hollow. That is why "fit-and-proper" and "sponsored individual" are not HR jargon; they are the human foundation the firm's authority to trade actually rests on. If you hold a regulated role here, the regulator is, in a real sense, watching you by name. This module explains what that means and what it asks of you.

## What you will be able to do

1. Explain how the firm's licence depends on individually vouched-for people under ISA 2025.
2. Identify who must be a sponsored individual and why.
3. Walk the sponsored-individual lifecycle from training to renewal.
4. Apply the fit-and-proper test, and understand that it is continuing, not a one-time gate.
5. State the consequences — for the person and the firm — when the obligation fails.

## ISA 2025: the ground beneath the licence

In March 2025 the President signed the **Investments and Securities Act 2025** into law, repealing the long-standing Investments and Securities Act of 2007 and resetting the legal foundation of the Nigerian capital market. The SEC remains the apex regulator, now with expanded powers — including over digital and virtual assets — and a sharper enforcement reach. For an existing operator like Transworld, the practical message is twofold: registrations granted under the old 2007 Act remain valid, but the firm must comply with the new Act's requirements, including meeting revised minimum capital by **30 June 2027**. Everything in this module sits on that ground. Note that the firm's older policy documents still cite "ISA 2024"; the correct, current statute is **ISA 2025**, and that is what governs.

The Act did more than rename the statute. It broadened the definition of securities to capture digital and virtual assets, strengthened the SEC's independence and its sanctioning powers over operators who behave badly, and reinforced the machinery of investor protection and market integrity. For a sponsored individual the takeaway is not the section numbers but the direction of travel: the standards expected of the people who run a capital market operator have been raised, not relaxed, and the regulator's ability to act against those who fall short is greater than it was under the old regime.

## Who must be a sponsored individual

A **sponsored individual (SI)** is an employee of a registered capital market operator whom the SEC authorizes to perform a regulated function — dealing in securities, advising clients, managing portfolios, underwriting issues, or custody. The firm does not get to perform a regulated function unless it has registered SIs to carry it. In practice, most operator categories must maintain a minimum number of sponsored individuals — typically three to four — **one of whom must be the Compliance Officer**, and the firm's principal officers, including the Managing Director, are themselves sponsored. The number is not a target to be hit once; it is a floor the firm must hold continuously. Fall below it — through a resignation, say — and the firm is, until it regularizes, short of the structure its licence requires.

There is a quiet but important consequence in how the SEC's systems work: only a sponsored individual can register or renew the firm on the SEC Operators Portal. The people are not merely staff who happen to be registered; they are the legal hands through which the firm transacts with its regulator.

Think about what this means for the firm's resilience. Because the required structure is a floor and not a target, the firm has to plan around its sponsored individuals the way it plans around any critical resource. A single resignation can drop the firm below its minimum and, until a replacement is trained, examined, and registered, leave it technically unable to perform a function it is licensed for. That is why succession for regulated roles is not an HR nicety but a licence-protection measure: the firm keeps a clear view of who is sponsored for what, anticipates departures, and starts the long SEC registration runway early rather than scrambling after someone gives notice. A regulated role left vacant is not just an empty desk — it can be a gap in the firm's authority to operate.

## The sponsored-individual lifecycle

Becoming and remaining an SI is a defined path, not a single event.

**Pre-registration training and examination.** Before registration, a prospective SI attends the SEC's pre-registration training and sits its qualifying examination — held quarterly. This is not a formality; failing it means the person cannot be sponsored, and the firm cannot count them toward its required number.

**Registration.** A successful candidate is registered with the SEC through the Operators Portal, with the prescribed forms and documentation — a full CV with no unexplained gaps, credentials sighted in original, valid identification, and the rest of the file. The firm's offer of employment must come from Transworld Investment & Securities Limited specifically, not from any affiliate — a point our own control framework insists on.

**Ongoing obligations.** Registration is the beginning of duties, not the end. An SI must comply with all SEC rules, conduct themselves in line with the fit-and-proper standard continuously, and submit the periodic activity reports the Commission requires. The SEC oversees SIs through ongoing fit-and-proper assessment, inspection, and enforcement — so the obligations are live, not dormant.

**Annual renewal.** The firm's registration — and the standing of its SIs within it — is renewed annually, **not later than 31 January** each year. Renewal is calendared well ahead, with the documentation gathered in good time, because a lapse here goes to the firm's authority to operate at all.

## Fit-and-proper: a continuing test

The fit-and-proper standard asks, in plain terms, whether a person is **honest, trustworthy, and competent** to perform a regulated function. It has three strands. **Integrity** — a clean record of honesty, no disqualifying conduct, no pattern of dishonesty in their dealings. **Competence** — the qualifications, knowledge, and relevant experience the role demands. **Financial soundness** — a personal financial history that does not raise concern about their reliability in a position of trust.

The crucial word is *continuing*. Fit-and-proper is not a gate you pass once at hire and forget. A person who was fit and proper on the day they were registered can cease to be — through a conviction, a serious disciplinary finding, an act of dishonesty, a financial collapse. When that happens, the firm cannot simply look away; the change must be assessed and, where it matters, reported, because the firm is vouching for that person's standing every day they remain in the role.

Put yourself on the other side of the test for a moment, because it sharpens the point. The regulator is not asking whether someone is a good colleague or a strong performer; it is asking whether the investing public can trust this person with other people's money and with a regulated function. Integrity is weighed through their record of honesty and any history of dishonest conduct. Competence is weighed through qualifications and genuinely relevant experience, not merely years served. Financial soundness is weighed because a person under severe personal financial pressure is, all else equal, more exposed to the temptation that controls exist to resist. None of these is a one-time checkbox; each is a standard the person must keep meeting, and the firm's duty is to keep an eye on whether they still do.

## When it fails

The consequences are real on both sides. For the **individual**, the SEC can suspend or revoke their registration, impose fines, or disqualify them from the industry — ending their ability to work in a regulated role, sometimes permanently. For the **firm**, operating a regulated function without the required registered SIs, or retaining a person who is no longer fit and proper, is a breach that draws enforcement and, at the extreme, threatens the licence. There is also the everyday exposure: an offer letter issued before screening is complete, or by the wrong entity, can unravel an appointment and embarrass the firm with its regulator. The discipline is to get it right before, not after.

It is worth dwelling on how personal this is, because it changes how a regulated employee should think about their own conduct. The SEC's enforcement reaches the individual directly, not only the firm — a disqualification follows the person, not the desk, and can foreclose a career across the entire industry, not just at Transworld. That is a powerful reason to treat the fit-and-proper standard as a personal asset to protect rather than a box the firm ticks on your behalf. Your registration is, in effect, your professional licence; guarding your integrity, keeping your competence current, and managing your own affairs soundly are how you keep it.

## The Transworld control

Our Internal Control Framework turns these obligations into a routine. Regulated roles are filled only by appropriately qualified people; all prospective employees are screened against the SEC/NGX sponsored-individual requirements where applicable; background checks, reference verification, and qualification checks are completed **before** an offer letter is issued; and employment letters are issued by Transworld Investment & Securities Limited itself, never an affiliate. People-Ops maintains the register of who is sponsored for what, and that register is kept current so the firm always knows whether it is holding its required structure. The control is reviewed periodically and on any material staffing change, and senior changes are board-approved — so that the firm's compliance with its sponsored-individual structure is checked deliberately, not assumed.

## A worked example

**Illustration — a new dealing hire (entirely hypothetical).** The desk wants to bring on a dealer. Walk the sequence. First, screening: background, references, and qualifications are checked while the fit-and-proper strands — integrity, competence, financial soundness — are assessed; nothing is offered until this clears. Then the offer letter, issued by Transworld itself, not an affiliate. Then the SEC path: the candidate attends pre-registration training and sits the quarterly qualifying exam; on success, the firm registers them as a sponsored individual through the Operators Portal with the full documentation. Only once registered may they perform the dealing function — and from that point they carry the continuing duties, including periodic activity reports, with renewal calendared for 31 January. Skip a step — offer before screening, or trading before registration — and you have exposed both the person and the firm.

## Common traps

- **Treating fit-and-proper as a one-time gate.** It is continuing; a person can cease to be fit and proper after hire.
- **An offer letter before screening clears.** Get the checks done first; an early offer can unravel.
- **The wrong issuing entity.** Employment letters must come from Transworld itself, not an affiliate.
- **Letting the SI count slip quietly.** The required number — including a Compliance Officer — is a continuous floor, not a one-off.
- **Citing the old Act.** The governing statute is ISA 2025, not the repealed 2007 Act (and not the "ISA 2024" some old documents print).

## Key takeaways

- The firm's licence rests on individually vouched-for people; ISA 2025 is the statute that frames it.
- Regulated functions need registered sponsored individuals — typically three to four, including the Compliance Officer.
- The SI lifecycle runs training and the quarterly exam → portal registration → activity reports → renewal by 31 January.
- Fit-and-proper (integrity, competence, financial soundness) is a continuing test, not a one-time hurdle.
- Screen before you offer, issue letters from Transworld only, and keep the register current; failure carries real enforcement.

*Reference: Internal Control Framework v3.0 (fit-and-proper / staff recruitment control) and Compliance Manual v3.0 (Transworld), with current SEC Nigeria sponsored-individual and registration requirements (verified June 2026). Governing statute: the Investments and Securities Act 2025. This module is a navigation aid; the Act, the SEC rules, and the firm's policies are the governing authority.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'REG-204';

-- 2) twenty graded questions (80% pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_01$id$, m.id, $p$The current apex statute governing Nigeria's capital market is the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Investments and Securities Act 2007"}, {"key": "b", "text": "Investments and Securities Act 2025"}, {"key": "c", "text": "Investments and Securities Act 2024"}, {"key": "d", "text": "Companies and Allied Matters Act"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$ISA 2025 was signed in March 2025, repealing the 2007 Act; older firm documents that say 'ISA 2024' are out of date.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_02$id$, m.id, $p$For an operator already registered under the old 2007 Act, ISA 2025 means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the old registration is void and must be re-applied for"}, {"key": "b", "text": "the registration stays valid, but the firm must comply with the new Act, including revised minimum capital by 30 June 2027"}, {"key": "c", "text": "nothing changes at all"}, {"key": "d", "text": "the firm may ignore minimum capital rules"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Existing registrations remain valid but must meet the new Act's requirements, with revised minimum capital due by 30 June 2027.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_03$id$, m.id, $p$A sponsored individual is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any employee of the firm"}, {"key": "b", "text": "an employee the SEC authorizes to perform a regulated function such as dealing, advising, or portfolio management"}, {"key": "c", "text": "an external consultant"}, {"key": "d", "text": "a client granted trading access"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An SI is an employee of a registered operator individually authorized by the SEC to perform a regulated function.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_04$id$, m.id, $p$Most operator categories must maintain a minimum number of sponsored individuals, one of whom must be the...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Head of Sales"}, {"key": "b", "text": "Compliance Officer"}, {"key": "c", "text": "External Auditor"}, {"key": "d", "text": "Company Secretary"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Typically three to four SIs are required, one of whom must be the Compliance Officer; the MD is also sponsored.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_05$id$, m.id, $p$The required number of sponsored individuals is a one-time hurdle at first registration.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$It is a continuous floor; if a resignation drops the firm below it, the firm is short of the structure its licence requires until it regularizes.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_06$id$, m.id, $p$Before registration, a prospective sponsored individual must...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "simply be hired by the firm"}, {"key": "b", "text": "attend SEC pre-registration training and pass the qualifying examination (held quarterly)"}, {"key": "c", "text": "work one year unsupervised first"}, {"key": "d", "text": "be approved only by the firm's MD"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The SEC's pre-registration training and quarterly qualifying exam are prerequisites; failing means the person cannot be sponsored.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_07$id$, m.id, $p$The three strands of the fit-and-proper test are best described as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "speed, size, and seniority"}, {"key": "b", "text": "integrity, competence, and financial soundness"}, {"key": "c", "text": "revenue, results, and reputation"}, {"key": "d", "text": "tenure, title, and training"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Fit-and-proper asks whether a person is honest (integrity), capable (competence), and financially sound.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_08$id$, m.id, $p$Fit-and-proper is a continuing standard, not a one-time gate. This means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "once registered, a person's standing can never be questioned"}, {"key": "b", "text": "a person who was fit and proper at hire can cease to be, and the change must be assessed and, where it matters, reported"}, {"key": "c", "text": "it only applies to the MD"}, {"key": "d", "text": "it is reassessed only every ten years"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A conviction, serious disciplinary finding, or financial collapse can end someone's fit-and-proper status after hire; the firm vouches for them daily.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_09$id$, m.id, $p$When may a newly hired dealer begin performing the dealing function?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "On their first day, before registration"}, {"key": "b", "text": "Only once registered with the SEC as a sponsored individual"}, {"key": "c", "text": "As soon as the offer letter is signed"}, {"key": "d", "text": "After one month of shadowing"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A regulated function may be performed only after SEC registration as an SI — trading before registration exposes the person and the firm.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_10$id$, m.id, $p$At what point should a job offer be issued relative to background and fit-and-proper checks?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Before the checks, to secure the candidate"}, {"key": "b", "text": "Only after background, reference, and qualification checks clear"}, {"key": "c", "text": "Checks are optional if the candidate seems strong"}, {"key": "d", "text": "After the candidate starts work"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Screening is completed before an offer is issued; an early offer can unravel the appointment and embarrass the firm.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_11$id$, m.id, $p$Employment letters for a sponsored role must be issued by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "any affiliate company in the group"}, {"key": "b", "text": "Transworld Investment & Securities Limited specifically"}, {"key": "c", "text": "the SEC"}, {"key": "d", "text": "the candidate's previous employer"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm's control framework requires letters to be issued by Transworld itself, not an affiliate.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_12$id$, m.id, $p$Registration once granted carries no ongoing obligations.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "t", "text": "True"}, {"key": "f", "text": "False"}]$o$::jsonb, $c$["f"]$c$::jsonb, $e$Registration is the beginning of duties: ongoing compliance, continuing fit-and-proper conduct, and periodic activity reports to the SEC.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_13$id$, m.id, $p$The firm's registration (and its SIs' standing within it) is renewed annually no later than...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "31 March"}, {"key": "b", "text": "30 June"}, {"key": "c", "text": "31 January"}, {"key": "d", "text": "31 December"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Annual renewal is due not later than 31 January and is calendared well ahead, as a lapse goes to the firm's authority to operate.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_14$id$, m.id, $p$If a sponsored individual ceases to be fit and proper, the firm should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "do nothing as long as they perform well commercially"}, {"key": "b", "text": "assess the change and, where it matters, report it"}, {"key": "c", "text": "transfer them to an affiliate quietly"}, {"key": "d", "text": "wait for the SEC to notice"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The firm cannot look away; it vouches for the person daily, so a material change must be assessed and reported where required.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_15$id$, m.id, $p$Possible SEC enforcement actions against a non-compliant sponsored individual include...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a polite reminder only"}, {"key": "b", "text": "suspension or revocation of registration, fines, or disqualification from the industry"}, {"key": "c", "text": "a mandatory pay rise"}, {"key": "d", "text": "transfer to another firm"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The SEC can suspend or revoke registration, fine, or disqualify — potentially ending the person's ability to work in a regulated role.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_16$id$, m.id, $p$On the SEC Operators Portal, who can register or renew the firm?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Any staff member with a login"}, {"key": "b", "text": "Only a sponsored individual"}, {"key": "c", "text": "The firm's external lawyer"}, {"key": "d", "text": "Any director, sponsored or not"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Only a sponsored individual can register or renew the firm on the Operators Portal — the SIs are the legal hands that transact with the regulator.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_17$id$, m.id, $p$Periodic activity reports to the SEC are owed by...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the firm's clients"}, {"key": "b", "text": "sponsored individuals, as part of their continuing obligations"}, {"key": "c", "text": "the external auditor only"}, {"key": "d", "text": "no one \u2014 they were abolished"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$SIs must submit the periodic activity reports the Commission requires; the obligations are live, not dormant.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_18$id$, m.id, $p$Who keeps the firm's register of who is sponsored for what?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The trading desk"}, {"key": "b", "text": "People-Ops, kept current so the firm knows it holds its required structure"}, {"key": "c", "text": "The SEC only"}, {"key": "d", "text": "No one needs to"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$People-Ops maintains the SI register and keeps it current, so the firm always knows whether it is meeting its required structure.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_19$id$, m.id, $p$The firm's licence is fundamentally granted to...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the company building and brand"}, {"key": "b", "text": "the firm on the strength of individually examined and vouched-for people"}, {"key": "c", "text": "the firm's largest client"}, {"key": "d", "text": "the Nigerian Exchange"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The licence rests on named individuals the regulator has examined and vouched for; remove them and the licence is hollow.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_reg204_20$id$, m.id, $p$ISA 2025 expanded the SEC's powers, including over...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "agricultural commodities only"}, {"key": "b", "text": "digital and virtual assets, with a sharper enforcement reach"}, {"key": "c", "text": "foreign exchange policy"}, {"key": "d", "text": "income tax collection"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$ISA 2025 broadened the SEC's reach — including digital and virtual assets — and strengthened its enforcement powers.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'REG-204'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'REG-204';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: REG-204 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'REG-204' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: REG-204 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: REG-204 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
