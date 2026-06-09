import { requirePermission } from "@/lib/auth/rbac";
import {
  getFeatureFlags,
  FEATURE_FLAG_KEYS,
  FEATURE_FLAG_LABELS,
} from "@/lib/feature-flags";
import FeatureFlagControls from "@/components/admin/FeatureFlagControls";

export const metadata = { title: "Settings · Transworld PeopleOps" };

export default async function SettingsPage() {
  // Super-Admin only: SUPER_ADMIN holds "*", and no other role is granted
  // `admin.settings`, so only the Chairman can reach this screen.
  await requirePermission("admin.settings");
  const flags = await getFeatureFlags();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Settings</h1>
          <p>
            Super-Admin feature switches. Use these to stage a soft launch — turn a
            feature off for everyone, then on when you are ready. Changes apply
            immediately and are recorded in the audit log.
          </p>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Feature flags</h3>
        </div>
        <div>
          {FEATURE_FLAG_KEYS.map((key) => (
            <FeatureFlagControls
              key={key}
              flagKey={key}
              enabled={flags[key]}
              label={FEATURE_FLAG_LABELS[key].label}
              description={FEATURE_FLAG_LABELS[key].description}
            />
          ))}
        </div>
      </div>
    </>
  );
}
