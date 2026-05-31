// Transworld PeopleOps — Learning & Development populate (idempotent, dry-run first).
//
// Seeds a starter library of ~15 training modules (authored markdown, tagged to the
// competency catalog) so the module ships useful rather than empty.
//
// SAFETY (mirrors prisma/jobframework-populate.ts):
//   • DEFAULT = DRY RUN. Prints the full plan and writes NOTHING.
//   • Add `--commit` to apply. Re-running converges to the same state (idempotent).
//   • NON-DESTRUCTIVE: only creates. It never edits a module you have changed in the
//     UI and never deletes anything — for an existing module it only ensures the
//     listed competency tags are present.
//   • Every write is recorded in audit_logs. Never touches payroll, compensation, or .env.
//
// USAGE (from the repo root):
//   npx tsx prisma/learning-populate.ts                # dry run (review)
//   npx tsx prisma/learning-populate.ts -- --commit    # apply
//   (or:  npm run learning:populate -- --commit )

import { readFileSync } from "node:fs";

// Load DATABASE_URL from .env before the Prisma client is constructed.
if (!process.env.DATABASE_URL) {
  try {
    for (const line of readFileSync(".env", "utf8").split("\n")) {
      const m = line.match(/^\s*DATABASE_URL\s*=\s*(.*)\s*$/);
      if (m) {
        let v = m[1].trim();
        if (
          (v.startsWith('"') && v.endsWith('"')) ||
          (v.startsWith("'") && v.endsWith("'"))
        )
          v = v.slice(1, -1);
        process.env.DATABASE_URL = v;
        break;
      }
    }
  } catch {
    /* .env optional if DATABASE_URL already set */
  }
}

const COMMIT = process.argv.includes("--commit");

// ---------------------------------------------------------------------------
// The starter library. Each module is published, tagged to competency names
// from the catalog (jobframework-populate.ts). Tags that don't resolve to a
// competency are skipped with a warning.
// ---------------------------------------------------------------------------
export type SeedModule = {
  title: string;
  category: string;
  summary: string;
  estimatedMinutes: number;
  competencies: string[];
  body: string;
};

const COMPLIANCE = "Compliance & Regulatory";
const TECHNICAL = "Technical & Functional";
const LEADERSHIP = "Leadership & Professional";

export const MODULES: SeedModule[] = [
  {
    title: "AML / KYC Fundamentals",
    category: COMPLIANCE,
    summary: "Why anti-money-laundering rules exist and how KYC protects the firm.",
    estimatedMinutes: 30,
    competencies: ["AML / CFT & KYC", "Client onboarding & KYC", "Regulatory reporting"],
    body: `## Why this matters

Money laundering moves the proceeds of crime through legitimate businesses. As a SEC-regulated capital market operator, Transworld is a gatekeeper: we must know who our clients are and refuse business that doesn't add up.

## Know Your Customer (KYC)

- Verify identity with valid documents before opening an account.
- Understand the source of funds and the purpose of the relationship.
- Risk-rate each client and apply enhanced due diligence to higher-risk ones (e.g. PEPs).

## Red flags

- Reluctance to provide identification or source-of-funds detail.
- Transactions with no clear economic rationale.
- Sudden, unexplained changes in activity.

## Your duty

If something looks wrong, escalate to the Compliance Officer. Never "tip off" a client that a report may be filed. When in doubt, ask — a delayed transaction is far cheaper than a regulatory breach.`,
  },
  {
    title: "Market Conduct & SEC Rules (Nigeria)",
    category: COMPLIANCE,
    summary: "The conduct standards every capital-market operator is held to.",
    estimatedMinutes: 35,
    competencies: ["SEC & NGX regulations", "Regulatory reporting", "Risk management"],
    body: `## The rulebook

We operate under the Investments and Securities Act, SEC Rules and Regulations, and NGX rules. These set out who may deal, how, and what must be reported.

## Core conduct standards

- **Fair dealing** — treat clients honestly and put their interests first.
- **Best execution** — seek the best available terms for client orders.
- **Record-keeping** — keep complete, accurate records of orders and advice.
- **Timely reporting** — returns to the SEC and NGX must be accurate and on time.

## Consequences

Breaches can mean fines, suspension, or loss of licence — for the firm and the individual. Conduct is everyone's responsibility, not just Compliance's.`,
  },
  {
    title: "Insider Dealing & Conflicts of Interest",
    category: COMPLIANCE,
    summary: "Recognising material non-public information and managing conflicts.",
    estimatedMinutes: 25,
    competencies: ["SEC & NGX regulations", "Corporate governance", "Internal controls & audit"],
    body: `## Insider dealing

Trading on material, non-public information (MNPI) — or passing it to someone who trades — is a criminal offence. Information is "material" if a reasonable investor would consider it important to a decision to buy or sell.

## Practical rules

- Never trade a security while holding MNPI about it.
- Don't share MNPI outside the need-to-know circle.
- Personal trades may require pre-clearance — check the policy.

## Conflicts of interest

A conflict arises when personal interest could improperly influence a decision. Disclose it, and let it be managed — don't decide alone whether it "matters".`,
  },
  {
    title: "Data Protection (NDPA) Basics",
    category: COMPLIANCE,
    summary: "Handling personal data lawfully under Nigeria's data-protection regime.",
    estimatedMinutes: 25,
    competencies: ["Data protection (NDPR)", "IT systems & security"],
    body: `## Personal data

Any information about an identifiable person — names, BVNs, account details, contact info — is personal data and must be protected.

## Principles

- Collect only what you need, for a clear purpose.
- Keep it accurate and secure.
- Don't keep it longer than necessary.
- Share it only with a lawful basis.

## Day to day

- Lock your screen; don't leave client files on your desk.
- Don't email personal data to personal accounts.
- Report any suspected breach immediately — the clock on notification starts fast.`,
  },
  {
    title: "Cybersecurity Awareness",
    category: COMPLIANCE,
    summary: "Spotting phishing, using strong credentials, and protecting client data.",
    estimatedMinutes: 20,
    competencies: ["IT systems & security", "Data protection (NDPR)"],
    body: `## You are the first line of defence

Most breaches start with a person, not a server. A moment's attention prevents most attacks.

## Phishing

- Check the sender address, not just the display name.
- Hover over links before clicking; be wary of urgency ("act now").
- Never enter your password on a page you reached from an email link.

## Good habits

- Use a unique, strong password and the password manager.
- Turn on multi-factor authentication.
- Lock your device when you step away.
- Report anything suspicious to IT — reporting a false alarm is always fine.`,
  },
  {
    title: "Investment Products & the Nigerian Capital Market",
    category: TECHNICAL,
    summary: "A grounding in the instruments we trade and the market structure.",
    estimatedMinutes: 40,
    competencies: ["Market analysis", "Investment advisory", "Equity research & valuation"],
    body: `## The market

The Nigerian Exchange (NGX) is where listed equities and many fixed-income instruments trade. The SEC regulates; the CSCS handles clearing and settlement.

## Core instruments

- **Equities** — ownership in listed companies; returns from price and dividends.
- **Bonds** — debt of governments or companies; returns from coupons.
- **Mutual funds** — pooled, professionally managed portfolios.
- **Treasury bills** — short-term government debt.

## Risk and return

Higher expected return comes with higher risk. Diversification spreads risk across holdings. Match each client's portfolio to their objectives and risk tolerance — never the other way round.`,
  },
  {
    title: "Trade Settlement & Reconciliation",
    category: TECHNICAL,
    summary: "From order to settled trade — and why reconciliation is non-negotiable.",
    estimatedMinutes: 35,
    competencies: ["Trade execution & settlement", "Treasury & reconciliation", "Operations management"],
    body: `## The trade lifecycle

1. **Order** — client instruction is captured and validated.
2. **Execution** — the order is filled on the exchange.
3. **Clearing** — obligations are confirmed via CSCS.
4. **Settlement** — cash and securities change hands (T+ cycle).

## Reconciliation

Every day, internal records must match the depository and the bank. Reconciliation catches errors, fraud, and fails before they grow.

- Investigate breaks immediately; don't carry them forward.
- Document the cause and the fix.
- Escalate anything you can't resolve same-day.

A clean reconciliation is the evidence that client assets are where they should be.`,
  },
  {
    title: "Financial Modeling in Excel",
    category: TECHNICAL,
    summary: "Building clear, auditable models for valuation and planning.",
    estimatedMinutes: 45,
    competencies: ["Equity research & valuation", "Financial accounting & reporting", "Budgeting & planning"],
    body: `## Build for the reader

A model nobody can follow is a liability. Separate inputs, calculations, and outputs. Colour-code inputs. One formula per row, copied across.

## Good practice

- No hard-coded numbers inside formulas — drive everything from an inputs sheet.
- Use clear labels and units.
- Add checks (totals that must reconcile, balances that must be zero).
- Document assumptions in plain language.

## Valuation basics

- **DCF** — value is the present value of future cash flows.
- **Multiples** — compare with similar listed companies.
Always sanity-check the answer: does it make business sense?`,
  },
  {
    title: "Client Onboarding & Suitability",
    category: TECHNICAL,
    summary: "Onboarding clients properly and recommending only what suits them.",
    estimatedMinutes: 30,
    competencies: ["Client onboarding & KYC", "Client relationship management", "Investment advisory"],
    body: `## Onboarding done right

Onboarding is where compliance and client experience meet. Collect KYC, agree the mandate, and set expectations clearly.

## Suitability

Before recommending anything, understand the client's:

- Objectives and time horizon.
- Risk tolerance and capacity for loss.
- Knowledge and experience.
- Financial situation.

## The rule

Recommend only what fits the client's profile, and record why it fits. Suitability protects the client and the firm. If a product doesn't suit, say so — even if the client asks for it.`,
  },
  {
    title: "Leadership Essentials for New Supervisors",
    category: LEADERSHIP,
    summary: "The shift from doing the work to leading the people who do it.",
    estimatedMinutes: 35,
    competencies: ["People management", "Strategic leadership"],
    body: `## A different job

As an individual contributor you were measured on your output. As a supervisor you're measured on your team's. Your job is to make others effective.

## First principles

- **Set clear expectations** — people can't hit targets they can't see.
- **Delegate** — give the work and the authority, then support.
- **Give feedback early** — small course-corrections beat big surprises.
- **Be consistent** — fairness builds trust faster than charisma.

## Common traps

Doing the work yourself "because it's faster", avoiding hard conversations, and treating everyone identically rather than equitably. Lead the people, and the work follows.`,
  },
  {
    title: "Professional Business Communication",
    category: LEADERSHIP,
    summary: "Writing and speaking clearly, especially with clients and regulators.",
    estimatedMinutes: 25,
    competencies: ["Client relationship management", "People management"],
    body: `## Clear beats clever

In our business, miscommunication is risk. Aim for messages that can be read once and understood.

## Writing

- Lead with the point, then the detail.
- Short sentences. One idea each.
- Spell out who does what, by when.
- Re-read before sending — especially anything client- or regulator-facing.

## Speaking and listening

- Confirm understanding ("so the action is…").
- Listen to understand, not to reply.
- Match the channel to the message — sensitive matters aren't for group chats.`,
  },
  {
    title: "Time Management & Productivity",
    category: LEADERSHIP,
    summary: "Prioritising the work that matters and protecting focus.",
    estimatedMinutes: 20,
    competencies: ["Operations management", "Process documentation"],
    body: `## Important vs urgent

Urgent shouts; important matters. Spend your best hours on important work before urgency floods in.

## A simple system

- Plan tomorrow before you leave today — pick the three things that matter most.
- Batch shallow work (email, admin) into set windows.
- Protect a focus block for deep work; silence notifications.
- Capture every commitment in one place so nothing relies on memory.

## Sustainable pace

Breaks aren't lost time — they restore the attention good work needs. Consistency beats heroics.`,
  },
  {
    title: "Customer Service Excellence",
    category: LEADERSHIP,
    summary: "Turning every client interaction into trust and retention.",
    estimatedMinutes: 25,
    competencies: ["Client relationship management", "Client onboarding & KYC"],
    body: `## Service is the product

Clients can get securities anywhere. They stay for how we treat them.

## The essentials

- **Respond promptly** — even "I'm on it, expect an update by 3pm" reassures.
- **Own the problem** — don't bounce the client between desks.
- **Be accurate** — never guess on money or compliance; check and come back.
- **Close the loop** — confirm the issue is resolved.

## Difficult moments

Acknowledge the feeling, focus on the fix, and keep your tone steady. A well-handled complaint can build more loyalty than a smooth transaction.`,
  },
  {
    title: "Giving & Receiving Feedback",
    category: LEADERSHIP,
    summary: "Making feedback specific, kind, and useful — both ways.",
    estimatedMinutes: 20,
    competencies: ["People management"],
    body: `## Feedback is a gift

Done well, feedback helps people grow. Done badly — or not at all — it festers.

## Giving it

- Be specific and timely: behaviour, impact, and what to do differently.
- Separate the person from the action.
- Balance honesty with respect; private for criticism, public for praise.

## Receiving it

- Listen fully before responding; don't defend reflexively.
- Ask for examples if it's vague.
- Thank the person — it took effort to tell you.
Treat every piece of feedback as data, not a verdict.`,
  },
  {
    title: "Ethics & Professional Integrity",
    category: LEADERSHIP,
    summary: "Doing the right thing when it's hard — the foundation of trust.",
    estimatedMinutes: 25,
    competencies: ["Corporate governance", "Internal controls & audit", "Risk management"],
    body: `## Why ethics, not just rules

Rules can't cover every situation. Integrity is what guides you when no one is watching and no rule applies exactly.

## A simple test

Before acting, ask:

- Is it legal and within policy?
- Would it withstand scrutiny if it were public?
- Is it fair to the client and the firm?

## Speaking up

If you see something wrong, raise it — through your manager, Compliance, or the whistleblowing channel. Silence makes small problems into scandals. The firm's reputation is built one honest decision at a time.`,
  },
];

function tag() {
  return COMMIT ? "APPLY " : "PLAN  ";
}

async function main() {
  const { prisma } = await import("@/lib/db");

  console.log("============================================================");
  console.log(" Transworld PeopleOps — Learning & Development populate");
  console.log(` Mode    : ${COMMIT ? "COMMIT (writing)" : "DRY RUN (no writes)"}`);
  console.log("============================================================");

  const admin =
    (process.env.ADMIN_EMAIL
      ? await prisma.user.findFirst({ where: { email: process.env.ADMIN_EMAIL } })
      : null) ?? (await prisma.user.findFirst({ orderBy: { createdAt: "asc" } }));
  const actorId: string | null = admin?.id ?? null;

  const audit = async (
    action: string,
    entityId: string | null,
    metadata: Record<string, unknown>
  ) => {
    if (!COMMIT) return;
    await prisma.auditLog.create({
      data: { actorId, action, entityType: "learning_module", entityId, metadata: metadata as never, ip: null },
    });
  };

  const summary = { created: 0, existing: 0, tagsAdded: 0, tagsMissing: 0 };

  for (const mod of MODULES) {
    const existing = await prisma.learningModule.findFirst({
      where: { title: { equals: mod.title, mode: "insensitive" } },
      select: { id: true },
    });

    let moduleId: string | null = existing?.id ?? null;
    if (existing) {
      summary.existing++;
    } else {
      console.log(`${tag()}module: CREATE "${mod.title}"  [${mod.category}]`);
      if (COMMIT) {
        const created = await prisma.learningModule.create({
          data: {
            title: mod.title,
            category: mod.category,
            summary: mod.summary,
            body: mod.body,
            estimatedMinutes: mod.estimatedMinutes,
            status: "PUBLISHED",
            createdById: actorId,
          },
          select: { id: true },
        });
        moduleId = created.id;
        await audit("learningmodule.create", moduleId, { title: mod.title, seeded: true });
      }
      summary.created++;
    }

    // Ensure competency tags (resolve by name; never remove existing tags).
    const tagsForLog: string[] = [];
    for (const name of mod.competencies) {
      const comp = await prisma.competency.findFirst({
        where: { name: { equals: name, mode: "insensitive" } },
        select: { id: true },
      });
      if (!comp) {
        console.log(`${tag()}  · competency not found, skipping tag: "${name}"`);
        summary.tagsMissing++;
        continue;
      }
      if (!moduleId) {
        // dry run, module not yet created
        tagsForLog.push(`${name} (after create)`);
        summary.tagsAdded++;
        continue;
      }
      const link = await prisma.learningModuleCompetency.findUnique({
        where: { moduleId_competencyId: { moduleId, competencyId: comp.id } },
        select: { moduleId: true },
      });
      if (!link) {
        tagsForLog.push(`+${name}`);
        if (COMMIT) {
          await prisma.learningModuleCompetency.create({
            data: { moduleId, competencyId: comp.id },
          });
        }
        summary.tagsAdded++;
      }
    }
    if (tagsForLog.length) {
      console.log(`${tag()}  tags: ${tagsForLog.join(", ")}`);
    }
  }

  console.log("------------------------------------------------------------");
  console.log(` Modules : +${summary.created} created · ${summary.existing} already existed`);
  console.log(` Tags    : +${summary.tagsAdded} added · ${summary.tagsMissing} skipped (competency not found)`);
  if (!COMMIT) {
    console.log(" DRY RUN — nothing was written. Re-run with --commit to apply.");
  } else {
    console.log(" COMMITTED. Open Learning & Development to see the library.");
  }
  console.log("------------------------------------------------------------");

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error("[learning:populate] failed:", e);
  process.exit(1);
});
