# Claude Code Kickoff — Transworld PeopleOps & Payroll Control Portal

Paste this into Claude Code, opened in the `~/transworld-peopleops` folder.

---

You are building the **Transworld PeopleOps & Payroll Control Portal**, an internal HR +
payroll-control + compliance-evidence web app for Transworld Investment & Securities Limited
(a Nigerian, SEC-regulated investment firm, ~15 staff).

## Ground rules
- **Do not build a payroll payment engine.** HumanManager + Remita stay authoritative for
  paying staff. This portal reproduces the monthly *control sheet* (a cross-check the HR
  operator eyeballs) and houses HR operations.
- **The payroll model is review-and-confirm, NOT file upload.** Standing inputs live in
  `compensation_profiles`. Each cycle carries them forward into `pay_items`, recomputes the
  breakdown via the configurable tax engine, the operator reviews ~15 rows and confirms,
  then the app generates the control sheet (and an Excel export) for keying into HumanManager.
- **Tax is configurable, never hardcoded** — read it from `tax_rule_sets` / `tax_bands`.
  The seeded 2026 bands are a starting point flagged for verification.
- **Server-enforced RBAC** on every protected route; **audit-log** every sensitive action.
- Before changing any file, read it first. Keep changes small and committed per module.

## Stack (already scaffolded in this folder)
Next.js 15 (App Router) · React 19 · TypeScript · Prisma 6 + PostgreSQL · Tailwind.
The database schema, seed, Prisma client (`lib/db.ts`), and payroll engine (`lib/payroll.ts`)
already exist. Run `npx prisma studio` to inspect the seeded data.

## Visual spec
Match the approved mock-up (institutional "control room": deep navy, clean tables, the
13-module sidebar). Ask me for `Transworld_Portal_Mockup.html` if not present.

## Build order (Phase 1 first — stop and show me after each)
1. **Auth + RBAC**: email/password login, sessions, role checks (roles seeded), audit log
   writes on login and sensitive actions. A simple admin user bootstrap.
2. **Employee directory + profile**: list/detail from `employees` (+ entity, department,
   pay category, job profile, manager), document-completeness indicator.
3. **Org chart** from `manager_id`.
4. **Job & Competency Framework**: CRUD over `job_profiles` / `competencies`.
5. **Documents & Policies**: upload (protected storage), versioning, policy acknowledgments.
6. **Dashboard**: headcount, total payable, pending approvals, compliance posture.

## Then Phase 2 — Payroll Control Center (the centerpiece)
- Create a `PayCycle` for a month; **carry forward** the latest `compensation_profiles`
  into `pay_items`; mark each `review_status` (CARRIED_FORWARD / CHANGED / NEW).
- Compute outputs with `computePay()` from `lib/payroll.ts` against the active `tax_rule_set`.
- Per-employee review UI: show stored inputs + computed breakdown; flag what changed vs the
  prior cycle (`previous_values`); operator confirms each.
- Exec approval → **generate the control sheet** (HTML preview + **Excel export** matching the
  current layout: Basic, Utility, Gross, Pension, NHF, PAYE, Net, Quarterly, Employer Pension,
  plus totals Monthly Gross / Employer Pension / Quarterly Allowance / Total Payable) → lock.
- Save each cycle as an evidence record.

## Acceptance for this run
- I can log in, see the 15 seeded employees, open a payroll cycle, see inputs carried forward
  and the breakdown computed, confirm a change, and generate the control sheet.
- All payroll/salary access is written to `audit_logs`.

Ask only blocking questions; otherwise make reasonable assumptions, note them, and proceed.
