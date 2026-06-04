-- 0024_employee_enhancement.sql  (v0.36.0)
-- Employee enhancement pass:
--   (A) rich personal / contact / next-of-kin / identification / demographic
--       columns on public.employees,
--   (B) promotions/history columns on public.employment_records, and
--   (C) the new public.employee_dependents child table (bare employee_id FK).
-- Additive + idempotent. House convention: new status vocabularies are CHECK-
-- constrained TEXT (no new Postgres enums). NULL is always permitted by every
-- CHECK below. Apply this in the Supabase SQL Editor BEFORE pushing the code.

begin;

-- ── (A) employees: personal / contact / NOK / identification / demographics ──
alter table public.employees add column if not exists date_of_birth       timestamp(3);
alter table public.employees add column if not exists gender              text;
alter table public.employees add column if not exists marital_status      text;
alter table public.employees add column if not exists nationality         text;
alter table public.employees add column if not exists state_of_origin     text;
alter table public.employees add column if not exists personal_email      text;
alter table public.employees add column if not exists personal_phone      text;
alter table public.employees add column if not exists residential_address text;
alter table public.employees add column if not exists city                text;
alter table public.employees add column if not exists state_region        text;
alter table public.employees add column if not exists country             text;
alter table public.employees add column if not exists work_location       text;
alter table public.employees add column if not exists nok_name            text;
alter table public.employees add column if not exists nok_relationship    text;
alter table public.employees add column if not exists nok_phone           text;
alter table public.employees add column if not exists nok_address         text;
alter table public.employees add column if not exists id_type             text;
alter table public.employees add column if not exists id_number_masked    text;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'employees_gender_check') then
    alter table public.employees add constraint employees_gender_check
      check (gender is null or gender in ('MALE','FEMALE','OTHER','UNDISCLOSED'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'employees_marital_status_check') then
    alter table public.employees add constraint employees_marital_status_check
      check (marital_status is null or marital_status in ('SINGLE','MARRIED','DIVORCED','WIDOWED','OTHER'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'employees_work_location_check') then
    alter table public.employees add constraint employees_work_location_check
      check (work_location is null or work_location in ('HEAD_OFFICE','REMOTE','HYBRID','CLIENT_SITE'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'employees_id_type_check') then
    alter table public.employees add constraint employees_id_type_check
      check (id_type is null or id_type in ('NIN','PASSPORT','DRIVERS_LICENSE','VOTERS_CARD'));
  end if;
end $$;

-- ── (B) employment_records: promotions / history ────────────────────────────
alter table public.employment_records add column if not exists event_type     text;
alter table public.employment_records add column if not exists grade          text;
alter table public.employment_records add column if not exists job_profile_id text;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'employment_records_event_type_check') then
    alter table public.employment_records add constraint employment_records_event_type_check
      check (event_type is null or event_type in
        ('HIRE','CONFIRMATION','PROMOTION','REGRADE','TRANSFER','STATUS_CHANGE','COMP_CHANGE','EXIT','NOTE'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'employment_records_grade_check') then
    alter table public.employment_records add constraint employment_records_grade_check
      check (grade is null or grade in ('G0','G1','G2','G3','G4','G5','PT'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'employment_records_job_profile_fk') then
    alter table public.employment_records add constraint employment_records_job_profile_fk
      foreign key (job_profile_id) references public.job_profiles(id) on delete set null;
  end if;
end $$;

-- ── (C) employee_dependents (new child table; bare employee_id FK) ───────────
create table if not exists public.employee_dependents (
  id            text primary key,
  employee_id   text not null references public.employees(id) on delete cascade,
  full_name     text not null,
  relationship  text not null,
  date_of_birth timestamp(3),
  note          text,
  sort_order    integer not null default 0,
  created_at    timestamp(3) not null default now(),
  updated_at    timestamp(3) not null default now()
);
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'employee_dependents_relationship_check') then
    alter table public.employee_dependents add constraint employee_dependents_relationship_check
      check (relationship in ('SPOUSE','CHILD','PARENT','SIBLING','OTHER'));
  end if;
end $$;
create index if not exists employee_dependents_employee_id_idx
  on public.employee_dependents(employee_id);

commit;
