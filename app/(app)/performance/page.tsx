import Link from "next/link";
import { requirePermission, hasPermission, isOversight } from "@/lib/auth/rbac";
import {
  getCycles,
  getCycle,
  getDefaultCycle,
  getRoster,
  CYCLE_STAGES,
  CYCLE_STATUSES,
  stageIndex,
  ratingBadge,
} from "@/lib/performance";
import { getGoalsOverview } from "@/lib/performance-toolkit";
import { multiplierFor } from "@/lib/scorecard-scoring";
import { getGoalSettingRoster, reviewStateBadge, myEmployeeLite, getDirectReports } from "@/lib/goal-agreement";
import CycleControls from "@/components/performance/CycleControls";

export const metadata = { title: "Performance · Transworld PeopleOps" };

// Canonical multiplier bands (Handbook 12.3 / Ops Manual) — the labels for the
// calibration roll-up. The multiplier values match lib/scorecard-scoring#multiplierFor.
const CALIB_BANDS = [
  { label: "4.5 – 5.0", mult: 1.3 },
  { label: "4.0 – 4.4", mult: 1.15 },
  { label: "3.5 – 3.9", mult: 1.0 },
  { label: "3.0 – 3.4", mult: 0.8 },
  { label: "2.0 – 2.9", mult: 0.5 },
  { label: "below 2.0", mult: 0.0 },
] as const;

function fmtRange(start: Date | null, end: Date | null): string | null {
  const o: Intl.DateTimeFormatOptions = { month: "short", day: "numeric", year: "numeric" };
  if (start && end)
    return `${start.toLocaleDateString("en-US", { month: "short", day: "numeric" })} – ${end.toLocaleDateString("en-US", o)}`;
  if (start) return start.toLocaleDateString("en-US", o);
  if (end) return end.toLocaleDateString("en-US", o);
  return null;
}

export default async function PerformancePage({
  searchParams,
}: {
  searchParams: Promise<{ cycle?: string }>;
}) {
  const me = await requirePermission("performance.view");
  const canManage = hasPermission(me, "performance.manage");
  const canSelf = hasPermission(me, "performance.self");
  const oversight = isOversight(me);
  let visibleIds: Set<string> | null = null;
  if (!oversight) {
    const meEmp = await myEmployeeLite(me.id);
    const reports = meEmp ? await getDirectReports(meEmp.id) : [];
    visibleIds = new Set(reports.map((r) => r.id));
  }
  const { cycle: cycleParam } = await searchParams;

  const cycles = await getCycles();
  const selected =
    (cycleParam ? await getCycle(cycleParam) : null) ?? (await getDefaultCycle());

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Performance &amp; Development</h1>
          <p>
            Goals and KPIs drawn from each role, scored on a cycle, with development
            plans and improvement plans where needed.
          </p>
        </div>
        {canManage ? (
          <Link href="/performance/new" className="btn btn-pri">
            Open review cycle
          </Link>
        ) : null}
      </div>

      {/* Toolkit */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Toolkit</h3>
          <span className="hint">goal-setting · weekly reporting · development · improvement</span>
        </div>
        <div className="card-pad">
          <div style={{ display: "grid", gridTemplateColumns: "repeat(2, minmax(0, 1fr))", gap: 14 }}>
            <div className="card" style={{ margin: 0 }}>
              <div className="card-pad">
                <div className="appr-sub">Goal-setting</div>
                <p className="faint" style={{ marginTop: 0 }}>
                  Staff draft their own goals in My Performance and submit them; line managers review,
                  agree, and seal them in My Team.
                </p>
              </div>
            </div>
            <div className="card" style={{ margin: 0 }}>
              <div className="card-pad">
                <div className="appr-sub">Weekly reporting</div>
                <p className="faint" style={{ marginTop: 0 }}>
                  Staff file weekly check-ins in My Performance.
                </p>
                {canSelf ? (
                  <Link href="/my-performance" className="jc-link">
                    Go to My Performance →
                  </Link>
                ) : null}
              </div>
            </div>
            <div className="card" style={{ margin: 0 }}>
              <div className="card-pad">
                <div className="appr-sub">Development plan</div>
                <p className="faint" style={{ marginTop: 0 }}>
                  Trackable development objectives live on each person’s scorecard, beside the appraisal.
                </p>
              </div>
            </div>
            <div className="card" style={{ margin: 0 }}>
              <div className="card-pad">
                <div className="appr-sub">Improvement plan (PIP)</div>
                <p className="faint" style={{ marginTop: 0 }}>
                  Formal improvement plans with expectations, review dates, and staff acknowledgment.
                </p>
                {canManage ? (
                  <Link href="/performance/pip" className="jc-link">
                    Open the PIP workspace →
                  </Link>
                ) : null}
              </div>
            </div>
          </div>
        </div>
      </div>

      {!selected ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No review cycle yet.</b>
                {canManage
                  ? " Use “Open review cycle” to start the first one (e.g. H2 2026, stage Goal setting). Each appraisable employee then gets a scorecard seeded from their role, and you can set their goals."
                  : " Ask an HR admin to open the first review cycle."}
              </div>
            </div>
          </div>
        </div>
      ) : (
        <PerformanceCycle
          selected={selected}
          cycles={cycles}
          canManage={canManage}
          visibleIds={visibleIds}
          fmt={fmtRange}
        />
      )}
    </>
  );
}

async function PerformanceCycle({
  selected,
  cycles,
  canManage,
  visibleIds,
  fmt,
}: {
  selected: {
    id: string;
    name: string;
    stage: string;
    status: string;
    periodStart: Date | null;
    periodEnd: Date | null;
  };
  cycles: { id: string; name: string; status: string }[];
  canManage: boolean;
  visibleIds: Set<string> | null;
  fmt: (a: Date | null, b: Date | null) => string | null;
}) {
  const [rosterAll, goalsOverview] = await Promise.all([
    getRoster(selected.id),
    getGoalsOverview(selected.id),
  ]);
  const roster = visibleIds ? rosterAll.filter((r) => visibleIds.has(r.employeeId)) : rosterAll;
  const goalSetting = canManage ? await getGoalSettingRoster(selected.id) : null;
  const started = roster.filter((r) => r.appraisalId).length;
  const finalized = roster.filter((r) => r.status.key === "FINALIZED").length;

  // Calibration roll-up (read-only) from the saved overall ratings of finalized
  // appraisals, mapped to the canonical multiplier bands.
  const ratedRows = roster.filter(
    (r) =>
      r.status.key === "FINALIZED" &&
      r.overallRating != null &&
      !Number.isNaN(parseFloat(r.overallRating)),
  );
  const ratedVals = ratedRows.map((r) => parseFloat(r.overallRating as string));
  const avgRating = ratedVals.length
    ? ratedVals.reduce((a, b) => a + b, 0) / ratedVals.length
    : null;
  const avgMultiplier = ratedVals.length
    ? ratedVals.reduce((a, b) => a + multiplierFor(b), 0) / ratedVals.length
    : null;
  const bandRows = CALIB_BANDS.map((band) => ({
    label: band.label,
    mult: band.mult,
    count: ratedVals.filter((v) => multiplierFor(v) === band.mult).length,
  }));
  const calStatus = {
    notStarted: roster.filter((r) => r.status.key === "NOT_STARTED").length,
    inProgress: roster.filter((r) => r.status.key === "IN_PROGRESS").length,
    selfSubmitted: roster.filter((r) => r.status.key === "SELF_SUBMITTED").length,
    finalized,
  };
  const gradeMap = new Map<string, { count: number; sum: number }>();
  for (const r of ratedRows) {
    const key = r.grade ?? "—";
    const e = gradeMap.get(key) ?? { count: 0, sum: 0 };
    e.count += 1;
    e.sum += parseFloat(r.overallRating as string);
    gradeMap.set(key, e);
  }
  const gradeRows = [...gradeMap.entries()]
    .map(([grade, e]) => ({ grade, count: e.count, avg: e.sum / e.count }))
    .sort((a, b) => a.grade.localeCompare(b.grade));
  const goalsByEmp = new Map(goalsOverview.map((g) => [g.employeeId, g] as const));
  const cur = stageIndex(selected.stage);
  const range = fmt(selected.periodStart, selected.periodEnd);

  return (
    <>
      {cycles.length > 1 ? (
        <div className="cyc-tabs">
          {cycles.map((c) => (
            <Link
              key={c.id}
              href={`/performance?cycle=${c.id}`}
              className={"cyc-tab" + (c.id === selected.id ? " active" : "")}
            >
              {c.name}
              {c.status === "CLOSED" ? <span className="faint"> · closed</span> : null}
            </Link>
          ))}
        </div>
      ) : null}

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="pipe">
          {CYCLE_STAGES.map((s, i) => {
            const cls = i < cur ? "step done" : i === cur ? "step cur" : "step";
            return (
              <div className="pipe-seg" key={s.value}>
                <div className={cls}>
                  <span className="num">{i < cur ? "✓" : i + 1}</span>
                  {s.label}
                </div>
                {i < CYCLE_STAGES.length - 1 ? (
                  <span className={"ln" + (i < cur ? " done" : "")} />
                ) : null}
              </div>
            );
          })}
        </div>
        <div className="card-pad cyc-meta">
          <span className="hint">
            {selected.name}
            {range ? ` · ${range}` : ""} · {started} of {roster.length} appraisals started
            {finalized ? ` · ${finalized} finalized` : ""}
            {selected.status === "CLOSED" ? " · cycle closed" : ""}
          </span>
          {canManage ? (
            <CycleControls
              cycle={{ id: selected.id, name: selected.name, stage: selected.stage, status: selected.status }}
              stages={CYCLE_STAGES.map((s) => ({ value: s.value, label: s.label }))}
              statuses={CYCLE_STATUSES.map((s) => ({ value: s.value, label: s.label }))}
            />
          ) : null}
        </div>
      </div>

      {goalSetting ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Goal-setting status — {selected.name}</h3>
            <span className="hint">
              {goalSetting.counts.approved} of {goalSetting.counts.total} agreed &amp; sealed
            </span>
          </div>
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              How goal-setting is progressing across the firm. Staff draft and submit; line managers
              review, agree, and seal. This view is read-only — agreement and sign-off happen between
              each person and their line manager.
            </p>

            <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginBottom: 6 }}>
              <span className="b b-gry">Not started {goalSetting.counts.notStarted}</span>
              <span className="b b-gry">Draft {goalSetting.counts.draft}</span>
              <span className="b b-blu">Submitted {goalSetting.counts.submitted}</span>
              <span className="b b-amb">Changes requested {goalSetting.counts.changes}</span>
              <span className="b b-grn">Approved &amp; sealed {goalSetting.counts.approved}</span>
              <span className="b b-grn">Acknowledged {goalSetting.counts.acknowledged}</span>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Line manager</th>
                <th>Goals</th>
                <th>Acknowledged</th>
                <th>Amendments</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {goalSetting.rows.map((r) => {
                const sb = reviewStateBadge(r.reviewState);
                return (
                  <tr key={r.employeeId}>
                    <td>{r.name}</td>
                    <td>{r.managerName ?? <span className="faint">— unset</span>}</td>
                    <td className="mono">{r.goalCount}</td>
                    <td>
                      {r.reviewState === "APPROVED" ? (
                        r.acknowledged ? (
                          <span className="b b-grn">Yes</span>
                        ) : (
                          <span className="b b-amb">Pending</span>
                        )
                      ) : (
                        <span className="faint">—</span>
                      )}
                    </td>
                    <td className="mono">{r.amendmentCount > 0 ? r.amendmentCount : <span className="faint">—</span>}</td>
                    <td>
                      <span className={"b " + sb.cls}>
                        <span className="dot" />
                        {sb.label}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : null}

      {canManage ? (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-h">
            <h3>Calibration — {selected.name}</h3>
            <span className="hint">
              {finalized} of {roster.length} finalized
            </span>
          </div>
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              A read-only roll-up of the saved overall ratings across this cycle, mapped to the
              canonical multiplier bands — for committee calibration before finalizing. The
              integrity gate (a 1 on Integrity Above All or Compliance by Default) can still force
              ×0 at bonus build.
            </p>

            <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginBottom: 12 }}>
              <span className="b b-gry">Not started {calStatus.notStarted}</span>
              <span className="b b-amb">In progress {calStatus.inProgress}</span>
              <span className="b b-blu">Self submitted {calStatus.selfSubmitted}</span>
              <span className="b b-grn">Finalized {calStatus.finalized}</span>
            </div>

            {ratedVals.length === 0 ? (
              <div className="note">
                <span>ℹ</span>
                <div>No finalized appraisals to calibrate yet.</div>
              </div>
            ) : (
              <>
                <div className="grid kpis" style={{ marginBottom: 12 }}>
                  <div className="card kpi">
                    <div className="lab">Average overall</div>
                    <div className="val">{avgRating!.toFixed(2)}</div>
                  </div>
                  <div className="card kpi">
                    <div className="lab">Implied avg multiplier</div>
                    <div className="val">×{avgMultiplier!.toFixed(2)}</div>
                  </div>
                </div>

                <table>
                  <thead>
                    <tr>
                      <th>Score band</th>
                      <th>Multiplier</th>
                      <th className="num">Finalized</th>
                    </tr>
                  </thead>
                  <tbody>
                    {bandRows.map((b) => (
                      <tr key={b.label}>
                        <td>{b.label}</td>
                        <td className="mono">×{b.mult.toFixed(2)}</td>
                        <td className="num mono">
                          {b.count || <span className="faint">—</span>}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>

                {gradeRows.length ? (
                  <>
                    <div className="sec-t mt">By grade</div>
                    <table>
                      <thead>
                        <tr>
                          <th>Grade</th>
                          <th className="num">Finalized</th>
                          <th className="num">Avg overall</th>
                        </tr>
                      </thead>
                      <tbody>
                        {gradeRows.map((g) => (
                          <tr key={g.grade}>
                            <td className="mono">{g.grade}</td>
                            <td className="num mono">{g.count}</td>
                            <td className="num mono">{g.avg.toFixed(2)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </>
                ) : null}
              </>
            )}
          </div>
        </div>
      ) : null}

      <div className="card">
        <div className="card-h">
          <h3>Appraisals — {selected.name}</h3>
          <span className="hint">scorecards drawn from each role</span>
        </div>
        {roster.length === 0 ? (
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No appraisable staff.</b> Appraisals cover active staff whose role
                has a <b>published scorecard</b>. Publish role scorecards in Job &amp;
                Competency to populate this list.
              </div>
            </div>
          </div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Employee</th>
                <th>Role</th>
                <th>Grade</th>
                <th>Goals</th>
                <th>Overall</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {roster.map((r) => {
                const rb = ratingBadge(r.overallRating);
                const g = goalsByEmp.get(r.employeeId);
                return (
                  <tr key={r.employeeId}>
                    <td>
                      <Link
                        href={`/performance/${selected.id}/${r.employeeId}`}
                        className="jc-link"
                      >
                        {r.name}
                      </Link>
                    </td>
                    <td>{r.role ?? "—"}</td>
                    <td className="mono">{r.grade ?? "—"}</td>
                    <td>
                      {g && g.total > 0 ? (
                        <span className="faint">{g.total} set</span>
                      ) : (
                        <span className="faint">—</span>
                      )}
                    </td>
                    <td>{rb ? <span className={"b " + rb.cls}>{rb.label}</span> : <span className="faint">—</span>}</td>
                    <td>
                      <span className={"b " + r.status.cls}>
                        <span className="dot" />
                        {r.status.label}
                      </span>
                    </td>
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
