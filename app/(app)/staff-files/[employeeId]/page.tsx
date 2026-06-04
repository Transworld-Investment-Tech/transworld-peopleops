import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getEmployeeStaffFile } from "@/lib/stafffile-data";
import { completenessBadge, completenessBarClass } from "@/lib/stafffile";
import { ClassifyDocForm, RegulatedToggle } from "@/components/stafffile/StaffFileControls";

export const metadata = { title: "Staff File · Transworld PeopleOps" };

export default async function EmployeeStaffFilePage({
  params,
}: {
  params: Promise<{ employeeId: string }>;
}) {
  const me = await requirePermission("stafffile.view");
  const canManage = hasPermission(me, "stafffile.manage");
  const { employeeId } = await params;
  const f = await getEmployeeStaffFile(employeeId);
  if (!f) notFound();

  const c = f.completeness;
  const badge = completenessBadge(c.pct);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{f.fullName}</h1>
          <p>
            <span className="faint mono">{f.eeId}</span> · {f.grade ?? "—"} · {f.status}
            {f.isRegulated ? <span className="b b-amb" style={{ marginLeft: 8 }}>Regulated role</span> : null}
          </p>
        </div>
        <Link href="/staff-files" className="btn">← All staff files</Link>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>D6.2 completeness</h3>
          <span className={`b ${badge.cls}`}>{badge.label}</span>
        </div>
        <div className="card-pad">
          <div className="ln-prog" style={{ maxWidth: 360 }}>
            <span className={completenessBarClass(c.pct)}>
              <i style={{ width: `${c.pct}%` }} />
            </span>
            <span className="faint">{c.satisfiedCount} of {c.requiredCount} required documents on file</span>
          </div>
          {canManage ? (
            <div style={{ marginTop: 12 }}>
              <RegulatedToggle employeeId={f.employeeId} isRegulated={f.isRegulated} />
              <p className="faint" style={{ fontSize: 11.5, marginTop: 4 }}>
                Regulated roles additionally require verified qualifications and SEC / NGX registration.
              </p>
            </div>
          ) : null}
        </div>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Document checklist</h3>
          <span className="hint">HR Operations Manual D6.2</span>
        </div>
        <table>
          <thead>
            <tr>
              <th></th>
              <th>Document</th>
              <th>Required for</th>
              <th>On file</th>
            </tr>
          </thead>
          <tbody>
            {f.slots.map((s) => {
              const dot = !s.required ? "b-gry" : s.satisfied ? "b-grn" : "b-red";
              const label = !s.required ? "N/A" : s.satisfied ? "On file" : "Missing";
              return (
                <tr key={s.slot}>
                  <td><span className={`b ${dot}`}>{label}</span></td>
                  <td>
                    <b>{s.label}</b>
                    {s.docs.length > 0 ? (
                      <div className="faint" style={{ fontSize: 12 }}>
                        {s.docs.map((d) => d.title).join(", ")}
                      </div>
                    ) : null}
                  </td>
                  <td className="faint" style={{ fontSize: 12 }}>{s.d62}</td>
                  <td className="num">{s.docs.length}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {canManage ? (
        <div className="card">
          <div className="card-h">
            <h3>File documents into D6.2 slots</h3>
            <span className="hint">classify uploaded documents so they count toward completeness</span>
          </div>
          <div className="card-pad">
            {f.unfiledDocs.length === 0 ? (
              <div className="note"><span>ℹ</span><div>No unfiled documents. Upload documents from the employee record, then file them here.</div></div>
            ) : (
              <div className="doc-list">
                {f.unfiledDocs.map((d) => (
                  <div key={d.id} className="row" style={{ display: "flex", gap: 12, alignItems: "center", padding: "8px 0", borderBottom: "1px solid var(--line)" }}>
                    <div style={{ flex: "1 1 auto" }}>
                      <b>{d.title}</b> <span className="faint">· {d.status}</span>
                    </div>
                    <ClassifyDocForm docId={d.id} employeeId={f.employeeId} current={null} />
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      ) : null}
    </>
  );
}
