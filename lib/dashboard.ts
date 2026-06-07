// Read-only aggregator for the executive Dashboard (v0.15.0). No writes here.
//
// The /dashboard route is visible to every role (dashboard.view is granted to
// all of them), so each ORG-WIDE section is computed only when the viewer holds
// the permission that already governs its source module. A section the viewer
// may not see is never queried and comes back null — the Dashboard can't leak
// anything a viewer couldn't already reach in the relevant module.
//
// Gating (reusing existing module permissions):
//   employees.view    -> roster posture
//   admin.users       -> login coverage
//   compensation.view -> pending compensation approvals
//   learning.view     -> learning + handbook posture (counts only) AND the
//                        viewer's own learning + handbook acknowledgment
//   leave.manage      -> org leave posture (pending / out this week)
//   leave.view        -> the viewer's own leave (balances + pending requests)
//
// Everything is a thin re-use of the modules' existing read functions, mirroring
// the shape of lib/leave.ts (getLeavePageData): one async entry point returns a
// typed bundle the server component renders. No new DB access patterns.
import { hasPermission, type CurrentUser } from "@/lib/auth/rbac";
import { getEmployeesForList } from "@/lib/employees";
import { getUsersForList, getUnlinkedEmployees } from "@/lib/admin-users";
import { getPendingRequestCount } from "@/lib/compensation";
import { getLibrary, getHandbook, getMyLearning, isOverdue } from "@/lib/learning";
import { getLeaveDashboardStats, getLeavePageData } from "@/lib/leave";
import { getPayrollHome } from "@/lib/payroll-cycle";
import { getBonusHome } from "@/lib/bonus-round";
import { getDeferrals } from "@/lib/bonus-deferrals";
import { getSponsorshipRegister } from "@/lib/sponsorship-reads";
import { getCompensationPositioning } from "@/lib/compensation";
import { getDefaultCycle, getRoster } from "@/lib/performance";
import { prisma } from "@/lib/db";
import { getMyPayslips } from "@/lib/my-payslips";

// --- Org-wide tiles --------------------------------------------------------
export type RosterTile = {
  total: number;
  nonExited: number;
  active: number;
  probation: number;
  onLeave: number;
  suspended: number;
  exited: number;
};

export type LoginsTile = {
  accounts: number;
  active: number;
  awaiting: number; // non-exited staff with no login yet
};

export type CompTile = { pending: number };

export type LearningTile = {
  modules: number;
  completions: number;
  inProgress: number;
  overdue: number;
  handbook: {
    published: boolean;
    version: string | null;
    acknowledged: number;
    total: number;
  };
};

export type OrgLeaveTile = {
  pending: number;
  onLeaveThisWeek: number;
  onLeaveName: string | null;
  avgAnnualRemaining: number;
};

// --- Personal strip --------------------------------------------------------
export type MyLeaveTile = {
  linked: boolean;
  annualRemaining: number | null;
  pending: number;
};

export type MyLearningTile = {
  linked: boolean;
  assigned: number; // ASSIGNED + IN_PROGRESS
  overdue: number;
  available: number;
};

export type MyHandbookTile = {
  linked: boolean;
  published: boolean;
  acknowledged: boolean;
};

export type IdentityTile = {
  firstName: string;
  title: string | null;
  grade: string | null;
} | null;

export type MyPayslipTile = {
  label: string;
  net: number;
} | null;

// --- New org tiles surfaced in v0.32.0 -------------------------------------
export type PayrollTile = {
  label: string | null; // most recent cycle label
  status: string | null; // its status
  itemCount: number;
  totalPayable: number | null;
  hasOpenCycle: boolean;
};

export type BonusTile = {
  roundLabel: string | null; // most recent round
  roundStatus: string | null;
  hasOpenRound: boolean;
  deferralsDue: number; // net due in the focus year
  focusYear: number;
};

export type SponsorshipTile = {
  exposure: number; // live firm exposure (₦)
  committed: number;
  activeCount: number;
};

export type CompaFlagsTile = {
  prioritize: number; // compa-ratio below the prioritize threshold
  belowMin: number; // fully-loaded below band minimum
  threshold: number; // CR prioritize threshold (for the caption)
};

export type AppraisalCycleTile = {
  cycleName: string | null;
  cycleStatus: string | null;
  finalized: number;
  total: number;
  pct: number; // finalized / total, rounded
};

export type DashboardData = {
  viewerName: string;
  roleKeys: string[];
  identity: IdentityTile;
  myPayslip: MyPayslipTile;
  // org-wide (null = viewer not permitted)
  roster: RosterTile | null;
  logins: LoginsTile | null;
  comp: CompTile | null;
  learning: LearningTile | null;
  orgLeave: OrgLeaveTile | null;
  payroll: PayrollTile | null;
  bonus: BonusTile | null;
  sponsorship: SponsorshipTile | null;
  compaFlags: CompaFlagsTile | null;
  appraisalCycle: AppraisalCycleTile | null;
  hasOrgTiles: boolean;
  // personal (null = viewer not permitted; .linked=false = no employee record)
  myLeave: MyLeaveTile | null;
  myLearning: MyLearningTile | null;
  myHandbook: MyHandbookTile | null;
  hasPersonal: boolean;
};

function annualRemaining(balances: { typeName: string; remaining: number }[]): number | null {
  const annual = balances.find((b) => /annual/i.test(b.typeName));
  return annual ? annual.remaining : null;
}

export async function getDashboardData(me: CurrentUser): Promise<DashboardData> {
  const canEmployees = hasPermission(me, "employees.view");
  const canAdminUsers = hasPermission(me, "admin.users");
  const canComp = hasPermission(me, "compensation.view");
  const canLearning = hasPermission(me, "learning.view");
  const canLeaveManage = hasPermission(me, "leave.manage");
  const canLeaveView = hasPermission(me, "leave.view");
  const canPayroll = hasPermission(me, "payroll.view");
  const canBonus = hasPermission(me, "bonus.view");
  const canPerformance = hasPermission(me, "performance.view");
  const canPayslipsOwn = hasPermission(me, "payslips.view_own");

  // Every permitted read fires in parallel; unpermitted sections resolve to
  // undefined and are never queried.
  const [employees, users, unlinked, pendingComp, library, handbook, myLearning, orgLeaveStats, leavePage] =
    await Promise.all([
      canEmployees ? getEmployeesForList() : undefined,
      canAdminUsers ? getUsersForList() : undefined,
      canAdminUsers ? getUnlinkedEmployees() : undefined,
      canComp ? getPendingRequestCount() : undefined,
      canLearning ? getLibrary(false) : undefined,
      canLearning ? getHandbook(me.id) : undefined,
      canLearning ? getMyLearning(me.id) : undefined,
      canLeaveManage ? getLeaveDashboardStats() : undefined,
      canLeaveView ? getLeavePageData(me) : undefined,
    ]);

  // New v0.32.0 org tiles — each gated by the permission that already governs
  // its source module, fired only when permitted (same doctrine as above).
  const [payrollHome, bonusHome, deferrals, sponsorshipReg, positioning, defaultCycle] =
    await Promise.all([
      canPayroll ? getPayrollHome() : undefined,
      canBonus ? getBonusHome() : undefined,
      canBonus ? getDeferrals() : undefined,
      canComp ? getSponsorshipRegister() : undefined,
      canComp ? getCompensationPositioning() : undefined,
      canPerformance ? getDefaultCycle() : undefined,
    ]);
  // Appraisal completion needs the roster for the resolved cycle (sequential,
  // and only when performance.view holds and a cycle actually exists).
  const appraisalRoster =
    canPerformance && defaultCycle ? await getRoster(defaultCycle.id) : undefined;

  // --- Identity + latest payslip (self-service; powers the employee dashboard) ---
  const [linkedEmployee, myPayslipData] = await Promise.all([
    prisma.employee.findUnique({
      where: { userId: me.id },
      select: {
        fullName: true,
        preferredName: true,
        grade: true,
        jobProfile: { select: { title: true, grade: true } },
      },
    }),
    canPayslipsOwn ? getMyPayslips(me.id) : undefined,
  ]);

  let identity: IdentityTile = null;
  if (linkedEmployee) {
    const first =
      linkedEmployee.preferredName?.trim() ||
      linkedEmployee.fullName.trim().split(/\s+/)[0] ||
      me.name;
    identity = {
      firstName: first,
      title: linkedEmployee.jobProfile?.title ?? null,
      grade: linkedEmployee.grade ?? linkedEmployee.jobProfile?.grade ?? null,
    };
  }

  let myPayslip: MyPayslipTile = null;
  if (myPayslipData && myPayslipData.linked && myPayslipData.latest) {
    myPayslip = { label: myPayslipData.latest.label, net: myPayslipData.latest.netPay };
  }

  // --- Roster (employees.view) ---
  let roster: RosterTile | null = null;
  if (employees) {
    const exited = employees.filter((e) => e.status === "EXITED").length;
    roster = {
      total: employees.length,
      nonExited: employees.length - exited,
      active: employees.filter((e) => e.status === "ACTIVE").length,
      probation: employees.filter((e) => e.status === "PROBATION").length,
      onLeave: employees.filter((e) => e.status === "ON_LEAVE").length,
      suspended: employees.filter((e) => e.status === "SUSPENDED").length,
      exited,
    };
  }

  // --- Logins (admin.users) ---
  let logins: LoginsTile | null = null;
  if (users && unlinked) {
    logins = {
      accounts: users.length,
      active: users.filter((u) => u.status === "active").length,
      awaiting: unlinked.length,
    };
  }

  // --- Pending compensation approvals (compensation.view) ---
  const comp: CompTile | null = pendingComp === undefined ? null : { pending: pendingComp };

  // --- Learning + handbook posture (learning.view) ---
  let learning: LearningTile | null = null;
  if (library && handbook) {
    learning = {
      modules: library.kpis.modules,
      completions: library.kpis.completions,
      inProgress: library.kpis.inProgress,
      overdue: library.kpis.overdue,
      handbook: {
        published: !!handbook.current,
        version: handbook.current?.version ?? null,
        acknowledged: handbook.ack.acknowledged,
        total: handbook.ack.total,
      },
    };
  }

  // --- Org leave posture (leave.manage) ---
  const orgLeave: OrgLeaveTile | null = orgLeaveStats
    ? {
        pending: orgLeaveStats.pending,
        onLeaveThisWeek: orgLeaveStats.onLeaveThisWeek,
        onLeaveName: orgLeaveStats.onLeaveName,
        avgAnnualRemaining: orgLeaveStats.avgAnnualRemaining,
      }
    : null;

  // --- Personal: my leave (leave.view + linked employee) ---
  let myLeave: MyLeaveTile | null = null;
  if (leavePage) {
    const linked = !!leavePage.viewer.employeeId;
    myLeave = {
      linked,
      annualRemaining: linked ? annualRemaining(leavePage.myBalances) : null,
      pending: leavePage.myRequests.filter((r) => r.status === "PENDING").length,
    };
  }

  // --- Personal: my learning (learning.view + linked employee) ---
  let myLearningTile: MyLearningTile | null = null;
  if (myLearning) {
    if (myLearning.linked) {
      const recs = myLearning.records;
      myLearningTile = {
        linked: true,
        assigned: recs.filter((r) => r.status === "ASSIGNED" || r.status === "IN_PROGRESS").length,
        overdue: recs.filter((r) => isOverdue(r.status, r.dueDate)).length,
        available: myLearning.available.length,
      };
    } else {
      myLearningTile = { linked: false, assigned: 0, overdue: 0, available: 0 };
    }
  }

  // --- Personal: my handbook acknowledgment (learning.view + linked employee) ---
  let myHandbook: MyHandbookTile | null = null;
  if (handbook) {
    myHandbook = {
      linked: handbook.myAck.linked,
      published: !!handbook.current,
      acknowledged: handbook.myAck.acknowledged,
    };
  }

  // --- Payroll posture (payroll.view) ---
  let payroll: PayrollTile | null = null;
  if (payrollHome) {
    const latest = [...payrollHome.cycles].sort(
      (a, b) => b.createdAt.getTime() - a.createdAt.getTime()
    )[0];
    payroll = {
      label: latest?.label ?? null,
      status: latest?.status ?? null,
      itemCount: latest?.itemCount ?? 0,
      totalPayable: latest?.totalPayable ?? null,
      hasOpenCycle: payrollHome.hasOpenCycle,
    };
  }

  // --- Bonus posture (bonus.view) ---
  let bonus: BonusTile | null = null;
  if (bonusHome) {
    const latest = [...bonusHome.rounds].sort(
      (a, b) => b.createdAt.getTime() - a.createdAt.getTime()
    )[0];
    bonus = {
      roundLabel: latest?.label ?? null,
      roundStatus: latest?.status ?? null,
      hasOpenRound: bonusHome.hasOpenRound,
      deferralsDue: deferrals?.dueTotal ?? 0,
      focusYear: deferrals?.focusYear ?? new Date().getFullYear(),
    };
  }

  // --- Sponsorship exposure (compensation.view) ---
  const sponsorship: SponsorshipTile | null = sponsorshipReg
    ? {
        exposure: sponsorshipReg.totalExposure,
        committed: sponsorshipReg.totalCommitted,
        activeCount: sponsorshipReg.activeCount,
      }
    : null;

  // --- Compa-ratio flags (compensation.view) ---
  let compaFlags: CompaFlagsTile | null = null;
  if (positioning) {
    compaFlags = {
      prioritize: positioning.rows.filter((r) => r.prioritise).length,
      belowMin: positioning.rows.filter((r) => r.belowMin).length,
      threshold: positioning.crThreshold,
    };
  }

  // --- Appraisal-cycle completion (performance.view) ---
  let appraisalCycle: AppraisalCycleTile | null = null;
  if (canPerformance) {
    const total = appraisalRoster?.length ?? 0;
    const finalized = appraisalRoster?.filter((r) => r.status.key === "FINALIZED").length ?? 0;
    appraisalCycle = {
      cycleName: defaultCycle?.name ?? null,
      cycleStatus: defaultCycle?.status ?? null,
      finalized,
      total,
      pct: total ? Math.round((finalized / total) * 100) : 0,
    };
  }

  const hasOrgTiles = !!(
    roster ||
    logins ||
    comp ||
    learning ||
    orgLeave ||
    payroll ||
    bonus ||
    sponsorship ||
    compaFlags ||
    appraisalCycle
  );
  const hasPersonal = !!(myLeave || myLearningTile || myHandbook);

  return {
    viewerName: me.name,
    roleKeys: me.roleKeys,
    roster,
    logins,
    comp,
    learning,
    orgLeave,
    payroll,
    bonus,
    sponsorship,
    compaFlags,
    appraisalCycle,
    hasOrgTiles,
    myLeave,
    myLearning: myLearningTile,
    myHandbook,
    identity,
    myPayslip,
    hasPersonal,
  };
}
