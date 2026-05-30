// Writes rows to audit_logs. Best-effort: a failure to record an audit entry
// must never break the user-facing action, so writes are wrapped and logged.
import { headers } from "next/headers";
import { prisma } from "@/lib/db";

export async function writeAudit(params: {
  actorId?: string | null;
  action: string;
  entityType: string;
  entityId?: string | null;
  metadata?: Record<string, unknown> | null;
}): Promise<void> {
  try {
    let ip: string | null = null;
    try {
      const h = await headers();
      ip =
        h.get("x-forwarded-for")?.split(",")[0]?.trim() ||
        h.get("x-real-ip") ||
        null;
    } catch {
      // headers() is unavailable in some execution contexts; ignore.
    }
    await prisma.auditLog.create({
      data: {
        actorId: params.actorId ?? null,
        action: params.action,
        entityType: params.entityType,
        entityId: params.entityId ?? null,
        // Prisma Json input; metadata is a plain serializable object.
        metadata: (params.metadata ?? undefined) as never,
        ip,
      },
    });
  } catch (e) {
    console.error("[audit] failed to write audit log:", e);
  }
}
