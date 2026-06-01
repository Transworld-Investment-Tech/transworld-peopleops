import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOpeningDetail, stageBadge, fmtDate } from "@/lib/recruitment";
import {
  AddCandidateForm,
  CandidateStageControl,
  RequisitionStatusControl,
} from "@/components/recruitment/CandidatePipelineControls";

export const metadata = { title: "Pipeline · Transworld PeopleOps" };

export default async function PipelinePage({
  params,
}: {
  params: Promise<{ openingId: string }>;
}) {
  const me = await requirePermission("recruitment.view");
  const canManage = hasPermission(me, "recruitment.manage");
  const { openingId } = await params;
  const d = await getOpeningDetail(openingId);
  if (!d) notFound();

  const sub = [d.departmentName, d.jobProfileTitle].filter(Boolean).join(" · ");

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">
            {d.title}
            {d.grade ? ` (${d.grade})` : ""}
          </h1>
          <p>
            <span className="faint mono">{d.code}</span>
            {sub ? ` · ${sub}` : ""} · opened {fmtDate(d.openedAt)} · {d.headcount} to hire
          </p>
        </div>
        <Link href="/recruitment" className="btn">
          ← All requisitions
        </Link>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Pipeline</h3>
          {canManage ? (
            <RequisitionStatusControl openingId={d.id} status={d.status} />
          ) : (
            <span className={`b ${stageBadge(d.status).cls}`}>{d.status}</span>
          )}
        </div>
        <div className="card-pad">
          <div
            style={{
              display: "grid",
              gridTemplateColumns: `repeat(${d.columns.length}, minmax(0, 1fr))`,
              gap: 12,
              alignItems: "start",
            }}
          >
            {d.columns.map((col) => (
              <div key={col.stage}>
                <div className="sec-t" style={{ marginBottom: 8 }}>
                  {col.label} · {col.candidates.length}
                </div>
                {col.candidates.length === 0 ? (
                  <p className="faint" style={{ margin: 0, fontSize: 12 }}>
                    —
                  </p>
                ) : (
                  col.candidates.map((c) => (
                    <div
                      key={c.id}
                      style={{
                        border: "1px solid var(--line)",
                        borderRadius: 8,
                        padding: 10,
                        marginBottom: 8,
                        background: "#fff",
                      }}
                    >
                      <div className="nm">{c.fullName}</div>
                      {c.source ? <div className="faint" style={{ fontSize: 12 }}>{c.source}</div> : null}
                      {c.stageNote ? <div className="faint" style={{ fontSize: 12 }}>{c.stageNote}</div> : null}
                      {c.interviewAt ? (
                        <div className="faint" style={{ fontSize: 12 }}>Interview {fmtDate(c.interviewAt)}</div>
                      ) : null}
                      {canManage ? (
                        <CandidateStageControl candidateId={c.id} openingId={d.id} stage={c.stage} />
                      ) : null}
                    </div>
                  ))
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      {d.terminal.length > 0 ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Closed candidates</h3>
            <span className="hint">hired, rejected or withdrawn</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>Candidate</th>
                <th>Outcome</th>
                <th>Note</th>
                {canManage ? <th>Move</th> : null}
              </tr>
            </thead>
            <tbody>
              {d.terminal.map((c) => {
                const b = stageBadge(c.stage);
                return (
                  <tr key={c.id}>
                    <td>
                      <b>{c.fullName}</b>
                      {c.source ? <span className="faint"> · {c.source}</span> : null}
                    </td>
                    <td>
                      <span className={`b ${b.cls}`}>{b.label}</span>
                    </td>
                    <td className="faint">{c.stageNote ?? "—"}</td>
                    {canManage ? (
                      <td>
                        <CandidateStageControl candidateId={c.id} openingId={d.id} stage={c.stage} />
                      </td>
                    ) : null}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : null}

      {canManage ? (
        <div className="card">
          <div className="card-h">
            <h3>Add a candidate</h3>
            <span className="hint">to {d.code}</span>
          </div>
          <div className="card-pad">
            <AddCandidateForm openingId={d.id} />
          </div>
        </div>
      ) : null}
    </>
  );
}
