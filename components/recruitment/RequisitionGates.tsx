"use client";
import { useActionState } from "react";
import {
  recordBudgetApprovalAction,
  confirmRolePackAction,
  type FormState,
} from "@/lib/recruitment-actions";

const EMPTY: FormState = { ok: false };

export type GateProps = {
  openingId: string;
  reqStageLabel: string;
  reason: string | null;
  mustHaves: string | null;
  budgetBand: string | null;
  isControlFunction: boolean;
  raisedByName: string | null;
  raisedAt: string;
  cfoApprovedByName: string | null;
  cfoApprovedAt: string | null;
  mdApprovedByName: string | null;
  mdApprovedAt: string | null;
  rolePackConfirmedByName: string | null;
  rolePackConfirmedAt: string | null;
  canApprove: boolean;
  canManage: boolean;
};

function dot(done: boolean) {
  return (
    <span
      aria-hidden
      style={{
        display: "inline-block",
        width: 9,
        height: 9,
        borderRadius: 9,
        background: done ? "var(--green)" : "var(--line-2)",
        marginRight: 8,
      }}
    />
  );
}

function CfoButton({ openingId, budgetBand }: { openingId: string; budgetBand: string | null }) {
  const [state, formAction, pending] = useActionState(recordBudgetApprovalAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
      <input type="hidden" name="openingId" value={openingId} />
      <input type="hidden" name="which" value="CFO" />
      <input name="budgetBand" placeholder="Budget band" defaultValue={budgetBand ?? ""} style={{ flex: "1 1 180px" }} />
      <button className="btn btn-xs btn-pri" type="submit" disabled={pending}>
        {pending ? "…" : "Record CFO approval"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

function MdButton({ openingId }: { openingId: string }) {
  const [state, formAction, pending] = useActionState(recordBudgetApprovalAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="openingId" value={openingId} />
      <input type="hidden" name="which" value="MD" />
      <button className="btn btn-xs btn-pri" type="submit" disabled={pending}>
        {pending ? "…" : "Record MD approval"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

function RolePackButton({ openingId }: { openingId: string }) {
  const [state, formAction, pending] = useActionState(confirmRolePackAction, EMPTY);
  return (
    <form action={formAction} style={{ display: "flex", gap: 8, alignItems: "center" }}>
      <input type="hidden" name="openingId" value={openingId} />
      <button className="btn btn-xs btn-grn" type="submit" disabled={pending}>
        {pending ? "…" : "Confirm role pack ready"}
      </button>
      {state.error ? <span className="form-err">{state.error}</span> : null}
    </form>
  );
}

export default function RequisitionGates(p: GateProps) {
  const cfoDone = !!p.cfoApprovedAt;
  const mdDone = !!p.mdApprovedAt;
  const rolePackDone = !!p.rolePackConfirmedAt;

  return (
    <div className="kv">
      <div className="row">
        <span className="k">{dot(true)}1 · Requisition</span>
        <span className="v">
          {p.raisedByName ? `Raised by ${p.raisedByName}` : "Raised"} · {p.raisedAt}
          {p.isControlFunction ? <span className="b b-amb" style={{ marginLeft: 8 }}>Control-function</span> : null}
        </span>
      </div>

      <div className="row">
        <span className="k">{dot(cfoDone && mdDone)}2 · Budget approval</span>
        <span className="v">
          {cfoDone ? (
            <span className="faint">CFO: {p.cfoApprovedByName} · {p.cfoApprovedAt}</span>
          ) : (
            <span className="faint">CFO affordability pending</span>
          )}
          {" · "}
          {mdDone ? (
            <span className="faint">MD: {p.mdApprovedByName} · {p.mdApprovedAt}</span>
          ) : (
            <span className="faint">MD approval pending</span>
          )}
          {p.canApprove && !cfoDone ? (
            <div style={{ marginTop: 6 }}>
              <CfoButton openingId={p.openingId} budgetBand={p.budgetBand} />
            </div>
          ) : null}
          {p.canApprove && cfoDone && !mdDone ? (
            <div style={{ marginTop: 6 }}>
              <MdButton openingId={p.openingId} />
            </div>
          ) : null}
        </span>
      </div>

      <div className="row">
        <span className="k">{dot(rolePackDone)}3 · Role pack</span>
        <span className="v">
          {rolePackDone ? (
            <span className="faint">Confirmed by {p.rolePackConfirmedByName} · {p.rolePackConfirmedAt}</span>
          ) : (
            <span className="faint">JD, competency profile &amp; scorecard not yet confirmed</span>
          )}
          {p.canManage && cfoDone && mdDone && !rolePackDone ? (
            <div style={{ marginTop: 6 }}>
              <RolePackButton openingId={p.openingId} />
            </div>
          ) : null}
        </span>
      </div>

      {p.mustHaves ? (
        <div className="row">
          <span className="k">Must-haves</span>
          <span className="v">{p.mustHaves}</span>
        </div>
      ) : null}
    </div>
  );
}
