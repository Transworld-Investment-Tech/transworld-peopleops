// Job & Competency module — shared queries and presentation helpers.
// Read-only here; the audited writes live in lib/jobframework-actions.ts.
//
// Notes:
// - JobProfile.departmentId is a bare column (no Prisma relation), so the
//   department NAME is resolved via a small id→name lookup rather than an
//   `include`. This matches the schema as shipped; no migration is implied.
// - Job profiles set the `title` rendered across the Employee database and the
//   org chart (Employee.jobProfile), which is why this module sits in "People".
import { prisma } from "@/lib/db";
import type { JdStatus } from "@prisma/client";

// ---------------------------------------------------------------------------
// Presentation helpers
// ---------------------------------------------------------------------------
const JD_STATUS_BADGE: Record<JdStatus, { cls: string; label: string }> = {
  DRAFT: { cls: "b-amb", label: "Draft" },
  PUBLISHED: { cls: "b-grn", label: "Published" },
};
export function jdStatusBadge(s: JdStatus): { cls: string; label: string } {
  return JD_STATUS_BADGE[s] ?? { cls: "b-gry", label: String(s) };
}

export const JD_STATUSES: { value: string; label: string }[] = [
  { value: "DRAFT", label: "Draft" },
  { value: "PUBLISHED", label: "Published" },
];

// Canonical competency proficiency scale, F/P/E (stored as JobProfileCompetency.level 1..3).
export const LEVELS: { value: number; label: string }[] = [
  { value: 1, label: "F · Foundation" },
  { value: 2, label: "P · Proficient" },
  { value: 3, label: "E · Expert" },
];
export function levelLabel(n: number): string {
  return LEVELS.find((l) => l.value === n)?.label ?? `Level ${n}`;
}

// Job-family vocabulary (four families; control-function is a flag, not a fifth family).
export const FAMILIES: { value: string; label: string }[] = [
  { value: "BUSINESS_DEVELOPMENT", label: "Business Development" },
  { value: "INVESTMENTS", label: "Investments" },
  { value: "CONTROL_OPERATIONS", label: "Control & Operations" },
  { value: "LEADERSHIP", label: "Leadership" },
];
export function familyLabel(v: string | null): string {
  return FAMILIES.find((f) => f.value === v)?.label ?? "—";
}
export const TRACKS: { value: string; label: string }[] = [
  { value: "MANAGER", label: "Manager track" },
  { value: "EXPERT", label: "Expert track" },
];
export const RUNGS: { value: string; label: string }[] = [
  { value: "JUNIOR", label: "Junior" },
  { value: "MID", label: "Mid" },
  { value: "SENIOR", label: "Senior" },
];
export function trackLabel(v: string | null): string {
  return TRACKS.find((t) => t.value === v)?.label ?? "—";
}
export function rungLabel(v: string | null): string {
  return RUNGS.find((r) => r.value === v)?.label ?? "—";
}

// Growth Ladder / PADP (Layer 3 of the model): fixed firm reference by grade. Feeds
// development and promotion conversations — never the bonus.
export const GROWTH_LADDER: { grade: string; stage: string; summary: string }[] = [
  { grade: "G1", stage: "Learn & Deliver", summary: "Build your technical foundation; deliver quality work consistently in your defined area." },
  { grade: "G2", stage: "Collaborate", summary: "Work effectively across functions; contribute beyond your own assignments; begin mentoring juniors." },
  { grade: "G3", stage: "Lead a Team or Domain", summary: "Own outcomes and develop others (Manager), or deepen mastery and influence peers (Expert)." },
  { grade: "G4", stage: "Lead Teams and Functions", summary: "Set standards for a function; develop G3s toward leadership; own the people and performance of your area." },
  { grade: "G5", stage: "Cast Vision", summary: "Shape the firm's direction; develop G4 leaders; operate at an institutional level." },
];
export function ladderStageFor(grade: string | null): { grade: string; stage: string; summary: string } | null {
  if (!grade) return null;
  return GROWTH_LADDER.find((g) => g.grade === grade.toUpperCase().trim()) ?? null;
}

// ---------------------------------------------------------------------------
// Queries
// ---------------------------------------------------------------------------

/** Job-profile rows for the list: counts of required competencies + holders. */
export async function getJobProfilesForList() {
  const [profiles, departments, scorecards] = await Promise.all([
    prisma.jobProfile.findMany({
      include: { _count: { select: { employees: true, competencies: true } } },
      orderBy: [{ title: "asc" }],
    }),
    prisma.department.findMany({ select: { id: true, name: true } }),
    prisma.scorecard.findMany({
      where: { status: "PUBLISHED" },
      select: { jobProfileId: true },
    }),
  ]);
  const deptName = new Map(departments.map((d) => [d.id, d.name]));
  const scored = new Set(scorecards.map((s) => s.jobProfileId));
  return profiles.map((p) => ({
    id: p.id,
    title: p.title,
    grade: p.grade,
    status: p.status,
    department: p.departmentId ? deptName.get(p.departmentId) ?? null : null,
    competencyCount: p._count.competencies,
    employeeCount: p._count.employees,
    hasScorecard: scored.has(p.id),
  }));
}

export type JobProfileDetail = {
  id: string;
  title: string;
  grade: string | null;
  departmentId: string | null;
  department: string | null;
  description: string | null;
  status: JdStatus;
  family: string | null;
  isControlFunction: boolean;
  track: string | null;
  rung: string | null;
  competencies: { id: string; name: string; category: string | null; level: number }[];
  behaviors: { id: string; name: string; definition: string | null }[];
  employees: { id: string; eeId: string; fullName: string; status: string }[];
};

/** One job profile with its required competencies and the staff who hold it. */
export async function getJobProfileDetail(id: string): Promise<JobProfileDetail | null> {
  const p = await prisma.jobProfile.findUnique({
    where: { id },
    include: {
      competencies: { include: { competency: true } },
      employees: {
        where: { status: { not: "EXITED" } },
        select: { id: true, eeId: true, fullName: true, status: true },
        orderBy: { eeId: "asc" },
      },
    },
  });
  if (!p) return null;

  let department: string | null = null;
  if (p.departmentId) {
    const d = await prisma.department.findUnique({
      where: { id: p.departmentId },
      select: { name: true },
    });
    department = d?.name ?? null;
  }

  const competencies = p.competencies
    .filter((c) => c.competency.kind !== "BEHAVIOR")
    .map((c) => ({
      id: c.competency.id,
      name: c.competency.name,
      category: c.competency.category,
      level: c.level,
    }))
    .sort((a, b) => b.level - a.level || a.name.localeCompare(b.name));

  const behaviors = p.competencies
    .filter((c) => c.competency.kind === "BEHAVIOR")
    .map((c) => ({
      id: c.competency.id,
      name: c.competency.name,
      definition: c.competency.definition,
      sortOrder: c.competency.sortOrder,
    }))
    .sort((a, b) => a.sortOrder - b.sortOrder)
    .map(({ id, name, definition }) => ({ id, name, definition }));

  return {
    id: p.id,
    title: p.title,
    grade: p.grade,
    departmentId: p.departmentId,
    department,
    description: p.description,
    status: p.status,
    family: p.family,
    isControlFunction: p.isControlFunction,
    track: p.track,
    rung: p.rung,
    competencies,
    behaviors,
    employees: p.employees,
  };
}

/** Competency catalog rows with how many profiles use each. */
export async function getCompetencies() {
  const rows = await prisma.competency.findMany({
    include: { _count: { select: { profiles: true } } },
    orderBy: [{ category: "asc" }, { name: "asc" }],
  });
  return rows.map((c) => ({
    id: c.id,
    name: c.name,
    category: c.category,
    kind: c.kind,
    definition: c.definition,
    profileCount: c._count.profiles,
  }));
}

export async function getCompetency(id: string) {
  return prisma.competency.findUnique({
    where: { id },
    select: { id: true, name: true, category: true },
  });
}

export type JobProfileFormData = {
  departments: { id: string; name: string }[];
  catalog: { id: string; name: string; category: string | null }[];
  profile:
    | {
        id: string;
        title: string;
        grade: string | null;
        departmentId: string | null;
        description: string | null;
        status: JdStatus;
        family: string | null;
        isControlFunction: boolean;
        track: string | null;
        rung: string | null;
      }
    | null;
  selected: { id: string; level: number }[];
};

/** Everything the job-profile editor needs: departments, the competency
 *  catalog, and (for edit) the profile's current values + selected levels. */
export async function getJobProfileFormData(id?: string): Promise<JobProfileFormData> {
  const [departments, catalog] = await Promise.all([
    prisma.department.findMany({ orderBy: { name: "asc" }, select: { id: true, name: true } }),
    prisma.competency.findMany({
      orderBy: [{ category: "asc" }, { name: "asc" }],
      select: { id: true, name: true, category: true },
    }),
  ]);

  let profile: JobProfileFormData["profile"] = null;
  let selected: { id: string; level: number }[] = [];
  if (id) {
    const p = await prisma.jobProfile.findUnique({
      where: { id },
      include: { competencies: true },
    });
    if (p) {
      profile = {
        id: p.id,
        title: p.title,
        grade: p.grade,
        departmentId: p.departmentId,
        description: p.description,
        status: p.status,
        family: p.family,
        isControlFunction: p.isControlFunction,
        track: p.track,
        rung: p.rung,
      };
      selected = p.competencies.map((c) => ({ id: c.competencyId, level: c.level }));
    }
  }
  return { departments, catalog, profile, selected };
}
