"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import { requestLeaveAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

export default function RequestLeaveForm({
  types,
}: {
  types: { id: string; name: string; daysPerYear: number }[];
}) {
  const [state, formAction, pending] = useActionState(requestLeaveAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const [start, setStart] = useState("");
  const [end, setEnd] = useState("");
  const sameDay = start !== "" && start === end;

  return (
    <form action={formAction}>
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Request leave</h3>
          <span className="hint">goes to your line manager, then HR</span>
        </div>
        <div className="card-pad">
          <div className="field">
            <label htmlFor="leaveTypeId">Leave type</label>
            <select id="leaveTypeId" name="leaveTypeId" defaultValue="">
              <option value="" disabled>
                Choose a type…
              </option>
              {types.map((t) => (
                <option key={t.id} value={t.id}>
                  {t.name}
                </option>
              ))}
            </select>
            {fe.leaveTypeId ? <div className="form-err">{fe.leaveTypeId}</div> : null}
          </div>

          <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 14 }}>
            <div className="field">
              <label htmlFor="startDate">Start date</label>
              <input
                id="startDate"
                name="startDate"
                type="date"
                value={start}
                onChange={(e) => setStart(e.target.value)}
              />
              {fe.startDate ? <div className="form-err">{fe.startDate}</div> : null}
            </div>
            <div className="field">
              <label htmlFor="endDate">End date</label>
              <input
                id="endDate"
                name="endDate"
                type="date"
                value={end}
                onChange={(e) => setEnd(e.target.value)}
              />
              {fe.endDate ? <div className="form-err">{fe.endDate}</div> : null}
            </div>
          </div>

          {sameDay ? (
            <div className="field">
              <label style={{ display: "flex", alignItems: "center", gap: 8, fontWeight: 400 }}>
                <input type="checkbox" name="half" style={{ width: "auto" }} />
                Half day (counts as 0.5)
              </label>
              {fe.half ? <div className="form-err">{fe.half}</div> : null}
            </div>
          ) : null}

          <div className="field">
            <label htmlFor="note">Note (optional)</label>
            <textarea id="note" name="note" rows={2} placeholder="A short reason or context." />
          </div>

          <p className="faint" style={{ marginTop: 0 }}>
            Working days are counted Monday–Friday; weekends are excluded. Public holidays
            aren’t deducted automatically.
          </p>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/leave" className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Submitting…" : "Submit request"}
        </button>
      </div>
    </form>
  );
}
