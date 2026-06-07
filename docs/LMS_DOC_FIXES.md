# LMS Doc-Fix Register

**Purpose.** As we author the LMS, modules are built from the canonical policy documents
*and* verified against current law. Where a module teaches a position that differs from a
source document — because the source is internally inconsistent, stale, or superseded — we
record it here rather than silently diverging. The LMS teaches the correct/current position
now; the source documents are corrected in a later doc-refresh pass so the whole estate
realigns.

**Maintainer:** People-Ops. **Source-of-truth note:** the HR Operations Manual is the human
canonical for policy; the portal is the operational source of truth for live data; this
register is the backlog of corrections owed to the policy estate.

**Status key:** OPEN (logged, not yet fixed in source) · FIXED (source updated) · CONFIRM
(needs a decision/fact confirmed before fixing).

| # | Source doc & location | Issue | Position the LMS teaches | Discovered | Status |
|---|---|---|---|---|---|
| DF-01 | Compliance Manual §12.2 ("within 2 hours"); Code of Ethics 8.3 ("within 24 hours"); HR Ops H3.4 ("same day") | The internal breach-reporting window is stated three different ways across three documents, and the shortest (2 hours) is still treated as a permissible delay. | **Report a suspected or actual breach immediately on discovery** — no hour-based latitude. Compliance then assesses regulator (NDPC) notification. Standardize all three sources to "immediately." | Batch 1 (REG-101 / TEC-102 / PPL-102) | OPEN |
| DF-02 | Compliance Manual §3 (NDPA 2023 listed as administered by "NITDA"); HR Ops H3 (regulatory basis cites "NDPR 2019 / NITDA" only) | Data-protection regulator and instrument are stale. The NDPA 2023 established the **NDPC** as regulator (not NITDA); and per the **GAID 2025 (effective 19 Sep 2025) the NDPR 2019 has ceased to be extant law**. | Governing framework is **NDPA 2023 + GAID 2025**, regulated by the **NDPC**. NDPR 2019 is superseded. Update CM §3 table (regulator → NDPC) and HR Ops H3 (regulatory basis + breach clause: NITDA → NDPC; retire NDPR-2019 primacy). | Batch 1 (web-verified 06 Jun 2026) | OPEN |
| DF-03 | Operational Manual + Employee Handbook (performance-cycle calendar) | Both print a **June–May** performance cycle; the canonical cycle is the **calendar year (Jan–Dec), mid-cycle July**, per the PD Guides. (HR Ops Manual Part A already prints the calendar-year version.) | Calendar-year cycle (Jan–Dec): goal-setting Jan, goal-sealing 28 Feb, mid-cycle July, year-end due 31 Dec, calibration Feb–Mar, bonus April. Correct the calendar in the Operational Manual and the Handbook. | Pre-existing (carried in) | OPEN |
| DF-04 | WS2 Workforce Architecture pack (compa floor) | Prints a compa-ratio floor of **0.85**; the locked model floor is **0.80**. | Compa floor 0.80 ("At 0.80" green / "Below 0.80" amber). Correct WS2. | Pre-existing (carried in) | OPEN |
| DF-05 | Whistleblower Policy / Handbook / portal (speak-up channel details) | Whistleblower reporting **email address** and the **Report-a-Concern** channel reference need to be confirmed and aligned across the policy, the Handbook, and the portal. | (Pending) — confirm the live WB email + Report-a-Concern channel, then align all three. | Pre-existing (carried in) | CONFIRM |
| DF-06 | Operational Manual §12.1 Settlement Rules (cheque release "on T+3 settlement day"; failed settlement "fails to settle on T+2") | Settlement cycle is stale. NGX equities settlement moved T+3 → T+2 (28 Nov 2025) → **T+1 (effective 1 Jun 2026)**. | **NGX equities settle T+1.** Update the Operational Manual settlement rules (cheque release / failed-settlement timing) to a T+1 basis. | Batch 2 (OPS-101; web-verified 06 Jun 2026) | OPEN |
| DF-07 | Operational Manual §5.2 Issuance Rules ("Contract notes must be prepared and dispatched within 24 hours of trade execution") | Contract-note dispatch is stated as "within 24 hours"; current practice and the LMS teach same-day issuance. | **Contract notes are issued the same day as the trade.** Tighten §5.2 from "within 24 hours" to "same day." | Batch 2 (OPS-101) | OPEN |
| DF-08 | LMS Curriculum Source Map (mandatory markers) | The source map does not consistently mark which modules are firmwide-mandatory vs. role-targeted. | Add explicit mandatory markers so the mandatory set (the 11 level-F FND) is unambiguous against role-targeted P/E content. | Carried in (from handoff) | OPEN |
| DF-09 | Employee / Manager PD Guides (version label) | Version labeling drifts between v1.0 and v1.1 across references. | Standardize PD Guide references to v1.1 throughout the estate. | Carried in (from handoff) | OPEN |
| DF-10 | Compliance Manual v3.0; AML/CFT/CPF Policy v3.0; LMS Curriculum Source Map (statute citation) | All three cite **"ISA 2024"** as the governing capital-market statute. The enacted, current law is the **Investments and Securities Act 2025** (signed 29 Mar 2025), repealing ISA 2007; existing CMO registrations remain valid but must meet revised minimum capital by **30 Jun 2027**. | Cite **ISA 2025** as the apex statute throughout the compliance estate; correct every "ISA 2024" reference. REG-201…204 already teach ISA 2025. | Batch P1 / REG (web-verified 07 Jun 2026) | OPEN |

*All Batch 1–4 LMS content is now published (v0.48.0–v0.51.0); Batch 4 added no new rows. The register is therefore due for the **batched doc-refresh pass** — read each target source first, propose the per-document edit set, then mark each row FIXED as it lands. DF-05 requires a CONFIRM (live WB email + Report-a-Concern channel) before it can be fixed.*
