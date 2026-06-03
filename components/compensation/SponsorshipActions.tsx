"use client";

import { useActionState } from "react";
import {
  approveSponsorshipAction,
  startSponsorshipAction,
  completeSponsorshipAction,
  withdrawSponsorshipAction,
  type FormState,
} from "@/lib/sponsorship-actions";

const initial: FormState = { ok: false };

type Act = (prev: FormState, fd: FormData) => Promise<FormState>;

function ActionButton({
  action,
  sponsorshipId,
  label,
  pendingLabel,
  className,
  confirm,
}: {
  action: Act;
  sponsorshipId: string;
  label: string;
  pendingLabel: string;
  className: string;
  confirm?: string;
}) {
  const [state, formAction, pending] = useActionState(action, initial);
  return (
    <span style={{ display: "inline-flex", alignItems: "center", gap: 8 }}>
      <form
        action={formAction}
        style={{ display: "inline" }}
        onSubmit={confirm ? (e) => { if (!window.confirm(confirm)) e.preventDefault(); } : undefined}
      >
        <input type="hidden" name="sponsorshipId" value={sponsorshipId} />
        <button type="submit" className={className} disabled={pending}>
          {pending ? pendingLabel : label}
        </button>
      </form>
      {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
    </span>
  );
}

function WithdrawForm({ sponsorshipId }: { sponsorshipId: string }) {
  const [state, formAction, pending] = useActionState(withdrawSponsorshipAction, initial);
  return (
    <form
      action={formAction}
      style={{ display: "flex", flexWrap: "wrap", alignItems: "center", gap: 8 }}
      onSubmit={(e) => { if (!window.confirm("Withdraw this sponsorship?")) e.preventDefault(); }}
    >
      <input type="hidden" name="sponsorshipId" value={sponsorshipId} />
      <input type="text" name="reason" placeholder="Reason (optional)" style={{ minWidth: 220 }} />
      <button type="submit" className="btn btn-danger" disabled={pending}>
        {pending ? "Withdrawing…" : "Withdraw"}
      </button>
      {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
    </form>
  );
}

function CompleteForm({ sponsorshipId }: { sponsorshipId: string }) {
  const [state, formAction, pending] = useActionState(completeSponsorshipAction, initial);
  return (
    <form
      action={formAction}
      style={{ display: "flex", flexWrap: "wrap", alignItems: "center", gap: 8 }}
      onSubmit={(e) => { if (!window.confirm("Mark this sponsorship completed? The clawback window runs from the completion date you set (blank = today).")) e.preventDefault(); }}
    >
      <input type="hidden" name="sponsorshipId" value={sponsorshipId} />
      <label className="hint" style={{ margin: 0 }}>Completion date</label>
      <input type="date" name="completionDate" />
      <button type="submit" className="btn btn-grn" disabled={pending}>
        {pending ? "Saving…" : "Mark completed"}
      </button>
      {state.error ? <span className="form-err" style={{ margin: 0 }}>{state.error}</span> : null}
    </form>
  );
}

export default function SponsorshipActions({
  id,
  status,
  canManage,
  canApprove,
  selfProposed,
}: {
  id: string;
  status: string;
  canManage: boolean;
  canApprove: boolean;
  selfProposed: boolean;
}) {
  if (status === "COMPLETED" || status === "WITHDRAWN") {
    return (
      <p className="faint" style={{ margin: 0 }}>
        {status === "COMPLETED"
          ? "Completed — exposure now follows the bonding window below."
          : "Withdrawn — no further actions."}
      </p>
    );
  }

  return (
    <div style={{ display: "flex", flexWrap: "wrap", alignItems: "center", gap: 12 }}>
      {status === "PROPOSED" ? (
        canApprove ? (
          selfProposed ? (
            <p className="note" style={{ margin: 0 }}>
              <span>ℹ</span>
              <span>You proposed this sponsorship — it needs a different Executive approver (no self-approval).</span>
            </p>
          ) : (
            <ActionButton
              action={approveSponsorshipAction}
              sponsorshipId={id}
              label="Approve"
              pendingLabel="Approving…"
              className="btn btn-grn"
            />
          )
        ) : (
          <p className="faint" style={{ margin: 0 }}>Awaiting Executive approval.</p>
        )
      ) : null}

      {status === "APPROVED" && canManage ? (
        <ActionButton
          action={startSponsorshipAction}
          sponsorshipId={id}
          label="Mark in progress"
          pendingLabel="Saving…"
          className="btn btn-pri"
        />
      ) : null}

      {status === "IN_PROGRESS" && canManage ? (
        <CompleteForm sponsorshipId={id} />
      ) : null}

      {canManage ? <WithdrawForm sponsorshipId={id} /> : null}
    </div>
  );
}
