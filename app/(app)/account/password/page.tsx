import { requireUser } from "@/lib/auth/rbac";
import ChangePasswordForm from "@/components/account/ChangePasswordForm";

export const metadata = { title: "Change password · Transworld PeopleOps" };

export default async function ChangePasswordPage() {
  const me = await requireUser();
  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Change password</h1>
          <p>
            Signed in as <span className="mono">{me.email}</span>. If you signed
            in with the shared initial password, set your own here.
          </p>
        </div>
      </div>
      <ChangePasswordForm />
    </>
  );
}
