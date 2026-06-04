"use client";

// components/HelpDrawer.tsx — the in-app Help drawer.
// Wired once into the Topbar (so it reaches every page). It reads the current
// route, resolves it to a help-registry entry (with parent fallback so it's
// never blank), and renders that entry filtered by what THIS user can do —
// using the same permission set the pages enforce.

import { useEffect, useMemo, useState } from "react";
import { usePathname } from "next/navigation";
import Link from "next/link";
import { helpFor, resolveSlugFromPath, visibleActions } from "@/lib/help";

export default function HelpDrawer({ perms }: { perms: string[] }) {
  const [open, setOpen] = useState(false);
  const pathname = usePathname() || "/dashboard";
  const permSet = useMemo(() => new Set(perms), [perms]);

  const entry = useMemo(() => helpFor(resolveSlugFromPath(pathname)), [pathname]);

  // Close on Escape.
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setOpen(false);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open]);

  const actions = entry ? visibleActions(entry, permSet) : [];

  return (
    <>
      <button
        type="button"
        className="btn help-trigger"
        aria-label="Help for this page"
        aria-haspopup="dialog"
        aria-expanded={open}
        onClick={() => setOpen(true)}
        title="Help for this page"
      >
        ?
      </button>

      {open && (
        <div className="help-backdrop" onClick={() => setOpen(false)}>
          <aside
            className="help-drawer"
            role="dialog"
            aria-label="Page help"
            aria-modal="true"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="help-drawer-h">
              <div>
                <div className="help-eyebrow">Help · {entry ? entry.section : "Portal"}</div>
                <h2>{entry ? entry.title : "Help"}</h2>
              </div>
              <button type="button" className="btn help-close" aria-label="Close help" onClick={() => setOpen(false)}>
                ✕
              </button>
            </div>

            <div className="help-drawer-body">
              {!entry && (
                <p className="help-muted">
                  There&apos;s no page-specific help here yet. Open the full Help index for everything.
                </p>
              )}

              {entry && (
                <>
                  {entry.status === "coming_soon" && (
                    <div className="note">
                      <span>ℹ</span>
                      <div>
                        <b>Coming soon.</b> This module is part of the planned build sequence. You can
                        reach it because your role grants permission; the full interface arrives in a
                        later phase.
                      </div>
                    </div>
                  )}

                  <p className="help-purpose">{entry.purpose}</p>

                  <div className="help-sect">
                    <h3>Who can use this</h3>
                    <p>{entry.audience}</p>
                  </div>

                  <div className="help-sect">
                    <h3>What you can do here</h3>
                    {actions.length === 0 ? (
                      <p className="help-muted">
                        {entry.actions.length === 0
                          ? "This page is for viewing — there are no actions to take."
                          : "This page is read-only for your role — you can view it but not change anything."}
                      </p>
                    ) : (
                      <ul className="help-actions">
                        {actions.map((a) => (
                          <li key={a.label}>
                            <b>{a.label}</b> — {a.what}
                            {a.separation && <span className="help-flag help-flag-sep">two people, on purpose</span>}
                            {a.immutable && <span className="help-flag help-flag-lock">permanent once done</span>}
                          </li>
                        ))}
                      </ul>
                    )}
                  </div>

                  {entry.workflow && (
                    <div className="help-sect">
                      <h3>Where this sits</h3>
                      <p>{entry.workflow}</p>
                    </div>
                  )}

                  {entry.gotchas.length > 0 && (
                    <div className="help-sect">
                      <h3>Good to know</h3>
                      <ul className="help-gotchas">
                        {entry.gotchas.map((g, i) => (
                          <li key={i}>{g}</li>
                        ))}
                      </ul>
                    </div>
                  )}

                  {entry.related.length > 0 && (
                    <div className="help-sect">
                      <h3>Related</h3>
                      <div className="help-related">
                        {entry.related.map((r) => {
                          const rel = helpFor(r);
                          if (!rel) return null;
                          return (
                            <Link key={r} className="help-chip" href={`/help#${slugId(r)}`} onClick={() => setOpen(false)}>
                              {rel.title}
                            </Link>
                          );
                        })}
                      </div>
                    </div>
                  )}
                </>
              )}
            </div>

            <div className="help-drawer-f">
              <Link className="btn btn-pri" href="/help" onClick={() => setOpen(false)}>
                Open full Help
              </Link>
            </div>
          </aside>
        </div>
      )}
    </>
  );
}

function slugId(slug: string): string {
  return slug.replace(/[^a-z0-9]+/gi, "-");
}
