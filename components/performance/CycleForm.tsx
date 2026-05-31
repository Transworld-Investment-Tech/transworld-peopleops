"use client";
import { useActionState } from "react";
import Link from "next/link";
import { createCycleAction, type FormState } from "@/lib/performance-actions";

const EMPTY: FormState = { ok: false };

export default function CycleForm({
  stages,
}: {
  stages: { value: string; label: string }[];
}) {
  const [state, formAction, pending] = useActionState(createCycleAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="card">
        <div className="card-h">
          <h3>Cycle details</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field full">
              <label htmlFor="name">Cycle name</label>
              <input id="name" name="name" placeholder="e.g. Q2 2026" />
              {fe.name ? <span className="err">{fe.name}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="periodStart">Period start (optional)</label>
              <input id="periodStart" name="periodStart" type="date" />
            </div>
            <div className="field">
              <label htmlFor="periodEnd">Period end (optional)</label>
              <input id="periodEnd" name="periodEnd" type="date" />
            </div>
            <div className="field">
              <label htmlFor="stage">Starting stage</label>
              <select id="stage" name="stage" defaultValue="GOAL_SETTING">
                {stages.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/performance" className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Opening…" : "Open cycle"}
        </button>
      </div>
    </form>
  );
}
