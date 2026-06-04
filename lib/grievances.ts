// Grievance (E9) reads. Handler views are gated grievance.manage; the
// complainant sees only their own via getMyGrievances. The named respondent
// never has a read path to the record (confidentiality).
import { prisma } from "@/lib/db";

export async function getGrievances() {
  return prisma.grievance.findMany({
    orderBy: [{ closedAt: { sort: "asc", nulls: "first" } }, { createdAt: "desc" }],
  });
}
export type GrievanceRow = Awaited<ReturnType<typeof getGrievances>>[number];

export async function getGrievance(id: string) {
  return prisma.grievance.findUnique({ where: { id } });
}
export type GrievanceDetail = NonNullable<Awaited<ReturnType<typeof getGrievance>>>;

export async function getMyGrievances(complainantId: string) {
  return prisma.grievance.findMany({
    where: { complainantId },
    orderBy: { createdAt: "desc" },
  });
}

export async function getRespondentOptions(excludeEmployeeId?: string) {
  return prisma.employee.findMany({
    where: { status: { not: "EXITED" }, ...(excludeEmployeeId ? { id: { not: excludeEmployeeId } } : {}) },
    orderBy: { eeId: "asc" },
    select: { id: true, eeId: true, fullName: true },
  });
}
