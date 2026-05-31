"use client";
import { useActionState, useState } from "react";
import {
  startAppraisalAction,
  saveSelfAction,
  saveReviewAction,
  unsubmitSelfAction,
  type FormState,
} from "@/lib/performance-actions";

const EMPTY: FormState = { ok: false };

type ItemView = {
  id: string;
  kind: string;
  position: number;
  label: string;
  measure: string | null;
  target: string | null;
  weight: number | null;
  expectedLevel: number | null;
  selfActual: string | null;
  selfRating: string | null;
  selfLevel: number | null;
  selfNote: string | null;
  actual: string | null;
  rating: string | null;
  assessedLevel: number | null;
  managerNote: string | null;
};

type Appraisal = {
  id: string;
  selfStatus: string;
  selfSummary: string | null;
  managerStatus: string;
  managerSummary: string | null;
  developmentPlan: string | null;
  overallRating: string | null;
  items: ItemView[];
};

type Row = {
  id: string;
  kind: string;
  label: string;
  measure: string | null;
  weight: number | null;
  expectedLevel: number | null;
  selfActual: string;
  selfRating: string;
  selfLevel: string;
  selfNote: string;
  target: string;
  actual: string;
  rating: string;
  assessedLevel: string;
  managerNote: string;
};

function toRow(it: ItemView): Row {
  return {
    id: it.id,
    kind: it.kind,
    label: it.label,
    measure: it.measure,
    weight: it.weight,
    expectedLevel: it.expectedLevel,
    selfActual: it.selfActual ?? "",
    selfRating: it.selfRating ?? "",
    selfLevel: it.selfLevel === null || it.selfLevel === undefined ? "" : String(it.selfLevel),
    selfNote: it.selfNote ?? "",
    target: it.target ?? "",
    actual: it.actual ?? "",
    rating: it.rating ?? "",
    assessedLevel:
      it.assessedLevel === null || it.assessedLevel === undefined ? "" : String(it.assessedLevel),
    managerNote: it.managerNote ?? "",
  };
}

export default function AppraisalEditor({
  cycleId,
  employeeId,
  cycleStatus,
  canManage,
  appraisal,
  ratings,
  levels,
}: {
  cycleId: string;
  employeeId: string;
  cycleStatus: string;
  canManage: boolean;
  appraisal: Appraisal | null;
  ratings: { value: string; label: string }[];
  levels: { value: number; label: string }[];
}) {
  // All hooks are declared unconditionally (Rules of Hooks); the not-started
  // branch returns afterwards. The rows initializer guards the null appraisal.
  const [startState, startAction, startPending] = useActionState(startAppraisalAction, EMPTY);
  const [rows, setRows] = useState<Row[]>(() => (appraisal ? appraisal.items.map(toRow) : []));
  const [selfState, selfAction, selfPending] = useActionState(saveSelfAction, EMPTY);
  const [reviewState, reviewAction, reviewPending] = useActionState(saveReviewAction, EMPTY);
  const [unsubState, unsubAction, unsubPending] = useActionState(unsubmitSelfAction, EMPTY);

  // ---- Not started -------------------------------------------------------
  if (!appraisal) {
    return (
      <div className="card">
        <div className="card-pad">
          <div className="note">
            <span>ℹ</span>
            <div>
              <b>Appraisal not started.</b> Starting it seeds the scoring grid from this
              role’s published scorecard outcomes and required competencies.
            </div>
          </div>
          {startState.error ? <div className="form-err" style={{ marginTop: 10 }}>{startState.error}</div> : null}
          {canManage ? (
            <form action={startAction} style={{ marginTop: 12 }}>
              <input type="hidden" name="cycleId" value={cycleId} />
              <input type="hidden" name="employeeId" value={employeeId} />
              <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={startPending}>
                {startPending ? "Starting…" : "Start appraisal"}
              </button>
            </form>
          ) : (
            <p className="faint" style={{ marginTop: 12 }}>An HR admin will start this appraisal.</p>
          )}
        </div>
      </div>
    );
  }

  // ---- Started -----------------------------------------------------------
  const selfSubmitted = appraisal.selfStatus === "SUBMITTED";
  const managerSubmitted = appraisal.managerStatus === "SUBMITTED";

  function update(id: string, patch: Partial<Row>) {
    setRows((rs) => rs.map((r) => (r.id === id ? { ...r, ...patch } : r)));
  }

  const selfPayload = JSON.stringify(
    rows.map((r) => ({
      id: r.id,
      selfActual: r.selfActual,
      selfRating: r.kind === "OUTCOME" ? r.selfRating : "",
      selfLevel: r.kind === "COMPETENCY" ? r.selfLevel : "",
      selfNote: r.selfNote,
    }))
  );
  const reviewPayload = JSON.stringify(
    rows.map((r) => ({
      id: r.id,
      target: r.kind === "OUTCOME" ? r.target : "",
      actual: r.actual,
      rating: r.kind === "OUTCOME" ? r.rating : "",
      assessedLevel: r.kind === "COMPETENCY" ? r.assessedLevel : "",
      managerNote: r.managerNote,
    }))
  );

  const outcomes = rows.filter((r) => r.kind === "OUTCOME");
  const competencies = rows.filter((r) => r.kind === "COMPETENCY");

  const ratingLabel = (v: string) => ratings.find((x) => x.value === v)?.label ?? v;
  const levelLabelOf = (v: string) =>
    v === "" ? "—" : levels.find((x) => String(x.value) === v)?.label ?? v;

  // read-only viewer for users without manage
  const readOnly = !canManage;

  return (
    <>
      {/* ---------------- Self-assessment ---------------- */}
      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h">
          <h3>Self-assessment</h3>
          <span className={"b " + (selfSubmitted ? "b-grn" : "b-amb")}>
            <span className="dot" />
            {selfSubmitted ? "Submitted" : "Pending"}
          </span>
        </div>

        {readOnly || selfSubmitted ? (
          <div className="card-pad">
            <ul className="appr-list">
              {rows.map((r) => (
                <li className="appr-ro" key={r.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kind">{r.kind === "OUTCOME" ? "KRA" : "Competency"}</span>
                    <span className="appr-kra">{r.label}</span>
                  </div>
                  <div className="appr-ro-b">
                    {r.kind === "OUTCOME" ? (
                      <>
                        <span>Self: {r.selfActual || "—"}</span>
                        {r.selfRating ? <span className="b b-gry">{ratingLabel(r.selfRating)}</span> : null}
                      </>
                    ) : (
                      <span>Self level: {levelLabelOf(r.selfLevel)}</span>
                    )}
                  </div>
                  {r.selfNote ? <div className="appr-note">{r.selfNote}</div> : null}
                </li>
              ))}
            </ul>
            {appraisal.selfSummary ? (
              <p className="sc-mission" style={{ marginTop: 10 }}>{appraisal.selfSummary}</p>
            ) : null}
            {canManage && selfSubmitted ? (
              <form action={unsubAction} style={{ marginTop: 12 }}>
                <input type="hidden" name="appraisalId" value={appraisal.id} />
                <button type="submit" className="btn" disabled={unsubPending}>
                  {unsubPending ? "Reopening…" : "Reopen self-assessment"}
                </button>
                {unsubState.error ? <div className="form-err" style={{ marginTop: 8 }}>{unsubState.error}</div> : null}
              </form>
            ) : null}
          </div>
        ) : (
          <form action={selfAction}>
            <input type="hidden" name="appraisalId" value={appraisal.id} />
            <input type="hidden" name="items" value={selfPayload} />
            <div className="card-pad">
              {selfState.error ? <div className="form-err">{selfState.error}</div> : null}

              {outcomes.length ? <div className="appr-sub">Key result areas</div> : null}
              {outcomes.map((r) => (
                <div className="appr-item" key={r.id}>
                  <div className="appr-item-h">
                    <div>
                      <div className="appr-kra">{r.label}</div>
                      {r.measure ? <div className="appr-kpi">KPI · {r.measure}</div> : null}
                    </div>
                    {r.weight != null ? <span className="sc-o-weight">{r.weight}%</span> : null}
                  </div>
                  <div className="appr-fields">
                    <div className="field">
                      <label>Your result / evidence</label>
                      <input
                        value={r.selfActual}
                        onChange={(e) => update(r.id, { selfActual: e.target.value })}
                        placeholder="e.g. 99.4%"
                      />
                    </div>
                    <div className="field">
                      <label>Self rating</label>
                      <select value={r.selfRating} onChange={(e) => update(r.id, { selfRating: e.target.value })}>
                        <option value="">—</option>
                        {ratings.map((x) => (
                          <option key={x.value} value={x.value}>{x.label}</option>
                        ))}
                      </select>
                    </div>
                    <div className="field full">
                      <label>Note (optional)</label>
                      <input
                        value={r.selfNote}
                        onChange={(e) => update(r.id, { selfNote: e.target.value })}
                        placeholder="Context, blockers, supporting detail"
                      />
                    </div>
                  </div>
                </div>
              ))}

              {competencies.length ? <div className="appr-sub">Competencies</div> : null}
              {competencies.map((r) => (
                <div className="appr-item" key={r.id}>
                  <div className="appr-item-h">
                    <div>
                      <div className="appr-kra">{r.label}</div>
                      <div className="appr-kpi">
                        {r.measure ? `${r.measure} · ` : ""}Expected: {levelLabelOf(String(r.expectedLevel ?? ""))}
                      </div>
                    </div>
                  </div>
                  <div className="appr-fields">
                    <div className="field">
                      <label>Self-assessed level</label>
                      <select value={r.selfLevel} onChange={(e) => update(r.id, { selfLevel: e.target.value })}>
                        <option value="">—</option>
                        {levels.map((x) => (
                          <option key={x.value} value={String(x.value)}>{x.label}</option>
                        ))}
                      </select>
                    </div>
                    <div className="field full">
                      <label>Note (optional)</label>
                      <input
                        value={r.selfNote}
                        onChange={(e) => update(r.id, { selfNote: e.target.value })}
                        placeholder="Evidence of proficiency"
                      />
                    </div>
                  </div>
                </div>
              ))}

              <div className="field full" style={{ marginTop: 14 }}>
                <label htmlFor="selfSummary">Overall self-assessment summary</label>
                <textarea
                  id="selfSummary"
                  name="selfSummary"
                  rows={3}
                  defaultValue={appraisal.selfSummary ?? ""}
                  placeholder="A short reflection on the period."
                />
              </div>
            </div>
            <div className="appr-actions">
              <button type="submit" name="submit" value="" className="btn" disabled={selfPending}>
                {selfPending ? "Saving…" : "Save draft"}
              </button>
              <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={selfPending}>
                Submit self-assessment
              </button>
            </div>
          </form>
        )}
      </div>

      {/* ---------------- Manager review ---------------- */}
      <div className="card">
        <div className="card-h">
          <h3>Manager review</h3>
          <span className={"b " + (managerSubmitted ? "b-grn" : "b-amb")}>
            <span className="dot" />
            {managerSubmitted ? "Finalized" : "Pending"}
          </span>
        </div>

        {readOnly ? (
          <div className="card-pad">
            <ul className="appr-list">
              {rows.map((r) => (
                <li className="appr-ro" key={r.id}>
                  <div className="appr-ro-h">
                    <span className="appr-kind">{r.kind === "OUTCOME" ? "KRA" : "Competency"}</span>
                    <span className="appr-kra">{r.label}</span>
                  </div>
                  <div className="appr-ro-b">
                    {r.kind === "OUTCOME" ? (
                      <>
                        <span>Target: {r.target || "—"}</span>
                        <span>Actual: {r.actual || "—"}</span>
                        {r.rating ? <span className="b b-gry">{ratingLabel(r.rating)}</span> : null}
                      </>
                    ) : (
                      <span>
                        Expected {levelLabelOf(String(r.expectedLevel ?? ""))} · Assessed {levelLabelOf(r.assessedLevel)}
                      </span>
                    )}
                  </div>
                  {r.managerNote ? <div className="appr-note">{r.managerNote}</div> : null}
                </li>
              ))}
            </ul>
            {appraisal.managerSummary ? <p className="sc-mission" style={{ marginTop: 10 }}>{appraisal.managerSummary}</p> : null}
            {appraisal.developmentPlan ? (
              <>
                <div className="appr-sub">Development plan</div>
                <p className="sc-mission">{appraisal.developmentPlan}</p>
              </>
            ) : null}
          </div>
        ) : (
          <form action={reviewAction}>
            <input type="hidden" name="appraisalId" value={appraisal.id} />
            <input type="hidden" name="items" value={reviewPayload} />
            <div className="card-pad">
              {reviewState.error ? <div className="form-err">{reviewState.error}</div> : null}
              {!selfSubmitted ? (
                <div className="note" style={{ marginBottom: 12 }}>
                  <span>ℹ</span>
                  <div>The self-assessment is not submitted yet. You can still record the review.</div>
                </div>
              ) : null}

              {outcomes.length ? <div className="appr-sub">Key result areas</div> : null}
              {outcomes.map((r) => (
                <div className="appr-item" key={r.id}>
                  <div className="appr-item-h">
                    <div>
                      <div className="appr-kra">{r.label}</div>
                      {r.measure ? <div className="appr-kpi">KPI · {r.measure}</div> : null}
                    </div>
                    {r.weight != null ? <span className="sc-o-weight">{r.weight}%</span> : null}
                  </div>
                  {(r.selfActual || r.selfRating) ? (
                    <div className="appr-self-ro">
                      Self: {r.selfActual || "—"}
                      {r.selfRating ? ` · ${ratingLabel(r.selfRating)}` : ""}
                    </div>
                  ) : null}
                  <div className="appr-fields">
                    <div className="field">
                      <label>Target</label>
                      <input value={r.target} onChange={(e) => update(r.id, { target: e.target.value })} placeholder="e.g. 99%" />
                    </div>
                    <div className="field">
                      <label>Actual</label>
                      <input value={r.actual} onChange={(e) => update(r.id, { actual: e.target.value })} placeholder="e.g. 99.4%" />
                    </div>
                    <div className="field">
                      <label>Rating</label>
                      <select value={r.rating} onChange={(e) => update(r.id, { rating: e.target.value })}>
                        <option value="">—</option>
                        {ratings.map((x) => (
                          <option key={x.value} value={x.value}>{x.label}</option>
                        ))}
                      </select>
                    </div>
                    <div className="field full">
                      <label>Manager note (optional)</label>
                      <input value={r.managerNote} onChange={(e) => update(r.id, { managerNote: e.target.value })} />
                    </div>
                  </div>
                </div>
              ))}

              {competencies.length ? <div className="appr-sub">Competencies</div> : null}
              {competencies.map((r) => (
                <div className="appr-item" key={r.id}>
                  <div className="appr-item-h">
                    <div>
                      <div className="appr-kra">{r.label}</div>
                      <div className="appr-kpi">
                        {r.measure ? `${r.measure} · ` : ""}Expected: {levelLabelOf(String(r.expectedLevel ?? ""))}
                      </div>
                    </div>
                  </div>
                  {r.selfLevel ? <div className="appr-self-ro">Self level: {levelLabelOf(r.selfLevel)}</div> : null}
                  <div className="appr-fields">
                    <div className="field">
                      <label>Assessed level</label>
                      <select value={r.assessedLevel} onChange={(e) => update(r.id, { assessedLevel: e.target.value })}>
                        <option value="">—</option>
                        {levels.map((x) => (
                          <option key={x.value} value={String(x.value)}>{x.label}</option>
                        ))}
                      </select>
                    </div>
                    <div className="field full">
                      <label>Manager note (optional)</label>
                      <input value={r.managerNote} onChange={(e) => update(r.id, { managerNote: e.target.value })} />
                    </div>
                  </div>
                </div>
              ))}

              <div className="form-grid" style={{ marginTop: 14 }}>
                <div className="field">
                  <label htmlFor="overallRating">Overall rating</label>
                  <select id="overallRating" name="overallRating" defaultValue={appraisal.overallRating ?? ""}>
                    <option value="">—</option>
                    {ratings.map((x) => (
                      <option key={x.value} value={x.value}>{x.label}</option>
                    ))}
                  </select>
                </div>
                <div className="field full">
                  <label htmlFor="managerSummary">Review summary</label>
                  <textarea id="managerSummary" name="managerSummary" rows={3} defaultValue={appraisal.managerSummary ?? ""} />
                </div>
                <div className="field full">
                  <label htmlFor="developmentPlan">Development / improvement plan (optional)</label>
                  <textarea
                    id="developmentPlan"
                    name="developmentPlan"
                    rows={3}
                    defaultValue={appraisal.developmentPlan ?? ""}
                    placeholder="Development actions, or a performance-improvement plan where a result is below standard."
                  />
                </div>
              </div>
            </div>
            <div className="appr-actions">
              <button type="submit" name="submit" value="" className="btn" disabled={reviewPending}>
                {reviewPending ? "Saving…" : "Save review"}
              </button>
              <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={reviewPending}>
                {managerSubmitted ? "Update finalized review" : "Finalize review"}
              </button>
            </div>
          </form>
        )}
      </div>

      {cycleStatus === "CLOSED" ? (
        <p className="faint" style={{ marginTop: 12 }}>This cycle is closed; edits are still recorded in the audit log.</p>
      ) : null}
    </>
  );
}
