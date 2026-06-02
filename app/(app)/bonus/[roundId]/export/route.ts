// GET /bonus/[roundId]/export — streams the bonus control sheet as .xlsx.
// Gated (bonus.view), audited. Available once the round is APPROVED or LOCKED.
import { NextRequest, NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth/rbac";
import { prisma } from "@/lib/db";
import { writeAudit } from "@/lib/auth/audit";
import { buildBonusSheetBuffer } from "@/lib/bonus-export";

export async function GET(_req: NextRequest, ctx: { params: Promise<{ roundId: string }> }) {
  const me = await getCurrentUser();
  if (!me) return NextResponse.redirect(new URL("/login", _req.url));
  if (!me.permissions.has("bonus.view")) return NextResponse.redirect(new URL("/access-denied", _req.url));

  const { roundId } = await ctx.params;
  const round = await prisma.bonusRound.findUnique({ where: { id: roundId }, select: { status: true, label: true } });
  if (!round) return new NextResponse("Not found", { status: 404 });
  if (round.status !== "APPROVED" && round.status !== "LOCKED")
    return new NextResponse("The control sheet is available once the round is approved.", { status: 409 });

  const built = await buildBonusSheetBuffer(roundId);
  if (!built) return new NextResponse("Not found", { status: 404 });

  await writeAudit({ actorId: me.id, action: "bonusround.export", entityType: "bonus_round", entityId: roundId, metadata: { label: round.label } });

  return new NextResponse(new Uint8Array(built.buffer), {
    status: 200,
    headers: {
      "Content-Type": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "Content-Disposition": `attachment; filename="${built.filename}"`,
      "Cache-Control": "no-store",
    },
  });
}
