# HANDOVER — Transworld PeopleOps Portal
_Last updated: June 6, 2026 · **HEAD v0.46.1** · `main` · green in production (FND-108 seed `b33a42d`; v0.46.x seed batch STAGED; docs `<filled after push>`)_

> **v0.46.1:** FND-101/102/110 each gained a 10-question server-graded check at 80% (`pass_mark` NULL → 80; fixes the check-page "pass of 100%" display). Still Tier C/B, no CCO gate, publish on run. `package.json` → `0.46.1`.

Read this first when continuing, alongside `STATE_OF_APP.md`, `SCHEMA_DB.md`, `APP_INSTRUCTIONS.md`, and
`PORTAL_DOC_RECONCILIATION.md`. Confirm pay/competency facts against the canonical framework doc
(`Transworld_Competency_Scorecard_Reward_Framework_Canonical.md`); confirm WS-procedure + cycle facts
against the **consolidated HR Operations Manual + Employee Handbook + the Manager & Employee PD Guides**
(the canonical docs in Project files) — not memory. The **LMS curriculum is canonical** and the Portal
catalogue matches it. The **LMS Curriculum Source Map v2.0** (in Project files) is the authoring-source
index (primary/supporting governing doc + Tier + build mode per module) — not a role matrix.

## What this project is
An internal HR + payroll-control + compensation/bonus + compliance-evidence web portal for **TISL** — a
Nigerian, SEC-regulated investment firm, ~15 staff — run by a single HR person. Owner: Okezie Ofoegbu
(Chairman); admin **okezie.ofoegbu@transworldltd.com.ng** (SUPER_ADMIN, EID 13). Stack: Next.js 15 ·
React 19 · TypeScript · Prisma 6 · PostgreSQL (Supabase) · Tailwind · Supabase Storage · SheetJS.

## The single most important design rule
**The portal does NOT process or pay salaries or bonuses.** HumanManager + Remita remain authoritative.
The portal is a **control room / evidence layer**. Tax is configurable; figures are provisional.

## The seal pattern (immutable evidence)
Sealed goals, locked payroll/bonus/raise cycles are permanently read-only (Bonus Phase B excepted). WS5
case records transition via audited events. **LMS:** a passed graded check and a waiver are completion
evidence; each annual mandatory period is its own immutable `learning_records` row (`period` key).

## Working conventions (strictly enforced)
**Build discipline:** propose scope → wait for sign-off → build. Schema-bearing → **live-repo recon, then
table design first**, then scope, then build. Read-first from `raw.githubusercontent.com` (`curl -gs`);
full inventory via the codeload tarball. Match the house CSS (real `app/globals.css` classes); additive
CSS = one **marker-guarded, palette-/typography-only** block, discussed first. No new Postgres enums
(CHECK text). Cross-entity refs = bare snapshot FK columns except new-to-new parent/child. New columns =
in-place node injection; new tables = marker-guarded append. **`npm run build` before push**; apply
migration before push; `auth:bootstrap` only on a permission change. **Help entry updated for any
changed/added page; `help:test` before push.** SQL inline in chat + shipped. Deploy steps + SQL in
separate boxes; wait for pasted output between steps. American English; ₦; navy/gold.

**Staging checks before shipping (the sandbox can't run the real Prisma client):** per-file syntax
(esbuild) + cross-file export/import resolution + `pglast` SQL parse + the pure-engine tests + `help:test`.
**For any release that touches a shared type or a server-action signature, also run `tsc` (TS 5.7.x) with a
permissive `@prisma/client` stub and the `@/*` path alias, filtering the stub noise
(TS7006 implicit-any on Prisma callbacks, `{}`-from-stub, `process`/`@types/node`, missing enum members).**
The v0.43.5 build break (a missing required property on one return literal) was invisible to esbuild and
*would* have been caught by this `tsc` step — it is now mandatory for type-touching changes. The real gate
remains `npm run build` on the Mac.

**Delivery:** one versioned zip per release (bump every time) — wrapper + generate-only `setup.sh` +
payload (`payload/`, and/or `tools/` injectors, `supabase/migrations/`, `seed/` as needed). Okezie is on a
Mac; zips land in `~/Downloads` — **unzip to a temp folder and run from there**; repo
`~/transworld-peopleops`; never touch `~/transworld-portal`. `setup.sh` is generate-only (never
migrates/seeds/touches `.env`). For edits to existing files, ship an **idempotent, fail-loud patcher**
(exact-string anchors; skip if already applied; abort if an anchor is missing or matches >1) — see
`patch_v0434/0435/0436.mjs`.

## Hard-won lessons still in force
- **Shared-type changes need `tsc`, not just esbuild (v0.43.6):** adding a required field to a type means
  **every** object literal of that type must carry it — including early-return / guard-clause branches.
  esbuild strips types; only `tsc`/`next build` catches a missing required property.
- **Form-action signatures (v0.42.1):** `<form action={fn}>` needs `fn:(fd)=>Promise<void>`; pass a
  `useActionState` dispatcher, not the `(prev, fd)=>state` action, to a form.
- **Unique-key swap renames the Prisma compound key (v0.42.2):** grep + fix every call site.
- **Drop constraints by their ACTUAL name on populated tables** (check `pg_constraint`), not the
  Prisma-default name (v0.43.1 / `0032`).
- **Grade resolves in ONE place** — `personGrade(employees.grade ?? jobProfile.grade)`. Every reader must
  call it; a view that reads `jobProfile.grade` directly will diverge for anyone with a personal-grade
  override (v0.43.4 fix). `lib/sponsorship-reads.ts` still has the role-only pattern (parking lot).
- **No self-approval** — approver ≠ preparer, action-layer enforced. **Profile versioning** is the
  pay-change contract. **Reuse before re-writing.**
- **Project-file policy "PDFs" are readable — correcting an earlier wrong assumption (v0.45.1):** they are
  bundles that ship a clean per-page `.txt` beside each page image, and some sources (HR Ops Manual, the LMS
  Source Map) are plain UTF-8 text saved with a `.pdf`/`.docx` name. Always run a content-inventory
  (`file`, `unzip -l`, look for per-page `.txt`) before assuming a source is unreadable. The Whistleblower,
  Compliance Manual, ICF, Operational Manual, Code of Ethics, Handbook, and Retreat sources are all readable.

## Canonical models (do not re-litigate)
Pay (gross × 17; fully-loaded = gross × 17 ÷ 12 ÷ FTE), bonus, scorecard multiplier, person grade
(`personGrade`), WS5 mapping, performance cycle (calendar year; PD Guides canonical), the WS7 LMS shape
(catalogue + matrix + server-graded check + records/evidence + markdown renderer), and the **compa
thresholds: floor 0.80 (`CR_PRIORITISE`; green "At 0.80" / amber "Below 0.80" decided on the displayed
2-dp CR via `atTarget`), COO-awareness 1.15 (`CR_COO_AWARE`)**.

## What is DONE
Foundation/Auth/RBAC/audit; Employees (+rich profile, dependents, history); Job & Competency; Storage+JDs;
Scorecards; Performance & Development; Compensation; Payroll Control + payslips; Bonus; Raise; sponsorship;
fully-loaded bands; offer letters; competency/scorecard framework; Leave; Recruitment (+WS3 depth);
Onboarding/Offboarding (+WS4 depth); Disciplinary/Grievance/Whistleblower (WS5); the help layer.
- **v0.42 — WS7 full LMS:** catalogue metadata, assignment matrix, mandatory auto-assign, per-employee
  completion + evidence/waiver, server-graded check, Training Compliance dashboard; `lib/lms.ts` (17),
  migration `0031`, +2 perms (51), bootstrap (links 196).
- **v0.43 — LMS rendering + canonical catalogue:** badges, callouts/dividers, `.lesson` typography; seeded
  the full **65-module curriculum**; re-authored FND-103.
- **v0.43.1 — WS7 role matrix + check-crash fix:** migration `0032` (constraint drop), `submitCheckAction`
  guarded, **8 reserved DRAFT roles + 164 JOB_PROFILE rules**, "Training for this role" card, list filter.
- **v0.43.2 — FND-104 content:** `seed_fnd104_content.sql` — AML/CFT & KYC Awareness lesson + 20-question
  check (80%), PUBLISHED, 30 min; FROM POLICY (AML/CFT v3.0 + KYC v3.0); Tier A.
- **v0.43.3 — LMS rendering polish:** justified lesson prose + left-aligned check options; CSS marker
  `TW-LMS-CSS-V0433`; `QuizTaker` uses `.quiz-opts`/`.quiz-opt`.
- **v0.43.4 — Compensation correctness:** individual page resolves grade via `personGrade`; CR target
  0.85 → 0.80 (`CR_PRIORITISE = 0.8`) + help copy.
- **v0.43.5 — Compa-ratio chip:** green **"At 0.80"** via `atTarget` (display-consistent), both views.
- **v0.43.6 — hotfix:** `atTarget: false` added to the `getEmployeePositioning` early-return (fixed the
  `next build` type error at `lib/compensation.ts:862`).
- **v0.43.7 — FND-107 content (Conflicts of Interest):** `seed_fnd107_content.sql` — lesson + 20-question
  check (80%), PUBLISHED, 35 min; FROM POLICY (CO-POL-002 v3.0; supporting CO-POL-001, HR-POL-006);
  Tier A. No schema/permission change.
- **v0.44.0 — Job Family Restructure (code + schema):** families **four → five** (new Administration &
  Corporate Services, `ADMIN_CORPORATE_SERVICES`); migration **`0033`** widens the `job_profiles.family`
  CHECK (text + CHECK, no enum). Vocabulary consolidated into `lib/jobframework-vocab.ts`; scoring engine
  `Family` union + `FAMILY_WEIGHTS` gain ADM at **50/25/25** (= Control & Ops fallback → **no bonus math
  change**). Functional competencies **22 → 26** (categories Business Development + Administration; category
  is free text). ADM revenue-free (authoring rule; no revenue primitive in the engine).
- **v0.45.0 — Job Family Restructure (data):** new role profiles Procurement Officer (G2 ADM),
  Marketing & Communications Officer (G2 BD), Office Administrator (G1 ADM); family moves People-Ops Officer
  → ADM, COO/CFO → Leadership. Grades/pay untouched; RemCom ratified before commit.
- **v0.45.1 — FND-108 content (Whistleblowing & Speaking Up):** `seed_fnd108_content.sql` — lesson +
  20-question check (80%), 30 min; FROM POLICY (Whistleblower Policy v1.0; supporting Compliance Manual).
  **Seed committed (`b33a42d`) and STAGED — running it by hand is the CCO publish gate (sets PUBLISHED).**
  Data-only (no schema/permission change; `package.json` unchanged at 0.45.0). Logged two Whistleblower-
  Policy doc-fixes (reporting email → whistleblower@transworldltd.com.ng; add the portal Report-a-Concern channel).
- **v0.46.0 — FND-10X go-live batch (six content seeds; data-only):** the remaining Foundational tier authored
  as one release. Graded Tier-A (CCO publish gate): **FND-105 NDPR** (CM §12.1 + HR Ops H3; standalone-policy GAP),
  **FND-106 Confidentiality & Info-Sec** (CM §12.2 + §15.1 + HR Ops H4; dedicated phishing section, "when in doubt
  DO NOT CLICK"; standalone-policy GAP), **FND-109 SEC/NGX Conduct** (CM §3 + §10 awareness-level market conduct +
  §15; Op Manual §1; Code of Ethics) — each lesson + 20-Q check at 80%, 30/30/35 min. Lesson-only (pass_mark NULL):
  **FND-101 Welcome** (WS1 Part 3 + WS2 Layer 3 six behaviors), **FND-102 How the firm works** (WS2 Parts 1-3 + WS1
  Part 2 + HR Ops A/B), **FND-110 Documentation discipline** (ICF §1 + Op Manual §19 + WS2 Behavior 5). WS1/WS2 now
  in Project files (refreshed) — the "WS absent" flag retired. One generate-only setup.sh writes all six seeds;
  all STAGED. No schema/permission change. `package.json` → `0.46.0`.
- **Content:** FND-103/104/107 authored & PUBLISHED; **FND-108 + the v0.46.0 batch (105/106/109/101/102/110)
  authored, seeds staged (pending the CCO publish run)**. Any remaining FND shells DRAFT; Tier A modules CCO-owned.

## What is NEXT (recommended order)
1. **LMS content authoring — FND-10X go-live: AUTHORED & STAGED.** PUBLISHED: FND-103/104/107. **Authored with
   seeds STAGED: FND-108 + the v0.46.0 batch (FND-105/106/109 graded Tier-A; FND-101/102/110 lesson-only).**
   The only remaining gate is the single consolidated CCO review of the four Tier-A modules (108/105/106/109);
   after sign-off, run the seeds (graded publish then; lesson-only publish on run) and run auto-assign. **The "scanned-image, no text" blocker is CLEARED** — all
   FND-10X sources are readable (see the lesson above). Remaining: **graded Tier-A (CCO gate) — FND-105
   (NDPR), FND-106 (Info-Sec), FND-109 (SEC/NGX Conduct)**; **lighter — FND-101/102 (Tier C, lesson-only,
   ADAPT), FND-110 (Tier B, lesson-only, FROM POLICY)**. FND-105/106 carry a standalone-policy GAP (author
   from Compliance Manual §12.1/§12.2 + HR Ops Manual; CCO accepts the gap at publish). WS1/WS2 (FND-101/102)
   absent from Project files — author from Handbook + Retreat + HR Ops Manual + canonical framework doc.
   **Fastest path: batch all six into one release + one consolidated CCO review of the four Tier-A modules
   (108/105/106/109). The go-live constraint is the CCO gate, not authoring.** Per-module workflow unchanged
   (lesson + 20-question check → content seed); the batch just parallelizes the round-trips.
2. **MANR role-specific mandatory layer (deferred):** three items have no 1:1 module (Best Execution,
   Client Funds Handling, Payroll & Statutory Remittance Controls) — author-new vs map-to-nearest.
3. **Phase 4 governance:** Evidence Vault; Internal Controls + RemCo; generated Employment Agreement.
4. **Doc fixes:** (a) Ops Manual + Handbook performance-calendar → calendar-year; (b) Whistleblower Policy
   v1.0 — correct reporting email to **whistleblower@transworldltd.com.ng** and add the portal **Report a
   Concern** channel (reflected in FND-108; owed in the policy at next review).
5. **Reserved roles at hire:** set department/rung/track, flip DRAFT→PUBLISHED; training auto-switches on.
6. **Hygiene:** align `lib/sponsorship-reads.ts` grade to `personGrade`; positioning-note copy mentions the
   green "At 0.80"; Dependabot/security rotations; retire vestigial `EmployeeDocument`.

## Continuation prompt (paste into the next conversation)
> Continuing the Transworld PeopleOps Portal. HEAD is **v0.46.0** (`main`, green in production). Read the five
> governing docs first — STATE_OF_APP, SCHEMA_DB, HANDOVER (repo root), APP_INSTRUCTIONS (`docs/APP_INSTRUCTIONS.md`,
> static v0.1.1) — and PORTAL_DOC_RECONCILIATION if you have it locally (it is NOT in the public repo; ask me for it
> or skip). Confirm pay/competency facts against the canonical framework doc and WS-procedure/cycle facts against the
> consolidated HR Operations Manual + Employee Handbook + the PD Guides + the refreshed WS1–WS7 packs (all in Project
> files), not memory. The **LMS Curriculum Source Map v2.0** is the authoring-source index. Performance cycle is the
> **calendar year (Jan–Dec), mid-cycle July** — PD Guides canonical; Ops Manual + Handbook still print the stale
> June–May calendar (open doc-fix).
>
> Where we are: the **WS7 full LMS is live**. **The whole Foundational (FND-10X) mandatory + culture tier is now
> authored.** PUBLISHED: FND-103/104/107. **Authored with content seeds committed and STAGED (run by hand to
> publish):** FND-108 (Whistleblowing) and the **v0.46.0 batch** — graded Tier-A (CCO publish gate) **FND-105
> Data Protection/NDPR, FND-106 Confidentiality & Info-Sec (incl. a phishing section), FND-109 SEC/NGX Conduct
> Essentials** (each lesson + 20-Q server-graded check at 80%, 30/30/35 min); and lesson-only (pass_mark NULL)
> **FND-101 Welcome, FND-102 How the firm works, FND-110 Documentation discipline.** Seeds are idempotent (module
> UPDATE by code + questions upsert by id) and shipped via one generate-only setup.sh; **no schema/permission
> change — migrations stay `0033`, `package.json` is `0.46.0`.** The binding go-live constraint is the **single
> consolidated CCO review of the four Tier-A modules (108/105/106/109)** — a CCO pack was produced for one sitting.
> The FND-105/106 standalone-policy GAP and the breach-window doc-fix (CM §12.2 "2 hours" vs HR Ops "same day")
> are flagged in that pack. After CCO sign-off: run all the seeds, then run auto-assign to push the newly-published
> mandatory modules to staff.
>
> Job Family Restructure remains LIVE (v0.44.0 code+schema, v0.45.0 data): five families incl. Administration &
> Corporate Services; 26 competencies / 9 categories; grades G0–G5; compa floor **0.80** (`CR_PRIORITISE`),
> green "At 0.80" / amber "Below 0.80" via `atTarget`; grade via `personGrade`. **75 models, migrations to `0033`,
> 8 legacy enums (CHECK text), 51 permissions, no `auth:bootstrap` pending.**
>
> Keep all working conventions (build in chat; one versioned zip per release with a generate-only setup.sh + wrapper;
> idempotent fail-loud patchers for edits to existing files; read-first from raw.githubusercontent.com / codeload
> tarball; no new Postgres enums — CHECK text; data seeds under seed/ run by hand; SQL inline + shipped; npm run build
> before push; help:test + tsc-with-prisma-stub for type/server-action changes; American English, ₦, navy/gold; ship
> into ~/transworld-peopleops, never ~/transworld-portal; unzip to a TEMP folder and run from there).
>
> What to build next: your call. Candidates — (a) **MANR role-specific mandatory layer** (Best Execution, Client
> Funds Handling, Payroll & Statutory Remittance Controls — author-new vs map-to-nearest); (b) **next curriculum
> tier** (FND-201/202, CLA, REG, OPS from the Source Map); (c) **Phase 4 governance** (Evidence Vault; Internal
> Controls + RemCo; generated Employment Agreement). Small later passes: align `lib/sponsorship-reads.ts` grade to
> `personGrade`; positioning-note copy for the green "At 0.80"; doc-fixes (Ops Manual/Handbook calendar; WS2 compa
> 0.85→0.80; the breach-window window; the Whistleblower email + Report-a-Concern channel).


## Working preferences (please keep)
American English; ₦; navy/gold. Concrete deliverables over abstract questions; don't get ahead of the
work. Explicit scope sign-off before code; table design first for schema-bearing builds. Terminal and SQL
in separate copy-paste boxes; wait for pasted output. Plain-English guides where helpful. The five
governing docs are refreshed at HEAD after each session, with a continuation prompt at session close.
