import { requirePermission } from "@/lib/auth/rbac";
import { getLeaveTypesWithUsage } from "@/lib/leave";
import LeaveTabs from "@/components/leave/LeaveTabs";
import LeaveTypeEditor from "@/components/leave/LeaveTypeEditor";

export const metadata = { title: "Leave types · Transworld PeopleOps" };

export default async function LeaveTypesPage() {
  await requirePermission("leave.manage");
  const types = await getLeaveTypesWithUsage();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Leave types</h1>
          <p>
            The default days/year seed each person’s entitlement; individual figures can still be
            adjusted under Balances.
          </p>
        </div>
      </div>

      <LeaveTabs active="types" showManage />

      <div className="card">
        <div className="card-h">
          <h3>Types &amp; default entitlement</h3>
          <span className="hint">used by {types.length} type{types.length === 1 ? "" : "s"}</span>
        </div>
        <div className="card-pad">
          <LeaveTypeEditor types={types} />
          <p className="faint" style={{ marginBottom: 0, marginTop: 12 }}>
            Changing a default doesn’t alter balances already set — it applies the next time an
            employee’s balance for that type is created. Use Balances to adjust existing figures.
          </p>
        </div>
      </div>
    </>
  );
}
