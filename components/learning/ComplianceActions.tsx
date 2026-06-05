"use client";
import { useActionState, useState } from "react";
import { waiveRecordAction, recordEvidenceAction, type FormState } from "@/lib/lms-actions";

const EMPTY: FormState = { ok: false };

// Compact inline actions for one learning_record on the compliance dashboard.
// People-Ops (learning.manage) only — the parent page gates rendering. Only one
// form is shown at a time, but both useActionState hooks are declared up-front
// (hooks must be unconditional).
export default function ComplianceActions({ recordId }: { recordId: string }) {
  const [open, setOpen] = useState<null | "waive" | "attest">(null);
  const [waiveState, waiveAction, waiving] = useActionState(waiveRecordAction, EMPTY);
  const [attestState, attestAction, attesting] = useActionState(recordEvidenceAction, EMPTY);

  if (!open) {
    return (
      <span className="row" style={{ gap: 6 }}>
        <button type="button" className="btn btn-xs" onClick={() => setOpen("attest")}>
          Attest
        </button>
        <button type="button" className="btn btn-xs" onClick={() => setOpen("waive")}>
          Waive
        </button>
      </span>
    );
  }

  if (open === "waive") {
    return (
      <form action={waiveAction} className="row" style={{ gap: 6 }}>
        <input type="hidden" name="recordId" value={recordId} />
        <input name="waivedReason" placeholder="Reason for waiver" style={{ minWidth: 180 }} />
        <button className="btn btn-xs btn-grn" disabled={waiving}>
          Save
        </button>
        <button type="button" className="btn btn-xs" onClick={() => setOpen(null)}>
          Cancel
        </button>
        {waiveState.error ? <span className="err">{waiveState.error}</span> : null}
        {waiveState.fieldErrors?.waivedReason ? (
          <span className="err">{waiveState.fieldErrors.waivedReason}</span>
        ) : null}
      </form>
    );
  }

  return (
    <form action={attestAction} className="row" style={{ gap: 6 }}>
      <input type="hidden" name="recordId" value={recordId} />
      <input type="hidden" name="markComplete" value="1" />
      <input name="evidenceNote" placeholder="Evidence note (e.g. external cert)" style={{ minWidth: 200 }} />
      <button className="btn btn-xs btn-grn" disabled={attesting}>
        Mark complete
      </button>
      <button type="button" className="btn btn-xs" onClick={() => setOpen(null)}>
        Cancel
      </button>
      {attestState.error ? <span className="err">{attestState.error}</span> : null}
    </form>
  );
}
