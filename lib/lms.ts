// =============================================================================
// lib/lms.ts — Transworld PeopleOps Portal: the pure WS7 LMS engine (v0.42.0).
//
// Import-free by design (no React, no Prisma, no server imports) so it runs under
// `tsx` with no database — exactly like lib/ws5.ts / lib/raise.ts. DB reads and
// server actions live in sibling files (lib/lms-data.ts, lib/lms-actions.ts).
//
// What lives here:
//   - the WS7 vocabularies (domain / level / cadence / rule scope / requirement /
//     question type) as CHECK-mirroring constants + label/badge helpers;
//   - currentPeriodFor(cadence, asOf)  — the recurrence-instance key;
//   - requiredSetFor(grade, jobProfileId, rules) — resolve the assignment matrix;
//   - gradeQuiz(questions, answers, passMark) — SERVER-SIDE grader;
//   - isComplete(record, module) — the passed-gate completion rule;
//   - rankGaps(rows) — compliance gaps, worst-first.
// =============================================================================

// ── Vocabularies (mirror the migration CHECK constraints exactly) ────────────
export const LMS_DOMAINS = [
  { value: "FND", label: "Foundational" },
  { value: "CLA", label: "Client & Advisory" },
  { value: "FIN", label: "Finance & Accounting" },
  { value: "INV", label: "Investment & Markets" },
  { value: "LDR", label: "Leadership & Governance" },
  { value: "OPS", label: "Operations & Controls" },
  { value: "REG", label: "Regulatory & Compliance" },
  { value: "TEC", label: "Technology" },
  { value: "BDV", label: "Business Development" },
  { value: "PPL", label: "People Operations" },
] as const;
export type LmsDomain = (typeof LMS_DOMAINS)[number]["value"];

export const LMS_LEVELS = [
  { value: "F", label: "Foundational" },
  { value: "P", label: "Proficient" },
  { value: "E", label: "Expert" },
] as const;
export type LmsLevel = (typeof LMS_LEVELS)[number]["value"];

export const LMS_CADENCES = [
  { value: "ON_JOIN", label: "On joining" },
  { value: "ANNUAL", label: "Annual" },
  { value: "ON_JOIN_ANNUAL", label: "On joining + annual" },
  { value: "PERIODIC", label: "Periodic" },
  { value: "ON_RENEWAL", label: "On renewal" },
] as const;
export type LmsCadence = (typeof LMS_CADENCES)[number]["value"];

export const LMS_OWNERS = [
  { value: "CCO", label: "Chief Compliance Officer" },
  { value: "PEOPLE_OPS", label: "People-Ops" },
  { value: "FUNCTION_HEAD", label: "Function head" },
] as const;

export const RULE_SCOPES = [
  { value: "ALL", label: "All staff (firmwide)" },
  { value: "GRADE", label: "By grade" },
  { value: "JOB_PROFILE", label: "By role" },
] as const;
export type RuleScope = (typeof RULE_SCOPES)[number]["value"];

export const RULE_REQUIREMENTS = [
  { value: "REQUIRED", label: "Required" },
  { value: "RECOMMENDED", label: "Recommended" },
] as const;
export type RuleRequirement = (typeof RULE_REQUIREMENTS)[number]["value"];

export const QUESTION_TYPES = [
  { value: "SINGLE", label: "Single answer" },
  { value: "MULTI", label: "Multiple answers" },
  { value: "TRUE_FALSE", label: "True / false" },
] as const;
export type QuestionType = (typeof QUESTION_TYPES)[number]["value"];

export const LMS_GRADES = ["G0", "G1", "G2", "G3", "G4", "G5", "PT"] as const;

// ── Label helpers ────────────────────────────────────────────────────────────
function lookup(
  list: ReadonlyArray<{ value: string; label: string }>,
  value: string | null | undefined
): string {
  if (!value) return "—";
  const hit = list.find((x) => x.value === value);
  return hit ? hit.label : value;
}
export const domainLabel = (v: string | null | undefined) => lookup(LMS_DOMAINS, v);
export const levelLabel = (v: string | null | undefined) => lookup(LMS_LEVELS, v);
export const cadenceLabel = (v: string | null | undefined) => lookup(LMS_CADENCES, v);
export const ownerLabel = (v: string | null | undefined) => lookup(LMS_OWNERS, v);
export const scopeLabel = (v: string | null | undefined) => lookup(RULE_SCOPES, v);
export const requirementLabel = (v: string | null | undefined) =>
  lookup(RULE_REQUIREMENTS, v);
export const questionTypeLabel = (v: string | null | undefined) =>
  lookup(QUESTION_TYPES, v);

export function requirementBadge(req: string): { cls: string; label: string } {
  return req === "REQUIRED"
    ? { cls: "b b-red", label: "Required" }
    : { cls: "b b-blu", label: "Recommended" };
}

// ── currentPeriodFor — the recurrence-instance key ───────────────────────────
// ON_JOIN modules are once-per-person ('JOIN'). Recurring cadences key on the
// calendar year (the cycle is Jan–Dec), so each year's mandatory completion is
// its own immutable learning_records row.
export function currentPeriodFor(
  cadence: string | null | undefined,
  asOf: Date = new Date()
): string {
  if (!cadence || cadence === "ON_JOIN" || cadence === "ON_RENEWAL") return "JOIN";
  return String(asOf.getUTCFullYear());
}

// ── requiredSetFor — resolve the assignment matrix for one person ────────────
export type AssignmentRule = {
  moduleId: string;
  scope: string; // ALL | GRADE | JOB_PROFILE
  grade: string | null;
  jobProfileId: string | null;
  requirement: string; // REQUIRED | RECOMMENDED
  active: boolean;
};
export type RequiredSet = {
  required: string[]; // moduleIds
  recommended: string[]; // moduleIds (excludes any also required)
  requirementByModule: Record<string, RuleRequirement>;
};

function ruleApplies(
  rule: AssignmentRule,
  grade: string | null,
  jobProfileId: string | null
): boolean {
  if (!rule.active) return false;
  if (rule.scope === "ALL") return true;
  if (rule.scope === "GRADE") return !!grade && rule.grade === grade;
  if (rule.scope === "JOB_PROFILE")
    return !!jobProfileId && rule.jobProfileId === jobProfileId;
  return false;
}

export function requiredSetFor(
  grade: string | null,
  jobProfileId: string | null,
  rules: AssignmentRule[]
): RequiredSet {
  const req = new Set<string>();
  const rec = new Set<string>();
  for (const rule of rules) {
    if (!ruleApplies(rule, grade, jobProfileId)) continue;
    if (rule.requirement === "REQUIRED") req.add(rule.moduleId);
    else rec.add(rule.moduleId);
  }
  // A module that is required anywhere outranks a recommended rule for it.
  for (const id of req) rec.delete(id);
  const requirementByModule: Record<string, RuleRequirement> = {};
  for (const id of req) requirementByModule[id] = "REQUIRED";
  for (const id of rec) requirementByModule[id] = "RECOMMENDED";
  return {
    required: Array.from(req),
    recommended: Array.from(rec),
    requirementByModule,
  };
}

// ── gradeQuiz — the server-side grader ───────────────────────────────────────
export type QuizOption = { key: string; text: string };
export type QuizQuestion = {
  id: string;
  type: string; // SINGLE | MULTI | TRUE_FALSE
  options: QuizOption[];
  correct: string[]; // option keys
};
export type QuizAnswers = Record<string, string[]>; // questionId -> chosen keys
export type QuizResult = {
  total: number;
  correctCount: number;
  score: number; // 0..100 integer
  passed: boolean;
  perQuestion: Record<string, boolean>;
};

function sameKeySet(a: string[], b: string[]): boolean {
  if (a.length !== b.length) return false;
  const sa = new Set(a);
  for (const k of b) if (!sa.has(k)) return false;
  return true;
}

export function gradeQuiz(
  questions: QuizQuestion[],
  answers: QuizAnswers,
  passMark: number
): QuizResult {
  const total = questions.length;
  const perQuestion: Record<string, boolean> = {};
  let correctCount = 0;
  for (const q of questions) {
    const given = (answers[q.id] ?? []).map((s) => String(s));
    // SINGLE / TRUE_FALSE: exactly one chosen key must equal the one correct key.
    // MULTI: the chosen set must equal the correct set exactly (no partial credit).
    const ok =
      q.type === "MULTI"
        ? sameKeySet(given, q.correct)
        : given.length === 1 && q.correct.length === 1 && given[0] === q.correct[0];
    perQuestion[q.id] = ok;
    if (ok) correctCount += 1;
  }
  const score = total === 0 ? 0 : Math.round((correctCount / total) * 100);
  return { total, correctCount, score, passed: score >= passMark, perQuestion };
}

// ── isComplete — the passed-gate completion rule ─────────────────────────────
// A graded module (passMark set) is COMPLETE only when the record is passed.
// An ungraded module is complete on status COMPLETED or WAIVED.
export function isComplete(
  record: { status: string; passed?: boolean | null },
  module: { passMark?: number | null }
): boolean {
  if (record.status === "WAIVED") return true;
  if (module.passMark != null) return record.status === "COMPLETED" && record.passed === true;
  return record.status === "COMPLETED";
}

// ── rankGaps — compliance gaps, worst-first ──────────────────────────────────
export type GapRow = {
  employeeId: string;
  moduleId: string;
  requirement: string; // REQUIRED | RECOMMENDED
  status: string; // ASSIGNED | IN_PROGRESS | COMPLETED | WAIVED | MISSING
  dueDate: Date | null;
};
const STATUS_RANK: Record<string, number> = {
  MISSING: 0,
  ASSIGNED: 1,
  IN_PROGRESS: 2,
  COMPLETED: 9,
  WAIVED: 9,
};
export function isGap(row: { requirement: string; status: string }): boolean {
  return (
    row.requirement === "REQUIRED" &&
    row.status !== "COMPLETED" &&
    row.status !== "WAIVED"
  );
}
export function rankGaps<T extends GapRow>(rows: T[], asOf: Date = new Date()): T[] {
  return [...rows].sort((a, b) => {
    // required before recommended
    if (a.requirement !== b.requirement) return a.requirement === "REQUIRED" ? -1 : 1;
    // overdue before not-yet-due
    const aOver = a.dueDate != null && a.dueDate.getTime() < asOf.getTime();
    const bOver = b.dueDate != null && b.dueDate.getTime() < asOf.getTime();
    if (aOver !== bOver) return aOver ? -1 : 1;
    // worse status first (missing < assigned < in-progress < done)
    const sa = STATUS_RANK[a.status] ?? 5;
    const sb = STATUS_RANK[b.status] ?? 5;
    if (sa !== sb) return sa - sb;
    // oldest due date first
    const da = a.dueDate ? a.dueDate.getTime() : Number.MAX_SAFE_INTEGER;
    const db = b.dueDate ? b.dueDate.getTime() : Number.MAX_SAFE_INTEGER;
    return da - db;
  });
}

// ── complianceBadge — a one-glance status pill ───────────────────────────────
export function complianceBadge(status: string): { cls: string; label: string } {
  switch (status) {
    case "COMPLETED":
      return { cls: "b b-grn", label: "Completed" };
    case "WAIVED":
      return { cls: "b b-gry", label: "Waived" };
    case "IN_PROGRESS":
      return { cls: "b b-amb", label: "In progress" };
    case "ASSIGNED":
      return { cls: "b b-blu", label: "Assigned" };
    case "MISSING":
      return { cls: "b b-red", label: "Not assigned" };
    default:
      return { cls: "b b-gry", label: status };
  }
}
