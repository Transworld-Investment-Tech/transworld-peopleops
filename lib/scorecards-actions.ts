"use server";
// Write-side server actions for role scorecards. Gated by jobframework.manage,
// validated with zod, audited. Outcomes are small and order-significant, so a
// save replaces them wholesale inside a transaction (upsert scorecard → clear →
// recreate in order). Mirrors the conventions of the other module actions.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const STATUSES = ["DRAFT", "PUBLISHED"] as const;

const outcomeSchema = z.object({
  title: z.string().trim().min(2, "Each outcome needs a title"),
  measure: z.string().trim().optional().or(z.literal("")),
  weight: z.number().int().min(0).max(100).nullable(),
});

const scorecardSchema = z.object({
  mission: z.string().trim().optional().or(z.literal("")),
  status: z.enum(STATUSES),
  outcomes: z.array(outcomeSchema),
});

function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}

function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = issue.path.length >= 2 ? "outcomes" : String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

function readForm(fd: FormData) {
  let outcomes: { title: string; measure: string; weight: number | null }[] = [];
  try {
    const arr = JSON.parse(String(fd.get("outcomes") ?? "[]"));
    if (Array.isArray(arr)) {
      outcomes = arr
        .map((x: { title?: unknown; measure?: unknown; weight?: unknown }) => {
          const w = x.weight;
          const weight =
            w === null || w === undefined || w === "" ? null : Number(w);
          return {
            title: String(x.title ?? ""),
            measure: String(x.measure ?? ""),
            weight: Number.isNaN(weight as number) ? null : weight,
          };
        })
        // ignore fully-blank rows the editor may submit
        .filter((o) => o.title.trim() !== "" || o.measure.trim() !== "");
    }
  } catch {
    /* malformed payload → no outcomes; schema validates the rest */
  }
  return {
    mission: String(fd.get("mission") ?? ""),
    status: String(fd.get("status") ?? "DRAFT"),
    resultsWeight: String(fd.get("resultsWeight") ?? ""),
    competenciesWeight: String(fd.get("competenciesWeight") ?? ""),
    behaviorsWeight: String(fd.get("behaviorsWeight") ?? ""),
    outcomes,
  };
}

// Dimension weighting override (whole-number percents). Returns fractions, or
// null to use the family default. Enforces all-or-none, sum = 100%, and the
// canonical bands (Ops Manual B4.2): Results 40–60 / Competencies 20–30 /
// Behaviors 20–30.
function parseWeights(form: {
  resultsWeight: string;
  competenciesWeight: string;
  behaviorsWeight: string;
}):
  | { ok: true; weights: { results: number; competencies: number; behaviors: number } | null }
  | { ok: false; message: string } {
  const raw = [form.resultsWeight, form.competenciesWeight, form.behaviorsWeight].map((s) =>
    s.trim(),
  );
  if (raw.every((s) => s === "")) return { ok: true, weights: null };
  if (raw.some((s) => s === ""))
    return {
      ok: false,
      message: "Set all three weights, or leave all three blank to use the family default.",
    };
  const nums = raw.map((s) => Number(s));
  if (nums.some((n) => !Number.isInteger(n) || n < 0 || n > 100))
    return { ok: false, message: "Each weight must be a whole-number percent." };
  const [r, c, b] = nums;
  if (r + c + b !== 100)
    return { ok: false, message: `Weights must sum to 100% (currently ${r + c + b}%).` };
  if (r < 40 || r > 60) return { ok: false, message: "Results must be between 40% and 60%." };
  if (c < 20 || c > 30) return { ok: false, message: "Competencies must be between 20% and 30%." };
  if (b < 20 || b > 30) return { ok: false, message: "Behaviors must be between 20% and 30%." };
  return { ok: true, weights: { results: r / 100, competencies: c / 100, behaviors: b / 100 } };
}

export async function saveScorecardAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const jobProfileId = String(fd.get("jobProfileId") ?? "");
  if (!jobProfileId) return { ok: false, error: "Missing job profile." };

  const profile = await prisma.jobProfile.findUnique({
    where: { id: jobProfileId },
    select: { id: true, title: true },
  });
  if (!profile) return { ok: false, error: "Job profile not found." };

  const form = readForm(fd);
  const parsed = scorecardSchema.safeParse(form);
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const w = parseWeights(form);
  if (!w.ok) return { ok: false, fieldErrors: { weights: w.message } };
  const weights = w.weights;

  await prisma.$transaction(async (tx) => {
    const sc = await tx.scorecard.upsert({
      where: { jobProfileId },
      create: {
        jobProfileId,
        mission: nz(v.mission),
        status: v.status,
        resultsWeight: weights ? weights.results : null,
        competenciesWeight: weights ? weights.competencies : null,
        behaviorsWeight: weights ? weights.behaviors : null,
      },
      update: {
        mission: nz(v.mission),
        status: v.status,
        resultsWeight: weights ? weights.results : null,
        competenciesWeight: weights ? weights.competencies : null,
        behaviorsWeight: weights ? weights.behaviors : null,
      },
    });
    await tx.scorecardOutcome.deleteMany({ where: { scorecardId: sc.id } });
    let position = 0;
    for (const o of v.outcomes) {
      await tx.scorecardOutcome.create({
        data: {
          scorecardId: sc.id,
          position: position++,
          title: o.title.trim(),
          measure: nz(o.measure),
          weight: o.weight,
        },
      });
    }
  });

  await writeAudit({
    actorId: me.id,
    action: "scorecard.save",
    entityType: "job_profile",
    entityId: jobProfileId,
    metadata: { title: profile.title, status: v.status, outcomes: v.outcomes.length, weightsOverride: !!weights },
  });

  revalidatePath(`/job-competency/${jobProfileId}`);
  revalidatePath("/job-competency");
  redirect(`/job-competency/${jobProfileId}`);
}

export async function deleteScorecardAction(
  _prev: FormState,
  fd: FormData
): Promise<FormState> {
  const me = await requirePermission("jobframework.manage");
  const jobProfileId = String(fd.get("jobProfileId") ?? "");
  if (!jobProfileId) return { ok: false, error: "Missing job profile." };

  const sc = await prisma.scorecard.findUnique({
    where: { jobProfileId },
    select: { id: true },
  });
  if (sc) {
    await prisma.scorecard.delete({ where: { id: sc.id } }); // cascade clears outcomes
    await writeAudit({
      actorId: me.id,
      action: "scorecard.delete",
      entityType: "job_profile",
      entityId: jobProfileId,
      metadata: {},
    });
  }

  revalidatePath(`/job-competency/${jobProfileId}`);
  revalidatePath("/job-competency");
  redirect(`/job-competency/${jobProfileId}`);
}
