import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getRecommendData } from "@/lib/learning";
import RecommendForm from "@/components/learning/RecommendForm";

export const metadata = { title: "Recommend modules · Transworld PeopleOps" };

export default async function RecommendPage({
  searchParams,
}: {
  searchParams: Promise<{ employeeId?: string; appraisalId?: string; cycleId?: string }>;
}) {
  await requirePermission("learning.recommend");
  const sp = await searchParams;
  const employeeId = sp.employeeId ?? "";
  if (!employeeId) notFound();

  const data = await getRecommendData(employeeId, sp.appraisalId ?? null);
  if (!data) notFound();

  const backHref =
    data.appraisal && data.appraisal.cycleId
      ? `/performance/${data.appraisal.cycleId}/${employeeId}`
      : "/learning";

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={backHref} className="back-link">
            ← Back
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Recommend modules — {data.employee.name}
            {data.employee.role ? ` · ${data.employee.role}` : ""}
          </h1>
          <p>
            {data.appraisal && data.appraisal.belowCompetencies.length
              ? "Modules tagged to competencies rated Below in this appraisal are pre-selected."
              : "Choose modules to recommend for this employee’s development."}
          </p>
        </div>
      </div>

      {data.appraisal && data.appraisal.belowCompetencies.length ? (
        <div className="card" style={{ marginBottom: 16 }}>
          <div className="card-pad">
            <div className="ln-statline">
              <span>
                Development areas from this appraisal:{" "}
                <b>{data.appraisal.belowCompetencies.join(", ")}</b>
              </span>
            </div>
          </div>
        </div>
      ) : null}

      <RecommendForm
        employeeId={data.employee.id}
        appraisalId={data.appraisal?.id ?? null}
        cycleId={data.appraisal?.cycleId ?? sp.cycleId ?? null}
        modules={data.modules}
      />
    </>
  );
}
