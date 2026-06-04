"use server";
// Write-side server action for self-service "My Profile" (v0.32.0). Mirrors the
// conventions of the other module actions (account/performance/leave): gated,
// zod-validated, audited. Per the Next 15 "use server" rule this module exports
// ONLY async functions plus the FormState type.
//
// Gating & scope: gated by `requireUser()` (any signed-in user) and SELF-SCOPED
// to the employee linked to the signed-in user. There is no subject id in the
// form — the target is resolved from `me.id` on the server, so a person can only
// ever edit their OWN record. Only `preferredName` and `phone` are writable;
// every other field stays HR-controlled.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { headers } from "next/headers";
import { prisma } from "@/lib/db";
import { requireUser } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type ProfileState = {
  ok: boolean;
  error?: string;
  message?: string;
  fieldErrors?: Record<string, string>;
};

function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

async function clientIp(): Promise<string | null> {
  try {
    const h = await headers();
    return h.get("x-forwarded-for")?.split(",")[0]?.trim() || h.get("x-real-ip") || null;
  } catch {
    return null;
  }
}

const profileSchema = z.object({
  preferredName: z
    .string()
    .trim()
    .max(60, "Keep your preferred name under 60 characters.")
    .optional(),
  phone: z
    .string()
    .trim()
    .max(40, "Keep the phone number under 40 characters.")
    .optional(),
});

export async function updateMyProfileAction(
  _prev: ProfileState,
  fd: FormData
): Promise<ProfileState> {
  const me = await requireUser();

  const parsed = profileSchema.safeParse({
    preferredName: String(fd.get("preferredName") ?? ""),
    phone: String(fd.get("phone") ?? ""),
  });
  if (!parsed.success) {
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: flatten(parsed.error) };
  }

  // Resolve the target from the signed-in user — never from the form.
  const mine = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: { id: true, eeId: true, preferredName: true, phone: true },
  });
  if (!mine) {
    return {
      ok: false,
      error: "Your login isn’t linked to an employee record yet, so there’s nothing to update.",
    };
  }

  const nextPreferred = nz(parsed.data.preferredName);
  const nextPhone = nz(parsed.data.phone);

  await prisma.employee.update({
    where: { id: mine.id },
    data: { preferredName: nextPreferred, phone: nextPhone },
  });

  await writeAudit({
    actorId: me.id,
    action: "employee.self_profile_update",
    entityType: "Employee",
    entityId: mine.id,
    metadata: {
      eeId: mine.eeId,
      preferredName: { from: mine.preferredName, to: nextPreferred },
      phone: { from: mine.phone, to: nextPhone },
      ip: await clientIp(),
    },
  });

  revalidatePath("/account/profile");
  return { ok: true, message: "Your profile has been updated." };
}
