// Employee self-service read of their OWN appraisal — self side only. Manager
// ratings/notes/overall are deliberately NOT selected, so they can never reach
// the employee's browser before calibration (Ops Manual E6). Used by My
// Performance. Writes live in lib/self-assessment-actions.ts.
import { prisma } from "@/lib/db";

export type MySelfItem = {
  id: string;
  kind: string;
  position: number;
  label: string;
  measure: string | null;
  target: string | null;
  weight: number | null;
  expectedLevel: number | null;
  selfActual: string | null;
  selfRating: string | null;
  selfLevel: number | null;
  selfNote: string | null;
};

export type MySelfAssessment = {
  linked: boolean;
  cycle: { id: string; name: string; stage: string; status: string } | null;
  appraisal:
    | { id: string; selfStatus: string; selfSummary: string | null; items: MySelfItem[] }
    | null;
};

export async function getMySelfAssessment(userId: string): Promise<MySelfAssessment> {
  const employee = await prisma.employee.findUnique({ where: { userId }, select: { id: true } });
  if (!employee) return { linked: false, cycle: null, appraisal: null };

  const cycle =
    (await prisma.appraisalCycle.findFirst({ where: { status: "OPEN" }, orderBy: { createdAt: "desc" } })) ??
    (await prisma.appraisalCycle.findFirst({ orderBy: { createdAt: "desc" } }));
  if (!cycle) return { linked: true, cycle: null, appraisal: null };

  const appraisal = await prisma.appraisal.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId: employee.id } },
    select: {
      id: true,
      selfStatus: true,
      selfSummary: true,
      items: {
        orderBy: [{ kind: "asc" }, { position: "asc" }, { createdAt: "asc" }],
        select: {
          id: true,
          kind: true,
          position: true,
          label: true,
          measure: true,
          target: true,
          weight: true,
          expectedLevel: true,
          selfActual: true,
          selfRating: true,
          selfLevel: true,
          selfNote: true,
        },
      },
    },
  });

  return {
    linked: true,
    cycle: { id: cycle.id, name: cycle.name, stage: cycle.stage, status: cycle.status },
    appraisal: appraisal ?? null,
  };
}
