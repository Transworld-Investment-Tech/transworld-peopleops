"use server";
// Write-side server actions for the Manage editor. Every mutation is gated by
// employees.manage, validated with zod, writes an audit_logs row with the
// before/after diff, and guards against reporting cycles. These are the only
// employee writes in the app outside the explicit org:bootstrap script.
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

const baseSchema = z.object({
  fullName: z.string().trim().min(2, "Full name is required"),
  preferredName: z.string().trim().optional().or(z.literal("")),
  workEmail: z
    .string()
    .trim()
    .email("Enter a valid email")
    .optional()
    .or(z.literal("")),
  phone: z.string().trim().optional().or(z.literal("")),
  departmentId: z.string().optional().or(z.literal("")),
  jobProfileId: z.string().optional().or(z.literal("")),
  payCategoryId: z.string().optional().or(z.literal("")),
  managerId: z.string().optional().or(z.literal("")),
  employmentType: z.enum(TYPES),
  status: z.enum(STATUSES),
  startDate: z.string().optional().or(z.literal("")),
  bankNameMasked: z.string().trim().optional().or(z.literal("")),
  bankAcctMasked: z.string().trim().optional().or(z.literal("")),
});

function nz(v: string | undefined | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}

function readForm(fd: FormData) {
  return {
    fullName: String(fd.get("fullName") ?? ""),
    preferredName: String(fd.get("preferredName") ?? ""),
    workEmail: String(fd.get("workEmail") ?? ""),
    phone: String(fd.get("phone") ?? ""),
    departmentId: String(fd.get("departmentId") ?? ""),
    jobProfileId: String(fd.get("jobProfileId") ?? ""),
    payCategoryId: String(fd.get("payCategoryId") ?? ""),
    managerId: String(fd.get("managerId") ?? ""),
    employmentType: String(fd.get("employmentType") ?? ""),
    status: String(fd.get("status") ?? ""),
    startDate: String(fd.get("startDate") ?? ""),
    bankNameMasked: String(fd.get("bankNameMasked") ?? ""),
    bankAcctMasked: String(fd.get("bankAcctMasked") ?? ""),
  };
}

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

const SENSITIVE = new Set(["bankNameMasked", "bankAcctMasked"]);

export async function updateEmployeeAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing employee id." };

  const parsed = baseSchema.safeParse(readForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const cur = await prisma.employee.findUnique({ where: { id } });
  if (!cur) return { ok: false, error: "Employee not found." };

  const managerId = nz(v.managerId);
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
    fullName: v.fullName.trim(),
    preferredName: nz(v.preferredName),
    workEmail: nz(v.workEmail),
    phone: nz(v.phone),
    departmentId: nz(v.departmentId),
    jobProfileId: nz(v.jobProfileId),
    payCategoryId: nz(v.payCategoryId),
    managerId,
    employmentType: v.employmentType,
    status: v.status,
    startDate: v.startDate ? new Date(v.startDate) : null,
    exitDate: v.status === "EXITED" ? cur.exitDate ?? new Date() : null,
    bankNameMasked: nz(v.bankNameMasked),
    bankAcctMasked: nz(v.bankAcctMasked),
  };

  // diff for audit + minimal update
  const data: Record<string, unknown> = {};
  const changes: string[] = [];
  const curIso = cur.startDate ? cur.startDate.toISOString().slice(0, 10) : null;
  const nextIso = next.startDate ? next.startDate.toISOString().slice(0, 10) : null;
  const compare: [string, unknown, unknown][] = [
    ["fullName", cur.fullName, next.fullName],
    ["preferredName", cur.preferredName, next.preferredName],
    ["workEmail", cur.workEmail, next.workEmail],
    ["phone", cur.phone, next.phone],
    ["departmentId", cur.departmentId, next.departmentId],
    ["jobProfileId", cur.jobProfileId, next.jobProfileId],
    ["payCategoryId", cur.payCategoryId, next.payCategoryId],
    ["managerId", cur.managerId, next.managerId],
    ["employmentType", cur.employmentType, next.employmentType],
    ["status", cur.status, next.status],
    ["startDate", curIso, nextIso],
    ["bankNameMasked", cur.bankNameMasked, next.bankNameMasked],
    ["bankAcctMasked", cur.bankAcctMasked, next.bankAcctMasked],
  ];
  for (const [key, before, after] of compare) {
    if (before !== after) {
      (data as Record<string, unknown>)[key] =
        key === "startDate" ? next.startDate : (next as Record<string, unknown>)[key];
      changes.push(SENSITIVE.has(key) ? `${key} (updated)` : `${key}: ${before ?? "—"} → ${after ?? "—"}`);
    }
  }
  // exitDate follows status transitions even if listed above didn't catch it
  if (cur.exitDate?.getTime() !== next.exitDate?.getTime()) {
    data.exitDate = next.exitDate;
  }

  if (changes.length === 0 && data.exitDate === undefined) {
    redirect(`/employees/${id}`);
  }

  await prisma.employee.update({ where: { id }, data });
  await writeAudit({
    actorId: me.id,
    action: "employee.update",
    entityType: "employee",
    entityId: id,
    metadata: { eeId: cur.eeId, changes },
  });

  revalidatePath("/employees");
  revalidatePath("/employees/org");
  revalidatePath(`/employees/${id}`);
  redirect(`/employees/${id}`);
}

const createSchema = baseSchema.extend({
  eeId: z.string().trim().min(1, "Employee ID is required"),
});

export async function createEmployeeAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const parsed = createSchema.safeParse({ ...readForm(fd), eeId: String(fd.get("eeId") ?? "") });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const dupe = await prisma.employee.findUnique({ where: { eeId: v.eeId.trim() } });
  if (dupe) return { ok: false, fieldErrors: { eeId: "That Employee ID already exists." } };

  const created = await prisma.employee.create({
    data: {
      eeId: v.eeId.trim(),
      fullName: v.fullName.trim(),
      preferredName: nz(v.preferredName),
      workEmail: nz(v.workEmail),
      phone: nz(v.phone),
      departmentId: nz(v.departmentId),
      jobProfileId: nz(v.jobProfileId),
      payCategoryId: nz(v.payCategoryId),
      managerId: nz(v.managerId),
      employmentType: v.employmentType,
      status: v.status,
      startDate: v.startDate ? new Date(v.startDate) : null,
      exitDate: v.status === "EXITED" ? new Date() : null,
      bankNameMasked: nz(v.bankNameMasked),
      bankAcctMasked: nz(v.bankAcctMasked),
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
