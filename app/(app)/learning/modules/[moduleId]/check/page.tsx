import Link from "next/link";
import { notFound } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getQuizForEmployee } from "@/lib/lms-data";
import QuizTaker from "@/components/learning/QuizTaker";

export const metadata = { title: "Knowledge-check · Transworld PeopleOps" };

export default async function CheckPage({
  params,
  searchParams,
}: {
  params: Promise<{ moduleId: string }>;
  searchParams: Promise<{ employeeId?: string }>;
}) {
  const me = await requirePermission("learning.view");
  const { moduleId } = await params;
  const { employeeId } = await searchParams;

  const mod = await prisma.learningModule.findUnique({
    where: { id: moduleId },
    select: { id: true, title: true, passMark: true, status: true },
  });
  if (!mod) notFound();

  // On-behalf is only honored for learning.manage holders (server-enforced too).
  const onBehalf = employeeId && hasPermission(me, "learning.manage") ? employeeId : null;
  const questions = await getQuizForEmployee(moduleId);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/learning/modules/${mod.id}`} className="back-link">
            ← {mod.title}
          </Link>
          <h1 className="serif">Knowledge-check: {mod.title}</h1>
          <p>
            Answer every question, then submit. Your answers are graded on the server; a pass of{" "}
            <strong className="num">{mod.passMark ?? 100}%</strong> records the module as completed for
            this period.
          </p>
        </div>
      </div>

      {questions.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              This module has no knowledge-check yet. Ask People-Ops to author one on the manage page.
            </p>
          </div>
        </div>
      ) : (
        <QuizTaker
          moduleId={mod.id}
          employeeId={onBehalf}
          passMark={mod.passMark ?? 100}
          questions={questions}
        />
      )}
    </>
  );
}
