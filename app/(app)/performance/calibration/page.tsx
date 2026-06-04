import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getDefaultCycle } from "@/lib/performance";
import { getCalibration } from "@/lib/calibration";
import { ratingBadge } from "@/lib/performance";
import { OpenCalibrationForm, CalibrationEntryForm, FinalizeCalibrationForm } from "@/components/performance/CalibrationControls";

export const metadata = { title: "Calibration · Transworld PeopleOps" };

function fmtMult(v: unknown): string {
  if (v === null || v === undefined) return "—";
  const n = Number(v);
  return Number.isFinite(n) ? `×${n.toFixed(2)}` : "—";
}
function fmtDate(d: Date | null) {
  return d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";
}

export default async function CalibrationPage() {
  const me = await requirePermission("performance.view");
  const canManage = hasPermission(me, "performance.manage");
  const cycle = await getDefaultCycle();
  const { session, entries } = cycle ? await getCalibration(cycle.id) : { session: null, entries: [] };
  const finalized = session?.status === "FINALIZED";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance" className="back-link">← Performance</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>Calibration</h1>
          <p>Confidential governance record (E4). Agreed ratings are written back to each appraisal on finalize.{cycle ? ` Cycle: ${cycle.name}.` : ""}</p>
        </div>
      </div>

      {!cycle ? (
        <div className="note"><span>ℹ</span><div>No performance cycle exists yet.</div></div>
      ) : !session ? (
        canManage ? (
          <div className="card">
            <div className="card-h"><h3>Open calibration</h3><span className="hint">generates the pack from submitted appraisals</span></div>
            <div className="card-pad"><OpenCalibrationForm cycleId={cycle.id} /></div>
          </div>
        ) : (
          <div className="note"><span>ℹ</span><div>No calibration session has been opened for this cycle.</div></div>
        )
      ) : (
        <>
          <div className="card" style={{ marginBottom: 18 }}>
            <div className="card-h">
              <h3>Session — {cycle.name}</h3>
              <span className={"b " + (finalized ? "b-grn" : "b-amb")}>{session.status}</span>
            </div>
            <div className="card-pad">
              <div className="kv">
                <div className="row"><span className="k">Chair</span><span className="v">{session.chairName ?? "—"}</span></div>
                <div className="row"><span className="k">Held</span><span className="v">{fmtDate(session.heldAt)}</span></div>
                {finalized ? <div className="row"><span className="k">Finalized</span><span className="v">{fmtDate(session.finalizedAt)} · {session.finalizedByName ?? "—"}</span></div> : null}
              </div>
              {canManage && !finalized ? (
                <div style={{ marginTop: 14 }}>
                  <OpenCalibrationForm cycleId={cycle.id} />
                </div>
              ) : null}
            </div>
          </div>

          <div className="card" style={{ marginBottom: 18 }}>
            <div className="card-h"><h3>Calibration pack</h3><span className="hint">{entries.length}</span></div>
            {entries.length === 0 ? (
              <div className="card-pad"><span className="faint">No entries yet. Generate the pack above.</span></div>
            ) : (
              <div className="card-pad">
                {entries.map((e) => {
                  const pb = ratingBadge(e.preliminaryRating);
                  return (
                    <div key={e.id} className="card" style={{ margin: 0, marginBottom: 10 }}>
                      <div className="card-h">
                        <h3 style={{ fontSize: 15 }}>
                          {e.employeeName} <span className="faint" style={{ fontWeight: 400 }}>· {e.grade ?? "—"} · {e.jobFamily ?? "—"}</span>
                        </h3>
                        <span className="faint" style={{ fontSize: 12.5 }}>
                          Preliminary: {pb ? <span className={"b " + pb.cls}>{pb.label}</span> : "—"} · {fmtMult(e.indicativeMultiplier)} · Mgr {e.managerName ?? "—"}
                        </span>
                      </div>
                      <div className="card-pad">
                        <CalibrationEntryForm
                          id={e.id}
                          disabled={finalized || !canManage}
                          defaults={{
                            calibratedRating: e.calibratedRating ?? "",
                            calibratedMultiplier: e.calibratedMultiplier === null || e.calibratedMultiplier === undefined ? "" : String(Number(e.calibratedMultiplier)),
                            integrityGate: e.integrityGate,
                            note: e.note ?? "",
                          }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>

          {canManage ? (
            <div className="card">
              <div className="card-h"><h3>Finalize</h3></div>
              <div className="card-pad"><FinalizeCalibrationForm sessionId={session.id} finalized={finalized} /></div>
            </div>
          ) : null}
        </>
      )}

      <div className="faint" style={{ fontSize: 11.5, marginTop: 14 }}>
        Calibration records are confidential and must not be shared with employees.
      </div>
    </>
  );
}
