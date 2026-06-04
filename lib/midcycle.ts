// Mid-cycle review (the July check-in) reads. Manager/People-Ops surfaces are
// gated performance.view; the employee self surface is on My Performance.
import { prisma } from "@/lib/db";

export async function getOpenCycle() {
  return (
    (await prisma.appraisalCycle.findFirst({ where: { status: "OPEN" }, orderBy: { createdAt: "desc" } })) ??
    (await prisma.appraisalCycle.findFirst({ orderBy: { createdAt: "desc" } }))
  );
}

export async function getMidCycleReviews(cycleId: string) {
  return prisma.midCycleReview.findMany({
    where: { cycleId },
    orderBy: [{ status: "asc" }, { employeeName: "asc" }],
  });
}
export type MidCycleRow = Awaited<ReturnType<typeof getMidCycleReviews>>[number];

export async function getMyMidCycle(userId: string) {
  const employee = await prisma.employee.findUnique({ where: { userId }, select: { id: true } });
  if (!employee) return { linked: false as const, cycle: null, review: null };
  const cycle = await getOpenCycle();
  if (!cycle) return { linked: true as const, cycle: null, review: null };
  const review = await prisma.midCycleReview.findUnique({
    where: { cycleId_employeeId: { cycleId: cycle.id, employeeId: employee.id } },
  });
  return {
    linked: true as const,
    cycle: { id: cycle.id, name: cycle.name, stage: cycle.stage, status: cycle.status },
    review,
  };
}
