import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getCycle, cycleStateBadge } from "@/lib/payroll-cycle";
import PayRunControls from "@/components/payroll/PayRunControls";
import CycleThirteenthToggle from "@/components/payroll/CycleThirteenthToggle";

export const metadata = { title: "Payroll cycle · Transworld PeopleOps" };

export default async function PayCyclePage({ params }: { params: Promise<{ cycleId: string }> }) {
  const me = await requirePermission("payroll.view");
  const canManage = hasPermission(me, "payroll.manage");
  const canApprove = hasPermission(me, "payroll.approve");

  const { cycleId } = await params;
  const cycle = await getCycle(cycleId);
  if (!cycle) notFound();

  const b = cycleStateBadge(cycle.status);

  const rows = cycle.rows.map((r) => ({
    id: r.id, eeId: r.eeId, name: r.name, grade: r.grade, payCategory: r.payCategory,
    basicSalary: r.basicSalary, utilityAllowance: r.utilityAllowance, quarterlyAllowance: r.quarterlyAllowance,
    grossPay: r.grossPay, employeePension: r.employeePension, nhf: r.nhf, itf: r.itf, payeTax: r.payeTax,
    employerPension: r.employerPension, netPay: r.netPay, totalPayable: r.totalPayable,
    adjustments: r.adjustments, reviewStatus: r.reviewStatus, changeNote: r.changeNote,
  }));

  const approved = cycle.approvedAt
    ? `${new Date(cycle.approvedAt).toLocaleDateString("en-US")}${cycle.approvedByName ? ` · ${cycle.approvedByName}` : ""}`
    : "—";

  return (
    <div className="pay-wide">
      <div className="page-h">
        <div>
          <h1 className="serif">{cycle.label}</h1>
          <p>
            <Link href="/payroll" className="jc-link">Payroll Run</Link> · cross-check control
            sheet. The portal never pays anyone; HumanManager and Remita stay authoritative.
          </p>
        </div>
        <span className={`b ${b.cls}`}>{b.label}</span>
      </div>

      <div className="grid kpis pay-meta">
        <div className="card kpi"><div className="lab">Tax rules</div><div className="val" style={{ fontSize: 16 }}>{cycle.ruleSetName ?? "—"}</div></div>
        <div className="card kpi"><div className="lab">Confirmed</div><div className="val">{cycle.confirmedCount}<span style={{ fontSize: 16, color: "var(--faint)" }}>/{cycle.rows.length}</span></div></div>
        <div className="card kpi"><div className="lab">Approved</div><div className="val" style={{ fontSize: 16 }}>{approved}</div></div>
        <div className="card kpi"><div className="lab">Locked</div><div className="val" style={{ fontSize: 16 }}>{cycle.lockedAt ? new Date(cycle.lockedAt).toLocaleDateString("en-US") : "—"}</div></div>
      </div>

      <div className="note" style={{ alignItems: "flex-start" }}>
        <span>🗓️</span>
        <div>
          <b>{cycle.monthType}.</b>{" "}
          {cycle.isQuarterMonth
            ? "The quarterly payment — one month's gross — is added on top of regular monthly pay (basic + utility) for every eligible employee."
            : "Regular monthly pay only (basic + utility); no quarterly line this month."}
          {cycle.isThirteenthMonth ? " A thirteenth-month line (one month's gross) is also added for every employee." : ""}
          {canManage && cycle.editable ? (
            <div style={{ marginTop: 8 }}>
              <CycleThirteenthToggle cycleId={cycle.id} isThirteenthMonth={cycle.isThirteenthMonth} />
            </div>
          ) : null}
        </div>
      </div>

      {cycle.flags.length ? (
        <div style={{ marginBottom: 14 }}>
          {cycle.flags.map((f, i) => (
            <div key={i} className="note" style={{ alignItems: "flex-start" }}>
              <span>{f.kind === "ERROR" ? "⛔" : "⚠️"}</span>
              <div>{f.message}</div>
            </div>
          ))}
        </div>
      ) : null}

      {cycle.status === "LOCKED" ? (
        <div className="note"><span>🔒</span><div>This cycle is locked as evidence — permanently read-only.</div></div>
      ) : null}

      <PayRunControls
        cycleId={cycle.id}
        status={cycle.status}
        editable={cycle.editable}
        canManage={canManage}
        canApprove={canApprove}
        rows={rows}
        totals={cycle.totals}
        allConfirmed={cycle.allConfirmed}
        isQuarterMonth={cycle.isQuarterMonth}
      />
    </div>
  );
}
