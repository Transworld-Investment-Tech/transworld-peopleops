"use client";
import { useActionState } from "react";
import { acknowledgePipAction, type FormState } from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

export default function PipAcknowledge({
  pipId,
  defaultName,
  acknowledged,
  ackName,
  ackAtLabel,
}: {
  pipId: string;
  defaultName: string;
  acknowledged: boolean;
  ackName?: string | null;
  ackAtLabel?: string | null;
}) {
  const [state, action, pending] = useActionState(acknowledgePipAction, EMPTY);

  if (acknowledged || state.ok) {
    return (
      <div className="note">
        <span>✓</span>
        <div>
          <b>Acknowledged.</b>
          {ackName ? ` ${ackName}` : ""}
          {ackAtLabel ? ` · ${ackAtLabel}` : ""}
        </div>
      </div>
    );
  }

  return (
    <form action={action}>
      <input type="hidden" name="pipId" value={pipId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <p style={{ marginTop: 0 }}>
        Please confirm you have read and discussed this plan with your manager. Your acknowledgment is
        recorded with your name, the time, and your IP address.
      </p>
      <div className="field" style={{ maxWidth: 360 }}>
        <label>Type your full name to acknowledge</label>
        <input name="ackName" defaultValue={defaultName} placeholder="Your full name" />
      </div>
      <label style={{ display: "flex", gap: 8, alignItems: "flex-start", marginTop: 8 }}>
        <input type="checkbox" name="consent" value="1" />
        <span className="faint">
          I confirm I have read and discussed this performance improvement plan. Acknowledging does not
          waive any of my rights.
        </span>
      </label>
      <button type="submit" className="btn btn-pri" disabled={pending} style={{ marginTop: 12 }}>
        {pending ? "Recording…" : "Acknowledge plan"}
      </button>
    </form>
  );
}
