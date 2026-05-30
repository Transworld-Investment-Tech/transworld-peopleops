import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getJobProfileFormData, JD_STATUSES, LEVELS } from "@/lib/jobframework";
import JobProfileForm from "@/components/jobcompetency/JobProfileForm";

export const metadata = { title: "Edit job profile · Transworld PeopleOps" };

export default async function EditJobProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requirePermission("jobframework.manage");
  const { id } = await params;
  const { departments, catalog, profile, selected } = await getJobProfileFormData(id);
  if (!profile) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/job-competency/${id}`} className="back-link">
            ← {profile.title}
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Edit job profile
          </h1>
          <p>Changes are recorded in the audit log.</p>
        </div>
      </div>

      <JobProfileForm
        mode="edit"
        initial={{
          id: profile.id,
          title: profile.title,
          grade: profile.grade,
          departmentId: profile.departmentId,
          description: profile.description,
          status: profile.status,
        }}
        departments={departments}
        catalog={catalog}
        selected={selected}
        statuses={JD_STATUSES}
        levels={LEVELS}
      />
    </>
  );
}
