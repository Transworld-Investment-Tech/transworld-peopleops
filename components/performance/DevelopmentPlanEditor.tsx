"use client";
import { useActionState, useState } from "react";
import {
  createDevPlanAction,
  updateDevPlanAction,
  deleteDevPlanAction,
  type FormState,
} from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

type Item = {
  id: string;
  objective: string;
  action: string | null;
  support: string | null;
  targetDate: string | null; // ISO yyyy-mm-dd
  status: string;
};

export default function DevelopmentPlanEditor({
  employeeId,
  cycleId,
  appraisalId,
  canManage,
  items,
  statuses,
}: {
  employeeId: string;
  cycleId: string;
  appraisalId: string | null;
  canManage: boolean;
  items: Item[];
  statuses: { value: string; label: string }[];
}) {
  const [createState, createAction, createPending] = useActionState(createDevPlanAction, EMPTY);
  const [showNew, setShowNew] = useState(false);

  const badge = (s: string) =>
    s === "DONE" ? "b-grn" : s === "IN_PROGRESS" ? "b-blu" : "b-amb";
  const statusLabel = (s: string) => statuses.find((x) => x.value === s)?.label ?? s;

  return (
    <div className="card" style={{ marginTop: 18 }}>
      <div className="card-h">
        <h3>Development plan</h3>
        {canManage ? (
          <button type="button" className="btn btn-pri" onClick={() => setShowNew((v) => !v)}>
            {showNew ? "Cancel" : "Add objective"}
          </button>
        ) : (
          <span className="hint">{items.length}</span>
        )}
      </div>
      <div className="card-pad">
        <p className="faint" style={{ marginTop: 0 }}>
          Trackable development objectives for this person. The manager’s narrative note stays in the
          appraisal above; these are the discrete, status-tracked actions.
        </p>

        {canManage && showNew ? (
          <form action={createAction} className="appr-item" style={{ marginBottom: 14 }}>
            <input type="hidden" name="employeeId" value={employeeId} />
            <input type="hidden" name="cycleId" value={cycleId} />
            {appraisalId ? <input type="hidden" name="appraisalId" value={appraisalId} /> : null}
            {createState.error ? <div className="form-err">{createState.error}</div> : null}
            <div className="appr-fields">
              <div className="field full">
                <label>Objective</label>
                <input name="objective" placeholder="e.g. Strengthen client-reporting skills" required />
                {createState.fieldErrors?.objective ? (
                  <div className="form-err">{createState.fieldErrors.objective}</div>
                ) : null}
              </div>
              <div className="field full">
                <label>Action / how</label>
                <input name="action" placeholder="e.g. Complete reporting module + shadow senior analyst" />
              </div>
              <div className="field full">
                <label>Support needed</label>
                <input name="support" placeholder="e.g. Mentor time, course budget" />
              </div>
              <div className="field">
                <label>Target date</label>
                <input name="targetDate" type="date" />
              </div>
              <div className="field">
                <label>Status</label>
                <select name="status" defaultValue="OPEN">
                  {statuses.map((s) => (
                    <option key={s.value} value={s.value}>
                      {s.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <button type="submit" className="btn btn-pri" disabled={createPending} style={{ marginTop: 10 }}>
              {createPending ? "Adding…" : "Add objective"}
            </button>
          </form>
        ) : null}

        {items.length === 0 ? (
          <p className="faint" style={{ marginTop: 0 }}>
            No development objectives recorded yet.
          </p>
        ) : (
          <div className="appr-list">
            {items.map((it) =>
              canManage ? (
                <DevRow key={it.id} item={it} statuses={statuses} badge={badge} statusLabel={statusLabel} cycleId={cycleId} />
              ) : (
                <div className="appr-ro" key={it.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kra">{it.objective}</span>
                    <span className={`b ${badge(it.status)}`}>{statusLabel(it.status)}</span>
                  </div>
                  {it.action ? <div className="appr-note">{it.action}</div> : null}
                  <div className="faint" style={{ fontSize: 12.5 }}>
                    {[it.support ? `Support: ${it.support}` : null, it.targetDate ? `By ${it.targetDate}` : null]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </div>
                </div>
              )
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function DevRow({
  item,
  statuses,
  badge,
  statusLabel,
}: {
  item: Item;
  statuses: { value: string; label: string }[];
  badge: (s: string) => string;
  statusLabel: (s: string) => string;
  cycleId: string;
}) {
  const [editState, editAction, editPending] = useActionState(updateDevPlanAction, EMPTY);
  const [delState, delAction, delPending] = useActionState(deleteDevPlanAction, EMPTY);
  const [editing, setEditing] = useState(false);

  if (!editing) {
    return (
      <div className="appr-ro">
        <div className="appr-ro-h">
          <span className="appr-kra">{item.objective}</span>
          <span className={`b ${badge(item.status)}`}>{statusLabel(item.status)}</span>
          <button type="button" className="btn" onClick={() => setEditing(true)}>
            Edit
          </button>
        </div>
        {item.action ? <div className="appr-note">{item.action}</div> : null}
        <div className="faint" style={{ fontSize: 12.5 }}>
          {[item.support ? `Support: ${item.support}` : null, item.targetDate ? `By ${item.targetDate}` : null]
            .filter(Boolean)
            .join(" · ") || "—"}
        </div>
      </div>
    );
  }

  return (
    <form action={editAction} className="appr-item">
      <input type="hidden" name="planId" value={item.id} />
      {editState.error ? <div className="form-err">{editState.error}</div> : null}
      <div className="appr-fields">
        <div className="field full">
          <label>Objective</label>
          <input name="objective" defaultValue={item.objective} required />
        </div>
        <div className="field full">
          <label>Action / how</label>
          <input name="action" defaultValue={item.action ?? ""} />
        </div>
        <div className="field full">
          <label>Support needed</label>
          <input name="support" defaultValue={item.support ?? ""} />
        </div>
        <div className="field">
          <label>Target date</label>
          <input name="targetDate" type="date" defaultValue={item.targetDate ?? ""} />
        </div>
        <div className="field">
          <label>Status</label>
          <select name="status" defaultValue={item.status}>
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
            if (!confirm("Remove this objective?")) e.preventDefault();
          }}
        >
          {delPending ? "Removing…" : "Delete"}
        </button>
      </div>
      {delState.error ? <div className="form-err" style={{ marginTop: 8 }}>{delState.error}</div> : null}
    </form>
  );
}
