// Single source of truth for access control and navigation.
// - PERMISSIONS: the catalog seeded into the `permissions` table by auth:bootstrap.
// - ROLE_PERMISSIONS: which permission keys each seeded role receives.
// - NAV: the sidebar (matching the approved mock-up), each item gated by a
//   permission. buildNav() returns only the sections/items a user may see.
// - MODULE_BY_SLUG: lets a route enforce the same permission a nav item implies.
//
// This file contains data only (no React, no server imports) so it can be
// imported both by the Next.js app and by the standalone bootstrap script.
//
// v0.13.0 — Staff login provisioning / admin.users:
//   * `admin.users` already existed in the catalog (count stays 24). This
//     release GRANTS it to HR_ADMIN (in addition to SUPER_ADMIN via "*") and
//     adds the "Administration -> User Management" sidebar entry.
//
// v0.16.0 — Recruitment + Onboarding:
//   * Adds `recruitment.manage` and `onboarding.manage` (the *.view keys already
//     existed and stay granted to EXEC + HR_ADMIN). Both manage keys are granted
//     to HR_ADMIN (SUPER_ADMIN holds everything via "*"). Permission count
//     24 -> 26; re-run `npm run auth:bootstrap` after this release.
//
// v0.17.0 — Staff & Hire Document Layer:
//   * Adds `documents.manage` (HR authoring/generate/issue, granted to HR_ADMIN)
//     and `documents.view_own` (every staff member views/signs/uploads their own,
//     granted to all real-person roles). Adds the "People -> My Documents" and
//     "Administration -> Document Templates" sidebar entries. Permission count
//     26 -> 28; re-run `npm run auth:bootstrap` after this release.
//
// v0.18.0 — Performance toolkit:
//   * Adds `performance.self` (every staff member views their own goals, files
//     weekly reports, reads their development plan, and acknowledges an
//     improvement plan), granted to all real-person roles — the same set that
//     holds `documents.view_own` (NOT AUDITOR_RO; SUPER_ADMIN holds everything
//     via "*"). Adds the "People -> My Performance" sidebar entry. The existing
//     `performance.view` / `performance.manage` keys are unchanged. Permission
//     count 28 -> 29; re-run `npm run auth:bootstrap` after this release.
//
// v0.18.1 — Goal agreement & sign-off:
//   * Adds `performance.team` (a line manager reviews, agrees, and seals the
//     goals of their own direct reports, resolved from the org chart
//     `employee.managerId`; HR does not approve). Granted to MANAGER ("Line
//     Manager") and to SUPER_ADMIN via "*". Adds the "People -> My Team"
//     sidebar entry (perm `performance.team`). The existing performance keys
//     are unchanged. Permission count 29 -> 30; role-permission links
//     116 -> 118 (MANAGER + SUPER_ADMIN). Re-run `npm run auth:bootstrap`.

// v0.20.0 — Bonus model (WS6 Part 3):
//   * Adds `bonus.view`, `bonus.manage`, `bonus.approve`. FINANCE prepares the
//     round (`bonus.manage`); EXEC (Remuneration Committee) approves + locks
//     (`bonus.approve`). HR_ADMIN, COMPLIANCE, INTERNAL_CONTROL and AUDITOR_RO
//     get read (`bonus.view`); SUPER_ADMIN holds everything via "*". Adds the
//     "Grow & Reward -> Bonus" sidebar entry. Permission count 30 -> 33;
//     role-permission links 118 -> 126. Re-run `npm run auth:bootstrap`.

// v0.20.2 — My Bonus (self-service, WS6 Part 3):
//   * Adds `bonus.view_own` (a staff member views their OWN target bonus,
//     awards and deferral schedule). Granted to EXEC, HR_ADMIN, FINANCE,
//     COMPLIANCE, INTERNAL_CONTROL, MANAGER and EMPLOYEE; SUPER_ADMIN holds
//     everything via "*". NOT granted to AUDITOR_RO. Adds the
//     "Payroll Control -> My Bonus" sidebar entry. Permission count 33 -> 34;
//     role-permission links 126 -> 133. Re-run `npm run auth:bootstrap`.

export type Permission = { key: string; label: string };

export const PERMISSIONS: Permission[] = [
  { key: "dashboard.view", label: "View dashboard" },
  { key: "employees.view", label: "View employees" },
  { key: "employees.manage", label: "Manage employees" },
  { key: "jobframework.view", label: "View job & competency framework" },
  { key: "jobframework.manage", label: "Manage job & competency framework" },
  { key: "leave.view", label: "View leave" },
  { key: "leave.manage", label: "Manage leave" },
  { key: "recruitment.view", label: "View recruitment" },
  { key: "recruitment.manage", label: "Manage recruitment" },
  { key: "onboarding.view", label: "View onboarding" },
  { key: "onboarding.manage", label: "Manage onboarding" },
  { key: "performance.view", label: "View performance" },
  { key: "performance.manage", label: "Manage performance & appraisals" },
  { key: "performance.self", label: "View & contribute to own performance" },
  { key: "performance.team", label: "Review & agree own team’s goals" },
  { key: "learning.view", label: "View learning & development" },
  { key: "learning.manage", label: "Manage learning & development" },
  { key: "learning.recommend", label: "Recommend development modules" },
  { key: "compensation.view", label: "View compensation" },
  { key: "compensation.manage", label: "Manage compensation" },
  { key: "compensation.approve", label: "Approve compensation changes" },
  { key: "payroll.view", label: "View payroll control" },
  { key: "payroll.manage", label: "Manage payroll control" },
  { key: "payroll.approve", label: "Approve payroll" },
  { key: "payslips.view_own", label: "View own payslips" },
  { key: "bonus.view", label: "View bonus" },
  { key: "bonus.manage", label: "Manage bonus" },
  { key: "bonus.approve", label: "Approve bonus" },
  { key: "bonus.view_own", label: "View own bonus" },
  { key: "evidence.view", label: "View evidence vault" },
  { key: "controls.view", label: "View internal controls" },
  { key: "admin.users", label: "Administer users & roles" },
  { key: "documents.manage", label: "Manage staff documents & templates" },
  { key: "documents.view_own", label: "View, sign & upload own documents" },
];

// "*" means every permission (granted to SUPER_ADMIN).
export const ROLE_PERMISSIONS: Record<string, string[] | "*"> = {
  SUPER_ADMIN: "*",
  EXEC: [
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "employees.view",
    "jobframework.view",
    "leave.view",
    "recruitment.view",
    "onboarding.view",
    "performance.view",
    "learning.view",
    "compensation.view",
    "compensation.approve",
    "payroll.view",
    "payroll.approve",
    "evidence.view",
    "controls.view",
    "bonus.view",
    "bonus.approve",
    "bonus.view_own",
  ],
  HR_ADMIN: [
    "documents.manage",
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "employees.view",
    "employees.manage",
    "jobframework.view",
    "jobframework.manage",
    "leave.view",
    "leave.manage",
    "recruitment.view",
    "recruitment.manage",
    "onboarding.view",
    "onboarding.manage",
    "performance.view",
    "performance.manage",
    "learning.view",
    "learning.manage",
    "learning.recommend",
    "compensation.view",
    "compensation.manage",
    "payroll.view",
    "evidence.view",
    "payslips.view_own",
    "bonus.view_own",
    // v0.13.0: HR operator can provision/link staff logins and reset passwords.
    // (Role *assignment* inside the screen is further gated to SUPER_ADMIN in
    // the server action — HR_ADMIN can create/link users but cannot elevate.)
    "admin.users",
    "bonus.view",
  ],
  FINANCE: [
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "employees.view",
    "compensation.view",
    "compensation.manage",
    "payroll.view",
    "payroll.manage",
    "bonus.view",
    "bonus.manage",
    "evidence.view",
    "payslips.view_own",
    "bonus.view_own",
  ],
  COMPLIANCE: [
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "employees.view",
    "learning.view",
    "evidence.view",
    "controls.view",
    "payslips.view_own",
    "bonus.view_own",
    "bonus.view",
  ],
  INTERNAL_CONTROL: [
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "employees.view",
    "payroll.view",
    "evidence.view",
    "controls.view",
    "payslips.view_own",
    "bonus.view_own",
    "bonus.view",
  ],
  MANAGER: [
    "documents.view_own",
    "performance.self",
    "performance.team",
    "dashboard.view",
    "employees.view",
    "leave.view",
    "performance.view",
    "learning.view",
    "learning.recommend",
    "payslips.view_own",
    "bonus.view_own",
  ],
  EMPLOYEE: [
    "documents.view_own",
    "performance.self",
    "dashboard.view",
    "leave.view",
    "learning.view",
    "payslips.view_own",
    "bonus.view_own",
  ],
  AUDITOR_RO: [
    "dashboard.view",
    "employees.view",
    "payroll.view",
    "evidence.view",
    "controls.view",
    "bonus.view",
  ],
};

export const ROLE_LABELS: Record<string, string> = {
  SUPER_ADMIN: "Super Admin",
  EXEC: "Executive Mgmt",
  HR_ADMIN: "HR Admin",
  FINANCE: "Finance / Payroll",
  COMPLIANCE: "Compliance",
  INTERNAL_CONTROL: "Internal Control",
  MANAGER: "Line Manager",
  EMPLOYEE: "Employee",
  AUDITOR_RO: "Auditor (read-only)",
};

export type NavItem = {
  slug: string;
  label: string;
  perm: string;
  icon: string; // inline SVG markup, rendered into the sidebar
};

export type NavSection = { label: string; items: NavItem[] };

const I = {
  dash: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="9"/><rect x="14" y="3" width="7" height="5"/><rect x="14" y="12" width="7" height="9"/><rect x="3" y="16" width="7" height="5"/></svg>`,
  emp: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="3.2"/><path d="M3.5 20a5.5 5.5 0 0 1 11 0M16 7a3 3 0 0 1 0 6M19.5 20a5 5 0 0 0-3-4.6"/></svg>`,
  roles: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 17.5h7M17.5 14v7"/></svg>`,
  leave: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="4.5" width="18" height="16" rx="2"/><path d="M3 9h18M8 2.5v4M16 2.5v4"/></svg>`,
  recruit: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="10" cy="8" r="3.2"/><path d="M3.5 20a5.5 5.5 0 0 1 11 0M17 8h5M19.5 5.5v5"/></svg>`,
  onboard: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="5" y="3" width="14" height="18" rx="2"/><path d="m8.5 11 1.7 1.7L14 9M8.5 16h5"/></svg>`,
  perf: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="3.5"/><path d="M12 1v3M12 20v3M1 12h3M20 12h3"/></svg>`,
  learn: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 4 2.5 8.5 12 13l9.5-4.5L12 4Z"/><path d="M6 10.5V16c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5v-5.5"/></svg>`,
  comp: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><ellipse cx="12" cy="6" rx="8" ry="3"/><path d="M4 6v12c0 1.7 3.6 3 8 3s8-1.3 8-3V6M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3"/></svg>`,
  payroll: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 2v20M17 5.5H9.5a3 3 0 0 0 0 6h5a3 3 0 0 1 0 6H6"/></svg>`,
  payslips: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2.5h9l5 5V21a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1Z"/><path d="M14 2.5V8h5M8.5 13h7M8.5 17h5"/></svg>`,
  bonus: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="9" r="6"/><path d="m9 14.5-2 7 5-3 5 3-2-7"/><path d="M12 6.2l1 2 2.2.3-1.6 1.6.4 2.2L12 11.3l-2 1 .4-2.2L8.8 8.5 11 8.2z"/></svg>`,
  evidence: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 2.5 4 6v5c0 5 3.4 8.6 8 10.5C16.6 19.6 20 16 20 11V6Z"/><path d="m9 11.5 2 2 4-4.5"/></svg>`,
  controls: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3v18M3 7.5h18M6.5 7.5 5 18M17.5 7.5 19 18M3.5 18h17"/></svg>`,
  docs: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2.5h8l4 4V21a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1Z"/><path d="M13 2.5V7h4M8.5 12h7M8.5 16h7"/></svg>`,
  admin: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="3.2"/><path d="M3.5 20a5.5 5.5 0 0 1 11 0"/><circle cx="18" cy="16.5" r="2.4"/><path d="M18 11.6v1.4M18 20v1.4M22.2 16.5h-1.4M15.2 16.5h-1.4"/></svg>`,
};

export const NAV: NavSection[] = [
  {
    label: "Overview",
    items: [
      { slug: "dashboard", label: "Dashboard", perm: "dashboard.view", icon: I.dash },
    ],
  },
  {
    label: "People",
    items: [
      { slug: "employees", label: "Employees", perm: "employees.view", icon: I.emp },
      { slug: "job-competency", label: "Job & Competency", perm: "jobframework.view", icon: I.roles },
      { slug: "leave", label: "Leave", perm: "leave.view", icon: I.leave },
      { slug: "my-documents", label: "My Documents", perm: "documents.view_own", icon: I.docs },
      { slug: "my-performance", label: "My Performance", perm: "performance.self", icon: I.perf },
      { slug: "my-team", label: "My Team", perm: "performance.team", icon: I.emp },
    ],
  },
  {
    label: "Talent",
    items: [
      { slug: "recruitment", label: "Recruitment", perm: "recruitment.view", icon: I.recruit },
      { slug: "onboarding", label: "Onboarding", perm: "onboarding.view", icon: I.onboard },
    ],
  },
  {
    label: "Grow & Reward",
    items: [
      { slug: "performance", label: "Performance", perm: "performance.view", icon: I.perf },
      { slug: "learning", label: "Learning & Development", perm: "learning.view", icon: I.learn },
      { slug: "compensation", label: "Compensation", perm: "compensation.view", icon: I.comp },
      { slug: "bonus", label: "Bonus", perm: "bonus.view", icon: I.bonus },
    ],
  },
  {
    label: "Payroll Control",
    items: [
      { slug: "payroll", label: "Payroll Run", perm: "payroll.view", icon: I.payroll },
      { slug: "payslips", label: "My Payslips", perm: "payslips.view_own", icon: I.payslips },
      { slug: "my-bonus", label: "My Bonus", perm: "bonus.view_own", icon: I.bonus },
    ],
  },
  {
    label: "Governance",
    items: [
      { slug: "evidence", label: "Evidence Vault", perm: "evidence.view", icon: I.evidence },
      { slug: "controls", label: "Internal Controls", perm: "controls.view", icon: I.controls },
    ],
  },
  {
    label: "Administration",
    items: [
      { slug: "admin/users", label: "User Management", perm: "admin.users", icon: I.admin },
      { slug: "admin/templates", label: "Document Templates", perm: "documents.manage", icon: I.docs },
    ],
  },
];

export function buildNav(permissions: Set<string>): NavSection[] {
  return NAV.map((sec) => ({
    label: sec.label,
    items: sec.items.filter((it) => permissions.has(it.perm)),
  })).filter((sec) => sec.items.length > 0);
}

export function countVisibleModules(permissions: Set<string>): number {
  return buildNav(permissions).reduce((n, s) => n + s.items.length, 0);
}

export const MODULE_BY_SLUG: Record<string, { label: string; perm: string }> =
  Object.fromEntries(
    NAV.flatMap((s) => s.items).map((it) => [
      it.slug,
      { label: it.label, perm: it.perm },
    ])
  );
