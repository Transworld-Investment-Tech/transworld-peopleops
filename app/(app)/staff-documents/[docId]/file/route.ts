import { NextResponse } from "next/server";
import { requireUser, hasPermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { signedUrl, storageConfigured } from "@/lib/storage";
import { writeAudit } from "@/lib/auth/audit";

// GET /staff-documents/[docId]/file — redirects to a short-lived signed URL for
// the document's stored file. Access is enforced here (route handlers aren't
// wrapped by the app layout): HR who can manage documents, the staff member the
// document belongs to, or a permitted viewer of the host record.
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
  const url = await signedUrl(doc.fileKey, 120);
  return NextResponse.redirect(url);
}
