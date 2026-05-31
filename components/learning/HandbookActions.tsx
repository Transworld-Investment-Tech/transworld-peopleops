"use client";
import { useActionState } from "react";
import {
  acknowledgeHandbookAction,
  recordAckAction,
  type FormState,
} from "@/lib/learning-actions";

const EMPTY: FormState = { ok: false };

export function AcknowledgeButton({
  policyId,
  acknowledged,
  linked,
}: {
  policyId: string;
  acknowledged: boolean;
  linked: boolean;
}) {
  const [state, formAction, pending] = useActionState(acknowledgeHandbookAction, EMPTY);

  if (acknowledged) {
    return (
      <span className="b b-grn">
        <span className="dot" />
        You acknowledged this version
      </span>
    );
  }
  return (
    <div>
      <form action={formAction}>
        <input type="hidden" name="policyId" value={policyId} />
        <button className="btn btn-pri" type="submit" disabled={pending || !linked}>
          {pending ? "Recording…" : "I acknowledge I have read this handbook"}
        </button>
      </form>
      {!linked ? (
        <p className="faint" style={{ marginTop: 8 }}>
          Acknowledgment becomes available once your login is linked to your employee record.
        </p>
      ) : null}
      {state.error ? (
        <div className="form-err" style={{ marginTop: 10 }}>
          {state.error}
        </div>
      ) : null}
    </div>
  );
}

export function RecordAckButton({
  policyId,
  employeeId,
}: {
  policyId: string;
  employeeId: string;
}) {
  const [state, formAction, pending] = useActionState(recordAckAction, EMPTY);
  return (
    <form action={formAction} className="ln-rec-actions">
      <input type="hidden" name="policyId" value={policyId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      <button className="btn" type="submit" disabled={pending}>
        {pending ? "…" : "Record acknowledgment"}
      </button>
      {state.error ? <span className="err">{state.error}</span> : null}
    </form>
  );
}
