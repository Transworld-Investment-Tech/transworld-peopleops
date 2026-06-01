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
