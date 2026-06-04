import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getWhistleblowerReports } from "@/lib/whistleblower";
import { wbStatusLabel, wbCategoryLabel, routeLabel, statusBadgeClass } from "@/lib/ws5";

export const metadata = { title: "Whistleblower · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function WhistleblowerPage() {
  const me = await requirePermission("whistleblower.access");
  const canExec = hasPermission(me, "whistleblower.exec");
  const rows = await getWhistleblowerReports(canExec);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Whistleblower</h1>
          <p>
            Protected disclosures. {canExec
              ? "You can see all reports, including those involving senior management."
              : "Reports that involve senior management are routed to the Chairman / BARC Chair and are not shown here."}
          </p>
        </div>
      </div>
      {rows.length === 0 ? (
        <div className="note"><span>ℹ</span><div>No reports to show.</div></div>
      ) : (
        <div className="card">
          <table>
            <thead><tr><th>Ref</th><th>Category</th><th>Route</th><th>Status</th><th>Reporter</th><th>Received</th><th></th></tr></thead>
            <tbody>
              {rows.map((r) => (
                <tr key={r.id}>
                  <td className="mono">{r.caseRef}</td>
                  <td>{wbCategoryLabel(r.category)}</td>
                  <td>{r.involvesSeniorManagement ? <span className="b b-red">{routeLabel(r.route)}</span> : routeLabel(r.route)}</td>
                  <td><span className={"b " + statusBadgeClass(r.status)}>{wbStatusLabel(r.status)}</span></td>
                  <td>{r.isAnonymous ? <span className="faint">Anonymous</span> : r.reporterName ?? "—"}</td>
                  <td>{fmtDate(r.receivedAt)}</td>
                  <td><Link href={`/whistleblower/${r.id}`} className="jc-link">Open</Link></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
