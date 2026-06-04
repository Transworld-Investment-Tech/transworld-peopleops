"use client";
import { useActionState } from "react";
import Link from "next/link";
import {
  openCaseAction,
  recordInvestigationAction,
  suspendAction,
  liftSuspensionAction,
  issueActionAction,
  recordResponseAction,
  recordAckAction,
  closeCaseAction,
  type FormState,
} from "@/lib/disciplinary-actions";

const EMPTY: FormState = { ok: false };
function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}
function Note({ s }: { s: FormState }) {
  if (s.error) return <div className="form-err">{s.error}</div>;
  return null;
}

const STAGE_OPTS = [
  { value: "INFORMAL_DISCUSSION", label: "Informal discussion", tier: "manage" },
  { value: "VERBAL_WARNING", label: "Verbal warning (COO sign-off)", tier: "approve" },
  { value: "WRITTEN_WARNING", label: "Written warning (COO sign-off)", tier: "approve" },
  { value: "FINAL_WRITTEN_WARNING", label: "Final written warning (MD/Chairman)", tier: "dismiss" },
  { value: "DISMISSAL", label: "Dismissal (MD/Chairman)", tier: "dismiss" },
] as const;

export function OpenCaseForm({ employees }: { employees: { id: string; eeId: string; fullName: string }[] }) {
  const [state, action, pending] = useActionState(openCaseAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      <Note s={state} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="dc-emp">Employee</label>
          <select id="dc-emp" name="employeeId" defaultValue="">
            <option value="" disabled>Select…</option>
            {employees.map((e) => (
              <option key={e.id} value={e.id}>{e.fullName} · {e.eeId}</option>
            ))}
          </select>
          <Err msg={fe.employeeId} />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="dc-concern">Conduct concern</label>
          <textarea id="dc-concern" name="concern" rows={3} placeholder="What happened — the breach of policy, standard or regulation" />
          <Err msg={fe.concern} />
        </div>
        <div className="field">
          <label><input type="checkbox" name="isRegulatory" /> Involves a regulatory obligation</label>
          <span className="hint">A final written warning here is retained permanently; Compliance is notified.</span>
        </div>
        <div className="field">
          <label><input type="checkbox" name="isGrossMisconduct" /> Suspected gross misconduct</label>
          <span className="hint">May warrant suspension on full pay while investigated.</span>
        </div>
      </div>
      <div className="form-actions">
        <Link href="/discipline" className="btn">Cancel</Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Opening…" : "Open case"}</button>
      </div>
    </form>
  );
}

export function InvestigationForm({ caseId, current }: { caseId: string; current: string | null }) {
  const [state, action, pending] = useActionState(recordInvestigationAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <div className="field">
        <label htmlFor="dc-inv">Investigation summary</label>
        <textarea id="dc-inv" name="summary" rows={4} defaultValue={current ?? ""} placeholder="Facts established, who was involved, evidence reviewed, the employee’s account" />
        <Err msg={fe.summary} />
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "Saving…" : "Save investigation"}</button>
      </div>
    </form>
  );
}

export function SuspendControl({ caseId, suspended }: { caseId: string; suspended: boolean }) {
  const [state, action, pending] = useActionState(suspendAction, EMPTY);
  if (suspended) {
    return (
      <form action={liftSuspensionAction}>
        <input type="hidden" name="caseId" value={caseId} />
        <button className="btn btn-xs" type="submit">Lift suspension</button>
      </form>
    );
  }
  return (
    <form action={action}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <div className="field">
        <label htmlFor="dc-susp">Suspend on full pay — expected end (optional)</label>
        <input id="dc-susp" name="suspensionEndsAt" type="date" />
        <span className="hint">A protective measure while the facts are established — not a punishment.</span>
      </div>
      <div className="form-actions">
        <button className="btn btn-danger btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Suspend"}</button>
      </div>
    </form>
  );
}

export function IssueActionForm({ caseId, canApprove, canDismiss }: { caseId: string; canApprove: boolean; canDismiss: boolean }) {
  const [state, action, pending] = useActionState(issueActionAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const opts = STAGE_OPTS.filter((o) =>
    o.tier === "manage" ? true : o.tier === "approve" ? canApprove : canDismiss
  );
  return (
    <form action={action}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="dc-stage">Stage</label>
          <select id="dc-stage" name="stage" defaultValue="">
            <option value="" disabled>Select…</option>
            {opts.map((o) => (<option key={o.value} value={o.value}>{o.label}</option>))}
          </select>
          <Err msg={fe.stage} />
        </div>
        <div className="field">
          <label htmlFor="dc-period">Improvement period (months)</label>
          <input id="dc-period" name="improvementPeriodMonths" type="number" min="0" placeholder="e.g. 3–6" />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="dc-std">Required standard</label>
          <input id="dc-std" name="requiredStandard" placeholder="The standard the employee must meet" />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="dc-cons">Consequence of further breach</label>
          <input id="dc-cons" name="consequence" placeholder="e.g. further breach may result in dismissal" />
        </div>
        <div className="field" style={{ gridColumn: "1 / -1" }}>
          <label htmlFor="dc-note">Note</label>
          <input id="dc-note" name="note" />
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>{pending ? "Issuing…" : "Issue & sign off"}</button>
      </div>
      <p className="faint" style={{ fontSize: 11.5, marginTop: 4 }}>
        Verbal/Written require COO sign-off; Final written &amp; Dismissal require the MD/Chairman. The signer must differ from the case preparer.
      </p>
    </form>
  );
}

export function ResponseForm({ caseId, actionId }: { caseId: string; actionId: string }) {
  const [state, action, pending] = useActionState(recordResponseAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action} style={{ marginTop: 6 }}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <input type="hidden" name="actionId" value={actionId} />
      <div className="field">
        <input name="employeeResponse" placeholder="Record the employee’s written response (within 5 working days)" />
        <Err msg={fe.employeeResponse} />
      </div>
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Save response"}</button>
    </form>
  );
}

export function AckForm({ caseId }: { caseId: string }) {
  const [state, action, pending] = useActionState(recordAckAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={action}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <div className="field">
        <label htmlFor="dc-ack">Acknowledged by (name)</label>
        <input id="dc-ack" name="ackName" placeholder="Employee name" />
        <Err msg={fe.ackName} />
      </div>
      <div className="form-actions">
        <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Record acknowledgment"}</button>
      </div>
    </form>
  );
}

export function CloseForm({ caseId }: { caseId: string }) {
  const [state, action, pending] = useActionState(closeCaseAction, EMPTY);
  return (
    <form action={action}>
      <Note s={state} />
      <input type="hidden" name="caseId" value={caseId} />
      <div className="field">
        <label htmlFor="dc-out">Outcome</label>
        <input id="dc-out" name="outcome" placeholder="Closing summary (optional)" />
      </div>
      <div className="form-actions">
        <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Close case"}</button>
      </div>
    </form>
  );
}
