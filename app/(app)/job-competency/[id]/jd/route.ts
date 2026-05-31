import { NextResponse } from "next/server";
import { requirePermission } from "@/lib/auth/rbac";
import { getLatestDocument } from "@/lib/documents";
import { signedUrl, storageConfigured } from "@/lib/storage";

// GET /job-competency/[id]/jd — redirects to a short-lived signed URL for the
// profile's current job-description file. Permission is enforced here (route
// handlers aren't wrapped by the app layout), so the private object is only
// reachable by someone who may view the framework.
export async function GET(
  _req: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  await requirePermission("jobframework.view");
  const { id } = await params;

  if (!storageConfigured()) {
    return NextResponse.json({ error: "Storage not configured" }, { status: 503 });
  }
  const doc = await getLatestDocument("job_profile", id, "JOB_DESCRIPTION");
  if (!doc) {
    return NextResponse.json({ error: "No job description on file" }, { status: 404 });
  }
  const url = await signedUrl(doc.path, 120);
  return NextResponse.redirect(url);
}
