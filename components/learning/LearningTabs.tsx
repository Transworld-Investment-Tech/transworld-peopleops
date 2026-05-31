import Link from "next/link";

// Sub-navigation for Learning & Development. Server component; styled like the
// cycle tabs used elsewhere. The active tab is passed in by each page.
const TABS: { key: string; label: string; href: string }[] = [
  { key: "library", label: "Library", href: "/learning" },
  { key: "my", label: "My learning", href: "/learning/my" },
  { key: "handbook", label: "Employee handbook", href: "/learning/handbook" },
];

export default function LearningTabs({
  active,
}: {
  active: "library" | "my" | "handbook";
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
        </Link>
      ))}
    </div>
  );
}
