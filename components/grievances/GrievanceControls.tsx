"use client";
import { useActionState } from "react";
import {
  raiseGrievanceAction,
  acknowledgeGrievanceAction,
  recordFindingAction,
  recordAppealAction,
  closeGrievanceAction,
  type FormState,
} from "@/lib/grievance-actions";

const EMPTY: FormState = { ok: false };
function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}
function Notes({ s }: { s: FormState }) {
  return (
    <>
      {s.error && <div className="form-err">{s.error}</div>}
      {s.ok && s.message && (
        <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
          <span>✓</span>
          <div>{s.message}</div>
        </div>
      )}
    </>
  );
}

const FINDINGS = [
  { value: "SUBSTANTIATED", label: "Substantiated" },
  { value: "PARTIALLY_SUBSTANTIATED", label: "Partially substantiated" },
  { value: "NOT_SUBSTANTIATED", label: "Not substantiated" },
];

export function RaiseGrievanceForm({ respondents }: { respondents: { id: string; eeId: string; fullName: string }[] }) {
  const [state, action, pending] = useActionState(raiseGrievanceAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      <Notes s={state} />
      <div className="form-grid">
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="gr-subject">Subject</label>
          <input id="gr-subject" name="subject" placeholder="A short summary of your grievance" />
          <Err msg={fe.subject} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="gr-details">Details</label>
          <textarea id="gr-details" name="details" rows={5} placeholder="What happened, when, and what resolution you’re seeking" />
          <Err msg={fe.details} />
        </div>
        <div className="field">
          <label htmlFor="gr-resp">Person named (optional)</label>
          <select id="gr-resp" name="respondentId" defaultValue="">
            <option value="">— not about a specific person</option>
            {respondents.map((r) => (<option key={r.id} value={r.id}>{r.fullName} · {r.eeId}</option>))}
          </select>
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Submitting…" : "Submit grievance"}</button>
      </div>
      <p className="faint" style={{ fontSize: 12, marginTop: 4 }}>
        Your grievance is confidential. The person named is given a chance to respond but never sees your letter or the names of any witnesses.
      </p>
    </form>
  );
}

export function AcknowledgeForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(acknowledgeGrievanceAction, EMPTY);
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Acknowledge receipt"}</button>
    </form>
  );
}

export function FindingForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(recordFindingAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="gr-investigator">Investigator</label>
          <input id="gr-investigator" name="investigatorName" placeholder="Who investigated (e.g. COO)" />
          <Err msg={fe.investigatorName} />
        </div>
        <div className="field">
          <label htmlFor="gr-finding">Finding</label>
          <select id="gr-finding" name="finding" defaultValue="">
            <option value="" disabled>Select…</option>
            {FINDINGS.map((f) => (<option key={f.value} value={f.value}>{f.label}</option>))}
          </select>
          <Err msg={fe.finding} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="gr-summary">Finding summary</label>
          <textarea id="gr-summary" name="findingSummary" rows={4} placeholder="What was investigated, the evidence reviewed, and the finding" />
          <Err msg={fe.findingSummary} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="gr-action">Recommended action (optional)</label>
          <input id="gr-action" name="recommendedAction" />
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "Recording…" : "Record finding & communicate"}</button>
      </div>
    </form>
  );
}

export function AppealForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(recordAppealAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <div className="field">
        <label htmlFor="gr-appeal">Appeal outcome</label>
        <textarea id="gr-appeal" name="appealOutcome" rows={3} placeholder="The outcome of the appeal (heard by COO or MD)" />
        <Err msg={fe.appealOutcome} />
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Record appeal outcome"}</button>
      </div>
    </form>
  );
}

export function CloseGrievanceForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(closeGrievanceAction, EMPTY);
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Close grievance"}</button>
    </form>
  );
}
