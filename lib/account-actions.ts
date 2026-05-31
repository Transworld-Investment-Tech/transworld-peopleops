"use server";
// Self-serve "Change password" for any signed-in user. Verifies the current
// password, enforces a minimum length and confirmation match, stores a new
// bcrypt hash, and audits the change. No forced rotation flow exists at this
// stage (by decision) — this is the voluntary path staff use after signing in
// with the shared initial password.
import { z } from "zod";
import { prisma } from "@/lib/db";
import { requireUser } from "@/lib/auth/rbac";
import { verifyPassword, hashPassword } from "@/lib/auth/password";
import { writeAudit } from "@/lib/auth/audit";

export type ChangePasswordState = {
  ok: boolean;
  error?: string;
  message?: string;
  fieldErrors?: Record<string, string>;
};

const schema = z
  .object({
    current: z.string().min(1, "Enter your current password."),
    next: z.string().min(8, "New password must be at least 8 characters."),
    confirm: z.string().min(1, "Re-enter the new password."),
  })
  .refine((v) => v.next === v.confirm, {
    path: ["confirm"],
    message: "The new passwords don't match.",
  })
  .refine((v) => v.next !== v.current, {
    path: ["next"],
    message: "Choose a password different from your current one.",
  });

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

export async function changeOwnPasswordAction(
  _prev: ChangePasswordState,
  fd: FormData
): Promise<ChangePasswordState> {
  const me = await requireUser();

  const parsed = schema.safeParse({
    current: String(fd.get("current") ?? ""),
    next: String(fd.get("next") ?? ""),
    confirm: String(fd.get("confirm") ?? ""),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const user = await prisma.user.findUnique({ where: { id: me.id } });
  if (!user || !user.passwordHash)
    return { ok: false, error: "Account not found." };

  const currentOk = await verifyPassword(parsed.data.current, user.passwordHash);
  if (!currentOk)
    return { ok: false, fieldErrors: { current: "That isn't your current password." } };

  const passwordHash = await hashPassword(parsed.data.next);
  await prisma.user.update({ where: { id: user.id }, data: { passwordHash } });

  await writeAudit({
    actorId: user.id,
    action: "auth.password_changed",
    entityType: "user",
    entityId: user.id,
  });

  return { ok: true, message: "Your password has been updated." };
}
