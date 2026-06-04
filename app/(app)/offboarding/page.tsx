import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOffboardingList } from "@/lib/ws4-data";
import { exitTypeLabel, offboardingStatusBadge, fmtDate } from "@/lib/ws4";
import { OpenOffboardingForm } from "@/components/offboarding/OffboardingControls";

export const metadata = { title: "Offboarding · Transworld PeopleOps" };

export default async function OffboardingListPage() {
  const me = await requirePermission("offboarding.view");
  const canManage = hasPermission(me, "offboarding.manage");
  const { open, closed, startable } = await getOffboardingList();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Offboarding</h1>
          <p className="faint">
            Orderly, documented exits — access revocation, the handover checklist, and the close-out
            that marks the record exited (WS4 / Ops Manual D5).
          </p>
        </div>
      </div>

      {canManage ? (
        <div className="card" style={{ marginBottom: 16 }}>
          <div className="card-h">
            <h3>Start an exit</h3>
            <span className="hint">opens a case and seeds the revocation checklist</span>
          </div>
          <div className="card-pad">
            {startable.length === 0 ? (
              <div className="faint">No active employees without an open case.</div>
            ) : (
              <OpenOffboardingForm employees={startable} />
            )}
          </div>
        </div>
      ) : null}

      <div className="card" style={{ marginBottom: 16 }}>
        <div className="card-h">
          <h3>Open cases</h3>
          <span className="hint">{open.length}</span>
        </div>
        {open.length === 0 ? (
          <div className="card-pad"><div className="faint">No open exits.</div></div>
        ) : (
          <table>
            <thead>
              <tr><th>Employee</th><th>Type</th><th>Last day</th><th>Access</th><th>Status</th></tr>
            </thead>
            <tbody>
              {open.map((r) => {
                const b = offboardingStatusBadge(r.status);
                return (
                  <tr key={r.caseId}>
                    <td>
                      <Link href={`/offboarding/${r.employeeId}`} className="jc-link">{r.employeeName}</Link>
                      <span className="faint mono"> · {r.eeId}</span>
                    </td>
                    <td>{exitTypeLabel(r.exitType)}</td>
                    <td>{fmtDate(r.lastWorkingDay)}</td>
                    <td><span className={`b ${r.accessRevoked ? "b-grn" : "b-amb"}`}>{r.accessRevoked ? "Revoked" : "Active"}</span></td>
                    <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {closed.length > 0 ? (
        <div className="card">
          <div className="card-h">
            <h3>Closed</h3>
            <span className="hint">{closed.length}</span>
          </div>
          <table>
            <thead><tr><th>Employee</th><th>Type</th><th>Last day</th></tr></thead>
            <tbody>
              {closed.map((r) => (
                <tr key={r.caseId}>
                  <td>
                    <Link href={`/offboarding/${r.employeeId}`} className="jc-link">{r.employeeName}</Link>
                    <span className="faint mono"> · {r.eeId}</span>
                  </td>
                  <td>{exitTypeLabel(r.exitType)}</td>
                  <td>{fmtDate(r.lastWorkingDay)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : null}
    </>
  );
}
