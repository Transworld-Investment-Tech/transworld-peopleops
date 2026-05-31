"use client";
import { useActionState } from "react";
import { saveEntitlementAction, type FormState } from "@/lib/leave-actions";

const EMPTY: FormState = { ok: false };

// One editable balance cell: HR sets days_entitled; taken/remaining are shown
// read-only (taken is driven by approved requests, not edited here).
export default function EntitlementEditor({
  employeeId,
  leaveTypeId,
  year,
  entitled,
  taken,
  remaining,
}: {
  employeeId: string;
  leaveTypeId: string;
  year: number;
  entitled: number;
  taken: number;
  remaining: number;
}) {
  const [state, formAction, pending] = useActionState(saveEntitlementAction, EMPTY);

  return (
    <form
      action={formAction}
      style={{ display: "flex", alignItems: "center", gap: 6, flexWrap: "wrap" }}
    >
      <input type="hidden" name="employeeId" value={employeeId} />
      <input type="hidden" name="leaveTypeId" value={leaveTypeId} />
      <input type="hidden" name="year" value={year} />
      <input
        name="daysEntitled"
        type="number"
        step="0.5"
        min="0"
        max="366"
        defaultValue={entitled}
        aria-label="Days entitled"
        style={{ width: 72 }}
      />
      <button type="submit" className="btn" style={{ padding: "5px 10px" }} disabled={pending}>
        {pending ? "…" : "Save"}
      </button>
      <span className="faint mono" style={{ whiteSpace: "nowrap" }}>
        −{taken} = {remaining} left
      </span>
      {state.error ? (
        <span className="form-err" style={{ margin: 0 }}>
          {state.error}
        </span>
      ) : null}
    </form>
  );
}
