import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { getModuleForManage } from "@/lib/lms-data";
import ModuleMetaForm from "@/components/learning/ModuleMetaForm";
import QuizEditor from "@/components/learning/QuizEditor";

export const metadata = { title: "Manage module · Transworld PeopleOps" };

export default async function ManageModulePage({
  params,
}: {
  params: Promise<{ moduleId: string }>;
}) {
  await requirePermission("learning.manage");
  const { moduleId } = await params;
  const m = await getModuleForManage(moduleId);
  if (!m) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/learning/modules/${m.id}`} className="back-link">
            ← {m.title}
          </Link>
          <h1 className="serif">Manage: {m.title}</h1>
          <p>
            Set this module&apos;s compliance metadata and author its gradable knowledge-check. Correct
            answers are stored server-side and never sent to the person taking the check.
          </p>
        </div>
      </div>

      <ModuleMetaForm
        initial={{
          id: m.id,
          code: m.code,
          domain: m.domain,
          level: m.level,
          owner: m.owner,
          isMandatory: m.isMandatory,
          cadence: m.cadence,
          passMark: m.passMark,
          status: m.status,
        }}
      />

      <QuizEditor moduleId={m.id} questions={m.questions} />
    </>
  );
}
