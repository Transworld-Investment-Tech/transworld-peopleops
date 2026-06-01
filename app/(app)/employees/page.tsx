import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import EmployeesTabs from "@/components/employees/EmployeesTabs";
import { getPresentCategoriesByEmployee } from "@/lib/staff-documents";
import {
  getEmployeesForList,
  empInitials,
  statusBadge,
  typeLabel,
  docCompleteness,
  barClass,
} from "@/lib/employees";

export const metadata = { title: "Employees · Transworld PeopleOps" };

export default async function EmployeesPage() {
  const me = await requirePermission("employees.view");
  const canManage = hasPermission(me, "employees.manage");
  const rows = await getEmployeesForList();

  const catMap = await getPresentCategoriesByEmployee(rows.map((r) => r.id));
  const completeness = rows.map((r) => docCompleteness(catMap.get(r.id) ?? []));
  const total = rows.length;
  const active = rows.filter((r) => r.status === "ACTIVE").length;
  const probation = rows.filter((r) => r.status === "PROBATION").length;
  const filesComplete = completeness.filter((c) => c.pct >= 100).length;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Employee Master Database</h1>
          <p>
            Single source of truth for staff, consultants, and outsourced roles
            across Transworld Investment &amp; Securities (TISL).
          </p>
        </div>
        {canManage ? (
          <Link href="/employees/new" className="btn btn-pri">
            + Add employee
          </Link>
        ) : (
          <button className="btn btn-pri" disabled title="Requires the Manage employees permission">
            + Add employee
          </button>
        )}
      </div>

      <EmployeesTabs />

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Headcount</div>
          <div className="val">{total}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Active</div>
          <div className="val">{active}</div>
        </div>
        <div className="card kpi">
          <div className="lab">On probation</div>
          <div className="val">{probation}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Staff files complete</div>
          <div className="val">
            {filesComplete}
            <span className="faint" style={{ fontSize: 15 }}>
              /{total}
            </span>
          </div>
        </div>
      </div>

      <div className="card">
        <table>
          <thead>
            <tr>
              <th>Employee</th>
              <th>Entity</th>
              <th>Department</th>
              <th>Category</th>
              <th>Type</th>
              <th>Status</th>
              <th>Documents</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => {
              const s = statusBadge(r.status);
              const c = completeness[i];
              return (
                <tr key={r.id}>
                  <td>
                    <Link href={`/employees/${r.id}`} className="emp emp-link">
                      <span className="chip">{empInitials(r.fullName)}</span>
                      <span>
                        <span className="nm">{r.fullName}</span>
                        <span className="rl">
                          {r.jobProfile?.title ?? r.eeId}
                        </span>
                      </span>
                    </Link>
                  </td>
                  <td>{r.entity?.code ?? "—"}</td>
                  <td>{r.department?.name ?? "—"}</td>
                  <td>{r.payCategory?.name ?? "—"}</td>
                  <td>{typeLabel(r.employmentType)}</td>
                  <td>
                    <span className={"b " + s.cls}>
                      <span className="dot" />
                      {s.label}
                    </span>
                  </td>
                  <td>
                    <div className="docbar">
                      <div className={"bar " + barClass(c.pct)}>
                        <i style={{ width: `${c.pct}%` }} />
                      </div>
                      <span className="mono">
                        {c.have}/{c.total}
                      </span>
                      {c.pct === 0 && (
                        <span className="faint" style={{ fontSize: 11.5 }}>
                          none on file
                        </span>
                      )}
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </>
  );
}
