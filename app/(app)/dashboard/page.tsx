import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { ROLE_LABELS } from "@/lib/permissions";
import { getDashboardData } from "@/lib/dashboard";

export const metadata = { title: "Dashboard · Transworld PeopleOps" };

const capStyle = { fontSize: 12, marginTop: 6 } as const;
const linkStyle = { display: "inline-block", marginTop: 8 } as const;

function ngn(n: number): string {
  return `₦${Math.round(n).toLocaleString("en-NG")}`;
}

// Time-of-day greeting computed in the firm's timezone (Lagos / WAT), never the
// server's — a Vercel function in us-west-2 must not greet a Lagos user by its
// own clock.
function greeting(): string {
  const hourStr = new Intl.DateTimeFormat("en-US", {
    timeZone: "Africa/Lagos",
    hour: "numeric",
    hour12: false,
  }).format(new Date());
  const h = Number.parseInt(hourStr, 10);
  if (Number.isNaN(h)) return "Welcome";
  if (h < 12) return "Good morning";
  if (h < 17) return "Good afternoon";
  return "Good evening";
}

// One decorative glyph for every quick-action row (the label carries the
// meaning; the chip is the affordance, matching the approved mock-up).
function QAItem({
  href,
  label,
  badge,
}: {
  href: string;
  label: string;
  badge?: string | null;
}) {
  return (
    <Link href={href} className="qa-item">
      <span className="qa-ico" aria-hidden="true">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.6">
          <rect x="2.5" y="2.5" width="11" height="11" rx="2.5" />
        </svg>
      </span>
      <span className="qa-label">{label}</span>
      {badge ? <span className="b b-gold">{badge}</span> : null}
      <span className="qa-chev" aria-hidden="true">›</span>
    </Link>
  );
}

export default async function DashboardPage() {
  // dashboard.view is granted to every role, so this only confirms the viewer
  // is authenticated; each tile below is gated by its own module permission
  // inside getDashboardData().
  const me = await requirePermission("dashboard.view");
  const d = await getDashboardData(me);
  const canMyPay = hasPermission(me, "compensation.view_own");

  // A "pure staff" viewer has a personal strip but no org tiles — they get the
  // welcoming, mobile-first layout (the greeting hero leads, no "Dashboard"
  // heading). Admin/HR keep the heading + the org grid, with the same personal
  // strip beneath it.
  const staffFirst = !d.hasOrgTiles && d.hasPersonal && !!d.identity;

  const myLearn = d.myLearning && d.myLearning.linked ? d.myLearning : null;
  const learnActive = myLearn ? myLearn.assigned : 0;
  const learnTotal = myLearn ? myLearn.assigned + myLearn.available : 0;
  const learnPct = learnTotal ? Math.round((learnActive / learnTotal) * 100) : 0;
  const learnDue = myLearn ? myLearn.overdue : 0;
  const handbookDue = !!(d.myHandbook && d.myHandbook.linked && d.myHandbook.published && !d.myHandbook.acknowledged);

  return (
    <>
      {staffFirst && d.identity ? (
        <div className="dash-hero">
          <div className="dash-hero-eyebrow">Transworld PeopleOps</div>
          <h1 className="serif dash-hero-greet">
            {greeting()}, {d.identity.firstName}
          </h1>
          <div className="dash-hero-sub">
            {d.identity.title ?? "Team member"}
            {d.identity.grade ? ` · ${d.identity.grade}` : ""}
          </div>
        </div>
      ) : (
        <div className="page-h">
          <div>
            <h1 className="serif">Dashboard</h1>
            <p>
              Signed in to the Transworld PeopleOps control room as {d.viewerName}. You see only the
              posture for areas your access already covers.
            </p>
          </div>
          {d.roleKeys.length ? (
            <div className="chips">
              {d.roleKeys.map((r) => (
                <span key={r} className="b b-blu">
                  {ROLE_LABELS[r] ?? r}
                </span>
              ))}
            </div>
          ) : null}
        </div>
      )}

      {/* ---------------------------------------------------------------- */}
      {/* Organization posture (each tile gated by its module permission)   */}
      {/* ---------------------------------------------------------------- */}
      {d.hasOrgTiles ? (
        <>
          <div className="sec-t">Organization</div>
          <div className="grid kpis">
            {d.roster ? (
              <div className="card kpi">
                <div className="lab">Headcount</div>
                <div className="val">{d.roster.nonExited}</div>
                <div className="faint" style={capStyle}>
                  {d.roster.active} active · {d.roster.probation} probation
                  {d.roster.onLeave ? ` · ${d.roster.onLeave} on leave` : ""}
                  {d.roster.suspended ? ` · ${d.roster.suspended} suspended` : ""}
                </div>
                <Link href="/employees" className="jc-link" style={linkStyle}>
                  Employees →
                </Link>
              </div>
            ) : null}

            {d.logins ? (
              <div className="card kpi">
                <div className="lab">Active logins</div>
                <div className="val">{d.logins.active}</div>
                <div className="faint" style={capStyle}>
                  {d.logins.accounts} account{d.logins.accounts === 1 ? "" : "s"} ·{" "}
                  {d.logins.awaiting} awaiting a login
                </div>
                <Link href="/admin/users" className="jc-link" style={linkStyle}>
                  User management →
                </Link>
              </div>
            ) : null}

            {d.comp ? (
              <div className="card kpi">
                <div className="lab">Pending comp approvals</div>
                <div className="val">{d.comp.pending}</div>
                <div className="faint" style={capStyle}>
                  compensation change request{d.comp.pending === 1 ? "" : "s"} awaiting sign-off
                </div>
                <Link href="/compensation" className="jc-link" style={linkStyle}>
                  Compensation →
                </Link>
              </div>
            ) : null}

            {d.orgLeave ? (
              <div className="card kpi">
                <div className="lab">Pending leave</div>
                <div className="val">{d.orgLeave.pending}</div>
                <div className="faint" style={capStyle}>
                  {d.orgLeave.onLeaveThisWeek} on leave this week
                  {d.orgLeave.onLeaveName ? ` · ${d.orgLeave.onLeaveName}` : ""} · avg{" "}
                  {d.orgLeave.avgAnnualRemaining} days left
                </div>
                <Link href="/leave" className="jc-link" style={linkStyle}>
                  Leave →
                </Link>
              </div>
            ) : null}

            {d.learning ? (
              <div className="card kpi">
                <div className="lab">Learning completions</div>
                <div className="val">{d.learning.completions}</div>
                <div className="faint" style={capStyle}>
                  {d.learning.modules} module{d.learning.modules === 1 ? "" : "s"} ·{" "}
                  {d.learning.inProgress} in progress
                  {d.learning.overdue ? ` · ${d.learning.overdue} overdue` : ""}
                  {" · handbook "}
                  {d.learning.handbook.published
                    ? `${d.learning.handbook.acknowledged}/${d.learning.handbook.total} acknowledged`
                    : "not published"}
                </div>
                <Link href="/learning" className="jc-link" style={linkStyle}>
                  Learning →
                </Link>
              </div>
            ) : null}

            {d.payroll ? (
              <div className="card kpi">
                <div className="lab">Latest payroll cycle</div>
                <div className="val" style={{ fontSize: 22 }}>
                  {d.payroll.label ?? "—"}
                </div>
                <div className="faint" style={capStyle}>
                  {d.payroll.status ? `${d.payroll.status.toLowerCase()} · ` : ""}
                  {d.payroll.itemCount} item{d.payroll.itemCount === 1 ? "" : "s"}
                  {d.payroll.totalPayable != null ? ` · ${ngn(d.payroll.totalPayable)} payable` : ""}
                  {d.payroll.hasOpenCycle ? " · open cycle" : ""}
                </div>
                <Link href="/payroll" className="jc-link" style={linkStyle}>
                  Payroll →
                </Link>
              </div>
            ) : null}

            {d.bonus ? (
              <div className="card kpi">
                <div className="lab">Bonus</div>
                <div className="val" style={{ fontSize: 22 }}>
                  {d.bonus.roundLabel ?? "No round yet"}
                </div>
                <div className="faint" style={capStyle}>
                  {d.bonus.roundStatus ? `${d.bonus.roundStatus.toLowerCase()}` : "—"}
                  {d.bonus.hasOpenRound ? " · open round" : ""}
                  {` · ${ngn(d.bonus.deferralsDue)} deferred due ${d.bonus.focusYear}`}
                </div>
                <Link href="/bonus" className="jc-link" style={linkStyle}>
                  Bonus →
                </Link>
              </div>
            ) : null}

            {d.sponsorship ? (
              <div className="card kpi">
                <div className="lab">Sponsorship exposure</div>
                <div className="val" style={{ fontSize: 22 }}>
                  {ngn(d.sponsorship.exposure)}
                </div>
                <div className="faint" style={capStyle}>
                  {d.sponsorship.activeCount} active · {ngn(d.sponsorship.committed)} committed
                </div>
                <Link href="/compensation/sponsorship" className="jc-link" style={linkStyle}>
                  Sponsorship →
                </Link>
              </div>
            ) : null}

            {d.compaFlags ? (
              <div className="card kpi">
                <div className="lab">Compa-ratio flags</div>
                <div className="val">{d.compaFlags.prioritize + d.compaFlags.belowMin}</div>
                <div className="faint" style={capStyle}>
                  {d.compaFlags.prioritize} below {d.compaFlags.threshold} compa ·{" "}
                  {d.compaFlags.belowMin} below minimum
                </div>
                <Link href="/compensation/positioning" className="jc-link" style={linkStyle}>
                  Positioning →
                </Link>
              </div>
            ) : null}

            {d.appraisalCycle ? (
              <div className="card kpi">
                <div className="lab">Appraisal cycle</div>
                <div className="val">
                  {d.appraisalCycle.total ? `${d.appraisalCycle.pct}%` : "—"}
                </div>
                <div className="faint" style={capStyle}>
                  {d.appraisalCycle.cycleName
                    ? `${d.appraisalCycle.cycleName} · ${d.appraisalCycle.finalized}/${d.appraisalCycle.total} finalized`
                    : "no cycle yet"}
                </div>
                <Link href="/performance" className="jc-link" style={linkStyle}>
                  Performance →
                </Link>
              </div>
            ) : null}
          </div>
        </>
      ) : null}

      {/* ---------------------------------------------------------------- */}
      {/* Your space — the personal-first layout (greeting hero above when   */}
      {/* the viewer is pure staff). Heroes + stat row + quick actions.      */}
      {/* ---------------------------------------------------------------- */}
      {d.hasPersonal ? (
        <>
          {d.hasOrgTiles ? <div className="sec-t mt">Your space</div> : null}

          {d.myLeave && d.myLeave.linked ? (
            <Link href="/leave" className="leave-hero">
              <div className="leave-hero-lab">Annual leave left</div>
              <div className="leave-hero-val">
                {d.myLeave.annualRemaining ?? "—"} <span>days</span>
              </div>
              <div className="leave-hero-sub">
                {d.myLeave.pending
                  ? `${d.myLeave.pending} pending request${d.myLeave.pending === 1 ? "" : "s"}`
                  : "No pending requests"}
              </div>
            </Link>
          ) : null}

          {d.myPayslip || myLearn ? (
            <div className="dash-stats">
              {d.myPayslip ? (
                <Link href="/payslips" className="dash-stat">
                  <div className="lab">Latest payslip</div>
                  <div className="val mono">{ngn(d.myPayslip.net)}</div>
                  <div className="faint dash-stat-sub">{d.myPayslip.label} · net</div>
                </Link>
              ) : null}

              {myLearn ? (
                <Link href="/learning/my" className="dash-stat">
                  <div className="lab">My learning</div>
                  <div className="val">
                    {learnActive} <span className="faint">/ {learnTotal}</span>
                  </div>
                  <div className="lp-bar" aria-hidden="true">
                    <span style={{ width: `${learnPct}%` }} />
                  </div>
                </Link>
              ) : null}
            </div>
          ) : null}

          {d.hasPersonal ? (
            <div className="qa-list">
              <QAItem href="/payslips" label="My payslips" />
              {canMyPay ? <QAItem href="/my-pay" label="My pay" /> : null}
              <QAItem href="/learning/my" label="My learning" badge={learnDue ? `${learnDue} due` : null} />
              <QAItem href="/leave/request" label="Request leave" />
              <QAItem
                href="/learning/handbook"
                label="Employee handbook"
                badge={handbookDue ? "Action needed" : null}
              />
            </div>
          ) : null}

          {d.myLeave && !d.myLeave.linked ? (
            <div className="note">
              <span>ℹ</span>
              <div>Your login isn&rsquo;t linked to an employee record yet.</div>
            </div>
          ) : null}
        </>
      ) : null}

      {!d.hasOrgTiles && !d.hasPersonal ? (
        <div className="note">
          <span>ℹ</span>
          <div>
            You&rsquo;re signed in. There&rsquo;s nothing to surface here for your current access —
            use the sidebar to reach the areas you can view.
          </div>
        </div>
      ) : null}
    </>
  );
}
