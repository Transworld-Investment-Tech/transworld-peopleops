// Read-side helpers for the User Management screen (admin.users). No writes.
// Writes live in lib/admin-users-actions.ts; the one-time backfill lives in
// prisma/users-populate.ts.
import { prisma } from "@/lib/db";
import { ROLE_LABELS } from "@/lib/permissions";

// Shared initial password for staff logins created in v0.13.0. Staff change it
// from the self-serve "Change password" page. There is no forced rotation at
// this stage (by decision), so this constant is also the value the "Reset
// password" admin action restores an account to.
export const DEFAULT_STAFF_PASSWORD = "Transworld!23";

export type AdminUserRow = {
  id: string;
  name: string;
  email: string;
  status: string; // "active" | "disabled"
  roleKeys: string[];
  roleLabels: string[];
  employee: { id: string; eeId: string; fullName: string; status: string } | null;
};

export type UnlinkedEmployee = {
  id: string;
  eeId: string;
  fullName: string;
  workEmail: string | null;
  status: string;
};

export type RoleOption = { key: string; name: string; label: string };

export async function getUsersForList(): Promise<AdminUserRow[]> {
  const users = await prisma.user.findMany({
    orderBy: { name: "asc" },
    include: {
      roles: { include: { role: true } },
      employee: {
        select: { id: true, eeId: true, fullName: true, status: true },
      },
    },
  });

  return users.map((u): AdminUserRow => {
    const roleKeys = u.roles.map((ur) => ur.role.key).sort();
    return {
      id: u.id,
      name: u.name,
      email: u.email,
      status: u.status,
      roleKeys,
      roleLabels: roleKeys.map((k) => ROLE_LABELS[k] ?? k),
      employee: u.employee
        ? {
            id: u.employee.id,
            eeId: u.employee.eeId,
            fullName: u.employee.fullName,
            status: u.employee.status as unknown as string,
          }
        : null,
    };
  });
}

// Employees who can still receive a login: not yet linked, and not exited.
export async function getUnlinkedEmployees(): Promise<UnlinkedEmployee[]> {
  const rows = await prisma.employee.findMany({
    where: { userId: null, status: { not: "EXITED" } },
    orderBy: { fullName: "asc" },
    select: { id: true, eeId: true, fullName: true, workEmail: true, status: true },
  });
  return rows.map((r): UnlinkedEmployee => ({
    id: r.id,
    eeId: r.eeId,
    fullName: r.fullName,
    workEmail: r.workEmail,
    status: r.status as unknown as string,
  }));
}

export async function getRoleOptions(): Promise<RoleOption[]> {
  const roles = await prisma.role.findMany({ orderBy: { key: "asc" } });
  return roles.map((r): RoleOption => ({
    key: r.key,
    name: r.name,
    label: ROLE_LABELS[r.key] ?? r.name,
  }));
}

export function userStatusBadge(status: string): { label: string; color: string; bg: string } {
  if (status === "active") {
    return { label: "Active", color: "#1c6b3c", bg: "#e6f4ea" };
  }
  return { label: "Disabled", color: "#7a241b", bg: "#fbe9e6" };
}
