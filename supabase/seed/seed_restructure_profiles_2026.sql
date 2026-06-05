-- seed_restructure_profiles_2026.sql (v0.45.0) — Job Family Restructure, data.
--
-- Creates the new ADM / BD ROLE profiles, attaches their behaviors + functional
-- competencies, gives the canonical HR competency to People-Ops Officer, and
-- moves People-Ops/COO/CFO to their canonical families.
--
-- PREREQUISITES (run first, in order):
--   1) 0033_job_family_add_adm.sql        (so ADM is allowed by the family CHECK)
--   2) seed_competency_2026_adm_bdv.sql   (so the four new competencies exist)
--
-- Idempotent. Grades and pay are untouched. New roles start DRAFT, 0 holders.
-- Competency levels are F/P/E = 1/2/3. status is assigned as a text literal and
-- implicitly cast to the JdStatus enum by the column (no type name needed).

begin;

-- 1) New role profiles (titles are ROLES, not families). Create if missing.
insert into public.job_profiles
  (id, title, grade, family, is_control_function, status, description, created_at, updated_at)
values
  ('jp_procurement_officer', 'Procurement Officer', 'G2', 'ADMIN_CORPORATE_SERVICES', false, 'DRAFT',
   'Sourcing, vendor management, and purchasing controls.', now(), now()),
  ('jp_marketing_comms', 'Marketing & Communications Officer', 'G2', 'BUSINESS_DEVELOPMENT', false, 'DRAFT',
   'Brand, marketing campaigns, and corporate communications.', now(), now()),
  ('jp_office_admin', 'Office Administrator', 'G1', 'ADMIN_CORPORATE_SERVICES', false, 'DRAFT',
   'Facilities, office administration, and general support.', now(), now())
on conflict (id) do nothing;

-- 2) Attach the six behaviors (level 2) to each new profile (matches 0020).
insert into public.job_profile_competencies (job_profile_id, competency_id, level)
select p.id, c.id, 2
from public.job_profiles p
cross join public.competencies c
where p.id in ('jp_procurement_officer','jp_marketing_comms','jp_office_admin')
  and c.kind = 'BEHAVIOR'
on conflict (job_profile_id, competency_id) do nothing;

-- 3) Functional competencies per new profile (resolved by name).
insert into public.job_profile_competencies (job_profile_id, competency_id, level)
select v.pid, c.id, v.lvl
from (values
  ('jp_procurement_officer', 'Procurement & vendor management', 3),
  ('jp_procurement_officer', 'Process documentation', 2),
  ('jp_procurement_officer', 'Internal controls & audit', 2),
  ('jp_procurement_officer', 'Financial accounting & reporting', 1),
  ('jp_marketing_comms', 'Marketing & communications', 3),
  ('jp_marketing_comms', 'Business development & sales', 2),
  ('jp_marketing_comms', 'Client relationship management', 2),
  ('jp_marketing_comms', 'Client onboarding & KYC', 1),
  ('jp_office_admin', 'Process documentation', 2),
  ('jp_office_admin', 'Operations management', 1),
  ('jp_office_admin', 'Procurement & vendor management', 1),
  ('jp_office_admin', 'People operations & HR', 1)
) as v(pid, cname, lvl)
join public.competencies c on c.name = v.cname
on conflict (job_profile_id, competency_id) do update set level = excluded.level;

-- 4) People-Ops Officer is the canonical HR role -> add the HR competency (E).
insert into public.job_profile_competencies (job_profile_id, competency_id, level)
select p.id, c.id, 3
from public.job_profiles p
join public.competencies c on c.name = 'People operations & HR'
where p.title = 'People-Ops Officer'
on conflict (job_profile_id, competency_id) do update set level = excluded.level;

-- 5) Family moves (idempotent; by exact title). No grade/pay change.
update public.job_profiles set family = 'ADMIN_CORPORATE_SERVICES', updated_at = now()
  where title = 'People-Ops Officer';
update public.job_profiles set family = 'LEADERSHIP', updated_at = now()
  where title in ('COO', 'CFO');

commit;
