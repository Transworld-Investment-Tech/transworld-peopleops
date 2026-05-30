"use client";
import { useActionState } from "react";
import Link from "next/link";
import {
  createCompetencyAction,
  updateCompetencyAction,
  type FormState,
} from "@/lib/jobframework-actions";

const EMPTY: FormState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function CompetencyForm({
  mode,
  initial,
}: {
  mode: "create" | "edit";
  initial: { id?: string; name?: string; category?: string | null };
}) {
  const action = mode === "create" ? createCompetencyAction : updateCompetencyAction;
  const [state, formAction, pending] = useActionState(action, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {mode === "edit" && <input type="hidden" name="id" value={initial.id} />}
      {state.error && <div className="form-err">{state.error}</div>}

      <div className="card">
        <div className="card-h">
          <h3>Competency</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="name">Name</label>
              <input
                id="name"
                name="name"
                defaultValue={initial.name ?? ""}
                placeholder="Regulatory reporting"
              />
              <Err msg={fe.name} />
            </div>
            <div className="field">
              <label htmlFor="category">Category</label>
              <input
                id="category"
                name="category"
                defaultValue={initial.category ?? ""}
                placeholder="Compliance"
              />
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/job-competency/competencies" className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : mode === "create" ? "Add competency" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
