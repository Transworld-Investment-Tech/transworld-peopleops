// Transworld PeopleOps — Job & Competency populate (idempotent, dry-run first).
//
// Fills in the framework that v0.7.0 surfaces but ships empty:
//   • creates a competency catalog (grouped by category)
//   • sets each job profile's GRADE and DEPARTMENT
//   • attaches each profile's REQUIRED COMPETENCIES at a target level (1–5)
//
// SAFETY (mirrors prisma/org-bootstrap.ts):
//   • DEFAULT = DRY RUN. Prints the full plan and writes NOTHING.
//   • Add `--commit` to apply. Re-running converges to the same state
//     (idempotent): unchanged fields are skipped and not re-audited.
//   • NON-DESTRUCTIVE: only creates/updates. It never deletes competencies and
//     never removes a competency you attached yourself in the UI — it only
//     ensures the ones listed here exist at the listed level.
//   • Every write is recorded in audit_logs. Never touches compensation or .env.
//
// USAGE (run from the repo root):
//   npx tsx prisma/jobframework-populate.ts                # dry run (review)
//   npx tsx prisma/jobframework-populate.ts -- --commit    # apply
//   (or without the `--`:  npx tsx prisma/jobframework-populate.ts --commit )

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

// ---------------------------------------------------------------------------
// 1) Competency catalog (name is unique; category is free text)
// ---------------------------------------------------------------------------
const CATALOG: { name: string; category: string }[] = [
  // Leadership & Governance
  { name: "Strategic leadership", category: "Leadership & Governance" },
  { name: "Corporate governance", category: "Leadership & Governance" },
  { name: "People management", category: "Leadership & Governance" },
  // Regulatory & Compliance
  { name: "SEC & NGX regulations", category: "Regulatory & Compliance" },
  { name: "AML / CFT & KYC", category: "Regulatory & Compliance" },
  { name: "Regulatory reporting", category: "Regulatory & Compliance" },
  { name: "Risk management", category: "Regulatory & Compliance" },
  // Investment & Markets
  { name: "Equity research & valuation", category: "Investment & Markets" },
  { name: "Portfolio management", category: "Investment & Markets" },
  { name: "Trade execution & settlement", category: "Investment & Markets" },
  { name: "Market analysis", category: "Investment & Markets" },
  // Client & Advisory
  { name: "Client relationship management", category: "Client & Advisory" },
  { name: "Client onboarding & KYC", category: "Client & Advisory" },
  { name: "Investment advisory", category: "Client & Advisory" },
  // Finance & Accounting
  { name: "Financial accounting & reporting", category: "Finance & Accounting" },
  { name: "Treasury & reconciliation", category: "Finance & Accounting" },
  { name: "Budgeting & planning", category: "Finance & Accounting" },
  // Operations & Controls
  { name: "Operations management", category: "Operations & Controls" },
  { name: "Process documentation", category: "Operations & Controls" },
  { name: "Internal controls & audit", category: "Operations & Controls" },
  // Technology
  { name: "IT systems & security", category: "Technology" },
  { name: "Data protection (NDPR)", category: "Technology" },
];

// ---------------------------------------------------------------------------
// 2) Per-profile grade + department + required competencies (with levels 1–5).
//    Titles match the 12 seeded job profiles. Department names match the seeded
//    departments (resolved case-insensitively; the script will not create new
//    departments — it warns if one is missing).
// ---------------------------------------------------------------------------
type Req = { name: string; level: number };
type ProfilePlan = {
  title: string;
  grade: string;
  department: string;
  competencies: Req[];
};

const PROFILES: ProfilePlan[] = [
  {
    title: "Chairman",
    grade: "G5",
    department: "Executive Office",
    competencies: [
      { name: "Strategic leadership", level: 5 },
      { name: "Corporate governance", level: 5 },
      { name: "SEC & NGX regulations", level: 4 },
      { name: "Risk management", level: 4 },
      { name: "People management", level: 4 },
    ],
  },
  {
    title: "MD",
    grade: "G5",
    department: "Executive Office",
    competencies: [
      { name: "Strategic leadership", level: 5 },
      { name: "People management", level: 5 },
      { name: "Corporate governance", level: 4 },
      { name: "SEC & NGX regulations", level: 4 },
      { name: "Risk management", level: 4 },
      { name: "Investment advisory", level: 4 },
    ],
  },
  {
    title: "Dealing Clerk / DMD",
    grade: "G4",
    department: "Executive Office",
    competencies: [
      { name: "Trade execution & settlement", level: 5 },
      { name: "SEC & NGX regulations", level: 4 },
      { name: "Market analysis", level: 4 },
      { name: "Equity research & valuation", level: 3 },
      { name: "Client relationship management", level: 3 },
    ],
  },
  {
    title: "COO / Head of Finance",
    grade: "G4",
    department: "Operations",
    competencies: [
      { name: "Operations management", level: 5 },
      { name: "Financial accounting & reporting", level: 4 },
      { name: "Treasury & reconciliation", level: 4 },
      { name: "Risk management", level: 4 },
      { name: "People management", level: 4 },
      { name: "Strategic leadership", level: 3 },
    ],
  },
  {
    title: "Head of Operations",
    grade: "G4",
    department: "Operations",
    competencies: [
      { name: "Operations management", level: 5 },
      { name: "Process documentation", level: 4 },
      { name: "People management", level: 4 },
      { name: "Internal controls & audit", level: 3 },
      { name: "Client relationship management", level: 3 },
    ],
  },
  {
    title: "Client Services",
    grade: "G2",
    department: "Operations",
    competencies: [
      { name: "Client relationship management", level: 4 },
      { name: "Client onboarding & KYC", level: 4 },
      { name: "Investment advisory", level: 3 },
      { name: "SEC & NGX regulations", level: 2 },
    ],
  },
  {
    title: "Field Officer",
    grade: "G1",
    department: "Operations",
    competencies: [
      { name: "Client relationship management", level: 3 },
      { name: "Client onboarding & KYC", level: 3 },
      { name: "AML / CFT & KYC", level: 2 },
      { name: "Market analysis", level: 2 },
    ],
  },
  {
    title: "Senior Investment Analyst",
    grade: "G3",
    department: "Trading & Settlement",
    competencies: [
      { name: "Equity research & valuation", level: 5 },
      { name: "Market analysis", level: 5 },
      { name: "Portfolio management", level: 4 },
      { name: "Investment advisory", level: 4 },
      { name: "Trade execution & settlement", level: 3 },
    ],
  },
  {
    title: "Finance",
    grade: "G3",
    department: "Finance & Accounts",
    competencies: [
      { name: "Financial accounting & reporting", level: 5 },
      { name: "Treasury & reconciliation", level: 4 },
      { name: "Budgeting & planning", level: 4 },
      { name: "Regulatory reporting", level: 3 },
    ],
  },
  {
    title: "Chief Compliance Officer",
    grade: "G4",
    department: "Compliance",
    competencies: [
      { name: "SEC & NGX regulations", level: 5 },
      { name: "AML / CFT & KYC", level: 5 },
      { name: "Regulatory reporting", level: 5 },
      { name: "Internal controls & audit", level: 4 },
      { name: "Corporate governance", level: 4 },
      { name: "Risk management", level: 4 },
    ],
  },
  {
    title: "Internal Control",
    grade: "G3",
    department: "Compliance",
    competencies: [
      { name: "Internal controls & audit", level: 5 },
      { name: "Risk management", level: 4 },
      { name: "Process documentation", level: 4 },
      { name: "AML / CFT & KYC", level: 3 },
      { name: "Regulatory reporting", level: 3 },
    ],
  },
  {
    title: "IT Lead",
    grade: "G3",
    department: "Technology",
    competencies: [
      { name: "IT systems & security", level: 5 },
      { name: "Data protection (NDPR)", level: 4 },
      { name: "Process documentation", level: 3 },
      { name: "Risk management", level: 2 },
    ],
  },
];

function tag() {
  return COMMIT ? "APPLY " : "PLAN  ";
}

async function main() {
  const { prisma } = await import("@/lib/db");

  console.log("============================================================");
  console.log(" Transworld PeopleOps — Job & Competency populate");
  console.log(` Mode    : ${COMMIT ? "COMMIT (writing)" : "DRY RUN (no writes)"}`);
  console.log("============================================================");

  const admin =
    (process.env.ADMIN_EMAIL
      ? await prisma.user.findFirst({ where: { email: process.env.ADMIN_EMAIL } })
      : null) ?? (await prisma.user.findFirst({ orderBy: { createdAt: "asc" } }));
  const actorId = admin?.id ?? null;

  const audit = async (
    action: string,
    entityType: string,
    entityId: string | null,
    metadata: Record<string, unknown>
  ) => {
    if (!COMMIT) return;
    await prisma.auditLog.create({
      data: { actorId, action, entityType, entityId, metadata: metadata as never, ip: null },
    });
  };

  const summary = {
    competenciesCreated: 0,
    competenciesUnchanged: 0,
    profilesUpdated: 0,
    profilesUnchanged: 0,
    linksAdded: 0,
    linksRelevelled: 0,
    linksUnchanged: 0,
  };

  // --- 1) competency catalog (upsert by unique name) ----------------------
  console.log("— competency catalog —");
  const compId = new Map<string, string>();
  for (const c of CATALOG) {
    const existing = await prisma.competency.findFirst({
      where: { name: { equals: c.name, mode: "insensitive" } },
    });
    if (existing) {
      compId.set(c.name, existing.id);
      summary.competenciesUnchanged++;
    } else {
      console.log(`${tag()}competency: CREATE "${c.name}"  [${c.category}]`);
      if (COMMIT) {
        const created = await prisma.competency.create({
          data: { name: c.name, category: c.category },
        });
        compId.set(c.name, created.id);
        await audit("competency.create", "competency", created.id, {
          name: c.name,
          category: c.category,
        });
      }
      summary.competenciesCreated++;
    }
  }

  // --- 2) profiles: grade + department + required competencies ------------
  console.log("— job profiles —");
  for (const p of PROFILES) {
    const profile = await prisma.jobProfile.findFirst({
      where: { title: { equals: p.title, mode: "insensitive" } },
    });
    if (!profile) {
      console.log(`${tag()}${p.title}: NOT FOUND — skipping`);
      continue;
    }

    // resolve department by name (do not create — these are seeded)
    let deptId: string | null = null;
    const dept = await prisma.department.findFirst({
      where: { name: { equals: p.department, mode: "insensitive" } },
    });
    if (dept) {
      deptId = dept.id;
    } else {
      console.log(`${tag()}${p.title}: department "${p.department}" not found — leaving department unset`);
    }

    // scalar changes (grade / department)
    const data: Record<string, unknown> = {};
    const changes: string[] = [];
    if (profile.grade !== p.grade) {
      changes.push(`grade ${profile.grade ?? "—"}→${p.grade}`);
      data.grade = p.grade;
    }
    if (deptId !== null && profile.departmentId !== deptId) {
      changes.push(`department →${p.department}`);
      data.departmentId = deptId;
    }
    if (Object.keys(data).length > 0) {
      console.log(`${tag()}${p.title}: ${changes.join(" · ")}`);
      if (COMMIT) {
        await prisma.jobProfile.update({ where: { id: profile.id }, data });
        await audit("jobprofile.update", "job_profile", profile.id, { title: p.title, changes });
      }
      summary.profilesUpdated++;
    } else {
      summary.profilesUnchanged++;
    }

    // competency links (ensure listed; never remove)
    const linkSummary: string[] = [];
    for (const req of p.competencies) {
      const cid =
        compId.get(req.name) ??
        (await prisma.competency.findFirst({
          where: { name: { equals: req.name, mode: "insensitive" } },
        }))?.id ??
        null;
      if (!cid) {
        // Only happens in DRY RUN, where the competency hasn't been created yet.
        linkSummary.push(`${req.name}@${req.level} (after catalog create)`);
        summary.linksAdded++;
        continue;
      }
      const existingLink = await prisma.jobProfileCompetency.findUnique({
        where: { jobProfileId_competencyId: { jobProfileId: profile.id, competencyId: cid } },
      });
      if (!existingLink) {
        linkSummary.push(`+${req.name}@${req.level}`);
        if (COMMIT) {
          await prisma.jobProfileCompetency.create({
            data: { jobProfileId: profile.id, competencyId: cid, level: req.level },
          });
        }
        summary.linksAdded++;
      } else if (existingLink.level !== req.level) {
        linkSummary.push(`${req.name} ${existingLink.level}→${req.level}`);
        if (COMMIT) {
          await prisma.jobProfileCompetency.update({
            where: { jobProfileId_competencyId: { jobProfileId: profile.id, competencyId: cid } },
            data: { level: req.level },
          });
        }
        summary.linksRelevelled++;
      } else {
        summary.linksUnchanged++;
      }
    }
    if (linkSummary.length > 0) {
      console.log(`${tag()}${p.title}: competencies ${linkSummary.join(", ")}`);
      await audit("jobprofile.competencies", "job_profile", profile.id, {
        title: p.title,
        changes: linkSummary,
      });
    }
  }

  console.log("------------------------------------------------------------");
  console.log(
    ` Competencies: +${summary.competenciesCreated} created · ${summary.competenciesUnchanged} existing`
  );
  console.log(
    ` Profiles    : ${summary.profilesUpdated} updated · ${summary.profilesUnchanged} unchanged`
  );
  console.log(
    ` Links       : +${summary.linksAdded} added · ${summary.linksRelevelled} re-levelled · ${summary.linksUnchanged} unchanged`
  );
  if (!COMMIT) {
    console.log(" DRY RUN — nothing was written. Re-run with --commit to apply.");
  } else {
    console.log(" COMMITTED. Open Job & Competency to see grades, departments, and competencies.");
  }
  console.log("------------------------------------------------------------");

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error("[jobframework:populate] failed:", e);
  process.exit(1);
});
