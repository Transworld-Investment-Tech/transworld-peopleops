import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { CYCLE_STAGES } from "@/lib/performance";
import CycleForm from "@/components/performance/CycleForm";

export const metadata = { title: "Open review cycle · Transworld PeopleOps" };

export default async function NewCyclePage() {
  await requirePermission("performance.manage");
  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance" className="back-link">
            ← Performance
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Open review cycle
          </h1>
          <p>
            A cycle is the period staff are appraised over (e.g. Q2 2026). Recorded in
            the audit log.
          </p>
        </div>
      </div>
      <CycleForm stages={CYCLE_STAGES.map((s) => ({ value: s.value, label: s.label }))} />
    </>
  );
}
