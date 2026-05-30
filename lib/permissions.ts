// Single source of truth for access control and navigation.
// - PERMISSIONS: the catalog seeded into the `permissions` table by auth:bootstrap.
// - ROLE_PERMISSIONS: which permission keys each seeded role receives.
// - NAV: the 13-module sidebar (matching the approved mock-up), each item gated
//   by a permission. buildNav() returns only the sections/items a user may see.
// - MODULE_BY_SLUG: lets a route enforce the same permission a nav item implies.
//
// This file contains data only (no React, no server imports) so it can be
// imported both by the Next.js app and by the standalone bootstrap script.

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
  { key: "onboarding.view", label: "View onboarding" },
  { key: "performance.view", label: "View performance" },
  { key: "learning.view", label: "View learning & compliance" },
  { key: "compensation.view", label: "View compensation" },
  { key: "payroll.view", label: "View payroll control" },
  { key: "payroll.manage", label: "Manage payroll control" },
  { key: "payroll.approve", label: "Approve payroll" },
  { key: "payslips.view_own", label: "View own payslips" },
  { key: "evidence.view", label: "View evidence vault" },
  { key: "controls.view", label: "View internal controls" },
  { key: "admin.users", label: "Administer users & roles" },
];

// "*" means every permission (granted to SUPER_ADMIN).
export const ROLE_PERMISSIONS: Record<string, string[] | "*"> = {
  SUPER_ADMIN: "*",
  EXEC: [
    "dashboard.view",
    "employees.view",
    "jobframework.view",
    "leave.view",
    "recruitment.view",
    "onboarding.view",
    "performance.view",
    "learning.view",
    "compensation.view",
    "payroll.view",
    "payroll.approve",
    "evidence.view",
    "controls.view",
  ],
  HR_ADMIN: [
    "dashboard.view",
    "employees.view",
    "employees.manage",
    "jobframework.view",
    "jobframework.manage",
    "leave.view",
    "leave.manage",
    "recruitment.view",
    "onboarding.view",
    "performance.view",
    "learning.view",
    "compensation.view",
    "payroll.view",
    "evidence.view",
    "payslips.view_own",
  ],
  FINANCE: [
    "dashboard.view",
    "employees.view",
    "compensation.view",
    "payroll.view",
    "payroll.manage",
    "evidence.view",
    "payslips.view_own",
  ],
  COMPLIANCE: [
    "dashboard.view",
    "employees.view",
    "learning.view",
    "evidence.view",
    "controls.view",
    "payslips.view_own",
  ],
  INTERNAL_CONTROL: [
    "dashboard.view",
    "employees.view",
    "payroll.view",
    "evidence.view",
    "controls.view",
    "payslips.view_own",
  ],
  MANAGER: [
    "dashboard.view",
    "employees.view",
    "leave.view",
    "performance.view",
    "payslips.view_own",
  ],
  EMPLOYEE: [
    "dashboard.view",
    "leave.view",
    "learning.view",
    "payslips.view_own",
  ],
  AUDITOR_RO: [
    "dashboard.view",
    "employees.view",
    "payroll.view",
    "evidence.view",
    "controls.view",
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
  evidence: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 2.5 4 6v5c0 5 3.4 8.6 8 10.5C16.6 19.6 20 16 20 11V6Z"/><path d="m9 11.5 2 2 4-4.5"/></svg>`,
  controls: `<svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3v18M3 7.5h18M6.5 7.5 5 18M17.5 7.5 19 18M3.5 18h17"/></svg>`,
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
      { slug: "learning", label: "Learning & Compliance", perm: "learning.view", icon: I.learn },
      { slug: "compensation", label: "Compensation", perm: "compensation.view", icon: I.comp },
    ],
  },
  {
    label: "Payroll Control",
    items: [
      { slug: "payroll", label: "Payroll Run", perm: "payroll.view", icon: I.payroll },
      { slug: "payslips", label: "My Payslips", perm: "payslips.view_own", icon: I.payslips },
    ],
  },
  {
    label: "Governance",
    items: [
      { slug: "evidence", label: "Evidence Vault", perm: "evidence.view", icon: I.evidence },
      { slug: "controls", label: "Internal Controls", perm: "controls.view", icon: I.controls },
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
