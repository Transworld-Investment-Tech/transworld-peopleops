import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getCompensationPositioning,
  getPendingRequestCount,
  fmtNaira,
  CR_PRIORITISE,
} from "@/lib/compensation";
import { bandFlagBadge } from "@/lib/raise-cycle";
import CompTabs from "@/components/compensation/CompTabs";

export const metadata = { title: "Pay positioning · Transworld PeopleOps" };

/** Compa-ratio shown to two decimals; the COO-awareness chip is the signal of
 * record for the > threshold rule. */
function fmtCR(cr: number | null): string {
  if (cr === null) return "—";
  return cr.toFixed(2);
}

export default async function PositioningPage() {
  await requirePermission("compensation.view");

  const [pos, pendingCount] = await Promise.all([
    getCompensationPositioning(),
    getPendingRequestCount(),
  ]);

  const { rows, gradeSummaries, cooAware, ungraded, unprofiled, crThreshold } = pos;
  const positionedCount = rows.filter((r) => r.monthlyGross !== null && r.band).length;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Pay positioning</h1>
          <p>
            Where each person sits against their grade band, and their compa-ratio
            (monthly gross ÷ grade midpoint). Awareness only — it doesn’t change
            anyone’s pay. Monthly gross is basic + utility, the same basis the
            bands are set on.
          </p>
        </div>
      </div>

      <CompTabs active="positioning" pendingCount={pendingCount} />

      {cooAware.length ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>⚠</span>
              <div>
                <b>
                  {cooAware.length} {cooAware.length === 1 ? "person is" : "people are"} above a{" "}
                  {crThreshold.toFixed(2)} compa-ratio
                </b>{" "}
                — surfaced for COO awareness (Ops Manual B1.3).{" "}
                {cooAware.map((r, i) => (
                  <span key={r.employeeId}>
                    {i > 0 ? ", " : ""}
                    <Link href={`/compensation/${r.employeeId}`} className="jc-link">
                      {r.name}
                    </Link>{" "}
                    ({fmtCR(r.compaRatio)})
                  </span>
                ))}
                .
              </div>
            </div>
          </div>
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>By grade</h3>
          <span className="hint">
            {positionedCount} positioned · {gradeSummaries.length} band
            {gradeSummaries.length === 1 ? "" : "s"}
          </span>
        </div>
        <div className="card-pad">
          {gradeSummaries.length === 0 ? (
            <div className="note">
              <span>ℹ</span>
              <div>
                No salary bands defined yet — set the grade structure under Salary
                bands.
              </div>
            </div>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Grade</th>
                  <th>Band</th>
                  <th className="num">Min</th>
                  <th className="num">Midpoint</th>
                  <th className="num">Max</th>
                  <th className="num">Staff</th>
                  <th className="num">Avg CR</th>
                  <th className="num">Above mid</th>
                  <th className="num">Above max</th>
                  <th className="num">Below min</th>
                </tr>
              </thead>
              <tbody>
                {gradeSummaries.map((g) => (
                  <tr key={g.grade}>
                    <td className="mono">{g.grade}</td>
                    <td>{g.label}</td>
                    <td className="num mono">{fmtNaira(g.band.min)}</td>
                    <td className="num mono">{fmtNaira(g.band.midpoint)}</td>
                    <td className="num mono">{fmtNaira(g.band.max)}</td>
                    <td className="num">{g.positioned}</td>
                    <td className="num mono">{fmtCR(g.avgCompaRatio)}</td>
                    <td className="num">{g.aboveMid || "—"}</td>
                    <td className="num">{g.aboveMax || "—"}</td>
                    <td className="num">{g.belowMin || "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>By employee</h3>
          <span className="hint">{rows.length} non-exited staff</span>
        </div>
        <p className="faint" style={{ margin: "0 16px 4px" }}>
          Compa-ratio and band position are on the fully-loaded, FTE-normalized basis
          (monthly gross × 17 ÷ 12 ÷ FTE) against the fully-loaded bands. Amber flags a CR below{" "}
          {CR_PRIORITISE.toFixed(2)} (prioritize at the next raise); a “Below min” position should be escalated to the COO.
        </p>
        <div className="card-pad">
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Grade</th>
                <th className="num">Monthly gross</th>
                <th className="num">Band (min · mid · max)</th>
                <th className="num">CR</th>
                <th>Position</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const fb = r.bandFlag ? bandFlagBadge(r.bandFlag) : null;
                return (
                  <tr key={r.employeeId}>
                    <td>
                      <Link href={`/compensation/${r.employeeId}`} className="jc-link">
                        {r.name}
                      </Link>
                      <div className="faint mono">{r.eeId}</div>
                    </td>
                    <td>{r.grade ?? "—"}</td>
                    <td className="num mono">
                      {r.hasProfile ? fmtNaira(r.monthlyGross) : "—"}
                    </td>
                    <td className="num mono">
                      {r.band ? (
                        <span className="faint">
                          {fmtNaira(r.band.min)} · {fmtNaira(r.band.midpoint)} ·{" "}
                          {fmtNaira(r.band.max)}
                        </span>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td className="num mono">
                      {fmtCR(r.compaRatio)}
                      {r.cooAware ? (
                        <span className="b b-red" style={{ marginLeft: 6 }}>
                          Above {crThreshold.toFixed(2)}
                        </span>
                      ) : null}
                      {r.prioritise ? (
                        <span className="b b-amb" style={{ marginLeft: 6 }}>
                          Below {CR_PRIORITISE.toFixed(2)}
                        </span>
                      ) : null}
                    </td>
                    <td>
                      {fb ? (
                        <span className={`b ${fb.cls}`}>{fb.label}</span>
                      ) : !r.hasProfile ? (
                        <span className="b b-gry">No profile</span>
                      ) : (
                        <span className="b b-gry">No band</span>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {ungraded.length || unprofiled.length ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                {unprofiled.length ? (
                  <>
                    <b>{unprofiled.length}</b> without a compensation profile (no
                    gross to position).{" "}
                  </>
                ) : null}
                {ungraded.length ? (
                  <>
                    <b>{ungraded.length}</b> profiled but not matched to a grade
                    band — no position or compa-ratio shown.
                  </>
                ) : null}
              </div>
            </div>
          </div>
        </div>
      ) : null}
    </>
  );
}
