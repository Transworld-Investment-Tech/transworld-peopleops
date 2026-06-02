"use client";

import { useActionState, useEffect, useState } from "react";
import {
  markPaid,
  settleYear,
  clawbackAction,
  forfeitLeaverAction,
  reinstateAction,
  type FormState,
} from "@/lib/bonus-deferrals-actions";

type Tranche = {
  id: string;
  employeeId: string;
  eeId: string;
  name: string;
  grade: string;
  deferred: boolean;
  awardYear: number;
  roundLabel: string;
  sequence: number;
  label: string;
  amount: number;
  clawed: number;
  net: number;
  scheduledMonth: number;
  scheduledYear: number;
  status: string;
  paidAt: string | null;
};
type Employee = {
  employeeId: string;
  eeId: string;
  name: string;
  grade: string;
  scheduledNet: number;
  paidNet: number;
  clawedTotal: number;
  forfeitedAmount: number;
  tranches: Tranche[];
};

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
function monthLabel(m: number): string { return MONTHS[m - 1] ?? String(m); }
function money(n: number): string {
  return "₦" + (n || 0).toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}
function badge(s: string): { cls: string; label: string } {
  switch (s) {
    case "PAID": return { cls: "b-grn", label: "Paid" };
    case "CLAWED_BACK": return { cls: "b-red", label: "Clawed back" };
    case "FORFEITED": return { cls: "b-red", label: "Forfeited" };
    default: return { cls: "b-blu", label: "Scheduled" };
  }
}

const initial: FormState = { ok: false };

export default function DeferralControls({
  focusYear,
  dueThisYear,
  dueTotal,
  employees,
  canManage,
  canApprove,
}: {
  focusYear: number;
  dueThisYear: Tranche[];
  dueTotal: number;
  employees: Employee[];
  canManage: boolean;
  canApprove: boolean;
}) {
  const [clawbackId, setClawbackId] = useState<string | null>(null);
  const [reinstateId, setReinstateId] = useState<string | null>(null);
  const [leaverId, setLeaverId] = useState<string | null>(null);

  const [cbState, cbAction, cbPending] = useActionState(clawbackAction, initial);
  const [reState, reAction, rePending] = useActionState(reinstateAction, initial);
  const [lvState, lvAction, lvPending] = useActionState(forfeitLeaverAction, initial);

  useEffect(() => { if (cbState.ok) setClawbackId(null); }, [cbState]);
  useEffect(() => { if (reState.ok) setReinstateId(null); }, [reState]);
  useEffect(() => { if (lvState.ok) setLeaverId(null); }, [lvState]);

  const allTranches = employees.flatMap((e) => e.tranches);
  const find = (id: string | null) => (id ? allTranches.find((t) => t.id === id) ?? null : null);
  const clawTarget = find(clawbackId);
  const reinTarget = find(reinstateId);
  const leaver = leaverId ? employees.find((e) => e.employeeId === leaverId) ?? null : null;

  return (
    <>
      {/* Due in the focus April --------------------------------------------- */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3 className="serif">Due in April {focusYear}</h3>
          {canManage && dueThisYear.length > 0 ? (
            <form
              action={settleYear}
              onSubmit={(e) => {
                if (!confirm(`Mark all ${dueThisYear.length} tranches due in April ${focusYear} as paid (${money(dueTotal)})? Record only — payment is made in Remita.`)) {
                  e.preventDefault();
                }
              }}
            >
              <input type="hidden" name="year" value={focusYear} />
              <button type="submit" className="btn btn-pri btn-xs">
                Settle all due ({dueThisYear.length}) · {money(dueTotal)}
              </button>
            </form>
          ) : null}
        </div>
        {dueThisYear.length === 0 ? (
          <div className="card-pad"><p className="faint">Nothing scheduled for April {focusYear}.</p></div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Award</th>
                <th>Tranche</th>
                <th className="num">Net due</th>
                {canManage ? <th>Action</th> : null}
              </tr>
            </thead>
            <tbody>
              {dueThisYear.map((t) => (
                <tr key={t.id}>
                  <td>{t.name} <span className="faint mono">{t.eeId} · {t.grade}</span></td>
                  <td>{t.awardYear}</td>
                  <td>{t.label}</td>
                  <td className="num mono">{money(t.net)}</td>
                  {canManage ? (
                    <td>
                      <form action={markPaid}>
                        <input type="hidden" name="trancheId" value={t.id} />
                        <button type="submit" className="btn btn-grn btn-xs">Mark paid</button>
                      </form>
                    </td>
                  ) : null}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Inline forms (one shared each) ------------------------------------- */}
      {canApprove && clawTarget ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h"><h3 className="serif">Claw back — {clawTarget.name}, {clawTarget.label} ({clawTarget.awardYear})</h3></div>
          <div className="card-pad">
            <p className="hint">Net on this tranche: {money(clawTarget.net)}. Enter a partial or full amount to reclaim.</p>
            <form action={cbAction}>
              <input type="hidden" name="trancheId" value={clawTarget.id} />
              <div className="form-grid">
                <div className="field"><label>Amount to claw back</label>
                  <input type="number" name="amount" step="0.01" min={0.01} max={clawTarget.net} defaultValue={clawTarget.net} /></div>
                <div className="field"><label>Reason</label>
                  <input type="text" name="reason" maxLength={500} placeholder="e.g. restatement, misconduct finding" /></div>
              </div>
              <label className="hint" style={{ display: "block", marginTop: 8 }}>
                <input type="checkbox" name="boardOverride" /> Board-discretion decision
              </label>
              {cbState.error ? <div className="form-err" style={{ marginTop: 10 }}>{cbState.error}</div> : null}
              <div className="form-actions">
                <button type="submit" className="btn btn-danger" disabled={cbPending}>{cbPending ? "Working…" : "Claw back"}</button>
                <button type="button" className="btn" onClick={() => setClawbackId(null)}>Cancel</button>
              </div>
            </form>
          </div>
        </div>
      ) : null}

      {canApprove && reinTarget ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h"><h3 className="serif">Reinstate — {reinTarget.name}, {reinTarget.label} ({reinTarget.awardYear})</h3></div>
          <div className="card-pad">
            <p className="hint">Board-discretion override: return this forfeited tranche ({money(reinTarget.amount)}) to schedule.</p>
            <form action={reAction}>
              <input type="hidden" name="trancheId" value={reinTarget.id} />
              <div className="field"><label>Reason</label>
                <input type="text" name="reason" maxLength={500} placeholder="e.g. Board override of forfeiture" /></div>
              {reState.error ? <div className="form-err" style={{ marginTop: 10 }}>{reState.error}</div> : null}
              <div className="form-actions">
                <button type="submit" className="btn btn-pri" disabled={rePending}>{rePending ? "Working…" : "Reinstate to schedule"}</button>
                <button type="button" className="btn" onClick={() => setReinstateId(null)}>Cancel</button>
              </div>
            </form>
          </div>
        </div>
      ) : null}

      {canApprove && leaver ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h"><h3 className="serif">Process leaver — {leaver.name}</h3></div>
          <div className="card-pad">
            <p className="hint">
              {leaver.scheduledNet > 0
                ? `${money(leaver.scheduledNet)} is still scheduled across unpaid tranches.`
                : "No unpaid tranches remain."}{" "}
              A good leaver keeps unpaid tranches on schedule; a bad leaver forfeits them. Already-paid or clawed tranches are never affected.
            </p>
            <form action={lvAction}>
              <input type="hidden" name="employeeId" value={leaver.employeeId} />
              <div className="form-grid">
                <div className="field"><label>Classification</label>
                  <select name="classification" defaultValue="GOOD">
                    <option value="GOOD">Good leaver — keep on schedule</option>
                    <option value="BAD">Bad leaver — forfeit unpaid tranches</option>
                  </select></div>
                <div className="field"><label>Reason</label>
                  <input type="text" name="reason" maxLength={500} placeholder="e.g. resignation in good standing" /></div>
              </div>
              {lvState.error ? <div className="form-err" style={{ marginTop: 10 }}>{lvState.error}</div> : null}
              <div className="form-actions">
                <button type="submit" className="btn btn-pri" disabled={lvPending}>{lvPending ? "Working…" : "Apply leaver treatment"}</button>
                <button type="button" className="btn" onClick={() => setLeaverId(null)}>Cancel</button>
              </div>
            </form>
          </div>
        </div>
      ) : null}

      {/* All deferred balances by person ------------------------------------ */}
      <div className="sec-t" style={{ marginBottom: 10 }}>Deferred balances by person</div>
      {employees.length === 0 ? (
        <div className="card"><div className="card-pad"><p className="faint">No tranches recorded yet.</p></div></div>
      ) : (
        employees.map((e) => (
          <div className="card" key={e.employeeId} style={{ marginBottom: 14 }}>
            <div className="card-h">
              <h3 className="serif">{e.name} <span className="faint mono">{e.eeId} · {e.grade}</span></h3>
              <span className="hint">
                Scheduled {money(e.scheduledNet)} · Paid {money(e.paidNet)}
                {e.clawedTotal > 0 ? ` · Clawed ${money(e.clawedTotal)}` : ""}
                {e.forfeitedAmount > 0 ? ` · Forfeited ${money(e.forfeitedAmount)}` : ""}
                {canApprove && e.scheduledNet > 0 ? (
                  <>
                    {" · "}
                    <button type="button" className="btn btn-xs" onClick={() => setLeaverId(e.employeeId)}>Process leaver</button>
                  </>
                ) : null}
              </span>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Award</th>
                  <th>Tranche</th>
                  <th>Scheduled</th>
                  <th className="num">Amount</th>
                  <th className="num">Net</th>
                  <th>Status</th>
                  {canManage || canApprove ? <th>Actions</th> : null}
                </tr>
              </thead>
              <tbody>
                {e.tranches.map((t) => {
                  const b = badge(t.status);
                  return (
                    <tr key={t.id}>
                      <td>{t.awardYear}</td>
                      <td>{t.label}</td>
                      <td>{monthLabel(t.scheduledMonth)} {t.scheduledYear}</td>
                      <td className="num mono">{money(t.amount)}{t.clawed > 0 ? <span className="faint"> −{money(t.clawed)}</span> : null}</td>
                      <td className="num mono">{money(t.net)}</td>
                      <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                      {canManage || canApprove ? (
                        <td className="pay-row-actions">
                          {canManage && t.status === "SCHEDULED" && t.scheduledYear === focusYear ? (
                            <form action={markPaid} style={{ display: "inline" }}>
                              <input type="hidden" name="trancheId" value={t.id} />
                              <button type="submit" className="btn btn-grn btn-xs">Mark paid</button>
                            </form>
                          ) : null}
                          {canApprove && (t.status === "SCHEDULED" || t.status === "PAID") && t.net > 0 ? (
                            <button type="button" className="btn btn-xs" onClick={() => setClawbackId(t.id)}>Claw back</button>
                          ) : null}
                          {canApprove && t.status === "FORFEITED" ? (
                            <button type="button" className="btn btn-xs" onClick={() => setReinstateId(t.id)}>Reinstate</button>
                          ) : null}
                        </td>
                      ) : null}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        ))
      )}
    </>
  );
}
