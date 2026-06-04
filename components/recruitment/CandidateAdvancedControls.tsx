"use client";
import { useActionState } from "react";
import {
  recordSelectionAction,
  recordCcoSignoffAction,
  seedCandidateChecksAction,
  setCandidateCheckAction,
  type FormState,
} from "@/lib/recruitment-actions";
import { checkLabel, checkStatusBadge, CHECK_STATUSES } from "@/lib/recruitment";

const EMPTY: FormState = { ok: false };

type CheckView = {
  id: string;
  checkType: string;
  applicable: boolean;
  status: string;
  clearedByName: string | null;
  note: string | null;
};

type StageEvent = { id: string; stage: string; clearedAt: string; clearedByName: string | null; note: string | null };

// --- Stage 7: selection + CCO sign-off -------------------------------------
export function SelectionControl({
  candidateId,
  openingId,
  selectionRationale,
  selectedByName,
  selectedAt,
  ccoSignoffByName,
  ccoSignoffAt,
  isControlFunction,
  canCco,
}: {
  candidateId: string;
  openingId: string;
  selectionRationale: string | null;
  selectedByName: string | null;
  selectedAt: string | null;
  ccoSignoffByName: string | null;
  ccoSignoffAt: string | null;
  isControlFunction: boolean;
  canCco: boolean;
}) {
  const [state, formAction, pending] = useActionState(recordSelectionAction, EMPTY);
  const [ccoState, ccoAction, ccoPending] = useActionState(recordCcoSignoffAction, EMPTY);
  const decided = !!selectedAt;

  return (
    <div style={{ marginTop: 8, borderTop: "1px dashed var(--line)", paddingTop: 8 }}>
      <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>Selection decision (Stage 7)</div>
      {decided ? (
        <div className="faint" style={{ fontSize: 12 }}>
          Selected by {selectedByName} · {selectedAt}
          {selectionRationale ? <div style={{ marginTop: 2 }}>“{selectionRationale}”</div> : null}
        </div>
      ) : (
        <form action={formAction}>
          <input type="hidden" name="candidateId" value={candidateId} />
          <input type="hidden" name="openingId" value={openingId} />
          {state.error ? <div className="form-err">{state.error}</div> : null}
          <textarea
            name="selectionRationale"
            rows={2}
            placeholder="Why this candidate — best-evidenced fit against the scorecard."
            style={{ width: "100%" }}
          />
          <button className="btn btn-xs btn-pri" type="submit" disabled={pending} style={{ marginTop: 6 }}>
            {pending ? "…" : "Record selection"}
          </button>
        </form>
      )}

      {isControlFunction ? (
        <div style={{ marginTop: 8 }}>
          <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>
            CCO independent sign-off {ccoSignoffAt ? "" : "(required — control-function)"}
          </div>
          {ccoSignoffAt ? (
            <span className="b b-grn">CCO: {ccoSignoffByName} · {ccoSignoffAt}</span>
          ) : canCco && decided ? (
            <form action={ccoAction}>
              <input type="hidden" name="candidateId" value={candidateId} />
              <input type="hidden" name="openingId" value={openingId} />
              {ccoState.error ? <div className="form-err">{ccoState.error}</div> : null}
              <button className="btn btn-xs btn-grn" type="submit" disabled={ccoPending}>
                {ccoPending ? "…" : "CCO sign off"}
              </button>
            </form>
          ) : (
            <span className="faint" style={{ fontSize: 12 }}>
              {decided ? "Awaiting CCO sign-off." : "Record the selection first."}
            </span>
          )}
        </div>
      ) : null}
    </div>
  );
}

// --- Stage 8: verification checklist ---------------------------------------
function CheckRow({ candidateId, openingId, c }: { candidateId: string; openingId: string; c: CheckView }) {
  const [state, formAction, pending] = useActionState(setCandidateCheckAction, EMPTY);
  const badge = checkStatusBadge(c.status);
  return (
    <form action={formAction} style={{ borderTop: "1px solid var(--line)", padding: "6px 0" }}>
      <input type="hidden" name="candidateId" value={candidateId} />
      <input type="hidden" name="openingId" value={openingId} />
      <input type="hidden" name="checkType" value={c.checkType} />
      <div style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
        <span style={{ flex: "1 1 160px", fontSize: 12.5 }}>{checkLabel(c.checkType)}</span>
        <span className={`b ${badge.cls}`}>{badge.label}</span>
        {c.applicable ? null : <span className="b b-gry">N/A</span>}
      </div>
      <div style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap", marginTop: 4 }}>
        <label style={{ display: "flex", alignItems: "center", gap: 4, fontSize: 11.5 }}>
          <input type="checkbox" name="applicable" defaultChecked={c.applicable} /> Applies
        </label>
        <select name="status" defaultValue={c.status} style={{ flex: "0 1 130px" }}>
          {CHECK_STATUSES.map((s) => (
            <option key={s} value={s}>{checkStatusBadge(s).label}</option>
          ))}
        </select>
        <input name="note" placeholder="Note / evidence ref" defaultValue={c.note ?? ""} style={{ flex: "1 1 140px" }} />
        <button className="btn btn-xs" type="submit" disabled={pending}>{pending ? "…" : "Save"}</button>
      </div>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      {c.clearedByName ? <div className="faint" style={{ fontSize: 11 }}>by {c.clearedByName}</div> : null}
    </form>
  );
}

export function ChecksControl({
  candidateId,
  openingId,
  checks,
  ready,
}: {
  candidateId: string;
  openingId: string;
  checks: CheckView[];
  ready: boolean;
}) {
  const [state, seedAction, pending] = useActionState(seedCandidateChecksAction, EMPTY);
  return (
    <div style={{ marginTop: 8, borderTop: "1px dashed var(--line)", paddingTop: 8 }}>
      <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>
        Pre-employment checks (Stage 8) {ready ? <span className="b b-grn">Ready for offer</span> : <span className="b b-amb">In progress</span>}
      </div>
      {checks.length === 0 ? (
        <form action={seedAction}>
          <input type="hidden" name="candidateId" value={candidateId} />
          <input type="hidden" name="openingId" value={openingId} />
          {state.error ? <div className="form-err">{state.error}</div> : null}
          <button className="btn btn-xs btn-pri" type="submit" disabled={pending}>
            {pending ? "…" : "Start verification checklist"}
          </button>
        </form>
      ) : (
        <div>
          {checks.map((c) => (
            <CheckRow key={c.id} candidateId={candidateId} openingId={openingId} c={c} />
          ))}
        </div>
      )}
    </div>
  );
}

// --- Stage-event trail (read-only) -----------------------------------------
export function StageTimeline({ events }: { events: StageEvent[] }) {
  if (events.length === 0) return null;
  return (
    <details style={{ marginTop: 8 }}>
      <summary className="faint" style={{ fontSize: 11.5, cursor: "pointer" }}>
        Stage history ({events.length})
      </summary>
      <div style={{ marginTop: 4 }}>
        {events.map((e) => (
          <div key={e.id} className="faint" style={{ fontSize: 11.5 }}>
            <span className="mono">{e.clearedAt}</span> · {e.stage}
            {e.clearedByName ? ` · ${e.clearedByName}` : ""}
            {e.note ? ` — ${e.note}` : ""}
          </div>
        ))}
      </div>
    </details>
  );
}
