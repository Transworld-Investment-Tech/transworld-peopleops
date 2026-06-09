"use server";
// Write-side server action for the Settings screen. Gated by `admin.settings`
// (Super Admin only — SUPER_ADMIN holds "*"; no other role is granted it),
// validated with zod, audited, then revalidated so the nav + dashboard reflect
// the change everywhere. Mirrors lib/admin-users-actions.ts.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type SettingsActionState = { ok: boolean; error?: string; message?: string };

// Bounded to the known flag keys; widen alongside the CHECK when adding a flag.
const schema = z.object({
  key: z.enum(["my_pay"]),
  enabled: z.enum(["true", "false"]),
});

const LABELS: Record<string, string> = { my_pay: "My Pay" };

export async function setFeatureFlagAction(
  _prev: SettingsActionState,
  fd: FormData
): Promise<SettingsActionState> {
  const me = await requirePermission("admin.settings");

  const parsed = schema.safeParse({
    key: String(fd.get("key") ?? ""),
    enabled: String(fd.get("enabled") ?? ""),
  });
  if (!parsed.success) return { ok: false, error: "Invalid request." };

  const { key } = parsed.data;
  const enabled = parsed.data.enabled === "true";

  await prisma.featureFlag.upsert({
    where: { key },
    create: { key, enabled, updatedById: me.id },
    update: { enabled, updatedById: me.id },
  });

  await writeAudit({
    actorId: me.id,
    action: enabled ? "feature_flag.enable" : "feature_flag.disable",
    entityType: "feature_flag",
    entityId: key,
    metadata: { key, enabled },
  });

  // The settings page, and the layout (nav) + dashboard everywhere, must reflect it.
  revalidatePath("/admin/settings");
  revalidatePath("/", "layout");

  return { ok: true, message: `${LABELS[key] ?? key} is now ${enabled ? "ON" : "OFF"}.` };
}
