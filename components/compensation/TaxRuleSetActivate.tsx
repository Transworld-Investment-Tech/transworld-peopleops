"use client";
import { useActionState } from "react";
import { activateTaxRuleSetAction, type FormState } from "@/lib/compensation-actions";

const EMPTY: FormState = { ok: false };

export default function TaxRuleSetActivate({ rulesetId }: { rulesetId: string }) {
  const [state, formAction, pending] = useActionState(activateTaxRuleSetAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "inline-flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="rulesetId" value={rulesetId} />
      <button type="submit" className="btn" disabled={pending}>
        {pending ? "Activating…" : "Make active"}
      </button>
      {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
    </form>
  );
}
