// Employees module — shared queries and presentation helpers.
// Read-only over the existing `employees` table and its relations. No writes
// here; the only audited side effect (opening a profile) lives in the page.
//
// Design notes:
// - Salary amounts are intentionally NOT read or surfaced in this module. The
//   directory shows org attributes and pay *category* only; compensation
//   figures stay behind compensation.view / payroll.view (control-room
//   separation of duties).
// - Document completeness is computed against REQUIRED_DOC_CATEGORIES below.
//   The seed currently loads no employee_documents, so completeness reads 0/…
//   honestly until files are attached in a later (documents) build.
import { prisma } from "@/lib/db";
import type { EmploymentStatus, EmploymentType } from "@prisma/client";

// ---------------------------------------------------------------------------
// Required staff-file checklist (edit freely — completeness is derived from it)
// ---------------------------------------------------------------------------
export const REQUIRED_DOC_CATEGORIES: string[] = [
  "Signed contract",
  "Means of identification",
  "Utility bill",
  "Résumé / CV",
  "Tax (TIN)",
  "Pension (RSA / PenCom)",
  "Bank details",
  "Guarantor / reference",
  "Next of kin",
];

// ---------------------------------------------------------------------------
// Small pure helpers
// ---------------------------------------------------------------------------

/** Trailing integer of an ee_id like "EID 7" → 7 (for numeric sorting). */
export function eeNum(eeId: string): number {
  const m = eeId.match(/(\d+)\s*$/);
  return m ? parseInt(m[1], 10) : Number.MAX_SAFE_INTEGER;
}

/**
 * Initials for the avatar chip. Handles the stored "SURNAME, FIRST MIDDLE"
 * format (→ surname + first-given initial) and plain "First Last".
 */
export function empInitials(fullName: string): string {
  const name = (fullName || "").trim();
  if (!name) return "?";
  if (name.includes(",")) {
    const [last, rest = ""] = name.split(",");
    const first = rest.trim().split(/\s+/)[0] ?? "";
    return ((last.trim()[0] ?? "") + (first[0] ?? "")).toUpperCase() || "?";
  }
  const parts = name.split(/\s+/).filter(Boolean);
  return (
    parts
      .slice(0, 2)
      .map((p) => p[0])
      .join("")
      .toUpperCase() || "?"
  );
}

const STATUS_BADGE: Record<EmploymentStatus, { cls: string; label: string }> = {
  ACTIVE: { cls: "b-grn", label: "Active" },
  PROBATION: { cls: "b-blu", label: "Probation" },
  ON_LEAVE: { cls: "b-amb", label: "On leave" },
  SUSPENDED: { cls: "b-red", label: "Suspended" },
  EXITED: { cls: "b-gry", label: "Exited" },
};
export function statusBadge(s: EmploymentStatus): { cls: string; label: string } {
  return STATUS_BADGE[s] ?? { cls: "b-gry", label: String(s) };
}

const TYPE_LABEL: Record<EmploymentType, string> = {
  FULL_TIME: "Full-time",
  PART_TIME: "Part-time",
  CONTRACT: "Contract",
  OUTSOURCED: "Outsourced",
  FRACTIONAL: "Fractional",
  CONSULTANT: "Consultant",
  EXTERNAL_REVIEWER: "External reviewer",
};
export function typeLabel(t: EmploymentType): string {
  return TYPE_LABEL[t] ?? String(t);
}

export type DocCompleteness = {
  have: number;
  total: number;
  pct: number;
  missing: string[];
  present: string[];
};

/** Completeness from the distinct document categories on file for one employee. */
export function docCompleteness(presentCategories: string[]): DocCompleteness {
  const norm = (s: string) => s.trim().toLowerCase();
  const presentSet = new Set(presentCategories.map(norm));
  const missing = REQUIRED_DOC_CATEGORIES.filter((c) => !presentSet.has(norm(c)));
  const present = REQUIRED_DOC_CATEGORIES.filter((c) => presentSet.has(norm(c)));
  const total = REQUIRED_DOC_CATEGORIES.length;
  const have = total - missing.length;
  const pct = total === 0 ? 0 : Math.round((have / total) * 100);
  return { have, total, pct, missing, present };
}

/** Progress-bar modifier class for a completeness percentage. */
export function barClass(pct: number): string {
  if (pct >= 100) return "";
  if (pct >= 50) return "warn";
  return "bad";
}

/** Format a date for display, or an em dash when absent. */
export function fmtDate(d: Date | null | undefined): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

// ---------------------------------------------------------------------------
// Queries
// ---------------------------------------------------------------------------

/** Directory rows: every employee with org attributes + document categories. */
export async function getEmployeesForList() {
  const rows = await prisma.employee.findMany({
    include: {
      entity: true,
      department: true,
      payCategory: true,
      jobProfile: true,
      documents: { select: { category: true } },
    },
  });
  return rows.sort((a, b) => eeNum(a.eeId) - eeNum(b.eeId));
}
export type EmployeeListRow = Awaited<ReturnType<typeof getEmployeesForList>>[number];

/** One employee with everything the profile renders. */
export async function getEmployeeDetail(id: string) {
  return prisma.employee.findUnique({
    where: { id },
    include: {
      entity: true,
      department: true,
      payCategory: true,
      jobProfile: true,
      manager: true,
      reports: { where: { status: { not: "EXITED" } }, orderBy: { eeId: "asc" } },
      documents: { orderBy: { createdAt: "desc" } },
      employmentRecords: { orderBy: { effectiveDate: "desc" } },
    },
  });
}
export type EmployeeDetail = NonNullable<Awaited<ReturnType<typeof getEmployeeDetail>>>;

// ---------------------------------------------------------------------------
// Org chart (built from employees.manager_id self-relation)
// ---------------------------------------------------------------------------
// `department` (name) and `employmentType` are carried on the node so the
// chart can show role + department and tag notable employment types
// (e.g. Fractional). Both are existing columns — read-only, no schema change.
export type OrgNode = {
  id: string;
  eeId: string;
  fullName: string;
  title: string | null;
  department: string | null;
  employmentType: EmploymentType;
  status: EmploymentStatus;
  managerId: string | null;
  children: OrgNode[];
};

export async function getOrgData(): Promise<{
  roots: OrgNode[];
  hasHierarchy: boolean;
  count: number;
}> {
  const emps = await prisma.employee.findMany({
    // Exited staff are not part of the live reporting hierarchy.
    where: { status: { not: "EXITED" } },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      managerId: true,
      status: true,
      employmentType: true,
      jobProfile: { select: { title: true } },
      department: { select: { name: true } },
    },
  });

  const byId = new Map<string, OrgNode>();
  for (const e of emps) {
    byId.set(e.id, {
      id: e.id,
      eeId: e.eeId,
      fullName: e.fullName,
      title: e.jobProfile?.title ?? null,
      department: e.department?.name ?? null,
      employmentType: e.employmentType,
      status: e.status,
      managerId: e.managerId,
      children: [],
    });
  }

  const roots: OrgNode[] = [];
  for (const node of byId.values()) {
    const parent = node.managerId ? byId.get(node.managerId) : undefined;
    if (parent && parent.id !== node.id) parent.children.push(node);
    else roots.push(node);
  }

  const sort = (a: OrgNode, b: OrgNode) => eeNum(a.eeId) - eeNum(b.eeId);
  const sortDeep = (n: OrgNode) => {
    n.children.sort(sort);
    n.children.forEach(sortDeep);
  };
  roots.sort(sort);
  roots.forEach(sortDeep);

  const hasHierarchy = emps.some((e) => e.managerId);
  return { roots, hasHierarchy, count: emps.length };
}


// ---------------------------------------------------------------------------
// Manage editor support (v0.5.0): dropdown options + cycle-safe manager list
// ---------------------------------------------------------------------------
export type FormOptions = {
  departments: { id: string; name: string }[];
  jobProfiles: { id: string; title: string }[];
  payCategories: { id: string; name: string }[];
  managers: { id: string; eeId: string; fullName: string }[];
};

/**
 * Eligible managers exclude exited staff and, for an existing employee, the
 * employee themselves plus all of their descendants (so a reporting cycle
 * cannot be created from the UI).
 */
export async function getEligibleManagers(
  employeeId?: string
): Promise<{ id: string; eeId: string; fullName: string }[]> {
  const all = await prisma.employee.findMany({
    select: { id: true, eeId: true, fullName: true, managerId: true, status: true },
  });
  const excluded = new Set<string>();
  if (employeeId) {
    excluded.add(employeeId);
    const childrenOf = new Map<string, string[]>();
    for (const e of all) {
      if (e.managerId) {
        const arr = childrenOf.get(e.managerId) ?? [];
        arr.push(e.id);
        childrenOf.set(e.managerId, arr);
      }
    }
    const stack = [employeeId];
    while (stack.length) {
      const cur = stack.pop()!;
      for (const child of childrenOf.get(cur) ?? []) {
        if (!excluded.has(child)) {
          excluded.add(child);
          stack.push(child);
        }
      }
    }
  }
  return all
    .filter((e) => e.status !== "EXITED" && !excluded.has(e.id))
    .map((e) => ({ id: e.id, eeId: e.eeId, fullName: e.fullName }))
    .sort((a, b) => eeNum(a.eeId) - eeNum(b.eeId));
}

/** Returns the set of an employee's descendant ids (for server-side cycle guard). */
export async function getDescendantIds(employeeId: string): Promise<Set<string>> {
  const all = await prisma.employee.findMany({ select: { id: true, managerId: true } });
  const childrenOf = new Map<string, string[]>();
  for (const e of all) {
    if (e.managerId) {
      const arr = childrenOf.get(e.managerId) ?? [];
      arr.push(e.id);
      childrenOf.set(e.managerId, arr);
    }
  }
  const out = new Set<string>();
  const stack = [employeeId];
  while (stack.length) {
    const cur = stack.pop()!;
    for (const child of childrenOf.get(cur) ?? []) {
      if (!out.has(child)) {
        out.add(child);
        stack.push(child);
      }
    }
  }
  return out;
}

/** Dropdown options for the manage editor. */
export async function getFormOptions(employeeId?: string): Promise<FormOptions> {
  const [departments, jobProfiles, payCategories, managers] = await Promise.all([
    prisma.department.findMany({ orderBy: { name: "asc" }, select: { id: true, name: true } }),
    prisma.jobProfile.findMany({ orderBy: { title: "asc" }, select: { id: true, title: true } }),
    prisma.payCategory.findMany({ orderBy: { name: "asc" }, select: { id: true, name: true } }),
    getEligibleManagers(employeeId),
  ]);
  return { departments, jobProfiles, payCategories, managers };
}

export const EMPLOYMENT_TYPES: { value: string; label: string }[] = [
  { value: "FULL_TIME", label: "Full-time" },
  { value: "PART_TIME", label: "Part-time" },
  { value: "CONTRACT", label: "Contract" },
  { value: "OUTSOURCED", label: "Outsourced" },
  { value: "FRACTIONAL", label: "Fractional" },
  { value: "CONSULTANT", label: "Consultant" },
  { value: "EXTERNAL_REVIEWER", label: "External reviewer" },
];

export const EMPLOYMENT_STATUSES: { value: string; label: string }[] = [
  { value: "ACTIVE", label: "Active" },
  { value: "PROBATION", label: "Probation" },
  { value: "ON_LEAVE", label: "On leave" },
  { value: "SUSPENDED", label: "Suspended" },
  { value: "EXITED", label: "Exited" },
];
