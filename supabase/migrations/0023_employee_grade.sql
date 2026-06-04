-- 0023_employee_grade.sql (v0.35.0) — person-level grade, independent of the role.
-- Adds employees.grade and backfills each current employee from the grade of the
-- role they hold, so from here on re-grading a role no longer moves the holder.
-- Nullable (null => fall back to the role's grade at read time). No new enum.
-- Idempotent and safe to re-run.

begin;

-- 1) Column.
alter table public.employees add column if not exists grade text;

-- 2) CHECK (G0–G5/PT), guarded (no ADD CONSTRAINT IF NOT EXISTS in Postgres).
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'employees_grade_check') then
    alter table public.employees add constraint employees_grade_check
      check (grade is null or grade in ('G0','G1','G2','G3','G4','G5','PT'));
  end if;
end $$;

-- 3) Backfill from the held role's grade. Guarded on `grade is null` (re-runnable)
--    and on a valid role grade (so a stray/non-standard role grade can't violate the
--    new CHECK — those employees stay null and fall back to the role at read time).
update public.employees e
set grade = jp.grade
from public.job_profiles jp
where e.job_profile_id = jp.id
  and e.grade is null
  and jp.grade in ('G0','G1','G2','G3','G4','G5','PT');

commit;
