"use client";
import { useActionState, useState } from "react";
import {
  recordMidpointReviewAction,
  decideProbationOutcomeAction,
  type FormState,
} from "@/lib/probation-actions";

const EMPTY: FormState = { ok: false };

type DocOpt = { id: string; title: string; fileSlot: string | null };

function DocSelect({ docs, name, label }: { docs: DocOpt[]; name: string; label: string }) {
  if (docs.length === 0) return null;
  return (
    <label className="field" style={{ display: "block", marginTop: 10 }}>
      <span className="faint" style={{ fontSize: 12 }}>{label}</span>
      <select name={name} defaultValue="">
        <option value="">— file later —</option>
        {docs.map((d) => (
          <option key={d.id} value={d.id}>
            {d.title}{d.fileSlot ? ` (currently: ${d.fileSlot})` : ""}
          </option>
        ))}
      </select>
    </label>
  );
}

export function MidpointReviewForm({ employeeId, docs }: { employeeId: string; docs: DocOpt[] }) {
  const [state, formAction, pending] = useActionState(recordMidpointReviewAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <label className="field" style={{ display: "block" }}>
        <span className="faint" style={{ fontSize: 12 }}>Midpoint outcome</span>
        <select name="outcome" defaultValue="ON_TRACK">
          <option value="ON_TRACK">On track</option>
          <option value="CONCERNS">Concerns raised</option>
        </select>
      </label>
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Review held on</span>
        <input type="date" name="heldOn" />
      </label>
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Note (gaps named, expectations for the second half)</span>
        <textarea name="note" rows={3} />
      </label>
      <DocSelect docs={docs} name="staffDocumentId" label="File the signed Midpoint Review form (D6.2)" />
      <div style={{ marginTop: 12 }}>
        <button className="btn" type="submit" disabled={pending}>
          {pending ? "Recording…" : "Record midpoint review"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function FinalDecisionForm({ employeeId, docs }: { employeeId: string; docs: DocOpt[] }) {
  const [state, formAction, pending] = useActionState(decideProbationOutcomeAction, EMPTY);
  const [outcome, setOutcome] = useState("CONFIRM");
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <label className="field" style={{ display: "block" }}>
        <span className="faint" style={{ fontSize: 12 }}>End-of-probation decision (COO)</span>
        <select name="outcome" value={outcome} onChange={(e) => setOutcome(e.target.value)}>
          <option value="CONFIRM">Confirm — onto the performance cycle</option>
          <option value="EXTEND">Extend — defined period, written objectives</option>
          <option value="NON_CONFIRM">Do not confirm — opens an exit</option>
        </select>
      </label>
      {outcome === "EXTEND" ? (
        <label className="field" style={{ display: "block", marginTop: 10 }}>
          <span className="faint" style={{ fontSize: 12 }}>Extension runs to</span>
          <input type="date" name="extensionUntil" />
        </label>
      ) : null}
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Note (the basis for the decision)</span>
        <textarea name="note" rows={3} />
      </label>
      <DocSelect docs={docs} name="staffDocumentId" label="File the Probation Outcome letter (D6.2)" />
      {outcome === "NON_CONFIRM" ? (
        <div className="note" style={{ marginTop: 10 }}>
          <span>⚠</span>
          <div>Recording this opens an offboarding case (end of probation) and takes you there. Confirm with employment counsel before issuing the non-confirmation letter (Ops Manual D4.3).</div>
        </div>
      ) : null}
      <div style={{ marginTop: 12 }}>
        <button className="btn" type="submit" disabled={pending}>
          {pending ? "Recording…" : "Record decision"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}
