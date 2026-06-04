import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  getEmployeeDetail,
  getEmployeeDependents,
  empInitials,
  statusBadge,
  typeLabel,
  docCompleteness,
  barClass,
  fmtDate,
  relationshipLabel,
  eventTypeLabel,
  optLabel,
  GENDERS,
  MARITAL_STATUSES,
  WORK_LOCATIONS,
  ID_TYPES,
} from "@/lib/employees";
import {
  getStaffDocuments,
  getPresentCategories,
  statusBadge as docStatusBadge,
  sourceBadge as docSourceBadge,
  prettySize,
  fmtDate as docFmtDate,
  fmtDateTime,
  DOC_CATEGORIES,
} from "@/lib/staff-documents";
import { getActiveTemplates, kindLabel } from "@/lib/document-templates";
import { storageConfigured } from "@/lib/storage";
import StaffDocumentsPanel, { type DocView } from "@/components/documents/StaffDocumentsPanel";
import DependentsEditor, { type DependentView } from "@/components/employees/DependentsEditor";
import EmploymentHistoryForm from "@/components/employees/EmploymentHistoryForm";

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
  const canManageDocs = hasPermission(me, "documents.manage");
  const s = statusBadge(emp.status);

  const [presentCategories, staffDocs, templates, dependents] = await Promise.all([
    getPresentCategories(emp.id),
    getStaffDocuments(emp.id),
    getActiveTemplates(),
    getEmployeeDependents(emp.id),
  ]);
  const comp = docCompleteness(presentCategories);
  const storageReady = storageConfigured();

  const docViews: DocView[] = staffDocs.map((d) => {
    const sb = docStatusBadge(d.status);
    const src = docSourceBadge(d.source);
    return {
      id: d.id,
      title: d.title,
      category: d.category,
      statusCls: sb.cls,
      statusLabel: sb.label,
      sourceCls: src.cls,
      sourceLabel: src.label,
      sizeLabel: prettySize(d.sizeBytes),
      createdAt: docFmtDate(d.createdAt),
      expiry: d.expiryDate ? docFmtDate(d.expiryDate) : null,
      hasFile: Boolean(d.fileKey),
      isGeneratedDraft: d.source === "GENERATED" && d.status === "DRAFT",
      awaiting: d.status === "AWAITING_SIGNATURE",
      signerName: d.signerName ?? null,
      signedAt: d.signedAt ? fmtDateTime(d.signedAt) : null,
    };
  });
  const templateOpts = templates.map((t) => ({
    id: t.id,
    name: t.name,
    kindLabel: kindLabel(t.kind),
  }));
  const categoryOpts = DOC_CATEGORIES.map((c) => ({ key: c.key, label: c.label }));

  const dependentViews: DependentView[] = dependents.map((d) => ({
    id: d.id,
    fullName: d.fullName,
    relationshipLabel: relationshipLabel(d.relationship),
    dateOfBirth: d.dateOfBirth ? fmtDate(d.dateOfBirth) : null,
  }));

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
              <div className="row"><span className="k">Employee ID</span><span className="v mono">{emp.eeId}</span></div>
              <div className="row"><span className="k">Entity</span><span className="v">{emp.entity?.name ?? "—"}</span></div>
              <div className="row"><span className="k">Department</span><span className="v">{emp.department?.name ?? "—"}</span></div>
              <div className="row"><span className="k">Pay category</span><span className="v">{emp.payCategory?.name ?? "—"}</span></div>
              <div className="row"><span className="k">Job profile</span><span className="v">{emp.jobProfile?.title ?? "—"}</span></div>
              <div className="row"><span className="k">Employment type</span><span className="v">{typeLabel(emp.employmentType)}</span></div>
              <div className="row"><span className="k">Work location</span><span className="v">{optLabel(WORK_LOCATIONS, emp.workLocation)}</span></div>
              <div className="row">
                <span className="k">Manager</span>
                <span className="v">
                  {emp.manager ? (
                    <Link href={`/employees/${emp.manager.id}`} className="emp-link">{emp.manager.fullName}</Link>
                  ) : ("—")}
                </span>
              </div>
              <div className="row"><span className="k">Start date</span><span className="v">{fmtDate(emp.startDate)}</span></div>
              {emp.exitDate && (
                <div className="row"><span className="k">Exit date</span><span className="v">{fmtDate(emp.exitDate)}</span></div>
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
              <div className="row"><span className="k">Work email</span><span className="v">{emp.workEmail ?? "—"}</span></div>
              <div className="row"><span className="k">Phone</span><span className="v">{emp.phone ?? "—"}</span></div>
              <div className="row"><span className="k">Bank</span><span className="v">{emp.bankNameMasked ?? "—"}</span></div>
              <div className="row"><span className="k">Account</span><span className="v mono">{emp.bankAcctMasked ? `•••• ${emp.bankAcctMasked}` : "—"}</span></div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid two-col mt">
        <div className="card">
          <div className="card-h">
            <h3>Personal</h3>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row"><span className="k">Date of birth</span><span className="v">{fmtDate(emp.dateOfBirth)}</span></div>
              <div className="row"><span className="k">Gender</span><span className="v">{optLabel(GENDERS, emp.gender)}</span></div>
              <div className="row"><span className="k">Marital status</span><span className="v">{optLabel(MARITAL_STATUSES, emp.maritalStatus)}</span></div>
              <div className="row"><span className="k">Nationality</span><span className="v">{emp.nationality ?? "—"}</span></div>
              <div className="row"><span className="k">State of origin</span><span className="v">{emp.stateOfOrigin ?? "—"}</span></div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-h">
            <h3>Personal contact &amp; address</h3>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row"><span className="k">Personal email</span><span className="v">{emp.personalEmail ?? "—"}</span></div>
              <div className="row"><span className="k">Personal phone</span><span className="v">{emp.personalPhone ?? "—"}</span></div>
              <div className="row"><span className="k">Address</span><span className="v">{emp.residentialAddress ?? "—"}</span></div>
              <div className="row"><span className="k">City</span><span className="v">{emp.city ?? "—"}</span></div>
              <div className="row"><span className="k">State</span><span className="v">{emp.stateRegion ?? "—"}</span></div>
              <div className="row"><span className="k">Country</span><span className="v">{emp.country ?? "—"}</span></div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid two-col mt">
        <div className="card">
          <div className="card-h">
            <h3>Next of kin</h3>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row"><span className="k">Name</span><span className="v">{emp.nokName ?? "—"}</span></div>
              <div className="row"><span className="k">Relationship</span><span className="v">{emp.nokRelationship ?? "—"}</span></div>
              <div className="row"><span className="k">Phone</span><span className="v">{emp.nokPhone ?? "—"}</span></div>
              <div className="row"><span className="k">Address</span><span className="v">{emp.nokAddress ?? "—"}</span></div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-h">
            <h3>Identification</h3>
            <span className="hint">Stored masked</span>
          </div>
          <div className="card-pad">
            <div className="kv">
              <div className="row"><span className="k">ID type</span><span className="v">{optLabel(ID_TYPES, emp.idType)}</span></div>
              <div className="row"><span className="k">ID number</span><span className="v mono">{emp.idNumberMasked ?? "—"}</span></div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid two-col mt">
        <div className="card">
          <div className="card-h">
            <h3>Document completeness</h3>
            <span className="hint">{comp.have}/{comp.total} required on file</span>
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
                  <span className="st b b-grn"><span className="dot" />On file</span>
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
                No required documents on file yet. Add them in the Documents panel below.
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

      <DependentsEditor employeeId={emp.id} dependents={dependentViews} canManage={canManage} />

      <StaffDocumentsPanel
        employeeId={emp.id}
        canManage={canManageDocs}
        storageReady={storageReady}
        docs={docViews}
        templates={templateOpts}
        categories={categoryOpts}
      />

      <div className="card mt">
        <div className="card-h">
          <h3>Employment history</h3>
          <span className="hint">Hires, promotions, transfers &amp; status changes</span>
        </div>
        {emp.employmentRecords.length === 0 ? (
          <div className="card-pad">
            <span className="faint">
              No employment records on file yet. Grade, role, reporting-line and status changes are
              recorded here automatically when you edit this employee, and you can add events manually below.
            </span>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Effective</th>
                <th>Event</th>
                <th>Title</th>
                <th>Grade</th>
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
                    <td>{eventTypeLabel(rec.eventType)}</td>
                    <td>{rec.title ?? "—"}</td>
                    <td className="mono">{rec.grade ?? "—"}</td>
                    <td><span className={"b " + rs.cls}>{rs.label}</span></td>
                    <td>{rec.note ?? "—"}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
        {canManage ? (
          <div className="card-pad">
            <div className="sec-t">Record a history event</div>
            <EmploymentHistoryForm employeeId={emp.id} />
          </div>
        ) : null}
      </div>

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        This record view was written to the audit log.
      </div>
    </>
  );
}
