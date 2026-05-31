"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import { recommendModulesAction, type FormState } from "@/lib/learning-actions";
import type { RecommendModule } from "@/lib/learning";

const EMPTY: FormState = { ok: false };

export default function RecommendForm({
  employeeId,
  appraisalId,
  cycleId,
  modules,
}: {
  employeeId: string;
  appraisalId: string | null;
  cycleId: string | null;
  modules: RecommendModule[];
}) {
  const [state, formAction, pending] = useActionState(recommendModulesAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  // Pre-select suggested modules the employee doesn't already have.
  const [picked, setPicked] = useState<string[]>(
    modules.filter((m) => m.suggested && !m.alreadyHas).map((m) => m.id)
  );
  const toggle = (id: string) =>
    setPicked((cur) => (cur.includes(id) ? cur.filter((x) => x !== id) : [...cur, id]));

  return (
    <form action={formAction}>
      <input type="hidden" name="employeeId" value={employeeId} />
      {appraisalId ? <input type="hidden" name="appraisalId" value={appraisalId} /> : null}
      {cycleId ? <input type="hidden" name="cycleId" value={cycleId} /> : null}
      <input type="hidden" name="moduleIds" value={JSON.stringify(picked)} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Choose modules to recommend</h3>
          <span className="hint">{picked.length} selected</span>
        </div>
        <div className="card-pad">
          {fe.moduleIds ? <div className="form-err" style={{ marginBottom: 10 }}>{fe.moduleIds}</div> : null}
          {modules.length === 0 ? (
            <p className="faint">No published modules yet — create some in the library first.</p>
          ) : (
            modules.map((m) => {
              const on = picked.includes(m.id);
              return (
                <label key={m.id} className={"ln-pick" + (on ? " on" : "")}>
                  <input
                    type="checkbox"
                    checked={on}
                    onChange={() => toggle(m.id)}
                    disabled={m.alreadyHas}
                  />
                  <span className="ln-pick-main">
                    <span className="ln-pick-title">
                      {m.title}
                      {m.suggested ? <span className="b b-amb" style={{ marginLeft: 8 }}>Suggested</span> : null}
                      {m.alreadyHas ? <span className="b b-gry" style={{ marginLeft: 8 }}>Already assigned</span> : null}
                    </span>
                    <span className="ln-pick-sub">
                      {m.category}
                      {m.competencies.length ? ` · ${m.competencies.join(", ")}` : ""}
                    </span>
                  </span>
                </label>
              );
            })
          )}

          <div className="form-grid" style={{ marginTop: 16 }}>
            <div className="field">
              <label>Target date (optional)</label>
              <input type="date" name="dueDate" />
            </div>
            <div className="field full">
              <label>Note to the employee (optional)</label>
              <input name="note" placeholder="e.g. Let's close the gap on settlement before Q3." />
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link
          href={appraisalId && cycleId ? `/performance/${cycleId}/${employeeId}` : "/learning"}
          className="btn"
        >
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending || picked.length === 0}>
          {pending ? "Recommending…" : "Recommend selected"}
        </button>
      </div>
    </form>
  );
}
