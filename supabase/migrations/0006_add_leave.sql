-- 0006_add_leave.sql — Leave (v0.14.0)
-- Wires up the existing leave tables for self-service requests with a two-stage
-- approval (line-manager review -> HR decision). No new tables; in-place column
-- adds only:
--   * leave_balances.days_entitled  — editable per-employee entitlement
--   * leave_requests.manager_*       — the line-manager review stage
--   * leave_requests.decided_at / decision_note — the HR decision trail
-- (leave_requests.approver_id already exists and holds the deciding HR user.)
--
-- Cross-entity references are kept as bare columns in Prisma (FKs enforced here
-- in SQL only), and status vocab is CHECK-constrained text — same convention as
-- learning / scorecards / performance. Ids stay app-generated cuid.
--
-- Idempotent: wrapped in a transaction; IF NOT EXISTS / guarded constraints
-- throughout. Safe to re-run. Applied by hand in the Supabase SQL Editor.
-- This migration writes NO data (entitlements are seeded by prisma/leave-populate.ts).

begin;

-- 1) leave_balances: editable per-employee entitlement ----------------------
-- Default 0 at the DB; the seed/in-app editor sets the real figure from the
-- leave type's days_per_year, and HR can override it per person.
alter table public.leave_balances
  add column if not exists days_entitled numeric(6,1) not null default 0;

-- 2) leave_requests: two-stage review + decision trail ----------------------
alter table public.leave_requests
  add column if not exists manager_status      text not null default 'PENDING';
alter table public.leave_requests
  add column if not exists manager_reviewer_id text;
alter table public.leave_requests
  add column if not exists manager_reviewed_at timestamptz;
alter table public.leave_requests
  add column if not exists manager_note        text;
alter table public.leave_requests
  add column if not exists decided_at          timestamptz;
alter table public.leave_requests
  add column if not exists decision_note       text;

-- manager_status vocabulary (CHECK-constrained text, like learning.status).
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'leave_requests_manager_status_check'
  ) then
    alter table public.leave_requests
      add constraint leave_requests_manager_status_check
      check (manager_status in ('PENDING', 'RECOMMENDED', 'DECLINED'));
  end if;
end $$;

-- manager_reviewer_id references a user; FK in SQL only (bare in Prisma).
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'leave_requests_manager_reviewer_fkey'
  ) then
    alter table public.leave_requests
      add constraint leave_requests_manager_reviewer_fkey
      foreign key (manager_reviewer_id) references public.users (id) on delete set null;
  end if;
end $$;

-- Helpful read indexes for the approval queues.
create index if not exists leave_requests_status_idx          on public.leave_requests (status);
create index if not exists leave_requests_manager_status_idx  on public.leave_requests (manager_status);
create index if not exists leave_requests_employee_idx        on public.leave_requests (employee_id);

commit;
