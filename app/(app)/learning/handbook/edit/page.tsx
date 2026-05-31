import { requirePermission } from "@/lib/auth/rbac";
import { getHandbook } from "@/lib/learning";
import HandbookForm from "@/components/learning/HandbookForm";

export const metadata = { title: "Edit handbook · Transworld PeopleOps" };

export default async function HandbookEditPage() {
  const me = await requirePermission("learning.manage");
  const hb = await getHandbook(me.id);
  const cur = hb.current;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{cur ? "Handbook" : "Create handbook"}</h1>
          <p>
            Saving a new version and marking it current supersedes the previous one; staff
            re-acknowledge the new version.
          </p>
        </div>
      </div>

      <HandbookForm
        initial={{
          id: cur?.id ?? null,
          title: cur?.title ?? "Employee Handbook",
          version: cur?.version ?? "1.0",
          summary: cur?.summary ?? "",
          effectiveDate: cur?.effectiveDate
            ? cur.effectiveDate.toISOString().slice(0, 10)
            : "",
          body: cur?.body ?? "",
          isCurrent: true,
        }}
      />
    </>
  );
}
