"use client";
import { useActionState } from "react";
import { updateMyProfileAction, type ProfileState } from "@/lib/profile-actions";

const EMPTY: ProfileState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function ProfileForm({
  defaults,
}: {
  defaults: { preferredName: string; phone: string };
}) {
  const [state, formAction, pending] = useActionState(updateMyProfileAction, EMPTY);
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
              <label htmlFor="preferredName">Preferred name</label>
              <input
                id="preferredName"
                name="preferredName"
                type="text"
                defaultValue={defaults.preferredName}
                placeholder="What you’d like to be called"
                autoComplete="nickname"
              />
              <Err msg={fe.preferredName} />
            </div>
            <div className="field">
              <label htmlFor="phone">Phone</label>
              <input
                id="phone"
                name="phone"
                type="tel"
                defaultValue={defaults.phone}
                placeholder="e.g. 080 0000 0000"
                autoComplete="tel"
              />
              <Err msg={fe.phone} />
            </div>
          </div>
          <p className="faint" style={{ fontSize: 12.5, marginTop: 4 }}>
            Only your preferred name and phone are editable here. Everything else —
            work email, grade, department and bank details — is maintained by HR.
          </p>
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
