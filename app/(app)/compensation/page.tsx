import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getCompensationRegister,
  fmtNaira,
  treatmentBadge,
} from "@/lib/compensation";
import CompTabs from "@/components/compensation/CompTabs";

export const metadata = { title: "Compensation · Transworld PeopleOps" };

export default async function CompensationPage() {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");

  const { rows, hasActiveRuleSet, missingProfiles, pendingCount } =
    await getCompensationRegister();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Compensation</h1>
          <p>
            A control room for pay: standing salary inputs, provisional breakdowns
            and the salary-band and tax structures behind them. This portal never
            pays anyone — HumanManager and Remita stay authoritative.
          </p>
        </div>
      </div>

      <CompTabs active="register" pendingCount={pendingCount} />

      {!hasActiveRuleSet ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No active tax rule set.</b>{" "}
                {canManage
                  ? "PAYE estimates can’t be computed until a rule set is marked active. Set one up under Tax rules."
                  : "PAYE estimates can’t be shown until an HR admin activates a tax rule set."}
              </div>
            </div>
          </div>
        </div>
      ) : null}

      {missingProfiles.length ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>⚠</span>
              <div>
                <b>
                  {missingProfiles.length} employee
                  {missingProfiles.length === 1 ? "" : "s"} without a compensation profile.
                </b>{" "}
                {missingProfiles.map((m, i) => (
                  <span key={m.eeId}>
                    {i > 0 ? ", " : ""}
                    {m.name} ({m.eeId})
                  </span>
                ))}
                {canManage ? " — open each to establish one." : "."}
              </div>
            </div>
          </div>
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Register</h3>
          <span className="hint">{rows.length} non-exited staff</span>
        </div>
        <div className="card-pad">
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Category</th>
                <th>Grade</th>
                <th className="num">Basic / Gross</th>
                <th className="num">PAYE est</th>
                <th className="num">Net est</th>
                <th>Tax</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const tb = r.treatment ? treatmentBadge(r.treatment) : null;
                return (
                  <tr key={r.employeeId}>
                    <td>
                      <Link href={`/compensation/${r.employeeId}`} className="jc-link">
                        {r.name}
                      </Link>
                      <div className="faint mono">{r.eeId}</div>
                    </td>
                    <td>{r.payCategory ?? "—"}</td>
                    <td>{r.grade ?? "—"}</td>
                    <td className="num mono">
                      {r.hasProfile ? (
                        <>
                          {fmtNaira(r.basic)}
                          <div className="faint">{fmtNaira(r.gross)}</div>
                        </>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td className="num mono">{r.hasProfile ? fmtNaira(r.paye) : "—"}</td>
                    <td className="num mono">{r.hasProfile ? fmtNaira(r.net) : "—"}</td>
                    <td>{tb ? <span className={`b ${tb.cls}`}>{tb.label}</span> : <span className="faint">—</span>}</td>
                    <td>
                      {!r.hasProfile ? (
                        <span className="b b-gry">No profile</span>
                      ) : r.pendingRequest ? (
                        <span className="b b-amb">Change pending</span>
                      ) : (
                        <span className="b b-grn">Current</span>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}
