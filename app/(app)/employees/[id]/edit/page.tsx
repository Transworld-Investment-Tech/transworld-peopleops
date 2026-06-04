import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission } from "@/lib/auth/rbac";
import {
  getEmployeeDetail,
  getFormOptions,
  EMPLOYMENT_TYPES,
  EMPLOYMENT_STATUSES,
} from "@/lib/employees";
import EmployeeForm from "@/components/employees/EmployeeForm";

export const metadata = { title: "Edit employee · Transworld PeopleOps" };

const isoDay = (d: Date | null | undefined) => (d ? d.toISOString().slice(0, 10) : "");

export default async function EditEmployeePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requirePermission("employees.manage");
  const { id } = await params;
  const emp = await getEmployeeDetail(id);
  if (!emp) notFound();
  const options = await getFormOptions(id);

  return (
    <>
      <div className="page-h">
        <div>
          <Link href={`/employees/${id}`} className="back-link">
            ← {emp.fullName}
          </Link>
          <h1 className="serif" style={{ marginTop: 6 }}>
            Edit employee
          </h1>
          <p>Changes are recorded in the audit log.</p>
        </div>
      </div>

      <EmployeeForm
        mode="edit"
        initial={{
          id: emp.id,
          eeId: emp.eeId,
          fullName: emp.fullName,
          preferredName: emp.preferredName,
          workEmail: emp.workEmail,
          phone: emp.phone,
          departmentId: emp.departmentId,
          jobProfileId: emp.jobProfileId,
          grade: emp.grade,
          payCategoryId: emp.payCategoryId,
          managerId: emp.managerId,
          employmentType: emp.employmentType,
          status: emp.status,
          startDate: isoDay(emp.startDate),
          bankNameMasked: emp.bankNameMasked,
          bankAcctMasked: emp.bankAcctMasked,
          dateOfBirth: isoDay(emp.dateOfBirth),
          gender: emp.gender,
          maritalStatus: emp.maritalStatus,
          nationality: emp.nationality,
          stateOfOrigin: emp.stateOfOrigin,
          personalEmail: emp.personalEmail,
          personalPhone: emp.personalPhone,
          residentialAddress: emp.residentialAddress,
          city: emp.city,
          stateRegion: emp.stateRegion,
          country: emp.country,
          workLocation: emp.workLocation,
          nokName: emp.nokName,
          nokRelationship: emp.nokRelationship,
          nokPhone: emp.nokPhone,
          nokAddress: emp.nokAddress,
          idType: emp.idType,
          idNumberMasked: emp.idNumberMasked,
        }}
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
