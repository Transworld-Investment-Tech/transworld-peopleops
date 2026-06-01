"use client";
import { useActionState } from "react";
import { saveWeeklyReportAction, type FormState } from "@/lib/performance-toolkit-actions";

const EMPTY: FormState = { ok: false };

export default function WeeklyReportForm({
  weekStartIso,
  weekLabel,
  existing,
}: {
  weekStartIso: string; // yyyy-mm-dd of the Monday
  weekLabel: string;
  existing: {
    accomplishments: string;
    priorities: string | null;
    blockers: string | null;
    status: string;
  } | null;
}) {
  const [state, action, pending] = useActionState(saveWeeklyReportAction, EMPTY);
  const submitted = existing?.status === "SUBMITTED";

  if (submitted) {
    return (
      <div>
        <div className="note">
          <span>✓</span>
          <div>
            <b>This week’s report is submitted.</b> {weekLabel}
          </div>
        </div>
        <div style={{ marginTop: 12 }}>
          <div className="field">
            <label>What you accomplished</label>
            <p className="sc-mission" style={{ marginTop: 4 }}>{existing.accomplishments}</p>
          </div>
          {existing.priorities ? (
            <div className="field">
              <label>Next week’s priorities</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{existing.priorities}</p>
            </div>
          ) : null}
          {existing.blockers ? (
            <div className="field">
              <label>Blockers</label>
              <p className="sc-mission" style={{ marginTop: 4 }}>{existing.blockers}</p>
            </div>
          ) : null}
        </div>
      </div>
    );
  }

  return (
    <form action={action}>
      <input type="hidden" name="weekStart" value={weekStartIso} />
      <div className="hint" style={{ marginBottom: 10 }}>{weekLabel}</div>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      {state.ok ? (
        <div className="note" style={{ marginBottom: 10 }}>
          <span>✓</span>
          <div>{state.message ?? "Saved."}</div>
        </div>
      ) : null}
      <div className="field full">
        <label>What you accomplished this week</label>
        <textarea
          name="accomplishments"
          rows={3}
          defaultValue={existing?.accomplishments ?? ""}
          placeholder="Key wins, progress against goals, anything notable"
        />
        {state.fieldErrors?.accomplishments ? (
          <div className="form-err">{state.fieldErrors.accomplishments}</div>
        ) : null}
      </div>
      <div className="field full">
        <label>Next week’s priorities (optional)</label>
        <textarea name="priorities" rows={2} defaultValue={existing?.priorities ?? ""} placeholder="Your focus for the coming week" />
      </div>
      <div className="field full">
        <label>Blockers / support needed (optional)</label>
        <textarea name="blockers" rows={2} defaultValue={existing?.blockers ?? ""} placeholder="Anything getting in your way" />
      </div>
      <div style={{ display: "flex", gap: 8, marginTop: 10, flexWrap: "wrap" }}>
        <button type="submit" name="submit" value="0" className="btn" disabled={pending}>
          {pending ? "Saving…" : "Save draft"}
        </button>
        <button type="submit" name="submit" value="1" className="btn btn-pri" disabled={pending}>
          {pending ? "Submitting…" : "Submit week"}
        </button>
      </div>
      <p className="faint" style={{ fontSize: 11.5, marginTop: 10 }}>
        Submitting locks this week’s report. Save a draft to keep editing.
      </p>
    </form>
  );
}
