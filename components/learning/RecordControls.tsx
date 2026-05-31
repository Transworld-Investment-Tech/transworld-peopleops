"use client";
import { useActionState, useState } from "react";
import {
  selfEnrollAction,
  updateRecordAction,
  deleteRecordAction,
  type FormState,
} from "@/lib/learning-actions";

const EMPTY: FormState = { ok: false };

// --- The signed-in learner's own progress on a module ----------------------
export function SelfLearning({
  moduleId,
  record,
  published,
}: {
  moduleId: string;
  record: { id: string; status: string; reflection: string | null } | null;
  published: boolean;
}) {
  const [enrollState, enrollAction, enrolling] = useActionState(selfEnrollAction, EMPTY);
  const [updState, updAction, updating] = useActionState(updateRecordAction, EMPTY);
  const [showReflect, setShowReflect] = useState(false);

  if (!record) {
    if (!published) return null;
    return (
      <div className="card mt">
        <div className="card-pad">
          <div className="ln-rec-actions">
            <form action={enrollAction}>
              <input type="hidden" name="moduleId" value={moduleId} />
              <button className="btn btn-pri" type="submit" disabled={enrolling}>
                {enrolling ? "Enrolling…" : "Enroll in this module"}
              </button>
            </form>
            <span className="faint">Add it to your learning and work through it at your own pace.</span>
          </div>
          {enrollState.error ? (
            <div className="form-err" style={{ marginTop: 10 }}>
              {enrollState.error}
            </div>
          ) : null}
        </div>
      </div>
    );
  }

  const closed = record.status === "COMPLETED" || record.status === "WAIVED";

  return (
    <div className="card mt">
      <div className="card-h">
        <h3>Your progress</h3>
      </div>
      <div className="card-pad">
        {record.status === "COMPLETED" ? (
          <p style={{ marginTop: 0 }}>
            <span className="b b-grn">
              <span className="dot" />
              Completed
            </span>
            {record.reflection ? (
              <span className="faint" style={{ marginLeft: 10 }}>
                Your note: “{record.reflection}”
              </span>
            ) : null}
          </p>
        ) : null}

        {!closed ? (
          <form action={updAction}>
            <input type="hidden" name="recordId" value={record.id} />
            {showReflect ? (
              <div className="field full" style={{ marginBottom: 12 }}>
                <label>What did you take away? (optional)</label>
                <textarea name="reflection" rows={3} placeholder="A sentence or two on what you learned." />
              </div>
            ) : null}
            <div className="ln-rec-actions">
              {record.status === "ASSIGNED" ? (
                <button className="btn" type="submit" name="op" value="START" disabled={updating}>
                  {updating ? "…" : "Start"}
                </button>
              ) : null}
              <button
                className="btn btn-grn"
                type="submit"
                name="op"
                value="COMPLETE"
                disabled={updating}
              >
                {updating ? "Saving…" : "Mark complete"}
              </button>
              {!showReflect ? (
                <button type="button" className="btn" onClick={() => setShowReflect(true)}>
                  Add a reflection
                </button>
              ) : null}
            </div>
            {updState.error ? (
              <div className="form-err" style={{ marginTop: 10 }}>
                {updState.error}
              </div>
            ) : null}
          </form>
        ) : null}
      </div>
    </div>
  );
}

// --- Management controls on a roster row (waive / reopen / remove) ----------
export function RosterControls({
  recordId,
  status,
}: {
  recordId: string;
  status: string;
}) {
  const [updState, updAction, updating] = useActionState(updateRecordAction, EMPTY);
  const [delState, delAction, deleting] = useActionState(deleteRecordAction, EMPTY);
  const closed = status === "COMPLETED" || status === "WAIVED";

  return (
    <div className="ln-rec-actions">
      {!closed ? (
        <form action={updAction}>
          <input type="hidden" name="recordId" value={recordId} />
          <button className="btn" type="submit" name="op" value="WAIVE" disabled={updating}>
            Waive
          </button>
        </form>
      ) : null}
      {status === "COMPLETED" || status === "WAIVED" ? (
        <form action={updAction}>
          <input type="hidden" name="recordId" value={recordId} />
          <button className="btn" type="submit" name="op" value="REOPEN" disabled={updating}>
            Reopen
          </button>
        </form>
      ) : null}
      <form action={delAction}>
        <input type="hidden" name="recordId" value={recordId} />
        <button className="btn" type="submit" disabled={deleting} title="Remove this assignment">
          Remove
        </button>
      </form>
      {(updState.error || delState.error) && (
        <span className="err">{updState.error || delState.error}</span>
      )}
    </div>
  );
}
