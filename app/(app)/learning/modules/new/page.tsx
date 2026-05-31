import { requirePermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { LEARNING_CATEGORIES } from "@/lib/learning";
import ModuleForm from "@/components/learning/ModuleForm";

export const metadata = { title: "New module · Transworld PeopleOps" };

export default async function NewModulePage() {
  await requirePermission("learning.manage");
  const competencies = await prisma.competency.findMany({
    select: { id: true, name: true, category: true },
    orderBy: [{ category: "asc" }, { name: "asc" }],
  });

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">New module</h1>
          <p>Author reading material and tag it to competencies.</p>
        </div>
      </div>
      <ModuleForm
        initial={{
          id: null,
          title: "",
          category: LEARNING_CATEGORIES[0],
          summary: "",
          estimatedMinutes: "",
          status: "DRAFT",
          body: "",
          competencyIds: [],
        }}
        categories={LEARNING_CATEGORIES}
        competencies={competencies}
      />
    </>
  );
}
