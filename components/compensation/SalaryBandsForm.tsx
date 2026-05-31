"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import { saveSalaryBandsAction, type FormState } from "@/lib/compensation-actions";

// Dynamic-row editor for the salary-band structure. Rows are serialized to a
// hidden JSON input (the action reads `bands`). Same pattern as ScorecardForm.
type BandInput = { grade: string; label: string; min: string; midpoint: string; max: string };
type InitialBand = { grade: string; label: string; min: number; midpoint: number; max: number };

const EMPTY: FormState = { ok: false };

function blankRow(): BandInput {
  return { grade: "", label: "", min: "", midpoint: "", max: "" };
}

export default function SalaryBandsForm({ initial }: { initial: InitialBand[] }) {
  const [state, formAction, pending] = useActionState(saveSalaryBandsAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  const [rows, setRows] = useState<BandInput[]>(() =>
    initial.length
      ? initial.map((b) => ({
          grade: b.grade,
          label: b.label,
          min: String(b.min),
          midpoint: String(b.midpoint),
          max: String(b.max),
        }))
      : [blankRow()]
  );

  const serialized = JSON.stringify(
    rows.map((r) => ({
      grade: r.grade,
      label: r.label,
      min: r.min,
      midpoint: r.midpoint,
      max: r.max,
    }))
  );

  function update(i: number, patch: Partial<BandInput>) {
    setRows((rs) => rs.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));
  }
  function addRow() {
    setRows((rs) => [...rs, blankRow()]);
  }
  function removeRow(i: number) {
    setRows((rs) => (rs.length <= 1 ? [blankRow()] : rs.filter((_, idx) => idx !== i)));
  }

  return (
    <form action={formAction}>
      <input type="hidden" name="bands" value={serialized} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card mt">
        <div className="card-h">
          <h3>Edit salary bands</h3>
          <span className="hint">one row per grade · saving replaces the whole structure</span>
        </div>
        <div className="card-pad">
          {fe.bands ? <div className="form-err" style={{ marginBottom: 10 }}>{fe.bands}</div> : null}
          <div className="comp-band-rows">
            <div className="comp-band-head">
              <span>Grade</span>
              <span>Band name</span>
              <span>Min (₦)</span>
              <span>Midpoint (₦)</span>
              <span>Max (₦)</span>
              <span />
            </div>
            {rows.map((r, i) => (
              <div className="comp-band-row" key={i}>
                <input
                  value={r.grade}
                  onChange={(e) => update(i, { grade: e.target.value })}
                  placeholder="G1"
                  aria-label={`Grade for band ${i + 1}`}
                />
                <input
                  value={r.label}
                  onChange={(e) => update(i, { label: e.target.value })}
                  placeholder="e.g. Officer"
                  aria-label={`Name for band ${i + 1}`}
                />
                <input
                  value={r.min}
                  onChange={(e) => update(i, { min: e.target.value })}
                  placeholder="e.g. 300,000"
                  inputMode="numeric"
                  aria-label={`Minimum for band ${i + 1}`}
                />
                <input
                  value={r.midpoint}
                  onChange={(e) => update(i, { midpoint: e.target.value })}
                  placeholder="e.g. 450,000"
                  inputMode="numeric"
                  aria-label={`Midpoint for band ${i + 1}`}
                />
                <input
                  value={r.max}
                  onChange={(e) => update(i, { max: e.target.value })}
                  placeholder="e.g. 600,000"
                  inputMode="numeric"
                  aria-label={`Maximum for band ${i + 1}`}
                />
                <button
                  type="button"
                  className="sc-remove"
                  onClick={() => removeRow(i)}
                  aria-label={`Remove band ${i + 1}`}
                >
                  ×
                </button>
              </div>
            ))}
          </div>
          <button type="button" className="btn sc-add" onClick={addRow}>
            + Add band
          </button>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/compensation/bands" className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save salary bands"}
        </button>
      </div>
    </form>
  );
}
