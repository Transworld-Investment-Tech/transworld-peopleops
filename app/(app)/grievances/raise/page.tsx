import { requirePermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { getMyGrievances, getRespondentOptions } from "@/lib/grievances";
import { grievanceStatusLabel, grievanceFindingLabel, statusBadgeClass } from "@/lib/ws5";
import { RaiseGrievanceForm } from "@/components/grievances/GrievanceControls";

export const metadata = { title: "Raise a grievance · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function RaiseGrievancePage() {
  const me = await requirePermission("grievance.raise");
  const mine = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true } });
  const [respondents, myGrievances] = await Promise.all([
    getRespondentOptions(mine?.id),
    mine ? getMyGrievances(mine.id) : Promise.resolve([]),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Raise a grievance</h1>
          <p>A formal, confidential way to raise a workplace concern. People Ops coordinates an independent investigation.</p>
        </div>
      </div>

      {!mine ? (
        <div className="note"><span>ℹ</span><div>Your login isn’t linked to an employee record yet, so a grievance can’t be filed under your name. Please contact People Ops.</div></div>
      ) : (
        <>
          <div className="card">
            <div className="card-h"><h3>New grievance</h3></div>
            <div className="card-pad"><RaiseGrievanceForm respondents={respondents} /></div>
          </div>

          <div className="card mt">
            <div className="card-h"><h3>Your grievances</h3><span className="hint">{myGrievances.length}</span></div>
            {myGrievances.length === 0 ? (
              <div className="card-pad"><span className="faint">You haven’t raised any grievances.</span></div>
            ) : (
              <table>
                <thead><tr><th>Subject</th><th>Status</th><th>Finding</th><th>Raised</th></tr></thead>
                <tbody>
                  {myGrievances.map((g) => (
                    <tr key={g.id}>
                      <td>{g.subject}</td>
                      <td><span className={"b " + statusBadgeClass(g.status)}>{grievanceStatusLabel(g.status)}</span></td>
                      <td>{grievanceFindingLabel(g.finding)}</td>
                      <td>{fmtDate(g.createdAt)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      )}
    </>
  );
}
