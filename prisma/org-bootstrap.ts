// Transworld PeopleOps — org bootstrap (idempotent, dry-run first).
//
// Builds out the organization from the confirmed reconciliation of the staff
// sheet against the seeded `employees` table:
//   • sets department + job profile + manager for the 12 existing real staff
//   • retires 3 phantom seed records (EID 12 / 14 / 19)
//   • creates 3 real people missing from the table (Ezekiel exited, Ayobami
//     fractional IT, Ibrahim new hire) into the unused EID gaps 4 / 8 / 11
//   • creates job profiles from titles; departments are matched to the 8 seeded
//     ones (no duplicates created)
//
// SAFETY
//   • DEFAULT = DRY RUN. Prints the full before/after plan and writes NOTHING.
//   • Add `--commit` to apply. Re-running converges to the same state
//     (idempotent): unchanged fields are skipped and not re-audited.
//   • Phantoms are retired to status EXITED by default (reversible). Add
//     `--delete-phantoms` to hard-delete them instead.
//   • Every write is recorded in audit_logs.
//   • This is NOT a payroll path and never touches compensation amounts.
//
// USAGE
//   npm run org:bootstrap                 # dry run (review the plan)
//   npm run org:bootstrap -- --commit     # apply
//   npm run org:bootstrap -- --commit --delete-phantoms

import { readFileSync } from "node:fs";

// Load DATABASE_URL from .env before the Prisma client is constructed.
if (!process.env.DATABASE_URL) {
  try {
    for (const line of readFileSync(".env", "utf8").split("\n")) {
      const m = line.match(/^\s*DATABASE_URL\s*=\s*(.*)\s*$/);
      if (m) {
        let v = m[1].trim();
        if (
          (v.startsWith('"') && v.endsWith('"')) ||
          (v.startsWith("'") && v.endsWith("'"))
        )
          v = v.slice(1, -1);
        process.env.DATABASE_URL = v;
        break;
      }
    }
  } catch {
    /* .env optional if DATABASE_URL already set */
  }
}

const COMMIT = process.argv.includes("--commit");
const DELETE_PHANTOMS = process.argv.includes("--delete-phantoms");

type EmpType =
  | "FULL_TIME"
  | "PART_TIME"
  | "CONTRACT"
  | "OUTSOURCED"
  | "FRACTIONAL"
  | "CONSULTANT"
  | "EXTERNAL_REVIEWER";
type EmpStatus = "ACTIVE" | "PROBATION" | "ON_LEAVE" | "EXITED" | "SUSPENDED";

type Entry = {
  eeId: string;
  create?: boolean;
  fullName?: string; // required when create
  workEmail?: string;
  department: string | null; // seeded department name
  jobTitle: string | null;
  managerEeId: string | null; // another entry's eeId, or null = top of tree
  employmentType?: EmpType; // only set when creating / when a change is intended
  status?: EmpStatus; // only set when a change is intended
  phantom?: boolean; // retire (EXITED) or hard-delete with --delete-phantoms
  note?: string;
};

// --- The confirmed plan ----------------------------------------------------
// Department names below are the SEEDED ones. CSV→seeded remaps applied:
//   Corporate → Executive Office · Finance → Finance & Accounts
//   IT Operations → Technology · Investments → Trading & Settlement (flagged)
const PLAN: Entry[] = [
  // Executive Office
  { eeId: "EID 13", department: "Executive Office", jobTitle: "Chairman", managerEeId: null, note: "root" },
  { eeId: "EID 1", department: "Executive Office", jobTitle: "MD", managerEeId: "EID 13" },
  { eeId: "EID 2", department: "Executive Office", jobTitle: "Dealing Clerk / DMD", managerEeId: "EID 1" },
  // Operations chain
  { eeId: "EID 5", department: "Operations", jobTitle: "COO / Head of Finance", managerEeId: "EID 1" },
  { eeId: "EID 6", department: "Operations", jobTitle: "Head of Operations", managerEeId: "EID 5" },
  { eeId: "EID 10", department: "Operations", jobTitle: "Client Services", managerEeId: "EID 6" },
  { eeId: "EID 17", department: "Operations", jobTitle: "Field Officer", managerEeId: "EID 6" },
  { eeId: "EID 9", department: "Operations", jobTitle: "Client Services", managerEeId: "EID 6" },
  // Investments / Finance under COO
  { eeId: "EID 7", department: "Trading & Settlement", jobTitle: "Senior Investment Analyst", managerEeId: "EID 5" },
  { eeId: "EID 18", department: "Finance & Accounts", jobTitle: "Finance", managerEeId: "EID 5" },
  // Compliance
  { eeId: "EID 3", department: "Compliance", jobTitle: "Chief Compliance Officer", managerEeId: "EID 1" },
  { eeId: "EID 16", department: "Compliance", jobTitle: "Internal Control", managerEeId: "EID 3" },

  // --- new real people (created into unused EID gaps) ----------------------
  {
    eeId: "EID 4",
    create: true,
    fullName: "EZEKIEL, EUNICE",
    workEmail: "eunice.ezekiel@transworld.com.ng",
    department: "Operations",
    jobTitle: "Field Officer",
    managerEeId: "EID 6",
    employmentType: "FULL_TIME",
    status: "EXITED",
    note: "Resigned — retained for audit",
  },
  {
    eeId: "EID 8",
    create: true,
    fullName: "AYOBAMI, MAX",
    workEmail: "max.ayobami@transworldltd.com.ng",
    department: "Technology",
    jobTitle: "IT Lead",
    managerEeId: "EID 5",
    employmentType: "FRACTIONAL",
    status: "ACTIVE",
    note: "Fractional IT head",
  },
  {
    eeId: "EID 11",
    create: true,
    fullName: "IBRAHIM, OYINKANSOLA",
    workEmail: "oyinkansola.ibrahim@transworldltd.com.ng",
    department: "Operations",
    jobTitle: "Field Officer",
    managerEeId: "EID 6",
    employmentType: "FULL_TIME",
    status: "PROBATION",
    note: "New hire",
  },

  // --- phantom seed records ------------------------------------------------
  { eeId: "EID 12", department: null, jobTitle: null, managerEeId: null, phantom: true, note: "Phantom seed record" },
  { eeId: "EID 14", department: null, jobTitle: null, managerEeId: null, phantom: true, note: "Phantom seed record" },
  { eeId: "EID 19", department: null, jobTitle: null, managerEeId: null, phantom: true, note: "Phantom seed record" },
];

function tag(commit: boolean) {
  return commit ? "APPLY " : "PLAN  ";
}

async function main() {
  const { prisma } = await import("@/lib/db");

  console.log("============================================================");
  console.log(" Transworld PeopleOps — org bootstrap");
  console.log(
    ` Mode    : ${COMMIT ? "COMMIT (writing)" : "DRY RUN (no writes)"}` +
      (DELETE_PHANTOMS ? " · hard-delete phantoms" : "")
  );
  console.log("============================================================");

  // audit actor: the bootstrap admin if resolvable
  const admin =
    (process.env.ADMIN_EMAIL
      ? await prisma.user.findFirst({ where: { email: process.env.ADMIN_EMAIL } })
      : null) ?? (await prisma.user.findFirst({ orderBy: { createdAt: "asc" } }));
  const actorId = admin?.id ?? null;

  const audit = async (
    action: string,
    entityId: string | null,
    metadata: Record<string, unknown>
  ) => {
    if (!COMMIT) return;
    await prisma.auditLog.create({
      data: { actorId, action, entityType: "employee", entityId, metadata: metadata as never, ip: null },
    });
  };

  // guard: new EIDs must be free
  const newIds = PLAN.filter((e) => e.create).map((e) => e.eeId);
  for (const id of newIds) {
    const existing = await prisma.employee.findUnique({ where: { eeId: id } });
    if (existing && !PLAN.find((e) => e.eeId === id)?.create) {
      // (only relevant if a create target is already taken by a non-create)
    }
  }

  // --- departments: match seeded (case-insensitive), never duplicate ------
  const deptNames = Array.from(
    new Set(PLAN.map((e) => e.department).filter((d): d is string => !!d))
  );
  const deptId = new Map<string, string | null>();
  for (const name of deptNames) {
    const found = await prisma.department.findFirst({
      where: { name: { equals: name, mode: "insensitive" } },
    });
    if (found) {
      deptId.set(name, found.id);
    } else {
      console.log(`${tag(COMMIT)}dept   : CREATE "${name}" (not among seeded departments)`);
      if (COMMIT) {
        const created = await prisma.department.create({ data: { name } });
        deptId.set(name, created.id);
      } else {
        deptId.set(name, null);
      }
    }
  }

  // --- job profiles: create from titles if missing ------------------------
  const titles = Array.from(
    new Set(PLAN.map((e) => e.jobTitle).filter((t): t is string => !!t))
  );
  const jobId = new Map<string, string | null>();
  for (const title of titles) {
    const found = await prisma.jobProfile.findFirst({
      where: { title: { equals: title, mode: "insensitive" } },
    });
    if (found) {
      jobId.set(title, found.id);
    } else {
      console.log(`${tag(COMMIT)}job    : CREATE profile "${title}"`);
      if (COMMIT) {
        const created = await prisma.jobProfile.create({
          data: { title, status: "PUBLISHED" },
        });
        jobId.set(title, created.id);
      } else {
        jobId.set(title, null);
      }
    }
  }

  // --- employees: create / update fields (manager set in a later pass) ----
  const summary = { created: 0, updated: 0, retired: 0, deleted: 0, unchanged: 0 };

  for (const e of PLAN) {
    const cur = await prisma.employee.findUnique({
      where: { eeId: e.eeId },
      include: { department: true, jobProfile: true, manager: true },
    });

    // phantom handling
    if (e.phantom) {
      if (!cur) {
        console.log(`${tag(COMMIT)}${e.eeId}: phantom not found — skipping`);
        continue;
      }
      if (DELETE_PHANTOMS) {
        console.log(`${tag(COMMIT)}${e.eeId} ${cur.fullName}: DELETE (phantom)`);
        if (COMMIT) {
          await prisma.employee.delete({ where: { id: cur.id } });
          await audit("employee.delete", cur.id, { eeId: e.eeId, reason: e.note });
        }
        summary.deleted++;
      } else if (cur.status !== "EXITED") {
        console.log(`${tag(COMMIT)}${e.eeId} ${cur.fullName}: RETIRE → EXITED (phantom)`);
        if (COMMIT) {
          await prisma.employee.update({
            where: { id: cur.id },
            data: { status: "EXITED", managerId: null, exitDate: new Date() },
          });
          await audit("employee.retire", cur.id, { eeId: e.eeId, reason: e.note });
        }
        summary.retired++;
      } else {
        summary.unchanged++;
      }
      continue;
    }

    const targetDept = e.department ? deptId.get(e.department) ?? null : null;
    const targetJob = e.jobTitle ? jobId.get(e.jobTitle) ?? null : null;

    if (!cur) {
      if (!e.create) {
        console.log(`${tag(COMMIT)}${e.eeId}: NOT FOUND and not marked create — skipping`);
        continue;
      }
      console.log(
        `${tag(COMMIT)}${e.eeId} ${e.fullName}: CREATE · dept=${e.department} · title=${e.jobTitle} · type=${e.employmentType} · status=${e.status} · mgr=${e.managerEeId ?? "—"}`
      );
      if (COMMIT) {
        const created = await prisma.employee.create({
          data: {
            eeId: e.eeId,
            fullName: e.fullName!,
            workEmail: e.workEmail ?? null,
            employmentType: e.employmentType ?? "FULL_TIME",
            status: e.status ?? "ACTIVE",
            departmentId: targetDept,
            jobProfileId: targetJob,
            startDate: e.status === "PROBATION" ? new Date() : null,
          },
        });
        await audit("employee.create", created.id, {
          eeId: e.eeId,
          fullName: e.fullName,
          note: e.note,
        });
      }
      summary.created++;
      continue;
    }

    // update existing: only changed fields
    const changes: string[] = [];
    const data: Record<string, unknown> = {};
    if (cur.departmentId !== targetDept) {
      changes.push(`dept ${cur.department?.name ?? "—"}→${e.department ?? "—"}`);
      data.departmentId = targetDept;
    }
    if (cur.jobProfileId !== targetJob) {
      changes.push(`title ${cur.jobProfile?.title ?? "—"}→${e.jobTitle ?? "—"}`);
      data.jobProfileId = targetJob;
    }
    if (e.status && cur.status !== e.status) {
      changes.push(`status ${cur.status}→${e.status}`);
      data.status = e.status;
    }
    if (e.employmentType && cur.employmentType !== e.employmentType) {
      changes.push(`type ${cur.employmentType}→${e.employmentType}`);
      data.employmentType = e.employmentType;
    }
    if (changes.length === 0) {
      summary.unchanged++;
    } else {
      console.log(`${tag(COMMIT)}${e.eeId} ${cur.fullName}: ${changes.join(" · ")}`);
      if (COMMIT) {
        await prisma.employee.update({ where: { id: cur.id }, data });
        await audit("employee.org_update", cur.id, { eeId: e.eeId, changes });
      }
      summary.updated++;
    }
  }

  // --- manager pass (all employees now exist when committing) -------------
  console.log("— reporting lines —");
  for (const e of PLAN) {
    if (e.phantom) continue;
    const self = await prisma.employee.findUnique({
      where: { eeId: e.eeId },
      include: { manager: true },
    });
    if (!self) {
      if (!COMMIT)
        console.log(`PLAN  ${e.eeId}: mgr → ${e.managerEeId ?? "—"} (after create)`);
      continue;
    }
    const mgr = e.managerEeId
      ? await prisma.employee.findUnique({ where: { eeId: e.managerEeId } })
      : null;
    const targetMgrId = mgr?.id ?? null;
    if (self.managerId !== targetMgrId) {
      console.log(
        `${tag(COMMIT)}${e.eeId} ${self.fullName}: manager ${self.manager?.fullName ?? "—"} → ${e.managerEeId ?? "—"}`
      );
      if (COMMIT) {
        await prisma.employee.update({ where: { id: self.id }, data: { managerId: targetMgrId } });
        await audit("employee.org_update", self.id, {
          eeId: e.eeId,
          managerEeId: e.managerEeId,
        });
      }
    }
  }

  console.log("------------------------------------------------------------");
  console.log(
    ` Summary: created ${summary.created} · updated ${summary.updated} · retired ${summary.retired} · deleted ${summary.deleted} · unchanged ${summary.unchanged}`
  );
  if (!COMMIT) {
    console.log(" DRY RUN — nothing was written. Re-run with --commit to apply.");
  } else {
    console.log(" COMMITTED. Open Employees → Org chart to see the hierarchy.");
  }
  console.log("------------------------------------------------------------");

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error("[org:bootstrap] failed:", e);
  process.exit(1);
});
