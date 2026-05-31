"use client";
import { useActionState } from "react";
import Link from "next/link";
import { createChangeRequestAction, type FormState } from "@/lib/compensation-actions";
import { CompFields, type CompFormInitial } from "@/components/compensation/CompFields";

const EMPTY: FormState = { ok: false };

export default function CompChangeRequestForm({
  employeeId,
  initial,
  reason = "",
}: {
  employeeId: string;
  initial: CompFormInitial;
  reason?: string;
}) {
  const [state, formAction, pending] = useActionState(createChangeRequestAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Raise a change request</h3>
          <span className="hint">prefilled from the current profile · needs exec sign-off</span>
        </div>
        <div className="card-pad">
          <CompFields initial={initial} fieldErrors={fe} />
          <div className="form-grid" style={{ marginTop: 14 }}>
            <div className="field full">
              <label htmlFor="reason">Reason for change</label>
              <textarea
                id="reason"
                name="reason"
                rows={2}
                defaultValue={reason}
                placeholder="e.g. Promotion to Senior Analyst; confirmation increase after probation."
              />
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href={`/compensation/${employeeId}`} className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Submitting…" : "Submit change request"}
        </button>
      </div>
    </form>
  );
}
