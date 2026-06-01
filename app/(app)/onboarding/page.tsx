import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOnboardingList, planStatusBadge, fmtDate } from "@/lib/onboarding";
import StartOnboardingForm from "@/components/onboarding/StartOnboardingForm";

export const metadata = { title: "Onboarding · Transworld PeopleOps" };

export default async function OnboardingPage() {
  const me = await requirePermission("onboarding.view");
  const canManage = hasPermission(me, "onboarding.manage");
  const { rows, eligible } = await getOnboardingList();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Onboarding &amp; Probation</h1>
          <p>Structured induction and probation-to-confirmation tracking — no more informal appointments.</p>
        </div>
      </div>

      {canManage ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Start onboarding</h3>
            <span className="hint">creates an induction plan for a new hire</span>
          </div>
          <div className="card-pad">
            <StartOnboardingForm eligible={eligible} />
          </div>
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Onboarding plans</h3>
          <span className="hint">{rows.length} active</span>
        </div>
        {rows.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>No onboarding plans yet{canManage ? " — start one above." : "."}</div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>New hire</th>
                <th>Staff ID</th>
                <th>Status</th>
                <th>Progress</th>
                <th>Start date</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const b = planStatusBadge(r.planStatus);
                return (
                  <tr key={r.employeeId}>
                    <td>
                      <b>{r.name}</b>
                    </td>
                    <td className="faint mono">{r.eeId}</td>
                    <td>
                      <span className={`b ${b.cls}`}>{b.label}</span>
                    </td>
                    <td>
                      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                        <div className="bar" style={{ width: 120 }}>
                          <i
                            style={{
                              width: `${r.pct}%`,
                              background: r.pct >= 100 ? "var(--green)" : "var(--amber, #c98a1b)",
                            }}
                          />
                        </div>
                        <span className="faint" style={{ fontSize: 12 }}>
                          {r.done}/{r.total}
                        </span>
                      </div>
                    </td>
                    <td>{fmtDate(r.startDate)}</td>
                    <td className="num">
                      <Link href={`/onboarding/${r.employeeId}`} className="jc-link">
                        Open →
                      </Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
