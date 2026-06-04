import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getOpeningDetail,
  stageBadge,
  fmtDate,
  reasonLabel,
  requisitionStageLabel,
} from "@/lib/recruitment";
import { getActiveTemplates, kindLabel } from "@/lib/document-templates";
import { getCandidateDocsLite, statusBadge as docStatusBadge } from "@/lib/staff-documents";
import GenerateDocControl, { type DocLite } from "@/components/documents/GenerateDocControl";
import ConvertCandidate from "@/components/recruitment/ConvertCandidate";
import {
  AddCandidateForm,
  CandidateStageControl,
  OfferTermsForm,
  RequisitionStatusControl,
} from "@/components/recruitment/CandidatePipelineControls";
import RequisitionGates from "@/components/recruitment/RequisitionGates";
import {
  SelectionControl,
  ChecksControl,
  StageTimeline,
} from "@/components/recruitment/CandidateAdvancedControls";

export const metadata = { title: "Pipeline · Transworld PeopleOps" };

export default async function PipelinePage({
  params,
}: {
  params: Promise<{ openingId: string }>;
}) {
  const me = await requirePermission("recruitment.view");
  const canManage = hasPermission(me, "recruitment.manage");
  const canConvert = hasPermission(me, "employees.manage");
  const canApprove = hasPermission(me, "requisition.approve");
  const canCco = hasPermission(me, "selection.cco");
  const { openingId } = await params;
  const d = await getOpeningDetail(openingId);
  if (!d) notFound();

  const offerColumn = d.columns.find((c) => c.stage === "OFFER");
  const offerCandidateIds = offerColumn?.candidates.map((c) => c.id) ?? [];
  const offerTemplates = canManage
    ? (await getActiveTemplates())
        .filter((t) => t.kind === "OFFER_LETTER")
        .map((t) => ({ id: t.id, name: t.name, kindLabel: kindLabel(t.kind) }))
    : [];
  const candDocs =
    canManage && offerCandidateIds.length
      ? await getCandidateDocsLite(offerCandidateIds)
      : new Map<string, { id: string; title: string; status: string; source: string; fileKey: string | null }[]>();
  const docLites = (candidateId: string): DocLite[] =>
    (candDocs.get(candidateId) ?? []).map((r: { id: string; title: string; status: string; source: string; fileKey: string | null }) => {
      const sb = docStatusBadge(r.status);
      return { id: r.id, title: r.title, statusCls: sb.cls, statusLabel: sb.label, hasFile: Boolean(r.fileKey) };
    });

  const sub = [d.departmentName, d.jobProfileTitle].filter(Boolean).join(" · ");
  const controlFn = d.isControlFunction || d.jobProfileIsControlFunction;

  const renderAdvanced = (c: (typeof d.columns)[number]["candidates"][number]) => (
    <>
      {canManage && (c.stage === "SHORTLISTED" || c.stage === "INTERVIEW" || c.stage === "SELECTED" || c.stage === "CHECKS") ? (
        <SelectionControl
          candidateId={c.id}
          openingId={d.id}
          selectionRationale={c.selectionRationale}
          selectedByName={c.selectedByName}
          selectedAt={c.selectedAt ? fmtDate(c.selectedAt) : null}
          ccoSignoffByName={c.ccoSignoffByName}
          ccoSignoffAt={c.ccoSignoffAt ? fmtDate(c.ccoSignoffAt) : null}
          isControlFunction={controlFn}
          canCco={canCco}
        />
      ) : null}
      {canManage && (c.stage === "SELECTED" || c.stage === "CHECKS") ? (
        <ChecksControl
          candidateId={c.id}
          openingId={d.id}
          ready={c.checksReady}
          checks={c.checks.map((k) => ({
            id: k.id,
            checkType: k.checkType,
            applicable: k.applicable,
            status: k.status,
            clearedByName: k.clearedByName,
            note: k.note,
          }))}
        />
      ) : null}
      {canManage ? (
        <StageTimeline
          events={c.stageEvents.map((e) => ({
            id: e.id,
            stage: e.stage,
            clearedAt: fmtDate(e.clearedAt),
            clearedByName: e.clearedByName,
            note: e.note,
          }))}
        />
      ) : null}
    </>
  );

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
            {d.reason ? ` · ${reasonLabel(d.reason)}` : ""}
          </p>
        </div>
        <Link href="/recruitment" className="btn">
          ← All requisitions
        </Link>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Requisition gates</h3>
          <span className="hint">{requisitionStageLabel(d.reqStage)}</span>
        </div>
        <div className="card-pad">
          <RequisitionGates
            openingId={d.id}
            reqStageLabel={requisitionStageLabel(d.reqStage)}
            reason={d.reason}
            mustHaves={d.mustHaves}
            budgetBand={d.budgetBand}
            isControlFunction={controlFn}
            raisedByName={d.raisedByName}
            raisedAt={fmtDate(d.raisedAt)}
            cfoApprovedByName={d.cfoApprovedByName}
            cfoApprovedAt={d.cfoApprovedAt ? fmtDate(d.cfoApprovedAt) : null}
            mdApprovedByName={d.mdApprovedByName}
            mdApprovedAt={d.mdApprovedAt ? fmtDate(d.mdApprovedAt) : null}
            rolePackConfirmedByName={d.rolePackConfirmedByName}
            rolePackConfirmedAt={d.rolePackConfirmedAt ? fmtDate(d.rolePackConfirmedAt) : null}
            canApprove={canApprove}
            canManage={canManage}
          />
          {d.businessCase ? (
            <p className="faint" style={{ marginTop: 10, fontSize: 12.5 }}>
              <b>Business case:</b> {d.businessCase}
            </p>
          ) : null}
        </div>
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
                      {renderAdvanced(c)}
                      {canManage && col.stage === "OFFER" ? (
                        <div style={{ marginTop: 8, borderTop: "1px dashed var(--line)", paddingTop: 8 }}>
                          <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>
                            Offer terms
                          </div>
                          <OfferTermsForm
                            candidateId={c.id}
                            openingId={d.id}
                            grade={c.offerGrade}
                            basic={c.offerBasic}
                            utility={c.offerUtility}
                            startDate={c.offerStartDate ? new Date(c.offerStartDate).toISOString().slice(0, 10) : null}
                            acceptanceDeadline={c.offerAcceptanceDeadline ? new Date(c.offerAcceptanceDeadline).toISOString().slice(0, 10) : null}
                          />
                          <div className="faint" style={{ fontSize: 11.5, marginBottom: 4 }}>
                            Offer letter
                          </div>
                          <GenerateDocControl
                            candidateId={c.id}
                            templates={offerTemplates}
                            docs={docLites(c.id)}
                            allowUpload
                          />
                          {canConvert ? (
                            <ConvertCandidate
                              candidateId={c.id}
                              openingId={d.id}
                              defaultStartDate={c.offerStartDate ? new Date(c.offerStartDate).toISOString().slice(0, 10) : null}
                            />
                          ) : null}
                        </div>
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
