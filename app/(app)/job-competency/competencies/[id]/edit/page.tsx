import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getCompetency } from "@/lib/jobframework";
import CompetencyForm from "@/components/jobcompetency/CompetencyForm";

export const metadata = { title: "Edit competency · Transworld PeopleOps" };

export default async function EditCompetencyPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requirePermission("jobframework.manage");
  const { id } = await params;
  const c = await getCompetency(id);
  if (!c) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/job-competency/competencies" className="back-link">
            ← Competencies
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Edit competency
          </h1>
          <p>Changes are recorded in the audit log.</p>
        </div>
      </div>

      <CompetencyForm mode="edit" initial={{ id: c.id, name: c.name, category: c.category }} />
    </>
  );
}
