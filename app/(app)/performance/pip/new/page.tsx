import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getActiveEmployeesLite } from "@/lib/performance-toolkit";
import PipEditor from "@/components/performance/PipEditor";

export const metadata = { title: "Open improvement plan · Transworld PeopleOps" };

export default async function NewPipPage() {
  await requirePermission("performance.manage");
  const employees = await getActiveEmployeesLite();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/performance/pip" className="back-link">
            ← Improvement plans
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Open a performance improvement plan
          </h1>
          <p>
            Set out the concerns, the support to be provided, the expectations to meet, and the review
            window. Recorded in the audit log; the employee acknowledges it in My Performance.
          </p>
        </div>
      </div>
      <PipEditor employees={employees} />
    </>
  );
}
