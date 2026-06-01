import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getPips, pipStatusBadge, fmtDate } from "@/lib/performance-toolkit";

export const metadata = { title: "Improvement plans · Transworld PeopleOps" };

export default async function PipListPage() {
  await requirePermission("performance.manage");
  const pips = await getPips();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance" className="back-link">
            ← Performance
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Performance improvement plans
          </h1>
          <p>Formal improvement plans with expectations, review dates, and staff acknowledgment.</p>
        </div>
        <Link href="/performance/pip/new" className="btn btn-pri">
          Open a plan
        </Link>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Plans</h3>
          <span className="hint">{pips.length}</span>
        </div>
        {pips.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No improvement plans yet.</b> Use “Open a plan” to start one for a staff member.
              </div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Plan</th>
                <th>Window</th>
                <th>Expectations</th>
                <th>Acknowledged</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {pips.map((p) => {
                const sb = pipStatusBadge(p.status);
                return (
                  <tr key={p.id}>
                    <td>
                      <Link href={`/performance/pip/${p.id}`} className="jc-link">
                        {p.employeeName}
                      </Link>
                      <div className="faint">EID {p.eeId}</div>
                    </td>
                    <td>{p.title}</td>
                    <td className="faint">
                      {fmtDate(p.startDate)} → {fmtDate(p.endDate)}
                    </td>
                    <td className="mono">{p.itemCount}</td>
                    <td>
                      {p.acknowledged ? (
                        <span className="b b-grn">Yes</span>
                      ) : (
                        <span className="b b-amb">Pending</span>
                      )}
                    </td>
                    <td>
                      <span className={`b ${sb.cls}`}>
                        <span className="dot" />
                        {sb.label}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
