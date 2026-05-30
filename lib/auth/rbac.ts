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
