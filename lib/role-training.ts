// lib/role-training.ts — read layer for "Training for this role" (v0.43.1).
// Server-only (Prisma). Resolves the LMS assignment rules that target a job
// profile — plus the firm-wide mandatory set (scope ALL / REQUIRED) — into a
// display-ready shape for the Job & Competency detail page. Assignment rules
// carry a bare module_id (no Prisma relation, per WS7 convention), so this is
// two selects + a JS join rather than an include.
import { prisma } from "@/lib/db";

export type RoleTrainingItem = { code: string; title: string; domain: string | null };
export type RoleTraining = {
  firmwide: RoleTrainingItem[]; // ALL / REQUIRED — everyone completes these
  required: RoleTrainingItem[]; // JOB_PROFILE / REQUIRED — this role adds these
  recommended: RoleTrainingItem[]; // JOB_PROFILE / RECOMMENDED — grow-toward
};

const byCode = (a: RoleTrainingItem, b: RoleTrainingItem) => a.code.localeCompare(b.code);

export async function getRoleTraining(jobProfileId: string): Promise<RoleTraining> {
  const rules = await prisma.learningAssignmentRule.findMany({
    where: {
      active: true,
      OR: [
        { scope: "ALL", requirement: "REQUIRED" },
        { scope: "JOB_PROFILE", jobProfileId },
      ],
    },
    select: { moduleId: true, scope: true, requirement: true },
  });
  if (rules.length === 0) return { firmwide: [], required: [], recommended: [] };

  const ids = Array.from(new Set(rules.map((r) => r.moduleId)));
  const modules = await prisma.learningModule.findMany({
    where: { id: { in: ids } },
    select: { id: true, code: true, title: true, domain: true },
  });
  const mod = new Map(modules.map((m) => [m.id, m]));

  const firmwide: RoleTrainingItem[] = [];
  const required: RoleTrainingItem[] = [];
  const recommended: RoleTrainingItem[] = [];
  for (const rule of rules) {
    const m = mod.get(rule.moduleId);
    if (!m) continue;
    const item: RoleTrainingItem = { code: m.code ?? "—", title: m.title, domain: m.domain };
    if (rule.scope === "ALL") firmwide.push(item);
    else if (rule.requirement === "REQUIRED") required.push(item);
    else recommended.push(item);
  }
  firmwide.sort(byCode);
  required.sort(byCode);
  recommended.sort(byCode);
  return { firmwide, required, recommended };
}
