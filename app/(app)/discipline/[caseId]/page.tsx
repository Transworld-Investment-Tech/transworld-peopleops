import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getDisciplinaryCase } from "@/lib/disciplinary";
import { caseStatusLabel, stageLabel, statusBadgeClass, isActiveSanction } from "@/lib/ws5";
import {
  InvestigationForm,
  SuspendControl,
  IssueActionForm,
  ResponseForm,
  AckForm,
  CloseForm,
} from "@/components/discipline/DisciplineControls";

export const metadata = { title: "Disciplinary case · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}
const WARNING_STAGES = new Set(["VERBAL_WARNING", "WRITTEN_WARNING", "FINAL_WRITTEN_WARNING"]);

export default async function DisciplinaryCaseDetail({ params }: { params: Promise<{ caseId: string }> }) {
  const me = await requirePermission("discipline.manage");
  const { caseId } = await params;
  const c = await getDisciplinaryCase(caseId);
  if (!c) notFound();
  const canApprove = hasPermission(me, "discipline.approve");
  const canDismiss = hasPermission(me, "discipline.dismiss");
  const closed = c.status === "CLOSED";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/discipline" className="back-link">← Disciplinary</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>{c.employeeName}</h1>
          <p>
            <span className={"b " + statusBadgeClass(c.status)}>{caseStatusLabel(c.status)}</span>
            {c.currentStage ? <> · {stageLabel(c.currentStage)}</> : null}
            {c.isRegulatory ? <> · <span className="b b-red">Regulatory</span></> : null}
            {c.isGrossMisconduct ? <> · <span className="b b-red">Gross misconduct</span></> : null}
          </p>
        </div>
      </div>

      <div className="grid two-col">
        <div className="card">
          <div className="card-h"><h3>Case</h3></div>
          <div className="card-pad">
            <p style={{ marginTop: 0 }}>{c.concern}</p>
            <div className="kv">
              <div className="row"><span className="k">Opened</span><span className="v">{fmtDate(c.openedAt)} · {c.preparedByName ?? "—"}</span></div>
              <div className="row"><span className="k">Suspension</span><span className="v">{c.suspendedAt ? `Since ${fmtDate(c.suspendedAt)}${c.suspensionEndsAt ? ` · until ${fmtDate(c.suspensionEndsAt)}` : ""}` : "—"}</span></div>
              <div className="row"><span className="k">Acknowledged</span><span className="v">{c.ackName ? `${c.ackName} · ${fmtDate(c.ackAt)}` : "—"}</span></div>
              {closed ? <div className="row"><span className="k">Outcome</span><span className="v">{c.outcome ?? "Closed"}</span></div> : null}
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-h"><h3>Investigation</h3><span className="hint">Required before a written warning+</span></div>
          <div className="card-pad">
            {c.investigationSummary ? (
              <p className="faint" style={{ marginTop: 0 }}>{c.investigationSummary}<br /><span style={{ fontSize: 12 }}>{c.investigatedByName} · {fmtDate(c.investigatedAt)}</span></p>
            ) : null}
            {!closed ? <InvestigationForm caseId={c.id} current={c.investigationSummary} /> : null}
          </div>
        </div>
      </div>

      {!closed ? (
        <div className="card mt">
          <div className="card-h"><h3>Suspension</h3><span className="hint">Gross misconduct — full pay</span></div>
          <div className="card-pad"><SuspendControl caseId={c.id} suspended={Boolean(c.suspendedAt) && !c.suspensionEndsAt} /></div>
        </div>
      ) : null}

      <div className="card mt">
        <div className="card-h"><h3>Sanctions</h3><span className="hint">{c.actions.length}</span></div>
        {c.actions.length === 0 ? (
          <div className="card-pad"><span className="faint">No sanctions issued yet.</span></div>
        ) : (
          <table>
            <thead><tr><th>Stage</th><th>Issued</th><th>Sign-off</th><th>Retention</th><th>Response</th></tr></thead>
            <tbody>
              {c.actions.map((a) => {
                const isWarning = WARNING_STAGES.has(a.stage);
                const retentionLabel = !isWarning ? "—" : a.expiresAt
                  ? `${isActiveSanction(a.expiresAt) ? "Active until" : "Spent"} ${fmtDate(a.expiresAt)}`
                  : "Permanent";
                return (
                  <tr key={a.id}>
                    <td><b>{stageLabel(a.stage)}</b>{a.requiredStandard ? <div className="faint" style={{ fontSize: 12 }}>{a.requiredStandard}</div> : null}{a.consequence ? <div className="faint" style={{ fontSize: 12 }}>{a.consequence}</div> : null}</td>
                    <td>{fmtDate(a.issuedAt)}</td>
                    <td>{a.approverRole ? `${a.approverRole} · ${a.approvedByName ?? "—"}` : "—"}</td>
                    <td>{retentionLabel}</td>
                    <td>
                      {a.employeeResponse ? <span className="faint">{a.employeeResponse}</span> : (!closed ? <ResponseForm caseId={c.id} actionId={a.id} /> : "—")}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {!closed ? (
        <div className="grid two-col mt">
          <div className="card">
            <div className="card-h"><h3>Issue a sanction</h3></div>
            <div className="card-pad"><IssueActionForm caseId={c.id} canApprove={canApprove} canDismiss={canDismiss} /></div>
          </div>
          <div className="card">
            <div className="card-h"><h3>Acknowledgment &amp; close</h3></div>
            <div className="card-pad">
              <AckForm caseId={c.id} />
              <div style={{ height: 12 }} />
              <CloseForm caseId={c.id} />
            </div>
          </div>
        </div>
      ) : null}

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>Disciplinary actions are recorded in the audit log.</div>
    </>
  );
}
