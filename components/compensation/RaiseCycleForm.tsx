"use client";

import { useActionState } from "react";
import { openCycleAction, type FormState } from "@/lib/raise-cycle-actions";

const initial: FormState = { ok: false };

function isoDate(d: Date): string {
  return new Date(d).toISOString().slice(0, 10);
}

export default function RaiseCycleForm({
  eligibleCount,
  suggestedEffective,
}: {
  eligibleCount: number;
  suggestedEffective: Date;
}) {
  const [state, action, pending] = useActionState(openCycleAction, initial);

  return (
    <form action={action}>
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="form-grid">
        <div className="field">
          <label>Milestone name</label>
          <input type="text" name="milestoneLabel" placeholder="e.g. FY2026 Milestone 1 — ₦500m gross revenue" />
        </div>
        <div className="field">
          <label>Revenue target (₦)</label>
          <input type="number" name="revenueTarget" step="0.01" min={0} placeholder="e.g. 500000000" />
        </div>
        <div className="field">
          <label>Firm-wide raise (%)</label>
          <input type="number" name="raisePercent" step="0.01" min={0} max={100} placeholder="e.g. 5" />
        </div>
        <div className="field">
          <label>Effective date</label>
          <input type="date" name="effectiveDate" defaultValue={isoDate(suggestedEffective)} />
        </div>
        <div className="field">
          <label>Revenue to date (₦, optional — for the gap tracker)</label>
          <input type="number" name="revenueObserved" step="0.01" min={0} placeholder="latest CFO figure" />
        </div>
      </div>

      <p className="hint" style={{ marginTop: 12 }}>
        Carries every active employee with a current compensation profile and applies the same
        percentage to <b>every pay component</b> (basic, utility and quarterly), so each person&apos;s
        total annual compensation rises by exactly that percentage and the tax-efficient structure is
        preserved. You can then review band flags, exclude or cap individuals, confirm the milestone is
        hit, and submit for Remuneration Committee approval. Nothing is communicated or applied until
        the Committee approves.
      </p>

      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending || eligibleCount === 0}>
          {pending ? "Opening…" : `Open raise cycle (${eligibleCount} staff)`}
        </button>
      </div>
    </form>
  );
}
