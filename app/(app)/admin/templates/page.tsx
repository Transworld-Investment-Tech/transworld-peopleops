import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getTemplates, kindLabel } from "@/lib/document-templates";

export const metadata = { title: "Document templates · Transworld PeopleOps" };

export default async function TemplatesPage() {
  await requirePermission("documents.manage");
  const templates = await getTemplates();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Document templates</h1>
          <p>Editable templates HR uses to generate staff documents (offer, contract, guarantor, next of kin).</p>
        </div>
        <Link href="/admin/templates/new" className="btn btn-pri">
          + New template
        </Link>
      </div>

      <div className="card">
        {templates.length === 0 ? (
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              No templates yet. Create one to start generating documents.
            </p>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Template</th>
                <th>Type</th>
                <th>Signature</th>
                <th>Status</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {templates.map((t) => (
                <tr key={t.id}>
                  <td>
                    <b>{t.name}</b>
                  </td>
                  <td>{kindLabel(t.kind)}</td>
                  <td>{t.requiresSignature ? "Required" : "Not required"}</td>
                  <td>
                    {t.isActive ? (
                      <span className="b b-grn">
                        <span className="dot" />
                        Active
                      </span>
                    ) : (
                      <span className="b b-gry">Inactive</span>
                    )}
                  </td>
                  <td>
                    <Link href={`/admin/templates/${t.id}`} className="btn" style={{ padding: "5px 10px" }}>
                      Edit
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
