import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
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
import CycleControls from "@/components/performance/CycleControls";

export const metadata = { title: "Performance · Transworld PeopleOps" };

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
  fmt: (a: Date | null, b: Date | null) => string | null;
}) {
  const [roster, goalsOverview] = await Promise.all([
    getRoster(selected.id),
    getGoalsOverview(selected.id),
  ]);
  const started = roster.filter((r) => r.appraisalId).length;
  const finalized = roster.filter((r) => r.status.key === "FINALIZED").length;
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
