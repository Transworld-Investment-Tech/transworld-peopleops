// lib/jobframework-vocab.ts — pure job-family vocabulary (no IO, no prisma).
//
// Single source of truth for the family value->label list. Because this module
// imports nothing server-only, it is safe to import from client components (the
// Job & Competency form does). lib/jobframework.ts re-exports these so the many
// server-side callers can keep importing from "@/lib/jobframework" unchanged.
//
// NOTE: control-function is a role-level flag (job_profiles.is_control_function),
// NOT a sixth family — do not add it here. The DB CHECK on job_profiles.family
// (supabase/migrations/0020 + 0033) is the authoritative allowlist; keep these
// values in lockstep with it.

export const FAMILIES: { value: string; label: string }[] = [
  { value: "BUSINESS_DEVELOPMENT", label: "Business Development" },
  { value: "INVESTMENTS", label: "Investments" },
  { value: "CONTROL_OPERATIONS", label: "Control & Operations" },
  { value: "ADMIN_CORPORATE_SERVICES", label: "Administration & Corporate Services" },
  { value: "LEADERSHIP", label: "Leadership" },
];

export function familyLabel(v: string | null): string {
  return FAMILIES.find((f) => f.value === v)?.label ?? "—";
}
