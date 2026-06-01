"use client";
import { useActionState } from "react";
import {
  generateDocumentAction,
  uploadDocumentAction,
  type FormState,
} from "@/lib/staff-documents-actions";

const EMPTY: FormState = { ok: false };

export type DocLite = { id: string; title: string; statusCls: string; statusLabel: string; hasFile: boolean };
export type TemplateOpt = { id: string; name: string; kindLabel: string };

export default function GenerateDocControl({
  employeeId,
  candidateId,
  templates,
  docs,
  allowUpload,
}: {
  employeeId?: string;
  candidateId?: string;
  templates: TemplateOpt[];
  docs?: DocLite[];
  allowUpload?: boolean;
}) {
  const [genState, genAction, genPending] = useActionState(generateDocumentAction, EMPTY);
  const [upState, upAction, upPending] = useActionState(uploadDocumentAction, EMPTY);

  return (
    <div>
      {docs && docs.length ? (
        <div className="doc-list" style={{ marginBottom: 10 }}>
          {docs.map((d) => (
            <div className="doc-row" key={d.id}>
              <span className="doc-ic" aria-hidden>
                📄
              </span>
              <div className="doc-meta">
                {d.hasFile ? (
                  <a className="doc-name" href={`/staff-documents/${d.id}/file`} target="_blank" rel="noopener noreferrer">
                    {d.title}
                  </a>
                ) : (
                  <span className="doc-name">{d.title}</span>
                )}
              </div>
              <span className={`b ${d.statusCls}`}>{d.statusLabel}</span>
            </div>
          ))}
        </div>
      ) : null}

      {templates.length === 0 ? (
        <p className="faint" style={{ marginTop: 0, fontSize: 13 }}>
          No active templates. Add one under Administration → Document Templates.
        </p>
      ) : (
        <form action={genAction} className="doc-upload">
          {employeeId ? <input type="hidden" name="employeeId" value={employeeId} /> : null}
          {candidateId ? <input type="hidden" name="candidateId" value={candidateId} /> : null}
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

      {allowUpload && candidateId ? (
        <form action={upAction} className="doc-upload" style={{ marginTop: 10 }}>
          <input type="hidden" name="candidateId" value={candidateId} />
          <input type="hidden" name="category" value="Other HR document" />
          <input type="file" name="file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
          <button className="btn" type="submit" disabled={upPending}>
            {upPending ? "Uploading…" : "Upload a file"}
          </button>
          {upState.error ? <div className="form-err" style={{ marginTop: 8 }}>{upState.error}</div> : null}
        </form>
      ) : null}
    </div>
  );
}
