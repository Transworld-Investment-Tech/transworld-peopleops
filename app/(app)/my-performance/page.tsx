import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getMyPerformance,
  devStatusBadge,
  pipStatusBadge,
  pipResultBadge,
  fmtDate,
  fmtDateTime,
  weekRangeLabel,
} from "@/lib/performance-toolkit";
import {
  getMyGoalSetting,
  AMENDMENT_KINDS,
  fmtDate as fmtDateGA,
  fmtDateTime as fmtDateTimeGA,
} from "@/lib/goal-agreement";
import WeeklyReportForm from "@/components/performance/WeeklyReportForm";
import PipAcknowledge from "@/components/performance/PipAcknowledge";
import MyGoalsEditor from "@/components/performance/MyGoalsEditor";
import AmendmentsPanel from "@/components/performance/AmendmentsPanel";

export const metadata = { title: "My performance · Transworld PeopleOps" };

function isoDay(d: Date): string {
  return d.toISOString().slice(0, 10);
}

export default async function MyPerformancePage() {
  const me = await requirePermission("performance.self");
  const data = await getMyPerformance(me.id);
  const gs = await getMyGoalSetting(me.id);

  if (!data.linked) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My performance</h1>
            <p>Your goals, weekly check-ins, development plan, and any improvement plan.</p>
          </div>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once it is, your performance
                will appear here.
              </div>
            </div>
          </div>
        </div>
      </>
    );
  }

  const { employee, cycle, weekly, thisWeek, thisWeekReport, devPlans, pips } = data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My performance</h1>
          <p>
            Your goals, weekly check-ins, development plan, and any improvement plan.
            {cycle ? ` Current cycle: ${cycle.name}.` : ""}
          </p>
        </div>
      </div>

      {/* Open PIP(s) — surfaced first so they're never missed */}
      {pips.length > 0 ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Performance improvement plan</h3>
            <span className="hint">{pips.length}</span>
          </div>
          <div className="card-pad">
            {pips.map((p) => {
              const sb = pipStatusBadge(p.status);
              return (
                <div key={p.id} className="card" style={{ margin: 0, marginBottom: 12 }}>
                  <div className="card-h">
                    <h3 style={{ fontSize: 15 }}>{p.title}</h3>
                    <span className={`b ${sb.cls}`}>{sb.label}</span>
                  </div>
                  <div className="card-pad">
                    {p.concerns ? <p className="sc-mission" style={{ marginTop: 0 }}>{p.concerns}</p> : null}
                    <div className="ln-statline" style={{ marginBottom: 12 }}>
                      <span>Start <b>{fmtDate(p.startDate)}</b></span>
                      <span>Review <b>{fmtDate(p.reviewDate)}</b></span>
                      <span>End <b>{fmtDate(p.endDate)}</b></span>
                    </div>
                    {p.items.length ? (
                      <ul className="appr-list">
                        {p.items.map((it) => {
                          const rb = pipResultBadge(it.result);
                          return (
                            <li className="appr-ro" key={it.id}>
                              <div className="appr-ro-h">
                                <span className="appr-kra">{it.expectation}</span>
                                <span className={`b ${rb.cls}`}>{rb.label}</span>
                              </div>
                              {it.measure ? <div className="appr-ro-b"><span>{it.measure}</span></div> : null}
                            </li>
                          );
                        })}
                      </ul>
                    ) : null}
                    <div style={{ marginTop: 12 }}>
                      <PipAcknowledge
                        pipId={p.id}
                        defaultName={employee.fullName}
                        acknowledged={!!p.ackAt}
                        ackName={p.ackName}
                        ackAtLabel={p.ackAt ? fmtDateTime(p.ackAt) : null}
                      />
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      ) : null}

      {/* This week's report */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>This week’s report</h3>
        </div>
        <div className="card-pad">
          <WeeklyReportForm
            weekStartIso={isoDay(thisWeek)}
            weekLabel={`Week of ${weekRangeLabel(thisWeek)}`}
            existing={
              thisWeekReport
                ? {
                    accomplishments: thisWeekReport.accomplishments,
                    priorities: thisWeekReport.priorities,
                    blockers: thisWeekReport.blockers,
                    status: thisWeekReport.status,
                  }
                : null
            }
          />
        </div>
      </div>

      {/* Goals — employee-driven, manager-approved, sealed */}
      {gs.linked && gs.cycle ? (
        <>
          <MyGoalsEditor
            cycleName={gs.cycle.name}
            managerName={gs.manager?.name ?? null}
            sheet={
              gs.sheet
                ? {
                    id: gs.sheet.id,
                    reviewState: gs.sheet.reviewState,
                    changesNote: gs.sheet.changesNote,
                    agreementNote: gs.sheet.agreementNote,
                    approvedAt: gs.sheet.approvedAt ? fmtDateTimeGA(gs.sheet.approvedAt) : null,
                    ackName: gs.sheet.ackName,
                    ackAt: gs.sheet.ackAt ? fmtDateTimeGA(gs.sheet.ackAt) : null,
                  }
                : null
            }
            goals={gs.goals.map((g) => ({
              id: g.id,
              title: g.title,
              description: g.description,
              measure: g.measure,
              target: g.target,
              weight: g.weight,
              dueDate: g.dueDate ? g.dueDate.toISOString().slice(0, 10) : null,
              status: g.status,
            }))}
            defaultName={gs.employee.fullName}
          />

          {gs.sheet?.sealed ? (
            <AmendmentsPanel
              employeeId={gs.employee.id}
              sealed={true}
              midCycleOpen={gs.cycle.stage !== "GOAL_SETTING"}
              asManager={false}
              kinds={AMENDMENT_KINDS.map((k) => ({ value: k.value, label: k.label }))}
              amendments={gs.amendments.map((a) => ({
                id: a.id,
                kind: a.kind,
                body: a.body,
                newMeasure: a.newMeasure,
                newTarget: a.newTarget,
                createdAt: fmtDateGA(a.createdAt),
                by: null,
              }))}
            />
          ) : null}
        </>
      ) : null}

      {/* Development plan */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>My development plan</h3>
          <span className="hint">{devPlans.length}</span>
        </div>
        <div className="card-pad">
          {devPlans.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No development objectives recorded yet.
            </p>
          ) : (
            <div className="appr-list">
              {devPlans.map((d) => {
                const sb = devStatusBadge(d.status);
                return (
                  <div className="appr-ro" key={d.id}>
                    <div className="appr-ro-h">
                      <span className="appr-kra">{d.objective}</span>
                      <span className={`b ${sb.cls}`}>{sb.label}</span>
                    </div>
                    {d.action ? <div className="appr-note">{d.action}</div> : null}
                    <div className="faint" style={{ fontSize: 12.5 }}>
                      {[d.support ? `Support: ${d.support}` : null, d.targetDate ? `By ${fmtDate(d.targetDate)}` : null]
                        .filter(Boolean)
                        .join(" · ") || "—"}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      {/* Recent weekly reports */}
      <div className="card">
        <div className="card-h">
          <h3>Recent weekly reports</h3>
          <span className="hint">{weekly.length}</span>
        </div>
        <div className="card-pad">
          {weekly.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No reports yet. Your first one starts above.
            </p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Week</th>
                  <th>Accomplishments</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {weekly.map((w) => (
                  <tr key={w.id}>
                    <td className="mono">{weekRangeLabel(w.weekStart)}</td>
                    <td>{w.accomplishments.length > 90 ? w.accomplishments.slice(0, 90) + "…" : w.accomplishments}</td>
                    <td>
                      <span className={`b ${w.status === "SUBMITTED" ? "b-grn" : "b-amb"}`}>
                        {w.status === "SUBMITTED" ? "Submitted" : "Draft"}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        You draft your own goals here and submit them to your line manager to agree. Your development plan and any improvement plan are set with your manager. Questions?{" "}
        <Link href="/leave" className="jc-link">
          Contact HR
        </Link>
        .
      </div>
    </>
  );
}
