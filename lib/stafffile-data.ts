// Read-side for the Staff Files module. Resolves each employee's D6.2 facts
// (effective grade = employees.grade ?? jobProfile.grade; regulated flag;
// status; whether they carry a sealed conduct/grievance record), maps the set
// of satisfied D6.2 slots from staff_documents.file_slot, and computes
// completeness via the pure engine in lib/stafffile.ts. No writes here.
import { prisma } from "@/lib/db";
import {
  STAFF_FILE_SLOTS,
  SLOT_META,
  type SlotKey,
  type EmployeeFacts,
  computeCompleteness,
  averagePct,
  DEFAULT_THRESHOLD_PCT,
  type Completeness,
} from "@/lib/stafffile";

export const SCOPES = ["ALL", "ACTIVE", "ACTIVE_AND_PROBATION"] as const;
export type Scope = (typeof SCOPES)[number];

export function scopeLabel(s: Scope): string {
  switch (s) {
    case "ALL": return "All staff records";
    case "ACTIVE": return "Active staff";
    case "ACTIVE_AND_PROBATION": return "Active + on probation";
  }
}

function statusFilter(scope: Scope): { status?: { in: string[] } } {
  if (scope === "ACTIVE") return { status: { in: ["ACTIVE"] } };
  if (scope === "ACTIVE_AND_PROBATION") return { status: { in: ["ACTIVE", "PROBATION"] } };
  return {};
}

type EmpCore = {
  id: string;
  eeId: string;
  fullName: string;
  grade: string | null;
  status: string;
  isRegulated: boolean;
  jobProfileId: string | null;
};

async function loadCohort(scope: Scope): Promise<EmpCore[]> {
  const employees = await prisma.employee.findMany({
    where: statusFilter(scope) as never,
    orderBy: { eeId: "asc" },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      grade: true,
      status: true,
      isRegulatedRole: true,
      jobProfileId: true,
    },
  });

  const profIds = Array.from(
    new Set(employees.map((e) => e.jobProfileId).filter((x): x is string => !!x))
  );
  const profs = profIds.length
    ? await prisma.jobProfile.findMany({
        where: { id: { in: profIds } },
        select: { id: true, grade: true },
      })
    : [];
  const profGrade = new Map(profs.map((p) => [p.id, p.grade] as const));

  return employees.map((e) => ({
    id: e.id,
    eeId: e.eeId,
    fullName: e.fullName,
    grade: e.grade ?? (e.jobProfileId ? profGrade.get(e.jobProfileId) ?? null : null),
    status: String(e.status),
    isRegulated: e.isRegulatedRole,
    jobProfileId: e.jobProfileId,
  }));
}

/** Map empId -> set of satisfied D6.2 slot keys (from filed staff_documents). */
async function loadSatisfiedSlots(empIds: string[]): Promise<Map<string, Set<string>>> {
  const out = new Map<string, Set<string>>();
  if (empIds.length === 0) return out;
  const docs = await prisma.staffDocument.findMany({
    where: { employeeId: { in: empIds }, fileSlot: { not: null }, status: { not: "VOID" } },
    select: { employeeId: true, fileSlot: true },
  });
  for (const d of docs) {
    if (!d.employeeId || !d.fileSlot) continue;
    const s = out.get(d.employeeId) ?? new Set<string>();
    s.add(d.fileSlot);
    out.set(d.employeeId, s);
  }
  return out;
}

/** Set of employee ids that carry a sealed disciplinary or grievance record. */
async function loadHasCaseRecords(empIds: string[]): Promise<Set<string>> {
  const out = new Set<string>();
  if (empIds.length === 0) return out;
  const [disc, grv] = await Promise.all([
    prisma.disciplinaryCase.findMany({
      where: { employeeId: { in: empIds } },
      select: { employeeId: true },
    }),
    prisma.grievance.findMany({
      where: { complainantId: { in: empIds } },
      select: { complainantId: true },
    }),
  ]);
  for (const d of disc) if (d.employeeId) out.add(d.employeeId);
  for (const g of grv) if (g.complainantId) out.add(g.complainantId);
  return out;
}

export type StaffFileRow = {
  employeeId: string;
  eeId: string;
  fullName: string;
  grade: string | null;
  status: string;
  isRegulated: boolean;
  pct: number;
  requiredCount: number;
  satisfiedCount: number;
  complete: boolean;
  missing: SlotKey[];
};

export type StaffFileRollup = {
  scope: Scope;
  threshold: number;
  population: number;
  completeCount: number;
  avgPct: number;
  rows: StaffFileRow[]; // sorted worst-first (D6.3: prioritize the highest-risk gaps)
};

export async function getStaffFileRollup(
  scope: Scope = "ALL",
  threshold = DEFAULT_THRESHOLD_PCT
): Promise<StaffFileRollup> {
  const cohort = await loadCohort(scope);
  const ids = cohort.map((e) => e.id);
  const [slots, cases] = await Promise.all([loadSatisfiedSlots(ids), loadHasCaseRecords(ids)]);

  const rows: StaffFileRow[] = cohort.map((e) => {
    const hasCaseRecords = cases.has(e.id);
    const satisfied = new Set<string>(slots.get(e.id) ?? new Set<string>());
    // A sealed WS5 case record satisfies the CASE_RECORDS slot in itself.
    if (hasCaseRecords) satisfied.add("CASE_RECORDS");
    const facts: EmployeeFacts = {
      grade: e.grade,
      isRegulated: e.isRegulated,
      status: e.status,
      hasCaseRecords,
    };
    const c = computeCompleteness(facts, satisfied, threshold);
    return {
      employeeId: e.id,
      eeId: e.eeId,
      fullName: e.fullName,
      grade: e.grade,
      status: e.status,
      isRegulated: e.isRegulated,
      pct: c.pct,
      requiredCount: c.requiredCount,
      satisfiedCount: c.satisfiedCount,
      complete: c.complete,
      missing: c.missing,
    };
  });

  rows.sort((a, b) => a.pct - b.pct || a.eeId.localeCompare(b.eeId));

  return {
    scope,
    threshold,
    population: rows.length,
    completeCount: rows.filter((r) => r.complete).length,
    avgPct: averagePct(rows.map((r) => r.pct)),
    rows,
  };
}

export type SlotDoc = { id: string; title: string; status: string };

export type StaffFileSlotView = {
  slot: SlotKey;
  label: string;
  d62: string;
  required: boolean;
  satisfied: boolean;
  docs: SlotDoc[];
};

export type EmployeeStaffFile = {
  employeeId: string;
  eeId: string;
  fullName: string;
  grade: string | null;
  status: string;
  isRegulated: boolean;
  hasCaseRecords: boolean;
  completeness: Completeness;
  slots: StaffFileSlotView[]; // every D6.2 slot, in canonical order
  unfiledDocs: SlotDoc[]; // staff_documents with no file_slot yet
};

export async function getEmployeeStaffFile(employeeId: string): Promise<EmployeeStaffFile | null> {
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: {
      id: true,
      eeId: true,
      fullName: true,
      grade: true,
      status: true,
      isRegulatedRole: true,
      jobProfileId: true,
    },
  });
  if (!e) return null;

  const grade =
    e.grade ??
    (e.jobProfileId
      ? (await prisma.jobProfile.findUnique({ where: { id: e.jobProfileId }, select: { grade: true } }))?.grade ?? null
      : null);

  const docs = await prisma.staffDocument.findMany({
    where: { employeeId, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
    select: { id: true, title: true, status: true, fileSlot: true },
  });

  const cases = await loadHasCaseRecords([employeeId]);
  const hasCaseRecords = cases.has(employeeId);

  const bySlot = new Map<string, SlotDoc[]>();
  const unfiled: SlotDoc[] = [];
  for (const d of docs) {
    const lite = { id: d.id, title: d.title, status: d.status };
    if (d.fileSlot) {
      const arr = bySlot.get(d.fileSlot) ?? [];
      arr.push(lite);
      bySlot.set(d.fileSlot, arr);
    } else {
      unfiled.push(lite);
    }
  }

  const satisfiedSet = new Set<string>([...bySlot.keys()]);
  if (hasCaseRecords) satisfiedSet.add("CASE_RECORDS");

  const facts: EmployeeFacts = {
    grade,
    isRegulated: e.isRegulatedRole,
    status: String(e.status),
    hasCaseRecords,
  };
  const completeness = computeCompleteness(facts, satisfiedSet);
  const requiredSet = new Set<string>(completeness.required);

  const slots: StaffFileSlotView[] = STAFF_FILE_SLOTS.map((slot) => ({
    slot,
    label: SLOT_META[slot].label,
    d62: SLOT_META[slot].d62,
    required: requiredSet.has(slot),
    satisfied: satisfiedSet.has(slot),
    docs: bySlot.get(slot) ?? [],
  }));

  return {
    employeeId: e.id,
    eeId: e.eeId,
    fullName: e.fullName,
    grade,
    status: String(e.status),
    isRegulated: e.isRegulatedRole,
    hasCaseRecords,
    completeness,
    slots,
    unfiledDocs: unfiled,
  };
}

export type SnapshotRow = {
  id: string;
  takenAt: Date;
  scope: string;
  population: number;
  complete: number;
  thresholdPct: number;
  avgPct: number;
  note: string | null;
  takenByName: string | null;
};

export async function getSnapshots(limit = 24): Promise<SnapshotRow[]> {
  const rows = await prisma.staffFileSnapshot.findMany({
    orderBy: { takenAt: "desc" },
    take: limit,
  });
  return rows.map((s) => ({
    id: s.id,
    takenAt: s.takenAt,
    scope: s.scope,
    population: s.populationCount,
    complete: s.completeCount,
    thresholdPct: s.thresholdPct,
    avgPct: Number(s.avgCompletenessPct),
    note: s.note,
    takenByName: s.takenByName,
  }));
}
