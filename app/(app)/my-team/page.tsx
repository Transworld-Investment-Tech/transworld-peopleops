import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getTeamGoalSetting, reviewStateBadge, fmtDate } from "@/lib/goal-agreement";

export const metadata = { title: "My team · Transworld PeopleOps" };

export default async function MyTeamPage() {
  const me = await requirePermission("performance.team");
  const data = await getTeamGoalSetting(me.id);

  if (!data.linked) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My team</h1>
            <p>Review and agree your direct reports’ goals for the cycle.</p>
          </div>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once it is, your direct reports will
                appear here.
              </div>
            </div>
          </div>
        </div>
      </>
    );
  }

  const { cycle, rows } = data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My team</h1>
          <p>
            Review and agree your direct reports’ goals for the cycle.
            {cycle ? ` Current cycle: ${cycle.name}.` : ""}
          </p>
        </div>
      </div>

      {!cycle ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No review cycle is open yet.</b> Goal-setting begins once HR opens the cycle.
              </div>
            </div>
          </div>
        </div>
      ) : rows.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No direct reports.</b> People who report to you in the org chart will appear here.
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div className="card">
          <div className="card-h">
            <h3>Direct reports — {cycle.name}</h3>
            <span className="hint">{rows.length}</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Role</th>
                <th>Goals</th>
                <th>Acknowledged</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const sb = reviewStateBadge(r.reviewState);
                const needsReview = r.reviewState === "SUBMITTED";
                return (
                  <tr key={r.employeeId}>
                    <td>
                      <Link href={`/my-team/${r.employeeId}`} className="jc-link">
                        {r.name}
                      </Link>
                      <div className="faint">EID {r.eeId}</div>
                    </td>
                    <td>{r.role ?? "—"}</td>
                    <td className="mono">{r.goalCount}</td>
                    <td>
                      {r.sealed ? (
                        r.acknowledged ? (
                          <span className="b b-grn">Yes</span>
                        ) : (
                          <span className="b b-amb">Pending</span>
                        )
                      ) : (
                        <span className="faint">—</span>
                      )}
                    </td>
                    <td>
                      <span className={`b ${sb.cls}`}>
                        <span className="dot" />
                        {sb.label}
                      </span>
                      {needsReview ? <span className="b b-blu" style={{ marginLeft: 6 }}>Review now</span> : null}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
