import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getMyLearning, fmtMinutes, recordStatusBadge, sourceBadge } from "@/lib/learning";
import LearningTabs from "@/components/learning/LearningTabs";

export const metadata = { title: "My learning · Transworld PeopleOps" };

export default async function MyLearningPage() {
  const me = await requirePermission("learning.view");
  const data = await getMyLearning(me.id);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My learning</h1>
          <p>Modules assigned to you and recommended for your development.</p>
        </div>
      </div>

      <LearningTabs active="my" />

      {!data.linked ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once staff logins are
                provisioned, your assigned and recommended modules will appear here. In the
                meantime, browse the <Link href="/learning" className="jc-link">library</Link>.
              </div>
            </div>
          </div>
        </div>
      ) : (
        <>
          <div className="card">
            <div className="card-h">
              <h3>Assigned to me</h3>
              <span className="hint">{data.records.length} module{data.records.length === 1 ? "" : "s"}</span>
            </div>
            <div className="card-pad">
              {data.records.length === 0 ? (
                <p className="faint" style={{ marginTop: 0 }}>
                  Nothing assigned yet. Enroll in anything from the library below.
                </p>
              ) : (
                <table>
                  <thead>
                    <tr>
                      <th>Module</th>
                      <th>Source</th>
                      <th>Status</th>
                      <th>Due</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.records.map((r) => {
                      const sb = recordStatusBadge(r.status, r.dueDate);
                      const src = sourceBadge(r.source);
                      return (
                        <tr key={r.recordId}>
                          <td>
                            <Link href={`/learning/modules/${r.moduleId}`} className="jc-link">
                              {r.title}
                            </Link>
                            <div className="faint">{r.category}</div>
                          </td>
                          <td>
                            <span className={`b ${src.cls}`}>{src.label}</span>
                            {r.recommendedBy ? (
                              <div className="faint">by {r.recommendedBy}</div>
                            ) : null}
                          </td>
                          <td>
                            <span className={`b ${sb.cls}`}>{sb.label}</span>
                          </td>
                          <td className="faint">
                            {r.dueDate ? r.dueDate.toLocaleDateString("en-US") : "—"}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              )}
            </div>
          </div>

          {data.available.length ? (
            <div className="card mt">
              <div className="card-h">
                <h3>Explore the library</h3>
                <span className="hint">{data.available.length} more</span>
              </div>
              <div className="card-pad">
                <table>
                  <thead>
                    <tr>
                      <th>Module</th>
                      <th>Category</th>
                      <th className="num">Time</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.available.map((m) => (
                      <tr key={m.id}>
                        <td>
                          <Link href={`/learning/modules/${m.id}`} className="jc-link">
                            {m.title}
                          </Link>
                        </td>
                        <td>{m.category}</td>
                        <td className="num faint">{fmtMinutes(m.estimatedMinutes)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ) : null}
        </>
      )}
    </>
  );
}
