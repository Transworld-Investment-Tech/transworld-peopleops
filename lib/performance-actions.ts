"use server";
// Write-side server actions for Performance & Development. Gated by
// performance.manage, validated with zod, audited. Mirrors the conventions of
// the other module actions (scorecards/jobframework/employees).
//
// Two-sided flow:
//  - startAppraisalAction seeds an appraisal's items from the employee's role
//    (published scorecard outcomes -> OUTCOME rows; required competencies ->
//    COMPETENCY rows). Idempotent: re-opening an existing appraisal just returns it.
//  - saveSelfAction writes the SELF side of each item (+ self summary); on submit
//    it locks the self-assessment (self_status = SUBMITTED).
//  - saveReviewAction writes the MANAGER side (+ targets, manager summary,
//    development plan, overall rating); on finalize it sets manager_status =
//    SUBMITTED and stamps the reviewer.
//
// NOTE (v1): both sides are recorded by a performance.manage holder, because staff
// logins are not yet provisioned (employee.userId is unlinked). The data model is
// already two-sided, so when logins arrive the self side can be handed to the
// employee behind a future performance.self permission with no schema change.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { getScorecard } from "@/lib/scorecards";
import { getJobProfileDetail } from "@/lib/jobframework";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const STAGES = ["GOAL_SETTING", "MID_CYCLE", "SELF_ASSESSMENT", "MANAGER_REVIEW", "REWARDS"] as const;
const STATUSES = ["OPEN", "CLOSED"] as const;
const RATING_VALUES = ["EXCEEDS", "MEETS", "BELOW", "NA"] as const;

function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function parseDate(v?: string | null): Date | null {
  const s = (v ?? "").trim();
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
function ratingOrNull(v: unknown): string | null {
  const s = String(v ?? "").trim();
  return (RATING_VALUES as readonly string[]).includes(s) ? s : null;
}
function levelOrNull(v: unknown): number | null {
  if (v === null || v === undefined || v === "") return null;
  const n = Number(v);
  if (!Number.isInteger(n) || n < 1 || n > 5) return null;
  return n;
}
function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Cycles
// ---------------------------------------------------------------------------
const cycleSchema = z.object({
  name: z.string().trim().min(2, "Give the cycle a name (e.g. Q2 2026)"),
  stage: z.enum(STAGES),
});

export async function createCycleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const parsed = cycleSchema.safeParse({
    name: String(fd.get("name") ?? ""),
    stage: String(fd.get("stage") ?? "GOAL_SETTING"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };

  const cycle = await prisma.appraisalCycle.create({
    data: {
      name: parsed.data.name,
      stage: parsed.data.stage,
      status: "OPEN",
      periodStart: parseDate(String(fd.get("periodStart") ?? "")),
      periodEnd: parseDate(String(fd.get("periodEnd") ?? "")),
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "appraisalcycle.create",
    entityType: "appraisal_cycle",
    entityId: cycle.id,
    metadata: { name: cycle.name, stage: cycle.stage },
  });

  revalidatePath("/performance");
  redirect(`/performance?cycle=${cycle.id}`);
}

export async function updateCycleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const cycleId = String(fd.get("cycleId") ?? "");
  if (!cycleId) return { ok: false, error: "Missing cycle." };

  const stage = String(fd.get("stage") ?? "");
  const status = String(fd.get("status") ?? "");
  if (!(STAGES as readonly string[]).includes(stage)) return { ok: false, error: "Invalid stage." };
  if (!(STATUSES as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  await prisma.appraisalCycle.update({
    where: { id: cycleId },
    data: { stage, status },
  });

  await writeAudit({
    actorId: me.id,
    action: "appraisalcycle.update",
    entityType: "appraisal_cycle",
    entityId: cycleId,
    metadata: { stage, status },
  });

  revalidatePath("/performance");
  redirect(`/performance?cycle=${cycleId}`);
}

// ---------------------------------------------------------------------------
// Start (seed) an appraisal from the role
// ---------------------------------------------------------------------------
export async function startAppraisalAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const cycleId = String(fd.get("cycleId") ?? "");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!cycleId || !employeeId) return { ok: false, error: "Missing cycle or employee." };

  const [cycle, employee] = await Promise.all([
    prisma.appraisalCycle.findUnique({ where: { id: cycleId }, select: { id: true } }),
    prisma.employee.findUnique({
      where: { id: employeeId },
      select: { id: true, jobProfileId: true, fullName: true },
    }),
  ]);
  if (!cycle) return { ok: false, error: "Cycle not found." };
  if (!employee) return { ok: false, error: "Employee not found." };
  if (!employee.jobProfileId) return { ok: false, error: "Employee has no job profile to appraise against." };

  // Idempotent: if an appraisal already exists, just go to it.
  const existing = await prisma.appraisal.findFirst({
    where: { cycleId, employeeId },
    select: { id: true },
  });
  if (!existing) {
    const [scorecard, detail] = await Promise.all([
      getScorecard(employee.jobProfileId),
      getJobProfileDetail(employee.jobProfileId),
    ]);
    if (!scorecard || scorecard.status !== "PUBLISHED") {
      return { ok: false, error: "This role has no published scorecard yet." };
    }

    await prisma.$transaction(async (tx) => {
      const appraisal = await tx.appraisal.create({
        data: {
          cycleId,
          employeeId,
          jobProfileId: employee.jobProfileId,
          scorecardId: scorecard.id,
        },
      });
      let pos = 0;
      for (const o of scorecard.outcomes) {
        await tx.appraisalItem.create({
          data: {
            appraisalId: appraisal.id,
            kind: "OUTCOME",
            position: pos++,
            label: o.title,
            measure: o.measure,
            weight: o.weight,
          },
        });
      }
      pos = 0;
      for (const c of detail?.competencies ?? []) {
        await tx.appraisalItem.create({
          data: {
            appraisalId: appraisal.id,
            kind: "COMPETENCY",
            position: pos++,
            label: c.name,
            measure: c.category,
            expectedLevel: c.level,
          },
        });
      }
    });

    await writeAudit({
      actorId: me.id,
      action: "appraisal.start",
      entityType: "appraisal",
      entityId: `${cycleId}:${employeeId}`,
      metadata: { employee: employee.fullName, outcomes: scorecard.outcomes.length },
    });
  }

  revalidatePath(`/performance/${cycleId}/${employeeId}`);
  revalidatePath("/performance");
  redirect(`/performance/${cycleId}/${employeeId}`);
}

// ---------------------------------------------------------------------------
// Self-assessment (employee side)
// ---------------------------------------------------------------------------
async function loadAppraisalForEdit(appraisalId: string) {
  return prisma.appraisal.findUnique({
    where: { id: appraisalId },
    select: {
      id: true,
      cycleId: true,
      employeeId: true,
      selfStatus: true,
      managerStatus: true,
      items: { select: { id: true } },
    },
  });
}

type ItemPayload = Record<string, unknown>;
function readItems(fd: FormData): ItemPayload[] {
  try {
    const arr = JSON.parse(String(fd.get("items") ?? "[]"));
    return Array.isArray(arr) ? (arr as ItemPayload[]) : [];
  } catch {
    return [];
  }
}

export async function saveSelfAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const appraisalId = String(fd.get("appraisalId") ?? "");
  const submit = String(fd.get("submit") ?? "") === "1";
  if (!appraisalId) return { ok: false, error: "Missing appraisal." };

  const appraisal = await loadAppraisalForEdit(appraisalId);
  if (!appraisal) return { ok: false, error: "Appraisal not found." };
  if (appraisal.selfStatus === "SUBMITTED")
    return { ok: false, error: "Self-assessment is already submitted." };

  const allowed = new Set(appraisal.items.map((i) => i.id));
  const items = readItems(fd).filter((r) => allowed.has(String(r.id ?? "")));

  await prisma.$transaction(async (tx) => {
    for (const r of items) {
      await tx.appraisalItem.update({
        where: { id: String(r.id) },
        data: {
          selfActual: nz(String(r.selfActual ?? "")),
          selfRating: ratingOrNull(r.selfRating),
          selfLevel: levelOrNull(r.selfLevel),
          selfNote: nz(String(r.selfNote ?? "")),
        },
      });
    }
    await tx.appraisal.update({
      where: { id: appraisalId },
      data: {
        selfSummary: nz(String(fd.get("selfSummary") ?? "")),
        ...(submit ? { selfStatus: "SUBMITTED", selfSubmittedAt: new Date() } : {}),
      },
    });
  });

  await writeAudit({
    actorId: me.id,
    action: submit ? "appraisal.self_submit" : "appraisal.self_save",
    entityType: "appraisal",
    entityId: appraisalId,
    metadata: { items: items.length },
  });

  revalidatePath(`/performance/${appraisal.cycleId}/${appraisal.employeeId}`);
  revalidatePath("/performance");
  redirect(`/performance/${appraisal.cycleId}/${appraisal.employeeId}`);
}

// ---------------------------------------------------------------------------
// Manager review (reviewer side)
// ---------------------------------------------------------------------------
export async function saveReviewAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const appraisalId = String(fd.get("appraisalId") ?? "");
  const submit = String(fd.get("submit") ?? "") === "1";
  if (!appraisalId) return { ok: false, error: "Missing appraisal." };

  const appraisal = await loadAppraisalForEdit(appraisalId);
  if (!appraisal) return { ok: false, error: "Appraisal not found." };

  const allowed = new Set(appraisal.items.map((i) => i.id));
  const items = readItems(fd).filter((r) => allowed.has(String(r.id ?? "")));

  await prisma.$transaction(async (tx) => {
    for (const r of items) {
      await tx.appraisalItem.update({
        where: { id: String(r.id) },
        data: {
          target: nz(String(r.target ?? "")),
          actual: nz(String(r.actual ?? "")),
          rating: ratingOrNull(r.rating),
          assessedLevel: levelOrNull(r.assessedLevel),
          managerNote: nz(String(r.managerNote ?? "")),
        },
      });
    }
    await tx.appraisal.update({
      where: { id: appraisalId },
      data: {
        managerSummary: nz(String(fd.get("managerSummary") ?? "")),
        developmentPlan: nz(String(fd.get("developmentPlan") ?? "")),
        overallRating: ratingOrNull(fd.get("overallRating")),
        ...(submit
          ? { managerStatus: "SUBMITTED", managerReviewedAt: new Date(), reviewerId: me.id }
          : {}),
      },
    });
  });

  await writeAudit({
    actorId: me.id,
    action: submit ? "appraisal.finalize" : "appraisal.review_save",
    entityType: "appraisal",
    entityId: appraisalId,
    metadata: { items: items.length, overallRating: ratingOrNull(fd.get("overallRating")) },
  });

  revalidatePath(`/performance/${appraisal.cycleId}/${appraisal.employeeId}`);
  revalidatePath("/performance");
  redirect(`/performance/${appraisal.cycleId}/${appraisal.employeeId}`);
}
