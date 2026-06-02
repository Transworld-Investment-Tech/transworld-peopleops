"use client";

import { useActionState, useEffect, useState } from "react";
import {
  setCycleInputsAction,
  setItemAction,
  submitForApproval,
  approveCycle,
  lockCycle,
  deleteDraftCycle,
  recomputeItems,
  type FormState,
} from "@/lib/raise-cycle-actions";

type Row = {
  id: string; employeeId: string; eeId: string; name: string; grade: string | null;
  included: boolean; excludeReason: string | null; capApplied: boolean;
  oldBasic: number; oldUtility: number; oldQuarterly: number; oldAnnualTotal: number;
  newBasic: number; newUtility: number; newQuarterly: number; newAnnualTotal: number;
  annualIncrease: number; oldGross: number; newGross: number;
  bandMin: number | null; bandMid: number | null; bandMax: number | null;
  bandFlag: string; appliedProfileId: string | null; note: string | null;
};
type Totals = {
  includedCount: number; excludedCount: number; totalAnnualIncrease: number;
  totalNewAnnual: number; totalOldAnnual: number; aboveMax: number; aboveMid: number; belowMin: number;
};

function money(n: number): string {
  return "₦" + (n || 0).toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}
function flagBadge(f: string): { cls: string; label: string } {
  switch (f) {
    case "ABOVE_MAX": return { cls: "b-red", label: "Above max" };
    case "ABOVE_MID": return { cls: "b-amb", label: "Above mid" };
    case "BELOW_MIN": return { cls: "b-red", label: "Below min" };
    default: return { cls: "b-gry", label: "Within band" };
  }
}

const initial: FormState = { ok: false };

export default function RaiseControls({
  cycleId, status, canManage, canApprove,
  milestoneLabel, raisePercent, revenueTarget, revenueObserved, revenueConfirmed, gap,
  effectiveDateIso, confirmedNote, rows, totals,
}: {
  cycleId: string; status: string; canManage: boolean; canApprove: boolean;
  milestoneLabel: string; raisePercent: number; revenueTarget: number;
  revenueObserved: number | null; revenueConfirmed: number | null; gap: number;
  effectiveDateIso: string; confirmedNote: string | null;
  rows: Row[]; totals: Totals;
}) {
  const [editId, setEditId] = useState<string | null>(null);
  const editing = rows.find((r) => r.id === editId) ?? null;
  const isDraft = status === "DRAFT";
  const showActions = isDraft && canManage;

  return (
    <>
      {showActions ? (
        <CycleInputsForm
          cycleId={cycleId}
          milestoneLabel={milestoneLabel}
          raisePercent={raisePercent}
          revenueTarget={revenueTarget}
          revenueObserved={revenueObserved}
          revenueConfirmed={revenueConfirmed}
          gap={gap}
          effectiveDateIso={effectiveDateIso}
          confirmedNote={confirmedNote}
        />
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Per-employee raise</h3>
          <span className="hint">{totals.includedCount} included{totals.excludedCount ? ` · ${totals.excludedCount} excluded` : ""}</span>
        </div>
        <table>
          <thead>
            <tr>
              <th>Employee</th>
              <th>Grade</th>
              <th className="num">Old annual</th>
              <th className="num">New annual</th>
              <th className="num">Increase</th>
              <th>Band</th>
              <th>Status</th>
              {showActions ? <th></th> : null}
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => {
              const fb = flagBadge(r.bandFlag);
              return (
                <tr key={r.id} className={r.included ? "" : "is-confirmed"}>
                  <td>
                    {r.name}
                    <div className="faint mono">
                      {r.eeId}
                      {r.capApplied ? " · capped at max" : ""}
                      {!r.included && r.excludeReason ? ` · ${r.excludeReason}` : ""}
                    </div>
                    {r.note ? <div className="pay-note-inline">✎ {r.note}</div> : null}
                  </td>
                  <td>{r.grade ?? "—"}</td>
                  <td className="num mono">{money(r.oldAnnualTotal)}</td>
                  <td className="num mono">{r.included ? money(r.newAnnualTotal) : "—"}</td>
                  <td className="num mono">{r.included ? money(r.annualIncrease) : "—"}</td>
                  <td><span className={`b ${fb.cls}`}>{fb.label}</span></td>
                  <td>
                    {r.included
                      ? <span className="b b-grn">Included</span>
                      : <span className="b b-gry">Excluded</span>}
                  </td>
                  {showActions ? (
                    <td className="pay-actions-cell">
                      <div className="pay-row-actions">
                        <button type="button" className="btn btn-xs" onClick={() => setEditId(r.id)}>Review</button>
                      </div>
                    </td>
                  ) : null}
                </tr>
              );
            })}
          </tbody>
          <tfoot>
            <tr>
              <td colSpan={2}>Total (included)</td>
              <td className="num mono">{money(totals.totalOldAnnual)}</td>
              <td className="num mono">{money(totals.totalNewAnnual)}</td>
              <td className="num mono">{money(totals.totalAnnualIncrease)}</td>
              <td colSpan={showActions ? 3 : 2}></td>
            </tr>
          </tfoot>
        </table>
      </div>

      <div className="card pay-bar">
        <div className="card-pad">
          <div className="pay-totals">
            <div className="t"><div className="t-lab">Included</div><div className="t-val mono">{totals.includedCount}</div></div>
            <div className="t"><div className="t-lab">Old annual</div><div className="t-val mono">{money(totals.totalOldAnnual)}</div></div>
            <div className="t payable"><div className="t-lab">New annual</div><div className="t-val mono">{money(totals.totalNewAnnual)}</div></div>
            <div className="t"><div className="t-lab">Annual increase</div><div className="t-val mono">{money(totals.totalAnnualIncrease)}</div></div>
            <div className="t"><div className="t-lab">Above max / mid</div><div className="t-val mono">{totals.aboveMax} / {totals.aboveMid}</div></div>
          </div>

          <div className="pay-bar-actions">
            {isDraft && canManage ? (
              <>
                <form action={recomputeItems}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn">Refresh from current profiles</button>
                </form>
                <form action={deleteDraftCycle}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-danger">Discard draft</button>
                </form>
                <form action={submitForApproval}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-pri">Submit for approval</button>
                </form>
                {revenueConfirmed === null ? (
                  <span className="hint">Record the CFO-confirmed revenue (above) before submitting.</span>
                ) : null}
              </>
            ) : null}

            {status === "IN_REVIEW" ? (
              canApprove ? (
                <form action={approveCycle}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-pri">Approve &amp; apply (Remuneration Committee)</button>
                </form>
              ) : (
                <span className="hint">Submitted — awaiting Remuneration Committee approval (a separate approver from the preparer).</span>
              )
            ) : null}

            {status === "APPROVED" && canApprove ? (
              <form action={lockCycle}>
                <input type="hidden" name="cycleId" value={cycleId} />
                <button type="submit" className="btn btn-grn">Lock as evidence</button>
              </form>
            ) : null}
          </div>
        </div>
      </div>

      {editing && showActions ? (
        <ItemDrawer key={editing.id} row={editing} raisePercent={raisePercent} onClose={() => setEditId(null)} />
      ) : null}
    </>
  );
}

function CycleInputsForm({
  cycleId, milestoneLabel, raisePercent, revenueTarget, revenueObserved, revenueConfirmed, gap,
  effectiveDateIso, confirmedNote,
}: {
  cycleId: string; milestoneLabel: string; raisePercent: number; revenueTarget: number;
  revenueObserved: number | null; revenueConfirmed: number | null; gap: number;
  effectiveDateIso: string; confirmedNote: string | null;
}) {
  const [state, action, pending] = useActionState(setCycleInputsAction, initial);
  return (
    <div className="card" style={{ marginBottom: 18 }}>
      <div className="card-h"><h3>Milestone &amp; raise</h3><span className="hint">Gap to milestone: {money(gap)}</span></div>
      <div className="card-pad">
        <form action={action}>
          <input type="hidden" name="cycleId" value={cycleId} />
          <div className="form-grid">
            <div className="field"><label>Milestone name</label>
              <input type="text" name="milestoneLabel" defaultValue={milestoneLabel} /></div>
            <div className="field"><label>Revenue target (₦)</label>
              <input type="number" name="revenueTarget" step="0.01" min={0} defaultValue={revenueTarget} /></div>
            <div className="field"><label>Firm-wide raise (%)</label>
              <input type="number" name="raisePercent" step="0.01" min={0} max={100} defaultValue={Math.round(raisePercent * 10000) / 100} /></div>
            <div className="field"><label>Effective date</label>
              <input type="date" name="effectiveDate" defaultValue={effectiveDateIso} /></div>
            <div className="field"><label>Revenue to date (₦)</label>
              <input type="number" name="revenueObserved" step="0.01" min={0} defaultValue={revenueObserved ?? ""} /></div>
            <div className="field"><label>CFO-confirmed revenue (₦) — set when the milestone is hit</label>
              <input type="number" name="revenueConfirmed" step="0.01" min={0} defaultValue={revenueConfirmed ?? ""} /></div>
            <div className="field"><label>Confirmation note (optional)</label>
              <input type="text" name="confirmedNote" maxLength={500} defaultValue={confirmedNote ?? ""} placeholder="e.g. Confirmed by CFO from May management accounts" /></div>
          </div>
          {state.error ? <div className="form-err" style={{ marginTop: 10 }}>{state.error}</div> : null}
          {state.ok && state.message ? <div className="note" style={{ marginTop: 10 }}><span>✓</span><div>{state.message}</div></div> : null}
          <p className="hint" style={{ marginTop: 8 }}>
            Changing the percentage recomputes every row from its current snapshot. The same percentage
            applies to basic, utility and quarterly — total annual compensation rises by exactly that
            percentage.
          </p>
          <div className="form-actions">
            <button type="submit" className="btn" disabled={pending}>{pending ? "Saving…" : "Save milestone & raise"}</button>
          </div>
        </form>
      </div>
    </div>
  );
}

function ItemDrawer({ row, raisePercent, onClose }: { row: Row; raisePercent: number; onClose: () => void }) {
  const [state, action, pending] = useActionState(setItemAction, initial);
  const [included, setIncluded] = useState<boolean>(row.included);
  const [cap, setCap] = useState<boolean>(row.capApplied);

  useEffect(() => { if (state.ok) onClose(); }, [state.ok, onClose]);
  useEffect(() => {
    function onKey(e: KeyboardEvent) { if (e.key === "Escape") onClose(); }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const pct = `${Math.round(raisePercent * 10000) / 100}%`;

  return (
    <>
      <div className="pay-drawer-backdrop" onClick={onClose} />
      <div className="pay-drawer" role="dialog" aria-modal="true">
        <div className="pay-drawer-h">
          <div>
            <h3>Review row</h3>
            <div className="faint mono" style={{ marginTop: 2 }}>{row.name} · {row.eeId} · {row.grade ?? "no grade"}</div>
          </div>
          <button type="button" className="btn btn-xs" onClick={onClose}>Close</button>
        </div>

        <form action={action} style={{ display: "contents" }}>
          <div className="pay-drawer-body">
            <input type="hidden" name="itemId" value={row.id} />

            <div className="comp-slip-row"><span className="comp-slip-lab">Basic (monthly)</span><span className="comp-slip-val num mono">{money(row.oldBasic)} → {money(row.newBasic)}</span></div>
            <div className="comp-slip-row"><span className="comp-slip-lab">Utility (monthly)</span><span className="comp-slip-val num mono">{money(row.oldUtility)} → {money(row.newUtility)}</span></div>
            <div className="comp-slip-row"><span className="comp-slip-lab">Quarterly</span><span className="comp-slip-val num mono">{money(row.oldQuarterly)} → {money(row.newQuarterly)}</span></div>
            <div className="comp-slip-row sub"><span className="comp-slip-lab">Monthly gross (basic + utility)</span><span className="comp-slip-val num mono">{money(row.oldGross)} → {money(row.newGross)}</span></div>
            <div className="comp-slip-row net"><span className="comp-slip-lab">Annual total ({pct})</span><span className="comp-slip-val num mono">{money(row.oldAnnualTotal)} → {money(row.newAnnualTotal)}</span></div>
            {row.bandMax !== null ? (
              <div className="comp-slip-row"><span className="comp-slip-lab">Band (min / mid / max)</span><span className="comp-slip-val num mono">{money(row.bandMin ?? 0)} / {money(row.bandMid ?? 0)} / {money(row.bandMax)}</span></div>
            ) : <div className="comp-slip-row"><span className="comp-slip-lab">Band</span><span className="comp-slip-val faint">no band for this grade</span></div>}

            <label className="pay-check" style={{ marginTop: 12 }}>
              <input type="checkbox" name="included" value="on" checked={included} onChange={(e) => setIncluded(e.target.checked)} />
              Include this employee in the raise
            </label>

            {!included ? (
              <div className="field" style={{ marginTop: 8 }}>
                <label>Reason for excluding (optional)</label>
                <input type="text" name="excludeReason" maxLength={300} defaultValue={row.excludeReason ?? ""} placeholder="e.g. On probation; recent individual adjustment" />
              </div>
            ) : null}

            <label className="pay-check" style={{ marginTop: 8 }}>
              <input type="checkbox" name="cap" value="on" checked={cap} onChange={(e) => setCap(e.target.checked)} disabled={row.bandMax === null} />
              Cap at band maximum (hold monthly gross at max; all components scaled to fit)
            </label>

            <div className="field" style={{ marginTop: 12 }}>
              <label>Note (optional)</label>
              <input type="text" name="note" maxLength={500} defaultValue={row.note ?? ""} placeholder="e.g. RemCom acknowledged above-max placement" />
            </div>

            {state.error ? <div className="form-err" style={{ marginTop: 14 }}>{state.error}</div> : null}
          </div>

          <div className="pay-drawer-foot">
            <button type="button" className="btn" onClick={onClose}>Cancel</button>
            <button type="submit" className="btn btn-pri" disabled={pending}>{pending ? "Saving…" : "Save row"}</button>
          </div>
        </form>
      </div>
    </>
  );
}
