import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getRaiseHome, raiseStateBadge, fmtNaira, fmtPct, monthLabel } from "@/lib/raise-cycle";
import CompTabs from "@/components/compensation/CompTabs";
import RaiseCycleForm from "@/components/compensation/RaiseCycleForm";

export const metadata = { title: "Raises · Transworld PeopleOps" };

export default async function RaisesPage() {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");

  const home = await getRaiseHome();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Raises</h1>
          <p>
            Firm-wide, uniform pay raises (WS6 Part 2): when the Board confirms a revenue milestone is
            met, a single percentage is applied across every band. Not performance-linked — that
            uniformity is what keeps it control-function-safe. The portal records and applies the new
            compensation profiles; HumanManager and Remita stay authoritative for payment.
          </p>
        </div>
      </div>

      <CompTabs active="raises" />

      {home.openGap ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Milestone gap tracker</h3>
            <span className="hint">{home.openGap.milestoneLabel}</span>
          </div>
          <div className="card-pad">
            <div className="grid kpis">
              <div className="kpi"><div className="lab">Revenue target</div><div className="val mono">{fmtNaira(home.openGap.revenueTarget)}</div></div>
              <div className="kpi"><div className="lab">Revenue to date</div><div className="val mono">{home.openGap.revenueObserved === null ? "—" : fmtNaira(home.openGap.revenueObserved)}</div></div>
              <div className="kpi"><div className="lab">Gap to milestone</div><div className="val mono">{fmtNaira(home.openGap.gap)}</div></div>
              <div className="kpi"><div className="lab">Progress</div><div className="val">{(home.openGap.progress * 100).toFixed(1)}%</div></div>
            </div>
            <p className="hint" style={{ marginTop: 10 }}>
              Update the revenue-to-date figure on the{" "}
              <Link href={`/compensation/raises/${home.openGap.id}`} className="jc-link">cycle</Link>{" "}
              as the CFO reports each month. When the milestone is confirmed hit, record the confirmed
              figure and submit for approval.
            </p>
          </div>
        </div>
      ) : null}

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h"><h3 className="serif">Raise cycles</h3></div>
        {home.cycles.length === 0 ? (
          <div className="card-pad"><p className="faint">No raise cycles yet.</p></div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Cycle</th>
                <th>Status</th>
                <th className="num">Raise</th>
                <th className="num">Staff</th>
                <th className="num">Annual increase</th>
                <th>Effective</th>
              </tr>
            </thead>
            <tbody>
              {home.cycles.map((c) => {
                const b = raiseStateBadge(c.status);
                const eff = new Date(c.effectiveDate);
                return (
                  <tr key={c.id}>
                    <td>
                      <Link href={`/compensation/raises/${c.id}`} className="jc-link">{c.label}</Link>
                      <div className="faint mono">{c.milestoneLabel}</div>
                    </td>
                    <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                    <td className="num mono">{fmtPct(c.raisePercent)}</td>
                    <td className="num">{c.itemCount}</td>
                    <td className="num mono">{c.totalAnnualIncrease === null ? "—" : fmtNaira(c.totalAnnualIncrease)}</td>
                    <td>{monthLabel(eff.getUTCMonth() + 1)} {eff.getUTCFullYear()}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {canManage ? (
        <div className="card">
          <div className="card-h"><h3 className="serif">Open a raise cycle</h3></div>
          <div className="card-pad">
            {home.hasOpenCycle ? (
              <div className="note">
                <span>ℹ</span>
                <div>A raise cycle is already open. Lock or discard it before opening another.</div>
              </div>
            ) : (
              <RaiseCycleForm eligibleCount={home.eligibleCount} suggestedEffective={home.suggestedEffective} />
            )}
          </div>
        </div>
      ) : null}
    </>
  );
}
