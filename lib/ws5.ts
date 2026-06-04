// Pure WS5 helpers — no imports, fully unit-testable. Disciplinary retention &
// expiry (Ops Manual E8), working-day targets (E9: ack <=2, finding <=15), the
// sign-off tier per disciplinary stage, plus label/badge helpers shared by the
// three case modules. DB reads/actions live in the sibling lib/*.ts files.

export const DISCIPLINARY_STAGES = [
  "INFORMAL_DISCUSSION",
  "VERBAL_WARNING",
  "WRITTEN_WARNING",
  "FINAL_WRITTEN_WARNING",
  "DISMISSAL",
] as const;
export type DisciplinaryStage = (typeof DISCIPLINARY_STAGES)[number];

const STAGE_LABEL: Record<string, string> = {
  INFORMAL_DISCUSSION: "Informal discussion",
  VERBAL_WARNING: "Verbal warning",
  WRITTEN_WARNING: "Written warning",
  FINAL_WRITTEN_WARNING: "Final written warning",
  DISMISSAL: "Dismissal",
};
export function stageLabel(s: string | null): string {
  return s ? STAGE_LABEL[s] ?? s : "—";
}

/** Retention period on the staff file, per E8. null = permanent (regulatory
 *  conduct) or not-retained (informal / dismissal). */
export function retentionMonthsFor(stage: string, isRegulatory: boolean): number | null {
  switch (stage) {
    case "VERBAL_WARNING":
      return 12;
    case "WRITTEN_WARNING":
      return 18;
    case "FINAL_WRITTEN_WARNING":
      return isRegulatory ? null : 24; // permanent for regulatory obligations
    default:
      return null; // informal discussion / dismissal carry no expiry
  }
}

/** The expiry date of a sanction (issuedAt + retentionMonths). null = permanent. */
export function expiresAt(issuedAt: Date, retentionMonths: number | null): Date | null {
  if (retentionMonths == null) return null;
  const d = new Date(issuedAt.getTime());
  d.setMonth(d.getMonth() + retentionMonths);
  return d;
}

/** A sanction is "active" until it expires; a null expiry means permanent
 *  (a regulatory final warning) and is always active. Call only for warning
 *  stages — informal discussions and dismissals are not retained warnings. */
export function isActiveSanction(expires: Date | null, asOf: Date = new Date()): boolean {
  if (expires == null) return true; // permanent
  return asOf.getTime() < expires.getTime();
}

/** Which permission a given disciplinary stage requires to sign off.
 *  null  -> no approval (informal discussion, recorded by the manager)
 *  COO   -> discipline.approve  (verbal / written)
 *  MD/Chairman -> discipline.dismiss  (final written / dismissal) */
export function approvalPermForStage(stage: string): string | null {
  switch (stage) {
    case "INFORMAL_DISCUSSION":
      return null;
    case "VERBAL_WARNING":
    case "WRITTEN_WARNING":
      return "discipline.approve";
    case "FINAL_WRITTEN_WARNING":
    case "DISMISSAL":
      return "discipline.dismiss";
    default:
      return null;
  }
}

export function approverRoleForStage(stage: string): "COO" | "CHAIRMAN" | null {
  const perm = approvalPermForStage(stage);
  if (perm === "discipline.approve") return "COO";
  if (perm === "discipline.dismiss") return "CHAIRMAN";
  return null;
}

/** Add N working days (skipping Sat/Sun) to a date. Used for the E9 timelines. */
export function addWorkingDays(from: Date, n: number): Date {
  const d = new Date(from.getTime());
  let added = 0;
  while (added < n) {
    d.setDate(d.getDate() + 1);
    const day = d.getDay();
    if (day !== 0 && day !== 6) added += 1;
  }
  return d;
}

// ── label / badge helpers ───────────────────────────────────────────────────
const CASE_STATUS_LABEL: Record<string, string> = {
  OPEN: "Open",
  INVESTIGATING: "Investigating",
  SUSPENDED: "Suspended",
  AWAITING_DECISION: "Awaiting decision",
  SANCTION_ISSUED: "Sanction issued",
  CLOSED: "Closed",
  APPEALED: "Appealed",
};
const GRIEVANCE_STATUS_LABEL: Record<string, string> = {
  RECEIVED: "Received",
  ACKNOWLEDGED: "Acknowledged",
  INVESTIGATING: "Investigating",
  FINDING_ISSUED: "Finding issued",
  APPEALED: "Appealed",
  CLOSED: "Closed",
};
const GRIEVANCE_FINDING_LABEL: Record<string, string> = {
  SUBSTANTIATED: "Substantiated",
  PARTIALLY_SUBSTANTIATED: "Partially substantiated",
  NOT_SUBSTANTIATED: "Not substantiated",
};
const WB_STATUS_LABEL: Record<string, string> = {
  RECEIVED: "Received",
  UNDER_REVIEW: "Under review",
  INVESTIGATING: "Investigating",
  SUBSTANTIATED: "Substantiated",
  NOT_SUBSTANTIATED: "Not substantiated",
  CLOSED: "Closed",
};
const WB_CATEGORY_LABEL: Record<string, string> = {
  FRAUD: "Fraud",
  REGULATORY: "Regulatory breach",
  FINANCIAL_MISCONDUCT: "Financial misconduct",
  UNETHICAL_CONDUCT: "Unethical conduct",
  HEALTH_SAFETY: "Health & safety",
  RETALIATION: "Retaliation",
  OTHER: "Other",
};

export const caseStatusLabel = (s: string) => CASE_STATUS_LABEL[s] ?? s;
export const grievanceStatusLabel = (s: string) => GRIEVANCE_STATUS_LABEL[s] ?? s;
export const grievanceFindingLabel = (s: string | null) => (s ? GRIEVANCE_FINDING_LABEL[s] ?? s : "—");
export const wbStatusLabel = (s: string) => WB_STATUS_LABEL[s] ?? s;
export const wbCategoryLabel = (s: string) => WB_CATEGORY_LABEL[s] ?? s;
export const routeLabel = (r: string) => (r === "BARC_CHAIR" ? "BARC Chair / Chairman" : "Compliance Officer");

/** A b-* badge class for any of the case statuses (open/active = amber/blue,
 *  terminal = grey/green, adverse = red). */
export function statusBadgeClass(status: string): string {
  switch (status) {
    case "OPEN":
    case "RECEIVED":
    case "UNDER_REVIEW":
      return "b-blu";
    case "INVESTIGATING":
    case "AWAITING_DECISION":
    case "ACKNOWLEDGED":
      return "b-amb";
    case "SUSPENDED":
    case "APPEALED":
    case "SANCTION_ISSUED":
    case "SUBSTANTIATED":
      return "b-red";
    case "CLOSED":
    case "FINDING_ISSUED":
    case "NOT_SUBSTANTIATED":
      return "b-gry";
    default:
      return "b-gry";
  }
}

export const DISCIPLINARY_CASE_STATUSES = [
  "OPEN", "INVESTIGATING", "SUSPENDED", "AWAITING_DECISION", "SANCTION_ISSUED", "CLOSED", "APPEALED",
] as const;
export const GRIEVANCE_STATUSES = [
  "RECEIVED", "ACKNOWLEDGED", "INVESTIGATING", "FINDING_ISSUED", "APPEALED", "CLOSED",
] as const;
export const GRIEVANCE_FINDINGS = ["SUBSTANTIATED", "PARTIALLY_SUBSTANTIATED", "NOT_SUBSTANTIATED"] as const;
export const WB_STATUSES = [
  "RECEIVED", "UNDER_REVIEW", "INVESTIGATING", "SUBSTANTIATED", "NOT_SUBSTANTIATED", "CLOSED",
] as const;
export const WB_CATEGORIES = [
  "FRAUD", "REGULATORY", "FINANCIAL_MISCONDUCT", "UNETHICAL_CONDUCT", "HEALTH_SAFETY", "RETALIATION", "OTHER",
] as const;
