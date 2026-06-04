import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getAppraisalView, RATINGS } from "@/lib/performance";
import { LEVELS } from "@/lib/jobframework";
import { getDevelopmentPlans, DEV_STATUSES } from "@/lib/performance-toolkit";
import {
  getSheet,
  getGoals,
  reviewStateBadge,
  fmtDate as fmtDateGA,
  fmtDateTime as fmtDateTimeGA,
} from "@/lib/goal-agreement";
import AppraisalEditor from "@/components/performance/AppraisalEditor";
import DevelopmentCard from "@/components/performance/DevelopmentCard";
import DevelopmentPlanEditor from "@/components/performance/DevelopmentPlanEditor";

export const metadata = { title: "Appraisal · Transworld PeopleOps" };

function isoDay(d: Date | null | undefined): string | null {
  return d ? d.toISOString().slice(0, 10) : null;
}

function fmtAvg(n: number | null): string {
  return n == null ? "—" : n.toFixed(2);
}

export default async function AppraisalPage({
  params,
}: {
  params: Promise<{ cycleId: string; employeeId: string }>;
}) {
  const me = await requirePermission("performance.view");
  const canManage = hasPermission(me, "performance.manage");
  const canRecommend = hasPermission(me, "learning.recommend");
  const { cycleId, employeeId } = await params;

  const view = await getAppraisalView(cycleId, employeeId);
  if (!view) notFound();

  const [goals, sheet, devItems] = await Promise.all([
    getGoals(cycleId, employeeId),
    getSheet(cycleId, employeeId),
    getDevelopmentPlans(employeeId, view.appraisal?.id ?? null),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/performance?cycle=${cycleId}`} className="back-link">
            ← {view.cycle.name}
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Scorecard — {view.employee.name}
            {view.employee.role ? ` · ${view.employee.role}` : ""}
          </h1>
          <p>
            KRAs &amp; KPIs drawn from the role
            {view.employee.grade ? ` profile ${view.employee.grade}` : ""}. Recorded in
            the audit log.
          </p>
        </div>
      </div>

      {view.mission ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Role mission</h3>
          </div>
          <div className="card-pad">
            <p className="sc-mission">{view.mission}</p>
          </div>
        </div>
      ) : null}

      <div className="card" style={{ marginTop: 18, marginBottom: 18 }}>
        <div className="card-h">
          <h3>Agreed goals — {view.cycle.name}</h3>
          {sheet ? (
            <span className={`b ${reviewStateBadge(sheet.reviewState).cls}`}>
              <span className="dot" />
              {reviewStateBadge(sheet.reviewState).label}
            </span>
          ) : (
            <span className="hint">not started</span>
          )}
        </div>
        <div className="card-pad">
          <p className="faint" style={{ marginTop: 0 }}>
            The individual goals agreed for this cycle. These are set by the employee and sealed on the line
            manager’s approval — they’re the canonical reference for this review and can’t be edited here.
          </p>
          {goals.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No goals agreed yet. The employee drafts these in My Performance and their line manager approves
              them in My Team.
            </p>
          ) : (
            <ul className="appr-list">
              {goals.map((g) => (
                <li className="appr-ro" key={g.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kra">{g.title}</span>
                    <span className="b b-gry">{g.status}</span>
                  </div>
                  <div className="faint" style={{ fontSize: 12.5 }}>
                    {[g.measure ? `KPI · ${g.measure}` : null, g.target ? `Target ${g.target}` : null, g.weight != null ? `${g.weight}%` : null, g.dueDate ? `Due ${fmtDateGA(g.dueDate)}` : null]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </div>
                  {g.description ? <div className="appr-note">{g.description}</div> : null}
                </li>
              ))}
            </ul>
          )}
          {sheet?.sealed && sheet.agreementNote ? (
            <div className="field" style={{ marginTop: 12 }}>
              <label>Agreement on record</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{sheet.agreementNote}</p>
              <p className="faint" style={{ fontSize: 11.5, marginTop: 6 }}>
                Approved {fmtDateTimeGA(sheet.approvedAt)}
                {sheet.ackAt ? ` · acknowledged by ${sheet.ackName} ${fmtDateTimeGA(sheet.ackAt)}` : " · employee acknowledgment pending"}.
              </p>
            </div>
          ) : null}
        </div>
      </div>

      {view.score ? (
        <div className="card" style={{ marginTop: 18, marginBottom: 18 }}>
          <div className="card-h">
            <h3>Indicative score</h3>
            {view.score.integrityGate ? (
              <span className="b b-red">Integrity gate · ×0.00</span>
            ) : (
              <span className="b b-blu">×{view.score.multiplier.toFixed(2)}</span>
            )}
          </div>
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0, fontSize: 12.5 }}>
              Computed from the saved manager ratings with the role&rsquo;s dimension weighting —
              the same calculation that drives the bonus multiplier. Indicative until the
              appraisal is finalized.
            </p>
            <p className="faint" style={{ marginTop: 0, fontSize: 12 }}>
              Weighting — Results {Math.round(view.scoreWeights.results * 100)}% · Competencies{" "}
              {Math.round(view.scoreWeights.competencies * 100)}% · Behaviors{" "}
              {Math.round(view.scoreWeights.behaviors * 100)}%
            </p>
            <div className="grid kpis">
              <div className="card kpi">
                <div className="lab">Results</div>
                <div className="val">{fmtAvg(view.score.results)}</div>
              </div>
              <div className="card kpi">
                <div className="lab">Competencies</div>
                <div className="val">{fmtAvg(view.score.competencies)}</div>
              </div>
              <div className="card kpi">
                <div className="lab">Behaviors</div>
                <div className="val">{fmtAvg(view.score.behaviors)}</div>
              </div>
              <div className="card kpi">
                <div className="lab">Overall</div>
                <div className="val">{fmtAvg(view.score.overall)}</div>
                <div className="faint" style={{ fontSize: 12, marginTop: 6 }}>
                  &rarr; ×{view.score.multiplier.toFixed(2)}
                  {view.score.integrityGate ? " (gated)" : ""}
                </div>
              </div>
            </div>
            {view.score.integrityGate ? (
              <div
                className="note"
                style={{ marginTop: 12, background: "#fdeaea", borderColor: "#f3c0c0", color: "#9b1c1c" }}
              >
                <span>!</span>
                <div>
                  A rating of 1 on Integrity Above All or Compliance by Default forces the
                  multiplier to ×0.00, regardless of the other scores.
                </div>
              </div>
            ) : null}
          </div>
        </div>
      ) : null}

      <AppraisalEditor
        cycleId={cycleId}
        employeeId={employeeId}
        cycleStatus={view.cycle.status}
        canManage={canManage}
        appraisal={view.appraisal}
        ratings={RATINGS.map((r) => ({ value: r.value, label: r.label }))}
        levels={LEVELS.map((l) => ({ value: l.value, label: l.label }))}
      />

      <DevelopmentPlanEditor
        employeeId={employeeId}
        cycleId={cycleId}
        appraisalId={view.appraisal?.id ?? null}
        canManage={canManage}
        items={devItems.map((d) => ({
          id: d.id,
          objective: d.objective,
          action: d.action,
          support: d.support,
          targetDate: isoDay(d.targetDate),
          status: d.status,
        }))}
        statuses={DEV_STATUSES.map((s) => ({ value: s.value, label: s.label }))}
      />

      <DevelopmentCard
        employeeId={employeeId}
        cycleId={cycleId}
        appraisalId={view.appraisal?.id ?? null}
        canRecommend={canRecommend}
      />
    </>
  );
}
