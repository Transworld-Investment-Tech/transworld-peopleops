"use server";
// lib/lms-actions.ts — WS7 LMS write actions (v0.42.0).
// Every action is gated, zod-validated, audited, and transactional where it
// touches more than one row. Correct quiz answers are graded SERVER-SIDE here and
// never sent to the client. Auto-assignment is dry-run → commit (never silent).
//
// Permission model:
//   learning.manage     — module compliance metadata + quiz authoring + evidence/waiver.
//   learning.assign     — the assignment matrix + mandatory auto-assignment.
//   learning.view       — take a knowledge-check (self-scoped; manage holders may
//                         act on behalf where staff logins aren't yet provisioned).
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { requireUser, requirePermission, hasPermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  gradeQuiz,
  currentPeriodFor,
  requiredSetFor,
  LMS_DOMAINS,
  LMS_LEVELS,
  LMS_CADENCES,
  LMS_OWNERS,
  QUESTION_TYPES,
  type AssignmentRule,
  type QuizQuestion,
} from "@/lib/lms";

export type FormState = { ok: boolean; error?: string; fieldErrors?: Record<string, string> };
export type PreviewRow = { employeeId: string; eeId: string; name: string; moduleId: string; moduleCode: string | null; moduleTitle: string; period: string };
export type AssignState = { ok: boolean; error?: string; mode?: "preview" | "commit"; preview?: PreviewRow[]; committed?: number };
export type CheckState = { ok: boolean; error?: string; score?: number; passed?: boolean };

// ── helpers ──────────────────────────────────────────────────────────────────
function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function asBool(v: FormDataEntryValue | null): boolean {
  const s = String(v ?? "");
  return s === "1" || s === "true" || s === "on";
}
function intOrNull(v?: string | null): number | null {
  const s = (v ?? "").replace(/[,\s]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? Math.round(n) : null;
}
function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}
function cuid(): string {
  return "c" + Date.now().toString(36) + Math.random().toString(36).slice(2, 10);
}
const domainVals = LMS_DOMAINS.map((d) => d.value) as [string, ...string[]];
const levelVals = LMS_LEVELS.map((d) => d.value) as [string, ...string[]];
const cadenceVals = LMS_CADENCES.map((d) => d.value) as [string, ...string[]];
const ownerVals = LMS_OWNERS.map((d) => d.value) as [string, ...string[]];
const typeVals = QUESTION_TYPES.map((d) => d.value) as [string, ...string[]];

// ===========================================================================
// Module compliance metadata (catalogue fields + pass mark)
// ===========================================================================
const metaSchema = z.object({
  code: z.string().trim().max(20).nullable(),
  domain: z.enum(domainVals).nullable(),
  level: z.enum(levelVals).nullable(),
  owner: z.enum(ownerVals).nullable(),
  isMandatory: z.boolean(),
  cadence: z.enum(cadenceVals).nullable(),
  passMark: z.number().int().min(0).max(100).nullable(),
  status: z.enum(["DRAFT", "PUBLISHED", "ARCHIVED"]),
});

export async function saveModuleMetaAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const moduleId = nz(String(fd.get("moduleId") ?? ""));
  if (!moduleId) return { ok: false, error: "Missing module." };

  const parsed = metaSchema.safeParse({
    code: nz(String(fd.get("code") ?? "")),
    domain: nz(String(fd.get("domain") ?? "")),
    level: nz(String(fd.get("level") ?? "")),
    owner: nz(String(fd.get("owner") ?? "")),
    isMandatory: asBool(fd.get("isMandatory")),
    cadence: nz(String(fd.get("cadence") ?? "")),
    passMark: intOrNull(String(fd.get("passMark") ?? "")),
    status: String(fd.get("status") ?? "DRAFT"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  if (v.isMandatory && !v.cadence) {
    return { ok: false, fieldErrors: { cadence: "A mandatory module needs a cadence." } };
  }
  if (v.code) {
    const clash = await prisma.learningModule.findFirst({
      where: { code: v.code, id: { not: moduleId } },
      select: { id: true },
    });
    if (clash) return { ok: false, fieldErrors: { code: "That module code is already in use." } };
  }

  await prisma.learningModule.update({
    where: { id: moduleId },
    data: {
      code: v.code, domain: v.domain, level: v.level, owner: v.owner,
      isMandatory: v.isMandatory, cadence: v.cadence, passMark: v.passMark, status: v.status,
    },
  });
  await writeAudit({
    actorId: me.id, action: "learningmodule.meta", entityType: "learning_module", entityId: moduleId,
    metadata: { code: v.code, domain: v.domain, mandatory: v.isMandatory, cadence: v.cadence, passMark: v.passMark, status: v.status },
  });
  revalidatePath(`/learning/modules/${moduleId}/manage`);
  revalidatePath("/learning/compliance");
  return { ok: true };
}

// ===========================================================================
// Assignment matrix
// ===========================================================================
const ruleSchema = z
  .object({
    moduleId: z.string().trim().min(1, "Pick a module"),
    scope: z.enum(["ALL", "GRADE", "JOB_PROFILE"]),
    grade: z.enum(["G0", "G1", "G2", "G3", "G4", "G5", "PT"]).nullable(),
    jobProfileId: z.string().trim().nullable(),
    requirement: z.enum(["REQUIRED", "RECOMMENDED"]),
  })
  .refine((d) => d.scope !== "GRADE" || !!d.grade, { path: ["grade"], message: "Choose a grade" })
  .refine((d) => d.scope !== "JOB_PROFILE" || !!d.jobProfileId, { path: ["jobProfileId"], message: "Choose a role" });

export async function saveRuleAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.assign");
  const ruleId = nz(String(fd.get("ruleId") ?? ""));
  const scope = String(fd.get("scope") ?? "ALL");
  const parsed = ruleSchema.safeParse({
    moduleId: String(fd.get("moduleId") ?? ""),
    scope,
    grade: scope === "GRADE" ? nz(String(fd.get("grade") ?? "")) : null,
    jobProfileId: scope === "JOB_PROFILE" ? nz(String(fd.get("jobProfileId") ?? "")) : null,
    requirement: String(fd.get("requirement") ?? "REQUIRED"),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const mod = await prisma.learningModule.findUnique({ where: { id: v.moduleId }, select: { id: true } });
  if (!mod) return { ok: false, error: "Module not found." };

  // de-dupe on (module, scope, grade, jobProfile)
  const dupe = await prisma.learningAssignmentRule.findFirst({
    where: {
      moduleId: v.moduleId, scope: v.scope, grade: v.grade ?? null, jobProfileId: v.jobProfileId ?? null,
      ...(ruleId ? { id: { not: ruleId } } : {}),
    },
    select: { id: true },
  });
  if (dupe) return { ok: false, error: "A rule for that target already exists." };

  if (ruleId) {
    await prisma.learningAssignmentRule.update({
      where: { id: ruleId },
      data: { moduleId: v.moduleId, scope: v.scope, grade: v.grade, jobProfileId: v.jobProfileId, requirement: v.requirement },
    });
  } else {
    await prisma.learningAssignmentRule.create({
      data: { id: cuid(), moduleId: v.moduleId, scope: v.scope, grade: v.grade, jobProfileId: v.jobProfileId, requirement: v.requirement, createdById: me.id },
    });
  }
  await writeAudit({
    actorId: me.id, action: ruleId ? "learningrule.update" : "learningrule.create",
    entityType: "learning_assignment_rule", entityId: ruleId ?? v.moduleId,
    metadata: { moduleId: v.moduleId, scope: v.scope, grade: v.grade, requirement: v.requirement },
  });
  revalidatePath("/learning/matrix");
  return { ok: true };
}

export async function deleteRuleAction(fd: FormData): Promise<void> {
  const me = await requirePermission("learning.assign");
  const ruleId = nz(String(fd.get("ruleId") ?? ""));
  if (!ruleId) return;
  await prisma.learningAssignmentRule.delete({ where: { id: ruleId } });
  await writeAudit({ actorId: me.id, action: "learningrule.delete", entityType: "learning_assignment_rule", entityId: ruleId });
  revalidatePath("/learning/matrix");
}

// ===========================================================================
// Mandatory auto-assignment — dry-run (preview) → commit
// ===========================================================================
async function computeAutoAssign(asOf: Date): Promise<PreviewRow[]> {
  const rules = await prisma.learningAssignmentRule.findMany({ where: { active: true } });
  const ruleObjs: AssignmentRule[] = rules.map((r) => ({
    moduleId: r.moduleId, scope: r.scope, grade: r.grade, jobProfileId: r.jobProfileId, requirement: r.requirement, active: r.active,
  }));
  const [employees, modules] = await Promise.all([
    prisma.employee.findMany({
      where: { status: { not: "EXITED" } },
      select: { id: true, eeId: true, fullName: true, preferredName: true, grade: true, jobProfileId: true, jobProfile: { select: { grade: true } } },
    }),
    prisma.learningModule.findMany({
      where: { status: "PUBLISHED", isMandatory: true },
      select: { id: true, code: true, title: true, cadence: true },
    }),
  ]);
  const mandatoryById = new Map(modules.map((m) => [m.id, m]));

  // existing records keyed by employee+module+period to avoid duplicates
  const existing = await prisma.learningRecord.findMany({
    where: { moduleId: { in: modules.map((m) => m.id) } },
    select: { employeeId: true, moduleId: true, period: true },
  });
  const has = new Set(existing.map((r) => `${r.employeeId}::${r.moduleId}::${r.period}`));

  const out: PreviewRow[] = [];
  for (const e of employees) {
    const grade = e.grade ?? e.jobProfile?.grade ?? null;
    const { required } = requiredSetFor(grade, e.jobProfileId, ruleObjs);
    for (const mid of required) {
      const mod = mandatoryById.get(mid);
      if (!mod) continue; // recommended-only or non-mandatory modules are not auto-assigned
      const period = currentPeriodFor(mod.cadence, asOf);
      if (has.has(`${e.id}::${mid}::${period}`)) continue;
      out.push({
        employeeId: e.id, eeId: e.eeId,
        name: (e.preferredName || e.fullName || `EID ${e.eeId}`).trim(),
        moduleId: mid, moduleCode: mod.code, moduleTitle: mod.title, period,
      });
    }
  }
  out.sort((a, b) => a.eeId.localeCompare(b.eeId) || (a.moduleCode ?? "").localeCompare(b.moduleCode ?? ""));
  return out;
}

export async function autoAssignAction(_prev: AssignState, fd: FormData): Promise<AssignState> {
  const me = await requirePermission("learning.assign");
  const mode = String(fd.get("mode") ?? "preview") === "commit" ? "commit" : "preview";
  const asOf = new Date();
  const rows = await computeAutoAssign(asOf);

  if (mode === "preview") {
    return { ok: true, mode: "preview", preview: rows };
  }

  // commit
  if (rows.length === 0) return { ok: true, mode: "commit", committed: 0 };
  const ruleByModule = new Map<string, string>();
  const rules = await prisma.learningAssignmentRule.findMany({
    where: { active: true, requirement: "REQUIRED" },
    select: { id: true, moduleId: true },
  });
  for (const r of rules) if (!ruleByModule.has(r.moduleId)) ruleByModule.set(r.moduleId, r.id);

  let committed = 0;
  await prisma.$transaction(async (tx) => {
    for (const r of rows) {
      await tx.learningRecord.create({
        data: {
          id: cuid(),
          moduleId: r.moduleId,
          employeeId: r.employeeId,
          period: r.period,
          source: "MANDATORY",
          status: "ASSIGNED",
          ruleId: ruleByModule.get(r.moduleId) ?? null,
        },
      });
      committed += 1;
    }
  });
  await writeAudit({
    actorId: me.id, action: "learning.autoassign.commit", entityType: "learning_record",
    metadata: { committed, period: rows[0]?.period ?? null },
  });
  revalidatePath("/learning/matrix");
  revalidatePath("/learning/compliance");
  return { ok: true, mode: "commit", committed };
}

// ===========================================================================
// Quiz authoring
// ===========================================================================
const optionSchema = z.object({ key: z.string().trim().min(1), text: z.string().trim().min(1) });
const questionSchema = z
  .object({
    moduleId: z.string().trim().min(1),
    prompt: z.string().trim().min(2, "Write the question"),
    type: z.enum(typeVals),
    options: z.array(optionSchema).min(2, "At least two options"),
    correct: z.array(z.string().trim().min(1)).min(1, "Mark the correct answer(s)"),
    explanation: z.string().trim().max(600).nullable(),
    sortOrder: z.number().int().min(0),
  })
  .refine((d) => d.type === "MULTI" || d.correct.length === 1, {
    path: ["correct"], message: "Single/true-false questions have exactly one correct answer.",
  })
  .refine((d) => d.correct.every((k) => d.options.some((o) => o.key === k)), {
    path: ["correct"], message: "Correct answer must be one of the options.",
  });

export async function saveQuestionAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const questionId = nz(String(fd.get("questionId") ?? ""));
  let options: unknown;
  let correct: unknown;
  try {
    options = JSON.parse(String(fd.get("options") ?? "[]"));
    correct = JSON.parse(String(fd.get("correct") ?? "[]"));
  } catch {
    return { ok: false, error: "Could not read the options/answers." };
  }
  const parsed = questionSchema.safeParse({
    moduleId: String(fd.get("moduleId") ?? ""),
    prompt: String(fd.get("prompt") ?? ""),
    type: String(fd.get("type") ?? "SINGLE"),
    options,
    correct,
    explanation: nz(String(fd.get("explanation") ?? "")),
    sortOrder: intOrNull(String(fd.get("sortOrder") ?? "0")) ?? 0,
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  if (questionId) {
    await prisma.learningQuizQuestion.update({
      where: { id: questionId },
      data: { prompt: v.prompt, type: v.type, options: v.options, correct: v.correct, explanation: v.explanation, sortOrder: v.sortOrder },
    });
  } else {
    await prisma.learningQuizQuestion.create({
      data: { id: cuid(), moduleId: v.moduleId, prompt: v.prompt, type: v.type, options: v.options, correct: v.correct, explanation: v.explanation, sortOrder: v.sortOrder },
    });
  }
  await writeAudit({
    actorId: me.id, action: questionId ? "learningquestion.update" : "learningquestion.create",
    entityType: "learning_quiz_question", entityId: questionId ?? v.moduleId,
    metadata: { moduleId: v.moduleId, type: v.type },
  });
  revalidatePath(`/learning/modules/${v.moduleId}/manage`);
  return { ok: true };
}

export async function deleteQuestionAction(fd: FormData): Promise<void> {
  const me = await requirePermission("learning.manage");
  const questionId = nz(String(fd.get("questionId") ?? ""));
  if (!questionId) return;
  const q = await prisma.learningQuizQuestion.findUnique({ where: { id: questionId }, select: { moduleId: true } });
  if (!q) return;
  await prisma.learningQuizQuestion.delete({ where: { id: questionId } });
  await writeAudit({ actorId: me.id, action: "learningquestion.delete", entityType: "learning_quiz_question", entityId: questionId, metadata: { moduleId: q.moduleId } });
  revalidatePath(`/learning/modules/${q.moduleId}/manage`);
}

// ===========================================================================
// Take the knowledge-check — graded SERVER-SIDE
// ===========================================================================
export async function submitCheckAction(_prev: CheckState, fd: FormData): Promise<CheckState> {
  const me = await requireUser();
  const moduleId = nz(String(fd.get("moduleId") ?? ""));
  const onBehalfId = nz(String(fd.get("employeeId") ?? "")); // manage holders may submit for others
  if (!moduleId) return { ok: false, error: "Missing module." };

  let answers: Record<string, string[]>;
  try {
    const raw = JSON.parse(String(fd.get("answers") ?? "{}"));
    answers = {};
    for (const k of Object.keys(raw)) {
      const val = raw[k];
      answers[k] = Array.isArray(val) ? val.map((x) => String(x)) : [String(val)];
    }
  } catch {
    return { ok: false, error: "Could not read your answers." };
  }

  // resolve the subject employee (self by default; on-behalf needs learning.manage)
  let employeeId: string | null = null;
  if (onBehalfId) {
    if (!hasPermission(me, "learning.manage")) return { ok: false, error: "Not allowed to submit for another person." };
    employeeId = onBehalfId;
  } else {
    const self = await prisma.employee.findUnique({ where: { userId: me.id }, select: { id: true } });
    employeeId = self?.id ?? null;
  }
  if (!employeeId) return { ok: false, error: "No employee record is linked to act on." };

  const [mod, questions] = await Promise.all([
    prisma.learningModule.findUnique({ where: { id: moduleId }, select: { id: true, cadence: true, passMark: true } }),
    prisma.learningQuizQuestion.findMany({ where: { moduleId, active: true }, select: { id: true, type: true, options: true, correct: true } }),
  ]);
  if (!mod) return { ok: false, error: "Module not found." };
  if (questions.length === 0) return { ok: false, error: "This module has no knowledge-check." };

  const qForGrade: QuizQuestion[] = questions.map((q) => ({
    id: q.id, type: q.type,
    options: Array.isArray(q.options) ? (q.options as { key: string; text: string }[]) : [],
    correct: Array.isArray(q.correct) ? (q.correct as string[]).map((k) => String(k)) : [],
  }));
  const passMark = mod.passMark ?? 100;
  const result = gradeQuiz(qForGrade, answers, passMark);
  const period = currentPeriodFor(mod.cadence, new Date());
  const now = new Date();

  // TW-LMS-SUBMIT-GUARD-V0431 — a persistence failure must not 500 the check page.
  try {
    const existing = await prisma.learningRecord.findUnique({
      where: { moduleId_employeeId_period: { moduleId, employeeId, period } },
      select: { id: true, attemptCount: true, status: true },
    });

    if (existing) {
      await prisma.learningRecord.update({
        where: { id: existing.id },
        data: {
          score: result.score,
          passed: result.passed,
          attemptCount: { increment: 1 },
          lastAttemptAt: now,
          status: result.passed ? "COMPLETED" : existing.status === "ASSIGNED" ? "IN_PROGRESS" : existing.status,
          startedAt: existing.status === "ASSIGNED" ? now : undefined,
          completedAt: result.passed ? now : undefined,
        },
      });
    } else {
      await prisma.learningRecord.create({
        data: {
          id: cuid(), moduleId, employeeId, period,
          source: onBehalfId ? "MANDATORY" : "SELF",
          status: result.passed ? "COMPLETED" : "IN_PROGRESS",
          startedAt: now, completedAt: result.passed ? now : null,
          score: result.score, passed: result.passed, attemptCount: 1, lastAttemptAt: now,
        },
      });
    }
    await writeAudit({
      actorId: me.id, action: "learning.check.submit", entityType: "learning_record",
      metadata: { moduleId, employeeId, period, score: result.score, passed: result.passed },
    });
  } catch (e) {
    console.error("submitCheckAction: persistence failed", e);
    return {
      ok: false,
      error: "Your answers were graded, but saving the result failed. Please try again — if it keeps happening, contact People-Ops.",
    };
  }
  revalidatePath(`/learning/modules/${moduleId}/check`);
  revalidatePath("/learning/compliance");
  return { ok: true, score: result.score, passed: result.passed };
}

// ===========================================================================
// Evidence / attestation + waiver (People-Ops, on a record)
// ===========================================================================
export async function recordEvidenceAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const recordId = nz(String(fd.get("recordId") ?? ""));
  const note = nz(String(fd.get("evidenceNote") ?? ""));
  const docId = nz(String(fd.get("evidenceDocId") ?? ""));
  const markComplete = asBool(fd.get("markComplete"));
  if (!recordId) return { ok: false, error: "Missing record." };
  if (!note && !docId) return { ok: false, error: "Add an evidence note or attach a document." };
  const now = new Date();
  await prisma.learningRecord.update({
    where: { id: recordId },
    data: {
      evidenceNote: note, evidenceDocId: docId, attestedById: me.id, attestedAt: now,
      ...(markComplete ? { status: "COMPLETED", completedAt: now, passed: true } : {}),
    },
  });
  await writeAudit({ actorId: me.id, action: "learning.evidence", entityType: "learning_record", entityId: recordId, metadata: { markComplete } });
  revalidatePath("/learning/compliance");
  return { ok: true };
}

export async function waiveRecordAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("learning.manage");
  const recordId = nz(String(fd.get("recordId") ?? ""));
  const reason = nz(String(fd.get("waivedReason") ?? ""));
  if (!recordId) return { ok: false, error: "Missing record." };
  if (!reason) return { ok: false, fieldErrors: { waivedReason: "A waiver needs a reason." } };
  await prisma.learningRecord.update({
    where: { id: recordId },
    data: { status: "WAIVED", waivedById: me.id, waivedReason: reason, waivedAt: new Date() },
  });
  await writeAudit({ actorId: me.id, action: "learning.waive", entityType: "learning_record", entityId: recordId, metadata: { reason } });
  revalidatePath("/learning/compliance");
  return { ok: true };
}
