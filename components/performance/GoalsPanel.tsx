"use client";
import { useActionState, useState } from "react";
import {
  createGoalAction,
  updateGoalAction,
  deleteGoalAction,
  type FormState,
} from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

type Goal = {
  id: string;
  title: string;
  description: string | null;
  measure: string | null;
  target: string | null;
  weight: number | null;
  dueDate: string | null; // ISO yyyy-mm-dd for the date input
  status: string;
};

export default function GoalsPanel({
  cycleId,
  cycleName,
  employeeId,
  canManage,
  goals,
  statuses,
}: {
  cycleId: string;
  cycleName: string;
  employeeId: string;
  canManage: boolean;
  goals: Goal[];
  statuses: { value: string; label: string }[];
}) {
  const [createState, createAction, createPending] = useActionState(createGoalAction, EMPTY);
  const [showNew, setShowNew] = useState(false);

  const badge = (s: string) => {
    switch (s) {
      case "ACHIEVED":
        return "b-grn";
      case "ACTIVE":
        return "b-blu";
      case "PARTIAL":
        return "b-amb";
      case "MISSED":
        return "b-red";
      default:
        return "b-gry";
    }
  };
  const statusLabel = (s: string) => statuses.find((x) => x.value === s)?.label ?? s;

  return (
    <div className="card" style={{ marginTop: 18 }}>
      <div className="card-h">
        <h3>Goals — {cycleName}</h3>
        {canManage ? (
          <button type="button" className="btn btn-pri" onClick={() => setShowNew((v) => !v)}>
            {showNew ? "Cancel" : "Add goal"}
          </button>
        ) : (
          <span className="hint">{goals.length}</span>
        )}
      </div>

      <div className="card-pad">
        <p className="faint" style={{ marginTop: 0 }}>
          Individual goals agreed for this cycle. Separate from the role scorecard KRAs scored below —
          these are the personal objectives set at goal-setting.
        </p>

        {canManage && showNew ? (
          <form action={createAction} className="appr-item" style={{ marginBottom: 14 }}>
            <input type="hidden" name="cycleId" value={cycleId} />
            <input type="hidden" name="employeeId" value={employeeId} />
            {createState.error ? <div className="form-err">{createState.error}</div> : null}
            <div className="appr-fields">
              <div className="field full">
                <label>Goal</label>
                <input name="title" placeholder="e.g. Grow advisory AUM by 15%" required />
                {createState.fieldErrors?.title ? (
                  <div className="form-err">{createState.fieldErrors.title}</div>
                ) : null}
              </div>
              <div className="field full">
                <label>Description (optional)</label>
                <input name="description" placeholder="Context or scope" />
              </div>
              <div className="field">
                <label>Measure (KPI)</label>
                <input name="measure" placeholder="e.g. AUM (₦)" />
              </div>
              <div className="field">
                <label>Target</label>
                <input name="target" placeholder="e.g. ₦500m" />
              </div>
              <div className="field">
                <label>Weight %</label>
                <input name="weight" type="number" min={0} max={100} placeholder="e.g. 30" />
              </div>
              <div className="field">
                <label>Due</label>
                <input name="dueDate" type="date" />
              </div>
              <div className="field">
                <label>Status</label>
                <select name="status" defaultValue="ACTIVE">
                  {statuses.map((s) => (
                    <option key={s.value} value={s.value}>
                      {s.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <button type="submit" className="btn btn-pri" disabled={createPending} style={{ marginTop: 10 }}>
              {createPending ? "Adding…" : "Add goal"}
            </button>
          </form>
        ) : null}

        {goals.length === 0 ? (
          <p className="faint" style={{ marginTop: 0 }}>
            No goals set for this cycle yet.
            {canManage ? " Use “Add goal” to set the first one." : ""}
          </p>
        ) : (
          <div className="appr-list">
            {goals.map((g) =>
              canManage ? (
                <GoalRow key={g.id} goal={g} statuses={statuses} badge={badge} statusLabel={statusLabel} />
              ) : (
                <div className="appr-ro" key={g.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kra">{g.title}</span>
                    <span className={`b ${badge(g.status)}`}>{statusLabel(g.status)}</span>
                  </div>
                  <div className="faint" style={{ fontSize: 12.5 }}>
                    {[g.measure ? `KPI · ${g.measure}` : null, g.target ? `Target ${g.target}` : null, g.weight != null ? `${g.weight}%` : null]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </div>
                  {g.description ? <div className="appr-note">{g.description}</div> : null}
                </div>
              )
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function GoalRow({
  goal,
  statuses,
  badge,
  statusLabel,
}: {
  goal: Goal;
  statuses: { value: string; label: string }[];
  badge: (s: string) => string;
  statusLabel: (s: string) => string;
}) {
  const [editState, editAction, editPending] = useActionState(updateGoalAction, EMPTY);
  const [delState, delAction, delPending] = useActionState(deleteGoalAction, EMPTY);
  const [editing, setEditing] = useState(false);

  if (!editing) {
    return (
      <div className="appr-ro">
        <div className="appr-ro-h">
          <span className="appr-kra">{goal.title}</span>
          <span className={`b ${badge(goal.status)}`}>{statusLabel(goal.status)}</span>
          <button type="button" className="btn" onClick={() => setEditing(true)}>
            Edit
          </button>
        </div>
        <div className="faint" style={{ fontSize: 12.5 }}>
          {[goal.measure ? `KPI · ${goal.measure}` : null, goal.target ? `Target ${goal.target}` : null, goal.weight != null ? `${goal.weight}%` : null, goal.dueDate ? `Due ${goal.dueDate}` : null]
            .filter(Boolean)
            .join(" · ") || "—"}
        </div>
        {goal.description ? <div className="appr-note">{goal.description}</div> : null}
      </div>
    );
  }

  return (
    <form action={editAction} className="appr-item">
      <input type="hidden" name="goalId" value={goal.id} />
      {editState.error ? <div className="form-err">{editState.error}</div> : null}
      <div className="appr-fields">
        <div className="field full">
          <label>Goal</label>
          <input name="title" defaultValue={goal.title} required />
        </div>
        <div className="field full">
          <label>Description</label>
          <input name="description" defaultValue={goal.description ?? ""} />
        </div>
        <div className="field">
          <label>Measure (KPI)</label>
          <input name="measure" defaultValue={goal.measure ?? ""} />
        </div>
        <div className="field">
          <label>Target</label>
          <input name="target" defaultValue={goal.target ?? ""} />
        </div>
        <div className="field">
          <label>Weight %</label>
          <input name="weight" type="number" min={0} max={100} defaultValue={goal.weight ?? ""} />
        </div>
        <div className="field">
          <label>Due</label>
          <input name="dueDate" type="date" defaultValue={goal.dueDate ?? ""} />
        </div>
        <div className="field">
          <label>Status</label>
          <select name="status" defaultValue={goal.status}>
            {statuses.map((s) => (
              <option key={s.value} value={s.value}>
                {s.label}
              </option>
            ))}
          </select>
        </div>
      </div>
      <div style={{ display: "flex", gap: 8, marginTop: 10, flexWrap: "wrap" }}>
        <button type="submit" className="btn btn-pri" disabled={editPending}>
          {editPending ? "Saving…" : "Save"}
        </button>
        <button type="button" className="btn" onClick={() => setEditing(false)}>
          Cancel
        </button>
        <button
          type="submit"
          className="btn"
          formAction={delAction}
          style={{ color: "var(--red)", borderColor: "var(--line)", marginLeft: "auto" }}
          disabled={delPending}
          onClick={(e) => {
            if (!confirm("Remove this goal?")) e.preventDefault();
          }}
        >
          {delPending ? "Removing…" : "Delete"}
        </button>
      </div>
    </form>
  );
}
