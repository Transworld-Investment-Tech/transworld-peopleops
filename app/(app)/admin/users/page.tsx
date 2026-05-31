import { requirePermission } from "@/lib/auth/rbac";
import {
  getUsersForList,
  getUnlinkedEmployees,
  getRoleOptions,
  userStatusBadge,
} from "@/lib/admin-users";
import UserCreateForm from "@/components/admin/UserCreateForm";
import UserAdminControls from "@/components/admin/UserAdminControls";

export const metadata = { title: "User Management · Transworld PeopleOps" };

export default async function UserManagementPage() {
  const me = await requirePermission("admin.users");
  const canAssignRoles = me.roleKeys.includes("SUPER_ADMIN");

  const [users, unlinked, roleOptions] = await Promise.all([
    getUsersForList(),
    getUnlinkedEmployees(),
    getRoleOptions(),
  ]);

  const totalLogins = users.length;
  const linkedToStaff = users.filter((u) => u.employee).length;
  const activeLogins = users.filter((u) => u.status === "active").length;

  const employeeOptions = unlinked.map((e) => ({
    id: e.id,
    label: `${e.fullName} · ${e.eeId}`,
    email: e.workEmail ?? "",
  }));

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">User Management</h1>
          <p>
            Create login accounts for staff, link each to its employee record,
            and manage roles and access. New accounts start with the
            <b> Employee</b> role and the shared initial password.
          </p>
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Login accounts</div>
          <div className="val">{totalLogins}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Active</div>
          <div className="val">{activeLogins}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Linked to staff</div>
          <div className="val">{linkedToStaff}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Staff awaiting a login</div>
          <div className="val">{unlinked.length}</div>
        </div>
      </div>

      {employeeOptions.length > 0 && (
        <div className="card mt">
          <div className="card-h">
            <h3>Provision a login</h3>
            <span className="hint">
              For the one-time bulk backfill, use the{" "}
              <span className="mono">users:populate</span> script. Use this for
              new hires or anyone added since.
            </span>
          </div>
          <div className="card-pad">
            <UserCreateForm employees={employeeOptions} />
          </div>
        </div>
      )}

      <div className="card mt">
        <div className="card-h">
          <h3>Login accounts</h3>
          {!canAssignRoles && (
            <span className="hint">
              Role changes require Super Admin. You can create, link, reset, and
              enable/disable accounts.
            </span>
          )}
        </div>
        <table>
          <thead>
            <tr>
              <th>User</th>
              <th>Linked employee</th>
              <th>Roles</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((u) => {
              const sb = userStatusBadge(u.status);
              return (
                <tr key={u.id}>
                  <td>
                    <span className="nm">{u.name}</span>
                    <span className="rl mono">{u.email}</span>
                    {u.id === me.id && (
                      <span className="faint" style={{ fontSize: 11.5 }}> (you)</span>
                    )}
                  </td>
                  <td>
                    {u.employee ? (
                      <>
                        <span>{u.employee.fullName}</span>
                        <br />
                        <span className="faint mono" style={{ fontSize: 12 }}>
                          {u.employee.eeId}
                        </span>
                      </>
                    ) : (
                      <span className="faint">— not linked</span>
                    )}
                  </td>
                  <td>
                    <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
                      {u.roleLabels.length > 0 ? (
                        u.roleLabels.map((rl) => (
                          <span
                            key={rl}
                            style={{
                              fontSize: 11.5,
                              padding: "2px 8px",
                              borderRadius: 999,
                              background: "#eef1f6",
                              color: "#384152",
                              whiteSpace: "nowrap",
                            }}
                          >
                            {rl}
                          </span>
                        ))
                      ) : (
                        <span className="faint">No role</span>
                      )}
                    </div>
                  </td>
                  <td>
                    <span
                      style={{
                        fontSize: 11.5,
                        padding: "2px 8px",
                        borderRadius: 999,
                        background: sb.bg,
                        color: sb.color,
                        whiteSpace: "nowrap",
                      }}
                    >
                      {sb.label}
                    </span>
                  </td>
                  <td>
                    <UserAdminControls
                      user={{
                        id: u.id,
                        email: u.email,
                        status: u.status,
                        roleKeys: u.roleKeys,
                      }}
                      meId={me.id}
                      canAssignRoles={canAssignRoles}
                      roleOptions={roleOptions.map((r) => ({ key: r.key, label: r.label }))}
                    />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </>
  );
}
