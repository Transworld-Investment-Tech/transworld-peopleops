import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import JobCompetencyTabs from "@/components/jobcompetency/JobCompetencyTabs";
import { getJobProfilesForList, jdStatusBadge } from "@/lib/jobframework";

export const metadata = { title: "Job & Competency · Transworld PeopleOps" };

export default async function JobProfilesPage({
  searchParams,
}: {
  searchParams: Promise<{ status?: string }>;
}) {
  const me = await requirePermission("jobframework.view");
  const canManage = hasPermission(me, "jobframework.manage");
  const rows = await getJobProfilesForList();
  const { status } = await searchParams;
  const filter =
    status === "PUBLISHED" || status === "DRAFT" || status === "UNSTAFFED" ? status : null;

  const total = rows.length;
  const published = rows.filter((r) => r.status === "PUBLISHED").length;
  const draft = rows.filter((r) => r.status === "DRAFT").length;
  const unstaffed = rows.filter((r) => r.employeeCount === 0).length;

  const visible =
    filter === "PUBLISHED" ? rows.filter((r) => r.status === "PUBLISHED")
    : filter === "DRAFT" ? rows.filter((r) => r.status === "DRAFT")
    : filter === "UNSTAFFED" ? rows.filter((r) => r.employeeCount === 0)
    : rows;
  const filterLabel =
    filter === "PUBLISHED" ? "Published"
    : filter === "DRAFT" ? "Draft"
    : filter === "UNSTAFFED" ? "Unstaffed"
    : null;
  const activeStyle = { outline: "2px solid #1F4E79", outlineOffset: 2 } as const;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Job &amp; Competency Framework</h1>
          <p>
            Role definitions and the competencies each role requires. Job profiles set the
            titles shown across the Employee database and the org chart.
          </p>
        </div>
        {canManage ? (
          <Link href="/job-competency/new" className="btn btn-pri">
            + Add job profile
          </Link>
        ) : (
          <button className="btn btn-pri" disabled title="Requires the Manage job & competency framework permission">
            + Add job profile
          </button>
        )}
      </div>

      <JobCompetencyTabs />

      <div className="grid kpis">
        <Link className="card kpi" href="/job-competency" aria-current={!filter ? "page" : undefined} style={!filter ? activeStyle : undefined}>
          <div className="lab">Job profiles</div>
          <div className="val">{total}</div>
        </Link>
        <Link className="card kpi" href="/job-competency?status=PUBLISHED" aria-current={filter === "PUBLISHED" ? "page" : undefined} style={filter === "PUBLISHED" ? activeStyle : undefined}>
          <div className="lab">Published</div>
          <div className="val">{published}</div>
        </Link>
        <Link className="card kpi" href="/job-competency?status=DRAFT" aria-current={filter === "DRAFT" ? "page" : undefined} style={filter === "DRAFT" ? activeStyle : undefined}>
          <div className="lab">Draft</div>
          <div className="val">{draft}</div>
        </Link>
        <Link className="card kpi" href="/job-competency?status=UNSTAFFED" aria-current={filter === "UNSTAFFED" ? "page" : undefined} style={filter === "UNSTAFFED" ? activeStyle : undefined}>
          <div className="lab">Unstaffed</div>
          <div className="val">{unstaffed}</div>
        </Link>
      </div>

      {filterLabel ? (
        <p className="hint">
          Showing <b>{filterLabel}</b> — {visible.length} of {total}.{" "}
          <Link href="/job-competency" className="jc-link">Show all</Link>
        </p>
      ) : null}

      <div className="card">
        {visible.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                {total === 0 ? (
                  <>
                    <b>No job profiles yet.</b>
                    {canManage
                      ? " Use “Add job profile” to create the first one."
                      : " Ask an HR admin to create the first one."}
                  </>
                ) : (
                  <>
                    <b>Nothing matches this filter.</b>{" "}
                    <Link href="/job-competency" className="jc-link">Show all</Link>
                  </>
                )}
              </div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Title</th>
                <th>Grade</th>
                <th>Department</th>
                <th>Competencies</th>
                <th>Staff</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {visible.map((r) => {
                const s = jdStatusBadge(r.status);
                return (
                  <tr key={r.id}>
                    <td>
                      <Link href={`/job-competency/${r.id}`} className="jc-link">
                        {r.title}
                      </Link>
                    </td>
                    <td>{r.grade ?? "—"}</td>
                    <td>{r.department ?? "—"}</td>
                    <td className="mono">
                      {r.competencyCount}
                      {r.hasScorecard ? <span className="faint"> · 1 scorecard</span> : null}
                    </td>
                    <td className="mono">{r.employeeCount}</td>
                    <td>
                      <span className={"b " + s.cls}>
                        <span className="dot" />
                        {s.label}
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
