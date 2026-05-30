import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getJobProfileFormData, JD_STATUSES, LEVELS } from "@/lib/jobframework";
import JobProfileForm from "@/components/jobcompetency/JobProfileForm";

export const metadata = { title: "Add job profile · Transworld PeopleOps" };

export default async function NewJobProfilePage() {
  await requirePermission("jobframework.manage");
  const { departments, catalog } = await getJobProfileFormData();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/job-competency" className="back-link">
            ← Job &amp; Competency
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Add job profile
          </h1>
          <p>Creates a role definition. This is recorded in the audit log.</p>
        </div>
      </div>

      <JobProfileForm
        mode="create"
        initial={{ status: "DRAFT" }}
        departments={departments}
        catalog={catalog}
        selected={[]}
        statuses={JD_STATUSES}
        levels={LEVELS}
      />
    </>
  );
}
