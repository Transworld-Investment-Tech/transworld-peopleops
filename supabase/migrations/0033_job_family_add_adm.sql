-- 0033_job_family_add_adm.sql (v0.44.0) — Job Family Restructure.
-- Adds the fifth job family "Administration & Corporate Services"
-- (value ADMIN_CORPORATE_SERVICES) to the job_profiles.family CHECK.
--
--   * No new Postgres enum (family is CHECK-constrained text, per 0020).
--   * No new column, no permission change (so no auth:bootstrap).
--   * Existing rows hold only the four legacy values, all still permitted, so the
--     re-added CHECK cannot fail on current data.
--
-- Idempotent and safe to re-run: drops whatever CHECK currently constrains
-- job_profiles.family by its ACTUAL pg_constraint name (not a Prisma-default
-- guess), then re-adds the canonical five-value CHECK under a stable name.

begin;

do $$
declare
  con record;
begin
  -- 1) Drop any CHECK on public.job_profiles that references the family column,
  --    by its real name. (Inline column CHECKs are auto-named, e.g.
  --    job_profiles_family_check, but never assume the name.)
  for con in
    select c.conname
    from pg_constraint c
    join pg_class t      on t.oid = c.conrelid
    join pg_namespace n  on n.oid = t.relnamespace
    where n.nspname = 'public'
      and t.relname = 'job_profiles'
      and c.contype = 'c'
      and pg_get_constraintdef(c.oid) ilike '%family%'
  loop
    execute format('alter table public.job_profiles drop constraint %I', con.conname);
  end loop;

  -- 2) Re-add the canonical five-value CHECK under a stable name.
  if not exists (
    select 1 from pg_constraint where conname = 'job_profiles_family_check'
  ) then
    alter table public.job_profiles
      add constraint job_profiles_family_check
      check (
        family is null
        or family in (
          'BUSINESS_DEVELOPMENT',
          'INVESTMENTS',
          'CONTROL_OPERATIONS',
          'ADMIN_CORPORATE_SERVICES',
          'LEADERSHIP'
        )
      );
  end if;
end $$;

commit;
