// Read-side helpers for the Document registry. Writes live in
// lib/documents-actions.ts; storage I/O lives in lib/storage.ts.
import { prisma } from "@/lib/db";

/** The most recent document for an entity (optionally within a category). */
export async function getLatestDocument(
  entityType: string,
  entityId: string,
  category?: string
) {
  return prisma.document.findFirst({
    where: { entityType, entityId, ...(category ? { category } : {}) },
    orderBy: { createdAt: "desc" },
  });
}

/** All documents for an entity (optionally within a category), newest first. */
export async function listDocuments(
  entityType: string,
  entityId: string,
  category?: string
) {
  return prisma.document.findMany({
    where: { entityType, entityId, ...(category ? { category } : {}) },
    orderBy: { createdAt: "desc" },
  });
}

/** Human-friendly file size. */
export function prettySize(bytes: number | null | undefined): string {
  if (bytes === null || bytes === undefined) return "";
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}
