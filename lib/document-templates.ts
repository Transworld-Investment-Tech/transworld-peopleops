// Document templates — read helpers, the merge-field renderer, and the
// print-ready HTML shell that wraps every generated/signed document. Templates
// are HR-authored HTML with {{merge_field}} tokens; generation snapshots the
// rendered body so later template edits never change an already-issued document.
// Writes live in lib/staff-documents-actions.ts; storage I/O in lib/storage.ts.
import { prisma } from "@/lib/db";

export const TEMPLATE_KINDS = [
  "OFFER_LETTER",
  "EMPLOYMENT_CONTRACT",
  "GUARANTOR_FORM",
  "NEXT_OF_KIN",
  "OTHER",
] as const;
export type TemplateKind = (typeof TEMPLATE_KINDS)[number];

const KIND_LABEL: Record<string, string> = {
  OFFER_LETTER: "Offer letter",
  EMPLOYMENT_CONTRACT: "Employment contract",
  GUARANTOR_FORM: "Guarantor form",
  NEXT_OF_KIN: "Next-of-kin form",
  OTHER: "Other document",
};
export function kindLabel(k: string): string {
  return KIND_LABEL[k] ?? k;
}

/** The merge fields a template author may use, shown as a quick-reference list. */
export const MERGE_FIELDS: { token: string; note: string }[] = [
  { token: "{{full_name}}", note: "Full name" },
  { token: "{{preferred_name}}", note: "Preferred / first name" },
  { token: "{{ee_id}}", note: "Employee ID" },
  { token: "{{job_title}}", note: "Job title" },
  { token: "{{department}}", note: "Department" },
  { token: "{{entity}}", note: "Legal entity" },
  { token: "{{employment_type}}", note: "Employment type" },
  { token: "{{start_date}}", note: "Start date" },
  { token: "{{work_email}}", note: "Work email" },
  { token: "{{phone}}", note: "Phone" },
  { token: "{{manager_name}}", note: "Line manager" },
  { token: "{{basic_salary}}", note: "Monthly basic (₦)" },
  { token: "{{utility_allowance}}", note: "Utility allowance (₦)" },
  { token: "{{quarterly_allowance}}", note: "Quarterly allowance (₦)" },
  { token: "{{gross_monthly}}", note: "Monthly gross (₦)" },
  { token: "{{today}}", note: "Today's date" },
];

export function escapeHtml(s: string): string {
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

/**
 * Replace {{token}} occurrences with HTML-escaped values from ctx. Unknown
 * tokens render as an em dash so a half-filled document is obvious, never blank.
 */
export function renderTemplate(bodyHtml: string, ctx: Record<string, string>): string {
  return bodyHtml.replace(/\{\{\s*([a-z0-9_]+)\s*\}\}/gi, (_m, key: string) => {
    const v = ctx[key.toLowerCase()];
    return v && v.trim() ? escapeHtml(v) : "&mdash;";
  });
}

/** A signed-on signature block appended to the body when a document is signed. */
export function signatureBlockHtml(opts: {
  signerName: string;
  signedAtLabel: string;
  signatureImg?: string | null;
}): string {
  const img = opts.signatureImg
    ? `<img src="${opts.signatureImg}" alt="Signature" style="max-height:80px;max-width:320px;display:block;margin:4px 0;" />`
    : `<div style="font-family:'Segoe Script','Brush Script MT',cursive;font-size:26px;margin:6px 0;">${escapeHtml(
        opts.signerName
      )}</div>`;
  return `
  <div class="sig-block">
    <div class="sig-label">Signed electronically</div>
    ${img}
    <div class="sig-meta"><b>${escapeHtml(opts.signerName)}</b><br/>${escapeHtml(
    opts.signedAtLabel
  )}</div>
  </div>`;
}

/**
 * Wrap rendered body HTML in a self-contained, print-ready page (inline CSS, no
 * external assets) so the stored artifact opens in any browser and prints to PDF.
 */
export function documentShell(opts: {
  title: string;
  bodyHtml: string;
  entityName?: string | null;
  reference?: string | null;
  watermark?: string | null;
}): string {
  const wm = opts.watermark
    ? `<div class="wm">${escapeHtml(opts.watermark)}</div>`
    : "";
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${escapeHtml(opts.title)}</title>
<style>
  :root { --ink:#1d2733; --muted:#5b6675; --line:#d9dee6; --brand:#0b3d6b; }
  * { box-sizing:border-box; }
  body { margin:0; background:#eef1f5; color:var(--ink);
    font:15px/1.6 "Segoe UI",-apple-system,Roboto,Helvetica,Arial,sans-serif; }
  .sheet { max-width:820px; margin:24px auto; background:#fff; padding:56px 64px;
    box-shadow:0 1px 4px rgba(20,30,45,.12); position:relative; }
  .doc-head { border-bottom:2px solid var(--brand); padding-bottom:14px; margin-bottom:26px;
    display:flex; justify-content:space-between; align-items:flex-end; gap:16px; }
  .doc-head .org { font-size:20px; font-weight:700; color:var(--brand); letter-spacing:.2px; }
  .doc-head .ref { font-size:12px; color:var(--muted); text-align:right; }
  h1 { font-size:20px; margin:0 0 18px; }
  h2 { font-size:16px; margin:22px 0 8px; }
  p { margin:0 0 12px; }
  table { width:100%; border-collapse:collapse; margin:12px 0; }
  td, th { border:1px solid var(--line); padding:7px 10px; text-align:left; font-size:14px; }
  .sig-block { margin-top:40px; padding-top:14px; border-top:1px dashed var(--line); }
  .sig-label { font-size:11px; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); }
  .sig-meta { font-size:13px; color:var(--muted); margin-top:4px; }
  .wm { position:absolute; top:46%; left:0; right:0; text-align:center; font-size:78px;
    color:rgba(11,61,107,.06); font-weight:800; transform:rotate(-18deg); pointer-events:none;
    letter-spacing:6px; }
  @media print { body { background:#fff; } .sheet { box-shadow:none; margin:0; padding:32px 40px; } }
</style></head>
<body><div class="sheet">${wm}
  <div class="doc-head">
    <div class="org">${escapeHtml(opts.entityName || "Transworld Investment & Securities Limited")}</div>
    <div class="ref">${opts.reference ? escapeHtml(opts.reference) + "<br/>" : ""}${escapeHtml(
    opts.title
  )}</div>
  </div>
  ${opts.bodyHtml}
</div></body></html>`;
}

// ---------------------------------------------------------------------------
// Reads
// ---------------------------------------------------------------------------
export async function getTemplates() {
  return prisma.documentTemplate.findMany({
    orderBy: [{ isActive: "desc" }, { kind: "asc" }, { name: "asc" }],
  });
}

export async function getTemplate(id: string) {
  return prisma.documentTemplate.findUnique({ where: { id } });
}

/** Active templates only, for the "Generate" pickers. */
export async function getActiveTemplates() {
  return prisma.documentTemplate.findMany({
    where: { isActive: true },
    orderBy: [{ kind: "asc" }, { name: "asc" }],
  });
}

// ---------------------------------------------------------------------------
// Default templates (seeded by prisma/document-templates-populate.ts)
// ---------------------------------------------------------------------------
export const DEFAULT_TEMPLATES: {
  key: string;
  name: string;
  kind: TemplateKind;
  requiresSignature: boolean;
  bodyHtml: string;
}[] = [
  {
    key: "offer-letter-standard",
    name: "Offer letter (standard)",
    kind: "OFFER_LETTER",
    requiresSignature: true,
    bodyHtml: `<h1>Letter of Offer</h1>
<p>{{today}}</p>
<p>Dear {{preferred_name}},</p>
<p>Following your interview with us, we are pleased to offer you the position of
<b>{{job_title}}</b> in the {{department}} department at {{entity}}.</p>
<p>Your appointment is on a {{employment_type}} basis, with an intended start date of
<b>{{start_date}}</b>. Your monthly gross remuneration will be <b>₦{{gross_monthly}}</b>,
made up of a basic salary of ₦{{basic_salary}} and a utility allowance of ₦{{utility_allowance}},
together with a quarterly allowance of ₦{{quarterly_allowance}} paid separately, and subject to
statutory deductions.</p>
<p>This offer is conditional on satisfactory references, guarantor confirmation, and proof of
identity. Please indicate your acceptance by signing below.</p>
<p>We look forward to welcoming you to the team.</p>
<p>Yours sincerely,<br/>For and on behalf of {{entity}}</p>`,
  },
  {
    key: "employment-contract-standard",
    name: "Employment contract (standard)",
    kind: "EMPLOYMENT_CONTRACT",
    requiresSignature: true,
    bodyHtml: `<h1>Contract of Employment</h1>
<p>This Contract of Employment is made on {{today}} between {{entity}} ("the Company") and
<b>{{full_name}}</b> ("the Employee").</p>
<h2>1. Position</h2>
<p>The Employee is engaged as <b>{{job_title}}</b> in the {{department}} department, reporting to
{{manager_name}}, on a {{employment_type}} basis commencing {{start_date}}.</p>
<h2>2. Remuneration</h2>
<p>The Employee's monthly gross salary is ₦{{gross_monthly}} (basic ₦{{basic_salary}};
utility allowance ₦{{utility_allowance}}), with a quarterly allowance of ₦{{quarterly_allowance}}
paid separately, subject to PAYE and statutory deductions.</p>
<h2>3. Hours, leave and conduct</h2>
<p>The Employee shall observe the Company's policies, the staff handbook, and all regulatory
obligations applicable to a SEC-licensed investment firm, including AML/KYC requirements.</p>
<h2>4. Confidentiality</h2>
<p>The Employee shall keep confidential all proprietary and client information during and after
employment.</p>
<p>The parties agree to the terms above.</p>`,
  },
  {
    key: "guarantor-form-standard",
    name: "Guarantor form (standard)",
    kind: "GUARANTOR_FORM",
    requiresSignature: true,
    bodyHtml: `<h1>Guarantor's Undertaking</h1>
<p>In respect of the employment of <b>{{full_name}}</b> ({{ee_id}}) as {{job_title}} at {{entity}},
the undersigned agrees to act as Guarantor.</p>
<table>
  <tr><th>Guarantor's full name</th><td>&nbsp;</td></tr>
  <tr><th>Relationship to employee</th><td>&nbsp;</td></tr>
  <tr><th>Occupation / employer</th><td>&nbsp;</td></tr>
  <tr><th>Residential address</th><td>&nbsp;</td></tr>
  <tr><th>Phone &amp; email</th><td>&nbsp;</td></tr>
  <tr><th>Means of identification</th><td>&nbsp;</td></tr>
</table>
<p>I confirm that I know the above-named employee and undertake to be responsible for their good
conduct in the course of their employment, to the extent permitted by law.</p>`,
  },
  {
    key: "next-of-kin-standard",
    name: "Next-of-kin form (standard)",
    kind: "NEXT_OF_KIN",
    requiresSignature: true,
    bodyHtml: `<h1>Next-of-Kin Details</h1>
<p>Employee: <b>{{full_name}}</b> ({{ee_id}}) &middot; {{job_title}}, {{department}}</p>
<table>
  <tr><th>Next-of-kin full name</th><td>&nbsp;</td></tr>
  <tr><th>Relationship</th><td>&nbsp;</td></tr>
  <tr><th>Phone</th><td>&nbsp;</td></tr>
  <tr><th>Email</th><td>&nbsp;</td></tr>
  <tr><th>Residential address</th><td>&nbsp;</td></tr>
  <tr><th>Alternate contact</th><td>&nbsp;</td></tr>
</table>
<p>I confirm the above details are correct and may be used by {{entity}} in case of emergency.</p>`,
  },
];
