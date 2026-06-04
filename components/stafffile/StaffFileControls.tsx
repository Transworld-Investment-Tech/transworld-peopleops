"use client";
import { useActionState } from "react";
import {
  takeStaffFileSnapshotAction,
  classifyDocumentSlotAction,
  setEmployeeRegulatedFlagAction,
  type FormState,
} from "@/lib/stafffile-actions";
import { STAFF_FILE_SLOTS, slotLabel } from "@/lib/stafffile";

const EMPTY: FormState = { ok: false };

export function TakeSnapshotForm({ scope }: { scope: string }) {
  const [state, formAction, pending] = useActionState(takeStaffFileSnapshotAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
      <input type="hidden" name="scope" value={scope} />
      <input name="note" placeholder="Note (optional)" style={{ flex: "1 1 220px" }} />
      <button className="btn btn-pri" type="submit" disabled={pending}>
        {pending ? "Saving…" : "Take snapshot"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function ClassifyDocForm({
  docId,
  employeeId,
  current,
}: {
  docId: string;
  employeeId: string;
  current: string | null;
}) {
  const [state, formAction, pending] = useActionState(classifyDocumentSlotAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 6, alignItems: "center", flexWrap: "wrap" }}>
      <input type="hidden" name="docId" value={docId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      <select name="fileSlot" defaultValue={current ?? ""} style={{ flex: "1 1 200px" }}>
        <option value="">— unfiled —</option>
        {STAFF_FILE_SLOTS.map((s) => (
          <option key={s} value={s}>{slotLabel(s)}</option>
        ))}
      </select>
      <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "File"}</button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function RegulatedToggle({ employeeId, isRegulated }: { employeeId: string; isRegulated: boolean }) {
  const [state, formAction, pending] = useActionState(setEmployeeRegulatedFlagAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="employeeId" value={employeeId} />
      <input type="hidden" name="isRegulated" value={isRegulated ? "" : "on"} />
      <button className="btn btn-xs" type="submit" disabled={pending}>
        {pending ? "…" : isRegulated ? "Mark as non-regulated" : "Mark as regulated role"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}
