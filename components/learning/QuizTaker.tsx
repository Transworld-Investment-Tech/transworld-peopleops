"use client";
import { useActionState, useState } from "react";
import { submitCheckAction, type CheckState } from "@/lib/lms-actions";

const EMPTY: CheckState = { ok: false };

type Q = { id: string; prompt: string; type: string; options: { key: string; text: string }[] };

export default function QuizTaker({
  moduleId,
  employeeId,
  passMark,
  questions,
}: {
  moduleId: string;
  employeeId?: string | null;
  passMark: number;
  questions: Q[];
}) {
  const [state, formAction, pending] = useActionState(submitCheckAction, EMPTY);
  const [answers, setAnswers] = useState<Record<string, string[]>>({});

  const setSingle = (qid: string, key: string) =>
    setAnswers((a) => ({ ...a, [qid]: [key] }));
  const toggleMulti = (qid: string, key: string) =>
    setAnswers((a) => {
      const cur = a[qid] ?? [];
      return { ...a, [qid]: cur.includes(key) ? cur.filter((k) => k !== key) : [...cur, key] };
    });

  if (state.ok) {
    return (
      <div className="card">
        <div className="card-pad">
          <h3 className="serif" style={{ marginTop: 0 }}>
            {state.passed ? "Passed" : "Not passed"}
          </h3>
          <p>
            You scored <strong className="num">{state.score}%</strong> (pass mark {passMark}%).{" "}
            <span className={state.passed ? "b b-grn" : "b b-amb"}>
              {state.passed ? "Recorded as completed" : "You can retake the check"}
            </span>
          </p>
        </div>
      </div>
    );
  }

  return (
    <form action={formAction}>
      <input type="hidden" name="moduleId" value={moduleId} />
      {employeeId ? <input type="hidden" name="employeeId" value={employeeId} /> : null}
      <input type="hidden" name="answers" value={JSON.stringify(answers)} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      {questions.map((q, i) => (
        <div className="card" key={q.id}>
          <div className="card-pad">
            <p style={{ marginTop: 0 }}>
              <strong>
                {i + 1}. {q.prompt}
              </strong>{" "}
              {q.type === "MULTI" ? <span className="hint">(select all that apply)</span> : null}
            </p>
            <div className="kv" style={{ gap: 6 }}>
              {q.options.map((o) => (
                <label key={o.key} className="row" style={{ gap: 8, cursor: "pointer" }}>
                  <input
                    type={q.type === "MULTI" ? "checkbox" : "radio"}
                    name={`q_${q.id}`}
                    checked={(answers[q.id] ?? []).includes(o.key)}
                    onChange={() =>
                      q.type === "MULTI" ? toggleMulti(q.id, o.key) : setSingle(q.id, o.key)
                    }
                  />
                  <span>{o.text}</span>
                </label>
              ))}
            </div>
          </div>
        </div>
      ))}

      <div className="form-actions">
        <button className="btn btn-pri" disabled={pending}>
          {pending ? "Grading…" : "Submit answers"}
        </button>
      </div>
    </form>
  );
}
