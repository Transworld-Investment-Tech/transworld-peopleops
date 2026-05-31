// Transworld PeopleOps — Leave populate (idempotent, dry-run first).
//
// Seeds the five starter leave types and, for every active employee, a balance
// row for the current leave year so the module ships with real figures rather
// than empty tables.
//
// SAFETY (mirrors prisma/learning-populate.ts):
//   • DEFAULT = DRY RUN. Prints the full plan and writes NOTHING.
//   • Add `--commit` to apply. Re-running converges to the same state (idempotent).
//   • NON-DESTRUCTIVE: only creates. It never overwrites a leave type's default or
//     an employee's entitlement you've changed in the UI, and never deletes anything.
//   • Writes are recorded in audit_logs. Never touches payroll, compensation, or .env.
//
// USAGE (from the repo root):
//   npx tsx prisma/leave-populate.ts                # dry run (review)
//   npx tsx prisma/leave-populate.ts -- --commit    # apply
//   (or:  npm run leave:populate -- --commit )

import { readFileSync } from "node:fs";

// Load DATABASE_URL from .env before the Prisma client is constructed.
if (!process.env.DATABASE_URL) {
  try {
    for (const line of readFileSync(".env", "utf8").split("\n")) {
      const m = line.match(/^\s*DATABASE_URL\s*=\s*(.*)\s*$/);
      if (m) {
        let v = m[1].trim();
        if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'")))
          v = v.slice(1, -1);
        process.env.DATABASE_URL = v;
        break;
      }
    }
  } catch {
    /* .env optional if DATABASE_URL already set */
  }
}

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
const COMMIT = process.argv.includes("--commit");
const YEAR = new Date().getFullYear();

// ---------------------------------------------------------------------------
// Starter leave types and their default annual entitlement.
//
// Annual = 14 (confirmed). The rest are RECOMMENDED Nigerian defaults for HR to
// confirm/adjust under Leave types and Balances:
//   • Sick 12          — up to 12 working days paid sick leave is the common floor.
//   • Compassionate 5  — discretionary bereavement allowance.
//   • Maternity/Paternity 90 — PLACEHOLDER. Statutory maternity (~12 weeks) and
//     paternity differ and vary by employer/State; HR should set the real figure
//     and typically adjusts it per case under Balances.
//   • Unpaid 0         — uncapped; tracked only, so remaining goes negative and
//     surfaces as the unpaid-leave payroll-variance signal.
// ---------------------------------------------------------------------------
const TYPES: { name: string; daysPerYear: number }[] = [
  { name: "Annual Leave", daysPerYear: 14 },
  { name: "Sick Leave", daysPerYear: 12 },
  { name: "Compassionate Leave", daysPerYear: 5 },
  { name: "Maternity / Paternity Leave", daysPerYear: 90 },
  { name: "Unpaid Leave", daysPerYear: 0 },
];

function line() {
  console.log("─".repeat(64));
}

async function main() {
  console.log(`\nTransworld PeopleOps — Leave seed  (${COMMIT ? "COMMIT" : "DRY RUN"}) · year ${YEAR}`);
  line();

  // 1) Leave types ----------------------------------------------------------
  const existingTypes = await prisma.leaveType.findMany();
  const typeByName = new Map(existingTypes.map((t) => [t.name, t] as const));

  console.log("Leave types:");
  for (const t of TYPES) {
    const ex = typeByName.get(t.name);
    if (ex) console.log(`  SKIP    ${t.name}  (exists · ${Number(ex.daysPerYear)} days/yr — left as-is)`);
    else console.log(`  CREATE  ${t.name}  (${t.daysPerYear} days/yr)`);
  }

  if (COMMIT) {
    for (const t of TYPES) {
      if (typeByName.has(t.name)) continue;
      const created = await prisma.leaveType.create({
        data: { name: t.name, daysPerYear: t.daysPerYear },
      });
      typeByName.set(created.name, created);
      await prisma.auditLog.create({
        data: {
          actorId: null,
          action: "leavetype.seed",
          entityType: "leave_type",
          entityId: created.id,
          metadata: { name: t.name, daysPerYear: t.daysPerYear } as never,
          ip: null,
        },
      });
    }
  }

  // Resolve the type set we'll seed balances against. In a dry run, types that
  // don't exist yet have no id — every active employee would get a fresh row.
  const resolvedTypes = TYPES.map((t) => {
    const ex = typeByName.get(t.name);
    return { name: t.name, id: ex?.id ?? null, daysPerYear: ex ? Number(ex.daysPerYear) : t.daysPerYear };
  });

  // 2) Balances for active employees ---------------------------------------
  const employees = await prisma.employee.findMany({
    where: { status: { not: "EXITED" } },
    select: { id: true, eeId: true, fullName: true },
    orderBy: { eeId: "asc" },
  });

  const existingBalances = await prisma.leaveBalance.findMany({
    where: { year: YEAR },
    select: { employeeId: true, leaveTypeId: true },
  });
  const hasBalance = new Set(existingBalances.map((b) => `${b.employeeId}::${b.leaveTypeId}`));

  line();
  console.log(`Balances for ${employees.length} active employees × ${TYPES.length} types · year ${YEAR}:`);

  let toCreate = 0;
  let toSkip = 0;
  const plan: { employeeId: string; leaveTypeId: string; daysEntitled: number }[] = [];

  for (const rt of resolvedTypes) {
    let createForType = 0;
    for (const e of employees) {
      // If the type doesn't exist yet (dry run), no balance can exist for it.
      const exists = rt.id ? hasBalance.has(`${e.id}::${rt.id}`) : false;
      if (exists) {
        toSkip += 1;
      } else {
        toCreate += 1;
        createForType += 1;
        if (rt.id) plan.push({ employeeId: e.id, leaveTypeId: rt.id, daysEntitled: rt.daysPerYear });
      }
    }
    console.log(`  ${rt.name}: ${createForType} to create, ${employees.length - createForType} present`);
  }

  if (COMMIT) {
    let created = 0;
    for (const p of plan) {
      // Guard again at write time (idempotent even if run concurrently).
      const existing = await prisma.leaveBalance.findUnique({
        where: {
          employeeId_leaveTypeId_year: {
            employeeId: p.employeeId,
            leaveTypeId: p.leaveTypeId,
            year: YEAR,
          },
        },
        select: { id: true },
      });
      if (existing) continue;
      await prisma.leaveBalance.create({
        data: {
          employeeId: p.employeeId,
          leaveTypeId: p.leaveTypeId,
          year: YEAR,
          daysEntitled: p.daysEntitled,
          daysTaken: 0,
        },
      });
      created += 1;
    }
    await prisma.auditLog.create({
      data: {
        actorId: null,
        action: "leavebalance.seed",
        entityType: "leave_balance",
        entityId: null,
        metadata: { year: YEAR, created, skipped: toSkip } as never,
        ip: null,
      },
    });
    line();
    console.log(`COMMITTED: ${created} balance row(s) created, ${toSkip} already present.`);
  } else {
    line();
    console.log(`DRY RUN: would create ${toCreate} balance row(s), skip ${toSkip}.`);
    console.log("Re-run with `-- --commit` to apply.");
  }

  console.log(
    "\nNote: Maternity / Paternity defaults to 90 days as a placeholder — confirm the statutory\nfigure for your policy under Leave types, and adjust individuals under Balances.\n"
  );
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
