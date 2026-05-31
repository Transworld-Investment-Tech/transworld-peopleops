-- 0002_add_scorecards.sql
-- Transworld PeopleOps — structured role scorecards.
--
-- HOW TO APPLY: Supabase dashboard → SQL Editor → New query → paste this whole
-- file → Run. Additive only (two new tables + one index); it does not touch any
-- existing table or data, and is safe to run once.
--
-- A scorecard is the "right people, right seat" definition for a role: a mission
-- plus an ordered list of measurable outcomes. One scorecard per job profile.
-- Ids are app-generated (Prisma cuid), so the id columns carry no DB default.

create table if not exists public.scorecards (
  id             text        primary key,
  job_profile_id text        not null unique references public.job_profiles(id) on delete cascade,
  mission        text,
  status         text        not null default 'DRAFT' check (status in ('DRAFT', 'PUBLISHED')),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create table if not exists public.scorecard_outcomes (
  id           text        primary key,
  scorecard_id text        not null references public.scorecards(id) on delete cascade,
  position     integer     not null default 0,
  title        text        not null,
  measure      text,
  weight       integer,
  created_at   timestamptz not null default now()
);

create index if not exists scorecard_outcomes_scorecard_idx
  on public.scorecard_outcomes (scorecard_id);
