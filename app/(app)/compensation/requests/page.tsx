import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getCompChangeRequests,
  getPendingRequestCount,
  fmtNaira,
  requestStatusBadge,
  treatmentBadge,
  type ChangeRequestRow,
  type CompFields as CompFieldsData,
} from "@/lib/compensation";
import CompTabs from "@/components/compensation/CompTabs";
import CompChangeReview from "@/components/compensation/CompChangeReview";
import CompRequestCancel from "@/components/compensation/CompRequestCancel";

export const metadata = { title: "Compensation changes · Transworld PeopleOps" };

const CHIPS: { value: string; label: string }[] = [
  { value: "PENDING", label: "Pending" },
  { value: "APPROVED", label: "Approved" },
  { value: "REJECTED", label: "Rejected" },
  { value: "ALL", label: "All" },
];

function fmtDate(d: Date): string {
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

function Delta({ current, proposed }: { current: CompFieldsData | null; proposed: CompFieldsData }) {
  function row(label: string, from: string, to: string, changed: boolean) {
    return (
      <div className={"comp-delta-row" + (changed ? " changed" : "")}>
        <span className="comp-delta-lab">{label}</span>
        <span className="comp-delta-from mono">{from}</span>
        <span className="comp-delta-arrow">→</span>
        <span className="comp-delta-to mono">{to}</span>
      </div>
    );
  }
  const ct = current ? treatmentBadge(current.taxTreatment).label : "—";
  const pt = treatmentBadge(proposed.taxTreatment).label;
  return (
    <div className="comp-delta">
      {row("Basic", current ? fmtNaira(current.basicSalary) : "—", fmtNaira(proposed.basicSalary), !current || current.basicSalary !== proposed.basicSalary)}
      {row("Utility", current ? fmtNaira(current.utilityAllowance) : "—", fmtNaira(proposed.utilityAllowance), !current || current.utilityAllowance !== proposed.utilityAllowance)}
      {row("Quarterly", current ? fmtNaira(current.quarterlyAllowance) : "—", fmtNaira(proposed.quarterlyAllowance), !current || current.quarterlyAllowance !== proposed.quarterlyAllowance)}
      {row("Tax", ct, pt, !current || current.taxTreatment !== proposed.taxTreatment)}
    </div>
  );
}

export default async function CompChangeRequestsPage({
  searchParams,
}: {
  searchParams: Promise<{ status?: string }>;
}) {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");
  const canApprove = hasPermission(me, "compensation.approve");
  const { status: statusParam } = await searchParams;
  const status = statusParam && CHIPS.some((c) => c.value === statusParam) ? statusParam : "PENDING";

  const [requests, pendingCount] = await Promise.all([
    getCompChangeRequests(status),
    getPendingRequestCount(),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Change requests</h1>
          <p>Proposed compensation changes and their exec sign-off trail.</p>
        </div>
      </div>

      <CompTabs active="requests" pendingCount={pendingCount} />

      <div className="cyc-tabs" style={{ marginBottom: 16 }}>
        {CHIPS.map((c) => (
          <Link
            key={c.value}
            href={`/compensation/requests?status=${c.value}`}
            className={"cyc-tab" + (c.value === status ? " active" : "")}
          >
            {c.label}
          </Link>
        ))}
      </div>

      {requests.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>No requests with this status.</div>
            </div>
          </div>
        </div>
      ) : (
        requests.map((r: ChangeRequestRow) => {
          const sb = requestStatusBadge(r.status);
          return (
            <div className="card mt" key={r.id}>
              <div className="card-h">
                <h3>
                  <Link href={`/compensation/${r.employee.id}`} className="jc-link">
                    {r.employee.name}
                  </Link>{" "}
                  <span className="faint mono">{r.employee.eeId}</span>
                </h3>
                <span className={`b ${sb.cls}`}>{sb.label}</span>
              </div>
              <div className="card-pad">
                <p className="faint" style={{ marginTop: 0 }}>
                  Raised {fmtDate(r.requestedAt)}
                  {r.requestedBy ? ` by ${r.requestedBy}` : ""} · effective {fmtDate(r.effectiveDate)}
                  {r.status !== "PENDING" && r.decidedAt
                    ? ` · ${sb.label.toLowerCase()} ${fmtDate(r.decidedAt)}${r.decidedBy ? ` by ${r.decidedBy}` : ""}`
                    : ""}
                  {r.selfApproved ? " · self-approved" : ""}
                </p>
                {r.reason ? <p>{r.reason}</p> : null}

                <Delta current={r.current} proposed={r.proposed} />

                {r.decisionNote ? (
                  <p className="faint" style={{ marginTop: 12 }}>
                    Decision note: {r.decisionNote}
                  </p>
                ) : null}

                {r.status === "PENDING" && canApprove ? (
                  <div style={{ marginTop: 16 }}>
                    <CompChangeReview requestId={r.id} selfApproval={r.requestedById === me.id} />
                  </div>
                ) : null}

                {r.status === "PENDING" && canManage ? (
                  <div style={{ marginTop: 12 }}>
                    <CompRequestCancel requestId={r.id} />
                  </div>
                ) : null}
              </div>
            </div>
          );
        })
      )}
    </>
  );
}
