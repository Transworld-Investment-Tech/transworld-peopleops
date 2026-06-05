// lib/lms-data.ts — WS7 LMS read layer (v0.42.0).
// Server-only reads for the catalogue/matrix/quiz/compliance surfaces. Pairs with
// the pure engine (lib/lms.ts) and the write actions (lib/lms-actions.ts). Imported
// by server components only (it pulls in Prisma). Cross-entity reads to employees /
// job_profiles / users are plain selects; the new learning_* columns/tables come
// from the 0031 migration.
import { prisma } from "@/lib/db";
import {
  currentPeriodFor,
  requiredSetFor,
  isComplete,
  rankGaps,
  type AssignmentRule,
  type GapRow,
} from "@/lib/lms";

const ACTIVE = { status: { not: "EXITED" as const } };

function nameOf(e: { fullName: string | null; preferredName: string | null; eeId: string }): string {
  return (e.preferredName || e.fullName || `EID ${e.eeId}`).trim();
}
function personGrade(e: {
  grade: string | null;
  jobProfile: { grade: string | null } | null;
}): string | null {
  return e.grade ?? e.jobProfile?.grade ?? null;
}

// ── Catalogue ────────────────────────────────────────────────────────────────
export type CatalogRow = {
  id: string;
  code: string | null;
  title: string;
  domain: string | null;
  level: string | null;
  category: string;
  status: string;
  isMandatory: boolean;
  cadence: string | null;
  owner: string | null;
  passMark: number | null;
  questionCount: number;
  ruleCount: number;
};

export async function getCatalog(includeArchived = false): Promise<CatalogRow[]> {
  const modules = await prisma.learningModule.findMany({
    where: includeArchived ? {} : { status: { not: "ARCHIVED" } },
    orderBy: [{ domain: "asc" }, { code: "asc" }, { title: "asc" }],
    select: {
      id: true, code: true, title: true, domain: true, level: true,
      category: true, status: true, isMandatory: true, cadence: true,
      owner: true, passMark: true,
    },
  });
  const ids = modules.map((m) => m.id);
  const [questions, rules] = await Promise.all([
    prisma.learningQuizQuestion.groupBy({
      by: ["moduleId"], where: { moduleId: { in: ids }, active: true }, _count: { _all: true },
    }),
    prisma.learningAssignmentRule.groupBy({
      by: ["moduleId"], where: { moduleId: { in: ids }, active: true }, _count: { _all: true },
    }),
  ]);
  const qBy = new Map(questions.map((q) => [q.moduleId, q._count._all]));
  const rBy = new Map(rules.map((r) => [r.moduleId, r._count._all]));
  return modules.map((m) => ({
    ...m,
    questionCount: qBy.get(m.id) ?? 0,
    ruleCount: rBy.get(m.id) ?? 0,
  }));
}

// ── One module, for the manage page (questions include the correct answers) ──
export type ManageQuestion = {
  id: string;
  prompt: string;
  type: string;
  options: { key: string; text: string }[];
  correct: string[];
  explanation: string | null;
  sortOrder: number;
  active: boolean;
};
export type ModuleManageView = {
  id: string;
  code: string | null;
  title: string;
  domain: string | null;
  level: string | null;
  status: string;
  isMandatory: boolean;
  cadence: string | null;
  owner: string | null;
  passMark: number | null;
  questions: ManageQuestion[];
};

function asOptions(v: unknown): { key: string; text: string }[] {
  if (!Array.isArray(v)) return [];
  return v
    .map((o) => {
      const r = o as { key?: unknown; text?: unknown };
      return { key: String(r?.key ?? ""), text: String(r?.text ?? "") };
    })
    .filter((o) => o.key !== "");
}
function asKeys(v: unknown): string[] {
  if (!Array.isArray(v)) return [];
  return v.map((k) => String(k)).filter((k) => k !== "");
}

export async function getModuleForManage(moduleId: string): Promise<ModuleManageView | null> {
  const m = await prisma.learningModule.findUnique({
    where: { id: moduleId },
    select: {
      id: true, code: true, title: true, domain: true, level: true, status: true,
      isMandatory: true, cadence: true, owner: true, passMark: true,
    },
  });
  if (!m) return null;
  const qs = await prisma.learningQuizQuestion.findMany({
    where: { moduleId },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
  });
  return {
    id: m.id, code: m.code, title: m.title, domain: m.domain, level: m.level,
    status: m.status, isMandatory: m.isMandatory, cadence: m.cadence, owner: m.owner,
    passMark: m.passMark,
    questions: qs.map((q) => ({
      id: q.id, prompt: q.prompt, type: q.type,
      options: asOptions(q.options), correct: asKeys(q.correct),
      explanation: q.explanation, sortOrder: q.sortOrder, active: q.active,
    })),
  };
}

// ── Quiz for a taker — NEVER includes correct answers (client-safe) ──────────
export type TakerQuestion = {
  id: string;
  prompt: string;
  type: string;
  options: { key: string; text: string }[];
};
export async function getQuizForEmployee(moduleId: string): Promise<TakerQuestion[]> {
  const qs = await prisma.learningQuizQuestion.findMany({
    where: { moduleId, active: true },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
    select: { id: true, prompt: true, type: true, options: true }, // correct deliberately omitted
  });
  return qs.map((q) => ({
    id: q.id, prompt: q.prompt, type: q.type, options: asOptions(q.options),
  }));
}

// ── Assignment matrix ────────────────────────────────────────────────────────
export type MatrixRow = {
  id: string;
  moduleId: string;
  moduleCode: string | null;
  moduleTitle: string;
  scope: string;
  grade: string | null;
  jobProfileId: string | null;
  jobProfileTitle: string | null;
  requirement: string;
  active: boolean;
};
export async function getMatrix(): Promise<MatrixRow[]> {
  const rules = await prisma.learningAssignmentRule.findMany({
    orderBy: [{ createdAt: "asc" }],
  });
  const moduleIds = Array.from(new Set(rules.map((r) => r.moduleId)));
  const jpIds = Array.from(new Set(rules.map((r) => r.jobProfileId).filter((x): x is string => !!x)));
  const [modules, jps] = await Promise.all([
    prisma.learningModule.findMany({ where: { id: { in: moduleIds } }, select: { id: true, code: true, title: true } }),
    jpIds.length ? prisma.jobProfile.findMany({ where: { id: { in: jpIds } }, select: { id: true, title: true } }) : Promise.resolve([]),
  ]);
  const mBy = new Map(modules.map((m) => [m.id, m]));
  const jBy = new Map(jps.map((j) => [j.id, j.title]));
  return rules.map((r) => ({
    id: r.id, moduleId: r.moduleId,
    moduleCode: mBy.get(r.moduleId)?.code ?? null,
    moduleTitle: mBy.get(r.moduleId)?.title ?? "(deleted module)",
    scope: r.scope, grade: r.grade, jobProfileId: r.jobProfileId,
    jobProfileTitle: r.jobProfileId ? jBy.get(r.jobProfileId) ?? null : null,
    requirement: r.requirement, active: r.active,
  }));
}

export async function getModuleOptions(): Promise<{ id: string; code: string | null; title: string }[]> {
  return prisma.learningModule.findMany({
    where: { status: { not: "ARCHIVED" } },
    orderBy: [{ code: "asc" }, { title: "asc" }],
    select: { id: true, code: true, title: true },
  });
}
export async function getJobProfileOptions(): Promise<{ id: string; title: string; grade: string | null }[]> {
  return prisma.jobProfile.findMany({
    orderBy: [{ title: "asc" }],
    select: { id: true, title: true, grade: true },
  });
}

// ── Compliance overview (matrix × active staff) ──────────────────────────────
export type ComplianceCell = {
  recordId: string | null;
  employeeId: string;
  employeeName: string;
  eeId: string;
  moduleId: string;
  moduleCode: string | null;
  moduleTitle: string;
  requirement: string; // REQUIRED | RECOMMENDED
  status: string; // ASSIGNED | IN_PROGRESS | COMPLETED | WAIVED | MISSING
  dueDate: Date | null;
  score: number | null;
  passed: boolean | null;
  period: string;
};
export type ComplianceSummary = {
  employeeId: string;
  employeeName: string;
  eeId: string;
  requiredTotal: number;
  requiredMet: number;
  pct: number;
  openGaps: number;
};
export type ComplianceView = {
  summaries: ComplianceSummary[];
  gaps: ComplianceCell[]; // required + unmet, worst-first
  asOfYear: string;
  staffCount: number;
  moduleCount: number;
};

async function loadRules(): Promise<AssignmentRule[]> {
  const rules = await prisma.learningAssignmentRule.findMany({ where: { active: true } });
  return rules.map((r) => ({
    moduleId: r.moduleId, scope: r.scope, grade: r.grade,
    jobProfileId: r.jobProfileId, requirement: r.requirement, active: r.active,
  }));
}

export async function getComplianceOverview(asOf: Date = new Date()): Promise<ComplianceView> {
  const [rules, employees, modules] = await Promise.all([
    loadRules(),
    prisma.employee.findMany({
      where: ACTIVE,
      orderBy: [{ eeId: "asc" }],
      select: {
        id: true, eeId: true, fullName: true, preferredName: true, grade: true,
        jobProfileId: true, jobProfile: { select: { grade: true } },
      },
    }),
    prisma.learningModule.findMany({
      where: { status: { not: "ARCHIVED" } },
      select: { id: true, code: true, title: true, cadence: true, passMark: true },
    }),
  ]);
  const modBy = new Map(modules.map((m) => [m.id, m]));
  const empIds = employees.map((e) => e.id);
  const records = await prisma.learningRecord.findMany({
    where: { employeeId: { in: empIds } },
    select: {
      id: true, employeeId: true, moduleId: true, status: true, dueDate: true, period: true,
      score: true, passed: true,
    },
  });
  // index records by employee+module+period
  const recKey = (e: string, m: string, p: string) => `${e}::${m}::${p}`;
  const recBy = new Map(records.map((r) => [recKey(r.employeeId, r.moduleId, r.period), r]));

  const summaries: ComplianceSummary[] = [];
  const allCells: ComplianceCell[] = [];

  for (const e of employees) {
    const grade = personGrade(e);
    const { required, recommended, requirementByModule } = requiredSetFor(grade, e.jobProfileId, rules);
    const moduleIdsForPerson = [...required, ...recommended];
    let requiredMet = 0;
    let openGaps = 0;
    for (const mid of moduleIdsForPerson) {
      const mod = modBy.get(mid);
      if (!mod) continue;
      const period = currentPeriodFor(mod.cadence, asOf);
      const rec = recBy.get(recKey(e.id, mid, period));
      const status = rec ? rec.status : "MISSING";
      const requirement = requirementByModule[mid];
      const met = rec
        ? isComplete({ status: rec.status, passed: rec.passed }, { passMark: mod.passMark })
        : false;
      if (requirement === "REQUIRED") {
        if (met) requiredMet += 1;
        else openGaps += 1;
      }
      allCells.push({
        recordId: rec?.id ?? null,
        employeeId: e.id, employeeName: nameOf(e), eeId: e.eeId,
        moduleId: mid, moduleCode: mod.code, moduleTitle: mod.title,
        requirement, status: met && status !== "WAIVED" ? "COMPLETED" : status,
        dueDate: rec?.dueDate ?? null, score: rec?.score ?? null,
        passed: rec?.passed ?? null, period,
      });
    }
    const requiredTotal = required.length;
    summaries.push({
      employeeId: e.id, employeeName: nameOf(e), eeId: e.eeId,
      requiredTotal, requiredMet,
      pct: requiredTotal === 0 ? 100 : Math.round((requiredMet / requiredTotal) * 100),
      openGaps,
    });
  }

  const gapRows = allCells.filter(
    (c) => c.requirement === "REQUIRED" && c.status !== "COMPLETED" && c.status !== "WAIVED"
  );
  const gaps = rankGaps(gapRows as (ComplianceCell & GapRow)[], asOf);
  // worst staff first
  summaries.sort((a, b) => b.openGaps - a.openGaps || a.pct - b.pct || a.eeId.localeCompare(b.eeId));

  return {
    summaries, gaps,
    asOfYear: String(asOf.getUTCFullYear()),
    staffCount: employees.length,
    moduleCount: modules.length,
  };
}

// ── One person's training record (the staff-file slice) ──────────────────────
export type EmployeeComplianceView = {
  employeeId: string;
  employeeName: string;
  eeId: string;
  grade: string | null;
  cells: ComplianceCell[];
  requiredTotal: number;
  requiredMet: number;
  pct: number;
};
export async function getEmployeeCompliance(
  employeeId: string,
  asOf: Date = new Date()
): Promise<EmployeeComplianceView | null> {
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: {
      id: true, eeId: true, fullName: true, preferredName: true, grade: true,
      jobProfileId: true, jobProfile: { select: { grade: true } },
    },
  });
  if (!e) return null;
  const rules = await loadRules();
  const grade = personGrade(e);
  const { required, recommended, requirementByModule } = requiredSetFor(grade, e.jobProfileId, rules);
  const ids = [...required, ...recommended];
  const [modules, records] = await Promise.all([
    prisma.learningModule.findMany({
      where: { id: { in: ids } },
      select: { id: true, code: true, title: true, cadence: true, passMark: true },
    }),
    prisma.learningRecord.findMany({
      where: { employeeId, moduleId: { in: ids } },
      select: { id: true, moduleId: true, status: true, dueDate: true, period: true, score: true, passed: true },
    }),
  ]);
  const modBy = new Map(modules.map((m) => [m.id, m]));
  const recBy = new Map(records.map((r) => [`${r.moduleId}::${r.period}`, r]));
  let requiredMet = 0;
  const cells: ComplianceCell[] = [];
  for (const mid of ids) {
    const mod = modBy.get(mid);
    if (!mod) continue;
    const period = currentPeriodFor(mod.cadence, asOf);
    const rec = recBy.get(`${mid}::${period}`);
    const status = rec ? rec.status : "MISSING";
    const requirement = requirementByModule[mid];
    const met = rec
      ? isComplete({ status: rec.status, passed: rec.passed }, { passMark: mod.passMark })
      : false;
    if (requirement === "REQUIRED" && met) requiredMet += 1;
    cells.push({
      recordId: rec?.id ?? null,
      employeeId, employeeName: nameOf(e), eeId: e.eeId,
      moduleId: mid, moduleCode: mod.code, moduleTitle: mod.title,
      requirement, status: met && status !== "WAIVED" ? "COMPLETED" : status,
      dueDate: rec?.dueDate ?? null, score: rec?.score ?? null,
      passed: rec?.passed ?? null, period,
    });
  }
  cells.sort((a, b) =>
    a.requirement !== b.requirement ? (a.requirement === "REQUIRED" ? -1 : 1) : (a.moduleCode ?? "").localeCompare(b.moduleCode ?? "")
  );
  const requiredTotal = required.length;
  return {
    employeeId: e.id, employeeName: nameOf(e), eeId: e.eeId, grade,
    cells, requiredTotal, requiredMet,
    pct: requiredTotal === 0 ? 100 : Math.round((requiredMet / requiredTotal) * 100),
  };
}
