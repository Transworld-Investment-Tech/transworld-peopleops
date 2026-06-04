// =============================================================================
// lib/ws4-data.ts — server reads for WS4 depth (probation clock + offboarding).
// Queries + shaping only; all writes live in lib/probation-actions.ts and
// lib/offboarding-actions.ts. Pages stay client-prop-fed: these functions
// return plain serializable shapes, never Prisma rows.
// =============================================================================

import { prisma } from "@/lib/db";
import {
  probationMilestones,
  probationPhase,
  clawbackOnExit,
  type ProbationPhase,
  type ProbationMilestones,
} from "@/lib/ws4";

// ── effective grade + regulated flag (mirrors lib/stafffile-data.ts) ─────────
async function gradeAndRegulated(
  e: { grade: string | null; jobProfileId: string | null; isRegulatedRole: boolean }
): Promise<{ grade: string | null; isRegulated: boolean }> {
  let grade = e.grade ?? null;
  if (!grade && e.jobProfileId) {
    const jp = await prisma.jobProfile.findUnique({
      where: { id: e.jobProfileId },
      select: { grade: true },
    });
    grade = jp?.grade ?? null;
  }
  return { grade, isRegulated: e.isRegulatedRole };
}

// ── PROBATION VIEW (rendered inside the onboarding detail page) ───────────────
export type ProbationReviewView = {
  id: string;
  kind: string;
  outcome: string | null;
  scheduledFor: Date | null;
  heldOn: Date | null;
  extensionUntil: Date | null;
  decidedByName: string | null;
  note: string | null;
  staffDocumentId: string | null;
};

export type ProbationView = {
  planId: string;
  employee: { id: string; eeId: string; name: string; status: string; isRegulated: boolean };
  probationMonths: number;
  milestones: ProbationMilestones;
  phase: ProbationPhase;
  reviews: ProbationReviewView[];
  hasMidpoint: boolean;
  hasFinal: boolean;
  // staff documents on file the operator can attach to a probation slot
  attachableDocs: { id: string; title: string; fileSlot: string | null }[];
} | null;

export async function getProbationView(employeeId: string): Promise<ProbationView> {
  const plan = await prisma.onboardingPlan.findUnique({
    where: { employeeId },
    select: { id: true, startDate: true, probationMonths: true },
  });
  if (!plan) return null;

  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true, status: true, grade: true, jobProfileId: true, isRegulatedRole: true },
  });
  if (!e) return null;
  const gr = await gradeAndRegulated(e);

  const reviews = await prisma.probationReview.findMany({
    where: { employeeId },
    orderBy: [{ kind: "asc" }, { createdAt: "asc" }],
    select: {
      id: true, kind: true, outcome: true, scheduledFor: true, heldOn: true,
      extensionUntil: true, decidedByName: true, note: true, staffDocumentId: true,
    },
  });

  const milestones = probationMilestones(plan.startDate, plan.probationMonths);
  const phase = probationPhase(new Date(), milestones, reviews.map((r) => ({ kind: r.kind, outcome: r.outcome })));

  const attachableDocs = await prisma.staffDocument.findMany({
    where: { employeeId, status: { not: "VOID" } },
    orderBy: { createdAt: "desc" },
    select: { id: true, title: true, fileSlot: true },
    take: 50,
  });

  return {
    planId: plan.id,
    employee: { id: e.id, eeId: e.eeId, name: e.fullName, status: String(e.status), isRegulated: gr.isRegulated },
    probationMonths: plan.probationMonths,
    milestones,
    phase,
    reviews,
    hasMidpoint: reviews.some((r) => r.kind === "MIDPOINT" && r.outcome && r.outcome !== "PENDING"),
    hasFinal: reviews.some((r) => r.kind === "FINAL" && !!r.outcome && r.outcome !== "PENDING"),
    attachableDocs,
  };
}

// ── OFFBOARDING LIST ─────────────────────────────────────────────────────────
export type OffboardingListRow = {
  caseId: string;
  employeeId: string;
  eeId: string;
  employeeName: string;
  exitType: string;
  status: string;
  lastWorkingDay: Date | null;
  accessRevoked: boolean;
  createdAt: Date;
};

export type StartableEmployee = { id: string; eeId: string; name: string; status: string };

export type OffboardingList = {
  open: OffboardingListRow[];
  closed: OffboardingListRow[];
  startable: StartableEmployee[];
};

export async function getOffboardingList(): Promise<OffboardingList> {
  const cases = await prisma.offboardingCase.findMany({
    orderBy: { createdAt: "desc" },
    select: {
      id: true, employeeId: true, eeId: true, employeeName: true, exitType: true,
      status: true, lastWorkingDay: true, accessRevokedAt: true, createdAt: true,
    },
  });
  const rows: OffboardingListRow[] = cases.map((c) => ({
    caseId: c.id,
    employeeId: c.employeeId,
    eeId: c.eeId,
    employeeName: c.employeeName,
    exitType: c.exitType,
    status: c.status,
    lastWorkingDay: c.lastWorkingDay,
    accessRevoked: !!c.accessRevokedAt,
    createdAt: c.createdAt,
  }));

  // Employees with no active (open/clearing) case who are not already exited
  // can start an exit — a cancelled or closed case does not block them.
  const ACTIVE = new Set(["OPEN", "CLEARING"]);
  const withCase = new Set(cases.filter((c) => ACTIVE.has(c.status)).map((c) => c.employeeId));
  const emps = await prisma.employee.findMany({
    where: { status: { not: "EXITED" } },
    orderBy: { eeId: "asc" },
    select: { id: true, eeId: true, fullName: true, status: true },
  });
  const startable = emps
    .filter((e) => !withCase.has(e.id))
    .map((e) => ({ id: e.id, eeId: e.eeId, name: e.fullName, status: String(e.status) }));

  return {
    open: rows.filter((r) => r.status === "OPEN" || r.status === "CLEARING"),
    closed: rows.filter((r) => r.status === "CLOSED" || r.status === "CANCELLED"),
    startable,
  };
}

// ── OFFBOARDING DETAIL ───────────────────────────────────────────────────────
export type OffboardingTaskView = {
  id: string; label: string; category: string; status: string; sortOrder: number;
};

export type AccessPreview = {
  hasUser: boolean;
  userId: string | null;
  userEmail: string | null;
  userStatus: string | null; // "active" | "disabled"
  roleKeys: string[];
  holdsElevatedRights: boolean; // SUPER_ADMIN / admin.users present
  alreadyRevoked: boolean;
};

export type ClawbackPreviewRow = {
  sponsorshipId: string;
  qualificationName: string;
  status: string;
  committed: number;
  exposure: number;
  phase: string;
  repaymentStatus: "NOT_APPLICABLE" | "PENDING" | "WAIVED";
  repaymentAmount: number | null;
  reason: string;
  currentRepaymentStatus: string; // what's stored now
};

export type OffboardingDetail = {
  caseId: string;
  employee: { id: string; eeId: string; name: string; status: string; isRegulated: boolean };
  exitType: string;
  status: string;
  noticeReceivedAt: Date | null;
  lastWorkingDay: Date | null;
  reason: string | null;
  note: string | null;
  exitInterviewDone: boolean;
  finalPaySettled: boolean;
  regulatoryNotified: boolean;
  accessRevokedAt: Date | null;
  closedAt: Date | null;
  tasks: OffboardingTaskView[];
  access: AccessPreview;
  clawback: ClawbackPreviewRow[];
} | null;

const ELEVATED = new Set(["admin.users"]);

export async function getOffboardingDetail(employeeId: string): Promise<OffboardingDetail> {
  const c = await prisma.offboardingCase.findFirst({
    where: { employeeId },
    orderBy: { createdAt: "desc" },
    include: { tasks: { orderBy: { sortOrder: "asc" } } },
  });
  if (!c) return null;

  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: {
      id: true, eeId: true, fullName: true, status: true, grade: true, jobProfileId: true,
      isRegulatedRole: true, userId: true,
    },
  });
  if (!e) return null;
  const gr = await gradeAndRegulated(e);

  // Access-revocation preview — the linked user + its roles.
  let access: AccessPreview = {
    hasUser: false, userId: null, userEmail: null, userStatus: null,
    roleKeys: [], holdsElevatedRights: false, alreadyRevoked: !!c.accessRevokedAt,
  };
  if (e.userId) {
    const u = await prisma.user.findUnique({
      where: { id: e.userId },
      select: { id: true, email: true, status: true, roles: { include: { role: true } } },
    });
    if (u) {
      const roleKeys = u.roles.map((ur) => ur.role.key).sort();
      access = {
        hasUser: true,
        userId: u.id,
        userEmail: u.email,
        userStatus: u.status,
        roleKeys,
        holdsElevatedRights: roleKeys.includes("SUPER_ADMIN") || roleKeys.some((k) => ELEVATED.has(k)),
        alreadyRevoked: !!c.accessRevokedAt || u.status === "disabled",
      };
    }
  }

  // Sponsorship clawback preview — derived live, as of the last working day.
  const asOf = c.lastWorkingDay ?? new Date();
  const sponsorships = await prisma.qualificationSponsorship.findMany({
    where: { employeeId },
    orderBy: { createdAt: "desc" },
    include: { costs: { select: { amount: true, waived: true } } },
  });
  const clawback: ClawbackPreviewRow[] = sponsorships.map((s) => {
    const r = clawbackOnExit({
      exitType: c.exitType,
      status: s.status,
      costs: s.costs.map((x) => ({ amount: Number(x.amount), waived: x.waived })),
      bondingMonths: s.bondingMonths,
      bondingStartBasis: s.bondingStartBasis,
      bondingWaived: s.bondingWaived,
      approvedAt: s.approvedAt,
      completedAt: s.completedAt,
      asOf,
    });
    return {
      sponsorshipId: s.id,
      qualificationName: s.qualificationName,
      status: s.status,
      committed: r.exposure.committed,
      exposure: r.exposure.exposure,
      phase: r.exposure.phase,
      repaymentStatus: r.repaymentStatus,
      repaymentAmount: r.repaymentAmount,
      reason: r.reason,
      currentRepaymentStatus: s.repaymentStatus,
    };
  });

  return {
    caseId: c.id,
    employee: { id: e.id, eeId: e.eeId, name: e.fullName, status: String(e.status), isRegulated: gr.isRegulated },
    exitType: c.exitType,
    status: c.status,
    noticeReceivedAt: c.noticeReceivedAt,
    lastWorkingDay: c.lastWorkingDay,
    reason: c.reason,
    note: c.note,
    exitInterviewDone: c.exitInterviewDone,
    finalPaySettled: c.finalPaySettled,
    regulatoryNotified: c.regulatoryNotified,
    accessRevokedAt: c.accessRevokedAt,
    closedAt: c.closedAt,
    tasks: c.tasks.map((t) => ({ id: t.id, label: t.label, category: t.category, status: t.status, sortOrder: t.sortOrder })),
    access,
    clawback,
  };
}
