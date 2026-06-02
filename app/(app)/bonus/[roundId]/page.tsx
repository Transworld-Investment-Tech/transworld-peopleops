import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getRound, bonusStateBadge, fmtNaira, monthLabel } from "@/lib/bonus-round";
import BonusRoundControls from "@/components/bonus/BonusRoundControls";

export const metadata = { title: "Bonus round · Transworld PeopleOps" };

export default async function BonusRoundPage({ params }: { params: Promise<{ roundId: string }> }) {
  const me = await requirePermission("bonus.view");
  const canManage = hasPermission(me, "bonus.manage");
  const canApprove = hasPermission(me, "bonus.approve");

  const { roundId } = await params;
  const round = await getRound(roundId);
  if (!round) notFound();

  const b = bonusStateBadge(round.status);
  const rec = round.reconciliation;
  const approved = round.approvedAt
    ? `${new Date(round.approvedAt).toLocaleDateString("en-US")}${round.approvedByName ? ` · ${round.approvedByName}` : ""}`
    : "—";

  return (
    <div className="pay-wide">
      <div className="page-h">
        <div>
          <h1 className="serif">{round.label}</h1>
          <p>
            <Link href="/bonus" className="jc-link">Bonus</Link> · profit-share reconciliation.
            Salary basis {round.salaryBasis} · payment {monthLabel(round.paymentMonth)} {round.paymentYear}.
            The portal records and reconciles; it never pays.
          </p>
        </div>
        <span className={`b ${b.cls}`}>{b.label}</span>
      </div>

      <div className="grid kpis pay-meta">
        <div className="card kpi"><div className="lab">Bonus pool (15% PBT)</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(rec.poolAmount)}</div></div>
        <div className="card kpi"><div className="lab">Total calculated</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(rec.totalCalculated)}</div></div>
        <div className="card kpi"><div className="lab">Scaling factor</div><div className="val" style={{ fontSize: 18 }}>{(rec.scalingFactor * 100).toFixed(1)}%</div></div>
        <div className="card kpi"><div className="lab">Total awarded</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(round.totals.awarded)}</div></div>
      </div>

      <div className="note" style={{ marginBottom: 16 }}>
        <span>{rec.withinPool ? "✓" : "⚠"}</span>
        <div>
          {rec.withinPool ? (
            <>Within pool — headroom {fmtNaira(rec.headroom)}. Awards pay as calculated.</>
          ) : (
            <>Oversubscribed by {fmtNaira(-rec.headroom)}. Awards scale to {(rec.scalingFactor * 100).toFixed(1)}% so the firm pays only what profit supports.</>
          )}
        </div>
      </div>

      {round.status === "APPROVED" ? (
        <div className="note" style={{ marginBottom: 16 }}><span>ℹ</span><div>Approved {approved}. Export the control sheet, then lock as evidence.</div></div>
      ) : null}
      {round.status === "LOCKED" ? (
        <div className="note" style={{ marginBottom: 16 }}><span>🔒</span><div>Locked as evidence — permanently read-only.</div></div>
      ) : null}

      <BonusRoundControls
        roundId={round.id}
        status={round.status}
        editable={round.editable}
        canManage={canManage}
        canApprove={canApprove}
        rows={round.rows}
        totals={round.totals}
        reconciliation={rec}
        allConfirmed={round.allConfirmed}
        confirmedCount={round.confirmedCount}
        tranches={round.tranches}
      />
    </div>
  );
}
