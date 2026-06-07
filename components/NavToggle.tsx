"use client";

// =============================================================================
// components/NavToggle.tsx — v0.55.0
// Mobile navigation control. On phones the desktop sidebar (.side) becomes an
// off-canvas drawer (see TW-MOBILE-V0550 in globals.css); this renders the
// hamburger that opens it and the backdrop that closes it. Open state is a
// single `nav-open` class on <html>, so no shared context is needed — the
// existing <Sidebar> markup is reused as-is. The drawer auto-closes on any
// route change. The hamburger is hidden on desktop via CSS.
// =============================================================================

import { useEffect } from "react";
import { usePathname } from "next/navigation";

export default function NavToggle() {
  const path = usePathname();

  // Close the drawer whenever the route changes (i.e. a nav link was tapped).
  useEffect(() => {
    document.documentElement.classList.remove("nav-open");
  }, [path]);

  function toggle() {
    document.documentElement.classList.toggle("nav-open");
  }
  function close() {
    document.documentElement.classList.remove("nav-open");
  }

  return (
    <>
      <button
        type="button"
        className="nav-burger"
        aria-label="Open navigation"
        onClick={toggle}
      >
        <svg
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          aria-hidden="true"
        >
          <path d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <div className="nav-backdrop" aria-hidden="true" onClick={close} />
    </>
  );
}
