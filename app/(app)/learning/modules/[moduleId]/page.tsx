import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getModule,
  getMyEmployee,
  getRecordForEmployee,
  fmtMinutes,
  moduleStatusBadge,
  recordStatusBadge,
  sourceBadge,
} from "@/lib/learning";
import MarkdownView from "@/components/learning/MarkdownView";
import { SelfLearning, RosterControls } from "@/components/learning/RecordControls";
import ModuleDelete from "@/components/learning/ModuleDelete";

export const metadata = { title: "Module · Transworld PeopleOps" };

export default async function ModulePage({
  params,
}: {
  params: Promise<{ moduleId: string }>;
}) {
  const me = await requirePermission("learning.view");
  const canManage = hasPermission(me, "learning.manage");
  const { moduleId } = await params;

  const view = await getModule(moduleId);
  if (!view) notFound();
  // Drafts are visible only to managers.
  if (view.module.status !== "PUBLISHED" && !canManage) notFound();

  const myEmployee = await getMyEmployee(me.id);
  const myRecord = myEmployee ? await getRecordForEmployee(moduleId, myEmployee.id) : null;
  const sb = moduleStatusBadge(view.module.status);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/learning" className="back-link">
            ← Library
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {view.module.title}
          </h1>
          <div className="ln-meta">
            <span>{view.module.category}</span>
            <span className="dot-sep">{fmtMinutes(view.module.estimatedMinutes)}</span>
            {canManage ? <span className={`b ${sb.cls}`}>{sb.label}</span> : null}
          </div>
        </div>
        {canManage ? (
          <Link href={`/learning/modules/${moduleId}/edit`} className="btn">
            Edit
          </Link>
        ) : null}
      </div>

      {view.competencies.length ? (
        <div className="ln-tags" style={{ marginBottom: 16 }}>
          {view.competencies.map((c) => (
            <span key={c.id} className="ln-tag">
              {c.name}
            </span>
          ))}
        </div>
      ) : null}

      <div className="card">
        {view.module.summary ? (
          <div className="card-pad" style={{ paddingBottom: 0 }}>
            <p className="faint" style={{ marginTop: 0, fontSize: 15 }}>
              {view.module.summary}
            </p>
          </div>
        ) : null}
        <div className="card-pad">
          <MarkdownView source={view.module.body} />
        </div>
      </div>

      {view.material ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Attached material</h3>
          </div>
          <div className="card-pad">
            <div className="doc-row">
              <span className="doc-ic" aria-hidden>
                📄
              </span>
              <div className="doc-meta">
                <a
                  className="doc-name"
                  href={`/learning/modules/${moduleId}/material`}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  {view.material.filename}
                </a>
                <span className="doc-sub">{view.material.sizeLabel}</span>
              </div>
            </div>
          </div>
        </div>
      ) : null}

      <SelfLearning
        moduleId={moduleId}
        record={
          myRecord
            ? { id: myRecord.id, status: myRecord.status, reflection: myRecord.reflection }
            : null
        }
        published={view.module.status === "PUBLISHED"}
      />

      {canManage ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Assignments</h3>
            <span className="hint">{view.roster.length} on roster</span>
          </div>
          <div className="card-pad">
            {view.roster.length === 0 ? (
              <p className="faint" style={{ marginTop: 0 }}>
                No one is enrolled yet. Staff can self-enroll, or recommend this module from an
                appraisal.
              </p>
            ) : (
              <table>
                <thead>
                  <tr>
                    <th>Employee</th>
                    <th>Source</th>
                    <th>Status</th>
                    <th>Completed</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  {view.roster.map((r) => {
                    const rb = recordStatusBadge(r.status, r.dueDate);
                    const src = sourceBadge(r.source);
                    return (
                      <tr key={r.recordId}>
                        <td>
                          {r.name}
                          <div className="faint mono">{r.eeId}</div>
                        </td>
                        <td>
                          <span className={`b ${src.cls}`}>{src.label}</span>
                        </td>
                        <td>
                          <span className={`b ${rb.cls}`}>{rb.label}</span>
                        </td>
                        <td className="faint">
                          {r.completedAt ? r.completedAt.toLocaleDateString("en-US") : "—"}
                        </td>
                        <td>
                          <RosterControls recordId={r.recordId} status={r.status} />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        </div>
      ) : null}

      {canManage ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Danger zone</h3>
          </div>
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              Deleting a module also removes its assignments and completion records.
            </p>
            <ModuleDelete moduleId={moduleId} />
          </div>
        </div>
      ) : null}
    </>
  );
}
