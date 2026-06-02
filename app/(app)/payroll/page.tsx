import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getPayrollHome, getOpenPreview, cycleStateBadge, fmtNaira } from "@/lib/payroll-cycle";
import OpenCycleForm from "@/components/payroll/OpenCycleForm";

export const metadata = { title: "Payroll Run · Transworld PeopleOps" };

export default async function PayrollPage() {
  const me = await requirePermission("payroll.view");
  const canManage = hasPermission(me, "payroll.manage");

  const home = await getPayrollHome();
  const preview = canManage ? await getOpenPreview() : null;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Payroll Run</h1>
          <p>
            A monthly control room: carry compensation forward, review and confirm each
            person, get executive approval, then export the control sheet and lock it as
            evidence. This portal never pays anyone — HumanManager and Remita stay
            authoritative.
          </p>
        </div>
      </div>

      {!home.hasActiveRuleSet ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>⚠</span>
              <div>
                <b>No active tax rule set.</b> A cycle can’t compute deductions until a
                rule set is active. Set one under Compensation → Tax rules.
              </div>
            </div>
          </div>
        </div>
      ) : null}

      {canManage ? (
        <div className="card">
          <div className="card-h">
            <h3>Open a new cycle</h3>
            <span className="hint">{home.ruleSetName ? `Active rules: ${home.ruleSetName}` : "No active rules"}</span>
          </div>
          <div className="card-pad">
            {home.hasOpenCycle ? (
              <div className="note">
                <span>ℹ</span>
                <div>
                  A cycle is currently open. Finish and lock it before opening another —
                  only one cycle is open at a time.
                </div>
              </div>
            ) : (
              <OpenCycleForm
                defaultYear={home.suggested.year}
                defaultMonth={home.suggested.month}
                eligibleCount={preview?.eligible.length ?? 0}
                skipped={preview?.skipped ?? []}
                disabled={!home.hasActiveRuleSet}
              />
            )}
          </div>
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Cycles</h3>
          <span className="hint">{home.cycles.length} total</span>
        </div>
        <div className="card-pad">
          {home.cycles.length === 0 ? (
            <p className="faint">No pay cycles yet.</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Period</th>
                  <th>Status</th>
                  <th className="num">Staff</th>
                  <th className="num">Net total</th>
                  <th className="num">Total payable</th>
                  <th>Approved</th>
                </tr>
              </thead>
              <tbody>
                {home.cycles.map((c) => {
                  const b = cycleStateBadge(c.status);
                  return (
                    <tr key={c.id}>
                      <td>
                        <Link href={`/payroll/${c.id}`} className="jc-link">{c.label}</Link>
                      </td>
                      <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                      <td className="num mono">{c.itemCount}</td>
                      <td className="num mono">{c.totalNet === null ? "—" : fmtNaira(c.totalNet)}</td>
                      <td className="num mono">{c.totalPayable === null ? "—" : fmtNaira(c.totalPayable)}</td>
                      <td className="faint">{c.approvedAt ? new Date(c.approvedAt).toLocaleDateString("en-US") : "—"}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </>
  );
}
