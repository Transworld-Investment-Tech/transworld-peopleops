-- 0015_add_qualification_sponsorship.sql (v0.24.0) — Qualification sponsorship (WS6 Part 4).
-- THREE NEW TABLES: qualification_sponsorships (parent), sponsorship_costs, sponsorship_attempts.
-- Idempotent (create table if not exists), begin/commit, writes no data. No new Postgres enums —
-- status / bonding_start_basis / repayment_status / cost_type / outcome are CHECK-constrained text.
-- Cross-entity ids are bare columns with DB-level FKs only (no Prisma @relation):
--   qualification_sponsorships.employee_id           -> employees(id)         ON DELETE RESTRICT (protect evidence)
--   qualification_sponsorships.learning_module_id    -> learning_modules(id)  ON DELETE SET NULL  (optional WS7 link)
--   qualification_sponsorships.agreement_document_id -> staff_documents(id)   ON DELETE SET NULL  (signed agreement)
--   qualification_sponsorships.{proposed,approved,withdrawn}_by_id -> users(id) ON DELETE SET NULL
-- Parent/child (new-to-new) keep @relation: *_costs / *_attempts -> parent ON DELETE CASCADE.
-- Run in the Supabase SQL Editor, then mirror the models into schema.prisma (setup.sh appends
-- them, marker-guarded). Table count 56 -> 59.

begin;

create table if not exists public.qualification_sponsorships (
  id                    text primary key,
  employee_id           text not null references public.employees(id) on delete restrict,
  ee_id                 text not null,
  employee_name         text not null,
  qualification_name    text not null,
  awarding_body         text,
  learning_module_id    text references public.learning_modules(id) on delete set null,
  agreement_document_id text references public.staff_documents(id) on delete set null,
  status                text not null default 'PROPOSED'
                          check (status in ('PROPOSED', 'APPROVED', 'IN_PROGRESS', 'COMPLETED', 'WITHDRAWN')),
  bonding_months        integer,
  bonding_start_basis   text not null default 'ON_APPROVAL'
                          check (bonding_start_basis in ('ON_APPROVAL', 'ON_COMPLETION')),
  bonding_waived        boolean not null default false,
  repayment_status      text not null default 'NOT_APPLICABLE'
                          check (repayment_status in ('NOT_APPLICABLE', 'PENDING', 'WAIVED', 'REPAYING', 'SETTLED')),
  repayment_amount      numeric(16, 2),
  agreement_date        timestamp(3),
  proposed_by_id        text references public.users(id) on delete set null,
  approved_by_id        text references public.users(id) on delete set null,
  withdrawn_by_id       text references public.users(id) on delete set null,
  proposed_at           timestamp(3),
  approved_at           timestamp(3),
  started_at            timestamp(3),
  completed_at          timestamp(3),
  withdrawn_at          timestamp(3),
  note                  text,
  created_at            timestamp(3) not null default now(),
  updated_at            timestamp(3) not null default now()
);

create table if not exists public.sponsorship_costs (
  id              text primary key,
  sponsorship_id  text not null references public.qualification_sponsorships(id) on delete cascade,
  cost_type       text not null
                    check (cost_type in ('REGISTRATION', 'TUITION', 'EXAM_FEE', 'MATERIALS', 'MEMBERSHIP', 'OTHER')),
  description     text,
  amount          numeric(14, 2) not null,
  incurred_date   timestamp(3),
  paid            boolean not null default false,
  paid_date       timestamp(3),
  waived          boolean not null default false,
  note            text,
  created_at      timestamp(3) not null default now(),
  updated_at      timestamp(3) not null default now()
);

create table if not exists public.sponsorship_attempts (
  id              text primary key,
  sponsorship_id  text not null references public.qualification_sponsorships(id) on delete cascade,
  level_label     text not null,
  attempt_number  integer,
  sitting_date    timestamp(3),
  outcome         text not null default 'SCHEDULED'
                    check (outcome in ('SCHEDULED', 'PASSED', 'FAILED', 'DEFERRED', 'WITHDRAWN')),
  score           text,
  note            text,
  created_at      timestamp(3) not null default now(),
  updated_at      timestamp(3) not null default now()
);

create index if not exists qualification_sponsorships_employee_idx on public.qualification_sponsorships (employee_id);
create index if not exists qualification_sponsorships_status_idx   on public.qualification_sponsorships (status);
create index if not exists qualification_sponsorships_module_idx   on public.qualification_sponsorships (learning_module_id);
create index if not exists sponsorship_costs_sponsorship_idx on public.sponsorship_costs (sponsorship_id);
create index if not exists sponsorship_costs_type_idx        on public.sponsorship_costs (cost_type);
create index if not exists sponsorship_attempts_sponsorship_idx on public.sponsorship_attempts (sponsorship_id);
create index if not exists sponsorship_attempts_outcome_idx     on public.sponsorship_attempts (outcome);

commit;
