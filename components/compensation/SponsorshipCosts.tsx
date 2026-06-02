"use client";

import { useActionState } from "react";
import {
  addCostAction,
  toggleWaiveCostAction,
  deleteCostAction,
  type FormState,
} from "@/lib/sponsorship-actions";
import { COST_TYPES, costTypeLabel } from "@/lib/sponsorship";

const initial: FormState = { ok: false };

export type CostDisplay = {
  id: string;
  typeLabel: string;
  description: string | null;
  amountText: string;
  incurredText: string;
  paid: boolean;
  waived: boolean;
};

function CostRowActions({ costId, waived }: { costId: string; waived: boolean }) {
  const [, waiveAction, waivePending] = useActionState(toggleWaiveCostAction, initial);
  const [, deleteAction, deletePending] = useActionState(deleteCostAction, initial);
  return (
    <span style={{ display: "inline-flex", gap: 6 }}>
      <form action={waiveAction} style={{ display: "inline" }}>
        <input type="hidden" name="costId" value={costId} />
        <button type="submit" className="btn btn-xs" disabled={waivePending}>
          {waived ? "Reinstate" : "Waive"}
        </button>
      </form>
      <form
        action={deleteAction}
        style={{ display: "inline" }}
        onSubmit={(e) => { if (!window.confirm("Remove this cost line?")) e.preventDefault(); }}
      >
        <input type="hidden" name="costId" value={costId} />
        <button type="submit" className="btn btn-xs btn-danger" disabled={deletePending}>
          Remove
        </button>
      </form>
    </span>
  );
}

function AddCostForm({ sponsorshipId }: { sponsorshipId: string }) {
  const [state, action, pending] = useActionState(addCostAction, initial);
  return (
    <form action={action} style={{ marginTop: 14 }}>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="form-grid">
        <div className="field">
          <label>Cost type</label>
          <select name="costType" defaultValue="TUITION">
            {COST_TYPES.map((t) => (
              <option key={t} value={t}>{costTypeLabel(t)}</option>
            ))}
          </select>
        </div>
        <div className="field">
          <label>Amount (₦)</label>
          <input type="number" name="amount" step="0.01" min={0} placeholder="e.g. 150000" />
        </div>
        <div className="field">
          <label>Incurred date (optional)</label>
          <input type="date" name="incurredDate" />
        </div>
        <div className="field">
          <label>Description (optional)</label>
          <input type="text" name="description" placeholder="e.g. Level I exam registration" />
        </div>
        <div className="field full">
          <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <input type="checkbox" name="paid" style={{ width: "auto" }} />
            <span>Already paid by the firm</span>
          </label>
        </div>
      </div>
      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending}>
          {pending ? "Adding…" : "Add cost line"}
        </button>
      </div>
    </form>
  );
}

export default function SponsorshipCosts({
  sponsorshipId,
  costs,
  canManage,
  locked,
}: {
  sponsorshipId: string;
  costs: CostDisplay[];
  canManage: boolean;
  locked: boolean;
}) {
  return (
    <>
      {costs.length === 0 ? (
        <p className="faint" style={{ marginTop: 0 }}>No cost lines recorded yet.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Type</th>
              <th>Description</th>
              <th className="num">Amount</th>
              <th>Incurred</th>
              <th>Paid</th>
              <th>Counts</th>
              {canManage ? <th></th> : null}
            </tr>
          </thead>
          <tbody>
            {costs.map((c) => (
              <tr key={c.id} style={c.waived ? { opacity: 0.6 } : undefined}>
                <td>{c.typeLabel}</td>
                <td>{c.description ?? "—"}</td>
                <td className="num mono">{c.amountText}</td>
                <td>{c.incurredText}</td>
                <td>{c.paid ? "Yes" : "No"}</td>
                <td>
                  {c.waived ? (
                    <span className="b b-gry">Waived</span>
                  ) : (
                    <span className="b b-blu">In exposure</span>
                  )}
                </td>
                {canManage ? (
                  <td>
                    <CostRowActions costId={c.id} waived={c.waived} />
                  </td>
                ) : null}
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {canManage && !locked ? <AddCostForm sponsorshipId={sponsorshipId} /> : null}
    </>
  );
}
