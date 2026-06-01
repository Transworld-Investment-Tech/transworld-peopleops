"use client";
import { useActionState, useState } from "react";
import { updatePipAction, type FormState } from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

type Item = { id: string; expectation: string; measure: string | null; result: string; note: string | null };

export default function PipManage({
  pipId,
  status,
  outcome,
  reviewDateIso,
  endDateIso,
  items,
  statuses,
  results,
}: {
  pipId: string;
  status: string;
  outcome: string | null;
  reviewDateIso: string | null;
  endDateIso: string | null;
  items: Item[];
  statuses: { value: string; label: string }[];
  results: { value: string; label: string }[];
}) {
  const [state, action, pending] = useActionState(updatePipAction, EMPTY);
  const [rows, setRows] = useState<Item[]>(() => items.map((i) => ({ ...i, note: i.note ?? "" })));

  function update(id: string, patch: Partial<Item>) {
    setRows((rs) => rs.map((r) => (r.id === id ? { ...r, ...patch } : r)));
  }

  const itemsPayload = JSON.stringify(rows.map((r) => ({ id: r.id, result: r.result, note: r.note })));

  return (
    <form action={action} className="card">
      <input type="hidden" name="pipId" value={pipId} />
      <input type="hidden" name="items" value={itemsPayload} />
      <div className="card-h">
        <h3>Manage plan</h3>
      </div>
      <div className="card-pad">
        {state.error ? <div className="form-err">{state.error}</div> : null}
        {state.ok ? (
          <div className="note" style={{ marginBottom: 10 }}>
            <span>✓</span>
            <div>{state.message ?? "Saved."}</div>
          </div>
        ) : null}

        <div className="appr-fields">
          <div className="field">
            <label>Status</label>
            <select name="status" defaultValue={status}>
              {statuses.map((s) => (
                <option key={s.value} value={s.value}>
                  {s.label}
                </option>
              ))}
            </select>
          </div>
          <div className="field">
            <label>Review date</label>
            <input name="reviewDate" type="date" defaultValue={reviewDateIso ?? ""} />
          </div>
          <div className="field">
            <label>End date</label>
            <input name="endDate" type="date" defaultValue={endDateIso ?? ""} />
          </div>
          <div className="field full">
            <label>Outcome / closing note</label>
            <textarea name="outcome" rows={2} defaultValue={outcome ?? ""} placeholder="Recorded when the plan is reviewed or closed" />
          </div>
        </div>

        {rows.length ? <div className="appr-sub" style={{ marginTop: 14 }}>Expectation results</div> : null}
        {rows.map((r) => (
          <div className="appr-item" key={r.id}>
            <div className="appr-item-h">
              <div>
                <div className="appr-kra">{r.expectation}</div>
                {r.measure ? <div className="appr-kpi">{r.measure}</div> : null}
              </div>
            </div>
            <div className="appr-fields">
              <div className="field">
                <label>Result</label>
                <select value={r.result} onChange={(e) => update(r.id, { result: e.target.value })}>
                  {results.map((x) => (
                    <option key={x.value} value={x.value}>
                      {x.label}
                    </option>
                  ))}
                </select>
              </div>
              <div className="field full">
                <label>Note (optional)</label>
                <input value={r.note ?? ""} onChange={(e) => update(r.id, { note: e.target.value })} placeholder="Evidence or context" />
              </div>
            </div>
          </div>
        ))}

        <div style={{ marginTop: 14 }}>
          <button type="submit" className="btn btn-pri" disabled={pending}>
            {pending ? "Saving…" : "Save plan"}
          </button>
        </div>
      </div>
    </form>
  );
}
