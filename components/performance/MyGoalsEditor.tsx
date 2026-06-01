"use client";
import { useActionState, useState } from "react";
import {
  draftAddGoalAction,
  draftUpdateGoalAction,
  draftDeleteGoalAction,
  submitGoalSheetAction,
  acknowledgeAgreementAction,
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
  dueDate: string | null; // yyyy-mm-dd
  status: string;
};

type Sheet = {
  id: string;
  reviewState: string;
  changesNote: string | null;
  agreementNote: string | null;
  approvedAt: string | null;
  ackName: string | null;
  ackAt: string | null;
} | null;

export default function MyGoalsEditor({
  cycleName,
  managerName,
  sheet,
  goals,
  defaultName,
}: {
  cycleName: string;
  managerName: string | null;
  sheet: Sheet;
  goals: Goal[];
  defaultName: string;
}) {
  const state = sheet?.reviewState ?? "DRAFT";
  const editable = state === "DRAFT" || state === "CHANGES_REQUESTED";
  const approved = state === "APPROVED";
  const submitted = state === "SUBMITTED";

  return (
    <div className="card" style={{ marginBottom: 18 }}>
      <div className="card-h">
        <h3>My goals — {cycleName}</h3>
        <StateBadge state={state} />
      </div>
      <div className="card-pad">
        {state === "CHANGES_REQUESTED" && sheet?.changesNote ? (
          <div className="note" style={{ marginBottom: 12 }}>
            <span>↩</span>
            <div>
              <b>Your manager asked for changes:</b> {sheet.changesNote}
            </div>
          </div>
        ) : null}

        {submitted ? (
          <div className="note" style={{ marginBottom: 12 }}>
            <span>⏳</span>
            <div>
              <b>Submitted for review.</b> {managerName ? `${managerName} will review and agree these with you.` : "Your line manager will review these with you."} You can't edit while it's under review.
            </div>
          </div>
        ) : null}

        {approved ? (
          <ApprovedView sheet={sheet!} goals={goals} defaultName={defaultName} />
        ) : (
          <>
            <p className="faint" style={{ marginTop: 0 }}>
              {editable
                ? "Draft your goals for this cycle, then submit them to your line manager to review and agree. Once agreed, they're sealed for the cycle."
                : "These goals are locked."}
            </p>

            {goals.length === 0 ? (
              <p className="faint">No goals yet. Add your first below.</p>
            ) : (
              <div className="appr-list" style={{ marginBottom: 14 }}>
                {goals.map((g) =>
                  editable ? (
                    <DraftRow key={g.id} goal={g} />
                  ) : (
                    <ReadGoal key={g.id} goal={g} />
                  )
                )}
              </div>
            )}

            {editable ? <AddGoal /> : null}

            {editable && goals.length > 0 ? <SubmitBar managerName={managerName} /> : null}
          </>
        )}
      </div>
    </div>
  );
}

function StateBadge({ state }: { state: string }) {
  const map: Record<string, { cls: string; label: string }> = {
    APPROVED: { cls: "b-grn", label: "Approved & sealed" },
    SUBMITTED: { cls: "b-blu", label: "Submitted" },
    CHANGES_REQUESTED: { cls: "b-amb", label: "Changes requested" },
    DRAFT: { cls: "b-gry", label: "Draft" },
  };
  const b = map[state] ?? map.DRAFT;
  return (
    <span className={`b ${b.cls}`}>
      <span className="dot" />
      {b.label}
    </span>
  );
}

function ReadGoal({ goal }: { goal: Goal }) {
  return (
    <div className="appr-ro">
      <div className="appr-ro-h">
        <span className="appr-kra">{goal.title}</span>
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

function DraftRow({ goal }: { goal: Goal }) {
  const [editState, editAction, editPending] = useActionState(draftUpdateGoalAction, EMPTY);
  const [delState, delAction, delPending] = useActionState(draftDeleteGoalAction, EMPTY);
  const [editing, setEditing] = useState(false);

  if (!editing) {
    return (
      <div className="appr-ro">
        <div className="appr-ro-h">
          <span className="appr-kra">{goal.title}</span>
          <button type="button" className="btn" onClick={() => setEditing(true)} style={{ marginLeft: "auto", fontSize: 12, padding: "5px 10px" }}>
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
      <GoalFields g={goal} />
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
          disabled={delPending}
          style={{ color: "var(--red)", borderColor: "var(--line)", marginLeft: "auto" }}
          onClick={(e) => {
            if (!confirm("Remove this goal?")) e.preventDefault();
          }}
        >
          {delPending ? "Removing…" : "Delete"}
        </button>
      </div>
      {delState.error ? <div className="form-err" style={{ marginTop: 8 }}>{delState.error}</div> : null}
    </form>
  );
}

function AddGoal() {
  const [state, action, pending] = useActionState(draftAddGoalAction, EMPTY);
  const [open, setOpen] = useState(false);
  if (!open) {
    return (
      <button type="button" className="btn btn-pri" onClick={() => setOpen(true)}>
        Add a goal
      </button>
    );
  }
  return (
    <form action={action} className="appr-item">
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <GoalFields />
      <div style={{ display: "flex", gap: 8, marginTop: 10 }}>
        <button type="submit" className="btn btn-pri" disabled={pending}>
          {pending ? "Adding…" : "Add goal"}
        </button>
        <button type="button" className="btn" onClick={() => setOpen(false)}>
          Cancel
        </button>
      </div>
    </form>
  );
}

function GoalFields({ g }: { g?: Goal }) {
  return (
    <div className="appr-fields">
      <div className="field full">
        <label>Goal</label>
        <input name="title" defaultValue={g?.title ?? ""} placeholder="e.g. Grow advisory AUM by 15%" required />
      </div>
      <div className="field full">
        <label>Description (optional)</label>
        <input name="description" defaultValue={g?.description ?? ""} placeholder="Context or scope" />
      </div>
      <div className="field">
        <label>Measure (KPI)</label>
        <input name="measure" defaultValue={g?.measure ?? ""} placeholder="e.g. AUM (₦)" />
      </div>
      <div className="field">
        <label>Target</label>
        <input name="target" defaultValue={g?.target ?? ""} placeholder="e.g. ₦500m" />
      </div>
      <div className="field">
        <label>Weight %</label>
        <input name="weight" type="number" min={0} max={100} defaultValue={g?.weight ?? ""} />
      </div>
      <div className="field">
        <label>Due</label>
        <input name="dueDate" type="date" defaultValue={g?.dueDate ?? ""} />
      </div>
    </div>
  );
}

function SubmitBar({ managerName }: { managerName: string | null }) {
  const [state, action, pending] = useActionState(submitGoalSheetAction, EMPTY);
  return (
    <form action={action} style={{ marginTop: 16, borderTop: "1px solid var(--line)", paddingTop: 14 }}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <p className="faint" style={{ marginTop: 0 }}>
        When you're ready, submit these to {managerName ?? "your line manager"} to review and agree. You won't be
        able to edit while they're under review.
      </p>
      <button type="submit" className="btn btn-pri" disabled={pending}>
        {pending ? "Submitting…" : "Submit to my manager"}
      </button>
    </form>
  );
}

function ApprovedView({ sheet, goals, defaultName }: { sheet: NonNullable<Sheet>; goals: Goal[]; defaultName: string }) {
  return (
    <>
      <div className="note" style={{ marginBottom: 12 }}>
        <span>✓</span>
        <div>
          <b>Agreed & sealed.</b> These are your locked goals for the cycle. They stay on the record exactly as
          agreed.
        </div>
      </div>

      <div className="appr-list" style={{ marginBottom: 14 }}>
        {goals.map((g) => (
          <ReadGoal key={g.id} goal={g} />
        ))}
      </div>

      {sheet.agreementNote ? (
        <div className="field">
          <label>What was discussed and agreed</label>
          <p className="sc-mission" style={{ marginTop: 4 }}>{sheet.agreementNote}</p>
        </div>
      ) : null}

      {sheet.ackAt ? (
        <div className="note">
          <span>✓</span>
          <div>
            Acknowledged by {sheet.ackName} on {sheet.ackAt}.
          </div>
        </div>
      ) : (
        <Acknowledge sheetId={sheet.id} defaultName={defaultName} />
      )}
    </>
  );
}

function Acknowledge({ sheetId, defaultName }: { sheetId: string; defaultName: string }) {
  const [state, action, pending] = useActionState(acknowledgeAgreementAction, EMPTY);
  if (state.ok) {
    return (
      <div className="note">
        <span>✓</span>
        <div>{state.message ?? "Acknowledged."}</div>
      </div>
    );
  }
  return (
    <form action={action} style={{ borderTop: "1px solid var(--line)", paddingTop: 14 }}>
      <input type="hidden" name="sheetId" value={sheetId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <p style={{ marginTop: 0 }}>
        Please acknowledge that these are the goals you discussed and agreed with your manager. Your
        acknowledgment is recorded with your name, the time, and your IP address.
      </p>
      <div className="field" style={{ maxWidth: 360 }}>
        <label>Type your full name to acknowledge</label>
        <input name="ackName" defaultValue={defaultName} placeholder="Your full name" />
      </div>
      <label style={{ display: "flex", gap: 8, alignItems: "flex-start", marginTop: 8 }}>
        <input type="checkbox" name="consent" value="1" />
        <span className="faint">I confirm these are the goals I discussed and agreed for this cycle.</span>
      </label>
      <button type="submit" className="btn btn-pri" disabled={pending} style={{ marginTop: 12 }}>
        {pending ? "Recording…" : "Acknowledge & seal"}
      </button>
    </form>
  );
}
