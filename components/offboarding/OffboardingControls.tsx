"use client";
import { useActionState } from "react";
import {
  openOffboardingAction,
  updateOffboardingFieldsAction,
  setOffboardingTaskStatusAction,
  setOffboardingFlagAction,
  revokeAccessAction,
  closeOffboardingAction,
  cancelOffboardingAction,
  reopenOffboardingAction,
  type FormState,
} from "@/lib/offboarding-actions";

const EMPTY: FormState = { ok: false };

const EXIT_OPTS: { v: string; l: string }[] = [
  { v: "RESIGNATION", l: "Resignation" },
  { v: "DISMISSAL", l: "Dismissal (conduct / capability)" },
  { v: "REDUNDANCY", l: "Redundancy" },
  { v: "RETIREMENT", l: "Retirement" },
  { v: "END_OF_TERM", l: "End of fixed term / contract" },
  { v: "NON_CONFIRMATION", l: "End of probation (not confirmed)" },
];

export function OpenOffboardingForm({
  employees,
}: {
  employees: { id: string; eeId: string; name: string; status: string }[];
}) {
  const [state, formAction, pending] = useActionState(openOffboardingAction, EMPTY);
  return (
    <form action={formAction}>
      <div className="two-col" style={{ gap: 10, alignItems: "end" }}>
        <label className="field" style={{ display: "block", flex: 1 }}>
          <span className="faint" style={{ fontSize: 12 }}>Employee</span>
          <select name="employeeId" defaultValue="">
            <option value="" disabled>Choose someone…</option>
            {employees.map((e) => (
              <option key={e.id} value={e.id}>{e.eeId} · {e.name}</option>
            ))}
          </select>
        </label>
        <label className="field" style={{ display: "block" }}>
          <span className="faint" style={{ fontSize: 12 }}>Type of exit</span>
          <select name="exitType" defaultValue="RESIGNATION">
            {EXIT_OPTS.map((o) => <option key={o.v} value={o.v}>{o.l}</option>)}
          </select>
        </label>
      </div>
      <div className="two-col" style={{ gap: 10, marginTop: 10 }}>
        <label className="field" style={{ display: "block" }}>
          <span className="faint" style={{ fontSize: 12 }}>Notice received</span>
          <input type="date" name="noticeReceivedAt" />
        </label>
        <label className="field" style={{ display: "block" }}>
          <span className="faint" style={{ fontSize: 12 }}>Last working day</span>
          <input type="date" name="lastWorkingDay" />
        </label>
      </div>
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Reason / note (optional)</span>
        <input type="text" name="reason" />
      </label>
      <div style={{ marginTop: 12 }}>
        <button className="btn" type="submit" disabled={pending}>
          {pending ? "Opening…" : "Open exit case"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function OffboardingFieldsForm({
  employeeId, noticeReceivedAt, lastWorkingDay, reason, note,
}: {
  employeeId: string; noticeReceivedAt: string; lastWorkingDay: string; reason: string; note: string;
}) {
  const [state, formAction, pending] = useActionState(updateOffboardingFieldsAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <div className="two-col" style={{ gap: 10 }}>
        <label className="field" style={{ display: "block" }}>
          <span className="faint" style={{ fontSize: 12 }}>Notice received</span>
          <input type="date" name="noticeReceivedAt" defaultValue={noticeReceivedAt} />
        </label>
        <label className="field" style={{ display: "block" }}>
          <span className="faint" style={{ fontSize: 12 }}>Last working day</span>
          <input type="date" name="lastWorkingDay" defaultValue={lastWorkingDay} />
        </label>
      </div>
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Reason</span>
        <input type="text" name="reason" defaultValue={reason} />
      </label>
      <label className="field" style={{ display: "block", marginTop: 10 }}>
        <span className="faint" style={{ fontSize: 12 }}>Note</span>
        <textarea name="note" rows={2} defaultValue={note} />
      </label>
      <div style={{ marginTop: 12 }}>
        <button className="btn" type="submit" disabled={pending}>{pending ? "Saving…" : "Save details"}</button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function TaskStatusControl({ employeeId, taskId, status }: { employeeId: string; taskId: string; status: string }) {
  const [state, formAction, pending] = useActionState(setOffboardingTaskStatusAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline-flex", gap: 6, alignItems: "center" }}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <input type="hidden" name="taskId" value={taskId} />
      <select name="status" defaultValue={status} disabled={pending}>
        <option value="PENDING">Pending</option>
        <option value="DONE">Done</option>
        <option value="NA">N/A</option>
      </select>
      <button className="btn btn-sm" type="submit" disabled={pending}>Set</button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function FlagToggle({ employeeId, flag, value, label }: { employeeId: string; flag: string; value: boolean; label: string }) {
  const [state, formAction, pending] = useActionState(setOffboardingFlagAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline-flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <input type="hidden" name="flag" value={flag} />
      <input type="hidden" name="value" value={value ? "false" : "true"} />
      <button className="btn btn-sm" type="submit" disabled={pending}>
        {value ? `✓ ${label}` : `Mark ${label}`}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function RevokeAccessControl({ employeeId, alreadyRevoked }: { employeeId: string; alreadyRevoked: boolean }) {
  const [state, formAction, pending] = useActionState(revokeAccessAction, EMPTY);
  if (alreadyRevoked) {
    return <span className="b b-grn">Access revoked ✓</span>;
  }
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 13 }}>
        <input type="checkbox" name="confirm" value="REVOKE" required />
        I confirm: disable the login and clear all roles now.
      </label>
      <div style={{ marginTop: 10 }}>
        <button className="btn btn-danger" type="submit" disabled={pending}>
          {pending ? "Revoking…" : "Revoke access"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function CloseCaseControl({ employeeId, accessRevoked }: { employeeId: string; accessRevoked: boolean }) {
  const [state, formAction, pending] = useActionState(closeOffboardingAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {!accessRevoked ? (
        <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 13, marginBottom: 8 }}>
          <input type="checkbox" name="waiveAccess" value="true" />
          Access not revoked through the portal — waive (recorded in the audit log).
        </label>
      ) : null}
      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 13 }}>
        <input type="checkbox" name="confirm" value="CLOSE" required />
        I confirm: mark the employee exited, crystallize any sponsorship repayment, and close.
      </label>
      <div style={{ marginTop: 10 }}>
        <button className="btn btn-danger" type="submit" disabled={pending}>
          {pending ? "Closing…" : "Mark exited & close"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function CancelCaseControl({ employeeId }: { employeeId: string }) {
  const [state, formAction, pending] = useActionState(cancelOffboardingAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <label className="field" style={{ display: "block", marginBottom: 8 }}>
        <span className="faint" style={{ fontSize: 12 }}>Reason (optional)</span>
        <input type="text" name="reason" placeholder="e.g. opened in error; resignation retracted" />
      </label>
      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 13 }}>
        <input type="checkbox" name="confirm" value="CANCEL" required />
        Cancel this exit. The employee is not exited; any revoked access stays revoked.
      </label>
      <div style={{ marginTop: 10 }}>
        <button className="btn" type="submit" disabled={pending}>
          {pending ? "Cancelling…" : "Cancel exit"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}

export function ReopenCaseControl({ employeeId, wasClosed }: { employeeId: string; wasClosed: boolean }) {
  const [state, formAction, pending] = useActionState(reopenOffboardingAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {wasClosed ? (
        <div className="note" style={{ marginTop: 0, marginBottom: 8 }}>
          <span>⚠</span>
          <div>Reopening reverses the exit: the employee returns to ACTIVE and any repayment crystallized at close (still pending/waived) is reverted. Revoked logins are not re-enabled — re-grant roles in User Management.</div>
        </div>
      ) : null}
      <label style={{ display: "flex", gap: 8, alignItems: "center", fontSize: 13 }}>
        <input type="checkbox" name="confirm" value="REOPEN" required />
        I confirm: reopen this case{wasClosed ? " and reinstate the employee" : ""}.
      </label>
      <div style={{ marginTop: 10 }}>
        <button className="btn btn-danger" type="submit" disabled={pending}>
          {pending ? "Reopening…" : "Reopen case"}
        </button>
        {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
      </div>
    </form>
  );
}
