"use server";
// Write-side server actions for Leave. Two-stage approval: an employee submits a
// request (self-service), the requester's LINE MANAGER recommends or declines it,
// then HR (leave.manage) takes the final decision. Approving applies the day count
// to the employee's balance for that leave year. Every action is gated, validated,
// transactional where it touches more than one row, and audited — mirroring the
// Compensation module's conventions.
//
// Separation of duties: if the final HR approver is also the requester (an HR
// admin's own leave), v1 allows it but stamps the audit entry self_approved — the
// same posture as Compensation sign-off.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requireUser, requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { computeRequestDays } from "@/lib/leave";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const MANAGER_DECISIONS = ["RECOMMEND", "DECLINE"] as const;
const HR_DECISIONS = ["APPROVE", "REJECT"] as const;

// ---------------------------------------------------------------------------
// Parsing helpers
// ---------------------------------------------------------------------------
function nz(v?: FormDataEntryValue | null): string | null {
  const s = (typeof v === "string" ? v : "").trim();
  return s === "" ? null : s;
}
function s(v?: FormDataEntryValue | null): string {
  return typeof v === "string" ? v.trim() : "";
}
/** Parse a date-only ("YYYY-MM-DD") input as UTC midnight; null if blank/invalid. */
function parseDateUTC(v?: FormDataEntryValue | null): Date | null {
  const str = s(v);
  if (!str) return null;
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(str);
  if (m) {
    const dt = new Date(Date.UTC(+m[1], +m[2] - 1, +m[3]));
    return Number.isNaN(dt.getTime()) ? null : dt;
  }
  const dt = new Date(str);
  return Number.isNaN(dt.getTime()) ? null : dt;
}
function parseNum(v?: FormDataEntryValue | null): number | null {
  const str = s(v);
  if (str === "") return null;
  const n = Number(str);
  return Number.isNaN(n) ? null : n;
}

// ---------------------------------------------------------------------------
// 1) Submit a leave request (self-service)
// ---------------------------------------------------------------------------
export async function requestLeaveAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("leave.view");

  const employee = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true, status: true },
  });
  if (!employee) {
    return { ok: false, error: "Your login isn’t linked to an employee record, so you can’t request leave." };
  }
  if (employee.status === "EXITED") {
    return { ok: false, error: "This employee record is exited." };
  }

  const leaveTypeId = s(fd.get("leaveTypeId"));
  const startDate = parseDateUTC(fd.get("startDate"));
  const endDate = parseDateUTC(fd.get("endDate"));
  const half = s(fd.get("half")) === "on" || s(fd.get("half")) === "1";
  const note = nz(fd.get("note"));

  const fieldErrors: Record<string, string> = {};
  if (!leaveTypeId) fieldErrors.leaveTypeId = "Choose a leave type.";
  if (!startDate) fieldErrors.startDate = "Start date is required.";
  if (!endDate) fieldErrors.endDate = "End date is required.";
  if (startDate && endDate && endDate.getTime() < startDate.getTime())
    fieldErrors.endDate = "End date can’t be before the start date.";
  if (half && startDate && endDate && startDate.getTime() !== endDate.getTime())
    fieldErrors.half = "A half day applies to a single date only.";
  if (Object.keys(fieldErrors).length) return { ok: false, fieldErrors };

  const type = await prisma.leaveType.findUnique({ where: { id: leaveTypeId }, select: { id: true } });
  if (!type) return { ok: false, fieldErrors: { leaveTypeId: "Unknown leave type." } };

  const days = computeRequestDays(startDate!, endDate!, half);
  if (days <= 0) {
    return { ok: false, fieldErrors: { startDate: "That range contains no working days (weekends are excluded)." } };
  }

  const created = await prisma.leaveRequest.create({
    data: {
      employeeId: employee.id,
      leaveTypeId,
      startDate: startDate!,
      endDate: endDate!,
      days,
      status: "PENDING",
      managerStatus: "PENDING",
      note,
    },
    select: { id: true },
  });

  await writeAudit({
    actorId: me.id,
    action: "leaverequest.create",
    entityType: "leave_request",
    entityId: created.id,
    metadata: { employeeId: employee.id, leaveTypeId, days },
  });

  revalidatePath("/leave");
  redirect("/leave");
}

// ---------------------------------------------------------------------------
// 2) Line-manager review (recommend / decline)
// ---------------------------------------------------------------------------
export async function managerReviewLeaveAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireUser();
  const requestId = s(fd.get("requestId"));
  const decision = s(fd.get("decision"));
  const managerNote = nz(fd.get("managerNote"));
  if (!requestId) return { ok: false, error: "Missing request." };
  if (!(MANAGER_DECISIONS as readonly string[]).includes(decision))
    return { ok: false, error: "Choose recommend or decline." };

  const req = await prisma.leaveRequest.findUnique({
    where: { id: requestId },
    select: { id: true, status: true, managerStatus: true, employeeId: true, employee: { select: { managerId: true } } },
  });
  if (!req) return { ok: false, error: "Request not found." };

  // Authorization is relationship-based: only the requester's line manager may
  // review. Resolve the signed-in user's employee and compare.
  const reviewer = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true },
  });
  if (!reviewer || req.employee.managerId !== reviewer.id) redirect("/access-denied");

  if (req.status !== "PENDING") return { ok: false, error: "This request has already been decided." };
  if (req.managerStatus !== "PENDING") return { ok: false, error: "This request has already been reviewed." };

  await prisma.leaveRequest.update({
    where: { id: requestId },
    data: {
      managerStatus: decision === "RECOMMEND" ? "RECOMMENDED" : "DECLINED",
      managerReviewerId: me.id,
      managerReviewedAt: new Date(),
      managerNote,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "leaverequest.manager_review",
    entityType: "leave_request",
    entityId: requestId,
    metadata: { employeeId: req.employeeId, decision },
  });

  revalidatePath("/leave");
  redirect("/leave");
}

// ---------------------------------------------------------------------------
// 3) HR final decision (approve applies the balance / reject)
// ---------------------------------------------------------------------------
export async function decideLeaveAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("leave.manage");
  const requestId = s(fd.get("requestId"));
  const decision = s(fd.get("decision"));
  const decisionNote = nz(fd.get("decisionNote"));
  if (!requestId) return { ok: false, error: "Missing request." };
  if (!(HR_DECISIONS as readonly string[]).includes(decision))
    return { ok: false, error: "Choose approve or reject." };

  const req = await prisma.leaveRequest.findUnique({
    where: { id: requestId },
    select: {
      id: true,
      status: true,
      managerStatus: true,
      employeeId: true,
      leaveTypeId: true,
      startDate: true,
      days: true,
      employee: { select: { managerId: true, userId: true } },
      leaveType: { select: { daysPerYear: true } },
    },
  });
  if (!req) return { ok: false, error: "Request not found." };
  if (req.status !== "PENDING") return { ok: false, error: "This request has already been decided." };

  const needsManager = !!req.employee.managerId;
  if (needsManager && req.managerStatus === "PENDING") {
    return { ok: false, error: "This request is awaiting line-manager review first." };
  }

  const selfApproved = req.employee.userId === me.id;
  const days = Number(req.days);
  const year = req.startDate.getUTCFullYear();

  if (decision === "REJECT") {
    await prisma.leaveRequest.update({
      where: { id: requestId },
      data: { status: "REJECTED", approverId: me.id, decidedAt: new Date(), decisionNote },
    });
    await writeAudit({
      actorId: me.id,
      action: "leaverequest.reject",
      entityType: "leave_request",
      entityId: requestId,
      metadata: { employeeId: req.employeeId, self_approved: selfApproved },
    });
  } else {
    // APPROVE: apply the day count to the employee's balance for that leave year
    // (creating the balance row from the type default if it doesn't exist yet),
    // then mark the request approved — atomically.
    await prisma.$transaction(async (tx) => {
      await tx.leaveBalance.upsert({
        where: {
          employeeId_leaveTypeId_year: {
            employeeId: req.employeeId,
            leaveTypeId: req.leaveTypeId,
            year,
          },
        },
        create: {
          employeeId: req.employeeId,
          leaveTypeId: req.leaveTypeId,
          year,
          daysEntitled: Number(req.leaveType.daysPerYear),
          daysTaken: days,
        },
        update: { daysTaken: { increment: days } },
      });
      await tx.leaveRequest.update({
        where: { id: requestId },
        data: { status: "APPROVED", approverId: me.id, decidedAt: new Date(), decisionNote },
      });
    });
    await writeAudit({
      actorId: me.id,
      action: "leaverequest.approve",
      entityType: "leave_request",
      entityId: requestId,
      metadata: { employeeId: req.employeeId, days, year, self_approved: selfApproved },
    });
  }

  revalidatePath("/leave");
  revalidatePath("/leave/balances");
  redirect("/leave");
}

// ---------------------------------------------------------------------------
// 4) Cancel a pending request (requester, or HR)
// ---------------------------------------------------------------------------
export async function cancelLeaveAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireUser();
  const requestId = s(fd.get("requestId"));
  if (!requestId) return { ok: false, error: "Missing request." };

  const req = await prisma.leaveRequest.findUnique({
    where: { id: requestId },
    select: { id: true, status: true, employeeId: true, employee: { select: { userId: true } } },
  });
  if (!req) return { ok: false, error: "Request not found." };

  const isOwner = req.employee.userId === me.id;
  const canManage = me.permissions.has("leave.manage");
  if (!isOwner && !canManage) redirect("/access-denied");

  if (req.status !== "PENDING") return { ok: false, error: "Only a pending request can be cancelled." };

  await prisma.leaveRequest.update({ where: { id: requestId }, data: { status: "CANCELLED" } });
  await writeAudit({
    actorId: me.id,
    action: "leaverequest.cancel",
    entityType: "leave_request",
    entityId: requestId,
    metadata: { employeeId: req.employeeId, byOwner: isOwner },
  });

  revalidatePath("/leave");
  redirect("/leave");
}

// ---------------------------------------------------------------------------
// 5) Edit a per-employee entitlement (HR) — Balances editor
// ---------------------------------------------------------------------------
const entitlementSchema = z.object({
  employeeId: z.string().min(1),
  leaveTypeId: z.string().min(1),
  year: z.number().int().min(2000).max(2100),
  daysEntitled: z.number().min(0).max(366),
});

export async function saveEntitlementAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("leave.manage");

  const parsed = entitlementSchema.safeParse({
    employeeId: s(fd.get("employeeId")),
    leaveTypeId: s(fd.get("leaveTypeId")),
    year: parseNum(fd.get("year")) ?? NaN,
    daysEntitled: parseNum(fd.get("daysEntitled")) ?? NaN,
  });
  if (!parsed.success) return { ok: false, error: "Enter a valid number of days (0–366)." };
  const { employeeId, leaveTypeId, year, daysEntitled } = parsed.data;

  await prisma.leaveBalance.upsert({
    where: { employeeId_leaveTypeId_year: { employeeId, leaveTypeId, year } },
    create: { employeeId, leaveTypeId, year, daysEntitled, daysTaken: 0 },
    update: { daysEntitled },
  });

  await writeAudit({
    actorId: me.id,
    action: "leavebalance.set_entitlement",
    entityType: "leave_balance",
    entityId: `${employeeId}:${leaveTypeId}:${year}`,
    metadata: { employeeId, leaveTypeId, year, daysEntitled },
  });

  revalidatePath("/leave/balances");
  revalidatePath("/leave");
  redirect("/leave/balances");
}

// ---------------------------------------------------------------------------
// 6) Create / edit a leave type + its default entitlement (HR) — Types editor
// ---------------------------------------------------------------------------
const typeSchema = z.object({
  id: z.string().optional(),
  name: z.string().min(2).max(80),
  daysPerYear: z.number().int().min(0).max(366),
});

export async function saveLeaveTypeAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("leave.manage");

  const parsed = typeSchema.safeParse({
    id: nz(fd.get("id")) ?? undefined,
    name: s(fd.get("name")),
    daysPerYear: parseNum(fd.get("daysPerYear")) ?? NaN,
  });
  if (!parsed.success) {
    return { ok: false, error: "Enter a name (2–80 chars) and a default of 0–366 days." };
  }
  const { id, name, daysPerYear } = parsed.data;

  // Names are unique in the schema; surface a friendly message on collision.
  const clash = await prisma.leaveType.findFirst({
    where: { name, ...(id ? { NOT: { id } } : {}) },
    select: { id: true },
  });
  if (clash) return { ok: false, fieldErrors: { name: "A leave type with that name already exists." } };

  let entityId: string;
  if (id) {
    const updated = await prisma.leaveType.update({
      where: { id },
      data: { name, daysPerYear },
      select: { id: true },
    });
    entityId = updated.id;
  } else {
    const created = await prisma.leaveType.create({
      data: { name, daysPerYear },
      select: { id: true },
    });
    entityId = created.id;
  }

  await writeAudit({
    actorId: me.id,
    action: id ? "leavetype.update" : "leavetype.create",
    entityType: "leave_type",
    entityId,
    metadata: { name, daysPerYear },
  });

  revalidatePath("/leave/types");
  revalidatePath("/leave");
  redirect("/leave/types");
}
