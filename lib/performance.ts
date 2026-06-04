// Performance & Development — shared queries and presentation helpers.
// Read-only here; the audited writes live in lib/performance-actions.ts.
//
// Shape of the module:
// - A review CYCLE moves through a five-stage pipeline (CYCLE_STAGES).
// - Each appraisable employee (ACTIVE/PROBATION, in a role that has a PUBLISHED
//   scorecard) gets one APPRAISAL per cycle.
// - An appraisal's items are seeded from the role: scorecard outcomes -> OUTCOME
//   rows, required competencies -> COMPETENCY rows. Each item has a self side and
//   a manager side, so self-assessment and manager review are distinct submissions.
import { prisma } from "@/lib/db";
import { getScorecard } from "@/lib/scorecards";
import { levelLabel, personGrade } from "@/lib/jobframework";
import { scoreAppraisal, familyWeights, type ScoreResult, type DimensionWeights } from "@/lib/scorecard-scoring";

export { levelLabel };

// ---------------------------------------------------------------------------
// Vocabularies
// ---------------------------------------------------------------------------
export const CYCLE_STAGES = [
  { value: "GOAL_SETTING", label: "Goal setting" },
  { value: "MID_CYCLE", label: "Mid-cycle check-in" },
  { value: "SELF_ASSESSMENT", label: "Self-assessment" },
  { value: "MANAGER_REVIEW", label: "Manager review" },
  { value: "REWARDS", label: "Rewards & interventions" },
] as const;

export const CYCLE_STATUSES = [
  { value: "OPEN", label: "Open" },
  { value: "CLOSED", label: "Closed" },
] as const;

export const RATINGS = [
  { value: "EXCEEDS", label: "Exceeds" },
  { value: "MEETS", label: "Meets" },
  { value: "BELOW", label: "Below" },
  { value: "NA", label: "N/A" },
] as const;

export function stageLabel(stage: string): string {
  return CYCLE_STAGES.find((s) => s.value === stage)?.label ?? stage;
}

export function stageIndex(stage: string): number {
  const i = CYCLE_STAGES.findIndex((s) => s.value === stage);
  return i < 0 ? 0 : i;
}

export function ratingBadge(r: string | null | undefined): { cls: string; label: string } | null {
  if (!r) return null;
  switch (r) {
    case "EXCEEDS":
      return { cls: "b-grn", label: "Exceeds" };
    case "MEETS":
      return { cls: "b-grn", label: "Meets" };
    case "BELOW":
      return { cls: "b-amb", label: "Below" };
    case "NA":
      return { cls: "b-gry", label: "N/A" };
    default:
      return { cls: "b-gry", label: r };
  }
}

export type AppraisalStatus = {
  key: "NOT_STARTED" | "IN_PROGRESS" | "SELF_SUBMITTED" | "FINALIZED";
  label: string;
  cls: string;
};

export function appraisalStatus(
  a: { selfStatus: string; managerStatus: string } | null
): AppraisalStatus {
  if (!a) return { key: "NOT_STARTED", label: "Not started", cls: "b-gry" };
  if (a.managerStatus === "SUBMITTED")
    return { key: "FINALIZED", label: "Finalized", cls: "b-grn" };
  if (a.selfStatus === "SUBMITTED")
    return { key: "SELF_SUBMITTED", label: "Self submitted", cls: "b-blu" };
  return { key: "IN_PROGRESS", label: "In progress", cls: "b-amb" };
}

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Cycles
// ---------------------------------------------------------------------------
export async function getCycles() {
  return prisma.appraisalCycle.findMany({ orderBy: [{ createdAt: "desc" }] });
}

export async function getCycle(id: string) {
  return prisma.appraisalCycle.findUnique({ where: { id } });
}

/** The cycle to show by default: the most recently created OPEN one, else the
 *  most recent of any status, else null. */
export async function getDefaultCycle() {
  return (
    (await prisma.appraisalCycle.findFirst({
      where: { status: "OPEN" },
      orderBy: [{ createdAt: "desc" }],
    })) ??
    (await prisma.appraisalCycle.findFirst({ orderBy: [{ createdAt: "desc" }] }))
  );
}

// ---------------------------------------------------------------------------
// Roster for a cycle
// ---------------------------------------------------------------------------
export type RosterRow = {
  employeeId: string;
  eeId: string;
  name: string;
  role: string | null;
  grade: string | null;
  appraisalId: string | null;
  status: AppraisalStatus;
  overallRating: string | null;
};

/** Appraisable employees for a cycle: ACTIVE/PROBATION, in a role that has a
 *  PUBLISHED scorecard, joined to their appraisal (if any) for this cycle. */
export async function getRoster(cycleId: string): Promise<RosterRow[]> {
  const [employees, scored, appraisals] = await Promise.all([
    prisma.employee.findMany({
      where: { status: { in: ["ACTIVE", "PROBATION"] }, jobProfileId: { not: null } },
      select: {
        id: true,
        eeId: true,
        grade: true,
        fullName: true,
        preferredName: true,
        jobProfileId: true,
        jobProfile: { select: { title: true, grade: true } },
      },
      orderBy: { eeId: "asc" },
    }),
    prisma.scorecard.findMany({
      where: { status: "PUBLISHED" },
      select: { jobProfileId: true },
    }),
    prisma.appraisal.findMany({
      where: { cycleId },
      select: {
        id: true,
        employeeId: true,
        selfStatus: true,
        managerStatus: true,
        overallRating: true,
      },
    }),
  ]);

  const scoredSet = new Set(scored.map((s) => s.jobProfileId));
  const byEmp = new Map(appraisals.map((a) => [a.employeeId, a] as [string, typeof a]));

  return employees
    .filter((e) => e.jobProfileId && scoredSet.has(e.jobProfileId))
    .map((e) => {
      const a = byEmp.get(e.id) ?? null;
      return {
        employeeId: e.id,
        eeId: e.eeId,
        name: personName(e),
        role: e.jobProfile?.title ?? null,
        grade: personGrade(e.grade, e.jobProfile?.grade),
        appraisalId: a?.id ?? null,
        status: appraisalStatus(a),
        overallRating: a?.overallRating ?? null,
      };
    });
}

// ---------------------------------------------------------------------------
// One appraisal (detail / editors)
// ---------------------------------------------------------------------------
export type AppraisalItemView = {
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
  actual: string | null;
  rating: string | null;
  assessedLevel: number | null;
  managerNote: string | null;
};

export type AppraisalView = {
  cycle: { id: string; name: string; stage: string; status: string };
  employee: { id: string; eeId: string; name: string; role: string | null; grade: string | null };
  mission: string | null;
  appraisal:
    | {
        id: string;
        selfStatus: string;
        selfSummary: string | null;
        managerStatus: string;
        managerSummary: string | null;
        developmentPlan: string | null;
        overallRating: string | null;
        items: AppraisalItemView[];
      }
    | null;
  score: ScoreResult | null;
  scoreWeights: DimensionWeights;
};

/** Everything the appraisal page needs: cycle + employee + role mission +
 *  the appraisal with ordered items (OUTCOME rows first, then COMPETENCY). */
export async function getAppraisalView(
  cycleId: string,
  employeeId: string
): Promise<AppraisalView | null> {
  const [cycle, employee] = await Promise.all([
    prisma.appraisalCycle.findUnique({ where: { id: cycleId } }),
    prisma.employee.findUnique({
      where: { id: employeeId },
      select: {
        id: true,
        eeId: true,
        grade: true,
        fullName: true,
        preferredName: true,
        jobProfileId: true,
        jobProfile: { select: { title: true, grade: true, family: true } },
      },
    }),
  ]);
  if (!cycle || !employee) return null;

  const sc = employee.jobProfileId ? await getScorecard(employee.jobProfileId) : null;

  const appraisal = await prisma.appraisal.findFirst({
    where: { cycleId, employeeId },
    include: {
      items: { orderBy: [{ kind: "asc" }, { position: "asc" }, { createdAt: "asc" }] },
    },
  });

  // Indicative score from the manager's saved ratings (read-only panel on the
  // appraisal page). Same pure engine the bonus run uses, so the breakdown the
  // reviewer sees is exactly what would drive the multiplier — including the
  // role scorecard's weighting override when one is set.
  const overrideWeights = sc?.weights ?? null;
  const scoreWeights: DimensionWeights =
    overrideWeights ?? familyWeights(employee.jobProfile?.family ?? null);
  const score: ScoreResult | null = appraisal
    ? scoreAppraisal(
        appraisal.items.map((it) => ({
          kind: it.kind,
          rating: it.rating,
          weight: it.weight == null ? null : Number(it.weight),
          label: it.label,
        })),
        employee.jobProfile?.family ?? null,
        overrideWeights,
      )
    : null;

  return {
    cycle: { id: cycle.id, name: cycle.name, stage: cycle.stage, status: cycle.status },
    employee: {
      id: employee.id,
      eeId: employee.eeId,
      name: personName(employee),
      role: employee.jobProfile?.title ?? null,
      grade: personGrade(employee.grade, employee.jobProfile?.grade),
    },
    mission: sc?.mission ?? null,
    appraisal: appraisal
      ? {
          id: appraisal.id,
          selfStatus: appraisal.selfStatus,
          selfSummary: appraisal.selfSummary,
          managerStatus: appraisal.managerStatus,
          managerSummary: appraisal.managerSummary,
          developmentPlan: appraisal.developmentPlan,
          overallRating: appraisal.overallRating,
          items: appraisal.items.map((it) => ({
            id: it.id,
            kind: it.kind,
            position: it.position,
            label: it.label,
            measure: it.measure,
            target: it.target,
            weight: it.weight,
            expectedLevel: it.expectedLevel,
            selfActual: it.selfActual,
            selfRating: it.selfRating,
            selfLevel: it.selfLevel,
            selfNote: it.selfNote,
            actual: it.actual,
            rating: it.rating,
            assessedLevel: it.assessedLevel,
            managerNote: it.managerNote,
          })),
        }
      : null,
    score,
    scoreWeights,
  };
}
