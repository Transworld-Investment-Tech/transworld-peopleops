-- ===========================================================================
-- TEC-102 Cyber hygiene & safe data handling: lesson + 20-question check (v0.48.0 content)
-- Authored FROM POLICY off Compliance Manual v3.0 §12.2 + HR Operations Manual v1.1 H4. Supporting: Code of Ethics Part 8; Employee Handbook v2.1 Ch 20. Role-craft cut of FND-106; breach window taught as 'report immediately'.
-- Tier A. Running this seed PUBLISHES the module. DATA, not schema.
-- Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Every control the firm buys — the firewalls, the antivirus, the encrypted systems — protects a perimeter that you sit inside. The attacker's easiest route into a brokerage is not the network; it is a person who clicks the wrong link, reuses a password, leaves a screen unlocked, or sends client data to the wrong address. That makes cyber hygiene a **daily craft**, not an IT problem you can delegate. FND-106 introduced confidentiality and the firm's control families at an awareness level. This module is the practical cut: exactly how you handle identity, data, devices, and incidents so that you are a control, not a gap. Client information is among the most sensitive assets the firm holds, and a breach is not just an operational incident — it is a compliance failure, a regulatory breach, and a betrayal of client trust.

## What you'll be able to do

1. Apply the firm's access and authentication rules — unique ID, role-based access, strong passwords, multi-factor authentication, and locking your screen.
2. Handle firm and client data safely across its whole life: classify it, store it only on approved systems, transmit it securely, and dispose of it securely.
3. Recognize and resist social-engineering attacks — phishing, pretexting, and payment-redirect fraud — and verify before you act.
4. Follow the IT Acceptable Use Policy: permitted versus prohibited use, no unauthorized software, and no expectation of privacy on firm systems.
5. Run the incident response correctly — report immediately, preserve evidence, and never investigate or self-fix.

## Access and identity: who you are to the system

The firm grants access on a **need-to-do-your-job** basis. The mechanics are simple and non-negotiable:

- **Unique identity.** Each staff member has a unique user ID and role-based access rights. You never share credentials, and you never use someone else's login — every action on a firm system is attributable to a person, and that person is you.
- **Least privilege, reviewed.** Access is granted to what your role needs and is **reviewed quarterly**. If you can reach data you no longer need, flag it. When someone leaves, their access is revoked on their **last working day** — no lingering logins.
- **Strong authentication.** Use strong, unique passwords and comply with **multi-factor authentication (MFA)** everywhere it is required. A password you reuse on a personal site is a password an attacker already has.
- **Lock when you leave.** Lock your workstation every time you step away. An unlocked, logged-in screen is an open door to everything you can reach.

## Handling data safely across its life

Data is exposed at every stage — when it is stored, when it moves, and when it is thrown away. Handle each stage deliberately.

**Know what you are holding.** Information falls into categories, and the most sensitive deserve the most care:

- **Client information** — personal and financial data, account details, transaction history, and correspondence.
- **Company information** — proprietary methods, strategy, internal financials, pricing, and employee and compensation records.
- **Regulatory information** — inspection findings, audit reports, and compliance and breach records.

**Store it only on approved systems.** Confidential information lives on firm-approved platforms — never on personal email, personal cloud accounts, or unencrypted USB drives. Moving client data onto a personal channel "to work on it at home" is itself a breach, even if nothing is lost.

**Move it securely.** Confidential client information is not transmitted over unsecured channels, and **external sharing of client data requires Compliance Officer approval**. Use encrypted channels for sensitive communications; check the recipient before you send.

**Dispose of it securely.** Paper goes into secure shredding bins, not the regular bin. Digital records are deleted in line with the Record Retention Schedule, not kept "just in case." Keep a **clean desk** — physical client files are stored in locked, access-controlled locations, and visitor access to operational areas is restricted.

>! The bright line: if you would not be comfortable having the firm's Compliance Officer watch you do it, do not do it. Forwarding a client's statement to your personal Gmail to print at home, photographing a screen of account numbers, dropping a client list into a free online converter — each of these moves regulated data off an approved system, and each is a breach in its own right, whether or not anything is ever lost.

## Devices, networks, and working away from the office

- **Firm devices for firm work.** Firm-provided laptops, phones, and storage are the place for firm data. Do not move firm data onto personal devices.
- **No unauthorized software.** Do not install unauthorized software on any firm device. Unvetted software is one of the commonest ways malware enters a firm.
- **Lost or stolen, reported at once.** A lost or stolen device — or any device you suspect is compromised — is reported to IT and Compliance **immediately**. Speed limits the damage.
- **Mind the network.** Public Wi-Fi is hostile ground; avoid handling confidential data over it, and use only approved, secured connections for firm work.

## Social engineering: the attack aimed at you

The most effective attacks do not break the technology — they manipulate the person. Learn the shapes:

- **Phishing and spear-phishing** — emails (often well-crafted and personalized) that push you to click a link, open an attachment, or enter credentials on a fake page.
- **Pretexting and vishing** — a convincing story, by email or phone, in which someone impersonates a colleague, an executive, a vendor, or "IT support" to extract information or access.
- **Payment-redirect fraud** — a message, seemingly from a known party, asking you to change bank details or rush a payment.

The tells are consistent: **urgency and pressure**, an unusual request, a mismatched sender address, a demand for secrecy, or a change to payment or login details. The defense is consistent too: **slow down and verify out-of-band** — confirm the request through a channel and contact you already trust, never the contact details in the suspicious message. When in doubt, do not click, do not act, and report it.

Picture the common one: an email that looks like it is from a senior colleague lands late on a Friday. It is urgent, it is confidential — "handle this discreetly" — and it asks you to update a vendor's bank details or push a payment before close. Every pressure lever is being pulled at once. The correct move is not to act faster; it is to stop, and to confirm by calling the colleague on a number you already have, or by walking to their desk. A genuine request survives that check. A fraudulent one collapses the moment you step outside the attacker's channel. No legitimate instruction is ever damaged by being verified.

## Acceptable use and monitoring

The IT Acceptable Use Policy governs all firm technology — hardware, software, email, the PeopleOps portal, trading systems, network access, and cloud storage. In short:

- Firm technology is provided for **business purposes**. Incidental personal use is permitted only where it does not impede your work, consume significant resources, expose the firm to security risk, or involve inappropriate content.
- Prohibited activities — unauthorized software, accessing data you do not need, unsafe handling of confidential information — are breaches of policy.
- You should have **no expectation of privacy** when using firm systems; authorized monitoring may occur for security and compliance purposes.

## When something goes wrong: report immediately

Mistakes and attacks happen; what separates a contained incident from a crisis is **speed**.

- **Report immediately on discovery.** Any suspected or actual data breach or security incident is reported to the IT lead and the Compliance Officer the moment you discover it. There is no acceptable delay — "I'll mention it later" is how a small incident becomes a large one.
- **Do not investigate, do not self-fix.** You are not expected to chase the attacker, test the malware, or quietly undo your mistake. Report it and let the people equipped to respond take over.
- **Preserve the evidence.** Do not delete the suspicious email or wipe the device — leave it as-is so it can be assessed.
- **Compliance assesses notification.** The Compliance Officer determines whether the breach must be notified to the NDPC under the data-protection law. Your job is to surface it fast and accurately.

> Why the urgency is absolute: the damage from most incidents grows by the hour. Credentials are sold and reused, a fraudulent payment clears, an exposed dataset spreads. Reporting in the first minutes gives the firm the chance to reset access, stop a payment, or notify those affected while it still matters. A staff member who reports their own mistake immediately is doing exactly the right thing — concealment, not error, is what turns a manageable incident into a serious one.

## Key takeaways

- You are the firm's largest attack surface — cyber hygiene is a **daily craft**, not an IT setting.
- **Unique ID, least-privilege access, strong passwords, MFA, and lock-on-leave** — identity discipline is the foundation.
- Keep data on **approved systems only**; transmit securely; external client-data sharing needs **Compliance approval**; dispose securely.
- **Slow down and verify out-of-band** — urgency, secrecy, and a change of payment or login details are the tells of social engineering.
- If something goes wrong, **report immediately** to IT and Compliance; do not investigate or self-fix; preserve the evidence.

## References

- **Compliance Manual v3.0 §12.2 (Information Security Controls)** and §12.1 (Data Protection Principles) — primary.
- **HR Operations Manual v1.1 Chapter H4 (IT Acceptable Use Policy)** — primary.
- Supporting: **Code of Ethics CO-POL-001 Part 8 (Confidentiality, Data Protection and Information Security)**; **Employee Handbook v2.1 Chapter 20**.
- *Note: the firm's source documents state several different breach-reporting windows; the standard is to report immediately on discovery. Regulator notification is assessed by Compliance under the NDPA 2023 (NDPC). Mandatory · annual refresh. Content owner: Chief Compliance Officer / IT Lead. Tier A.*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'TEC-102';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_01$id$, m.id, $p$How is access to firm systems and data granted?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Everyone gets the same broad access for convenience"},{"key":"b","text":"On a least-privilege basis — only what your role needs — and reviewed quarterly"},{"key":"c","text":"By seniority, regardless of role"},{"key":"d","text":"Permanently, once granted at hire"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Access is role-based and least-privilege, granted to what the job needs and reviewed quarterly; a departing staff member's access is revoked on their last working day.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_02$id$, m.id, $p$A colleague is out sick and asks you to log in with their credentials to finish an urgent task. You should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Log in as them — it is for the firm's benefit"},{"key":"b","text":"Decline; credentials are never shared, and every action must be attributable to one person"},{"key":"c","text":"Log in as them but only for read-only work"},{"key":"d","text":"Ask another colleague to do it instead, using the sick colleague's login"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Credentials are never shared. Each user has a unique ID so every action is attributable; sharing logins breaks that and is prohibited.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_03$id$, m.id, $p$Reusing the same password on a firm system that you use on personal websites is acceptable as long as the password is long.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Use strong, unique passwords and required MFA. A password reused on a personal site is one an attacker may already have.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_04$id$, m.id, $p$To work on a client's file over the weekend, the safest of these options is to:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Forward it to your personal email"},{"key":"b","text":"Copy it to a personal USB drive"},{"key":"c","text":"Access it only through firm-approved systems on a firm device"},{"key":"d","text":"Upload it to a free online file converter"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Confidential data stays on firm-approved systems and devices. Personal email, personal USB drives, and unapproved cloud tools all move regulated data off approved systems — a breach.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_05$id$, m.id, $p$Sharing client data externally (for example, to a third party) requires:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Nothing — it is fine if the client is cooperative"},{"key":"b","text":"Compliance Officer approval, and use of a secure channel"},{"key":"c","text":"Only the client's verbal say-so"},{"key":"d","text":"Approval from any manager"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$External sharing of client data requires Compliance Officer approval, and confidential information must travel only over secure channels.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_06$id$, m.id, $p$Confidential paper documents should be disposed of by:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The regular waste bin"},{"key":"b","text":"Recycling with other office paper"},{"key":"c","text":"Secure shredding bins"},{"key":"d","text":"Taking them home to dispose of"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Confidential paper goes into secure shredding bins; digital records are deleted per the Record Retention Schedule.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_07$id$, m.id, $p$Select all that are safe data-handling practices at the firm.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Storing confidential data only on approved systems"},{"key":"b","text":"Keeping a clean desk and locking files in access-controlled storage"},{"key":"c","text":"Using encrypted channels for sensitive communications"},{"key":"d","text":"Keeping personal data indefinitely in case it is useful later"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Approved systems, a clean desk, and encrypted channels are all correct. Keeping data indefinitely breaches storage limitation — data is not kept longer than necessary.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_08$id$, m.id, $p$Moving a client list onto your personal cloud account is only a breach if the data is actually lost or stolen.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Moving regulated data off an approved system is a breach in its own right, whether or not anything is ever lost.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_09$id$, m.id, $p$Installing a free productivity tool you found online onto your firm laptop is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Fine if it improves your work"},{"key":"b","text":"Prohibited — no unauthorized software may be installed on firm devices"},{"key":"c","text":"Allowed if it is free"},{"key":"d","text":"Allowed if a colleague uses it too"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Unauthorized software must not be installed on any firm device; unvetted software is a common route for malware.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_10$id$, m.id, $p$You realize your firm laptop has been stolen from your car. You should:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Wait to see if it turns up before saying anything"},{"key":"b","text":"Report it to IT and Compliance immediately"},{"key":"c","text":"Only report it if it held client data"},{"key":"d","text":"Buy a replacement and move on"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A lost or stolen device is reported to IT and Compliance immediately; speed limits the damage and lets the firm revoke access.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_11$id$, m.id, $p$Handling confidential firm data over public Wi-Fi is a safe alternative when you are away from the office.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Public Wi-Fi is hostile ground; use only approved, secured connections for firm work and avoid handling confidential data over open networks.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_12$id$, m.id, $p$An email that pressures you to act urgently and secretly, and asks you to change a vendor's bank details, is most likely:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"A routine internal request to act on quickly"},{"key":"b","text":"A social-engineering attack (payment-redirect fraud)"},{"key":"c","text":"Safe, because it appears to come from a colleague"},{"key":"d","text":"A system error to ignore"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Urgency, secrecy, and a change to payment details are classic social-engineering tells — here, payment-redirect fraud.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_13$id$, m.id, $p$The single best defense against a suspicious request to move money or change details is to:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Act faster so the deadline is met"},{"key":"b","text":"Reply to the email to confirm"},{"key":"c","text":"Verify out-of-band using a contact you already trust"},{"key":"d","text":"Forward it to a colleague to decide"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Verify out-of-band — confirm through a trusted channel, never the contact details in the suspicious message. A genuine request survives the check.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_14$id$, m.id, $p$Select all that are common tells of a social-engineering attack.$p$, $t$MULTI$t$, $o$[{"key":"a","text":"Pressure and urgency"},{"key":"b","text":"A demand for secrecy"},{"key":"c","text":"A request to change payment or login details"},{"key":"d","text":"A routine message with no requests, from a known sender"}]$o$::jsonb, $c$["a","b","c"]$c$::jsonb, $e$Pressure, secrecy, and a change to payment or login details are the classic tells. A routine message with no request is not, in itself, a tell.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_15$id$, m.id, $p$Replying directly to a suspicious email to ask 'is this really you?' is a reliable way to verify it.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. If the message is fraudulent, the reply goes to the attacker. Verify out-of-band through a channel and contact you already trust.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_16$id$, m.id, $p$Under the IT Acceptable Use Policy, incidental personal use of firm technology is:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Completely forbidden"},{"key":"b","text":"Permitted within limits — provided it does not impede work, consume significant resources, expose the firm to risk, or involve inappropriate content"},{"key":"c","text":"Unlimited"},{"key":"d","text":"Allowed only outside working hours"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Limited incidental personal use is permitted, subject to those conditions; firm technology is provided for business purposes.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_17$id$, m.id, $p$You have a right to privacy in your use of firm email and systems, so the firm may not monitor them.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. You should have no expectation of privacy on firm systems; authorized monitoring may occur for security and compliance purposes.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_18$id$, m.id, $p$You discover a suspected data breach. Your first action is to:$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"Investigate it yourself to understand what happened"},{"key":"b","text":"Try to quietly undo the mistake"},{"key":"c","text":"Report it to IT and the Compliance Officer immediately"},{"key":"d","text":"Wait until you are sure it is serious"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Report immediately on discovery to IT and Compliance. Do not investigate or self-fix; speed is the control.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_19$id$, m.id, $p$On finding a suspected breach, you should preserve the evidence — for example, not deleting the suspicious email or wiping the affected device.$p$, $t$TRUE_FALSE$t$, $o$[{"key":"a","text":"True"},{"key":"b","text":"False"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$True. Preserve the evidence so the incident can be assessed; do not delete or wipe before Compliance and IT have responded.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_tec102_20$id$, m.id, $p$Who decides whether a breach must be notified to the data-protection regulator (NDPC)?$p$, $t$SINGLE$t$, $o$[{"key":"a","text":"The individual who discovered it"},{"key":"b","text":"The Compliance Officer"},{"key":"c","text":"Any manager"},{"key":"d","text":"No one — it is automatic"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The Compliance Officer assesses whether the breach requires regulator notification under the data-protection law; your job is to surface it fast and accurately.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'TEC-102'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
