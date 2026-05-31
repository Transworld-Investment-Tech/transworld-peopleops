"use client";
import { useActionState } from "react";
import { saveLeaveTypeAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

function TypeRowForm({
  id,
  name,
  daysPerYear,
  usage,
}: {
  id?: string;
  name?: string;
  daysPerYear?: number;
  usage?: string;
}) {
  const [state, formAction, pending] = useActionState(saveLeaveTypeAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const isNew = !id;

  return (
    <form
      action={formAction}
      style={{ display: "flex", alignItems: "flex-end", gap: 10, flexWrap: "wrap", padding: "10px 0" }}
    >
      {id ? <input type="hidden" name="id" value={id} /> : null}
      <div className="field" style={{ flex: "1 1 220px", marginBottom: 0 }}>
        {isNew ? <label>New leave type</label> : null}
        <input name="name" type="text" defaultValue={name ?? ""} placeholder="e.g. Study Leave" />
        {fe.name ? <div className="form-err">{fe.name}</div> : null}
      </div>
      <div className="field" style={{ width: 140, marginBottom: 0 }}>
        {isNew ? <label>Default days / year</label> : null}
        <input
          name="daysPerYear"
          type="number"
          step="1"
          min="0"
          max="366"
          defaultValue={daysPerYear ?? 0}
          aria-label="Default days per year"
        />
      </div>
      <button type="submit" className="btn btn-pri" style={{ padding: "8px 14px" }} disabled={pending}>
        {pending ? "Saving…" : isNew ? "Add type" : "Save"}
      </button>
      {usage ? (
        <span className="faint" style={{ alignSelf: "center" }}>
          {usage}
        </span>
      ) : null}
      {state.error ? (
        <span className="form-err" style={{ margin: 0, alignSelf: "center" }}>
          {state.error}
        </span>
      ) : null}
    </form>
  );
}

export default function LeaveTypeEditor({
  types,
}: {
  types: { id: string; name: string; daysPerYear: number; balanceCount: number; requestCount: number }[];
}) {
  return (
    <div>
      {types.map((t, i) => (
        <div key={t.id} style={i > 0 ? { borderTop: "1px solid var(--line)" } : undefined}>
          <TypeRowForm
            id={t.id}
            name={t.name}
            daysPerYear={t.daysPerYear}
            usage={`${t.balanceCount} balance${t.balanceCount === 1 ? "" : "s"} · ${t.requestCount} request${
              t.requestCount === 1 ? "" : "s"
            }`}
          />
        </div>
      ))}
      <div style={{ borderTop: "2px solid var(--line)", marginTop: 6 }}>
        <TypeRowForm />
      </div>
    </div>
  );
}
