"use client";
import { useActionState } from "react";
import {
  seedDefaultTasksAction,
  addTaskAction,
  setTaskStatusAction,
  setProbationAction,
  scheduleReviewAction,
  type FormState,
} from "@/lib/onboarding-actions";

const EMPTY: FormState = { ok: false };

export function SeedDefaultTasksButton({
  planId,
  employeeId,
}: {
  planId: string;
  employeeId: string;
}) {
  const [state, formAction, pending] = useActionState(seedDefaultTasksAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="planId" value={planId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      <button className="btn" type="submit" disabled={pending}>
        {pending ? "Adding…" : "Seed default tasks"}
      </button>
      {state.error ? <span className="form-err" style={{ marginLeft: 8 }}>{state.error}</span> : null}
    </form>
  );
}

export function TaskAddForm({ planId, employeeId }: { planId: string; employeeId: string }) {
  const [state, formAction, pending] = useActionState(addTaskAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  return (
    <form action={formAction}>
      <input type="hidden" name="planId" value={planId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div style={{ display: "flex", gap: 8, alignItems: "flex-end", flexWrap: "wrap" }}>
        <div className="field" style={{ flex: "2 1 220px" }}>
          <label htmlFor="label">New task</label>
          <input id="label" name="label" placeholder="e.g. Issue staff ID card" />
          {fe.label ? <div className="form-err">{fe.label}</div> : null}
        </div>
        <div className="field" style={{ flex: "1 1 130px" }}>
          <label htmlFor="category">Category</label>
          <input id="category" name="category" placeholder="e.g. IT" />
        </div>
        <div className="field" style={{ flex: "1 1 130px" }}>
          <label htmlFor="dueDate">Due (optional)</label>
          <input id="dueDate" name="dueDate" type="date" />
        </div>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Adding…" : "Add task"}
        </button>
      </div>
    </form>
  );
}

export function TaskStatusControl({
  taskId,
  employeeId,
  status,
}: {
  taskId: string;
  employeeId: string;
  status: string;
}) {
  const [state, formAction, pending] = useActionState(setTaskStatusAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline-flex", gap: 6 }}>
      <input type="hidden" name="taskId" value={taskId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      {status !== "DONE" ? (
        <button name="status" value="DONE" className="btn btn-grn" type="submit" disabled={pending} style={{ padding: "5px 10px" }}>
          Done
        </button>
      ) : (
        <button name="status" value="PENDING" className="btn" type="submit" disabled={pending} style={{ padding: "5px 10px" }}>
          Reopen
        </button>
      )}
      <button name="status" value="WAIVED" className="btn" type="submit" disabled={pending} style={{ padding: "5px 10px" }}>
        Waive
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function ProbationEditor({
  planId,
  employeeId,
  startDate,
  probationMonths,
}: {
  planId: string;
  employeeId: string;
  startDate: string; // yyyy-mm-dd or ""
  probationMonths: number;
}) {
  const [state, formAction, pending] = useActionState(setProbationAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "flex-end", flexWrap: "wrap" }}>
      <input type="hidden" name="planId" value={planId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      <div className="field" style={{ flex: "1 1 150px" }}>
        <label htmlFor="startDate">Start date</label>
        <input id="startDate" name="startDate" type="date" defaultValue={startDate} />
      </div>
      <div className="field" style={{ flex: "1 1 120px" }}>
        <label htmlFor="probationMonths">Probation (months)</label>
        <input
          id="probationMonths"
          name="probationMonths"
          type="number"
          min={0}
          max={24}
          defaultValue={probationMonths}
        />
      </div>
      <button className="btn" type="submit" disabled={pending}>
        {pending ? "Saving…" : "Save"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export function ScheduleReviewButton({
  planId,
  employeeId,
  scheduled,
}: {
  planId: string;
  employeeId: string;
  scheduled: boolean;
}) {
  const [state, formAction, pending] = useActionState(scheduleReviewAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="planId" value={planId} />
      <input type="hidden" name="employeeId" value={employeeId} />
      <button className="btn btn-pri" type="submit" disabled={pending} style={{ width: "100%" }}>
        {pending ? "Working…" : scheduled ? "30-day review scheduled ✓ — reschedule" : "Schedule 30-day review"}
      </button>
      {state.error ? <div className="form-err">{state.error}</div> : null}
    </form>
  );
}
