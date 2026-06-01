import { NextResponse } from "next/server";
import { requireUser, hasPermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { downloadObject, storageConfigured } from "@/lib/storage";
import { writeAudit } from "@/lib/auth/audit";

// GET /staff-documents/[docId]/file — streams the document's stored file with an
// explicit Content-Type (and UTF-8 charset for the generated HTML), so it always
// renders correctly in the browser. Access is enforced here (route handlers
// aren't wrapped by the app layout): HR who can manage documents, the staff
// member the document belongs to, or a permitted viewer of the host record.
function contentTypeFor(stored: string | null, fileKey: string): string {
  if (stored && stored.trim()) {
    return stored.startsWith("text/html") ? "text/html; charset=utf-8" : stored;
  }
  if (/\.html?$/i.test(fileKey)) return "text/html; charset=utf-8";
  if (/\.pdf$/i.test(fileKey)) return "application/pdf";
  if (/\.png$/i.test(fileKey)) return "image/png";
  if (/\.jpe?g$/i.test(fileKey)) return "image/jpeg";
  return "application/octet-stream";
}

function filenameFor(title: string, type: string): string {
  const base = (title || "document").replace(/[^\w.\- ]+/g, "_").trim().slice(0, 80) || "document";
  if (type.startsWith("text/html") && !/\.html?$/i.test(base)) return `${base}.html`;
  return base;
}

export async function GET(req: Request, { params }: { params: Promise<{ docId: string }> }) {
  const me = await requireUser();
  const { docId } = await params;

  if (!storageConfigured()) {
    return NextResponse.json({ error: "Storage not configured" }, { status: 503 });
  }
  const doc = await prisma.staffDocument.findUnique({ where: { id: docId } });
  if (!doc || !doc.fileKey || doc.status === "VOID") {
    return NextResponse.json({ error: "Not found" }, { status: 404 });
  }

  let allowed = hasPermission(me, "documents.manage");
  if (!allowed && doc.employeeId) {
    const emp = await prisma.employee.findUnique({
      where: { userId: me.id },
      select: { id: true },
    });
    if (emp && emp.id === doc.employeeId) allowed = true; // owner
    else if (hasPermission(me, "employees.view")) allowed = true; // HR/EXEC viewer
  }
  if (!allowed && doc.candidateId && hasPermission(me, "recruitment.view")) allowed = true;
  if (!allowed) return NextResponse.redirect(new URL("/access-denied", req.url));

  await writeAudit({
    actorId: me.id,
    action: "stafdoc.download",
    entityType: "staff_document",
    entityId: doc.id,
  });

  const bytes = await downloadObject(doc.fileKey);
  const type = contentTypeFor(doc.contentType, doc.fileKey);
  return new Response(new Uint8Array(bytes), {
    headers: {
      "Content-Type": type,
      "Content-Disposition": `inline; filename="${filenameFor(doc.title, type)}"`,
      "Cache-Control": "private, no-store",
    },
  });
}
