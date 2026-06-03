-- 0019_add_thirteenth_month.sql (v0.28.0) — Payroll month-type control (Release D; Ops Manual
-- F2.0/F2.2). Adds the thirteenth-month additive line. The utility-suppression fix and the
-- additive quarterly (= one month's gross) are code-only and take effect on the next cycle
-- generation. Three nullable/defaulted columns, idempotent. No new enums, no permission change.

begin;

alter table public.pay_cycles add column if not exists is_thirteenth_month boolean not null default false;
alter table public.pay_cycles add column if not exists total_thirteenth numeric(16, 2);
alter table public.pay_items add column if not exists thirteenth_month numeric(14, 2) not null default 0;

commit;
