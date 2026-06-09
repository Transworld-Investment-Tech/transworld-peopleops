-- =============================================================================
-- seed_feature_flags.sql  (v0.66.0)
-- Materializes the my_pay feature flag, default OFF (the soft-launch state).
-- DATA, not schema. Run AFTER 0035_feature_flags.sql.
--
-- Idempotent and SAFE TO RE-RUN: ON CONFLICT DO NOTHING preserves whatever the
-- flag is currently set to. Re-running this never flips an ON flag back OFF, so
-- once My Pay has been switched on in Admin > Settings it stays on.
-- =============================================================================

BEGIN;

INSERT INTO "feature_flags" ("key", "enabled")
VALUES ('my_pay', false)
ON CONFLICT ("key") DO NOTHING;

-- fail-loud guard
DO $guard$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM "feature_flags" WHERE "key" = 'my_pay';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: my_pay flag row missing (got %)', n; END IF;
END
$guard$;

COMMIT;
