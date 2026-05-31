import { requirePermission } from "@/lib/auth/rbac";
import { getBalancesMatrix, leaveYear } from "@/lib/leave";
import LeaveTabs from "@/components/leave/LeaveTabs";
import EntitlementEditor from "@/components/leave/EntitlementEditor";

export const metadata = { title: "Leave balances · Transworld PeopleOps" };

export default async function LeaveBalancesPage() {
  await requirePermission("leave.manage");
  const year = leaveYear();
  const { types, rows } = await getBalancesMatrix(year);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Leave balances · {year}</h1>
          <p>
            Entitlements are editable per person. Days taken come from approved requests; remaining
            is entitled minus taken.
          </p>
        </div>
      </div>

      <LeaveTabs active="balances" showManage />

      {rows.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>No active employees to show.</div>
            </div>
          </div>
        </div>
      ) : (
        <div className="card">
          <div className="card-pad" style={{ overflowX: "auto" }}>
            <table className="table">
              <thead>
                <tr>
                  <th>Employee</th>
                  {types.map((t) => (
                    <th key={t.id}>{t.name}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {rows.map((row) => (
                  <tr key={row.employeeId}>
                    <td>
                      <span className="nm">{row.name}</span>{" "}
                      <span className="faint mono">{row.eeId}</span>
                    </td>
                    {row.cells.map((c) => (
                      <td key={c.leaveTypeId}>
                        <EntitlementEditor
                          employeeId={row.employeeId}
                          leaveTypeId={c.leaveTypeId}
                          year={year}
                          entitled={c.entitled}
                          taken={c.taken}
                          remaining={c.remaining}
                        />
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </>
  );
}
