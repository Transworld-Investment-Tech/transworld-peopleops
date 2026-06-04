"use client";
import { useActionState } from "react";
import {
  openCalibrationAction,
  recordCalibrationEntryAction,
  finalizeCalibrationAction,
  type FormState,
} from "@/lib/calibration-actions";

const EMPTY: FormState = { ok: false };
const RATINGS = [
  { value: "EXCEEDS", label: "Exceeds" },
  { value: "MEETS", label: "Meets" },
  { value: "BELOW", label: "Below" },
  { value: "NA", label: "N/A" },
];
function Notes({ s }: { s: FormState }) {
  return (
    <>
      {s.error && <div className="form-err">{s.error}</div>}
      {s.ok && s.message && (
        <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
          <span>✓</span><div>{s.message}</div>
        </div>
      )}
    </>
  );
}

export function OpenCalibrationForm({ cycleId }: { cycleId: string }) {
  const [state, action, pending] = useActionState(openCalibrationAction, EMPTY);
  return (
    <form action={action}>
      <Notes s={state} />
      <input type="hidden" name="cycleId" value={cycleId} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="cal-chair">Chair (COO)</label>
          <input id="cal-chair" name="chairName" placeholder="Session chair" />
        </div>
        <div className="field">
          <label htmlFor="cal-held">Session date</label>
          <input id="cal-held" name="heldAt" type="date" />
        </div>
      </div>
      <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Generating…" : "Open session / generate pack"}</button>
    </form>
  );
}

export function CalibrationEntryForm({
  id,
  defaults,
  disabled,
}: {
  id: string;
  defaults: { calibratedRating: string; calibratedMultiplier: string; integrityGate: boolean; note: string };
  disabled: boolean;
}) {
  const [state, action, pending] = useActionState(recordCalibrationEntryAction, EMPTY);
  return (
    <form action={action}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <input type="hidden" name="id" value={id} />
      <div style={{ display: "flex", gap: 8, alignItems: "flex-end", flexWrap: "wrap" }}>
        <div className="field" style={{ minWidth: 120 }}>
          <label>Calibrated rating</label>
          <select name="calibratedRating" defaultValue={defaults.calibratedRating} disabled={disabled}>
            <option value="">—</option>
            {RATINGS.map((r) => (<option key={r.value} value={r.value}>{r.label}</option>))}
          </select>
        </div>
        <div className="field" style={{ minWidth: 110 }}>
          <label>Multiplier</label>
          <input name="calibratedMultiplier" defaultValue={defaults.calibratedMultiplier} placeholder="e.g. 1.00" disabled={disabled} />
        </div>
        <label style={{ fontSize: 13, display: "flex", gap: 6, alignItems: "center", paddingBottom: 8 }}>
          <input type="checkbox" name="integrityGate" defaultChecked={defaults.integrityGate} disabled={disabled} /> Integrity gate (×0)
        </label>
        <div className="field" style={{ flex: 1, minWidth: 160 }}>
          <label>Note</label>
          <input name="note" defaultValue={defaults.note} disabled={disabled} />
        </div>
        {!disabled ? (
          <button className="btn btn-xs" type="submit" disabled={pending} style={{ marginBottom: 8 }}>{pending ? "…" : "Save"}</button>
        ) : null}
      </div>
    </form>
  );
}

export function FinalizeCalibrationForm({ sessionId, finalized }: { sessionId: string; finalized: boolean }) {
  const [state, action, pending] = useActionState(finalizeCalibrationAction, EMPTY);
  if (finalized) {
    return <span className="b b-grn">Finalized — agreed ratings written back</span>;
  }
  return (
    <form action={action}>
      <Notes s={state} />
      <input type="hidden" name="sessionId" value={sessionId} />
      <div className="field">
        <label htmlFor="cal-chair2">Chair (COO) — confirm</label>
        <input id="cal-chair2" name="chairName" placeholder="Session chair" />
      </div>
      <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Finalizing…" : "Finalize calibration"}</button>
      <p className="faint" style={{ fontSize: 11.5, marginTop: 6 }}>
        Finalizing writes each agreed rating back to the employee’s appraisal overall rating. Confidential — not shared with employees.
      </p>
    </form>
  );
}
