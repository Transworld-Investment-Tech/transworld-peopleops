import { PrismaClient, EmploymentType, EmploymentStatus, TaxTreatment } from "@prisma/client";
const prisma = new PrismaClient();

async function main() {
  // Roles
  const roles = [
    ["SUPER_ADMIN", "Super Admin"], ["EXEC", "Executive Management"],
    ["HR_ADMIN", "HR Admin"], ["FINANCE", "Finance / Payroll"],
    ["COMPLIANCE", "Compliance Officer"], ["INTERNAL_CONTROL", "Internal Control / Risk"],
    ["MANAGER", "Line Manager"], ["EMPLOYEE", "Employee"], ["AUDITOR_RO", "External Auditor (read-only)"],
  ];
  for (const [key, name] of roles)
    await prisma.role.upsert({ where: { key }, update: { name }, create: { key, name } });

  // Pay categories (from the real sheet)
  const cats = [["Advisory", "ADV"], ["Core", "CORE"], ["Investment", "INV"], ["Part-Time", "PT"]];
  const catMap: Record<string, string> = {};
  for (const [name, code] of cats) {
    const c = await prisma.payCategory.upsert({ where: { code }, update: { name }, create: { name, code } });
    catMap[name] = c.id;
  }

  // Entity + departments
  const entity = await prisma.entity.upsert({
    where: { code: "TISL" },
    update: {}, create: { name: "Transworld Investment and Securities Limited", code: "TISL" },
  });
  const deptNames = ["Executive Office", "Compliance", "Operations", "Finance & Accounts",
    "Client Operations", "Business Development", "Trading & Settlement", "Technology"];
  for (const name of deptNames) {
    const exists = await prisma.department.findFirst({ where: { name } });
    if (!exists) await prisma.department.create({ data: { name } });
  }

  // Tax rule set — Nigeria PIT 2026 (NTA 2025). VERIFY bands with a tax advisor.
  const existing = await prisma.taxRuleSet.findFirst({ where: { name: "Nigeria PIT 2026 (NTA 2025)" } });
  if (!existing) {
    await prisma.taxRuleSet.create({
      data: {
        name: "Nigeria PIT 2026 (NTA 2025)",
        effectiveFrom: new Date("2026-01-01"),
        exemptThresholdAnnual: 800000,
        pensionEmployeeRate: 0.08,
        pensionEmployerRate: 0.10,
        nhfRate: 0.025,
        rentReliefRate: 0.20,
        rentReliefCapAnnual: 500000,
        pensionOnBasicOnly: true,
        isActive: true,
        bands: {
          create: [
            { sequence: 1, lowerBound: 0,         upperBound: 800000,   rate: 0.00 },
            { sequence: 2, lowerBound: 800000,    upperBound: 3000000,  rate: 0.15 },
            { sequence: 3, lowerBound: 3000000,   upperBound: 12000000, rate: 0.18 },
            { sequence: 4, lowerBound: 12000000,  upperBound: 25000000, rate: 0.21 },
            { sequence: 5, lowerBound: 25000000,  upperBound: 50000000, rate: 0.23 },
            { sequence: 6, lowerBound: 50000000,  upperBound: null,     rate: 0.25 },
          ],
        },
      },
    });
  }

  // Employees + standing compensation inputs (from September 2025 control sheet)
  type Row = [string, string, string, EmploymentType, TaxTreatment, number, number, number];
  const F = EmploymentType.FULL_TIME, P = EmploymentType.PART_TIME, C = EmploymentType.CONSULTANT;
  const PAYE = TaxTreatment.PAYE, EX = TaxTreatment.EXEMPT, FLAT = TaxTreatment.FLAT_RATE;
  const rows: Row[] = [
    // eeId, name, category, type, tax, basic, utility, quarterly
    ["EID 7",  "EZEH, DANIEL EKPEREAMAKA",        "Advisory",   F, PAYE, 93333.33, 46666.67, 140000],
    ["EID 2",  "AMAMCHUKWU, NKEMAKOLAM",          "Core",       F, PAYE, 100000,   0,        0],
    ["EID 6",  "ASHOFOR, FLORENCE ESHE",          "Advisory",   F, PAYE, 93333.33, 46666.67, 140000],
    ["EID 9",  "AMATEY, SARAH OTEI",              "Advisory",   F, PAYE, 73333.33, 36666.67, 110000],
    ["EID 1",  "NWACHUKWU, JOSEPH CHIDUBEM",      "Core",       F, PAYE, 200000,   0,        0],
    ["EID 5",  "NWANKWO, IFUNANYA CHINAZA",       "Advisory",   F, PAYE, 140000,   70000,    320000],
    ["EID 18", "AGANGAN, MABEL ABIODUN",          "Advisory",   F, PAYE, 73333.33, 36666.67, 110000],
    ["EID 12", "NZEKA, MARYAM EKENECHUKWU",       "Advisory",   F, EX,   35000,    20000,    55000],
    ["EID 16", "MUSA, ROLAND IMAORONA",           "Core",       C, FLAT, 100000,   0,        0],
    ["EID 17", "ODIGBO, MATTHEW",                 "Advisory",   F, PAYE, 73333.33, 36666.67, 110000],
    ["EID 3",  "OLADELE, CLEMENT OMONIYI",        "Investment", F, PAYE, 280000,   120000,   400000],
    ["EID 10", "AGEGE, HAPPINESS OSEMWONYEMWEN",  "Advisory",   F, PAYE, 73333.33, 36666.67, 110000],
    ["EID 19", "FIELD OFFICER (NEW HIRE)",        "Advisory",   F, PAYE, 73333.33, 36666.67, 110000],
    ["EID 14", "AWOTUNDE, RASHIDAT",              "Part-Time",  P, EX,   26000,    0,        0],
    ["EID 13", "OFOEGBU, OKEZIE OKECHUKWU",       "Part-Time",  P, EX,   43000,    0,        0],
  ];

  for (const [eeId, fullName, cat, type, tax, basic, utility, qtr] of rows) {
    const emp = await prisma.employee.upsert({
      where: { eeId },
      update: { fullName, payCategoryId: catMap[cat], employmentType: type, entityId: entity.id },
      create: {
        eeId, fullName, employmentType: type, status: EmploymentStatus.ACTIVE,
        entityId: entity.id, payCategoryId: catMap[cat],
      },
    });
    const isPaye = tax === PAYE;
    await prisma.compensationProfile.updateMany({ where: { employeeId: emp.id, isCurrent: true }, data: { isCurrent: false } });
    await prisma.compensationProfile.create({
      data: {
        employeeId: emp.id, effectiveDate: new Date("2025-09-01"),
        basicSalary: basic, utilityAllowance: utility, quarterlyAllowance: qtr,
        taxTreatment: tax, pensionApplicable: isPaye, nhfApplicable: isPaye, isCurrent: true,
      },
    });
  }

  console.log("Seed complete: roles, pay categories, entity, departments, 2026 tax rules, 15 employees.");
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
