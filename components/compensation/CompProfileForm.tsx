"use client";
import { useActionState } from "react";
import Link from "next/link";
import { establishProfileAction, type FormState } from "@/lib/compensation-actions";
import { CompFields, type CompFormInitial } from "@/components/compensation/CompFields";

const EMPTY: FormState = { ok: false };

export default function CompProfileForm({
  employeeId,
  initial,
}: {
  employeeId: string;
  initial: CompFormInitial;
}) {
  const [state, formAction, pending] = useActionState(establishProfileAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Establish compensation profile</h3>
          <span className="hint">standing inputs the control room reads</span>
        </div>
        <div className="card-pad">
          <CompFields initial={initial} fieldErrors={fe} />
        </div>
      </div>

      <div className="form-actions">
        <Link href={`/compensation/${employeeId}`} className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Establish profile"}
        </button>
      </div>
    </form>
  );
}
