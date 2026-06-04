import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getOffboardingDetail } from "@/lib/ws4-data";
import { exitTypeLabel, offboardingStatusBadge, repaymentStatusBadge, fmtDate } from "@/lib/ws4";
import {
  OffboardingFieldsForm,
  TaskStatusControl,
  FlagToggle,
  RevokeAccessControl,
  CloseCaseControl,
} from "@/components/offboarding/OffboardingControls";

export const metadata = { title: "Exit case · Transworld PeopleOps" };

function isoDate(d: Date | null): string {
  return d ? new Date(d).toISOString().slice(0, 10) : "";
}
function naira(n: number | null): string {
  if (n === null || n === undefined) return "—";
  return `₦${Math.round(n).toLocaleString("en-US")}`;
}

const GROUPS: { key: string; label: string }[] = [
  { key: "SYSTEM", label: "System & data access" },
  { key: "PHYSICAL", label: "Physical assets" },
  { key: "REGULATORY", label: "Regulatory & records" },
];

export default async function OffboardingDetailPage({ params }: { params: Promise<{ employeeId: string }> }) {
  const me = await requirePermission("offboarding.view");
  const canManage = hasPermission(me, "offboarding.manage");
  const { employeeId } = await params;
  const d = await getOffboardingDetail(employeeId);
  if (!d) notFound();

  const st = offboardingStatusBadge(d.status);
  const closed = d.status === "CLOSED";

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Exit · {d.employee.name}</h1>
          <p>
            <span className="faint mono">{d.employee.eeId}</span> · {exitTypeLabel(d.exitType)}{" "}
            <span className={`b ${st.cls}`}>{st.label}</span>
          </p>
        </div>
        <Link href="/offboarding" className="btn">← All exits</Link>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "minmax(0, 1.5fr) minmax(0, 1fr)", gap: 16, alignItems: "start" }}>
        {/* Left: checklist + details */}
        <div>
          <div className="card" style={{ marginBottom: 16 }}>
            <div className="card-h"><h3>Access &amp; asset revocation</h3></div>
            <div className="card-pad">
              {GROUPS.map((g) => {
                const items = d.tasks.filter((t) => t.category === g.key);
                if (items.length === 0) return null;
                return (
                  <div className="ofb-group" key={g.key}>
                    <h4>{g.label}</h4>
                    {items.map((t) => (
                      <div className="ofb-task" key={t.id}>
                        <span>
                          {t.status === "DONE" ? "✓ " : t.status === "NA" ? "– " : "☐ "}
                          {t.label}
                        </span>
                        {canManage && !closed ? (
                          <TaskStatusControl employeeId={d.employee.id} taskId={t.id} status={t.status} />
                        ) : (
                          <span className="faint" style={{ fontSize: 12 }}>{t.status}</span>
                        )}
                      </div>
                    ))}
                  </div>
                );
              })}
            </div>
          </div>

          {canManage ? (
            <div className="card">
              <div className="card-h"><h3>Case details</h3></div>
              <div className="card-pad">
                <OffboardingFieldsForm
                  employeeId={d.employee.id}
                  noticeReceivedAt={isoDate(d.noticeReceivedAt)}
                  lastWorkingDay={isoDate(d.lastWorkingDay)}
                  reason={d.reason ?? ""}
                  note={d.note ?? ""}
                />
              </div>
            </div>
          ) : null}
        </div>

        {/* Right: access revocation, flags, clawback, close */}
        <div>
          <div className="card" style={{ marginBottom: 16 }}>
            <div className="card-h"><h3>Login &amp; roles</h3></div>
            <div className="card-pad">
              {d.access.hasUser ? (
                <>
                  <div className="two-col" style={{ marginBottom: 8 }}>
                    <span className="faint">Account</span>
                    <b>{d.access.userEmail}</b>
                  </div>
                  <div className="two-col" style={{ marginBottom: 8 }}>
                    <span className="faint">Login status</span>
                    <span className={`b ${d.access.userStatus === "disabled" ? "b-gry" : "b-blu"}`}>
                      {d.access.userStatus === "disabled" ? "Disabled" : "Active"}
                    </span>
                  </div>
                  <div className="two-col" style={{ marginBottom: 8 }}>
                    <span className="faint">Roles</span>
                    <b>{d.access.roleKeys.length ? d.access.roleKeys.join(", ") : "—"}</b>
                  </div>
                  {d.access.holdsElevatedRights ? (
                    <div className="note" style={{ marginTop: 8 }}>
                      <span>⚠</span>
                      <div>This account holds elevated rights — reassign SUPER_ADMIN / admin before revoking.</div>
                    </div>
                  ) : null}
                </>
              ) : (
                <div className="faint">No portal login is linked to this employee.</div>
              )}
              {canManage && !closed ? (
                <div style={{ marginTop: 12 }}>
                  <RevokeAccessControl employeeId={d.employee.id} alreadyRevoked={d.access.alreadyRevoked} />
                </div>
              ) : null}
            </div>
          </div>

          <div className="card" style={{ marginBottom: 16 }}>
            <div className="card-h"><h3>Sign-offs</h3></div>
            <div className="card-pad" style={{ display: "flex", flexDirection: "column", gap: 10 }}>
              {canManage && !closed ? (
                <>
                  <FlagToggle employeeId={d.employee.id} flag="exitInterviewDone" value={d.exitInterviewDone} label="exit interview done" />
                  <FlagToggle employeeId={d.employee.id} flag="finalPaySettled" value={d.finalPaySettled} label="final pay settled" />
                  <FlagToggle employeeId={d.employee.id} flag="regulatoryNotified" value={d.regulatoryNotified} label="regulatory notified" />
                </>
              ) : (
                <>
                  <div className="two-col"><span className="faint">Exit interview</span><b>{d.exitInterviewDone ? "Done" : "—"}</b></div>
                  <div className="two-col"><span className="faint">Final pay</span><b>{d.finalPaySettled ? "Settled" : "—"}</b></div>
                  <div className="two-col"><span className="faint">Regulatory</span><b>{d.regulatoryNotified ? "Notified" : "—"}</b></div>
                </>
              )}
            </div>
          </div>

          {d.clawback.length > 0 ? (
            <div className="card" style={{ marginBottom: 16 }}>
              <div className="card-h"><h3>Sponsorship repayment</h3></div>
              <div className="card-pad">
                <div className="faint" style={{ fontSize: 12, marginBottom: 8 }}>
                  Derived live as of the last working day (Ops Manual G4.3). Crystallized on close.
                </div>
                {d.clawback.map((c) => {
                  const b = repaymentStatusBadge(c.repaymentStatus);
                  return (
                    <div className="ofb-preview" key={c.sponsorshipId} style={{ marginTop: 8 }}>
                      <div className="two-col"><b>{c.qualificationName}</b><span className={`b ${b.cls}`}>{b.label}</span></div>
                      <div className="two-col" style={{ marginTop: 6 }}>
                        <span className="faint">Committed</span><span className="num">{naira(c.committed)}</span>
                      </div>
                      <div className="two-col">
                        <span className="faint">Repayable</span>
                        <span className="num">{c.repaymentStatus === "PENDING" && c.repaymentAmount === null ? "COO review" : naira(c.repaymentAmount)}</span>
                      </div>
                      <div className="faint" style={{ fontSize: 12, marginTop: 6 }}>{c.reason}</div>
                    </div>
                  );
                })}
              </div>
            </div>
          ) : null}

          {canManage && !closed ? (
            <div className="card">
              <div className="card-h"><h3>Close the case</h3></div>
              <div className="card-pad">
                <CloseCaseControl employeeId={d.employee.id} accessRevoked={!!d.accessRevokedAt} />
              </div>
            </div>
          ) : null}

          {closed ? (
            <div className="card">
              <div className="card-pad">
                <div className="note" style={{ marginTop: 0 }}>
                  <span>✓</span>
                  <div>Closed {fmtDate(d.closedAt)} — {d.employee.name} marked exited. The staff file is retained per policy.</div>
                </div>
              </div>
            </div>
          ) : null}
        </div>
      </div>
    </>
  );
}
