import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getFormOptions,
  EMPLOYMENT_TYPES,
  EMPLOYMENT_STATUSES,
} from "@/lib/employees";
import EmployeeForm from "@/components/employees/EmployeeForm";

export const metadata = { title: "Add employee · Transworld PeopleOps" };

export default async function NewEmployeePage() {
  await requirePermission("employees.manage");
  const options = await getFormOptions();

  return (
    <>
      <div className="page-h">
        <div>
          <Link href="/employees" className="back-link">
            ← Employees
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Add employee
          </h1>
          <p>Creates a new staff record. This is recorded in the audit log.</p>
        </div>
      </div>

      <EmployeeForm
        mode="create"
        initial={{ employmentType: "FULL_TIME", status: "ACTIVE" }}
        departments={options.departments}
        jobProfiles={options.jobProfiles}
        payCategories={options.payCategories}
        managers={options.managers}
        employmentTypes={EMPLOYMENT_TYPES}
        statuses={EMPLOYMENT_STATUSES}
      />
    </>
  );
}
