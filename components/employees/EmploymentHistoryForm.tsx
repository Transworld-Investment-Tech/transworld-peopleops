"use client";
import { useActionState } from "react";
import { addEmploymentRecordAction, type FormState } from "@/lib/employees-actions";

const EMPTY: FormState = { ok: false };

const EVENT_TYPES = [
  { value: "HIRE", label: "Hire" },
  { value: "CONFIRMATION", label: "Confirmation" },
  { value: "PROMOTION", label: "Promotion" },
  { value: "REGRADE", label: "Re-grade" },
  { value: "TRANSFER", label: "Transfer" },
  { value: "STATUS_CHANGE", label: "Status change" },
  { value: "COMP_CHANGE", label: "Compensation change" },
  { value: "EXIT", label: "Exit" },
  { value: "NOTE", label: "Note" },
];

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function EmploymentHistoryForm({ employeeId }: { employeeId: string }) {
  const [state, formAction, pending] = useActionState(addEmploymentRecordAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction} style={{ marginTop: 14 }}>
      {state.error && <div className="form-err">{state.error}</div>}
      <input type="hidden" name="employeeId" value={employeeId} />
      <div className="form-grid">
        <div className="field">
          <label htmlFor="hist-eventType">Event</label>
          <select id="hist-eventType" name="eventType" defaultValue="NOTE">
            {EVENT_TYPES.map((e) => (
              <option key={e.value} value={e.value}>{e.label}</option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="hist-effectiveDate">Effective date</label>
          <input id="hist-effectiveDate" name="effectiveDate" type="date" />
          <Err msg={fe.effectiveDate} />
        </div>
        <div className="field">
          <label htmlFor="hist-title">Title (optional)</label>
          <input id="hist-title" name="title" placeholder="Role title at this event" />
        </div>
        <div className="field">
          <label htmlFor="hist-grade">Grade (optional)</label>
          <select id="hist-grade" name="grade" defaultValue="">
            <option value="">—</option>
            {["G0", "G1", "G2", "G3", "G4", "G5", "PT"].map((g) => (
              <option key={g} value={g}>{g}</option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="hist-note">Note</label>
          <input id="hist-note" name="note" placeholder="What changed" />
        </div>
      </div>
      <div className="form-actions">
        <button className="btn btn-pri btn-xs" type="submit" disabled={pending}>
          {pending ? "Recording…" : "Record event"}
        </button>
      </div>
    </form>
  );
}
