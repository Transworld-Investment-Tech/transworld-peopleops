"use client";
import { useActionState } from "react";
import { deleteModuleAction, type FormState } from "@/lib/learning-actions";

const EMPTY: FormState = { ok: false };

export default function ModuleDelete({ moduleId }: { moduleId: string }) {
  const [state, formAction, pending] = useActionState(deleteModuleAction, EMPTY);
  return (
    <form action={formAction}>
      <input type="hidden" name="moduleId" value={moduleId} />
      <button className="btn" type="submit" disabled={pending}>
        {pending ? "Deleting…" : "Delete module"}
      </button>
      {state.error ? <span className="err" style={{ marginLeft: 10 }}>{state.error}</span> : null}
    </form>
  );
}
