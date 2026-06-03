"use client";

import { useActionState } from "react";
import { createSponsorshipAction, type FormState } from "@/lib/sponsorship-actions";

const initial: FormState = { ok: false };

export default function SponsorshipForm({
  employees,
  modules,
}: {
  employees: { id: string; eeId: string; name: string; grade: string | null }[];
  modules: { id: string; title: string }[];
}) {
  const [state, action, pending] = useActionState(createSponsorshipAction, initial);

  return (
    <form action={action}>
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="form-grid">
        <div className="field">
          <label>Employee</label>
          <select name="employeeId" defaultValue="">
            <option value="" disabled>
              Choose an employee…
            </option>
            {employees.map((e) => (
              <option key={e.id} value={e.id}>
                {e.eeId} · {e.name}
                {e.grade ? ` (${e.grade})` : ""}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label>Qualification</label>
          <input type="text" name="qualificationName" placeholder="e.g. CFA Program, CIS Diploma, ICAN" />
        </div>
        <div className="field">
          <label>Awarding body (optional)</label>
          <input type="text" name="awardingBody" placeholder="e.g. CFA Institute, CIS, ICAN" />
        </div>
        <div className="field">
          <label>Linked L&amp;D module (optional)</label>
          <select name="learningModuleId" defaultValue="">
            <option value="">— none —</option>
            {modules.map((m) => (
              <option key={m.id} value={m.id}>
                {m.title}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label>Service commitment (months)</label>
          <input type="number" name="bondingMonths" min={0} step={1} defaultValue={12} placeholder="e.g. 12" />
        </div>
        <div className="field">
          <label>Bond starts</label>
          <select name="bondingStartBasis" defaultValue="ON_COMPLETION">
            <option value="ON_COMPLETION">On completion (canonical — clock starts when qualified)</option>
            <option value="ON_APPROVAL">On approval (legacy — includes study period)</option>
          </select>
        </div>
        <div className="field full">
          <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <input type="checkbox" name="bondingWaived" style={{ width: "auto" }} />
            <span>Waive the service commitment (no repayment exposure)</span>
          </label>
        </div>
        <div className="field full">
          <label>Note (optional)</label>
          <textarea name="note" rows={2} placeholder="Agreed terms, context, conditions…" />
        </div>
      </div>

      <p className="hint" style={{ marginTop: 12 }}>
        Creates the sponsorship as <b>Proposed</b>. People Ops / Finance add the funded cost lines and
        exam attempts; an Executive approver signs it off (a sponsorship can&apos;t be approved by the
        person who proposed it). Outstanding repayment exposure is shown live from the cost lines and
        the bonding window — nothing is paid here.
      </p>

      <div className="form-actions">
        <button type="submit" className="btn btn-pri" disabled={pending || employees.length === 0}>
          {pending ? "Creating…" : "Create sponsorship"}
        </button>
      </div>
    </form>
  );
}
