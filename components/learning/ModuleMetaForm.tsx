"use client";
import { useActionState, useState } from "react";
import { saveModuleMetaAction, type FormState } from "@/lib/lms-actions";
import { LMS_DOMAINS, LMS_LEVELS, LMS_CADENCES, LMS_OWNERS } from "@/lib/lms";

const EMPTY: FormState = { ok: false };

export type MetaInitial = {
  id: string;
  code: string | null;
  domain: string | null;
  level: string | null;
  owner: string | null;
  isMandatory: boolean;
  cadence: string | null;
  passMark: number | null;
  status: string;
};

export default function ModuleMetaForm({ initial }: { initial: MetaInitial }) {
  const [state, formAction, pending] = useActionState(saveModuleMetaAction, EMPTY);
  const fe = state.fieldErrors ?? {};
  const [mandatory, setMandatory] = useState(initial.isMandatory);

  return (
    <form action={formAction}>
      <input type="hidden" name="moduleId" value={initial.id} />
      {state.error ? <div className="form-err">{state.error}</div> : null}
      {state.ok ? <div className="note">Saved.</div> : null}

      <div className="card">
        <div className="card-h">
          <h3>Catalogue &amp; compliance</h3>
          <span className="hint">WS7 curriculum metadata</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label>Module code</label>
              <input name="code" defaultValue={initial.code ?? ""} placeholder="e.g. FND-103" />
              {fe.code ? <span className="err">{fe.code}</span> : null}
            </div>
            <div className="field">
              <label>Domain</label>
              <select name="domain" defaultValue={initial.domain ?? ""}>
                <option value="">—</option>
                {LMS_DOMAINS.map((d) => (
                  <option key={d.value} value={d.value}>
                    {d.value} · {d.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label>Level</label>
              <select name="level" defaultValue={initial.level ?? ""}>
                <option value="">—</option>
                {LMS_LEVELS.map((d) => (
                  <option key={d.value} value={d.value}>
                    {d.value} · {d.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label>Content owner</label>
              <select name="owner" defaultValue={initial.owner ?? ""}>
                <option value="">—</option>
                {LMS_OWNERS.map((d) => (
                  <option key={d.value} value={d.value}>
                    {d.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="field">
              <label>Mandatory</label>
              <label className="row" style={{ gap: 8 }}>
                <input
                  type="checkbox"
                  name="isMandatory"
                  value="1"
                  checked={mandatory}
                  onChange={(e) => setMandatory(e.target.checked)}
                />
                <span>Required training (auto-assignable)</span>
              </label>
            </div>
            <div className="field">
              <label>Cadence</label>
              <select name="cadence" defaultValue={initial.cadence ?? ""}>
                <option value="">—</option>
                {LMS_CADENCES.map((d) => (
                  <option key={d.value} value={d.value}>
                    {d.label}
                  </option>
                ))}
              </select>
              {fe.cadence ? <span className="err">{fe.cadence}</span> : null}
            </div>
            <div className="field">
              <label>Pass mark (%)</label>
              <input name="passMark" defaultValue={initial.passMark ?? ""} placeholder="e.g. 80 (blank = no graded check)" />
              {fe.passMark ? <span className="err">{fe.passMark}</span> : null}
            </div>
            <div className="field">
              <label>Status</label>
              <select name="status" defaultValue={initial.status}>
                <option value="DRAFT">Draft</option>
                <option value="PUBLISHED">Published</option>
                <option value="ARCHIVED">Archived</option>
              </select>
            </div>
          </div>
          <p className="hint" style={{ marginTop: 8 }}>
            A graded module (pass mark set) is completed only on a pass. Mandatory modules need a cadence.
          </p>
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" disabled={pending}>
          {pending ? "Saving…" : "Save catalogue & compliance"}
        </button>
      </div>
    </form>
  );
}
