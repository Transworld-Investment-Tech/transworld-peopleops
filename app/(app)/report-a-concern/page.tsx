import { requirePermission } from "@/lib/auth/rbac";
import { ReportForm } from "@/components/whistleblower/WhistleblowerControls";

export const metadata = { title: "Report a concern · Transworld PeopleOps" };

export default async function ReportAConcernPage() {
  await requirePermission("whistleblower.report");
  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Report a concern</h1>
          <p>
            If you see something that isn’t right, say something. You don’t need proof. You can report
            anonymously, and you are protected from any form of retaliation.
          </p>
        </div>
      </div>
      <div className="card">
        <div className="card-pad">
          <ReportForm />
        </div>
      </div>
      <div className="note mt">
        <span>ℹ</span>
        <div>
          Normal reports go to the Compliance Officer. A concern that involves senior management is
          routed directly to the Chairman / BARC Chair instead — tick the box so it reaches the right place.
        </div>
      </div>
    </>
  );
}
