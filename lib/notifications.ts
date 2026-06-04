// Read-side for the notification spine + the Alerts surface. Computes the
// alerts that SHOULD exist from current data (document expiry + staff-file
// gaps) — this is the read-only "dry run" the Alerts page shows — and reads the
// persisted open alerts. No writes here; commit/dismiss/resolve live in
// lib/notifications-actions.ts.
import { prisma } from "@/lib/db";
import {
  daysUntil,
  expiryBucket,
  severityForExpiry,
  gapSeverity,
  dedupeKeyForExpiry,
  dedupeKeyForGap,
  expiryPhrase,
  categoryLabel,
  type NotificationCategory,
  type Severity,
} from "@/lib/expiry";
import { getStaffFileRollup } from "@/lib/stafffile-data";
import { slotLabel } from "@/lib/stafffile";

const ALERT_CATEGORIES = ["DOC_EXPIRY", "STAFF_FILE_GAP"];
const SEVERITY_RANK: Record<string, number> = { CRITICAL: 0, WARNING: 1, INFO: 2 };

export type ComputedAlert = {
  dedupeKey: string;
  category: NotificationCategory;
  severity: Severity;
  title: string;
  body: string | null;
  entityType: string;
  entityId: string;
  dueAt: Date | null;
};

/** Document-expiry alerts implied by staff_documents.expiry_date (<= 90 days). */
export async function computeExpiryAlerts(now: Date = new Date()): Promise<ComputedAlert[]> {
  const docs = await prisma.staffDocument.findMany({
    where: { expiryDate: { not: null }, status: { not: "VOID" }, employeeId: { not: null } },
    select: { id: true, title: true, expiryDate: true, employeeId: true },
  });
  if (docs.length === 0) return [];
  const empIds = Array.from(new Set(docs.map((d) => d.employeeId).filter((x): x is string => !!x)));
  const emps = await prisma.employee.findMany({
    where: { id: { in: empIds } },
    select: { id: true, fullName: true },
  });
  const name = new Map(emps.map((e) => [e.id, e.fullName] as const));

  const out: ComputedAlert[] = [];
  for (const d of docs) {
    if (!d.expiryDate || !d.employeeId) continue;
    const days = daysUntil(d.expiryDate, now);
    const bucket = expiryBucket(days);
    if (!bucket) continue;
    const who = name.get(d.employeeId) ?? "An employee";
    out.push({
      dedupeKey: dedupeKeyForExpiry(d.id, bucket),
      category: "DOC_EXPIRY",
      severity: severityForExpiry(bucket),
      title: `${who}: ${d.title} ${expiryPhrase(days)}`,
      body: `Document ${d.title} for ${who} ${expiryPhrase(days)}. Renew and re-file before it lapses.`,
      entityType: "StaffDocument",
      entityId: d.id,
      dueAt: d.expiryDate,
    });
  }
  return out;
}

/** Staff-file-gap alerts for files below the D6.3 completeness threshold. */
export async function computeGapAlerts(): Promise<ComputedAlert[]> {
  const rollup = await getStaffFileRollup("ALL");
  const out: ComputedAlert[] = [];
  for (const r of rollup.rows) {
    if (r.complete) continue;
    const top = r.missing.slice(0, 3).map((s) => slotLabel(s)).join(", ");
    out.push({
      dedupeKey: dedupeKeyForGap(r.employeeId),
      category: "STAFF_FILE_GAP",
      severity: gapSeverity(r.pct),
      title: `${r.fullName} — staff file ${r.pct}% (${r.satisfiedCount}/${r.requiredCount})`,
      body: top ? `Top gaps: ${top}.` : null,
      entityType: "Employee",
      entityId: r.employeeId,
      dueAt: null,
    });
  }
  return out;
}

export async function computeAllAlerts(now: Date = new Date()): Promise<ComputedAlert[]> {
  const [exp, gap] = await Promise.all([computeExpiryAlerts(now), computeGapAlerts()]);
  return [...exp, ...gap].sort(
    (a, b) => (SEVERITY_RANK[a.severity] ?? 9) - (SEVERITY_RANK[b.severity] ?? 9)
  );
}

export type AlertView = {
  id: string;
  category: string;
  categoryLabel: string;
  severity: string;
  title: string;
  body: string | null;
  dueAt: Date | null;
  createdAt: Date;
  status: string;
};

function toView(n: {
  id: string;
  category: string | null;
  severity: string | null;
  title: string;
  body: string | null;
  dueAt: Date | null;
  createdAt: Date;
  status: string;
}): AlertView {
  return {
    id: n.id,
    category: n.category ?? "SYSTEM",
    categoryLabel: categoryLabel(n.category ?? "SYSTEM"),
    severity: n.severity ?? "INFO",
    title: n.title,
    body: n.body,
    dueAt: n.dueAt,
    createdAt: n.createdAt,
    status: n.status,
  };
}

export async function getOpenAlerts(): Promise<AlertView[]> {
  const rows = await prisma.notification.findMany({
    where: { status: "OPEN", category: { in: ALERT_CATEGORIES } },
    orderBy: [{ createdAt: "desc" }],
    select: {
      id: true,
      category: true,
      severity: true,
      title: true,
      body: true,
      dueAt: true,
      createdAt: true,
      status: true,
    },
  });
  const views = rows.map(toView);
  views.sort((a, b) => (SEVERITY_RANK[a.severity] ?? 9) - (SEVERITY_RANK[b.severity] ?? 9));
  return views;
}

export type AlertKpis = {
  openCount: number;
  pendingCount: number; // computed alerts not yet persisted
  expiringSoon: number; // computed expiry alerts within 30 days / expired
  filesBelowThreshold: number;
};

/** The computed alerts whose dedupe_key is not already persisted (what a commit
 * would newly create). This is the dry-run preview. */
export async function getPendingAlerts(now: Date = new Date()): Promise<ComputedAlert[]> {
  const computed = await computeAllAlerts(now);
  if (computed.length === 0) return [];
  const keys = computed.map((c) => c.dedupeKey);
  const existing = await prisma.notification.findMany({
    where: { dedupeKey: { in: keys } },
    select: { dedupeKey: true },
  });
  const have = new Set(existing.map((e) => e.dedupeKey).filter((x): x is string => !!x));
  return computed.filter((c) => !have.has(c.dedupeKey));
}

export async function getAlertKpis(now: Date = new Date()): Promise<AlertKpis> {
  const [computed, open] = await Promise.all([computeAllAlerts(now), getOpenAlerts()]);
  const keys = computed.map((c) => c.dedupeKey);
  const existing = keys.length
    ? await prisma.notification.findMany({
        where: { dedupeKey: { in: keys } },
        select: { dedupeKey: true },
      })
    : [];
  const have = new Set(existing.map((e) => e.dedupeKey).filter((x): x is string => !!x));
  return {
    openCount: open.length,
    pendingCount: computed.filter((c) => !have.has(c.dedupeKey)).length,
    expiringSoon: computed.filter((c) => c.category === "DOC_EXPIRY" && c.severity !== "INFO").length,
    filesBelowThreshold: computed.filter((c) => c.category === "STAFF_FILE_GAP").length,
  };
}
