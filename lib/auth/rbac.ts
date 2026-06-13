// Server-enforced access control. These guards run inside server components,
// layouts, and server actions — not in middleware alone — so every protected
// route resolves the signed-in user and their permissions from the database.
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { readSessionUid } from "@/lib/auth/session";

export type CurrentUser = {
  id: string;
  name: string;
  email: string;
  roleKeys: string[];
  permissions: Set<string>;
};

export async function getCurrentUser(): Promise<CurrentUser | null> {
  const uid = await readSessionUid();
  if (!uid) return null;

  const user = await prisma.user.findUnique({
    where: { id: uid },
    include: {
      roles: {
        include: {
          role: {
            include: { permissions: { include: { permission: true } } },
          },
        },
      },
    },
  });

  if (!user || user.status !== "active") return null;

  const roleKeys: string[] = [];
  const permissions = new Set<string>();
  for (const ur of user.roles) {
    roleKeys.push(ur.role.key);
    for (const rp of ur.role.permissions) permissions.add(rp.permission.key);
  }

  return {
    id: user.id,
    name: user.name,
    email: user.email,
    roleKeys,
    permissions,
  };
}

export async function requireUser(): Promise<CurrentUser> {
  const u = await getCurrentUser();
  if (!u) redirect("/login");
  return u;
}

export async function requirePermission(perm: string): Promise<CurrentUser> {
  const u = await requireUser();
  if (!u.permissions.has(perm)) redirect("/access-denied");
  return u;
}

export function hasPermission(u: CurrentUser, perm: string): boolean {
  return u.permissions.has(perm);
}

// v0.70.0 — soft-launch visibility gates.
// "Oversight" = HR, Super-Admin, and the control/exec functions (Exec, Finance,
// Compliance, Internal Control, Auditor). We key this on `evidence.view`, which
// today is held by exactly that population and is NEVER held by the line-manager
// role — so it cleanly separates oversight (full employee record + firm-wide
// performance) from a line manager (directory-lite + team-scoped views).
// Swap this for a dedicated permission once auth:bootstrap can run.
export function isOversight(u: CurrentUser): boolean {
  return u.permissions.has("evidence.view");
}

// Super-Admin only (the Chairman). Used for destructive cleanup such as the
// permanent deletion of a staff document. Keyed on the role, not a permission,
// because no new permission can be granted live until auth:bootstrap runs.
export function isSuperAdmin(u: CurrentUser): boolean {
  return u.roleKeys.includes("SUPER_ADMIN");
}
