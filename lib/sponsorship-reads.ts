// lib/sponsorship-reads.ts — DB reads for qualification sponsorship (WS6 Part 4, v0.24.0).
// Pure engine + vocab live in lib/sponsorship.ts; write actions in lib/sponsorship-actions.ts.
// Cross-entity ids (employee, learning module, staff document, users) are bare snapshot
// columns — no Prisma @relation — so display titles are resolved with separate lookups.
import { prisma } from "@/lib/db";
import { exposureFor, round2, type ExposurePhase, type ExposureResult } from "@/lib/sponsorship";

export type SponsorshipRow = {
  id: string;
  eeId: string;
  employeeId: string;
  employeeName: string;
  qualificationName: string;
  awardingBody: string | null;
  status: string;
  committed: number;
  exposure: number;
  phase: ExposurePhase;
  bondingMonths: number | null;
  bondingStartBasis: string;
};

/** Firm-wide register: every sponsorship with committed cost + live exposure. */
export async function getSponsorshipRegister(): Promise<{
  rows: SponsorshipRow[];
  totalCommitted: number;
  totalExposure: number;
  activeCount: number;
}> {
  const records = await prisma.qualificationSponsorship.findMany({
    orderBy: [{ status: "asc" }, { createdAt: "desc" }],
    include: { costs: { select: { amount: true, waived: true } } },
  });

  const rows: SponsorshipRow[] = records.map((s) => {
    const costs = s.costs.map((c) => ({ amount: Number(c.amount), waived: c.waived }));
    const exp = exposureFor({
      status: s.status,
      costs,
      bondingMonths: s.bondingMonths,
      bondingStartBasis: s.bondingStartBasis,
      bondingWaived: s.bondingWaived,
      approvedAt: s.approvedAt,
      completedAt: s.completedAt,
    });
    return {
      id: s.id,
      eeId: s.eeId,
      employeeId: s.employeeId,
      employeeName: s.employeeName,
      qualificationName: s.qualificationName,
      awardingBody: s.awardingBody,
      status: s.status,
      committed: exp.committed,
      exposure: exp.exposure,
      phase: exp.phase,
      bondingMonths: s.bondingMonths,
      bondingStartBasis: s.bondingStartBasis,
    };
  });

  const totalCommitted = round2(rows.reduce((n, r) => n + r.committed, 0));
  const totalExposure = round2(rows.reduce((n, r) => n + r.exposure, 0));
  const activeCount = rows.filter((r) => r.status !== "WITHDRAWN" && r.status !== "COMPLETED").length;
  return { rows, totalCommitted, totalExposure, activeCount };
}

export type SponsorshipCostRow = {
  id: string;
  costType: string;
  description: string | null;
  amount: number;
  incurredDate: Date | null;
  paid: boolean;
  paidDate: Date | null;
  waived: boolean;
  note: string | null;
};

export type SponsorshipAttemptRow = {
  id: string;
  levelLabel: string;
  attemptNumber: number | null;
  sittingDate: Date | null;
  outcome: string;
  score: string | null;
  note: string | null;
};

export type SponsorshipDetail = {
  id: string;
  employeeId: string;
  eeId: string;
  employeeName: string;
  qualificationName: string;
  awardingBody: string | null;
  learningModuleId: string | null;
  learningModuleTitle: string | null;
  agreementDocumentId: string | null;
  agreementDocumentTitle: string | null;
  status: string;
  bondingMonths: number | null;
  bondingStartBasis: string;
  bondingWaived: boolean;
  repaymentStatus: string;
  repaymentAmount: number | null;
  note: string | null;
  proposedById: string | null;
  approvedById: string | null;
  agreementDate: Date | null;
  proposedAt: Date | null;
  approvedAt: Date | null;
  startedAt: Date | null;
  completedAt: Date | null;
  withdrawnAt: Date | null;
  costs: SponsorshipCostRow[];
  attempts: SponsorshipAttemptRow[];
  exposure: ExposureResult;
};

/** One sponsorship with its cost lines, exam attempts, and live exposure. */
export async function getSponsorshipDetail(id: string): Promise<SponsorshipDetail | null> {
  const s = await prisma.qualificationSponsorship.findUnique({
    where: { id },
    include: {
      costs: { orderBy: { createdAt: "asc" } },
      attempts: { orderBy: [{ attemptNumber: "asc" }, { createdAt: "asc" }] },
    },
  });
  if (!s) return null;

  // Bare snapshot ids — resolve display titles separately (no Prisma @relation).
  const [learningModule, agreement] = await Promise.all([
    s.learningModuleId
      ? prisma.learningModule.findUnique({ where: { id: s.learningModuleId }, select: { title: true } })
      : Promise.resolve(null),
    s.agreementDocumentId
      ? prisma.staffDocument.findUnique({ where: { id: s.agreementDocumentId }, select: { title: true } })
      : Promise.resolve(null),
  ]);

  const costs: SponsorshipCostRow[] = s.costs.map((c) => ({
    id: c.id,
    costType: c.costType,
    description: c.description,
    amount: Number(c.amount),
    incurredDate: c.incurredDate,
    paid: c.paid,
    paidDate: c.paidDate,
    waived: c.waived,
    note: c.note,
  }));

  const exposure = exposureFor({
    status: s.status,
    costs: costs.map((c) => ({ amount: c.amount, waived: c.waived })),
    bondingMonths: s.bondingMonths,
    bondingStartBasis: s.bondingStartBasis,
    bondingWaived: s.bondingWaived,
    approvedAt: s.approvedAt,
    completedAt: s.completedAt,
  });

  return {
    id: s.id,
    employeeId: s.employeeId,
    eeId: s.eeId,
    employeeName: s.employeeName,
    qualificationName: s.qualificationName,
    awardingBody: s.awardingBody,
    learningModuleId: s.learningModuleId,
    learningModuleTitle: learningModule?.title ?? null,
    agreementDocumentId: s.agreementDocumentId,
    agreementDocumentTitle: agreement?.title ?? null,
    status: s.status,
    bondingMonths: s.bondingMonths,
    bondingStartBasis: s.bondingStartBasis,
    bondingWaived: s.bondingWaived,
    repaymentStatus: s.repaymentStatus,
    repaymentAmount: s.repaymentAmount === null ? null : Number(s.repaymentAmount),
    note: s.note,
    proposedById: s.proposedById,
    approvedById: s.approvedById,
    agreementDate: s.agreementDate,
    proposedAt: s.proposedAt,
    approvedAt: s.approvedAt,
    startedAt: s.startedAt,
    completedAt: s.completedAt,
    withdrawnAt: s.withdrawnAt,
    costs,
    attempts: s.attempts.map((a) => ({
      id: a.id,
      levelLabel: a.levelLabel,
      attemptNumber: a.attemptNumber,
      sittingDate: a.sittingDate,
      outcome: a.outcome,
      score: a.score,
      note: a.note,
    })),
    exposure,
  };
}

export type EmployeeSponsorshipRow = {
  id: string;
  qualificationName: string;
  awardingBody: string | null;
  status: string;
  committed: number;
  exposure: number;
  phase: ExposurePhase;
};

/** Read-only strip for the per-employee compensation page. */
export async function getEmployeeSponsorships(employeeId: string): Promise<EmployeeSponsorshipRow[]> {
  const records = await prisma.qualificationSponsorship.findMany({
    where: { employeeId },
    orderBy: { createdAt: "desc" },
    include: { costs: { select: { amount: true, waived: true } } },
  });
  return records.map((s) => {
    const exp = exposureFor({
      status: s.status,
      costs: s.costs.map((c) => ({ amount: Number(c.amount), waived: c.waived })),
      bondingMonths: s.bondingMonths,
      bondingStartBasis: s.bondingStartBasis,
      bondingWaived: s.bondingWaived,
      approvedAt: s.approvedAt,
      completedAt: s.completedAt,
    });
    return {
      id: s.id,
      qualificationName: s.qualificationName,
      awardingBody: s.awardingBody,
      status: s.status,
      committed: exp.committed,
      exposure: exp.exposure,
      phase: exp.phase,
    };
  });
}

export type SponsorshipFormData = {
  employees: { id: string; eeId: string; name: string; grade: string | null }[];
  modules: { id: string; title: string }[];
};

/** Options for the "new sponsorship" form: active employees + published L&D modules. */
export async function getSponsorshipFormData(): Promise<SponsorshipFormData> {
  const [emps, mods] = await Promise.all([
    prisma.employee.findMany({
      where: { status: "ACTIVE" },
      orderBy: { eeId: "asc" },
      select: { id: true, eeId: true, fullName: true, jobProfile: { select: { grade: true } } },
    }),
    prisma.learningModule.findMany({
      where: { status: "PUBLISHED" },
      orderBy: { title: "asc" },
      select: { id: true, title: true },
    }),
  ]);
  return {
    employees: emps.map((e) => ({
      id: e.id,
      eeId: e.eeId,
      name: e.fullName,
      grade: e.jobProfile?.grade ?? null,
    })),
    modules: mods.map((m) => ({ id: m.id, title: m.title })),
  };
}
