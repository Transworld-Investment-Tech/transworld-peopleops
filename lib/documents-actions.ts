"use server";
// Write-side server actions for stored documents. The file posts to the server
// (multipart) and is uploaded with the service-role key here — the key never
// reaches the browser. Every action is RBAC-gated and audited. Uploads are
// "latest-wins": replacing a document deletes the previous object + row, so an
// entity+category keeps a single current file.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { putObject, removeObject, storageConfigured, STORAGE_BUCKET } from "@/lib/storage";

export type DocState = { ok: boolean; error?: string };

const ALLOWED = new Set([
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
]);
const MAX_BYTES = 10 * 1024 * 1024; // 10 MB

function sanitize(name: string): string {
  return name.replace(/[^\w.\-]+/g, "_").slice(0, 120) || "file";
}

async function uploadLatest(opts: {
  perm: string;
  entityType: string;
  entityId: string;
  category: string;
  pathPrefix: string;
  action: string;
  fd: FormData;
}): Promise<DocState> {
  const me = await requirePermission(opts.perm);
  if (!storageConfigured()) {
    return {
      ok: false,
      error:
        "File storage isn't configured yet. Add SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY to the environment.",
    };
  }

  const entry = opts.fd.get("file");
  if (!entry || typeof entry === "string") return { ok: false, error: "Choose a file to upload." };
  const file = entry as File;
  if (file.size === 0) return { ok: false, error: "Choose a file to upload." };
  if (!ALLOWED.has(file.type)) {
    return { ok: false, error: "Only PDF or Word (.doc/.docx) files are allowed." };
  }
  if (file.size > MAX_BYTES) return { ok: false, error: "File exceeds the 10 MB limit." };

  const bytes = Buffer.from(await file.arrayBuffer());
  const path = `${opts.pathPrefix}/${opts.entityId}/${Date.now()}_${sanitize(file.name)}`;
  await putObject(path, bytes, file.type);

  const prev = await prisma.document.findFirst({
    where: { entityType: opts.entityType, entityId: opts.entityId, category: opts.category },
    orderBy: { createdAt: "desc" },
  });

  await prisma.document.create({
    data: {
      bucket: STORAGE_BUCKET,
      path,
      filename: file.name,
      contentType: file.type,
      sizeBytes: file.size,
      category: opts.category,
      entityType: opts.entityType,
      entityId: opts.entityId,
      uploadedById: me.id,
    },
  });

  if (prev) {
    try {
      await removeObject(prev.path);
    } catch {
      /* ignore storage cleanup failure — the row swap still succeeds */
    }
    await prisma.document.delete({ where: { id: prev.id } });
  }

  await writeAudit({
    actorId: me.id,
    action: opts.action,
    entityType: opts.entityType,
    entityId: opts.entityId,
    metadata: { filename: file.name, size: file.size },
  });
  return { ok: true };
}

async function removeLatest(opts: {
  perm: string;
  entityType: string;
  entityId: string;
  category: string;
  action: string;
}): Promise<DocState> {
  const me = await requirePermission(opts.perm);
  const doc = await prisma.document.findFirst({
    where: { entityType: opts.entityType, entityId: opts.entityId, category: opts.category },
    orderBy: { createdAt: "desc" },
  });
  if (!doc) return { ok: true };
  if (storageConfigured()) {
    try {
      await removeObject(doc.path);
    } catch {
      /* ignore */
    }
  }
  await prisma.document.delete({ where: { id: doc.id } });
  await writeAudit({
    actorId: me.id,
    action: opts.action,
    entityType: opts.entityType,
    entityId: opts.entityId,
    metadata: { filename: doc.filename },
  });
  return { ok: true };
}

// --- Job description (thin wrappers; permission is fixed server-side) -------
export async function uploadJobDescriptionAction(
  _prev: DocState,
  fd: FormData
): Promise<DocState> {
  const profileId = String(fd.get("entityId") ?? "");
  if (!profileId) return { ok: false, error: "Missing job profile." };
  const profile = await prisma.jobProfile.findUnique({
    where: { id: profileId },
    select: { id: true },
  });
  if (!profile) return { ok: false, error: "Job profile not found." };

  const res = await uploadLatest({
    perm: "jobframework.manage",
    entityType: "job_profile",
    entityId: profileId,
    category: "JOB_DESCRIPTION",
    pathPrefix: "job-descriptions",
    action: "jobprofile.jd_upload",
    fd,
  });
  if (res.ok) {
    revalidatePath(`/job-competency/${profileId}`);
    revalidatePath("/job-competency");
  }
  return res;
}

export async function removeJobDescriptionAction(
  _prev: DocState,
  fd: FormData
): Promise<DocState> {
  const profileId = String(fd.get("entityId") ?? "");
  if (!profileId) return { ok: false, error: "Missing job profile." };

  const res = await removeLatest({
    perm: "jobframework.manage",
    entityType: "job_profile",
    entityId: profileId,
    category: "JOB_DESCRIPTION",
    action: "jobprofile.jd_remove",
  });
  if (res.ok) {
    revalidatePath(`/job-competency/${profileId}`);
    revalidatePath("/job-competency");
  }
  return res;
}
