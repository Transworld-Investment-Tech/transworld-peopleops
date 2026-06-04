"use server";
// Write-side for the Alerts surface. The page shows the read-only dry run
// (lib/notifications.getPendingAlerts); committing persists the computed alerts
// idempotently by dedupe_key (never resurrecting a dismissed/resolved one).
// Gated by stafffile.manage and audited.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { computeAllAlerts } from "@/lib/notifications";

export type FormState = { ok: boolean; error?: string; created?: number };

/** Commit step of the dry-run -> commit gate: create any computed alert whose
 * dedupe_key is not already on file. Existing rows (open OR dismissed/resolved)
 * are left untouched, so a dismissed alert is not resurrected. */
export async function commitAlertsAction(_prev: FormState, _fd: FormData): Promise<FormState> {
  const me = await requirePermission("stafffile.manage");
  const computed = await computeAllAlerts();
  if (computed.length === 0) {
    return { ok: true, created: 0 };
  }
  const keys = computed.map((c) => c.dedupeKey);
  const existing = await prisma.notification.findMany({
    where: { dedupeKey: { in: keys } },
    select: { dedupeKey: true },
  });
  const have = new Set(existing.map((e) => e.dedupeKey).filter((x): x is string => !!x));
  const toCreate = computed.filter((c) => !have.has(c.dedupeKey));

  if (toCreate.length > 0) {
    await prisma.notification.createMany({
      data: toCreate.map((c) => ({
        category: c.category,
        severity: c.severity,
        title: c.title,
        body: c.body,
        entityType: c.entityType,
        entityId: c.entityId,
        dueAt: c.dueAt,
        status: "OPEN",
        dedupeKey: c.dedupeKey,
      })),
      skipDuplicates: true,
    });
  }
  await writeAudit({
    actorId: me.id,
    action: "alerts.commit",
    entityType: "Notification",
    metadata: { computed: computed.length, created: toCreate.length },
  });
  revalidatePath("/alerts");
  return { ok: true, created: toCreate.length };
}

async function transition(
  fd: FormData,
  status: "DISMISSED" | "RESOLVED",
  action: string
): Promise<FormState> {
  const me = await requirePermission("stafffile.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing alert." };
  const n = await prisma.notification.findUnique({ where: { id }, select: { id: true } });
  if (!n) return { ok: false, error: "Alert not found." };
  await prisma.notification.update({
    where: { id },
    data: {
      status,
      dismissedAt: status === "DISMISSED" ? new Date() : null,
      resolvedAt: status === "RESOLVED" ? new Date() : null,
    },
  });
  await writeAudit({ actorId: me.id, action, entityType: "Notification", entityId: id });
  revalidatePath("/alerts");
  return { ok: true };
}

export async function dismissAlertAction(_prev: FormState, fd: FormData): Promise<FormState> {
  return transition(fd, "DISMISSED", "alerts.dismiss");
}

export async function resolveAlertAction(_prev: FormState, fd: FormData): Promise<FormState> {
  return transition(fd, "RESOLVED", "alerts.resolve");
}
