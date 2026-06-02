"use client";

import { useActionState } from "react";
import {
  addAttemptAction,
  updateAttemptAction,
  deleteAttemptAction,
  type FormState,
} from "@/lib/sponsorship-actions";
import { ATTEMPT_OUTCOMES, attemptOutcomeBadge } from "@/lib/sponsorship";

const initial: FormState = { ok: false };

export type AttemptDisplay = {
  id: string;
  levelLabel: string;
  attemptNumber: number | null;
  sittingText: string;
  outcome: string;
  score: string | null;
};

function AttemptRowActions({ attemptId, outcome, score }: { attemptId: string; outcome: string; score: string | null }) {
  const [, updateAction, updatePending] = useActionState(updateAttemptAction, initial);
  const [, deleteAction, deletePending] = useActionState(deleteAttemptAction, initial);
  return (
    <span style={{ display: "inline-flex", gap: 6, alignItems: "center", flexWrap: "wrap" }}>
      <form action={updateAction} style={{ display: "inline-flex", gap: 6, alignItems: "center" }}>
        <input type="hidden" name="attemptId" value={attemptId} />
        <select name="outcome" defaultValue={outcome} style={{ padding: "5px 8px" }}>
          {ATTEMPT_OUTCOMES.map((o) => (
            <option key={o} value={o}>{attemptOutcomeBadge(o).label}</option>
          ))}
        </select>
        <input type="text" name="score" defaultValue={score ?? ""} placeholder="score" style={{ width: 90, padding: "5px 8px" }} />
        <button type="submit" className="btn btn-xs" disabled={updatePending}>Save</button>
      </form>
      <form
        action={deleteAction}
        style={{ display: "inline" }}
        onSubmit={(e) => { if (!window.confirm("Remove this attempt?")) e.preventDefault(); }}
      >
        <input type="hidden" name="attemptId" value={attemptId} />
        <button type="submit" className="btn btn-xs btn-danger" disabled={deletePending}>Remove</button>
      </form>
    </span>
  );
}

function AddAttemptForm({ sponsorshipId }: { sponsorshipId: string }) {
  const [state, action, pending] = useActionState(addAttemptAction, initial);
  return (
    <form action={action} style={{ marginTop: 14 }}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="form-grid">
        <div className="field">
          <label>Level / paper</label>
          <input type="text" name="levelLabel" placeholder="e.g. Level I, Paper 1, Foundation" />
        </div>
        <div className="field">
          <label>Attempt # (optional)</label>
          <input type="number" name="attemptNumber" min={1} step={1} placeholder="e.g. 1" />
        </div>
        <div className="field">
          <label>Sitting date (optional)</label>
          <input type="date" name="sittingDate" />
        </div>
        <div className="field">
          <label>Outcome</label>
          <select name="outcome" defaultValue="SCHEDULED">
            {ATTEMPT_OUTCOMES.map((o) => (
              <option key={o} value={o}>{attemptOutcomeBadge(o).label}</option>
            ))}
          </select>
        </div>
        <div className="field">
          <label>Score (optional)</label>
          <input type="text" name="score" placeholder="e.g. Pass, 72%" />
        </div>
      </div>
      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending}>
          {pending ? "Adding…" : "Add attempt"}
        </button>
      </div>
    </form>
  );
}

export default function SponsorshipAttempts({
  sponsorshipId,
  attempts,
  canManage,
  locked,
}: {
  sponsorshipId: string;
  attempts: AttemptDisplay[];
  canManage: boolean;
  locked: boolean;
}) {
  return (
    <>
      {attempts.length === 0 ? (
        <p className="faint" style={{ marginTop: 0 }}>No exam attempts recorded yet.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Level / paper</th>
              <th className="num">Attempt</th>
              <th>Sitting</th>
              <th>Outcome</th>
              <th>Score</th>
              {canManage ? <th></th> : null}
            </tr>
          </thead>
          <tbody>
            {attempts.map((a) => {
              const b = attemptOutcomeBadge(a.outcome);
              return (
                <tr key={a.id}>
                  <td>{a.levelLabel}</td>
                  <td className="num">{a.attemptNumber ?? "—"}</td>
                  <td>{a.sittingText}</td>
                  <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                  <td>{a.score ?? "—"}</td>
                  {canManage ? (
                    <td>
                      <AttemptRowActions attemptId={a.id} outcome={a.outcome} score={a.score} />
                    </td>
                  ) : null}
                </tr>
              );
            })}
          </tbody>
        </table>
      )}

      {canManage && !locked ? <AddAttemptForm sponsorshipId={sponsorshipId} /> : null}
    </>
  );
}
