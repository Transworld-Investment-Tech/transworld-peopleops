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

export type DashboardData = {
  viewerName: string;
  roleKeys: string[];
  // org-wide (null = viewer not permitted)
  roster: RosterTile | null;
  logins: LoginsTile | null;
  comp: CompTile | null;
  learning: LearningTile | null;
  orgLeave: OrgLeaveTile | null;
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

  const hasOrgTiles = !!(roster || logins || comp || learning || orgLeave);
  const hasPersonal = !!(myLeave || myLearningTile || myHandbook);

  return {
    viewerName: me.name,
    roleKeys: me.roleKeys,
    roster,
    logins,
    comp,
    learning,
    orgLeave,
    hasOrgTiles,
    myLeave,
    myLearning: myLearningTile,
    myHandbook,
    hasPersonal,
  };
}
