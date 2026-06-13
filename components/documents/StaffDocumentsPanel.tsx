"use client";
import { useActionState } from "react";
import {
  generateDocumentAction,
  uploadDocumentAction,
  voidDocumentAction,
  uploadSignedCopyAction,
  approveDocumentAction,
  rejectDocumentAction,
  deleteDocumentAction,
  type FormState,
} from "@/lib/staff-documents-actions";

const EMPTY: FormState = { ok: false };

export type DocView = {
  id: string;
  title: string;
  category: string;
  statusCls: string;
  statusLabel: string;
  sourceCls: string;
  sourceLabel: string;
  sizeLabel: string;
  createdAt: string;
  expiry: string | null;
  hasFile: boolean;
  isGeneratedDraft: boolean;
  awaiting: boolean;
  status: string;
  pending: boolean;
  signerName: string | null;
  signedAt: string | null;
};

export type TemplateOpt = { id: string; name: string; kindLabel: string };
export type CategoryOpt = { key: string; label: string };

export default function StaffDocumentsPanel({
  employeeId,
  canManage,
  canHardDelete,
  storageReady,
  docs,
  templates,
  categories,
}: {
  employeeId: string;
  canManage: boolean;
  canHardDelete: boolean;
  storageReady: boolean;
  docs: DocView[];
  templates: TemplateOpt[];
  categories: CategoryOpt[];
}) {
  const [genState, genAction, genPending] = useActionState(generateDocumentAction, EMPTY);
  const [upState, upAction, upPending] = useActionState(uploadDocumentAction, EMPTY);
  const [, voidAction, voidPending] = useActionState(voidDocumentAction, EMPTY);
  const [signedState, signedAction, signedPending] = useActionState(uploadSignedCopyAction, EMPTY);
  const [, approveAction, approvePending] = useActionState(approveDocumentAction, EMPTY);
  const [, rejectAction, rejectPending] = useActionState(rejectDocumentAction, EMPTY);
  const [, deleteAction, deletePending] = useActionState(deleteDocumentAction, EMPTY);

  return (
    <div className="card mt">
      <div className="card-h">
        <h3>Documents</h3>
        <span className="hint">{docs.length} on file</span>
      </div>
      <div className="card-pad">
        {!storageReady ? (
          <div className="note">
            <span>ℹ</span>
            <div>
              <b>File storage isn’t configured yet.</b> Add <code>SUPABASE_URL</code> and{" "}
              <code>SUPABASE_SERVICE_ROLE_KEY</code> to enable documents.
            </div>
          </div>
        ) : null}

        {docs.length === 0 ? (
          <p className="faint" style={{ marginTop: 0 }}>
            No documents on file yet.
          </p>
        ) : (
          <div className="doc-list">
            {docs.map((d) => (
              <div className="doc-row" key={d.id}>
                <span className="doc-ic" aria-hidden>
                  📄
                </span>
                <div className="doc-meta">
                  {d.hasFile ? (
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
                    {d.sizeLabel ? ` · ${d.sizeLabel}` : ""} · {d.createdAt}
                    {d.expiry ? ` · expires ${d.expiry}` : ""}
                    {d.signedAt ? ` · signed by ${d.signerName} on ${d.signedAt}` : ""}
                  </span>
                </div>
                <span className={`b ${d.sourceCls}`}>{d.sourceLabel}</span>
                <span className={`b ${d.statusCls}`}>{d.statusLabel}</span>
                {canManage && d.pending ? (
                  <>
                    <form action={approveAction} className="doc-actions">
                      <input type="hidden" name="docId" value={d.id} />
                      <button className="btn btn-pri" type="submit" disabled={approvePending}>
                        Approve
                      </button>
                    </form>
                    <form action={rejectAction} className="doc-actions">
                      <input type="hidden" name="docId" value={d.id} />
                      <button className="btn" type="submit" disabled={rejectPending}>
                        Reject
                      </button>
                    </form>
                  </>
                ) : null}
                {canManage && !d.pending ? (
                  <form action={voidAction} className="doc-actions">
                    <input type="hidden" name="docId" value={d.id} />
                    <button className="btn" type="submit" disabled={voidPending}>
                      Remove
                    </button>
                  </form>
                ) : null}
                {canHardDelete ? (
                  <form
                    action={deleteAction}
                    className="doc-actions"
                    onSubmit={(e) => {
                      if (
                        !window.confirm(
                          `Permanently delete “${d.title}”? This removes the file and the record and cannot be undone.`,
                        )
                      ) {
                        e.preventDefault();
                      }
                    }}
                  >
                    <input type="hidden" name="docId" value={d.id} />
                    <button
                      className="btn"
                      type="submit"
                      disabled={deletePending}
                      style={{ color: "var(--red, #b91c1c)" }}
                    >
                      Delete
                    </button>
                  </form>
                ) : null}
              </div>
            ))}
          </div>
        )}

        {/* Per-document: upload an externally-signed copy onto a draft */}
        {canManage &&
          storageReady &&
          docs.filter((d) => d.isGeneratedDraft).map((d) => (
            <form action={signedAction} className="doc-upload" key={`sign-${d.id}`} style={{ marginTop: 10 }}>
              <input type="hidden" name="docId" value={d.id} />
              <span className="faint" style={{ fontSize: 13 }}>
                Signed copy for “{d.title}”:
              </span>
              <input type="file" name="file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
              <button className="btn" type="submit" disabled={signedPending}>
                {signedPending ? "Uploading…" : "Upload signed copy"}
              </button>
            </form>
          ))}
        {signedState.error ? <div className="form-err" style={{ marginTop: 8 }}>{signedState.error}</div> : null}

        {canManage && storageReady ? (
          <>
            <div className="sec-t" style={{ marginTop: 18, marginBottom: 8 }}>
              Generate from a template
            </div>
            {templates.length === 0 ? (
              <p className="faint" style={{ marginTop: 0 }}>
                No active templates yet. Add one under Administration → Document Templates.
              </p>
            ) : (
              <form action={genAction} className="doc-upload">
                <input type="hidden" name="employeeId" value={employeeId} />
                <select name="templateId" defaultValue="">
                  <option value="" disabled>
                    Choose a template…
                  </option>
                  {templates.map((t) => (
                    <option key={t.id} value={t.id}>
                      {t.name} ({t.kindLabel})
                    </option>
                  ))}
                </select>
                <button className="btn btn-pri" type="submit" disabled={genPending}>
                  {genPending ? "Generating…" : "Generate"}
                </button>
              </form>
            )}
            {genState.error ? <div className="form-err" style={{ marginTop: 8 }}>{genState.error}</div> : null}
            {genState.ok && genState.message ? (
              <div className="note" style={{ marginTop: 8 }}>
                <span>✓</span>
                <div>{genState.message}</div>
              </div>
            ) : null}

            <div className="sec-t" style={{ marginTop: 18, marginBottom: 8 }}>
              Upload a file
            </div>
            <form action={upAction} className="doc-upload">
              <input type="hidden" name="employeeId" value={employeeId} />
              <select name="category" defaultValue="">
                <option value="" disabled>
                  Category…
                </option>
                {categories.map((c) => (
                  <option key={c.key} value={c.key}>
                    {c.label}
                  </option>
                ))}
              </select>
              <input type="file" name="file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
              <input type="date" name="expiry" title="Expiry date (optional)" />
              <button className="btn btn-pri" type="submit" disabled={upPending}>
                {upPending ? "Uploading…" : "Upload"}
              </button>
            </form>
            {upState.error ? <div className="form-err" style={{ marginTop: 8 }}>{upState.error}</div> : null}
          </>
        ) : null}
      </div>
    </div>
  );
}
