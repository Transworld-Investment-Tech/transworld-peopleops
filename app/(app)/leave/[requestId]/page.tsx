import Link from "next/link";
import { redirect } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getLeaveRequestDetail, statusBadge, managerStatusBadge, fmtDays } from "@/lib/leave";
import LeaveEditForm from "@/components/leave/LeaveEditForm";
import LeaveManagerReview from "@/components/leave/LeaveManagerReview";
import LeaveDecision from "@/components/leave/LeaveDecision";
import LeaveCancel from "@/components/leave/LeaveCancel";

export const metadata = { title: "Leave request · Transworld PeopleOps" };

function fmtFull(d: Date): string {
  return d.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric", year: "numeric" });
}
function fmtAt(d: Date): string {
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

export default async function LeaveRequestDetailPage({
  params,
}: {
  params: Promise<{ requestId: string }>;
}) {
  const me = await requirePermission("leave.view");
  const { requestId } = await params;
  const result = await getLeaveRequestDetail(me, requestId);

  if (!result) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">Leave request</h1>
          </div>
          <Link href="/leave" className="btn">
            Back to Leave
          </Link>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>That request no longer exists.</div>
            </div>
          </div>
        </div>
      </>
    );
  }
  if (!result.allowed) redirect("/access-denied");

  const { detail } = result;
  const r = detail.row;
  const sb = statusBadge(r.status);
  const mb = managerStatusBadge(r.managerStatus);
  const single = r.startDate.getTime() === r.endDate.getTime();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{r.employeeName}</h1>
          <p>
            {r.typeName} · <span className="faint mono">{r.eeId}</span>
          </p>
        </div>
        <Link href="/leave" className="btn">
          Back to Leave
        </Link>
      </div>

      {/* Summary --------------------------------------------------------- */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Request</h3>
          <span className={`b ${sb.cls}`}>{sb.label}</span>
        </div>
        <div className="card-pad">
          <div className="grid kpis">
            <div className="kpi">
              <div className="lab">Leave type</div>
              <div className="val" style={{ fontSize: 20 }}>
                {r.typeName}
              </div>
            </div>
            <div className="kpi">
              <div className="lab">Days requested</div>
              <div className="val">
                {fmtDays(r.days)} <span className="faint">day{r.days === 1 ? "" : "s"}</span>
              </div>
              {detail.isHalf ? <div className="delta">half day</div> : null}
            </div>
            <div className="kpi">
              <div className="lab">{single ? "Date" : "From"}</div>
              <div className="val" style={{ fontSize: 18 }}>
                {fmtFull(r.startDate)}
              </div>
              {!single ? <div className="delta">to {fmtFull(r.endDate)}</div> : detail.isHalf ? <div className="delta">half day</div> : null}
            </div>
          </div>

          <p className="faint" style={{ marginBottom: 0, marginTop: 14 }}>
            Requested {fmtAt(r.createdAt)}
            {r.needsManager ? "" : " · no line manager — goes straight to HR"}
            {detail.balanceForType
              ? ` · ${r.typeName} balance: ${fmtDays(detail.balanceForType.remaining)} of ${fmtDays(
                  detail.balanceForType.entitled
                )} remaining`
              : ""}
          </p>
          {r.note ? (
            <p style={{ marginBottom: 0, marginTop: 8 }}>
              <span className="faint">Reason: </span>
              {r.note}
            </p>
          ) : null}
        </div>
      </div>

      {/* Review / decision trail ----------------------------------------- */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Approval trail</h3>
        </div>
        <div className="card-pad">
          <p style={{ marginTop: 0 }}>
            <span className="faint">Line manager: </span>
            {r.needsManager ? (
              <>
                <span className={`b ${mb.cls}`}>{mb.label}</span>
                {r.managerReviewer ? ` · ${r.managerReviewer}` : ""}
                {r.managerReviewedAt ? ` · ${fmtAt(r.managerReviewedAt)}` : ""}
                {r.managerNote ? ` · “${r.managerNote}”` : ""}
              </>
            ) : (
              <span className="faint">not required (no line manager)</span>
            )}
          </p>
          <p style={{ marginBottom: 0 }}>
            <span className="faint">HR decision: </span>
            {r.status === "PENDING" ? (
              <span className="faint">pending</span>
            ) : (
              <>
                <span className={`b ${sb.cls}`}>{sb.label}</span>
                {r.approver ? ` · ${r.approver}` : ""}
                {r.decidedAt ? ` · ${fmtAt(r.decidedAt)}` : ""}
                {r.selfApproval ? " · self-approved" : ""}
                {r.decisionNote ? ` · “${r.decisionNote}”` : ""}
              </>
            )}
          </p>
        </div>
      </div>

      {/* Modify ---------------------------------------------------------- */}
      {r.canEdit ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Modify request</h3>
            <span className="hint">while pending</span>
          </div>
          <div className="card-pad">
            <LeaveEditForm
              requestId={r.id}
              types={detail.typeOptions}
              defaultTypeId={r.leaveTypeId}
              startInput={detail.startInput}
              endInput={detail.endInput}
              isHalf={detail.isHalf}
              defaultNote={r.note}
              reviewWillReset={r.needsManager && r.managerStatus !== "PENDING"}
            />
          </div>
        </div>
      ) : null}

      {/* Action ---------------------------------------------------------- */}
      {r.canReviewAsManager || r.canDecide || r.awaitingManager || r.canCancel ? (
        <div className="card">
          <div className="card-h">
            <h3>
              {r.canReviewAsManager
                ? "Your review"
                : r.canDecide
                ? "Your decision"
                : "Actions"}
            </h3>
          </div>
          <div className="card-pad">
            {r.canReviewAsManager ? <LeaveManagerReview requestId={r.id} /> : null}
            {r.canDecide ? <LeaveDecision requestId={r.id} selfApproval={r.selfApproval} /> : null}
            {r.awaitingManager ? (
              <p className="hint" style={{ marginTop: 0 }}>
                Waiting on {r.firstName}’s line manager to review before you can decide.
              </p>
            ) : null}
            {r.canCancel ? (
              <div style={{ marginTop: r.canReviewAsManager || r.canDecide ? 14 : 0 }}>
                <LeaveCancel requestId={r.id} />
              </div>
            ) : null}
          </div>
        </div>
      ) : null}
    </>
  );
}
