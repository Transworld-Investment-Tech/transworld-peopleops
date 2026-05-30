import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import JobCompetencyTabs from "@/components/jobcompetency/JobCompetencyTabs";
import { getCompetencies } from "@/lib/jobframework";

export const metadata = { title: "Competencies · Transworld PeopleOps" };

export default async function CompetenciesPage() {
  const me = await requirePermission("jobframework.view");
  const canManage = hasPermission(me, "jobframework.manage");
  const rows = await getCompetencies();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Job &amp; Competency Framework</h1>
          <p>The competency catalog — the master list of skills that job profiles draw from.</p>
        </div>
        {canManage ? (
          <Link href="/job-competency/competencies/new" className="btn btn-pri">
            + Add competency
          </Link>
        ) : (
          <button className="btn btn-pri" disabled title="Requires the Manage job & competency framework permission">
            + Add competency
          </button>
        )}
      </div>

      <JobCompetencyTabs />

      <div className="card">
        {rows.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No competencies yet.</b>
                {canManage ? " Add the first one to start building the catalog." : ""}
              </div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Competency</th>
                <th>Category</th>
                <th>Used by</th>
                {canManage ? <th aria-label="Actions" /> : null}
              </tr>
            </thead>
            <tbody>
              {rows.map((c) => (
                <tr key={c.id}>
                  <td>
                    <strong>{c.name}</strong>
                  </td>
                  <td>{c.category ?? "—"}</td>
                  <td className="mono">
                    {c.profileCount} profile{c.profileCount === 1 ? "" : "s"}
                  </td>
                  {canManage ? (
                    <td style={{ textAlign: "right" }}>
                      <Link href={`/job-competency/competencies/${c.id}/edit`} className="btn">
                        Edit
                      </Link>
                    </td>
                  ) : null}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
