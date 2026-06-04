import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOpenCycle, getMidCycleReviews } from "@/lib/midcycle";
import { OpenMidCycleButton, MidCycleReviewForm } from "@/components/performance/MidCycleControls";

export const metadata = { title: "Mid-cycle reviews · Transworld PeopleOps" };

function badge(ok: boolean) {
  return ok ? "b-grn" : "b-amb";
}

export default async function MidCyclePage() {
  const me = await requirePermission("performance.view");
  const canRun = hasPermission(me, "performance.team") || hasPermission(me, "performance.manage");
  const cycle = await getOpenCycle();
  const reviews = cycle ? await getMidCycleReviews(cycle.id) : [];

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance" className="back-link">← Performance</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>Mid-cycle reviews</h1>
          <p>The July check-in — a structured conversation about Goals, Behavior, Competencies/Skills and Developmental Level. Not rated.{cycle ? ` Current cycle: ${cycle.name}.` : ""}</p>
        </div>
      </div>

      {!cycle ? (
        <div className="note"><span>ℹ</span><div>No performance cycle exists yet.</div></div>
      ) : (
        <>
          {canRun ? (
            <div className="card" style={{ marginBottom: 18 }}>
              <div className="card-pad"><OpenMidCycleButton cycleId={cycle.id} /></div>
            </div>
          ) : null}

          {reviews.length === 0 ? (
            <div className="note"><span>ℹ</span><div>No mid-cycle reviews opened for this cycle yet.</div></div>
          ) : (
            <div className="card">
              <div className="card-h"><h3>Reviews</h3><span className="hint">{reviews.length}</span></div>
              <div className="card-pad">
                {reviews.map((r) => (
                  <details key={r.id} className="card" style={{ margin: 0, marginBottom: 10 }}>
                    <summary style={{ listStyle: "none", cursor: "pointer", padding: "12px 14px", display: "flex", justifyContent: "space-between", alignItems: "center", gap: 8 }}>
                      <b>{r.employeeName}</b>
                      <span style={{ display: "flex", gap: 6 }}>
                        <span className={"b " + badge(r.selfStatus === "SUBMITTED")}>Self: {r.selfStatus === "SUBMITTED" ? "in" : "—"}</span>
                        <span className={"b " + badge(r.status === "COMPLETED")}>{r.status === "COMPLETED" ? "Completed" : "Open"}</span>
                      </span>
                    </summary>
                    <div className="card-pad" style={{ borderTop: "1px solid var(--line)" }}>
                      {r.selfSummary ? (
                        <div className="note" style={{ marginBottom: 12 }}><span>“</span><div><b>Their reflection:</b> {r.selfSummary}</div></div>
                      ) : <p className="faint" style={{ marginTop: 0 }}>No self-reflection submitted yet.</p>}
                      {canRun ? (
                        <MidCycleReviewForm
                          id={r.id}
                          defaults={{
                            goalsNote: r.goalsNote ?? "",
                            behaviorNote: r.behaviorNote ?? "",
                            skillsNote: r.skillsNote ?? "",
                            developmentNote: r.developmentNote ?? "",
                            managerSummary: r.managerSummary ?? "",
                          }}
                        />
                      ) : (
                        <div className="kv">
                          <div className="row"><span className="k">Goals</span><span className="v">{r.goalsNote ?? "—"}</span></div>
                          <div className="row"><span className="k">Behavior</span><span className="v">{r.behaviorNote ?? "—"}</span></div>
                          <div className="row"><span className="k">Skills</span><span className="v">{r.skillsNote ?? "—"}</span></div>
                          <div className="row"><span className="k">Development</span><span className="v">{r.developmentNote ?? "—"}</span></div>
                        </div>
                      )}
                    </div>
                  </details>
                ))}
              </div>
            </div>
          )}
        </>
      )}
    </>
  );
}
