// Transworld PeopleOps — Document templates populate (idempotent, dry-run first).
//
// Seeds the four standard TISL templates the Document Templates screen uses:
//   • Offer letter        • Employment contract
//   • Guarantor form      • Next-of-kin form
//
// SAFETY (mirrors prisma/jobframework-populate.ts):
//   • DEFAULT = DRY RUN. Prints the plan and writes NOTHING.
//   • Add `--commit` to apply. Idempotent on `key`: existing templates are left
//     as-is (so your edits in the UI are never overwritten); only missing ones
//     are created. NON-DESTRUCTIVE — never deletes or deactivates anything.
//   • Never touches compensation or .env.
//
// USAGE (run from the repo root):
//   npx tsx prisma/document-templates-populate.ts                # dry run
//   npx tsx prisma/document-templates-populate.ts -- --commit    # apply

import { readFileSync } from "node:fs";

// Load DATABASE_URL from .env before the Prisma client is constructed.
if (!process.env.DATABASE_URL) {
  try {
    for (const line of readFileSync(".env", "utf8").split("\n")) {
      const m = line.match(/^\s*DATABASE_URL\s*=\s*(.*)\s*$/);
      if (m) {
        let v = m[1].trim();
        if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'")))
          v = v.slice(1, -1);
        process.env.DATABASE_URL = v;
        break;
      }
    }
  } catch {
    /* .env optional if DATABASE_URL already set */
  }
}

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
const COMMIT = process.argv.includes("--commit");

type Seed = { key: string; name: string; kind: string; requiresSignature: boolean; bodyHtml: string };

const TEMPLATES: Seed[] = [
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
<b>{{start_date}}</b>. Your monthly gross remuneration will be <b>&#8358;{{gross_monthly}}</b>,
made up of a basic salary of &#8358;{{basic_salary}} and a utility allowance of &#8358;{{utility_allowance}},
together with a quarterly allowance of &#8358;{{quarterly_allowance}} paid separately, and subject to
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
<p>The Employee's monthly gross salary is &#8358;{{gross_monthly}} (basic &#8358;{{basic_salary}};
utility allowance &#8358;{{utility_allowance}}), with a quarterly allowance of &#8358;{{quarterly_allowance}}
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

function cuid(): string {
  // Lightweight collision-resistant id (templates created here are few).
  return "tmpl" + Date.now().toString(36) + Math.random().toString(36).slice(2, 10);
}

async function main() {
  console.log(`\nDocument templates populate — ${COMMIT ? "COMMIT (writing)" : "DRY RUN (no writes)"}\n`);
  let created = 0;
  let skipped = 0;

  for (const t of TEMPLATES) {
    const existing = await prisma.documentTemplate.findUnique({ where: { key: t.key } });
    if (existing) {
      console.log(`  • skip   ${t.key.padEnd(32)} (already exists)`);
      skipped += 1;
      continue;
    }
    console.log(`  + create ${t.key.padEnd(32)} ${t.name}`);
    created += 1;
    if (COMMIT) {
      const row = await prisma.documentTemplate.create({
        data: {
          id: cuid(),
          key: t.key,
          name: t.name,
          kind: t.kind,
          bodyHtml: t.bodyHtml,
          requiresSignature: t.requiresSignature,
          isActive: true,
        },
      });
      await prisma.auditLog.create({
        data: {
          actorId: null,
          action: "doctemplate.seed",
          entityType: "document_template",
          entityId: row.id,
          metadata: { key: t.key, kind: t.kind } as never,
        },
      });
    }
  }

  console.log(`\n  ${created} to create, ${skipped} already present.`);
  if (!COMMIT && created > 0) {
    console.log("  Re-run with `-- --commit` to apply.\n");
  } else if (COMMIT) {
    console.log("  Done.\n");
  } else {
    console.log("  Nothing to do.\n");
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
