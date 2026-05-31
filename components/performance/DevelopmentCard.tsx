import Link from "next/link";
import { getEmployeeRecords, recordStatusBadge, sourceBadge } from "@/lib/learning";

// Additive card rendered on the appraisal page. Shows the employee's learning at
// a glance and — for someone who may recommend — a link into the recommend flow
// seeded by this appraisal. Read-only; no rewrite of the appraisal editor.
export default async function DevelopmentCard({
  employeeId,
  cycleId,
  appraisalId,
  canRecommend,
}: {
  employeeId: string;
  cycleId: string;
  appraisalId: string | null;
  canRecommend: boolean;
}) {
  const records = await getEmployeeRecords(employeeId);
  const completed = records.filter((r) => r.status === "COMPLETED").length;
  const open = records.filter((r) => r.status === "ASSIGNED" || r.status === "IN_PROGRESS").length;

  const recommendHref = appraisalId
    ? `/learning/recommend?employeeId=${employeeId}&appraisalId=${appraisalId}&cycleId=${cycleId}`
    : `/learning/recommend?employeeId=${employeeId}`;

  return (
    <div className="card" style={{ marginTop: 18 }}>
      <div className="card-h">
        <h3>Development &amp; learning</h3>
        {canRecommend ? (
          <Link href={recommendHref} className="btn btn-pri">
            Recommend modules
          </Link>
        ) : null}
      </div>
      <div className="card-pad">
        <div className="ln-statline" style={{ marginBottom: records.length ? 14 : 0 }}>
          <span>
            <b>{completed}</b> completed
          </span>
          <span>
            <b>{open}</b> in progress
          </span>
          <span>
            <b>{records.length}</b> total
          </span>
        </div>

        {records.length === 0 ? (
          <p className="faint" style={{ marginTop: 0 }}>
            No learning on record yet.
            {canRecommend
              ? " Use “Recommend modules” to suggest targeted training — modules tagged to competencies rated Below are pre-selected for you."
              : ""}
          </p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Module</th>
                <th>Source</th>
                <th>Status</th>
                <th>Completed</th>
              </tr>
            </thead>
            <tbody>
              {records.map((r) => {
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
                    </td>
                    <td>
                      <span className={`b ${sb.cls}`}>{sb.label}</span>
                    </td>
                    <td className="faint">
                      {r.completedAt ? r.completedAt.toLocaleDateString("en-US") : "—"}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
