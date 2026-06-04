"use client";
import { useActionState } from "react";
import { addDependentAction, removeDependentAction, type FormState } from "@/lib/employees-actions";

const EMPTY: FormState = { ok: false };

const RELATIONSHIPS = [
  { value: "SPOUSE", label: "Spouse" },
  { value: "CHILD", label: "Child" },
  { value: "PARENT", label: "Parent" },
  { value: "SIBLING", label: "Sibling" },
  { value: "OTHER", label: "Other" },
];

export type DependentView = {
  id: string;
  fullName: string;
  relationshipLabel: string;
  dateOfBirth: string | null; // already formatted for display
};

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function DependentsEditor({
  employeeId,
  dependents,
  canManage,
}: {
  employeeId: string;
  dependents: DependentView[];
  canManage: boolean;
}) {
  const [state, formAction, pending] = useActionState(addDependentAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <div className="card mt">
      <div className="card-h">
        <h3>Dependents</h3>
        <span className="hint">{dependents.length}</span>
      </div>
      <div className="card-pad">
        {dependents.length === 0 ? (
          <span className="faint">No dependents recorded.</span>
        ) : (
          <div className="doc-list">
            {dependents.map((d) => (
              <div className="row" key={d.id}>
                <span>
                  {d.fullName} <span className="faint">· {d.relationshipLabel}</span>
                  {d.dateOfBirth ? <span className="faint"> · {d.dateOfBirth}</span> : null}
                </span>
                {canManage ? (
                  <form action={removeDependentAction}>
                    <input type="hidden" name="id" value={d.id} />
                    <input type="hidden" name="employeeId" value={employeeId} />
                    <button className="btn btn-xs btn-danger" type="submit">Remove</button>
                  </form>
                ) : null}
              </div>
            ))}
          </div>
        )}

        {canManage ? (
          <form action={formAction} style={{ marginTop: dependents.length ? 14 : 4 }}>
            {state.error && <div className="form-err">{state.error}</div>}
            <input type="hidden" name="employeeId" value={employeeId} />
            <div className="form-grid">
              <div className="field">
                <label htmlFor="dep-fullName">Name</label>
                <input id="dep-fullName" name="fullName" placeholder="Full name" />
                <Err msg={fe.fullName} />
              </div>
              <div className="field">
                <label htmlFor="dep-relationship">Relationship</label>
                <select id="dep-relationship" name="relationship" defaultValue="">
                  <option value="" disabled>Select…</option>
                  {RELATIONSHIPS.map((r) => (
                    <option key={r.value} value={r.value}>{r.label}</option>
                  ))}
                </select>
                <Err msg={fe.relationship} />
              </div>
              <div className="field">
                <label htmlFor="dep-dob">Date of birth</label>
                <input id="dep-dob" name="dateOfBirth" type="date" />
              </div>
              <div className="field">
                <label htmlFor="dep-note">Note</label>
                <input id="dep-note" name="note" placeholder="Optional" />
              </div>
            </div>
            <div className="form-actions">
              <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>
                {pending ? "Adding…" : "Add dependent"}
              </button>
            </div>
          </form>
        ) : null}
      </div>
    </div>
  );
}
