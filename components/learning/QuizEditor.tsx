"use client";
import { useActionState, useState } from "react";
import { saveQuestionAction, deleteQuestionAction, type FormState } from "@/lib/lms-actions";
import { QUESTION_TYPES, questionTypeLabel } from "@/lib/lms";

const EMPTY: FormState = { ok: false };

export type EditorQuestion = {
  id: string;
  prompt: string;
  type: string;
  options: { key: string; text: string }[];
  correct: string[];
  explanation: string | null;
  sortOrder: number;
  active: boolean;
};

type Opt = { key: string; text: string; correct: boolean };

function blankOpts(type: string): Opt[] {
  if (type === "TRUE_FALSE")
    return [
      { key: "t", text: "True", correct: false },
      { key: "f", text: "False", correct: false },
    ];
  return [
    { key: "a", text: "", correct: false },
    { key: "b", text: "", correct: false },
    { key: "c", text: "", correct: false },
    { key: "d", text: "", correct: false },
  ];
}

export default function QuizEditor({
  moduleId,
  questions,
}: {
  moduleId: string;
  questions: EditorQuestion[];
}) {
  const [state, formAction, pending] = useActionState(saveQuestionAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const [type, setType] = useState<string>("SINGLE");
  const [opts, setOpts] = useState<Opt[]>(blankOpts("SINGLE"));

  const onType = (t: string) => {
    setType(t);
    setOpts(blankOpts(t));
  };
  const setOptText = (i: number, text: string) =>
    setOpts((o) => o.map((x, j) => (j === i ? { ...x, text } : x)));
  const toggleCorrect = (i: number) =>
    setOpts((o) =>
      o.map((x, j) => {
        if (type === "MULTI") return j === i ? { ...x, correct: !x.correct } : x;
        return { ...x, correct: j === i };
      })
    );

  const cleanOpts = opts.filter((o) => o.text.trim() !== "");
  const optionsJson = JSON.stringify(cleanOpts.map((o) => ({ key: o.key, text: o.text.trim() })));
  const correctJson = JSON.stringify(cleanOpts.filter((o) => o.correct).map((o) => o.key));

  return (
    <div className="card">
      <div className="card-h">
        <h3>Knowledge-check</h3>
        <span className="hint">
          {questions.length} question{questions.length === 1 ? "" : "s"} · answers graded server-side
        </span>
      </div>
      <div className="card-pad">
        {questions.length > 0 ? (
          <div className="doc-list" style={{ marginBottom: 16 }}>
            {questions.map((q, i) => (
              <div className="row" key={q.id} style={{ justifyContent: "space-between", alignItems: "flex-start" }}>
                <div>
                  <div>
                    <strong>
                      {i + 1}. {q.prompt}
                    </strong>{" "}
                    <span className="b b-gry">{questionTypeLabel(q.type)}</span>
                    {!q.active ? <span className="b b-gry"> inactive</span> : null}
                  </div>
                  <div className="faint">
                    {q.options.map((o) => o.key + (q.correct.includes(o.key) ? "✓" : "")).join(" · ")}
                  </div>
                </div>
                <form action={deleteQuestionAction}>
                  <input type="hidden" name="questionId" value={q.id} />
                  <button className="btn btn-xs btn-danger">Delete</button>
                </form>
              </div>
            ))}
          </div>
        ) : (
          <p className="faint" style={{ marginTop: 0 }}>
            No questions yet. Add the first one below.
          </p>
        )}

        <form action={formAction}>
          <input type="hidden" name="moduleId" value={moduleId} />
          <input type="hidden" name="type" value={type} />
          <input type="hidden" name="options" value={optionsJson} />
          <input type="hidden" name="correct" value={correctJson} />
          <input type="hidden" name="sortOrder" value={questions.length} />
          {state.error ? <div className="form-err">{state.error}</div> : null}
          {fe.correct ? <div className="form-err">{fe.correct}</div> : null}

          <div className="form-grid">
            <div className="field full">
              <label>Question</label>
              <input name="prompt" placeholder="Write the question" />
              {fe.prompt ? <span className="err">{fe.prompt}</span> : null}
            </div>
            <div className="field">
              <label>Type</label>
              <select value={type} onChange={(e) => onType(e.target.value)}>
                {QUESTION_TYPES.map((t) => (
                  <option key={t.value} value={t.value}>
                    {t.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field full">
              <label>Options {type === "MULTI" ? "(tick all correct)" : "(tick the correct one)"}</label>
              <div className="kv" style={{ gap: 6 }}>
                {opts.map((o, i) => (
                  <div className="row" key={o.key} style={{ gap: 8 }}>
                    <input
                      type={type === "MULTI" ? "checkbox" : "radio"}
                      checked={o.correct}
                      onChange={() => toggleCorrect(i)}
                      aria-label={`mark ${o.key} correct`}
                    />
                    <span className="mono">{o.key}</span>
                    <input
                      value={o.text}
                      onChange={(e) => setOptText(i, e.target.value)}
                      placeholder={type === "TRUE_FALSE" ? "" : `Option ${o.key}`}
                      readOnly={type === "TRUE_FALSE"}
                      style={{ flex: 1 }}
                    />
                  </div>
                ))}
              </div>
            </div>
            <div className="field full">
              <label>Explanation (shown after grading) — optional</label>
              <input name="explanation" placeholder="Why this is the answer" />
            </div>
          </div>

          <div className="form-actions">
            <button className="btn btn-pri" disabled={pending}>
              {pending ? "Adding…" : "Add question"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
