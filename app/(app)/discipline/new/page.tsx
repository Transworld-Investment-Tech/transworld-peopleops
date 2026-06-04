import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getActiveEmployeeOptions } from "@/lib/disciplinary";
import { OpenCaseForm } from "@/components/discipline/DisciplineControls";

export const metadata = { title: "New disciplinary case · Transworld PeopleOps" };

export default async function NewDisciplinaryCasePage() {
  await requirePermission("discipline.manage");
  const employees = await getActiveEmployeeOptions();
  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/discipline" className="back-link">← Disciplinary</Link>
          <h1 className="serif" style={{ marginTop: 6 }}>Open a disciplinary case</h1>
          <p>Conduct only. The case is recorded in the audit log.</p>
        </div>
      </div>
      <div className="card">
        <div className="card-pad">
          <OpenCaseForm employees={employees} />
        </div>
      </div>
    </>
  );
}
