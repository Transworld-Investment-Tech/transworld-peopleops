"use client";
import { useActionState } from "react";
import {
  uploadMaterialAction,
  removeMaterialAction,
  type DocState,
} from "@/lib/learning-actions";

const EMPTY: DocState = { ok: false };

export default function MaterialCard({
  moduleId,
  doc,
  storageReady,
}: {
  moduleId: string;
  doc: { filename: string; sizeLabel: string } | null;
  storageReady: boolean;
}) {
  const [upState, upAction, upPending] = useActionState(uploadMaterialAction, EMPTY);
  const [rmState, rmAction, rmPending] = useActionState(removeMaterialAction, EMPTY);

  return (
    <div className="card mt">
      <div className="card-h">
        <h3>Attached material</h3>
        {doc ? (
          <span className="b b-grn">
            <span className="dot" />
            On file
          </span>
        ) : null}
      </div>
      <div className="card-pad">
        {!storageReady ? (
          <div className="note">
            <span>ℹ</span>
            <div>
              <b>File storage isn’t configured yet.</b> Add the Supabase Storage environment
              variables to enable optional slide/PDF attachments. The markdown body still works.
            </div>
          </div>
        ) : null}

        {doc ? (
          <div className="doc-row">
            <span className="doc-ic" aria-hidden>
              📄
            </span>
            <div className="doc-meta">
              <a
                className="doc-name"
                href={`/learning/modules/${moduleId}/material`}
                target="_blank"
                rel="noopener noreferrer"
              >
                {doc.filename}
              </a>
              <span className="doc-sub">{doc.sizeLabel}</span>
            </div>
            <form action={rmAction} className="doc-actions">
              <input type="hidden" name="moduleId" value={moduleId} />
              <button className="btn" type="submit" disabled={rmPending}>
                {rmPending ? "Removing…" : "Remove"}
              </button>
            </form>
          </div>
        ) : (
          <p className="faint" style={{ marginTop: 0 }}>
            No file attached. Optional — the in-portal reading content is the main material.
          </p>
        )}

        {storageReady ? (
          <form action={upAction} className="doc-upload">
            <input type="hidden" name="moduleId" value={moduleId} />
            <input
              type="file"
              name="file"
              accept=".pdf,.doc,.docx,.ppt,.pptx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation"
            />
            <button className="btn btn-pri" type="submit" disabled={upPending}>
              {upPending ? "Uploading…" : doc ? "Replace" : "Upload"}
            </button>
          </form>
        ) : null}

        {upState.error ? (
          <div className="form-err" style={{ marginTop: 10 }}>
            {upState.error}
          </div>
        ) : null}
        {rmState.error ? (
          <div className="form-err" style={{ marginTop: 10 }}>
            {rmState.error}
          </div>
        ) : null}
      </div>
    </div>
  );
}
