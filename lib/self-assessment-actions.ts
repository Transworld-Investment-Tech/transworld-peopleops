"use server";
// Self-service self-assessment (v0.38.0). Hands the SELF side of the year-end
// appraisal to the employee, gated `performance.self` and SELF-SCOPED to the
// signed-in user's own appraisal. Writes only the self fields + self summary;
// on submit it locks (self_status = SUBMITTED). The manager side
// (saveReviewAction, performance.manage) is untouched. Mirrors the existing
// self payload shape so the data model is identical.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = { ok: boolean; error?: string; message?: string };

const RATINGS = new Set(["EXCEEDS", "MEETS", "BELOW", "NA"]);

function nz(v: unknown): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}
function ratingOrNull(v: unknown): string | null {
  const s = String(v ?? "").trim();
  return RATINGS.has(s) ? s : null;
}
function levelOrNull(v: unknown): number | null {
  if (v === null || v === undefined || v === "") return null;
  const n = Number(v);
  return Number.isInteger(n) && n >= 1 && n <= 5 ? n : null;
}

type SelfRow = { id?: string; selfActual?: string; selfRating?: string; selfLevel?: string; selfNote?: string };

function readItems(fd: FormData): SelfRow[] {
  try {
    const raw = JSON.parse(String(fd.get("items") ?? "[]"));
    return Array.isArray(raw) ? (raw as SelfRow[]) : [];
  } catch {
    return [];
  }
}

export async function saveMySelfAssessmentAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const appraisalId = String(fd.get("appraisalId") ?? "");
  const submit = String(fd.get("submit") ?? "") === "1";
  if (!appraisalId) return { ok: false, error: "Missing appraisal." };

  const mine = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true } });
  if (!mine) return { ok: false, error: "Your login isn’t linked to an employee record yet." };

  const appraisal = await prisma.appraisal.findUnique({
    where: { id: appraisalId },
    select: { id: true, employeeId: true, selfStatus: true, items: { select: { id: true } } },
  });
  if (!appraisal) return { ok: false, error: "Appraisal not found." };
  if (appraisal.employeeId !== mine.id) return { ok: false, error: "You can only complete your own self-assessment." };
  if (appraisal.selfStatus === "SUBMITTED") return { ok: false, error: "Your self-assessment is already submitted." };

  const allowed = new Set(appraisal.items.map((i) => i.id));
  const rows = readItems(fd).filter((r) => allowed.has(String(r.id ?? "")));

  await prisma.$transaction(async (tx) => {
    for (const r of rows) {
      await tx.appraisalItem.update({
        where: { id: String(r.id) },
        data: {
          selfActual: nz(r.selfActual),
          selfRating: ratingOrNull(r.selfRating),
          selfLevel: levelOrNull(r.selfLevel),
          selfNote: nz(r.selfNote),
        },
      });
    }
    await tx.appraisal.update({
      where: { id: appraisalId },
      data: {
        selfSummary: nz(fd.get("selfSummary")),
        ...(submit ? { selfStatus: "SUBMITTED", selfSubmittedAt: new Date() } : {}),
      },
    });
  });

  await writeAudit({
    actorId: me.id,
    action: submit ? "appraisal.self_submit" : "appraisal.self_save",
    entityType: "appraisal",
    entityId: appraisalId,
    metadata: { items: rows.length, self: true },
  });

  revalidatePath("/my-performance");
  return { ok: true, message: submit ? "Your self-assessment has been submitted." : "Your self-assessment has been saved." };
}
