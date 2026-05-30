# Transworld Portal — Database Schema (SCHEMA_DB)
**Version:** v0.1.1 · **Source of truth:** `prisma/schema.prisma` · DB: PostgreSQL

## Conventions
- snake_case tables/columns. IDs are app-generated cuid TEXT PKs.
- Every sensitive table has `created_at` / `updated_at`; audit logs are append-only.

## Tables (26)
**Identity & access:** `users`, `roles`, `permissions`, `user_roles`, `role_permissions`
**Organization:** `entities`, `departments`, `pay_categories` (Advisory/Core/Investment/Part-Time)
**Job framework:** `job_profiles`, `competencies`, `job_profile_competencies`
**People:** `employees`, `employment_records`, `compensation_profiles` (standing payroll INPUTS that carry forward)
**Documents/policy:** `employee_documents`, `policies`, `policy_acknowledgments`
**Leave:** `leave_types`, `leave_balances`, `leave_requests`
**Payroll tax engine (configurable):** `tax_rule_sets`, `tax_bands`
**Payroll cycles:** `pay_cycles`, `pay_items` (per-employee snapshot: inputs + computed outputs + review status)
**System:** `audit_logs`, `notifications`

## Enums
EmploymentType, EmploymentStatus, TaxTreatment (PAYE/EXEMPT/FLAT_RATE), JdStatus,
PayCycleStatus (DRAFT→IN_REVIEW→APPROVED→GENERATED→LOCKED),
PayItemReviewStatus (CARRIED_FORWARD/CHANGED/NEW/CONFIRMED), DocAccessLevel, LeaveRequestStatus.

## Payroll model (key design)
- Inputs stored once per employee in `compensation_profiles` (basic, utility, quarterly, tax treatment, pension/NHF applicable).
- Each cycle = a `pay_cycles` row; `pay_items` are created by carrying forward the current comp profiles and computing outputs (gross, pension 8% of basic, NHF 2.5%, PAYE, net, employer pension 10% of gross) via `lib/payroll.ts` against the active `tax_rule_sets`.
- Tax bands/rates are DATA, not code. Seeded set: "Nigeria PIT 2026 (NTA 2025)" — **bands flagged for verification** with a tax advisor.

## Not yet in schema (future versioned updates)
Recruitment/ATS, onboarding, performance, learning, compensation grades/benefits,
evidence vault, internal controls, HR audit. To be added in later versions.
