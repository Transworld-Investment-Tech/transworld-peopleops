"use client";

import { useActionState } from "react";
import { openRoundAction, type FormState } from "@/lib/bonus-round-actions";

const initial: FormState = { ok: false };

export default function OpenRoundForm({
  defaultYear,
  eligibleCount,
  skipped,
  appraisalCycles,
}: {
  defaultYear: number;
  eligibleCount: number;
  skipped: { eeId: string; name: string; reason: string }[];
  appraisalCycles: { id: string; name: string }[];
}) {
  const [state, action, pending] = useActionState(openRoundAction, initial);

  return (
    <form action={action}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      {state.ok && state.message ? (
        <div className="note"><span>✓</span><div>{state.message}</div></div>
      ) : null}

      <div className="form-grid">
        <div className="field">
          <label>Award year (performance year)</label>
          <input type="number" name="awardYear" defaultValue={defaultYear} min={2020} max={2100} />
        </div>
        <div className="field">
          <label>Profit before tax (PBT)</label>
          <input type="number" name="pbt" step="0.01" min={0} placeholder="e.g. 25000000" />
        </div>
        <div className="field">
          <label>Pool rate</label>
          <input type="number" name="poolRate" step="0.01" min={0} max={1} defaultValue={0.15} />
        </div>
        <div className="field">
          <label>Salary basis</label>
          <select name="salaryBasis" defaultValue="GROSS">
            <option value="GROSS">Gross (base + allowance ÷ 12)</option>
            <option value="BASIC">Basic only</option>
          </select>
        </div>
        <div className="field">
          <label>Appraisal cycle (multiplier reference, optional)</label>
          <select name="appraisalCycleId" defaultValue="">
            <option value="">— none —</option>
            {appraisalCycles.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
          </select>
        </div>
      </div>

      <p className="hint" style={{ marginTop: 12 }}>
        Carries every eligible employee (active, with a current compensation profile and a graded
        job profile) at a default ×1.0 multiplier. The pool is the pool rate × PBT. You then set
        each person&apos;s multiplier and the integrity gate, reconcile against the pool, and submit
        for approval. Payment is recorded for April {defaultYear + 1}.
      </p>

      {skipped.length > 0 ? (
        <div className="note" style={{ marginTop: 12 }}>
          <span>⚠</span>
          <div>
            <b>{skipped.length} staff will be skipped</b> (no grade on their job profile):{" "}
            {skipped.map((s, i) => <span key={s.eeId}>{i > 0 ? ", " : ""}{s.name} ({s.eeId})</span>)}
            . Set their grade under Job &amp; Competency first if they should be included.
          </div>
        </div>
      ) : null}

      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending || eligibleCount === 0}>
          {pending ? "Opening…" : `Open round (${eligibleCount} staff)`}
        </button>
      </div>
    </form>
  );
}
