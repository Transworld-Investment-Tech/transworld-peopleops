// GET /payroll/[cycleId]/export — streams the control sheet as .xlsx.
// Gated (payroll.view), audited. Available once the cycle is APPROVED or LOCKED.
import { NextRequest, NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { writeAudit } from "@/lib/auth/audit";
import { buildControlSheetBuffer } from "@/lib/payroll-export";

export async function GET(_req: NextRequest, ctx: { params: Promise<{ cycleId: string }> }) {
  const me = await getCurrentUser();
  if (!me) return NextResponse.redirect(new URL("/login", _req.url));
  if (!me.permissions.has("payroll.view")) return NextResponse.redirect(new URL("/access-denied", _req.url));

  const { cycleId } = await ctx.params;
  const cycle = await prisma.payCycle.findUnique({ where: { id: cycleId }, select: { status: true, label: true } });
  if (!cycle) return new NextResponse("Not found", { status: 404 });
  if (cycle.status !== "APPROVED" && cycle.status !== "LOCKED")
    return new NextResponse("The control sheet is available once the cycle is approved.", { status: 409 });

  const built = await buildControlSheetBuffer(cycleId);
  if (!built) return new NextResponse("Not found", { status: 404 });

  await writeAudit({ actorId: me.id, action: "paycycle.export", entityType: "pay_cycle", entityId: cycleId, metadata: { label: cycle.label } });

  return new NextResponse(new Uint8Array(built.buffer), {
    status: 200,
    headers: {
      "Content-Type": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "Content-Disposition": `attachment; filename="${built.filename}"`,
      "Cache-Control": "no-store",
    },
  });
}
