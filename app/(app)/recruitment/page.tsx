import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getRecruitmentOverview,
  getRequisitionFormOptions,
  openingStatusBadge,
} from "@/lib/recruitment";
import RaiseRequisitionForm from "@/components/recruitment/RaiseRequisitionForm";

export const metadata = { title: "Recruitment · Transworld PeopleOps" };

export default async function RecruitmentPage() {
  const me = await requirePermission("recruitment.view");
  const canManage = hasPermission(me, "recruitment.manage");
  const { kpis, openings } = await getRecruitmentOverview();
  const opts = canManage ? await getRequisitionFormOptions() : null;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Recruitment &amp; Talent Acquisition</h1>
          <p>Requisition → sourcing → screening → assessment → interview → offer.</p>
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Open requisitions</div>
          <div className="val">{kpis.openReqs}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Candidates in pipeline</div>
          <div className="val">{kpis.candidatesInPipeline}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Interviews this week</div>
          <div className="val">{kpis.interviewsThisWeek}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Offers out</div>
          <div className="val">{kpis.offersOut}</div>
        </div>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Requisitions</h3>
          <span className="hint">click a row to open its pipeline</span>
        </div>
        {openings.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>No requisitions yet{canManage ? " — raise one below." : "."}</div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Code</th>
                <th>Role</th>
                <th>Department</th>
                <th>Status</th>
                <th className="num">Headcount</th>
                <th className="num">Pipeline</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {openings.map((o) => {
                const b = openingStatusBadge(o.status);
                return (
                  <tr key={o.id}>
                    <td className="faint mono">{o.code}</td>
                    <td>
                      <b>{o.title}</b>
                      {o.grade ? <span className="faint"> · {o.grade}</span> : null}
                    </td>
                    <td>{o.departmentName ?? "—"}</td>
                    <td>
                      <span className={`b ${b.cls}`}>{b.label}</span>
                    </td>
                    <td className="num">{o.headcount}</td>
                    <td className="num">
                      {o.active}
                      <span className="faint"> / {o.total}</span>
                    </td>
                    <td className="num">
                      <Link href={`/recruitment/${o.id}`} className="jc-link">
                        Pipeline →
                      </Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {canManage && opts ? (
        <div className="card">
          <div className="card-h">
            <h3>Raise a requisition</h3>
            <span className="hint">creates a REQ-{new Date().getFullYear()}-NN code</span>
          </div>
          <div className="card-pad">
            <RaiseRequisitionForm departments={opts.departments} jobProfiles={opts.jobProfiles} />
          </div>
        </div>
      ) : null}
    </>
  );
}
