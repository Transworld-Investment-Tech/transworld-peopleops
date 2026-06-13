import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getReportSheetForReview,
  reviewStateBadge,
  AMENDMENT_KINDS,
  fmtDate,
  fmtDateTime,
} from "@/lib/goal-agreement";
import TeamReviewPanel from "@/components/performance/TeamReviewPanel";
import AmendmentsPanel from "@/components/performance/AmendmentsPanel";
import { getWeeklyReports, weekRangeLabel } from "@/lib/performance-toolkit";

export const metadata = { title: "Review goals · Transworld PeopleOps" };

const PROGRESS_OPTIONS = [
  { value: "ACTIVE", label: "Active" },
  { value: "ACHIEVED", label: "Achieved" },
  { value: "PARTIAL", label: "Partly met" },
  { value: "MISSED", label: "Missed" },
  { value: "DROPPED", label: "Dropped" },
];

function isoDay(d: Date | null | undefined): string | null {
  return d ? d.toISOString().slice(0, 10) : null;
}

export default async function ReviewReportPage({
  params,
}: {
  params: Promise<{ employeeId: string }>;
}) {
  const me = await requirePermission("performance.team");
  const { employeeId } = await params;
  const res = await getReportSheetForReview(me.id, employeeId);

  if (!res.ok) {
    if (res.reason === "not-a-report") {
      return (
        <>
          <div className="page-h">
            <div>
              <Link href="/my-team" className="back-link">
                ← My team
              </Link>
              <h1 className="serif" style={{ marginTop: 6 }}>
                Not your report
              </h1>
            </div>
          </div>
          <div className="card">
            <div className="card-pad">
              <div className="note">
                <span>ℹ</span>
                <div>You can only review the goals of your own direct reports.</div>
              </div>
            </div>
          </div>
        </>
      );
    }
    if (res.reason === "no-cycle") {
      return (
        <>
          <div className="page-h">
            <div>
              <Link href="/my-team" className="back-link">
                ← My team
              </Link>
              <h1 className="serif" style={{ marginTop: 6 }}>
                No open cycle
              </h1>
            </div>
          </div>
          <div className="card">
            <div className="card-pad">
              <p className="faint" style={{ marginTop: 0 }}>Goal-setting begins once HR opens a review cycle.</p>
            </div>
          </div>
        </>
      );
    }
    notFound();
  }

  const { cycle, employee, sheet, goals, amendments } = res;
  const weekly = await getWeeklyReports(employee.id, 8);
  const state = sheet?.reviewState ?? "DRAFT";
  const sb = reviewStateBadge(state);
  const sealed = !!sheet?.sealed;
  const midCycleOpen = cycle.stage !== "GOAL_SETTING";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/my-team" className="back-link">
            ← My team
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {employee.name}
            {employee.role ? ` · ${employee.role}` : ""}
          </h1>
          <p>
            {cycle.name} · <span className={`b ${sb.cls}`}>{sb.label}</span>
            {sheet?.submittedAt ? ` · submitted ${fmtDate(sheet.submittedAt)}` : ""}
          </p>
        </div>
      </div>

      <TeamReviewPanel
        employeeId={employee.id}
        employeeName={employee.name}
        reviewState={state}
        agreementNote={sheet?.agreementNote ?? null}
        progressOptions={PROGRESS_OPTIONS}
        goals={goals.map((g) => ({
          id: g.id,
          title: g.title,
          description: g.description,
          measure: g.measure,
          target: g.target,
          weight: g.weight,
          dueDate: isoDay(g.dueDate),
          status: g.status,
        }))}
      />

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Weekly check-ins</h3>
          <span className="hint">{weekly.length}</span>
        </div>
        <div className="card-pad">
          {weekly.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No weekly check-ins filed yet. {employee.name} files these in My Performance.
            </p>
          ) : (
            <div className="doc-list">
              {weekly.map((w) => (
                <details key={w.id} className="card" style={{ margin: 0, marginBottom: 10 }}>
                  <summary
                    style={{
                      listStyle: "none",
                      cursor: "pointer",
                      padding: "12px 14px",
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                      gap: 8,
                    }}
                  >
                    <b>{weekRangeLabel(w.weekStart)}</b>
                    <span className={"b " + (w.status === "SUBMITTED" ? "b-grn" : "b-amb")}>
                      {w.status === "SUBMITTED" ? "Submitted" : "Draft"}
                    </span>
                  </summary>
                  <div className="card-pad" style={{ borderTop: "1px solid var(--line)" }}>
                    <div className="kv">
                      <div className="row" style={{ alignItems: "flex-start" }}>
                        <span className="k">Accomplished</span>
                        <span className="v" style={{ whiteSpace: "pre-wrap" }}>{w.accomplishments || "—"}</span>
                      </div>
                      <div className="row" style={{ alignItems: "flex-start" }}>
                        <span className="k">Next priorities</span>
                        <span className="v" style={{ whiteSpace: "pre-wrap" }}>{w.priorities || "—"}</span>
                      </div>
                      <div className="row" style={{ alignItems: "flex-start" }}>
                        <span className="k">Blockers</span>
                        <span className="v" style={{ whiteSpace: "pre-wrap" }}>{w.blockers || "—"}</span>
                      </div>
                    </div>
                  </div>
                </details>
              ))}
            </div>
          )}
        </div>
      </div>

      {sealed && sheet ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Seal & acknowledgment</h3>
          </div>
          <div className="card-pad">
            <div className="ln-statline">
              <span>Approved <b>{fmtDateTime(sheet.approvedAt)}</b></span>
              <span>
                Employee acknowledgment{" "}
                <b>{sheet.ackAt ? `${sheet.ackName} · ${fmtDateTime(sheet.ackAt)}` : "pending"}</b>
              </span>
            </div>
          </div>
        </div>
      ) : null}

      {sealed && sheet ? (
        <AmendmentsPanel
          employeeId={employee.id}
          sealed={true}
          midCycleOpen={midCycleOpen}
          asManager={true}
          kinds={AMENDMENT_KINDS.map((k) => ({ value: k.value, label: k.label }))}
          amendments={amendments.map((a) => ({
            id: a.id,
            kind: a.kind,
            body: a.body,
            newMeasure: a.newMeasure,
            newTarget: a.newTarget,
            createdAt: fmtDate(a.createdAt),
            by: null,
          }))}
        />
      ) : null}
    </>
  );
}
