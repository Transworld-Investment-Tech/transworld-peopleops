"use client";
import { useActionState } from "react";
import Link from "next/link";
import {
  updateEmployeeAction,
  createEmployeeAction,
  type FormState,
} from "@/lib/employees-actions";

type Option = { value: string; label: string };
type Initial = {
  id?: string;
  eeId?: string;
  fullName?: string;
  preferredName?: string | null;
  workEmail?: string | null;
  phone?: string | null;
  departmentId?: string | null;
  jobProfileId?: string | null;
  grade?: string | null;
  payCategoryId?: string | null;
  managerId?: string | null;
  employmentType?: string;
  status?: string;
  startDate?: string | null; // YYYY-MM-DD
  bankNameMasked?: string | null;
  bankAcctMasked?: string | null;
};

const EMPTY: FormState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function EmployeeForm({
  mode,
  initial,
  departments,
  jobProfiles,
  payCategories,
  managers,
  employmentTypes,
  statuses,
}: {
  mode: "edit" | "create";
  initial: Initial;
  departments: { id: string; name: string }[];
  jobProfiles: { id: string; title: string }[];
  payCategories: { id: string; name: string }[];
  managers: { id: string; eeId: string; fullName: string }[];
  employmentTypes: Option[];
  statuses: Option[];
}) {
  const action = mode === "create" ? createEmployeeAction : updateEmployeeAction;
  const [state, formAction, pending] = useActionState(action, EMPTY);
  const fe = state.fieldErrors ?? {};
  const cancelHref = mode === "edit" && initial.id ? `/employees/${initial.id}` : "/employees";

  return (
    <form action={formAction}>
      {mode === "edit" && <input type="hidden" name="id" value={initial.id} />}
      {state.error && <div className="form-err">{state.error}</div>}

      <div className="card">
        <div className="card-h">
          <h3>Identity</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            {mode === "create" && (
              <div className="field">
                <label htmlFor="eeId">Employee ID</label>
                <input id="eeId" name="eeId" defaultValue={initial.eeId ?? ""} placeholder="EID 20" />
                <Err msg={fe.eeId} />
              </div>
            )}
            <div className="field">
              <label htmlFor="fullName">Full name</label>
              <input id="fullName" name="fullName" defaultValue={initial.fullName ?? ""} placeholder="LAST, FIRST MIDDLE" />
              <Err msg={fe.fullName} />
            </div>
            <div className="field">
              <label htmlFor="preferredName">Preferred name</label>
              <input id="preferredName" name="preferredName" defaultValue={initial.preferredName ?? ""} />
            </div>
            <div className="field">
              <label htmlFor="workEmail">Work email</label>
              <input id="workEmail" name="workEmail" defaultValue={initial.workEmail ?? ""} />
              <Err msg={fe.workEmail} />
            </div>
            <div className="field">
              <label htmlFor="phone">Phone</label>
              <input id="phone" name="phone" defaultValue={initial.phone ?? ""} />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Organization &amp; employment</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="departmentId">Department</label>
              <select id="departmentId" name="departmentId" defaultValue={initial.departmentId ?? ""}>
                <option value="">—</option>
                {departments.map((d) => (
                  <option key={d.id} value={d.id}>{d.name}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="jobProfileId">Job profile</label>
              <select id="jobProfileId" name="jobProfileId" defaultValue={initial.jobProfileId ?? ""}>
                <option value="">—</option>
                {jobProfiles.map((j) => (
                  <option key={j.id} value={j.id}>{j.title}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="grade">Grade</label>
              <select id="grade" name="grade" defaultValue={initial.grade ?? ""}>
                <option value="">Use role default</option>
                {["G0", "G1", "G2", "G3", "G4", "G5", "PT"].map((g) => (
                  <option key={g} value={g}>{g}</option>
                ))}
              </select>
              <span className="hint">The person&rsquo;s grade. Leave on &ldquo;role default&rdquo; to inherit the job profile&rsquo;s grade.</span>
            </div>
            <div className="field">
              <label htmlFor="payCategoryId">Pay category</label>
              <select id="payCategoryId" name="payCategoryId" defaultValue={initial.payCategoryId ?? ""}>
                <option value="">—</option>
                {payCategories.map((c) => (
                  <option key={c.id} value={c.id}>{c.name}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="managerId">Manager</label>
              <select id="managerId" name="managerId" defaultValue={initial.managerId ?? ""}>
                <option value="">— (top of tree)</option>
                {managers.map((m) => (
                  <option key={m.id} value={m.id}>{m.fullName} · {m.eeId}</option>
                ))}
              </select>
              <Err msg={fe.managerId} />
            </div>
            <div className="field">
              <label htmlFor="employmentType">Employment type</label>
              <select id="employmentType" name="employmentType" defaultValue={initial.employmentType ?? "FULL_TIME"}>
                {employmentTypes.map((t) => (
                  <option key={t.value} value={t.value}>{t.label}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="status">Status</label>
              <select id="status" name="status" defaultValue={initial.status ?? "ACTIVE"}>
                {statuses.map((s) => (
                  <option key={s.value} value={s.value}>{s.label}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="startDate">Start date</label>
              <input id="startDate" name="startDate" type="date" defaultValue={initial.startDate ?? ""} />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Banking</h3>
          <span className="hint">Store masked values only (e.g. last 4 digits)</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="bankNameMasked">Bank</label>
              <input id="bankNameMasked" name="bankNameMasked" defaultValue={initial.bankNameMasked ?? ""} />
            </div>
            <div className="field">
              <label htmlFor="bankAcctMasked">Account (last 4)</label>
              <input id="bankAcctMasked" name="bankAcctMasked" defaultValue={initial.bankAcctMasked ?? ""} placeholder="1234" />
            </div>
          </div>
        </div>
      </div>

      <div className="form-actions">
        <Link href={cancelHref} className="btn">Cancel</Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : mode === "create" ? "Create employee" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
