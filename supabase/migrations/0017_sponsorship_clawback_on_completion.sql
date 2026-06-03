-- 0017_sponsorship_clawback_on_completion.sql (v0.26.0) — Sponsorship Clawback Fix (Release B;
-- Ops Manual G4.3). Makes ON_COMPLETION the canonical default for the bonding/clawback window.
-- The 12-month clawback clock starts at the confirmed COMPLETION date (held in completed_at,
-- entered by People Ops from the award evidence), not at approval. The CHECK already allows both
-- values; only the column DEFAULT changes here. No new columns, no data backfill (the application
-- sets the basis explicitly on every create, and no sponsorships exist yet). Idempotent.

begin;

alter table public.qualification_sponsorships
  alter column bonding_start_basis set default 'ON_COMPLETION';

commit;
