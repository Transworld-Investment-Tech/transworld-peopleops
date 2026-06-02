"use client";

import { useActionState, useEffect, useState } from "react";
import {
  adjustRowAction,
  confirmRow,
  reopenRow,
  submitForApproval,
  approveCycle,
  lockCycle,
  deleteDraftCycle,
  type FormState,
} from "@/lib/payroll-cycle-actions";

type Adj = { label: string; amount: number; kind: "ALLOWANCE" | "DEDUCTION" };
type Row = {
  id: string; eeId: string; name: string; grade: string | null; payCategory: string | null;
  basicSalary: number; utilityAllowance: number; quarterlyAllowance: number;
  grossPay: number; employeePension: number; nhf: number; itf: number; payeTax: number;
  employerPension: number; netPay: number; totalPayable: number;
  adjustments: Adj[]; reviewStatus: string; changeNote: string | null;
};
type Totals = {
  basic: number; utility: number; quarterly: number; gross: number; employeePension: number;
  nhf: number; itf: number; paye: number; otherDeductions: number; totalDeductions: number;
  employerPension: number; net: number; totalPayable: number;
};

function money(n: number): string {
  return "₦" + (n || 0).toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}
function badge(s: string): { cls: string; label: string } {
  switch (s) {
    case "CONFIRMED": return { cls: "b-grn", label: "Confirmed" };
    case "CHANGED": return { cls: "b-amb", label: "Changed" };
    case "NEW": return { cls: "b-blu", label: "New" };
    default: return { cls: "b-gry", label: "Carried forward" };
  }
}
function rowClass(s: string): string {
  if (s === "CONFIRMED") return "is-confirmed";
  if (s === "CHANGED") return "is-changed";
  return "";
}

const initial: FormState = { ok: false };

export default function PayRunControls({
  cycleId, status, editable, canManage, canApprove, rows, totals, allConfirmed, isQuarterMonth,
}: {
  cycleId: string; status: string; editable: boolean; canManage: boolean; canApprove: boolean;
  rows: Row[]; totals: Totals; allConfirmed: boolean; isQuarterMonth: boolean;
}) {
  const [editId, setEditId] = useState<string | null>(null);
  const editing = rows.find((r) => r.id === editId) ?? null;
  const showActions = editable && canManage;

  return (
    <>
      <div className="card">
        <div className="card-h">
          <h3>Per-employee review</h3>
          <span className="hint">{rows.length} staff{isQuarterMonth ? " · quarter-end month" : ""}</span>
        </div>
        <table>
          <thead>
            <tr>
              <th>Employee</th>
              <th className="num">Basic</th>
              <th className="num">Utility</th>
              <th className="num">Gross</th>
              <th className="num">Pension</th>
              <th className="num">NHF</th>
              <th className="num">ITF</th>
              <th className="num">PAYE</th>
              <th className="num">Net</th>
              <th className="num">Qtrly</th>
              <th>Status</th>
              {showActions ? <th></th> : null}
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => {
              const b = badge(r.reviewStatus);
              return (
                <tr key={r.id} className={rowClass(r.reviewStatus)}>
                  <td>
                    {r.name}
                    <div className="faint mono">{r.eeId}{r.grade ? ` · ${r.grade}` : ""}</div>
                    {r.changeNote ? <div className="pay-note-inline">✎ {r.changeNote}</div> : null}
                  </td>
                  <td className="num mono">{money(r.basicSalary)}</td>
                  <td className="num mono">{money(r.utilityAllowance)}</td>
                  <td className="num mono">{money(r.grossPay)}</td>
                  <td className="num mono">{money(r.employeePension)}</td>
                  <td className="num mono">{money(r.nhf)}</td>
                  <td className="num mono">{money(r.itf)}</td>
                  <td className="num mono">{money(r.payeTax)}</td>
                  <td className="num mono">{money(r.netPay)}</td>
                  <td className="num mono">{r.quarterlyAllowance ? money(r.quarterlyAllowance) : "—"}</td>
                  <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                  {showActions ? (
                    <td className="pay-actions-cell">
                      <div className="pay-row-actions">
                        <button type="button" className="btn btn-xs" onClick={() => setEditId(r.id)}>Edit</button>
                        {r.reviewStatus !== "CONFIRMED" && r.reviewStatus !== "CHANGED" ? (
                          <form action={confirmRow}>
                            <input type="hidden" name="payItemId" value={r.id} />
                            <button type="submit" className="btn btn-xs btn-pri">Confirm</button>
                          </form>
                        ) : (
                          <form action={reopenRow}>
                            <input type="hidden" name="payItemId" value={r.id} />
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
              <td>Total</td>
              <td className="num mono">{money(totals.basic)}</td>
              <td className="num mono">{money(totals.utility)}</td>
              <td className="num mono">{money(totals.gross)}</td>
              <td className="num mono">{money(totals.employeePension)}</td>
              <td className="num mono">{money(totals.nhf)}</td>
              <td className="num mono">{money(totals.itf)}</td>
              <td className="num mono">{money(totals.paye)}</td>
              <td className="num mono">{money(totals.net)}</td>
              <td className="num mono">{money(totals.quarterly)}</td>
              <td colSpan={showActions ? 2 : 1}></td>
            </tr>
          </tfoot>
        </table>
      </div>

      <div className="card pay-bar">
        <div className="card-pad">
          <div className="pay-totals">
            <div className="t"><div className="t-lab">Gross</div><div className="t-val mono">{money(totals.gross)}</div></div>
            <div className="t"><div className="t-lab">Deductions</div><div className="t-val mono">{money(totals.totalDeductions)}</div></div>
            <div className="t"><div className="t-lab">Net</div><div className="t-val mono">{money(totals.net)}</div></div>
            <div className="t"><div className="t-lab">Quarterly</div><div className="t-val mono">{money(totals.quarterly)}</div></div>
            <div className="t payable"><div className="t-lab">Total payable</div><div className="t-val mono">{money(totals.totalPayable)}</div></div>
            <div className="t"><div className="t-lab">Employer pension</div><div className="t-val mono">{money(totals.employerPension)}</div></div>
          </div>

          <div className="pay-bar-actions">
            {status === "DRAFT" && canManage ? (
              <>
                {!allConfirmed ? <span className="hint">Confirm every row to submit.</span> : null}
                <form action={deleteDraftCycle}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-danger">Discard draft</button>
                </form>
                <form action={submitForApproval}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-pri" disabled={!allConfirmed}>Submit for approval</button>
                </form>
              </>
            ) : null}

            {status === "IN_REVIEW" ? (
              canApprove ? (
                <form action={approveCycle}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn btn-pri">Approve payroll</button>
                </form>
              ) : (
                <span className="hint">Submitted — awaiting executive approval (a separate role from preparation).</span>
              )
            ) : null}

            {status === "APPROVED" ? (
              <>
                <a className="btn btn-pri" href={`/payroll/${cycleId}/export`}>Export control sheet (Excel)</a>
                {canApprove ? (
                  <form action={lockCycle}>
                    <input type="hidden" name="cycleId" value={cycleId} />
                    <button type="submit" className="btn btn-grn">Lock as evidence</button>
                  </form>
                ) : null}
              </>
            ) : null}

            {status === "LOCKED" ? (
              <a className="btn" href={`/payroll/${cycleId}/export`}>Export control sheet (Excel)</a>
            ) : null}
          </div>
        </div>
      </div>

      {editing && showActions ? (
        <RowDrawer key={editing.id} row={editing} onClose={() => setEditId(null)} />
      ) : null}
    </>
  );
}

function RowDrawer({ row, onClose }: { row: Row; onClose: () => void }) {
  const [state, action, pending] = useActionState(adjustRowAction, initial);
  const [adj, setAdj] = useState<Adj[]>(row.adjustments ?? []);

  useEffect(() => { if (state.ok) onClose(); }, [state.ok, onClose]);
  useEffect(() => {
    function onKey(e: KeyboardEvent) { if (e.key === "Escape") onClose(); }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  function addAdj() { setAdj((a) => [...a, { label: "", amount: 0, kind: "DEDUCTION" }]); }
  function removeAdj(i: number) { setAdj((a) => a.filter((_, idx) => idx !== i)); }
  function setField(i: number, patch: Partial<Adj>) {
    setAdj((a) => a.map((x, idx) => (idx === i ? { ...x, ...patch } : x)));
  }

  return (
    <>
      <div className="pay-drawer-backdrop" onClick={onClose} />
      <div className="pay-drawer" role="dialog" aria-modal="true">
        <div className="pay-drawer-h">
          <div>
            <h3>Adjust row</h3>
            <div className="faint mono" style={{ marginTop: 2 }}>{row.name} · {row.eeId}</div>
          </div>
          <button type="button" className="btn btn-xs" onClick={onClose}>Close</button>
        </div>

        <form action={action} style={{ display: "contents" }}>
          <div className="pay-drawer-body">
            <input type="hidden" name="payItemId" value={row.id} />
            <input type="hidden" name="adjustmentsJson" value={JSON.stringify(adj.filter((a) => a.label && a.amount))} />

            <div className="form-grid">
              <div className="field"><label>Basic salary</label>
                <input type="number" name="basicSalary" step="0.01" defaultValue={row.basicSalary} /></div>
              <div className="field"><label>Utility allowance</label>
                <input type="number" name="utilityAllowance" step="0.01" defaultValue={row.utilityAllowance} /></div>
              <div className="field"><label>Quarterly allowance</label>
                <input type="number" name="quarterlyAllowance" step="0.01" defaultValue={row.quarterlyAllowance} /></div>
            </div>

            <label className="pay-check">
              <input type="checkbox" name="itfApplicable" defaultChecked value="on" />
              Apply ITF (1% of basic) — uncheck to opt this person out
            </label>

            <div className="pay-adj">
              <div className="pay-adj-h">
                <b>Adjustments</b>
                <button type="button" className="btn btn-xs" onClick={addAdj}>+ Add line</button>
              </div>
              <p className="hint" style={{ marginBottom: 8 }}>Quarterly lump, special/leave allowance, or an unpaid-leave deduction.</p>
              {adj.length === 0 ? <p className="faint" style={{ fontSize: 12.5 }}>No adjustments.</p> : null}
              {adj.map((a, i) => (
                <div className="pay-adj-line" key={i}>
                  <input placeholder="Label (e.g. Unpaid leave — 3 days)" value={a.label} onChange={(e) => setField(i, { label: e.target.value })} />
                  <input type="number" step="0.01" placeholder="Amount" value={a.amount || ""} onChange={(e) => setField(i, { amount: Number(e.target.value) })} />
                  <select value={a.kind} onChange={(e) => setField(i, { kind: e.target.value as Adj["kind"] })}>
                    <option value="DEDUCTION">Deduction (−)</option>
                    <option value="ALLOWANCE">Allowance (+)</option>
                  </select>
                  <button type="button" className="btn btn-xs" onClick={() => removeAdj(i)}>✕</button>
                </div>
              ))}
            </div>

            <div className="field" style={{ marginTop: 14 }}>
              <label>Note (what changed and why)</label>
              <input type="text" name="changeNote" maxLength={500} defaultValue={row.changeNote ?? ""} placeholder="e.g. Quarterly lump applied; 3 days unpaid leave" />
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
