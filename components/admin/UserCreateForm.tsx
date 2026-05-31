"use client";
import { useActionState, useState } from "react";
import { provisionUserAction, type AdminActionState } from "@/lib/admin-users-actions";

type Option = { id: string; label: string; email: string };

const EMPTY: AdminActionState = { ok: false };

export default function UserCreateForm({ employees }: { employees: Option[] }) {
  const [state, formAction, pending] = useActionState(provisionUserAction, EMPTY);
  const [selected, setSelected] = useState<string>(employees[0]?.id ?? "");
  const [email, setEmail] = useState<string>(employees[0]?.email ?? "");
  const fe = state.fieldErrors ?? {};

  function onPick(id: string) {
    setSelected(id);
    const opt = employees.find((e) => e.id === id);
    setEmail(opt?.email ?? "");
  }

  return (
    <form action={formAction}>
      {state.error && <div className="form-err">{state.error}</div>}
      {state.ok && state.message && (
        <div
          className="note"
          style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}
        >
          <span>✓</span>
          <div>{state.message}</div>
        </div>
      )}

      <div className="form-grid">
        <div className="field">
          <label htmlFor="employeeId">Employee</label>
          <select
            id="employeeId"
            name="employeeId"
            value={selected}
            onChange={(e) => onPick(e.target.value)}
          >
            {employees.map((e) => (
              <option key={e.id} value={e.id}>
                {e.label}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="email">Work email (login)</label>
          <input
            id="email"
            name="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="first.last@transworldltd.com.ng"
          />
          {fe.email && <span className="err">{fe.email}</span>}
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending || !selected}>
          {pending ? "Creating…" : "Create login & link"}
        </button>
      </div>
      <p className="faint" style={{ fontSize: 12.5, marginTop: 8 }}>
        The new account starts with the shared initial password and the
        <b> Employee</b> role. The person changes their password after signing
        in; a Super Admin can adjust roles below.
      </p>
    </form>
  );
}
