import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getScorecardEditData, SCORECARD_STATUSES } from "@/lib/scorecards";
import ScorecardForm from "@/components/jobcompetency/ScorecardForm";

export const metadata = { title: "Edit scorecard · Transworld PeopleOps" };

export default async function EditScorecardPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requirePermission("jobframework.manage");
  const { id } = await params;
  const { profile, scorecard } = await getScorecardEditData(id);
  if (!profile) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/job-competency/${id}`} className="back-link">
            ← {profile.title}
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            {scorecard ? "Edit scorecard" : "Create scorecard"}
          </h1>
          <p>Mission and the measurable outcomes for this role. Recorded in the audit log.</p>
        </div>
      </div>

      <ScorecardForm
        jobProfileId={id}
        initial={{
          mission: scorecard?.mission ?? "",
          status: scorecard?.status ?? "DRAFT",
          outcomes: scorecard?.outcomes ?? [],
        }}
        statuses={SCORECARD_STATUSES}
        hasExisting={!!scorecard}
      />
    </>
  );
}
