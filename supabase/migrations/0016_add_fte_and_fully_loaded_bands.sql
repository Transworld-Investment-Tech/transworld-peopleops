-- 0016_add_fte_and_fully_loaded_bands.sql (v0.25.0) — Band & Compa-Ratio Realignment
-- (Release A; Ops Manual B1.2/B1.3). Two changes, both idempotent, writes employee data
-- only as a backfilled default:
--   1) ADD employees.fte (numeric(5,4), default 1.0) — the full-time-equivalent fraction
--      used to normalize part-timers in the compa-ratio. Existing rows backfill to 1.0.
--   2) UPDATE salary_bands G0–G5 to the ratified fully-loaded monthly-equivalent figures
--      (min = 0.78 × midpoint, max = 1.25 × midpoint). PT remains proportional (no row).
-- After this runs, compa-ratio and band position read on the fully-loaded basis
-- (gross × 17 ÷ 12 ÷ FTE) — the portal code handles the conversion; the bands here are
-- the matching fully-loaded denominators.
-- No new tables, no new Postgres enums, no permission change (no auth:bootstrap).

begin;

-- 1) FTE on the employee record.
alter table public.employees
  add column if not exists fte numeric(5, 4) not null default 1.0;

-- 2) Fully-loaded salary bands (ratified 2026 compensation review).
update public.salary_bands set min_amount =  93600, midpoint = 120000, max_amount = 150000, updated_at = now() where grade = 'G0';
update public.salary_bands set min_amount = 152100, midpoint = 195000, max_amount = 243750, updated_at = now() where grade = 'G1';
update public.salary_bands set min_amount = 195000, midpoint = 250000, max_amount = 312500, updated_at = now() where grade = 'G2';
update public.salary_bands set min_amount = 265200, midpoint = 340000, max_amount = 425000, updated_at = now() where grade = 'G3';
update public.salary_bands set min_amount = 366600, midpoint = 470000, max_amount = 587500, updated_at = now() where grade = 'G4';
update public.salary_bands set min_amount = 499200, midpoint = 640000, max_amount = 800000, updated_at = now() where grade = 'G5';

commit;
