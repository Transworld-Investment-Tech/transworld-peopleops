"use client";

// app/(app)/help/HelpSearch.tsx — renders the /help index from the pre-filtered
// groups passed by the server page, with a simple client-side search box.

import { useMemo, useState } from "react";
import type { HelpEntry } from "@/lib/help";

type Group = { section: string; entries: HelpEntry[] };

function slugId(slug: string): string {
  return slug.replace(/[^a-z0-9]+/gi, "-");
}

export default function HelpSearch({ groups }: { groups: Group[] }) {
  const [q, setQ] = useState("");

  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase();
    if (!needle) return groups;
    const match = (e: HelpEntry) =>
      [
        e.title,
        e.purpose,
        e.audience,
        e.section,
        e.workflow ?? "",
        e.gotchas.join(" "),
        e.actions.map((a) => `${a.label} ${a.what}`).join(" "),
      ]
        .join(" ")
        .toLowerCase()
        .includes(needle);
    return groups
      .map((g) => ({ section: g.section, entries: g.entries.filter(match) }))
      .filter((g) => g.entries.length > 0);
  }, [q, groups]);

  const total = filtered.reduce((n, g) => n + g.entries.length, 0);

  return (
    <div className="help-index">
      <div className="help-search">
        <input
          className="help-search-input"
          type="search"
          placeholder="Search help — page, action, or topic…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          aria-label="Search help"
        />
        <span className="help-search-count">{total} page{total === 1 ? "" : "s"}</span>
      </div>

      {filtered.length === 0 && <div className="note"><span>ℹ</span><div>No help matches “{q}”.</div></div>}

      {filtered.map((g) => (
        <section key={g.section} className="help-group">
          <h2 className="help-group-h">{g.section}</h2>
          <div className="help-cards">
            {g.entries.map((e) => (
              <article key={e.slug} id={slugId(e.slug)} className="card help-card">
                <div className="help-card-h">
                  <h3>{e.title}</h3>
                  {e.status === "coming_soon" && <span className="help-flag help-flag-soon">coming soon</span>}
                </div>
                <p className="help-purpose">{e.purpose}</p>
                <p className="help-who"><b>Who:</b> {e.audience}</p>
                {e.actions.length > 0 && (
                  <ul className="help-actions">
                    {e.actions.map((a) => (
                      <li key={a.label}>
                        <b>{a.label}</b> — {a.what}
                        {a.separation && <span className="help-flag help-flag-sep">two people, on purpose</span>}
                        {a.immutable && <span className="help-flag help-flag-lock">permanent once done</span>}
                      </li>
                    ))}
                  </ul>
                )}
                {e.workflow && <p className="help-where"><b>Where this sits:</b> {e.workflow}</p>}
                {e.gotchas.length > 0 && (
                  <ul className="help-gotchas">
                    {e.gotchas.map((x, i) => (
                      <li key={i}>{x}</li>
                    ))}
                  </ul>
                )}
              </article>
            ))}
          </div>
        </section>
      ))}
    </div>
  );
}
