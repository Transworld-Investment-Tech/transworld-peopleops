"use client";

// =============================================================================
// components/learning/LibraryBrowser.tsx — v0.55.0
// Client-side instant filtering of the L&D course library. BOTH dimensions are
// multi-select: LEVEL (100/200/300 = F/P/E, segmented toggles) and CATEGORY (the
// ten LMS domains, checklist dropdown), combined as AND across dimensions / OR
// within a dimension; plus a free-text search over code + title. Dismissable
// gold pills mirror the active filters. Zero DB round trips.
//
// v0.55.0: level is now multi-select (was a single-select dropdown); each table
// row carries data-labels + a --dom custom property so the table reflows to
// stacked, domain-tabbed cards on phones (see TW-MOBILE-V0550 in globals.css);
// search placeholder ellipsis fixed.
//
// Client-safe imports only: lib/lms.ts is import-free; LibraryRow is type-only.
// =============================================================================

import { useMemo, useState } from "react";
import Link from "next/link";
import { LMS_DOMAINS, LMS_LEVELS, domainLabel, levelLabel } from "@/lib/lms";
import type { LibraryRow } from "@/lib/learning";

const DOMAIN_COLOR: Record<string, string> = {
  FND: "#1c3a66",
  REG: "#8a1c1c",
  FIN: "#0f6e56",
  INV: "#3c3489",
  OPS: "#854f0b",
  TEC: "#1f5fa5",
  LDR: "#993556",
  PPL: "#3b6d11",
  BDV: "#b8960c",
  CLA: "#5f5e5a",
};

// The 1xx / 2xx / 3xx the firm thinks in, mapped onto the stored F/P/E level.
const LEVEL_NUM: Record<string, string> = { F: "100", P: "200", E: "300" };

function fmtMinutes(m: number | null | undefined): string {
  if (!m || m <= 0) return "\u2014";
  if (m < 60) return `${m} min`;
  const h = Math.floor(m / 60);
  const r = m % 60;
  return r ? `${h} h ${r} min` : `${h} h`;
}

function statusBadge(s: string): { cls: string; label: string } {
  if (s === "PUBLISHED") return { cls: "b-grn", label: "Published" };
  if (s === "DRAFT") return { cls: "b-gry", label: "Draft" };
  return { cls: "b-gry", label: s };
}

export default function LibraryBrowser({
  rows,
  canManage,
}: {
  rows: LibraryRow[];
  canManage: boolean;
}) {
  const [q, setQ] = useState("");
  const [levels, setLevels] = useState<string[]>([]);
  const [cats, setCats] = useState<string[]>([]);
  const [open, setOpen] = useState(false);

  const counts = useMemo(() => {
    const c: Record<string, number> = {};
    for (const r of rows) if (r.domain) c[r.domain] = (c[r.domain] ?? 0) + 1;
    return c;
  }, [rows]);

  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase();
    return rows.filter((r) => {
      if (levels.length && !(r.level && levels.includes(r.level))) return false;
      if (cats.length && !(r.domain && cats.includes(r.domain))) return false;
      if (needle) {
        const hay = `${r.code ?? ""} ${r.title}`.toLowerCase();
        if (!hay.includes(needle)) return false;
      }
      return true;
    });
  }, [rows, q, levels, cats]);

  function toggleLevel(v: string) {
    setLevels((cur) => (cur.includes(v) ? cur.filter((x) => x !== v) : [...cur, v]));
  }
  function toggleCat(v: string) {
    setCats((cur) => (cur.includes(v) ? cur.filter((x) => x !== v) : [...cur, v]));
  }

  const hasFilters = levels.length > 0 || cats.length > 0;

  return (
    <>
      <div className="lib-tool">
        <label className="lib-search">
          <svg
            width="15"
            height="15"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            aria-hidden="true"
          >
            <circle cx="11" cy="11" r="7" />
            <path d="M21 21l-4.3-4.3" />
          </svg>
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="Search code or title…"
            aria-label="Search modules"
          />
        </label>

        <div className="lib-lvl" role="group" aria-label="Filter by level">
          {LMS_LEVELS.map((l) => {
            const on = levels.includes(l.value);
            return (
              <button
                key={l.value}
                type="button"
                className={"lib-lvl-btn" + (on ? " on" : "")}
                aria-pressed={on}
                title={l.label}
                onClick={() => toggleLevel(l.value)}
              >
                {LEVEL_NUM[l.value]}
              </button>
            );
          })}
        </div>

        <div className="lib-ms">
          <button
            type="button"
            className="lib-ms-btn"
            aria-expanded={open}
            onClick={() => setOpen((o) => !o)}
          >
            Category
            {cats.length ? <span className="ct">{cats.length}</span> : null}
            <span aria-hidden="true" style={{ fontSize: 11 }}>
              {"\u25be"}
            </span>
          </button>
          {open ? (
            <div className="lib-ms-pop" role="listbox" aria-label="Filter by category">
              {LMS_DOMAINS.map((d) => {
                const on = cats.includes(d.value);
                return (
                  <div
                    key={d.value}
                    className={"lib-ms-opt" + (on ? " on" : "")}
                    role="option"
                    aria-selected={on}
                    onClick={() => toggleCat(d.value)}
                  >
                    <span className="bx" aria-hidden="true">
                      {on ? "\u2713" : ""}
                    </span>
                    <span>{d.label}</span>
                    <span className="cd">
                      {d.value} · {counts[d.value] ?? 0}
                    </span>
                  </div>
                );
              })}
            </div>
          ) : null}
        </div>
      </div>

      {hasFilters ? (
        <div className="lib-pills">
          {levels.map((lv) => (
            <button key={lv} type="button" className="lib-pill" onClick={() => toggleLevel(lv)}>
              {LEVEL_NUM[lv]} · {levelLabel(lv)}
              <span aria-hidden="true">{"\u2715"}</span>
            </button>
          ))}
          {cats.map((c) => (
            <button key={c} type="button" className="lib-pill" onClick={() => toggleCat(c)}>
              {c} · {domainLabel(c)}
              <span aria-hidden="true">{"\u2715"}</span>
            </button>
          ))}
          {levels.length + cats.length > 1 ? (
            <button
              type="button"
              className="lib-pill lib-pill-clear"
              onClick={() => {
                setLevels([]);
                setCats([]);
              }}
            >
              Clear all
            </button>
          ) : null}
        </div>
      ) : null}

      {filtered.length === 0 ? (
        <p className="lib-empty">No modules match these filters.</p>
      ) : (
        <table className="lib-table">
          <thead>
            <tr>
              <th>Code</th>
              <th>Module</th>
              <th>Domain</th>
              <th className="num">Time</th>
              <th className="num">Enrolled</th>
              <th>Completion</th>
              {canManage ? <th>Status</th> : null}
            </tr>
          </thead>
          <tbody>
            {filtered.map((r) => {
              const color = (r.domain && DOMAIN_COLOR[r.domain]) || "var(--line)";
              const sb = statusBadge(r.status);
              return (
                <tr key={r.id} style={{ ["--dom" as string]: color }}>
                  <td className="mono faint" data-label="Code">
                    {r.code ?? "\u2014"}
                  </td>
                  <td className="lib-mod" data-label="Module">
                    <Link href={`/learning/modules/${r.id}`} className="jc-link">
                      {r.title}
                    </Link>
                    <div className="ln-meta" style={{ marginTop: 4 }}>
                      {r.level ? <span className="b b-gry">{levelLabel(r.level)}</span> : null}
                      {r.isMandatory ? <span className="b b-red">Mandatory</span> : null}
                    </div>
                  </td>
                  <td className="lib-dom" data-label="Domain" style={{ color }}>
                    {r.domain ? domainLabel(r.domain) : <span className="faint">{r.category}</span>}
                  </td>
                  <td className="num faint" data-label="Time">
                    {fmtMinutes(r.estimatedMinutes)}
                  </td>
                  <td className="num mono" data-label="Enrolled">
                    {r.enrolled}
                  </td>
                  <td data-label="Completion">
                    <div className="ln-prog">
                      <span className={"bar" + (r.overdue ? " warn" : "")}>
                        <i style={{ width: `${r.completionPct}%` }} />
                      </span>
                      <span className="pct">{r.completionPct}%</span>
                    </div>
                  </td>
                  {canManage ? (
                    <td data-label="Status">
                      <span className={`b ${sb.cls}`}>{sb.label}</span>
                    </td>
                  ) : null}
                </tr>
              );
            })}
          </tbody>
        </table>
      )}

      <div className="lib-count">
        Showing {filtered.length} of {rows.length} module{rows.length === 1 ? "" : "s"}
      </div>
    </>
  );
}
