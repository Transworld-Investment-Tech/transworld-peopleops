"use server";
// Write-side server actions for the User Management screen. Every mutation is
// gated by `admin.users`, validated with zod, and writes an audit_logs row.
// Role *assignment* is further restricted to SUPER_ADMIN (so an HR_ADMIN who
// can provision logins cannot elevate anyone — including themselves).
//
// Pattern mirrors lib/employees-actions.ts (requirePermission -> zod -> mutate
// -> writeAudit -> revalidatePath).
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { hashPassword } from "@/lib/auth/password";
import { DEFAULT_STAFF_PASSWORD } from "@/lib/admin-users";

export type AdminActionState = {
  ok: boolean;
  error?: string;
  message?: string;
  fieldErrors?: Record<string, string>;
};

const EMPTY: AdminActionState = { ok: false };

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Provision a login for an existing (non-exited, unlinked) employee, one-by-one.
// Creates the user with the shared default password and the EMPLOYEE role, then
// links employee.userId and stamps work_email. SUPER_ADMIN later adjusts roles.
// ---------------------------------------------------------------------------
const provisionSchema = z.object({
  employeeId: z.string().trim().min(1, "Choose an employee."),
  email: z.string().trim().toLowerCase().email("Enter a valid work email."),
});

export async function provisionUserAction(
  _prev: AdminActionState,
  fd: FormData
): Promise<AdminActionState> {
  const me = await requirePermission("admin.users");

  const parsed = provisionSchema.safeParse({
    employeeId: String(fd.get("employeeId") ?? ""),
    email: String(fd.get("email") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const { employeeId, email } = parsed.data;

  const emp = await prisma.employee.findUnique({ where: { id: employeeId } });
  if (!emp) return { ok: false, error: "That employee no longer exists." };
  if (emp.status === "EXITED")
    return { ok: false, error: "That employee has exited and cannot receive a login." };
  if (emp.userId)
    return { ok: false, error: "That employee already has a linked login." };

  const existingByEmail = await prisma.user.findUnique({ where: { email } });
  if (existingByEmail)
    return {
      ok: false,
      fieldErrors: { email: "A user with that email already exists." },
    };

  const employeeRole = await prisma.role.findUnique({ where: { key: "EMPLOYEE" } });
  if (!employeeRole)
    return { ok: false, error: "The EMPLOYEE role is missing — run the foundation seed." };

  const passwordHash = await hashPassword(DEFAULT_STAFF_PASSWORD);

  const user = await prisma.$transaction(async (tx) => {
    const created = await tx.user.create({
      data: { email, name: emp.fullName, passwordHash, status: "active" },
    });
    await tx.userRole.create({
      data: { userId: created.id, roleId: employeeRole.id },
    });
    await tx.employee.update({
      where: { id: emp.id },
      data: { userId: created.id, workEmail: email },
    });
    return created;
  });

  await writeAudit({
    actorId: me.id,
    action: "user.provision",
    entityType: "user",
    entityId: user.id,
    metadata: { email, employeeId: emp.id, eeId: emp.eeId, role: "EMPLOYEE" },
  });

  revalidatePath("/admin/users");
  return { ok: true, message: `Login created for ${emp.fullName} and linked to ${emp.eeId}.` };
}

// ---------------------------------------------------------------------------
// Reset a user's password back to the shared default.
// ---------------------------------------------------------------------------
const userIdSchema = z.object({ userId: z.string().trim().min(1) });

export async function resetPasswordAction(
  _prev: AdminActionState,
  fd: FormData
): Promise<AdminActionState> {
  const me = await requirePermission("admin.users");
  const parsed = userIdSchema.safeParse({ userId: String(fd.get("userId") ?? "") });
  if (!parsed.success) return { ok: false, error: "Missing user id." };

  const user = await prisma.user.findUnique({ where: { id: parsed.data.userId } });
  if (!user) return { ok: false, error: "User not found." };

  const passwordHash = await hashPassword(DEFAULT_STAFF_PASSWORD);
  await prisma.user.update({ where: { id: user.id }, data: { passwordHash } });

  await writeAudit({
    actorId: me.id,
    action: "user.password_reset",
    entityType: "user",
    entityId: user.id,
    metadata: { email: user.email, to: "default" },
  });

  revalidatePath("/admin/users");
  return { ok: true, message: `Password reset to the default for ${user.email}.` };
}

// ---------------------------------------------------------------------------
// Enable / disable a login. A disabled user cannot sign in (rbac + login both
// require status === "active"). You cannot disable your own account.
// ---------------------------------------------------------------------------
const statusSchema = z.object({
  userId: z.string().trim().min(1),
  status: z.enum(["active", "disabled"]),
});

export async function setUserStatusAction(
  _prev: AdminActionState,
  fd: FormData
): Promise<AdminActionState> {
  const me = await requirePermission("admin.users");
  const parsed = statusSchema.safeParse({
    userId: String(fd.get("userId") ?? ""),
    status: String(fd.get("status") ?? ""),
  });
  if (!parsed.success) return { ok: false, error: "Invalid request." };
  const { userId, status } = parsed.data;

  if (userId === me.id && status === "disabled")
    return { ok: false, error: "You can't disable your own account." };

  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) return { ok: false, error: "User not found." };

  await prisma.user.update({ where: { id: userId }, data: { status } });
  await writeAudit({
    actorId: me.id,
    action: status === "active" ? "user.enable" : "user.disable",
    entityType: "user",
    entityId: userId,
    metadata: { email: user.email },
  });

  revalidatePath("/admin/users");
  return { ok: true, message: `${user.email} is now ${status}.` };
}

// ---------------------------------------------------------------------------
// Replace a user's roles wholesale. SUPER_ADMIN only. Guards:
//   * you cannot change your own roles (no self-lockout / no self-elevation),
//   * at least one role is required,
//   * submitted role keys must exist.
// Roles arrive as repeated `roles` checkbox values (role KEYS).
// ---------------------------------------------------------------------------
export async function setUserRolesAction(
  _prev: AdminActionState,
  fd: FormData
): Promise<AdminActionState> {
  const me = await requirePermission("admin.users");
  if (!me.roleKeys.includes("SUPER_ADMIN")) {
    // HR_ADMIN can reach the screen but not assign roles.
    redirect("/access-denied");
  }

  const userId = String(fd.get("userId") ?? "").trim();
  if (!userId) return { ok: false, error: "Missing user id." };
  if (userId === me.id)
    return { ok: false, error: "You can't change your own roles." };

  const keys = fd
    .getAll("roles")
    .map((v) => String(v).trim())
    .filter(Boolean);
  const uniqueKeys = Array.from(new Set(keys));
  if (uniqueKeys.length === 0)
    return { ok: false, error: "Select at least one role." };

  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { roles: { include: { role: true } } },
  });
  if (!user) return { ok: false, error: "User not found." };

  const roles = await prisma.role.findMany({ where: { key: { in: uniqueKeys } } });
  if (roles.length !== uniqueKeys.length) {
    const found = new Set(roles.map((r) => r.key));
    const missing = uniqueKeys.filter((k) => !found.has(k));
    return { ok: false, error: `Unknown role(s): ${missing.join(", ")}.` };
  }

  const before = user.roles.map((ur) => ur.role.key).sort();
  const after = roles.map((r) => r.key).sort();
  if (before.join("|") === after.join("|"))
    return { ok: true, message: "No changes — roles are already set that way." };

  await prisma.$transaction(async (tx) => {
    await tx.userRole.deleteMany({ where: { userId } });
    await tx.userRole.createMany({
      data: roles.map((r) => ({ userId, roleId: r.id })),
    });
  });

  await writeAudit({
    actorId: me.id,
    action: "user.roles_set",
    entityType: "user",
    entityId: userId,
    metadata: { email: user.email, before, after },
  });

  revalidatePath("/admin/users");
  return { ok: true, message: `Roles updated for ${user.email}.` };
}
