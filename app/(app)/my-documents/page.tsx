import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getMyDocuments, statusBadge, sourceBadge, fmtDate, prettySize, DOC_CATEGORIES } from "@/lib/staff-documents";
import SignDocument from "@/components/documents/SignDocument";
import MyDocumentsUpload from "@/components/documents/MyDocumentsUpload";

export const metadata = { title: "My documents · Transworld PeopleOps" };

const uploadable = DOC_CATEGORIES.filter((c) => c.owner === "STAFF").map((c) => ({
  key: c.key,
  label: c.label,
}));

export default async function MyDocumentsPage() {
  const me = await requirePermission("documents.view_own");
  const data = await getMyDocuments(me.id);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My documents</h1>
          <p>Documents waiting for your signature, your uploads, and your records on file.</p>
        </div>
      </div>

      {!data.linked ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once it is, your documents
                will appear here.
              </div>
            </div>
          </div>
        </div>
      ) : (
        <>
          <div className="card">
            <div className="card-h">
              <h3>Awaiting your signature</h3>
              <span className="hint">{data.awaiting.length}</span>
            </div>
            <div className="card-pad">
              {data.awaiting.length === 0 ? (
                <p className="faint" style={{ marginTop: 0 }}>
                  Nothing to sign right now.
                </p>
              ) : (
                <div className="grid two-col">
                  {data.awaiting.map((d) => (
                    <div className="card" key={d.id} style={{ margin: 0 }}>
                      <div className="card-h">
                        <h3 style={{ fontSize: 15 }}>{d.title}</h3>
                        <span className="b b-amb">{d.category}</span>
                      </div>
                      <div className="card-pad">
                        <SignDocument docId={d.id} title={d.title} defaultName={data.employee.fullName} />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          <div className="card mt">
            <div className="card-h">
              <h3>Upload a personal document</h3>
              <span className="hint">ID, utility bill, résumé, bank, pension, TIN, next of kin</span>
            </div>
            <div className="card-pad">
              <MyDocumentsUpload categories={uploadable} />
            </div>
          </div>

          <div className="card mt">
            <div className="card-h">
              <h3>Your documents on file</h3>
              <span className="hint">{data.others.length}</span>
            </div>
            <div className="card-pad">
              {data.others.length === 0 ? (
                <p className="faint" style={{ marginTop: 0 }}>
                  Nothing on file yet.
                </p>
              ) : (
                <div className="doc-list">
                  {data.others.map((d) => {
                    const sb = statusBadge(d.status);
                    const src = sourceBadge(d.source);
                    return (
                      <div className="doc-row" key={d.id}>
                        <span className="doc-ic" aria-hidden>
                          📄
                        </span>
                        <div className="doc-meta">
                          {d.fileKey ? (
                            <a
                              className="doc-name"
                              href={`/staff-documents/${d.id}/file`}
                              target="_blank"
                              rel="noopener noreferrer"
                            >
                              {d.title}
                            </a>
                          ) : (
                            <span className="doc-name">{d.title}</span>
                          )}
                          <span className="doc-sub">
                            {d.category}
                            {d.sizeBytes ? ` · ${prettySize(d.sizeBytes)}` : ""} · {fmtDate(d.createdAt)}
                            {d.signedAt ? ` · signed ${fmtDate(d.signedAt)}` : ""}
                          </span>
                        </div>
                        <span className={`b ${src.cls}`}>{src.label}</span>
                        <span className={`b ${sb.cls}`}>{sb.label}</span>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          </div>

          <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
            Official documents (offer, contract, guarantor) are managed by HR. Need a change?{" "}
            <Link href="/leave" className="jc-link">
              Contact HR
            </Link>
            .
          </div>
        </>
      )}
    </>
  );
}
