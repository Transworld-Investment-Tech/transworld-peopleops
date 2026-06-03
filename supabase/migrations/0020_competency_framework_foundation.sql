-- 0020_competency_framework_foundation.sql (v0.30.0) — WS2 slice (a).
-- Schema (idempotent ALTERs) + the deterministic data reconciliation: collapse the legacy
-- 2–5 proficiency scale to canonical F/P/E (1/2/3), and seed the six behaviors as
-- BEHAVIOR-kind competencies attached to every job profile. family/track/rung are added
-- nullable and set per profile via the Job & Competency form (not bulk-assigned here).
-- No new Postgres enums (all CHECK-constrained text). No permission change.

begin;

-- 1) JobProfile: family (4 canonical) + control-function flag + track + rung.
alter table public.job_profiles add column if not exists family text
  check (family is null or family in ('BUSINESS_DEVELOPMENT', 'INVESTMENTS', 'CONTROL_OPERATIONS', 'LEADERSHIP'));
alter table public.job_profiles add column if not exists is_control_function boolean not null default false;
alter table public.job_profiles add column if not exists track text
  check (track is null or track in ('MANAGER', 'EXPERT'));
alter table public.job_profiles add column if not exists rung text
  check (rung is null or rung in ('JUNIOR', 'MID', 'SENIOR'));

-- 2) Competency: layer kind + ordering + definition.
alter table public.competencies add column if not exists kind text not null default 'FUNCTIONAL'
  check (kind in ('FUNCTIONAL', 'BEHAVIOR'));
alter table public.competencies add column if not exists sort_order integer not null default 0;
alter table public.competencies add column if not exists definition text;

-- 3) F/P/E remap (one-time, guarded): 2->F(1), 3->P(2), 4->P(2), 5->E(3). Guarded on the
--    presence of the legacy scale (level >= 4) so re-running is a no-op.
do $$
begin
  if exists (select 1 from public.job_profile_competencies where level >= 4) then
    update public.job_profile_competencies set level = case
      when level >= 5 then 3
      when level = 4 then 2
      when level = 3 then 2
      when level = 2 then 1
      else level
    end;
  end if;
end $$;

-- 4) The six behaviors (Layer 3), seeded as BEHAVIOR-kind competencies (stable ids).
insert into public.competencies (id, name, category, kind, sort_order, definition) values
  ('beh_mastery_growth', 'Mastery & Growth', 'Behaviors', 'BEHAVIOR', 1,
   'Pursue excellence, stay current in your field, and actively grow your capability; do not coast on what you already know.'),
  ('beh_integrity_above_all', 'Integrity Above All', 'Behaviors', 'BEHAVIOR', 2,
   'Act honestly in every situation, even when no one is watching; disclose conflicts, protect client information, and never cut corners.'),
  ('beh_compliance_by_default', 'Compliance by Default', 'Behaviors', 'BEHAVIOR', 3,
   'Meet every regulatory and company requirement without being reminded; flag issues before they become breaches and keep records current.'),
  ('beh_ownership_mentality', 'Ownership Mentality', 'Behaviors', 'BEHAVIOR', 4,
   'Take full responsibility for your outcomes; bring solutions, not just problems; behave like a stakeholder in the firm.'),
  ('beh_trust_through_documentation', 'Trust Through Documentation', 'Behaviors', 'BEHAVIOR', 5,
   'Document what you commit to and what you do; what is not documented is treated as if it did not happen.'),
  ('beh_lifting_others', 'Lifting Others', 'Behaviors', 'BEHAVIOR', 6,
   'Share knowledge, support colleagues who are learning, and strengthen the team''s collective capability.')
on conflict (id) do update set
  name = excluded.name, category = excluded.category, kind = excluded.kind,
  sort_order = excluded.sort_order, definition = excluded.definition;

-- 5) Attach the six behaviors to every job profile (nominal target level P=2; behaviors are
--    expected of everyone and scored separately at appraisal).
insert into public.job_profile_competencies (job_profile_id, competency_id, level)
select p.id, c.id, 2
from public.job_profiles p
cross join public.competencies c
where c.kind = 'BEHAVIOR'
on conflict (job_profile_id, competency_id) do nothing;

commit;
