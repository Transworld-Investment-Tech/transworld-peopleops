import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getMatrix, getModuleOptions, getJobProfileOptions } from "@/lib/lms-data";
import MatrixManager from "@/components/learning/MatrixManager";

export const metadata = { title: "Training Matrix · Transworld PeopleOps" };

export default async function TrainingMatrixPage() {
  await requirePermission("learning.assign");
  const [rules, modules, jobProfiles] = await Promise.all([
    getMatrix(),
    getModuleOptions(),
    getJobProfileOptions(),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/learning" className="back-link">
            ← Learning &amp; Development
          </Link>
          <h1 className="serif">Training Matrix</h1>
          <p>
            Define who must complete which training — firmwide, by grade, or by role — then auto-assign
            the mandatory set for the current period. Preview first; nothing is written until you commit.
          </p>
        </div>
        <Link href="/learning/compliance" className="btn">
          Compliance dashboard
        </Link>
      </div>

      <MatrixManager rules={rules} modules={modules} jobProfiles={jobProfiles} />
    </>
  );
}
