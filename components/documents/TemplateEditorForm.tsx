"use client";
import { useActionState } from "react";
import {
  createTemplateAction,
  updateTemplateAction,
  type FormState,
} from "@/lib/staff-documents-actions";
import { TEMPLATE_KINDS, kindLabel, MERGE_FIELDS } from "@/lib/document-templates";

const EMPTY: FormState = { ok: false };

export default function TemplateEditorForm({
  template,
}: {
  template?: {
    id: string;
    name: string;
    kind: string;
    bodyHtml: string;
    requiresSignature: boolean;
    isActive: boolean;
  };
}) {
  const editing = Boolean(template);
  const [state, action, pending] = useActionState(
    editing ? updateTemplateAction : createTemplateAction,
    EMPTY
  );

  return (
    <form action={action}>
      {editing ? <input type="hidden" name="id" value={template!.id} /> : null}
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="grid two-col">
        <div className="field">
          <label htmlFor="name">Template name</label>
          <input id="name" name="name" defaultValue={template?.name ?? ""} placeholder="e.g. Offer letter (standard)" />
        </div>
        <div className="field">
          <label htmlFor="kind">Type</label>
          <select id="kind" name="kind" defaultValue={template?.kind ?? "OTHER"}>
            {TEMPLATE_KINDS.map((k) => (
              <option key={k} value={k}>
                {kindLabel(k)}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="field">
        <label htmlFor="bodyHtml">Document body</label>
        <textarea
          id="bodyHtml"
          name="bodyHtml"
          rows={16}
          defaultValue={template?.bodyHtml ?? ""}
          placeholder="Write the letter. Use merge fields like {{full_name}} and {{job_title}}."
          style={{ fontFamily: "ui-monospace,Menlo,Consolas,monospace", fontSize: 13, lineHeight: 1.5 }}
        />
      </div>

      <div className="note" style={{ marginBottom: 12 }}>
        <span>ℹ</span>
        <div>
          <b>Merge fields</b> — these are filled in automatically when you generate a document:
          <div style={{ marginTop: 6, display: "flex", flexWrap: "wrap", gap: "4px 12px" }}>
            {MERGE_FIELDS.map((f) => (
              <code key={f.token} title={f.note}>
                {f.token}
              </code>
            ))}
          </div>
        </div>
      </div>

      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 14, margin: "6px 0" }}>
        <input type="checkbox" name="requiresSignature" defaultChecked={template?.requiresSignature ?? true} />
        <span>Requires the staff member’s signature</span>
      </label>
      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 14, margin: "6px 0" }}>
        <input type="checkbox" name="isActive" defaultChecked={template?.isActive ?? true} />
        <span>Active (available to generate)</span>
      </label>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : editing ? "Save changes" : "Create template"}
        </button>
      </div>
    </form>
  );
}
