// Read-only access to the audit trail for the admin Audit Log viewer (v0.32.0).
// Events are written across the app by lib/auth/audit.ts#writeAudit; this module
// only reads them back. Gated at the page by `admin.users` (no new permission).
//
// Filters are simple and server-side (driven by the page's searchParams): by
// entity type, by action, by actor, and by a date window. Newest first, paged.
import { prisma } from "@/lib/db";

export const AUDIT_PAGE_SIZE = 50;

export type AuditRow = {
  id: string;
  createdAt: Date;
  actorName: string | null;
  actorEmail: string | null;
  action: string;
  entityType: string;
  entityId: string | null;
  ip: string | null;
};

export type AuditFilters = {
  entityType?: string;
  action?: string;
  actorId?: string;
  from?: string; // YYYY-MM-DD inclusive
  to?: string; // YYYY-MM-DD inclusive
  page?: number;
};

export type AuditLogView = {
  rows: AuditRow[];
  total: number;
  page: number;
  pageCount: number;
  pageSize: number;
  // Distinct option lists for the filter strip:
  entityTypes: string[];
  actions: string[];
  actors: { id: string; label: string }[];
  applied: AuditFilters;
};

function dayStart(s?: string): Date | undefined {
  if (!s) return undefined;
  const d = new Date(`${s}T00:00:00`);
  return Number.isNaN(d.getTime()) ? undefined : d;
}
function dayEndExclusive(s?: string): Date | undefined {
  if (!s) return undefined;
  const d = new Date(`${s}T00:00:00`);
  if (Number.isNaN(d.getTime())) return undefined;
  d.setDate(d.getDate() + 1); // inclusive end-of-day → next midnight, used with `lt`
  return d;
}

export async function getAuditLog(filters: AuditFilters = {}): Promise<AuditLogView> {
  const page = Math.max(1, Math.floor(filters.page ?? 1));
  const from = dayStart(filters.from);
  const toExclusive = dayEndExclusive(filters.to);

  const where = {
    ...(filters.entityType ? { entityType: filters.entityType } : {}),
    ...(filters.action ? { action: filters.action } : {}),
    ...(filters.actorId ? { actorId: filters.actorId } : {}),
    ...(from || toExclusive
      ? { createdAt: { ...(from ? { gte: from } : {}), ...(toExclusive ? { lt: toExclusive } : {}) } }
      : {}),
  };

  const [total, records, entityTypeGroups, actionGroups, actors] = await Promise.all([
    prisma.auditLog.count({ where }),
    prisma.auditLog.findMany({
      where,
      orderBy: [{ createdAt: "desc" }],
      skip: (page - 1) * AUDIT_PAGE_SIZE,
      take: AUDIT_PAGE_SIZE,
      include: { actor: { select: { name: true, email: true } } },
    }),
    prisma.auditLog.groupBy({ by: ["entityType"], orderBy: { entityType: "asc" } }),
    prisma.auditLog.groupBy({ by: ["action"], orderBy: { action: "asc" } }),
    prisma.user.findMany({ select: { id: true, name: true, email: true }, orderBy: { name: "asc" } }),
  ]);

  const rows: AuditRow[] = records.map((r) => ({
    id: r.id,
    createdAt: r.createdAt,
    actorName: r.actor?.name ?? null,
    actorEmail: r.actor?.email ?? null,
    action: r.action,
    entityType: r.entityType,
    entityId: r.entityId,
    ip: r.ip,
  }));

  return {
    rows,
    total,
    page,
    pageSize: AUDIT_PAGE_SIZE,
    pageCount: Math.max(1, Math.ceil(total / AUDIT_PAGE_SIZE)),
    entityTypes: entityTypeGroups.map((g) => g.entityType),
    actions: actionGroups.map((g) => g.action),
    actors: actors.map((u) => ({ id: u.id, label: `${u.name} · ${u.email}` })),
    applied: filters,
  };
}
