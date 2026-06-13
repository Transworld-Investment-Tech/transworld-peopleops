-- 0036_doc_pending_approval.sql
-- v0.70.0 — Staff self-uploaded documents now require HR approval before they
-- count as "on file". A self-upload lands as PENDING_APPROVAL; HR approves
-- (-> UPLOADED) or rejects (-> VOID). Widen the staff_documents.status CHECK to
-- admit the new value in the SAME release that introduces it.
--
-- No new Postgres enum (CHECK-constrained text only, per house convention).
-- The constraint name was verified against pg_constraint: 'staff_documents_status_check'
-- (created in 0008_add_staff_documents.sql). Idempotent: drop-if-exists then add.

do $$
begin
  if exists (
    select 1 from pg_constraint where conname = 'staff_documents_status_check'
  ) then
    alter table public.staff_documents
      drop constraint staff_documents_status_check;
  end if;

  alter table public.staff_documents
    add constraint staff_documents_status_check
    check (status in (
      'DRAFT',
      'AWAITING_SIGNATURE',
      'SIGNED',
      'UPLOADED',
      'PENDING_APPROVAL',
      'VOID'
    ));
end $$;
