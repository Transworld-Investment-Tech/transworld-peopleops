import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { LEARNING_CATEGORIES, getModule } from "@/lib/learning";
import { storageConfigured } from "@/lib/storage";
import ModuleForm from "@/components/learning/ModuleForm";
import MaterialCard from "@/components/learning/MaterialCard";

export const metadata = { title: "Edit module · Transworld PeopleOps" };

export default async function EditModulePage({
  params,
}: {
  params: Promise<{ moduleId: string }>;
}) {
  await requirePermission("learning.manage");
  const { moduleId } = await params;

  const [view, competencies] = await Promise.all([
    getModule(moduleId),
    prisma.competency.findMany({
      select: { id: true, name: true, category: true },
      orderBy: [{ category: "asc" }, { name: "asc" }],
    }),
  ]);
  if (!view) notFound();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Edit module</h1>
          <p>{view.module.title}</p>
        </div>
      </div>

      <ModuleForm
        initial={{
          id: view.module.id,
          title: view.module.title,
          category: view.module.category,
          summary: view.module.summary ?? "",
          estimatedMinutes:
            view.module.estimatedMinutes != null ? String(view.module.estimatedMinutes) : "",
          status: view.module.status,
          body: view.module.body ?? "",
          competencyIds: view.competencies.map((c) => c.id),
        }}
        categories={LEARNING_CATEGORIES}
        competencies={competencies}
      />

      <MaterialCard moduleId={moduleId} doc={view.material} storageReady={storageConfigured()} />
    </>
  );
}
