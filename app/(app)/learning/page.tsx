import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getLibrary } from "@/lib/learning";
import LearningTabs from "@/components/learning/LearningTabs";
import LibraryBrowser from "@/components/learning/LibraryBrowser";

export const metadata = { title: "Learning & Development · Transworld PeopleOps" };

export default async function LearningPage() {
  const me = await requirePermission("learning.view");
  const canManage = hasPermission(me, "learning.manage");

  const { rows, kpis } = await getLibrary(canManage);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Learning &amp; Development</h1>
          <p>
            A self-serve library of training material and the employee handbook. Work
            through modules at your own pace; supervisors can recommend targeted modules
            off an appraisal.
          </p>
        </div>
        {canManage ? (
          <Link href="/learning/modules/new" className="btn btn-pri">
            New module
          </Link>
        ) : null}
      </div>

      <LearningTabs active="library" />

      <div className="kpis">
        <div className="kpi">
          <div className="lab">Published modules</div>
          <div className="val">{kpis.modules}</div>
        </div>
        <div className="kpi">
          <div className="lab">Completions</div>
          <div className="val">{kpis.completions}</div>
        </div>
        <div className="kpi">
          <div className="lab">In progress</div>
          <div className="val">{kpis.inProgress}</div>
        </div>
        <div className="kpi">
          <div className="lab">Overdue</div>
          <div className="val">{kpis.overdue}</div>
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Course library</h3>
          <span className="hint">{rows.length} module{rows.length === 1 ? "" : "s"}</span>
        </div>
        <div className="card-pad">
          {rows.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No modules yet.
              {canManage
                ? " Create one with “New module”, or seed the starter library with npm run learning:populate -- --commit."
                : " Check back soon."}
            </p>
          ) : (
            <LibraryBrowser rows={rows} canManage={canManage} />
          )}
        </div>
      </div>
    </>
  );
}
