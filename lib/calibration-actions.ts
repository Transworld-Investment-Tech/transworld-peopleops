"use server";
// Calibration (Ops Manual E4) write actions. People Ops records the COO-chaired
// session; all gated performance.manage. Opening a session generates the pack
// (one entry per employee whose year-end appraisal is manager-SUBMITTED),
// snapshotting the preliminary rating + indicative multiplier. On finalize, each
// agreed calibrated rating is written back to appraisals.overall_rating.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import { getAppraisalView } from "@/lib/performance";
import { personGrade, familyLabel } from "@/lib/jobframework";

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
function multOrNull(v: unknown): number | null {
  const s = String(v ?? "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) && n >= 0 ? n : null;
}
function parseDate(v: unknown): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}

export async function openCalibrationAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const cycleId = String(fd.get("cycleId") ?? "");
  if (!cycleId) return { ok: false, error: "Missing cycle." };
  const cycle = await prisma.appraisalCycle.findUnique({ where: { id: cycleId }, select: { id: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };

  // Session (one per cycle).
  let session = await prisma.calibrationSession.findUnique({ where: { cycleId } });
  if (!session) {
    session = await prisma.calibrationSession.create({
      data: { cycleId, status: "DRAFT", chairName: nz(fd.get("chairName")), heldAt: parseDate(fd.get("heldAt")) },
    });
  }

  // Pack: appraisals with a submitted manager review, not already an entry.
  const appraisals = await prisma.appraisal.findMany({
    where: { cycleId, managerStatus: "SUBMITTED" },
    select: { id: true, employeeId: true, overallRating: true },
  });
  const existing = await prisma.calibrationEntry.findMany({ where: { sessionId: session.id }, select: { employeeId: true } });
  const have = new Set(existing.map((e) => e.employeeId));

  let created = 0;
  for (const a of appraisals) {
    if (have.has(a.employeeId)) continue;
    const emp = await prisma.employee.findUnique({
      where: { id: a.employeeId },
      select: {
        fullName: true,
        grade: true,
        jobProfile: { select: { grade: true, family: true } },
        manager: { select: { fullName: true, preferredName: true } },
      },
    });
    if (!emp) continue;
    let indicative: number | null = null;
    try {
      const view = await getAppraisalView(cycleId, a.employeeId);
      indicative = view?.score ? view.score.multiplier : null;
    } catch {
      indicative = null;
    }
    await prisma.calibrationEntry.create({
      data: {
        sessionId: session.id,
        employeeId: a.employeeId,
        employeeName: emp.fullName,
        grade: personGrade(emp.grade, emp.jobProfile?.grade) ?? null,
        jobFamily: emp.jobProfile?.family ? familyLabel(emp.jobProfile.family) : null,
        managerName: emp.manager ? emp.manager.preferredName || emp.manager.fullName : null,
        appraisalId: a.id,
        preliminaryRating: a.overallRating,
        indicativeMultiplier: indicative,
      },
    });
    created += 1;
  }

  await writeAudit({ actorId: me.id, action: "calibration.open", entityType: "CalibrationSession", entityId: session.id, metadata: { created } });
  revalidatePath("/performance/calibration");
  return { ok: true, message: created ? `Pack generated — ${created} entr${created === 1 ? "y" : "ies"} added.` : "No new submitted appraisals to add." };
}

export async function recordCalibrationEntryAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const id = String(fd.get("id") ?? "");
  if (!id) return { ok: false, error: "Missing entry." };
  const entry = await prisma.calibrationEntry.findUnique({ where: { id }, select: { id: true, sessionId: true } });
  if (!entry) return { ok: false, error: "Entry not found." };

  await prisma.calibrationEntry.update({
    where: { id },
    data: {
      calibratedRating: ratingOrNull(fd.get("calibratedRating")),
      calibratedMultiplier: multOrNull(fd.get("calibratedMultiplier")),
      integrityGate: String(fd.get("integrityGate") ?? "") === "on",
      note: nz(fd.get("note")),
    },
  });
  await prisma.calibrationSession.update({ where: { id: entry.sessionId }, data: { status: "IN_SESSION" } });
  await writeAudit({ actorId: me.id, action: "calibration.record", entityType: "CalibrationEntry", entityId: id, metadata: {} });
  revalidatePath("/performance/calibration");
  return { ok: true };
}

export async function finalizeCalibrationAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.manage");
  const sessionId = String(fd.get("sessionId") ?? "");
  if (!sessionId) return { ok: false, error: "Missing session." };
  const session = await prisma.calibrationSession.findUnique({ where: { id: sessionId }, select: { id: true } });
  if (!session) return { ok: false, error: "Session not found." };

  const entries = await prisma.calibrationEntry.findMany({
    where: { sessionId },
    select: { id: true, appraisalId: true, calibratedRating: true },
  });

  await prisma.$transaction(async (tx) => {
    for (const e of entries) {
      if (e.appraisalId && e.calibratedRating) {
        await tx.appraisal.update({ where: { id: e.appraisalId }, data: { overallRating: e.calibratedRating } });
      }
    }
    await tx.calibrationSession.update({
      where: { id: sessionId },
      data: {
        status: "FINALIZED",
        finalizedById: me.id,
        finalizedByName: me.name,
        finalizedAt: new Date(),
        chairName: nz(fd.get("chairName")) ?? undefined,
      },
    });
  });

  await writeAudit({ actorId: me.id, action: "calibration.finalize", entityType: "CalibrationSession", entityId: sessionId, metadata: { written: entries.filter((e) => e.appraisalId && e.calibratedRating).length } });
  revalidatePath("/performance/calibration");
  revalidatePath("/performance");
  return { ok: true, message: "Calibration finalized — agreed ratings written to the appraisals." };
}
