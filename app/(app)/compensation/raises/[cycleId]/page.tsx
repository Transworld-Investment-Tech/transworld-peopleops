import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getCycle, raiseStateBadge, fmtNaira, fmtPct, monthLabel } from "@/lib/raise-cycle";
import RaiseControls from "@/components/compensation/RaiseControls";

export const metadata = { title: "Raise cycle · Transworld PeopleOps" };

export default async function RaiseCyclePage({ params }: { params: Promise<{ cycleId: string }> }) {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");
  const canApprove = hasPermission(me, "compensation.approve");

  const { cycleId } = await params;
  const cycle = await getCycle(cycleId);
  if (!cycle) notFound();

  const b = raiseStateBadge(cycle.status);
  const eff = new Date(cycle.effectiveDate);
  const approved = cycle.approvedAt
    ? `${new Date(cycle.approvedAt).toLocaleDateString("en-US")}${cycle.approvedByName ? ` · ${cycle.approvedByName}` : ""}`
    : "—";

  return (
    <div className="pay-wide">
      <div className="page-h">
        <div>
          <h1 className="serif">{cycle.label}</h1>
          <p>
            <Link href="/compensation/raises" className="jc-link">Raises</Link> · {cycle.milestoneLabel}.
            A firm-wide {fmtPct(cycle.raisePercent)} applied to every pay component, effective{" "}
            {monthLabel(eff.getUTCMonth() + 1)} {eff.getUTCFullYear()}. The portal records and applies;
            it never pays.
          </p>
        </div>
        <span className={`b ${b.cls}`}>{b.label}</span>
      </div>

      <div className="grid kpis pay-meta">
        <div className="card kpi"><div className="lab">Raise</div><div className="val" style={{ fontSize: 18 }}>{fmtPct(cycle.raisePercent)}</div></div>
        <div className="card kpi"><div className="lab">Staff included</div><div className="val" style={{ fontSize: 18 }}>{cycle.totals.includedCount}{cycle.totals.excludedCount ? ` (+${cycle.totals.excludedCount} excl.)` : ""}</div></div>
        <div className="card kpi"><div className="lab">Total annual increase</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(cycle.totals.totalAnnualIncrease)}</div></div>
        <div className="card kpi"><div className="lab">New annual total</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(cycle.totals.totalNewAnnual)}</div></div>
      </div>

      {cycle.totals.aboveMax > 0 || cycle.totals.aboveMid > 0 || cycle.totals.belowMin > 0 ? (
        <div className="note" style={{ marginBottom: 16 }}>
          <span>⚠</span>
          <div>
            Band awareness:{" "}
            {cycle.totals.aboveMax > 0 ? <b>{cycle.totals.aboveMax} above band max</b> : null}
            {cycle.totals.aboveMax > 0 && (cycle.totals.aboveMid > 0 || cycle.totals.belowMin > 0) ? ", " : ""}
            {cycle.totals.aboveMid > 0 ? <>{cycle.totals.aboveMid} above midpoint</> : null}
            {cycle.totals.belowMin > 0 ? <>{cycle.totals.aboveMid > 0 || cycle.totals.aboveMax > 0 ? ", " : ""}{cycle.totals.belowMin} below minimum</> : null}
            . Per Ops Manual B1.3 these need awareness/approval (COO for G0–G3, MD for G4+). Review each
            flagged row before approving; you can cap an individual at band max if the Board directs.
          </div>
        </div>
      ) : null}

      {cycle.status === "APPROVED" ? (
        <div className="note" style={{ marginBottom: 16 }}><span>✓</span><div>Approved {approved}; new compensation profiles applied (effective {monthLabel(eff.getUTCMonth() + 1)} {eff.getUTCFullYear()}). The next payroll cycle will pick them up. Lock as evidence when ready.</div></div>
      ) : null}
      {cycle.status === "LOCKED" ? (
        <div className="note" style={{ marginBottom: 16 }}><span>🔒</span><div>Locked as evidence — permanently read-only. Applied {approved}.</div></div>
      ) : null}

      <RaiseControls
        cycleId={cycle.id}
        status={cycle.status}
        canManage={canManage}
        canApprove={canApprove}
        milestoneLabel={cycle.milestoneLabel}
        raisePercent={cycle.raisePercent}
        revenueTarget={cycle.revenueTarget}
        revenueObserved={cycle.revenueObserved}
        revenueConfirmed={cycle.revenueConfirmed}
        gap={cycle.gap}
        effectiveDateIso={new Date(cycle.effectiveDate).toISOString().slice(0, 10)}
        confirmedNote={cycle.confirmedNote}
        rows={cycle.rows}
        totals={cycle.totals}
      />
    </div>
  );
}
