import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { fmtNaira } from "@/lib/compensation";
import { getSponsorshipDetail } from "@/lib/sponsorship-reads";
import {
  sponsorshipStatusBadge,
  exposurePhaseLabel,
  bondingBasisLabel,
  costTypeLabel,
  fmtDate,
} from "@/lib/sponsorship";
import CompTabs from "@/components/compensation/CompTabs";
import SponsorshipActions from "@/components/compensation/SponsorshipActions";
import SponsorshipCosts from "@/components/compensation/SponsorshipCosts";
import SponsorshipAttempts from "@/components/compensation/SponsorshipAttempts";

export const metadata = { title: "Sponsorship detail · Transworld PeopleOps" };

export default async function SponsorshipDetailPage({
  params,
}: {
  params: Promise<{ sponsorshipId: string }>;
}) {
  const { sponsorshipId } = await params;
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");
  const canApprove = hasPermission(me, "compensation.approve");

  const s = await getSponsorshipDetail(sponsorshipId);
  if (!s) notFound();

  const badge = sponsorshipStatusBadge(s.status);
  const exp = s.exposure;
  const locked = s.status === "WITHDRAWN";

  const bondingText = s.bondingWaived
    ? "Waived — no service commitment"
    : s.bondingMonths
      ? `${s.bondingMonths} months, starting ${bondingBasisLabel(s.bondingStartBasis)}`
      : "None set";

  const windowText =
    exp.windowStart && exp.windowEnd
      ? `${fmtDate(exp.windowStart)} – ${fmtDate(exp.windowEnd)}`
      : exp.phase === "IN_STUDY"
        ? "Not started"
        : "—";

  const costRows = s.costs.map((c) => ({
    id: c.id,
    typeLabel: costTypeLabel(c.costType),
    description: c.description,
    amountText: fmtNaira(c.amount),
    incurredText: fmtDate(c.incurredDate),
    paid: c.paid,
    waived: c.waived,
  }));

  const attemptRows = s.attempts.map((a) => ({
    id: a.id,
    levelLabel: a.levelLabel,
    attemptNumber: a.attemptNumber,
    sittingText: fmtDate(a.sittingDate),
    outcome: a.outcome,
    score: a.score,
  }));

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{s.qualificationName}</h1>
          <p>
            <Link href={`/compensation/${s.employeeId}`} className="jc-link">{s.employeeName}</Link>
            {" · "}
            <span className="mono">{s.eeId}</span>
            {s.awardingBody ? ` · ${s.awardingBody}` : ""}
          </p>
        </div>
        <Link href="/compensation/sponsorship" className="btn">← Sponsorship</Link>
      </div>

      <CompTabs active="sponsorship" />

      {/* Status + lifecycle */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Status</h3>
          <span className={`b ${badge.cls}`}>{badge.label}</span>
        </div>
        <div className="card-pad">
          <SponsorshipActions
            id={s.id}
            status={s.status}
            canManage={canManage}
            canApprove={canApprove}
            selfProposed={s.proposedById !== null && s.proposedById === me.id}
          />
          <p className="faint" style={{ marginTop: 12, marginBottom: 0 }}>
            Proposed {fmtDate(s.proposedAt)}
            {s.approvedAt ? ` · approved ${fmtDate(s.approvedAt)}` : ""}
            {s.startedAt ? ` · started ${fmtDate(s.startedAt)}` : ""}
            {s.completedAt ? ` · completed ${fmtDate(s.completedAt)}` : ""}
            {s.withdrawnAt ? ` · withdrawn ${fmtDate(s.withdrawnAt)}` : ""}
          </p>
          {s.note ? <p style={{ marginBottom: 0 }}>{s.note}</p> : null}
        </div>
      </div>

      {/* Live exposure */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Repayment exposure</h3>
          <span className="hint">derived live</span>
        </div>
        <div className="card-pad">
          <div className="grid kpis">
            <div className="kpi"><div className="lab">Committed cost</div><div className="val mono">{fmtNaira(exp.committed)}</div></div>
            <div className="kpi"><div className="lab">Outstanding exposure</div><div className="val mono">{fmtNaira(exp.exposure)}</div></div>
            <div className="kpi"><div className="lab">Phase</div><div className="val">{exposurePhaseLabel(exp.phase)}</div></div>
            <div className="kpi"><div className="lab">Bond served</div><div className="val">{exp.windowStart ? `${Math.round(exp.servedFraction * 100)}%` : "—"}</div></div>
          </div>
          <p className="hint" style={{ marginTop: 10 }}>
            Service commitment: <b>{bondingText}</b>. Bonding window: {windowText}.{" "}
            {s.bondingWaived || !s.bondingMonths
              ? "No repayment is owed on an early exit."
              : s.status === "COMPLETED"
                ? "Exposure pro-rates to zero across the bonding window; a leaver before it ends repays the outstanding amount."
                : "Until the qualification is completed the clawback clock has not started — a mid-study departure is a COO-review case, resolved manually, not auto-clawed."}
          </p>
        </div>
      </div>

      {/* Links */}
      {s.learningModuleTitle || s.agreementDocumentTitle ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-pad">
            {s.learningModuleTitle ? (
              <p style={{ margin: 0 }}>
                Linked L&amp;D module:{" "}
                <Link href={`/learning/modules/${s.learningModuleId}`} className="jc-link">
                  {s.learningModuleTitle}
                </Link>
              </p>
            ) : null}
            {s.agreementDocumentTitle ? (
              <p style={{ marginBottom: 0 }}>Sponsorship agreement on file: {s.agreementDocumentTitle}</p>
            ) : null}
          </div>
        </div>
      ) : null}

      {/* Funded costs */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h"><h3 className="serif">Funded costs</h3></div>
        <div className="card-pad">
          <SponsorshipCosts sponsorshipId={s.id} costs={costRows} canManage={canManage} locked={locked} />
        </div>
      </div>

      {/* Exam attempts */}
      <div className="card">
        <div className="card-h"><h3 className="serif">Exam attempts</h3></div>
        <div className="card-pad">
          <SponsorshipAttempts sponsorshipId={s.id} attempts={attemptRows} canManage={canManage} locked={locked} />
        </div>
      </div>
    </>
  );
}
