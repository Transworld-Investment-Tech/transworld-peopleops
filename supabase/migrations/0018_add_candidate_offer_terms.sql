-- 0018_add_candidate_offer_terms.sql (v0.27.0) — Offer Letter (Release C; Ops Manual C5.2).
-- People Ops enters the offer terms on a candidate; the offer-letter merge context reads them
-- and computes the derived figures live (gross = basic+utility; quarterly = 13th = gross;
-- fully-loaded = gross × 17 ÷ 12; annual ≈ gross × 17). Five nullable columns, idempotent.
-- No new Postgres enums (offer_grade is CHECK-constrained text). No permission change.
--
-- The offer-letter TEMPLATE body is refreshed separately by re-running the seeder
-- (prisma/document-templates-populate.ts --commit), which now upserts.

begin;

alter table public.candidates
  add column if not exists offer_grade text
    check (offer_grade is null or offer_grade in ('G0', 'G1', 'G2', 'G3', 'G4', 'G5', 'PT'));
alter table public.candidates add column if not exists offer_basic numeric(14, 2);
alter table public.candidates add column if not exists offer_utility numeric(14, 2);
alter table public.candidates add column if not exists offer_start_date timestamp(3);
alter table public.candidates add column if not exists offer_acceptance_deadline timestamp(3);

commit;
