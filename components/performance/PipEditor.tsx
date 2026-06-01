"use client";
import { useActionState, useState } from "react";
import { openPipAction, type FormState } from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

type Row = { expectation: string; measure: string; targetDate: string };

export default function PipEditor({
  employees,
}: {
  employees: { id: string; eeId: string; name: string; role: string | null }[];
}) {
  const [state, action, pending] = useActionState(openPipAction, EMPTY);
  const [rows, setRows] = useState<Row[]>([{ expectation: "", measure: "", targetDate: "" }]);

  function update(i: number, patch: Partial<Row>) {
    setRows((rs) => rs.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));
  }
  function addRow() {
    setRows((rs) => [...rs, { expectation: "", measure: "", targetDate: "" }]);
  }
  function removeRow(i: number) {
    setRows((rs) => (rs.length > 1 ? rs.filter((_, idx) => idx !== i) : rs));
  }

  const itemsPayload = JSON.stringify(
    rows
      .filter((r) => r.expectation.trim().length > 0)
      .map((r) => ({ expectation: r.expectation, measure: r.measure, targetDate: r.targetDate }))
  );

  return (
    <form action={action} className="card">
      <input type="hidden" name="items" value={itemsPayload} />
      <div className="card-pad">
        {state.error ? <div className="form-err">{state.error}</div> : null}

        <div className="appr-fields">
          <div className="field full">
            <label>Employee</label>
            <select name="employeeId" defaultValue="" required>
              <option value="" disabled>
                Choose an employee…
              </option>
              {employees.map((e) => (
                <option key={e.id} value={e.id}>
                  {e.name} {e.role ? `· ${e.role}` : ""} (EID {e.eeId})
                </option>
              ))}
            </select>
            {state.fieldErrors?.employeeId ? <div className="form-err">{state.fieldErrors.employeeId}</div> : null}
          </div>
          <div className="field full">
            <label>Plan title</label>
            <input name="title" placeholder="e.g. Performance improvement plan — Q2 2026" required />
            {state.fieldErrors?.title ? <div className="form-err">{state.fieldErrors.title}</div> : null}
          </div>
          <div className="field full">
            <label>Performance concerns</label>
            <textarea name="concerns" rows={3} placeholder="Summarize the gaps that prompted this plan" />
            {state.fieldErrors?.concerns ? <div className="form-err">{state.fieldErrors.concerns}</div> : null}
          </div>
          <div className="field full">
            <label>Support to be provided (optional)</label>
            <textarea name="support" rows={2} placeholder="Coaching, training, resources, check-in cadence" />
          </div>
          <div className="field">
            <label>Start date</label>
            <input name="startDate" type="date" />
          </div>
          <div className="field">
            <label>Review date</label>
            <input name="reviewDate" type="date" />
          </div>
          <div className="field">
            <label>End date</label>
            <input name="endDate" type="date" />
          </div>
        </div>

        <div className="appr-sub" style={{ marginTop: 14 }}>Expectations to meet</div>
        {rows.map((r, i) => (
          <div className="appr-item" key={i}>
            <div className="appr-fields">
              <div className="field full">
                <label>Expectation {i + 1}</label>
                <input
                  value={r.expectation}
                  onChange={(e) => update(i, { expectation: e.target.value })}
                  placeholder="What the employee must demonstrate"
                />
              </div>
              <div className="field">
                <label>Measure</label>
                <input value={r.measure} onChange={(e) => update(i, { measure: e.target.value })} placeholder="How it's assessed" />
              </div>
              <div className="field">
                <label>Target date</label>
                <input type="date" value={r.targetDate} onChange={(e) => update(i, { targetDate: e.target.value })} />
              </div>
            </div>
            {rows.length > 1 ? (
              <button type="button" className="btn" onClick={() => removeRow(i)} style={{ marginTop: 8, color: "var(--red)" }}>
                Remove
              </button>
            ) : null}
          </div>
        ))}
        <button type="button" className="btn" onClick={addRow} style={{ marginTop: 4 }}>
          + Add expectation
        </button>

        <div style={{ marginTop: 16 }}>
          <button type="submit" className="btn btn-pri" disabled={pending}>
            {pending ? "Opening…" : "Open plan"}
          </button>
        </div>
      </div>
    </form>
  );
}
