"use client";
import { useActionState } from "react";
import { managerReviewLeaveAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

// Line-manager review. Two named buttons (RECOMMEND / DECLINE) post the same
// action with an optional note; HR then takes the final decision.
export default function LeaveManagerReview({ requestId }: { requestId: string }) {
  const [state, formAction, pending] = useActionState(managerReviewLeaveAction, EMPTY);

  return (
    <form action={formAction} className="comp-review">
      <input type="hidden" name="requestId" value={requestId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="field">
        <label htmlFor={`mn-${requestId}`}>Manager note (optional)</label>
        <textarea
          id={`mn-${requestId}`}
          name="managerNote"
          rows={2}
          placeholder="Context for HR — cover arrangements, timing, etc."
        />
      </div>

      <div className="comp-review-actions">
        <button
          type="submit"
          name="decision"
          value="DECLINE"
          className="btn"
          style={{ color: "var(--red)", borderColor: "var(--line)" }}
          disabled={pending}
        >
          {pending ? "Working…" : "Decline"}
        </button>
        <button
          type="submit"
          name="decision"
          value="RECOMMEND"
          className="btn btn-grn"
          disabled={pending}
        >
          {pending ? "Working…" : "Recommend to HR"}
        </button>
      </div>
    </form>
  );
}
