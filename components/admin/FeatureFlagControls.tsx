"use client";
import { useActionState } from "react";
import { setFeatureFlagAction, type SettingsActionState } from "@/lib/settings-actions";

const EMPTY: SettingsActionState = { ok: false };

export default function FeatureFlagControls({
  flagKey,
  enabled,
  label,
  description,
}: {
  flagKey: string;
  enabled: boolean;
  label: string;
  description: string;
}) {
  const [state, action, pending] = useActionState(setFeatureFlagAction, EMPTY);
  const next = enabled ? "false" : "true";

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "flex-start",
        gap: 16,
        padding: "14px 0",
        borderTop: "1px solid var(--line, #e7e2d9)",
      }}
    >
      <div style={{ maxWidth: 560 }}>
        <div style={{ fontWeight: 600, fontSize: 13.5 }}>{label}</div>
        <p className="faint" style={{ fontSize: 12, marginTop: 4 }}>
          {description}
        </p>
        {state.error ? (
          <span className="err">{state.error}</span>
        ) : null}
        {state.ok && state.message ? (
          <span className="faint" style={{ color: "#1c6b3c", fontSize: 12 }}>
            {"\u2713 "}
            {state.message}
          </span>
        ) : null}
      </div>
      <div style={{ display: "flex", alignItems: "center", gap: 12, flexShrink: 0 }}>
        <span
          className="chip"
          style={{
            background: enabled ? "var(--gold-soft, #fbf3d6)" : "transparent",
            fontVariant: "small-caps",
          }}
        >
          {enabled ? "On" : "Off"}
        </span>
        <form action={action}>
          <input type="hidden" name="key" value={flagKey} />
          <input type="hidden" name="enabled" value={next} />
          <button
            type="submit"
            disabled={pending}
            style={{
              padding: "7px 14px",
              borderRadius: 8,
              border: "1px solid var(--navy, #1c2b46)",
              background: enabled ? "transparent" : "var(--navy, #1c2b46)",
              color: enabled ? "var(--navy, #1c2b46)" : "#fff",
              fontWeight: 600,
              fontSize: 13,
              cursor: pending ? "default" : "pointer",
              opacity: pending ? 0.6 : 1,
            }}
          >
            {pending ? "Saving..." : enabled ? "Turn off" : "Turn on"}
          </button>
        </form>
      </div>
    </div>
  );
}
