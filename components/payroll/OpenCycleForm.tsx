"use client";

import { useActionState } from "react";
import { openCycleAction, type FormState } from "@/lib/payroll-cycle-actions";

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];

const initial: FormState = { ok: false };

export default function OpenCycleForm({
  defaultYear,
  defaultMonth,
  eligibleCount,
  skipped,
  disabled,
}: {
  defaultYear: number;
  defaultMonth: number;
  eligibleCount: number;
  skipped: { eeId: string; name: string; reason: string }[];
  disabled: boolean;
}) {
  const [state, action, pending] = useActionState(openCycleAction, initial);

  return (
    <form action={action}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      {state.ok && state.message ? (
        <div className="note"><span>✓</span><div>{state.message}</div></div>
      ) : null}

      <div className="form-grid">
        <div className="field">
          <label>Month</label>
          <select name="month" defaultValue={defaultMonth} disabled={disabled}>
            {MONTHS.map((m, i) => <option key={m} value={i + 1}>{m}</option>)}
          </select>
        </div>
        <div className="field">
          <label>Year</label>
          <input type="number" name="year" defaultValue={defaultYear} min={2020} max={2100} disabled={disabled} />
        </div>
      </div>

      <p className="hint" style={{ marginTop: 12 }}>
        Carries the current compensation profile for every active employee into the run and
        computes deductions. Quarter-end months (Jan/Apr/Jul/Oct) carry the quarterly lump and
        suppress monthly utility — adjust per row as needed.
      </p>

      {skipped.length > 0 ? (
        <div className="note" style={{ marginTop: 12 }}>
          <span>⚠</span>
          <div>
            <b>{skipped.length} staff will be skipped</b> (no current compensation profile):{" "}
            {skipped.map((s, i) => <span key={s.eeId}>{i > 0 ? ", " : ""}{s.name} ({s.eeId})</span>)}
            . Establish their profile under Compensation first if they should be paid.
          </div>
        </div>
      ) : null}

      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending || disabled || eligibleCount === 0}>
          {pending ? "Opening…" : `Open cycle (${eligibleCount} staff)`}
        </button>
      </div>
    </form>
  );
}
