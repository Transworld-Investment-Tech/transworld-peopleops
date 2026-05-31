"use client";
import { useActionState } from "react";
import Link from "next/link";
import { saveHandbookAction, type FormState } from "@/lib/learning-actions";

const EMPTY: FormState = { ok: false };

export type HandbookFormInitial = {
  id: string | null;
  title: string;
  version: string;
  summary: string;
  effectiveDate: string;
  body: string;
  isCurrent: boolean;
};

export default function HandbookForm({ initial }: { initial: HandbookFormInitial }) {
  const [state, formAction, pending] = useActionState(saveHandbookAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {initial.id ? <input type="hidden" name="policyId" value={initial.id} /> : null}
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>{initial.id ? "Edit handbook version" : "New handbook version"}</h3>
          <span className="hint">staff read this in the portal and acknowledge it</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field full">
              <label>Title</label>
              <input name="title" defaultValue={initial.title} placeholder="Employee Handbook" />
              {fe.title ? <span className="err">{fe.title}</span> : null}
            </div>
            <div className="field">
              <label>Version</label>
              <input name="version" defaultValue={initial.version || "1.0"} placeholder="e.g. 2.0" />
              {fe.version ? <span className="err">{fe.version}</span> : null}
            </div>
            <div className="field">
              <label>Effective date (optional)</label>
              <input type="date" name="effectiveDate" defaultValue={initial.effectiveDate} />
            </div>
            <div className="field full">
              <label>Summary (optional)</label>
              <input name="summary" defaultValue={initial.summary} placeholder="One line shown above the handbook" />
              {fe.summary ? <span className="err">{fe.summary}</span> : null}
            </div>
            <div className="field full">
              <label>Handbook text (markdown)</label>
              <textarea
                name="body"
                defaultValue={initial.body}
                rows={20}
                placeholder={"## 1. Welcome\n\nWrite the handbook here using markdown."}
              />
              {fe.body ? <span className="err">{fe.body}</span> : null}
            </div>
            <div className="field full">
              <label style={{ display: "flex", gap: 8, alignItems: "center" }}>
                <input type="checkbox" name="makeCurrent" value="1" defaultChecked={initial.isCurrent || !initial.id} />
                Make this the current handbook (supersedes the previous version; staff re-acknowledge)
              </label>
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/learning/handbook" className="btn">Cancel</Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save handbook"}
        </button>
      </div>
    </form>
  );
}
