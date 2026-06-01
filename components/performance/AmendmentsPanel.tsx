"use client";
import { useActionState, useState } from "react";
import {
  addAmendmentAction,
  addFollowupNoteAction,
  type FormState,
} from "@/lib/goal-agreement-actions";

const EMPTY: FormState = { ok: false };

type Amendment = {
  id: string;
  kind: string;
  body: string;
  newMeasure: string | null;
  newTarget: string | null;
  createdAt: string;
  by: string | null;
};

export default function AmendmentsPanel({
  employeeId,
  sealed,
  midCycleOpen,
  amendments,
  kinds,
  // who is viewing: a manager (full amend) or the employee (note only)
  asManager,
}: {
  employeeId: string;
  sealed: boolean;
  midCycleOpen: boolean;
  amendments: Amendment[];
  kinds: { value: string; label: string }[];
  asManager: boolean;
}) {
  const kindLabel = (k: string) => kinds.find((x) => x.value === k)?.label ?? k;

  return (
    <div className="card" style={{ marginBottom: 18 }}>
      <div className="card-h">
        <h3>Mid-cycle amendments</h3>
        <span className="hint">{amendments.length}</span>
      </div>
      <div className="card-pad">
        <p className="faint" style={{ marginTop: 0 }}>
          The original agreed goals stay sealed. Anything that changes mid-cycle — amend, expand, contract, a
          new goal, or a follow-up note — is added here as a dated entry. Nothing above is overwritten.
        </p>

        {amendments.length === 0 ? (
          <p className="faint">No amendments yet.</p>
        ) : (
          <div className="appr-list" style={{ marginBottom: 14 }}>
            {amendments.map((a) => (
              <div className="appr-ro" key={a.id}>
                <div className="appr-ro-h">
                  <span className="appr-kind">{kindLabel(a.kind)}</span>
                  <span className="faint" style={{ fontSize: 12, marginLeft: "auto" }}>
                    {a.createdAt}
                    {a.by ? ` · ${a.by}` : ""}
                  </span>
                </div>
                <div className="appr-ro-b">
                  <span>{a.body}</span>
                </div>
                {a.newMeasure || a.newTarget ? (
                  <div className="faint" style={{ fontSize: 12.5, marginTop: 4 }}>
                    {[a.newMeasure ? `New measure: ${a.newMeasure}` : null, a.newTarget ? `New target: ${a.newTarget}` : null]
                      .filter(Boolean)
                      .join(" · ")}
                  </div>
                ) : null}
              </div>
            ))}
          </div>
        )}

        {!sealed ? (
          <p className="faint" style={{ marginTop: 0 }}>
            Amendments open once the goals are sealed.
          </p>
        ) : !midCycleOpen ? (
          <p className="faint" style={{ marginTop: 0 }}>
            Amendments open at the Mid-cycle stage.
          </p>
        ) : asManager ? (
          <ManagerAmend employeeId={employeeId} kinds={kinds.filter((k) => k.value !== "NOTE")} />
        ) : (
          <EmployeeNote />
        )}
      </div>
    </div>
  );
}

function ManagerAmend({
  employeeId,
  kinds,
}: {
  employeeId: string;
  kinds: { value: string; label: string }[];
}) {
  const [state, action, pending] = useActionState(addAmendmentAction, EMPTY);
  const [open, setOpen] = useState(false);
  if (!open) {
    return (
      <button type="button" className="btn btn-pri" onClick={() => setOpen(true)}>
        Add amendment
      </button>
    );
  }
  return (
    <form action={action} className="appr-item" style={{ borderTop: "1px solid var(--line)" }}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="appr-fields">
        <div className="field">
          <label>Type</label>
          <select name="kind" defaultValue="AMEND">
            {kinds.map((k) => (
              <option key={k.value} value={k.value}>
                {k.label}
              </option>
            ))}
          </select>
        </div>
        <div className="field full">
          <label>What changed / what was agreed</label>
          <textarea name="body" rows={3} placeholder="Describe the amendment and why it was agreed" />
        </div>
        <div className="field">
          <label>New measure (optional)</label>
          <input name="newMeasure" placeholder="If the KPI changed" />
        </div>
        <div className="field">
          <label>New target (optional)</label>
          <input name="newTarget" placeholder="If the target changed" />
        </div>
      </div>
      <div style={{ display: "flex", gap: 8, marginTop: 10 }}>
        <button type="submit" className="btn btn-pri" disabled={pending}>
          {pending ? "Adding…" : "Add to record"}
        </button>
        <button type="button" className="btn" onClick={() => setOpen(false)}>
          Cancel
        </button>
      </div>
    </form>
  );
}

function EmployeeNote() {
  const [state, action, pending] = useActionState(addFollowupNoteAction, EMPTY);
  const [open, setOpen] = useState(false);
  if (!open) {
    return (
      <button type="button" className="btn" onClick={() => setOpen(true)}>
        Add a follow-up note
      </button>
    );
  }
  return (
    <form action={action} className="appr-item" style={{ borderTop: "1px solid var(--line)" }}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="field full">
        <label>Follow-up note</label>
        <textarea name="body" rows={3} placeholder="Note something for the record (e.g. a follow-up discussion)" />
      </div>
      <div style={{ display: "flex", gap: 8, marginTop: 10 }}>
        <button type="submit" className="btn btn-pri" disabled={pending}>
          {pending ? "Adding…" : "Add note"}
        </button>
        <button type="button" className="btn" onClick={() => setOpen(false)}>
          Cancel
        </button>
      </div>
    </form>
  );
}
