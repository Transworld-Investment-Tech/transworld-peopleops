import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import CompetencyForm from "@/components/jobcompetency/CompetencyForm";

export const metadata = { title: "Add competency · Transworld PeopleOps" };

export default async function NewCompetencyPage() {
  await requirePermission("jobframework.manage");

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/job-competency/competencies" className="back-link">
            ← Competencies
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Add competency
          </h1>
          <p>Adds a skill to the catalog. This is recorded in the audit log.</p>
        </div>
      </div>

      <CompetencyForm mode="create" initial={{}} />
    </>
  );
}
