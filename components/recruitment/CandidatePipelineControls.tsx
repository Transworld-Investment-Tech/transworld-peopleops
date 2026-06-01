"use client";
import { useActionState } from "react";
import {
  addCandidateAction,
  setCandidateStageAction,
  setRequisitionStatusAction,
  type FormState,
} from "@/lib/recruitment-actions";
import { STAGES, stageLabel, OPENING_STATUSES, openingStatusBadge } from "@/lib/recruitment";

const EMPTY: FormState = { ok: false };

export function AddCandidateForm({ openingId }: { openingId: string }) {
  const [state, formAction, pending] = useActionState(addCandidateAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      <input type="hidden" name="openingId" value={openingId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 14 }}>
        <div className="field">
          <label htmlFor="fullName">Candidate name</label>
          <input id="fullName" name="fullName" placeholder="Full name" />
          {fe.fullName ? <div className="form-err">{fe.fullName}</div> : null}
        </div>
        <div className="field">
          <label htmlFor="source">Source (optional)</label>
          <input id="source" name="source" placeholder="e.g. Referral, Job board" />
        </div>
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 14 }}>
        <div className="field">
          <label htmlFor="email">Email (optional)</label>
          <input id="email" name="email" type="email" placeholder="name@example.com" />
          {fe.email ? <div className="form-err">{fe.email}</div> : null}
        </div>
        <div className="field">
          <label htmlFor="phone">Phone (optional)</label>
          <input id="phone" name="phone" placeholder="Phone" />
        </div>
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 2fr", gap: 14 }}>
        <div className="field">
          <label htmlFor="stage">Stage</label>
          <select id="stage" name="stage" defaultValue="SOURCED">
            {STAGES.map((s) => (
              <option key={s} value={s}>
                {stageLabel(s)}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="stageNote">Note (optional)</label>
          <input id="stageNote" name="stageNote" placeholder="e.g. CV review, Aptitude 78%" />
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Adding…" : "Add candidate"}
        </button>
      </div>
    </form>
  );
}

export function CandidateStageControl({
  candidateId,
  openingId,
  stage,
}: {
  candidateId: string;
  openingId: string;
  stage: string;
}) {
  const [state, formAction, pending] = useActionState(setCandidateStageAction, EMPTY);

  return (
    <form action={formAction} style={{ marginTop: 8 }}>
      <input type="hidden" name="candidateId" value={candidateId} />
      <input type="hidden" name="openingId" value={openingId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div style={{ display: "flex", gap: 6, alignItems: "center", flexWrap: "wrap" }}>
        <select name="stage" defaultValue={stage} style={{ flex: "1 1 110px" }}>
          {STAGES.map((s) => (
            <option key={s} value={s}>
              {stageLabel(s)}
            </option>
          ))}
        </select>
        <input
          name="interviewAt"
          type="date"
          title="Interview date (optional)"
          style={{ flex: "1 1 130px" }}
        />
        <button className="btn" type="submit" disabled={pending} style={{ padding: "6px 10px" }}>
          {pending ? "…" : "Move"}
        </button>
      </div>
      <input
        name="stageNote"
        placeholder="Update note (optional)"
        style={{ marginTop: 6, width: "100%" }}
      />
    </form>
  );
}

export function RequisitionStatusControl({
  openingId,
  status,
}: {
  openingId: string;
  status: string;
}) {
  const [state, formAction, pending] = useActionState(setRequisitionStatusAction, EMPTY);
  const badge = openingStatusBadge(status);

  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="openingId" value={openingId} />
      <span className={`b ${badge.cls}`}>{badge.label}</span>
      <select name="status" defaultValue={status}>
        {OPENING_STATUSES.map((s) => (
          <option key={s} value={s}>
            {openingStatusBadge(s).label}
          </option>
        ))}
      </select>
      <button className="btn" type="submit" disabled={pending} style={{ padding: "6px 10px" }}>
        {pending ? "…" : "Update"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}
