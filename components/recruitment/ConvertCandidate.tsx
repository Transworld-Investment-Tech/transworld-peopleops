"use client";
import { useActionState } from "react";
import { convertCandidateToStaffAction, type FormState } from "@/lib/recruitment-actions";

const EMPTY: FormState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

// Rendered inside the OFFER column card. The server action re-reads the
// candidate, validates that offer terms are set, and (on success) redirects to
// the new employee record. Gated server-side by employees.manage.
export default function ConvertCandidate({
  candidateId,
  openingId,
  defaultStartDate,
}: {
  candidateId: string;
  openingId: string;
  defaultStartDate: string | null;
}) {
  const [state, formAction, pending] = useActionState(convertCandidateToStaffAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <div style={{ marginTop: 8, borderTop: "1px dashed var(--line)", paddingTop: 8 }}>
      <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>
        Convert to staff
      </div>
      <form action={formAction}>
        {state.error && <div className="form-err">{state.error}</div>}
        <input type="hidden" name="candidateId" value={candidateId} />
        <input type="hidden" name="openingId" value={openingId} />
        <div className="field">
          <label htmlFor={`ee-${candidateId}`}>New Employee ID</label>
          <input id={`ee-${candidateId}`} name="eeId" placeholder="EID 20" />
          <Err msg={fe.eeId} />
        </div>
        <div className="field">
          <label htmlFor={`start-${candidateId}`}>Start date</label>
          <input id={`start-${candidateId}`} name="startDate" type="date" defaultValue={defaultStartDate ?? ""} />
        </div>
        <button className="btn btn-grn btn-xs" type="submit" disabled={pending} style={{ marginTop: 6 }}>
          {pending ? "Converting…" : "Convert to staff →"}
        </button>
        <p className="faint" style={{ fontSize: 11, marginTop: 6 }}>
          Creates the employee (on probation), their starting compensation profile from the offer
          terms, a hire history entry and an onboarding shell. Payment stays with HumanManager/Remita.
        </p>
      </form>
    </div>
  );
}
