"use server";
// Write-side server actions for the probation clock. Gated by onboarding.manage,
// validated, audited. Produces the D6.2 PROBATION_MIDPOINT / PROBATION_OUTCOME
// records (by tagging a staff document into the slot) and drives the
// PROBATION -> ACTIVE confirmation transition. A NON_CONFIRM outcome opens an
// offboarding case (exit_type NON_CONFIRMATION) and routes there.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";
import {
  MIDPOINT_OUTCOMES,
  FINAL_OUTCOMES,
  defaultOffboardingTasks,
} from "@/lib/ws4";

export type FormState = { ok: boolean; error?: string; fieldErrors?: Record<string, string> };

function nz(v: FormDataEntryValue | null): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}
function parseDateUTC(v: FormDataEntryValue | null): Date | null {
  const s = String(v ?? "").trim();
  if (!s) return null;
  const d = new Date(`${s}T00:00:00.000Z`);
  return Number.isNaN(d.getTime()) ? null : d;
}

// Tag an existing staff document into a D6.2 slot (scoped to the employee), so
// the probation record actually counts toward staff-file completeness.
async function classifyDoc(employeeId: string, docId: string | null, slot: string): Promise<string | null> {
  if (!docId) return null;
  const doc = await prisma.staffDocument.findFirst({
    where: { id: docId, employeeId },
    select: { id: true },
  });
  if (!doc) return null;
  await prisma.staffDocument.update({ where: { id: doc.id }, data: { fileSlot: slot } });
  return doc.id;
}

// ── Midpoint review (D4.2) ───────────────────────────────────────────────────
const midpointSchema = z.object({
  employeeId: z.string().min(1),
  outcome: z.enum(["ON_TRACK", "CONCERNS"]),
  heldOn: z.string().optional(),
  note: z.string().max(4000).optional(),
  staffDocumentId: z.string().optional(),
});

export async function recordMidpointReviewAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const parsed = midpointSchema.safeParse({
    employeeId: fd.get("employeeId"),
    outcome: fd.get("outcome"),
    heldOn: fd.get("heldOn") ?? undefined,
    note: fd.get("note") ?? undefined,
    staffDocumentId: fd.get("staffDocumentId") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Choose the midpoint outcome (on track / concerns)." };
  if (!MIDPOINT_OUTCOMES.includes(parsed.data.outcome)) return { ok: false, error: "Invalid midpoint outcome." };

  const plan = await prisma.onboardingPlan.findUnique({
    where: { employeeId: parsed.data.employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "No onboarding plan for this person." };
  const e = await prisma.employee.findUnique({
    where: { id: parsed.data.employeeId },
    select: { eeId: true, fullName: true },
  });
  if (!e) return { ok: false, error: "Employee not found." };

  const docId = await classifyDoc(parsed.data.employeeId, nz(fd.get("staffDocumentId")), "PROBATION_MIDPOINT");

  await prisma.probationReview.create({
    data: {
      planId: plan.id,
      employeeId: parsed.data.employeeId,
      eeId: e.eeId,
      employeeName: e.fullName,
      kind: "MIDPOINT",
      outcome: parsed.data.outcome,
      heldOn: parseDateUTC(fd.get("heldOn")) ?? new Date(),
      staffDocumentId: docId,
      decidedById: me.id,
      decidedByName: me.name,
      note: nz(fd.get("note")),
    },
  });
  await writeAudit({
    actorId: me.id,
    action: "probation.midpoint",
    entityType: "probation_review",
    entityId: parsed.data.employeeId,
    metadata: { outcome: parsed.data.outcome, filed: !!docId },
  });
  revalidatePath(`/onboarding/${parsed.data.employeeId}`);
  return { ok: true };
}

// ── End-of-probation decision (D4.3) ─────────────────────────────────────────
const finalSchema = z.object({
  employeeId: z.string().min(1),
  outcome: z.enum(["CONFIRM", "EXTEND", "NON_CONFIRM"]),
  extensionUntil: z.string().optional(),
  note: z.string().max(4000).optional(),
  staffDocumentId: z.string().optional(),
});

export async function decideProbationOutcomeAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("onboarding.manage");
  const parsed = finalSchema.safeParse({
    employeeId: fd.get("employeeId"),
    outcome: fd.get("outcome"),
    extensionUntil: fd.get("extensionUntil") ?? undefined,
    note: fd.get("note") ?? undefined,
    staffDocumentId: fd.get("staffDocumentId") ?? undefined,
  });
  if (!parsed.success) return { ok: false, error: "Choose the decision (confirm / extend / do not confirm)." };
  const { employeeId, outcome } = parsed.data;
  if (!FINAL_OUTCOMES.includes(outcome)) return { ok: false, error: "Invalid decision." };

  const plan = await prisma.onboardingPlan.findUnique({
    where: { employeeId },
    select: { id: true },
  });
  if (!plan) return { ok: false, error: "No onboarding plan for this person." };
  const e = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, eeId: true, fullName: true, status: true, userId: true },
  });
  if (!e) return { ok: false, error: "Employee not found." };

  const extensionUntil = outcome === "EXTEND" ? parseDateUTC(fd.get("extensionUntil")) : null;
  if (outcome === "EXTEND" && !extensionUntil) {
    return { ok: false, error: "Set the date the extension runs to." };
  }

  const docId = await classifyDoc(employeeId, nz(fd.get("staffDocumentId")), "PROBATION_OUTCOME");

  // 1) Record the FINAL review (the decision).
  await prisma.probationReview.create({
    data: {
      planId: plan.id,
      employeeId,
      eeId: e.eeId,
      employeeName: e.fullName,
      kind: "FINAL",
      outcome,
      heldOn: new Date(),
      extensionUntil,
      staffDocumentId: docId,
      decidedById: me.id,
      decidedByName: me.name,
      note: nz(fd.get("note")),
    },
  });

  // 2) Apply the consequence.
  if (outcome === "CONFIRM") {
    if (String(e.status) === "PROBATION") {
      await prisma.employee.update({ where: { id: employeeId }, data: { status: "ACTIVE" } });
      await prisma.employmentRecord.create({
        data: {
          employeeId,
          eventType: "CONFIRMATION",
          title: "Probation confirmed",
          status: "ACTIVE",
          effectiveDate: new Date(),
          note: "Employment confirmed at end of probation (WS4 / Ops Manual D4.3).",
        },
      });
    }
    await writeAudit({
      actorId: me.id,
      action: "probation.confirm",
      entityType: "employee",
      entityId: employeeId,
      metadata: { filed: !!docId },
    });
    revalidatePath(`/onboarding/${employeeId}`);
    return { ok: true };
  }

  if (outcome === "EXTEND") {
    await writeAudit({
      actorId: me.id,
      action: "probation.extend",
      entityType: "employee",
      entityId: employeeId,
      metadata: { extensionUntil: extensionUntil?.toISOString() ?? null, filed: !!docId },
    });
    revalidatePath(`/onboarding/${employeeId}`);
    return { ok: true };
  }

  // NON_CONFIRM — open an offboarding case (a termination) and route there.
  const existing = await prisma.offboardingCase.findFirst({
    where: { employeeId, status: { not: "CLOSED" } },
    select: { id: true },
  });
  if (!existing) {
    let elevated = false;
    if (e.userId) {
      const u = await prisma.user.findUnique({
        where: { id: e.userId },
        select: { roles: { include: { role: true } } },
      });
      const keys = u?.roles.map((r) => r.role.key) ?? [];
      elevated = keys.includes("SUPER_ADMIN") || keys.includes("admin.users");
    }
    const reg = await prisma.employee.findUnique({ where: { id: employeeId }, select: { isRegulatedRole: true } });
    const created = await prisma.offboardingCase.create({
      data: {
        employeeId,
        eeId: e.eeId,
        employeeName: e.fullName,
        userId: e.userId ?? null,
        exitType: "NON_CONFIRMATION",
        status: "OPEN",
        reason: "End of probation — not confirmed.",
      },
    });
    const seeds = defaultOffboardingTasks("NON_CONFIRMATION", !!reg?.isRegulatedRole, elevated);
    await prisma.offboardingTask.createMany({
      data: seeds.map((s) => ({ caseId: created.id, label: s.label, category: s.category, sortOrder: s.sortOrder })),
    });
  }
  await writeAudit({
    actorId: me.id,
    action: "probation.non_confirm",
    entityType: "employee",
    entityId: employeeId,
    metadata: { filed: !!docId },
  });
  redirect(`/offboarding/${employeeId}`);
}
