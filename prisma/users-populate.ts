// One-time (idempotent) staff login backfill — v0.13.0.
//
//   Dry run (default):  npm run users:populate
//   Apply:              npm run users:populate -- --commit
//
// What it does (and only this):
//   * Matches each CSV person to an employee record by normalized LAST name
//     (with a soft first-name check to disambiguate / flag short forms).
//   * SKIPS anyone whose matched employee is EXITED (e.g. EZEKIEL, EUNICE).
//   * REUSES an existing user when the email already has a login (the
//     SUPER_ADMIN, OFOEGBU/Okezie) — links the employee, never touches the
//     password or roles.
//   * CREATES a login for every other non-exited match: shared initial
//     password, the EMPLOYEE role, then links employee.userId + work_email.
//   * Never creates duplicates, never overrides an existing link, never
//     migrates/seeds anything else, never edits .env or the schema.
//
// Re-running is safe: created/linked rows report ALREADY LINKED and write
// nothing.
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

// Shared initial password (staff change it after signing in). Keep this in
// step with DEFAULT_STAFF_PASSWORD in lib/admin-users.ts.
const DEFAULT_PASSWORD = "Transworld!23";

// Source rows from Users_30_05_2026_15_20.csv (first, last, email).
// Emails are lowercased/trimmed; Eunice's domain corrected to ...ltd... per
// instruction (she is EXITED and will be skipped regardless).
type Row = { first: string; last: string; email: string };
const ROWS: Row[] = [
  { first: "Clement", last: "Oladele", email: "clement.oladele@transworldltd.com.ng" },
  { first: "Daniel", last: "Ezeh", email: "daniel.ezeh@transworldltd.com.ng" },
  { first: "Eunice", last: "Ezekiel", email: "eunice.ezekiel@transworldltd.com.ng" },
  { first: "Florence", last: "Ashofor", email: "florence.ashofor@transworldltd.com.ng" },
  { first: "Happiness", last: "Agege", email: "happiness.agege@transworldltd.com.ng" },
  { first: "Ifunanya", last: "Nwankwo", email: "ifunanya.nwankwo@transworldltd.com.ng" },
  { first: "Joseph", last: "Nwachukwu", email: "joseph.nwachukwu@transworldltd.com.ng" },
  { first: "Mabel", last: "Agangan", email: "mabel.agangan@transworldltd.com.ng" },
  { first: "Matthew", last: "Odigbo", email: "matthew.odigbo@transworldltd.com.ng" },
  { first: "Max", last: "Ayobami", email: "max.ayobami@transworldltd.com.ng" },
  { first: "Nkem", last: "Amamchukwu", email: "nkem.amamchukwu@transworldltd.com.ng" },
  { first: "Okezie", last: "Ofoegbu", email: "okezie.ofoegbu@transworldltd.com.ng" },
  { first: "Oyinkansola", last: "Ibrahim", email: "oyinkansola.ibrahim@transworldltd.com.ng" },
  { first: "Roland", last: "Musa", email: "roland.musa@transworldltd.com.ng" },
  { first: "Sarah", last: "Amatey", email: "sarah.amatey@transworldltd.com.ng" },
];

function norm(s: string): string {
  return s
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, "")
    .trim();
}

function firstCompatible(a: string, b: string): boolean {
  const x = norm(a);
  const y = norm(b);
  if (!x || !y) return false;
  return x === y || x.startsWith(y) || y.startsWith(x);
}

type EmpLite = {
  id: string;
  eeId: string;
  fullName: string;
  status: string;
  userId: string | null;
  workEmail: string | null;
  pLast: string;
  pFirst: string;
};

type Action =
  | "CREATE"
  | "REUSE_LINK"
  | "ALREADY_LINKED"
  | "SKIP_EXITED"
  | "CONFLICT"
  | "UNMATCHED"
  | "AMBIGUOUS";

type Plan = {
  row: Row;
  action: Action;
  emp?: EmpLite;
  note: string;
};

function parseEmployee(e: {
  id: string;
  eeId: string;
  fullName: string;
  status: string;
  userId: string | null;
  workEmail: string | null;
}): EmpLite {
  // full_name is "LAST, FIRST MIDDLE" (some have no comma, e.g. placeholders).
  const comma = e.fullName.indexOf(",");
  let last = e.fullName;
  let first = "";
  if (comma >= 0) {
    last = e.fullName.slice(0, comma);
    const rest = e.fullName.slice(comma + 1).trim();
    first = rest.split(/\s+/)[0] ?? "";
  } else {
    const toks = e.fullName.trim().split(/\s+/);
    last = toks[0] ?? e.fullName;
    first = toks[1] ?? "";
  }
  return {
    id: e.id,
    eeId: e.eeId,
    fullName: e.fullName,
    status: e.status,
    userId: e.userId,
    workEmail: e.workEmail,
    pLast: norm(last),
    pFirst: norm(first),
  };
}

async function main() {
  const commit = process.argv.includes("--commit");

  const employeesRaw = await prisma.employee.findMany({
    select: {
      id: true,
      eeId: true,
      fullName: true,
      status: true,
      userId: true,
      workEmail: true,
    },
  });
  const employees = employeesRaw.map((e) =>
    parseEmployee({ ...e, status: e.status as unknown as string })
  );

  const usersRaw = await prisma.user.findMany({
    select: { id: true, email: true },
  });
  const userByEmail = new Map<string, { id: string; email: string }>();
  for (const u of usersRaw) userByEmail.set(u.email.trim().toLowerCase(), u);

  // Which user ids are already attached to some employee.
  const empByUserId = new Map<string, EmpLite>();
  for (const e of employees) if (e.userId) empByUserId.set(e.userId, e);

  const employeeRole = await prisma.role.findUnique({ where: { key: "EMPLOYEE" } });
  if (!employeeRole) {
    throw new Error("The EMPLOYEE role is missing — run the foundation seed / auth:bootstrap first.");
  }

  const plans: Plan[] = [];
  const matchedEmpIds = new Set<string>();

  for (const row of ROWS) {
    const email = row.email.trim().toLowerCase();
    const lastN = norm(row.last);
    const candidates = employees.filter((e) => e.pLast === lastN);

    let emp: EmpLite | undefined;
    let note = "";

    if (candidates.length === 0) {
      plans.push({ row, action: "UNMATCHED", note: "no employee with that surname" });
      continue;
    } else if (candidates.length === 1) {
      emp = candidates[0];
      if (!firstCompatible(emp.pFirst, row.first)) {
        note = `first name differs (CSV "${row.first}" vs record "${emp.pFirst}")`;
      } else if (norm(emp.pFirst) !== norm(row.first)) {
        note = "short/long first-name form";
      }
    } else {
      const compat = candidates.filter((e) => firstCompatible(e.pFirst, row.first));
      if (compat.length === 1) {
        emp = compat[0];
        note = "disambiguated by first name";
      } else {
        plans.push({
          row,
          action: "AMBIGUOUS",
          note: `${candidates.length} surname matches; first name didn't disambiguate`,
        });
        continue;
      }
    }

    if (emp) matchedEmpIds.add(emp.id);

    if (emp.status === "EXITED") {
      plans.push({ row, action: "SKIP_EXITED", emp, note: note || "employee has exited" });
      continue;
    }

    const existingUser = userByEmail.get(email);

    if (emp.userId) {
      if (existingUser && emp.userId === existingUser.id) {
        plans.push({ row, action: "ALREADY_LINKED", emp, note: "linked on a prior run" });
      } else {
        plans.push({
          row,
          action: "CONFLICT",
          emp,
          note: "employee already linked to a different login",
        });
      }
      continue;
    }

    if (existingUser) {
      const takenBy = empByUserId.get(existingUser.id);
      if (takenBy && takenBy.id !== emp.id) {
        plans.push({
          row,
          action: "CONFLICT",
          emp,
          note: `login already attached to ${takenBy.eeId}`,
        });
      } else {
        plans.push({
          row,
          action: "REUSE_LINK",
          emp,
          note: note ? `reuse existing login; ${note}` : "reuse existing login (no password/role change)",
        });
      }
    } else {
      plans.push({
        row,
        action: "CREATE",
        emp,
        note: note || "new EMPLOYEE login",
      });
    }
  }

  // ---- Report ---------------------------------------------------------------
  const pad = (s: string, n: number) => (s.length >= n ? s.slice(0, n) : s + " ".repeat(n - s.length));
  console.log("");
  console.log(commit ? "USERS POPULATE — COMMIT" : "USERS POPULATE — DRY RUN (no changes written)");
  console.log("=".repeat(96));
  console.log(
    pad("CSV name", 22) + pad("Email", 38) + pad("Match", 10) + pad("Action", 16) + "Note"
  );
  console.log("-".repeat(96));
  for (const p of plans) {
    const who = `${p.row.first} ${p.row.last}`;
    console.log(
      pad(who, 22) +
        pad(p.row.email, 38) +
        pad(p.emp ? p.emp.eeId : "—", 10) +
        pad(p.action, 16) +
        p.note
    );
  }
  console.log("-".repeat(96));

  const count = (a: Action) => plans.filter((p) => p.action === a).length;
  console.log(
    `CREATE ${count("CREATE")} · REUSE+LINK ${count("REUSE_LINK")} · ALREADY LINKED ${count(
      "ALREADY_LINKED"
    )} · SKIP exited ${count("SKIP_EXITED")} · CONFLICT ${count("CONFLICT")} · UNMATCHED ${count(
      "UNMATCHED"
    )} · AMBIGUOUS ${count("AMBIGUOUS")}`
  );

  const orphanNonExited = employees.filter(
    (e) => e.status !== "EXITED" && !matchedEmpIds.has(e.id)
  );
  if (orphanNonExited.length > 0) {
    console.log("");
    console.log("Non-exited employees with NO CSV row (no login will be created):");
    for (const e of orphanNonExited) console.log(`  - ${e.eeId}  ${e.fullName}  (${e.status})`);
  } else {
    console.log("Non-exited employees with no CSV row: none.");
  }

  if (!commit) {
    console.log("");
    console.log("Dry run only. Re-run with:  npm run users:populate -- --commit");
    return;
  }

  // ---- Apply ----------------------------------------------------------------
  const passwordHash = await bcrypt.hash(DEFAULT_PASSWORD, 10);
  let created = 0;
  let linked = 0;

  for (const p of plans) {
    if (!p.emp) continue;
    if (p.action === "CREATE") {
      await prisma.$transaction(async (tx) => {
        const user = await tx.user.create({
          data: {
            email: p.row.email.trim().toLowerCase(),
            name: `${p.row.first} ${p.row.last}`,
            passwordHash,
            status: "active",
          },
        });
        await tx.userRole.create({ data: { userId: user.id, roleId: employeeRole.id } });
        await tx.employee.update({
          where: { id: p.emp!.id },
          data: { userId: user.id, workEmail: p.row.email.trim().toLowerCase() },
        });
        await tx.auditLog.create({
          data: {
            actorId: user.id,
            action: "user.provision_seed_created",
            entityType: "user",
            entityId: user.id,
            metadata: { email: user.email, eeId: p.emp!.eeId, role: "EMPLOYEE" },
          },
        });
      });
      created++;
    } else if (p.action === "REUSE_LINK") {
      const existingUser = userByEmail.get(p.row.email.trim().toLowerCase())!;
      await prisma.$transaction(async (tx) => {
        await tx.employee.update({
          where: { id: p.emp!.id },
          data: {
            userId: existingUser.id,
            workEmail: p.emp!.workEmail ?? p.row.email.trim().toLowerCase(),
          },
        });
        await tx.auditLog.create({
          data: {
            actorId: existingUser.id,
            action: "user.provision_seed_linked",
            entityType: "employee",
            entityId: p.emp!.id,
            metadata: { email: existingUser.email, eeId: p.emp!.eeId, reused: true },
          },
        });
      });
      linked++;
    }
  }

  const [userCount, linkedCount] = await Promise.all([
    prisma.user.count(),
    prisma.employee.count({ where: { userId: { not: null } } }),
  ]);

  console.log("");
  console.log(`Applied. Created ${created} new login(s), linked ${linked} existing login(s).`);
  console.log(`Totals now — users: ${userCount} · employees linked to a login: ${linkedCount}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
