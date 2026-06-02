import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getCycle, cycleStateBadge } from "@/lib/payroll-cycle";
import PayRunControls from "@/components/payroll/PayRunControls";

export const metadata = { title: "Payroll cycle · Transworld PeopleOps" };

export default async function PayCyclePage({ params }: { params: Promise<{ cycleId: string }> }) {
  const me = await requirePermission("payroll.view");
  const canManage = hasPermission(me, "payroll.manage");
  const canApprove = hasPermission(me, "payroll.approve");

  const { cycleId } = await params;
  const cycle = await getCycle(cycleId);
  if (!cycle) notFound();

  const b = cycleStateBadge(cycle.status);

  // Pass a serializable, client-safe view of each row.
  const rows = cycle.rows.map((r) => ({
    id: r.id, eeId: r.eeId, name: r.name, grade: r.grade, payCategory: r.payCategory,
    basicSalary: r.basicSalary, utilityAllowance: r.utilityAllowance, quarterlyAllowance: r.quarterlyAllowance,
    grossPay: r.grossPay, employeePension: r.employeePension, nhf: r.nhf, itf: r.itf, payeTax: r.payeTax,
    employerPension: r.employerPension, netPay: r.netPay, totalPayable: r.totalPayable,
    adjustments: r.adjustments, reviewStatus: r.reviewStatus, changeNote: r.changeNote,
  }));

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{cycle.label}</h1>
          <p>
            <Link href="/payroll" className="jc-link">Payroll Run</Link> · cross-check control
            sheet. The portal never pays anyone; HumanManager and Remita stay authoritative.
          </p>
        </div>
        <div className="page-h-side">
          <span className={`b ${b.cls}`}>{b.label}</span>
        </div>
      </div>

      <div className="card">
        <div className="card-pad">
          <div className="meta-grid">
            <div><span className="faint">Tax rules</span><div>{cycle.ruleSetName ?? "—"}</div></div>
            <div><span className="faint">Confirmed</span><div>{cycle.confirmedCount}/{cycle.rows.length}</div></div>
            <div><span className="faint">Approved</span><div>{cycle.approvedAt ? `${new Date(cycle.approvedAt).toLocaleDateString("en-US")}${cycle.approvedByName ? ` · ${cycle.approvedByName}` : ""}` : "—"}</div></div>
            <div><span className="faint">Locked</span><div>{cycle.lockedAt ? new Date(cycle.lockedAt).toLocaleDateString("en-US") : "—"}</div></div>
          </div>
          {cycle.status === "LOCKED" ? (
            <div className="note" style={{ marginTop: 12 }}>
              <span>🔒</span>
              <div>This cycle is locked as evidence — permanently read-only.</div>
            </div>
          ) : null}
        </div>
      </div>

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
    </>
  );
}
