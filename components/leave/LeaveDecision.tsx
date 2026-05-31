"use client";
import { useActionState } from "react";
import { decideLeaveAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

// HR final decision. Approving applies the day count to the employee's balance.
// When the approver is also the requester (HR admin's own leave), v1 allows it
// and the audit log records a self-approval.
export default function LeaveDecision({
  requestId,
  selfApproval = false,
}: {
  requestId: string;
  selfApproval?: boolean;
}) {
  const [state, formAction, pending] = useActionState(decideLeaveAction, EMPTY);

  return (
    <form action={formAction} className="comp-review">
      <input type="hidden" name="requestId" value={requestId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="field">
        <label htmlFor={`dn-${requestId}`}>Decision note (optional)</label>
        <textarea
          id={`dn-${requestId}`}
          name="decisionNote"
          rows={2}
          placeholder="Context for the approval or rejection."
        />
      </div>

      {selfApproval ? (
        <p className="comp-selfapprove">
          You raised this request. In v1 the same person may approve it; the audit log records
          this as a self-approval.
        </p>
      ) : null}

      <div className="comp-review-actions">
        <button
          type="submit"
          name="decision"
          value="REJECT"
          className="btn"
          style={{ color: "var(--red)", borderColor: "var(--line)" }}
          disabled={pending}
        >
          {pending ? "Working…" : "Reject"}
        </button>
        <button type="submit" name="decision" value="APPROVE" className="btn btn-grn" disabled={pending}>
          {pending ? "Working…" : "Approve & apply"}
        </button>
      </div>
    </form>
  );
}
