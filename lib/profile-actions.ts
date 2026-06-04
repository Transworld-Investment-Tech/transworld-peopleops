"use server";
// Write-side server action for self-service "My Profile" (v0.32.0; contact-block
// self-edit added v0.36.0). Mirrors the conventions of the other module actions
// (account/performance/leave): gated, zod-validated, audited. Per the Next 15
// "use server" rule this module exports ONLY async functions plus the FormState
// type.
//
// Gating & scope: gated by `requireUser()` (any signed-in user) and SELF-SCOPED
// to the employee linked to the signed-in user. There is no subject id in the
// form — the target is resolved from `me.id` on the server, so a person can only
// ever edit their OWN record. The self-editable set is the person's CONTACT
// block: preferred name, phone, personal email/phone, residential address
// (line/city/state/country) and next-of-kin (name/relationship/phone/address).
// Every other field — DOB, demographics, identification, grade, department,
// employment, bank and dependents — stays HR-controlled (edited at
// /employees/[id]/edit) and is never writable here.
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
  preferredName: z.string().trim().max(60, "Keep your preferred name under 60 characters.").optional(),
  phone: z.string().trim().max(40, "Keep the phone number under 40 characters.").optional(),
  personalEmail: z
    .string()
    .trim()
    .email("Enter a valid personal email")
    .max(120)
    .optional()
    .or(z.literal("")),
  personalPhone: z.string().trim().max(40, "Keep the personal phone under 40 characters.").optional(),
  residentialAddress: z.string().trim().max(200, "Keep the address under 200 characters.").optional(),
  city: z.string().trim().max(80).optional(),
  stateRegion: z.string().trim().max(80).optional(),
  country: z.string().trim().max(80).optional(),
  nokName: z.string().trim().max(120, "Keep the name under 120 characters.").optional(),
  nokRelationship: z.string().trim().max(60).optional(),
  nokPhone: z.string().trim().max(40, "Keep the phone under 40 characters.").optional(),
  nokAddress: z.string().trim().max(200, "Keep the address under 200 characters.").optional(),
});

const FIELDS = [
  "preferredName",
  "phone",
  "personalEmail",
  "personalPhone",
  "residentialAddress",
  "city",
  "stateRegion",
  "country",
  "nokName",
  "nokRelationship",
  "nokPhone",
  "nokAddress",
] as const;

export async function updateMyProfileAction(
  _prev: ProfileState,
  fd: FormData
): Promise<ProfileState> {
  const me = await requireUser();

  const raw: Record<string, string> = {};
  for (const f of FIELDS) raw[f] = String(fd.get(f) ?? "");
  const parsed = profileSchema.safeParse(raw);
  if (!parsed.success) {
    return { ok: false, error: "Please fix the highlighted fields.", fieldErrors: flatten(parsed.error) };
  }

  // Resolve the target from the signed-in user — never from the form.
  const mine = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: {
      id: true,
      eeId: true,
      preferredName: true,
      phone: true,
      personalEmail: true,
      personalPhone: true,
      residentialAddress: true,
      city: true,
      stateRegion: true,
      country: true,
      nokName: true,
      nokRelationship: true,
      nokPhone: true,
      nokAddress: true,
    },
  });
  if (!mine) {
    return {
      ok: false,
      error: "Your login isn’t linked to an employee record yet, so there’s nothing to update.",
    };
  }

  const next: Record<string, unknown> = {};
  for (const f of FIELDS) next[f] = nz(parsed.data[f] as string | undefined);

  const changes: string[] = [];
  for (const f of FIELDS) {
    if ((mine as Record<string, unknown>)[f] !== next[f]) changes.push(f);
  }
  if (changes.length === 0) {
    return { ok: true, message: "Nothing to update — your details are already current." };
  }

  await prisma.employee.update({ where: { id: mine.id }, data: next });

  await writeAudit({
    actorId: me.id,
    action: "employee.self_profile_update",
    entityType: "Employee",
    entityId: mine.id,
    metadata: { eeId: mine.eeId, changed: changes, ip: await clientIp() },
  });

  revalidatePath("/account/profile");
  return { ok: true, message: "Your profile has been updated." };
}
