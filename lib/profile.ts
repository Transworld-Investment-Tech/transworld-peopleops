// Read-only aggregator for the self-service "My Profile" page (v0.32.0). No
// writes here. Resolves the employee record linked to the signed-in user and
// returns a typed bundle the server component renders — mirroring the
// one-entry-point shape used elsewhere (lib/dashboard.ts, lib/leave.ts).
//
// The login may not be tied to an employee record yet (a fresh account before
// People Ops links it). In that case `linked` is false and `employee` is null,
// and the page shows the same friendly empty state as My Documents.
//
// What the person may EDIT lives in lib/profile-actions.ts and is limited to
// `preferredName` and `phone`. Everything returned here that isn't those two is
// rendered read-only — work email, bank, grade/profile and department stay
// HR-controlled (edited at /employees/[id]/edit).
import { prisma } from "@/lib/db";
import type { CurrentUser } from "@/lib/auth/rbac";

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
      eeId: true,
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
      department: { select: { name: true } },
      jobProfile: {
        select: { title: true, grade: true, family: true, track: true, rung: true },
      },
      manager: { select: { fullName: true, preferredName: true } },
      entity: { select: { name: true } },
    },
  });

  if (!e) return { linked: false, loginEmail: me.email, employee: null };

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
      grade: e.jobProfile?.grade ?? null,
      family: e.jobProfile?.family ?? null,
      track: e.jobProfile?.track ?? null,
      rung: e.jobProfile?.rung ?? null,
      manager: e.manager ? personName(e.manager) : null,
      entity: e.entity?.name ?? null,
      bankNameMasked: e.bankNameMasked,
      bankAcctMasked: e.bankAcctMasked,
    },
  };
}
