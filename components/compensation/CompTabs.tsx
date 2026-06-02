import Link from "next/link";

// Sub-navigation for the Compensation module. Server component — it just renders
// links styled like the cycle tabs used elsewhere. The active tab is passed in by
// each page; the pending count surfaces on the Change requests tab.
const TABS: { key: string; label: string; href: string }[] = [
  { key: "register", label: "Register", href: "/compensation" },
  { key: "bands", label: "Salary bands", href: "/compensation/bands" },
  { key: "positioning", label: "Positioning", href: "/compensation/positioning" },
  { key: "tax", label: "Tax rules", href: "/compensation/tax" },
  { key: "requests", label: "Change requests", href: "/compensation/requests" },
  { key: "raises", label: "Raises", href: "/compensation/raises" },
];

export default function CompTabs({
  active,
  pendingCount = 0,
}: {
  active: "register" | "bands" | "positioning" | "tax" | "requests" | "raises";
  pendingCount?: number;
}) {
  return (
    <div className="cyc-tabs" style={{ marginBottom: 18 }}>
      {TABS.map((t) => (
        <Link
          key={t.key}
          href={t.href}
          className={"cyc-tab" + (t.key === active ? " active" : "")}
        >
          {t.label}
          {t.key === "requests" && pendingCount > 0 ? (
            <span className="comp-tab-count">{pendingCount}</span>
          ) : null}
        </Link>
      ))}
    </div>
  );
}
