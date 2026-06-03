"use server";
// lib/sponsorship-actions.ts — Qualification sponsorship write actions (WS6 Part 4, v0.24.0).
//
// Segregation of duties mirrors raises/bonus and honors the Ops Manual: People Ops /
// Finance author the sponsorship and its cost lines (compensation.manage); an Executive
// approver signs it off (compensation.approve), and approval may not be done by the
// person who proposed it (no self-approval, enforced on the server). Every mutation is
// gated + audited. These are interactive, per-record writes — there is no batch "apply
// across everyone" step, so no dry-run/--commit gate is involved.
//
// Exposure is never written: it is derived live (see lib/sponsorship.ts). Crystallized
// repayment on early exit (repayment_status / repayment_amount) is left for the WS4
// offboarding build; it is not driven here. Cross-entity ids stay bare snapshot columns.
//
// "use server" rule: this module exports only async functions plus the FormState type.
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { COST_TYPES, ATTEMPT_OUTCOMES, BONDING_BASES } from "@/lib/sponsorship";

export type FormState = { ok: boolean; error?: string; message?: string };

// --- parsing helpers (mirror lib/raise-cycle-actions.ts) -------------------
function str(v: FormDataEntryValue | null): string {
  return typeof v === "string" ? v.trim() : "";
}
function nz(v: FormDataEntryValue | null): string | null {
  const s = str(v);
  return s === "" ? null : s;
}
function parseDate(v: FormDataEntryValue | null): Date | null {
  const s = str(v);
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
function parseMoney(v: FormDataEntryValue | null): number | null {
  const s = str(v).replace(/[₦,\s]/g, "");
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? n : null;
}
function parseInt0(v: FormDataEntryValue | null): number | null {
  const s = str(v).replace(/[,\s]/g, "");
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? Math.trunc(n) : null;
}

function revalidateSponsorship(id: string, employeeId?: string) {
  revalidatePath("/compensation/sponsorship");
  revalidatePath(`/compensation/sponsorship/${id}`);
  if (employeeId) revalidatePath(`/compensation/${employeeId}`);
}

// ---------------------------------------------------------------------------
// Create (-> PROPOSED). People Ops / Finance author. Snapshots ee_id + name.
// ---------------------------------------------------------------------------
export async function createSponsorshipAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");

  const employeeId = str(formData.get("employeeId"));
  const qualificationName = str(formData.get("qualificationName"));
  if (!employeeId) return { ok: false, error: "Choose an employee." };
  if (!qualificationName) return { ok: false, error: "Enter the qualification name." };

  const awardingBody = nz(formData.get("awardingBody"));
  const learningModuleId = nz(formData.get("learningModuleId"));
  const bondingMonths = parseInt0(formData.get("bondingMonths"));
  if (bondingMonths !== null && bondingMonths < 0) {
    return { ok: false, error: "Bonding months cannot be negative." };
  }
  let bondingStartBasis = str(formData.get("bondingStartBasis")) || "ON_COMPLETION";
  if (!BONDING_BASES.includes(bondingStartBasis as never)) bondingStartBasis = "ON_COMPLETION";
  const bondingWaived = str(formData.get("bondingWaived")) === "on";
  const note = nz(formData.get("note"));

  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  const created = await prisma.qualificationSponsorship.create({
    data: {
      employeeId: employee.id,
      eeId: employee.eeId,
      employeeName: employee.fullName,
      qualificationName,
      awardingBody,
      learningModuleId,
      status: "PROPOSED",
      bondingMonths,
      bondingStartBasis,
      bondingWaived,
      note,
      proposedById: me.id,
      proposedAt: new Date(),
    },
    select: { id: true },
  });

  await writeAudit({
    actorId: me.id,
    action: "sponsorship.create",
    entityType: "qualification_sponsorship",
    entityId: created.id,
    metadata: { employeeId: employee.id, qualificationName, bondingMonths, bondingStartBasis, bondingWaived },
  });

  revalidateSponsorship(created.id, employee.id);
  redirect(`/compensation/sponsorship/${created.id}`);
}

// ---------------------------------------------------------------------------
// Approve (PROPOSED -> APPROVED). No self-approval.
// ---------------------------------------------------------------------------
export async function approveSponsorshipAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.approve");
  const id = str(formData.get("sponsorshipId"));
  const s = await prisma.qualificationSponsorship.findUnique({
    where: { id },
    select: { id: true, status: true, proposedById: true, employeeId: true },
  });
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status !== "PROPOSED") return { ok: false, error: "Only a proposed sponsorship can be approved." };
  if (me.id === s.proposedById) {
    return {
      ok: false,
      error:
        "Segregation of duties: a sponsorship must be approved by someone other than the person who proposed it.",
    };
  }
  await prisma.qualificationSponsorship.update({
    where: { id },
    data: { status: "APPROVED", approvedById: me.id, approvedAt: new Date() },
  });
  await writeAudit({
    actorId: me.id,
    action: "sponsorship.approve",
    entityType: "qualification_sponsorship",
    entityId: id,
    metadata: { proposedById: s.proposedById },
  });
  revalidateSponsorship(id, s.employeeId);
  return { ok: true, message: "Approved." };
}

// ---------------------------------------------------------------------------
// Start (APPROVED -> IN_PROGRESS).
// ---------------------------------------------------------------------------
export async function startSponsorshipAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const id = str(formData.get("sponsorshipId"));
  const s = await prisma.qualificationSponsorship.findUnique({
    where: { id },
    select: { status: true, employeeId: true },
  });
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status !== "APPROVED") return { ok: false, error: "Only an approved sponsorship can be started." };
  await prisma.qualificationSponsorship.update({
    where: { id },
    data: { status: "IN_PROGRESS", startedAt: new Date() },
  });
  await writeAudit({ actorId: me.id, action: "sponsorship.start", entityType: "qualification_sponsorship", entityId: id, metadata: null });
  revalidateSponsorship(id, s.employeeId);
  return { ok: true, message: "Marked in progress." };
}

// ---------------------------------------------------------------------------
// Complete (IN_PROGRESS -> COMPLETED). Anchors the bonding clock if basis is
// ON_COMPLETION; under the default ON_APPROVAL the window already runs from approval.
// ---------------------------------------------------------------------------
export async function completeSponsorshipAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const id = str(formData.get("sponsorshipId"));
  const s = await prisma.qualificationSponsorship.findUnique({
    where: { id },
    select: { status: true, employeeId: true },
  });
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status !== "IN_PROGRESS") return { ok: false, error: "Only an in-progress sponsorship can be completed." };
  // The completion date is the date the awarding body confirms the qualification (entered by
  // People Ops from the evidence); it anchors the clawback window. Falls back to today if blank.
  const completedAt = parseDate(formData.get("completionDate")) ?? new Date();
  await prisma.qualificationSponsorship.update({
    where: { id },
    data: { status: "COMPLETED", completedAt },
  });
  await writeAudit({ actorId: me.id, action: "sponsorship.complete", entityType: "qualification_sponsorship", entityId: id, metadata: { completedAt: completedAt.toISOString() } });
  revalidateSponsorship(id, s.employeeId);
  return { ok: true, message: "Marked completed — the clawback window now runs from the completion date." };
}

// ---------------------------------------------------------------------------
// Withdraw (PROPOSED/APPROVED/IN_PROGRESS -> WITHDRAWN). Records a reason.
// ---------------------------------------------------------------------------
export async function withdrawSponsorshipAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const id = str(formData.get("sponsorshipId"));
  const reason = nz(formData.get("reason"));
  const s = await prisma.qualificationSponsorship.findUnique({
    where: { id },
    select: { status: true, employeeId: true, note: true },
  });
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status === "WITHDRAWN") return { ok: false, error: "Already withdrawn." };
  if (s.status === "COMPLETED") return { ok: false, error: "A completed sponsorship cannot be withdrawn." };
  await prisma.qualificationSponsorship.update({
    where: { id },
    data: {
      status: "WITHDRAWN",
      withdrawnById: me.id,
      withdrawnAt: new Date(),
      note: reason ?? s.note,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "sponsorship.withdraw",
    entityType: "qualification_sponsorship",
    entityId: id,
    metadata: { reason },
  });
  revalidateSponsorship(id, s.employeeId);
  return { ok: true, message: "Withdrawn." };
}

// ---------------------------------------------------------------------------
// Cost lines
// ---------------------------------------------------------------------------
async function loadOpenSponsorship(id: string) {
  return prisma.qualificationSponsorship.findUnique({
    where: { id },
    select: { id: true, status: true, employeeId: true },
  });
}

export async function addCostAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const sponsorshipId = str(formData.get("sponsorshipId"));
  const s = await loadOpenSponsorship(sponsorshipId);
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status === "WITHDRAWN") return { ok: false, error: "Cannot add costs to a withdrawn sponsorship." };

  let costType = str(formData.get("costType"));
  if (!COST_TYPES.includes(costType as never)) costType = "OTHER";
  const amount = parseMoney(formData.get("amount"));
  if (amount === null || amount <= 0) return { ok: false, error: "Enter a cost amount greater than zero." };

  const created = await prisma.sponsorshipCost.create({
    data: {
      sponsorshipId,
      costType,
      description: nz(formData.get("description")),
      amount,
      incurredDate: parseDate(formData.get("incurredDate")),
      paid: str(formData.get("paid")) === "on",
      paidDate: parseDate(formData.get("paidDate")),
      note: nz(formData.get("note")),
    },
    select: { id: true },
  });
  await writeAudit({
    actorId: me.id,
    action: "sponsorshipcost.add",
    entityType: "sponsorship_cost",
    entityId: created.id,
    metadata: { sponsorshipId, costType, amount },
  });
  revalidateSponsorship(sponsorshipId, s.employeeId);
  return { ok: true, message: "Cost line added." };
}

export async function toggleWaiveCostAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const costId = str(formData.get("costId"));
  const cost = await prisma.sponsorshipCost.findUnique({
    where: { id: costId },
    select: { id: true, waived: true, sponsorshipId: true, sponsorship: { select: { employeeId: true } } },
  });
  if (!cost) return { ok: false, error: "Cost line not found." };
  await prisma.sponsorshipCost.update({ where: { id: costId }, data: { waived: !cost.waived } });
  await writeAudit({
    actorId: me.id,
    action: "sponsorshipcost.waive",
    entityType: "sponsorship_cost",
    entityId: costId,
    metadata: { waived: !cost.waived },
  });
  revalidateSponsorship(cost.sponsorshipId, cost.sponsorship.employeeId);
  return { ok: true, message: cost.waived ? "Cost line reinstated." : "Cost line waived (excluded from exposure)." };
}

export async function deleteCostAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const costId = str(formData.get("costId"));
  const cost = await prisma.sponsorshipCost.findUnique({
    where: { id: costId },
    select: { id: true, sponsorshipId: true, sponsorship: { select: { employeeId: true } } },
  });
  if (!cost) return { ok: false, error: "Cost line not found." };
  await prisma.sponsorshipCost.delete({ where: { id: costId } });
  await writeAudit({ actorId: me.id, action: "sponsorshipcost.delete", entityType: "sponsorship_cost", entityId: costId, metadata: null });
  revalidateSponsorship(cost.sponsorshipId, cost.sponsorship.employeeId);
  return { ok: true, message: "Cost line removed." };
}

// ---------------------------------------------------------------------------
// Exam attempts
// ---------------------------------------------------------------------------
export async function addAttemptAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const sponsorshipId = str(formData.get("sponsorshipId"));
  const s = await loadOpenSponsorship(sponsorshipId);
  if (!s) return { ok: false, error: "Sponsorship not found." };
  if (s.status === "WITHDRAWN") return { ok: false, error: "Cannot add attempts to a withdrawn sponsorship." };

  const levelLabel = str(formData.get("levelLabel"));
  if (!levelLabel) return { ok: false, error: "Enter the level or paper (e.g. Level I)." };
  let outcome = str(formData.get("outcome"));
  if (!ATTEMPT_OUTCOMES.includes(outcome as never)) outcome = "SCHEDULED";

  const created = await prisma.sponsorshipAttempt.create({
    data: {
      sponsorshipId,
      levelLabel,
      attemptNumber: parseInt0(formData.get("attemptNumber")),
      sittingDate: parseDate(formData.get("sittingDate")),
      outcome,
      score: nz(formData.get("score")),
      note: nz(formData.get("note")),
    },
    select: { id: true },
  });
  await writeAudit({
    actorId: me.id,
    action: "sponsorshipattempt.add",
    entityType: "sponsorship_attempt",
    entityId: created.id,
    metadata: { sponsorshipId, levelLabel, outcome },
  });
  revalidateSponsorship(sponsorshipId, s.employeeId);
  return { ok: true, message: "Attempt recorded." };
}

export async function updateAttemptAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const attemptId = str(formData.get("attemptId"));
  const attempt = await prisma.sponsorshipAttempt.findUnique({
    where: { id: attemptId },
    select: { id: true, sponsorshipId: true, sponsorship: { select: { employeeId: true } } },
  });
  if (!attempt) return { ok: false, error: "Attempt not found." };
  let outcome = str(formData.get("outcome"));
  if (!ATTEMPT_OUTCOMES.includes(outcome as never)) outcome = "SCHEDULED";
  await prisma.sponsorshipAttempt.update({
    where: { id: attemptId },
    data: { outcome, score: nz(formData.get("score")) },
  });
  await writeAudit({
    actorId: me.id,
    action: "sponsorshipattempt.update",
    entityType: "sponsorship_attempt",
    entityId: attemptId,
    metadata: { outcome },
  });
  revalidateSponsorship(attempt.sponsorshipId, attempt.sponsorship.employeeId);
  return { ok: true, message: "Attempt updated." };
}

export async function deleteAttemptAction(_prev: FormState, formData: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const attemptId = str(formData.get("attemptId"));
  const attempt = await prisma.sponsorshipAttempt.findUnique({
    where: { id: attemptId },
    select: { id: true, sponsorshipId: true, sponsorship: { select: { employeeId: true } } },
  });
  if (!attempt) return { ok: false, error: "Attempt not found." };
  await prisma.sponsorshipAttempt.delete({ where: { id: attemptId } });
  await writeAudit({ actorId: me.id, action: "sponsorshipattempt.delete", entityType: "sponsorship_attempt", entityId: attemptId, metadata: null });
  revalidateSponsorship(attempt.sponsorshipId, attempt.sponsorship.employeeId);
  return { ok: true, message: "Attempt removed." };
}
