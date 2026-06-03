// Read-side helpers for the Recruitment module. Pure formatters + badge mappers
// and the queries that back the Recruitment overview and the per-requisition
// pipeline. No writes here — those live in lib/recruitment-actions.ts. Mirrors
// the shape of lib/leave.ts. Cross-entity references (department_id,
// job_profile_id) are bare columns, resolved by lookup here.
import { prisma } from "@/lib/db";

export const STAGES = [
  "SOURCED",
  "SCREENING",
  "ASSESSMENT",
  "INTERVIEW",
  "OFFER",
  "HIRED",
  "REJECTED",
  "WITHDRAWN",
] as const;
export type Stage = (typeof STAGES)[number];

// The five live pipeline columns (terminal stages are not "in pipeline").
export const PIPELINE_STAGES: Stage[] = [
  "SOURCED",
  "SCREENING",
  "ASSESSMENT",
  "INTERVIEW",
  "OFFER",
];

export const OPENING_STATUSES = ["OPEN", "ON_HOLD", "CLOSED", "FILLED"] as const;
export type OpeningStatus = (typeof OPENING_STATUSES)[number];

const STAGE_LABEL: Record<string, string> = {
  SOURCED: "Sourced",
  SCREENING: "Screening",
  ASSESSMENT: "Assessment",
  INTERVIEW: "Interview",
  OFFER: "Offer",
  HIRED: "Hired",
  REJECTED: "Rejected",
  WITHDRAWN: "Withdrawn",
};

export function stageLabel(s: string): string {
  return STAGE_LABEL[s] ?? s;
}

export function stageBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "OFFER":
    case "HIRED":
      return { cls: "b-grn", label: stageLabel(s) };
    case "INTERVIEW":
      return { cls: "b-amb", label: stageLabel(s) };
    case "SCREENING":
    case "ASSESSMENT":
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

  // Resolve department names for the bare department_id column.
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
};

export type PipelineColumn = { stage: Stage; label: string; candidates: CandidateView[] };

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
  openedAt: Date;
  columns: PipelineColumn[];
  terminal: CandidateView[]; // hired / rejected / withdrawn
  total: number;
};

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
        select: { title: true },
      })
    : null;

  const toView = (c: (typeof o.candidates)[number]): CandidateView => ({
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
  });

  const columns: PipelineColumn[] = PIPELINE_STAGES.map((stage) => ({
    stage,
    label: stageLabel(stage),
    candidates: o.candidates.filter((c) => c.stage === stage).map(toView),
  }));

  const terminalStages = new Set(["HIRED", "REJECTED", "WITHDRAWN"]);
  const terminal = o.candidates.filter((c) => terminalStages.has(c.stage)).map(toView);

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
    openedAt: o.openedAt,
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
