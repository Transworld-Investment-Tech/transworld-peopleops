// Pure engine for staff-file completeness against HR Operations Manual D6.2
// ("What a Complete Staff File Contains"). Import-free and side-effect-free so
// it can be unit-tested in isolation (npm run stafffile:test). The data layer
// (lib/stafffile-data.ts) resolves each employee's facts + the set of D6.2
// slots they have satisfied, and calls computeCompleteness() here.
//
// A "slot" is one canonical D6.2 document type. An employee's REQUIRED slots
// depend on their effective grade (employees.grade ?? jobProfile.grade),
// whether the role is regulated (employees.is_regulated_role), their
// employment status, and whether they carry any conduct/grievance record.
// Completeness is the share of required slots that are satisfied.

export const STAFF_FILE_SLOTS = [
  "CONTRACT",
  "OFFER_LETTER",
  "ID_VERIFIED",
  "RIGHT_TO_WORK",
  "GUARANTOR",
  "QUALIFICATIONS",
  "SEC_NGX_REG",
  "CRIMINAL_CHECK",
  "HANDBOOK_ACK",
  "PAD_ACK",
  "CONFIDENTIALITY_ACK",
  "PROBATION_MIDPOINT",
  "PROBATION_OUTCOME",
  "PERF_REVIEWS",
  "CASE_RECORDS",
  "EXIT_DOCS",
] as const;

export type SlotKey = (typeof STAFF_FILE_SLOTS)[number];

// Applicability rule per slot — how the required set is decided.
//   ALL              every employee
//   QUAL             G2+ OR regulated role
//   REGULATED        regulated role only
//   POST_PROBATION   confirmed (ACTIVE) or exited — i.e. probation is behind them
//   CONFIRMED        confirmed (ACTIVE) only
//   AS_APPLICABLE    only if the person carries a conduct/grievance record
//   EXITED           exited only
type Rule =
  | "ALL"
  | "QUAL"
  | "REGULATED"
  | "POST_PROBATION"
  | "CONFIRMED"
  | "AS_APPLICABLE"
  | "EXITED";

type SlotMeta = { label: string; d62: string; rule: Rule };

// Order here is the canonical display order (mirrors the D6.2 table).
export const SLOT_META: Record<SlotKey, SlotMeta> = {
  CONTRACT:            { label: "Signed employment contract",        d62: "All employees — current and exited", rule: "ALL" },
  OFFER_LETTER:        { label: "Signed offer letter",               d62: "All employees", rule: "ALL" },
  ID_VERIFIED:         { label: "Verified ID (passport / NIN)",      d62: "All employees", rule: "ALL" },
  RIGHT_TO_WORK:       { label: "Right-to-work confirmation",        d62: "All employees", rule: "ALL" },
  GUARANTOR:           { label: "Guarantor forms (×2)",              d62: "All employees", rule: "ALL" },
  QUALIFICATIONS:      { label: "Verified qualifications",           d62: "All G2+ employees; all regulated roles", rule: "QUAL" },
  SEC_NGX_REG:         { label: "SEC / NGX registration",            d62: "All regulated roles", rule: "REGULATED" },
  CRIMINAL_CHECK:      { label: "Criminal-record check result",      d62: "All employees", rule: "ALL" },
  HANDBOOK_ACK:        { label: "Signed Handbook acknowledgment",    d62: "All employees — current version", rule: "ALL" },
  PAD_ACK:             { label: "Personal Account Dealing ack",      d62: "All employees", rule: "ALL" },
  CONFIDENTIALITY_ACK: { label: "Confidentiality / Data-Protection ack", d62: "All employees", rule: "ALL" },
  PROBATION_MIDPOINT:  { label: "Probation midpoint review",         d62: "All employees post-probation", rule: "POST_PROBATION" },
  PROBATION_OUTCOME:   { label: "Probation outcome letter",          d62: "All employees post-probation", rule: "POST_PROBATION" },
  PERF_REVIEWS:        { label: "Performance reviews",               d62: "All confirmed employees", rule: "CONFIRMED" },
  CASE_RECORDS:        { label: "Disciplinary / grievance records",  d62: "As applicable — sealed on file", rule: "AS_APPLICABLE" },
  EXIT_DOCS:           { label: "Exit documentation",                d62: "Exited employees", rule: "EXITED" },
};

export function slotLabel(s: string): string {
  return (SLOT_META as Record<string, SlotMeta>)[s]?.label ?? s;
}

/** Numeric rank for the GN grades; PT and unknown are below G0. */
export function gradeRank(grade: string | null | undefined): number {
  if (!grade) return -1;
  const m = /^G(\d)$/.exec(grade.trim().toUpperCase());
  return m ? Number(m[1]) : -1; // "PT" or anything non-GN -> -1
}

/** True when the effective grade is G2 or higher. */
export function isG2Plus(grade: string | null | undefined): boolean {
  return gradeRank(grade) >= 2;
}

export type EmployeeFacts = {
  grade: string | null; // effective grade (employees.grade ?? jobProfile.grade)
  isRegulated: boolean;
  status: string; // EmploymentStatus: ACTIVE | PROBATION | ON_LEAVE | EXITED | SUSPENDED
  hasCaseRecords: boolean;
};

function ruleApplies(rule: Rule, f: EmployeeFacts): boolean {
  const exited = f.status === "EXITED";
  // "Confirmed" = active staff who are past probation. ON_LEAVE / SUSPENDED are
  // confirmed people in a temporary state, so they count as confirmed too.
  const confirmed = f.status === "ACTIVE" || f.status === "ON_LEAVE" || f.status === "SUSPENDED";
  switch (rule) {
    case "ALL":            return true;
    case "QUAL":           return isG2Plus(f.grade) || f.isRegulated;
    case "REGULATED":      return f.isRegulated;
    case "POST_PROBATION": return confirmed || exited;
    case "CONFIRMED":      return confirmed;
    case "AS_APPLICABLE":  return f.hasCaseRecords;
    case "EXITED":         return exited;
  }
}

/** The D6.2 slots required for a given employee, in canonical display order. */
export function requiredSlotsFor(f: EmployeeFacts): SlotKey[] {
  return STAFF_FILE_SLOTS.filter((s) => ruleApplies(SLOT_META[s].rule, f));
}

export type Completeness = {
  required: SlotKey[];
  satisfied: SlotKey[];
  missing: SlotKey[];
  requiredCount: number;
  satisfiedCount: number;
  pct: number; // 0..100, rounded to a whole number
  complete: boolean; // pct >= threshold
};

export const DEFAULT_THRESHOLD_PCT = 90; // D6.3 target: 18/18 files at >= 90%

/**
 * Completeness for one employee. `satisfiedSet` is the set of slot keys the
 * employee actually has on file (a slot is satisfied when >=1 acceptable
 * staff_document carries that file_slot; CASE_RECORDS may also be satisfied by
 * an existing sealed case record — the data layer decides that and passes it in).
 */
export function computeCompleteness(
  f: EmployeeFacts,
  satisfiedSet: ReadonlySet<string>,
  threshold = DEFAULT_THRESHOLD_PCT
): Completeness {
  const required = requiredSlotsFor(f);
  const satisfied = required.filter((s) => satisfiedSet.has(s));
  const missing = required.filter((s) => !satisfiedSet.has(s));
  const requiredCount = required.length;
  const satisfiedCount = satisfied.length;
  const pct = requiredCount === 0 ? 100 : Math.round((satisfiedCount / requiredCount) * 100);
  return {
    required,
    satisfied,
    missing,
    requiredCount,
    satisfiedCount,
    pct,
    complete: pct >= threshold,
  };
}

/** Bar tone for a completeness %: green at/above threshold, amber/red below. */
export function completenessBarClass(pct: number, threshold = DEFAULT_THRESHOLD_PCT): string {
  if (pct >= threshold) return "bar";
  if (pct >= 50) return "bar warn";
  return "bar warn";
}

/** Badge tone for a completeness %. */
export function completenessBadge(pct: number, threshold = DEFAULT_THRESHOLD_PCT): { cls: string; label: string } {
  if (pct >= threshold) return { cls: "b-grn", label: `${pct}%` };
  if (pct >= 50) return { cls: "b-amb", label: `${pct}%` };
  return { cls: "b-red", label: `${pct}%` };
}

/** Average completeness across a set of per-employee percentages (0..100). */
export function averagePct(pcts: number[]): number {
  if (pcts.length === 0) return 0;
  const sum = pcts.reduce((a, b) => a + b, 0);
  return Math.round((sum / pcts.length) * 100) / 100; // two decimals
}
