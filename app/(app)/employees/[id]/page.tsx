import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  getEmployeeDetail,
  empInitials,
  statusBadge,
  typeLabel,
  docCompleteness,
  barClass,
  fmtDate,
} from "@/lib/employees";

export const metadata = { title: "Employee · Transworld PeopleOps" };

export default async function EmployeeProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const me = await requirePermission("employees.view");
  const { id } = await params;
  const emp = await getEmployeeDetail(id);
  if (!emp) notFound();

  // Sensitive personal data: record that this record was opened.
  await writeAudit({
    actorId: me.id,
    action: "employee.view",
    entityType: "employee",
    entityId: emp.id,
    metadata: { eeId: emp.eeId, fullName: emp.fullName },
  });

  const canManage = hasPermission(me, "employees.manage");
  const s = statusBadge(emp.status);
  const comp = docCompleteness(emp.documents.map((d) => d.category));

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/employees" className="back-link">
            ← Employees
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {emp.fullName}
          </h1>
          <p>
            {emp.eeId} · {emp.jobProfile?.title ?? "No job profile linked"} ·{" "}
            <span className={"b " + s.cls}>
              <span className="dot" />
              {s.label}
            </span>
          </p>
        </div>
        {canManage ? (
          <Link href={`/employees/${emp.id}/edit`} className="btn">
            Edit
          </Link>
        ) : (
          <button className="btn" disabled title="Requires the Manage employees permission">
            Edit
          </button>
        )}
      </div>

      <div className="grid two-col">
        <div className="card">
          <div className="card-h">
            <h3>Organization &amp; employment</h3>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row">
                <span className="k">Employee ID</span>
                <span className="v mono">{emp.eeId}</span>
              </div>
              <div className="row">
                <span className="k">Entity</span>
                <span className="v">{emp.entity?.name ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Department</span>
                <span className="v">{emp.department?.name ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Pay category</span>
                <span className="v">{emp.payCategory?.name ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Job profile</span>
                <span className="v">{emp.jobProfile?.title ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Employment type</span>
                <span className="v">{typeLabel(emp.employmentType)}</span>
              </div>
              <div className="row">
                <span className="k">Manager</span>
                <span className="v">
                  {emp.manager ? (
                    <Link href={`/employees/${emp.manager.id}`} className="emp-link">
                      {emp.manager.fullName}
                    </Link>
                  ) : (
                    "—"
                  )}
                </span>
              </div>
              <div className="row">
                <span className="k">Start date</span>
                <span className="v">{fmtDate(emp.startDate)}</span>
              </div>
              {emp.exitDate && (
                <div className="row">
                  <span className="k">Exit date</span>
                  <span className="v">{fmtDate(emp.exitDate)}</span>
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-h">
            <h3>Contact &amp; banking</h3>
            <span className="hint">Bank details stored masked</span>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row">
                <span className="k">Work email</span>
                <span className="v">{emp.workEmail ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Phone</span>
                <span className="v">{emp.phone ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Bank</span>
                <span className="v">{emp.bankNameMasked ?? "—"}</span>
              </div>
              <div className="row">
                <span className="k">Account</span>
                <span className="v mono">
                  {emp.bankAcctMasked ? `•••• ${emp.bankAcctMasked}` : "—"}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid two-col mt">
        <div className="card">
          <div className="card-h">
            <h3>Document completeness</h3>
            <span className="hint">
              {comp.have}/{comp.total} required on file
            </span>
          </div>
          <div className="card-pad">
            <div className="docbar" style={{ marginBottom: 14 }}>
              <div className={"bar " + barClass(comp.pct)} style={{ width: 200 }}>
                <i style={{ width: `${comp.pct}%` }} />
              </div>
              <span className="mono">{comp.pct}%</span>
            </div>
            <div className="doc-list">
              {comp.present.map((c) => (
                <div className="row" key={c}>
                  <span>{c}</span>
                  <span className="st b b-grn">
                    <span className="dot" />
                    On file
                  </span>
                </div>
              ))}
              {comp.missing.map((c) => (
                <div className="row" key={c}>
                  <span>{c}</span>
                  <span className="st b b-gry">Missing</span>
                </div>
              ))}
            </div>
            {comp.have === 0 && (
              <div className="faint" style={{ fontSize: 12, marginTop: 12 }}>
                No documents are on file yet. Document upload and storage arrive
                in the Documents &amp; policies build.
              </div>
            )}
          </div>
        </div>

        <div className="card">
          <div className="card-h">
            <h3>Direct reports</h3>
            <span className="hint">{emp.reports.length}</span>
          </div>
          <div className="card-pad">
            {emp.reports.length === 0 ? (
              <span className="faint">No direct reports.</span>
            ) : (
              <div className="doc-list">
                {emp.reports.map((r) => (
                  <div className="row" key={r.id}>
                    <Link href={`/employees/${r.id}`} className="emp emp-link">
                      <span className="chip">{empInitials(r.fullName)}</span>
                      <span className="nm">{r.fullName}</span>
                    </Link>
                    <span className="st faint mono">{r.eeId}</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Reporting-line history</h3>
          <span className="hint">From employment records</span>
        </div>
        {emp.employmentRecords.length === 0 ? (
          <div className="card-pad">
            <span className="faint">
              No employment records on file. Title, department, and
              reporting-line changes will appear here once recorded.
            </span>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Effective</th>
                <th>Title</th>
                <th>Status</th>
                <th>Note</th>
              </tr>
            </thead>
            <tbody>
              {emp.employmentRecords.map((rec) => {
                const rs = statusBadge(rec.status);
                return (
                  <tr key={rec.id}>
                    <td>{fmtDate(rec.effectiveDate)}</td>
                    <td>{rec.title ?? "—"}</td>
                    <td>
                      <span className={"b " + rs.cls}>{rs.label}</span>
                    </td>
                    <td>{rec.note ?? "—"}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        This record view was written to the audit log.
      </div>
    </>
  );
}
