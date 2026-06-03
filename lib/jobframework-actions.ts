"use server";
// Write-side server actions for the Job & Competency module. Every mutation is
// gated by jobframework.manage, validated with zod, and writes an audit_logs
// row. Mirrors the employees-actions.ts conventions (diff for audit, then a
// minimal update + revalidate + redirect). Competency requirements are applied
// inside an interactive transaction so a profile's skill set updates atomically.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const STATUSES = ["DRAFT", "PUBLISHED"] as const;

function nz(v: string | undefined | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

// --------------------------------------------------------------------------
// Job profiles
// --------------------------------------------------------------------------
const reqItemSchema = z.object({
  id: z.string().min(1),
  level: z.number().int().min(1).max(3),
});

const profileSchema = z.object({
  title: z.string().trim().min(2, "Title is required"),
  grade: z.string().trim().optional().or(z.literal("")),
  departmentId: z.string().optional().or(z.literal("")),
  description: z.string().trim().optional().or(z.literal("")),
  status: z.enum(STATUSES),
  family: z.string().optional().or(z.literal("")),
  isControlFunction: z.boolean().optional(),
  track: z.string().optional().or(z.literal("")),
  rung: z.string().optional().or(z.literal("")),
  competencies: z.array(reqItemSchema),
});

function readProfileForm(fd: FormData) {
  let competencies: { id: string; level: number }[] = [];
  try {
    const arr = JSON.parse(String(fd.get("competencies") ?? "[]"));
    if (Array.isArray(arr)) {
      competencies = arr.map((x: { id: unknown; level: unknown }) => ({
        id: String(x.id),
        level: Number(x.level),
      }));
    }
  } catch {
    // Malformed payload → treat as no competencies; schema would also reject.
  }
  return {
    title: String(fd.get("title") ?? ""),
    grade: String(fd.get("grade") ?? ""),
    departmentId: String(fd.get("departmentId") ?? ""),
    description: String(fd.get("description") ?? ""),
    status: String(fd.get("status") ?? "DRAFT"),
    family: String(fd.get("family") ?? ""),
    isControlFunction: fd.get("isControlFunction") === "on",
    track: String(fd.get("track") ?? ""),
    rung: String(fd.get("rung") ?? ""),
    competencies,
  };
}

/** Reconcile a profile's competency requirements to the desired set. */
async function applyCompetencies(
  jobProfileId: string,
  desired: { id: string; level: number }[]
): Promise<{ added: number; removed: number; changed: number }> {
  const existing = await prisma.jobProfileCompetency.findMany({ where: { jobProfileId } });
  const exMap = new Map(existing.map((e) => [e.competencyId, e.level]));
  const desiredMap = new Map(desired.map((d) => [d.id, d.level]));

  const toDelete = existing.filter((e) => !desiredMap.has(e.competencyId)).map((e) => e.competencyId);
  const toCreate = desired.filter((d) => !exMap.has(d.id));
  const toUpdate = desired.filter((d) => exMap.has(d.id) && exMap.get(d.id) !== d.level);

  if (toDelete.length || toCreate.length || toUpdate.length) {
    await prisma.$transaction(async (tx) => {
      if (toDelete.length) {
        await tx.jobProfileCompetency.deleteMany({
          where: { jobProfileId, competencyId: { in: toDelete } },
        });
      }
      for (const c of toCreate) {
        await tx.jobProfileCompetency.create({
          data: { jobProfileId, competencyId: c.id, level: c.level },
        });
      }
      for (const c of toUpdate) {
        await tx.jobProfileCompetency.update({
          where: { jobProfileId_competencyId: { jobProfileId, competencyId: c.id } },
          data: { level: c.level },
        });
      }
    });
  }
  return { added: toCreate.length, removed: toDelete.length, changed: toUpdate.length };
}

/** Drop any submitted competency ids that aren't in the catalog (FK safety). */
async function validIds(desired: { id: string; level: number }[]) {
  if (desired.length === 0) return [];
  const rows = await prisma.competency.findMany({ select: { id: true } });
  const valid = new Set(rows.map((r) => r.id));
  return desired.filter((d) => valid.has(d.id));
}

export async function createJobProfileAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const parsed = profileSchema.safeParse(readProfileForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const created = await prisma.jobProfile.create({
    data: {
      title: v.title.trim(),
      grade: nz(v.grade),
      departmentId: nz(v.departmentId),
      description: nz(v.description),
      status: v.status,
      family: nz(v.family),
      isControlFunction: v.isControlFunction ?? false,
      track: nz(v.track),
      rung: nz(v.rung),
    },
  });

  const summary = await applyCompetencies(created.id, await validIds(v.competencies));

  await writeAudit({
    actorId: me.id,
    action: "jobprofile.create",
    entityType: "job_profile",
    entityId: created.id,
    metadata: { title: created.title, competencies: summary },
  });

  revalidatePath("/job-competency");
  revalidatePath("/employees");
  redirect(`/job-competency/${created.id}`);
}

export async function updateJobProfileAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing job profile id." };

  const parsed = profileSchema.safeParse(readProfileForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const cur = await prisma.jobProfile.findUnique({ where: { id } });
  if (!cur) return { ok: false, error: "Job profile not found." };

  const next = {
    title: v.title.trim(),
    grade: nz(v.grade),
    departmentId: nz(v.departmentId),
    description: nz(v.description),
    status: v.status,
    family: nz(v.family),
    isControlFunction: v.isControlFunction ?? false,
    track: nz(v.track),
    rung: nz(v.rung),
  };

  const data: Record<string, unknown> = {};
  const changes: string[] = [];
  const compare: [string, unknown, unknown][] = [
    ["title", cur.title, next.title],
    ["grade", cur.grade, next.grade],
    ["departmentId", cur.departmentId, next.departmentId],
    ["description", cur.description, next.description],
    ["status", cur.status, next.status],
    ["family", cur.family, next.family],
    ["isControlFunction", cur.isControlFunction, next.isControlFunction],
    ["track", cur.track, next.track],
    ["rung", cur.rung, next.rung],
  ];
  for (const [key, before, after] of compare) {
    if (before !== after) {
      (data as Record<string, unknown>)[key] = (next as Record<string, unknown>)[key];
      changes.push(
        key === "description"
          ? "description (updated)"
          : `${key}: ${before ?? "—"} → ${after ?? "—"}`
      );
    }
  }

  if (Object.keys(data).length > 0) {
    await prisma.jobProfile.update({ where: { id }, data });
  }
  const summary = await applyCompetencies(id, await validIds(v.competencies));

  const touchedComps = summary.added + summary.removed + summary.changed > 0;
  if (changes.length === 0 && !touchedComps) {
    redirect(`/job-competency/${id}`);
  }

  await writeAudit({
    actorId: me.id,
    action: "jobprofile.update",
    entityType: "job_profile",
    entityId: id,
    metadata: { title: cur.title, changes, competencies: summary },
  });

  revalidatePath("/job-competency");
  revalidatePath(`/job-competency/${id}`);
  revalidatePath("/employees");
  redirect(`/job-competency/${id}`);
}

// --------------------------------------------------------------------------
// Competencies (catalog)
// --------------------------------------------------------------------------
const competencySchema = z.object({
  name: z.string().trim().min(2, "Name is required"),
  category: z.string().trim().optional().or(z.literal("")),
});

function readCompetencyForm(fd: FormData) {
  return {
    name: String(fd.get("name") ?? ""),
    category: String(fd.get("category") ?? ""),
  };
}

async function nameTaken(name: string, exceptId?: string): Promise<boolean> {
  const hit = await prisma.competency.findFirst({
    where: { name: { equals: name, mode: "insensitive" } },
    select: { id: true },
  });
  return !!hit && hit.id !== exceptId;
}

export async function createCompetencyAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const parsed = competencySchema.safeParse(readCompetencyForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  if (await nameTaken(v.name.trim())) {
    return { ok: false, fieldErrors: { name: "A competency with that name already exists." } };
  }

  const created = await prisma.competency.create({
    data: { name: v.name.trim(), category: nz(v.category) },
  });

  await writeAudit({
    actorId: me.id,
    action: "competency.create",
    entityType: "competency",
    entityId: created.id,
    metadata: { name: created.name, category: created.category },
  });

  revalidatePath("/job-competency/competencies");
  revalidatePath("/job-competency");
  redirect("/job-competency/competencies");
}

export async function updateCompetencyAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing competency id." };

  const parsed = competencySchema.safeParse(readCompetencyForm(fd));
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const cur = await prisma.competency.findUnique({ where: { id } });
  if (!cur) return { ok: false, error: "Competency not found." };

  if (await nameTaken(v.name.trim(), id)) {
    return { ok: false, fieldErrors: { name: "A competency with that name already exists." } };
  }

  const next = { name: v.name.trim(), category: nz(v.category) };
  const changes: string[] = [];
  if (cur.name !== next.name) changes.push(`name: ${cur.name} → ${next.name}`);
  if (cur.category !== next.category) changes.push(`category: ${cur.category ?? "—"} → ${next.category ?? "—"}`);

  if (changes.length === 0) redirect("/job-competency/competencies");

  await prisma.competency.update({ where: { id }, data: next });
  await writeAudit({
    actorId: me.id,
    action: "competency.update",
    entityType: "competency",
    entityId: id,
    metadata: { name: cur.name, changes },
  });

  revalidatePath("/job-competency/competencies");
  revalidatePath("/job-competency");
  redirect("/job-competency/competencies");
}
