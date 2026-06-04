-- 0021_scorecard_weight_overrides.sql (v0.34.0) — per-scorecard dimension weighting.
-- Adds an optional Results / Competencies / Behaviors weight triple to scorecards.
--   * All three NULL  => the scorecard uses its job family's default split (no change
--     for existing rows — every scorecard starts NULL, so scoring is unchanged).
--   * All three SET   => the scoring engine uses them instead of the family default.
-- Stored as fractions (0.0000–1.0000). No new Postgres enum; no permission change.
-- Idempotent and safe to re-run.

begin;

alter table public.scorecards add column if not exists results_weight numeric(6,4);
alter table public.scorecards add column if not exists competencies_weight numeric(6,4);
alter table public.scorecards add column if not exists behaviors_weight numeric(6,4);

-- Structural invariant: all-or-none, non-negative, sums to ~100%. Added guarded
-- (Postgres has no ADD CONSTRAINT IF NOT EXISTS). The canonical band check
-- (Results 40–60 / Competencies 20–30 / Behaviors 20–30) lives in the action layer.
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'scorecards_weight_triple_chk'
  ) then
    alter table public.scorecards add constraint scorecards_weight_triple_chk check (
      (results_weight is null and competencies_weight is null and behaviors_weight is null)
      or (
        results_weight is not null and competencies_weight is not null and behaviors_weight is not null
        and results_weight >= 0 and competencies_weight >= 0 and behaviors_weight >= 0
        and (results_weight + competencies_weight + behaviors_weight) between 0.9990 and 1.0010
      )
    );
  end if;
end $$;

commit;
