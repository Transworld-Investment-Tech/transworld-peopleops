"use client";
// Sub-navigation tabs that live INSIDE the Employees module (no extra sidebar
// item). "Directory" and "Org chart" are sibling routes under /employees; the
// org chart is therefore a tab here, exactly as specified. Active state is
// derived from the current path.
import Link from "next/link";
import { usePathname } from "next/navigation";

export default function EmployeesTabs() {
  const path = usePathname();
  const onOrg = path === "/employees/org" || path.startsWith("/employees/org/");
  const onDirectory = path === "/employees";

  return (
    <div className="tabs" role="tablist" aria-label="Employees views">
      <Link
        href="/employees"
        role="tab"
        aria-selected={onDirectory}
        className={"tab" + (onDirectory ? " active" : "")}
      >
        Directory
      </Link>
      <Link
        href="/employees/org"
        role="tab"
        aria-selected={onOrg}
        className={"tab" + (onOrg ? " active" : "")}
      >
        Org chart
      </Link>
    </div>
  );
}
