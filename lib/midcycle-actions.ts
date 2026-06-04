"use server";
// Mid-cycle review (July check-in) write actions. Opening reviews + recording the
// four-bucket manager review are gated by performance.team OR performance.manage
// (line managers run it; People Ops administers). The employee's self-reflection
// is self-scoped under performance.self. Not rated — free-text only.
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requireUser, requirePermission, type CurrentUser } from "@/lib/auth/rbac";
import { redirect } from "next/navigation";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = { ok: boolean; error?: string; message?: string };

function nz(v: unknown): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}

async function requireManagerOrPeopleOps(): Promise<CurrentUser> {
  const me = await requireUser();
  if (!me.permissions.has("performance.team") && !me.permissions.has("performance.manage")) {
    redirect("/access-denied");
  }
  return me;
}

export async function openMidCycleReviewsAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireManagerOrPeopleOps();
  const cycleId = String(fd.get("cycleId") ?? "");
  if (!cycleId) return { ok: false, error: "Missing cycle." };
  const cycle = await prisma.appraisalCycle.findUnique({ where: { id: cycleId }, select: { id: true } });
  if (!cycle) return { ok: false, error: "Cycle not found." };

  const employees = await prisma.employee.findMany({
    where: { status: { in: ["ACTIVE", "PROBATION"] } },
    select: { id: true, fullName: true },
  });
  const existing = await prisma.midCycleReview.findMany({ where: { cycleId }, select: { employeeId: true } });
  const have = new Set(existing.map((r) => r.employeeId));
  const toCreate = employees.filter((e) => !have.has(e.id));

  if (toCreate.length) {
    await prisma.midCycleReview.createMany({
      data: toCreate.map((e) => ({ cycleId, employeeId: e.id, employeeName: e.fullName })),
    });
  }
  await writeAudit({ actorId: me.id, action: "midcycle.open", entityType: "AppraisalCycle", entityId: cycleId, metadata: { created: toCreate.length } });
  revalidatePath("/performance/mid-cycle");
  return { ok: true, message: toCreate.length ? `Opened ${toCreate.length} mid-cycle review(s).` : "All active staff already have a mid-cycle review for this cycle." };
}

export async function submitMyMidCycleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("performance.self");
  const id = String(fd.get("id") ?? "");
  const submit = String(fd.get("submit") ?? "") === "1";
  if (!id) return { ok: false, error: "Missing review." };
  const mine = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true } });
  if (!mine) return { ok: false, error: "Your login isn’t linked to an employee record yet." };
  const review = await prisma.midCycleReview.findUnique({ where: { id }, select: { id: true, employeeId: true, selfStatus: true } });
  if (!review || review.employeeId !== mine.id) return { ok: false, error: "You can only update your own mid-cycle reflection." };
  if (review.selfStatus === "SUBMITTED") return { ok: false, error: "Your reflection is already submitted." };

  await prisma.midCycleReview.update({
    where: { id },
    data: {
      selfSummary: nz(fd.get("selfSummary")),
      ...(submit ? { selfStatus: "SUBMITTED", selfSubmittedAt: new Date() } : {}),
    },
  });
  await writeAudit({ actorId: me.id, action: submit ? "midcycle.self_submit" : "midcycle.self_save", entityType: "MidCycleReview", entityId: id, metadata: {} });
  revalidatePath("/my-performance");
  return { ok: true, message: submit ? "Your mid-cycle reflection has been submitted." : "Saved." };
}

export async function recordMidCycleReviewAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requireManagerOrPeopleOps();
  const id = String(fd.get("id") ?? "");
  const complete = String(fd.get("complete") ?? "") === "1";
  if (!id) return { ok: false, error: "Missing review." };
  const review = await prisma.midCycleReview.findUnique({ where: { id }, select: { id: true } });
  if (!review) return { ok: false, error: "Review not found." };

  await prisma.midCycleReview.update({
    where: { id },
    data: {
      goalsNote: nz(fd.get("goalsNote")),
      behaviorNote: nz(fd.get("behaviorNote")),
      skillsNote: nz(fd.get("skillsNote")),
      developmentNote: nz(fd.get("developmentNote")),
      managerSummary: nz(fd.get("managerSummary")),
      reviewerId: me.id,
      reviewerName: me.name,
      ...(complete ? { managerStatus: "SUBMITTED", managerReviewedAt: new Date(), status: "COMPLETED" } : {}),
    },
  });
  await writeAudit({ actorId: me.id, action: complete ? "midcycle.complete" : "midcycle.review_save", entityType: "MidCycleReview", entityId: id, metadata: {} });
  revalidatePath("/performance/mid-cycle");
  return { ok: true, message: complete ? "Mid-cycle review completed." : "Saved." };
}
