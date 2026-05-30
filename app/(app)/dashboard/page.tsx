import { requirePermission } from "@/lib/auth/rbac";
import { countVisibleModules, ROLE_LABELS } from "@/lib/permissions";

export const metadata = { title: "Dashboard · Transworld PeopleOps" };

export default async function DashboardPage() {
  const me = await requirePermission("dashboard.view");
  const modules = countVisibleModules(me.permissions);

  return (
    <>
      <div className="page-h">
        <div>
          <h1>Dashboard</h1>
          <p>Signed in to the Transworld PeopleOps control room.</p>
        </div>
      </div>

      <div className="note">
        <span>✓</span>
        <div>
          <b>Authenticated.</b> Access control is enforced on the server for
          every module, and your sign-in was written to the audit log. The full
          executive dashboard (headcount, total payable, approvals, compliance
          posture) arrives in a later build.
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Signed in as</div>
          <div className="val" style={{ fontSize: 17 }}>
            {me.name}
          </div>
        </div>
        <div className="card kpi">
          <div className="lab">Roles</div>
          <div className="val">{me.roleKeys.length}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Permissions</div>
          <div className="val">{me.permissions.size}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Modules visible</div>
          <div className="val">{modules}</div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Your access</h3>
          <span className="hint">From roles and permissions in the database</span>
        </div>
        <div className="card-pad">
          <div className="sec-t">Roles</div>
          <div className="chips">
            {me.roleKeys.length ? (
              me.roleKeys.map((r) => (
                <span key={r} className="b b-blu">
                  {ROLE_LABELS[r] ?? r}
                </span>
              ))
            ) : (
              <span className="b b-gry">No role assigned</span>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
