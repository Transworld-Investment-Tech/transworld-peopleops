import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { MODULE_BY_SLUG } from "@/lib/permissions";
import ComingSoon from "@/components/ComingSoon";

export default async function ModulePage({
  params,
}: {
  params: Promise<{ slug: string[] }>;
}) {
  const { slug } = await params;
  const key = slug?.[0];
  const mod = key ? MODULE_BY_SLUG[key] : undefined;
  if (!mod) notFound();

  // Same permission the sidebar uses to show the item is enforced on the route.
  await requirePermission(mod.perm);

  return <ComingSoon title={mod.label} />;
}
