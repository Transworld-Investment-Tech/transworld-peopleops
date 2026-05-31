"use client";
import { useActionState } from "react";
import { updateCycleAction, type FormState } from "@/lib/performance-actions";

const EMPTY: FormState = { ok: false };

export default function CycleControls({
  cycle,
  stages,
  statuses,
}: {
  cycle: { id: string; stage: string; status: string };
  stages: { value: string; label: string }[];
  statuses: { value: string; label: string }[];
}) {
  const [state, formAction, pending] = useActionState(updateCycleAction, EMPTY);

  return (
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
  );
}
