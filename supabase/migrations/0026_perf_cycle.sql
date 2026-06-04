-- 0026_perf_cycle.sql  (v0.38.0)
-- Performance-cycle follow-on: mid-cycle review (the July check-in) + calibration
-- (the formal record). Three new tables. Cross-entity refs to existing tables
-- (appraisal_cycles, employees, users, appraisals) are bare FK columns; the only
-- intra-feature relation is calibration_entries -> calibration_sessions (cascade).
-- Status vocabularies are CHECK-constrained TEXT. calibrated/preliminary ratings
-- match the appraisal overall-rating vocabulary (EXCEEDS/MEETS/BELOW/NA) so the
-- agreed rating writes back to appraisals.overall_rating cleanly. Additive +
-- idempotent. Apply in the Supabase SQL Editor BEFORE pushing.

begin;

-- ── Mid-cycle review (July check-in; four free-text buckets, not rated) ──────
create table if not exists public.mid_cycle_reviews (
  id                  text primary key,
  cycle_id            text not null references public.appraisal_cycles(id) on delete cascade,
  employee_id         text not null references public.employees(id) on delete restrict,
  employee_name       text not null,
  self_summary        text,
  self_status         text not null default 'PENDING',
  self_submitted_at   timestamp(3),
  goals_note          text,
  behavior_note       text,
  skills_note         text,
  development_note    text,
  manager_summary     text,
  manager_status      text not null default 'PENDING',
  reviewer_id         text references public.users(id) on delete set null,
  reviewer_name       text,
  manager_reviewed_at timestamp(3),
  status              text not null default 'OPEN',
  created_at          timestamp(3) not null default now(),
  updated_at          timestamp(3) not null default now(),
  constraint mid_cycle_self_status_check check (self_status in ('PENDING','SUBMITTED')),
  constraint mid_cycle_manager_status_check check (manager_status in ('PENDING','SUBMITTED')),
  constraint mid_cycle_status_check check (status in ('OPEN','COMPLETED')),
  constraint mid_cycle_cycle_employee_uq unique (cycle_id, employee_id)
);
create index if not exists mid_cycle_reviews_cycle_id_idx on public.mid_cycle_reviews(cycle_id);

-- ── Calibration session (one per cycle; COO-chaired) ─────────────────────────
create table if not exists public.calibration_sessions (
  id                 text primary key,
  cycle_id           text not null unique references public.appraisal_cycles(id) on delete cascade,
  status             text not null default 'DRAFT',
  chair_id           text references public.users(id) on delete set null,
  chair_name         text,
  held_at            timestamp(3),
  finalized_by_id    text references public.users(id) on delete set null,
  finalized_by_name  text,
  finalized_at       timestamp(3),
  note               text,
  created_at         timestamp(3) not null default now(),
  updated_at         timestamp(3) not null default now(),
  constraint calibration_sessions_status_check check (status in ('DRAFT','IN_SESSION','AGREED','FINALIZED'))
);

-- ── Calibration entries (the pack — one row per employee) ────────────────────
create table if not exists public.calibration_entries (
  id                     text primary key,
  session_id             text not null references public.calibration_sessions(id) on delete cascade,
  employee_id            text not null references public.employees(id) on delete restrict,
  employee_name          text not null,
  grade                  text,
  job_family             text,
  manager_name           text,
  appraisal_id           text references public.appraisals(id) on delete set null,
  preliminary_rating     text,
  indicative_multiplier  numeric(6,4),
  calibrated_rating      text,
  calibrated_multiplier  numeric(6,4),
  integrity_gate         boolean not null default false,
  note                   text,
  created_at             timestamp(3) not null default now(),
  updated_at             timestamp(3) not null default now(),
  constraint calibration_entries_prelim_rating_check check (preliminary_rating is null or preliminary_rating in ('EXCEEDS','MEETS','BELOW','NA')),
  constraint calibration_entries_calib_rating_check check (calibrated_rating is null or calibrated_rating in ('EXCEEDS','MEETS','BELOW','NA')),
  constraint calibration_entries_session_employee_uq unique (session_id, employee_id)
);
create index if not exists calibration_entries_session_id_idx on public.calibration_entries(session_id);

commit;
