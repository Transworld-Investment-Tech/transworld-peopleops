// lib/my-payslips.ts — "My Payslips" self-service read layer (v0.19.3).
//
// The portal NEVER pays anyone. This screen lets a signed-in staff member view
// their OWN pay rows for cycles that have been LOCKED as evidence. It reads the
// existing pay_items (the ten seeded historical months, plus each new run once it
// is locked) and reuses the Payroll Control Center's math so a staff member's
// figures match the control room to the kobo.
//
// Locked-only by design (owner decision, v0.19.3): a payslip surfaces only once
// its monthly cycle is sealed. DRAFT / IN_REVIEW / APPROVED / GENERATED cycles do
// NOT appear here — those are operator/working states.
//
// Reads only. No writes, no audit — a self-view of one's own record, consistent
// with the other self-service pages (My Performance, My Documents). The linked
// employee is resolved the same way as everywhere else:
// prisma.employee.findUnique({ where: { userId } }).
import { prisma } from "@/lib/db";
import {
  parseAdjustments,
  adjustmentsNet,
  fmtNaira,
  type Adjustment,
} from "@/lib/payroll-cycle";

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}
function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

export type MyPaySlip = {
  payItemId: string;
  cycleId: string;
  label: string;
  periodYear: number;
  periodMonth: number;
  lockedAt: Date | null;
  // snapshot inputs
  basicSalary: number;
  utilityAllowance: number;
  quarterlyAllowance: number;
  taxTreatment: string;
  // computed deductions / employer cost
  employeePension: number;
  nhf: number;
  itf: number;
  payeTax: number;
  employerPension: number;
  // adjustments (special/leave allowance, unpaid-leave deduction)
  adjustments: Adjustment[];
  adjustmentAllowances: number;
  adjustmentDeductions: number;
  // derived — same recipe as lib/payroll-cycle.ts getCycle()
  grossPay: number; // basic + utility (engine gross)
  grossForMonth: number; // grossPay + adjustment allowances
  totalDeductions: number; // pension + nhf + itf + paye + adj deductions
  netPay: number; // grossForMonth - totalDeductions
  totalPayable: number; // net + quarterly (paid on top)
};

export type MyPayslipsData =
  | { linked: false }
  | {
      linked: true;
      employee: { id: string; eeId: string; name: string; grade: string | null };
      slips: MyPaySlip[];
      latest: MyPaySlip | null;
    };

export async function getMyPayslips(userId: string): Promise<MyPayslipsData> {
  const employee = await prisma.employee.findUnique({
    where: { userId },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { grade: true } },
    },
  });
  if (!employee) return { linked: false };

  const items = await prisma.payItem.findMany({
    where: { employeeId: employee.id, payCycle: { status: "LOCKED" } },
    select: {
      id: true,
      basicSalary: true,
      utilityAllowance: true,
      quarterlyAllowance: true,
      taxTreatment: true,
      grossPay: true,
      employeePension: true,
      nhf: true,
      itf: true,
      payeTax: true,
      employerPension: true,
      adjustments: true,
      payCycle: {
        select: {
          id: true,
          label: true,
          periodYear: true,
          periodMonth: true,
          lockedAt: true,
        },
      },
    },
  });

  const slips: MyPaySlip[] = items.map((it) => {
    const adj = parseAdjustments(it.adjustments);
    const { allowances, deductions } = adjustmentsNet(adj);
    const gross = num(it.grossPay);
    const ee = num(it.employeePension);
    const nhf = num(it.nhf);
    const itf = num(it.itf);
    const paye = num(it.payeTax);
    const quarterly = num(it.quarterlyAllowance);
    const grossForMonth = round2(gross + allowances);
    const totalDeductions = round2(ee + nhf + itf + paye + deductions);
    const net = round2(grossForMonth - totalDeductions);
    return {
      payItemId: it.id,
      cycleId: it.payCycle.id,
      label: it.payCycle.label,
      periodYear: it.payCycle.periodYear,
      periodMonth: it.payCycle.periodMonth,
      lockedAt: it.payCycle.lockedAt,
      basicSalary: num(it.basicSalary),
      utilityAllowance: num(it.utilityAllowance),
      quarterlyAllowance: quarterly,
      taxTreatment: String(it.taxTreatment),
      employeePension: ee,
      nhf,
      itf,
      payeTax: paye,
      employerPension: num(it.employerPension),
      adjustments: adj,
      adjustmentAllowances: allowances,
      adjustmentDeductions: deductions,
      grossPay: gross,
      grossForMonth,
      totalDeductions,
      netPay: net,
      totalPayable: round2(net + quarterly),
    };
  });

  // Newest month first.
  slips.sort(
    (a, b) => b.periodYear - a.periodYear || b.periodMonth - a.periodMonth,
  );

  return {
    linked: true,
    employee: {
      id: employee.id,
      eeId: employee.eeId,
      name: employee.preferredName?.trim() || employee.fullName,
      grade: employee.jobProfile?.grade ?? null,
    },
    slips,
    latest: slips[0] ?? null,
  };
}

export { fmtNaira };
