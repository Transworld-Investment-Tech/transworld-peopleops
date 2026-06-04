"use server";
// Write-side server actions for Recruitment. Every mutation is gated, validated
// with zod where it takes a form, and writes an audit_logs row.
//
// v0.39.0 (WS3 depth): the requisition gates (Stage 1 raise carries reason /
// business case / must-haves / control-function + raiser snapshot; Stage 2
// CFO+MD budget approval under requisition.approve, approver != raiser; Stage 3
// role-pack confirmation), the Stage 7 selection decision + CCO sign-off
// (selection.cco, control-function), and the Stage 8 verification checklist
// (gates the move to OFFER). Every candidate stage move now also writes a
// candidate_stage_events row.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  nextRequisitionCode,
  STAGES,
  OPENING_STATUSES,
  REQUISITION_REASONS,
  CHECK_TYPES,
  CHECK_STATUSES,
  defaultChecklistFor,
  checksReady,
} from "@/lib/recruitment";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const EMPTY = "" as const;

function nz(v: FormDataEntryValue | string | null | undefined): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}

function parseDateUTC(v: FormDataEntryValue | string | null | undefined): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(`${s}T00:00:00.000Z`);
  return Number.isNaN(d.getTime()) ? null : d;
}

// --- Raise requisition (Stage 1) -------------------------------------------
const requisitionSchema = z.object({
  title: z.string().trim().min(2, "Job title is required"),
  grade: z.string().trim().optional().or(z.literal(EMPTY)),
  departmentId: z.string().optional().or(z.literal(EMPTY)),
  jobProfileId: z.string().optional().or(z.literal(EMPTY)),
  headcount: z.coerce.number().int().min(1, "At least 1").max(99),
  reason: z.string().trim().optional().or(z.literal(EMPTY)),
  businessCase: z.string().trim().optional().or(z.literal(EMPTY)),
  mustHaves: z.string().trim().optional().or(z.literal(EMPTY)),
  budgetBand: z.string().trim().optional().or(z.literal(EMPTY)),
  isControlFunction: z.string().optional().or(z.literal(EMPTY)),
  notes: z.string().trim().optional().or(z.literal(EMPTY)),
});

export async function raiseRequisitionAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const parsed = requisitionSchema.safeParse({
    title: fd.get("title"),
    grade: fd.get("grade"),
    departmentId: fd.get("departmentId"),
    jobProfileId: fd.get("jobProfileId"),
    headcount: fd.get("headcount") || "1",
    reason: fd.get("reason"),
    businessCase: fd.get("businessCase"),
    mustHaves: fd.get("mustHaves"),
    budgetBand: fd.get("budgetBand"),
    isControlFunction: fd.get("isControlFunction"),
    notes: fd.get("notes"),
  });
  if (!parsed.success) {
    const fe: Record<string, string> = {};
    for (const i of parsed.error.issues) fe[String(i.path[0])] = i.message;
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: fe };
  }
  const reason = nz(parsed.data.reason);
  if (reason !== null && !(REQUISITION_REASONS as readonly string[]).includes(reason)) {
    return { ok: false, error: "Invalid reason." };
  }
  const code = await nextRequisitionCode();
  const created = await prisma.jobOpening.create({
    data: {
      code,
      title: parsed.data.title,
      grade: nz(parsed.data.grade ?? null),
      departmentId: nz(parsed.data.departmentId ?? null),
      jobProfileId: nz(parsed.data.jobProfileId ?? null),
      headcount: parsed.data.headcount,
      reason,
      businessCase: nz(parsed.data.businessCase ?? null),
      mustHaves: nz(parsed.data.mustHaves ?? null),
      budgetBand: nz(parsed.data.budgetBand ?? null),
      isControlFunction: nz(parsed.data.isControlFunction) === "on",
      notes: nz(parsed.data.notes ?? null),
      status: "OPEN",
      raisedById: me.id,
      raisedByName: me.name,
      raisedAt: new Date(),
    },
    select: { id: true, code: true },
  });
  await writeAudit({
    actorId: me.id,
    action: "jobopening.create",
    entityType: "JobOpening",
    entityId: created.id,
    metadata: { code: created.code, title: parsed.data.title, reason },
  });
  revalidatePath("/recruitment");
  redirect(`/recruitment/${created.id}`);
}

// --- Stage 2: budget approval (CFO -> MD) ----------------------------------
export async function recordBudgetApprovalAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("requisition.approve");
  const openingId = String(fd.get("openingId") ?? "");
  const which = String(fd.get("which") ?? "");
  if (!openingId) return { ok: false, error: "Missing requisition." };
  if (which !== "CFO" && which !== "MD") return { ok: false, error: "Invalid approval step." };

  const o = await prisma.jobOpening.findUnique({
    where: { id: openingId },
    select: { id: true, raisedById: true, cfoApprovedAt: true },
  });
  if (!o) return { ok: false, error: "That requisition no longer exists." };
  // No self-approval: the person who raised the requisition cannot approve it.
  if (o.raisedById && o.raisedById === me.id) {
    return { ok: false, error: "You raised this requisition — budget approval needs a different approver." };
  }
  if (which === "MD" && !o.cfoApprovedAt) {
    return { ok: false, error: "Record the CFO affordability approval before the MD approval." };
  }

  const data =
    which === "CFO"
      ? {
          cfoApprovedById: me.id,
          cfoApprovedByName: me.name,
          cfoApprovedAt: new Date(),
          budgetBand: nz(fd.get("budgetBand")) ?? undefined,
        }
      : {
          mdApprovedById: me.id,
          mdApprovedByName: me.name,
          mdApprovedAt: new Date(),
        };

  await prisma.jobOpening.update({ where: { id: openingId }, data });
  await writeAudit({
    actorId: me.id,
    action: "jobopening.budget_approval",
    entityType: "JobOpening",
    entityId: openingId,
    metadata: { which },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Stage 3: confirm role pack --------------------------------------------
export async function confirmRolePackAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const openingId = String(fd.get("openingId") ?? "");
  if (!openingId) return { ok: false, error: "Missing requisition." };
  const o = await prisma.jobOpening.findUnique({
    where: { id: openingId },
    select: { id: true, cfoApprovedAt: true, mdApprovedAt: true },
  });
  if (!o) return { ok: false, error: "That requisition no longer exists." };
  if (!o.cfoApprovedAt || !o.mdApprovedAt) {
    return { ok: false, error: "Budget approval (CFO and MD) must be recorded first." };
  }
  await prisma.jobOpening.update({
    where: { id: openingId },
    data: {
      rolePackConfirmedById: me.id,
      rolePackConfirmedByName: me.name,
      rolePackConfirmedAt: new Date(),
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "jobopening.role_pack_confirmed",
    entityType: "JobOpening",
    entityId: openingId,
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Set requisition status -------------------------------------------------
export async function setRequisitionStatusAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const openingId = String(fd.get("openingId") ?? "");
  const status = String(fd.get("status") ?? "");
  if (!openingId) return { ok: false, error: "Missing requisition." };
  if (!(OPENING_STATUSES as readonly string[]).includes(status)) {
    return { ok: false, error: "Invalid status." };
  }
  const closing = status === "CLOSED" || status === "FILLED";
  await prisma.jobOpening.update({
    where: { id: openingId },
    data: { status, closedAt: closing ? new Date() : null },
  });
  await writeAudit({
    actorId: me.id,
    action: "jobopening.set_status",
    entityType: "JobOpening",
    entityId: openingId,
    metadata: { status },
  });
  revalidatePath("/recruitment");
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Add candidate ----------------------------------------------------------
const candidateSchema = z.object({
  openingId: z.string().min(1),
  fullName: z.string().trim().min(2, "Candidate name is required"),
  email: z.string().trim().email("Enter a valid email").optional().or(z.literal(EMPTY)),
  phone: z.string().trim().optional().or(z.literal(EMPTY)),
  source: z.string().trim().optional().or(z.literal(EMPTY)),
  stage: z.enum(STAGES),
  stageNote: z.string().trim().optional().or(z.literal(EMPTY)),
});

export async function addCandidateAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const parsed = candidateSchema.safeParse({
    openingId: fd.get("openingId"),
    fullName: fd.get("fullName"),
    email: fd.get("email"),
    phone: fd.get("phone"),
    source: fd.get("source"),
    stage: fd.get("stage") || "SOURCED",
    stageNote: fd.get("stageNote"),
  });
  if (!parsed.success) {
    const fe: Record<string, string> = {};
    for (const i of parsed.error.issues) fe[String(i.path[0])] = i.message;
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: fe };
  }
  const opening = await prisma.jobOpening.findUnique({
    where: { id: parsed.data.openingId },
    select: { id: true },
  });
  if (!opening) return { ok: false, error: "That requisition no longer exists." };

  const created = await prisma.candidate.create({
    data: {
      openingId: parsed.data.openingId,
      fullName: parsed.data.fullName,
      email: nz(parsed.data.email ?? null),
      phone: nz(parsed.data.phone ?? null),
      source: nz(parsed.data.source ?? null),
      stage: parsed.data.stage,
      stageNote: nz(parsed.data.stageNote ?? null),
    },
    select: { id: true, fullName: true, stage: true },
  });
  await prisma.candidateStageEvent.create({
    data: {
      candidateId: created.id,
      candidateName: created.fullName,
      stage: created.stage,
      clearedById: me.id,
      clearedByName: me.name,
      note: "Added to pipeline",
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "candidate.create",
    entityType: "Candidate",
    entityId: created.id,
    metadata: { openingId: parsed.data.openingId, stage: parsed.data.stage },
  });
  revalidatePath(`/recruitment/${parsed.data.openingId}`);
  return { ok: true };
}

// --- Move candidate stage (+ stage-event trail; gates the move to OFFER) ----
export async function setCandidateStageAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  const stage = String(fd.get("stage") ?? "");
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };
  if (!(STAGES as readonly string[]).includes(stage)) {
    return { ok: false, error: "Invalid stage." };
  }
  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: {
      id: true,
      fullName: true,
      stage: true,
      ccoSignoffAt: true,
      opening: { select: { grade: true, isControlFunction: true } },
    },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };

  // Gate the move to OFFER: every applicable Stage-8 check must be cleared or
  // waived, and control-function roles need the CCO sign-off first.
  if (stage === "OFFER") {
    const checks = await prisma.candidateCheck.findMany({
      where: { candidateId },
      select: { applicable: true, status: true },
    });
    if (!checksReady(checks)) {
      return {
        ok: false,
        error: "Clear (or waive) every applicable pre-employment check before extending the offer.",
      };
    }
    if (existing.opening.isControlFunction && !existing.ccoSignoffAt) {
      return { ok: false, error: "This is a control-function role — the CCO must sign off the selection first." };
    }
  }

  // Seed the default Stage-8 checklist the first time a candidate enters CHECKS.
  if (stage === "CHECKS") {
    const count = await prisma.candidateCheck.count({ where: { candidateId } });
    if (count === 0) {
      const facts = {
        isRegulated: existing.opening.isControlFunction,
        grade: existing.opening.grade,
      };
      await prisma.candidateCheck.createMany({
        data: defaultChecklistFor(facts).map((c) => ({
          candidateId,
          candidateName: existing.fullName,
          checkType: c.checkType,
          applicable: c.applicable,
          status: "PENDING",
        })),
      });
    }
  }

  const note = nz(fd.get("stageNote"));
  await prisma.candidate.update({
    where: { id: candidateId },
    data: {
      stage,
      stageNote: note,
      interviewAt: parseDateUTC(fd.get("interviewAt")),
    },
  });
  if (stage !== existing.stage) {
    await prisma.candidateStageEvent.create({
      data: {
        candidateId,
        candidateName: existing.fullName,
        stage,
        clearedById: me.id,
        clearedByName: me.name,
        note,
      },
    });
  }
  await writeAudit({
    actorId: me.id,
    action: "candidate.set_stage",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { from: existing.stage, to: stage },
  });
  revalidatePath(`/recruitment/${openingId}`);
  revalidatePath("/recruitment");
  return { ok: true };
}

// --- Stage 7: selection decision -------------------------------------------
export async function recordSelectionAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  const rationale = nz(fd.get("selectionRationale"));
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };
  if (!rationale) return { ok: false, error: "Record the selection rationale." };

  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true, fullName: true },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };

  await prisma.candidate.update({
    where: { id: candidateId },
    data: {
      stage: "SELECTED",
      selectionRationale: rationale,
      selectedById: me.id,
      selectedByName: me.name,
      selectedAt: new Date(),
    },
  });
  await prisma.candidateStageEvent.create({
    data: {
      candidateId,
      candidateName: existing.fullName,
      stage: "SELECTED",
      clearedById: me.id,
      clearedByName: me.name,
      note: "Selection decision recorded",
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "candidate.select",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { openingId },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Stage 7/8: CCO sign-off for control-function roles --------------------
export async function recordCcoSignoffAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("selection.cco");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };

  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true, fullName: true, selectedAt: true, selectedById: true },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };
  if (!existing.selectedAt) {
    return { ok: false, error: "Record the selection decision before the CCO sign-off." };
  }
  if (existing.selectedById && existing.selectedById === me.id) {
    return { ok: false, error: "The CCO sign-off must be independent of the person who made the selection." };
  }

  await prisma.candidate.update({
    where: { id: candidateId },
    data: { ccoSignoffById: me.id, ccoSignoffByName: me.name, ccoSignoffAt: new Date() },
  });
  await prisma.candidateStageEvent.create({
    data: {
      candidateId,
      candidateName: existing.fullName,
      stage: "SELECTED",
      clearedById: me.id,
      clearedByName: me.name,
      note: "CCO independent sign-off (control-function role)",
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "candidate.cco_signoff",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { openingId },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Stage 8: seed / update verification checks ----------------------------
export async function seedCandidateChecksAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };
  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true, fullName: true, opening: { select: { grade: true, isControlFunction: true } } },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };
  const present = await prisma.candidateCheck.findMany({
    where: { candidateId },
    select: { checkType: true },
  });
  const have = new Set(present.map((p) => p.checkType));
  const toAdd = defaultChecklistFor({
    isRegulated: existing.opening.isControlFunction,
    grade: existing.opening.grade,
  }).filter((c) => !have.has(c.checkType));
  if (toAdd.length) {
    await prisma.candidateCheck.createMany({
      data: toAdd.map((c) => ({
        candidateId,
        candidateName: existing.fullName,
        checkType: c.checkType,
        applicable: c.applicable,
        status: "PENDING",
      })),
    });
  }
  await writeAudit({
    actorId: me.id,
    action: "candidate.seed_checks",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { added: toAdd.length },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

export async function setCandidateCheckAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  const checkType = String(fd.get("checkType") ?? "");
  const status = String(fd.get("status") ?? "PENDING");
  const applicable = nz(fd.get("applicable")) === "on" || nz(fd.get("applicable")) === "true";
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };
  if (!(CHECK_TYPES as readonly string[]).includes(checkType)) {
    return { ok: false, error: "Invalid check." };
  }
  if (!(CHECK_STATUSES as readonly string[]).includes(status)) {
    return { ok: false, error: "Invalid status." };
  }
  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true, fullName: true },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };

  const cleared = status === "CLEARED" || status === "WAIVED";
  const row = await prisma.candidateCheck.findFirst({
    where: { candidateId, checkType },
    select: { id: true },
  });
  const payload = {
    applicable,
    status,
    note: nz(fd.get("note")),
    evidenceDocId: nz(fd.get("evidenceDocId")),
    clearedAt: cleared ? new Date() : null,
    clearedById: cleared ? me.id : null,
    clearedByName: cleared ? me.name : null,
    updatedAt: new Date(),
  };
  if (row) {
    await prisma.candidateCheck.update({ where: { id: row.id }, data: payload });
  } else {
    await prisma.candidateCheck.create({
      data: { candidateId, candidateName: existing.fullName, checkType, ...payload },
    });
  }
  await writeAudit({
    actorId: me.id,
    action: "candidate.set_check",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { checkType, status, applicable },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

const OFFER_GRADES = ["G0", "G1", "G2", "G3", "G4", "G5", "PT"] as const;

/** People Ops enters the offer terms (grade + pay + dates) on a candidate. These persist
 * on the candidate and feed the offer-letter merge context (gross / quarterly / 13th /
 * fully-loaded are computed live from basic + utility). Grade is set here, never inferred. */
export async function setCandidateOfferTermsAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("recruitment.manage");
  const candidateId = String(fd.get("candidateId") ?? "");
  const openingId = String(fd.get("openingId") ?? "");
  if (!candidateId || !openingId) return { ok: false, error: "Missing candidate." };

  const money = (v: FormDataEntryValue | null): number | null => {
    const s = String(v ?? "").replace(/[\u20a6,\s]/g, "");
    if (s === "") return null;
    const n = Number(s);
    return Number.isFinite(n) && n >= 0 ? n : null;
  };
  const grade = nz(fd.get("offerGrade"));
  if (grade !== null && !(OFFER_GRADES as readonly string[]).includes(grade)) {
    return { ok: false, error: "Invalid grade." };
  }
  const basic = money(fd.get("offerBasic"));
  const utility = money(fd.get("offerUtility"));

  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };

  await prisma.candidate.update({
    where: { id: candidateId },
    data: {
      offerGrade: grade,
      offerBasic: basic,
      offerUtility: utility,
      offerStartDate: parseDateUTC(fd.get("offerStartDate")),
      offerAcceptanceDeadline: parseDateUTC(fd.get("offerAcceptanceDeadline")),
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "candidate.set_offer_terms",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { grade, basic, utility },
  });
  revalidatePath(`/recruitment/${openingId}`);
  return { ok: true };
}

// --- Convert candidate → staff (v0.36.0; Stage 10) --------------------------
// Turns an offered/hired candidate into an Employee. Gated by employees.manage
// (it creates a person), not recruitment.manage. In one transaction it creates
// the Employee (PROBATION), the initial current CompensationProfile from the
// offer terms, a HIRE employment-history row, and a minimal onboarding-plan
// shell, then stamps the candidate HIRED + hiredEmployeeId. Payment stays with
// HumanManager/Remita — the comp profile is the standing record only.
const convertSchema = z.object({
  candidateId: z.string().min(1),
  openingId: z.string().min(1),
  eeId: z.string().trim().min(1, "Employee ID is required"),
  startDate: z.string().trim().optional().or(z.literal(EMPTY)),
});

export async function convertCandidateToStaffAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("employees.manage");
  const parsed = convertSchema.safeParse({
    candidateId: fd.get("candidateId"),
    openingId: fd.get("openingId"),
    eeId: fd.get("eeId"),
    startDate: fd.get("startDate"),
  });
  if (!parsed.success) {
    const fe: Record<string, string> = {};
    for (const i of parsed.error.issues) fe[String(i.path[0])] = i.message;
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: fe };
  }
  const { candidateId, openingId, eeId } = parsed.data;

  const cand = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: {
      id: true,
      fullName: true,
      email: true,
      phone: true,
      stage: true,
      hiredEmployeeId: true,
      offerGrade: true,
      offerBasic: true,
      offerUtility: true,
      offerStartDate: true,
      opening: { select: { title: true, jobProfileId: true, departmentId: true, isControlFunction: true } },
    },
  });
  if (!cand) return { ok: false, error: "Candidate not found for this requisition." };
  if (cand.hiredEmployeeId) return { ok: false, error: "This candidate has already been converted to staff." };
  if (cand.stage !== "OFFER" && cand.stage !== "HIRED") {
    return { ok: false, error: "Move the candidate to the Offer stage before converting." };
  }
  if (cand.offerBasic === null || cand.offerUtility === null || !cand.offerGrade) {
    return { ok: false, error: "Set the offer terms (grade, basic and utility) before converting." };
  }

  const offerBasic = cand.offerBasic;
  const offerUtility = cand.offerUtility;
  const offerGrade = cand.offerGrade;
  const isControlFn = cand.opening.isControlFunction;

  const trimmedEe = eeId.trim();
  const dupe = await prisma.employee.findUnique({ where: { eeId: trimmedEe }, select: { id: true } });
  if (dupe) return { ok: false, fieldErrors: { eeId: "That Employee ID already exists." } };

  const start = parseDateUTC(fd.get("startDate")) ?? cand.offerStartDate ?? new Date();

  const created = await prisma.$transaction(async (tx) => {
    const emp = await tx.employee.create({
      data: {
        eeId: trimmedEe,
        fullName: cand.fullName,
        grade: offerGrade,
        jobProfileId: cand.opening.jobProfileId ?? null,
        departmentId: cand.opening.departmentId ?? null,
        personalEmail: cand.email ?? null,
        personalPhone: cand.phone ?? null,
        employmentType: "FULL_TIME",
        status: "PROBATION",
        startDate: start,
        isRegulatedRole: isControlFn,
      },
    });
    await tx.compensationProfile.create({
      data: {
        employeeId: emp.id,
        effectiveDate: start,
        basicSalary: offerBasic,
        utilityAllowance: offerUtility,
        quarterlyAllowance: 0,
        taxTreatment: "PAYE",
        pensionApplicable: true,
        nhfApplicable: true,
        isCurrent: true,
      },
    });
    await tx.employmentRecord.create({
      data: {
        employeeId: emp.id,
        eventType: "HIRE",
        title: cand.opening.title ?? null,
        grade: offerGrade,
        jobProfileId: cand.opening.jobProfileId ?? null,
        departmentId: cand.opening.departmentId ?? null,
        status: "PROBATION",
        effectiveDate: start,
        note: `Hired from the candidate pipeline (${cand.fullName}).`,
      },
    });
    await tx.onboardingPlan.create({
      data: { employeeId: emp.id, startDate: start, probationMonths: 3, status: "IN_PROGRESS" },
    });
    await tx.candidate.update({
      where: { id: cand.id },
      data: { stage: "HIRED", hiredEmployeeId: emp.id },
    });
    return emp;
  });

  await writeAudit({
    actorId: me.id,
    action: "candidate.convert_to_staff",
    entityType: "Employee",
    entityId: created.id,
    metadata: { eeId: created.eeId, candidateId: cand.id, openingId, grade: offerGrade },
  });

  revalidatePath(`/recruitment/${openingId}`);
  revalidatePath("/recruitment");
  revalidatePath("/employees");
  redirect(`/employees/${created.id}`);
}
