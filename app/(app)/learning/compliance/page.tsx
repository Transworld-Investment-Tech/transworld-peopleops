import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getComplianceOverview } from "@/lib/lms-data";
import { complianceBadge, requirementBadge } from "@/lib/lms";
import ComplianceActions from "@/components/learning/ComplianceActions";

export const metadata = { title: "Training Compliance · Transworld PeopleOps" };

function fmtDue(d: Date | null): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}

export default async function TrainingCompliancePage() {
  const me = await requirePermission("learning.compliance");
  const canAct = hasPermission(me, "learning.manage");
  const canAssign = hasPermission(me, "learning.assign");
  const { summaries, gaps, asOfYear, staffCount, moduleCount } = await getComplianceOverview();

  const totalGaps = summaries.reduce((n, s) => n + s.openGaps, 0);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/learning" className="back-link">
            ← Learning &amp; Development
          </Link>
          <h1 className="serif">Training Compliance</h1>
          <p>
            Who has completed what, gaps worst-first, for the {asOfYear} period. A graded module counts
            as complete only on a pass. This is the read that feeds the staff file.
          </p>
        </div>
        {canAssign ? (
          <Link href="/learning/matrix" className="btn btn-pri">
            Training matrix
          </Link>
        ) : null}
      </div>

      <div className="kpis">
        <div className="kpi">
          <div className="lab">Active staff</div>
          <div className="val">{staffCount}</div>
        </div>
        <div className="kpi">
          <div className="lab">Modules in catalogue</div>
          <div className="val">{moduleCount}</div>
        </div>
        <div className="kpi">
          <div className="lab">Open required gaps</div>
          <div className="val">{totalGaps}</div>
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Gaps — worst first</h3>
          <span className="hint">
            {gaps.length} open required item{gaps.length === 1 ? "" : "s"}
          </span>
        </div>
        <div className="card-pad">
          {gaps.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No open required gaps for {asOfYear}. Everyone is up to date.
            </p>
          ) : (
            <div className="doc-list">
              {gaps.map((g, i) => {
                const sb = complianceBadge(g.status);
                return (
                  <div className="row" key={i} style={{ justifyContent: "space-between", alignItems: "center" }}>
                    <div>
                      <strong>{g.employeeName}</strong> <span className="faint">({g.eeId})</span>{" "}
                      — {g.moduleCode ? `${g.moduleCode} · ` : ""}
                      {g.moduleTitle} <span className={sb.cls}>{sb.label}</span>{" "}
                      <span className="faint">due {fmtDue(g.dueDate)}</span>
                    </div>
                    <span className="row" style={{ gap: 6 }}>
                      <Link href={`/learning/modules/${g.moduleId}/check`} className="btn btn-xs">
                        Open check
                      </Link>
                      {canAct && g.recordId ? <ComplianceActions recordId={g.recordId} /> : null}
                    </span>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>By person</h3>
          <span className="hint">required completion</span>
        </div>
        <div className="card-pad">
          {summaries.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No active staff.
            </p>
          ) : (
            <div className="doc-list">
              {summaries.map((s) => {
                const cls = s.openGaps === 0 ? "b b-grn" : s.pct >= 50 ? "b b-amb" : "b b-red";
                return (
                  <div className="row" key={s.employeeId} style={{ justifyContent: "space-between" }}>
                    <span>
                      <strong>{s.employeeName}</strong> <span className="faint">({s.eeId})</span>
                    </span>
                    <span className="row" style={{ gap: 10 }}>
                      <span className="faint num">
                        {s.requiredMet}/{s.requiredTotal} required
                      </span>
                      <span className={cls}>{s.pct}%</span>
                    </span>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      <p className="hint">
        <span className={requirementBadge("REQUIRED").cls}>Required</span> items are tracked here;
        recommended modules show in My Learning. Use the Training Matrix to add rules and auto-assign.
      </p>
    </>
  );
}
