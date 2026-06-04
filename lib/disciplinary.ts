// Disciplinary (E8) reads. Gating is enforced in the pages/actions.
import { prisma } from "@/lib/db";

export async function getDisciplinaryCases() {
  return prisma.disciplinaryCase.findMany({
    orderBy: [{ closedAt: { sort: "asc", nulls: "first" } }, { openedAt: "desc" }],
    include: { actions: { orderBy: { issuedAt: "desc" } } },
  });
}
export type DisciplinaryCaseRow = Awaited<ReturnType<typeof getDisciplinaryCases>>[number];

export async function getDisciplinaryCase(id: string) {
  return prisma.disciplinaryCase.findUnique({
    where: { id },
    include: { actions: { orderBy: { issuedAt: "asc" } } },
  });
}
export type DisciplinaryCaseDetail = NonNullable<Awaited<ReturnType<typeof getDisciplinaryCase>>>;

export async function getActiveEmployeeOptions() {
  return prisma.employee.findMany({
    where: { status: { not: "EXITED" } },
    orderBy: { eeId: "asc" },
    select: { id: true, eeId: true, fullName: true },
  });
}
