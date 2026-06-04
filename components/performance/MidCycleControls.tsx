"use client";
import { useActionState } from "react";
import {
  openMidCycleReviewsAction,
  submitMyMidCycleAction,
  recordMidCycleReviewAction,
  type FormState,
} from "@/lib/midcycle-actions";

const EMPTY: FormState = { ok: false };
function Notes({ s }: { s: FormState }) {
  return (
    <>
      {s.error && <div className="form-err">{s.error}</div>}
      {s.ok && s.message && (
        <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
          <span>✓</span><div>{s.message}</div>
        </div>
      )}
    </>
  );
}

export function OpenMidCycleButton({ cycleId }: { cycleId: string }) {
  const [state, action, pending] = useActionState(openMidCycleReviewsAction, EMPTY);
  return (
    <form action={action}>
      <Notes s={state} />
      <input type="hidden" name="cycleId" value={cycleId} />
      <button className="btn btn-pri" type="submit" disabled={pending}>{pending ? "Opening…" : "Open mid-cycle reviews"}</button>
    </form>
  );
}

export function MidCycleSelfForm({
  id,
  defaultSummary,
  submitted,
}: {
  id: string;
  defaultSummary: string;
  submitted: boolean;
}) {
  const [state, action, pending] = useActionState(submitMyMidCycleAction, EMPTY);
  if (submitted && !state.ok) {
    return (
      <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
        <span>✓</span><div>Your mid-cycle reflection is submitted. Your manager will hold the check-in conversation with you.</div>
      </div>
    );
  }
  return (
    <form action={action}>
      <Notes s={state} />
      <input type="hidden" name="id" value={id} />
      <div className="field">
        <label htmlFor="mc-self">Your mid-cycle reflection</label>
        <textarea id="mc-self" name="selfSummary" rows={4} defaultValue={defaultSummary} placeholder="How is the year going against your goals? What support or course-correction would help in the second half?" />
      </div>
      <div className="appr-actions">
        <button type="submit" name="submit" value="" className="btn" disabled={pending}>{pending ? "Saving…" : "Save draft"}</button>
        <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={pending}>Submit reflection</button>
      </div>
    </form>
  );
}

export function MidCycleReviewForm({
  id,
  defaults,
}: {
  id: string;
  defaults: { goalsNote: string; behaviorNote: string; skillsNote: string; developmentNote: string; managerSummary: string };
}) {
  const [state, action, pending] = useActionState(recordMidCycleReviewAction, EMPTY);
  return (
    <form action={action}>
      <Notes s={state} />
      <input type="hidden" name="id" value={id} />
      <div className="form-grid">
        <div className="field full">
          <label htmlFor={`g-${id}`}>1 · Goals — progress &amp; any re-prioritization</label>
          <textarea id={`g-${id}`} name="goalsNote" rows={2} defaultValue={defaults.goalsNote} />
        </div>
        <div className="field full">
          <label htmlFor={`b-${id}`}>2 · Behavior — how they’re working (the six behaviors)</label>
          <textarea id={`b-${id}`} name="behaviorNote" rows={2} defaultValue={defaults.behaviorNote} />
        </div>
        <div className="field full">
          <label htmlFor={`s-${id}`}>3 · Competencies / Skills — growth &amp; gaps</label>
          <textarea id={`s-${id}`} name="skillsNote" rows={2} defaultValue={defaults.skillsNote} />
        </div>
        <div className="field full">
          <label htmlFor={`d-${id}`}>4 · Developmental Level — Growth-Ladder stage &amp; next steps</label>
          <textarea id={`d-${id}`} name="developmentNote" rows={2} defaultValue={defaults.developmentNote} />
        </div>
        <div className="field full">
          <label htmlFor={`m-${id}`}>Overall summary (optional)</label>
          <input id={`m-${id}`} name="managerSummary" defaultValue={defaults.managerSummary} />
        </div>
      </div>
      <div className="appr-actions">
        <button type="submit" name="complete" value="" className="btn" disabled={pending}>{pending ? "Saving…" : "Save"}</button>
        <button type="submit" name="complete" value="1" className="btn btn-pri" disabled={pending}>Complete review</button>
      </div>
    </form>
  );
}
