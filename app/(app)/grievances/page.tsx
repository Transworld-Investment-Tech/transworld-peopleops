import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getGrievances } from "@/lib/grievances";
import { grievanceStatusLabel, grievanceFindingLabel, statusBadgeClass } from "@/lib/ws5";

export const metadata = { title: "Grievances · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function GrievancesPage() {
  await requirePermission("grievance.manage");
  const rows = await getGrievances();
  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Grievances</h1>
          <p>Formal grievances (E9). Acknowledge within 2 working days; findings within 15. Strict confidentiality throughout.</p>
        </div>
      </div>
      {rows.length === 0 ? (
        <div className="note"><span>ℹ</span><div>No grievances on file.</div></div>
      ) : (
        <div className="card">
          <table>
            <thead><tr><th>Complainant</th><th>Subject</th><th>Status</th><th>Finding</th><th>Target</th><th></th></tr></thead>
            <tbody>
              {rows.map((g) => (
                <tr key={g.id}>
                  <td><b>{g.complainantName}</b></td>
                  <td className="faint">{g.subject}</td>
                  <td><span className={"b " + statusBadgeClass(g.status)}>{grievanceStatusLabel(g.status)}</span></td>
                  <td>{grievanceFindingLabel(g.finding)}</td>
                  <td>{fmtDate(g.targetDate)}</td>
                  <td><Link href={`/grievances/${g.id}`} className="jc-link">Open</Link></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
