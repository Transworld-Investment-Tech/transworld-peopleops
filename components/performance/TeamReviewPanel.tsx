"use client";
import { useActionState, useState } from "react";
import {
  requestChangesAction,
  approveAndSealAction,
  markGoalProgressAction,
  type FormState,
} from "@/lib/goal-agreement-actions";

const EMPTY: FormState = { ok: false };

type Goal = {
  id: string;
  title: string;
  description: string | null;
  measure: string | null;
  target: string | null;
  weight: number | null;
  dueDate: string | null;
  status: string;
};

export default function TeamReviewPanel({
  employeeId,
  employeeName,
  reviewState,
  agreementNote,
  goals,
  progressOptions,
}: {
  employeeId: string;
  employeeName: string;
  reviewState: string;
  agreementNote: string | null;
  goals: Goal[];
  progressOptions: { value: string; label: string }[];
}) {
  const sealed = reviewState === "APPROVED";

  return (
    <div className="card" style={{ marginBottom: 18 }}>
      <div className="card-h">
        <h3>{sealed ? "Agreed goals" : "Review goals"}</h3>
      </div>
      <div className="card-pad">
        {goals.length === 0 ? (
          <p className="faint" style={{ marginTop: 0 }}>
            {employeeName} hasn't drafted any goals yet.
          </p>
        ) : (
          <div className="appr-list">
            {goals.map((g) =>
              sealed ? (
                <ProgressRow key={g.id} employeeId={employeeId} goal={g} options={progressOptions} />
              ) : (
                <div className="appr-ro" key={g.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kra">{g.title}</span>
                  </div>
                  <div className="faint" style={{ fontSize: 12.5 }}>
                    {[g.measure ? `KPI · ${g.measure}` : null, g.target ? `Target ${g.target}` : null, g.weight != null ? `${g.weight}%` : null, g.dueDate ? `Due ${g.dueDate}` : null]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </div>
                  {g.description ? <div className="appr-note">{g.description}</div> : null}
                </div>
              )
            )}
          </div>
        )}

        {sealed ? (
          agreementNote ? (
            <div className="field" style={{ marginTop: 14 }}>
              <label>Agreement on record</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{agreementNote}</p>
            </div>
          ) : null
        ) : reviewState === "SUBMITTED" ? (
          <Decision employeeId={employeeId} canApprove={goals.length > 0} />
        ) : (
          <div className="note" style={{ marginTop: 14 }}>
            <span>ℹ</span>
            <div>
              {reviewState === "CHANGES_REQUESTED"
                ? `You sent this back to ${employeeName}. It will return here once they resubmit.`
                : `${employeeName} hasn't submitted goals for review yet.`}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function Decision({ employeeId, canApprove }: { employeeId: string; canApprove: boolean }) {
  const [reqState, reqAction, reqPending] = useActionState(requestChangesAction, EMPTY);
  const [appState, appAction, appPending] = useActionState(approveAndSealAction, EMPTY);
  const [mode, setMode] = useState<"none" | "changes" | "approve">("none");

  return (
    <div style={{ marginTop: 16, borderTop: "1px solid var(--line)", paddingTop: 14 }}>
      {mode === "none" ? (
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
          <button type="button" className="btn btn-pri" onClick={() => setMode("approve")} disabled={!canApprove}>
            Approve & seal…
          </button>
          <button type="button" className="btn" onClick={() => setMode("changes")}>
            Request changes…
          </button>
        </div>
      ) : null}

      {mode === "changes" ? (
        <form action={reqAction}>
          <input type="hidden" name="employeeId" value={employeeId} />
          {reqState.error ? <div className="form-err">{reqState.error}</div> : null}
          <div className="field full">
            <label>What should change?</label>
            <textarea name="changesNote" rows={3} placeholder="Tell the employee what to adjust before you can agree" />
          </div>
          <div style={{ display: "flex", gap: 8, marginTop: 10 }}>
            <button type="submit" className="btn btn-pri" disabled={reqPending}>
              {reqPending ? "Sending…" : "Send back"}
            </button>
            <button type="button" className="btn" onClick={() => setMode("none")}>
              Cancel
            </button>
          </div>
        </form>
      ) : null}

      {mode === "approve" ? (
        <form action={appAction}>
          <input type="hidden" name="employeeId" value={employeeId} />
          {appState.error ? <div className="form-err">{appState.error}</div> : null}
          <div className="note" style={{ marginBottom: 12 }}>
            <span>⚠</span>
            <div>
              Approving <b>permanently seals</b> these goals and your agreement note. They can't be edited
              afterwards — only progress is marked at review. Mid-cycle changes are added as amendments.
            </div>
          </div>
          <div className="field full">
            <label>Record of what was discussed and agreed (canonical)</label>
            <textarea
              name="agreementNote"
              rows={4}
              placeholder="Summarize the conversation and the agreements reached — this becomes the permanent reference for mid-cycle and final review."
            />
          </div>
          <label style={{ display: "flex", gap: 8, alignItems: "flex-start", marginTop: 8 }}>
            <input type="checkbox" name="consent" value="1" />
            <span className="faint">I confirm this is the final agreed position. Approval seals it permanently.</span>
          </label>
          <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
            <button type="submit" className="btn btn-pri" disabled={appPending}>
              {appPending ? "Sealing…" : "Approve & seal"}
            </button>
            <button type="button" className="btn" onClick={() => setMode("none")}>
              Cancel
            </button>
          </div>
        </form>
      ) : null}
    </div>
  );
}

function ProgressRow({
  employeeId,
  goal,
  options,
}: {
  employeeId: string;
  goal: Goal;
  options: { value: string; label: string }[];
}) {
  const [state, action, pending] = useActionState(markGoalProgressAction, EMPTY);
  const badge = (s: string) =>
    s === "ACHIEVED" ? "b-grn" : s === "PARTIAL" ? "b-amb" : s === "MISSED" ? "b-red" : s === "DROPPED" ? "b-gry" : "b-blu";

  return (
    <div className="appr-ro">
      <div className="appr-ro-h">
        <span className="appr-kra">{goal.title}</span>
        <span className={`b ${badge(goal.status)}`}>{options.find((o) => o.value === goal.status)?.label ?? goal.status}</span>
      </div>
      <div className="faint" style={{ fontSize: 12.5 }}>
        {[goal.measure ? `KPI · ${goal.measure}` : null, goal.target ? `Target ${goal.target}` : null, goal.weight != null ? `${goal.weight}%` : null]
          .filter(Boolean)
          .join(" · ") || "—"}
      </div>
      <form action={action} style={{ display: "flex", gap: 8, alignItems: "center", marginTop: 8, flexWrap: "wrap" }}>
        <input type="hidden" name="employeeId" value={employeeId} />
        <input type="hidden" name="goalId" value={goal.id} />
        <span className="faint" style={{ fontSize: 12 }}>Progress</span>
        <select name="status" defaultValue={goal.status} style={{ fontSize: 13, padding: "6px 9px", border: "1px solid var(--line)", borderRadius: 8, background: "#fff" }}>
          {options.map((o) => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
        <button type="submit" className="btn" disabled={pending} style={{ fontSize: 12, padding: "6px 11px" }}>
          {pending ? "Saving…" : "Update"}
        </button>
        {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
      </form>
    </div>
  );
}
