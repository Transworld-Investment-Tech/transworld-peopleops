"use server";
// Write-side server actions for Learning & Development. Every action is gated,
// zod-validated where it takes structured input, transactional where it touches
// more than one row, and audited. Mirrors the conventions of the other module
// actions (scorecards / performance / compensation).
//
// Permission model:
//   learning.manage    — author/publish modules, attach material, edit handbook,
//                        record completions/waivers for anyone, delete records.
//   learning.recommend — recommend modules to an employee (incl. off an appraisal).
//   learning.view      — self-serve: enroll yourself, mark your own record
//                        started/complete, acknowledge the handbook.
//
// v1 reality: staff logins are not yet provisioned (employee.userId is unlinked),
// so in practice a learning.manage holder operates the self-serve actions on
// behalf of staff. The actions are written staff-ready for when logins arrive.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requireUser, requirePermission, hasPermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  putObject,
  removeObject,
  storageConfigured,
  STORAGE_BUCKET,
} from "@/lib/storage";
import { LEARNING_CATEGORIES, LEARNING_MATERIAL, HANDBOOK_CATEGORY } from "@/lib/learning";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};
export type DocState = { ok: boolean; error?: string };

// ---------------------------------------------------------------------------
// Parsing helpers
// ---------------------------------------------------------------------------
function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function parseDate(v?: string | null): Date | null {
  const s = (v ?? "").trim();
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
function parseIntOrNull(v?: string | null): number | null {
  const s = (v ?? "").replace(/[,\s]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? Math.round(n) : null;
}
function asBool(v: FormDataEntryValue | null): boolean {
  const s = String(v ?? "");
  return s === "1" || s === "true" || s === "on";
}
function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}
function readIdList(fd: FormData, key: string): string[] {
  try {
    const arr = JSON.parse(String(fd.get(key) ?? "[]"));
    if (!Array.isArray(arr)) return [];
    return Array.from(
      new Set(arr.map((x) => String(x ?? "").trim()).filter((s) => s !== ""))
    );
  } catch {
    return [];
  }
}

// ===========================================================================
// Modules
// ===========================================================================
const moduleSchema = z.object({
  title: z.string().trim().min(2, "Give the module a title"),
  category: z.enum(LEARNING_CATEGORIES),
  summary: z.string().trim().max(400, "Keep the summary under 400 characters").nullable(),
  body: z.string().trim().nullable(),
  estimatedMinutes: z.number().int().min(0).max(100000).nullable(),
  status: z.enum(["DRAFT", "PUBLISHED"]),
});

export async function saveModuleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const moduleId = nz(String(fd.get("moduleId") ?? ""));

  const parsed = moduleSchema.safeParse({
    title: String(fd.get("title") ?? ""),
    category: String(fd.get("category") ?? ""),
    summary: nz(String(fd.get("summary") ?? "")),
    body: nz(String(fd.get("body") ?? "")),
    estimatedMinutes: parseIntOrNull(String(fd.get("estimatedMinutes") ?? "")),
    status: String(fd.get("status") ?? "DRAFT"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const competencyIds = readIdList(fd, "competencyIds");
  // Keep only ids that exist in the catalog (defensive against a stale client).
  const validIds = competencyIds.length
    ? (
        await prisma.competency.findMany({
          where: { id: { in: competencyIds } },
          select: { id: true },
        })
      ).map((c) => c.id)
    : [];

  let savedId: string;
  if (moduleId) {
    const existing = await prisma.learningModule.findUnique({
      where: { id: moduleId },
      select: { id: true },
    });
    if (!existing) return { ok: false, error: "Module not found." };
    savedId = await prisma.$transaction(async (tx) => {
      await tx.learningModule.update({
        where: { id: moduleId },
        data: {
          title: v.title,
          category: v.category,
          summary: v.summary,
          body: v.body,
          estimatedMinutes: v.estimatedMinutes,
          status: v.status,
        },
      });
      await tx.learningModuleCompetency.deleteMany({ where: { moduleId } });
      for (const cid of validIds) {
        await tx.learningModuleCompetency.create({
          data: { moduleId, competencyId: cid },
        });
      }
      return moduleId;
    });
    await writeAudit({
      actorId: me.id,
      action: "learningmodule.update",
      entityType: "learning_module",
      entityId: savedId,
      metadata: { title: v.title, status: v.status, competencies: validIds.length },
    });
  } else {
    savedId = await prisma.$transaction(async (tx) => {
      const created = await tx.learningModule.create({
        data: {
          title: v.title,
          category: v.category,
          summary: v.summary,
          body: v.body,
          estimatedMinutes: v.estimatedMinutes,
          status: v.status,
          createdById: me.id,
        },
      });
      for (const cid of validIds) {
        await tx.learningModuleCompetency.create({
          data: { moduleId: created.id, competencyId: cid },
        });
      }
      return created.id;
    });
    await writeAudit({
      actorId: me.id,
      action: "learningmodule.create",
      entityType: "learning_module",
      entityId: savedId,
      metadata: { title: v.title, status: v.status, competencies: validIds.length },
    });
  }

  revalidatePath("/learning");
  revalidatePath(`/learning/modules/${savedId}`);
  redirect(`/learning/modules/${savedId}`);
}

export async function deleteModuleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const moduleId = String(fd.get("moduleId") ?? "");
  if (!moduleId) return { ok: false, error: "Missing module." };

  const m = await prisma.learningModule.findUnique({
    where: { id: moduleId },
    select: { id: true, title: true },
  });
  if (!m) return { ok: false, error: "Module not found." };

  // Best-effort cleanup of any attached material object before the row goes.
  const material = await prisma.document.findFirst({
    where: { entityType: "learning_module", entityId: moduleId, category: LEARNING_MATERIAL },
  });
  if (material) {
    try {
      await removeObject(material.path);
    } catch {
      /* ignore storage cleanup failure */
    }
    await prisma.document.delete({ where: { id: material.id } });
  }

  // Records + competency tags cascade via the FK.
  await prisma.learningModule.delete({ where: { id: moduleId } });

  await writeAudit({
    actorId: me.id,
    action: "learningmodule.delete",
    entityType: "learning_module",
    entityId: moduleId,
    metadata: { title: m.title },
  });

  revalidatePath("/learning");
  redirect("/learning");
}

// ===========================================================================
// Reading material (reuses the v0.8.0 Document layer + Supabase Storage)
// ===========================================================================
const ALLOWED_MATERIAL = new Set([
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "application/vnd.ms-powerpoint",
  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
]);
const MAX_BYTES = 15 * 1024 * 1024; // 15 MB

function sanitize(name: string): string {
  return name.replace(/[^\w.\-]+/g, "_").slice(0, 120) || "file";
}

export async function uploadMaterialAction(_prev: DocState, fd: FormData): Promise<DocState> {
  const me = await requirePermission("learning.manage");
  const moduleId = String(fd.get("moduleId") ?? "");
  if (!moduleId) return { ok: false, error: "Missing module." };
  if (!storageConfigured()) {
    return {
      ok: false,
      error:
        "File storage isn't configured yet. Add SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY to the environment.",
    };
  }

  const entry = fd.get("file");
  if (!entry || typeof entry === "string") return { ok: false, error: "Choose a file to upload." };
  const file = entry as File;
  if (file.size === 0) return { ok: false, error: "Choose a file to upload." };
  if (!ALLOWED_MATERIAL.has(file.type)) {
    return { ok: false, error: "Only PDF, Word, or PowerPoint files are allowed." };
  }
  if (file.size > MAX_BYTES) return { ok: false, error: "File exceeds the 15 MB limit." };

  const bytes = Buffer.from(await file.arrayBuffer());
  const path = `learning/material/${moduleId}/${Date.now()}_${sanitize(file.name)}`;
  await putObject(path, bytes, file.type);

  const prev = await prisma.document.findFirst({
    where: { entityType: "learning_module", entityId: moduleId, category: LEARNING_MATERIAL },
    orderBy: { createdAt: "desc" },
  });

  await prisma.document.create({
    data: {
      bucket: STORAGE_BUCKET,
      path,
      filename: file.name,
      contentType: file.type,
      sizeBytes: file.size,
      category: LEARNING_MATERIAL,
      entityType: "learning_module",
      entityId: moduleId,
      uploadedById: me.id,
    },
  });

  if (prev) {
    try {
      await removeObject(prev.path);
    } catch {
      /* ignore */
    }
    await prisma.document.delete({ where: { id: prev.id } });
  }

  await writeAudit({
    actorId: me.id,
    action: "learningmaterial.upload",
    entityType: "learning_module",
    entityId: moduleId,
    metadata: { filename: file.name, size: file.size },
  });

  revalidatePath(`/learning/modules/${moduleId}`);
  revalidatePath(`/learning/modules/${moduleId}/edit`);
  return { ok: true };
}

export async function removeMaterialAction(_prev: DocState, fd: FormData): Promise<DocState> {
  const me = await requirePermission("learning.manage");
  const moduleId = String(fd.get("moduleId") ?? "");
  if (!moduleId) return { ok: false, error: "Missing module." };

  const doc = await prisma.document.findFirst({
    where: { entityType: "learning_module", entityId: moduleId, category: LEARNING_MATERIAL },
    orderBy: { createdAt: "desc" },
  });
  if (!doc) return { ok: false, error: "No material on file." };

  try {
    await removeObject(doc.path);
  } catch {
    /* ignore */
  }
  await prisma.document.delete({ where: { id: doc.id } });

  await writeAudit({
    actorId: me.id,
    action: "learningmaterial.remove",
    entityType: "learning_module",
    entityId: moduleId,
    metadata: { filename: doc.filename },
  });

  revalidatePath(`/learning/modules/${moduleId}`);
  revalidatePath(`/learning/modules/${moduleId}/edit`);
  return { ok: true };
}

// ===========================================================================
// Records — self-serve enroll + progress; manager/HR recommend
// ===========================================================================
export async function selfEnrollAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.view");
  const moduleId = String(fd.get("moduleId") ?? "");
  if (!moduleId) return { ok: false, error: "Missing module." };

  const employee = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true },
  });
  if (!employee) {
    return {
      ok: false,
      error: "Your login isn't linked to an employee record yet, so self-enrollment isn't available.",
    };
  }

  const mod = await prisma.learningModule.findUnique({
    where: { id: moduleId },
    select: { id: true, status: true, title: true },
  });
  if (!mod || mod.status !== "PUBLISHED") {
    return { ok: false, error: "This module isn't available to enroll in." };
  }

  const existing = await prisma.learningRecord.findFirst({
    where: { moduleId, employeeId: employee.id },
    select: { id: true },
  });
  if (existing) return { ok: false, error: "You're already enrolled in this module." };

  const rec = await prisma.learningRecord.create({
    data: { moduleId, employeeId: employee.id, source: "SELF", status: "ASSIGNED" },
  });

  await writeAudit({
    actorId: me.id,
    action: "learningrecord.enroll",
    entityType: "learning_record",
    entityId: rec.id,
    metadata: { moduleId, title: mod.title, self: true },
  });

  revalidatePath(`/learning/modules/${moduleId}`);
  revalidatePath("/learning/my");
  redirect(`/learning/modules/${moduleId}`);
}

const RECORD_OPS = ["START", "COMPLETE", "WAIVE", "REOPEN"] as const;

export async function updateRecordAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireUser();
  const canManage = hasPermission(me, "learning.manage");
  const recordId = String(fd.get("recordId") ?? "");
  const op = String(fd.get("op") ?? "");
  const reflection = nz(String(fd.get("reflection") ?? ""));
  if (!recordId) return { ok: false, error: "Missing record." };
  if (!(RECORD_OPS as readonly string[]).includes(op))
    return { ok: false, error: "Unknown action." };

  const rec = await prisma.learningRecord.findUnique({
    where: { id: recordId },
    select: { id: true, moduleId: true, employeeId: true, status: true },
  });
  if (!rec) return { ok: false, error: "Record not found." };

  // Ownership: a record is "mine" if the employee row is linked to my login.
  const owner = await prisma.employee.findUnique({
    where: { id: rec.employeeId },
    select: { userId: true },
  });
  const isOwner = !!owner?.userId && owner.userId === me.id;

  // Waive / reopen are management-only. Start / complete are allowed for the
  // owner (self-serve) or any learning.manage holder.
  if ((op === "WAIVE" || op === "REOPEN") && !canManage) redirect("/access-denied");
  if ((op === "START" || op === "COMPLETE") && !isOwner && !canManage) redirect("/access-denied");

  const data: Record<string, unknown> = {};
  if (op === "START") {
    if (rec.status === "COMPLETED" || rec.status === "WAIVED")
      return { ok: false, error: "This module is already closed." };
    data.status = "IN_PROGRESS";
    data.startedAt = new Date();
  } else if (op === "COMPLETE") {
    data.status = "COMPLETED";
    data.completedAt = new Date();
    if (reflection !== null) data.reflection = reflection;
    if (!("startedAt" in data)) {
      // ensure a started timestamp exists for the record's timeline
      const cur = await prisma.learningRecord.findUnique({
        where: { id: recordId },
        select: { startedAt: true },
      });
      if (!cur?.startedAt) data.startedAt = new Date();
    }
  } else if (op === "WAIVE") {
    data.status = "WAIVED";
  } else if (op === "REOPEN") {
    data.status = "IN_PROGRESS";
    data.completedAt = null;
  }

  await prisma.learningRecord.update({ where: { id: recordId }, data });

  await writeAudit({
    actorId: me.id,
    action: `learningrecord.${op.toLowerCase()}`,
    entityType: "learning_record",
    entityId: recordId,
    metadata: { moduleId: rec.moduleId, employeeId: rec.employeeId, self: isOwner },
  });

  revalidatePath(`/learning/modules/${rec.moduleId}`);
  revalidatePath("/learning/my");
  revalidatePath("/learning");
  return { ok: true };
}

export async function deleteRecordAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const recordId = String(fd.get("recordId") ?? "");
  if (!recordId) return { ok: false, error: "Missing record." };

  const rec = await prisma.learningRecord.findUnique({
    where: { id: recordId },
    select: { id: true, moduleId: true, employeeId: true },
  });
  if (!rec) return { ok: false, error: "Record not found." };

  await prisma.learningRecord.delete({ where: { id: recordId } });

  await writeAudit({
    actorId: me.id,
    action: "learningrecord.delete",
    entityType: "learning_record",
    entityId: recordId,
    metadata: { moduleId: rec.moduleId, employeeId: rec.employeeId },
  });

  revalidatePath(`/learning/modules/${rec.moduleId}`);
  return { ok: true };
}

export async function recommendModulesAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.recommend");
  const employeeId = String(fd.get("employeeId") ?? "");
  const appraisalId = nz(String(fd.get("appraisalId") ?? ""));
  const cycleId = nz(String(fd.get("cycleId") ?? ""));
  const dueDate = parseDate(String(fd.get("dueDate") ?? ""));
  const note = nz(String(fd.get("note") ?? ""));
  const moduleIds = readIdList(fd, "moduleIds");

  if (!employeeId) return { ok: false, error: "Missing employee." };
  if (moduleIds.length === 0)
    return { ok: false, fieldErrors: { moduleIds: "Choose at least one module to recommend." } };

  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, fullName: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  // Only published modules can be recommended.
  const modules = await prisma.learningModule.findMany({
    where: { id: { in: moduleIds }, status: "PUBLISHED" },
    select: { id: true },
  });
  const okIds = modules.map((m) => m.id);
  if (okIds.length === 0)
    return { ok: false, fieldErrors: { moduleIds: "None of the chosen modules are available." } };

  let recommended = 0;
  for (const mid of okIds) {
    const existing = await prisma.learningRecord.findFirst({
      where: { moduleId: mid, employeeId },
      select: { id: true, status: true },
    });
    if (existing) {
      // Don't disturb a finished record; otherwise re-stamp as recommended.
      if (existing.status === "COMPLETED" || existing.status === "WAIVED") continue;
      await prisma.learningRecord.update({
        where: { id: existing.id },
        data: {
          source: "RECOMMENDED",
          recommendedById: me.id,
          appraisalId: appraisalId,
          dueDate,
          notes: note,
        },
      });
    } else {
      await prisma.learningRecord.create({
        data: {
          moduleId: mid,
          employeeId,
          source: "RECOMMENDED",
          status: "ASSIGNED",
          recommendedById: me.id,
          appraisalId: appraisalId,
          dueDate,
          notes: note,
        },
      });
    }
    recommended++;
  }

  await writeAudit({
    actorId: me.id,
    action: "learningrecord.recommend",
    entityType: "employee",
    entityId: employeeId,
    metadata: { employee: employee.fullName, modules: recommended, appraisalId },
  });

  revalidatePath("/learning");
  revalidatePath(`/learning/recommend`);
  if (appraisalId && cycleId) {
    revalidatePath(`/performance/${cycleId}/${employeeId}`);
    redirect(`/performance/${cycleId}/${employeeId}`);
  }
  redirect(`/learning`);
}

// ===========================================================================
// Employee handbook (policies / policy_acknowledgments)
// ===========================================================================
const handbookSchema = z.object({
  title: z.string().trim().min(2, "Give the handbook a title"),
  version: z.string().trim().min(1, "Version is required"),
  summary: z.string().trim().max(400, "Keep the summary under 400 characters").nullable(),
  body: z.string().trim().min(1, "Add the handbook text"),
  effectiveDate: z.date().nullable(),
});

export async function saveHandbookAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const policyId = nz(String(fd.get("policyId") ?? ""));
  const makeCurrent = asBool(fd.get("makeCurrent"));

  const parsed = handbookSchema.safeParse({
    title: String(fd.get("title") ?? ""),
    version: String(fd.get("version") ?? ""),
    summary: nz(String(fd.get("summary") ?? "")),
    body: String(fd.get("body") ?? ""),
    effectiveDate: parseDate(String(fd.get("effectiveDate") ?? "")),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const savedId = await prisma.$transaction(async (tx) => {
    if (makeCurrent) {
      await tx.policy.updateMany({
        where: { category: HANDBOOK_CATEGORY, isCurrent: true },
        data: { isCurrent: false },
      });
    }
    if (policyId) {
      const updated = await tx.policy.update({
        where: { id: policyId },
        data: {
          title: v.title,
          version: v.version,
          summary: v.summary,
          body: v.body,
          effectiveDate: v.effectiveDate,
          category: HANDBOOK_CATEGORY,
          isCurrent: makeCurrent,
        },
      });
      return updated.id;
    }
    const created = await tx.policy.create({
      data: {
        title: v.title,
        version: v.version,
        summary: v.summary,
        body: v.body,
        effectiveDate: v.effectiveDate,
        category: HANDBOOK_CATEGORY,
        isCurrent: makeCurrent,
      },
    });
    return created.id;
  });

  await writeAudit({
    actorId: me.id,
    action: policyId ? "policy.update" : "policy.create",
    entityType: "policy",
    entityId: savedId,
    metadata: { title: v.title, version: v.version, current: makeCurrent },
  });

  revalidatePath("/learning/handbook");
  redirect("/learning/handbook");
}

export async function acknowledgeHandbookAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.view");
  const policyId = String(fd.get("policyId") ?? "");
  if (!policyId) return { ok: false, error: "Missing handbook." };

  const employee = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true },
  });
  if (!employee) {
    return {
      ok: false,
      error: "Your login isn't linked to an employee record yet, so acknowledgment isn't available.",
    };
  }

  await prisma.policyAcknowledgment.upsert({
    where: { policyId_employeeId: { policyId, employeeId: employee.id } },
    update: {},
    create: { policyId, employeeId: employee.id },
  });

  await writeAudit({
    actorId: me.id,
    action: "policyack.record",
    entityType: "policy",
    entityId: policyId,
    metadata: { employeeId: employee.id, self: true },
  });

  revalidatePath("/learning/handbook");
  return { ok: true };
}

export async function recordAckAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const policyId = String(fd.get("policyId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!policyId || !employeeId) return { ok: false, error: "Missing handbook or employee." };

  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  await prisma.policyAcknowledgment.upsert({
    where: { policyId_employeeId: { policyId, employeeId } },
    update: {},
    create: { policyId, employeeId },
  });

  await writeAudit({
    actorId: me.id,
    action: "policyack.record",
    entityType: "policy",
    entityId: policyId,
    metadata: { employeeId, self: false },
  });

  revalidatePath("/learning/handbook");
  return { ok: true };
}
