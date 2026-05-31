import { NextResponse } from "next/server";
import { requirePermission } from "@/lib/auth/rbac";
import { getLatestDocument } from "@/lib/documents";
import { signedUrl, storageConfigured } from "@/lib/storage";
import { LEARNING_MATERIAL } from "@/lib/learning";

// GET /learning/modules/[moduleId]/material — redirects to a short-lived signed
// URL for the module's attached reading file. Permission is enforced here
// (route handlers aren't wrapped by the app layout).
export async function GET(
  _req: Request,
  { params }: { params: Promise<{ moduleId: string }> }
) {
  await requirePermission("learning.view");
  const { moduleId } = await params;

  if (!storageConfigured()) {
    return NextResponse.json({ error: "Storage not configured" }, { status: 503 });
  }
  const doc = await getLatestDocument("learning_module", moduleId, LEARNING_MATERIAL);
  if (!doc) {
    return NextResponse.json({ error: "No material on file" }, { status: 404 });
  }
  const url = await signedUrl(doc.path, 120);
  return NextResponse.redirect(url);
}
