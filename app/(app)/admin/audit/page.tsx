import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getAuditLog } from "@/lib/audit-reads";

export const metadata = { title: "Audit Log · Transworld PeopleOps" };

function fmtDateTime(d: Date): string {
  return d.toLocaleString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

type SP = {
  entityType?: string;
  action?: string;
  actorId?: string;
  from?: string;
  to?: string;
  page?: string;
};

function pageHref(base: SP, page: number): string {
  const q = new URLSearchParams();
  if (base.entityType) q.set("entityType", base.entityType);
  if (base.action) q.set("action", base.action);
  if (base.actorId) q.set("actorId", base.actorId);
  if (base.from) q.set("from", base.from);
  if (base.to) q.set("to", base.to);
  q.set("page", String(page));
  return `/admin/audit?${q.toString()}`;
}

export default async function AuditLogPage({ searchParams }: { searchParams: Promise<SP> }) {
  await requirePermission("admin.users");
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10) || 1);

  const view = await getAuditLog({
    entityType: sp.entityType || undefined,
    action: sp.action || undefined,
    actorId: sp.actorId || undefined,
    from: sp.from || undefined,
    to: sp.to || undefined,
    page,
  });

  const hasFilters = !!(sp.entityType || sp.action || sp.actorId || sp.from || sp.to);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Audit Log</h1>
          <p>
            A read-only record of sensitive actions across the portal — who did what, to which
            record, and when. Newest first.
          </p>
        </div>
      </div>

      <div className="grid kpis">
        <div className="card kpi">
          <div className="lab">Matching events</div>
          <div className="val">{view.total.toLocaleString("en-US")}</div>
          <div className="faint" style={{ fontSize: 12, marginTop: 6 }}>
            page {view.page} of {view.pageCount}
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-pad">
          <form method="get" className="form-grid">
            <div className="field">
              <label htmlFor="entityType">Entity type</label>
              <select id="entityType" name="entityType" defaultValue={sp.entityType ?? ""}>
                <option value="">All</option>
                {view.entityTypes.map((t) => (
                  <option key={t} value={t}>
                    {t}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="action">Action</label>
              <select id="action" name="action" defaultValue={sp.action ?? ""}>
                <option value="">All</option>
                {view.actions.map((a) => (
                  <option key={a} value={a}>
                    {a}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="actorId">Actor</label>
              <select id="actorId" name="actorId" defaultValue={sp.actorId ?? ""}>
                <option value="">Anyone</option>
                {view.actors.map((a) => (
                  <option key={a.id} value={a.id}>
                    {a.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="from">From</label>
              <input id="from" name="from" type="date" defaultValue={sp.from ?? ""} />
            </div>
            <div className="field">
              <label htmlFor="to">To</label>
              <input id="to" name="to" type="date" defaultValue={sp.to ?? ""} />
            </div>
            <div className="field" style={{ alignSelf: "end" }}>
              <div className="form-actions" style={{ marginTop: 0 }}>
                <button className="btn btn-pri" type="submit">
                  Apply filters
                </button>
                {hasFilters ? (
                  <Link className="btn" href="/admin/audit">
                    Clear
                  </Link>
                ) : null}
              </div>
            </div>
          </form>
        </div>
      </div>

      {view.rows.length === 0 ? (
        <div className="note">
          <span>ℹ</span>
          <div>No audit events match these filters.</div>
        </div>
      ) : (
        <div className="card">
          <table>
            <thead>
              <tr>
                <th>When</th>
                <th>Actor</th>
                <th>Action</th>
                <th>Entity</th>
                <th>Record</th>
                <th>IP</th>
              </tr>
            </thead>
            <tbody>
              {view.rows.map((r) => (
                <tr key={r.id}>
                  <td className="mono" style={{ whiteSpace: "nowrap" }}>
                    {fmtDateTime(r.createdAt)}
                  </td>
                  <td>
                    {r.actorName ? (
                      <>
                        {r.actorName}
                        {r.actorEmail ? (
                          <div className="faint" style={{ fontSize: 12 }}>
                            {r.actorEmail}
                          </div>
                        ) : null}
                      </>
                    ) : (
                      <span className="faint">system</span>
                    )}
                  </td>
                  <td>
                    <span className="b b-blu">{r.action}</span>
                  </td>
                  <td>{r.entityType}</td>
                  <td className="mono faint" style={{ fontSize: 12 }}>
                    {r.entityId ?? "—"}
                  </td>
                  <td className="mono faint" style={{ fontSize: 12 }}>
                    {r.ip ?? "—"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {view.pageCount > 1 ? (
        <div className="form-actions" style={{ justifyContent: "space-between" }}>
          {view.page > 1 ? (
            <Link className="btn" href={pageHref(sp, view.page - 1)}>
              ← Newer
            </Link>
          ) : (
            <span />
          )}
          {view.page < view.pageCount ? (
            <Link className="btn" href={pageHref(sp, view.page + 1)}>
              Older →
            </Link>
          ) : (
            <span />
          )}
        </div>
      ) : null}
    </>
  );
}
