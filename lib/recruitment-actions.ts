"use server";
// Write-side server actions for Recruitment. Every mutation is gated by
// recruitment.manage, validated with zod, and writes an audit_logs row.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { nextRequisitionCode, STAGES, OPENING_STATUSES } from "@/lib/recruitment";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const EMPTY = "" as const;

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

// --- Raise requisition ------------------------------------------------------
const requisitionSchema = z.object({
  title: z.string().trim().min(2, "Job title is required"),
  grade: z.string().trim().optional().or(z.literal(EMPTY)),
  departmentId: z.string().optional().or(z.literal(EMPTY)),
  jobProfileId: z.string().optional().or(z.literal(EMPTY)),
  headcount: z.coerce.number().int().min(1, "At least 1").max(99),
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
    notes: fd.get("notes"),
  });
  if (!parsed.success) {
    const fe: Record<string, string> = {};
    for (const i of parsed.error.issues) fe[String(i.path[0])] = i.message;
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: fe };
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
      notes: nz(parsed.data.notes ?? null),
      status: "OPEN",
    },
    select: { id: true, code: true },
  });
  await writeAudit({
    actorId: me.id,
    action: "jobopening.create",
    entityType: "JobOpening",
    entityId: created.id,
    metadata: { code: created.code, title: parsed.data.title },
  });
  revalidatePath("/recruitment");
  redirect(`/recruitment/${created.id}`);
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
  // Confirm the opening exists (never trust a client id blindly).
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
    select: { id: true },
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

// --- Move candidate stage (+ optional note / interview date) ----------------
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
  // Scope the update to a candidate that actually belongs to this opening.
  const existing = await prisma.candidate.findFirst({
    where: { id: candidateId, openingId },
    select: { id: true },
  });
  if (!existing) return { ok: false, error: "Candidate not found for this requisition." };

  await prisma.candidate.update({
    where: { id: candidateId },
    data: {
      stage,
      stageNote: nz(fd.get("stageNote")),
      interviewAt: parseDateUTC(fd.get("interviewAt")),
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "candidate.set_stage",
    entityType: "Candidate",
    entityId: candidateId,
    metadata: { stage },
  });
  revalidatePath(`/recruitment/${openingId}`);
  revalidatePath("/recruitment");
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

// --- Convert candidate → staff (v0.36.0) ------------------------------------
// Turns an offered/hired candidate into an Employee. Gated by employees.manage
// (it creates a person), not recruitment.manage. In one transaction it creates
// the Employee (PROBATION), the initial current CompensationProfile from the
// offer terms, a HIRE employment-history row, and a minimal onboarding-plan
// shell (S3), then stamps the candidate HIRED + hiredEmployeeId. Payment stays
// with HumanManager/Remita — the comp profile is the standing record the
// control room reads, nothing more.
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
      opening: { select: { title: true, jobProfileId: true, departmentId: true } },
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

  // Capture the narrowed (non-null) offer values — TS widens these back to
  // `Decimal | null` inside the $transaction closure below, so bind them here.
  const offerBasic = cand.offerBasic;
  const offerUtility = cand.offerUtility;
  const offerGrade = cand.offerGrade;

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
