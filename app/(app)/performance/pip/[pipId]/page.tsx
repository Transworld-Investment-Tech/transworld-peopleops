import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getPip,
  pipStatusBadge,
  fmtDate,
  fmtDateTime,
  PIP_STATUSES,
  PIP_RESULTS,
} from "@/lib/performance-toolkit";
import PipManage from "@/components/performance/PipManage";

export const metadata = { title: "Improvement plan · Transworld PeopleOps" };

function isoDay(d: Date | null | undefined): string | null {
  return d ? d.toISOString().slice(0, 10) : null;
}

export default async function PipDetailPage({
  params,
}: {
  params: Promise<{ pipId: string }>;
}) {
  await requirePermission("performance.manage");
  const { pipId } = await params;
  const data = await getPip(pipId);
  if (!data || !data.plan) notFound();

  const { plan, employee } = data;
  const sb = pipStatusBadge(plan.status);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance/pip" className="back-link">
            ← Improvement plans
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {plan.title}
          </h1>
          <p>
            {employee ? `${employee.name} · EID ${employee.eeId}` : "—"} · <span className={`b ${sb.cls}`}>{sb.label}</span>
          </p>
        </div>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Plan</h3>
          {plan.ackAt ? (
            <span className="b b-grn">Acknowledged · {fmtDateTime(plan.ackAt)}</span>
          ) : (
            <span className="b b-amb">Awaiting acknowledgment</span>
          )}
        </div>
        <div className="card-pad">
          <div className="field">
            <label>Performance concerns</label>
            <p className="sc-mission" style={{ marginTop: 4 }}>{plan.concerns || "—"}</p>
          </div>
          {plan.support ? (
            <div className="field">
              <label>Support to be provided</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{plan.support}</p>
            </div>
          ) : null}
          <div className="ln-statline" style={{ marginTop: 10 }}>
            <span>Start <b>{fmtDate(plan.startDate)}</b></span>
            <span>Review <b>{fmtDate(plan.reviewDate)}</b></span>
            <span>End <b>{fmtDate(plan.endDate)}</b></span>
          </div>
          {plan.ackAt ? (
            <p className="faint" style={{ fontSize: 12, marginTop: 10 }}>
              Acknowledged by {plan.ackName} on {fmtDateTime(plan.ackAt)}
              {plan.ackIp ? ` · IP ${plan.ackIp}` : ""}.
            </p>
          ) : null}
          {plan.outcome ? (
            <div className="field" style={{ marginTop: 10 }}>
              <label>Outcome</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{plan.outcome}</p>
            </div>
          ) : null}
        </div>
      </div>

      <PipManage
        pipId={plan.id}
        status={plan.status}
        outcome={plan.outcome}
        reviewDateIso={isoDay(plan.reviewDate)}
        endDateIso={isoDay(plan.endDate)}
        items={plan.items.map((it) => ({
          id: it.id,
          expectation: it.expectation,
          measure: it.measure,
          result: it.result,
          note: it.note,
        }))}
        statuses={PIP_STATUSES.map((s) => ({ value: s.value, label: s.label }))}
        results={PIP_RESULTS.map((r) => ({ value: r.value, label: r.label }))}
      />
    </>
  );
}
