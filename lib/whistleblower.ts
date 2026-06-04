// Whistleblower reads. Restricted: only whistleblower.access holders reach this
// module at all, and reports flagged involvesSeniorManagement are visible ONLY
// to whistleblower.exec (the Chairman) — the CCO is excluded from those, per the
// Board policy's mandatory structural escalation.
import { prisma } from "@/lib/db";

export async function getWhistleblowerReports(canExec: boolean) {
  return prisma.whistleblowerReport.findMany({
    where: canExec ? {} : { involvesSeniorManagement: false },
    orderBy: [{ closedAt: { sort: "asc", nulls: "first" } }, { receivedAt: "desc" }],
  });
}
export type WhistleblowerRow = Awaited<ReturnType<typeof getWhistleblowerReports>>[number];

export async function getWhistleblowerReport(id: string) {
  return prisma.whistleblowerReport.findUnique({ where: { id } });
}
export type WhistleblowerDetail = NonNullable<Awaited<ReturnType<typeof getWhistleblowerReport>>>;

export async function nextWbCaseRef(): Promise<string> {
  const year = new Date().getFullYear();
  const prefix = `WB-${year}-`;
  const last = await prisma.whistleblowerReport.findFirst({
    where: { caseRef: { startsWith: prefix } },
    orderBy: { caseRef: "desc" },
    select: { caseRef: true },
  });
  const n = last ? parseInt(last.caseRef.slice(prefix.length), 10) + 1 : 1;
  return prefix + String(n).padStart(3, "0");
}
