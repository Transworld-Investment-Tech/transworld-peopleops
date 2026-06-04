import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOnboardingDetail, taskStatusBadge, fmtDate } from "@/lib/onboarding";
import { getActiveTemplates, kindLabel } from "@/lib/document-templates";
import { getProbationView } from "@/lib/ws4-data";
import {
  probationPhaseBadge,
  probationOutcomeBadge,
  probationOutcomeLabel,
  fmtDate as fmtDateW,
} from "@/lib/ws4";
import GenerateDocControl from "@/components/documents/GenerateDocControl";
import {
  SeedDefaultTasksButton,
  TaskAddForm,
  TaskStatusControl,
  ProbationEditor,
  ScheduleReviewButton,
} from "@/components/onboarding/OnboardingControls";
import { MidpointReviewForm, FinalDecisionForm } from "@/components/onboarding/ProbationClock";

export const metadata = { title: "Onboarding · Transworld PeopleOps" };

function isoDate(d: Date | null): string {
  if (!d) return "";
  return new Date(d).toISOString().slice(0, 10);
}

function dayOfWindow(start: Date | null): number | null {
  if (!start) return null;
  const days = Math.floor((Date.now() - new Date(start).getTime()) / 86400000) + 1;
  if (days < 1) return null;
  return days;
}

export default async function OnboardingDetailPage({
  params,
}: {
  params: Promise<{ employeeId: string }>;
}) {
  const me = await requirePermission("onboarding.view");
  const canManage = hasPermission(me, "onboarding.manage");
  const { employeeId } = await params;
  const d = await getOnboardingDetail(employeeId);
  if (!d) notFound();

  // No plan yet — point HR back to the list to start one.
  if (!d.plan) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">Onboarding · {d.employee.name}</h1>
            <p>
              <span className="faint mono">{d.employee.eeId}</span>
            </p>
          </div>
          <Link href="/onboarding" className="btn">
            ← All plans
          </Link>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                No onboarding plan for {d.employee.name} yet.{" "}
                <Link href="/onboarding" className="jc-link">
                  Start one from the Onboarding list →
                </Link>
              </div>
            </div>
          </div>
        </div>
      </>
    );
  }

  const plan = d.plan;
  const p = plan.probation;
  const day = dayOfWindow(p.startDate);
  const reviewLabel = p.review30Scheduled
    ? "Scheduled ✓"
    : p.daysUntilReview === null
      ? "—"
      : p.daysUntilReview > 0
        ? `Due in ${p.daysUntilReview} day${p.daysUntilReview === 1 ? "" : "s"}`
        : "Overdue";

  const docTemplates = canManage
    ? (await getActiveTemplates()).map((t) => ({ id: t.id, name: t.name, kindLabel: kindLabel(t.kind) }))
    : [];

  // Probation clock (WS4 depth) — milestones, phase, review history + decision.
  const pv = await getProbationView(employeeId);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Onboarding · {d.employee.name}</h1>
          <p>
            <span className="faint mono">{d.employee.eeId}</span> · {plan.progress.done}/
            {plan.progress.total} tasks complete
          </p>
        </div>
        <Link href="/onboarding" className="btn">
          ← All plans
        </Link>
      </div>

      {canManage ? (
        <div className="card" style={{ marginBottom: 16 }}>
          <div className="card-h">
            <h3>Documents</h3>
            <span className="hint">generate the new hire&apos;s paperwork</span>
          </div>
          <div className="card-pad">
            <GenerateDocControl employeeId={d.employee.id} templates={docTemplates} />
            <div className="faint" style={{ fontSize: 12, marginTop: 10 }}>
              Documents that need a signature are sent to{" "}
              <Link href={`/employees/${d.employee.id}`} className="jc-link">
                {d.employee.name}&apos;s record
              </Link>{" "}
              and to their My Documents page to sign.
            </div>
          </div>
        </div>
      ) : null}

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "minmax(0, 1.4fr) minmax(0, 1fr)",
          gap: 16,
          alignItems: "start",
        }}
      >
        {/* Checklist */}
        <div className="card">
          <div className="card-h">
            <h3>Onboarding checklist — {d.employee.name}</h3>
            {day !== null ? <span className="b b-blu">Day {day} of 30</span> : null}
          </div>

          {plan.tasks.length === 0 ? (
            <div className="card-pad">
              <div className="note" style={{ marginTop: 0 }}>
                <span>ℹ</span>
                <div>No tasks yet.{canManage ? " Seed the default checklist to get started." : ""}</div>
              </div>
              {canManage ? (
                <div style={{ marginTop: 12 }}>
                  <SeedDefaultTasksButton planId={plan.id} employeeId={d.employee.id} />
                </div>
              ) : null}
            </div>
          ) : (
            <table>
              <tbody>
                {plan.tasks.map((t) => {
                  const b = taskStatusBadge(t.status, t.dueDate);
                  return (
                    <tr key={t.id}>
                      <td>
                        {t.label}
                        {t.category ? <span className="faint"> · {t.category}</span> : null}
                        {t.dueDate ? (
                          <span className="faint" style={{ fontSize: 12 }}>
                            {" "}· due {fmtDate(t.dueDate)}
                          </span>
                        ) : null}
                      </td>
                      <td className="num">
                        <span className={`b ${b.cls}`}>{b.label}</span>
                      </td>
                      {canManage ? (
                        <td className="num">
                          <TaskStatusControl taskId={t.id} employeeId={d.employee.id} status={t.status} />
                        </td>
                      ) : null}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}

          {canManage && plan.tasks.length > 0 ? (
            <div className="card-pad" style={{ borderTop: "1px solid var(--line)" }}>
              <TaskAddForm planId={plan.id} employeeId={d.employee.id} />
            </div>
          ) : null}
        </div>

        {/* Probation tracker */}
        <div className="card">
          <div className="card-h">
            <h3>Probation tracker</h3>
          </div>
          <div className="card-pad">
            <div className="two-col" style={{ marginBottom: 10 }}>
              <span className="faint">Start date</span>
              <b>{fmtDate(p.startDate)}</b>
            </div>
            <div className="two-col" style={{ marginBottom: 10 }}>
              <span className="faint">Probation length</span>
              <b>
                {p.probationMonths} month{p.probationMonths === 1 ? "" : "s"}
              </b>
            </div>
            <div className="two-col" style={{ marginBottom: 10 }}>
              <span className="faint">Confirmation due</span>
              <b>{fmtDate(p.confirmationDue)}</b>
            </div>
            <div className="two-col" style={{ marginBottom: 14 }}>
              <span className="faint">30-day review</span>
              <span className={`b ${p.review30Scheduled ? "b-grn" : p.daysUntilReview !== null && p.daysUntilReview <= 0 ? "b-red" : "b-amb"}`}>
                {reviewLabel}
              </span>
            </div>

            <div className="faint" style={{ marginBottom: 6 }}>
              Onboarding completion
            </div>
            <div className="bar" style={{ width: "100%", marginBottom: 16 }}>
              <i
                style={{
                  width: `${plan.progress.pct}%`,
                  background: plan.progress.pct >= 100 ? "var(--green)" : "var(--amber, #c98a1b)",
                }}
              />
            </div>

            {canManage ? (
              <>
                <ScheduleReviewButton
                  planId={plan.id}
                  employeeId={d.employee.id}
                  scheduled={p.review30Scheduled}
                />
                <div style={{ marginTop: 14, borderTop: "1px solid var(--line)", paddingTop: 14 }}>
                  <div className="faint" style={{ marginBottom: 8 }}>
                    Adjust probation
                  </div>
                  <ProbationEditor
                    planId={plan.id}
                    employeeId={d.employee.id}
                    startDate={isoDate(p.startDate)}
                    probationMonths={p.probationMonths}
                  />
                </div>
              </>
            ) : null}
          </div>
        </div>
      </div>

      {/* Probation clock — milestones, phase, reviews, decision (WS4 depth) */}
      {pv ? (
        <div className="card" style={{ marginTop: 16 }}>
          <div className="card-h">
            <h3>Probation clock</h3>
            {(() => {
              const b = probationPhaseBadge(pv.phase);
              return <span className={`b ${b.cls}`}>{b.label}</span>;
            })()}
          </div>
          <div className="card-pad">
            <div
              style={{ display: "grid", gridTemplateColumns: "repeat(3, minmax(0,1fr))", gap: 12, marginBottom: 14 }}
            >
              <div>
                <div className="faint" style={{ fontSize: 12 }}>Midpoint review</div>
                <b>{fmtDateW(pv.milestones.midpointOn)}</b>
              </div>
              <div>
                <div className="faint" style={{ fontSize: 12 }}>Decide by</div>
                <b>{fmtDateW(pv.milestones.finalDueBy)}</b>
              </div>
              <div>
                <div className="faint" style={{ fontSize: 12 }}>Probation ends</div>
                <b>{fmtDateW(pv.milestones.endsOn)}</b>
              </div>
            </div>

            {pv.reviews.length > 0 ? (
              <table style={{ marginBottom: 8 }}>
                <thead>
                  <tr><th>Review</th><th>Outcome</th><th>Held</th><th>Filed</th></tr>
                </thead>
                <tbody>
                  {pv.reviews.map((r) => {
                    const b = probationOutcomeBadge(r.outcome);
                    return (
                      <tr key={r.id}>
                        <td>{r.kind === "MIDPOINT" ? "Midpoint" : "Final decision"}</td>
                        <td>
                          <span className={`b ${b.cls}`}>{probationOutcomeLabel(r.outcome)}</span>
                          {r.kind === "FINAL" && r.outcome === "EXTEND" && r.extensionUntil ? (
                            <span className="faint" style={{ fontSize: 12 }}> · to {fmtDateW(r.extensionUntil)}</span>
                          ) : null}
                        </td>
                        <td>{fmtDateW(r.heldOn)}</td>
                        <td>{r.staffDocumentId ? "✓" : "—"}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            ) : (
              <div className="faint" style={{ marginBottom: 8 }}>No probation reviews recorded yet.</div>
            )}

            {canManage && pv.phase !== "CONCLUDED" ? (
              <div
                style={{ display: "grid", gridTemplateColumns: "repeat(2, minmax(0,1fr))", gap: 16, marginTop: 12, borderTop: "1px solid var(--line)", paddingTop: 14 }}
              >
                <div>
                  <div className="faint" style={{ marginBottom: 8 }}>Midpoint review (≈ 3 months)</div>
                  <MidpointReviewForm employeeId={pv.employee.id} docs={pv.attachableDocs} />
                </div>
                <div>
                  <div className="faint" style={{ marginBottom: 8 }}>End-of-probation decision</div>
                  <FinalDecisionForm employeeId={pv.employee.id} docs={pv.attachableDocs} />
                </div>
              </div>
            ) : null}

            {pv.phase === "CONCLUDED" ? (
              <div className="note" style={{ marginTop: 8 }}>
                <span>✓</span>
                <div>Probation concluded — the decision and its letter are on the staff file.</div>
              </div>
            ) : null}
          </div>
        </div>
      ) : null}
    </>
  );
}
