"use client";

import { useActionState } from "react";
import { setCycleThirteenthMonthAction, type FormState } from "@/lib/payroll-cycle-actions";

const EMPTY: FormState = { ok: false };

export default function CycleThirteenthToggle({
  cycleId,
  isThirteenthMonth,
}: {
  cycleId: string;
  isThirteenthMonth: boolean;
}) {
  const [state, action, pending] = useActionState(setCycleThirteenthMonthAction, EMPTY);
  return (
    <form
      action={action}
      style={{ display: "inline-flex", gap: 8, alignItems: "center" }}
      onSubmit={(e) => {
        const msg = isThirteenthMonth
          ? "Clear the 13th-month run for this cycle?"
          : "Mark this cycle as the 13th-month run? A thirteenth-month line (one month's gross) will be added for every employee.";
        if (!window.confirm(msg)) e.preventDefault();
      }}
    >
      <input type="hidden" name="cycleId" value={cycleId} />
      <input type="hidden" name="on" value={isThirteenthMonth ? "false" : "true"} />
      <button type="submit" className="btn btn-xs" disabled={pending}>
        {pending ? "Saving…" : isThirteenthMonth ? "Clear 13th-month run" : "Mark as 13th-month run"}
      </button>
      {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
    </form>
  );
}
