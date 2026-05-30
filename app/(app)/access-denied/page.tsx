import { requireUser } from "@/lib/auth/rbac";

export const metadata = { title: "Access denied · Transworld PeopleOps" };

export default async function AccessDenied() {
  await requireUser();
  return (
    <>
      <div className="page-h">
        <div>
          <h1>Access denied</h1>
          <p>You don&apos;t have permission to view that module.</p>
        </div>
      </div>
      <div
        className="note"
        style={{
          background: "var(--red-soft)",
          borderColor: "#f0c9c3",
          color: "#7a241b",
        }}
      >
        <span>⚠</span>
        <div>
          Your account is signed in, but your assigned roles don&apos;t include
          access to that area. Contact an administrator if you believe this is a
          mistake.
        </div>
      </div>
    </>
  );
}
