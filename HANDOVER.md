# HANDOVER — Transworld PeopleOps Portal
_Last updated: June 5, 2026 · **HEAD v0.43.7** · `main` · green in production (`<filled after push>`)_

Read this first when continuing, alongside `STATE_OF_APP.md`, `SCHEMA_DB.md`, `APP_INSTRUCTIONS.md`, and
`PORTAL_DOC_RECONCILIATION.md`. Confirm pay/competency facts against the canonical framework doc
(`Transworld_Competency_Scorecard_Reward_Framework_Canonical.md`); confirm WS-procedure + cycle facts
against the **consolidated HR Operations Manual + Employee Handbook + the Manager & Employee PD Guides**
(the canonical docs in Project files) — not memory. The **LMS curriculum is canonical** and the Portal
catalogue matches it. The **LMS Curriculum Source Map** (in Project files) is the authoring-source index
(primary/supporting governing doc + Tier + build mode per module) — not a role matrix.

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
- **Content:** FND-103 + FND-104 + FND-107 authored. 62 shells remain DRAFT; Tier A modules are CCO-owned.

## What is NEXT (recommended order)
1. **LMS content authoring** — **FND-107 (Conflicts of Interest) DONE (v0.43.7, PUBLISHED).** Next: the rest
   of the FND mandatory set (e.g. FND-106 Confidentiality & Information Security; FND-108 Whistleblowing &
   Speaking Up), same content-seed pattern; Tier A → CCO review before publish.
2. **MANR role-specific mandatory layer (deferred):** three items have no 1:1 module (Best Execution,
   Client Funds Handling, Payroll & Statutory Remittance Controls) — author-new vs map-to-nearest.
3. **Phase 4 governance:** Evidence Vault; Internal Controls + RemCo; generated Employment Agreement.
4. **Doc fix:** Ops Manual + Handbook performance-calendar → calendar-year.
5. **Reserved roles at hire:** set department/rung/track, flip DRAFT→PUBLISHED; training auto-switches on.
6. **Hygiene:** align `lib/sponsorship-reads.ts` grade to `personGrade`; positioning-note copy mentions the
   green "At 0.80"; Dependabot/security rotations; retire vestigial `EmployeeDocument`.

## Continuation prompt (paste into the next conversation)
> Continuing the Transworld PeopleOps Portal. HEAD is **v0.43.7** (`main`, green in production). Read the
> five governing docs first — STATE_OF_APP, SCHEMA_DB, HANDOVER, APP_INSTRUCTIONS,
> PORTAL_DOC_RECONCILIATION — plus the canonical framework doc and the **LMS Curriculum Source Map** (an
> authoring-source index: primary/supporting governing doc + Tier + build mode per module — NOT a role
> matrix). Confirm WS-procedure + cycle facts against the consolidated HR Operations Manual + Employee
> Handbook + the Manager & Employee PD Guides (canonical docs in Project files), not memory. NOTE: the
> performance cycle is the **calendar year (Jan–Dec), mid-cycle July** — PD Guides canonical; Ops Manual +
> Handbook still print the stale June–May calendar (open doc-fix). The **LMS curriculum is canonical** and
> the Portal catalogue matches it.
>
> Where we are: the **WS7 full LMS is live** with the role-and-grade matrix (v0.42–v0.43.1), and **three
> mandatory modules are now authored and PUBLISHED — FND-103 (Code of Conduct & Ethics), FND-104 (AML/CFT &
> KYC Awareness), and FND-107 (Conflicts of Interest)** — each a lesson (callouts/dividers) + a 20-question
> server-graded check at 80%, shipped as idempotent content seeds (`seed_fnd103_content.sql`,
> `seed_fnd104_content.sql`, `seed_fnd107_content.sql`). Lesson prose is justified and check options are
> left-aligned (v0.43.3, CSS marker `TW-LMS-CSS-V0433`). Compensation: individual page resolves grade via
> `personGrade(employees.grade ?? jobProfile.grade)` (v0.43.4); compa floor target **0.80**
> (`CR_PRIORITISE`); people at the floor show a green **"At 0.80"** chip (amber "Below 0.80" otherwise),
> decided on the displayed 2-dp CR via the `atTarget` flag (v0.43.5; v0.43.6 hotfix). **75 models, migrations
> to `0032`, 8 legacy enums (CHECK text), 51 permissions, no `auth:bootstrap` pending.**
>
> Keep the working conventions (build in chat; one versioned zip per release with a generate-only setup.sh +
> wrapper; for edits to existing files ship an idempotent, fail-loud patcher with exact-string anchors;
> read-first from raw.githubusercontent.com / codeload tarball; real globals.css classes, additive CSS =
> one marker-guarded palette-/typography-only block discussed first; no new Postgres enums — CHECK text;
> bare snapshot FK columns except new-to-new; in-place column injection; new tables = marker-guarded append;
> data seeds under seed/ run by hand; SQL inline in its own box + shipped; migration before the push;
> auth:bootstrap only on a permission change; help entry updated + help:test before push; staging checks =
> esbuild syntax + cross-file import/export resolution + pglast SQL parse + pure-engine tests + help:test,
> PLUS tsc-with-prisma-stub for any change touching a shared type or server-action signature; American
> English, ₦, navy/gold; deploy steps and SQL in separate boxes; npm run build before push; ship into
> ~/transworld-peopleops, never ~/transworld-portal; unzip to a temp folder and run from there).
>
> What I want to build next: **continue the FND mandatory set** — the next content seed to the
> FND-103/104/107 pattern (lesson with callouts + a 20-question check at 80%), built FROM POLICY off its
> primary governing doc per the LMS Curriculum Source Map; Tier A → CCO review before publish. Give me the
> lesson outline for sign-off first, then the full module + questions, then ship the content seed. Deferred:
> the MANR role-specific mandatory layer (three items have no 1:1 catalogue module). Small later passes:
> align `lib/sponsorship-reads.ts` grade to `personGrade`; add a half-sentence to the positioning note about
> the green "At 0.80".

## Working preferences (please keep)
American English; ₦; navy/gold. Concrete deliverables over abstract questions; don't get ahead of the
work. Explicit scope sign-off before code; table design first for schema-bearing builds. Terminal and SQL
in separate copy-paste boxes; wait for pasted output. Plain-English guides where helpful. The five
governing docs are refreshed at HEAD after each session, with a continuation prompt at session close.
