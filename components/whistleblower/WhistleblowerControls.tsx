"use client";
import { useActionState } from "react";
import {
  submitReportAction,
  assignHandlerAction,
  recordWbInvestigationAction,
  recordWbOutcomeAction,
  acknowledgeReporterAction,
  type FormState,
} from "@/lib/whistleblower-actions";

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

const CATEGORIES = [
  { value: "FRAUD", label: "Fraud" },
  { value: "REGULATORY", label: "Regulatory breach" },
  { value: "FINANCIAL_MISCONDUCT", label: "Financial misconduct" },
  { value: "UNETHICAL_CONDUCT", label: "Unethical conduct" },
  { value: "HEALTH_SAFETY", label: "Health & safety" },
  { value: "RETALIATION", label: "Retaliation" },
  { value: "OTHER", label: "Other" },
];
const STATUSES = [
  { value: "INVESTIGATING", label: "Investigating" },
  { value: "SUBSTANTIATED", label: "Substantiated" },
  { value: "NOT_SUBSTANTIATED", label: "Not substantiated" },
  { value: "CLOSED", label: "Closed" },
];

export function ReportForm() {
  const [state, action, pending] = useActionState(submitReportAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      <Notes s={state} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="wb-cat">Category</label>
          <select id="wb-cat" name="category" defaultValue="">
            <option value="" disabled>Select…</option>
            {CATEGORIES.map((c) => (<option key={c.value} value={c.value}>{c.label}</option>))}
          </select>
          <Err msg={fe.category} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="wb-summary">What is your concern?</label>
          <textarea id="wb-summary" name="summary" rows={5} placeholder="Describe what you saw or believe happened. You don’t need proof — specifics help an investigation." />
          <Err msg={fe.summary} />
        </div>
        <div className="field">
          <label><input type="checkbox" name="involvesSeniorManagement" /> This involves senior management</label>
          <span className="hint">Routes the report to the Chairman / BARC Chair, not the Compliance Officer.</span>
        </div>
        <div className="field">
          <label><input type="checkbox" name="isAnonymous" /> Report anonymously</label>
          <span className="hint">Your identity will not be recorded. You’ll get a reference to follow up.</span>
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Submitting…" : "Submit report"}</button>
      </div>
      <p className="faint" style={{ fontSize: 12, marginTop: 4 }}>
        Retaliation against anyone who reports in good faith is treated as a disciplinary matter of the highest severity.
      </p>
    </form>
  );
}

export function AssignHandlerForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(assignHandlerAction, EMPTY);
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Take ownership"}</button>
    </form>
  );
}

export function WbInvestigationForm({ id, current }: { id: string; current: string | null }) {
  const [state, action, pending] = useActionState(recordWbInvestigationAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <div className="field">
        <label htmlFor="wb-inv">Investigation summary</label>
        <textarea id="wb-inv" name="investigationSummary" rows={4} defaultValue={current ?? ""} />
        <Err msg={fe.investigationSummary} />
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Save investigation"}</button>
      </div>
    </form>
  );
}

export function WbOutcomeForm({ id }: { id: string }) {
  const [state, action, pending] = useActionState(recordWbOutcomeAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="wb-status">Status / outcome</label>
          <select id="wb-status" name="status" defaultValue="">
            <option value="" disabled>Select…</option>
            {STATUSES.map((s) => (<option key={s.value} value={s.value}>{s.label}</option>))}
          </select>
          <Err msg={fe.status} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="wb-outcome">Outcome notes</label>
          <input id="wb-outcome" name="outcome" />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="wb-action">Action taken</label>
          <input id="wb-action" name="actionTaken" />
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Record outcome"}</button>
      </div>
    </form>
  );
}

export function AcknowledgeReporterForm({ id, anonymous }: { id: string; anonymous: boolean }) {
  const [state, action, pending] = useActionState(acknowledgeReporterAction, EMPTY);
  if (anonymous) return <span className="faint">Anonymous — no reporter to acknowledge.</span>;
  return (
    <form action={action}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Acknowledge to reporter"}</button>
    </form>
  );
}
