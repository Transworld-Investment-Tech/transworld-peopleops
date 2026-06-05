import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getLibrary, fmtMinutes, moduleStatusBadge } from "@/lib/learning";
import { domainLabel, levelLabel } from "@/lib/lms";
import LearningTabs from "@/components/learning/LearningTabs";

export const metadata = { title: "Learning & Development · Transworld PeopleOps" };

export default async function LearningPage() {
  const me = await requirePermission("learning.view");
  const canManage = hasPermission(me, "learning.manage");

  const { rows, kpis } = await getLibrary(canManage);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Learning &amp; Development</h1>
          <p>
            A self-serve library of training material and the employee handbook. Work
            through modules at your own pace; supervisors can recommend targeted modules
            off an appraisal.
          </p>
        </div>
        {canManage ? (
          <Link href="/learning/modules/new" className="btn btn-pri">
            New module
          </Link>
        ) : null}
      </div>

      <LearningTabs active="library" />

      <div className="kpis">
        <div className="kpi">
          <div className="lab">Published modules</div>
          <div className="val">{kpis.modules}</div>
        </div>
        <div className="kpi">
          <div className="lab">Completions</div>
          <div className="val">{kpis.completions}</div>
        </div>
        <div className="kpi">
          <div className="lab">In progress</div>
          <div className="val">{kpis.inProgress}</div>
        </div>
        <div className="kpi">
          <div className="lab">Overdue</div>
          <div className="val">{kpis.overdue}</div>
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Course library</h3>
          <span className="hint">{rows.length} module{rows.length === 1 ? "" : "s"}</span>
        </div>
        <div className="card-pad">
          {rows.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No modules yet.
              {canManage
                ? " Create one with “New module”, or seed the starter library with npm run learning:populate -- --commit."
                : " Check back soon."}
            </p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Code</th>
                  <th>Module</th>
                  <th>Domain</th>
                  <th>Competencies</th>
                  <th className="num">Time</th>
                  <th className="num">Enrolled</th>
                  <th>Completion</th>
                  {canManage ? <th>Status</th> : null}
                </tr>
              </thead>
              <tbody>
                {rows.map((r) => (
                  <tr key={r.id}>
                    <td className="mono faint">{r.code ?? "—"}</td>
                    <td>
                      <Link href={`/learning/modules/${r.id}`} className="jc-link">
                        {r.title}
                      </Link>
                      <div className="ln-meta" style={{ marginTop: 4 }}>
                        {r.level ? <span className="b b-gry">{levelLabel(r.level)}</span> : null}
                        {r.isMandatory ? <span className="b b-red">Mandatory</span> : null}
                      </div>
                    </td>
                    <td>{r.domain ? domainLabel(r.domain) : <span className="faint">{r.category}</span>}</td>
                    <td>
                      {r.competencies.length ? (
                        <div className="ln-tags">
                          {r.competencies.map((c) => (
                            <span key={c} className="ln-tag">
                              {c}
                            </span>
                          ))}
                        </div>
                      ) : (
                        <span className="faint">—</span>
                      )}
                    </td>
                    <td className="num faint">{fmtMinutes(r.estimatedMinutes)}</td>
                    <td className="num mono">{r.enrolled}</td>
                    <td>
                      <div className="ln-prog">
                        <span className={"bar" + (r.overdue ? " warn" : "")}>
                          <i style={{ width: `${r.completionPct}%` }} />
                        </span>
                        <span className="pct">{r.completionPct}%</span>
                      </div>
                    </td>
                    {canManage ? (
                      <td>
                        <span className={`b ${moduleStatusBadge(r.status).cls}`}>
                          {moduleStatusBadge(r.status).label}
                        </span>
                      </td>
                    ) : null}
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </>
  );
}
