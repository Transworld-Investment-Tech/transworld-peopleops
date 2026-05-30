// Presentational org chart. Two modes:
//  - Hierarchy present: an indented, connector-style tree (robust at any depth).
//  - No reporting lines yet (current data): a flat grid of all staff, so the
//    tab is still useful and reflects manager_id honestly.
import Link from "next/link";
import { empInitials, statusBadge, type OrgNode } from "@/lib/employees";

function NodeCard({ n }: { n: OrgNode }) {
  const s = statusBadge(n.status);
  return (
    <div className="org-node">
      <span className="chip">{empInitials(n.fullName)}</span>
      <div className="org-meta">
        <Link href={`/employees/${n.id}`} className="org-nm">
          {n.fullName}
        </Link>
        <div className="org-sub">
          {n.title ?? "—"} · <span className={"b " + s.cls}>{s.label}</span>
        </div>
      </div>
    </div>
  );
}

function TreeNode({ n }: { n: OrgNode }) {
  return (
    <li>
      <NodeCard n={n} />
      {n.children.length > 0 && (
        <ul className="org-children">
          {n.children.map((c) => (
            <TreeNode key={c.id} n={c} />
          ))}
        </ul>
      )}
    </li>
  );
}

export default function OrgChart({
  roots,
  hasHierarchy,
}: {
  roots: OrgNode[];
  hasHierarchy: boolean;
}) {
  if (!hasHierarchy) {
    return (
      <div className="org-flat">
        {roots.map((n) => (
          <NodeCard key={n.id} n={n} />
        ))}
      </div>
    );
  }
  return (
    <ul className="org-tree">
      {roots.map((n) => (
        <TreeNode key={n.id} n={n} />
      ))}
    </ul>
  );
}
