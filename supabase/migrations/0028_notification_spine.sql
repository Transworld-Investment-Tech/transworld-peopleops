-- 0028_notification_spine.sql  (v0.39.1 — document-expiry alerts + spine)
-- Enriches the orphan notifications table into the alert/notification spine:
-- category / severity / polymorphic entity pointer / due_at / status lifecycle /
-- dedupe_key (so an idempotent generator never double-creates). No new tables.
-- Conventions: ADD COLUMN IF NOT EXISTS; CHECKs via guarded DO blocks; the
-- entity pointer is polymorphic (no FK), matching audit_logs. Safe to re-run.

BEGIN;

ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS category     text;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS severity     text;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS entity_type  text;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS entity_id    text;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS due_at       timestamp(3);
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS status       text NOT NULL DEFAULT 'OPEN';
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS dismissed_at timestamp(3);
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS resolved_at  timestamp(3);
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS dedupe_key   text;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'notifications_category_check') THEN
    ALTER TABLE public.notifications ADD CONSTRAINT notifications_category_check
      CHECK (category IS NULL OR category IN ('DOC_EXPIRY','STAFF_FILE_GAP','PIPELINE_GATE','SYSTEM'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'notifications_severity_check') THEN
    ALTER TABLE public.notifications ADD CONSTRAINT notifications_severity_check
      CHECK (severity IS NULL OR severity IN ('INFO','WARNING','CRITICAL'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'notifications_status_check') THEN
    ALTER TABLE public.notifications ADD CONSTRAINT notifications_status_check
      CHECK (status IN ('OPEN','DISMISSED','RESOLVED'));
  END IF;
END $$;

-- One alert per condition+window: a unique index on dedupe_key (NULLs allowed,
-- so legacy/manual notifications without a key are unaffected).
CREATE UNIQUE INDEX IF NOT EXISTS notifications_dedupe_key_key
  ON public.notifications (dedupe_key);

CREATE INDEX IF NOT EXISTS notifications_status_category_idx
  ON public.notifications (status, category);

COMMIT;
