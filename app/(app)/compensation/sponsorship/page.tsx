import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { fmtNaira, getPendingRequestCount } from "@/lib/compensation";
import { getSponsorshipRegister } from "@/lib/sponsorship-reads";
import { sponsorshipStatusBadge } from "@/lib/sponsorship";
import CompTabs from "@/components/compensation/CompTabs";

export const metadata = { title: "Sponsorship · Transworld PeopleOps" };

export default async function SponsorshipPage() {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");

  const [reg, pendingCount] = await Promise.all([
    getSponsorshipRegister(),
    getPendingRequestCount(),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Qualification sponsorship</h1>
          <p>
            The firm&apos;s headline benefit (WS6 Part 4): Transworld sponsors the professional
            qualifications that define the craft — CIS, CFA, ICAN/ACCA and other agreed certifications.
            Each sponsorship records what is funded, any service commitment, and the outstanding
            repayment exposure if someone leaves early. Exposure is shown live; nothing is paid here.
          </p>
        </div>
        {canManage ? (
          <Link href="/compensation/sponsorship/new" className="btn btn-pri">
            New sponsorship
          </Link>
        ) : null}
      </div>

      <CompTabs active="sponsorship" pendingCount={pendingCount} />

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-pad">
          <div className="grid kpis">
            <div className="kpi"><div className="lab">Sponsorships</div><div className="val">{reg.rows.length}</div></div>
            <div className="kpi"><div className="lab">Active</div><div className="val">{reg.activeCount}</div></div>
            <div className="kpi"><div className="lab">Total committed</div><div className="val mono">{fmtNaira(reg.totalCommitted)}</div></div>
            <div className="kpi"><div className="lab">Outstanding exposure</div><div className="val mono">{fmtNaira(reg.totalExposure)}</div></div>
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-h"><h3 className="serif">Register</h3></div>
        {reg.rows.length === 0 ? (
          <div className="card-pad"><p className="faint">No sponsorships yet.</p></div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Qualification</th>
                <th>Status</th>
                <th className="num">Committed</th>
                <th className="num">Exposure</th>
                <th className="num">Bond</th>
              </tr>
            </thead>
            <tbody>
              {reg.rows.map((r) => {
                const b = sponsorshipStatusBadge(r.status);
                return (
                  <tr key={r.id}>
                    <td>
                      <Link href={`/compensation/sponsorship/${r.id}`} className="jc-link">
                        {r.employeeName}
                      </Link>
                      <div className="faint mono">{r.eeId}</div>
                    </td>
                    <td>
                      {r.qualificationName}
                      {r.awardingBody ? <div className="faint">{r.awardingBody}</div> : null}
                    </td>
                    <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                    <td className="num mono">{fmtNaira(r.committed)}</td>
                    <td className="num mono">{r.exposure > 0 ? fmtNaira(r.exposure) : "—"}</td>
                    <td className="num">
                      {r.bondingMonths ? `${r.bondingMonths} mo` : "—"}
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
