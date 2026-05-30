// Presentational org chart — v0.6.0 hybrid layout.
//
//  Leadership spine (top-down "boxes-and-lines"): the leading single-report
//  chain from the head (Chairman -> MD ...) is drawn as connected navy boxes;
//  the pivot's direct reports (the second-level execs) then fan out as a
//  connected row. Each exec branch expands DOWNWARD as an indented sub-tree
//  with connector rails, so the chart's width is bounded by the small number
//  of execs and the firm scales vertically rather than ever wider.
//
//  Falls back to a flat card grid when no reporting lines exist yet
//  (manager_id empty), so the tab stays honest about the data.
//
//  Server-rendered; same employees.view gate as the directory (enforced by the
//  page). Presentation only — consumes OrgNode from getOrgData, which already
//  excludes EXITED staff. No data writes, no new dependencies.
import { Fragment } from "react";
import type { CSSProperties } from "react";
import Link from "next/link";
import {
  empInitials,
  statusBadge,
  typeLabel,
  type OrgNode,
} from "@/lib/employees";
import type { EmploymentType } from "@prisma/client";

// Department color accents — muted, navy-compatible. Decorative only (NOT a
// status signal). Unknown departments fall back to a stable hashed hue so new
// departments still get a consistent accent without a code change.
const DEPT_ACCENT: Record<string, string> = {
  "Executive Office": "#2c5a9e",
  Compliance: "#0f766e",
  Operations: "#3b5ba5",
  "Finance & Accounts": "#b7791f",
  "Client Operations": "#0e7490",
  "Business Development": "#7a4db8",
  "Trading & Settlement": "#2563a8",
  Technology: "#475569",
};
function deptAccent(dept: string | null): string {
  if (!dept) return "#5b6675"; // --muted
  const hit = DEPT_ACCENT[dept];
  if (hit) return hit;
  let h = 0;
  for (let i = 0; i < dept.length; i++) h = (h * 31 + dept.charCodeAt(i)) % 360;
  return `hsl(${h} 38% 42%)`;
}

// Show an employment-type tag for everything except the common full-time case.
function notableType(t: EmploymentType): boolean {
  return t !== "FULL_TIME";
}

function Card({ n, lead }: { n: OrgNode; lead?: boolean }) {
  const s = statusBadge(n.status);
  const style = { "--oc-accent": deptAccent(n.department) } as CSSProperties;
  return (
    <div
      className={"oc-card" + (lead ? " oc-card--lead" : " oc-card--team")}
      style={style}
    >
      <span className="chip oc-chip">{empInitials(n.fullName)}</span>
      <div className="oc-card-main">
        <Link href={`/employees/${n.id}`} className="oc-name">
          {n.fullName}
        </Link>
        <div className="oc-role">
          <span className="oc-title">{n.title ?? "—"}</span>
          {n.department ? (
            <>
              <span className="oc-role-sep" aria-hidden="true">
                ·
              </span>
              <span className="oc-dept">{n.department}</span>
            </>
          ) : null}
        </div>
        <div className="oc-tags">
          <span className={"b " + s.cls}>
            <span className="dot" />
            {s.label}
          </span>
          {notableType(n.employmentType) ? (
            <span className="b b-gry oc-type">{typeLabel(n.employmentType)}</span>
          ) : null}
        </div>
      </div>
    </div>
  );
}

// Indented sub-tree with connector rails — used below each exec. Recurses to
// any depth; width grows by a fixed indent per level, never by node count.
function SubTree({ nodes }: { nodes: OrgNode[] }) {
  return (
    <ul className="oc-sub">
      {nodes.map((n) => (
        <li className="oc-sub-item" key={n.id}>
          <Card n={n} />
          {n.children.length > 0 ? <SubTree nodes={n.children} /> : null}
        </li>
      ))}
    </ul>
  );
}

function RootBlock({ root }: { root: OrgNode }) {
  // The leading single-report chain is the leadership spine; it ends at the
  // first node with 0 or >1 reports (the pivot). The pivot's reports fan out
  // as the exec row, and each of those expands downward as a sub-tree.
  const spine: OrgNode[] = [];
  let cur: OrgNode | undefined = root;
  while (cur && cur.children.length === 1) {
    spine.push(cur);
    cur = cur.children[0];
  }
  if (cur) spine.push(cur);
  const pivot = spine[spine.length - 1];
  const execRow = pivot ? pivot.children : [];

  return (
    <div className="oc-block">
      <div className="oc-spine">
        {spine.map((n, i) => (
          <Fragment key={n.id}>
            <Card n={n} lead />
            {i < spine.length - 1 || execRow.length > 0 ? (
              <span className="oc-stem" aria-hidden="true" />
            ) : null}
          </Fragment>
        ))}
      </div>

      {execRow.length > 0 ? (
        <ul className="oc-fan">
          {execRow.map((ex) => (
            <li className="oc-fan-item" key={ex.id}>
              <div className="oc-fan-head">
                <Card n={ex} lead />
              </div>
              {ex.children.length > 0 ? <SubTree nodes={ex.children} /> : null}
            </li>
          ))}
        </ul>
      ) : null}
    </div>
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
      <div className="oc-flat">
        {roots.map((n) => (
          <Card key={n.id} n={n} />
        ))}
      </div>
    );
  }
  return (
    <div className="oc">
      {roots.map((r) => (
        <RootBlock key={r.id} root={r} />
      ))}
    </div>
  );
}
