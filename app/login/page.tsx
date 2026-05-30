import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth/rbac";
import LoginForm from "@/components/LoginForm";

export const metadata = { title: "Sign in · Transworld PeopleOps" };

export default async function LoginPage() {
  const me = await getCurrentUser();
  if (me) redirect("/dashboard");

  return (
    <div className="login-shell">
      <div className="login-card">
        <div className="login-brand">
          <div className="brand-mark">
            <span>T</span>
          </div>
          <div>
            <div className="login-title">Transworld PeopleOps</div>
            <div className="login-sub">Payroll Control Portal</div>
          </div>
        </div>
        <LoginForm />
        <div className="login-foot">
          Authorized personnel only · Access is logged.
        </div>
      </div>
    </div>
  );
}
