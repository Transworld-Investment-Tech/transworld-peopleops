-- 0011_add_payroll_control.sql  (v0.19.0 — Payroll Control Center)
-- In-place column additions to EXISTING tables only (no new tables this release).
--   tax_rule_sets : firm-policy calculation flags + ITF rate
--   pay_items     : ITF column + per-row adjustments (special/leave allowance, unpaid leave)
-- Idempotent: safe to run more than once. Writes no data.
-- Tables affected are empty (pay_items) or tiny (tax_rule_sets, ~1 row).
begin;

-- ── tax_rule_sets: how the engine computes, made configurable (nothing hardcoded) ──
alter table public.tax_rule_sets
  add column if not exists paye_on_basic_only       boolean       not null default true,
  add column if not exists employer_pension_on_gross boolean      not null default true,
  add column if not exists itf_rate                 numeric(6,4)  not null default 0.0100;

comment on column public.tax_rule_sets.paye_on_basic_only is
  'When true, PAYE taxable base is basic salary only (allowances excluded). Firm policy / NG law.';
comment on column public.tax_rule_sets.employer_pension_on_gross is
  'When true, employer pension is computed on gross (basic+utility); employee side stays on basic.';
comment on column public.tax_rule_sets.itf_rate is
  'Industrial Training Fund rate applied to basic salary (e.g. 0.0100 = 1%).';

-- ── pay_items: ITF + free-form per-row adjustments captured at review-and-confirm ──
alter table public.pay_items
  add column if not exists itf         numeric(14,2) not null default 0,
  add column if not exists adjustments jsonb;

comment on column public.pay_items.itf is
  'ITF deduction for this row (1% of basic by default; zeroed when the operator opts the person out).';
comment on column public.pay_items.adjustments is
  'Optional JSON array of operator adjustments: [{ "label": string, "amount": number, "kind": "ALLOWANCE"|"DEDUCTION" }]. Used for the quarterly lump, special/leave allowances, and unpaid-leave deductions.';

commit;
