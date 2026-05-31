import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getHandbook, pct } from "@/lib/learning";
import LearningTabs from "@/components/learning/LearningTabs";
import MarkdownView from "@/components/learning/MarkdownView";
import { AcknowledgeButton, RecordAckButton } from "@/components/learning/HandbookActions";

export const metadata = { title: "Employee handbook · Transworld PeopleOps" };

export default async function HandbookPage() {
  const me = await requirePermission("learning.view");
  const canManage = hasPermission(me, "learning.manage");
  const hb = await getHandbook(me.id);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Employee handbook</h1>
          <p>Read the current handbook and acknowledge it. Acknowledgments are recorded in the audit log.</p>
        </div>
        {canManage ? (
          <Link href="/learning/handbook/edit" className="btn">
            {hb.current ? "Edit / new version" : "Create handbook"}
          </Link>
        ) : null}
      </div>

      <LearningTabs active="handbook" />

      {!hb.current ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No handbook published yet.</b>{" "}
                {canManage ? "Create one to make it available for staff to read and acknowledge." : "Check back soon."}
              </div>
            </div>
          </div>
        </div>
      ) : (
        <>
          <div className="card">
            <div className="card-h">
              <h3>
                {hb.current.title} · v{hb.current.version}
              </h3>
              {hb.current.effectiveDate ? (
                <span className="hint">
                  effective {hb.current.effectiveDate.toLocaleDateString("en-US")}
                </span>
              ) : null}
            </div>
            <div className="card-pad">
              {hb.current.summary ? (
                <p className="faint" style={{ marginTop: 0, fontSize: 15 }}>
                  {hb.current.summary}
                </p>
              ) : null}
              <MarkdownView source={hb.current.body} />
              <div style={{ marginTop: 18 }}>
                <AcknowledgeButton
                  policyId={hb.current.id}
                  acknowledged={hb.myAck.acknowledged}
                  linked={hb.myAck.linked}
                />
              </div>
            </div>
          </div>

          {canManage ? (
            <div className="card mt">
              <div className="card-h">
                <h3>Acknowledgment tracker</h3>
                <span className="hint">
                  {hb.ack.acknowledged}/{hb.ack.total} ({pct(hb.ack.acknowledged, hb.ack.total)}%)
                </span>
              </div>
              <div className="card-pad">
                <div className="bar" style={{ marginBottom: 14 }}>
                  <i style={{ width: `${pct(hb.ack.acknowledged, hb.ack.total)}%` }} />
                </div>
                {hb.ack.pending.length === 0 ? (
                  <p className="faint" style={{ marginTop: 0 }}>
                    Everyone has acknowledged the current version.
                  </p>
                ) : (
                  <>
                    <p className="faint" style={{ marginTop: 0 }}>
                      Pending acknowledgment:
                    </p>
                    <table>
                      <thead>
                        <tr>
                          <th>Employee</th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {hb.ack.pending.map((p) => (
                          <tr key={p.eeId}>
                            <td>
                              {p.name}
                              <div className="faint mono">{p.eeId}</div>
                            </td>
                            <td>
                              <RecordAckButton policyId={hb.current!.id} employeeId={p.id} />
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                    <p className="faint" style={{ fontSize: 12 }}>
                      Recording on behalf is for staff without a portal login yet; once logins arrive
                      staff acknowledge it themselves.
                    </p>
                  </>
                )}
              </div>
            </div>
          ) : null}
        </>
      )}
    </>
  );
}
