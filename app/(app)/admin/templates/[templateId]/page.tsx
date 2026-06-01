import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getTemplate } from "@/lib/document-templates";
import TemplateEditorForm from "@/components/documents/TemplateEditorForm";

export const metadata = { title: "Edit template · Transworld PeopleOps" };

export default async function EditTemplatePage({
  params,
}: {
  params: Promise<{ templateId: string }>;
}) {
  await requirePermission("documents.manage");
  const { templateId } = await params;
  const t = await getTemplate(templateId);
  if (!t) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/admin/templates" className="back-link">
            ← Document templates
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {t.name}
          </h1>
        </div>
      </div>
      <div className="card">
        <div className="card-pad">
          <TemplateEditorForm
            template={{
              id: t.id,
              name: t.name,
              kind: t.kind,
              bodyHtml: t.bodyHtml,
              requiresSignature: t.requiresSignature,
              isActive: t.isActive,
            }}
          />
        </div>
      </div>
    </>
  );
}
