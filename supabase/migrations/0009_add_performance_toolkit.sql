-- 0009_add_performance_toolkit.sql  (v0.18.0 — Performance toolkit)
--
-- Activates the four mock-only Performance toolkit actions on top of the
-- existing v0.10.0 cycle tracker + scorecards/appraisal layer:
--   (1) goal-setting        -> performance_goals
--   (2) weekly reporting     -> weekly_reports
--   (3) development plan     -> development_plans
--   (4) PIP workflow         -> improvement_plans + improvement_plan_items
--
-- Adds FIVE new tables and edits NO existing table.
--
-- House conventions honored:
--   * App-generated cuid TEXT primary keys; created_at/updated_at timestamptz.
--   * Status vocabularies are CHECK-constrained TEXT (not Postgres enums).
--   * Cross-entity references to EXISTING tables (employees, appraisal_cycles,
--     appraisals, users) are BARE columns with the FK enforced in SQL only, so
--     no existing Prisma model is edited (the Leave / v0.16.0 / v0.17.0 rule).
--     The only real Prisma relation is improvement_plans <-> improvement_plan_items
--     (both new models in this release).
--   * Idempotent: BEGIN/COMMIT, CREATE TABLE IF NOT EXISTS, pg_constraint-guarded
--     constraints, IF NOT EXISTS indexes. Writes no data.

begin;

-- ---------------------------------------------------------------------------
-- performance_goals — per-employee, per-cycle goals set at goal-setting.
-- Distinct from role-seeded appraisal OUTCOME items (those stay the year-end
-- KRA scoring surface); these are the individual goals agreed for the cycle.
-- ---------------------------------------------------------------------------
create table if not exists public.performance_goals (
  id           text primary key,
  cycle_id     text not null,
  employee_id  text not null,
  title        text not null,
  description  text,
  measure      text,
  target       text,
  weight       integer,
  due_date     timestamptz,
  status       text not null default 'ACTIVE',
  sort_order   integer not null default 0,
  created_by_id text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'performance_goals_status_check') then
    alter table public.performance_goals
      add constraint performance_goals_status_check
      check (status in ('DRAFT','ACTIVE','ACHIEVED','PARTIAL','MISSED','DROPPED'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'performance_goals_cycle_fk') then
    alter table public.performance_goals
      add constraint performance_goals_cycle_fk
      foreign key (cycle_id) references public.appraisal_cycles(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'performance_goals_employee_fk') then
    alter table public.performance_goals
      add constraint performance_goals_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'performance_goals_created_by_fk') then
    alter table public.performance_goals
      add constraint performance_goals_created_by_fk
      foreign key (created_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create index if not exists performance_goals_cycle_idx on public.performance_goals(cycle_id);
create index if not exists performance_goals_employee_idx on public.performance_goals(employee_id);

-- ---------------------------------------------------------------------------
-- weekly_reports — one short check-in per employee per ISO week. cycle_id is
-- nullable so weekly reporting works even between cycles.
-- ---------------------------------------------------------------------------
create table if not exists public.weekly_reports (
  id              text primary key,
  employee_id     text not null,
  cycle_id        text,
  week_start      timestamptz not null,
  accomplishments text not null default '',
  priorities      text,
  blockers        text,
  status          text not null default 'DRAFT',
  submitted_at    timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'weekly_reports_status_check') then
    alter table public.weekly_reports
      add constraint weekly_reports_status_check
      check (status in ('DRAFT','SUBMITTED'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'weekly_reports_employee_fk') then
    alter table public.weekly_reports
      add constraint weekly_reports_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'weekly_reports_cycle_fk') then
    alter table public.weekly_reports
      add constraint weekly_reports_cycle_fk
      foreign key (cycle_id) references public.appraisal_cycles(id) on delete set null;
  end if;
end $$;

-- one report per employee per week
create unique index if not exists weekly_reports_emp_week_ued
  on public.weekly_reports(employee_id, week_start);
create index if not exists weekly_reports_employee_idx on public.weekly_reports(employee_id);

-- ---------------------------------------------------------------------------
-- development_plans — trackable individual development plan rows. Sits
-- alongside the appraisal's existing free-text development_plan note (which is
-- NOT edited); appraisal_id is a bare optional cross-link.
-- ---------------------------------------------------------------------------
create table if not exists public.development_plans (
  id            text primary key,
  employee_id   text not null,
  cycle_id      text,
  appraisal_id  text,
  objective     text not null,
  action        text,
  support       text,
  target_date   timestamptz,
  status        text not null default 'OPEN',
  sort_order    integer not null default 0,
  created_by_id text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'development_plans_status_check') then
    alter table public.development_plans
      add constraint development_plans_status_check
      check (status in ('OPEN','IN_PROGRESS','DONE'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'development_plans_employee_fk') then
    alter table public.development_plans
      add constraint development_plans_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'development_plans_cycle_fk') then
    alter table public.development_plans
      add constraint development_plans_cycle_fk
      foreign key (cycle_id) references public.appraisal_cycles(id) on delete set null;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'development_plans_appraisal_fk') then
    alter table public.development_plans
      add constraint development_plans_appraisal_fk
      foreign key (appraisal_id) references public.appraisals(id) on delete set null;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'development_plans_created_by_fk') then
    alter table public.development_plans
      add constraint development_plans_created_by_fk
      foreign key (created_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create index if not exists development_plans_employee_idx on public.development_plans(employee_id);
create index if not exists development_plans_appraisal_idx on public.development_plans(appraisal_id);

-- ---------------------------------------------------------------------------
-- improvement_plans — PIP header. Staff acknowledgment reuses the document
-- e-signature idiom (name + timestamp + captured IP).
-- ---------------------------------------------------------------------------
create table if not exists public.improvement_plans (
  id            text primary key,
  employee_id   text not null,
  title         text not null,
  concerns      text not null default '',
  support       text,
  start_date    timestamptz,
  review_date   timestamptz,
  end_date      timestamptz,
  status        text not null default 'OPEN',
  outcome       text,
  ack_name      text,
  ack_at        timestamptz,
  ack_ip        text,
  created_by_id text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'improvement_plans_status_check') then
    alter table public.improvement_plans
      add constraint improvement_plans_status_check
      check (status in ('OPEN','IN_PROGRESS','MET','NOT_MET','EXTENDED','CLOSED'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'improvement_plans_employee_fk') then
    alter table public.improvement_plans
      add constraint improvement_plans_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'improvement_plans_created_by_fk') then
    alter table public.improvement_plans
      add constraint improvement_plans_created_by_fk
      foreign key (created_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create index if not exists improvement_plans_employee_idx on public.improvement_plans(employee_id);
create index if not exists improvement_plans_status_idx on public.improvement_plans(status);

-- ---------------------------------------------------------------------------
-- improvement_plan_items — discrete PIP expectations. Real relation -> header.
-- ---------------------------------------------------------------------------
create table if not exists public.improvement_plan_items (
  id          text primary key,
  plan_id     text not null,
  position    integer not null default 0,
  expectation text not null,
  measure     text,
  target_date timestamptz,
  result      text not null default 'PENDING',
  note        text,
  created_at  timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'improvement_plan_items_result_check') then
    alter table public.improvement_plan_items
      add constraint improvement_plan_items_result_check
      check (result in ('PENDING','MET','NOT_MET'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'improvement_plan_items_plan_fk') then
    alter table public.improvement_plan_items
      add constraint improvement_plan_items_plan_fk
      foreign key (plan_id) references public.improvement_plans(id) on delete cascade;
  end if;
end $$;

create index if not exists improvement_plan_items_plan_idx on public.improvement_plan_items(plan_id);

commit;
