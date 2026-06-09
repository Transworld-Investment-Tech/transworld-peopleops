// Feature flags (v0.66.0). A tiny Super-Admin-toggled switch layer so a feature
// can be staged behind a soft launch: off for everyone, then on when ready.
// Read-only here; writes go through lib/settings-actions.ts.
//
// Defaults are OFF: a flag with no row (or an unknown key, or before the
// migration has run) reads as disabled, so a feature is never silently live
// before it has been switched on.
import { cache } from "react";
import { prisma } from "@/lib/db";

export type FeatureFlagKey = "my_pay";
export const FEATURE_FLAG_KEYS: FeatureFlagKey[] = ["my_pay"];
export type FeatureFlags = Record<FeatureFlagKey, boolean>;

const DEFAULTS: FeatureFlags = { my_pay: false };

export const FEATURE_FLAG_LABELS: Record<
  FeatureFlagKey,
  { label: string; description: string }
> = {
  my_pay: {
    label: "My Pay (employee self-service)",
    description:
      "When on, staff who can view their own compensation see the My Pay page, plus its sidebar and dashboard links. Keep off during a soft launch.",
  },
};

// Request-scoped: deduped across the layout, the page, and the dashboard within
// a single render.
export const getFeatureFlags = cache(async (): Promise<FeatureFlags> => {
  const flags: FeatureFlags = { ...DEFAULTS };
  try {
    const rows = await prisma.featureFlag.findMany();
    for (const r of rows) {
      if ((FEATURE_FLAG_KEYS as string[]).includes(r.key)) {
        flags[r.key as FeatureFlagKey] = r.enabled;
      }
    }
  } catch {
    // Table absent (pre-migration) or transient read issue -> all defaults (OFF).
    // A flag read must never throw into a page render.
  }
  return flags;
});

export async function isFeatureEnabled(key: FeatureFlagKey): Promise<boolean> {
  return (await getFeatureFlags())[key];
}
