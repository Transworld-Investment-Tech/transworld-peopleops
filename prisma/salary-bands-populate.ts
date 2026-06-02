// prisma/salary-bands-populate.ts — seed the WS6 grade bands (G0–G5) into salary_bands.
// Idempotent upsert by grade. DRY-RUN by default; apply with `-- --commit`.
//   npm run salary-bands:populate            (dry run)
//   npm run salary-bands:populate -- --commit (apply)
import { prisma } from "../lib/db";

const COMMIT = process.argv.includes("--commit");

// WS6 — Compensation, Benefits & Payroll, Part 1. Monthly, full-time gross bands.
const BANDS = [
  { grade: "G0", label: "Intern / NYSC", minAmount: 30000, midpoint: 50000, maxAmount: 70000, sortOrder: 0 },
  { grade: "G1", label: "Entry / Support", minAmount: 80000, midpoint: 115000, maxAmount: 150000, sortOrder: 1 },
  { grade: "G2", label: "Associate", minAmount: 130000, midpoint: 165000, maxAmount: 200000, sortOrder: 2 },
  { grade: "G3", label: "Senior / Specialist", minAmount: 180000, midpoint: 225000, maxAmount: 270000, sortOrder: 3 },
  { grade: "G4", label: "Manager / Principal", minAmount: 250000, midpoint: 365000, maxAmount: 480000, sortOrder: 4 },
  { grade: "G5", label: "Head / Executive", minAmount: 330000, midpoint: 425000, maxAmount: 520000, sortOrder: 5 },
];

async function main() {
  console.log(`Salary bands populate — ${COMMIT ? "COMMIT" : "DRY RUN"}`);
  for (const b of BANDS) {
    const existing = await prisma.salaryBand.findUnique({ where: { grade: b.grade } });
    const verb = existing ? "update" : "create";
    console.log(`  ${verb.padEnd(6)} ${b.grade}  ${b.label.padEnd(22)} ₦${b.minAmount.toLocaleString()} / ₦${b.midpoint.toLocaleString()} / ₦${b.maxAmount.toLocaleString()}`);
    if (COMMIT) {
      await prisma.salaryBand.upsert({
        where: { grade: b.grade },
        update: { label: b.label, minAmount: b.minAmount, midpoint: b.midpoint, maxAmount: b.maxAmount, sortOrder: b.sortOrder },
        create: { grade: b.grade, label: b.label, minAmount: b.minAmount, midpoint: b.midpoint, maxAmount: b.maxAmount, sortOrder: b.sortOrder },
      });
    }
  }
  console.log(COMMIT ? "Done — bands written." : "Dry run only. Re-run with `-- --commit` to apply.");
  await prisma.$disconnect();
}
main().catch(async (e) => { console.error(e); await prisma.$disconnect(); process.exit(1); });
