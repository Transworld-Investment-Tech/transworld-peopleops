"use client";
import { useActionState } from "react";
import {
  resetPasswordAction,
  setUserStatusAction,
  setUserRolesAction,
  type AdminActionState,
} from "@/lib/admin-users-actions";

const EMPTY: AdminActionState = { ok: false };

type RoleOption = { key: string; label: string };

function Msg({ state }: { state: AdminActionState }) {
  if (state.error) return <span className="err">{state.error}</span>;
  if (state.ok && state.message)
    return (
      <span className="faint" style={{ color: "#1c6b3c", fontSize: 12 }}>
        ✓ {state.message}
      </span>
    );
  return null;
}

export default function UserAdminControls({
  user,
  meId,
  canAssignRoles,
  roleOptions,
}: {
  user: { id: string; email: string; status: string; roleKeys: string[] };
  meId: string;
  canAssignRoles: boolean;
  roleOptions: RoleOption[];
}) {
  const [resetState, resetAction, resetPending] = useActionState(resetPasswordAction, EMPTY);
  const [statusState, statusAction, statusPending] = useActionState(setUserStatusAction, EMPTY);
  const [rolesState, rolesAction, rolesPending] = useActionState(setUserRolesAction, EMPTY);

  const isSelf = user.id === meId;
  const nextStatus = user.status === "active" ? "disabled" : "active";

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 12, minWidth: 280 }}>
      {/* Roles — SUPER_ADMIN only */}
      {canAssignRoles && (
        <form
          action={rolesAction}
          style={{ borderBottom: "1px solid var(--line, #e7e2d9)", paddingBottom: 12 }}
        >
          <input type="hidden" name="userId" value={user.id} />
          <div style={{ fontWeight: 600, fontSize: 12.5, marginBottom: 6 }}>Roles</div>
          {isSelf ? (
            <p className="faint" style={{ fontSize: 12 }}>
              You can&apos;t change your own roles.
            </p>
          ) : (
            <>
              <div
                style={{
                  display: "grid",
                  gridTemplateColumns: "1fr 1fr",
                  gap: "4px 12px",
                  marginBottom: 8,
                }}
              >
                {roleOptions.map((r) => (
                  <label
                    key={r.key}
                    style={{ display: "flex", gap: 6, alignItems: "center", fontSize: 12.5 }}
                  >
                    <input
                      type="checkbox"
                      name="roles"
                      value={r.key}
                      defaultChecked={user.roleKeys.includes(r.key)}
                    />
                    {r.label}
                  </label>
                ))}
              </div>
              <div style={{ display: "flex", gap: 10, alignItems: "center" }}>
                <button className="btn" type="submit" disabled={rolesPending}>
                  {rolesPending ? "Saving…" : "Save roles"}
                </button>
                <Msg state={rolesState} />
              </div>
            </>
          )}
        </form>
      )}

      {/* Reset password */}
      <form
        action={resetAction}
        onSubmit={(e) => {
          if (!confirm(`Reset ${user.email}'s password to the shared default?`))
            e.preventDefault();
        }}
      >
        <input type="hidden" name="userId" value={user.id} />
        <div style={{ display: "flex", gap: 10, alignItems: "center" }}>
          <button className="btn" type="submit" disabled={resetPending}>
            {resetPending ? "Resetting…" : "Reset password"}
          </button>
          <Msg state={resetState} />
        </div>
      </form>

      {/* Enable / disable */}
      <form
        action={statusAction}
        onSubmit={(e) => {
          const verb = nextStatus === "disabled" ? "Disable" : "Enable";
          if (!confirm(`${verb} sign-in for ${user.email}?`)) e.preventDefault();
        }}
      >
        <input type="hidden" name="userId" value={user.id} />
        <input type="hidden" name="status" value={nextStatus} />
        <div style={{ display: "flex", gap: 10, alignItems: "center" }}>
          <button
            className="btn"
            type="submit"
            disabled={statusPending || (isSelf && nextStatus === "disabled")}
            title={
              isSelf && nextStatus === "disabled"
                ? "You can't disable your own account"
                : undefined
            }
          >
            {statusPending
              ? "Working…"
              : nextStatus === "disabled"
              ? "Disable login"
              : "Enable login"}
          </button>
          <Msg state={statusState} />
        </div>
      </form>
    </div>
  );
}
