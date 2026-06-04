import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getDisciplinaryCases } from "@/lib/disciplinary";
import { caseStatusLabel, stageLabel, statusBadgeClass } from "@/lib/ws5";

export const metadata = { title: "Disciplinary · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function DisciplinePage() {
  await requirePermission("discipline.manage");
  const cases = await getDisciplinaryCases();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Disciplinary</h1>
          <p>Conduct cases — the progressive procedure (E8). Capability shortfalls use a development plan, not this process.</p>
        </div>
        <Link href="/discipline/new" className="btn btn-pri">New case</Link>
      </div>

      {cases.length === 0 ? (
        <div className="note"><span>ℹ</span><div>No disciplinary cases on file.</div></div>
      ) : (
        <div className="card">
          <table>
            <thead>
              <tr><th>Employee</th><th>Concern</th><th>Stage</th><th>Status</th><th>Opened</th><th></th></tr>
            </thead>
            <tbody>
              {cases.map((c) => (
                <tr key={c.id}>
                  <td><b>{c.employeeName}</b>{c.isRegulatory ? <span className="b b-red" style={{ marginLeft: 6 }}>Regulatory</span> : null}</td>
                  <td className="faint">{c.concern.length > 60 ? c.concern.slice(0, 60) + "…" : c.concern}</td>
                  <td>{stageLabel(c.currentStage)}</td>
                  <td><span className={"b " + statusBadgeClass(c.status)}>{caseStatusLabel(c.status)}</span></td>
                  <td>{fmtDate(c.openedAt)}</td>
                  <td><Link href={`/discipline/${c.id}`} className="jc-link">Open</Link></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
