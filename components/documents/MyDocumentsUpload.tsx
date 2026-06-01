"use client";
import { useActionState } from "react";
import { uploadOwnDocumentAction, type FormState } from "@/lib/staff-documents-actions";

const EMPTY: FormState = { ok: false };

export default function MyDocumentsUpload({
  categories,
}: {
  categories: { key: string; label: string }[];
}) {
  const [state, action, pending] = useActionState(uploadOwnDocumentAction, EMPTY);
  return (
    <form action={action} className="doc-upload">
      <select name="category" defaultValue="">
        <option value="" disabled>
          What is this?
        </option>
        {categories.map((c) => (
          <option key={c.key} value={c.key}>
            {c.label}
          </option>
        ))}
      </select>
      <input type="file" name="file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
      <input type="date" name="expiry" title="Expiry date (optional)" />
      <button className="btn btn-pri" type="submit" disabled={pending}>
        {pending ? "Uploading…" : "Upload"}
      </button>
      {state.error ? <div className="form-err" style={{ marginTop: 8 }}>{state.error}</div> : null}
      {state.ok && state.message ? (
        <div className="note" style={{ marginTop: 8 }}>
          <span>✓</span>
          <div>{state.message}</div>
        </div>
      ) : null}
    </form>
  );
}
