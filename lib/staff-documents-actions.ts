"use server";
// Write-side server actions for the Staff & Hire Document Layer. Every action is
// RBAC-gated and audited; file bytes are uploaded with the service-role key here
// (never reaches the browser). Self-service actions are self-scoped: a staff
// member may only sign/upload against their OWN linked employee record, and only
// in personal categories. Never trusts a client-supplied subject id beyond the
// scoping checks below.
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { headers } from "next/headers";
import { z } from "zod";
import { prisma } from "@/lib/db";
import { requirePermission, requireUser, isSuperAdmin } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { putObject, removeObject, signedUrl, storageConfigured } from "@/lib/storage";
import {
  renderTemplate,
  documentShell,
  signatureBlockHtml,
  kindLabel,
} from "@/lib/document-templates";
import {
  buildEmployeeMergeContext,
  buildCandidateMergeContext,
  STAFF_UPLOADABLE_CATEGORIES,
  categoryByKey,
} from "@/lib/staff-documents";

export type FormState = { ok: boolean; error?: string; message?: string };
const OK = (message?: string): FormState => ({ ok: true, message });

const ALLOWED_UPLOAD = new Set([
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "image/jpeg",
  "image/png",
]);
const MAX_BYTES = 10 * 1024 * 1024; // 10 MB
const HTML_TYPE = "text/html; charset=utf-8";

function sanitize(name: string): string {
  return name.replace(/[^\w.\-]+/g, "_").slice(0, 120) || "file";
}
function slug(s: string): string {
  return (s || "document").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "").slice(0, 60) || "document";
}

const KIND_TO_CATEGORY: Record<string, string> = {
  OFFER_LETTER: "Offer letter",
  EMPLOYMENT_CONTRACT: "Signed contract",
  GUARANTOR_FORM: "Guarantor / reference",
  NEXT_OF_KIN: "Next of kin",
  OTHER: "Other HR document",
};

async function clientIp(): Promise<string | null> {
  try {
    const h = await headers();
    return h.get("x-forwarded-for")?.split(",")[0]?.trim() || h.get("x-real-ip") || null;
  } catch {
    return null;
  }
}

/** The employee linked to the signed-in user, or null. */
async function myEmployee(userId: string) {
  return prisma.employee.findUnique({
    where: { userId },
    select: { id: true, fullName: true, preferredName: true },
  });
}

// ===========================================================================
// HR: generate a document from a template
// ===========================================================================
export async function generateDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  if (!storageConfigured()) return { ok: false, error: "File storage isn't configured yet." };

  const templateId = String(fd.get("templateId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "") || null;
  const candidateId = String(fd.get("candidateId") ?? "") || null;
  if (!templateId) return { ok: false, error: "Choose a template." };
  if (!employeeId && !candidateId) return { ok: false, error: "Missing subject." };

  const template = await prisma.documentTemplate.findUnique({ where: { id: templateId } });
  if (!template || !template.isActive) return { ok: false, error: "Template not found or inactive." };

  const ctx = employeeId
    ? await buildEmployeeMergeContext(employeeId)
    : await buildCandidateMergeContext(candidateId!);
  if (!ctx) return { ok: false, error: "Could not load the person's record." };

  const category = KIND_TO_CATEGORY[template.kind] ?? "Other HR document";
  const bodySnapshot = renderTemplate(template.bodyHtml, ctx);
  const title = `${kindLabel(template.kind)} — ${ctx.full_name}`;

  // For staff who must sign in-portal, mark awaiting signature; otherwise a draft
  // HR can download, print, sign offline, and upload the signed copy.
  const requiresSignature = template.requiresSignature && !!employeeId;
  const status = requiresSignature ? "AWAITING_SIGNATURE" : "DRAFT";

  const doc = await prisma.staffDocument.create({
    data: {
      employeeId,
      candidateId,
      templateId: template.id,
      category,
      kind: template.kind,
      title,
      source: "GENERATED",
      status,
      bodyHtml: bodySnapshot,
      requiresSignature,
      accessLevel: "HR",
      uploadedById: me.id,
    },
  });

  const html = documentShell({
    title,
    bodyHtml: bodySnapshot,
    entityName: ctx.entity,
    reference: doc.id.slice(-8).toUpperCase(),
    watermark: requiresSignature ? "UNSIGNED" : "DRAFT",
  });
  const path = `staff-documents/${doc.id}/v1_${slug(title)}.html`;
  await putObject(path, Buffer.from(html, "utf8"), HTML_TYPE);

  await prisma.staffDocument.update({
    where: { id: doc.id },
    data: { fileKey: path, contentType: HTML_TYPE, sizeBytes: Buffer.byteLength(html, "utf8") },
  });

  await writeAudit({
    actorId: me.id,
    action: "stafdoc.generate",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { kind: template.kind, employeeId, candidateId, status },
  });

  if (employeeId) {
    revalidatePath(`/employees/${employeeId}`);
    revalidatePath(`/onboarding/${employeeId}`);
  }
  if (candidateId) {
    const c = await prisma.candidate.findUnique({ where: { id: candidateId }, select: { openingId: true } });
    if (c) revalidatePath(`/recruitment/${c.openingId}`);
  }
  return OK(
    requiresSignature
      ? "Generated and sent to the staff member to sign."
      : "Generated. Download to review, or print and upload the signed copy."
  );
}

// ===========================================================================
// HR: upload a file against a staff member or candidate
// ===========================================================================
async function storeUpload(opts: {
  actorId: string;
  employeeId: string | null;
  candidateId: string | null;
  category: string;
  expiry: Date | null;
  accessLevel: string;
  status: string;
  action: string;
  fd: FormData;
}): Promise<FormState> {
  const entry = opts.fd.get("file");
  if (!entry || typeof entry === "string") return { ok: false, error: "Choose a file to upload." };
  const file = entry as File;
  if (file.size === 0) return { ok: false, error: "Choose a file to upload." };
  if (!ALLOWED_UPLOAD.has(file.type))
    return { ok: false, error: "Allowed types: PDF, Word, JPG, or PNG." };
  if (file.size > MAX_BYTES) return { ok: false, error: "File exceeds the 10 MB limit." };

  const bytes = Buffer.from(await file.arrayBuffer());
  const doc = await prisma.staffDocument.create({
    data: {
      employeeId: opts.employeeId,
      candidateId: opts.candidateId,
      category: opts.category,
      title: file.name,
      source: "UPLOADED",
      status: opts.status,
      accessLevel: opts.accessLevel,
      expiryDate: opts.expiry,
      contentType: file.type,
      sizeBytes: file.size,
      uploadedById: opts.actorId,
    },
  });
  const path = `staff-documents/${doc.id}/v1_${sanitize(file.name)}`;
  await putObject(path, bytes, file.type);
  await prisma.staffDocument.update({ where: { id: doc.id }, data: { fileKey: path } });

  await writeAudit({
    actorId: opts.actorId,
    action: opts.action,
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { category: opts.category, filename: file.name, size: file.size },
  });
  return OK("Uploaded.");
}

function parseExpiry(v: FormDataEntryValue | null): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}

export async function uploadDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  if (!storageConfigured()) return { ok: false, error: "File storage isn't configured yet." };

  const employeeId = String(fd.get("employeeId") ?? "") || null;
  const candidateId = String(fd.get("candidateId") ?? "") || null;
  const category = String(fd.get("category") ?? "").trim();
  if (!employeeId && !candidateId) return { ok: false, error: "Missing subject." };
  if (!category) return { ok: false, error: "Choose a category." };
  if (!categoryByKey(category)) return { ok: false, error: "Unknown category." };

  const res = await storeUpload({
    actorId: me.id,
    employeeId,
    candidateId,
    category,
    expiry: parseExpiry(fd.get("expiry")),
    accessLevel: "HR",
    status: "UPLOADED",
    action: "stafdoc.upload",
    fd,
  });
  if (res.ok) {
    if (employeeId) revalidatePath(`/employees/${employeeId}`);
    if (candidateId) {
      const c = await prisma.candidate.findUnique({ where: { id: candidateId }, select: { openingId: true } });
      if (c) revalidatePath(`/recruitment/${c.openingId}`);
    }
  }
  return res;
}

// ===========================================================================
// HR: upload an externally-signed copy onto an existing generated document
// ===========================================================================
export async function uploadSignedCopyAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  if (!storageConfigured()) return { ok: false, error: "File storage isn't configured yet." };
  const docId = String(fd.get("docId") ?? "");
  const doc = docId ? await prisma.staffDocument.findUnique({ where: { id: docId } }) : null;
  if (!doc) return { ok: false, error: "Document not found." };

  const entry = fd.get("file");
  if (!entry || typeof entry === "string") return { ok: false, error: "Choose the signed file." };
  const file = entry as File;
  if (file.size === 0) return { ok: false, error: "Choose the signed file." };
  if (!ALLOWED_UPLOAD.has(file.type)) return { ok: false, error: "Allowed types: PDF, Word, JPG, or PNG." };
  if (file.size > MAX_BYTES) return { ok: false, error: "File exceeds the 10 MB limit." };

  const bytes = Buffer.from(await file.arrayBuffer());
  const path = `staff-documents/${doc.id}/signed_${Date.now()}_${sanitize(file.name)}`;
  await putObject(path, bytes, file.type);
  if (doc.fileKey) {
    try {
      await removeObject(doc.fileKey);
    } catch {
      /* ignore cleanup failure */
    }
  }
  await prisma.staffDocument.update({
    where: { id: doc.id },
    data: {
      fileKey: path,
      contentType: file.type,
      sizeBytes: file.size,
      status: "SIGNED",
      signedAt: new Date(),
      signerName: doc.signerName ?? "Uploaded signed copy",
      title: file.name,
      version: { increment: 1 },
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "stafdoc.upload_signed",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { filename: file.name },
  });
  if (doc.employeeId) revalidatePath(`/employees/${doc.employeeId}`);
  return OK("Signed copy stored.");
}

// ===========================================================================
// HR: void (soft-delete) a document
// ===========================================================================
export async function voidDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  const docId = String(fd.get("docId") ?? "");
  const doc = docId ? await prisma.staffDocument.findUnique({ where: { id: docId } }) : null;
  if (!doc) return { ok: false, error: "Document not found." };
  if (doc.fileKey && storageConfigured()) {
    try {
      await removeObject(doc.fileKey);
    } catch {
      /* ignore */
    }
  }
  await prisma.staffDocument.update({ where: { id: doc.id }, data: { status: "VOID", fileKey: null } });
  await writeAudit({
    actorId: me.id,
    action: "stafdoc.void",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { category: doc.category },
  });
  if (doc.employeeId) revalidatePath(`/employees/${doc.employeeId}`);
  if (doc.candidateId) {
    const c = await prisma.candidate.findUnique({ where: { id: doc.candidateId }, select: { openingId: true } });
    if (c) revalidatePath(`/recruitment/${c.openingId}`);
  }
  revalidatePath("/my-documents");
  return OK("Removed.");
}

// ===========================================================================
// Staff self-service: upload my own personal document
// ===========================================================================
export async function uploadOwnDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.view_own");
  if (!storageConfigured()) return { ok: false, error: "File storage isn't configured yet." };
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };

  const category = String(fd.get("category") ?? "").trim();
  if (!STAFF_UPLOADABLE_CATEGORIES.includes(category)) {
    return { ok: false, error: "You can only upload your own personal documents." };
  }
  const res = await storeUpload({
    actorId: me.id,
    employeeId: emp.id,
    candidateId: null,
    category,
    expiry: parseExpiry(fd.get("expiry")),
    accessLevel: "HR",
    status: "PENDING_APPROVAL",
    action: "stafdoc.upload_own",
    fd,
  });
  if (res.ok) {
    revalidatePath("/my-documents");
    revalidatePath(`/employees/${emp.id}`);
  }
  return res;
}

// ===========================================================================
// Staff self-service: sign a document assigned to me
// ===========================================================================
const signSchema = z.object({
  docId: z.string().min(1),
  signerName: z.string().trim().min(2, "Type your full name to sign."),
  consent: z.literal("on", { errorMap: () => ({ message: "Tick the box to confirm." }) }),
});

export async function signDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.view_own");
  if (!storageConfigured()) return { ok: false, error: "File storage isn't configured yet." };
  const emp = await myEmployee(me.id);
  if (!emp) return { ok: false, error: "Your login isn't linked to an employee record yet." };

  const parsed = signSchema.safeParse({
    docId: String(fd.get("docId") ?? ""),
    signerName: String(fd.get("signerName") ?? ""),
    consent: String(fd.get("consent") ?? ""),
  });
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0]?.message ?? "Check the form." };

  const doc = await prisma.staffDocument.findUnique({ where: { id: parsed.data.docId } });
  if (!doc) return { ok: false, error: "Document not found." };
  if (doc.employeeId !== emp.id) return { ok: false, error: "This document isn't assigned to you." };
  if (doc.status !== "AWAITING_SIGNATURE") return { ok: false, error: "This document is not awaiting your signature." };

  const sigData = String(fd.get("signatureData") ?? "");
  const signatureImg = /^data:image\/png;base64,/.test(sigData) && sigData.length < 400_000 ? sigData : null;
  const when = new Date();
  const signedAtLabel = when.toLocaleString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });

  const body =
    (doc.bodyHtml ?? "") +
    signatureBlockHtml({ signerName: parsed.data.signerName, signedAtLabel, signatureImg });
  const html = documentShell({
    title: doc.title,
    bodyHtml: body,
    reference: doc.id.slice(-8).toUpperCase(),
  });
  const path = `staff-documents/${doc.id}/v${doc.version + 1}_signed.html`;
  await putObject(path, Buffer.from(html, "utf8"), HTML_TYPE);
  if (doc.fileKey) {
    try {
      await removeObject(doc.fileKey);
    } catch {
      /* ignore */
    }
  }

  await prisma.staffDocument.update({
    where: { id: doc.id },
    data: {
      status: "SIGNED",
      fileKey: path,
      contentType: HTML_TYPE,
      sizeBytes: Buffer.byteLength(html, "utf8"),
      signedAt: when,
      signedById: me.id,
      signerName: parsed.data.signerName,
      signerIp: await clientIp(),
      version: { increment: 1 },
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "stafdoc.sign",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { signerName: parsed.data.signerName, employeeId: emp.id },
  });
  revalidatePath("/my-documents");
  revalidatePath(`/employees/${emp.id}`);
  return OK("Signed. Thank you.");
}

// ===========================================================================
// HR: template authoring
// ===========================================================================
const templateSchema = z.object({
  name: z.string().trim().min(2, "Give the template a name."),
  kind: z.enum(["OFFER_LETTER", "EMPLOYMENT_CONTRACT", "GUARANTOR_FORM", "NEXT_OF_KIN", "OTHER"]),
  bodyHtml: z.string().trim().min(10, "The template body looks empty."),
  requiresSignature: z.boolean(),
  isActive: z.boolean(),
});

function uniqueKey(name: string): string {
  return `${slug(name)}-${Date.now().toString(36)}`;
}

export async function createTemplateAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  const parsed = templateSchema.safeParse({
    name: String(fd.get("name") ?? ""),
    kind: String(fd.get("kind") ?? "OTHER"),
    bodyHtml: String(fd.get("bodyHtml") ?? ""),
    requiresSignature: fd.get("requiresSignature") === "on",
    isActive: fd.get("isActive") === "on",
  });
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0]?.message ?? "Check the form." };

  const t = await prisma.documentTemplate.create({
    data: {
      key: uniqueKey(parsed.data.name),
      name: parsed.data.name,
      kind: parsed.data.kind,
      bodyHtml: parsed.data.bodyHtml,
      requiresSignature: parsed.data.requiresSignature,
      isActive: parsed.data.isActive,
      createdById: me.id,
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "doctemplate.create",
    entityType: "document_template",
    entityId: t.id,
    metadata: { name: t.name, kind: t.kind },
  });
  revalidatePath("/admin/templates");
  redirect("/admin/templates");
}

export async function updateTemplateAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  const id = String(fd.get("id") ?? "");
  const existing = id ? await prisma.documentTemplate.findUnique({ where: { id } }) : null;
  if (!existing) return { ok: false, error: "Template not found." };

  const parsed = templateSchema.safeParse({
    name: String(fd.get("name") ?? ""),
    kind: String(fd.get("kind") ?? "OTHER"),
    bodyHtml: String(fd.get("bodyHtml") ?? ""),
    requiresSignature: fd.get("requiresSignature") === "on",
    isActive: fd.get("isActive") === "on",
  });
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0]?.message ?? "Check the form." };

  await prisma.documentTemplate.update({
    where: { id },
    data: {
      name: parsed.data.name,
      kind: parsed.data.kind,
      bodyHtml: parsed.data.bodyHtml,
      requiresSignature: parsed.data.requiresSignature,
      isActive: parsed.data.isActive,
      version: { increment: 1 },
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "doctemplate.update",
    entityType: "document_template",
    entityId: id,
    metadata: { name: parsed.data.name },
  });
  revalidatePath("/admin/templates");
  redirect("/admin/templates");
}

// ===========================================================================
// HR: approve / reject a staff self-uploaded document (v0.70.0)
// A staff upload lands as PENDING_APPROVAL and does NOT count as on file until
// HR approves it: approving promotes it to UPLOADED, rejecting voids it.
// ===========================================================================
export async function approveDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  const docId = String(fd.get("docId") ?? "");
  const doc = docId ? await prisma.staffDocument.findUnique({ where: { id: docId } }) : null;
  if (!doc) return { ok: false, error: "Document not found." };
  if (doc.status !== "PENDING_APPROVAL") return { ok: false, error: "This document is not awaiting approval." };
  await prisma.staffDocument.update({ where: { id: doc.id }, data: { status: "UPLOADED" } });
  await writeAudit({
    actorId: me.id,
    action: "stafdoc.approve",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { category: doc.category },
  });
  if (doc.employeeId) revalidatePath(`/employees/${doc.employeeId}`);
  revalidatePath("/my-documents");
  return OK("Approved.");
}

export async function rejectDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("documents.manage");
  const docId = String(fd.get("docId") ?? "");
  const doc = docId ? await prisma.staffDocument.findUnique({ where: { id: docId } }) : null;
  if (!doc) return { ok: false, error: "Document not found." };
  if (doc.status !== "PENDING_APPROVAL") return { ok: false, error: "This document is not awaiting approval." };
  if (doc.fileKey && storageConfigured()) {
    try {
      await removeObject(doc.fileKey);
    } catch {
      /* ignore */
    }
  }
  await prisma.staffDocument.update({ where: { id: doc.id }, data: { status: "VOID", fileKey: null } });
  await writeAudit({
    actorId: me.id,
    action: "stafdoc.reject",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { category: doc.category },
  });
  if (doc.employeeId) revalidatePath(`/employees/${doc.employeeId}`);
  revalidatePath("/my-documents");
  return OK("Rejected.");
}

// ===========================================================================
// Super-Admin: permanently delete a document (HARD delete — row + file).
// For cleanup of test artefacts. Distinct from HR void (soft-delete to VOID).
// ===========================================================================
export async function deleteDocumentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireUser();
  if (!isSuperAdmin(me)) redirect("/access-denied");
  const docId = String(fd.get("docId") ?? "");
  const doc = docId ? await prisma.staffDocument.findUnique({ where: { id: docId } }) : null;
  if (!doc) return { ok: false, error: "Document not found." };
  if (doc.fileKey && storageConfigured()) {
    try {
      await removeObject(doc.fileKey);
    } catch {
      /* ignore */
    }
  }
  await prisma.staffDocument.delete({ where: { id: doc.id } });
  await writeAudit({
    actorId: me.id,
    action: "stafdoc.delete",
    entityType: "staff_document",
    entityId: doc.id,
    metadata: { category: doc.category, title: doc.title, hard: true },
  });
  if (doc.employeeId) revalidatePath(`/employees/${doc.employeeId}`);
  if (doc.candidateId) {
    const c = await prisma.candidate.findUnique({ where: { id: doc.candidateId }, select: { openingId: true } });
    if (c) revalidatePath(`/recruitment/${c.openingId}`);
  }
  revalidatePath("/my-documents");
  return OK("Deleted permanently.");
}
