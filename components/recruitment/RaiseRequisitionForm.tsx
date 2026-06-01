"use client";
import { useActionState } from "react";
import { raiseRequisitionAction, type FormState } from "@/lib/recruitment-actions";

const EMPTY: FormState = { ok: false };

export default function RaiseRequisitionForm({
  departments,
  jobProfiles,
}: {
  departments: { id: string; name: string }[];
  jobProfiles: { id: string; title: string; grade: string | null }[];
}) {
  const [state, formAction, pending] = useActionState(raiseRequisitionAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="field">
        <label htmlFor="title">Job title</label>
        <input id="title" name="title" placeholder="e.g. Settlement Support Officer" />
        {fe.title ? <div className="form-err">{fe.title}</div> : null}
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 14 }}>
        <div className="field">
          <label htmlFor="grade">Grade (optional)</label>
          <input id="grade" name="grade" placeholder="e.g. G2" />
        </div>
        <div className="field">
          <label htmlFor="headcount">Headcount</label>
          <input id="headcount" name="headcount" type="number" min={1} max={99} defaultValue={1} />
          {fe.headcount ? <div className="form-err">{fe.headcount}</div> : null}
        </div>
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 14 }}>
        <div className="field">
          <label htmlFor="departmentId">Department (optional)</label>
          <select id="departmentId" name="departmentId" defaultValue="">
            <option value="">—</option>
            {departments.map((d) => (
              <option key={d.id} value={d.id}>
                {d.name}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="jobProfileId">Job profile (optional)</label>
          <select id="jobProfileId" name="jobProfileId" defaultValue="">
            <option value="">—</option>
            {jobProfiles.map((p) => (
              <option key={p.id} value={p.id}>
                {p.title}
                {p.grade ? ` · ${p.grade}` : ""}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="field">
        <label htmlFor="notes">Notes (optional)</label>
        <textarea id="notes" name="notes" rows={2} placeholder="Context for this requisition." />
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Raising…" : "Raise requisition"}
        </button>
      </div>
    </form>
  );
}
