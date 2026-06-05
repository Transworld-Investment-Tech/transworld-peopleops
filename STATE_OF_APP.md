# STATE_OF_APP — Transworld PeopleOps Portal
_Version: **v0.43.7** · Updated: June 5, 2026 · `main` · green in production (commit `<filled after push>`)_

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

Everything above is deployed to production. **`package.json` reads `0.43.7`.**

## Live infrastructure
| Layer    | Detail |
|----------|--------|
| Local    | `~/transworld-peopleops` (Mac). Never touch `~/transworld-portal` (legacy). |
| GitHub   | `Transworld-Investment-Tech/transworld-peopleops`, `main` (public). Recent: v0.43.1 `8bf5321` → v0.43.3 `43d0e10` → v0.43.4 `186965d` → (v0.43.5 `d9a6fb5` errored) → **v0.43.6 `763267a`**. |
| Vercel   | Project `transworld-peopleops`; auto-deploys from `main`; `https://transworld-peopleops.vercel.app`. Local `npm run build` is the pre-push gate (the v0.43.5 break would have been caught locally). |
| Database | Supabase ref `qvqupbzgzyohtrswqqon`, us-west-2, Pro. Pooler (IPv4) `aws-1-us-west-2.pooler.supabase.com:6543`, `?pgbouncer=true`. |
| Storage  | Supabase Storage, private bucket `peopleops` (service-role, server-side). |

Admin: **okezie.ofoegbu@transworldltd.com.ng** (SUPER_ADMIN, EID 13).

**Stack:** Next.js 15 · React 19 · TypeScript · Prisma 6 · PostgreSQL (Supabase) · Tailwind · Supabase
Storage · SheetJS.

**Scale (unchanged this session — no schema/permission change since v0.43.1):** **75 Prisma models** ·
**8 legacy Postgres enums** (no new enums — CHECK text) · **51 permissions** · role-permission links 196 ·
migrations sequential to **`0032`** · 15 users. No `auth:bootstrap` this session.

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
  `status` (DRAFT/PUBLISHED/ARCHIVED). The full **65-module curriculum** is seeded; **FND-103, FND-104 and FND-107
  are PUBLISHED with authored content**; the remaining 62 are DRAFT shells.
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
it → amber **"Below 0.80"**; **COO-awareness 1.15** (`CR_COO_AWARE`) → red "Above 1.15". 22 competencies /
7 categories (F/P/E); six behaviors; four families + control-fn flag; banded weighted-average multiplier +
integrity gate. **Person grade = `employees.grade ?? jobProfile.grade`** via `personGrade` — every
compensation view now uses it (fixed in v0.43.4).

## Module status
- **Live & deep:** Employees, Job & Competency, Compensation, Payroll Control, Bonus, Leave, Recruitment,
  Onboarding/Offboarding, Performance (+ self-assessment, mid-cycle, calibration, PIP), Disciplinary,
  Grievances, Whistleblower, **Learning + Training Matrix + Training Compliance (WS7 full LMS)**,
  My Profile/Documents/Bonus/Payslips, Staff Files, Alerts, Audit Log, Dashboard.
- **Content authoring (the live stream):** **FND-103 + FND-104 + FND-107 authored** (lesson + 20-question check each,
  80% pass). 62 module shells remain DRAFT and await content. Tier A (compliance) modules are CCO-owned;
  CCO review is the publish gate.
- **Spine-level / depth pending:** Evidence Vault, Internal Controls / RemCo, generated Employment
  Agreement.

## Roster snapshot
~18 employee records, **15 active staff / users**. `salary_bands` G0–G5 loaded (fully-loaded monthly
equivalents: 120k/195k/250k/340k/470k/640k midpoints); active tax ruleset Nigeria PIT 2026. Learning
records populate when auto-assign is committed.

## What's next (recommended order — see HANDOVER)
1. **LMS content authoring** — **FND-107 (Conflicts of Interest) DONE (v0.43.7, PUBLISHED).** Next: the
   rest of the FND mandatory set (e.g. FND-106 Confidentiality & Information Security; FND-108
   Whistleblowing & Speaking Up), same content-seed pattern; Tier A → CCO review before publish.
2. **MANR role-specific mandatory layer (deferred)** — three items have no 1:1 module (Best Execution,
   Client Funds Handling, Payroll & Statutory Remittance Controls): author-new vs map-to-nearest.
3. **Phase 4 governance** — Evidence Vault; Internal Controls + RemCo; generated Employment Agreement.
4. **Doc fix:** Ops Manual + Handbook performance-calendar → calendar-year.
5. **Reserved roles at hire** — set department/rung/track, flip DRAFT→PUBLISHED; training auto-switches on.
6. **Hygiene:** align `lib/sponsorship-reads.ts` role-only grade to `personGrade` (same latent pattern as
   the v0.43.4 fix); positioning-note copy to mention the green "At 0.80"; Dependabot/security rotations;
   retire vestigial `EmployeeDocument`.

## Next action
Doc set is at **v0.43.7** and reflects HEAD. FND-107 is authored, seeded, and PUBLISHED. The next
content-authoring build (next FND mandatory module) is queued for the next conversation.
