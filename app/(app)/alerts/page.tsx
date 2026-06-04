import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getAlertKpis, getOpenAlerts, getPendingAlerts } from "@/lib/notifications";
import { severityBadge, categoryLabel } from "@/lib/expiry";
import {
  GenerateAlertsButton,
  DismissButton,
  ResolveButton,
} from "@/components/alerts/AlertControls";

export const metadata = { title: "Alerts · Transworld PeopleOps" };

function fmtDate(d: Date | null): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}

export default async function AlertsPage() {
  const me = await requirePermission("stafffile.view");
  const canManage = hasPermission(me, "stafffile.manage");
  const [kpis, open, pending] = await Promise.all([getAlertKpis(), getOpenAlerts(), getPendingAlerts()]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Alerts</h1>
          <p>
            Document-expiry and staff-file-gap monitoring. The list below is computed live from current
            data; generating writes them to the spine so they can be dismissed or resolved.
          </p>
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Open alerts</div>
          <div className="val">{kpis.openCount}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Pending to generate</div>
          <div className="val">{kpis.pendingCount}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Expiring ≤30 days / expired</div>
          <div className="val">{kpis.expiringSoon}</div>
        </div>
        <div className="card kpi">
          <div className="lab">Files below threshold</div>
          <div className="val">{kpis.filesBelowThreshold}</div>
        </div>
      </div>

      {canManage ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Pending to generate</h3>
            <span className="hint">read-only preview — review, then generate</span>
          </div>
          <div className="card-pad" style={{ borderBottom: pending.length ? "1px solid var(--line)" : "none" }}>
            <GenerateAlertsButton pendingCount={kpis.pendingCount} />
          </div>
          {pending.length === 0 ? (
            <div className="card-pad">
              <div className="note"><span>ℹ</span><div>Nothing new to generate — every current condition already has an alert on file.</div></div>
            </div>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Severity</th>
                  <th>Type</th>
                  <th>Detail</th>
                  <th>Due</th>
                </tr>
              </thead>
              <tbody>
                {pending.map((p) => {
                  const sb = severityBadge(p.severity);
                  return (
                    <tr key={p.dedupeKey}>
                      <td><span className={`b ${sb.cls}`}>{sb.label}</span></td>
                      <td className="faint">{categoryLabel(p.category)}</td>
                      <td>{p.title}{p.body ? <div className="faint" style={{ fontSize: 12 }}>{p.body}</div> : null}</td>
                      <td className="faint">{fmtDate(p.dueAt)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Open alerts</h3>
          <span className="hint">{open.length} open</span>
        </div>
        {open.length === 0 ? (
          <div className="card-pad">
            <div className="note"><span>ℹ</span><div>No open alerts.{canManage ? " Generate from the live preview above." : ""}</div></div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Severity</th>
                <th>Type</th>
                <th>Detail</th>
                <th>Due</th>
                <th>Raised</th>
                {canManage ? <th></th> : null}
              </tr>
            </thead>
            <tbody>
              {open.map((a) => {
                const sb = severityBadge(a.severity);
                return (
                  <tr key={a.id}>
                    <td><span className={`b ${sb.cls}`}>{sb.label}</span></td>
                    <td className="faint">{a.categoryLabel}</td>
                    <td>{a.title}{a.body ? <div className="faint" style={{ fontSize: 12 }}>{a.body}</div> : null}</td>
                    <td className="faint">{fmtDate(a.dueAt)}</td>
                    <td className="faint mono">{fmtDate(a.createdAt)}</td>
                    {canManage ? (
                      <td style={{ whiteSpace: "nowrap" }}>
                        <DismissButton id={a.id} />
                        <ResolveButton id={a.id} />
                      </td>
                    ) : null}
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}
