"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { NavSection } from "@/lib/permissions";

export default function Sidebar({ sections }: { sections: NavSection[] }) {
  const path = usePathname();
  return (
    <aside className="side">
      <div className="brand">
        <div className="brand-mark">
          <span>T</span>
        </div>
        <div>
          <div className="brand-name">Transworld</div>
          <div className="brand-sub">PeopleOps Portal</div>
        </div>
      </div>
      <nav className="nav">
        {sections.map((sec) => (
          <div key={sec.label}>
            <div className="nav-label">{sec.label}</div>
            {sec.items.map((it) => {
              const href = `/${it.slug}`;
              const active = path === href || path.startsWith(href + "/");
              return (
                <Link key={it.slug} href={href} className={active ? "active" : ""}>
                  <span
                    className="ic-wrap"
                    dangerouslySetInnerHTML={{ __html: it.icon }}
                  />
                  {it.label}
                </Link>
              );
            })}
          </div>
        ))}
      </nav>
      <div className="side-foot">
        Transworld Investment &amp; Securities Ltd
        <br />
        SEC-regulated · Lagos, Nigeria
      </div>
    </aside>
  );
}
