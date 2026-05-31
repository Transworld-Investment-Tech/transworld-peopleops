"use client";
import { useActionState } from "react";
import {
  uploadJobDescriptionAction,
  removeJobDescriptionAction,
  type DocState,
} from "@/lib/documents-actions";

const EMPTY: DocState = { ok: false };

export default function JobDescriptionCard({
  profileId,
  canManage,
  doc,
  storageReady,
}: {
  profileId: string;
  canManage: boolean;
  doc: { filename: string; sizeLabel: string; uploadedAt: string } | null;
  storageReady: boolean;
}) {
  const [upState, upAction, upPending] = useActionState(uploadJobDescriptionAction, EMPTY);
  const [rmState, rmAction, rmPending] = useActionState(removeJobDescriptionAction, EMPTY);

  return (
    <div className="card mt">
      <div className="card-h">
        <h3>Job description</h3>
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
              variables (<code>SUPABASE_URL</code>, <code>SUPABASE_SERVICE_ROLE_KEY</code>) to
              enable uploads.
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
                href={`/job-competency/${profileId}/jd`}
                target="_blank"
                rel="noopener noreferrer"
              >
                {doc.filename}
              </a>
              <span className="doc-sub">
                {doc.sizeLabel}
                {doc.uploadedAt ? ` · uploaded ${doc.uploadedAt}` : ""}
              </span>
            </div>
            {canManage ? (
              <form action={rmAction} className="doc-actions">
                <input type="hidden" name="entityId" value={profileId} />
                <button className="btn" type="submit" disabled={rmPending}>
                  {rmPending ? "Removing…" : "Remove"}
                </button>
              </form>
            ) : null}
          </div>
        ) : (
          <p className="faint" style={{ marginTop: 0 }}>
            No job description on file.
          </p>
        )}

        {canManage && storageReady ? (
          <form action={upAction} className="doc-upload">
            <input type="hidden" name="entityId" value={profileId} />
            <input
              type="file"
              name="file"
              accept=".pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
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
