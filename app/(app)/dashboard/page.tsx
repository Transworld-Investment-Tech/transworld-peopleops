import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { ROLE_LABELS } from "@/lib/permissions";
import { getDashboardData } from "@/lib/dashboard";

export const metadata = { title: "Dashboard · Transworld PeopleOps" };

const capStyle = { fontSize: 12, marginTop: 6 } as const;
const linkStyle = { display: "inline-block", marginTop: 8 } as const;

export default async function DashboardPage() {
  // dashboard.view is granted to every role, so this only confirms the viewer
  // is authenticated; each tile below is gated by its own module permission
  // inside getDashboardData().
  const me = await requirePermission("dashboard.view");
  const d = await getDashboardData(me);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Dashboard</h1>
          <p>
            Signed in to the Transworld PeopleOps control room as {d.viewerName}. You see only the
            posture for areas your access already covers.
          </p>
        </div>
        {d.roleKeys.length ? (
          <div className="chips">
            {d.roleKeys.map((r) => (
              <span key={r} className="b b-blu">
                {ROLE_LABELS[r] ?? r}
              </span>
            ))}
          </div>
        ) : null}
      </div>

      {/* ---------------------------------------------------------------- */}
      {/* Organization posture (each tile gated by its module permission)   */}
      {/* ---------------------------------------------------------------- */}
      {d.hasOrgTiles ? (
        <>
          <div className="sec-t">Organization</div>
          <div className="grid kpis">
            {d.roster ? (
              <div className="card kpi">
                <div className="lab">Headcount</div>
                <div className="val">{d.roster.nonExited}</div>
                <div className="faint" style={capStyle}>
                  {d.roster.active} active · {d.roster.probation} probation
                  {d.roster.onLeave ? ` · ${d.roster.onLeave} on leave` : ""}
                  {d.roster.suspended ? ` · ${d.roster.suspended} suspended` : ""}
                </div>
                <Link href="/employees" className="jc-link" style={linkStyle}>
                  Employees →
                </Link>
              </div>
            ) : null}

            {d.logins ? (
              <div className="card kpi">
                <div className="lab">Active logins</div>
                <div className="val">{d.logins.active}</div>
                <div className="faint" style={capStyle}>
                  {d.logins.accounts} account{d.logins.accounts === 1 ? "" : "s"} ·{" "}
                  {d.logins.awaiting} awaiting a login
                </div>
                <Link href="/admin/users" className="jc-link" style={linkStyle}>
                  User management →
                </Link>
              </div>
            ) : null}

            {d.comp ? (
              <div className="card kpi">
                <div className="lab">Pending comp approvals</div>
                <div className="val">{d.comp.pending}</div>
                <div className="faint" style={capStyle}>
                  compensation change request{d.comp.pending === 1 ? "" : "s"} awaiting sign-off
                </div>
                <Link href="/compensation" className="jc-link" style={linkStyle}>
                  Compensation →
                </Link>
              </div>
            ) : null}

            {d.orgLeave ? (
              <div className="card kpi">
                <div className="lab">Pending leave</div>
                <div className="val">{d.orgLeave.pending}</div>
                <div className="faint" style={capStyle}>
                  {d.orgLeave.onLeaveThisWeek} on leave this week
                  {d.orgLeave.onLeaveName ? ` · ${d.orgLeave.onLeaveName}` : ""} · avg{" "}
                  {d.orgLeave.avgAnnualRemaining} days left
                </div>
                <Link href="/leave" className="jc-link" style={linkStyle}>
                  Leave →
                </Link>
              </div>
            ) : null}

            {d.learning ? (
              <div className="card kpi">
                <div className="lab">Learning completions</div>
                <div className="val">{d.learning.completions}</div>
                <div className="faint" style={capStyle}>
                  {d.learning.modules} module{d.learning.modules === 1 ? "" : "s"} ·{" "}
                  {d.learning.inProgress} in progress
                  {d.learning.overdue ? ` · ${d.learning.overdue} overdue` : ""}
                  {" · handbook "}
                  {d.learning.handbook.published
                    ? `${d.learning.handbook.acknowledged}/${d.learning.handbook.total} acknowledged`
                    : "not published"}
                </div>
                <Link href="/learning" className="jc-link" style={linkStyle}>
                  Learning →
                </Link>
              </div>
            ) : null}
          </div>
        </>
      ) : null}

      {/* ---------------------------------------------------------------- */}
      {/* Personal strip (useful to every signed-in staff member)          */}
      {/* ---------------------------------------------------------------- */}
      {d.hasPersonal ? (
        <>
          <div className={`sec-t${d.hasOrgTiles ? " mt" : ""}`}>Your space</div>
          <div className="grid kpis">
            {d.myLeave ? (
              d.myLeave.linked ? (
                <div className="card kpi">
                  <div className="lab">My annual leave left</div>
                  <div className="val">
                    {d.myLeave.annualRemaining ?? "—"} <span className="faint">days</span>
                  </div>
                  <div className="faint" style={capStyle}>
                    {d.myLeave.pending} pending request{d.myLeave.pending === 1 ? "" : "s"}
                  </div>
                  <Link href="/leave" className="jc-link" style={linkStyle}>
                    My leave →
                  </Link>
                </div>
              ) : (
                <div className="card kpi">
                  <div className="lab">My leave</div>
                  <div className="faint" style={{ marginTop: 8 }}>
                    Your login isn&rsquo;t linked to an employee record yet.
                  </div>
                </div>
              )
            ) : null}

            {d.myLearning && d.myLearning.linked ? (
              <div className="card kpi">
                <div className="lab">My learning</div>
                <div className="val">{d.myLearning.assigned}</div>
                <div className="faint" style={capStyle}>
                  assigned / in progress
                  {d.myLearning.overdue ? ` · ${d.myLearning.overdue} overdue` : ""}
                  {d.myLearning.available ? ` · ${d.myLearning.available} available` : ""}
                </div>
                <Link href="/learning" className="jc-link" style={linkStyle}>
                  My learning →
                </Link>
              </div>
            ) : null}

            {d.myHandbook && d.myHandbook.linked ? (
              <div className="card kpi">
                <div className="lab">Employee handbook</div>
                <div style={{ marginTop: 10 }}>
                  {!d.myHandbook.published ? (
                    <span className="b b-gry">Not published</span>
                  ) : d.myHandbook.acknowledged ? (
                    <span className="b b-grn">Acknowledged</span>
                  ) : (
                    <span className="b b-amb">Action needed</span>
                  )}
                </div>
                <div className="faint" style={capStyle}>
                  {!d.myHandbook.published
                    ? "no current version yet"
                    : d.myHandbook.acknowledged
                    ? "thank you — you're up to date"
                    : "please read and acknowledge"}
                </div>
                <Link href="/learning" className="jc-link" style={linkStyle}>
                  Open handbook →
                </Link>
              </div>
            ) : null}
          </div>
        </>
      ) : null}

      {!d.hasOrgTiles && !d.hasPersonal ? (
        <div className="note">
          <span>ℹ</span>
          <div>
            You&rsquo;re signed in. There&rsquo;s nothing to surface here for your current access —
            use the sidebar to reach the areas you can view.
          </div>
        </div>
      ) : null}
    </>
  );
}
