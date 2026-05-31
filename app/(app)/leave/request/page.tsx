import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { getLeaveTypeOptions } from "@/lib/leave";
import RequestLeaveForm from "@/components/leave/RequestLeaveForm";

export const metadata = { title: "Request leave · Transworld PeopleOps" };

export default async function RequestLeavePage() {
  const me = await requirePermission("leave.view");
  const [employee, types] = await Promise.all([
    prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true, status: true } }),
    getLeaveTypeOptions(),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Request leave</h1>
          <p>Submit a request for your line manager to review and HR to approve.</p>
        </div>
        <Link href="/leave" className="btn">
          Back to Leave
        </Link>
      </div>

      {!employee || employee.status === "EXITED" ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                Your login isn’t linked to an active employee record, so you can’t request leave.
                HR can link it from the Employees module.
              </div>
            </div>
          </div>
        </div>
      ) : types.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>No leave types are set up yet. HR needs to add them under Leave types first.</div>
            </div>
          </div>
        </div>
      ) : (
        <RequestLeaveForm types={types} />
      )}
    </>
  );
}
