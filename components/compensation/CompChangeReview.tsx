"use client";
import { useActionState } from "react";
import { decideRequestAction, type FormState } from "@/lib/compensation-actions";

const EMPTY: FormState = { ok: false };

// Exec sign-off control. Two named decision buttons (APPROVE / REJECT) write the
// same action; the optional note is recorded with the decision. When the current
// viewer also raised the request, a self-approval caption is shown — v1 allows it
// (only the SUPER_ADMIN login exists) and the audit entry is stamped accordingly.
export default function CompChangeReview({
  requestId,
  selfApproval = false,
}: {
  requestId: string;
  selfApproval?: boolean;
}) {
  const [state, formAction, pending] = useActionState(decideRequestAction, EMPTY);

  return (
    <form action={formAction} className="comp-review">
      <input type="hidden" name="requestId" value={requestId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="field">
        <label htmlFor="decisionNote">Decision note (optional)</label>
        <textarea id="decisionNote" name="decisionNote" rows={2} placeholder="Context for the approval or rejection." />
      </div>

      {selfApproval ? (
        <p className="comp-selfapprove">
          You raised this request. In v1 the same person may approve it; the audit log records this as a
          self-approval.
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
        <button
          type="submit"
          name="decision"
          value="APPROVE"
          className="btn btn-grn"
          disabled={pending}
        >
          {pending ? "Working…" : "Approve & apply"}
        </button>
      </div>
    </form>
  );
}
