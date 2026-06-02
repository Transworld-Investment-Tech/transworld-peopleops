"use client";

import { useActionState, useEffect, useState } from "react";
import {
  setMultiplierAction,
  setRoundInputsAction,
  confirmRow,
  reopenRow,
  submitForApproval,
  approveRound,
  lockRound,
  deleteDraftRound,
  type FormState,
} from "@/lib/bonus-round-actions";

type Row = {
  id: string; eeId: string; name: string; grade: string; deferred: boolean;
  monthlySalary: number; targetMonths: number; targetBonus: number;
  multiplier: number; integrityGate: boolean; appraisalRating: string | null;
  calculatedBonus: number; awardedBonus: number; immediateAmount: number; deferredAmount: number;
  reviewStatus: string; note: string | null;
};
type Totals = { targetBonus: number; calculated: number; awarded: number; immediate: number; deferred: number };
type Reconciliation = {
  pbt: number; poolRate: number; poolAmount: number; totalCalculated: number;
  scalingFactor: number; withinPool: boolean; headroom: number;
};
type Tranche = {
  id: string; eeId: string; name: string; sequence: number; label: string;
  amount: number; scheduledMonth: number; scheduledYear: number; status: string;
};

const MONTHS = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];
function money(n: number): string {
  return "₦" + (n || 0).toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}
function awardBadge(s: string): { cls: string; label: string } {
  return s === "CONFIRMED" ? { cls: "b-grn", label: "Confirmed" } : { cls: "b-gry", label: "Pending" };
}
function trancheBadge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PAID": return { cls: "b-grn", label: "Paid" };
    case "CLAWED_BACK": return { cls: "b-red", label: "Clawed back" };
    case "FORFEITED": return { cls: "b-red", label: "Forfeited" };
    default: return { cls: "b-blu", label: "Scheduled" };
  }
}

const initial: FormState = { ok: false };

export default function BonusRoundControls({
  roundId, status, editable, canManage, canApprove, rows, totals, reconciliation, allConfirmed, confirmedCount, tranches,
}: {
  roundId: string; status: string; editable: boolean; canManage: boolean; canApprove: boolean;
  rows: Row[]; totals: Totals; reconciliation: Reconciliation;
  allConfirmed: boolean; confirmedCount: number; tranches: Tranche[];
}) {
  const [editId, setEditId] = useState<string | null>(null);
  const editing = rows.find((r) => r.id === editId) ?? null;
  const showActions = editable && canManage;

  return (
    <>
      {showActions ? <RoundInputsForm roundId={roundId} reconciliation={reconciliation} /> : null}

      <div className="card">
        <div className="card-h">
          <h3>Awards</h3>
          <span className="hint">{confirmedCount}/{rows.length} confirmed</span>
        </div>
        <table>
          <thead>
            <tr>
              <th>Employee</th>
              <th>Grade</th>
              <th className="num">Monthly salary</th>
              <th className="num">Target ×mo</th>
              <th className="num">Target bonus</th>
              <th className="num">Multiplier</th>
              <th className="num">Calculated</th>
              <th className="num">Awarded</th>
              <th>Status</th>
              {showActions ? <th></th> : null}
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => {
              const b = awardBadge(r.reviewStatus);
              return (
                <tr key={r.id} className={r.reviewStatus === "CONFIRMED" ? "is-confirmed" : ""}>
                  <td>
                    {r.name}
                    <div className="faint mono">{r.eeId}{r.deferred ? " · deferred" : ""}{r.appraisalRating ? ` · ${r.appraisalRating}` : ""}</div>
                    {r.note ? <div className="pay-note-inline">✎ {r.note}</div> : null}
                  </td>
                  <td>{r.grade}</td>
                  <td className="num mono">{money(r.monthlySalary)}</td>
                  <td className="num mono">{r.targetMonths}</td>
                  <td className="num mono">{money(r.targetBonus)}</td>
                  <td className="num mono">{r.integrityGate ? "×0 (gate)" : `×${r.multiplier}`}</td>
                  <td className="num mono">{money(r.calculatedBonus)}</td>
                  <td className="num mono">{money(r.awardedBonus)}</td>
                  <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                  {showActions ? (
                    <td className="pay-actions-cell">
                      <div className="pay-row-actions">
                        <button type="button" className="btn btn-xs" onClick={() => setEditId(r.id)}>Set</button>
                        {r.reviewStatus !== "CONFIRMED" ? (
                          <form action={confirmRow}>
                            <input type="hidden" name="awardId" value={r.id} />
                            <button type="submit" className="btn btn-xs btn-pri">Confirm</button>
                          </form>
                        ) : (
                          <form action={reopenRow}>
                            <input type="hidden" name="awardId" value={r.id} />
                            <button type="submit" className="btn btn-xs">Reopen</button>
                          </form>
                        )}
                      </div>
                    </td>
                  ) : null}
                </tr>
              );
            })}
          </tbody>
          <tfoot>
            <tr>
              <td colSpan={4}>Total</td>
              <td className="num mono">{money(totals.targetBonus)}</td>
              <td></td>
              <td className="num mono">{money(totals.calculated)}</td>
              <td className="num mono">{money(totals.awarded)}</td>
              <td colSpan={showActions ? 2 : 1}></td>
            </tr>
          </tfoot>
        </table>
      </div>

      <div className="card pay-bar">
        <div className="card-pad">
          <div className="pay-totals">
            <div className="t"><div className="t-lab">Pool</div><div className="t-val mono">{money(reconciliation.poolAmount)}</div></div>
            <div className="t"><div className="t-lab">Calculated</div><div className="t-val mono">{money(reconciliation.totalCalculated)}</div></div>
            <div className="t"><div className="t-lab">Scaling</div><div className="t-val mono">{(reconciliation.scalingFactor * 100).toFixed(1)}%</div></div>
            <div className="t payable"><div className="t-lab">Awarded</div><div className="t-val mono">{money(totals.awarded)}</div></div>
            <div className="t"><div className="t-lab">Immediate</div><div className="t-val mono">{money(totals.immediate)}</div></div>
            <div className="t"><div className="t-lab">Deferred</div><div className="t-val mono">{money(totals.deferred)}</div></div>
          </div>

          <div className="pay-bar-actions">
            {status === "DRAFT" && canManage ? (
              <>
                {!allConfirmed ? <span className="hint">Confirm every award to submit.</span> : null}
                <form action={deleteDraftRound}>
                  <input type="hidden" name="roundId" value={roundId} />
                  <button type="submit" className="btn btn-danger">Discard draft</button>
                </form>
                <form action={submitForApproval}>
                  <input type="hidden" name="roundId" value={roundId} />
                  <button type="submit" className="btn btn-pri" disabled={!allConfirmed}>Submit for approval</button>
                </form>
              </>
            ) : null}

            {status === "IN_REVIEW" ? (
              canApprove ? (
                <form action={approveRound}>
                  <input type="hidden" name="roundId" value={roundId} />
                  <button type="submit" className="btn btn-pri">Approve (Remuneration Committee)</button>
                </form>
              ) : (
                <span className="hint">Submitted — awaiting Remuneration Committee approval (a separate role from preparation).</span>
              )
            ) : null}

            {status === "APPROVED" ? (
              <>
                <a className="btn btn-pri" href={`/bonus/${roundId}/export`}>Export control sheet (Excel)</a>
                {canApprove ? (
                  <form action={lockRound}>
                    <input type="hidden" name="roundId" value={roundId} />
                    <button type="submit" className="btn btn-grn">Lock as evidence</button>
                  </form>
                ) : null}
              </>
            ) : null}

            {status === "LOCKED" ? (
              <a className="btn" href={`/bonus/${roundId}/export`}>Export control sheet (Excel)</a>
            ) : null}
          </div>
        </div>
      </div>

      {tranches.length > 0 ? (
        <div className="card" style={{ marginTop: 18 }}>
          <div className="card-h"><h3>Payment schedule (tranches)</h3><span className="hint">G4/G5 awards defer; everyone else is a single April tranche</span></div>
          <table>
            <thead>
              <tr><th>Employee</th><th>Tranche</th><th className="num">Amount</th><th>Scheduled</th><th>Status</th></tr>
            </thead>
            <tbody>
              {tranches.map((t) => {
                const b = trancheBadge(t.status);
                return (
                  <tr key={t.id}>
                    <td>{t.name}<div className="faint mono">{t.eeId}</div></td>
                    <td>{t.label}</td>
                    <td className="num mono">{money(t.amount)}</td>
                    <td>{MONTHS[t.scheduledMonth - 1] ?? t.scheduledMonth} {t.scheduledYear}</td>
                    <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : null}

      {editing && showActions ? (
        <MultiplierDrawer key={editing.id} row={editing} onClose={() => setEditId(null)} />
      ) : null}
    </>
  );
}

function RoundInputsForm({ roundId, reconciliation }: { roundId: string; reconciliation: Reconciliation }) {
  const [state, action, pending] = useActionState(setRoundInputsAction, initial);
  return (
    <div className="card" style={{ marginBottom: 18 }}>
      <div className="card-h"><h3>Pool inputs</h3><span className="hint">Pool = pool rate × PBT</span></div>
      <div className="card-pad">
        <form action={action}>
          <input type="hidden" name="roundId" value={roundId} />
          <div className="form-grid">
            <div className="field"><label>Profit before tax (PBT)</label>
              <input type="number" name="pbt" step="0.01" min={0} defaultValue={reconciliation.pbt} /></div>
            <div className="field"><label>Pool rate</label>
              <input type="number" name="poolRate" step="0.01" min={0} max={1} defaultValue={reconciliation.poolRate} /></div>
          </div>
          {state.error ? <div className="form-err" style={{ marginTop: 10 }}>{state.error}</div> : null}
          <div className="form-actions">
            <button type="submit" className="btn" disabled={pending}>{pending ? "Saving…" : "Update pool"}</button>
          </div>
        </form>
      </div>
    </div>
  );
}

function MultiplierDrawer({ row, onClose }: { row: Row; onClose: () => void }) {
  const [state, action, pending] = useActionState(setMultiplierAction, initial);
  const [multiplier, setMultiplier] = useState<number>(row.multiplier);
  const [gate, setGate] = useState<boolean>(row.integrityGate);

  useEffect(() => { if (state.ok) onClose(); }, [state.ok, onClose]);
  useEffect(() => {
    function onKey(e: KeyboardEvent) { if (e.key === "Escape") onClose(); }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const effective = gate ? 0 : Math.min(1.3, Math.max(0, multiplier));
  const preview = Math.round(row.targetBonus * effective * 100) / 100;

  return (
    <>
      <div className="pay-drawer-backdrop" onClick={onClose} />
      <div className="pay-drawer" role="dialog" aria-modal="true">
        <div className="pay-drawer-h">
          <div>
            <h3>Set multiplier</h3>
            <div className="faint mono" style={{ marginTop: 2 }}>{row.name} · {row.eeId} · {row.grade}</div>
          </div>
          <button type="button" className="btn btn-xs" onClick={onClose}>Close</button>
        </div>

        <form action={action} style={{ display: "contents" }}>
          <div className="pay-drawer-body">
            <input type="hidden" name="awardId" value={row.id} />

            <div className="comp-slip-row"><span className="comp-slip-lab">Target bonus ({row.targetMonths} mo × {money(row.monthlySalary)})</span><span className="comp-slip-val num mono">{money(row.targetBonus)}</span></div>
            {row.appraisalRating ? (
              <div className="comp-slip-row"><span className="comp-slip-lab">Appraisal rating (reference)</span><span className="comp-slip-val">{row.appraisalRating}</span></div>
            ) : null}

            <div className="field" style={{ marginTop: 12 }}>
              <label>Scorecard multiplier (×0 to ×1.3)</label>
              <input
                type="number" name="multiplier" step="0.01" min={0} max={1.3}
                value={multiplier}
                onChange={(e) => setMultiplier(Number(e.target.value))}
                disabled={gate}
              />
            </div>

            <label className="pay-check">
              <input type="checkbox" name="integrityGate" value="on" checked={gate} onChange={(e) => setGate(e.target.checked)} />
              Integrity / compliance gate — a serious breach forces the multiplier to ×0 (no bonus)
            </label>

            <div className="comp-slip-row net" style={{ marginTop: 12 }}>
              <span className="comp-slip-lab">Calculated bonus</span>
              <span className="comp-slip-val num mono">{money(preview)}</span>
            </div>
            <p className="hint" style={{ marginTop: 6 }}>Subject to pool reconciliation on approval. {row.deferred ? "G4/G5 — 65% immediate, 35% deferred over two years." : ""}</p>

            <div className="field" style={{ marginTop: 14 }}>
              <label>Note (optional)</label>
              <input type="text" name="note" maxLength={500} defaultValue={row.note ?? ""} placeholder="e.g. Exceeds expectations; calibrated at ×1.15" />
            </div>

            {state.error ? <div className="form-err" style={{ marginTop: 14 }}>{state.error}</div> : null}
          </div>

          <div className="pay-drawer-foot">
            <button type="button" className="btn" onClick={onClose}>Cancel</button>
            <button type="submit" className="btn btn-pri" disabled={pending}>{pending ? "Saving…" : "Save & confirm"}</button>
          </div>
        </form>
      </div>
    </>
  );
}
