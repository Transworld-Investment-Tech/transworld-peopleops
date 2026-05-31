// Read-side helpers for role scorecards. Writes live in lib/scorecards-actions.ts.
import { prisma } from "@/lib/db";

export function scorecardStatusBadge(status: string): { cls: string; label: string } {
  return status === "PUBLISHED"
    ? { cls: "b-grn", label: "Published" }
    : { cls: "b-amb", label: "Draft" };
}

export const SCORECARD_STATUSES: { value: string; label: string }[] = [
  { value: "DRAFT", label: "Draft" },
  { value: "PUBLISHED", label: "Published" },
];

export type ScorecardOutcomeView = {
  id: string;
  title: string;
  measure: string | null;
  weight: number | null;
};

export type ScorecardView = {
  id: string;
  mission: string | null;
  status: string;
  outcomes: ScorecardOutcomeView[];
};

/** The scorecard for a job profile (with ordered outcomes), or null. */
export async function getScorecard(jobProfileId: string): Promise<ScorecardView | null> {
  const sc = await prisma.scorecard.findUnique({
    where: { jobProfileId },
    include: { outcomes: { orderBy: [{ position: "asc" }, { createdAt: "asc" }] } },
  });
  if (!sc) return null;
  return {
    id: sc.id,
    mission: sc.mission,
    status: sc.status,
    outcomes: sc.outcomes.map((o) => ({
      id: o.id,
      title: o.title,
      measure: o.measure,
      weight: o.weight,
    })),
  };
}

/** Everything the scorecard editor needs: the profile title + existing scorecard. */
export async function getScorecardEditData(jobProfileId: string): Promise<{
  profile: { id: string; title: string } | null;
  scorecard: ScorecardView | null;
}> {
  const profile = await prisma.jobProfile.findUnique({
    where: { id: jobProfileId },
    select: { id: true, title: true },
  });
  if (!profile) return { profile: null, scorecard: null };
  return { profile, scorecard: await getScorecard(jobProfileId) };
}
