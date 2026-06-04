// tools/gen-tutorial.ts — generate the written portal guide from lib/help.ts.
// Run: `npm run help:tutorial`  (tsx tools/gen-tutorial.ts)
//
// ONE source, organized BY WORKFLOW (not page-by-page): every help entry
// declares a `tutorialSection`; this groups them into chapters and writes a
// readable Markdown guide under docs/portal-guide/, in the same voice as
// How_to_Run_a_Payroll_Cycle.md (narrative, American English, Naira ₦).

import { HELP, type HelpEntry } from "../lib/help";
import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const OUT = join(process.cwd(), "docs", "portal-guide");

// Chapter order for the guide. Any chapter not listed is appended at the end.
const CHAPTER_ORDER = [
  "Getting started & finding your way",
  "Managing people",
  "The job & competency framework",
  "Leave",
  "Hiring (the ten-stage pipeline)",
  "Onboarding a joiner",
  "Staff files & the completeness drive",
  "Alerts",
  "The performance cycle",
  "Learning & development",
  "Compensation",
  "Bonus",
  "Running a payroll cycle",
  "Conduct & cases",
  "Your self-service",
  "Administration",
];

function fileSlug(s: string): string {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
}

function bySpecificity(a: HelpEntry, b: HelpEntry): number {
  const da = a.slug.split("/").length;
  const db = b.slug.split("/").length;
  if (da !== db) return da - db;
  return a.title.localeCompare(b.title);
}

function chapters(): { name: string; entries: HelpEntry[] }[] {
  const map = new Map<string, HelpEntry[]>();
  for (const e of Object.values(HELP)) {
    const list = map.get(e.tutorialSection) ?? [];
    list.push(e);
    map.set(e.tutorialSection, list);
  }
  const names = [
    ...CHAPTER_ORDER.filter((c) => map.has(c)),
    ...[...map.keys()].filter((c) => !CHAPTER_ORDER.includes(c)).sort(),
  ];
  return names.map((name) => ({ name, entries: (map.get(name) ?? []).sort(bySpecificity) }));
}

function entryMd(e: HelpEntry): string {
  const lines: string[] = [];
  lines.push(`### ${e.title}`);
  if (e.status === "coming_soon") lines.push(`> _Coming soon — reachable with permission; full interface in a later phase._\n`);
  lines.push("");
  lines.push(e.purpose);
  lines.push("");
  lines.push(`**Who can use this:** ${e.audience}`);
  lines.push("");
  if (e.actions.length > 0) {
    lines.push(`**What you can do here:**`);
    lines.push("");
    for (const a of e.actions) {
      const flags: string[] = [];
      if (a.separation) flags.push("_two people, on purpose_");
      if (a.immutable) flags.push("_permanent once done_");
      const tail = flags.length ? ` (${flags.join("; ")})` : "";
      lines.push(`- **${a.label}** — ${a.what}${tail}`);
    }
    lines.push("");
  }
  if (e.workflow) {
    lines.push(`**Where this sits:** ${e.workflow}`);
    lines.push("");
  }
  if (e.gotchas.length > 0) {
    lines.push(`**Good to know:**`);
    lines.push("");
    for (const g of e.gotchas) lines.push(`- ${g}`);
    lines.push("");
  }
  return lines.join("\n");
}

function chapterMd(name: string, entries: HelpEntry[]): string {
  const head = [
    `# ${name}`,
    `### Transworld PeopleOps Portal — a guide for the team`,
    ``,
    `This is part of the portal guide. It's written to be read alongside the app —`,
    `press the **?** on any page for the same help in a panel. The portal is a`,
    `**control room**: it records and checks pay, bonus and compliance evidence;`,
    `HumanManager and Remita still pay people. Figures shown in the portal are`,
    `provisional records in Naira (₦).`,
    ``,
    `---`,
    ``,
  ].join("\n");
  return head + entries.map(entryMd).join("\n---\n\n") + "\n";
}

function main() {
  mkdirSync(OUT, { recursive: true });
  const chs = chapters();

  const idx: string[] = [
    `# Transworld PeopleOps Portal — Team Guide`,
    ``,
    `Generated from the in-app help registry (\`lib/help.ts\`). Each chapter covers one`,
    `workflow. Press the **?** on any page in the portal for the same guidance, scoped`,
    `to what you can do on that page.`,
    ``,
    `## Chapters`,
    ``,
  ];

  let pages = 0;
  for (const ch of chs) {
    const fname = `${fileSlug(ch.name)}.md`;
    writeFileSync(join(OUT, fname), chapterMd(ch.name, ch.entries), "utf8");
    idx.push(`- [${ch.name}](./${fname}) — ${ch.entries.length} page${ch.entries.length === 1 ? "" : "s"}`);
    pages += ch.entries.length;
  }
  writeFileSync(join(OUT, "README.md"), idx.join("\n") + "\n", "utf8");

  // eslint-disable-next-line no-console
  console.log(`Wrote ${chs.length} chapters covering ${pages} pages to ${OUT}`);
}

main();
