import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getGrievance } from "@/lib/grievances";
import { grievanceStatusLabel, grievanceFindingLabel, statusBadgeClass } from "@/lib/ws5";
import { AcknowledgeForm, FindingForm, AppealForm, CloseGrievanceForm } from "@/components/grievances/GrievanceControls";

export const metadata = { title: "Grievance · Transworld PeopleOps" };

function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function GrievanceDetail({ params }: { params: Promise<{ grievanceId: string }> }) {
  const me = await requirePermission("grievance.manage");
  const { grievanceId } = await params;
  const g = await getGrievance(grievanceId);
  if (!g) notFound();
  const canAppeal = hasPermission(me, "grievance.approve");
  const closed = g.status === "CLOSED";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/grievances" className="back-link">← Grievances</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>{g.subject}</h1>
          <p>
            Raised by <b>{g.complainantName}</b>
            {g.respondentName ? <> · named: {g.respondentName}</> : null}
            {" · "}<span className={"b " + statusBadgeClass(g.status)}>{grievanceStatusLabel(g.status)}</span>
          </p>
        </div>
      </div>

      <div className="grid two-col">
        <div className="card">
          <div className="card-h"><h3>Grievance</h3></div>
          <div className="card-pad">
            <p style={{ marginTop: 0 }}>{g.details}</p>
            <div className="kv">
              <div className="row"><span className="k">Received</span><span className="v">{fmtDate(g.createdAt)}</span></div>
              <div className="row"><span className="k">Acknowledged</span><span className="v">{fmtDate(g.acknowledgedAt)}</span></div>
              <div className="row"><span className="k">Finding target</span><span className="v">{fmtDate(g.targetDate)}</span></div>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card-h"><h3>Finding</h3></div>
          <div className="card-pad">
            {g.finding ? (
              <div className="kv">
                <div className="row"><span className="k">Outcome</span><span className="v">{grievanceFindingLabel(g.finding)}</span></div>
                <div className="row"><span className="k">Investigator</span><span className="v">{g.investigatorName ?? "—"}</span></div>
                <div className="row"><span className="k">Communicated</span><span className="v">{fmtDate(g.communicatedAt)}</span></div>
                <div className="row"><span className="k">Summary</span><span className="v">{g.findingSummary}</span></div>
                {g.recommendedAction ? <div className="row"><span className="k">Action</span><span className="v">{g.recommendedAction}</span></div> : null}
              </div>
            ) : <span className="faint">No finding recorded yet.</span>}
            {g.appealOutcome ? (
              <div className="note" style={{ marginTop: 12 }}><span>⚖</span><div><b>Appeal ({fmtDate(g.appealAt)}, {g.appealHeardByName}):</b> {g.appealOutcome}</div></div>
            ) : null}
          </div>
        </div>
      </div>

      {!closed ? (
        <div className="card mt">
          <div className="card-h"><h3>Actions</h3></div>
          <div className="card-pad">
            {g.status === "RECEIVED" ? (<><AcknowledgeForm id={g.id} /><div style={{ height: 14 }} /></>) : null}
            {!g.finding ? (<><div className="sec-t">Record finding</div><FindingForm id={g.id} /><div style={{ height: 14 }} /></>) : null}
            {canAppeal && g.finding ? (<><div className="sec-t">Appeal</div><AppealForm id={g.id} /><div style={{ height: 14 }} /></>) : null}
            <CloseGrievanceForm id={g.id} />
          </div>
        </div>
      ) : null}

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        Confidential. The named person is given a chance to respond but never sees this record or any witness identities.
      </div>
    </>
  );
}
