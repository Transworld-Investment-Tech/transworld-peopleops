# STATE_OF_APP — Transworld PeopleOps Portal
_Version: **v0.46.0** · Updated: June 6, 2026 · `main` · green in production (FND-108 seed `b33a42d`; v0.46.0 six-seed batch STAGED; docs commit `<filled after push>`)_

## Current status: WS7 LMS live + content authoring underway ✅
The HRIS spine, the full compensation/reward stack, WS5 conduct & cases, the performance cycle,
WS3 + WS4 depth, the **WS7 full LMS**, and now the first two authored mandatory modules are live. This
session was a content + polish + compensation-correctness arc on top of the v0.43.1 LMS base:

- **v0.43.2 — FND-104 content (AML/CFT & KYC Awareness):** authored FROM POLICY off **AML/CFT/CPF Policy
  v3.0 + KYC Policy v3.0** (Tier A, CCO-owned). Data seed `seed_fnd104_content.sql` (idempotent): lesson
  body (with callouts/dividers) + a **20-question** server-graded check at **80%**, module set
  **PUBLISHED**, `estimated_minutes = 30`. No schema/permission change. The catalogue now has **two**
  authored mandatory modules (FND-103, FND-104).
- **v0.43.3 — LMS rendering polish (payload-only):** lesson prose is now **fully justified**
  (`.lesson p` / `.lesson .callout`, `text-align: justify` + `hyphens: auto`; lists left by design), and
  the **knowledge-check options are left-aligned** — `QuizTaker` stopped borrowing the key/value
  `.kv .row` pattern (which is `justify-content: space-between`) and uses its own `.quiz-opts` /
  `.quiz-opt` classes. One marker-guarded CSS block, **`TW-LMS-CSS-V0433`**. Fixes apply to every module
  (FND-103 + FND-104) at once.
- **v0.43.4 — Compensation correctness (code-only):** (1) the individual compensation page
  (`getEmployeeCompensation`) now resolves grade via the single canonical resolver
  **`personGrade(employees.grade ?? jobProfile.grade)`** — it previously read role-grade only and didn't
  even load `employees.grade`, which made a person with a personal-grade override (e.g. Tester EID 20 = G1,
  role Investment Analyst = G2) show **G2** on the profile but **G1** in the positioning table. Now both
  agree. (2) The **compa-ratio target moved 0.85 → 0.80** (`CR_PRIORITISE = 0.8`); every "Below 0.xx" chip
  and the positioning note render from that constant, plus the one hardcoded "below 0.85" string in the
  Compensation help entry was updated.
- **v0.43.5 — Compa-ratio chip refinement (code-only):** people **at** the 0.80 floor now show a **green
  "At 0.80"** chip instead of amber. "At" vs "Below" is decided once in `lib/compensation.ts` (new
  `atTarget` flag) on the **displayed (2-dp)** compa-ratio, so the chip always matches the figure shown —
  the G1 cohort that computes to ≈0.799 (displays 0.80) now reads green "At 0.80"; genuinely-under people
  (0.79) keep amber "Below 0.80". Both the positioning table and the individual page consume the flag.
- **v0.43.6 — hotfix (code-only):** v0.43.5 added `atTarget` as a **required** field on the
  `EmployeePositioning` type and to the main return of `getEmployeePositioning`, but missed the
  **early-return** (no-band / no-monthly-gross) branch — so `next build` failed
  (`lib/compensation.ts:862 — Property 'atTarget' is missing … required in 'EmployeePositioning'`).
  Added `atTarget: false` to that one object. (Lesson: shared-type changes need a real `tsc` typecheck in
  staging — esbuild strips types and can't catch a missing required property. `tsc` is now part of the
  staging checks for type-touching releases.)

- **v0.43.7 — FND-107 content (Conflicts of Interest):** authored FROM POLICY off **Conflict of Interest
  Policy CO-POL-002 v3.0** (supporting: Code of Ethics CO-POL-001; Gift/Benefit/Hospitality HR-POL-006);
  Tier A, CCO-owned. Data seed `seed_fnd107_content.sql` (idempotent): lesson body (callouts/dividers) +
  a **20-question** server-graded check at **80%**, module set **PUBLISHED**, `estimated_minutes = 35`.
  No schema/permission change. The catalogue now has **three** authored mandatory modules (FND-103,
  FND-104, FND-107). Running the seed by hand is the CCO publish gate.
- **v0.44.0 — Job Family Restructure (code + schema):** job families **four → five** (new **Administration
  & Corporate Services**, value `ADMIN_CORPORATE_SERVICES`). Family is CHECK-constrained `text` (no enum) —
  migration **`0033`** widens the `job_profiles.family` CHECK to five (dropped by actual `pg_constraint`
  name, re-added). Vocabulary consolidated into one pure client-safe module `lib/jobframework-vocab.ts`
  (re-exported from `jobframework.ts`; the form's duplicate `FAMILY_OPTS` retired). Scoring engine `Family`
  union + `FAMILY_WEIGHTS` gain ADM at **50/25/25** (= Control & Operations split; the engine already fell
  through to this default, so **no bonus math changed**). Functional competencies **22 → 26** (two new
  categories **Business Development** + **Administration**; competency `category` is free text, no CHECK).
  ADM is **revenue-free** (an authoring rule — there is no revenue primitive in the engine).
- **v0.45.0 — Job Family Restructure (data):** three new **role** profiles (DRAFT, 0 holders) —
  **Procurement Officer** (G2, ADM), **Marketing & Communications Officer** (G2, Business Development),
  **Office Administrator** (G1, ADM) — each with behaviors + functional competencies. Family moves by exact
  title: **People-Ops Officer → ADM**; **COO → Leadership**; **CFO → Leadership**. **Grades and pay
  untouched.** COO's default weighting becomes 55/20/25 (intentional). RemCom ratified before commit.
- **v0.45.1 — FND-108 content (Whistleblowing & Speaking Up):** authored FROM POLICY off the
  **Whistleblower Policy v1.0** (supporting: Compliance Manual v3.0); Tier A, CCO-owned. Data seed
  `seed_fnd108_content.sql` (idempotent): lesson body (callouts/dividers) + a **20-question** server-graded
  check at **80%**, `estimated_minutes = 30`. **Seed committed (`b33a42d`) and STAGED** — running it by hand
  sets FND-108 **PUBLISHED**; held for the **CCO publish gate**. Data-only (no schema/permission change;
  `package.json` unchanged at `0.45.0`). The lesson reflects two operational points beyond the v1.0 text —
  the corrected reporting email **whistleblower@transworldltd.com.ng** and the portal **Report a Concern**
  channel (senior-management + anonymity toggles) — both logged as open Whistleblower-Policy doc-fixes.

- **v0.46.0 — FND-10X go-live batch (six content seeds; data-only):** authored the remaining Foundational
  tier as one release. **Graded Tier-A (CCO publish gate) — FND-105 Data Protection/NDPR** (CM §12.1 + HR Ops
  H3; standalone-policy GAP), **FND-106 Confidentiality & Information Security** (CM §12.2 + §15.1 + HR Ops H4;
  dedicated phishing section — "when in doubt, DO NOT CLICK"; standalone-policy GAP), **FND-109 SEC/NGX Conduct
  Essentials** (CM §3 + §10 market-conduct at awareness level + §15; Op Manual §1; Code of Ethics) — each a
  lesson + **20-question** check at **80%**, 30/30/35 min, PUBLISHED on run. **Lesson-only (pass_mark NULL) —
  FND-101 Welcome** (WS1 Part 3 + WS2 Layer 3 six behaviors; Tier C), **FND-102 How the firm works** (WS2 Parts
  1-3 + WS1 Part 2 + HR Ops A/B; Tier C), **FND-110 Documentation discipline** (ICF §1 + Op Manual §19; WS2
  Behavior 5; Tier B). **WS1/WS2 are now in Project files (refreshed) — the "WS absent" flag is retired.** Six
  idempotent seeds via one generate-only setup.sh; all **STAGED**. No schema/permission change (migrations stay
  `0033`). `package.json` → `0.46.0`.

Everything above is deployed to production; the FND-108 seed plus the six v0.46.0 content seeds are committed and
staged for the CCO publish run. **`package.json` reads `0.46.0`.**

## Live infrastructure
| Layer    | Detail |
|----------|--------|
| Local    | `~/transworld-peopleops` (Mac). Never touch `~/transworld-portal` (legacy). |
| GitHub   | `Transworld-Investment-Tech/transworld-peopleops`, `main` (public). Recent: v0.43.1 `8bf5321` → v0.43.3 `43d0e10` → v0.43.4 `186965d` → (v0.43.5 `d9a6fb5` errored) → **v0.43.6 `763267a`** → v0.43.7 `191e57a` → **v0.45.0 `79d3e95`** → FND-108 seed `b33a42d`. |
| Vercel   | Project `transworld-peopleops`; auto-deploys from `main`; `https://transworld-peopleops.vercel.app`. Local `npm run build` is the pre-push gate (the v0.43.5 break would have been caught locally). |
| Database | Supabase ref `qvqupbzgzyohtrswqqon`, us-west-2, Pro. Pooler (IPv4) `aws-1-us-west-2.pooler.supabase.com:6543`, `?pgbouncer=true`. |
| Storage  | Supabase Storage, private bucket `peopleops` (service-role, server-side). |

Admin: **okezie.ofoegbu@transworldltd.com.ng** (SUPER_ADMIN, EID 13).

**Stack:** Next.js 15 · React 19 · TypeScript · Prisma 6 · PostgreSQL (Supabase) · Tailwind · Supabase
Storage · SheetJS.

**Scale (unchanged this session — no schema/permission change since v0.43.1):** **75 Prisma models** ·
**8 legacy Postgres enums** (no new enums — CHECK text) · **51 permissions** · role-permission links 196 ·
migrations sequential to **`0033`** · 15 users. No `auth:bootstrap` (v0.44.0 widened a CHECK; v0.45.0 was data-only).

**Pure engines + tests (green, unchanged):** payroll 31 · bonus 45 · bonus-ledger 19 · raise 42 ·
sponsorship 32 · scorecard 32 · ws5 7 · stafffile 14 · expiry 8 · ws4 27 · **lms 17** · help 15.

## The single most important design rule (unchanged)
The portal does **NOT** process or pay salaries/bonuses. HumanManager + Remita are authoritative; the
bonus is paid in April against the prior year's audited financials. The portal is a **control room /
evidence layer**. Tax is configurable; pay/bonus/raise figures are provisional.

## Seal pattern (unchanged)
Sealed goal agreements, locked payroll/bonus/raise cycles are immutable evidence; Bonus Phase B is the one
post-lock exception. WS5 case + calibration records are audited-event evidence. **LMS:** a passed graded
check (score/passed/attempt/date) and a waiver (who/why/when) are completion evidence; each annual
mandatory period is its own immutable `learning_records` row (the `period` key).

## Performance cycle (calendar year — unchanged)
Calendar year Jan–Dec; goal-setting Jan; **mid-cycle review July**; year-end self+manager Nov–Dec;
calibration Feb–Mar; bonus April (audited financials Mar 30). **PD Guides are canonical**; the HR Ops
Manual + Handbook still print the stale June–May / December calendar (open document-fix). LMS `ANNUAL`
cadence aligns to the calendar year.

## WS7 LMS — how it works (current)
- **Catalogue:** each module carries `code` (e.g. `FND-104`), `domain` (FND/CLA/FIN/INV/LDR/OPS/REG/TEC),
  `level` (F/P/E), `owner` (CCO/PEOPLE_OPS/FUNCTION_HEAD), `cadence`, `is_mandatory`, `pass_mark`,
  `status` (DRAFT/PUBLISHED/ARCHIVED). The full **65-module curriculum** is seeded; **FND-103, FND-104 and FND-107 are PUBLISHED with authored content; FND-108 + the v0.46.0 batch
  (FND-105/106/109/101/102/110) are authored with seeds committed and STAGED pending the run**; any remaining shells are DRAFT.
- **Matrix (`learning_assignment_rules`):** module × scope (ALL/GRADE/JOB_PROFILE) × requirement
  (REQUIRED/RECOMMENDED). 8 firmwide FND `ALL/REQUIRED` rules + the **164 `JOB_PROFILE` rules** across all
  20 roles (v0.43.1).
- **Auto-assign:** dry-run preview → commit; writes `source=MANDATORY` records for PUBLISHED+mandatory
  modules each person needs for the current period. **Now acts on FND-103 + FND-104 + FND-107** (all PUBLISHED).
- **Knowledge-check:** `learning_quiz_questions` (SINGLE/MULTI/TRUE_FALSE; `correct` server-side only).
  `submitCheckAction` grades server-side (guarded, `TW-LMS-SUBMIT-GUARD-V0431`); a pass completes the
  record. Pure engine `lib/lms.ts` (17 tests).
- **Lesson renderer:** markdown in `learning_modules.body` — `##/###`, lists, bold/italic/code/links,
  **`>` info** and **`>!` warning** callouts, **`---` dividers**; styled by the `.lesson` block, now with
  justified prose (`TW-LMS-CSS-V0433`). Options render via `.quiz-opts` / `.quiz-opt` (left-aligned).
- **Compliance dashboard:** `getComplianceOverview` (matrix × active staff → gaps worst-first) +
  per-person `getEmployeeCompliance`. Evidence/attestation + waiver actions on records.

## Canonical pay / competency / compa models (current)
Gross = basic + utility; fully-loaded = gross × 17 ÷ 12 ÷ FTE; annual = gross × 17; `quarterlyAllowance`
retired. **Compa-ratio = fully-loaded ÷ grade midpoint.** Compa thresholds: **floor target 0.80**
(`CR_PRIORITISE`) — at it → green **"At 0.80"** (decided on the displayed 2-dp CR via `atTarget`), below
it → amber **"Below 0.80"**; **COO-awareness 1.15** (`CR_COO_AWARE`) → red "Above 1.15". **26 competencies /
9 categories** (F/P/E); six behaviors; **five families** (added Administration & Corporate Services) +
control-fn flag; ADM weighting **50/25/25** (revenue-free, authoring rule); banded weighted-average multiplier +
integrity gate. **Person grade = `employees.grade ?? jobProfile.grade`** via `personGrade` — every
compensation view now uses it (fixed in v0.43.4).

## Module status
- **Live & deep:** Employees, Job & Competency, Compensation, Payroll Control, Bonus, Leave, Recruitment,
  Onboarding/Offboarding, Performance (+ self-assessment, mid-cycle, calibration, PIP), Disciplinary,
  Grievances, Whistleblower, **Learning + Training Matrix + Training Compliance (WS7 full LMS)**,
  My Profile/Documents/Bonus/Payslips, Staff Files, Alerts, Audit Log, Dashboard.
- **Content authoring (the live stream):** **FND-103 + FND-104 + FND-107 authored & PUBLISHED; FND-108 authored, seed staged (pending CCO publish)**
  (lesson + 20-question check each, 80% pass). The remaining FND shells await content. Tier A (compliance) modules are CCO-owned;
  CCO review is the publish gate.
- **Spine-level / depth pending:** Evidence Vault, Internal Controls / RemCo, generated Employment
  Agreement.

## Roster snapshot
~18 employee records, **15 active staff / users**. `salary_bands` G0–G5 loaded (fully-loaded monthly
equivalents: 120k/195k/250k/340k/470k/640k midpoints); active tax ruleset Nigeria PIT 2026. Learning
records populate when auto-assign is committed.

## What's next (recommended order — see HANDOVER)
1. **LMS content authoring — go-live sprint for the FND-10X tier.** Done & PUBLISHED: FND-103/104/107.
   **FND-108 authored, seed staged (pending CCO publish).** **The earlier "scanned-image, no text" BLOCKER
   is CLEARED** — the Project-file policy sources are bundles shipping clean per-page text (and the HR Ops
   Manual + LMS Source Map are plain text); Compliance Manual, ICF, Operational Manual, Code of Ethics,
   Handbook, and Retreat Report are all readable. Remaining 10X: **graded Tier-A (CCO gate) — FND-105 (NDPR),
   FND-106 (Info-Sec), FND-109 (SEC/NGX Conduct)**; **lighter — FND-101 (Tier C, lesson-only), FND-102
   (Tier C, lesson-only), FND-110 (Tier B, lesson-only)**. FND-105/106 carry a standalone-policy **GAP**
   (author from Compliance Manual §12.1/§12.2 + HR Ops Manual; the CCO must accept the gap at publish);
   WS1/WS2 (FND-101/102) are not in Project files — author from Handbook + Retreat + HR Ops Manual + the
   canonical framework doc and flag. **The binding go-live constraint is the CCO publish gate, not authoring
   throughput** — batch all four Tier-A modules (108/105/106/109) into one CCO review. See the **LMS
   Curriculum Source Map v2.0**.
2. **MANR role-specific mandatory layer (deferred)** — three items have no 1:1 module (Best Execution,
   Client Funds Handling, Payroll & Statutory Remittance Controls): author-new vs map-to-nearest.
3. **Phase 4 governance** — Evidence Vault; Internal Controls + RemCo; generated Employment Agreement.
4. **Doc fixes:** (a) Ops Manual + Handbook performance-calendar → calendar-year; (b) Whistleblower Policy
   v1.0 — correct the reporting email to **whistleblower@transworldltd.com.ng** and add the portal **Report a
   Concern** channel (both already reflected in FND-108; owed in the policy at next review).
5. **Reserved roles at hire** — set department/rung/track, flip DRAFT→PUBLISHED; training auto-switches on.
6. **Hygiene:** align `lib/sponsorship-reads.ts` role-only grade to `personGrade` (same latent pattern as
   the v0.43.4 fix); positioning-note copy to mention the green "At 0.80"; Dependabot/security rotations;
   retire vestigial `EmployeeDocument`.

## Next action
Doc set is at **v0.45.1** and reflects HEAD. **FND-108 is authored and its seed is staged** (run by hand
after CCO sign-off to publish). All FND-10X sources are confirmed readable. Next: the **FND-10X go-live
sprint** — author FND-105/106/109 (graded Tier-A) + FND-101/102/110 (lighter) as one batched release, with a
single consolidated CCO review covering all four Tier-A modules (108/105/106/109).
