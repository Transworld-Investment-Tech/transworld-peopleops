"use client";
import { useActionState } from "react";
import { startOnboardingAction, type FormState } from "@/lib/onboarding-actions";

const EMPTY: FormState = { ok: false };

export default function StartOnboardingForm({
  eligible,
}: {
  eligible: { id: string; eeId: string; name: string; status: string }[];
}) {
  const [state, formAction, pending] = useActionState(startOnboardingAction, EMPTY);

  if (!eligible.length) {
    return (
      <p className="faint" style={{ margin: 0 }}>
        Every non-exited employee already has an onboarding plan.
      </p>
    );
  }

  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <select name="employeeId" defaultValue="" style={{ minWidth: 260 }}>
        <option value="" disabled>
          Choose an employee…
        </option>
        {eligible.map((e) => (
          <option key={e.id} value={e.id}>
            {e.name} · {e.eeId}
            {e.status === "PROBATION" ? " (probation)" : ""}
          </option>
        ))}
      </select>
      <button className="btn btn-pri" type="submit" disabled={pending}>
        {pending ? "Starting…" : "Start onboarding"}
      </button>
    </form>
  );
}
