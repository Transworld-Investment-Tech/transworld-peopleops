"use server";
import { z } from "zod";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { verifyPassword } from "@/lib/auth/password";
import {
  setSessionCookie,
  clearSessionCookie,
  readSessionUid,
} from "@/lib/auth/session";
import { writeAudit } from "@/lib/auth/audit";

const loginSchema = z.object({
  email: z.string().email("Enter a valid email address."),
  password: z.string().min(1, "Enter your password."),
});

export type LoginState = { error?: string };

export async function loginAction(
  _prev: LoginState,
  formData: FormData
): Promise<LoginState> {
  const parsed = loginSchema.safeParse({
    email: String(formData.get("email") ?? "")
      .trim()
      .toLowerCase(),
    password: String(formData.get("password") ?? ""),
  });

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? "Invalid input." };
  }

  const { email, password } = parsed.data;
  const user = await prisma.user.findUnique({ where: { email } });

  if (!user || !user.passwordHash || user.status !== "active") {
    await writeAudit({
      action: "auth.login_failed",
      entityType: "user",
      metadata: { email, reason: "no_user_or_inactive" },
    });
    return { error: "Invalid email or password." };
  }

  const ok = await verifyPassword(password, user.passwordHash);
  if (!ok) {
    await writeAudit({
      actorId: user.id,
      action: "auth.login_failed",
      entityType: "user",
      entityId: user.id,
      metadata: { email, reason: "bad_password" },
    });
    return { error: "Invalid email or password." };
  }

  await setSessionCookie(user.id);
  await writeAudit({
    actorId: user.id,
    action: "auth.login",
    entityType: "user",
    entityId: user.id,
  });

  // redirect() throws internally; keep it out of any try/catch.
  redirect("/dashboard");
}

export async function logoutAction(): Promise<void> {
  const uid = await readSessionUid();
  await clearSessionCookie();
  if (uid) {
    await writeAudit({
      actorId: uid,
      action: "auth.logout",
      entityType: "user",
      entityId: uid,
    });
  }
  redirect("/login");
}
