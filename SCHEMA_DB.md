# SCHEMA_DB — Transworld PeopleOps Portal
_Version: **v0.43.7** · PostgreSQL (Supabase) · Prisma 6_

Source of truth: `prisma/schema.prisma` (snake_case via `@@map`/`@map`). Schema applied to Supabase via
SQL; the app uses `prisma generate` only (NOT `prisma migrate`). **75 models** · **8 legacy Postgres
enums** (no new enums) · migrations sequential to **`0032`**.

> **No schema change in v0.43.2 → v0.43.7.** This session was content (a data seed), CSS, and TypeScript
> in `lib/`/pages only — no new table, column, enum, migration, or permission. Migrations remain at
> `0032`; permissions remain 51 (no `auth:bootstrap`).

## Conventions (how schema is shaped here)
- **No new Postgres enums.** New status vocabularies are `text` with a CHECK constraint.
- **Cross-entity references to existing tables are bare snapshot columns** — DB-level FK only, **no
  Prisma `@relation`**. Snapshot the evidentiary name; `RESTRICT` the subject employee, `SET NULL`
  optional refs.
- **Only new-to-new parent/child pairs use Prisma `@relation`** (cascade).
- **ids** are app-generated `cuid`; raw SQL inserts may use stable text ids (e.g. `lm_fnd104`,
  `q_fnd104_01`).
- **Money** `Decimal(14,2)`/`Decimal(16,2)`; **percent** `Decimal(6,4)`; **timestamps** `timestamp(3)`;
  structured blobs `jsonb`.
- New tables ship as **marker-guarded pure-append** Prisma blocks; new **columns** are injected in place
  (node, idempotent, anchored on a model-unique line) + an idempotent `ALTER TABLE ... ADD COLUMN IF NOT
  EXISTS` migration.
- **Populated-table changes self-guard.** Before swapping a unique/constraint on a populated table, grep
  for the Prisma compound-key name and fix every call site (v0.42.2). Drop constraints by their ACTUAL
  name (`pg_constraint`), not the Prisma-default name (v0.43.1).

## Migration files (`supabase/migrations/`)
- `20260530232609_remote_schema.sql` — baseline. `0001`–`0030` — documents/scorecards/performance/
  compensation/learning/leave/recruitment+onboarding/payroll/bonus/raise/sponsorship/competency/WS5/
  perf-cycle/WS3/notification/WS4/offboarding.
- **`0031_ws7_lms.sql` (v0.42.0)** — WS7 full LMS. `learning_modules` += `code`/`domain`/`level`/
  `is_mandatory`/`cadence`/`owner`/`pass_mark` (+ CHECKs; status widened with `ARCHIVED`); **NEW
  `learning_assignment_rules`**; **NEW `learning_quiz_questions`**; `learning_records` += `period` (+ rule
  provenance, evidence/attestation/waiver, graded result), unique swapped to
  `(module_id,employee_id,period)`.
- **`0032_drop_legacy_learning_records_unique.sql` (v0.43.1)** — drops the stray
  `learning_records_module_employee_key` unique the `0031` swap missed; the correct 3-col unique stays.

> **v0.43.0 onward add no migrations.** Data seeds (not schema, run by hand) under `supabase/seed/`:
> `seed_lms_curriculum.sql` (65 modules upsert by code + archive legacy), `seed_fnd103_content.sql`
> (FND-103 body + 20 questions), **`seed_fnd104_content.sql` (v0.43.2 — FND-104 body + 20 questions,
> PUBLISHED, 80% pass, 30 min; idempotent: module UPDATE by code + questions upsert by id)**,
> **`seed_fnd107_content.sql` (v0.43.7 — FND-107 Conflicts of Interest body + 20 questions, PUBLISHED, 80%
> pass, 35 min; idempotent: module UPDATE by code + questions upsert by id)**, and `seed_ws7_role_matrix.sql` (v0.43.1 — 8 DRAFT job_profiles + 164 JOB_PROFILE rules). Plus the original
> `seed_fnd_lms.sql` / `seed_payroll_history.sql`. **Seed run order:** content seeds run AFTER
> `seed_lms_curriculum.sql` (which creates the module shells); re-running the curriculum seed reverts a
> module to DRAFT, so re-run its content seed afterward.

## Key LMS tables (v0.42)
- **`learning_modules`** — catalogue. `code` (stable, partial-unique), `domain`/`level`/`owner`/`cadence`
  (CHECK text), `is_mandatory`, `pass_mark` (0–100), `status` (DRAFT/PUBLISHED/ARCHIVED),
  `estimated_minutes`, title/category/summary/`body` (markdown). `body` rendered by `markdownToHtml`
  (callouts `>`/`>!`, dividers `---`). **FND-103 + FND-104 + FND-107 are PUBLISHED with content; the rest DRAFT.**
- **`learning_assignment_rules`** — `module_id` (bare FK CASCADE), `scope`, `grade?`, `job_profile_id?`
  (bare FK SET NULL), `requirement`, `active`, `created_by_id?`.
- **`learning_quiz_questions`** — `module_id` (bare FK CASCADE), `prompt`, `type` (SINGLE/MULTI/
  TRUE_FALSE), `options` jsonb `[{key,text}]`, `correct` jsonb `[key]` (**server-side only**),
  `explanation?`, `sort_order`, `active`.
- **`learning_records`** — assignment + completion + evidence. Unique `(module_id,employee_id,period)`.
  `period` (recurrence key), `source` (SELF/RECOMMENDED/MANDATORY), `status`
  (ASSIGNED/IN_PROGRESS/COMPLETED/WAIVED), `score`, `passed`, `attempt_count`, `last_attempt_at`,
  evidence/attestation/waiver columns, `rule_id?`.

## Code that reads/writes (integration contracts)
- `lib/db.ts` → `prisma`. `lib/auth/rbac.ts` → `requireUser`/`requirePermission`/`hasPermission`.
  `lib/auth/audit.ts` → `writeAudit`. **`lib/jobframework.ts` → `personGrade(own, role) = own ?? role`** —
  the single grade resolver; every compensation view now uses it (v0.43.4).
- **Pure engines:** payroll/bonus/bonus-ledger/raise/sponsorship/scorecard-scoring/ws5/ws4/stafffile/
  expiry, **`lib/lms.ts`** (17). Import-free.
- **Compensation (`lib/compensation.ts`):** `getCompensationRegister`, `getCompensationPositioning`
  (PositionRow rows), `getEmployeeCompensation` (individual page — now selects `employees.grade` and
  resolves via `personGrade`, v0.43.4), `getEmployeePositioning` (EmployeePositioning). Constants:
  **`CR_PRIORITISE = 0.8`** (floor target), `CR_COO_AWARE = 1.15`. Flags per row: `cooAware`,
  `prioritise` (displayed-CR < target, excludes at-target), **`atTarget`** (displayed 2-dp CR == target →
  green "At 0.80"), `belowMin`. **All three return literals of `EmployeePositioning`** (the two early
  guard returns + the main return) must carry every required flag — the v0.43.6 hotfix added `atTarget`
  to the no-band early return.
- **LMS reads/actions:** `lib/lms-data.ts`, `lib/lms-actions.ts` (`submitCheckAction` server-graded,
  guarded), `lib/role-training.ts`. `lib/learning.ts` — `markdownToHtml` + `getLibrary`/`getModule`.
- **Quiz UI:** `components/learning/QuizTaker.tsx` renders options with `.quiz-opts` / `.quiz-opt`
  (left-aligned; v0.43.3) — it no longer borrows the `.kv .row` key/value pattern.
- `lib/permissions.ts` — **51 permissions**. `lib/help.ts` — `help:test` (15 checks); Compensation help
  copy reads "below 0.80" (v0.43.4).

## CSS markers (app/globals.css)
`TW-LMS-LESSON-V0430` (lesson typography + callouts) · **`TW-LMS-CSS-V0433`** (justified lesson prose:
`.lesson p` / `.lesson .callout`; left-aligned check options: `.quiz-opts` / `.quiz-opt`).

## Migration / injection notes for the next builder
- New tables = marker-guarded append; new columns = in-place node injection (anchor on a model-unique
  line, idempotency inside the block, injector reads `argv[2]`).
- Apply the migration to the DB **before** pushing. `auth:bootstrap` only on a permission change.
- **For edits to existing files**, ship an idempotent, fail-loud patcher (exact-string anchors).
- Sandbox can't reach Prisma engines: verify with esbuild syntax + `pglast` SQL parse + the pure-engine
  tests, **and `tsc` with a stubbed `@prisma/client` for any change touching a shared type / server-action
  signature** (catches missing required properties on return literals — the v0.43.6 class). Real gate:
  `npm run build` on the Mac.

## Connection
Transaction pooler (IPv4), `?pgbouncer=true` required for Prisma. Schema applied by hand in the Supabase
SQL Editor.
