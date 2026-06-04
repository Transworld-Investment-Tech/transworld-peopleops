-- 0022_appraisal_items_allow_behavior.sql (v0.34.1) — fix stale kind CHECK.
-- BEHAVIOR appraisal items were introduced in v0.31 (WS2 slice b) and are seeded
-- when an appraisal starts, but the appraisal_items.kind CHECK predated them and
-- only allowed OUTCOME/COMPETENCY — so starting any appraisal failed (Postgres
-- 23514, check_violation). Widen the constraint to the three kinds the system
-- actually uses. Idempotent; safe (no appraisal_items rows exist yet).
begin;

alter table public.appraisal_items drop constraint if exists appraisal_items_kind_check;
alter table public.appraisal_items add constraint appraisal_items_kind_check
  check (kind in ('OUTCOME', 'COMPETENCY', 'BEHAVIOR'));

commit;
