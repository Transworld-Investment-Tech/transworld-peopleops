-- 0005_add_learning.sql — Learning & Development (v0.12.0)
-- Adds three new tables (learning_modules, learning_module_competencies,
-- learning_records) and extends the existing policies table for the employee
-- handbook (in-portal markdown body + metadata).
--
-- Cross-entity references are enforced as FKs here in SQL only; the Prisma models
-- keep them as bare columns (same convention as scorecards / performance /
-- compensation). Ids are app-generated cuid (no DB default). status / source are
-- CHECK-constrained text, not Postgres enums.
--
-- Idempotent: wrapped in a transaction, IF NOT EXISTS throughout. Safe to re-run.
-- Applied by hand in the Supabase SQL Editor. This migration writes no data.

begin;

-- 1) Handbook columns on the existing policies table -----------------------
alter table public.policies add column if not exists category       text not null default 'HANDBOOK';
alter table public.policies add column if not exists summary        text;
alter table public.policies add column if not exists body           text;
alter table public.policies add column if not exists effective_date timestamptz;
alter table public.policies add column if not exists updated_at      timestamptz not null default now();

-- 2) learning_modules ------------------------------------------------------
create table if not exists public.learning_modules (
  id                text primary key,
  title             text not null,
  category          text not null,
  summary           text,
  body              text,
  estimated_minutes integer,
  status            text not null default 'DRAFT',
  created_by_id     text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint learning_modules_status_check check (status in ('DRAFT', 'PUBLISHED')),
  constraint learning_modules_created_by_fkey foreign key (created_by_id)
    references public.users (id) on delete set null
);

-- 3) learning_module_competencies (tags onto the competency catalog) -------
create table if not exists public.learning_module_competencies (
  module_id     text not null,
  competency_id text not null,
  primary key (module_id, competency_id),
  constraint lmc_module_fkey foreign key (module_id)
    references public.learning_modules (id) on delete cascade,
  constraint lmc_competency_fkey foreign key (competency_id)
    references public.competencies (id) on delete cascade
);
create index if not exists learning_module_competencies_competency_idx
  on public.learning_module_competencies (competency_id);

-- 4) learning_records (one per employee per module) ------------------------
create table if not exists public.learning_records (
  id                text primary key,
  module_id         text not null,
  employee_id       text not null,
  source            text not null default 'SELF',
  status            text not null default 'ASSIGNED',
  assigned_at       timestamptz not null default now(),
  due_date          timestamptz,
  started_at        timestamptz,
  completed_at      timestamptz,
  reflection        text,
  score             integer,
  recommended_by_id text,
  appraisal_id      text,
  notes             text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint learning_records_source_check check (source in ('SELF', 'RECOMMENDED', 'MANDATORY')),
  constraint learning_records_status_check check (status in ('ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'WAIVED')),
  constraint learning_records_module_employee_key unique (module_id, employee_id),
  constraint learning_records_module_fkey foreign key (module_id)
    references public.learning_modules (id) on delete cascade,
  constraint learning_records_employee_fkey foreign key (employee_id)
    references public.employees (id) on delete cascade,
  constraint learning_records_recommended_by_fkey foreign key (recommended_by_id)
    references public.users (id) on delete set null,
  constraint learning_records_appraisal_fkey foreign key (appraisal_id)
    references public.appraisals (id) on delete set null
);
create index if not exists learning_records_employee_idx on public.learning_records (employee_id);
create index if not exists learning_records_module_idx   on public.learning_records (module_id);
create index if not exists learning_records_status_idx   on public.learning_records (status);

commit;
