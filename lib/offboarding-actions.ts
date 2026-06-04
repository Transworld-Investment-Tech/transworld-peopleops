"use server";
// Write-side server actions for offboarding. Gated by offboarding.manage,
// validated, audited. The two LIVE-DATA writes — access revocation and case
// close — are preview -> commit gated: the page shows the computed preview and
// the commit must carry an explicit confirm token. Nothing here is automated.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { EXIT_TYPES, defaultOffboardingTasks, clawbackOnExit, exitTypeLabel } from "@/lib/ws4";

export type FormState = { ok: boolean; error?: string; fieldErrors?: Record<string, string> };

function nz(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}
function parseDateUTC(v: FormDataEntryValue | null): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(`${s}T00:00:00.000Z`);
  return Number.isNaN(d.getTime()) ? null : d;
}

async function caseForEmployee(employeeId: string) {
  return prisma.offboardingCase.findFirst({
    where: { employeeId, status: { in: ["OPEN", "CLEARING"] } },
    orderBy: { createdAt: "desc" },
  });
}

async function terminalCaseForEmployee(employeeId: string) {
  return prisma.offboardingCase.findFirst({
    where: { employeeId, status: { in: ["CLOSED", "CANCELLED"] } },
    orderBy: { createdAt: "desc" },
  });
}

// ── Open an exit case ────────────────────────────────────────────────────────
export async function openOffboardingAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  const exitType = String(fd.get("exitType") ?? "");
  if (!employeeId) return { ok: false, error: "Choose an employee." };
  if (!(EXIT_TYPES as readonly string[]).includes(exitType)) return { ok: false, error: "Choose the type of exit." };

  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true, status: true, userId: true, isRegulatedRole: true },
  });
  if (!e) return { ok: false, error: "Employee not found." };
  if (String(e.status) === "EXITED") return { ok: false, error: "That employee has already exited." };

  const open = await caseForEmployee(employeeId);
  if (open) redirect(`/offboarding/${employeeId}`);

  let elevated = false;
  if (e.userId) {
    const u = await prisma.user.findUnique({ where: { id: e.userId }, select: { roles: { include: { role: true } } } });
    const keys = u?.roles.map((r) => r.role.key) ?? [];
    elevated = keys.includes("SUPER_ADMIN") || keys.includes("admin.users");
  }

  const created = await prisma.offboardingCase.create({
    data: {
      employeeId,
      eeId: e.eeId,
      employeeName: e.fullName,
      userId: e.userId ?? null,
      exitType,
      status: "OPEN",
      noticeReceivedAt: parseDateUTC(fd.get("noticeReceivedAt")),
      lastWorkingDay: parseDateUTC(fd.get("lastWorkingDay")),
      reason: nz(fd.get("reason")),
    },
  });
  const seeds = defaultOffboardingTasks(exitType, e.isRegulatedRole, elevated);
  await prisma.offboardingTask.createMany({
    data: seeds.map((s) => ({ caseId: created.id, label: s.label, category: s.category, sortOrder: s.sortOrder })),
  });
  await writeAudit({
    actorId: me.id,
    action: "offboarding.open",
    entityType: "offboarding_case",
    entityId: created.id,
    metadata: { exitType, employeeId },
  });
  redirect(`/offboarding/${employeeId}`);
}

// ── Edit case fields ─────────────────────────────────────────────────────────
export async function updateOffboardingFieldsAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case." };
  await prisma.offboardingCase.update({
    where: { id: c.id },
    data: {
      noticeReceivedAt: parseDateUTC(fd.get("noticeReceivedAt")) ?? undefined,
      lastWorkingDay: parseDateUTC(fd.get("lastWorkingDay")) ?? undefined,
      reason: nz(fd.get("reason")) ?? undefined,
      note: nz(fd.get("note")) ?? undefined,
    },
  });
  await writeAudit({ actorId: me.id, action: "offboarding.update", entityType: "offboarding_case", entityId: c.id, metadata: {} });
  revalidatePath(`/offboarding/${employeeId}`);
  return { ok: true };
}

// ── Checklist + flags ────────────────────────────────────────────────────────
export async function setOffboardingTaskStatusAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  const taskId = String(fd.get("taskId") ?? "");
  const status = String(fd.get("status") ?? "");
  if (!["PENDING", "DONE", "NA"].includes(status)) return { ok: false, error: "Invalid status." };
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case." };
  const task = await prisma.offboardingTask.findFirst({ where: { id: taskId, caseId: c.id }, select: { id: true } });
  if (!task) return { ok: false, error: "Task not found." };
  await prisma.offboardingTask.update({
    where: { id: task.id },
    data: { status, doneAt: status === "DONE" ? new Date() : null },
  });
  revalidatePath(`/offboarding/${employeeId}`);
  return { ok: true };
}

export async function setOffboardingFlagAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  const flag = String(fd.get("flag") ?? "");
  const value = String(fd.get("value") ?? "") === "true";
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case." };

  const data: { exitInterviewDone?: boolean; finalPaySettled?: boolean; regulatoryNotified?: boolean } = {};
  if (flag === "exitInterviewDone") data.exitInterviewDone = value;
  else if (flag === "finalPaySettled") data.finalPaySettled = value;
  else if (flag === "regulatoryNotified") data.regulatoryNotified = value;
  else return { ok: false, error: "Unknown flag." };

  await prisma.offboardingCase.update({ where: { id: c.id }, data });
  await writeAudit({ actorId: me.id, action: "offboarding.flag", entityType: "offboarding_case", entityId: c.id, metadata: { flag, value } });
  revalidatePath(`/offboarding/${employeeId}`);
  return { ok: true };
}

// ── LIVE WRITE 1: access revocation (preview -> commit) ──────────────────────
export async function revokeAccessAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (String(fd.get("confirm") ?? "") !== "REVOKE") {
    return { ok: false, error: "Confirm the revocation to proceed." };
  }
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case." };

  const e = await prisma.employee.findUnique({ where: { id: employeeId }, select: { userId: true } });
  let revokedRoles = 0;
  if (e?.userId) {
    if (e.userId === me.id) return { ok: false, error: "You can't revoke your own account." };
    const del = await prisma.userRole.deleteMany({ where: { userId: e.userId } });
    revokedRoles = del.count;
    await prisma.user.update({ where: { id: e.userId }, data: { status: "disabled" } });
  }
  // Mark the SYSTEM (access) checklist items done, and move the case to CLEARING.
  await prisma.offboardingTask.updateMany({
    where: { caseId: c.id, category: "SYSTEM", status: "PENDING" },
    data: { status: "DONE", doneAt: new Date() },
  });
  await prisma.offboardingCase.update({
    where: { id: c.id },
    data: {
      accessRevokedAt: new Date(),
      accessRevokedById: me.id,
      status: c.status === "OPEN" ? "CLEARING" : c.status,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "offboarding.revoke_access",
    entityType: "offboarding_case",
    entityId: c.id,
    metadata: { userId: e?.userId ?? null, rolesCleared: revokedRoles },
  });
  revalidatePath(`/offboarding/${employeeId}`);
  return { ok: true };
}

// ── LIVE WRITE 2: close the case (preview -> commit) ─────────────────────────
export async function closeOffboardingAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (String(fd.get("confirm") ?? "") !== "CLOSE") {
    return { ok: false, error: "Confirm to mark the employee exited and close the case." };
  }
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case." };

  const waiveAccess = String(fd.get("waiveAccess") ?? "") === "true";
  if (!c.accessRevokedAt && !waiveAccess) {
    return { ok: false, error: "Revoke access first (or explicitly waive it) before closing." };
  }

  const e = await prisma.employee.findUnique({ where: { id: employeeId }, select: { status: true } });
  if (!e) return { ok: false, error: "Employee not found." };

  const exitDate = c.lastWorkingDay ?? new Date();

  // 1) Mark the employee exited (+ audited EXIT event).
  if (String(e.status) !== "EXITED") {
    await prisma.employee.update({ where: { id: employeeId }, data: { status: "EXITED", exitDate } });
    await prisma.employmentRecord.create({
      data: {
        employeeId,
        eventType: "EXIT",
        title: exitTypeLabel(c.exitType),
        status: "EXITED",
        effectiveDate: exitDate,
        note: `Offboarding closed — ${exitTypeLabel(c.exitType)} (WS4 / Ops Manual D5).`,
      },
    });
  }

  // 2) Crystallize sponsorship repayment (Ops Manual G4.3) on each live row.
  const sponsorships = await prisma.qualificationSponsorship.findMany({
    where: { employeeId },
    include: { costs: { select: { amount: true, waived: true } } },
  });
  let crystallized = 0;
  for (const s of sponsorships) {
    // Never clobber a repayment Finance is already working (REPAYING / SETTLED).
    if (s.repaymentStatus === "REPAYING" || s.repaymentStatus === "SETTLED") continue;
    const r = clawbackOnExit({
      exitType: c.exitType,
      status: s.status,
      costs: s.costs.map((x) => ({ amount: Number(x.amount), waived: x.waived })),
      bondingMonths: s.bondingMonths,
      bondingStartBasis: s.bondingStartBasis,
      bondingWaived: s.bondingWaived,
      approvedAt: s.approvedAt,
      completedAt: s.completedAt,
      asOf: exitDate,
    });
    if (r.repaymentStatus === "NOT_APPLICABLE" && s.repaymentStatus === "NOT_APPLICABLE") continue;
    const stamp = `[${exitDate.toISOString().slice(0, 10)}] Exit crystallization (${exitTypeLabel(c.exitType)}): ${r.reason}`;
    await prisma.qualificationSponsorship.update({
      where: { id: s.id },
      data: {
        repaymentStatus: r.repaymentStatus,
        repaymentAmount: r.repaymentAmount ?? null,
        note: s.note ? `${s.note}\n${stamp}` : stamp,
      },
    });
    crystallized += 1;
  }

  // 3) Close the case.
  await prisma.offboardingCase.update({
    where: { id: c.id },
    data: { status: "CLOSED", closedAt: new Date(), closedById: me.id },
  });
  await writeAudit({
    actorId: me.id,
    action: "offboarding.close",
    entityType: "offboarding_case",
    entityId: c.id,
    metadata: { exitType: c.exitType, exitDate: exitDate.toISOString(), sponsorshipsCrystallized: crystallized, accessWaived: waiveAccess },
  });
  revalidatePath(`/offboarding/${employeeId}`);
  revalidatePath(`/offboarding`);
  return { ok: true };
}

// ── Cancel an OPEN / CLEARING case (opened in error, or the leaver retracts) ──
// Not destructive to employment/sponsorship data; the employee is never exited.
// If access was already revoked, it stays revoked — re-grant via User Management.
export async function cancelOffboardingAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (String(fd.get("confirm") ?? "") !== "CANCEL") {
    return { ok: false, error: "Confirm to cancel this exit." };
  }
  const c = await caseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No open exit case to cancel." };

  const reason = nz(fd.get("reason"));
  const stamp = `[${new Date().toISOString().slice(0, 10)}] Cancelled${reason ? `: ${reason}` : ""}.`;
  await prisma.offboardingCase.update({
    where: { id: c.id },
    data: { status: "CANCELLED", note: c.note ? `${c.note}\n${stamp}` : stamp },
  });
  await writeAudit({
    actorId: me.id,
    action: "offboarding.cancel",
    entityType: "offboarding_case",
    entityId: c.id,
    metadata: { accessWasRevoked: !!c.accessRevokedAt, reason },
  });
  revalidatePath(`/offboarding/${employeeId}`);
  revalidatePath(`/offboarding`);
  return { ok: true };
}

// ── Reopen a terminal case (preview -> commit) ───────────────────────────────
// CANCELLED -> OPEN: a simple un-cancel; nothing else changed.
// CLOSED -> OPEN: reverses the close — un-exits the employee (status back to
// ACTIVE, exit date cleared, a REINSTATEMENT event), and reverts any repayment
// THIS close crystallized (PENDING/WAIVED -> NOT_APPLICABLE), never touching
// REPAYING / SETTLED that Finance has since acted on.
export async function reopenOffboardingAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("offboarding.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (String(fd.get("confirm") ?? "") !== "REOPEN") {
    return { ok: false, error: "Confirm to reopen this case." };
  }
  const c = await terminalCaseForEmployee(employeeId);
  if (!c) return { ok: false, error: "No closed or cancelled case to reopen." };

  // Don't reopen on top of a fresh active case for the same person.
  const active = await caseForEmployee(employeeId);
  if (active) return { ok: false, error: "There is already an open case for this person." };

  let reinstated = false;
  let reverted = 0;

  if (c.status === "CLOSED") {
    const e = await prisma.employee.findUnique({ where: { id: employeeId }, select: { status: true } });
    if (e && String(e.status) === "EXITED") {
      await prisma.employee.update({ where: { id: employeeId }, data: { status: "ACTIVE", exitDate: null } });
      await prisma.employmentRecord.create({
        data: {
          employeeId,
          eventType: "REINSTATEMENT",
          title: "Exit reversed (case reopened)",
          status: "ACTIVE",
          effectiveDate: new Date(),
          note: "Offboarding case reopened — employment reinstated to ACTIVE.",
        },
      });
      reinstated = true;
    }
    // Revert repayment crystallization this close set (leave REPAYING/SETTLED).
    const sponsorships = await prisma.qualificationSponsorship.findMany({
      where: { employeeId, repaymentStatus: { in: ["PENDING", "WAIVED"] } },
      select: { id: true, note: true },
    });
    for (const s of sponsorships) {
      const stamp = `[${new Date().toISOString().slice(0, 10)}] Repayment reverted — offboarding case reopened.`;
      await prisma.qualificationSponsorship.update({
        where: { id: s.id },
        data: { repaymentStatus: "NOT_APPLICABLE", repaymentAmount: null, note: s.note ? `${s.note}\n${stamp}` : stamp },
      });
      reverted += 1;
    }
  }

  await prisma.offboardingCase.update({
    where: { id: c.id },
    data: { status: "OPEN", closedAt: null, closedById: null },
  });
  await writeAudit({
    actorId: me.id,
    action: "offboarding.reopen",
    entityType: "offboarding_case",
    entityId: c.id,
    metadata: { from: c.status, reinstated, repaymentsReverted: reverted },
  });
  revalidatePath(`/offboarding/${employeeId}`);
  revalidatePath(`/offboarding`);
  return { ok: true };
}
