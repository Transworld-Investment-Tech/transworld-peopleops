// prisma/restructure-2026-populate.ts — Job Family Restructure data migration.
//
// Reassigns job_profiles.family per the firm-wide restructure
// (PORTAL_ALIGNMENT_Job_Family_Restructure_v1.0). family is a property of the
// ROLE; employees inherit it through their job_profile, so the ONLY live write
// here is `update job_profiles set family = ...`.
//
// SAFETY (standing build discipline):
//   * DEFAULT = DRY RUN. Prints the full plan and writes NOTHING.
//   * --commit applies it. HOLD --commit until RemCom ratification is confirmed.
//   * NEVER touches grade, pay, salary_bands, competencies, or department.
//   * NEVER moves a control-function profile (those stay Control & Operations);
//     they are reported as skipped.
//   * Moves are positive-match only: a profile changes family ONLY when a rule
//     matches its title. Everything unmatched stays exactly where it is.
//   * Brand-new roles (Marketing & Comms / Procurement / People-Ops & HR) are
//     NOT auto-created here — creating a profile is a content decision (grade,
//     track, competencies). If none exists, the dry run flags it for the
//     Job & Competency UI (or extend seed_ws7_role_matrix.sql).
//   * Every write is recorded in audit_logs.
//
// USAGE (from the repo root, AFTER 0033 is applied so the CHECK allows ADM):
//   npx tsx prisma/restructure-2026-populate.ts             # dry run (review)
//   npx tsx prisma/restructure-2026-populate.ts -- --commit # apply (held)

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

import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

const COMMIT = process.argv.includes("--commit");

// Canonical family values (must match 0033 + lib/jobframework-vocab.ts).
const BD = "BUSINESS_DEVELOPMENT";
const ADM = "ADMIN_CORPORATE_SERVICES";

// Ordered move rules. First match wins. Title-keyword based; reviewed in dry run.
// Control-function profiles are excluded before these rules are consulted.
const MOVE_RULES: { test: RegExp; family: string; why: string }[] = [
  { test: /\bmarket(ing)?\b|comms?\b|communicat/i, family: BD, why: "Marketing & Communications -> Business Development" },
  { test: /procure|vendor|purchas/i, family: ADM, why: "Procurement & Vendor Management -> ADM" },
  { test: /facilit|office admin|office manage|administrat/i, family: ADM, why: "Facilities / Office Administration -> ADM" },
  { test: /\bh\.?r\.?\b|human resource|people ops|people operation|peopleops/i, family: ADM, why: "HR / People Operations -> ADM" },
];

// Roles we EXPECT to land in a new family; used only to warn if none is found.
const EXPECTED = [
  { label: "Marketing & Communications", test: /\bmarket(ing)?\b|comms?\b|communicat/i },
  { label: "Procurement & Vendor Management", test: /procure|vendor|purchas/i },
  { label: "People Operations / HR", test: /\bh\.?r\.?\b|human resource|people ops|people operation/i },
];

const FAMILY_LABEL: Record<string, string> = {
  BUSINESS_DEVELOPMENT: "Business Development",
  INVESTMENTS: "Investments",
  CONTROL_OPERATIONS: "Control & Operations",
  ADMIN_CORPORATE_SERVICES: "Administration & Corporate Services",
  LEADERSHIP: "Leadership",
};
const fam = (v: string | null) => (v ? FAMILY_LABEL[v] ?? v : "(none)");

async function main() {
  const admin =
    (await prisma.user.findFirst({ orderBy: { createdAt: "asc" } })) ?? null;
  const actorId = admin?.id ?? null;

  const profiles = await prisma.jobProfile.findMany({
    select: {
      id: true,
      title: true,
      grade: true,
      family: true,
      isControlFunction: true,
      _count: { select: { employees: true } },
    },
    orderBy: [{ title: "asc" }],
  });

  type Plan = { id: string; title: string; grade: string | null; from: string | null; to: string; holders: number };
  const moves: Plan[] = [];
  const cfSkips: { title: string; family: string | null }[] = [];
  const stays: { title: string; family: string | null }[] = [];

  for (const p of profiles) {
    if (p.isControlFunction) {
      // Control functions never move on this restructure.
      cfSkips.push({ title: p.title, family: p.family });
      continue;
    }
    const rule = MOVE_RULES.find((r) => r.test.test(p.title));
    if (rule && rule.family !== p.family) {
      moves.push({ id: p.id, title: p.title, grade: p.grade, from: p.family, to: rule.family, holders: p._count.employees });
    } else {
      stays.push({ title: p.title, family: p.family });
    }
  }

  // ---- Report -------------------------------------------------------------
  console.log(`\n=== Job Family Restructure 2026 — ${COMMIT ? "COMMIT" : "DRY RUN"} ===\n`);

  console.log(`Profiles examined: ${profiles.length}`);
  console.log(`Proposed family moves: ${moves.length}`);
  console.log(`Control-function profiles (never moved): ${cfSkips.length}`);
  console.log(`Profiles staying as-is: ${stays.length}\n`);

  if (moves.length) {
    console.log("PROPOSED MOVES (job_profiles.family only — no grade/pay change):");
    for (const m of moves) {
      console.log(
        `  - ${m.title} [${m.grade ?? "—"}]  ${fam(m.from)}  ->  ${fam(m.to)}   (holders: ${m.holders})`,
      );
    }
    console.log("");
  }

  if (cfSkips.length) {
    console.log("CONTROL-FUNCTION PROFILES (untouched, stay Control & Operations):");
    for (const c of cfSkips) console.log(`  - ${c.title}  [${fam(c.family)}]`);
    console.log("");
  }

  // Warn if an expected new-family role has no matching profile at all.
  for (const e of EXPECTED) {
    const any = profiles.some((p) => e.test.test(p.title));
    if (!any) {
      console.log(`  ! No profile found for "${e.label}". Create it in the Job & Competency UI`);
      console.log(`    (or extend seed_ws7_role_matrix.sql) with the correct family, then re-run.`);
    }
  }
  console.log("");

  if (!COMMIT) {
    console.log("DRY RUN — nothing written. Re-run with `-- --commit` to apply (held for RemCom).\n");
    await prisma.$disconnect();
    return;
  }

  // ---- Commit (family only; audited) -------------------------------------
  let applied = 0;
  for (const m of moves) {
    await prisma.jobProfile.update({ where: { id: m.id }, data: { family: m.to } });
    await prisma.auditLog.create({
      data: {
        actorId,
        action: "jobprofile.family.restructure_2026",
        entityType: "job_profile",
        entityId: m.id,
        metadata: { title: m.title, from: m.from, to: m.to, holders: m.holders } as never,
        ip: null,
      },
    });
    applied++;
  }
  console.log(`COMMITTED ${applied} family move(s). Grades, pay, and competencies untouched.\n`);
  await prisma.$disconnect();
}

main().catch(async (e) => {
  console.error(e);
  await prisma.$disconnect();
  process.exit(1);
});
