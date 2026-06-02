-- 0013_add_bonus_tranche_events.sql (v0.21.0) — Bonus model Phase B.
-- ONE new pure-append table: bonus_tranche_events — the structured history behind
-- the cross-year deferral ledger (mark-paid, partial/full clawback, leaver
-- forfeiture, Board-discretion reinstatement). No new Postgres enums — event_type
-- is CHECK-constrained text (the established pattern), so no enum casts arise.
-- Idempotent. Writes no data. Table count 53 -> 54.
begin;

create table if not exists "bonus_tranche_events" (
  "id"               text         primary key,
  "bonus_tranche_id" text         not null,
  "bonus_award_id"   text         not null,
  "bonus_round_id"   text         not null,
  "employee_id"      text         not null,
  "event_type"       text         not null,
  "amount"           numeric(14,2) not null,
  "board_override"   boolean      not null default false,
  "reason"           text,
  "actor_id"         text,
  "created_at"       timestamp(3) not null default now(),
  constraint "bonus_tranche_events_event_type_check"
    check ("event_type" in ('PAID', 'CLAWBACK', 'FORFEIT', 'REINSTATE')),
  constraint "bonus_tranche_events_tranche_fk"
    foreign key ("bonus_tranche_id") references "bonus_tranches" ("id") on delete cascade
);

create index if not exists "bonus_tranche_events_tranche_idx" on "bonus_tranche_events" ("bonus_tranche_id");
create index if not exists "bonus_tranche_events_round_idx"   on "bonus_tranche_events" ("bonus_round_id");
create index if not exists "bonus_tranche_events_emp_idx"     on "bonus_tranche_events" ("employee_id");
create index if not exists "bonus_tranche_events_type_idx"    on "bonus_tranche_events" ("event_type");

commit;
