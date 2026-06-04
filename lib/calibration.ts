// Calibration reads. The calibration record is a confidential governance
// document (Ops Manual E4) — surfaced under performance.view (managers attend;
// People Ops + COO run it) and never shown to employees.
import { prisma } from "@/lib/db";

export async function getCalibration(cycleId: string) {
  const session = await prisma.calibrationSession.findUnique({ where: { cycleId } });
  const entries = session
    ? await prisma.calibrationEntry.findMany({ where: { sessionId: session.id }, orderBy: { employeeName: "asc" } })
    : [];
  return { session, entries };
}
export type CalibrationEntryRow = Awaited<ReturnType<typeof getCalibration>>["entries"][number];
