import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getWhistleblowerReport } from "@/lib/whistleblower";
import { wbStatusLabel, wbCategoryLabel, routeLabel, statusBadgeClass } from "@/lib/ws5";
import {
  AssignHandlerForm,
  WbInvestigationForm,
  WbOutcomeForm,
  AcknowledgeReporterForm,
} from "@/components/whistleblower/WhistleblowerControls";

export const metadata = { title: "Whistleblower report · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function WhistleblowerDetail({ params }: { params: Promise<{ reportId: string }> }) {
  const me = await requirePermission("whistleblower.access");
  const { reportId } = await params;
  const r = await getWhistleblowerReport(reportId);
  // Restricted: senior-management reports are visible only to whistleblower.exec.
  if (!r || (r.involvesSeniorManagement && !hasPermission(me, "whistleblower.exec"))) notFound();
  const closed = r.status === "CLOSED";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/whistleblower" className="back-link">← Whistleblower</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>{r.caseRef}</h1>
          <p>
            <span className={"b " + statusBadgeClass(r.status)}>{wbStatusLabel(r.status)}</span>
            {" · "}{wbCategoryLabel(r.category)}
            {" · "}{r.involvesSeniorManagement ? <span className="b b-red">{routeLabel(r.route)}</span> : routeLabel(r.route)}
          </p>
        </div>
      </div>

      <div className="grid two-col">
        <div className="card">
          <div className="card-h"><h3>Disclosure</h3></div>
          <div className="card-pad">
            <p style={{ marginTop: 0 }}>{r.summary}</p>
            <div className="kv">
              <div className="row"><span className="k">Reporter</span><span className="v">{r.isAnonymous ? "Anonymous" : r.reporterName ?? "—"}</span></div>
              <div className="row"><span className="k">Received</span><span className="v">{fmtDate(r.receivedAt)}</span></div>
              <div className="row"><span className="k">Handler</span><span className="v">{r.handlerName ?? "—"}</span></div>
              <div className="row"><span className="k">Acknowledged</span><span className="v">{r.isAnonymous ? "—" : fmtDate(r.acknowledgedAt)}</span></div>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card-h"><h3>Investigation &amp; outcome</h3></div>
          <div className="card-pad">
            {r.investigationSummary ? <p className="faint" style={{ marginTop: 0 }}>{r.investigationSummary}</p> : null}
            {r.outcome ? <div className="kv"><div className="row"><span className="k">Outcome</span><span className="v">{r.outcome}</span></div></div> : null}
            {r.actionTaken ? <div className="kv"><div className="row"><span className="k">Action taken</span><span className="v">{r.actionTaken}</span></div></div> : null}
            {!r.investigationSummary && !r.outcome ? <span className="faint">No investigation recorded yet.</span> : null}
          </div>
        </div>
      </div>

      {!closed ? (
        <div className="card mt">
          <div className="card-h"><h3>Handle</h3></div>
          <div className="card-pad">
            <div style={{ display: "flex", gap: 12, alignItems: "center", marginBottom: 14 }}>
              <AssignHandlerForm id={r.id} />
              <AcknowledgeReporterForm id={r.id} anonymous={r.isAnonymous} />
            </div>
            <div className="sec-t">Investigation</div>
            <WbInvestigationForm id={r.id} current={r.investigationSummary} />
            <div style={{ height: 14 }} />
            <div className="sec-t">Outcome</div>
            <WbOutcomeForm id={r.id} />
          </div>
        </div>
      ) : null}

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        Restricted. Anonymous reporters are never identified. Retaliation is a disciplinary matter of the highest severity.
      </div>
    </>
  );
}
