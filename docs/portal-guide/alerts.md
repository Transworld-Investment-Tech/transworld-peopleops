# Alerts
### Transworld PeopleOps Portal — a guide for the team

This is part of the portal guide. It's written to be read alongside the app —
press the **?** on any page for the same help in a panel. The portal is a
**control room**: it records and checks pay, bonus and compliance evidence;
HumanManager and Remita still pay people. Figures shown in the portal are
provisional records in Naira (₦).

---
### Alerts

The early-warning board. It computes document-expiry alerts (from staff-document expiry dates, in 90-day / 30-day / expired buckets) and staff-file-gap alerts (files below the threshold). You see the live dry run first, then commit the ones worth tracking.

**Who can use this:** Oversight roles view; People Ops generates and manages (stafffile.manage).

**What you can do here:**

- **Commit alerts** — Persists the previewed alerts. Idempotent — committing twice won't duplicate, and a dismissed/resolved alert is never resurrected.
- **Dismiss / resolve** — Clears an alert you've handled or judged not relevant.

**Where this sits:** Dry run (the page preview) → commit (button) → work the list → dismiss or resolve. Never automated — you decide what becomes a tracked alert.

**Good to know:**

- The preview recomputes every visit; committing is what makes an alert stick.
- Expiry alerts read staff-document expiry dates; gap alerts read the staff-file drive.

