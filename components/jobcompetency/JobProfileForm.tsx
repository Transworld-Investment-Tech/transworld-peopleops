"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import {
  createJobProfileAction,
  updateJobProfileAction,
  type FormState,
} from "@/lib/jobframework-actions";
import { FAMILIES } from "@/lib/jobframework-vocab";

type Cat = { id: string; name: string; category: string | null };
type Initial = {
  id?: string;
  title?: string;
  grade?: string | null;
  departmentId?: string | null;
  description?: string | null;
  status?: string;
  family?: string | null;
  isControlFunction?: boolean;
  track?: string | null;
  rung?: string | null;
};

const EMPTY: FormState = { ok: false };
const DEFAULT_LEVEL = 2;
const TRACK_OPTS = [
  { value: "MANAGER", label: "Manager track" },
  { value: "EXPERT", label: "Expert track" },
];
const RUNG_OPTS = [
  { value: "JUNIOR", label: "Junior" },
  { value: "MID", label: "Mid" },
  { value: "SENIOR", label: "Senior" },
];

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export default function JobProfileForm({
  mode,
  initial,
  departments,
  catalog,
  selected,
  statuses,
  levels,
}: {
  mode: "create" | "edit";
  initial: Initial;
  departments: { id: string; name: string }[];
  catalog: Cat[];
  selected: { id: string; level: number }[];
  statuses: { value: string; label: string }[];
  levels: { value: number; label: string }[];
}) {
  const action = mode === "create" ? createJobProfileAction : updateJobProfileAction;
  const [state, formAction, pending] = useActionState(action, EMPTY);
  const fe = state.fieldErrors ?? {};
  const cancelHref =
    mode === "edit" && initial.id ? `/job-competency/${initial.id}` : "/job-competency";

  const [picked, setPicked] = useState<Record<string, number>>(() =>
    Object.fromEntries(selected.map((s) => [s.id, s.level]))
  );
  const serialized = JSON.stringify(
    Object.entries(picked).map(([id, level]) => ({ id, level }))
  );

  // Group the catalog by category for display.
  const groups = new Map<string, Cat[]>();
  for (const c of catalog) {
    const k = c.category ?? "Uncategorized";
    const arr = groups.get(k) ?? [];
    arr.push(c);
    groups.set(k, arr);
  }

  function toggle(id: string) {
    setPicked((p) => {
      const n = { ...p };
      if (id in n) delete n[id];
      else n[id] = DEFAULT_LEVEL;
      return n;
    });
  }
  function setLevel(id: string, lvl: number) {
    setPicked((p) => ({ ...p, [id]: lvl }));
  }

  return (
    <form action={formAction}>
      {mode === "edit" && <input type="hidden" name="id" value={initial.id} />}
      <input type="hidden" name="competencies" value={serialized} />
      {state.error && <div className="form-err">{state.error}</div>}

      <div className="card">
        <div className="card-h">
          <h3>Profile</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="title">Title</label>
              <input
                id="title"
                name="title"
                defaultValue={initial.title ?? ""}
                placeholder="Chief Compliance Officer"
              />
              <Err msg={fe.title} />
            </div>
            <div className="field">
              <label htmlFor="grade">Grade</label>
              <input id="grade" name="grade" defaultValue={initial.grade ?? ""} placeholder="G3" />
            </div>
            <div className="field">
              <label htmlFor="departmentId">Department</label>
              <select id="departmentId" name="departmentId" defaultValue={initial.departmentId ?? ""}>
                <option value="">—</option>
                {departments.map((d) => (
                  <option key={d.id} value={d.id}>
                    {d.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="family">Job family</label>
              <select id="family" name="family" defaultValue={initial.family ?? ""}>
                <option value="">—</option>
                {FAMILIES.map((f) => (
                  <option key={f.value} value={f.value}>{f.label}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="track">Track (G3+)</label>
              <select id="track" name="track" defaultValue={initial.track ?? ""}>
                <option value="">—</option>
                {TRACK_OPTS.map((t) => (
                  <option key={t.value} value={t.value}>{t.label}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="rung">Rung</label>
              <select id="rung" name="rung" defaultValue={initial.rung ?? ""}>
                <option value="">—</option>
                {RUNG_OPTS.map((r) => (
                  <option key={r.value} value={r.value}>{r.label}</option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="isControlFunction" style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <input id="isControlFunction" name="isControlFunction" type="checkbox" defaultChecked={initial.isControlFunction ?? false} style={{ width: "auto" }} />
                <span>Control function (never scored on revenue)</span>
              </label>
            </div>
            <div className="field">
              <label htmlFor="status">Status</label>
              <select id="status" name="status" defaultValue={initial.status ?? "DRAFT"}>
                {statuses.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="field full">
              <label htmlFor="description">Description</label>
              <textarea
                id="description"
                name="description"
                rows={4}
                defaultValue={initial.description ?? ""}
                placeholder="Purpose of the role and key responsibilities…"
              />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Required competencies</h3>
          <span className="hint">{Object.keys(picked).length} selected</span>
        </div>
        <div className="card-pad">
          {catalog.length === 0 ? (
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No competencies defined yet.</b> Add some in the{" "}
                <Link href="/job-competency/competencies">Competencies</Link> tab, then attach
                them here.
              </div>
            </div>
          ) : (
            <div className="jc-picker">
              {Array.from(groups.entries()).map(([cat, items]) => (
                <div className="jc-cat-group" key={cat}>
                  <div className="jc-cat">{cat}</div>
                  {items.map((c) => {
                    const on = c.id in picked;
                    return (
                      <label className={"jc-comp-row" + (on ? " on" : "")} key={c.id}>
                        <input type="checkbox" checked={on} onChange={() => toggle(c.id)} />
                        <span className="jc-comp-name">{c.name}</span>
                        {on ? (
                          <select
                            className="jc-level"
                            value={picked[c.id]}
                            onChange={(e) => setLevel(c.id, Number(e.target.value))}
                            aria-label={`Required level for ${c.name}`}
                          >
                            {levels.map((l) => (
                              <option key={l.value} value={l.value}>
                                {l.label}
                              </option>
                            ))}
                          </select>
                        ) : null}
                      </label>
                    );
                  })}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="form-actions">
        <Link href={cancelHref} className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : mode === "create" ? "Create profile" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
