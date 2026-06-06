-- ===========================================================================
-- FND-106 Confidentiality & Information Security: lesson + 20-question check (v0.46.0 content)
-- Authored FROM POLICY off Compliance Manual v3.0 §12.2 + §15.1 + HR Operations Manual v1.1 H4.
--   Includes a dedicated phishing section: spot the tells; when in doubt, DO NOT CLICK.
-- GAP: no standalone Board-edition info-sec/acceptable-use policy -- the CCO must accept publishing without one.
-- Tier A (CCO-owned). Running this seed PUBLISHES the module -- it is the CCO publish gate.
--   DO NOT RUN until the CCO has reviewed and approved the content.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (which creates the module shell).
-- Idempotent: module UPDATE by code; questions upsert by stable id (ON CONFLICT DO UPDATE).
-- ===========================================================================

BEGIN;

-- 1. lesson body + publish with the graded-check pass mark and estimated duration
UPDATE "learning_modules"
SET body = $body$Confidentiality is one of the firm's six standards of conduct, and information security is how we keep it. Clients trust Transworld with sensitive information; the firm runs on systems that must stay reliable and secure. A single careless click, a shared password, or a confidential file on an unsecured channel can undo that trust in minutes. This module turns the firm's confidentiality duty and its information-security controls into habits you can apply every day — and it gives special attention to the threat you are most likely to meet personally: the phishing email.

This is a module for everyone with a login, a laptop, a phone, or access to client information. Security is not the IT Lead's job alone; it is the sum of what every person does at their own desk.

## What you'll be able to do

1. Describe your personal confidentiality duty and the firm's five information-security control families.
2. Use Transworld systems within the Acceptable Use rules and avoid the prohibited activities.
3. **Spot a phishing email — and know that when in doubt, you do not click.**
4. Report a security incident the right way, fast, without trying to fix it yourself.

## Confidentiality is a personal duty

The Code of Conduct lists confidentiality among the standards every member of staff must demonstrate: protect client and company information, do not discuss client affairs in public or with people who do not need to know, do not access information you do not need for your role, and never take client data outside the firm without authorization. At Transworld a useful rule of thumb governs pay and similar data: individual amounts are confidential; the structure and rules are open. The same logic applies broadly — share what people are entitled to know, protect what they are not.

## The five control families

The firm's information-security framework protects both client data and the firm's systems. Five families of controls carry it:

- **Access controls.** Every person has a unique user ID and role-based access. Access is granted by job need, reviewed regularly, and revoked on a leaver's last working day. Your credentials are yours alone.
- **Physical security.** Client files — physical and digital — are kept in locked, access-controlled locations; visitor access to operational areas is restricted.
- **Network and system security.** Firewalls, intrusion prevention, antivirus, and regular updates protect the firm's infrastructure. You support this by never disabling security software or updates.
- **Email and communication controls.** Confidential client information is not sent over unsecured channels, and sharing client data externally requires Compliance Officer approval.
- **Incident response.** Any suspected breach or security incident is reported to the IT Lead and the Compliance Officer at once — the firm's standard expects the first alert within two hours of discovery.

## Acceptable use — the bright lines

Transworld technology — laptops, phones, email, the PeopleOps portal, trading systems, network, cloud storage — is provided for business. Limited incidental personal use is allowed only where it does not impede your work, consume significant bandwidth or storage, involve inappropriate content, or expose the firm to risk. You should have **no expectation of privacy** on firm systems; authorized monitoring may occur for security and compliance.

Some things are never acceptable. Do not share your login with anyone — *including a colleague covering for you.* Do not install unauthorized software, try to access systems or data beyond your permissions, use personal email for confidential business, connect a firm device to unsecured public Wi-Fi without the approved VPN, or disable security software, antivirus, or automatic updates.

>! Sharing a password is never a convenience — it breaks the unique-identity control that lets the firm know who did what. One login, one person. No exceptions, not even for a trusted colleague.

## Phishing — the threat you will meet personally

Most security incidents start with a single email. Phishing is a message designed to trick you into clicking a malicious link, opening a harmful attachment, or handing over a password or one-time code. Learn the tells:

- **Urgency or fear** — "your account will be closed in 24 hours," "act now," "final warning." Pressure is the oldest trick.
- **A sender or address that is slightly wrong** — a familiar name but a misspelled domain, a public email pretending to be a colleague or executive, a reply-to that does not match.
- **An unexpected link or attachment** — especially one asking you to "log in," "verify," "release a payment," or enable content. Hover to see where a link really goes before trusting it.
- **A request for credentials, codes, or a payment change** — the firm and real institutions do not ask for your password or one-time code by email.
- **Odd language or a too-good offer** — awkward grammar, generic greetings, prizes, refunds, or a senior person making an unusual request out of the blue.

>! **When in doubt, DO NOT CLICK.** Do not open the attachment, do not enter your password, do not approve the payment. Report the email to IT and delete it only after reporting. A phishing email that is reported is harmless; one that is clicked can cost the firm everything. There is no penalty for reporting a message that turns out to be genuine — there is real damage in clicking one that is not.

## Report fast — do not investigate, do not self-fix

Report all of the following to IT the same day: suspected malware or ransomware; phishing emails (report them — do not click the links); unauthorized access to any system; lost or stolen devices; and any situation where firm data may have been exposed. Speed matters more than certainty. Do not try to investigate or fix it yourself, and do not delay while you decide whether it is "serious enough." A weak control that leaves a clear trail beats a clever fix that hides what happened — and reporting protects you as much as the firm.

## Key takeaways

- Confidentiality is a **personal duty**: protect what people are not entitled to see; don't access what your role doesn't need.
- The five control families are **access, physical, network/system, email/communication, and incident response** — you have a part in each.
- **One login, one person** — never share credentials, even with a colleague covering for you. Expect no privacy on firm systems.
- **Spot phishing by its tells — urgency, a slightly-wrong sender, unexpected links/attachments, requests for credentials or payments.** When in doubt, **DO NOT CLICK**; report to IT, then delete.
- Report any incident the **same day**, do not self-investigate, and remember there is no penalty for a false alarm.

## References

- **Compliance Manual v3.0, §12.2 (Information Security Controls)** and **§15.1 (Confidentiality standard)** — primary sources.
- **HR Operations Manual v1.1, Chapter H4 (IT Acceptable Use Policy)**, including H4.4 (Cybersecurity Incidents) — primary source.
- Supporting: WS1 Foundation & Governance (separation of duties; the audit trail as the control).
- Regulatory basis: NDPA 2023 / NDPR; Cybercrimes (Prohibition, Prevention) Act 2015.
- *Mandatory module · annual refresh + induction. Content owner: Chief Compliance Officer. Tier A. Authoring note (for the CCO): Transworld has no standalone Board-edition information-security/acceptable-use policy; this module is authored from Compliance Manual §12.2 and HR Operations Manual H4 — publishing requires the CCO to accept that gap. The internal first-alert window differs between sources (CM §12.2: within 2 hours; HR Ops H4.4: same day) — logged as an open doc-fix; both are taught here as "immediately."*$body$,
    pass_mark = 80,
    estimated_minutes = 30,
    status = 'PUBLISHED',
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'FND-106';

-- 2. the 20-question graded knowledge-check (correct answers stored server-side)

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_01$id$, m.id, $p$Information security at Transworld is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Only the IT Lead's responsibility"}, {"key": "b", "text": "The sum of what every person does at their own desk"}, {"key": "c", "text": "Handled entirely by software"}, {"key": "d", "text": "Optional for non-technical staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Security is everyone's job — it is the sum of the choices each person makes, not a setting IT applies on your behalf.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_02$id$, m.id, $p$A colleague is covering your desk and asks for your login so they can work. You should:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Share it — they are covering for you"}, {"key": "b", "text": "Share it but change your password afterward"}, {"key": "c", "text": "Never share it; one login belongs to one person"}, {"key": "d", "text": "Share it if your manager is unavailable to ask"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Credentials are never shared, including with a colleague covering for you. Sharing breaks the unique-identity control that records who did what.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_03$id$, m.id, $p$You receive an email warning your account will be closed in 24 hours unless you 'verify' your password via a link. This is most likely:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "A genuine system message — click to keep your account"}, {"key": "b", "text": "A phishing attempt — do not click; report it to IT"}, {"key": "c", "text": "Safe because it mentions your account"}, {"key": "d", "text": "Only a concern if the link looks broken"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Urgency plus a request to verify a password via a link is a classic phishing pattern. Do not click; report it to IT.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_04$id$, m.id, $p$The single most important rule when an email looks suspicious is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Reply and ask the sender if it is real"}, {"key": "b", "text": "Forward it to colleagues to warn them first"}, {"key": "c", "text": "When in doubt, do not click — report to IT"}, {"key": "d", "text": "Open the attachment carefully to check"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$When in doubt, DO NOT CLICK. Do not open attachments, enter credentials, or approve payments. Report to IT first.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_05$id$, m.id, $p$Which are common tells of a phishing email? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "Urgency or threats to act now"}, {"key": "b", "text": "A sender address that is slightly misspelled"}, {"key": "c", "text": "An unexpected link or attachment asking you to log in or release a payment"}, {"key": "d", "text": "A request for your password or one-time code"}]$o$::jsonb, $c$["a", "b", "c", "d"]$c$::jsonb, $e$Urgency, a slightly-wrong sender, unexpected links/attachments, and requests for credentials or codes are all phishing tells. Legitimate institutions never ask for your password by email.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_06$id$, m.id, $p$There is a penalty for reporting an email that later turns out to be genuine.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. There is no penalty for reporting a false alarm — but real damage from clicking a malicious one. Reporting is always the safe choice.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_07$id$, m.id, $p$Confidential client information may be shared externally:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Freely, if the recipient asks nicely"}, {"key": "b", "text": "Only with Compliance Officer approval"}, {"key": "c", "text": "Over any channel as long as it is quick"}, {"key": "d", "text": "By personal email to save time"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$External sharing of client data requires Compliance Officer approval, and confidential information must not travel over unsecured channels.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_08$id$, m.id, $p$Which is a prohibited activity on Transworld systems?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Limited incidental personal browsing that does not impede work"}, {"key": "b", "text": "Installing unauthorized software on a firm device"}, {"key": "c", "text": "Using the approved VPN on public Wi-Fi"}, {"key": "d", "text": "Reporting a phishing email"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Installing unauthorized software is prohibited, as are credential sharing, accessing beyond your permissions, and disabling security software.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_09$id$, m.id, $p$On Transworld systems you should expect:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Complete privacy in all use"}, {"key": "b", "text": "No expectation of privacy; authorized monitoring may occur"}, {"key": "c", "text": "Privacy only for personal email"}, {"key": "d", "text": "Privacy as long as you log out"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$There is no expectation of privacy on firm systems; authorized monitoring may occur for security and compliance.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_10$id$, m.id, $p$Access to firm systems is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "The same for everyone"}, {"key": "b", "text": "Role-based, reviewed regularly, and revoked on a leaver's last working day"}, {"key": "c", "text": "Never reviewed once granted"}, {"key": "d", "text": "Granted permanently to all permanent staff"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Access controls are role-based, reviewed regularly, and revoked on the leaver's last working day.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_11$id$, m.id, $p$You lose a firm laptop that holds client files. You should:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Wait to see if it turns up"}, {"key": "b", "text": "Report it to IT the same day"}, {"key": "c", "text": "Buy a replacement quietly"}, {"key": "d", "text": "Only report it if it is not password-protected"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A lost or stolen device is a reportable incident — report to IT the same day; do not wait or self-assess severity.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_12$id$, m.id, $p$Hovering over a link before trusting it helps because:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "It opens the link safely"}, {"key": "b", "text": "It reveals where the link actually goes, which may differ from the text"}, {"key": "c", "text": "It reports the email automatically"}, {"key": "d", "text": "It disables any malware"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Hovering reveals the true destination of a link, which often differs from the displayed text — a key phishing check. It does not open or neutralize anything.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_13$id$, m.id, $p$On discovering suspected malware, the correct action is to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Try to remove it yourself first"}, {"key": "b", "text": "Report it to IT immediately and not attempt a self-fix"}, {"key": "c", "text": "Keep working and mention it later"}, {"key": "d", "text": "Shut down the network for everyone"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Report immediately and do not self-investigate or self-fix. Speed of response matters more than certainty.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_14$id$, m.id, $p$Connecting a firm device to unsecured public Wi-Fi without the approved VPN is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Fine if you are quick"}, {"key": "b", "text": "Prohibited"}, {"key": "c", "text": "Allowed for personal use only"}, {"key": "d", "text": "Allowed if antivirus is on"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Connecting to unsecured public Wi-Fi without the approved VPN is a prohibited activity.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_15$id$, m.id, $p$An executive emails you out of the blue asking you to urgently change a vendor's bank details and release a payment. You should:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Act immediately because it is from an executive"}, {"key": "b", "text": "Treat it as a possible phishing/impersonation attempt and verify through a known channel before acting"}, {"key": "c", "text": "Reply to the email to confirm"}, {"key": "d", "text": "Forward it to the vendor to check"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$An unusual, urgent payment-change request is a classic impersonation tell. Verify through a separate, known channel before acting — do not rely on the email itself.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_16$id$, m.id, $p$'One login, one person' exists mainly to:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Save software licenses"}, {"key": "b", "text": "Preserve the unique-identity control so the firm knows who did what"}, {"key": "c", "text": "Make logging in faster"}, {"key": "d", "text": "Reduce the number of passwords"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Unique credentials preserve accountability — the record of who did what. Sharing destroys that control.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_17$id$, m.id, $p$Disabling antivirus or automatic updates on a firm device is acceptable if it speeds up your work.$p$, $t$TRUE_FALSE$t$, $o$[{"key": "a", "text": "True"}, {"key": "b", "text": "False"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$False. Disabling security software, antivirus, or automatic updates is a prohibited activity.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_18$id$, m.id, $p$Which best reflects the firm's confidentiality rule of thumb on pay and similar data?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Everything is secret, including the rules"}, {"key": "b", "text": "Individual amounts are confidential; the structure and rules are open"}, {"key": "c", "text": "Everything is open, including individual amounts"}, {"key": "d", "text": "Only leadership pay is confidential"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Individual pay amounts are confidential; the structure and rules are open to all. Share what people are entitled to know; protect what they are not.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_19$id$, m.id, $p$Which of these are reportable security incidents? (Select all that apply.)$p$, $t$MULTI$t$, $o$[{"key": "a", "text": "A phishing email you received"}, {"key": "b", "text": "A lost or stolen device"}, {"key": "c", "text": "Unauthorized access to a system"}, {"key": "d", "text": "Approved use of the PeopleOps portal"}]$o$::jsonb, $c$["a", "b", "c"]$c$::jsonb, $e$Phishing emails, lost/stolen devices, and unauthorized access are all reportable. Normal approved use is not an incident.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_fnd106_20$id$, m.id, $p$The safest summary of handling a suspicious email is:$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "Click carefully to verify, then decide"}, {"key": "b", "text": "When in doubt, do not click — report to IT, then delete"}, {"key": "c", "text": "Ignore it and carry on"}, {"key": "d", "text": "Reply to the sender to confirm legitimacy"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$When in doubt, do not click; report to IT and delete after reporting. A reported phishing email is harmless; a clicked one can be catastrophic.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'FND-106'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

COMMIT;
