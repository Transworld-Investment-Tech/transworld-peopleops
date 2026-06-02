-- 0014_add_raise_mechanism.sql (v0.22.0) — Raise mechanism (WS6 Part 2).
-- TWO NEW TABLES: raise_cycles, raise_items. Idempotent (create table if not exists),
-- begin/commit, writes no data. No new Postgres enums — status and band_flag are
-- CHECK-constrained text. Cross-entity ids are bare columns with DB-level FKs only
-- (no Prisma @relation), except the parent/child raise_cycles <-> raise_items.
--   raise_items.raise_cycle_id     -> raise_cycles(id)         ON DELETE CASCADE
--   raise_items.employee_id        -> employees(id)            ON DELETE RESTRICT (protect evidence)
--   raise_items.applied_profile_id -> compensation_profiles(id) ON DELETE SET NULL
-- Run in the Supabase SQL Editor, then mirror the models into schema.prisma (setup.sh
-- appends them, marker-guarded). Table count 54 -> 56.

begin;

create table if not exists public.raise_cycles (
  id                     text primary key,
  label                  text not null,
  status                 text not null default 'DRAFT'
                           check (status in ('DRAFT', 'IN_REVIEW', 'APPROVED', 'LOCKED')),
  milestone_label        text not null,
  revenue_target         numeric(16, 2) not null,
  raise_percent          numeric(6, 4) not null,
  revenue_observed       numeric(16, 2),
  revenue_confirmed      numeric(16, 2),
  effective_date         timestamp(3) not null,
  confirmed_note         text,
  confirmed_by_id        text,
  prepared_by_id         text,
  submitted_by_id        text,
  submitted_at           timestamp(3),
  reviewed_by_id         text,
  reviewed_at            timestamp(3),
  approved_by_id         text,
  approved_at            timestamp(3),
  applied_at             timestamp(3),
  locked_at              timestamp(3),
  total_employees        integer,
  total_annual_increase  numeric(16, 2),
  total_new_annual       numeric(16, 2),
  created_at             timestamp(3) not null default now(),
  updated_at             timestamp(3) not null default now()
);

create table if not exists public.raise_items (
  id                  text primary key,
  raise_cycle_id      text not null references public.raise_cycles(id) on delete cascade,
  employee_id         text not null references public.employees(id) on delete restrict,
  ee_id               text not null,
  employee_name       text not null,
  grade               text,
  old_basic           numeric(14, 2) not null,
  old_utility         numeric(14, 2) not null,
  old_quarterly       numeric(14, 2) not null,
  old_annual_total    numeric(16, 2) not null,
  new_basic           numeric(14, 2) not null,
  new_utility         numeric(14, 2) not null,
  new_quarterly       numeric(14, 2) not null,
  new_annual_total    numeric(16, 2) not null,
  annual_increase     numeric(16, 2) not null,
  band_min            numeric(14, 2),
  band_mid            numeric(14, 2),
  band_max            numeric(14, 2),
  band_flag           text not null default 'WITHIN'
                        check (band_flag in ('WITHIN', 'ABOVE_MID', 'ABOVE_MAX', 'BELOW_MIN')),
  included            boolean not null default true,
  exclude_reason      text,
  cap_applied         boolean not null default false,
  applied_profile_id  text references public.compensation_profiles(id) on delete set null,
  note                text,
  created_at          timestamp(3) not null default now(),
  updated_at          timestamp(3) not null default now(),
  unique (raise_cycle_id, employee_id)
);

create index if not exists raise_cycles_status_idx on public.raise_cycles (status);
create index if not exists raise_items_cycle_idx on public.raise_items (raise_cycle_id);
create index if not exists raise_items_employee_idx on public.raise_items (employee_id);

commit;
