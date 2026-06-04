"use client";
import { useActionState } from "react";
import {
  commitAlertsAction,
  dismissAlertAction,
  resolveAlertAction,
  type FormState,
} from "@/lib/notifications-actions";

const EMPTY: FormState = { ok: false };

export function GenerateAlertsButton({ pendingCount }: { pendingCount: number }) {
  const [state, formAction, pending] = useActionState(commitAlertsAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 10, alignItems: "center" }}>
      <button className="btn btn-pri" type="submit" disabled={pending}>
        {pending ? "Generating…" : pendingCount > 0 ? `Generate ${pendingCount} alert${pendingCount === 1 ? "" : "s"}` : "Refresh alerts"}
      </button>
      {state.ok && typeof state.created === "number" ? (
        <span className="faint">Created {state.created} new alert{state.created === 1 ? "" : "s"}.</span>
      ) : null}
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function DismissButton({ id }: { id: string }) {
  const [state, formAction, pending] = useActionState(dismissAlertAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline" }}>
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs" type="submit" disabled={pending} title="Dismiss (not actioned)">
        {pending ? "…" : "Dismiss"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function ResolveButton({ id }: { id: string }) {
  const [state, formAction, pending] = useActionState(resolveAlertAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline", marginLeft: 6 }}>
      <input type="hidden" name="id" value={id} />
      <button className="btn btn-xs btn-grn" type="submit" disabled={pending} title="Resolved (actioned)">
        {pending ? "…" : "Resolve"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}
