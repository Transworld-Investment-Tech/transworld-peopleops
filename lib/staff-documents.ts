// Staff & candidate documents — read helpers, the category catalog, badge
// mappers, and the merge-context builders that turn a person's real record into
// the values a template fills in. Writes live in lib/staff-documents-actions.ts.
// employee_id / candidate_id are bare columns (FK in SQL only); names are
// resolved here by lookup — the v0.16.0 / Leave convention.
import { prisma } from "@/lib/db";

// ---------------------------------------------------------------------------
// Category catalog — what kinds of staff file we keep, and how each is captured
//   official  → only HR may add/replace (offer, contract, guarantor)
//   personal  → the staff member may self-upload their own copy
//   generate  → can be produced from a template of `templateKind`
// ---------------------------------------------------------------------------
export type DocCategory = {
  key: string; // also the stored `category` string
  label: string;
  owner: "HR" | "STAFF"; // STAFF categories are self-uploadable
  generate?: string; // template kind, when generatable
};

export const DOC_CATEGORIES: DocCategory[] = [
  { key: "Offer letter", label: "Offer letter", owner: "HR", generate: "OFFER_LETTER" },
  { key: "Signed contract", label: "Signed contract", owner: "HR", generate: "EMPLOYMENT_CONTRACT" },
  { key: "Guarantor / reference", label: "Guarantor / reference", owner: "HR", generate: "GUARANTOR_FORM" },
  { key: "Next of kin", label: "Next of kin", owner: "STAFF", generate: "NEXT_OF_KIN" },
  { key: "Means of identification", label: "Means of identification (Driver's license / NIN)", owner: "STAFF" },
  { key: "Utility bill", label: "Utility bill (proof of address)", owner: "STAFF" },
  { key: "Résumé / CV", label: "Résumé / CV", owner: "STAFF" },
  { key: "Tax (TIN)", label: "Tax (TIN)", owner: "STAFF" },
  { key: "Pension (RSA / PenCom)", label: "Pension (RSA / PenCom)", owner: "STAFF" },
  { key: "Bank details", label: "Bank details", owner: "STAFF" },
  { key: "Other HR document", label: "Other HR document", owner: "HR" },
];

export const STAFF_UPLOADABLE_CATEGORIES = DOC_CATEGORIES.filter((c) => c.owner === "STAFF").map(
  (c) => c.key
);

export function categoryByKey(key: string): DocCategory | undefined {
  return DOC_CATEGORIES.find((c) => c.key === key);
}

// ---------------------------------------------------------------------------
// Presentation helpers
// ---------------------------------------------------------------------------
export function statusBadge(status: string): { cls: string; label: string } {
  switch (status) {
    case "SIGNED":
      return { cls: "b-grn", label: "Signed" };
    case "AWAITING_SIGNATURE":
      return { cls: "b-amb", label: "Awaiting signature" };
    case "DRAFT":
      return { cls: "b-blu", label: "Draft" };
    case "PENDING_APPROVAL":
      return { cls: "b-amb", label: "Pending approval" };
    case "VOID":
      return { cls: "b-red", label: "Void" };
    default:
      return { cls: "b-gry", label: "On file" };
  }
}

export function sourceBadge(source: string): { cls: string; label: string } {
  return source === "GENERATED"
    ? { cls: "b-blu", label: "Generated" }
    : { cls: "b-gry", label: "Uploaded" };
}

export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}

export function fmtDateTime(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function naira(v: unknown): string {
  const n = Number(v ?? 0);
  if (!Number.isFinite(n)) return "0.00";
  return n.toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

export function prettySize(bytes: number | null | undefined): string {
  if (bytes === null || bytes === undefined) return "";
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}

function personName(e: { preferredName?: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

// ---------------------------------------------------------------------------
// Reads
// ---------------------------------------------------------------------------
export async function getStaffDocuments(employeeId: string) {
  return prisma.staffDocument.findMany({
    where: { employeeId, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
  });
}

export async function getCandidateDocuments(candidateId: string) {
  return prisma.staffDocument.findMany({
    where: { candidateId, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
  });
}

export async function getStaffDocument(id: string) {
  return prisma.staffDocument.findUnique({ where: { id } });
}

/** Lightweight candidate documents keyed by candidateId, for pipeline cards. */
export async function getCandidateDocsLite(
  ids: string[]
): Promise<Map<string, { id: string; title: string; status: string; source: string; fileKey: string | null }[]>> {
  const map = new Map<string, { id: string; title: string; status: string; source: string; fileKey: string | null }[]>();
  if (!ids.length) return map;
  const rows = await prisma.staffDocument.findMany({
    where: { candidateId: { in: ids }, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
  });
  for (const r of rows) {
    if (!r.candidateId) continue;
    const a = map.get(r.candidateId) ?? [];
    a.push({ id: r.id, title: r.title, status: r.status, source: r.source, fileKey: r.fileKey });
    map.set(r.candidateId, a);
  }
  return map;
}

/** Distinct, non-void document categories on file for one employee. */
export async function getPresentCategories(employeeId: string): Promise<string[]> {
  const rows = await prisma.staffDocument.findMany({
    where: { employeeId, status: { notIn: ["VOID", "PENDING_APPROVAL"] } },
    select: { category: true },
    distinct: ["category"],
  });
  return rows.map((r) => r.category);
}

/** Map of employeeId -> present categories, for the directory list. */
export async function getPresentCategoriesByEmployee(
  ids: string[]
): Promise<Map<string, string[]>> {
  const map = new Map<string, string[]>();
  if (!ids.length) return map;
  const rows = await prisma.staffDocument.findMany({
    where: { employeeId: { in: ids }, status: { notIn: ["VOID", "PENDING_APPROVAL"] } },
    select: { employeeId: true, category: true },
  });
  for (const r of rows) {
    if (!r.employeeId) continue;
    const arr = map.get(r.employeeId) ?? [];
    if (!arr.includes(r.category)) arr.push(r.category);
    map.set(r.employeeId, arr);
  }
  return map;
}

/** Self-service: documents for the employee linked to a signed-in user. */
export async function getMyDocuments(userId: string) {
  const employee = await prisma.employee.findUnique({
    where: { userId },
    select: { id: true, fullName: true, preferredName: true, eeId: true },
  });
  if (!employee) return { linked: false as const };
  const docs = await prisma.staffDocument.findMany({
    where: { employeeId: employee.id, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
  });
  return {
    linked: true as const,
    employee,
    awaiting: docs.filter((d) => d.status === "AWAITING_SIGNATURE"),
    pending: docs.filter((d) => d.status === "PENDING_APPROVAL"),
    others: docs.filter((d) => d.status !== "AWAITING_SIGNATURE" && d.status !== "PENDING_APPROVAL"),
  };
}

// ---------------------------------------------------------------------------
// Merge contexts — a person's real record -> {{token}} values
// ---------------------------------------------------------------------------
export async function buildEmployeeMergeContext(
  employeeId: string
): Promise<Record<string, string> | null> {
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    include: {
      entity: { select: { name: true } },
      department: { select: { name: true } },
      jobProfile: { select: { title: true } },
      manager: { select: { fullName: true, preferredName: true } },
    },
  });
  if (!e) return null;

  const comp = await prisma.compensationProfile.findFirst({
    where: { employeeId, isCurrent: true },
    orderBy: { effectiveDate: "desc" },
  });

  const basic = Number(comp?.basicSalary ?? 0);
  const utility = Number(comp?.utilityAllowance ?? 0);
  const quarterly = Number(comp?.quarterlyAllowance ?? 0);

  const typeLabels: Record<string, string> = {
    FULL_TIME: "full-time",
    PART_TIME: "part-time",
    CONTRACT: "contract",
    OUTSOURCED: "outsourced",
    FRACTIONAL: "fractional",
    CONSULTANT: "consultant",
    EXTERNAL_REVIEWER: "external reviewer",
  };

  return {
    full_name: e.fullName,
    preferred_name: personName(e),
    ee_id: e.eeId,
    job_title: e.jobProfile?.title ?? "",
    department: e.department?.name ?? "",
    entity: e.entity?.name ?? "Transworld Investment & Securities Limited",
    employment_type: typeLabels[e.employmentType] ?? String(e.employmentType),
    start_date: e.startDate ? fmtDate(e.startDate) : "",
    work_email: e.workEmail ?? "",
    phone: e.phone ?? "",
    manager_name: e.manager ? personName(e.manager) : "",
    basic_salary: naira(basic),
    utility_allowance: naira(utility),
    quarterly_allowance: naira(quarterly),
    gross_monthly: naira(basic + utility),
    today: new Date().toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" }),
  };
}

export async function buildCandidateMergeContext(
  candidateId: string
): Promise<Record<string, string> | null> {
  const c = await prisma.candidate.findUnique({ where: { id: candidateId } });
  if (!c) return null;
  const opening = await prisma.jobOpening.findUnique({
    where: { id: c.openingId },
    select: { title: true, grade: true, departmentId: true },
  });
  const dept = opening?.departmentId
    ? await prisma.department.findUnique({
        where: { id: opening.departmentId },
        select: { name: true },
      })
    : null;
  const fmt = (n: number) =>
    n.toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const fmtDateLong = (d: Date | null | undefined) =>
    d ? new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" }) : "";

  // Offer terms entered by People Ops on the candidate (nullable until set). Derived pay
  // figures are computed live on the fully-loaded basis (Ops Manual B1.3 / C5.2): the
  // quarterly payment and thirteenth month each equal one month's gross; fully-loaded
  // monthly-equivalent = gross × 17 ÷ 12; annual total ≈ gross × 17.
  const basic = c.offerBasic != null ? Number(c.offerBasic) : 0;
  const utility = c.offerUtility != null ? Number(c.offerUtility) : 0;
  const gross = Math.round((basic + utility) * 100) / 100;
  const fullyLoaded = Math.round((gross * 17 / 12) * 100) / 100;
  const annualTotal = Math.round(gross * 17 * 100) / 100;

  return {
    full_name: c.fullName,
    preferred_name: c.fullName.split(/\s+/)[0] ?? c.fullName,
    ee_id: "",
    job_title: opening?.title ?? "",
    department: dept?.name ?? "",
    entity: "Transworld Investment & Securities Limited",
    employment_type: "full-time",
    grade: c.offerGrade ?? "",
    start_date: fmtDateLong(c.offerStartDate),
    acceptance_deadline: fmtDateLong(c.offerAcceptanceDeadline),
    work_email: c.email ?? "",
    phone: c.phone ?? "",
    manager_name: "",
    basic_salary: fmt(basic),
    utility_allowance: fmt(utility),
    quarterly_allowance: fmt(gross),
    thirteenth_month: fmt(gross),
    gross_monthly: fmt(gross),
    fully_loaded: fmt(fullyLoaded),
    annual_total: fmt(annualTotal),
    today: new Date().toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" }),
  };
}
