// Read-only aggregator for the self-service "My Profile" page (v0.32.0; rich
// fields + dependents added v0.36.0). No writes here. Resolves the employee
// record linked to the signed-in user and returns a typed bundle the server
// component renders — mirroring the one-entry-point shape used elsewhere
// (lib/dashboard.ts, lib/leave.ts).
//
// The login may not be tied to an employee record yet (a fresh account before
// People Ops links it). In that case `linked` is false and `employee` is null,
// and the page shows the same friendly empty state as My Documents.
//
// What the person may EDIT lives in lib/profile-actions.ts. As of v0.36.0 the
// self-editable set is their own CONTACT block (personal email/phone, residential
// address, next-of-kin) plus preferred name + phone. Everything else returned
// here — DOB, demographics, identification, grade/profile, department, bank,
// employment and dependents — is rendered read-only and stays HR-controlled
// (edited at /employees/[id]/edit).
import { prisma } from "@/lib/db";
import type { CurrentUser } from "@/lib/auth/rbac";
import { personGrade } from "@/lib/jobframework";

export type MyProfileDependent = {
  fullName: string;
  relationship: string;
  dateOfBirth: Date | null;
};

export type MyProfileEmployee = {
  eeId: string;
  fullName: string;
  preferredName: string | null;
  workEmail: string | null;
  phone: string | null;
  employmentType: string;
  fte: number;
  status: string;
  startDate: Date | null;
  department: string | null;
  role: string | null; // job-profile title
  grade: string | null;
  family: string | null;
  track: string | null;
  rung: string | null;
  manager: string | null;
  entity: string | null;
  bankNameMasked: string | null;
  bankAcctMasked: string | null;
  // ── rich personal fields (v0.36.0) ──
  dateOfBirth: Date | null;
  gender: string | null;
  maritalStatus: string | null;
  nationality: string | null;
  stateOfOrigin: string | null;
  personalEmail: string | null;
  personalPhone: string | null;
  residentialAddress: string | null;
  city: string | null;
  stateRegion: string | null;
  country: string | null;
  workLocation: string | null;
  nokName: string | null;
  nokRelationship: string | null;
  nokPhone: string | null;
  nokAddress: string | null;
  idType: string | null;
  idNumberMasked: string | null;
  dependents: MyProfileDependent[];
};

export type MyProfile = {
  linked: boolean;
  loginEmail: string;
  employee: MyProfileEmployee | null;
};

function personName(e: { preferredName: string | null; fullName: string }): string {
  return e.preferredName?.trim() || e.fullName;
}

export async function getMyProfile(me: CurrentUser): Promise<MyProfile> {
  const e = await prisma.employee.findUnique({
    where: { userId: me.id },
    select: {
      id: true,
      eeId: true,
      grade: true,
      fullName: true,
      preferredName: true,
      workEmail: true,
      phone: true,
      employmentType: true,
      fte: true,
      status: true,
      startDate: true,
      bankNameMasked: true,
      bankAcctMasked: true,
      dateOfBirth: true,
      gender: true,
      maritalStatus: true,
      nationality: true,
      stateOfOrigin: true,
      personalEmail: true,
      personalPhone: true,
      residentialAddress: true,
      city: true,
      stateRegion: true,
      country: true,
      workLocation: true,
      nokName: true,
      nokRelationship: true,
      nokPhone: true,
      nokAddress: true,
      idType: true,
      idNumberMasked: true,
      department: { select: { name: true } },
      jobProfile: {
        select: { title: true, grade: true, family: true, track: true, rung: true },
      },
      manager: { select: { fullName: true, preferredName: true } },
      entity: { select: { name: true } },
    },
  });

  if (!e) return { linked: false, loginEmail: me.email, employee: null };

  const deps = await prisma.employeeDependent.findMany({
    where: { employeeId: e.id },
    orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
    select: { fullName: true, relationship: true, dateOfBirth: true },
  });

  return {
    linked: true,
    loginEmail: me.email,
    employee: {
      eeId: e.eeId,
      fullName: e.fullName,
      preferredName: e.preferredName,
      workEmail: e.workEmail,
      phone: e.phone,
      employmentType: e.employmentType,
      fte: Number(e.fte),
      status: e.status,
      startDate: e.startDate,
      department: e.department?.name ?? null,
      role: e.jobProfile?.title ?? null,
      grade: personGrade(e.grade, e.jobProfile?.grade),
      family: e.jobProfile?.family ?? null,
      track: e.jobProfile?.track ?? null,
      rung: e.jobProfile?.rung ?? null,
      manager: e.manager ? personName(e.manager) : null,
      entity: e.entity?.name ?? null,
      bankNameMasked: e.bankNameMasked,
      bankAcctMasked: e.bankAcctMasked,
      dateOfBirth: e.dateOfBirth,
      gender: e.gender,
      maritalStatus: e.maritalStatus,
      nationality: e.nationality,
      stateOfOrigin: e.stateOfOrigin,
      personalEmail: e.personalEmail,
      personalPhone: e.personalPhone,
      residentialAddress: e.residentialAddress,
      city: e.city,
      stateRegion: e.stateRegion,
      country: e.country,
      workLocation: e.workLocation,
      nokName: e.nokName,
      nokRelationship: e.nokRelationship,
      nokPhone: e.nokPhone,
      nokAddress: e.nokAddress,
      idType: e.idType,
      idNumberMasked: e.idNumberMasked,
      dependents: deps.map((d) => ({
        fullName: d.fullName,
        relationship: d.relationship,
        dateOfBirth: d.dateOfBirth,
      })),
    },
  };
}
