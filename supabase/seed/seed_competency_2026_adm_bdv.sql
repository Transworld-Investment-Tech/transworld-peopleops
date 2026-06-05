-- seed_competency_2026_adm_bdv.sql (v0.44.0) — functional competencies 22 -> 26.
--
-- Job Family Restructure: adds two competency categories ("Business Development",
-- "Administration") and four FUNCTIONAL competencies. Hand-run DATA seed (NOT a
-- migration) — run in the Supabase SQL Editor after 0033.
--
-- Idempotent: upsert by competencies.name (the unique key), matching how
-- prisma/jobframework-populate.ts upserts the catalog. Stable ids apply on first
-- insert only; re-running refreshes category/kind/sort_order and never deletes.
-- definition is intentionally left untouched (all 22 existing functional rows
-- carry NULL definitions; behaviors carry theirs from 0020).

insert into public.competencies (id, name, category, kind, sort_order, definition) values
  ('cmp_bdv_sales',       'Business development & sales',    'Business Development', 'FUNCTIONAL', 0, null),
  ('cmp_bdv_mktg',        'Marketing & communications',      'Business Development', 'FUNCTIONAL', 0, null),
  ('cmp_adm_people',      'People operations & HR',          'Administration',       'FUNCTIONAL', 0, null),
  ('cmp_adm_procurement', 'Procurement & vendor management', 'Administration',       'FUNCTIONAL', 0, null)
on conflict (name) do update set
  category   = excluded.category,
  kind       = excluded.kind,
  sort_order = excluded.sort_order;
