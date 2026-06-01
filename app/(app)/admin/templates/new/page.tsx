import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import TemplateEditorForm from "@/components/documents/TemplateEditorForm";

export const metadata = { title: "New template · Transworld PeopleOps" };

export default async function NewTemplatePage() {
  await requirePermission("documents.manage");
  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/admin/templates" className="back-link">
            ← Document templates
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            New template
          </h1>
        </div>
      </div>
      <div className="card">
        <div className="card-pad">
          <TemplateEditorForm />
        </div>
      </div>
    </>
  );
}
