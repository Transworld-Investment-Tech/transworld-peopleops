"use client";
import { useActionState } from "react";
import {
  changeOwnPasswordAction,
  type ChangePasswordState,
} from "@/lib/account-actions";

const EMPTY: ChangePasswordState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function ChangePasswordForm() {
  const [state, formAction, pending] = useActionState(changeOwnPasswordAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {state.error && <div className="form-err">{state.error}</div>}
      {state.ok && state.message && (
        <div
          className="note"
          style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}
        >
          <span>✓</span>
          <div>{state.message}</div>
        </div>
      )}

      <div className="card">
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="current">Current password</label>
              <input id="current" name="current" type="password" autoComplete="current-password" />
              <Err msg={fe.current} />
            </div>
            <div className="field">
              <label htmlFor="next">New password</label>
              <input id="next" name="next" type="password" autoComplete="new-password" />
              <Err msg={fe.next} />
            </div>
            <div className="field">
              <label htmlFor="confirm">Confirm new password</label>
              <input id="confirm" name="confirm" type="password" autoComplete="new-password" />
              <Err msg={fe.confirm} />
            </div>
          </div>
          <p className="faint" style={{ fontSize: 12.5, marginTop: 4 }}>
            Use at least 8 characters. Choose something only you know.
          </p>
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Updating…" : "Update password"}
        </button>
      </div>
    </form>
  );
}
