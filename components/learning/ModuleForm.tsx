"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import { saveModuleAction, type FormState } from "@/lib/learning-actions";

const EMPTY: FormState = { ok: false };

export type ModuleFormInitial = {
  id: string | null;
  title: string;
  category: string;
  summary: string;
  estimatedMinutes: string;
  status: string;
  body: string;
  competencyIds: string[];
};

export default function ModuleForm({
  initial,
  categories,
  competencies,
}: {
  initial: ModuleFormInitial;
  categories: readonly string[];
  competencies: { id: string; name: string; category: string | null }[];
}) {
  const [state, formAction, pending] = useActionState(saveModuleAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const [picked, setPicked] = useState<string[]>(initial.competencyIds);

  const toggle = (id: string) =>
    setPicked((cur) => (cur.includes(id) ? cur.filter((x) => x !== id) : [...cur, id]));

  return (
    <form action={formAction}>
      {initial.id ? <input type="hidden" name="moduleId" value={initial.id} /> : null}
      <input type="hidden" name="competencyIds" value={JSON.stringify(picked)} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>{initial.id ? "Edit module" : "New module"}</h3>
          <span className="hint">reading material staff work through</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field full">
              <label>Title</label>
              <input name="title" defaultValue={initial.title} placeholder="e.g. AML / KYC Fundamentals" />
              {fe.title ? <span className="err">{fe.title}</span> : null}
            </div>

            <div className="field">
              <label>Category</label>
              <select name="category" defaultValue={initial.category || categories[0]}>
                {categories.map((c) => (
                  <option key={c} value={c}>
                    {c}
                  </option>
                ))}
              </select>
              {fe.category ? <span className="err">{fe.category}</span> : null}
            </div>

            <div className="field">
              <label>Estimated time (minutes)</label>
              <input name="estimatedMinutes" defaultValue={initial.estimatedMinutes} inputMode="numeric" placeholder="e.g. 30" />
              {fe.estimatedMinutes ? <span className="err">{fe.estimatedMinutes}</span> : null}
            </div>

            <div className="field">
              <label>Status</label>
              <select name="status" defaultValue={initial.status || "DRAFT"}>
                <option value="DRAFT">Draft (hidden from staff)</option>
                <option value="PUBLISHED">Published (visible to staff)</option>
              </select>
            </div>

            <div className="field full">
              <label>Summary</label>
              <input name="summary" defaultValue={initial.summary} placeholder="One line shown in the library" />
              {fe.summary ? <span className="err">{fe.summary}</span> : null}
            </div>

            <div className="field full">
              <label>Reading content (markdown)</label>
              <textarea
                name="body"
                defaultValue={initial.body}
                rows={16}
                placeholder={"## Section heading\n\nWrite the lesson here. Use **bold**, *italic*, `code`, bullet lists with -, numbered lists with 1., and [links](https://example.com)."}
              />
              {fe.body ? <span className="err">{fe.body}</span> : null}
            </div>
          </div>

          <div style={{ marginTop: 16 }}>
            <label style={{ fontWeight: 600, display: "block", marginBottom: 8 }}>
              Competency tags
            </label>
            <p className="faint" style={{ marginTop: 0, marginBottom: 10 }}>
              Tagging a module to competencies powers smart recommendations from an appraisal.
            </p>
            <div className="ln-tags">
              {competencies.map((c) => {
                const on = picked.includes(c.id);
                return (
                  <button
                    type="button"
                    key={c.id}
                    className={"ln-tag" + (on ? " suggested" : "")}
                    style={{ cursor: "pointer", border: "none" }}
                    onClick={() => toggle(c.id)}
                  >
                    {on ? "✓ " : "+ "}
                    {c.name}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href={initial.id ? `/learning/modules/${initial.id}` : "/learning"} className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : initial.id ? "Save changes" : "Create module"}
        </button>
      </div>
    </form>
  );
}
