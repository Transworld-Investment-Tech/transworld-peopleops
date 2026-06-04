import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getStaffFileRollup,
  getSnapshots,
  scopeLabel,
  SCOPES,
  type Scope,
} from "@/lib/stafffile-data";
import { completenessBadge, completenessBarClass, slotLabel } from "@/lib/stafffile";
import { TakeSnapshotForm } from "@/components/stafffile/StaffFileControls";

export const metadata = { title: "Staff Files · Transworld PeopleOps" };

function fmtDateTime(d: Date): string {
  return new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}

export default async function StaffFilesPage({
  searchParams,
}: {
  searchParams: Promise<{ scope?: string }>;
}) {
  const me = await requirePermission("stafffile.view");
  const canManage = hasPermission(me, "stafffile.manage");
  const sp = await searchParams;
  const scope: Scope = (SCOPES as readonly string[]).includes(sp.scope ?? "")
    ? (sp.scope as Scope)
    : "ALL";

  const [rollup, snapshots] = await Promise.all([getStaffFileRollup(scope), getSnapshots()]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Staff Files</h1>
          <p>
            Completeness against HR Operations Manual D6.2. Worst-first, so the highest-risk gaps
            (contracts, fit-and-proper, guarantor forms, regulatory eligibility) surface at the top.
          </p>
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Files complete</div>
          <div className="val">
            {rollup.completeCount}
            <span className="faint"> / {rollup.population}</span>
          </div>
        </div>
        <div className="card kpi">
          <div className="lab">Average completeness</div>
          <div className="val">{rollup.avgPct}%</div>
        </div>
        <div className="card kpi">
          <div className="lab">Threshold (D6.3)</div>
          <div className="val">{rollup.threshold}%</div>
        </div>
        <div className="card kpi">
          <div className="lab">Scope</div>
          <div className="val" style={{ fontSize: 16 }}>{scopeLabel(scope)}</div>
        </div>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Completeness by employee</h3>
          <span style={{ display: "flex", gap: 6 }}>
            {SCOPES.map((s) => (
              <Link
                key={s}
                href={`/staff-files?scope=${s}`}
                className={`b ${s === scope ? "b-blu" : "b-gry"}`}
                style={{ textDecoration: "none" }}
              >
                {scopeLabel(s)}
              </Link>
            ))}
          </span>
        </div>
        <table>
          <thead>
            <tr>
              <th>EID</th>
              <th>Employee</th>
              <th>Grade</th>
              <th>Status</th>
              <th>Completeness</th>
              <th className="num">Slots</th>
              <th>Top gaps</th>
            </tr>
          </thead>
          <tbody>
            {rollup.rows.map((r) => {
              const badge = completenessBadge(r.pct, rollup.threshold);
              return (
                <tr key={r.employeeId}>
                  <td className="faint mono">{r.eeId}</td>
                  <td>
                    <Link href={`/staff-files/${r.employeeId}`} className="emp-link">
                      <span className="nm">{r.fullName}</span>
                    </Link>
                    {r.isRegulated ? <span className="b b-amb" style={{ marginLeft: 6 }}>Regulated</span> : null}
                  </td>
                  <td>{r.grade ?? "—"}</td>
                  <td className="faint">{r.status}</td>
                  <td>
                    <div className="ln-prog">
                      <span className={completenessBarClass(r.pct, rollup.threshold)}>
                        <i style={{ width: `${r.pct}%` }} />
                      </span>
                      <span className={`b ${badge.cls}`}>{badge.label}</span>
                    </div>
                  </td>
                  <td className="num">
                    {r.satisfiedCount}
                    <span className="faint"> / {r.requiredCount}</span>
                  </td>
                  <td className="faint" style={{ fontSize: 12 }}>
                    {r.missing.slice(0, 3).map((s) => slotLabel(s)).join(", ") || "—"}
                    {r.missing.length > 3 ? ` +${r.missing.length - 3}` : ""}
                  </td>
                </tr>
              );
            })}
            {rollup.rows.length === 0 ? (
              <tr>
                <td colSpan={7} className="faint">No employees in this scope.</td>
              </tr>
            ) : null}
          </tbody>
        </table>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Completion trend</h3>
          <span className="hint">immutable snapshots — “files complete: X of N, rising”</span>
        </div>
        {canManage ? (
          <div className="card-pad" style={{ borderBottom: "1px solid var(--line)" }}>
            <TakeSnapshotForm scope={scope} />
          </div>
        ) : null}
        {snapshots.length === 0 ? (
          <div className="card-pad">
            <div className="note"><span>ℹ</span><div>No snapshots yet{canManage ? " — take one above to start the trend." : "."}</div></div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Taken</th>
                <th>Scope</th>
                <th className="num">Complete</th>
                <th className="num">Avg %</th>
                <th>By</th>
                <th>Note</th>
              </tr>
            </thead>
            <tbody>
              {snapshots.map((s) => (
                <tr key={s.id}>
                  <td className="mono faint">{fmtDateTime(s.takenAt)}</td>
                  <td className="faint">{s.scope}</td>
                  <td className="num">
                    {s.complete}
                    <span className="faint"> / {s.population}</span>
                  </td>
                  <td className="num">{s.avgPct}%</td>
                  <td className="faint">{s.takenByName ?? "—"}</td>
                  <td className="faint">{s.note ?? "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
