"use client";
import { useActionState, useState } from "react";
import { saveMySelfAssessmentAction, type FormState } from "@/lib/self-assessment-actions";

const EMPTY: FormState = { ok: false };

type ItemView = {
  id: string;
  kind: string;
  label: string;
  measure: string | null;
  target: string | null;
  weight: number | null;
  expectedLevel: number | null;
  selfActual: string | null;
  selfRating: string | null;
  selfLevel: number | null;
  selfNote: string | null;
};
type Appraisal = { id: string; selfStatus: string; selfSummary: string | null; items: ItemView[] };
type Row = { id: string; kind: string; label: string; measure: string | null; expectedLevel: number | null; weight: number | null; selfActual: string; selfRating: string; selfLevel: string; selfNote: string };

function toRow(it: ItemView): Row {
  return {
    id: it.id,
    kind: it.kind,
    label: it.label,
    measure: it.measure,
    expectedLevel: it.expectedLevel,
    weight: it.weight,
    selfActual: it.selfActual ?? "",
    selfRating: it.selfRating ?? "",
    selfLevel: it.selfLevel === null || it.selfLevel === undefined ? "" : String(it.selfLevel),
    selfNote: it.selfNote ?? "",
  };
}

export default function SelfAssessmentEditor({
  appraisal,
  ratings,
  levels,
}: {
  appraisal: Appraisal;
  ratings: { value: string; label: string }[];
  levels: { value: number; label: string }[];
}) {
  const [state, action, pending] = useActionState(saveMySelfAssessmentAction, EMPTY);
  const [rows, setRows] = useState<Row[]>(() => appraisal.items.map(toRow));
  const submitted = appraisal.selfStatus === "SUBMITTED";

  const ratingLabel = (v: string) => ratings.find((x) => x.value === v)?.label ?? v;
  const levelLabel = (v: string) => (v === "" ? "—" : levels.find((x) => String(x.value) === v)?.label ?? v);

  if (submitted) {
    return (
      <div className="card-pad">
        <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
          <span>✓</span>
          <div>Your self-assessment is submitted. Your manager will complete the review; ratings are confirmed only after calibration.</div>
        </div>
        <ul className="appr-list" style={{ marginTop: 12 }}>
          {rows.map((r) => (
            <li className="appr-ro" key={r.id}>
              <div className="appr-ro-h">
                <span className="appr-kind">{r.kind === "OUTCOME" ? "KRA" : r.kind === "COMPETENCY" ? "Competency" : "Behavior"}</span>
                <span className="appr-kra">{r.label}</span>
              </div>
              <div className="appr-ro-b">
                {r.kind === "COMPETENCY" ? (
                  <span>Self level: {levelLabel(r.selfLevel)}</span>
                ) : (
                  <>
                    <span>Self: {r.selfActual || "—"}</span>
                    {r.selfRating ? <span className="b b-gry">{ratingLabel(r.selfRating)}</span> : null}
                  </>
                )}
              </div>
              {r.selfNote ? <div className="appr-note">{r.selfNote}</div> : null}
            </li>
          ))}
        </ul>
        {appraisal.selfSummary ? <p className="sc-mission" style={{ marginTop: 10 }}>{appraisal.selfSummary}</p> : null}
      </div>
    );
  }

  function update(id: string, patch: Partial<Row>) {
    setRows((rs) => rs.map((r) => (r.id === id ? { ...r, ...patch } : r)));
  }

  const payload = JSON.stringify(
    rows.map((r) => ({
      id: r.id,
      selfActual: r.kind === "COMPETENCY" ? "" : r.selfActual,
      selfRating: r.kind === "COMPETENCY" ? "" : r.selfRating,
      selfLevel: r.kind === "COMPETENCY" ? r.selfLevel : "",
      selfNote: r.selfNote,
    }))
  );

  const groups: { key: string; title: string }[] = [
    { key: "OUTCOME", title: "Key result areas" },
    { key: "COMPETENCY", title: "Competencies" },
    { key: "BEHAVIOR", title: "Behaviors" },
  ];

  return (
    <form action={action}>
      <input type="hidden" name="appraisalId" value={appraisal.id} />
      <input type="hidden" name="items" value={payload} />
      <div className="card-pad">
        {state.error ? <div className="form-err">{state.error}</div> : null}
        {groups.map((g) => {
          const items = rows.filter((r) => r.kind === g.key);
          if (!items.length) return null;
          return (
            <div key={g.key}>
              <div className="appr-sub">{g.title}</div>
              {items.map((r) => (
                <div className="appr-item" key={r.id}>
                  <div className="appr-item-h">
                    <div>
                      <div className="appr-kra">{r.label}</div>
                      {r.kind === "COMPETENCY" ? (
                        <div className="appr-kpi">{r.measure ? `${r.measure} · ` : ""}Expected: {levelLabel(String(r.expectedLevel ?? ""))}</div>
                      ) : r.measure ? (
                        <div className="appr-kpi">KPI · {r.measure}</div>
                      ) : null}
                    </div>
                    {r.weight != null ? <span className="sc-o-weight">{r.weight}%</span> : null}
                  </div>
                  <div className="appr-fields">
                    {r.kind === "COMPETENCY" ? (
                      <div className="field">
                        <label>Self-assessed level</label>
                        <select value={r.selfLevel} onChange={(e) => update(r.id, { selfLevel: e.target.value })}>
                          <option value="">—</option>
                          {levels.map((x) => (<option key={x.value} value={String(x.value)}>{x.label}</option>))}
                        </select>
                      </div>
                    ) : (
                      <>
                        <div className="field">
                          <label>Your result / evidence</label>
                          <input value={r.selfActual} onChange={(e) => update(r.id, { selfActual: e.target.value })} placeholder="What you achieved" />
                        </div>
                        <div className="field">
                          <label>Self rating</label>
                          <select value={r.selfRating} onChange={(e) => update(r.id, { selfRating: e.target.value })}>
                            <option value="">—</option>
                            {ratings.map((x) => (<option key={x.value} value={x.value}>{x.label}</option>))}
                          </select>
                        </div>
                      </>
                    )}
                    <div className="field full">
                      <label>Note (optional)</label>
                      <input value={r.selfNote} onChange={(e) => update(r.id, { selfNote: e.target.value })} placeholder="Context, evidence, blockers" />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          );
        })}
        <div className="field full" style={{ marginTop: 14 }}>
          <label htmlFor="selfSummary">Overall self-assessment summary</label>
          <textarea id="selfSummary" name="selfSummary" rows={3} defaultValue={appraisal.selfSummary ?? ""} placeholder="A short reflection on your year." />
        </div>
      </div>
      <div className="appr-actions">
        <button type="submit" name="submit" value="" className="btn" disabled={pending}>{pending ? "Saving…" : "Save draft"}</button>
        <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={pending}>Submit self-assessment</button>
      </div>
    </form>
  );
}
