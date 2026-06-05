// =============================================================================
// lib/help.ts — Transworld PeopleOps Portal: the single help-content registry.
//
// ONE source, THREE renders:
//   1. The in-app Help drawer (components/HelpDrawer.tsx) — role-aware "?" panel.
//   2. The /help index (app/(app)/help/page.tsx) — browsable by nav section.
//   3. The exported written guide (tools/gen-tutorial.ts → docs/portal-guide/*).
//
// CONTENT-ONLY. This module imports nothing but lib/permissions.ts (pure data):
// no React, no Prisma, no server imports. That keeps lib/help.test.ts runnable
// under `tsx` with no database, and lets Next tree-shake it into the client
// drawer cleanly.
//
// ── THE BINDING RULE (definition-of-done) ───────────────────────────────────
// A release that ADDS or CHANGES a page MUST add/update that page's HELP entry
// in the SAME release — exactly like widening a CHECK vocabulary in the release
// that uses it. `npm run help:test` is the mechanical backstop: it fails loudly
// if a nav slug (or any declared route in DEEP_ROUTES) has no entry, or if an
// entry points at a slug/permission that no longer exists.
//
// Keyed by route slug: nav pages use their MODULE_BY_SLUG slug; deep routes use
// their route path with the dynamic segment in brackets (e.g. "payroll/[cycleId]").
// =============================================================================

import { PERMISSIONS, MODULE_BY_SLUG } from "./permissions";

export type HelpAction = {
  /** The control exactly as it reads on the page, e.g. "Submit for approval". */
  label: string;
  /** Gating permission (a real PERMISSIONS key). null = anyone who can see the page. */
  perm: string | null;
  /** 1–2 plain-English sentences: what it does + its effect/gate. */
  what: string;
  /** true where approver ≠ preparer is enforced (renders a "two people, on purpose" note). */
  separation?: boolean;
  /** true where the action seals/locks a record (renders a "permanent once done" note). */
  immutable?: boolean;
};

export type HelpEntry = {
  /** Route key. Nav pages: a MODULE_BY_SLUG slug. Deep routes: the path, e.g. "compensation/raises/[cycleId]". */
  slug: string;
  /** Parent nav slug this sits under ("payroll", "compensation", …). "" for off-nav self-service. */
  navSlug: string;
  /** Nav section label ("People", "Talent", …). Drives /help ordering. */
  section: string;
  /** Page name as shown. */
  title: string;
  /** Permission to SEE the page (the route's requirePermission gate). null = any signed-in user. */
  viewPerm: string | null;
  /** 2–4 sentences, portal voice: what the page is for. */
  purpose: string;
  /** Plain English: who uses it. */
  audience: string;
  /** Actions on the page + gates; role-filtered at render. */
  actions: HelpAction[];
  /** Where the page sits in the larger lifecycle, with cross-refs. */
  workflow?: string;
  /** The "don't"s / surprises. */
  gotchas: string[];
  /** Related slugs for cross-links (must resolve to real HELP entries). */
  related: string[];
  /** Which WORKFLOW chapter of the exported guide this feeds (not page-by-page). */
  tutorialSection: string;
  /** "coming_soon" → evidence/controls render the placeholder note. */
  status?: "live" | "coming_soon";
};

// Order the /help index and the exported guide follow.
export const SECTION_ORDER = [
  "Overview",
  "People",
  "Talent",
  "Conduct & Cases",
  "Grow & Reward",
  "Payroll Control",
  "Governance",
  "Administration",
  "Account",
] as const;

// Off-nav and deep (dynamic / sub) routes the registry is expected to cover.
// The guard checks: every HELP key is a nav slug OR is in here (no orphans),
// and every entry here has a HELP entry (full coverage).
export const DEEP_ROUTES: string[] = [
  // People
  "employees/[id]",
  "employees/[id]/edit",
  "employees/new",
  "employees/org",
  "job-competency/[id]",
  "job-competency/[id]/edit",
  "job-competency/[id]/scorecard/edit",
  "job-competency/competencies",
  "job-competency/competencies/[id]/edit",
  "job-competency/competencies/new",
  "job-competency/new",
  "leave/[requestId]",
  "leave/balances",
  "leave/request",
  "leave/types",
  "my-team/[employeeId]",
  // Talent
  "recruitment/[openingId]",
  "onboarding/[employeeId]",
  "offboarding/[employeeId]",
  "staff-files/[employeeId]",
  // Conduct & Cases
  "discipline/[caseId]",
  "discipline/new",
  "grievances/[grievanceId]",
  "whistleblower/[reportId]",
  // Grow & Reward
  "performance/[cycleId]/[employeeId]",
  "performance/new",
  "performance/pip",
  "performance/pip/[pipId]",
  "performance/pip/new",
  "learning/handbook",
  "learning/handbook/edit",
  "learning/modules/[moduleId]",
  "learning/modules/[moduleId]/edit",
  "learning/modules/new",
  "learning/modules/[moduleId]/manage",
  "learning/modules/[moduleId]/check",
  "learning/my",
  "learning/recommend",
  "compensation/[employeeId]",
  "compensation/bands",
  "compensation/positioning",
  "compensation/raises",
  "compensation/raises/[cycleId]",
  "compensation/requests",
  "compensation/sponsorship",
  "compensation/sponsorship/[sponsorshipId]",
  "compensation/sponsorship/new",
  "compensation/tax",
  "bonus/[roundId]",
  "bonus/deferrals",
  // Payroll Control
  "payroll/[cycleId]",
  // Administration
  "admin/templates/[templateId]",
  "admin/templates/new",
  // Account (off-nav, reached from the Topbar)
  "account/profile",
  "account/password",
];

// Pages deliberately NOT in the registry (pre-auth / error / infra; not in NAV,
// so outside the coverage guard): "login", "access-denied", "[...slug]" (the
// coming-soon/not-found catch-all), and the root redirect.

// -----------------------------------------------------------------------------
// THE REGISTRY
// -----------------------------------------------------------------------------
export const HELP: Record<string, HelpEntry> = {
  // ===========================================================================
  // OVERVIEW
  // ===========================================================================
  dashboard: {
    slug: "dashboard",
    navSlug: "dashboard",
    section: "Overview",
    title: "Dashboard",
    viewPerm: "dashboard.view",
    purpose:
      `Your landing page and home base. It shows a set of tiles scoped to what your role can ` +
      `see — open payroll, pending approvals, leave to review, staff-file gaps, alerts — so you ` +
      `can tell at a glance what needs attention today. It is a summary, not a place to act: each ` +
      `tile links you through to the page that does the work.`,
    audience: `Everyone. Each person sees only the tiles their role unlocks.`,
    actions: [
      { label: "Open a tile", perm: null, what: `Jumps to the underlying page (payroll, approvals, alerts, and so on). The tiles you see depend on your roles.` },
    ],
    workflow: `The starting point. Most days begin here and fan out to Payroll, Performance, Alerts or the case desks.`,
    gotchas: [
      `Two people seeing different tiles is normal — the dashboard mirrors each role's permissions.`,
      `Numbers here are a prompt to look, not the record of truth; open the page itself to act.`,
    ],
    related: ["alerts", "payroll", "performance", "staff-files"],
    tutorialSection: "Getting started & finding your way",
  },

  // ===========================================================================
  // PEOPLE
  // ===========================================================================
  employees: {
    slug: "employees",
    navSlug: "employees",
    section: "People",
    title: "Employees",
    viewPerm: "employees.view",
    purpose:
      `The staff directory — every employee record in one place, with their grade, role, status ` +
      `and contact details. This is where People Ops keeps the master record each other module ` +
      `reads from (pay, performance, leave, staff files all hang off the person here).`,
    audience: `Most roles can view the directory; People Ops (HR Admin) maintains it.`,
    actions: [
      { label: "Open a person", perm: "employees.view", what: `Opens the full profile (Employees → a person).` },
      { label: "Add employee", perm: "employees.manage", what: `Starts a new staff record. Most joiners arrive instead through Recruitment → Onboarding; use this for direct adds.` },
    ],
    workflow: `The spine of the whole portal. A person usually enters via the hiring pipeline and the candidate→staff conversion, then lives here for the rest of their employment.`,
    gotchas: [
      `A person's grade is taken from their own record if set, otherwise from their job profile.`,
      `Editing here changes the master record other modules read — take care.`,
    ],
    related: ["employees/[id]", "employees/new", "employees/org", "job-competency"],
    tutorialSection: "Managing people",
  },
  "employees/[id]": {
    slug: "employees/[id]",
    navSlug: "employees",
    section: "People",
    title: "Employee profile",
    viewPerm: "employees.view",
    purpose:
      `One person's full record: personal details, grade and role, dependents and employment ` +
      `history (promotions, transfers, grade changes). This is the page auditors and managers open ` +
      `to understand who someone is and how their employment has moved over time.`,
    audience: `Viewable across most roles; editable by People Ops (HR Admin).`,
    actions: [
      { label: "Edit profile", perm: "employees.manage", what: `Opens the edit form for personal and role details.` },
      { label: "Add / remove dependent", perm: "employees.manage", what: `Maintains the dependents list used for records and benefits.` },
      { label: "Add employment record", perm: "employees.manage", what: `Logs a dated event — promotion, transfer, grade change — to the employment history.` },
    ],
    workflow: `Feeds compensation, performance, staff files and onboarding. Employment-history events are the audit trail of someone's progression.`,
    gotchas: [
      `Changing grade or role here ripples into pay positioning and staff-file applicability — review those after.`,
      `Add an employment record for any material change rather than silently editing — it is the history.`,
    ],
    related: ["employees", "employees/[id]/edit", "compensation/[employeeId]", "staff-files/[employeeId]"],
    tutorialSection: "Managing people",
  },
  "employees/[id]/edit": {
    slug: "employees/[id]/edit",
    navSlug: "employees",
    section: "People",
    title: "Edit employee",
    viewPerm: "employees.manage",
    purpose:
      `The form behind the profile's Edit button: name, contact, personal details, grade and role. ` +
      `Saving updates the master employee record.`,
    audience: `People Ops (HR Admin).`,
    actions: [
      { label: "Save changes", perm: "employees.manage", what: `Writes the edits to the employee record (audited).` },
    ],
    gotchas: [
      `For a grade or role move, also add an employment-history record on the profile so the change is dated and explained.`,
    ],
    related: ["employees/[id]", "employees"],
    tutorialSection: "Managing people",
  },
  "employees/new": {
    slug: "employees/new",
    navSlug: "employees",
    section: "People",
    title: "Add employee",
    viewPerm: "employees.manage",
    purpose:
      `Creates a brand-new staff record directly. Most new joiners should come through Recruitment ` +
      `and the candidate→staff conversion, which carries their hiring evidence across; use this for ` +
      `back-fills or records created outside a hiring round.`,
    audience: `People Ops (HR Admin).`,
    actions: [
      { label: "Create employee", perm: "employees.manage", what: `Adds the person to the directory (audited). Set up their compensation and onboarding next.` },
    ],
    gotchas: [
      `Prefer the hiring pipeline for real recruits — it keeps the selection and verification trail attached.`,
      `A new record has no pay until you establish a compensation profile.`,
    ],
    related: ["employees", "recruitment", "onboarding", "compensation/[employeeId]"],
    tutorialSection: "Managing people",
  },
  "employees/org": {
    slug: "employees/org",
    navSlug: "employees",
    section: "People",
    title: "Org chart",
    viewPerm: "employees.view",
    purpose:
      `A visual of the firm's structure — the leadership spine, the executive line, and each team ` +
      `beneath it. A read-only way to see reporting lines and where everyone sits.`,
    audience: `Anyone who can view employees.`,
    actions: [
      { label: "Open a person", perm: "employees.view", what: `Jumps from a node to that person's profile.` },
    ],
    gotchas: [`Read-only — it reflects the roles and reporting set on the employee records; fix the structure there.`],
    related: ["employees", "employees/[id]"],
    tutorialSection: "Managing people",
  },
  "job-competency": {
    slug: "job-competency",
    navSlug: "job-competency",
    section: "People",
    title: "Job & Competency",
    viewPerm: "jobframework.view",
    purpose:
      `The library of job profiles and the competency framework behind them: each role's grade, ` +
      `family and track, its job description, and the competencies and scorecard that define what ` +
      `"good" looks like. This is the firm's definition of every role.`,
    audience: `Viewable by most; People Ops maintains it (jobframework.manage).`,
    actions: [
      { label: "Open a profile", perm: "jobframework.view", what: `Opens a role's full definition.` },
      { label: "New job profile", perm: "jobframework.manage", what: `Creates a new role definition.` },
      { label: "Competencies", perm: "jobframework.view", what: `Opens the competency library (the 22 competencies in 7 categories).` },
    ],
    workflow: `Feeds compensation (grade → band) and performance (scorecard → bonus multiplier). Set the right grade, family, track and scorecard here and the reward maths follow.`,
    gotchas: [
      `Grade lives on the profile; a person can override it on their own record. Changing a profile's grade moves everyone on it.`,
      `Set family / track / rung / control-function flag on any new role.`,
    ],
    related: ["job-competency/[id]", "job-competency/competencies", "compensation", "performance"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/[id]": {
    slug: "job-competency/[id]",
    navSlug: "job-competency",
    section: "People",
    title: "Job profile",
    viewPerm: "jobframework.view",
    purpose:
      `One role's full definition — grade, family, track, the job description, the competency set ` +
      `the scorecard weights that drive appraisal and bonus, and the training assigned to the role.`,
    audience: `Viewable by most; editable by People Ops (jobframework.manage).`,
    actions: [
      { label: "Edit profile", perm: "jobframework.manage", what: `Changes grade, family, track and details for the role.` },
      { label: "Edit scorecard", perm: "jobframework.manage", what: `Sets the competency weights (40–60 / 20–30 / 20–30) that the bonus multiplier reads.` },
    ],
    gotchas: [
      `The scorecard weights here decide the indicative score; the leadership family carries its own 55/20/25 weighting.`,
      `"Training for this role" is driven by the assignment matrix; everyone also completes the firm-wide mandatory set. Reserved (Draft) roles show their training too — it switches on automatically when someone is assigned the profile.`,
    ],
    related: ["job-competency", "job-competency/[id]/edit", "job-competency/[id]/scorecard/edit", "learning"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/[id]/edit": {
    slug: "job-competency/[id]/edit",
    navSlug: "job-competency",
    section: "People",
    title: "Edit job profile",
    viewPerm: "jobframework.manage",
    purpose: `The form to change a role's grade, family, track and description.`,
    audience: `People Ops (jobframework.manage).`,
    actions: [{ label: "Save profile", perm: "jobframework.manage", what: `Writes the role definition (audited).` }],
    gotchas: [`Changing the grade re-positions everyone holding this profile who hasn't set a personal grade.`],
    related: ["job-competency/[id]", "compensation/positioning"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/[id]/scorecard/edit": {
    slug: "job-competency/[id]/scorecard/edit",
    navSlug: "job-competency",
    section: "People",
    title: "Edit scorecard",
    viewPerm: "jobframework.manage",
    purpose:
      `Sets which competencies count for this role and how they're weighted. The scorecard is what ` +
      `the appraisal scores against and what the bonus multiplier is computed from.`,
    audience: `People Ops (jobframework.manage).`,
    actions: [
      { label: "Save scorecard", perm: "jobframework.manage", what: `Stores the competency weights for the role.` },
      { label: "Delete scorecard", perm: "jobframework.manage", what: `Removes the scorecard (the role falls back to defaults).` },
    ],
    gotchas: [`Per-scorecard category split must stay inside 40–60 / 20–30 / 20–30; the integrity gate can still zero a multiplier regardless of score.`],
    related: ["job-competency/[id]", "performance/[cycleId]/[employeeId]", "bonus/[roundId]"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/competencies": {
    slug: "job-competency/competencies",
    navSlug: "job-competency",
    section: "People",
    title: "Competency library",
    viewPerm: "jobframework.view",
    purpose:
      `The master list of the firm's 22 competencies across 7 categories, each rated at Foundational, ` +
      `Proficient or Expert. Scorecards are built by selecting and weighting from this library.`,
    audience: `Viewable by most; editable by People Ops.`,
    actions: [
      { label: "New competency", perm: "jobframework.manage", what: `Adds a competency to the library.` },
      { label: "Edit competency", perm: "jobframework.manage", what: `Updates a competency's definition or levels.` },
    ],
    gotchas: [`This is the shared vocabulary — edits ripple into every scorecard that uses the competency.`],
    related: ["job-competency", "job-competency/competencies/new"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/competencies/[id]/edit": {
    slug: "job-competency/competencies/[id]/edit",
    navSlug: "job-competency",
    section: "People",
    title: "Edit competency",
    viewPerm: "jobframework.manage",
    purpose: `The form to revise a single competency's name, category and level descriptors.`,
    audience: `People Ops (jobframework.manage).`,
    actions: [{ label: "Save competency", perm: "jobframework.manage", what: `Writes the competency (audited).` }],
    gotchas: [`Changing a competency affects every scorecard referencing it.`],
    related: ["job-competency/competencies"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/competencies/new": {
    slug: "job-competency/competencies/new",
    navSlug: "job-competency",
    section: "People",
    title: "New competency",
    viewPerm: "jobframework.manage",
    purpose: `Adds a new competency to the firm-wide library.`,
    audience: `People Ops (jobframework.manage).`,
    actions: [{ label: "Create competency", perm: "jobframework.manage", what: `Adds it to the 7-category framework.` }],
    gotchas: [`Place it in the right category — categories carry the family weighting.`],
    related: ["job-competency/competencies"],
    tutorialSection: "The job & competency framework",
  },
  "job-competency/new": {
    slug: "job-competency/new",
    navSlug: "job-competency",
    section: "People",
    title: "New job profile",
    viewPerm: "jobframework.manage",
    purpose: `Creates a new role: its grade, family, track and description. Build its scorecard afterwards.`,
    audience: `People Ops (jobframework.manage).`,
    actions: [{ label: "Create profile", perm: "jobframework.manage", what: `Adds the role to the library.` }],
    gotchas: [`Set family, track, rung and the control-function flag now — they drive reward and the CCO sign-off rule in hiring.`],
    related: ["job-competency", "job-competency/[id]/scorecard/edit"],
    tutorialSection: "The job & competency framework",
  },
  leave: {
    slug: "leave",
    navSlug: "leave",
    section: "People",
    title: "Leave",
    viewPerm: "leave.view",
    purpose:
      `The leave hub: your own balances and requests, plus — for managers and People Ops — the ` +
      `requests waiting on you. Annual, sick and other leave types all flow through here.`,
    audience: `Everyone requests leave; managers recommend; People Ops decides (leave.manage).`,
    actions: [
      { label: "Request leave", perm: "leave.view", what: `Opens the request form for yourself.` },
      { label: "Open a request", perm: "leave.view", what: `Opens a request to review or act on it.` },
    ],
    workflow: `Employee requests → manager recommends → People Ops approves or declines → balance updates.`,
    gotchas: [`Your balance only moves once a request is approved.`, `Managers recommend; the formal decision sits with People Ops.`],
    related: ["leave/request", "leave/[requestId]", "leave/balances", "leave/types"],
    tutorialSection: "Leave",
  },
  "leave/request": {
    slug: "leave/request",
    navSlug: "leave",
    section: "People",
    title: "Request leave",
    viewPerm: "leave.view",
    purpose: `Where you book time off — pick the leave type, the dates, and add a note. The request goes to your manager and then People Ops.`,
    audience: `Every employee, for themselves.`,
    actions: [
      { label: "Submit request", perm: "leave.view", what: `Sends the request for review. The system always books it against you, the signed-in user — not whoever a form names.` },
    ],
    workflow: `The first step of the leave flow; track it on the request page once submitted.`,
    gotchas: [`Check your balance first — over-booking will be caught at decision, not here.`],
    related: ["leave", "leave/balances", "leave/[requestId]"],
    tutorialSection: "Leave",
  },
  "leave/[requestId]": {
    slug: "leave/[requestId]",
    navSlug: "leave",
    section: "People",
    title: "Leave request",
    viewPerm: "leave.view",
    purpose: `One leave request in detail — its dates, type, status, and the manager and People-Ops decisions on it.`,
    audience: `The requester (view), the manager (recommend), People Ops (decide).`,
    actions: [
      { label: "Recommend / decline (manager)", perm: null, what: `A line manager records a recommendation on a report's request. Available to the request's manager.` },
      { label: "Approve / decline", perm: "leave.manage", what: `People Ops makes the binding decision; an approval updates the balance.` },
      { label: "Cancel / edit", perm: null, what: `The requester can cancel; People Ops can edit a request with a note.` },
    ],
    gotchas: [`Once approved, the balance has moved — cancelling restores it, with an audit trail.`],
    related: ["leave", "leave/balances"],
    tutorialSection: "Leave",
  },
  "leave/balances": {
    slug: "leave/balances",
    navSlug: "leave",
    section: "People",
    title: "Leave balances",
    viewPerm: "leave.view",
    purpose:
      `Everyone's entitlements and remaining balances by leave type. People Ops sets and adjusts the ` +
      `entitlements that the request flow draws down.`,
    audience: `Viewable for your own; People Ops manages entitlements (leave.manage).`,
    actions: [
      { label: "Save entitlement", perm: "leave.manage", what: `Sets or adjusts a person's entitlement for a leave type (audited).` },
    ],
    gotchas: [`Entitlements set here are the ceiling the request flow checks against.`],
    related: ["leave", "leave/types"],
    tutorialSection: "Leave",
  },
  "leave/types": {
    slug: "leave/types",
    navSlug: "leave",
    section: "People",
    title: "Leave types",
    viewPerm: "leave.view",
    purpose: `The catalogue of leave types the firm offers (annual, sick, compassionate, and so on) and their rules.`,
    audience: `People Ops (leave.manage).`,
    actions: [{ label: "Save leave type", perm: "leave.manage", what: `Adds or edits a leave type and its settings.` }],
    gotchas: [`Changing a type's rules affects future requests, not ones already decided.`],
    related: ["leave", "leave/balances"],
    tutorialSection: "Leave",
  },
  "my-documents": {
    slug: "my-documents",
    navSlug: "my-documents",
    section: "People",
    title: "My Documents",
    viewPerm: "documents.view_own",
    purpose:
      `Your personal document shelf: letters and forms the firm has issued to you, anything awaiting ` +
      `your signature, and a place to upload your own copies (IDs, certificates).`,
    audience: `Every employee, for their own documents.`,
    actions: [
      { label: "Sign a document", perm: "documents.view_own", what: `Records your acknowledgement / signature on a document issued to you.` },
      { label: "Upload a document", perm: "documents.view_own", what: `Adds your own file (e.g. a certificate) to your shelf.` },
    ],
    workflow: `Documents People Ops generates for you land here for signature; signed copies feed your staff file.`,
    gotchas: [`Signing is logged with a timestamp — it is your acknowledgement on record.`],
    related: ["staff-files/[employeeId]", "account/profile"],
    tutorialSection: "Your self-service",
  },
  "my-performance": {
    slug: "my-performance",
    navSlug: "my-performance",
    section: "People",
    title: "My Performance",
    viewPerm: "performance.self",
    purpose:
      `Your own performance space across the calendar-year cycle: your goal agreement, your ` +
      `self-assessment, your mid-cycle input and any development plan or PIP. This is where you ` +
      `contribute your side of the appraisal.`,
    audience: `Every employee, for themselves.`,
    actions: [
      { label: "Draft & submit goals", perm: "performance.self", what: `Builds your goal sheet and submits it for your manager to agree and seal.` },
      { label: "Acknowledge agreement", perm: "performance.self", what: `Confirms the sealed goal agreement with your manager.` },
      { label: "Save self-assessment", perm: "performance.self", what: `Records your own assessment for the cycle.` },
      { label: "Submit mid-cycle / acknowledge PIP", perm: "performance.self", what: `Adds your mid-cycle input in July, or acknowledges a performance-improvement plan.` },
    ],
    workflow: `Goal-setting (January) → mid-cycle (July) → year-end self + manager review (Nov–Dec) → calibration (Feb–Mar) → bonus (April).`,
    gotchas: [
      `The cycle is the calendar year (Jan–Dec) — January goals, July mid-cycle.`,
      `Once your manager seals the goal agreement it's locked evidence; later changes go through amendments.`,
    ],
    related: ["my-team", "performance", "performance/mid-cycle", "my-bonus"],
    tutorialSection: "The performance cycle",
  },
  "my-team": {
    slug: "my-team",
    navSlug: "my-team",
    section: "People",
    title: "My Team",
    viewPerm: "performance.team",
    purpose:
      `A line manager's view of their direct reports' performance: the goal agreements to review and ` +
      `seal, progress to note, and the year-end picture. This is where you agree goals with your team ` +
      `and keep them moving.`,
    audience: `Line managers (performance.team).`,
    actions: [
      { label: "Request changes", perm: "performance.team", what: `Sends a report's draft goals back with comments.` },
      { label: "Approve & seal goals", perm: "performance.team", what: `Agrees and locks the goal agreement — it becomes immutable evidence.`, immutable: true },
      { label: "Note progress / add amendment", perm: "performance.team", what: `Records progress against goals, or amends a sealed agreement through the audited amendment route.` },
    ],
    workflow: `Sits opposite My Performance: the employee drafts, the manager agrees and seals, both track through the year.`,
    gotchas: [`Sealing is deliberate and permanent — use amendments for later change, not a re-seal.`],
    related: ["my-performance", "my-team/[employeeId]", "performance"],
    tutorialSection: "The performance cycle",
  },
  "my-team/[employeeId]": {
    slug: "my-team/[employeeId]",
    navSlug: "my-team",
    section: "People",
    title: "Team member performance",
    viewPerm: "performance.team",
    purpose: `One report's performance from the manager's side: their goals, progress and the actions you can take to agree and steward them.`,
    audience: `The person's line manager (performance.team).`,
    actions: [
      { label: "Request changes / approve & seal", perm: "performance.team", what: `Reviews the draft and seals the agreement (immutable once sealed).`, immutable: true },
      { label: "Note progress / amend", perm: "performance.team", what: `Records progress or files an amendment to a sealed agreement.` },
    ],
    gotchas: [`You only see and act on your own reports here.`],
    related: ["my-team", "my-performance"],
    tutorialSection: "The performance cycle",
  },
  "grievances/raise": {
    slug: "grievances/raise",
    navSlug: "grievances/raise",
    section: "People",
    title: "Raise a Grievance",
    viewPerm: "grievance.raise",
    purpose:
      `Where any employee formally raises a workplace grievance. You describe the matter and submit ` +
      `it; People Ops acknowledges and investigates, and there's an appeal route if you're not ` +
      `satisfied with the outcome.`,
    audience: `Every employee.`,
    actions: [
      { label: "Submit grievance", perm: "grievance.raise", what: `Files your grievance for People Ops to acknowledge and investigate.` },
    ],
    workflow: `Raise → acknowledged → investigated → finding → close, with an appeal heard separately.`,
    gotchas: [
      `This is the named, formal route. To report misconduct confidentially, use Report a Concern instead.`,
    ],
    related: ["grievances", "report-a-concern"],
    tutorialSection: "Conduct & cases",
  },
  "report-a-concern": {
    slug: "report-a-concern",
    navSlug: "report-a-concern",
    section: "People",
    title: "Report a Concern",
    viewPerm: "whistleblower.report",
    purpose:
      `The whistleblowing channel — for reporting suspected misconduct, fraud or regulatory breaches. ` +
      `Reports go to the Compliance Officer (the CCO); concerns about senior management route to the ` +
      `Chairman. Use this when you need a protected, formal channel rather than the grievance route.`,
    audience: `Every employee.`,
    actions: [
      { label: "Submit a report", perm: "whistleblower.report", what: `Files a whistleblowing report into the protected channel handled by the CCO.` },
    ],
    workflow: `Report → CCO assigns a handler → investigation → outcome → the reporter is acknowledged.`,
    gotchas: [
      `This is separate from grievances and is treated as protected disclosure.`,
      `Senior-management reports are visible only to the Chairman tier, not the normal CCO route.`,
    ],
    related: ["whistleblower", "grievances/raise"],
    tutorialSection: "Conduct & cases",
  },

  // ===========================================================================
  // TALENT
  // ===========================================================================
  recruitment: {
    slug: "recruitment",
    navSlug: "recruitment",
    section: "Talent",
    title: "Recruitment",
    viewPerm: "recruitment.view",
    purpose:
      `The hiring desk — every open role and its pipeline. Hiring runs as a ten-stage, gated process: ` +
      `Stages 1–3 are the requisition (raise the role, get CFO and MD budget sign-off, confirm the ` +
      `role pack); Stages 4–10 are the candidate journey from sourced to hired.`,
    audience: `Viewable by several roles; People Ops runs it; Finance/MD approve budget; the CCO signs off control-function selections.`,
    actions: [
      { label: "Raise a requisition", perm: "recruitment.manage", what: `Opens a new role with its business case and must-haves (Stage 1).` },
      { label: "Open an opening", perm: "recruitment.view", what: `Goes to the opening's pipeline to run the stages.` },
    ],
    workflow: `Requisition (raise → CFO affordability → MD budget → role pack) → candidates (source → screen → interview → select → checks → offer → hire). The hire becomes a staff record via candidate→staff conversion.`,
    gotchas: [
      `No self-approval: the person who raised a requisition can't approve its budget.`,
      `Control-function roles need the CCO's independent sign-off before an offer.`,
    ],
    related: ["recruitment/[openingId]", "onboarding", "employees"],
    tutorialSection: "Hiring (the ten-stage pipeline)",
  },
  "recruitment/[openingId]": {
    slug: "recruitment/[openingId]",
    navSlug: "recruitment",
    section: "Talent",
    title: "Opening & pipeline",
    viewPerm: "recruitment.view",
    purpose:
      `One role's whole pipeline on a single page: the requisition gates, the list of candidates with ` +
      `their stage, the selection decision and (for control-function roles) the CCO sign-off, the ` +
      `Stage-8 verification checklist, and the offer and conversion to staff.`,
    audience: `People Ops runs the pipeline; CFO/MD approve budget; the CCO signs off; People Ops converts the hire.`,
    actions: [
      { label: "Record budget approval", perm: "requisition.approve", what: `CFO records affordability, then MD records the budget decision (Stage 2). The approver must not be the person who raised it.`, separation: true },
      { label: "Confirm role pack", perm: "recruitment.manage", what: `Locks the agreed role definition before sourcing (Stage 3).` },
      { label: "Add / move a candidate", perm: "recruitment.manage", what: `Adds candidates and advances them through the eleven-stage vocabulary; each move is logged.` },
      { label: "Record selection", perm: "recruitment.manage", what: `Captures the selection decision and rationale (Stage 7).` },
      { label: "CCO sign-off", perm: "selection.cco", what: `For control-function roles, the CCO independently signs off the selection — and can't be the selector.`, separation: true },
      { label: "Stage-8 checks", perm: "recruitment.manage", what: `Works the 10-item verification checklist; every applicable check must be cleared or waived before an offer.` },
      { label: "Convert to staff", perm: "employees.manage", what: `Turns the hired candidate into an employee record (Stage 10), carrying the regulated-role flag.` },
    ],
    workflow: `The heart of hiring. The move to OFFER is blocked until checks are ready and (where required) the CCO has signed off; the move to HIRED hands off to Onboarding.`,
    gotchas: [
      `Raiser ≠ budget approver, and selector ≠ CCO sign-off — both enforced by the system.`,
      `You can't reach OFFER with an outstanding applicable check, or without CCO sign-off on a control-function role.`,
      `Every stage move writes an event — the pipeline is its own audit trail.`,
    ],
    related: ["recruitment", "onboarding/[employeeId]", "employees/[id]", "staff-files/[employeeId]"],
    tutorialSection: "Hiring (the ten-stage pipeline)",
  },
  onboarding: {
    slug: "onboarding",
    navSlug: "onboarding",
    section: "Talent",
    title: "Onboarding",
    viewPerm: "onboarding.view",
    purpose:
      `Tracks new joiners through their first weeks — the task checklist, probation milestone and ` +
      `first review. It picks up where hiring hands off and makes sure nothing is missed before a ` +
      `person is fully settled.`,
    audience: `Viewable by several roles; People Ops runs it (onboarding.manage).`,
    actions: [
      { label: "Start onboarding", perm: "onboarding.manage", what: `Begins the onboarding record for a joiner.` },
      { label: "Open a joiner", perm: "onboarding.view", what: `Opens their onboarding detail and tasks.` },
    ],
    workflow: `Hiring → onboarding (tasks + probation clock + decision) → confirmed employee. A confirm moves the person onto the performance cycle; a non-confirm opens an exit. Probation records (midpoint + outcome) feed the staff file.`,
    gotchas: [`Onboarding usually starts from a converted candidate, so the person already exists in Employees.`],
    related: ["onboarding/[employeeId]", "recruitment", "offboarding", "staff-files/[employeeId]"],
    tutorialSection: "Onboarding a joiner",
  },
  "onboarding/[employeeId]": {
    slug: "onboarding/[employeeId]",
    navSlug: "onboarding",
    section: "Talent",
    title: "Joiner onboarding",
    viewPerm: "onboarding.view",
    purpose:
      `One joiner's onboarding: the task list (seed a default set or add your own), the probation ` +
      `window, and the probation clock — the midpoint review and the end-of-probation decision.`,
    audience: `People Ops (onboarding.manage).`,
    actions: [
      { label: "Seed default tasks", perm: "onboarding.manage", what: `Adds the standard onboarding checklist.` },
      { label: "Add / complete tasks", perm: "onboarding.manage", what: `Adds tasks and marks them done as the joiner settles in.` },
      { label: "Set probation", perm: "onboarding.manage", what: `Records the probation period and its milestone dates (the standard is six months).` },
      { label: "Record midpoint review", perm: "onboarding.manage", what: `Logs the ~3-month review (on track / concerns) and files the signed form into the staff file.` },
      { label: "Record decision", perm: "onboarding.manage", what: `The end-of-probation call: confirm (onto the performance cycle), extend (defined period), or do not confirm (opens an exit). Files the outcome letter.` },
    ],
    workflow: `The clock derives the midpoint (~3 months), the decide-by date (two weeks before the end) and the end date from the start date and length. A confirm flips the person ACTIVE; a non-confirm opens an offboarding case.`,
    gotchas: [
      `Confirm and do-not-confirm change the person's employment status — they are real transitions, recorded as employment events.`,
      `The midpoint and outcome documents only count toward the staff file once you attach them to their D6.2 slot here.`,
    ],
    related: ["onboarding", "offboarding/[employeeId]", "staff-files/[employeeId]", "alerts"],
    tutorialSection: "Onboarding a joiner",
  },
  offboarding: {
    slug: "offboarding",
    navSlug: "offboarding",
    section: "Talent",
    title: "Offboarding",
    viewPerm: "offboarding.view",
    purpose:
      `The orderly exit workflow — the mirror of onboarding. Every departure runs as a case with the ` +
      `access-and-asset revocation checklist, the sign-offs, and a close-out that marks the record ` +
      `exited and crystallizes any sponsorship repayment.`,
    audience: `Oversight roles view; People Ops runs it (offboarding.manage).`,
    actions: [
      { label: "Start an exit", perm: "offboarding.manage", what: `Opens a case for the chosen exit type and seeds the revocation checklist.` },
      { label: "Open a case", perm: "offboarding.view", what: `Goes to the case detail to work the checklist and close it out.` },
    ],
    workflow: `Notice/decision → access review and revocation → handover and sign-offs → close (mark exited, retain the file). A non-confirmed probation lands here automatically.`,
    gotchas: [
      `Starting a case does not exit the person — that happens only at close.`,
      `Redundancy, retirement and medical incapacity never trigger sponsorship clawback (Ops Manual G4.3).`,
    ],
    related: ["offboarding/[employeeId]", "onboarding", "staff-files/[employeeId]"],
    tutorialSection: "Onboarding a joiner",
  },
  "offboarding/[employeeId]": {
    slug: "offboarding/[employeeId]",
    navSlug: "offboarding",
    section: "Talent",
    title: "Exit case",
    viewPerm: "offboarding.view",
    purpose:
      `One person's exit: the three-group revocation checklist (system, physical, regulatory), the ` +
      `linked login and its roles, the sign-offs, the live sponsorship-repayment preview, and the close.`,
    audience: `Oversight roles view; People Ops works it (offboarding.manage).`,
    actions: [
      { label: "Edit case details", perm: "offboarding.manage", what: `Records the notice date, last working day, reason and notes.` },
      { label: "Set checklist items", perm: "offboarding.manage", what: `Marks each revocation/handover item done or not-applicable.` },
      { label: "Mark sign-offs", perm: "offboarding.manage", what: `Flags the exit interview, final pay and any regulatory notification (awareness — pay is settled in Remita).` },
      { label: "Revoke access", perm: "offboarding.manage", what: `Disables the login and clears all roles after a preview of exactly what will change. Asks you to confirm first.`, separation: true },
      { label: "Mark exited & close", perm: "offboarding.manage", what: `Marks the employee exited, writes the exit event, crystallizes sponsorship repayment, and closes — after you confirm. Permanent.`, immutable: true },
      { label: "Cancel exit", perm: "offboarding.manage", what: `Cancels an open case opened in error or retracted. The employee is not exited; any revoked access stays revoked.` },
      { label: "Reopen case", perm: "offboarding.manage", what: `Reopens a closed or cancelled case. Reopening a closed case reinstates the employee to ACTIVE and reverts any still-pending repayment.` },
    ],
    workflow: `Revoke access (or waive it with a recorded reason), work the checklist, then close. Close reads the clawback exposure as of the last working day and writes the repayment status onto each sponsorship. A case opened in error can be cancelled; a terminal case can be reopened.`,
    gotchas: [
      `You can't revoke your own account.`,
      `Access must be revoked (or explicitly waived) before the case can close.`,
      `Mid-study sponsorships have no formula — they're flagged for COO review, not auto-clawed.`,
      `Closing is permanent: it sets the employment status to exited. Reopening reverses it but does not re-enable a revoked login — re-grant roles in User Management.`,
    ],
    related: ["offboarding", "onboarding/[employeeId]", "staff-files/[employeeId]", "compensation/sponsorship/[sponsorshipId]"],
    tutorialSection: "Onboarding a joiner",
  },
  "staff-files": {
    slug: "staff-files",
    navSlug: "staff-files",
    section: "Talent",
    title: "Staff Files",
    viewPerm: "stafffile.view",
    purpose:
      `The completeness drive for everyone's personnel file against the Operations Manual's 16 ` +
      `required document slots (D6.2). It shows, worst-first, who is missing what, the firm-wide ` +
      `"files complete: X of N" figure, and the trend over time as you take dated snapshots.`,
    audience: `Viewable by oversight roles (Exec, Compliance, Internal Control, Auditor); People Ops runs the drive (stafffile.manage).`,
    actions: [
      { label: "Open a person's file", perm: "stafffile.view", what: `Drills into one employee's slot-by-slot completeness.` },
      { label: "Take a snapshot", perm: "stafffile.manage", what: `Freezes today's completeness as immutable evidence — the trend line of the drive.`, immutable: true },
    ],
    workflow: `Classify each document into its D6.2 slot → completeness is computed live → snapshot the milestone. The 90% threshold (D6.3) marks "complete".`,
    gotchas: [
      `Snapshots are permanent once taken — they are the audit record, not a draft.`,
      `Which slots apply depends on grade, the regulated-role flag, status and case history.`,
      `The roll-up is worst-first, on purpose: attention goes where the gaps are.`,
    ],
    related: ["staff-files/[employeeId]", "alerts", "my-documents"],
    tutorialSection: "Staff files & the completeness drive",
  },
  "staff-files/[employeeId]": {
    slug: "staff-files/[employeeId]",
    navSlug: "staff-files",
    section: "Talent",
    title: "Employee staff file",
    viewPerm: "stafffile.view",
    purpose:
      `One person's file: each of the 16 D6.2 slots, whether it applies to them, and whether it's ` +
      `filled. This is where People Ops classifies documents into slots and sets the regulated-role flag.`,
    audience: `Oversight roles view; People Ops classifies (stafffile.manage).`,
    actions: [
      { label: "Classify a document into a slot", perm: "stafffile.manage", what: `Tags an existing staff document to the D6.2 slot it satisfies; completeness updates live.` },
      { label: "Set regulated-role flag", perm: "stafffile.manage", what: `Marks the person as a regulated role, which changes which slots apply.` },
    ],
    gotchas: [
      `A sealed disciplinary case record satisfies the CASE_RECORDS slot on its own.`,
      `Effective grade for applicability = the person's own grade, else their job profile's.`,
    ],
    related: ["staff-files", "my-documents", "employees/[id]"],
    tutorialSection: "Staff files & the completeness drive",
  },
  alerts: {
    slug: "alerts",
    navSlug: "alerts",
    section: "Talent",
    title: "Alerts",
    viewPerm: "stafffile.view",
    purpose:
      `The early-warning board. It computes document-expiry alerts (from staff-document expiry dates, ` +
      `in 90-day / 30-day / expired buckets) and staff-file-gap alerts (files below the threshold). ` +
      `You see the live dry run first, then commit the ones worth tracking.`,
    audience: `Oversight roles view; People Ops generates and manages (stafffile.manage).`,
    actions: [
      { label: "Commit alerts", perm: "stafffile.manage", what: `Persists the previewed alerts. Idempotent — committing twice won't duplicate, and a dismissed/resolved alert is never resurrected.` },
      { label: "Dismiss / resolve", perm: "stafffile.manage", what: `Clears an alert you've handled or judged not relevant.` },
    ],
    workflow: `Dry run (the page preview) → commit (button) → work the list → dismiss or resolve. Never automated — you decide what becomes a tracked alert.`,
    gotchas: [
      `The preview recomputes every visit; committing is what makes an alert stick.`,
      `Expiry alerts read staff-document expiry dates; gap alerts read the staff-file drive.`,
    ],
    related: ["staff-files", "staff-files/[employeeId]"],
    tutorialSection: "Alerts",
  },

  // ===========================================================================
  // CONDUCT & CASES
  // ===========================================================================
  discipline: {
    slug: "discipline",
    navSlug: "discipline",
    section: "Conduct & Cases",
    title: "Disciplinary",
    viewPerm: "discipline.manage",
    purpose:
      `The disciplinary case desk. People Ops opens and investigates cases; warnings are approved by ` +
      `the COO tier and final warnings / dismissals by the MD or Chairman. Case records are kept as ` +
      `evidence with defined retention.`,
    audience: `People Ops manages; COO approves warnings; MD/Chairman approve final warning & dismissal.`,
    actions: [
      { label: "Open a case", perm: "discipline.manage", what: `Starts a disciplinary case (the New case form).` },
      { label: "Open a case record", perm: "discipline.manage", what: `Goes to a case to investigate and act.` },
    ],
    workflow: `Open → investigate → (suspend if needed) → issue action with the right approval → record response & acknowledgement → close.`,
    gotchas: [
      `No self-approval — the person preparing a case isn't the one who approves the sanction.`,
      `Retention: verbal 12 months, written 18, final written 24 (permanent if regulatory).`,
    ],
    related: ["discipline/[caseId]", "discipline/new", "grievances"],
    tutorialSection: "Conduct & cases",
  },
  "discipline/[caseId]": {
    slug: "discipline/[caseId]",
    navSlug: "discipline",
    section: "Conduct & Cases",
    title: "Disciplinary case",
    viewPerm: "discipline.manage",
    purpose: `One case in full: the allegation, the investigation, any suspension, the action issued and its approval, the employee's response and the close.`,
    audience: `People Ops manages; the warning/dismissal step needs the right approver.`,
    actions: [
      { label: "Record investigation", perm: "discipline.manage", what: `Logs investigation notes and evidence.` },
      { label: "Suspend / lift suspension", perm: "discipline.manage", what: `Records a precautionary suspension and its lifting.` },
      { label: "Issue an action", perm: "discipline.approve", what: `Issues the sanction. A warning is approved at COO tier; a final warning or dismissal needs MD/Chairman (discipline.dismiss).`, separation: true },
      { label: "Record response / acknowledgement / close", perm: "discipline.manage", what: `Captures the employee's response, their acknowledgement, and closes the case.` },
    ],
    gotchas: [
      `The approval needed steps up with severity: warning → COO; final warning & dismissal → MD/Chairman.`,
      `A sealed case record can satisfy the staff-file CASE_RECORDS slot.`,
    ],
    related: ["discipline", "staff-files/[employeeId]"],
    tutorialSection: "Conduct & cases",
  },
  "discipline/new": {
    slug: "discipline/new",
    navSlug: "discipline",
    section: "Conduct & Cases",
    title: "New disciplinary case",
    viewPerm: "discipline.manage",
    purpose: `Opens a new disciplinary case against an employee, recording the allegation and the people involved.`,
    audience: `People Ops (discipline.manage).`,
    actions: [{ label: "Open case", perm: "discipline.manage", what: `Creates the case and takes you to its record.` }],
    gotchas: [`Be precise in the allegation — it frames the whole case and its retention.`],
    related: ["discipline", "discipline/[caseId]"],
    tutorialSection: "Conduct & cases",
  },
  grievances: {
    slug: "grievances",
    navSlug: "grievances",
    section: "Conduct & Cases",
    title: "Grievances",
    viewPerm: "grievance.manage",
    purpose:
      `The grievance case desk — where People Ops handles grievances employees have raised: ` +
      `acknowledge, investigate, record a finding, and close. Appeals are heard separately by the ` +
      `appeal tier.`,
    audience: `People Ops manages & investigates; the appeal tier hears appeals.`,
    actions: [
      { label: "Open a grievance", perm: "grievance.manage", what: `Goes to a raised grievance to work it.` },
    ],
    workflow: `Employee raises (Raise a Grievance) → acknowledged → investigated → finding → close; appeal heard by the appeal tier.`,
    gotchas: [`The employee-facing "Raise a Grievance" page is under People; this desk is the handling side.`],
    related: ["grievances/[grievanceId]", "grievances/raise"],
    tutorialSection: "Conduct & cases",
  },
  "grievances/[grievanceId]": {
    slug: "grievances/[grievanceId]",
    navSlug: "grievances",
    section: "Conduct & Cases",
    title: "Grievance case",
    viewPerm: "grievance.manage",
    purpose: `One grievance in detail: the matter raised, the investigation, the finding, any appeal and the close.`,
    audience: `People Ops (manage); appeal tier (appeal).`,
    actions: [
      { label: "Acknowledge", perm: "grievance.manage", what: `Confirms receipt to the employee and starts the clock.` },
      { label: "Record finding", perm: "grievance.manage", what: `Logs the investigation outcome.` },
      { label: "Record appeal", perm: "grievance.approve", what: `The appeal tier records the appeal hearing and decision.` },
      { label: "Close", perm: "grievance.manage", what: `Closes the grievance with its outcome.` },
    ],
    gotchas: [`Appeals are a separate permission and handler from the investigation, on purpose.`],
    related: ["grievances", "grievances/raise"],
    tutorialSection: "Conduct & cases",
  },
  whistleblower: {
    slug: "whistleblower",
    navSlug: "whistleblower",
    section: "Conduct & Cases",
    title: "Whistleblower",
    viewPerm: "whistleblower.access",
    purpose:
      `The protected channel for handling whistleblowing reports. The Compliance Officer (CCO) sees ` +
      `normal-route reports, assigns a handler, investigates and records the outcome; reports about ` +
      `senior management are restricted to the Chairman tier.`,
    audience: `The CCO (whistleblower.access); Chairman tier for senior-management reports (whistleblower.exec).`,
    actions: [
      { label: "Open a report", perm: "whistleblower.access", what: `Goes to a report to handle it.` },
    ],
    workflow: `Concern reported (Report a Concern) → assign handler → investigate → outcome → acknowledge the reporter.`,
    gotchas: [
      `Access is tightly held — this is sensitive, protected material.`,
      `Senior-management reports are visible only to the Chairman tier, not the normal CCO route.`,
    ],
    related: ["whistleblower/[reportId]", "report-a-concern"],
    tutorialSection: "Conduct & cases",
  },
  "whistleblower/[reportId]": {
    slug: "whistleblower/[reportId]",
    navSlug: "whistleblower",
    section: "Conduct & Cases",
    title: "Whistleblower report",
    viewPerm: "whistleblower.access",
    purpose: `One report in detail, handled within the protected channel: assignment, investigation, outcome and reporter acknowledgement.`,
    audience: `The CCO; Chairman tier for senior-management matters.`,
    actions: [
      { label: "Assign handler", perm: "whistleblower.access", what: `Assigns who investigates.` },
      { label: "Record investigation / outcome", perm: "whistleblower.access", what: `Logs the investigation and its result.` },
      { label: "Acknowledge reporter", perm: "whistleblower.access", what: `Closes the loop with the reporter, preserving protection.` },
    ],
    gotchas: [`Handle with care — confidentiality is the point of the channel.`],
    related: ["whistleblower", "report-a-concern"],
    tutorialSection: "Conduct & cases",
  },

  // ===========================================================================
  // GROW & REWARD
  // ===========================================================================
  performance: {
    slug: "performance",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "Performance",
    viewPerm: "performance.view",
    purpose:
      `The performance-cycle control room: the appraisal cycles, who's where in them, and the ` +
      `appraisal worksheets. People Ops opens the cycle and starts appraisals; managers and ` +
      `employees fill their sides; calibration agrees the final ratings that feed the bonus.`,
    audience: `Viewable by managers and oversight; People Ops manages the cycle (performance.manage).`,
    actions: [
      { label: "Create / start cycle", perm: "performance.manage", what: `Opens an appraisal cycle and starts appraisals for the population.` },
      { label: "Open an appraisal", perm: "performance.view", what: `Goes to one person's appraisal worksheet for the cycle.` },
    ],
    workflow: `Calendar-year cycle: goals (Jan) → mid-cycle (Jul) → year-end self + manager (Nov–Dec) → calibration (Feb–Mar) → bonus (Apr).`,
    gotchas: [
      `The cycle is the calendar year — the PD Guides are the source of truth on this.`,
      `Ratings only become final through calibration, which writes the agreed score back.`,
    ],
    related: ["performance/[cycleId]/[employeeId]", "performance/mid-cycle", "performance/calibration", "bonus"],
    tutorialSection: "The performance cycle",
  },
  "performance/[cycleId]/[employeeId]": {
    slug: "performance/[cycleId]/[employeeId]",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "Appraisal worksheet",
    viewPerm: "performance.view",
    purpose:
      `One person's appraisal for one cycle: the self-assessment, the manager review, the scorecard ` +
      `scoring and the indicative multiplier. This is where the year's rating is built before calibration.`,
    audience: `Managers and People Ops (performance.manage to record).`,
    actions: [
      { label: "Save self / review", perm: "performance.manage", what: `Records the self-assessment and the manager's review against the scorecard.` },
      { label: "Unsubmit self", perm: "performance.manage", what: `Reopens a submitted self-assessment for correction.` },
    ],
    workflow: `Feeds calibration, which agrees the final rating; the agreed rating then drives the bonus multiplier.`,
    gotchas: [
      `The indicative multiplier here is not final — calibration agrees and writes back the real one.`,
      `The integrity gate can zero a multiplier regardless of the competency score.`,
    ],
    related: ["performance", "performance/calibration", "job-competency/[id]/scorecard/edit", "bonus/[roundId]"],
    tutorialSection: "The performance cycle",
  },
  "performance/new": {
    slug: "performance/new",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "New performance cycle",
    viewPerm: "performance.manage",
    purpose: `Opens a new appraisal cycle (normally the calendar year) for the firm.`,
    audience: `People Ops (performance.manage).`,
    actions: [{ label: "Create cycle", perm: "performance.manage", what: `Creates the cycle so appraisals can be started against it.` }],
    gotchas: [`Align the cycle to the calendar year — Jan goals, Jul mid-cycle, Apr bonus.`],
    related: ["performance"],
    tutorialSection: "The performance cycle",
  },
  "performance/pip": {
    slug: "performance/pip",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "Improvement plans (PIP)",
    viewPerm: "performance.view",
    purpose:
      `Performance-improvement plans — the structured, time-boxed plans for staff who need to lift ` +
      `performance. Managers open and steward a PIP; the employee acknowledges it and works it.`,
    audience: `Managers / People Ops open and manage; the employee acknowledges.`,
    actions: [
      { label: "Open a PIP", perm: "performance.manage", what: `Starts a plan with objectives and a timeframe (the New PIP form).` },
      { label: "Open a plan", perm: "performance.view", what: `Goes to a PIP to update or review it.` },
    ],
    workflow: `Open → employee acknowledges → tracked to its review date → outcome. A PIP outcome can feed the staff file.`,
    gotchas: [`A PIP is supportive and structured, not a disciplinary sanction — keep the two separate.`],
    related: ["performance/pip/new", "performance/pip/[pipId]", "my-performance"],
    tutorialSection: "The performance cycle",
  },
  "performance/pip/[pipId]": {
    slug: "performance/pip/[pipId]",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "PIP detail",
    viewPerm: "performance.view",
    purpose: `One improvement plan in full: objectives, check-ins, the employee's acknowledgement and the outcome.`,
    audience: `Managers / People Ops update; the employee acknowledges.`,
    actions: [
      { label: "Update PIP", perm: "performance.manage", what: `Records progress, check-ins and the outcome.` },
      { label: "Acknowledge PIP", perm: "performance.self", what: `The employee confirms they've seen and understood the plan.` },
    ],
    gotchas: [`The employee's acknowledgement is recorded — it matters for fairness and the record.`],
    related: ["performance/pip", "my-performance"],
    tutorialSection: "The performance cycle",
  },
  "performance/pip/new": {
    slug: "performance/pip/new",
    navSlug: "performance",
    section: "Grow & Reward",
    title: "New PIP",
    viewPerm: "performance.manage",
    purpose: `Opens a new performance-improvement plan for an employee, with objectives and a review date.`,
    audience: `Managers / People Ops (performance.manage).`,
    actions: [{ label: "Open PIP", perm: "performance.manage", what: `Creates the plan and notifies the employee to acknowledge.` }],
    gotchas: [`Set clear, measurable objectives and a realistic review date.`],
    related: ["performance/pip", "performance/pip/[pipId]"],
    tutorialSection: "The performance cycle",
  },
  "performance/mid-cycle": {
    slug: "performance/mid-cycle",
    navSlug: "performance/mid-cycle",
    section: "Grow & Reward",
    title: "Mid-cycle Reviews",
    viewPerm: "performance.view",
    purpose:
      `The July check-in halfway through the calendar-year cycle. People Ops opens the round; ` +
      `employees submit their own mid-cycle input; managers record the review. It's the "are we on ` +
      `track?" moment before the year-end appraisal.`,
    audience: `Employees submit their own; managers and People Ops record reviews.`,
    actions: [
      { label: "Open mid-cycle round", perm: null, what: `Managers / People Ops open the round for the population.` },
      { label: "Submit my mid-cycle", perm: "performance.self", what: `An employee adds their own mid-cycle input.` },
      { label: "Record review", perm: null, what: `A manager / People Ops records the mid-cycle review for a report.` },
    ],
    workflow: `Sits between goal-setting (Jan) and year-end (Nov–Dec); a course-correction, not a rating.`,
    gotchas: [`Mid-cycle is in July — the calendar-year cycle, per the PD Guides.`],
    related: ["performance", "my-performance"],
    tutorialSection: "The performance cycle",
  },
  "performance/calibration": {
    slug: "performance/calibration",
    navSlug: "performance/calibration",
    section: "Grow & Reward",
    title: "Calibration",
    viewPerm: "performance.view",
    purpose:
      `Where the firm agrees final ratings fairly across people, before they drive reward. People Ops ` +
      `opens a calibration session, records the agreed rating per person, and finalizes — which writes ` +
      `the agreed rating back onto the appraisal as the official figure.`,
    audience: `People Ops runs calibration (performance.manage); oversight can view.`,
    actions: [
      { label: "Open calibration", perm: "performance.manage", what: `Starts a calibration session for a cycle.` },
      { label: "Record an entry", perm: "performance.manage", what: `Captures the agreed rating for a person.` },
      { label: "Finalize", perm: "performance.manage", what: `Locks the session and writes the agreed ratings back to the appraisals.`, immutable: true },
    ],
    workflow: `Feb–March, after year-end reviews and before the April bonus. Finalized ratings are what the bonus multiplier uses.`,
    gotchas: [
      `Finalizing writes back and seals — it's the official rating from then on.`,
      `Calibration is the fairness step; the worksheet figure is only indicative until here.`,
    ],
    related: ["performance", "performance/[cycleId]/[employeeId]", "bonus/[roundId]"],
    tutorialSection: "The performance cycle",
  },
  learning: {
    slug: "learning",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Learning & Development",
    viewPerm: "learning.view",
    purpose:
      `The learning catalogue and the firm's training record — modules staff can take, the policy ` +
      `handbook to read and acknowledge, and the record of who has completed what. People Ops curates ` +
      `the catalogue; managers can recommend modules; everyone can self-enroll.`,
    audience: `Everyone can view & enroll; People Ops manages the catalogue; managers recommend.`,
    actions: [
      { label: "Self-enroll", perm: "learning.view", what: `Adds yourself to a module.` },
      { label: "Manage modules", perm: "learning.manage", what: `Creates, edits and uploads materials for modules.` },
    ],
    workflow: `Catalogue (modules + handbook) → enroll / be recommended → complete → it shows in My Learning and the compliance record.`,
    gotchas: [`Mandatory modules and the handbook acknowledgement matter for compliance — they're not optional reading.`],
    related: ["learning/my", "learning/handbook", "learning/recommend", "learning/modules/[moduleId]"],
    tutorialSection: "Learning & development",
  },
  "learning/my": {
    slug: "learning/my",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "My Learning",
    viewPerm: "learning.view",
    purpose: `Your personal learning record — modules you're enrolled in, what you've completed, and anything outstanding or recommended for you.`,
    audience: `Every employee, for themselves.`,
    actions: [
      { label: "Self-enroll", perm: "learning.view", what: `Joins a module from the catalogue.` },
      { label: "Update my record", perm: null, what: `Marks your own progress; managers/People Ops can update others (learning.manage).` },
    ],
    gotchas: [`Outstanding mandatory items show here — clear them.`],
    related: ["learning", "learning/handbook"],
    tutorialSection: "Learning & development",
  },
  "learning/handbook": {
    slug: "learning/handbook",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Employee Handbook",
    viewPerm: "learning.view",
    purpose: `The firm's Employee Handbook to read and formally acknowledge. Your acknowledgement is recorded for compliance.`,
    audience: `Everyone reads & acknowledges; People Ops edits (learning.manage).`,
    actions: [
      { label: "Acknowledge handbook", perm: "learning.view", what: `Records that you've read and accept the current handbook.` },
    ],
    gotchas: [`Re-acknowledgement may be required when the handbook is updated.`],
    related: ["learning", "learning/handbook/edit", "my-documents"],
    tutorialSection: "Learning & development",
  },
  "learning/handbook/edit": {
    slug: "learning/handbook/edit",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Edit handbook",
    viewPerm: "learning.manage",
    purpose: `The editor for the Employee Handbook content that staff read and acknowledge.`,
    audience: `People Ops (learning.manage).`,
    actions: [{ label: "Save handbook", perm: "learning.manage", what: `Publishes the handbook content (may prompt re-acknowledgement).` }],
    gotchas: [`A material change should trigger a fresh acknowledgement round.`],
    related: ["learning/handbook"],
    tutorialSection: "Learning & development",
  },
  "learning/modules/[moduleId]": {
    slug: "learning/modules/[moduleId]",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Learning module",
    viewPerm: "learning.view",
    purpose: `One module in detail — its lesson, materials, curriculum code/domain/level, and who's enrolled or completed. Take the knowledge-check, enroll yourself, or (for People Ops) manage its content and records.`,
    audience: `Everyone views, takes the check & enrolls; People Ops manages content & records.`,
    actions: [
      { label: "Take the knowledge-check", perm: "learning.view", what: `Opens the module's graded check; a pass completes it for this period.` },
      { label: "Self-enroll", perm: "learning.view", what: `Adds you to the module.` },
      { label: "Manage", perm: "learning.manage", what: `Opens the catalogue/compliance metadata and the knowledge-check editor.` },
      { label: "Upload / remove material", perm: "learning.manage", what: `Manages the module's materials.` },
      { label: "Record acknowledgement", perm: "learning.manage", what: `Logs completion / acknowledgement for staff.` },
    ],
    gotchas: [`Removing a module's material doesn't erase completion records already logged.`],
    related: ["learning", "learning/modules/[moduleId]/manage", "learning/modules/[moduleId]/check", "learning/modules/[moduleId]/edit", "learning/my"],
    tutorialSection: "Learning & development",
  },
  "learning/modules/[moduleId]/edit": {
    slug: "learning/modules/[moduleId]/edit",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Edit module",
    viewPerm: "learning.manage",
    purpose: `The form to edit a learning module's details and settings.`,
    audience: `People Ops (learning.manage).`,
    actions: [{ label: "Save module", perm: "learning.manage", what: `Writes the module definition.` }],
    gotchas: [`Marking a module mandatory changes who must complete it.`],
    related: ["learning/modules/[moduleId]", "learning"],
    tutorialSection: "Learning & development",
  },
  "learning/modules/new": {
    slug: "learning/modules/new",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "New module",
    viewPerm: "learning.manage",
    purpose: `Creates a new learning module for the catalogue.`,
    audience: `People Ops (learning.manage).`,
    actions: [{ label: "Create module", perm: "learning.manage", what: `Adds the module so staff can enroll.` }],
    gotchas: [`Decide up front whether it's mandatory and for which grades/roles.`],
    related: ["learning", "learning/modules/[moduleId]"],
    tutorialSection: "Learning & development",
  },
  "learning/recommend": {
    slug: "learning/recommend",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Recommend modules",
    viewPerm: "learning.recommend",
    purpose: `Lets a manager recommend specific learning modules to their people — nudging development without making it mandatory firm-wide.`,
    audience: `Managers (learning.recommend).`,
    actions: [
      { label: "Recommend modules", perm: "learning.recommend", what: `Suggests modules to selected staff; the recommendation shows in their My Learning.` },
    ],
    gotchas: [`A recommendation is a nudge; mandatory assignment is a People-Ops/catalogue setting.`],
    related: ["learning", "learning/my"],
    tutorialSection: "Learning & development",
  },
  "learning/compliance": {
    slug: "learning/compliance",
    navSlug: "learning/compliance",
    section: "Grow & Reward",
    title: "Training Compliance",
    viewPerm: "learning.compliance",
    purpose:
      `The training-compliance dashboard: who has completed what, with the gaps surfaced worst-first. ` +
      `It reads the assignment matrix against each active employee and shows, per person and per module, ` +
      `whether a required item is completed, in progress, assigned, or not yet assigned. This is the read ` +
      `that feeds the staff file and answers an examiner's "show me your training records".`,
    audience: `People Ops, the CCO, and Exec (learning.compliance).`,
    actions: [
      { label: "Open a person", perm: "learning.compliance", what: `Drills into one employee's required training and evidence.` },
      { label: "Author a check", perm: "learning.manage", what: `Jumps to a module's manage page to write or edit its knowledge-check.` },
    ],
    workflow: `Matrix (who needs what) + records (who's done what) → this dashboard ranks the gaps → clear them via assignment, completion, evidence, or a waiver.`,
    gotchas: [
      `A module counts as complete only when it is genuinely met — a graded module needs a PASS, not just a "read".`,
      `"Not assigned" means a required module has no record yet for the current period; run the matrix auto-assign to create them.`,
    ],
    related: ["learning/matrix", "learning", "staff-files/[employeeId]"],
    tutorialSection: "Learning & development",
  },
  "learning/matrix": {
    slug: "learning/matrix",
    navSlug: "learning/matrix",
    section: "Grow & Reward",
    title: "Training Matrix",
    viewPerm: "learning.assign",
    purpose:
      `The role-and-grade assignment matrix and the mandatory auto-assigner. Each rule says a module is ` +
      `required or recommended for everyone (firmwide), for a grade, or for a specific role. The auto-assigner ` +
      `turns the mandatory rules into per-person learning records for the current period — always as a ` +
      `preview first, then on a separate commit.`,
    audience: `People Ops (learning.assign).`,
    actions: [
      { label: "Add / edit a rule", perm: "learning.assign", what: `Targets a module at ALL / a grade / a role as Required or Recommended.` },
      { label: "Preview auto-assign", perm: "learning.assign", what: `Shows exactly which mandatory records would be created — nothing is written yet.` },
      { label: "Commit auto-assign", perm: "learning.assign", what: `Creates the previewed mandatory records (source = Mandatory) for the current period.`, separation: true },
    ],
    workflow: `Define rules here → preview → commit → records appear in My Learning and the Training Compliance dashboard.`,
    gotchas: [
      `Auto-assign never writes on preview — you must commit deliberately.`,
      `Annual modules re-assign per calendar year (the period key); on-join modules assign once.`,
      `A module must be Published and mandatory, with at least one rule, to be auto-assigned.`,
    ],
    related: ["learning/compliance", "learning", "learning/modules/[moduleId]/manage"],
    tutorialSection: "Learning & development",
  },
  "learning/modules/[moduleId]/manage": {
    slug: "learning/modules/[moduleId]/manage",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Manage module (catalogue & check)",
    viewPerm: "learning.manage",
    purpose:
      `The authoring page for a module's compliance metadata and its gradable knowledge-check. Here you set ` +
      `the curriculum code, domain, level, owner, whether it's mandatory, its cadence and pass mark, and you ` +
      `write the check questions. Correct answers are stored server-side and never sent to the person taking it.`,
    audience: `People Ops (learning.manage).`,
    actions: [
      { label: "Save catalogue & compliance", perm: "learning.manage", what: `Sets code/domain/level/owner/mandatory/cadence/pass mark on the module.` },
      { label: "Add / edit a question", perm: "learning.manage", what: `Writes a single/multiple/true-false question with its correct answer and an explanation.` },
      { label: "Reorder / deactivate", perm: "learning.manage", what: `Orders the check and retires questions without deleting the evidence trail.` },
    ],
    workflow: `Set the module's compliance metadata + pass mark → author the questions → publish → it becomes assignable from the Training Matrix.`,
    gotchas: [
      `If a module has a pass mark, completion requires a PASS — set the questions before making it mandatory.`,
      `Correct answers are server-only; they are never exposed to the check-taker.`,
    ],
    related: ["learning/modules/[moduleId]", "learning/matrix", "learning/modules/[moduleId]/check"],
    tutorialSection: "Learning & development",
  },
  "learning/modules/[moduleId]/check": {
    slug: "learning/modules/[moduleId]/check",
    navSlug: "learning",
    section: "Grow & Reward",
    title: "Take the knowledge-check",
    viewPerm: "learning.view",
    purpose:
      `Where a person takes a module's gradable knowledge-check. Answers are graded on the server against the ` +
      `pass mark; a pass completes the module's record for the current period and records the score, attempt ` +
      `count and date as evidence. A fail can be retaken.`,
    audience: `The assigned employee (self-scoped); People Ops can take it on someone's behalf where logins aren't yet provisioned.`,
    actions: [
      { label: "Submit answers", perm: "learning.view", what: `Grades the check server-side; a pass marks the record completed for this period.`, immutable: true },
    ],
    workflow: `Assigned (or self-enrolled) → take the check → pass → it shows complete in My Learning and the Training Compliance dashboard.`,
    gotchas: [
      `Your score is computed server-side; multiple-answer questions need the exact set right (no partial credit).`,
      `A pass is the completion gate for a graded module — marking it "read" is not enough.`,
    ],
    related: ["learning/modules/[moduleId]", "learning/my", "learning/compliance"],
    tutorialSection: "Learning & development",
  },
  compensation: {
    slug: "compensation",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Compensation",
    viewPerm: "compensation.view",
    purpose:
      `The pay control room. It holds each person's standing compensation profile and the levers ` +
      `around it — salary bands, band positioning, raise cycles, change requests, sponsorships and ` +
      `the tax rules. Remember: the portal records and controls pay; HumanManager and Remita still pay it.`,
    audience: `Viewable by Finance/Exec; Finance & People Ops manage; Exec (RemCo) approves.`,
    actions: [
      { label: "Open a person", perm: "compensation.view", what: `Goes to one employee's compensation.` },
      { label: "Establish / change pay", perm: "compensation.manage", what: `Sets a profile or raises a change request; changes are approved separately.` },
    ],
    workflow: `Profile (basic + utility → fully-loaded gross × 17) → positioned against the band → changed via request or raise cycle → approved by RemCo → standing record updated. Payment stays with HumanManager/Remita.`,
    gotchas: [
      `The portal does not pay anyone — these are provisional control records.`,
      `Pay maths is settled: fully-loaded = gross × 17 ÷ 12 ÷ FTE; annual = gross × 17.`,
    ],
    related: ["compensation/[employeeId]", "compensation/bands", "compensation/raises", "payroll"],
    tutorialSection: "Compensation",
  },
  "compensation/[employeeId]": {
    slug: "compensation/[employeeId]",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Employee compensation",
    viewPerm: "compensation.view",
    purpose:
      `One person's pay in detail: their current profile (basic, utility, fully-loaded), their band ` +
      `position, and the change requests on file. Where People Ops establishes pay and raises a ` +
      `change for RemCo to approve.`,
    audience: `Finance/People Ops manage; Exec (RemCo) approves (compensation.approve).`,
    actions: [
      { label: "Establish profile", perm: "compensation.manage", what: `Sets the person's standing pay components.` },
      { label: "Create change request", perm: "compensation.manage", what: `Proposes a pay change for approval.` },
      { label: "Decide request", perm: "compensation.approve", what: `RemCo approves or rejects the change — a different person from the one who raised it.`, separation: true },
      { label: "Cancel request", perm: "compensation.manage", what: `Withdraws a pending change.` },
    ],
    workflow: `A pay change flips the prior profile version to not-current and writes a new current version in one transaction, carrying the tax structure forward — that versioning is the integration contract.`,
    gotchas: [
      `No self-approval on pay changes.`,
      `Approved changes update the standing record only; payment still runs in HumanManager/Remita.`,
    ],
    related: ["compensation", "compensation/requests", "compensation/positioning", "employees/[id]"],
    tutorialSection: "Compensation",
  },
  "compensation/bands": {
    slug: "compensation/bands",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Salary bands",
    viewPerm: "compensation.view",
    purpose: `The firm's fully-loaded salary bands, G0–G5. These define the pay range for each grade and are what band positioning and compa-ratio are measured against.`,
    audience: `Viewable; People Ops/Finance maintain (compensation.manage).`,
    actions: [
      { label: "Save salary bands", perm: "compensation.manage", what: `Updates the band minimum/mid/max by grade (audited).` },
    ],
    gotchas: [`Bands are fully-loaded (gross × 17 ÷ 12 ÷ FTE) — the same basis as positioning.`],
    related: ["compensation/positioning", "compensation"],
    tutorialSection: "Compensation",
  },
  "compensation/positioning": {
    slug: "compensation/positioning",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Band positioning",
    viewPerm: "compensation.view",
    purpose:
      `A read-only awareness view of where each person sits in their grade's band — their compa-ratio, ` +
      `and flags for anyone below minimum or below 0.80. It's a lens for spotting pay that needs ` +
      `attention; you act via change requests or a raise cycle.`,
    audience: `Finance/Exec/People Ops (compensation.view).`,
    actions: [
      { label: "Review positioning", perm: "compensation.view", what: `Reads compa-ratios and below-band flags; no changes are made here.` },
    ],
    gotchas: [`Awareness only — to move someone, use a change request or the raise cycle.`],
    related: ["compensation/bands", "compensation/raises", "compensation/[employeeId]"],
    tutorialSection: "Compensation",
  },
  "compensation/raises": {
    slug: "compensation/raises",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Raise cycles",
    viewPerm: "compensation.view",
    purpose:
      `The pay-raise cycles — a controlled, firm-wide pass that proposes and applies raises. People ` +
      `Ops opens and prepares a cycle; RemCom approves and applies it. A raise lifts every pay ` +
      `component uniformly so the structure is preserved.`,
    audience: `People Ops prepares (compensation.manage); RemCom approves & applies (compensation.approve).`,
    actions: [
      { label: "Open a cycle", perm: "compensation.manage", what: `Starts a new raise cycle.` },
      { label: "Open a cycle to work it", perm: "compensation.view", what: `Goes to the cycle's worksheet.` },
    ],
    workflow: `Open → set inputs → recompute → adjust per person → submit → RemCom approves → lock & apply. Applying updates standing profiles only.`,
    gotchas: [
      `A raise applies the percentage to every component (basic, utility, allowance) so the annual total rises by exactly that percentage.`,
      `The annual total is on the 17-month basis (gross × 17).`,
    ],
    related: ["compensation/raises/[cycleId]", "compensation", "compensation/positioning"],
    tutorialSection: "Compensation",
  },
  "compensation/raises/[cycleId]": {
    slug: "compensation/raises/[cycleId]",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Raise cycle",
    viewPerm: "compensation.view",
    purpose:
      `One raise cycle's worksheet: the inputs, the computed per-person raises, the adjustments, and ` +
      `the approve-and-lock that applies them. Prepared by People Ops, approved and locked by RemCom.`,
    audience: `People Ops prepares; RemCom approves & locks.`,
    actions: [
      { label: "Set inputs / recompute", perm: "compensation.manage", what: `Sets the cycle parameters and recomputes the per-person raises.` },
      { label: "Adjust a person", perm: "compensation.manage", what: `Overrides an individual's raise with a note.` },
      { label: "Submit for approval", perm: "compensation.manage", what: `Sends the cycle to RemCom; it locks for editing.` },
      { label: "Approve", perm: "compensation.approve", what: `RemCom approves — a different person from the preparer.`, separation: true },
      { label: "Lock & apply", perm: "compensation.approve", what: `Locks the cycle as permanent evidence and applies the raises to standing profiles.`, immutable: true },
    ],
    gotchas: [
      `No self-approval; preparer ≠ approver.`,
      `A locked cycle is permanent, read-only evidence.`,
    ],
    related: ["compensation/raises", "compensation/[employeeId]"],
    tutorialSection: "Compensation",
  },
  "compensation/requests": {
    slug: "compensation/requests",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Change requests",
    viewPerm: "compensation.view",
    purpose: `The queue of pay-change requests across the firm — what's proposed, by whom, and awaiting RemCo's decision.`,
    audience: `People Ops raises (compensation.manage); RemCo decides (compensation.approve).`,
    actions: [
      { label: "Create request", perm: "compensation.manage", what: `Proposes a pay change for a person.` },
      { label: "Decide request", perm: "compensation.approve", what: `Approves or rejects — never the same person who raised it.`, separation: true },
      { label: "Cancel request", perm: "compensation.manage", what: `Withdraws a pending request.` },
    ],
    gotchas: [`Approved requests update the standing profile (versioned), not payroll directly.`],
    related: ["compensation/[employeeId]", "compensation"],
    tutorialSection: "Compensation",
  },
  "compensation/sponsorship": {
    slug: "compensation/sponsorship",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Qualification sponsorship",
    viewPerm: "compensation.view",
    purpose:
      `The register of firm-sponsored professional qualifications — who's being sponsored, the costs, ` +
      `attempts, and the clawback terms if someone leaves. People Ops manages; RemCo approves a sponsorship.`,
    audience: `People Ops manages (compensation.manage); RemCo approves (compensation.approve).`,
    actions: [
      { label: "New sponsorship", perm: "compensation.manage", what: `Sets up a sponsorship for approval.` },
      { label: "Open a sponsorship", perm: "compensation.view", what: `Goes to a sponsorship to manage costs, attempts and status.` },
    ],
    workflow: `Create → RemCo approves → start → record costs/attempts → complete (clawback clock starts) or withdraw. Clawback is on completion, 12 months.`,
    gotchas: [
      `Clawback runs from completion for 12 months; mid-study exit is a COO review.`,
      `The early-leaver crystallization is handled when offboarding lands — not automated here yet.`,
    ],
    related: ["compensation/sponsorship/[sponsorshipId]", "compensation/sponsorship/new", "compensation"],
    tutorialSection: "Compensation",
  },
  "compensation/sponsorship/[sponsorshipId]": {
    slug: "compensation/sponsorship/[sponsorshipId]",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Sponsorship detail",
    viewPerm: "compensation.view",
    purpose: `One sponsorship in full: its status, the costs incurred, exam attempts, and the clawback position.`,
    audience: `People Ops manages; RemCo approves.`,
    actions: [
      { label: "Approve", perm: "compensation.approve", what: `RemCo approves the sponsorship.`, separation: true },
      { label: "Start / complete / withdraw", perm: "compensation.manage", what: `Moves the sponsorship through its lifecycle; completing starts the 12-month clawback clock.` },
      { label: "Add cost / attempt; waive", perm: "compensation.manage", what: `Records costs and exam attempts, and waives a cost where agreed.` },
    ],
    gotchas: [
      `Completion — not approval — starts the clawback window.`,
      `When the person exits, closing their offboarding case crystallizes the repayment here — pro-rata if they're inside the 12-month window, flagged for COO review if they were still studying.`,
    ],
    related: ["compensation/sponsorship", "compensation/sponsorship/new", "offboarding/[employeeId]"],
    tutorialSection: "Compensation",
  },
  "compensation/sponsorship/new": {
    slug: "compensation/sponsorship/new",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "New sponsorship",
    viewPerm: "compensation.manage",
    purpose: `Sets up a new qualification sponsorship for an employee, ready for RemCo approval.`,
    audience: `People Ops (compensation.manage).`,
    actions: [{ label: "Create sponsorship", perm: "compensation.manage", what: `Creates the sponsorship in draft for approval.` }],
    gotchas: [`Spell out the clawback terms up front — they bite on completion.`],
    related: ["compensation/sponsorship", "compensation/sponsorship/[sponsorshipId]"],
    tutorialSection: "Compensation",
  },
  "compensation/tax": {
    slug: "compensation/tax",
    navSlug: "compensation",
    section: "Grow & Reward",
    title: "Tax rules",
    viewPerm: "compensation.view",
    purpose:
      `The configurable tax rule sets and bands the portal uses for PAYE and statutory deductions. ` +
      `Tax is never hardcoded — it's read from here, so the active ruleset is what payroll computes against.`,
    audience: `Finance/People Ops (compensation.manage).`,
    actions: [
      { label: "Save tax ruleset", perm: "compensation.manage", what: `Creates or edits a ruleset and its bands.` },
      { label: "Activate ruleset", perm: "compensation.manage", what: `Makes a ruleset the active one payroll uses.` },
    ],
    gotchas: [
      `Only the active ruleset drives payroll — activate the right one.`,
      `ITF is an in-net employee deduction from April 2026.`,
    ],
    related: ["payroll", "compensation"],
    tutorialSection: "Compensation",
  },
  bonus: {
    slug: "bonus",
    navSlug: "bonus",
    section: "Grow & Reward",
    title: "Bonus",
    viewPerm: "bonus.view",
    purpose:
      `The bonus control room. It builds the annual bonus round from the audited result — the pool ` +
      `(15% of PBT), each person's target months by grade, and their scorecard multiplier — for RemCo ` +
      `to approve. The portal computes and records; it does not pay.`,
    audience: `Finance manages (bonus.manage); Exec (RemCo) approves (bonus.approve).`,
    actions: [
      { label: "Open a round", perm: "bonus.manage", what: `Starts a bonus round.` },
      { label: "Open a round to work it", perm: "bonus.view", what: `Goes to the round's worksheet.` },
    ],
    workflow: `Bonus is paid in April against the prior year's audited financials (published 30 March). Pool → target months → multiplier → confirm → RemCo approves → lock. Deferrals (Phase B) carry on the deferral ledger.`,
    gotchas: [
      `Pool = 0.15 × PBT; individual = target months × monthly gross × multiplier (×0–1.3); the integrity gate can zero it.`,
      `Figures are provisional control records — payment runs elsewhere.`,
    ],
    related: ["bonus/[roundId]", "bonus/deferrals", "my-bonus", "performance/calibration"],
    tutorialSection: "Bonus",
  },
  "bonus/[roundId]": {
    slug: "bonus/[roundId]",
    navSlug: "bonus",
    section: "Grow & Reward",
    title: "Bonus round",
    viewPerm: "bonus.view",
    purpose:
      `One bonus round's worksheet: the inputs (PBT, pool), each person's target months and ` +
      `multiplier, the per-row confirmation, and the approve-and-lock. Prepared by Finance, approved ` +
      `by RemCo.`,
    audience: `Finance prepares; RemCo approves & locks.`,
    actions: [
      { label: "Set inputs / multiplier", perm: "bonus.manage", what: `Enters the PBT/pool and each person's multiplier (from calibration).` },
      { label: "Confirm / reopen a row", perm: "bonus.manage", what: `Confirms a person's figure, or reopens it to amend.` },
      { label: "Submit for approval", perm: "bonus.manage", what: `Sends the round to RemCo; it locks for editing.` },
      { label: "Approve", perm: "bonus.approve", what: `RemCo approves — a different person from the preparer.`, separation: true },
      { label: "Lock", perm: "bonus.approve", what: `Seals the round as permanent evidence.`, immutable: true },
    ],
    gotchas: [
      `Preparer ≠ approver; a locked round is permanent.`,
      `G4/G5 awards split per the model; deferral portions move to the Phase B ledger.`,
    ],
    related: ["bonus", "bonus/deferrals", "performance/calibration"],
    tutorialSection: "Bonus",
  },
  "bonus/deferrals": {
    slug: "bonus/deferrals",
    navSlug: "bonus",
    section: "Grow & Reward",
    title: "Bonus deferrals (Phase B)",
    viewPerm: "bonus.view",
    purpose:
      `The deferral ledger for the part of senior bonuses held back and paid later — with clawback and ` +
      `leaver-forfeiture. This is the one place a sealed bonus figure can still move, by design.`,
    audience: `Finance manages payment/settlement (bonus.manage); RemCo handles clawback/forfeit/reinstate (bonus.approve).`,
    actions: [
      { label: "Mark paid / settle year", perm: "bonus.manage", what: `Records a deferred tranche as paid, or settles a year's deferrals.` },
      { label: "Clawback / forfeit leaver / reinstate", perm: "bonus.approve", what: `RemCo claws back, forfeits a leaver's deferral, or reinstates one.` },
    ],
    gotchas: [
      `Phase B is the deliberate exception to "locked = immutable" — handled here, with audit.`,
      `Clawback and forfeiture sit with the approval tier, not the preparer.`,
    ],
    related: ["bonus", "bonus/[roundId]"],
    tutorialSection: "Bonus",
  },

  // ===========================================================================
  // PAYROLL CONTROL
  // ===========================================================================
  payroll: {
    slug: "payroll",
    navSlug: "payroll",
    section: "Payroll Control",
    title: "Payroll Run",
    viewPerm: "payroll.view",
    purpose:
      `The monthly payroll control sheet — a clean, checked copy of the month's pay that you review, ` +
      `get approved, export and lock as the record. It does not pay anyone: HumanManager and Remita ` +
      `still calculate and pay. This is your monthly "double-check and file".`,
    audience: `Finance prepares (payroll.manage); an executive approves (payroll.approve).`,
    actions: [
      { label: "Open a cycle", perm: "payroll.manage", what: `Opens the month — pulls in active staff and works out deductions. Only one cycle open at a time.` },
      { label: "Open a cycle to work it", perm: "payroll.view", what: `Goes to the month's control sheet.` },
    ],
    workflow: `Open → review each row → adjust → confirm all → submit → executive approves → export Excel → lock. See the "Running a payroll cycle" guide.`,
    gotchas: [
      `The portal is a cross-check, not the payer — if it disagrees with HumanManager, stop and find out why.`,
      `Only one cycle open at a time; a locked month is permanent.`,
    ],
    related: ["payroll/[cycleId]", "payslips", "compensation/tax"],
    tutorialSection: "Running a payroll cycle",
  },
  "payroll/[cycleId]": {
    slug: "payroll/[cycleId]",
    navSlug: "payroll",
    section: "Payroll Control",
    title: "Payroll cycle",
    viewPerm: "payroll.view",
    purpose:
      `One month's payroll in detail: a row per employee (basic, utility, gross, pension, NHF, ITF, ` +
      `PAYE, net), running totals, and the prepare→approve→lock controls. This is the page the ` +
      `payroll guide walks through.`,
    audience: `Finance prepares; an executive approves & locks.`,
    actions: [
      { label: "Adjust a row", perm: "payroll.manage", what: `Edits a person's pay for the month (raise, unpaid leave, one-off) with a note, and confirms it.` },
      { label: "Confirm / reopen a row", perm: "payroll.manage", what: `Confirms a correct row, or reopens one to look again. All rows must be confirmed to submit.` },
      { label: "Set 13th month", perm: "payroll.manage", what: `Applies the 13th-month treatment to the cycle where due.` },
      { label: "Submit for approval", perm: "payroll.manage", what: `Sends the cycle to an executive; it locks for editing.` },
      { label: "Approve", perm: "payroll.approve", what: `An executive approves the run — a different person from the preparer.`, separation: true },
      { label: "Lock as evidence", perm: "payroll.approve", what: `Seals the month as the permanent, read-only record (Excel still exportable).`, immutable: true },
    ],
    gotchas: [
      `Preparer ≠ approver; the same person never does both.`,
      `Deductions: pension 8%×basic, NHF 2.5%×basic, ITF 1%×basic (in net from Apr 2026), PAYE on the active ruleset.`,
      `Always write a note when you change a row — for future-you and the auditor.`,
    ],
    related: ["payroll", "compensation/tax", "payslips"],
    tutorialSection: "Running a payroll cycle",
  },
  payslips: {
    slug: "payslips",
    navSlug: "payslips",
    section: "Payroll Control",
    title: "My Payslips",
    viewPerm: "payslips.view_own",
    purpose: `Your own payslips from locked payroll months — view and download your pay record. Read-only.`,
    audience: `Every employee, for themselves.`,
    actions: [
      { label: "View / download a payslip", perm: "payslips.view_own", what: `Opens your payslip for a locked month.` },
    ],
    gotchas: [`Payslips appear once a month's payroll is locked; figures mirror the control sheet, not necessarily the bank payment (which runs in Remita).`],
    related: ["payroll", "my-bonus", "account/profile"],
    tutorialSection: "Your self-service",
  },
  "my-bonus": {
    slug: "my-bonus",
    navSlug: "my-bonus",
    section: "Payroll Control",
    title: "My Bonus",
    viewPerm: "bonus.view_own",
    purpose: `Your own bonus position — your award from approved rounds and any deferred portion. Read-only.`,
    audience: `Every employee, for themselves.`,
    actions: [
      { label: "View my bonus", perm: "bonus.view_own", what: `Shows your bonus from approved/locked rounds and any Phase B deferral.` },
    ],
    gotchas: [`Bonus is paid in April against audited results; figures here are the recorded award, not a payment confirmation.`],
    related: ["bonus", "payslips"],
    tutorialSection: "Your self-service",
  },

  // ===========================================================================
  // GOVERNANCE (coming soon — reachable with permission, full UI is a later phase)
  // ===========================================================================
  evidence: {
    slug: "evidence",
    navSlug: "evidence",
    section: "Governance",
    title: "Evidence Vault",
    viewPerm: "evidence.view",
    status: "coming_soon",
    purpose:
      `A coming-soon governance module: a restricted store of compliance evidence built on the same ` +
      `"seal" pattern as staff-file snapshots — immutable, audited records for the regulator. The route ` +
      `is reachable now with permission, but the full interface is scheduled for a later build phase.`,
    audience: `Oversight roles (evidence.view) — Exec, Finance, Compliance, Internal Control, Auditor.`,
    actions: [],
    gotchas: [`Not yet built out — you'll see a "coming soon" placeholder. Access control already applies.`],
    related: ["controls", "staff-files"],
    tutorialSection: "Getting started & finding your way",
  },
  controls: {
    slug: "controls",
    navSlug: "controls",
    section: "Governance",
    title: "Internal Controls",
    viewPerm: "controls.view",
    status: "coming_soon",
    purpose:
      `A coming-soon governance module for the internal-controls and RemCo layer — the firm's control ` +
      `register and committee object. Reachable now with permission; the full interface is scheduled ` +
      `for a later build phase.`,
    audience: `Oversight roles (controls.view) — Exec, Compliance, Internal Control, Auditor.`,
    actions: [],
    gotchas: [`Not yet built out — a "coming soon" placeholder shows. Access control already applies.`],
    related: ["evidence"],
    tutorialSection: "Getting started & finding your way",
  },

  // ===========================================================================
  // ADMINISTRATION
  // ===========================================================================
  "admin/users": {
    slug: "admin/users",
    navSlug: "admin/users",
    section: "Administration",
    title: "User Management",
    viewPerm: "admin.users",
    purpose:
      `Where staff logins are provisioned and roles assigned. Create a user for an employee, set their ` +
      `roles (which decide everything they can see and do), reset passwords, and activate or ` +
      `deactivate accounts.`,
    audience: `Administrators (admin.users).`,
    actions: [
      { label: "Provision a user", perm: "admin.users", what: `Creates a login for an employee.` },
      { label: "Set roles", perm: "admin.users", what: `Assigns the roles that grant permissions across the portal.` },
      { label: "Reset password", perm: "admin.users", what: `Issues a new password for a user.` },
      { label: "Activate / deactivate", perm: "admin.users", what: `Enables or disables an account; a disabled account can't sign in.` },
    ],
    workflow: `Roles here are the whole access model — they decide each person's nav, pages and actions via the permission map.`,
    gotchas: [
      `Roles are powerful — assign the least that does the job; the Chairman role alone holds dismissal and senior whistleblower access.`,
      `Push staff off the shared initial password.`,
    ],
    related: ["admin/audit", "employees", "account/password"],
    tutorialSection: "Administration",
  },
  "admin/templates": {
    slug: "admin/templates",
    navSlug: "admin/templates",
    section: "Administration",
    title: "Document Templates",
    viewPerm: "documents.manage",
    purpose:
      `The library of document templates People Ops uses to generate staff letters and forms (offer ` +
      `letters, confirmations, and so on). Maintain the templates here; generate the actual documents ` +
      `from a person's record.`,
    audience: `People Ops (documents.manage).`,
    actions: [
      { label: "New template", perm: "documents.manage", what: `Creates a document template.` },
      { label: "Open / edit a template", perm: "documents.manage", what: `Edits an existing template.` },
    ],
    gotchas: [`Editing a template affects documents generated from then on, not ones already issued.`],
    related: ["admin/templates/new", "admin/templates/[templateId]", "my-documents"],
    tutorialSection: "Administration",
  },
  "admin/templates/[templateId]": {
    slug: "admin/templates/[templateId]",
    navSlug: "admin/templates",
    section: "Administration",
    title: "Edit template",
    viewPerm: "documents.manage",
    purpose: `The editor for one document template's content and merge fields.`,
    audience: `People Ops (documents.manage).`,
    actions: [{ label: "Save template", perm: "documents.manage", what: `Writes the template.` }],
    gotchas: [`Check the merge fields resolve before generating real letters from it.`],
    related: ["admin/templates"],
    tutorialSection: "Administration",
  },
  "admin/templates/new": {
    slug: "admin/templates/new",
    navSlug: "admin/templates",
    section: "Administration",
    title: "New template",
    viewPerm: "documents.manage",
    purpose: `Creates a new document template for the library.`,
    audience: `People Ops (documents.manage).`,
    actions: [{ label: "Create template", perm: "documents.manage", what: `Adds the template so documents can be generated from it.` }],
    gotchas: [`Follow the firm's letter format and brand.`],
    related: ["admin/templates"],
    tutorialSection: "Administration",
  },
  "admin/audit": {
    slug: "admin/audit",
    navSlug: "admin/audit",
    section: "Administration",
    title: "Audit Log",
    viewPerm: "admin.users",
    purpose:
      `The trail of sensitive actions across the portal — who did what, to what, and when. Read-only, ` +
      `and the first place to look when you need to reconstruct what happened.`,
    audience: `Administrators (admin.users).`,
    actions: [
      { label: "Browse the log", perm: "admin.users", what: `Reads the recorded actions; nothing here can be edited.` },
    ],
    gotchas: [`Read-only views don't write audit rows — only the actions that change data do.`],
    related: ["admin/users"],
    tutorialSection: "Administration",
  },

  // ===========================================================================
  // ACCOUNT (off-nav, reached from the Topbar)
  // ===========================================================================
  "account/profile": {
    slug: "account/profile",
    navSlug: "",
    section: "Account",
    title: "My Profile",
    viewPerm: null,
    purpose: `Your own account details — the personal information you can maintain about yourself. Reached from the top bar, not the sidebar.`,
    audience: `Every signed-in user, for themselves.`,
    actions: [
      { label: "Update my profile", perm: null, what: `Saves changes to your own details. The portal always acts on you, the signed-in user.` },
    ],
    gotchas: [`Some fields are maintained by People Ops on the employee record, not here.`],
    related: ["account/password", "my-documents"],
    tutorialSection: "Your self-service",
  },
  "account/password": {
    slug: "account/password",
    navSlug: "",
    section: "Account",
    title: "Change Password",
    viewPerm: null,
    purpose: `Change your own sign-in password. Reached from the top bar.`,
    audience: `Every signed-in user, for themselves.`,
    actions: [
      { label: "Change password", perm: null, what: `Sets a new password for your account.` },
    ],
    gotchas: [`If you're still on the shared initial password, change it here now.`],
    related: ["account/profile"],
    tutorialSection: "Your self-service",
  },
};

// -----------------------------------------------------------------------------
// PURE HELPERS (shared by the drawer, the /help index, and the tutorial export)
// -----------------------------------------------------------------------------

/** Look up an entry by exact slug key. */
export function helpFor(slug: string): HelpEntry | undefined {
  return HELP[slug];
}

/**
 * Map a live pathname (which carries real ids) to a registry slug.
 * Exact dynamic-segment match first (e.g. "/payroll/clx9" → "payroll/[cycleId]");
 * if nothing matches, fall back to the nearest parent entry (so a deep route is
 * never blank), then to the first segment.
 */
export function resolveSlugFromPath(pathname: string): string {
  const segs = pathname.replace(/^\/+|\/+$/g, "").split("/").filter(Boolean);
  if (segs.length === 0) return "dashboard";
  const keys = Object.keys(HELP);

  // 1) exact pattern match (literal segments must match; [param] matches any one segment)
  let best = "";
  let bestScore = -1;
  for (const k of keys) {
    const ks = k.split("/");
    if (ks.length !== segs.length) continue;
    let ok = true;
    let score = 0;
    for (let i = 0; i < ks.length; i++) {
      if (ks[i].startsWith("[")) continue; // dynamic: matches anything
      if (ks[i] === segs[i]) score++;
      else { ok = false; break; }
    }
    if (ok && score > bestScore) { best = k; bestScore = score; }
  }
  if (best) return best;

  // 2) parent fallback: the longest entry that is a segment-prefix of the path
  let fb = "";
  let fbLen = -1;
  for (const k of keys) {
    const ks = k.split("/");
    if (ks.length >= segs.length) continue;
    let ok = true;
    for (let i = 0; i < ks.length; i++) {
      if (ks[i].startsWith("[")) continue;
      if (ks[i] !== segs[i]) { ok = false; break; }
    }
    if (ok && ks.length > fbLen) { fb = k; fbLen = ks.length; }
  }
  return fb || segs[0];
}

/** Actions the given user can actually take (null perm = always shown). */
export function visibleActions(entry: HelpEntry, perms: Set<string>): HelpAction[] {
  return entry.actions.filter((a) => a.perm === null || perms.has(a.perm));
}

/** Can this user reach the page at all? (mirrors buildNav visibility). */
export function canView(entry: HelpEntry, perms: Set<string>): boolean {
  return entry.viewPerm === null || perms.has(entry.viewPerm);
}

/** The /help index: entries the user can reach, grouped and ordered by section. */
export function helpIndexBySection(
  perms: Set<string>
): { section: string; entries: HelpEntry[] }[] {
  const all = Object.values(HELP).filter((e) => canView(e, perms));
  return SECTION_ORDER.map((section) => ({
    section,
    entries: all
      .filter((e) => e.section === section)
      .sort((a, b) => a.title.localeCompare(b.title)),
  })).filter((g) => g.entries.length > 0);
}

/** All entries grouped by tutorial chapter (used by the export generator). */
export function entriesByTutorialSection(): { section: string; entries: HelpEntry[] }[] {
  const map = new Map<string, HelpEntry[]>();
  for (const e of Object.values(HELP)) {
    const list = map.get(e.tutorialSection) ?? [];
    list.push(e);
    map.set(e.tutorialSection, list);
  }
  return [...map.entries()].map(([section, entries]) => ({ section, entries }));
}

/** Real permission keys, for the guard. */
export const PERMISSION_KEYS: Set<string> = new Set(PERMISSIONS.map((p) => p.key));
/** Nav slugs, for the guard. */
export const NAV_SLUGS: string[] = Object.keys(MODULE_BY_SLUG);
