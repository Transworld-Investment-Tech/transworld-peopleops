"use client";
import { useActionState, useState } from "react";
import {
  updateCycleAction,
  deleteCycleAction,
  type FormState,
} from "@/lib/performance-actions";

const EMPTY: FormState = { ok: false };

const confirmInputStyle = {
  fontFamily: "inherit",
  fontSize: 13,
  padding: "7px 10px",
  border: "1px solid var(--line)",
  borderRadius: 8,
  background: "#fff",
  color: "var(--ink)",
  outline: "none",
};

export default function CycleControls({
  cycle,
  stages,
  statuses,
}: {
  cycle: { id: string; name: string; stage: string; status: string };
  stages: { value: string; label: string }[];
  statuses: { value: string; label: string }[];
}) {
  const [state, formAction, pending] = useActionState(updateCycleAction, EMPTY);
  const [delState, delAction, delPending] = useActionState(deleteCycleAction, EMPTY);
  const [showDelete, setShowDelete] = useState(false);
  const [confirmName, setConfirmName] = useState("");

  return (
    <div>
      <form action={formAction}>
        <div className="cyc-controls">
          <input type="hidden" name="cycleId" value={cycle.id} />
          <label className="cyc-ctl">
            <span className="faint">Stage</span>
            <select name="stage" defaultValue={cycle.stage}>
              {stages.map((s) => (
                <option key={s.value} value={s.value}>
                  {s.label}
                </option>
              ))}
            </select>
          </label>
          <label className="cyc-ctl">
            <span className="faint">Status</span>
            <select name="status" defaultValue={cycle.status}>
              {statuses.map((s) => (
                <option key={s.value} value={s.value}>
                  {s.label}
                </option>
              ))}
            </select>
          </label>
          <button className="btn" type="submit" disabled={pending}>
            {pending ? "Saving…" : "Update"}
          </button>
        </div>
        {state.error ? <div className="form-err" style={{ marginTop: 8 }}>{state.error}</div> : null}
      </form>

      <div style={{ marginTop: 10 }}>
        {!showDelete ? (
          <button
            type="button"
            className="btn"
            style={{ color: "var(--red)", borderColor: "var(--line)" }}
            onClick={() => setShowDelete(true)}
          >
            Delete cycle…
          </button>
        ) : (
          <form action={delAction}>
            <div style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
              <input type="hidden" name="cycleId" value={cycle.id} />
              <span className="faint">
                Type <b>{cycle.name}</b> to delete this cycle and all its appraisals:
              </span>
              <input
                name="confirmName"
                value={confirmName}
                onChange={(e) => setConfirmName(e.target.value)}
                placeholder={cycle.name}
                aria-label="Confirm cycle name"
                style={confirmInputStyle}
              />
              <button
                type="submit"
                className="btn"
                style={{ color: "var(--red)", borderColor: "var(--red)" }}
                disabled={delPending || confirmName.trim() !== cycle.name}
              >
                {delPending ? "Deleting…" : "Confirm delete"}
              </button>
              <button
                type="button"
                className="btn"
                onClick={() => {
                  setShowDelete(false);
                  setConfirmName("");
                }}
              >
                Cancel
              </button>
            </div>
            {delState.error ? <div className="form-err" style={{ marginTop: 8 }}>{delState.error}</div> : null}
          </form>
        )}
      </div>
    </div>
  );
}
