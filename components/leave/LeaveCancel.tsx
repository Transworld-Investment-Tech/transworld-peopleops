"use client";
import { useActionState, useState } from "react";
import { cancelLeaveAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

export default function LeaveCancel({ requestId }: { requestId: string }) {
  const [state, formAction, pending] = useActionState(cancelLeaveAction, EMPTY);
  const [confirm, setConfirm] = useState(false);

  if (!confirm) {
    return (
      <button
        type="button"
        className="btn"
        style={{ color: "var(--red)", borderColor: "var(--line)" }}
        onClick={() => setConfirm(true)}
      >
        Cancel request
      </button>
    );
  }

  return (
    <form
      action={formAction}
      style={{ display: "inline-flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}
    >
      <input type="hidden" name="requestId" value={requestId} />
      <span className="faint">Cancel this pending request?</span>
      <button
        type="submit"
        className="btn"
        style={{ color: "var(--red)", borderColor: "var(--red)" }}
        disabled={pending}
      >
        {pending ? "Cancelling…" : "Confirm"}
      </button>
      <button type="button" className="btn" onClick={() => setConfirm(false)}>
        Keep
      </button>
      {state.error ? (
        <span className="form-err" style={{ margin: 0 }}>
          {state.error}
        </span>
      ) : null}
    </form>
  );
}
