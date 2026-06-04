"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import {
  saveScorecardAction,
  deleteScorecardAction,
  type FormState,
} from "@/lib/scorecards-actions";

type OutcomeInput = { title: string; measure: string; weight: string };
type Initial = {
  mission: string;
  status: string;
  weights: { results: number; competencies: number; behaviors: number } | null;
  outcomes: { title: string; measure: string | null; weight: number | null }[];
};

const EMPTY: FormState = { ok: false };

function blankRow(): OutcomeInput {
  return { title: "", measure: "", weight: "" };
}

export default function ScorecardForm({
  jobProfileId,
  initial,
  statuses,
  hasExisting,
  familyDefault,
}: {
  jobProfileId: string;
  initial: Initial;
  statuses: { value: string; label: string }[];
  hasExisting: boolean;
  familyDefault: { results: number; competencies: number; behaviors: number };
}) {
  const [state, formAction, pending] = useActionState(saveScorecardAction, EMPTY);
  const [, deleteAction, deletePending] = useActionState(deleteScorecardAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  const [rows, setRows] = useState<OutcomeInput[]>(() =>
    initial.outcomes.length
      ? initial.outcomes.map((o) => ({
          title: o.title,
          measure: o.measure ?? "",
          weight: o.weight === null || o.weight === undefined ? "" : String(o.weight),
        }))
      : [blankRow()]
  );

  const serialized = JSON.stringify(
    rows.map((r) => ({
      title: r.title,
      measure: r.measure,
      weight: r.weight.trim() === "" ? null : Number(r.weight),
    }))
  );

  function update(i: number, patch: Partial<OutcomeInput>) {
    setRows((rs) => rs.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));
  }
  function addRow() {
    setRows((rs) => [...rs, blankRow()]);
  }
  function removeRow(i: number) {
    setRows((rs) => (rs.length <= 1 ? [blankRow()] : rs.filter((_, idx) => idx !== i)));
  }

  return (
    <form action={formAction}>
      <input type="hidden" name="jobProfileId" value={jobProfileId} />
      <input type="hidden" name="outcomes" value={serialized} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Mission &amp; status</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field full">
              <label htmlFor="mission">Mission</label>
              <textarea
                id="mission"
                name="mission"
                rows={3}
                defaultValue={initial.mission}
                placeholder="Why this role exists — the core purpose in a sentence or two."
              />
            </div>
            <div className="field">
              <label htmlFor="status">Status</label>
              <select id="status" name="status" defaultValue={initial.status || "DRAFT"}>
                {statuses.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Dimension weighting</h3>
          <span className="hint">how Results / Competencies / Behaviors combine into the score</span>
        </div>
        <div className="card-pad">
          {fe.weights ? <div className="form-err" style={{ marginBottom: 10 }}>{fe.weights}</div> : null}
          <p className="faint" style={{ marginTop: 0, fontSize: 12.5 }}>
            Leave all three blank to use this role&rsquo;s job-family default
            ({familyDefault.results} / {familyDefault.competencies} / {familyDefault.behaviors}).
            To override, set all three — they must sum to 100% and stay within the approved bands
            (Results 40–60, Competencies 20–30, Behaviors 20–30).
          </p>
          <div className="form-grid">
            <div className="field">
              <label htmlFor="resultsWeight">Results (%)</label>
              <input
                id="resultsWeight"
                name="resultsWeight"
                inputMode="numeric"
                defaultValue={initial.weights ? String(initial.weights.results) : ""}
                placeholder={String(familyDefault.results)}
              />
            </div>
            <div className="field">
              <label htmlFor="competenciesWeight">Competencies (%)</label>
              <input
                id="competenciesWeight"
                name="competenciesWeight"
                inputMode="numeric"
                defaultValue={initial.weights ? String(initial.weights.competencies) : ""}
                placeholder={String(familyDefault.competencies)}
              />
            </div>
            <div className="field">
              <label htmlFor="behaviorsWeight">Behaviors (%)</label>
              <input
                id="behaviorsWeight"
                name="behaviorsWeight"
                inputMode="numeric"
                defaultValue={initial.weights ? String(initial.weights.behaviors) : ""}
                placeholder={String(familyDefault.behaviors)}
              />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Key outcomes</h3>
          <span className="hint">measurable results expected in the role</span>
        </div>
        <div className="card-pad">
          {fe.outcomes ? <div className="form-err" style={{ marginBottom: 10 }}>{fe.outcomes}</div> : null}
          <div className="sc-rows">
            {rows.map((r, i) => (
              <div className="sc-row" key={i}>
                <span className="sc-row-n">{i + 1}</span>
                <div className="sc-row-fields">
                  <input
                    className="sc-in-title"
                    value={r.title}
                    onChange={(e) => update(i, { title: e.target.value })}
                    placeholder="Outcome (e.g. Clean SEC returns filed on time every quarter)"
                  />
                  <input
                    className="sc-in-measure"
                    value={r.measure}
                    onChange={(e) => update(i, { measure: e.target.value })}
                    placeholder="Measure / target (optional)"
                  />
                  <input
                    className="sc-in-weight"
                    value={r.weight}
                    onChange={(e) => update(i, { weight: e.target.value.replace(/[^\d]/g, "") })}
                    placeholder="wt %"
                    inputMode="numeric"
                    aria-label="Weight percent (optional)"
                  />
                </div>
                <button
                  type="button"
                  className="sc-remove"
                  onClick={() => removeRow(i)}
                  aria-label={`Remove outcome ${i + 1}`}
                >
                  ×
                </button>
              </div>
            ))}
          </div>
          <button type="button" className="btn sc-add" onClick={addRow}>
            + Add outcome
          </button>
        </div>
      </div>

      <div className="form-actions">
        <Link href={`/job-competency/${jobProfileId}`} className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save scorecard"}
        </button>
      </div>

      {hasExisting ? (
        <div className="sc-danger">
          <span className="faint">Removing the scorecard deletes its mission and all outcomes.</span>
          <button
            type="submit"
            className="btn"
            formAction={deleteAction}
            disabled={deletePending}
            formNoValidate
          >
            {deletePending ? "Removing…" : "Delete scorecard"}
          </button>
        </div>
      ) : null}
    </form>
  );
}
