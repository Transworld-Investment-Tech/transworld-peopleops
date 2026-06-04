-- 0025_ws5_conduct_cases.sql  (v0.37.0)
-- WS5 — the conduct & cases layer: Disciplinary (E8), Grievance (E9) and the
-- Whistleblower channel (Board policy). Four new tables. Cross-entity refs to
-- existing tables (employees, users) are bare FK columns; the only intra-feature
-- relation is disciplinary_actions -> disciplinary_cases (cascade). All status
-- vocabularies are CHECK-constrained TEXT (no new Postgres enums). Additive +
-- idempotent. Apply in the Supabase SQL Editor BEFORE pushing.

begin;

-- ── Disciplinary (E8) ───────────────────────────────────────────────────────
create table if not exists public.disciplinary_cases (
  id                     text primary key,
  employee_id            text not null references public.employees(id) on delete restrict,
  employee_name          text not null,
  concern                text not null,
  is_regulatory          boolean not null default false,
  is_gross_misconduct    boolean not null default false,
  status                 text not null default 'OPEN',
  current_stage          text,
  investigation_summary  text,
  investigated_by_id     text references public.users(id) on delete set null,
  investigated_by_name   text,
  investigated_at        timestamp(3),
  suspended_at           timestamp(3),
  suspension_ends_at     timestamp(3),
  outcome                text,
  opened_at              timestamp(3) not null default now(),
  closed_at              timestamp(3),
  prepared_by_id         text references public.users(id) on delete set null,
  prepared_by_name       text,
  ack_name               text,
  ack_at                 timestamp(3),
  ack_ip                 text,
  created_at             timestamp(3) not null default now(),
  updated_at             timestamp(3) not null default now(),
  constraint disciplinary_cases_status_check check (status in
    ('OPEN','INVESTIGATING','SUSPENDED','AWAITING_DECISION','SANCTION_ISSUED','CLOSED','APPEALED')),
  constraint disciplinary_cases_stage_check check (current_stage is null or current_stage in
    ('INFORMAL_DISCUSSION','VERBAL_WARNING','WRITTEN_WARNING','FINAL_WRITTEN_WARNING','DISMISSAL'))
);
create index if not exists disciplinary_cases_employee_id_idx on public.disciplinary_cases(employee_id);
create index if not exists disciplinary_cases_status_idx on public.disciplinary_cases(status);

create table if not exists public.disciplinary_actions (
  id                        text primary key,
  case_id                   text not null references public.disciplinary_cases(id) on delete cascade,
  stage                     text not null,
  issued_at                 timestamp(3) not null default now(),
  required_standard         text,
  improvement_period_months integer,
  consequence               text,
  retention_months          integer,
  expires_at                timestamp(3),
  approver_role             text,
  approved_by_id            text references public.users(id) on delete set null,
  approved_by_name          text,
  approved_at               timestamp(3),
  employee_response         text,
  employee_response_at      timestamp(3),
  note                      text,
  created_by_id             text references public.users(id) on delete set null,
  created_at                timestamp(3) not null default now(),
  constraint disciplinary_actions_stage_check check (stage in
    ('INFORMAL_DISCUSSION','VERBAL_WARNING','WRITTEN_WARNING','FINAL_WRITTEN_WARNING','DISMISSAL')),
  constraint disciplinary_actions_approver_role_check check (approver_role is null or approver_role in
    ('COO','MD','CHAIRMAN'))
);
create index if not exists disciplinary_actions_case_id_idx on public.disciplinary_actions(case_id);

-- ── Grievance (E9) ──────────────────────────────────────────────────────────
create table if not exists public.grievances (
  id                  text primary key,
  complainant_id      text not null references public.employees(id) on delete restrict,
  complainant_name    text not null,
  respondent_id       text references public.employees(id) on delete set null,
  respondent_name     text,
  subject             text not null,
  details             text not null,
  status              text not null default 'RECEIVED',
  acknowledged_at     timestamp(3),
  target_date         timestamp(3),
  investigator_id     text references public.users(id) on delete set null,
  investigator_name   text,
  investigated_at     timestamp(3),
  finding             text,
  finding_summary     text,
  recommended_action  text,
  communicated_at     timestamp(3),
  appeal_requested_at timestamp(3),
  appeal_heard_by_id  text references public.users(id) on delete set null,
  appeal_heard_by_name text,
  appeal_outcome      text,
  appeal_at           timestamp(3),
  prepared_by_id      text references public.users(id) on delete set null,
  prepared_by_name    text,
  closed_at           timestamp(3),
  created_at          timestamp(3) not null default now(),
  updated_at          timestamp(3) not null default now(),
  constraint grievances_status_check check (status in
    ('RECEIVED','ACKNOWLEDGED','INVESTIGATING','FINDING_ISSUED','APPEALED','CLOSED')),
  constraint grievances_finding_check check (finding is null or finding in
    ('SUBSTANTIATED','PARTIALLY_SUBSTANTIATED','NOT_SUBSTANTIATED'))
);
create index if not exists grievances_complainant_id_idx on public.grievances(complainant_id);
create index if not exists grievances_status_idx on public.grievances(status);

-- ── Whistleblower (Board policy) ────────────────────────────────────────────
create table if not exists public.whistleblower_reports (
  id                          text primary key,
  case_ref                    text not null unique,
  is_anonymous                boolean not null default false,
  reporter_id                 text references public.employees(id) on delete set null,
  reporter_name               text,
  category                    text not null,
  involves_senior_management  boolean not null default false,
  route                       text not null default 'CCO',
  summary                     text not null,
  status                      text not null default 'RECEIVED',
  received_at                 timestamp(3) not null default now(),
  handler_id                  text references public.users(id) on delete set null,
  handler_name                text,
  investigation_summary       text,
  outcome                     text,
  action_taken                text,
  acknowledged_at             timestamp(3),
  closed_at                   timestamp(3),
  created_at                  timestamp(3) not null default now(),
  updated_at                  timestamp(3) not null default now(),
  constraint whistleblower_category_check check (category in
    ('FRAUD','REGULATORY','FINANCIAL_MISCONDUCT','UNETHICAL_CONDUCT','HEALTH_SAFETY','RETALIATION','OTHER')),
  constraint whistleblower_route_check check (route in ('CCO','BARC_CHAIR')),
  constraint whistleblower_status_check check (status in
    ('RECEIVED','UNDER_REVIEW','INVESTIGATING','SUBSTANTIATED','NOT_SUBSTANTIATED','CLOSED'))
);
create index if not exists whistleblower_reports_status_idx on public.whistleblower_reports(status);
create index if not exists whistleblower_reports_route_idx on public.whistleblower_reports(route);

commit;
