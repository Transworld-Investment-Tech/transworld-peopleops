import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getAppraisalView, RATINGS } from "@/lib/performance";
import { LEVELS } from "@/lib/jobframework";
import AppraisalEditor from "@/components/performance/AppraisalEditor";

export const metadata = { title: "Appraisal · Transworld PeopleOps" };

export default async function AppraisalPage({
  params,
}: {
  params: Promise<{ cycleId: string; employeeId: string }>;
}) {
  const me = await requirePermission("performance.view");
  const canManage = hasPermission(me, "performance.manage");
  const { cycleId, employeeId } = await params;

  const view = await getAppraisalView(cycleId, employeeId);
  if (!view) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/performance?cycle=${cycleId}`} className="back-link">
            ← {view.cycle.name}
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Scorecard — {view.employee.name}
            {view.employee.role ? ` · ${view.employee.role}` : ""}
          </h1>
          <p>
            KRAs &amp; KPIs drawn from the role
            {view.employee.grade ? ` profile ${view.employee.grade}` : ""}. Recorded in
            the audit log.
          </p>
        </div>
      </div>

      {view.mission ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Role mission</h3>
          </div>
          <div className="card-pad">
            <p className="sc-mission">{view.mission}</p>
          </div>
        </div>
      ) : null}

      <AppraisalEditor
        cycleId={cycleId}
        employeeId={employeeId}
        cycleStatus={view.cycle.status}
        canManage={canManage}
        appraisal={view.appraisal}
        ratings={RATINGS.map((r) => ({ value: r.value, label: r.label }))}
        levels={LEVELS.map((l) => ({ value: l.value, label: l.label }))}
      />
    </>
  );
}
