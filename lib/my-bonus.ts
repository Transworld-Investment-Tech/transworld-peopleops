// lib/my-bonus.ts — "My Bonus" self-service read layer (v0.20.2, WS6 Part 3).
//
// The portal NEVER pays anyone. This screen lets a signed-in staff member view
// their OWN profit-share bonus:
//   1) an INDICATIVE TARGET — what they would receive IF the firm meets its
//      annual profit budget (so the pool is not scaled down) AND they meet their
//      appraisal target (a ×1.0 performance multiplier); and
//   2) their actual AWARDED bonus and deferral schedule for any bonus round that
//      has been LOCKED as evidence.
//
// Locked-only by design (mirrors My Payslips, v0.19.3): an awarded bonus surfaces
// only once its round is sealed. DRAFT / IN_REVIEW / APPROVED rounds are operator
// working states and do NOT appear here.
//
// The indicative target reconciles to a real round exactly because it uses the
// same recipe lib/bonus-round-actions.ts uses to carry an eligible employee:
//   grade         = employee.jobProfile.grade
//   monthlySalary = monthlySalaryFor("GROSS", basic, utility)   (basic + utility)
//   targetMonths  = targetMonthsFor(grade)
//   targetBonus   = targetMonths × monthlySalary   (i.e. multiplier ×1.0, no scaling)
//
// Reads only. No writes, no audit — a self-view of one's own record, consistent
// with the other self-service pages (My Payslips, My Performance, My Documents).
// The linked employee is resolved the same way as everywhere else:
// prisma.employee.findUnique({ where: { userId } }).
import { prisma } from "@/lib/db";
import { personGrade } from "@/lib/jobframework";
import {
  targetMonthsFor,
  monthlySalaryFor,
  computeTargetBonus,
  isDeferredGrade,
} from "@/lib/bonus";
import { fmtNaira, monthLabel, trancheStatusBadge } from "@/lib/bonus-round";

// Re-export the shared formatters/badges so the page imports from one module.
export { fmtNaira, monthLabel, trancheStatusBadge };

function num(v: unknown): number {
  if (v === null || v === undefined) return 0;
  const n = typeof v === "number" ? v : Number(v as never);
  return Number.isFinite(n) ? n : 0;
}

export type MyBonusTranche = {
  id: string;
  sequence: number;
  label: string;
  amount: number;
  scheduledMonth: number;
  scheduledYear: number;
  status: string;
};

export type MyBonusAward = {
  id: string;
  awardYear: number;
  roundLabel: string;
  grade: string;
  deferred: boolean;
  monthlySalary: number;
  targetMonths: number;
  targetBonus: number; // at-target benchmark for that sealed year (stored snapshot)
  multiplier: number; // the appraisal-outcome lever
  integrityGate: boolean;
  awardedBonus: number; // post-multiplier, post-scaling snapshot
  immediateAmount: number;
  deferredAmount: number;
  paymentMonth: number;
  paymentYear: number;
  lockedAt: Date | null;
  tranches: MyBonusTranche[];
};

export type IndicativeTarget = {
  grade: string;
  monthlySalary: number;
  targetMonths: number;
  targetBonus: number;
  deferred: boolean;
};

export type MyBonusData =
  | { linked: false }
  | {
      linked: true;
      employee: { id: string; eeId: string; name: string; grade: string | null };
      indicative: IndicativeTarget | null; // null if no current comp profile / ungraded role
      awards: MyBonusAward[];
    };

export async function getMyBonus(userId: string): Promise<MyBonusData> {
  const employee = await prisma.employee.findUnique({
    where: { userId },
    select: {
      id: true,
      eeId: true,
      grade: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { grade: true } },
    },
  });
  if (!employee) return { linked: false };

  const grade = personGrade(employee.grade, employee.jobProfile?.grade);

  // --- Indicative target (current), computed with the round's exact recipe ----
  let indicative: IndicativeTarget | null = null;
  if (grade) {
    const profile = await prisma.compensationProfile.findFirst({
      where: { employeeId: employee.id, isCurrent: true },
      select: { basicSalary: true, utilityAllowance: true },
    });
    if (profile) {
      const monthlySalary = monthlySalaryFor(
        "GROSS",
        num(profile.basicSalary),
        num(profile.utilityAllowance),
      );
      const targetMonths = targetMonthsFor(grade);
      indicative = {
        grade,
        monthlySalary,
        targetMonths,
        targetBonus: computeTargetBonus(targetMonths, monthlySalary),
        deferred: isDeferredGrade(grade),
      };
    }
  }

  // --- Awarded history (LOCKED rounds only) -----------------------------------
  const awardRows = await prisma.bonusAward.findMany({
    where: { employeeId: employee.id, bonusRound: { status: "LOCKED" } },
    select: {
      id: true,
      grade: true,
      deferred: true,
      monthlySalary: true,
      targetMonths: true,
      targetBonus: true,
      multiplier: true,
      integrityGate: true,
      awardedBonus: true,
      immediateAmount: true,
      deferredAmount: true,
      tranches: {
        select: {
          id: true,
          sequence: true,
          label: true,
          amount: true,
          scheduledMonth: true,
          scheduledYear: true,
          status: true,
        },
        orderBy: { sequence: "asc" },
      },
      bonusRound: {
        select: {
          awardYear: true,
          label: true,
          paymentMonth: true,
          paymentYear: true,
          lockedAt: true,
        },
      },
    },
  });

  const awards: MyBonusAward[] = awardRows.map((a) => ({
    id: a.id,
    awardYear: a.bonusRound.awardYear,
    roundLabel: a.bonusRound.label,
    grade: a.grade,
    deferred: a.deferred,
    monthlySalary: num(a.monthlySalary),
    targetMonths: num(a.targetMonths),
    targetBonus: num(a.targetBonus),
    multiplier: num(a.multiplier),
    integrityGate: a.integrityGate,
    awardedBonus: num(a.awardedBonus),
    immediateAmount: num(a.immediateAmount),
    deferredAmount: num(a.deferredAmount),
    paymentMonth: a.bonusRound.paymentMonth,
    paymentYear: a.bonusRound.paymentYear,
    lockedAt: a.bonusRound.lockedAt,
    tranches: a.tranches.map((t) => ({
      id: t.id,
      sequence: t.sequence,
      label: t.label,
      amount: num(t.amount),
      scheduledMonth: t.scheduledMonth,
      scheduledYear: t.scheduledYear,
      status: t.status,
    })),
  }));

  // Newest award year first.
  awards.sort((x, y) => y.awardYear - x.awardYear);

  return {
    linked: true,
    employee: {
      id: employee.id,
      eeId: employee.eeId,
      name: employee.preferredName?.trim() || employee.fullName,
      grade,
    },
    indicative,
    awards,
  };
}
