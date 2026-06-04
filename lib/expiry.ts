// Pure engine for document-expiry + staff-file-gap alerting. Import-free and
// side-effect-free so it can be unit-tested in isolation (npm run expiry:test).
// The data layer (lib/notifications.ts) reads staff_documents.expiry_date and
// the staff-file rollup, and uses these helpers to bucket, score, and dedupe
// the alerts it would generate. Mirrors the client-KYC alert mechanism.

export const NOTIFICATION_CATEGORIES = [
  "DOC_EXPIRY",
  "STAFF_FILE_GAP",
  "PIPELINE_GATE", // reserved; generator deferred
  "SYSTEM",
] as const;
export type NotificationCategory = (typeof NOTIFICATION_CATEGORIES)[number];

export const SEVERITIES = ["INFO", "WARNING", "CRITICAL"] as const;
export type Severity = (typeof SEVERITIES)[number];

export const NOTIFICATION_STATUSES = ["OPEN", "DISMISSED", "RESOLVED"] as const;
export type NotificationStatus = (typeof NOTIFICATION_STATUSES)[number];

// Horizons (days) at which a lapsing document raises an alert.
export const EXPIRY_WARN_DAYS = 30;
export const EXPIRY_NOTICE_DAYS = 90;

export type ExpiryBucket = "EXPIRED" | "30" | "90";

/** Whole calendar days until `date` (negative if already past). */
export function daysUntil(date: Date, now: Date = new Date()): number {
  const d0 = Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate());
  const n0 = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
  return Math.round((d0 - n0) / 86400000);
}

/** Which alert bucket a document falls in, or null if it is not yet alertable. */
export function expiryBucket(days: number): ExpiryBucket | null {
  if (days < 0) return "EXPIRED";
  if (days <= EXPIRY_WARN_DAYS) return "30";
  if (days <= EXPIRY_NOTICE_DAYS) return "90";
  return null;
}

export function severityForExpiry(bucket: ExpiryBucket): Severity {
  switch (bucket) {
    case "EXPIRED": return "CRITICAL";
    case "30": return "WARNING";
    case "90": return "INFO";
  }
}

/** A below-threshold staff file: critical under 50%, warning otherwise. */
export function gapSeverity(pct: number): Severity {
  return pct < 50 ? "CRITICAL" : "WARNING";
}

export function dedupeKeyForExpiry(docId: string, bucket: ExpiryBucket): string {
  return `exp:${docId}:${bucket}`;
}

export function dedupeKeyForGap(employeeId: string): string {
  return `gap:${employeeId}`;
}

export function severityBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "CRITICAL": return { cls: "b-red", label: "Critical" };
    case "WARNING": return { cls: "b-amb", label: "Warning" };
    case "INFO": return { cls: "b-blu", label: "Info" };
    default: return { cls: "b-gry", label: s };
  }
}

export function categoryLabel(c: string): string {
  switch (c) {
    case "DOC_EXPIRY": return "Document expiry";
    case "STAFF_FILE_GAP": return "Staff-file gap";
    case "PIPELINE_GATE": return "Pipeline gate";
    case "SYSTEM": return "System";
    default: return c;
  }
}

/** Human phrase for an expiry bucket + day count, for the alert title/body. */
export function expiryPhrase(days: number): string {
  if (days < 0) return `expired ${Math.abs(days)} day${Math.abs(days) === 1 ? "" : "s"} ago`;
  if (days === 0) return "expires today";
  return `expires in ${days} day${days === 1 ? "" : "s"}`;
}
