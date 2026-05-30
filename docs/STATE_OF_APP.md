# Transworld Portal — State of the App (STATE_OF_APP)
**Version:** v0.1.1 · **Date:** this run

> v0.1.1 change: project directory renamed to `~/transworld-peopleops` (the existing `transworld-portal` app is untouched). No schema or logic changes from v0.1.0.

## Done in v0.1.1
- ✅ Database schema designed (26 tables) — `prisma/schema.prisma` + reference `db/init.sql`.
- ✅ Corrected payroll model: standing inputs + carry-forward + compute + generate control sheet
  (replaces the earlier "upload a file each cycle" idea).
- ✅ Configurable Nigerian tax engine (`tax_rule_sets`/`tax_bands`) seeded with 2026 (NTA 2025)
  bands — FLAGGED FOR VERIFICATION with a tax advisor.
- ✅ Payroll computation module `lib/payroll.ts` (PAYE / EXEMPT / FLAT_RATE).
- ✅ Seed data: roles, pay categories, entity (TISL), departments, 15 real employees with
  September-2025 standing inputs.
- ✅ Runnable Next.js + Prisma scaffold + Claude Code kickoff.
- ✅ Automated `setup.sh` (deploy + install + generate + migrate + seed).

## Not yet built (next runs)
- ⬜ Auth + RBAC, audit logging (Phase 1 — first Claude Code task)
- ⬜ Employee directory, org chart, job & competency framework UI
- ⬜ Documents & policies, leave
- ⬜ Payroll Control Center UI (cycle, carry-forward, review/confirm, generate sheet + Excel)
- ⬜ Dashboard
- ⬜ Later phases: recruitment, onboarding, performance, learning, comp & benefits,
  evidence vault, internal controls, HR audit (added in later versioned schema updates)

## Open items to confirm
1. Whether HumanManager stays the authoritative tax calculator (portal cross-checks) or the
   portal computes PAYE itself — affects how much tax logic to trust.
2. Verify the 2026 PAYE bands/relief rules against the Nigeria Tax Act 2025 / a tax advisor.
3. Exact columns/layout Ifunanya needs in the generated control sheet (to match her Excel).
4. Postgres choice (free hosted e.g. Neon/Supabase vs local).

## Next action
Run `setup.sh`, configure `DATABASE_URL`, migrate + seed, then open Claude Code with
`claude/CLAUDE_CODE_KICKOFF.md` and build Phase 1.
