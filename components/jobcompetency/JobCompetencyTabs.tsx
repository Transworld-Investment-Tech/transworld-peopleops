"use client";
// Sub-navigation inside the Job & Competency module (no extra sidebar item).
// "Job profiles" and "Competencies" are sibling routes under /job-competency.
import Link from "next/link";
import { usePathname } from "next/navigation";

export default function JobCompetencyTabs() {
  const path = usePathname();
  const onComp = path.startsWith("/job-competency/competencies");
  const onProfiles = !onComp;

  return (
    <div className="tabs" role="tablist" aria-label="Job & Competency views">
      <Link
        href="/job-competency"
        role="tab"
        aria-selected={onProfiles}
        className={"tab" + (onProfiles ? " active" : "")}
      >
        Job profiles
      </Link>
      <Link
        href="/job-competency/competencies"
        role="tab"
        aria-selected={onComp}
        className={"tab" + (onComp ? " active" : "")}
      >
        Competencies
      </Link>
    </div>
  );
}
