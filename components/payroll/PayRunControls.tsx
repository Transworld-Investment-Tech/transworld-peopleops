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

const initial: FormState = { ok: false };

export default function PayRunControls({
  cycleId, status, editable, canManage, canApprove, rows, totals, allConfirmed, isQuarterMonth,
}: {
  cycleId: string; status: string; editable: boolean; canManage: boolean; canApprove: boolean;
  rows: Row[]; totals: Totals; allConfirmed: boolean; isQuarterMonth: boolean;
}) {
  const [editId, setEditId] = useState<string | null>(null);
  const editing = rows.find((r) => r.id === editId) ?? null;

  return (
    <>
      <div className="card">
        <div className="card-h">
          <h3>Per-employee review</h3>
          <span className="hint">{rows.length} staff{isQuarterMonth ? " · quarter-end month" : ""}</span>
        </div>
        <div className="card-pad">
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
                {editable && canManage ? <th></th> : null}
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const b = badge(r.reviewStatus);
                return (
                  <tr key={r.id}>
                    <td>
                      {r.name}
                      <div className="faint mono">{r.eeId}{r.grade ? ` · ${r.grade}` : ""}</div>
                      {r.changeNote ? <div className="faint">✎ {r.changeNote}</div> : null}
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
                    {editable && canManage ? (
                      <td className="row-actions">
                        <button type="button" className="btn btn-sm" onClick={() => setEditId(r.id)}>Edit</button>
                        {r.reviewStatus !== "CONFIRMED" && r.reviewStatus !== "CHANGED" ? (
                          <form action={confirmRow} style={{ display: "inline" }}>
                            <input type="hidden" name="payItemId" value={r.id} />
                            <button type="submit" className="btn btn-sm btn-primary">Confirm</button>
                          </form>
                        ) : (
                          <form action={reopenRow} style={{ display: "inline" }}>
                            <input type="hidden" name="payItemId" value={r.id} />
                            <button type="submit" className="btn btn-sm">Reopen</button>
                          </form>
                        )}
                      </td>
                    ) : null}
                  </tr>
                );
              })}
            </tbody>
            <tfoot>
              <tr>
                <td><b>Total</b></td>
                <td className="num mono">{money(totals.basic)}</td>
                <td className="num mono">{money(totals.utility)}</td>
                <td className="num mono">{money(totals.gross)}</td>
                <td className="num mono">{money(totals.employeePension)}</td>
                <td className="num mono">{money(totals.nhf)}</td>
                <td className="num mono">{money(totals.itf)}</td>
                <td className="num mono">{money(totals.paye)}</td>
                <td className="num mono">{money(totals.net)}</td>
                <td className="num mono">{money(totals.quarterly)}</td>
                <td colSpan={editable && canManage ? 2 : 1}></td>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>

      {editing && editable && canManage ? (
        <RowEditor key={editing.id} row={editing} onDone={() => setEditId(null)} />
      ) : null}

      <FooterActions
        cycleId={cycleId} status={status} canManage={canManage} canApprove={canApprove}
        allConfirmed={allConfirmed} totals={totals}
      />
    </>
  );
}

function RowEditor({ row, onDone }: { row: Row; onDone: () => void }) {
  const [state, action, pending] = useActionState(adjustRowAction, initial);
  const [adj, setAdj] = useState<Adj[]>(row.adjustments ?? []);
  const [itf, setItf] = useState<boolean>(row.itf > 0 || (row.adjustments?.length ?? 0) >= 0);

  useEffect(() => { if (state.ok) onDone(); }, [state.ok, onDone]);

  function addAdj() { setAdj((a) => [...a, { label: "", amount: 0, kind: "DEDUCTION" }]); }
  function removeAdj(i: number) { setAdj((a) => a.filter((_, idx) => idx !== i)); }
  function setAdjField(i: number, patch: Partial<Adj>) {
    setAdj((a) => a.map((x, idx) => (idx === i ? { ...x, ...patch } : x)));
  }

  return (
    <div className="card">
      <div className="card-h">
        <h3>Adjust — {row.name} <span className="faint mono">{row.eeId}</span></h3>
        <button type="button" className="btn btn-sm" onClick={onDone}>Close</button>
      </div>
      <div className="card-pad">
        <form action={action} className="stack">
          <input type="hidden" name="payItemId" value={row.id} />
          <input type="hidden" name="adjustmentsJson" value={JSON.stringify(adj.filter((a) => a.label && a.amount))} />
          <div className="form-row">
            <label>Basic salary
              <input type="number" name="basicSalary" step="0.01" defaultValue={row.basicSalary} />
            </label>
            <label>Utility allowance
              <input type="number" name="utilityAllowance" step="0.01" defaultValue={row.utilityAllowance} />
            </label>
            <label>Quarterly allowance
              <input type="number" name="quarterlyAllowance" step="0.01" defaultValue={row.quarterlyAllowance} />
            </label>
          </div>
          <label className="check">
            <input type="checkbox" name="itfApplicable" defaultChecked={true} value="on" onChange={(e) => setItf(e.target.checked)} />
            Apply ITF (1% of basic). Uncheck to opt this person out.
          </label>

          <div className="sub-card">
            <div className="card-h">
              <b>Adjustments</b>
              <button type="button" className="btn btn-sm" onClick={addAdj}>+ Add line</button>
            </div>
            <p className="hint">For the quarterly lump, a special or leave allowance, or an unpaid-leave deduction.</p>
            {adj.length === 0 ? <p className="faint">No adjustments.</p> : null}
            {adj.map((a, i) => (
              <div className="form-row" key={i}>
                <input placeholder="Label (e.g. Unpaid leave — 3 days)" value={a.label} onChange={(e) => setAdjField(i, { label: e.target.value })} />
                <input type="number" step="0.01" placeholder="Amount" value={a.amount || ""} onChange={(e) => setAdjField(i, { amount: Number(e.target.value) })} />
                <select value={a.kind} onChange={(e) => setAdjField(i, { kind: e.target.value as Adj["kind"] })}>
                  <option value="DEDUCTION">Deduction (−)</option>
                  <option value="ALLOWANCE">Allowance (+)</option>
                </select>
                <button type="button" className="btn btn-sm" onClick={() => removeAdj(i)}>Remove</button>
              </div>
            ))}
          </div>

          <label>Note (what changed and why)
            <input type="text" name="changeNote" maxLength={500} defaultValue={row.changeNote ?? ""} placeholder="e.g. Quarterly lump applied; 3 days unpaid leave" />
          </label>

          {state.error ? <p className="err">{state.error}</p> : null}
          <div className="form-row">
            <button type="submit" className="btn btn-primary" disabled={pending}>{pending ? "Saving…" : "Save & confirm row"}</button>
            <button type="button" className="btn" onClick={onDone}>Cancel</button>
          </div>
        </form>
      </div>
    </div>
  );
}

function FooterActions({
  cycleId, status, canManage, canApprove, allConfirmed, totals,
}: {
  cycleId: string; status: string; canManage: boolean; canApprove: boolean; allConfirmed: boolean; totals: Totals;
}) {
  return (
    <div className="card">
      <div className="card-pad">
        <div className="totals-strip">
          <span>Gross <b className="mono">{money(totals.gross)}</b></span>
          <span>Deductions <b className="mono">{money(totals.totalDeductions)}</b></span>
          <span>Net <b className="mono">{money(totals.net)}</b></span>
          <span>Quarterly <b className="mono">{money(totals.quarterly)}</b></span>
          <span>Total payable <b className="mono">{money(totals.totalPayable)}</b></span>
          <span>Employer pension <b className="mono">{money(totals.employerPension)}</b></span>
        </div>

        <div className="form-row" style={{ marginTop: 12 }}>
          {status === "DRAFT" && canManage ? (
            <>
              <form action={submitForApproval}>
                <input type="hidden" name="cycleId" value={cycleId} />
                <button type="submit" className="btn btn-primary" disabled={!allConfirmed}>
                  Submit for approval
                </button>
              </form>
              {!allConfirmed ? <span className="hint">Confirm every row first.</span> : null}
              <form action={deleteDraftCycle}>
                <input type="hidden" name="cycleId" value={cycleId} />
                <button type="submit" className="btn btn-danger">Discard draft</button>
              </form>
            </>
          ) : null}

          {status === "IN_REVIEW" ? (
            canApprove ? (
              <form action={approveCycle}>
                <input type="hidden" name="cycleId" value={cycleId} />
                <button type="submit" className="btn btn-primary">Approve payroll</button>
              </form>
            ) : (
              <span className="note"><span>ℹ</span><div>Submitted — awaiting executive approval. Approval is a separate role from preparation.</div></span>
            )
          ) : null}

          {status === "APPROVED" ? (
            <>
              <a className="btn btn-primary" href={`/payroll/${cycleId}/export`}>Export control sheet (Excel)</a>
              {canApprove ? (
                <form action={lockCycle}>
                  <input type="hidden" name="cycleId" value={cycleId} />
                  <button type="submit" className="btn">Lock as evidence</button>
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
  );
}
