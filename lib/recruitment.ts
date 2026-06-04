// Read-side helpers for the Recruitment module. Pure formatters + badge mappers
// and the queries that back the Recruitment overview and the per-requisition
// pipeline. No writes here — those live in lib/recruitment-actions.ts. Mirrors
// the shape of lib/leave.ts. Cross-entity references (department_id,
// job_profile_id) are bare columns, resolved by lookup here.
//
// v0.39.0 (WS3 depth): the eleven-stage hiring pipeline (Stages 4-10 are the
// candidate journey; SHORTLISTED / SELECTED / CHECKS added), the Stage-8
// verification-check catalog + applicability, the ten-stage stepper helpers,
// and the requisition gate (Stages 1-3) + per-candidate checks + stage-event
// trail folded into OpeningDetail / CandidateView.
import { prisma } from "@/lib/db";

export const STAGES = [
  "SOURCED",
  "SCREENING",
  "ASSESSMENT",
  "SHORTLISTED",
  "INTERVIEW",
  "SELECTED",
  "CHECKS",
  "OFFER",
  "HIRED",
  "REJECTED",
  "WITHDRAWN",
] as const;
export type Stage = (typeof STAGES)[number];

// The live pipeline columns (terminal stages are not "in pipeline").
export const PIPELINE_STAGES: Stage[] = [
  "SOURCED",
  "SCREENING",
  "ASSESSMENT",
  "SHORTLISTED",
  "INTERVIEW",
  "SELECTED",
  "CHECKS",
  "OFFER",
];

export const OPENING_STATUSES = ["OPEN", "ON_HOLD", "CLOSED", "FILLED"] as const;
export type OpeningStatus = (typeof OPENING_STATUSES)[number];

const STAGE_LABEL: Record<string, string> = {
  SOURCED: "Sourced",
  SCREENING: "Screening",
  ASSESSMENT: "Assessment",
  SHORTLISTED: "Shortlisted",
  INTERVIEW: "Interview",
  SELECTED: "Selected",
  CHECKS: "Pre-employment checks",
  OFFER: "Offer",
  HIRED: "Hired",
  REJECTED: "Rejected",
  WITHDRAWN: "Withdrawn",
};

export function stageLabel(s: string): string {
  return STAGE_LABEL[s] ?? s;
}

// The ten canonical hiring stages (Workflow Part 2). Stages 1-3 are
// opening-level (requisition / budget / role-pack); 4-10 map to candidate
// stages for the stepper.
export const CANDIDATE_STAGE_STEP: Record<string, number> = {
  SOURCED: 4,
  SCREENING: 5,
  SHORTLISTED: 5,
  ASSESSMENT: 6,
  INTERVIEW: 6,
  SELECTED: 7,
  CHECKS: 8,
  OFFER: 9,
  HIRED: 10,
};

export function candidateStageStep(s: string): number | null {
  return CANDIDATE_STAGE_STEP[s] ?? null;
}

export function stageBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "OFFER":
    case "HIRED":
    case "SELECTED":
      return { cls: "b-grn", label: stageLabel(s) };
    case "INTERVIEW":
    case "CHECKS":
      return { cls: "b-amb", label: stageLabel(s) };
    case "SCREENING":
    case "ASSESSMENT":
    case "SHORTLISTED":
      return { cls: "b-blu", label: stageLabel(s) };
    case "REJECTED":
      return { cls: "b-red", label: stageLabel(s) };
    default:
      return { cls: "b-gry", label: stageLabel(s) };
  }
}

export function openingStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "OPEN":
      return { cls: "b-grn", label: "Open" };
    case "ON_HOLD":
      return { cls: "b-amb", label: "On hold" };
    case "FILLED":
      return { cls: "b-blu", label: "Filled" };
    case "CLOSED":
      return { cls: "b-gry", label: "Closed" };
    default:
      return { cls: "b-gry", label: s };
  }
}

export const REQUISITION_REASONS = ["NEW", "REPLACEMENT", "GROWTH"] as const;
export function reasonLabel(s: string | null): string {
  switch (s) {
    case "NEW": return "New role";
    case "REPLACEMENT": return "Replacement";
    case "GROWTH": return "Growth";
    default: return "—";
  }
}

// ---------------------------------------------------------------------------
// Stage-8 verification-check catalog (Toolkit Part 5). Pure + import-free logic.
// ---------------------------------------------------------------------------
export const CHECK_TYPES = [
  "IDENTITY",
  "QUALIFICATIONS",
  "PROFESSIONAL_MEMBERSHIP",
  "REGULATORY_LICENSING",
  "FIT_AND_PROPER",
  "REFERENCES",
  "GUARANTOR",
  "BACKGROUND_SCREENING",
  "MEDICAL",
  "DATA_PROTECTION_CONSENT",
] as const;
export type CheckType = (typeof CHECK_TYPES)[number];

const CHECK_LABEL: Record<string, string> = {
  IDENTITY: "Identity & right to work",
  QUALIFICATIONS: "Qualifications",
  PROFESSIONAL_MEMBERSHIP: "Professional memberships",
  REGULATORY_LICENSING: "Regulatory licensing (SEC / CIS)",
  FIT_AND_PROPER: "Fit-and-proper declaration",
  REFERENCES: "Employment references (≥2)",
  GUARANTOR: "Guarantor form(s)",
  BACKGROUND_SCREENING: "Background & screening",
  MEDICAL: "Medical / fitness",
  DATA_PROTECTION_CONSENT: "Data-protection consent (NDPA)",
};
export function checkLabel(s: string): string {
  return CHECK_LABEL[s] ?? s;
}

export const CHECK_STATUSES = ["PENDING", "CLEARED", "WAIVED", "FAILED"] as const;
export function checkStatusBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "CLEARED": return { cls: "b-grn", label: "Cleared" };
    case "WAIVED": return { cls: "b-blu", label: "Waived" };
    case "FAILED": return { cls: "b-red", label: "Failed" };
    default: return { cls: "b-gry", label: "Pending" };
  }
}

function gradeRankLocal(grade: string | null | undefined): number {
  if (!grade) return -1;
  const m = /^G(\d)$/.exec(grade.trim().toUpperCase());
  return m ? Number(m[1]) : -1;
}

/** Whether a verification check applies by default, given the role's facts. */
export function checkAppliesByDefault(
  type: CheckType,
  facts: { isRegulated: boolean; grade: string | null }
): boolean {
  const g2plus = gradeRankLocal(facts.grade) >= 2;
  switch (type) {
    case "PROFESSIONAL_MEMBERSHIP": return facts.isRegulated || g2plus;
    case "REGULATORY_LICENSING": return facts.isRegulated;
    case "MEDICAL": return false; // role-dependent, set per hire
    default: return true; // identity, quals, fit-and-proper, references, guarantor, screening, NDPA consent
  }
}

/** The default checklist to seed for a candidate, in catalog order. */
export function defaultChecklistFor(facts: {
  isRegulated: boolean;
  grade: string | null;
}): { checkType: CheckType; applicable: boolean }[] {
  return CHECK_TYPES.map((checkType) => ({
    checkType,
    applicable: checkAppliesByDefault(checkType, facts),
  }));
}

/** A candidate is offer-eligible once every APPLICABLE check is cleared/waived
 * and at least one applicable check exists (so an empty list never "passes"). */
export function checksReady(
  checks: { applicable: boolean; status: string }[]
): boolean {
  const applicable = checks.filter((c) => c.applicable);
  if (applicable.length === 0) return false;
  return applicable.every((c) => c.status === "CLEARED" || c.status === "WAIVED");
}

export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

function weekBounds(now = new Date()): { start: Date; end: Date } {
  const day = now.getUTCDay();
  const diffToMon = (day + 6) % 7;
  const base = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
  const start = new Date(base - diffToMon * 86400000);
  const end = new Date(start.getTime() + 6 * 86400000 + (86400000 - 1));
  return { start, end };
}

/** Next requisition code, REQ-YYYY-NN, sequential within the calendar year. */
export async function nextRequisitionCode(): Promise<string> {
  const year = new Date().getFullYear();
  const prefix = `REQ-${year}-`;
  const last = await prisma.jobOpening.findFirst({
    where: { code: { startsWith: prefix } },
    orderBy: { code: "desc" },
    select: { code: true },
  });
  let n = 1;
  if (last) {
    const v = parseInt(last.code.slice(prefix.length), 10);
    if (!Number.isNaN(v)) n = v + 1;
  }
  return `${prefix}${String(n).padStart(2, "0")}`;
}

export type RecruitmentKpis = {
  openReqs: number;
  candidatesInPipeline: number;
  interviewsThisWeek: number;
  offersOut: number;
};

export type OpeningRow = {
  id: string;
  code: string;
  title: string;
  grade: string | null;
  status: string;
  headcount: number;
  departmentName: string | null;
  total: number;
  active: number;
};

export type RecruitmentOverview = {
  kpis: RecruitmentKpis;
  openings: OpeningRow[];
};

export async function getRecruitmentOverview(): Promise<RecruitmentOverview> {
  const openings = await prisma.jobOpening.findMany({
    orderBy: [{ status: "asc" }, { createdAt: "desc" }],
    include: { candidates: { select: { stage: true, interviewAt: true } } },
  });

  const deptIds = Array.from(
    new Set(openings.map((o) => o.departmentId).filter((x): x is string => !!x))
  );
  const depts = deptIds.length
    ? await prisma.department.findMany({
        where: { id: { in: deptIds } },
        select: { id: true, name: true },
      })
    : [];
  const deptName = new Map(depts.map((d) => [d.id, d.name] as const));

  const { start, end } = weekBounds();
  const active = new Set<string>(PIPELINE_STAGES);

  let candidatesInPipeline = 0;
  let interviewsThisWeek = 0;
  let offersOut = 0;

  const rows: OpeningRow[] = openings.map((o) => {
    let oActive = 0;
    for (const c of o.candidates) {
      if (active.has(c.stage)) {
        candidatesInPipeline += 1;
        oActive += 1;
      }
      if (c.stage === "OFFER") offersOut += 1;
      if (c.interviewAt && c.interviewAt >= start && c.interviewAt <= end) {
        interviewsThisWeek += 1;
      }
    }
    return {
      id: o.id,
      code: o.code,
      title: o.title,
      grade: o.grade,
      status: o.status,
      headcount: o.headcount,
      departmentName: o.departmentId ? deptName.get(o.departmentId) ?? null : null,
      total: o.candidates.length,
      active: oActive,
    };
  });

  const openReqs = openings.filter((o) => o.status === "OPEN").length;

  return {
    kpis: { openReqs, candidatesInPipeline, interviewsThisWeek, offersOut },
    openings: rows,
  };
}

export type CandidateCheckView = {
  id: string;
  checkType: string;
  applicable: boolean;
  status: string;
  clearedAt: Date | null;
  clearedByName: string | null;
  evidenceDocId: string | null;
  note: string | null;
};

export type StageEventView = {
  id: string;
  stage: string;
  clearedAt: Date;
  clearedByName: string | null;
  note: string | null;
};

export type CandidateView = {
  id: string;
  fullName: string;
  email: string | null;
  phone: string | null;
  source: string | null;
  stage: string;
  stageNote: string | null;
  interviewAt: Date | null;
  offerGrade: string | null;
  offerBasic: number | null;
  offerUtility: number | null;
  offerStartDate: Date | null;
  offerAcceptanceDeadline: Date | null;
  selectionRationale: string | null;
  selectedByName: string | null;
  selectedAt: Date | null;
  ccoSignoffByName: string | null;
  ccoSignoffAt: Date | null;
  checks: CandidateCheckView[];
  checksReady: boolean;
  stageEvents: StageEventView[];
};

export type PipelineColumn = { stage: Stage; label: string; candidates: CandidateView[] };

export type RequisitionStage = "REQUESTED" | "BUDGET_APPROVED" | "ROLE_PACK_READY" | "SOURCING";

export type OpeningDetail = {
  id: string;
  code: string;
  title: string;
  grade: string | null;
  status: string;
  headcount: number;
  notes: string | null;
  departmentName: string | null;
  jobProfileTitle: string | null;
  jobProfileIsControlFunction: boolean;
  openedAt: Date;
  // Stages 1-3 requisition gates
  reason: string | null;
  businessCase: string | null;
  mustHaves: string | null;
  isControlFunction: boolean;
  raisedByName: string | null;
  raisedAt: Date | null;
  budgetBand: string | null;
  cfoApprovedByName: string | null;
  cfoApprovedAt: Date | null;
  mdApprovedByName: string | null;
  mdApprovedAt: Date | null;
  rolePackConfirmedByName: string | null;
  rolePackConfirmedAt: Date | null;
  reqStage: RequisitionStage;
  // candidate journey
  columns: PipelineColumn[];
  terminal: CandidateView[]; // hired / rejected / withdrawn
  total: number;
};

export function requisitionStageLabel(s: RequisitionStage): string {
  switch (s) {
    case "REQUESTED": return "Requisition raised";
    case "BUDGET_APPROVED": return "Budget approved";
    case "ROLE_PACK_READY": return "Role pack ready";
    case "SOURCING": return "Sourcing";
  }
}

export async function getOpeningDetail(openingId: string): Promise<OpeningDetail | null> {
  const o = await prisma.jobOpening.findUnique({
    where: { id: openingId },
    include: { candidates: { orderBy: { createdAt: "asc" } } },
  });
  if (!o) return null;

  const dept = o.departmentId
    ? await prisma.department.findUnique({
        where: { id: o.departmentId },
        select: { name: true },
      })
    : null;
  const prof = o.jobProfileId
    ? await prisma.jobProfile.findUnique({
        where: { id: o.jobProfileId },
        select: { title: true, isControlFunction: true },
      })
    : null;

  // Batch the per-candidate checks + stage events (bare candidate_id models).
  const candIds = o.candidates.map((c) => c.id);
  const [checks, events] = candIds.length
    ? await Promise.all([
        prisma.candidateCheck.findMany({
          where: { candidateId: { in: candIds } },
          orderBy: { createdAt: "asc" },
        }),
        prisma.candidateStageEvent.findMany({
          where: { candidateId: { in: candIds } },
          orderBy: { clearedAt: "asc" },
        }),
      ])
    : [[], []];

  const checksByCand = new Map<string, CandidateCheckView[]>();
  for (const k of checks) {
    const arr = checksByCand.get(k.candidateId) ?? [];
    arr.push({
      id: k.id,
      checkType: k.checkType,
      applicable: k.applicable,
      status: k.status,
      clearedAt: k.clearedAt,
      clearedByName: k.clearedByName,
      evidenceDocId: k.evidenceDocId,
      note: k.note,
    });
    checksByCand.set(k.candidateId, arr);
  }
  const eventsByCand = new Map<string, StageEventView[]>();
  for (const e of events) {
    const arr = eventsByCand.get(e.candidateId) ?? [];
    arr.push({
      id: e.id,
      stage: e.stage,
      clearedAt: e.clearedAt,
      clearedByName: e.clearedByName,
      note: e.note,
    });
    eventsByCand.set(e.candidateId, arr);
  }

  const toView = (c: (typeof o.candidates)[number]): CandidateView => {
    const cChecks = checksByCand.get(c.id) ?? [];
    return {
      id: c.id,
      fullName: c.fullName,
      email: c.email,
      phone: c.phone,
      source: c.source,
      stage: c.stage,
      stageNote: c.stageNote,
      interviewAt: c.interviewAt,
      offerGrade: c.offerGrade,
      offerBasic: c.offerBasic != null ? Number(c.offerBasic) : null,
      offerUtility: c.offerUtility != null ? Number(c.offerUtility) : null,
      offerStartDate: c.offerStartDate,
      offerAcceptanceDeadline: c.offerAcceptanceDeadline,
      selectionRationale: c.selectionRationale,
      selectedByName: c.selectedByName,
      selectedAt: c.selectedAt,
      ccoSignoffByName: c.ccoSignoffByName,
      ccoSignoffAt: c.ccoSignoffAt,
      checks: cChecks,
      checksReady: checksReady(cChecks),
      stageEvents: eventsByCand.get(c.id) ?? [],
    };
  };

  const columns: PipelineColumn[] = PIPELINE_STAGES.map((stage) => ({
    stage,
    label: stageLabel(stage),
    candidates: o.candidates.filter((c) => c.stage === stage).map(toView),
  }));

  const terminalStages = new Set(["HIRED", "REJECTED", "WITHDRAWN"]);
  const terminal = o.candidates.filter((c) => terminalStages.has(c.stage)).map(toView);

  let reqStage: RequisitionStage = "REQUESTED";
  if (o.rolePackConfirmedAt) reqStage = "SOURCING";
  else if (o.cfoApprovedAt && o.mdApprovedAt) reqStage = "ROLE_PACK_READY";
  else if (o.cfoApprovedAt || o.mdApprovedAt) reqStage = "BUDGET_APPROVED";

  return {
    id: o.id,
    code: o.code,
    title: o.title,
    grade: o.grade,
    status: o.status,
    headcount: o.headcount,
    notes: o.notes,
    departmentName: dept?.name ?? null,
    jobProfileTitle: prof?.title ?? null,
    jobProfileIsControlFunction: prof?.isControlFunction ?? false,
    openedAt: o.openedAt,
    reason: o.reason,
    businessCase: o.businessCase,
    mustHaves: o.mustHaves,
    isControlFunction: o.isControlFunction,
    raisedByName: o.raisedByName,
    raisedAt: o.raisedAt,
    budgetBand: o.budgetBand,
    cfoApprovedByName: o.cfoApprovedByName,
    cfoApprovedAt: o.cfoApprovedAt,
    mdApprovedByName: o.mdApprovedByName,
    mdApprovedAt: o.mdApprovedAt,
    rolePackConfirmedByName: o.rolePackConfirmedByName,
    rolePackConfirmedAt: o.rolePackConfirmedAt,
    reqStage,
    columns,
    terminal,
    total: o.candidates.length,
  };
}

export type RequisitionFormOptions = {
  departments: { id: string; name: string }[];
  jobProfiles: { id: string; title: string; grade: string | null }[];
};

export async function getRequisitionFormOptions(): Promise<RequisitionFormOptions> {
  const [departments, jobProfiles] = await Promise.all([
    prisma.department.findMany({ orderBy: { name: "asc" }, select: { id: true, name: true } }),
    prisma.jobProfile.findMany({
      orderBy: { title: "asc" },
      select: { id: true, title: true, grade: true },
    }),
  ]);
  return { departments, jobProfiles };
}
