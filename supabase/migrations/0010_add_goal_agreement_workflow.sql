-- 0010_add_goal_agreement_workflow.sql  (v0.18.1 — Goal agreement & sign-off)
--
-- Adds the employee-driven goal-setting workflow with line-manager sign-off,
-- a permanently sealed agreement record, and an append-only mid-cycle
-- amendment layer.
--
-- Adds TWO new tables and edits NO existing table (performance_goals is
-- unchanged — a goal is bound to its sheet by the natural key cycle_id +
-- employee_id, so no FK column is added to it):
--   * goal_sheets       — one per employee per cycle. Holds the review
--     lifecycle (DRAFT -> SUBMITTED -> CHANGES_REQUESTED -> APPROVED), the
--     line manager's canonical agreement note, and the DUAL SEAL (manager
--     approval + employee acknowledgment). Once sealed, the agreed positions
--     are immutable (enforced in the action layer; only a direct DB change by
--     an administrator could alter them, and that would itself be auditable).
--   * goal_amendments   — append-only mid-cycle layer. Each row is a NEW entry
--     (amend / expand / contract / new goal / follow-up note) that references
--     the sheet and optionally a sealed goal. The original sealed positions are
--     never overwritten; the record accretes.
--
-- House conventions honored:
--   * App-generated cuid TEXT primary keys; created_at/updated_at timestamptz.
--   * Status vocabularies are CHECK-constrained TEXT (not Postgres enums).
--   * Cross-entity references to EXISTING tables (employees, appraisal_cycles,
--     users, performance_goals) are BARE columns with the FK enforced in SQL
--     only, so no existing Prisma model is edited. The only real Prisma
--     relation is goal_sheets <-> goal_amendments (both new in this release).
--   * Idempotent: BEGIN/COMMIT, CREATE TABLE IF NOT EXISTS, pg_constraint-guarded
--     constraints, IF NOT EXISTS indexes. Writes no data.

begin;

-- ---------------------------------------------------------------------------
-- goal_sheets — the per-employee, per-cycle goal-setting agreement header.
-- ---------------------------------------------------------------------------
create table if not exists public.goal_sheets (
  id              text primary key,
  cycle_id        text not null,
  employee_id     text not null,
  manager_id      text,                        -- line manager at submit time (snapshot)
  review_state    text not null default 'DRAFT',
  submitted_at    timestamptz,
  changes_note    text,                        -- manager's "please adjust" note (last round)
  agreement_note  text,                        -- manager's canonical record of what was agreed
  approved_by_id  text,                         -- the user (manager) who approved
  approved_at     timestamptz,
  manager_seal_ip text,
  ack_name        text,                         -- employee acknowledgment (dual seal)
  ack_at          timestamptz,
  ack_ip          text,
  sealed          boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_sheets_state_check') then
    alter table public.goal_sheets add constraint goal_sheets_state_check
      check (review_state in ('DRAFT','SUBMITTED','CHANGES_REQUESTED','APPROVED'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_sheets_cycle_fk') then
    alter table public.goal_sheets add constraint goal_sheets_cycle_fk
      foreign key (cycle_id) references public.appraisal_cycles(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_sheets_employee_fk') then
    alter table public.goal_sheets add constraint goal_sheets_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_sheets_manager_fk') then
    alter table public.goal_sheets add constraint goal_sheets_manager_fk
      foreign key (manager_id) references public.employees(id) on delete set null;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_sheets_approved_by_fk') then
    alter table public.goal_sheets add constraint goal_sheets_approved_by_fk
      foreign key (approved_by_id) references public.users(id) on delete set null;
  end if;
end $$;

-- one sheet per employee per cycle (the natural key that binds performance_goals)
create unique index if not exists goal_sheets_cycle_emp_ued
  on public.goal_sheets(cycle_id, employee_id);
create index if not exists goal_sheets_employee_idx on public.goal_sheets(employee_id);
create index if not exists goal_sheets_manager_idx on public.goal_sheets(manager_id);
create index if not exists goal_sheets_state_idx on public.goal_sheets(review_state);

-- ---------------------------------------------------------------------------
-- goal_amendments — append-only mid-cycle layer. Never overwrites a sealed
-- goal; every change is a new row pointing back at the sheet (and optionally a
-- specific sealed goal).
-- ---------------------------------------------------------------------------
create table if not exists public.goal_amendments (
  id            text primary key,
  sheet_id      text not null,
  goal_id       text,                          -- sealed performance_goals.id this concerns (optional)
  kind          text not null default 'NOTE',
  body          text not null,
  new_measure   text,                          -- forward-looking change (expand/contract), if any
  new_target    text,
  created_by_id text,
  created_at    timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_amendments_kind_check') then
    alter table public.goal_amendments add constraint goal_amendments_kind_check
      check (kind in ('AMEND','EXPAND','CONTRACT','NEW_GOAL','FOLLOWUP_NOTE','NOTE'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_amendments_sheet_fk') then
    alter table public.goal_amendments add constraint goal_amendments_sheet_fk
      foreign key (sheet_id) references public.goal_sheets(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'goal_amendments_created_by_fk') then
    alter table public.goal_amendments add constraint goal_amendments_created_by_fk
      foreign key (created_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create index if not exists goal_amendments_sheet_idx on public.goal_amendments(sheet_id);
create index if not exists goal_amendments_goal_idx on public.goal_amendments(goal_id);

commit;
