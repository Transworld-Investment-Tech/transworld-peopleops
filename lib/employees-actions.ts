"use server";
// Write-side server actions for the Manage editor. Every mutation is gated by
// employees.manage, validated with zod, writes an audit_logs row with the
// before/after diff, and guards against reporting cycles. These are the only
// employee writes in the app outside the explicit org:bootstrap script.
//
// v0.36.0 — Employee enhancement pass:
//   • create/update accept the rich personal / contact / NOK / identification /
//     demographic fields;
//   • a material change to grade / job profile / department / manager / status
//     auto-appends an employment_records history row (eventType inferred);
//   • dependents (employee_dependents) add/remove;
//   • a manual employment-history event can be recorded.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { getDescendantIds } from "@/lib/employees";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const TYPES = [
  "FULL_TIME",
  "PART_TIME",
  "CONTRACT",
  "OUTSOURCED",
  "FRACTIONAL",
  "CONSULTANT",
  "EXTERNAL_REVIEWER",
] as const;
const STATUSES = ["ACTIVE", "PROBATION", "ON_LEAVE", "SUSPENDED", "EXITED"] as const;
const GRADES = ["G0", "G1", "G2", "G3", "G4", "G5", "PT"] as const;
const GENDERS = ["MALE", "FEMALE", "OTHER", "UNDISCLOSED"] as const;
const MARITAL = ["SINGLE", "MARRIED", "DIVORCED", "WIDOWED", "OTHER"] as const;
const WORK_LOC = ["HEAD_OFFICE", "REMOTE", "HYBRID", "CLIENT_SITE"] as const;
const ID_TYPES = ["NIN", "PASSPORT", "DRIVERS_LICENSE", "VOTERS_CARD"] as const;
const EVENT_TYPES = [
  "HIRE",
  "CONFIRMATION",
  "PROMOTION",
  "REGRADE",
  "TRANSFER",
  "STATUS_CHANGE",
  "COMP_CHANGE",
  "EXIT",
  "NOTE",
] as const;
const RELATIONSHIPS = ["SPOUSE", "CHILD", "PARENT", "SIBLING", "OTHER"] as const;

const optStr = z.string().trim().optional().or(z.literal(""));

const baseSchema = z.object({
  fullName: z.string().trim().min(2, "Full name is required"),
  preferredName: optStr,
  workEmail: z.string().trim().email("Enter a valid email").optional().or(z.literal("")),
  phone: optStr,
  departmentId: optStr,
  jobProfileId: optStr,
  grade: z.enum(GRADES).or(z.literal("")).optional(),
  payCategoryId: optStr,
  managerId: optStr,
  employmentType: z.enum(TYPES),
  status: z.enum(STATUSES),
  startDate: optStr,
  bankNameMasked: optStr,
  bankAcctMasked: optStr,
  // ── rich personal fields (v0.36.0) ──
  dateOfBirth: optStr,
  gender: z.enum(GENDERS).or(z.literal("")).optional(),
  maritalStatus: z.enum(MARITAL).or(z.literal("")).optional(),
  nationality: optStr,
  stateOfOrigin: optStr,
  personalEmail: z.string().trim().email("Enter a valid personal email").optional().or(z.literal("")),
  personalPhone: optStr,
  residentialAddress: optStr,
  city: optStr,
  stateRegion: optStr,
  country: optStr,
  workLocation: z.enum(WORK_LOC).or(z.literal("")).optional(),
  nokName: optStr,
  nokRelationship: optStr,
  nokPhone: optStr,
  nokAddress: optStr,
  idType: z.enum(ID_TYPES).or(z.literal("")).optional(),
  idNumberMasked: optStr,
});

function nz(v: string | undefined | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function nd(v: string | undefined | null): Date | null {
  const s = (v ?? "").trim();
  return s === "" ? null : new Date(s);
}

const TEXT_FIELDS = [
  "fullName",
  "preferredName",
  "workEmail",
  "phone",
  "departmentId",
  "jobProfileId",
  "grade",
  "payCategoryId",
  "managerId",
  "employmentType",
  "status",
  "startDate",
  "bankNameMasked",
  "bankAcctMasked",
  "dateOfBirth",
  "gender",
  "maritalStatus",
  "nationality",
  "stateOfOrigin",
  "personalEmail",
  "personalPhone",
  "residentialAddress",
  "city",
  "stateRegion",
  "country",
  "workLocation",
  "nokName",
  "nokRelationship",
  "nokPhone",
  "nokAddress",
  "idType",
  "idNumberMasked",
] as const;

function readForm(fd: FormData): Record<string, string> {
  const out: Record<string, string> = {};
  for (const f of TEXT_FIELDS) out[f] = String(fd.get(f) ?? "");
  return out;
}

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

const SENSITIVE = new Set(["bankNameMasked", "bankAcctMasked", "idNumberMasked"]);

// The persisted scalar shape shared by create + update (everything except eeId).
function buildScalars(v: z.infer<typeof baseSchema>) {
  return {
    fullName: v.fullName.trim(),
    preferredName: nz(v.preferredName),
    workEmail: nz(v.workEmail),
    phone: nz(v.phone),
    departmentId: nz(v.departmentId),
    jobProfileId: nz(v.jobProfileId),
    grade: nz(v.grade),
    payCategoryId: nz(v.payCategoryId),
    managerId: nz(v.managerId),
    employmentType: v.employmentType,
    status: v.status,
    startDate: nd(v.startDate),
    bankNameMasked: nz(v.bankNameMasked),
    bankAcctMasked: nz(v.bankAcctMasked),
    dateOfBirth: nd(v.dateOfBirth),
    gender: nz(v.gender),
    maritalStatus: nz(v.maritalStatus),
    nationality: nz(v.nationality),
    stateOfOrigin: nz(v.stateOfOrigin),
    personalEmail: nz(v.personalEmail),
    personalPhone: nz(v.personalPhone),
    residentialAddress: nz(v.residentialAddress),
    city: nz(v.city),
    stateRegion: nz(v.stateRegion),
    country: nz(v.country),
    workLocation: nz(v.workLocation),
    nokName: nz(v.nokName),
    nokRelationship: nz(v.nokRelationship),
    nokPhone: nz(v.nokPhone),
    nokAddress: nz(v.nokAddress),
    idType: nz(v.idType),
    idNumberMasked: nz(v.idNumberMasked),
  };
}

// ── employment-history auto-log (S1a) ───────────────────────────────────────
const GRADE_RANK: Record<string, number> = { G0: 0, G1: 1, G2: 2, G3: 3, G4: 4, G5: 5 };

type MaterialCur = {
  grade: string | null;
  jobProfileId: string | null;
  departmentId: string | null;
  managerId: string | null;
  status: string;
};

function inferEventType(cur: MaterialCur, next: MaterialCur): string | null {
  if (next.status === "EXITED" && cur.status !== "EXITED") return "EXIT";
  if (cur.status === "PROBATION" && next.status === "ACTIVE") return "CONFIRMATION";
  if ((cur.grade ?? null) !== (next.grade ?? null)) {
    const a = cur.grade ? GRADE_RANK[cur.grade] : undefined;
    const b = next.grade ? GRADE_RANK[next.grade] : undefined;
    return a !== undefined && b !== undefined && b > a ? "PROMOTION" : "REGRADE";
  }
  if (cur.jobProfileId !== next.jobProfileId) return "TRANSFER";
  if (cur.departmentId !== next.departmentId || cur.managerId !== next.managerId) return "TRANSFER";
  if (cur.status !== next.status) return "STATUS_CHANGE";
  return null;
}

async function nameFor(table: "department" | "jobProfile" | "employee", id: string | null): Promise<string> {
  if (!id) return "—";
  if (table === "department") {
    const r = await prisma.department.findUnique({ where: { id }, select: { name: true } });
    return r?.name ?? id;
  }
  if (table === "jobProfile") {
    const r = await prisma.jobProfile.findUnique({ where: { id }, select: { title: true } });
    return r?.title ?? id;
  }
  const r = await prisma.employee.findUnique({ where: { id }, select: { fullName: true } });
  return r?.fullName ?? id;
}

// Builds a friendly history note + the grade snapshot for an auto-logged row,
// or returns null if nothing material changed.
async function buildAutoHistory(
  cur: MaterialCur,
  next: MaterialCur
): Promise<{ eventType: string; note: string; gradeSnapshot: string | null; title: string | null } | null> {
  const eventType = inferEventType(cur, next);
  if (!eventType) return null;

  const parts: string[] = [];
  if ((cur.grade ?? null) !== (next.grade ?? null)) {
    parts.push(`Grade ${cur.grade ?? "role default"} → ${next.grade ?? "role default"}`);
  }
  if (cur.jobProfileId !== next.jobProfileId) {
    parts.push(`Role ${await nameFor("jobProfile", cur.jobProfileId)} → ${await nameFor("jobProfile", next.jobProfileId)}`);
  }
  if (cur.departmentId !== next.departmentId) {
    parts.push(`Department ${await nameFor("department", cur.departmentId)} → ${await nameFor("department", next.departmentId)}`);
  }
  if (cur.managerId !== next.managerId) {
    parts.push(`Manager ${await nameFor("employee", cur.managerId)} → ${await nameFor("employee", next.managerId)}`);
  }
  if (cur.status !== next.status) {
    parts.push(`Status ${cur.status} → ${next.status}`);
  }

  let gradeSnapshot = next.grade;
  if (!gradeSnapshot && next.jobProfileId) {
    const jp = await prisma.jobProfile.findUnique({ where: { id: next.jobProfileId }, select: { grade: true } });
    gradeSnapshot = jp?.grade ?? null;
  }
  const title = next.jobProfileId ? await nameFor("jobProfile", next.jobProfileId) : null;

  return { eventType, note: parts.join("; "), gradeSnapshot, title };
}

export async function updateEmployeeAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing employee id." };

  const parsed = baseSchema.safeParse(readForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const cur = await prisma.employee.findUnique({ where: { id } });
  if (!cur) return { ok: false, error: "Employee not found." };

  const scalars = buildScalars(v);
  const managerId = scalars.managerId;
  if (managerId) {
    if (managerId === id)
      return { ok: false, fieldErrors: { managerId: "An employee cannot manage themselves." } };
    const descendants = await getDescendantIds(id);
    if (descendants.has(managerId))
      return {
        ok: false,
        fieldErrors: { managerId: "That person reports to this employee — it would create a loop." },
      };
  }

  const next = {
    ...scalars,
    exitDate: scalars.status === "EXITED" ? cur.exitDate ?? new Date() : null,
  };

  // diff for audit + minimal update
  const data: Record<string, unknown> = {};
  const changes: string[] = [];
  const iso = (d: Date | null) => (d ? d.toISOString().slice(0, 10) : null);
  const compare: [string, unknown, unknown][] = [
    ["fullName", cur.fullName, next.fullName],
    ["preferredName", cur.preferredName, next.preferredName],
    ["workEmail", cur.workEmail, next.workEmail],
    ["phone", cur.phone, next.phone],
    ["departmentId", cur.departmentId, next.departmentId],
    ["jobProfileId", cur.jobProfileId, next.jobProfileId],
    ["grade", cur.grade, next.grade],
    ["payCategoryId", cur.payCategoryId, next.payCategoryId],
    ["managerId", cur.managerId, next.managerId],
    ["employmentType", cur.employmentType, next.employmentType],
    ["status", cur.status, next.status],
    ["startDate", iso(cur.startDate), iso(next.startDate)],
    ["bankNameMasked", cur.bankNameMasked, next.bankNameMasked],
    ["bankAcctMasked", cur.bankAcctMasked, next.bankAcctMasked],
    ["dateOfBirth", iso(cur.dateOfBirth), iso(next.dateOfBirth)],
    ["gender", cur.gender, next.gender],
    ["maritalStatus", cur.maritalStatus, next.maritalStatus],
    ["nationality", cur.nationality, next.nationality],
    ["stateOfOrigin", cur.stateOfOrigin, next.stateOfOrigin],
    ["personalEmail", cur.personalEmail, next.personalEmail],
    ["personalPhone", cur.personalPhone, next.personalPhone],
    ["residentialAddress", cur.residentialAddress, next.residentialAddress],
    ["city", cur.city, next.city],
    ["stateRegion", cur.stateRegion, next.stateRegion],
    ["country", cur.country, next.country],
    ["workLocation", cur.workLocation, next.workLocation],
    ["nokName", cur.nokName, next.nokName],
    ["nokRelationship", cur.nokRelationship, next.nokRelationship],
    ["nokPhone", cur.nokPhone, next.nokPhone],
    ["nokAddress", cur.nokAddress, next.nokAddress],
    ["idType", cur.idType, next.idType],
    ["idNumberMasked", cur.idNumberMasked, next.idNumberMasked],
  ];
  for (const [key, before, after] of compare) {
    if (before !== after) {
      (data as Record<string, unknown>)[key] = (next as Record<string, unknown>)[key];
      changes.push(SENSITIVE.has(key) ? `${key} (updated)` : `${key}: ${before ?? "—"} → ${after ?? "—"}`);
    }
  }
  if (cur.exitDate?.getTime() !== next.exitDate?.getTime()) {
    data.exitDate = next.exitDate;
  }

  if (changes.length === 0 && data.exitDate === undefined) {
    redirect(`/employees/${id}`);
  }

  await prisma.employee.update({ where: { id }, data });

  // S1a — auto-append an employment-history row on a material change.
  const auto = await buildAutoHistory(
    { grade: cur.grade, jobProfileId: cur.jobProfileId, departmentId: cur.departmentId, managerId: cur.managerId, status: cur.status },
    { grade: next.grade, jobProfileId: next.jobProfileId, departmentId: next.departmentId, managerId: next.managerId, status: next.status }
  );
  if (auto) {
    await prisma.employmentRecord.create({
      data: {
        employeeId: id,
        eventType: auto.eventType,
        title: auto.title,
        grade: auto.gradeSnapshot,
        jobProfileId: next.jobProfileId,
        departmentId: next.departmentId,
        managerId: next.managerId,
        status: next.status,
        effectiveDate: new Date(),
        note: auto.note || null,
      },
    });
  }

  await writeAudit({
    actorId: me.id,
    action: "employee.update",
    entityType: "employee",
    entityId: id,
    metadata: { eeId: cur.eeId, changes, autoEvent: auto?.eventType ?? null },
  });

  revalidatePath("/employees");
  revalidatePath("/employees/org");
  revalidatePath(`/employees/${id}`);
  redirect(`/employees/${id}`);
}

const createSchema = baseSchema.extend({
  eeId: z.string().trim().min(1, "Employee ID is required"),
});

export async function createEmployeeAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const parsed = createSchema.safeParse({ ...readForm(fd), eeId: String(fd.get("eeId") ?? "") });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const dupe = await prisma.employee.findUnique({ where: { eeId: v.eeId.trim() } });
  if (dupe) return { ok: false, fieldErrors: { eeId: "That Employee ID already exists." } };

  const scalars = buildScalars(v);
  const created = await prisma.employee.create({
    data: {
      eeId: v.eeId.trim(),
      ...scalars,
      exitDate: scalars.status === "EXITED" ? new Date() : null,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "employee.create",
    entityType: "employee",
    entityId: created.id,
    metadata: { eeId: created.eeId, fullName: created.fullName },
  });

  revalidatePath("/employees");
  revalidatePath("/employees/org");
  redirect(`/employees/${created.id}`);
}

// ── Dependents (employee_dependents) ────────────────────────────────────────
const dependentSchema = z.object({
  employeeId: z.string().min(1),
  fullName: z.string().trim().min(2, "Name is required"),
  relationship: z.enum(RELATIONSHIPS),
  dateOfBirth: optStr,
  note: optStr,
});

export async function addDependentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const parsed = dependentSchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    fullName: String(fd.get("fullName") ?? ""),
    relationship: String(fd.get("relationship") ?? ""),
    dateOfBirth: String(fd.get("dateOfBirth") ?? ""),
    note: String(fd.get("note") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const emp = await prisma.employee.findUnique({ where: { id: v.employeeId }, select: { id: true, eeId: true } });
  if (!emp) return { ok: false, error: "Employee not found." };

  const count = await prisma.employeeDependent.count({ where: { employeeId: v.employeeId } });
  const dep = await prisma.employeeDependent.create({
    data: {
      employeeId: v.employeeId,
      fullName: v.fullName.trim(),
      relationship: v.relationship,
      dateOfBirth: nd(v.dateOfBirth),
      note: nz(v.note),
      sortOrder: count,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "employee.dependent_add",
    entityType: "employee",
    entityId: v.employeeId,
    metadata: { eeId: emp.eeId, dependentId: dep.id, relationship: v.relationship },
  });

  revalidatePath(`/employees/${v.employeeId}`);
  return { ok: true };
}

export async function removeDependentAction(fd: FormData): Promise<void> {
  const me = await requirePermission("employees.manage");
  const id = String(fd.get("id") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!id || !employeeId) return;

  const dep = await prisma.employeeDependent.findUnique({ where: { id }, select: { id: true, employeeId: true } });
  if (!dep || dep.employeeId !== employeeId) return;

  await prisma.employeeDependent.delete({ where: { id } });
  await writeAudit({
    actorId: me.id,
    action: "employee.dependent_remove",
    entityType: "employee",
    entityId: employeeId,
    metadata: { dependentId: id },
  });
  revalidatePath(`/employees/${employeeId}`);
}

// ── Manual employment-history event ─────────────────────────────────────────
const historySchema = z.object({
  employeeId: z.string().min(1),
  eventType: z.enum(EVENT_TYPES),
  effectiveDate: z.string().trim().min(1, "Effective date is required"),
  title: optStr,
  grade: z.enum(GRADES).or(z.literal("")).optional(),
  note: optStr,
});

export async function addEmploymentRecordAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const parsed = historySchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    eventType: String(fd.get("eventType") ?? ""),
    effectiveDate: String(fd.get("effectiveDate") ?? ""),
    title: String(fd.get("title") ?? ""),
    grade: String(fd.get("grade") ?? ""),
    note: String(fd.get("note") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const emp = await prisma.employee.findUnique({
    where: { id: v.employeeId },
    select: { id: true, eeId: true, status: true },
  });
  if (!emp) return { ok: false, error: "Employee not found." };

  await prisma.employmentRecord.create({
    data: {
      employeeId: v.employeeId,
      eventType: v.eventType,
      title: nz(v.title),
      grade: nz(v.grade),
      status: emp.status,
      effectiveDate: new Date(v.effectiveDate),
      note: nz(v.note),
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "employee.history_add",
    entityType: "employee",
    entityId: v.employeeId,
    metadata: { eeId: emp.eeId, eventType: v.eventType },
  });

  revalidatePath(`/employees/${v.employeeId}`);
  return { ok: true };
}
