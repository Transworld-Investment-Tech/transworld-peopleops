// prisma/ws2_role_reconciliation.ts
// One-time WS2 role / family reconciliation (Alignment Note item 5 + the canonical model).
// Sets each job profile's TITLE, reference GRADE, FAMILY, control-function flag, and (for the
// Investment Analyst) RUNG. It deliberately does NOT set TRACK — Manager vs Expert is the
// individual's choice at G3, set per person in the Job & Competency editor.
//
//   npx tsx prisma/ws2_role_reconciliation.ts            # DRY RUN — prints the diff, changes nothing
//   npx tsx prisma/ws2_role_reconciliation.ts --commit   # applies the changes
//
// Idempotent: each entry matches on the old OR new title, so re-running after --commit is a no-op.
//
// NOTE 1 (grade): grade currently lives on the job profile, so changing it here changes the grade
//   of whoever holds that role. True person-level grade (Alignment Note item 8) is a later build.
// NOTE 2 (red-circle): moving Investment Analyst to G2 will likely show the incumbent ABOVE the G2
//   band on Positioning. That is the intended red-circle state — this script does NOT touch pay.
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
const COMMIT = process.argv.includes("--commit");

type Role = {
  match: string[]; // current title(s) to match, case-insensitive (old or new)
  title: string;
  grade: string;
  family: "BUSINESS_DEVELOPMENT" | "INVESTMENTS" | "CONTROL_OPERATIONS" | "LEADERSHIP";
  control: boolean;
  rung: "JUNIOR" | "MID" | "SENIOR" | null;
};

const ROLES: Role[] = [
  { match: ["Chairman"], title: "Chairman", grade: "G5", family: "LEADERSHIP", control: false, rung: null },
  { match: ["MD"], title: "MD", grade: "G5", family: "LEADERSHIP", control: false, rung: null },
  { match: ["COO / Head of Finance", "COO"], title: "COO", grade: "G3", family: "LEADERSHIP", control: false, rung: null },
  { match: ["Finance", "Head of Finance"], title: "Head of Finance", grade: "G3", family: "CONTROL_OPERATIONS", control: true, rung: null },
  { match: ["Head of Operations"], title: "Head of Operations", grade: "G3", family: "CONTROL_OPERATIONS", control: false, rung: null },
  { match: ["Chief Compliance Officer"], title: "Chief Compliance Officer", grade: "G4", family: "CONTROL_OPERATIONS", control: true, rung: null },
  { match: ["Internal Control"], title: "Internal Control", grade: "G3", family: "CONTROL_OPERATIONS", control: true, rung: null },
  { match: ["IT Lead"], title: "IT Lead", grade: "G3", family: "CONTROL_OPERATIONS", control: false, rung: null },
  { match: ["Dealing Clerk / DMD", "Dealing Clerk/DMD"], title: "Dealing Clerk / DMD", grade: "G4", family: "INVESTMENTS", control: false, rung: null },
  { match: ["Senior Investment Analyst", "Investment Analyst"], title: "Investment Analyst", grade: "G2", family: "INVESTMENTS", control: false, rung: "SENIOR" },
  { match: ["Client Services"], title: "Client Services", grade: "G2", family: "BUSINESS_DEVELOPMENT", control: false, rung: null },
  { match: ["Field Officer"], title: "Field Officer", grade: "G1", family: "BUSINESS_DEVELOPMENT", control: false, rung: null },
];

async function main() {
  console.log(COMMIT ? "=== WS2 role reconciliation: APPLYING (--commit) ===\n" : "=== WS2 role reconciliation: DRY RUN (no --commit) ===\n");
  const profiles = await prisma.jobProfile.findMany();
  let matched = 0;
  let changed = 0;
  const unmatched: string[] = [];
  const seen = new Set<string>();

  for (const r of ROLES) {
    const p = profiles.find((x) => r.match.some((m) => x.title.trim().toLowerCase() === m.trim().toLowerCase()));
    if (!p) { unmatched.push(r.match[0]); continue; }
    matched++;
    seen.add(p.id);

    const diffs: string[] = [];
    if (p.title !== r.title) diffs.push(`title:      "${p.title}" -> "${r.title}"`);
    if ((p.grade ?? null) !== r.grade) diffs.push(`grade:      ${p.grade ?? "—"} -> ${r.grade}`);
    if ((p.family ?? null) !== r.family) diffs.push(`family:     ${p.family ?? "—"} -> ${r.family}`);
    if (p.isControlFunction !== r.control) diffs.push(`control-fn: ${p.isControlFunction} -> ${r.control}`);
    if ((p.rung ?? null) !== r.rung) diffs.push(`rung:       ${p.rung ?? "—"} -> ${r.rung ?? "—"}`);

    if (diffs.length === 0) {
      console.log(`  =  ${p.title.padEnd(28)} no change`);
      continue;
    }
    changed++;
    console.log(`  ~  ${r.title}`);
    for (const d of diffs) console.log(`        ${d}`);

    if (COMMIT) {
      await prisma.jobProfile.update({
        where: { id: p.id },
        data: {
          title: r.title,
          grade: r.grade,
          family: r.family,
          isControlFunction: r.control,
          rung: r.rung,
          // track is intentionally NOT set — it is the individual's G3 choice.
        },
      });
    }
  }

  // Profiles in the portal that this script didn't touch (so you can spot anything new/unexpected).
  const untouched = profiles.filter((p) => !seen.has(p.id)).map((p) => p.title);

  console.log(`\nMatched ${matched}/${ROLES.length} expected roles; ${changed} have changes.`);
  if (unmatched.length) console.log(`NOT FOUND in portal (check titles): ${unmatched.join(", ")}`);
  if (untouched.length) console.log(`Portal profiles NOT in this script (left as-is): ${untouched.join(", ")}`);
  console.log(COMMIT ? "\nApplied. Set each role's track (Manager/Expert) per person in the editor." : "\nDry run only — re-run with --commit to apply.");
}

main()
  .catch((e) => { console.error(e); process.exitCode = 1; })
  .finally(() => prisma.$disconnect());
