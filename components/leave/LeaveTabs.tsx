import Link from "next/link";

// Sub-navigation for the Leave module, styled like the Compensation cycle tabs.
// Balances and Types are management views, so the page only includes them for
// users who hold leave.manage (passed via `showManage`).
export default function LeaveTabs({
  active,
  pendingCount = 0,
  showManage = false,
}: {
  active: "requests" | "balances" | "types";
  pendingCount?: number;
  showManage?: boolean;
}) {
  const tabs: { key: string; label: string; href: string }[] = [
    { key: "requests", label: "Requests", href: "/leave" },
    ...(showManage
      ? [
          { key: "balances", label: "Balances", href: "/leave/balances" },
          { key: "types", label: "Leave types", href: "/leave/types" },
        ]
      : []),
  ];

  return (
    <div className="cyc-tabs" style={{ marginBottom: 18 }}>
      {tabs.map((t) => (
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
