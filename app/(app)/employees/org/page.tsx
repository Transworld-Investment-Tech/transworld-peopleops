import { requirePermission } from "@/lib/auth/rbac";
import EmployeesTabs from "@/components/employees/EmployeesTabs";
import OrgChart from "@/components/employees/OrgChart";
import { getOrgData } from "@/lib/employees";

export const metadata = { title: "Org chart · Employees · Transworld PeopleOps" };

export default async function EmployeesOrgPage() {
  // Same gate as the directory; the org chart is a view of the same data.
  await requirePermission("employees.view");
  const { roots, hasHierarchy, count } = await getOrgData();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Employee Master Database</h1>
          <p>Reporting lines, built from each employee&apos;s manager.</p>
        </div>
      </div>

      <EmployeesTabs />

      {!hasHierarchy ? (
        <div className="note">
          <span>ℹ</span>
          <div>
            <b>No reporting lines set yet.</b> The chart is built from{" "}
            <span className="mono">employees.manager_id</span>, which is
            currently empty for all {count} staff, so everyone is shown
            unassigned below. Once managers are set (via Manage employees, a
            later build, or a one-off mapping), this view renders the full
            hierarchy automatically.
          </div>
        </div>
      ) : (
        <div className="card-pad" style={{ paddingLeft: 0, paddingTop: 0 }}>
          <span className="faint">
            {count} staff · reporting lines from manager assignments
          </span>
        </div>
      )}

      <div className="card card-pad">
        <OrgChart roots={roots} hasHierarchy={hasHierarchy} />
      </div>
    </>
  );
}
