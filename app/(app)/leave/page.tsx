import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getLeavePageData,
  statusBadge,
  managerStatusBadge,
  fmtDays,
  type RequestRow,
} from "@/lib/leave";
import LeaveTabs from "@/components/leave/LeaveTabs";
import LeaveDecision from "@/components/leave/LeaveDecision";
import LeaveManagerReview from "@/components/leave/LeaveManagerReview";
import LeaveCancel from "@/components/leave/LeaveCancel";

export const metadata = { title: "Leave & Attendance · Transworld PeopleOps" };

function fmtDecided(d: Date): string {
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

function EmpCell({ r }: { r: RequestRow }) {
  return (
    <div className="emp">
      <span className="chip">{r.initials}</span>
      <span className="nm">{r.employeeName}</span>
    </div>
  );
}

export default async function LeavePage() {
  const me = await requirePermission("leave.view");
  const data = await getLeavePageData(me);
  const { viewer, kpis, approvalQueue, reviewQueue, orgRecent, myBalances, myRequests } = data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Leave &amp; Attendance</h1>
          <p>
            Requests, balances, and who’s out — approved leave feeds straight into payroll
            variance for unpaid leave.
          </p>
        </div>
        {viewer.employeeId ? (
          <Link href="/leave/request" className="btn btn-pri">
            Request leave
          </Link>
        ) : null}
      </div>

      <LeaveTabs active="requests" pendingCount={kpis?.pending ?? 0} showManage={viewer.canManage} />

      {/* KPIs ------------------------------------------------------------- */}
      {kpis ? (
        viewer.canManage ? (
          <div className="grid kpis" style={{ marginBottom: 18 }}>
            <div className="kpi">
              <div className="lab">Pending requests</div>
              <div className="val">{kpis.pending}</div>
              <div className="delta">{kpis.pendingCaption}</div>
            </div>
            <div className="kpi">
              <div className="lab">On leave this week</div>
              <div className="val">{kpis.onLeaveThisWeek}</div>
              <div className="delta">{kpis.onLeaveName ?? "—"}</div>
            </div>
            <div className="kpi">
              <div className="lab">Avg balance remaining</div>
              <div className="val">
                {kpis.avgAnnualRemaining} <span className="faint">days</span>
              </div>
              <div className="delta">annual</div>
            </div>
          </div>
        ) : (
          <div className="grid kpis" style={{ marginBottom: 18 }}>
            <div className="kpi">
              <div className="lab">Awaiting your review</div>
              <div className="val">{kpis.pending}</div>
              <div className="delta">{kpis.pendingCaption}</div>
            </div>
          </div>
        )
      ) : null}

      {/* Manager review queue -------------------------------------------- */}
      {viewer.isManager && reviewQueue.length ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Awaiting your review</h3>
            <span className="hint">you line-manage these people</span>
          </div>
          <div className="card-pad">
            {reviewQueue.map((r) => (
              <div key={r.id} className="comp-review" style={{ borderBottom: "1px solid var(--line)", paddingBottom: 14, marginBottom: 14 }}>
                <div className="emp" style={{ marginBottom: 6 }}>
                  <span className="chip">{r.initials}</span>
                  <span className="nm">{r.employeeName}</span>{" "}
                  <span className="faint mono">{r.eeId}</span>
                </div>
                <p className="faint" style={{ margin: "0 0 8px" }}>
                  {r.typeName} · {r.dateRange} · {fmtDays(r.days)} day{r.days === 1 ? "" : "s"}
                  {r.note ? ` · “${r.note}”` : ""}
                </p>
                <LeaveManagerReview requestId={r.id} />
              </div>
            ))}
          </div>
        </div>
      ) : null}

      {/* HR approval queue ------------------------------------------------ */}
      {viewer.canManage ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Requests</h3>
            <span className="hint">line-manager review, then your decision</span>
          </div>
          <div className="card-pad">
            {approvalQueue.length === 0 ? (
              <div className="note">
                <span>ℹ</span>
                <div>No requests are awaiting a decision.</div>
              </div>
            ) : (
              approvalQueue.map((r) => {
                const sb = statusBadge(r.status);
                const mb = managerStatusBadge(r.managerStatus);
                return (
                  <div
                    key={r.id}
                    style={{ borderBottom: "1px solid var(--line)", paddingBottom: 16, marginBottom: 16 }}
                  >
                    <div
                      style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 8 }}
                    >
                      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                        <EmpCell r={r} /> <span className="faint mono">{r.eeId}</span>
                      </div>
                      <span className={`b ${sb.cls}`}>{sb.label}</span>
                    </div>
                    <p className="faint" style={{ margin: "8px 0 0" }}>
                      {r.typeName} · {r.dateRange} · {fmtDays(r.days)} day{r.days === 1 ? "" : "s"}
                      {r.needsManager ? (
                        <>
                          {" · "}
                          <span className={`b ${mb.cls}`}>{mb.label}</span>
                          {r.managerReviewer ? ` by ${r.managerReviewer}` : ""}
                        </>
                      ) : (
                        " · no line manager — straight to HR"
                      )}
                    </p>
                    {r.note ? <p style={{ marginBottom: 0 }}>{r.note}</p> : null}
                    {r.managerNote ? (
                      <p className="faint" style={{ marginBottom: 0 }}>
                        Manager note: {r.managerNote}
                      </p>
                    ) : null}

                    {r.canDecide ? (
                      <div style={{ marginTop: 12 }}>
                        <LeaveDecision requestId={r.id} selfApproval={r.selfApproval} />
                      </div>
                    ) : r.awaitingManager ? (
                      <p className="hint" style={{ marginTop: 12 }}>
                        Waiting on {r.employeeName.split(" ")[0]}’s line manager to review before you
                        can decide.
                      </p>
                    ) : null}

                    {r.canCancel ? (
                      <div style={{ marginTop: 10 }}>
                        <LeaveCancel requestId={r.id} />
                      </div>
                    ) : null}
                  </div>
                );
              })
            )}
          </div>
        </div>
      ) : null}

      {/* Recently decided (HR) ------------------------------------------- */}
      {viewer.canManage && orgRecent.length ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Recently decided</h3>
          </div>
          <div className="card-pad">
            <table className="table">
              <thead>
                <tr>
                  <th>Employee</th>
                  <th>Type</th>
                  <th>Dates</th>
                  <th className="num">Days</th>
                  <th>Status</th>
                  <th>Decided</th>
                </tr>
              </thead>
              <tbody>
                {orgRecent.map((r) => {
                  const sb = statusBadge(r.status);
                  return (
                    <tr key={r.id}>
                      <td>
                        <EmpCell r={r} />
                      </td>
                      <td>{r.typeName}</td>
                      <td>{r.dateRange}</td>
                      <td className="num">{fmtDays(r.days)}</td>
                      <td>
                        <span className={`b ${sb.cls}`}>{sb.label}</span>
                        {r.selfApproval ? <span className="faint"> · self</span> : null}
                      </td>
                      <td className="faint">
                        {r.decidedAt ? fmtDecided(r.decidedAt) : "—"}
                        {r.approver ? ` · ${r.approver}` : ""}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      ) : null}

      {/* The viewer's own leave ------------------------------------------ */}
      {viewer.employeeId ? (
        <>
          <div className="card" style={{ marginBottom: 18 }}>
            <div className="card-h">
              <h3>My balances · {data.year}</h3>
            </div>
            <div className="card-pad">
              <div className="grid kpis">
                {myBalances.map((b) => (
                  <div className="kpi" key={b.leaveTypeId}>
                    <div className="lab">{b.typeName}</div>
                    <div className="val">{fmtDays(b.remaining)}</div>
                    <div className="delta">
                      {fmtDays(b.taken)} taken of {fmtDays(b.entitled)}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <div className="card">
            <div className="card-h">
              <h3>My requests</h3>
            </div>
            <div className="card-pad">
              {myRequests.length === 0 ? (
                <div className="note">
                  <span>ℹ</span>
                  <div>
                    You haven’t requested any leave yet.{" "}
                    <Link href="/leave/request" className="jc-link">
                      Request leave
                    </Link>
                    .
                  </div>
                </div>
              ) : (
                <table className="table">
                  <thead>
                    <tr>
                      <th>Type</th>
                      <th>Dates</th>
                      <th className="num">Days</th>
                      <th>Review</th>
                      <th>Status</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {myRequests.map((r) => {
                      const sb = statusBadge(r.status);
                      const mb = managerStatusBadge(r.managerStatus);
                      return (
                        <tr key={r.id}>
                          <td>{r.typeName}</td>
                          <td>{r.dateRange}</td>
                          <td className="num">{fmtDays(r.days)}</td>
                          <td>
                            {r.needsManager && r.status === "PENDING" ? (
                              <span className={`b ${mb.cls}`}>{mb.label}</span>
                            ) : (
                              <span className="faint">—</span>
                            )}
                          </td>
                          <td>
                            <span className={`b ${sb.cls}`}>{sb.label}</span>
                          </td>
                          <td>{r.canCancel ? <LeaveCancel requestId={r.id} /> : null}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              )}
            </div>
          </div>
        </>
      ) : (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                Your login isn’t linked to an employee record, so there’s no personal balance to
                show. HR can link it from the Employees module.
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
