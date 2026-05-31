"use client";
import { useActionState, useState } from "react";
import { editLeaveAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

export default function LeaveEditForm({
  requestId,
  types,
  defaultTypeId,
  startInput,
  endInput,
  isHalf,
  defaultNote,
  reviewWillReset = false,
}: {
  requestId: string;
  types: { id: string; name: string; daysPerYear: number }[];
  defaultTypeId: string;
  startInput: string;
  endInput: string;
  isHalf: boolean;
  defaultNote: string | null;
  reviewWillReset?: boolean;
}) {
  const [state, formAction, pending] = useActionState(editLeaveAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const [start, setStart] = useState(startInput);
  const [end, setEnd] = useState(endInput);
  const sameDay = start !== "" && start === end;

  return (
    <form action={formAction}>
      <input type="hidden" name="requestId" value={requestId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="field">
        <label htmlFor="leaveTypeId">Leave type</label>
        <select id="leaveTypeId" name="leaveTypeId" defaultValue={defaultTypeId}>
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
            <input type="checkbox" name="half" defaultChecked={isHalf} style={{ width: "auto" }} />
            Half day (counts as 0.5)
          </label>
          {fe.half ? <div className="form-err">{fe.half}</div> : null}
        </div>
      ) : null}

      <div className="field">
        <label htmlFor="note">Note (optional)</label>
        <textarea id="note" name="note" rows={2} defaultValue={defaultNote ?? ""} />
      </div>

      {reviewWillReset ? (
        <p className="hint" style={{ marginTop: 0 }}>
          This request has already been reviewed by the line manager. Changing the type, dates, or
          day count will send it back to them for a fresh review.
        </p>
      ) : null}

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
