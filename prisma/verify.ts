/**
 * Read-only database check (v0.1.2).
 * Connects using DATABASE_URL and prints row counts. Writes NOTHING.
 * Expected after the Supabase seed: employees=15, compensation_profiles=15, tax_bands=6.
 */
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const [employees, comp, bands] = await Promise.all([
    prisma.employee.count(),
    prisma.compensationProfile.count(),
    prisma.taxBand.count(),
  ]);

  console.log("Connected to the database. Row counts:");
  console.log("  employees             :", employees);
  console.log("  compensation_profiles :", comp);
  console.log("  tax_bands             :", bands);

  if (employees === 15 && comp === 15 && bands >= 6) {
    console.log("\n\u2705 Looks good \u2014 schema matches and seed data is present.");
  } else if (employees === 0 && comp === 0 && bands === 0) {
    console.log("\n\u26A0 All counts are 0. The connection works but the tables are empty \u2014");
    console.log("  the app is probably pointing at the wrong database/project.");
  } else {
    console.log("\n\u26A0 Counts differ from the expected 15 / 15 / 6.");
    console.log("  Fine if you intentionally changed data; investigate if unexpected.");
  }
}

main()
  .catch((e) => {
    console.error("\n\u274C DB check failed:", e?.message ?? e);
    console.error("  Check DATABASE_URL in .env (password, ?pgbouncer=true, correct host).");
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
