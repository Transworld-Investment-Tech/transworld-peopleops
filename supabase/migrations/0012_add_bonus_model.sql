-- 0012_add_bonus_model.sql (v0.20.0) — Bonus model (WS6 Part 3).
-- THREE NEW TABLES (no in-place edits, no new enums): bonus_rounds, bonus_awards,
-- bonus_tranches. Statuses are CHECK-constrained text (the v0.16.x pattern) — no
-- Postgres enums, so no enum casts are needed. Idempotent (IF NOT EXISTS).
-- Writes no data. Table count 50 -> 53. Apply in the Supabase SQL Editor.
begin;

create table if not exists bonus_rounds (
  id                text primary key,
  award_year        integer not null unique,
  label             text not null,
  status            text not null default 'DRAFT',
  pbt               numeric(16,2) not null default 0,
  pool_rate         numeric(6,4) not null default 0.15,
  pool_amount       numeric(16,2) not null default 0,
  salary_basis      text not null default 'GROSS',
  scaling_factor    numeric(8,6) not null default 1,
  total_calculated  numeric(16,2),
  total_awarded     numeric(16,2),
  payment_month     integer not null default 4,
  payment_year      integer not null,
  appraisal_cycle_id text,
  confirmed_note    text,
  approved_by_id    text,
  approved_at       timestamp(3),
  locked_at         timestamp(3),
  created_at        timestamp(3) not null default now(),
  updated_at        timestamp(3) not null default now(),
  constraint bonus_rounds_status_check check (status in ('DRAFT','IN_REVIEW','APPROVED','LOCKED')),
  constraint bonus_rounds_salary_basis_check check (salary_basis in ('BASIC','GROSS'))
);

create table if not exists bonus_awards (
  id               text primary key,
  bonus_round_id   text not null references bonus_rounds(id) on delete cascade,
  employee_id      text not null,
  ee_id            text not null,
  employee_name    text not null,
  grade            text not null,
  target_months    numeric(6,4) not null,
  monthly_salary   numeric(14,2) not null,
  target_bonus     numeric(14,2) not null,
  multiplier       numeric(5,3) not null default 1.0,
  integrity_gate   boolean not null default false,
  appraisal_rating text,
  calculated_bonus numeric(14,2) not null default 0,
  awarded_bonus    numeric(14,2) not null default 0,
  deferred         boolean not null default false,
  immediate_amount numeric(14,2) not null default 0,
  deferred_amount  numeric(14,2) not null default 0,
  review_status    text not null default 'PENDING',
  note             text,
  confirmed_by_id  text,
  confirmed_at     timestamp(3),
  created_at       timestamp(3) not null default now(),
  updated_at       timestamp(3) not null default now(),
  constraint bonus_awards_review_status_check check (review_status in ('PENDING','CONFIRMED')),
  constraint bonus_awards_round_employee_unique unique (bonus_round_id, employee_id)
);
create index if not exists bonus_awards_round_idx on bonus_awards(bonus_round_id);
create index if not exists bonus_awards_employee_idx on bonus_awards(employee_id);

create table if not exists bonus_tranches (
  id               text primary key,
  bonus_award_id   text not null references bonus_awards(id) on delete cascade,
  bonus_round_id   text not null,
  employee_id      text not null,
  sequence         integer not null,
  label            text not null,
  amount           numeric(14,2) not null,
  scheduled_month  integer not null default 4,
  scheduled_year   integer not null,
  status           text not null default 'SCHEDULED',
  paid_at          timestamp(3),
  note             text,
  created_at       timestamp(3) not null default now(),
  updated_at       timestamp(3) not null default now(),
  constraint bonus_tranches_status_check check (status in ('SCHEDULED','PAID','CLAWED_BACK','FORFEITED'))
);
create index if not exists bonus_tranches_award_idx on bonus_tranches(bonus_award_id);
create index if not exists bonus_tranches_round_idx on bonus_tranches(bonus_round_id);
create index if not exists bonus_tranches_employee_idx on bonus_tranches(employee_id);

commit;
