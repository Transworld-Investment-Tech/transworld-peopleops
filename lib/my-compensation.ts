// lib/my-compensation.ts — "My Pay" self-service read layer (v0.57.0).
//
// The portal NEVER pays anyone. This screen lets a signed-in staff member view
// their OWN standing pay structure: basic, utility, monthly gross, the
// fully-loaded monthly figure, and their tax treatment (PAYE or a flat rate —
// the latter matters for some staff / contractors). It reuses the firm's
// canonical fully-loaded recipe (gross × 17 ÷ 12 ÷ FTE) from lib/raise so the
// figure matches the compensation control room exactly.
//
// Reads only. No writes, no audit — a self-view of one's own record, consistent
// with the other self-service pages (My Payslips, My Bonus). The linked
// employee is resolved the same way as everywhere else:
// prisma.employee.findUnique({ where: { userId } }).
//
// Deliberately NO band positioning / compa-ratio / flags here. How a person's
// pay sits against their grade band is HR-only and is walked through during the
// appraisal review, with context — never surfaced raw on a phone screen.
import { prisma } from "@/lib/db";
import { fullyLoaded } from "@/lib/raise";
import { personGrade } from "@/lib/jobframework";

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
}
function numOrNull(v: unknown): number | null {
  if (v === null || v === undefined) return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

export type MyCompensation =
  | { linked: false }
  | {
      linked: true;
      hasProfile: boolean;
      employee: { eeId: string; name: string; role: string | null; grade: string | null };
      effectiveDate: Date | null;
      basicSalary: number;
      utilityAllowance: number;
      monthlyGross: number;
      fullyLoaded: number;
      taxTreatment: string; // "PAYE" | "FLAT_RATE"
      flatTaxRate: number | null; // fraction, e.g. 0.05; null unless FLAT_RATE
      fte: number;
    };

export async function getMyCompensation(userId: string): Promise<MyCompensation> {
  const employee = await prisma.employee.findUnique({
    where: { userId },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      fte: true,
      grade: true,
      jobProfile: { select: { title: true, grade: true } },
    },
  });
  if (!employee) return { linked: false };

  const profile = await prisma.compensationProfile.findFirst({
    where: { employeeId: employee.id, isCurrent: true },
    orderBy: [{ effectiveDate: "desc" }, { createdAt: "desc" }],
    select: {
      effectiveDate: true,
      basicSalary: true,
      utilityAllowance: true,
      taxTreatment: true,
      flatTaxRate: true,
    },
  });

  const fte = employee.fte != null ? num(employee.fte) : 1;
  const name = employee.preferredName?.trim() || employee.fullName;
  const role = employee.jobProfile?.title ?? null;
  const grade = personGrade(employee.grade, employee.jobProfile?.grade ?? null);

  if (!profile) {
    return {
      linked: true,
      hasProfile: false,
      employee: { eeId: employee.eeId, name, role, grade },
      effectiveDate: null,
      basicSalary: 0,
      utilityAllowance: 0,
      monthlyGross: 0,
      fullyLoaded: 0,
      taxTreatment: "PAYE",
      flatTaxRate: null,
      fte,
    };
  }

  const basic = num(profile.basicSalary);
  const utility = num(profile.utilityAllowance);
  const gross = basic + utility;
  return {
    linked: true,
    hasProfile: true,
    employee: { eeId: employee.eeId, name, role, grade },
    effectiveDate: profile.effectiveDate,
    basicSalary: basic,
    utilityAllowance: utility,
    monthlyGross: gross,
    fullyLoaded: fullyLoaded(gross, fte),
    taxTreatment: String(profile.taxTreatment),
    flatTaxRate: numOrNull(profile.flatTaxRate),
    fte,
  };
}
