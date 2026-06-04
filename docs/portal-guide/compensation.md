# Compensation
### Transworld PeopleOps Portal — a guide for the team

This is part of the portal guide. It's written to be read alongside the app —
press the **?** on any page for the same help in a panel. The portal is a
**control room**: it records and checks pay, bonus and compliance evidence;
HumanManager and Remita still pay people. Figures shown in the portal are
provisional records in Naira (₦).

---
### Compensation

The pay control room. It holds each person's standing compensation profile and the levers around it — salary bands, band positioning, raise cycles, change requests, sponsorships and the tax rules. Remember: the portal records and controls pay; HumanManager and Remita still pay it.

**Who can use this:** Viewable by Finance/Exec; Finance & People Ops manage; Exec (RemCo) approves.

**What you can do here:**

- **Open a person** — Goes to one employee's compensation.
- **Establish / change pay** — Sets a profile or raises a change request; changes are approved separately.

**Where this sits:** Profile (basic + utility → fully-loaded gross × 17) → positioned against the band → changed via request or raise cycle → approved by RemCo → standing record updated. Payment stays with HumanManager/Remita.

**Good to know:**

- The portal does not pay anyone — these are provisional control records.
- Pay maths is settled: fully-loaded = gross × 17 ÷ 12 ÷ FTE; annual = gross × 17.

---

### Band positioning

A read-only awareness view of where each person sits in their grade's band — their compa-ratio, and flags for anyone below minimum or below 0.85. It's a lens for spotting pay that needs attention; you act via change requests or a raise cycle.

**Who can use this:** Finance/Exec/People Ops (compensation.view).

**What you can do here:**

- **Review positioning** — Reads compa-ratios and below-band flags; no changes are made here.

**Good to know:**

- Awareness only — to move someone, use a change request or the raise cycle.

---

### Change requests

The queue of pay-change requests across the firm — what's proposed, by whom, and awaiting RemCo's decision.

**Who can use this:** People Ops raises (compensation.manage); RemCo decides (compensation.approve).

**What you can do here:**

- **Create request** — Proposes a pay change for a person.
- **Decide request** — Approves or rejects — never the same person who raised it. (_two people, on purpose_)
- **Cancel request** — Withdraws a pending request.

**Good to know:**

- Approved requests update the standing profile (versioned), not payroll directly.

---

### Employee compensation

One person's pay in detail: their current profile (basic, utility, fully-loaded), their band position, and the change requests on file. Where People Ops establishes pay and raises a change for RemCo to approve.

**Who can use this:** Finance/People Ops manage; Exec (RemCo) approves (compensation.approve).

**What you can do here:**

- **Establish profile** — Sets the person's standing pay components.
- **Create change request** — Proposes a pay change for approval.
- **Decide request** — RemCo approves or rejects the change — a different person from the one who raised it. (_two people, on purpose_)
- **Cancel request** — Withdraws a pending change.

**Where this sits:** A pay change flips the prior profile version to not-current and writes a new current version in one transaction, carrying the tax structure forward — that versioning is the integration contract.

**Good to know:**

- No self-approval on pay changes.
- Approved changes update the standing record only; payment still runs in HumanManager/Remita.

---

### Qualification sponsorship

The register of firm-sponsored professional qualifications — who's being sponsored, the costs, attempts, and the clawback terms if someone leaves. People Ops manages; RemCo approves a sponsorship.

**Who can use this:** People Ops manages (compensation.manage); RemCo approves (compensation.approve).

**What you can do here:**

- **New sponsorship** — Sets up a sponsorship for approval.
- **Open a sponsorship** — Goes to a sponsorship to manage costs, attempts and status.

**Where this sits:** Create → RemCo approves → start → record costs/attempts → complete (clawback clock starts) or withdraw. Clawback is on completion, 12 months.

**Good to know:**

- Clawback runs from completion for 12 months; mid-study exit is a COO review.
- The early-leaver crystallization is handled when offboarding lands — not automated here yet.

---

### Raise cycles

The pay-raise cycles — a controlled, firm-wide pass that proposes and applies raises. People Ops opens and prepares a cycle; RemCom approves and applies it. A raise lifts every pay component uniformly so the structure is preserved.

**Who can use this:** People Ops prepares (compensation.manage); RemCom approves & applies (compensation.approve).

**What you can do here:**

- **Open a cycle** — Starts a new raise cycle.
- **Open a cycle to work it** — Goes to the cycle's worksheet.

**Where this sits:** Open → set inputs → recompute → adjust per person → submit → RemCom approves → lock & apply. Applying updates standing profiles only.

**Good to know:**

- A raise applies the percentage to every component (basic, utility, allowance) so the annual total rises by exactly that percentage.
- The annual total is on the 17-month basis (gross × 17).

---

### Salary bands

The firm's fully-loaded salary bands, G0–G5. These define the pay range for each grade and are what band positioning and compa-ratio are measured against.

**Who can use this:** Viewable; People Ops/Finance maintain (compensation.manage).

**What you can do here:**

- **Save salary bands** — Updates the band minimum/mid/max by grade (audited).

**Good to know:**

- Bands are fully-loaded (gross × 17 ÷ 12 ÷ FTE) — the same basis as positioning.

---

### Tax rules

The configurable tax rule sets and bands the portal uses for PAYE and statutory deductions. Tax is never hardcoded — it's read from here, so the active ruleset is what payroll computes against.

**Who can use this:** Finance/People Ops (compensation.manage).

**What you can do here:**

- **Save tax ruleset** — Creates or edits a ruleset and its bands.
- **Activate ruleset** — Makes a ruleset the active one payroll uses.

**Good to know:**

- Only the active ruleset drives payroll — activate the right one.
- ITF is an in-net employee deduction from April 2026.

---

### New sponsorship

Sets up a new qualification sponsorship for an employee, ready for RemCo approval.

**Who can use this:** People Ops (compensation.manage).

**What you can do here:**

- **Create sponsorship** — Creates the sponsorship in draft for approval.

**Good to know:**

- Spell out the clawback terms up front — they bite on completion.

---

### Raise cycle

One raise cycle's worksheet: the inputs, the computed per-person raises, the adjustments, and the approve-and-lock that applies them. Prepared by People Ops, approved and locked by RemCom.

**Who can use this:** People Ops prepares; RemCom approves & locks.

**What you can do here:**

- **Set inputs / recompute** — Sets the cycle parameters and recomputes the per-person raises.
- **Adjust a person** — Overrides an individual's raise with a note.
- **Submit for approval** — Sends the cycle to RemCom; it locks for editing.
- **Approve** — RemCom approves — a different person from the preparer. (_two people, on purpose_)
- **Lock & apply** — Locks the cycle as permanent evidence and applies the raises to standing profiles. (_permanent once done_)

**Good to know:**

- No self-approval; preparer ≠ approver.
- A locked cycle is permanent, read-only evidence.

---

### Sponsorship detail

One sponsorship in full: its status, the costs incurred, exam attempts, and the clawback position.

**Who can use this:** People Ops manages; RemCo approves.

**What you can do here:**

- **Approve** — RemCo approves the sponsorship. (_two people, on purpose_)
- **Start / complete / withdraw** — Moves the sponsorship through its lifecycle; completing starts the 12-month clawback clock.
- **Add cost / attempt; waive** — Records costs and exam attempts, and waives a cost where agreed.

**Good to know:**

- Completion — not approval — starts the clawback window.

