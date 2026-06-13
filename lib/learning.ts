// lib/learning.ts — Learning & Development read layer + presentation helpers.
// Read-only here; audited writes live in lib/learning-actions.ts.
//
// The module is a self-serve library of training material (markdown, read in the
// portal) that staff work through, plus an employee handbook. Each module is
// tagged to the competency catalog so a supervisor can recommend targeted modules
// off a weak appraisal, and so completion feeds the development picture.
//
// Cross-entity references on the new models (competency_id, employee_id,
// recommended_by_id, appraisal_id) are bare columns — resolved by id at the edge.
import { prisma } from "@/lib/db";
import { getLatestDocument, prettySize } from "@/lib/documents";

// ---------------------------------------------------------------------------
// Vocabularies
// ---------------------------------------------------------------------------
export const LEARNING_CATEGORIES = [
  "Compliance & Regulatory",
  "Technical & Functional",
  "Leadership & Professional",
  "Onboarding",
] as const;

export const MODULE_STATUSES = [
  { value: "DRAFT", label: "Draft" },
  { value: "PUBLISHED", label: "Published" },
] as const;

export const RECORD_STATUSES = [
  { value: "ASSIGNED", label: "Assigned" },
  { value: "IN_PROGRESS", label: "In progress" },
  { value: "COMPLETED", label: "Completed" },
  { value: "WAIVED", label: "Waived" },
] as const;

export const RECORD_SOURCES = [
  { value: "SELF", label: "Self-enrolled" },
  { value: "RECOMMENDED", label: "Recommended" },
  { value: "MANDATORY", label: "Mandatory" },
] as const;

export const LEARNING_MATERIAL = "LEARNING_MATERIAL";
export const HANDBOOK_CATEGORY = "HANDBOOK";

// ---------------------------------------------------------------------------
// Formatting + badges
// ---------------------------------------------------------------------------
export function fmtMinutes(m: number | null | undefined): string {
  if (!m || m <= 0) return "—";
  if (m < 60) return `${m} min`;
  const h = Math.floor(m / 60);
  const rem = m % 60;
  return rem ? `${h} h ${rem} min` : `${h} h`;
}

export function pct(done: number, total: number): number {
  if (total <= 0) return 0;
  return Math.round((done / total) * 100);
}

export function moduleStatusBadge(status: string): { cls: string; label: string } {
  switch (status) {
    case "PUBLISHED":
      return { cls: "b-grn", label: "Published" };
    case "DRAFT":
      return { cls: "b-gry", label: "Draft" };
    default:
      return { cls: "b-gry", label: status };
  }
}

export function sourceBadge(source: string): { cls: string; label: string } {
  switch (source) {
    case "RECOMMENDED":
      return { cls: "b-blu", label: "Recommended" };
    case "MANDATORY":
      return { cls: "b-amb", label: "Mandatory" };
    case "SELF":
      return { cls: "b-gry", label: "Self-enrolled" };
    default:
      return { cls: "b-gry", label: source };
  }
}

export function isOverdue(status: string, dueDate: Date | null | undefined): boolean {
  if (status === "COMPLETED" || status === "WAIVED") return false;
  if (!dueDate) return false;
  return dueDate.getTime() < Date.now();
}

/** Display badge for a record, deriving the OVERDUE state from the due date. */
export function recordStatusBadge(
  status: string,
  dueDate: Date | null | undefined
): { cls: string; label: string } {
  if (isOverdue(status, dueDate)) return { cls: "b-red", label: "Overdue" };
  switch (status) {
    case "COMPLETED":
      return { cls: "b-grn", label: "Completed" };
    case "IN_PROGRESS":
      return { cls: "b-amb", label: "In progress" };
    case "WAIVED":
      return { cls: "b-gry", label: "Waived" };
    case "ASSIGNED":
      return { cls: "b-blu", label: "Assigned" };
    default:
      return { cls: "b-gry", label: status };
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

async function competencyNames(ids: string[]): Promise<Map<string, string>> {
  const want = Array.from(new Set(ids.filter(Boolean)));
  if (want.length === 0) return new Map();
  const rows = await prisma.competency.findMany({
    where: { id: { in: want } },
    select: { id: true, name: true },
  });
  return new Map(rows.map((c) => [c.id, c.name] as const));
}

/** Resolve the employee linked to a login user (userId is unique on Employee). */
export async function getMyEmployee(
  userId: string
): Promise<{ id: string; eeId: string; name: string } | null> {
  const e = await prisma.employee.findUnique({
    where: { userId },
    select: { id: true, eeId: true, fullName: true, preferredName: true },
  });
  return e ? { id: e.id, eeId: e.eeId, name: personName(e) } : null;
}

// ---------------------------------------------------------------------------
// Library (course catalog + completion)
// ---------------------------------------------------------------------------
export type LibraryRow = {
  id: string;
  title: string;
  code: string | null;
  domain: string | null;
  level: string | null;
  isMandatory: boolean;
  category: string;
  status: string;
  estimatedMinutes: number | null;
  competencies: string[];
  enrolled: number;
  completed: number;
  inProgress: number;
  overdue: number;
  completionPct: number;
};

export type LibraryView = {
  rows: LibraryRow[];
  kpis: { modules: number; completions: number; inProgress: number; overdue: number };
};

export async function getLibrary(includeDrafts: boolean): Promise<LibraryView> {
  const modules = await prisma.learningModule.findMany({
    where: includeDrafts ? { status: { not: "ARCHIVED" } } : { status: "PUBLISHED" },
    include: {
      competencies: { select: { competencyId: true } },
      records: { select: { status: true, dueDate: true } },
    },
    orderBy: [{ domain: "asc" }, { code: "asc" }, { category: "asc" }, { title: "asc" }],
  });

  const names = await competencyNames(
    modules.flatMap((m) => m.competencies.map((c) => c.competencyId))
  );

  let completions = 0;
  let inProgressTotal = 0;
  let overdueTotal = 0;

  const rows: LibraryRow[] = modules.map((m) => {
    const enrolled = m.records.length;
    const completed = m.records.filter((r) => r.status === "COMPLETED").length;
    const inProgress = m.records.filter(
      (r) => r.status === "ASSIGNED" || r.status === "IN_PROGRESS"
    ).length;
    const overdue = m.records.filter((r) => isOverdue(r.status, r.dueDate)).length;
    completions += completed;
    inProgressTotal += inProgress;
    overdueTotal += overdue;
    return {
      id: m.id,
      title: m.title,
      code: m.code,
      domain: m.domain,
      level: m.level,
      isMandatory: m.isMandatory,
      category: m.category,
      status: m.status,
      estimatedMinutes: m.estimatedMinutes,
      competencies: m.competencies
        .map((c) => names.get(c.competencyId))
        .filter((n): n is string => !!n),
      enrolled,
      completed,
      inProgress,
      overdue,
      completionPct: pct(completed, enrolled),
    };
  });

  return {
    rows,
    kpis: {
      modules: modules.filter((m) => m.status === "PUBLISHED").length,
      completions,
      inProgress: inProgressTotal,
      overdue: overdueTotal,
    },
  };
}

// ---------------------------------------------------------------------------
// One module (read + roster)
// ---------------------------------------------------------------------------
export type RosterRecord = {
  recordId: string;
  employeeId: string;
  eeId: string;
  name: string;
  source: string;
  status: string;
  dueDate: Date | null;
  completedAt: Date | null;
};

export type ModuleView = {
  module: {
    id: string;
    title: string;
    code: string | null;
    domain: string | null;
    level: string | null;
    isMandatory: boolean;
    passMark: number | null;
    category: string;
    summary: string | null;
    body: string | null;
    estimatedMinutes: number | null;
    status: string;
    updatedAt: Date;
  };
  competencies: { id: string; name: string }[];
  roster: RosterRecord[];
  material: { filename: string; sizeLabel: string } | null;
};

export async function getModule(moduleId: string): Promise<ModuleView | null> {
  const m = await prisma.learningModule.findUnique({
    where: { id: moduleId },
    include: { competencies: { select: { competencyId: true } } },
  });
  if (!m) return null;

  const [names, records, material] = await Promise.all([
    competencyNames(m.competencies.map((c) => c.competencyId)),
    prisma.learningRecord.findMany({
      where: { moduleId },
      orderBy: [{ status: "asc" }, { assignedAt: "desc" }],
    }),
    getLatestDocument("learning_module", moduleId, LEARNING_MATERIAL),
  ]);

  const empIds = Array.from(new Set(records.map((r) => r.employeeId)));
  const employees = empIds.length
    ? await prisma.employee.findMany({
        where: { id: { in: empIds } },
        select: { id: true, eeId: true, fullName: true, preferredName: true },
      })
    : [];
  const empById = new Map(employees.map((e) => [e.id, e] as const));

  const roster: RosterRecord[] = records.map((r) => {
    const e = empById.get(r.employeeId);
    return {
      recordId: r.id,
      employeeId: r.employeeId,
      eeId: e?.eeId ?? "—",
      name: e ? personName(e) : "Unknown",
      source: r.source,
      status: r.status,
      dueDate: r.dueDate,
      completedAt: r.completedAt,
    };
  });

  return {
    module: {
      id: m.id,
      title: m.title,
      code: m.code,
      domain: m.domain,
      level: m.level,
      isMandatory: m.isMandatory,
      passMark: m.passMark,
      category: m.category,
      summary: m.summary,
      body: m.body,
      estimatedMinutes: m.estimatedMinutes,
      status: m.status,
      updatedAt: m.updatedAt,
    },
    competencies: m.competencies
      .map((c) => ({ id: c.competencyId, name: names.get(c.competencyId) }))
      .filter((c): c is { id: string; name: string } => !!c.name),
    roster,
    material: material
      ? { filename: material.filename, sizeLabel: prettySize(material.sizeBytes) }
      : null,
  };
}

/** The signed-in employee's record for one module (drives the self-serve controls). */
export async function getRecordForEmployee(
  moduleId: string,
  employeeId: string
): Promise<{
  id: string;
  source: string;
  status: string;
  dueDate: Date | null;
  startedAt: Date | null;
  completedAt: Date | null;
  reflection: string | null;
} | null> {
  const r = await prisma.learningRecord.findFirst({
    where: { moduleId, employeeId },
    orderBy: { createdAt: "desc" },
    select: {
      id: true,
      source: true,
      status: true,
      dueDate: true,
      startedAt: true,
      completedAt: true,
      reflection: true,
    },
  });
  return r;
}

// ---------------------------------------------------------------------------
// One employee's learning (My learning / Development card / recommend context)
// ---------------------------------------------------------------------------
export type LearningRecordRow = {
  recordId: string;
  moduleId: string;
  title: string;
  code: string | null;
  category: string;
  source: string;
  status: string;
  assignedAt: Date;
  dueDate: Date | null;
  completedAt: Date | null;
  reflection: string | null;
  recommendedBy: string | null;
};

export async function getEmployeeRecords(employeeId: string): Promise<LearningRecordRow[]> {
  const records = await prisma.learningRecord.findMany({
    where: { employeeId },
    include: { module: { select: { title: true, code: true, category: true } } },
    orderBy: [{ assignedAt: "desc" }],
  });
  if (records.length === 0) return [];

  const recById = await resolveUserNames(records.map((r) => r.recommendedById));

  return records.map((r) => ({
    recordId: r.id,
    moduleId: r.moduleId,
    title: r.module.title,
    code: r.module.code,
    category: r.module.category,
    source: r.source,
    status: r.status,
    assignedAt: r.assignedAt,
    dueDate: r.dueDate,
    completedAt: r.completedAt,
    reflection: r.reflection,
    recommendedBy: r.recommendedById ? recById.get(r.recommendedById) ?? null : null,
  }));
}

async function resolveUserNames(
  ids: (string | null | undefined)[]
): Promise<Map<string, string>> {
  const want = Array.from(new Set(ids.filter((x): x is string => !!x)));
  if (want.length === 0) return new Map();
  const users = await prisma.user.findMany({
    where: { id: { in: want } },
    select: { id: true, name: true },
  });
  return new Map(users.map((u) => [u.id, u.name] as const));
}

export type MyLearningView =
  | { linked: false }
  | {
      linked: true;
      employee: { id: string; eeId: string; name: string };
      records: LearningRecordRow[];
      available: { id: string; title: string; code: string | null; category: string; estimatedMinutes: number | null }[];
    };

export async function getMyLearning(userId: string): Promise<MyLearningView> {
  const me = await getMyEmployee(userId);
  if (!me) return { linked: false };

  const records = await getEmployeeRecords(me.id);
  const haveModuleIds = new Set(records.map((r) => r.moduleId));

  const published = await prisma.learningModule.findMany({
    where: { status: "PUBLISHED" },
    select: { id: true, title: true, code: true, category: true, estimatedMinutes: true },
    orderBy: [{ category: "asc" }, { title: "asc" }],
  });

  return {
    linked: true,
    employee: me,
    records,
    available: published.filter((m) => !haveModuleIds.has(m.id)),
  };
}

// ---------------------------------------------------------------------------
// Recommend screen data (optionally seeded from a weak appraisal)
// ---------------------------------------------------------------------------
export type RecommendModule = {
  id: string;
  title: string;
  category: string;
  competencies: string[];
  alreadyHas: boolean;
  suggested: boolean;
};

export type RecommendData = {
  employee: { id: string; eeId: string; name: string; role: string | null };
  modules: RecommendModule[];
  appraisal: { id: string; cycleId: string | null; belowCompetencies: string[] } | null;
};

export async function getRecommendData(
  employeeId: string,
  appraisalId?: string | null
): Promise<RecommendData | null> {
  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      preferredName: true,
      jobProfile: { select: { title: true } },
    },
  });
  if (!employee) return null;

  const [modules, existing] = await Promise.all([
    prisma.learningModule.findMany({
      where: { status: "PUBLISHED" },
      include: { competencies: { select: { competencyId: true } } },
      orderBy: [{ category: "asc" }, { title: "asc" }],
    }),
    prisma.learningRecord.findMany({
      where: { employeeId },
      select: { moduleId: true },
    }),
  ]);

  const names = await competencyNames(
    modules.flatMap((m) => m.competencies.map((c) => c.competencyId))
  );
  const haveModuleIds = new Set(existing.map((r) => r.moduleId));

  // If launched from an appraisal, find the competencies rated "Below" and the
  // modules tagged to them (matched competency name -> id).
  let appraisalCtx: RecommendData["appraisal"] = null;
  const suggestedCompetencyIds = new Set<string>();
  if (appraisalId) {
    const appraisal = await prisma.appraisal.findUnique({
      where: { id: appraisalId },
      select: { id: true, cycleId: true },
    });
    if (appraisal) {
      const items = await prisma.appraisalItem.findMany({
        where: { appraisalId },
        select: {
          kind: true,
          label: true,
          rating: true,
          assessedLevel: true,
          expectedLevel: true,
        },
      });
      const belowLabels = items
        .filter(
          (it) =>
            it.kind === "COMPETENCY" &&
            (it.rating === "BELOW" ||
              (it.assessedLevel != null &&
                it.expectedLevel != null &&
                it.assessedLevel < it.expectedLevel))
        )
        .map((it) => it.label);

      if (belowLabels.length) {
        const matched = await prisma.competency.findMany({
          where: { name: { in: belowLabels } },
          select: { id: true },
        });
        for (const c of matched) suggestedCompetencyIds.add(c.id);
      }
      appraisalCtx = {
        id: appraisal.id,
        cycleId: appraisal.cycleId,
        belowCompetencies: Array.from(new Set(belowLabels)),
      };
    }
  }

  const recModules: RecommendModule[] = modules.map((m) => {
    const tagIds = m.competencies.map((c) => c.competencyId);
    return {
      id: m.id,
      title: m.title,
      category: m.category,
      competencies: tagIds.map((id) => names.get(id)).filter((n): n is string => !!n),
      alreadyHas: haveModuleIds.has(m.id),
      suggested: tagIds.some((id) => suggestedCompetencyIds.has(id)),
    };
  });

  return {
    employee: {
      id: employee.id,
      eeId: employee.eeId,
      name: personName(employee),
      role: employee.jobProfile?.title ?? null,
    },
    modules: recModules,
    appraisal: appraisalCtx,
  };
}

// ---------------------------------------------------------------------------
// Employee handbook (built on policies / policy_acknowledgments)
// ---------------------------------------------------------------------------
export type HandbookView = {
  current: {
    id: string;
    title: string;
    version: string;
    summary: string | null;
    body: string | null;
    effectiveDate: Date | null;
  } | null;
  versions: { id: string; title: string; version: string; isCurrent: boolean; createdAt: Date }[];
  ack: { acknowledged: number; total: number; pending: { id: string; eeId: string; name: string }[] };
  myAck: { linked: boolean; acknowledged: boolean };
};

export async function getHandbook(userId: string): Promise<HandbookView> {
  const policies = await prisma.policy.findMany({
    where: { category: HANDBOOK_CATEGORY },
    orderBy: [{ isCurrent: "desc" }, { createdAt: "desc" }],
  });
  const current = policies.find((p) => p.isCurrent) ?? null;

  let ack = { acknowledged: 0, total: 0, pending: [] as { id: string; eeId: string; name: string }[] };
  if (current) {
    const [staff, acks] = await Promise.all([
      prisma.employee.findMany({
        where: { status: { not: "EXITED" } },
        select: { id: true, eeId: true, fullName: true, preferredName: true },
        orderBy: { eeId: "asc" },
      }),
      prisma.policyAcknowledgment.findMany({
        where: { policyId: current.id },
        select: { employeeId: true },
      }),
    ]);
    const ackedIds = new Set(acks.map((a) => a.employeeId));
    ack = {
      acknowledged: staff.filter((s) => ackedIds.has(s.id)).length,
      total: staff.length,
      pending: staff
        .filter((s) => !ackedIds.has(s.id))
        .map((s) => ({ id: s.id, eeId: s.eeId, name: personName(s) })),
    };
  }

  let myAck = { linked: false, acknowledged: false };
  const me = await getMyEmployee(userId);
  if (me && current) {
    const mine = await prisma.policyAcknowledgment.findUnique({
      where: { policyId_employeeId: { policyId: current.id, employeeId: me.id } },
      select: { id: true },
    });
    myAck = { linked: true, acknowledged: !!mine };
  } else if (me) {
    myAck = { linked: true, acknowledged: false };
  }

  return {
    current: current
      ? {
          id: current.id,
          title: current.title,
          version: current.version,
          summary: current.summary ?? null,
          body: current.body ?? null,
          effectiveDate: current.effectiveDate ?? null,
        }
      : null,
    versions: policies.map((p) => ({
      id: p.id,
      title: p.title,
      version: p.version,
      isCurrent: p.isCurrent,
      createdAt: p.createdAt,
    })),
    ack,
    myAck,
  };
}

// ---------------------------------------------------------------------------
// Minimal, safe markdown -> HTML for in-portal reading material.
// HTML is escaped first so any raw markup in author content is inert; a small
// set of markdown constructs is then applied. Authors are trusted HR staff.
// ---------------------------------------------------------------------------
export function markdownToHtml(src: string | null | undefined): string {
  if (!src) return "";
  const esc = (s: string) =>
    s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

  const inline = (s: string) =>
    esc(s)
      .replace(/`([^`]+)`/g, "<code>$1</code>")
      .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
      .replace(/(^|[^*])\*([^*]+)\*/g, "$1<em>$2</em>")
      .replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g, '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>');

  const lines = src.replace(/\r\n/g, "\n").split("\n");
  const out: string[] = [];
  let para: string[] = [];
  let list: { type: "ul" | "ol"; items: string[] } | null = null;
  let callout: { warn: boolean; lines: string[] } | null = null;

  const flushPara = () => {
    if (para.length) {
      out.push(`<p>${inline(para.join(" "))}</p>`);
      para = [];
    }
  };
  const flushList = () => {
    if (list) {
      const inner = list.items.map((i) => `<li>${inline(i)}</li>`).join("");
      out.push(`<${list.type}>${inner}</${list.type}>`);
      list = null;
    }
  };
  const flushCallout = () => {
    if (callout) {
      const cls = callout.warn ? "callout callout-warn" : "callout";
      out.push(`<div class="${cls}">${inline(callout.lines.join(" "))}</div>`);
      callout = null;
    }
  };
  const flushAll = () => {
    flushPara();
    flushList();
    flushCallout();
  };

  for (const raw of lines) {
    const line = raw.trimEnd();
    if (line.trim() === "") {
      flushAll();
      continue;
    }
    const quote = line.match(/^>(!)?\s?(.*)$/);
    const hr = line.match(/^-{3,}$/);
    const h3 = line.match(/^###\s+(.*)$/);
    const h2 = line.match(/^##\s+(.*)$/);
    const ul = line.match(/^[-*]\s+(.*)$/);
    const ol = line.match(/^\d+\.\s+(.*)$/);
    if (quote) {
      flushPara();
      flushList();
      const warn = quote[1] === "!";
      if (!callout) callout = { warn, lines: [] };
      callout.lines.push(quote[2]);
    } else if (hr) {
      flushAll();
      out.push(`<hr class="rule" />`);
    } else if (h3) {
      flushAll();
      out.push(`<h3>${inline(h3[1])}</h3>`);
    } else if (h2) {
      flushAll();
      out.push(`<h2>${inline(h2[1])}</h2>`);
    } else if (ul) {
      flushPara();
      flushCallout();
      if (!list || list.type !== "ul") {
        flushList();
        list = { type: "ul", items: [] };
      }
      list.items.push(ul[1]);
    } else if (ol) {
      flushPara();
      flushCallout();
      if (!list || list.type !== "ol") {
        flushList();
        list = { type: "ol", items: [] };
      }
      list.items.push(ol[1]);
    } else {
      flushList();
      flushCallout();
      para.push(line.trim());
    }
  }
  flushAll();
  return out.join("\n");
}
