# Transworld Portal — App & Working Instructions (APP_INSTRUCTIONS)
**Version:** v0.1.1

## What the app is
Internal HR + payroll-control + compliance-evidence portal for Transworld (~15 staff),
designed to be operated by ONE hired/seconded HR person. HumanManager + Remita remain the
systems of record for paying staff; this portal reproduces the monthly control sheet and
houses HR operations.

## Stack & layout
Next.js 15 (App Router) · React 19 · TypeScript · Prisma 6 + PostgreSQL · Tailwind.
- `prisma/schema.prisma` — schema (source of truth)
- `prisma/seed.ts` — roles, pay categories, entity, departments, 2026 tax rules, 15 employees
- `db/init.sql` — reference DDL
- `lib/db.ts` — Prisma client singleton
- `lib/payroll.ts` — payroll computation engine (configurable tax)
- `app/` — Next.js app (Claude Code builds modules here)
- `claude/CLAUDE_CODE_KICKOFF.md` — the build prompt

## Working method with this project (IMPORTANT)
- Each update is shipped as a **versioned self-contained zip** with a `setup.sh` that does
  everything automatically. Versions increment (v0.1.1 → v0.2.0 …) so downloads don't clash.
- The zip is unzipped to a **temp folder**; `setup.sh` **deploys** to `~/transworld-peopleops`
  and runs from there (keeps ~/Downloads clean). It **backs up** any existing project first.
- Before changing files, **read them first** (diagnostic commands are given each turn).
- SQL is provided **inline** in chat. Terminal commands are given in **separate copy-paste boxes**.
- At the end of a completed, working run, the THREE project docs (SCHEMA_DB, APP_INSTRUCTIONS,
  STATE_OF_APP) are produced for upload to Project Files.

## Common commands
- Inspect data: `npx prisma studio`
- Re-migrate after schema change: `npx prisma migrate dev --name <change>`
- Re-seed: `npm run db:seed`
- Run app: `npm run dev`

## Guardrails
Server-side RBAC; audit-log sensitive actions; protected file downloads; mask bank details;
NDPA-aware data handling; tax rules configurable, never hardcoded; locked pay cycles immutable
except via controlled amendment.
