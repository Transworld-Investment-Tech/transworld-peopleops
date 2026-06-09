import { requireUser } from "@/lib/auth/rbac";
import { buildNav } from "@/lib/permissions";
import { getFeatureFlags } from "@/lib/feature-flags";
import Sidebar from "@/components/Sidebar";
import Topbar from "@/components/Topbar";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // Server-enforced: unauthenticated visitors are redirected to /login here,
  // covering every route inside this group.
  const me = await requireUser();
  const flags = await getFeatureFlags();
  const sections = buildNav(me.permissions, flags);

  return (
    <div className="app">
      <Sidebar sections={sections} />
      <main className="main">
        <Topbar name={me.name} roleKeys={me.roleKeys} permissions={[...me.permissions]} />
        <div className="content">{children}</div>
      </main>
    </div>
  );
}
