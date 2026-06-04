// lib/help.test.ts — the coverage guard for the help registry.
// Run: `npm run help:test`  (tsx lib/help.test.ts)
//
// This is the mechanical backstop behind the definition-of-done rule:
// "a release that adds or changes a page MUST add/update its lib/help.ts entry
// in the same release." It fails loudly when a nav slug (or any declared route
// in DEEP_ROUTES) has no entry, or when an entry points at a slug/permission
// that no longer exists.

import assert from "node:assert";
import {
  HELP,
  DEEP_ROUTES,
  NAV_SLUGS,
  PERMISSION_KEYS,
  SECTION_ORDER,
  resolveSlugFromPath,
  visibleActions,
  helpIndexBySection,
} from "./help";

let pass = 0;
function t(name: string, fn: () => void) {
  fn();
  pass += 1;
  // eslint-disable-next-line no-console
  console.log("ok -", name);
}

const keys = Object.keys(HELP);
const expected = new Set<string>([...NAV_SLUGS, ...DEEP_ROUTES]);
const sections = new Set<string>(SECTION_ORDER as readonly string[]);

t("every nav slug has a help entry (hard coverage gate)", () => {
  const missing = NAV_SLUGS.filter((s) => !(s in HELP));
  assert.deepEqual(missing, [], `nav slugs without a help entry: ${missing.join(", ")}`);
});

t("every declared route (nav + deep) has a help entry (full coverage)", () => {
  const missing = [...expected].filter((s) => !(s in HELP));
  assert.deepEqual(missing, [], `declared routes without a help entry: ${missing.join(", ")}`);
});

t("no orphan/stale entries (every entry is a nav slug or in DEEP_ROUTES)", () => {
  const orphans = keys.filter((k) => !expected.has(k));
  assert.deepEqual(orphans, [], `entries whose slug is neither a nav slug nor in DEEP_ROUTES: ${orphans.join(", ")}`);
});

t("entry.slug matches its key", () => {
  for (const k of keys) assert.equal(HELP[k].slug, k, `key/slug mismatch at ${k}`);
});

t("no duplicate slugs in DEEP_ROUTES", () => {
  assert.equal(new Set(DEEP_ROUTES).size, DEEP_ROUTES.length, "DEEP_ROUTES has duplicates");
});

t("every viewPerm is a real permission key or null", () => {
  for (const k of keys) {
    const p = HELP[k].viewPerm;
    assert.ok(p === null || PERMISSION_KEYS.has(p), `unknown viewPerm "${p}" at ${k}`);
  }
});

t("every action.perm is a real permission key or null", () => {
  for (const k of keys) {
    for (const a of HELP[k].actions) {
      assert.ok(a.perm === null || PERMISSION_KEYS.has(a.perm), `unknown action perm "${a.perm}" at ${k} (${a.label})`);
    }
  }
});

t("every related slug resolves to a real entry", () => {
  for (const k of keys) {
    for (const r of HELP[k].related) {
      assert.ok(r in HELP, `${k} relates to unknown slug "${r}"`);
    }
  }
});

t("every navSlug is a real nav slug or '' (off-nav)", () => {
  const navSet = new Set(NAV_SLUGS);
  for (const k of keys) {
    const ns = HELP[k].navSlug;
    assert.ok(ns === "" || navSet.has(ns), `unknown navSlug "${ns}" at ${k}`);
  }
});

t("every section is a known section", () => {
  for (const k of keys) assert.ok(sections.has(HELP[k].section), `unknown section "${HELP[k].section}" at ${k}`);
});

t("coming_soon entries are only the governance placeholders", () => {
  const cs = keys.filter((k) => HELP[k].status === "coming_soon").sort();
  assert.deepEqual(cs, ["controls", "evidence"], `unexpected coming_soon set: ${cs.join(", ")}`);
});

t("every entry has real prose (purpose, audience, tutorialSection)", () => {
  for (const k of keys) {
    const e = HELP[k];
    assert.ok(e.purpose.trim().length > 40, `purpose too thin at ${k}`);
    assert.ok(e.audience.trim().length > 0, `missing audience at ${k}`);
    assert.ok(e.title.trim().length > 0, `missing title at ${k}`);
    assert.ok(e.tutorialSection.trim().length > 0, `missing tutorialSection at ${k}`);
  }
});

t("resolveSlugFromPath: exact, dynamic, and parent-fallback", () => {
  assert.equal(resolveSlugFromPath("/dashboard"), "dashboard");
  assert.equal(resolveSlugFromPath("/payroll/clx9abc"), "payroll/[cycleId]");
  assert.equal(resolveSlugFromPath("/compensation/raises/clx1"), "compensation/raises/[cycleId]");
  assert.equal(resolveSlugFromPath("/performance/cyc1/emp2"), "performance/[cycleId]/[employeeId]");
  assert.equal(resolveSlugFromPath("/employees/clx/edit"), "employees/[id]/edit");
  assert.equal(resolveSlugFromPath("/grievances/raise"), "grievances/raise");
  // unknown deep route under a known parent → parent entry (never blank)
  assert.equal(resolveSlugFromPath("/compensation/clxEmp/unknown-tab"), "compensation/[employeeId]");
});

t("visibleActions filters by permission; null perms always show", () => {
  const payroll = HELP["payroll/[cycleId]"];
  const finance = new Set<string>(["payroll.view", "payroll.manage"]);
  const labels = visibleActions(payroll, finance).map((a) => a.label);
  assert.ok(labels.includes("Adjust a row"));
  assert.ok(!labels.includes("Approve")); // needs payroll.approve
  const allNull = HELP["account/password"];
  assert.equal(visibleActions(allNull, new Set()).length, allNull.actions.length);
});

t("helpIndexBySection mirrors view permissions and section order", () => {
  const employee = new Set<string>([
    "dashboard.view", "documents.view_own", "performance.self", "leave.view",
    "learning.view", "payslips.view_own", "bonus.view_own", "grievance.raise", "whistleblower.report",
  ]);
  const idx = helpIndexBySection(employee);
  const secs = idx.map((g) => g.section);
  // employee should not see Payroll Control's admin pages but should see self-service ones
  assert.ok(secs.includes("Overview"));
  assert.ok(secs.includes("People"));
  // sections appear in SECTION_ORDER order
  const order = (SECTION_ORDER as readonly string[]).filter((s) => secs.includes(s));
  assert.deepEqual(secs, order);
  // an employee cannot see the Employees directory (needs employees.view)
  const people = idx.find((g) => g.section === "People");
  assert.ok(people && !people.entries.some((e) => e.slug === "employees"));
});

// eslint-disable-next-line no-console
console.log(`\n${pass} checks passed — help registry covers ${keys.length} routes.`);
