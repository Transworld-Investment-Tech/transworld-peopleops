"use client";
import { useActionState, useState } from "react";
import {
  saveRuleAction,
  deleteRuleAction,
  autoAssignAction,
  type FormState,
  type AssignState,
} from "@/lib/lms-actions";
import { RULE_REQUIREMENTS, RULE_SCOPES, LMS_GRADES, requirementBadge, scopeLabel } from "@/lib/lms";

const EMPTY: FormState = { ok: false };
const EMPTY_ASSIGN: AssignState = { ok: false };

type MatrixRow = {
  id: string;
  moduleCode: string | null;
  moduleTitle: string;
  scope: string;
  grade: string | null;
  jobProfileTitle: string | null;
  requirement: string;
  active: boolean;
};

export default function MatrixManager({
  rules,
  modules,
  jobProfiles,
}: {
  rules: MatrixRow[];
  modules: { id: string; code: string | null; title: string }[];
  jobProfiles: { id: string; title: string; grade: string | null }[];
}) {
  const [state, formAction, pending] = useActionState(saveRuleAction, EMPTY);
  const [assign, assignAction, assigning] = useActionState(autoAssignAction, EMPTY_ASSIGN);
  const fe = state.fieldErrors ?? {};
  const [scope, setScope] = useState("ALL");

  return (
    <>
      <div className="card">
        <div className="card-h">
          <h3>Add a rule</h3>
          <span className="hint">target a module at everyone, a grade, or a role</span>
        </div>
        <div className="card-pad">
          <form action={formAction}>
            {state.error ? <div className="form-err">{state.error}</div> : null}
            <div className="form-grid">
              <div className="field full">
                <label>Module</label>
                <select name="moduleId" defaultValue="">
                  <option value="" disabled>
                    Choose a module…
                  </option>
                  {modules.map((m) => (
                    <option key={m.id} value={m.id}>
                      {m.code ? `${m.code} · ` : ""}
                      {m.title}
                    </option>
                  ))}
                </select>
                {fe.moduleId ? <span className="err">{fe.moduleId}</span> : null}
              </div>
              <div className="field">
                <label>Applies to</label>
                <select name="scope" value={scope} onChange={(e) => setScope(e.target.value)}>
                  {RULE_SCOPES.map((s) => (
                    <option key={s.value} value={s.value}>
                      {s.label}
                    </option>
                  ))}
                </select>
              </div>
              {scope === "GRADE" ? (
                <div className="field">
                  <label>Grade</label>
                  <select name="grade" defaultValue="">
                    <option value="" disabled>
                      Choose…
                    </option>
                    {LMS_GRADES.map((g) => (
                      <option key={g} value={g}>
                        {g}
                      </option>
                    ))}
                  </select>
                  {fe.grade ? <span className="err">{fe.grade}</span> : null}
                </div>
              ) : null}
              {scope === "JOB_PROFILE" ? (
                <div className="field">
                  <label>Role</label>
                  <select name="jobProfileId" defaultValue="">
                    <option value="" disabled>
                      Choose…
                    </option>
                    {jobProfiles.map((j) => (
                      <option key={j.id} value={j.id}>
                        {j.title}
                        {j.grade ? ` (${j.grade})` : ""}
                      </option>
                    ))}
                  </select>
                  {fe.jobProfileId ? <span className="err">{fe.jobProfileId}</span> : null}
                </div>
              ) : null}
              <div className="field">
                <label>Requirement</label>
                <select name="requirement" defaultValue="REQUIRED">
                  {RULE_REQUIREMENTS.map((r) => (
                    <option key={r.value} value={r.value}>
                      {r.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <div className="form-actions">
              <button className="btn btn-pri" disabled={pending}>
                {pending ? "Saving…" : "Add rule"}
              </button>
            </div>
          </form>
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Assignment matrix</h3>
          <span className="hint">
            {rules.length} rule{rules.length === 1 ? "" : "s"}
          </span>
        </div>
        <div className="card-pad">
          {rules.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>
              No rules yet.
            </p>
          ) : (
            <div className="doc-list">
              {rules.map((r) => {
                const badge = requirementBadge(r.requirement);
                const target =
                  r.scope === "ALL"
                    ? "All staff"
                    : r.scope === "GRADE"
                    ? `Grade ${r.grade}`
                    : r.jobProfileTitle ?? "Role";
                return (
                  <div className="row" key={r.id} style={{ justifyContent: "space-between" }}>
                    <div>
                      <strong>
                        {r.moduleCode ? `${r.moduleCode} · ` : ""}
                        {r.moduleTitle}
                      </strong>{" "}
                      <span className="b b-blu">{scopeLabel(r.scope)}</span> <span className="faint">{target}</span>{" "}
                      <span className={badge.cls}>{badge.label}</span>
                    </div>
                    <form action={deleteRuleAction}>
                      <input type="hidden" name="ruleId" value={r.id} />
                      <button className="btn btn-xs btn-danger">Remove</button>
                    </form>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      <div className="card">
        <div className="card-h">
          <h3>Auto-assign mandatory training</h3>
          <span className="hint">dry-run → commit</span>
        </div>
        <div className="card-pad">
          <p className="hint" style={{ marginTop: 0 }}>
            Creates assigned records for every mandatory module each person is required to hold this period.
            Preview first; nothing is written until you commit.
          </p>
          <form action={assignAction}>
            <div className="form-actions" style={{ gap: 8 }}>
              <button className="btn" name="mode" value="preview" disabled={assigning}>
                {assigning ? "Working…" : "Preview"}
              </button>
              <button className="btn btn-grn" name="mode" value="commit" disabled={assigning}>
                Commit
              </button>
            </div>
          </form>

          {assign.error ? <div className="form-err">{assign.error}</div> : null}
          {assign.ok && assign.mode === "commit" ? (
            <div className="note">Committed {assign.committed ?? 0} assignment(s).</div>
          ) : null}
          {assign.ok && assign.mode === "preview" ? (
            assign.preview && assign.preview.length > 0 ? (
              <div className="doc-list" style={{ marginTop: 12 }}>
                <p className="hint">{assign.preview.length} record(s) would be created:</p>
                {assign.preview.map((p, i) => (
                  <div className="row" key={i} style={{ justifyContent: "space-between" }}>
                    <span>
                      <strong>{p.name}</strong> <span className="faint">({p.eeId})</span>
                    </span>
                    <span className="faint">
                      {p.moduleCode ? `${p.moduleCode} · ` : ""}
                      {p.moduleTitle} <span className="mono">[{p.period}]</span>
                    </span>
                  </div>
                ))}
              </div>
            ) : (
              <div className="note" style={{ marginTop: 12 }}>
                Nothing to assign — everyone is up to date for this period.
              </div>
            )
          ) : null}
        </div>
      </div>
    </>
  );
}
