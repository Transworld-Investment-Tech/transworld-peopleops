import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getJobProfileDetail, jdStatusBadge, levelLabel, familyLabel, trackLabel, rungLabel, ladderStageFor } from "@/lib/jobframework";
import { getLatestDocument, prettySize } from "@/lib/documents";
import { storageConfigured } from "@/lib/storage";
import { empInitials, statusBadge } from "@/lib/employees";
import JobDescriptionCard from "@/components/jobcompetency/JobDescriptionCard";
import { getScorecard, scorecardStatusBadge } from "@/lib/scorecards";
import type { EmploymentStatus } from "@prisma/client";

export const metadata = { title: "Job profile · Transworld PeopleOps" };

export default async function JobProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const me = await requirePermission("jobframework.view");
  const canManage = hasPermission(me, "jobframework.manage");
  const { id } = await params;
  const p = await getJobProfileDetail(id);
  if (!p) notFound();
  const s = jdStatusBadge(p.status);
  const subtitle = [p.grade ? `Grade ${p.grade}` : null, p.department].filter(Boolean).join(" · ");
  const ladder = ladderStageFor(p.grade);

  const jd = await getLatestDocument("job_profile", p.id, "JOB_DESCRIPTION");
  const storageReady = storageConfigured();
  const jdView = jd
    ? {
        filename: jd.filename,
        sizeLabel: prettySize(jd.sizeBytes),
        uploadedAt: jd.createdAt.toLocaleDateString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
        }),
      }
    : null;

  const scorecard = await getScorecard(p.id);
  const scb = scorecard ? scorecardStatusBadge(scorecard.status) : null;

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/job-competency" className="back-link">
            ← Job &amp; Competency
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {p.title}
          </h1>
          <p>{subtitle || "Role definition"}</p>
        </div>
        {canManage && (
          <Link href={`/job-competency/${p.id}/edit`} className="btn btn-pri">
            Edit
          </Link>
        )}
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Overview</h3>
          <span className={"b " + s.cls}>
            <span className="dot" />
            {s.label}
          </span>
        </div>
        <div className="card-pad">
          <div className="grid kpis" style={{ marginBottom: 12 }}>
            <div className="kpi"><div className="lab">Family</div><div className="val" style={{ fontSize: 15 }}>{familyLabel(p.family)}{p.isControlFunction ? " · control fn" : ""}</div></div>
            <div className="kpi"><div className="lab">Track</div><div className="val" style={{ fontSize: 15 }}>{trackLabel(p.track)}</div></div>
            <div className="kpi"><div className="lab">Rung</div><div className="val" style={{ fontSize: 15 }}>{rungLabel(p.rung)}</div></div>
            <div className="kpi"><div className="lab">Growth stage</div><div className="val" style={{ fontSize: 15 }}>{ladder ? ladder.stage : "—"}</div></div>
          </div>
          {ladder ? <p className="hint" style={{ marginTop: 0, marginBottom: 10 }}>{ladder.grade} · {ladder.summary}</p> : null}
          {p.description ? (
            <p className="jc-desc">{p.description}</p>
          ) : (
            <p className="faint">No description.</p>
          )}
        </div>
      </div>

      <JobDescriptionCard
        profileId={p.id}
        canManage={canManage}
        doc={jdView}
        storageReady={storageReady}
      />

      <div className="card mt">
        <div className="card-h">
          <h3>Required competencies</h3>
          <span className="hint">{p.competencies.length}</span>
        </div>
        <div className="card-pad">
          {p.competencies.length === 0 ? (
            <p className="faint">None defined.</p>
          ) : (
            <div className="jc-reqs">
              {p.competencies.map((c) => (
                <span className="jc-req" key={c.id}>
                  <span className="jc-req-name">{c.name}</span>
                  <span className="jc-req-lvl">{levelLabel(c.level)}</span>
                </span>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Behaviors (firm-wide)</h3>
          <span className="hint">{p.behaviors.length}</span>
        </div>
        <div className="card-pad">
          {p.behaviors.length === 0 ? (
            <p className="faint">No behaviors attached.</p>
          ) : (
            <div className="jc-reqs" style={{ flexDirection: "column", gap: 8 }}>
              {p.behaviors.map((bh) => (
                <div key={bh.id}>
                  <span className="jc-req-name"><b>{bh.name}</b></span>
                  {bh.definition ? <div className="faint" style={{ fontSize: 13 }}>{bh.definition}</div> : null}
                </div>
              ))}
            </div>
          )}
          <p className="hint" style={{ marginTop: 10 }}>
            The six behaviors apply to every role and are scored alongside competencies at the annual review.
          </p>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Scorecard</h3>
          <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
            {scb ? (
              <span className={"b " + scb.cls}>
                <span className="dot" />
                {scb.label}
              </span>
            ) : null}
            {canManage ? (
              <Link href={`/job-competency/${p.id}/scorecard/edit`} className="btn">
                {scorecard ? "Edit scorecard" : "Create scorecard"}
              </Link>
            ) : null}
          </div>
        </div>
        <div className="card-pad">
          {!scorecard ? (
            <p className="faint">No scorecard yet.</p>
          ) : (
            <>
              {scorecard.mission ? <p className="sc-mission">{scorecard.mission}</p> : null}
              {scorecard.outcomes.length === 0 ? (
                <p className="faint">No outcomes defined.</p>
              ) : (
                <ol className="sc-outcomes">
                  {scorecard.outcomes.map((o) => (
                    <li className="sc-outcome" key={o.id}>
                      <div className="sc-o-head">
                        <span className="sc-o-title">{o.title}</span>
                        {o.weight !== null ? <span className="sc-o-weight">{o.weight}%</span> : null}
                      </div>
                      {o.measure ? <div className="sc-o-measure">{o.measure}</div> : null}
                    </li>
                  ))}
                </ol>
              )}
            </>
          )}
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Staff in this role</h3>
          <span className="hint">{p.employees.length}</span>
        </div>
        <div className="card-pad">
          {p.employees.length === 0 ? (
            <p className="faint">No active staff hold this profile.</p>
          ) : (
            <div className="jc-people">
              {p.employees.map((e) => {
                const es = statusBadge(e.status as EmploymentStatus);
                return (
                  <Link href={`/employees/${e.id}`} className="emp emp-link" key={e.id}>
                    <span className="chip">{empInitials(e.fullName)}</span>
                    <span>
                      <span className="nm">{e.fullName}</span>
                      <span className="rl">
                        {e.eeId} · <span className={"b " + es.cls}>{es.label}</span>
                      </span>
                    </span>
                  </Link>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </>
  );
}
