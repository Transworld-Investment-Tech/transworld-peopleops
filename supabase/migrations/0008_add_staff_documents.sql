-- 0008_add_staff_documents.sql  (v0.17.0 — Staff & Hire Document Layer)
--
-- Adds TWO new tables and edits NO existing table:
--   * document_templates — in-system, HR-authored templates (offer letter,
--     employment contract, guarantor form, next-of-kin form, other).
--   * staff_documents — one row per document (uploaded OR generated), for a
--     staff member OR a job candidate. Drives the employee "Documents on file"
--     checklist and the in-portal e-signature flow.
--
-- House conventions honored:
--   * App-generated cuid TEXT primary keys; created_at timestamptz default now().
--   * Status vocabularies are CHECK-constrained TEXT (not Postgres enums).
--   * Cross-entity references to EXISTING tables (employees, candidates, users)
--     are BARE columns with the FK enforced in SQL only, so no existing Prisma
--     model is edited. The only real Prisma relation is template <-> documents
--     (both new models).
--   * Idempotent: BEGIN/COMMIT, CREATE TABLE IF NOT EXISTS, pg_constraint-guarded
--     constraints, IF NOT EXISTS indexes. Writes no data.

begin;

-- ---------------------------------------------------------------------------
-- document_templates
-- ---------------------------------------------------------------------------
create table if not exists public.document_templates (
  id                 text primary key,
  key                text not null,
  name               text not null,
  kind               text not null default 'OTHER',
  body_html          text not null,
  requires_signature boolean not null default true,
  is_active          boolean not null default true,
  version            integer not null default 1,
  created_by_id      text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'document_templates_kind_check') then
    alter table public.document_templates
      add constraint document_templates_kind_check
      check (kind in ('OFFER_LETTER','EMPLOYMENT_CONTRACT','GUARANTOR_FORM','NEXT_OF_KIN','OTHER'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'document_templates_created_by_fk') then
    alter table public.document_templates
      add constraint document_templates_created_by_fk
      foreign key (created_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create unique index if not exists document_templates_key_ued on public.document_templates(key);

-- ---------------------------------------------------------------------------
-- staff_documents
-- ---------------------------------------------------------------------------
create table if not exists public.staff_documents (
  id                 text primary key,
  employee_id        text,
  candidate_id       text,
  template_id        text,
  category           text not null,
  kind               text,
  title              text not null,
  source             text not null default 'UPLOADED',
  status             text not null default 'UPLOADED',
  file_key           text,
  body_html          text,
  content_type       text,
  size_bytes         integer,
  access_level       text not null default 'HR',
  expiry_date        timestamptz,
  requires_signature boolean not null default false,
  signed_at          timestamptz,
  signed_by_id       text,
  signer_name        text,
  signer_ip          text,
  version            integer not null default 1,
  uploaded_by_id     text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_source_check') then
    alter table public.staff_documents
      add constraint staff_documents_source_check
      check (source in ('GENERATED','UPLOADED'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_status_check') then
    alter table public.staff_documents
      add constraint staff_documents_status_check
      check (status in ('DRAFT','AWAITING_SIGNATURE','SIGNED','UPLOADED','VOID'));
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_access_check') then
    alter table public.staff_documents
      add constraint staff_documents_access_check
      check (access_level in ('EMPLOYEE','HR','EXEC','RESTRICTED'));
  end if;
end $$;

-- Every document must attach to a staff member OR a candidate.
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_subject_check') then
    alter table public.staff_documents
      add constraint staff_documents_subject_check
      check (employee_id is not null or candidate_id is not null);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_employee_fk') then
    alter table public.staff_documents
      add constraint staff_documents_employee_fk
      foreign key (employee_id) references public.employees(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_candidate_fk') then
    alter table public.staff_documents
      add constraint staff_documents_candidate_fk
      foreign key (candidate_id) references public.candidates(id) on delete cascade;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_template_fk') then
    alter table public.staff_documents
      add constraint staff_documents_template_fk
      foreign key (template_id) references public.document_templates(id) on delete set null;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_signed_by_fk') then
    alter table public.staff_documents
      add constraint staff_documents_signed_by_fk
      foreign key (signed_by_id) references public.users(id) on delete set null;
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'staff_documents_uploaded_by_fk') then
    alter table public.staff_documents
      add constraint staff_documents_uploaded_by_fk
      foreign key (uploaded_by_id) references public.users(id) on delete set null;
  end if;
end $$;

create index if not exists staff_documents_employee_idx on public.staff_documents(employee_id);
create index if not exists staff_documents_candidate_idx on public.staff_documents(candidate_id);
create index if not exists staff_documents_status_idx on public.staff_documents(status);
create index if not exists staff_documents_template_idx on public.staff_documents(template_id);

commit;
