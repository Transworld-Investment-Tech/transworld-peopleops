"use server";
// Write-side server actions for the Staff Files module. All gated by
// stafffile.manage, validated, and audited. Snapshots are immutable evidence
// (the seal pattern) — once taken they are never edited.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { STAFF_FILE_SLOTS } from "@/lib/stafffile";
import { getStaffFileRollup, SCOPES, type Scope } from "@/lib/stafffile-data";

export type FormState = { ok: boolean; error?: string };

function nz(v: FormDataEntryValue | string | null | undefined): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}

/** Classify (or unclassify) a staff document into a D6.2 slot. */
export async function classifyDocumentSlotAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("stafffile.manage");
  const docId = String(fd.get("docId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  const slot = nz(fd.get("fileSlot")); // null clears the classification
  if (!docId || !employeeId) return { ok: false, error: "Missing document." };
  if (slot !== null && !(STAFF_FILE_SLOTS as readonly string[]).includes(slot)) {
    return { ok: false, error: "Invalid staff-file slot." };
  }
  const doc = await prisma.staffDocument.findFirst({
    where: { id: docId, employeeId },
    select: { id: true },
  });
  if (!doc) return { ok: false, error: "Document not found for this employee." };

  await prisma.staffDocument.update({ where: { id: docId }, data: { fileSlot: slot } });
  await writeAudit({
    actorId: me.id,
    action: "stafffile.classify_doc",
    entityType: "StaffDocument",
    entityId: docId,
    metadata: { employeeId, slot },
  });
  revalidatePath(`/staff-files/${employeeId}`);
  revalidatePath("/staff-files");
  return { ok: true };
}

/** Set the regulated-role flag on an employee (drives D6.2 applicability). */
export async function setEmployeeRegulatedFlagAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("stafffile.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  const value = nz(fd.get("isRegulated"));
  if (!employeeId) return { ok: false, error: "Missing employee." };
  const isRegulated = value === "on" || value === "true";
  const emp = await prisma.employee.findUnique({ where: { id: employeeId }, select: { id: true } });
  if (!emp) return { ok: false, error: "Employee not found." };

  await prisma.employee.update({ where: { id: employeeId }, data: { isRegulatedRole: isRegulated } });
  await writeAudit({
    actorId: me.id,
    action: "stafffile.set_regulated",
    entityType: "Employee",
    entityId: employeeId,
    metadata: { isRegulated },
  });
  revalidatePath(`/staff-files/${employeeId}`);
  revalidatePath("/staff-files");
  return { ok: true };
}

/** Take an immutable completeness snapshot for the trend ("X of N, rising"). */
export async function takeStaffFileSnapshotAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("stafffile.manage");
  const scopeRaw = String(fd.get("scope") ?? "ALL");
  const scope: Scope = (SCOPES as readonly string[]).includes(scopeRaw)
    ? (scopeRaw as Scope)
    : "ALL";
  const note = nz(fd.get("note"));

  const rollup = await getStaffFileRollup(scope);
  const created = await prisma.staffFileSnapshot.create({
    data: {
      scope,
      populationCount: rollup.population,
      completeCount: rollup.completeCount,
      thresholdPct: rollup.threshold,
      avgCompletenessPct: rollup.avgPct,
      note,
      takenById: me.id,
      takenByName: me.name,
    },
    select: { id: true },
  });
  await writeAudit({
    actorId: me.id,
    action: "stafffile.snapshot",
    entityType: "StaffFileSnapshot",
    entityId: created.id,
    metadata: { scope, population: rollup.population, complete: rollup.completeCount, avgPct: rollup.avgPct },
  });
  revalidatePath("/staff-files");
  return { ok: true };
}
