"use server";
// Write-side server actions for Compensation. Every action is gated (manage to
// raise/establish/edit structure; approve to sign off a change), zod-validated,
// transactional where it touches more than one row, and audited. Mirrors the
// conventions of the other module actions (scorecards / performance).
//
// Separation of duties: raising a change (compensation.manage) and approving it
// (compensation.approve) are deliberately different permissions. v1 reality: only
// the SUPER_ADMIN login exists, so the same person may raise and approve — that is
// allowed, but the audit entry is stamped self_approved when requester === approver.
//
// This module never pays anyone. Establishing/changing a profile only updates the
// standing inputs the control room reads; HumanManager + Remita stay authoritative.
import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { requirePermission } from "@/lib/auth/rbac";
import { writeAudit } from "@/lib/auth/audit";

export type FormState = {
  ok: boolean;
  error?: string;
  fieldErrors?: Record<string, string>;
};

const TREATMENTS = ["PAYE", "EXEMPT", "FLAT_RATE"] as const;
const DECISIONS = ["APPROVE", "REJECT"] as const;

// ---------------------------------------------------------------------------
// Parsing helpers
// ---------------------------------------------------------------------------
function nz(v?: string | null): string | null {
  const s = (v ?? "").trim();
  return s === "" ? null : s;
}
function parseDate(v?: string | null): Date | null {
  const s = (v ?? "").trim();
  if (s === "") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}
/** Strip ₦, commas and spaces; "" -> null. Returns a finite number or null. */
function parseMoney(v?: string | null): number | null {
  const s = (v ?? "").replace(/[₦,\s]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  return Number.isFinite(n) ? n : null;
}
/** Whole-number percent string -> fraction, rounded to 4 dp (fits Decimal(6,4)). */
function parsePercentToFraction(v?: string | null): number | null {
  const s = (v ?? "").replace(/[%\s,]/g, "").trim();
  if (s === "") return null;
  const n = Number(s);
  if (!Number.isFinite(n)) return null;
  return Math.round((n / 100) * 10000) / 10000;
}
function asBool(v: FormDataEntryValue | null): boolean {
  return String(v ?? "") === "1" || String(v ?? "") === "true" || String(v ?? "") === "on";
}
function flatten(err: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of err.issues) {
    const k = String(issue.path[0] ?? "form");
    if (!out[k]) out[k] = issue.message;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Shared comp-fields schema (used by establish + change request)
// ---------------------------------------------------------------------------
const compSchema = z
  .object({
    basicSalary: z.number({ invalid_type_error: "Enter a basic salary" }).positive("Basic salary must be greater than zero"),
    utilityAllowance: z.number().min(0, "Cannot be negative"),
    quarterlyAllowance: z.number().min(0, "Cannot be negative"),
    taxTreatment: z.enum(TREATMENTS),
    flatTaxRate: z.number().min(0).max(1, "Flat rate looks too high").nullable(),
    annualRentPaid: z.number().min(0, "Cannot be negative").nullable(),
    pensionApplicable: z.boolean(),
    nhfApplicable: z.boolean(),
    effectiveDate: z.date({ invalid_type_error: "Pick an effective date" }),
  })
  .superRefine((v, ctx) => {
    if (v.taxTreatment === "FLAT_RATE" && (v.flatTaxRate === null || v.flatTaxRate <= 0)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["flatTaxRate"],
        message: "A flat-rate profile needs a rate greater than zero",
      });
    }
  });

type CompValues = z.infer<typeof compSchema>;

/** Parse the comp form. The flat-rate field is a whole-number percent in the UI;
 *  it is converted to a stored fraction only when the treatment is FLAT_RATE. */
function readCompForm(fd: FormData): {
  basicSalary: number | null;
  utilityAllowance: number;
  quarterlyAllowance: number;
  taxTreatment: string;
  flatTaxRate: number | null;
  annualRentPaid: number | null;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
  effectiveDate: Date | null;
} {
  const taxTreatment = String(fd.get("taxTreatment") ?? "PAYE");
  const flatTaxRate =
    taxTreatment === "FLAT_RATE" ? parsePercentToFraction(String(fd.get("flatTaxRate") ?? "")) : null;
  return {
    basicSalary: parseMoney(String(fd.get("basicSalary") ?? "")),
    utilityAllowance: parseMoney(String(fd.get("utilityAllowance") ?? "")) ?? 0,
    quarterlyAllowance: parseMoney(String(fd.get("quarterlyAllowance") ?? "")) ?? 0,
    taxTreatment,
    flatTaxRate,
    annualRentPaid: parseMoney(String(fd.get("annualRentPaid") ?? "")),
    pensionApplicable: asBool(fd.get("pensionApplicable")),
    nhfApplicable: asBool(fd.get("nhfApplicable")),
    effectiveDate: parseDate(String(fd.get("effectiveDate") ?? "")),
  };
}

function validateComp(raw: ReturnType<typeof readCompForm>):
  | { ok: true; value: CompValues }
  | { ok: false; fieldErrors: Record<string, string> } {
  const parsed = compSchema.safeParse(raw);
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  return { ok: true, value: parsed.data };
}

// ---------------------------------------------------------------------------
// Establish the first compensation profile for an employee
// ---------------------------------------------------------------------------
export async function establishProfileAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!employeeId) return { ok: false, error: "Missing employee." };

  const employee = await prisma.employee.findUnique({
    where: { id: employeeId },
    select: { id: true, fullName: true },
  });
  if (!employee) return { ok: false, error: "Employee not found." };

  const existing = await prisma.compensationProfile.findFirst({
    where: { employeeId, isCurrent: true },
    select: { id: true },
  });
  if (existing)
    return { ok: false, error: "A current profile already exists — raise a change request instead." };

  const v = validateComp(readCompForm(fd));
  if (!v.ok) return { ok: false, fieldErrors: v.fieldErrors };

  const profile = await prisma.compensationProfile.create({
    data: {
      employeeId,
      effectiveDate: v.value.effectiveDate,
      basicSalary: v.value.basicSalary,
      utilityAllowance: v.value.utilityAllowance,
      quarterlyAllowance: v.value.quarterlyAllowance,
      taxTreatment: v.value.taxTreatment,
      flatTaxRate: v.value.flatTaxRate,
      annualRentPaid: v.value.annualRentPaid,
      pensionApplicable: v.value.pensionApplicable,
      nhfApplicable: v.value.nhfApplicable,
      isCurrent: true,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "compensation.establish",
    entityType: "compensation_profile",
    entityId: profile.id,
    metadata: { employee: employee.fullName, basicSalary: v.value.basicSalary, taxTreatment: v.value.taxTreatment },
  });

  revalidatePath(`/compensation/${employeeId}`);
  revalidatePath("/compensation");
  redirect(`/compensation/${employeeId}`);
}

// ---------------------------------------------------------------------------
// Raise a change request against the current profile
// ---------------------------------------------------------------------------
export async function createChangeRequestAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const employeeId = String(fd.get("employeeId") ?? "");
  if (!employeeId) return { ok: false, error: "Missing employee." };

  const current = await prisma.compensationProfile.findFirst({
    where: { employeeId, isCurrent: true },
    select: { id: true },
  });
  if (!current)
    return { ok: false, error: "No current profile to change yet — establish a profile first." };

  const pending = await prisma.compChangeRequest.findFirst({
    where: { employeeId, status: "PENDING" },
    select: { id: true },
  });
  if (pending)
    return { ok: false, error: "A pending change request already exists for this employee." };

  const v = validateComp(readCompForm(fd));
  if (!v.ok) return { ok: false, fieldErrors: v.fieldErrors };

  const req = await prisma.compChangeRequest.create({
    data: {
      employeeId,
      basicSalary: v.value.basicSalary,
      utilityAllowance: v.value.utilityAllowance,
      quarterlyAllowance: v.value.quarterlyAllowance,
      taxTreatment: v.value.taxTreatment,
      flatTaxRate: v.value.flatTaxRate,
      annualRentPaid: v.value.annualRentPaid,
      pensionApplicable: v.value.pensionApplicable,
      nhfApplicable: v.value.nhfApplicable,
      effectiveDate: v.value.effectiveDate,
      reason: nz(String(fd.get("reason") ?? "")),
      status: "PENDING",
      requestedById: me.id,
    },
  });

  await writeAudit({
    actorId: me.id,
    action: "comprequest.create",
    entityType: "comp_change_request",
    entityId: req.id,
    metadata: { employeeId, basicSalary: v.value.basicSalary, taxTreatment: v.value.taxTreatment },
  });

  revalidatePath(`/compensation/${employeeId}`);
  revalidatePath("/compensation/requests");
  revalidatePath("/compensation");
  redirect(`/compensation/${employeeId}`);
}

// ---------------------------------------------------------------------------
// Decide (approve / reject) a pending request — the exec sign-off
// ---------------------------------------------------------------------------
export async function decideRequestAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.approve");
  const requestId = String(fd.get("requestId") ?? "");
  const decision = String(fd.get("decision") ?? "");
  const decisionNote = nz(String(fd.get("decisionNote") ?? ""));
  if (!requestId) return { ok: false, error: "Missing request." };
  if (!(DECISIONS as readonly string[]).includes(decision))
    return { ok: false, error: "Choose approve or reject." };

  const req = await prisma.compChangeRequest.findUnique({ where: { id: requestId } });
  if (!req) return { ok: false, error: "Request not found." };
  if (req.status !== "PENDING") return { ok: false, error: "This request has already been decided." };

  const employeeId = req.employeeId;

  if (decision === "REJECT") {
    await prisma.compChangeRequest.update({
      where: { id: requestId },
      data: { status: "REJECTED", decidedById: me.id, decidedAt: new Date(), decisionNote },
    });
    await writeAudit({
      actorId: me.id,
      action: "comprequest.reject",
      entityType: "comp_change_request",
      entityId: requestId,
      metadata: { employeeId, self_approved: me.id === req.requestedById },
    });
  } else {
    // APPROVE: version the profile in a transaction — flip the prior current row
    // to false, insert the new current row from the request, mark the request applied.
    const newProfile = await prisma.$transaction(async (tx) => {
      await tx.compensationProfile.updateMany({
        where: { employeeId, isCurrent: true },
        data: { isCurrent: false },
      });
      const created = await tx.compensationProfile.create({
        data: {
          employeeId,
          effectiveDate: req.effectiveDate,
          basicSalary: req.basicSalary,
          utilityAllowance: req.utilityAllowance,
          quarterlyAllowance: req.quarterlyAllowance,
          taxTreatment: req.taxTreatment as (typeof TREATMENTS)[number],
          flatTaxRate: req.flatTaxRate,
          annualRentPaid: req.annualRentPaid,
          pensionApplicable: req.pensionApplicable,
          nhfApplicable: req.nhfApplicable,
          isCurrent: true,
        },
      });
      await tx.compChangeRequest.update({
        where: { id: requestId },
        data: {
          status: "APPROVED",
          decidedById: me.id,
          decidedAt: new Date(),
          decisionNote,
          appliedProfileId: created.id,
        },
      });
      return created;
    });

    await writeAudit({
      actorId: me.id,
      action: "comprequest.approve",
      entityType: "comp_change_request",
      entityId: requestId,
      metadata: {
        employeeId,
        appliedProfileId: newProfile.id,
        self_approved: me.id === req.requestedById,
      },
    });
  }

  revalidatePath(`/compensation/${employeeId}`);
  revalidatePath("/compensation/requests");
  revalidatePath("/compensation");
  redirect(`/compensation/${employeeId}`);
}

// ---------------------------------------------------------------------------
// Cancel (delete) a pending request
// ---------------------------------------------------------------------------
export async function cancelRequestAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const requestId = String(fd.get("requestId") ?? "");
  if (!requestId) return { ok: false, error: "Missing request." };

  const req = await prisma.compChangeRequest.findUnique({
    where: { id: requestId },
    select: { id: true, status: true, employeeId: true },
  });
  if (!req) return { ok: false, error: "Request not found." };
  if (req.status !== "PENDING")
    return { ok: false, error: "Only a pending request can be cancelled." };

  await prisma.compChangeRequest.delete({ where: { id: requestId } });

  await writeAudit({
    actorId: me.id,
    action: "comprequest.cancel",
    entityType: "comp_change_request",
    entityId: requestId,
    metadata: { employeeId: req.employeeId },
  });

  revalidatePath(`/compensation/${req.employeeId}`);
  revalidatePath("/compensation/requests");
  redirect("/compensation/requests");
}

// ---------------------------------------------------------------------------
// Salary band structure
// ---------------------------------------------------------------------------
const bandRowSchema = z
  .object({
    grade: z.string().trim().min(1, "Grade is required"),
    label: z.string().trim().min(1, "Band name is required"),
    min: z.number().min(0, "Cannot be negative"),
    midpoint: z.number().min(0, "Cannot be negative"),
    max: z.number().min(0, "Cannot be negative"),
  })
  .refine((r) => r.min <= r.max, { message: "Min must be ≤ max", path: ["min"] });

function readBandRows(fd: FormData): { grade: string; label: string; min: number; midpoint: number; max: number }[] {
  try {
    const arr = JSON.parse(String(fd.get("bands") ?? "[]"));
    if (!Array.isArray(arr)) return [];
    return arr
      .map((x: Record<string, unknown>) => ({
        grade: String(x.grade ?? "").trim(),
        label: String(x.label ?? "").trim(),
        min: Number(parseMoney(String(x.min ?? "")) ?? NaN),
        midpoint: Number(parseMoney(String(x.midpoint ?? "")) ?? NaN),
        max: Number(parseMoney(String(x.max ?? "")) ?? NaN),
      }))
      // drop fully-blank rows the editor may submit
      .filter(
        (r) =>
          r.grade !== "" ||
          r.label !== "" ||
          !Number.isNaN(r.min) ||
          !Number.isNaN(r.midpoint) ||
          !Number.isNaN(r.max)
      );
  } catch {
    return [];
  }
}

export async function saveSalaryBandsAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const rows = readBandRows(fd);

  const clean: { grade: string; label: string; min: number; midpoint: number; max: number }[] = [];
  for (let i = 0; i < rows.length; i++) {
    const parsed = bandRowSchema.safeParse(rows[i]);
    if (!parsed.success) {
      const msg = parsed.error.issues[0]?.message ?? "Check this band";
      return { ok: false, fieldErrors: { bands: `Band ${i + 1}: ${msg}` } };
    }
    clean.push(parsed.data);
  }
  const grades = clean.map((r) => r.grade.toUpperCase());
  if (new Set(grades).size !== grades.length)
    return { ok: false, fieldErrors: { bands: "Each grade can appear only once." } };

  await prisma.$transaction(async (tx) => {
    await tx.salaryBand.deleteMany({});
    let order = 0;
    for (const r of clean) {
      await tx.salaryBand.create({
        data: {
          grade: r.grade,
          label: r.label,
          minAmount: r.min,
          midpoint: r.midpoint,
          maxAmount: r.max,
          sortOrder: order++,
        },
      });
    }
  });

  await writeAudit({
    actorId: me.id,
    action: "salaryband.save",
    entityType: "salary_band",
    entityId: null,
    metadata: { bands: clean.length },
  });

  revalidatePath("/compensation/bands");
  revalidatePath("/compensation");
  redirect("/compensation/bands");
}

// ---------------------------------------------------------------------------
// Tax rule set + bands editor
// ---------------------------------------------------------------------------
const taxRuleSchema = z.object({
  name: z.string().trim().min(2, "Give the rule set a name"),
  effectiveFrom: z.date({ invalid_type_error: "Pick an effective-from date" }),
  exemptThresholdAnnual: z.number().min(0, "Cannot be negative"),
  pensionEmployeeRate: z.number().min(0).max(1),
  pensionEmployerRate: z.number().min(0).max(1),
  nhfRate: z.number().min(0).max(1),
  rentReliefRate: z.number().min(0).max(1),
  rentReliefCapAnnual: z.number().min(0, "Cannot be negative"),
  pensionOnBasicOnly: z.boolean(),
  isActive: z.boolean(),
});

function readTaxBandRows(fd: FormData): { lowerBound: number; upperBound: number | null; rate: number }[] {
  try {
    const arr = JSON.parse(String(fd.get("bands") ?? "[]"));
    if (!Array.isArray(arr)) return [];
    return arr
      .map((x: Record<string, unknown>) => {
        const lower = parseMoney(String(x.lowerBound ?? ""));
        const upperRaw = String(x.upperBound ?? "").trim();
        const upper = upperRaw === "" ? null : parseMoney(upperRaw);
        const rate = parsePercentToFraction(String(x.ratePercent ?? ""));
        return {
          lowerBound: lower === null ? NaN : lower,
          upperBound: upper,
          rate: rate === null ? NaN : rate,
        };
      })
      .filter((r) => !Number.isNaN(r.lowerBound) || !Number.isNaN(r.rate));
  } catch {
    return [];
  }
}

export async function saveTaxRuleSetAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const id = nz(String(fd.get("rulesetId") ?? ""));

  const parsed = taxRuleSchema.safeParse({
    name: String(fd.get("name") ?? ""),
    effectiveFrom: parseDate(String(fd.get("effectiveFrom") ?? "")),
    exemptThresholdAnnual: parseMoney(String(fd.get("exemptThresholdAnnual") ?? "")) ?? 0,
    pensionEmployeeRate: parsePercentToFraction(String(fd.get("pensionEmployeeRate") ?? "")) ?? 0,
    pensionEmployerRate: parsePercentToFraction(String(fd.get("pensionEmployerRate") ?? "")) ?? 0,
    nhfRate: parsePercentToFraction(String(fd.get("nhfRate") ?? "")) ?? 0,
    rentReliefRate: parsePercentToFraction(String(fd.get("rentReliefRate") ?? "")) ?? 0,
    rentReliefCapAnnual: parseMoney(String(fd.get("rentReliefCapAnnual") ?? "")) ?? 0,
    pensionOnBasicOnly: asBool(fd.get("pensionOnBasicOnly")),
    isActive: asBool(fd.get("isActive")),
  });
  if (!parsed.success) return { ok: false, fieldErrors: flatten(parsed.error) };
  const v = parsed.data;

  const bandRows = readTaxBandRows(fd);
  for (let i = 0; i < bandRows.length; i++) {
    const r = bandRows[i];
    if (Number.isNaN(r.lowerBound) || r.lowerBound < 0)
      return { ok: false, fieldErrors: { bands: `Band ${i + 1}: lower bound is required.` } };
    if (Number.isNaN(r.rate) || r.rate < 0 || r.rate > 1)
      return { ok: false, fieldErrors: { bands: `Band ${i + 1}: rate must be between 0 and 100%.` } };
    if (r.upperBound !== null && r.upperBound < r.lowerBound)
      return { ok: false, fieldErrors: { bands: `Band ${i + 1}: upper bound must be above the lower bound.` } };
  }

  const savedId = await prisma.$transaction(async (tx) => {
    if (v.isActive) {
      await tx.taxRuleSet.updateMany({ data: { isActive: false }, where: {} });
    }
    const ruleset = id
      ? await tx.taxRuleSet.update({
          where: { id },
          data: {
            name: v.name,
            effectiveFrom: v.effectiveFrom,
            exemptThresholdAnnual: v.exemptThresholdAnnual,
            pensionEmployeeRate: v.pensionEmployeeRate,
            pensionEmployerRate: v.pensionEmployerRate,
            nhfRate: v.nhfRate,
            rentReliefRate: v.rentReliefRate,
            rentReliefCapAnnual: v.rentReliefCapAnnual,
            pensionOnBasicOnly: v.pensionOnBasicOnly,
            isActive: v.isActive,
          },
        })
      : await tx.taxRuleSet.create({
          data: {
            name: v.name,
            effectiveFrom: v.effectiveFrom,
            exemptThresholdAnnual: v.exemptThresholdAnnual,
            pensionEmployeeRate: v.pensionEmployeeRate,
            pensionEmployerRate: v.pensionEmployerRate,
            nhfRate: v.nhfRate,
            rentReliefRate: v.rentReliefRate,
            rentReliefCapAnnual: v.rentReliefCapAnnual,
            pensionOnBasicOnly: v.pensionOnBasicOnly,
            isActive: v.isActive,
          },
        });

    // Replace bands wholesale, in order.
    await tx.taxBand.deleteMany({ where: { taxRuleSetId: ruleset.id } });
    let seq = 1;
    for (const r of bandRows) {
      await tx.taxBand.create({
        data: {
          taxRuleSetId: ruleset.id,
          sequence: seq++,
          lowerBound: r.lowerBound,
          upperBound: r.upperBound,
          rate: r.rate,
        },
      });
    }
    return ruleset.id;
  });

  await writeAudit({
    actorId: me.id,
    action: "taxruleset.save",
    entityType: "tax_rule_set",
    entityId: savedId,
    metadata: { name: v.name, bands: bandRows.length, isActive: v.isActive, created: !id },
  });

  revalidatePath("/compensation/tax");
  revalidatePath("/compensation");
  redirect("/compensation/tax");
}

export async function activateTaxRuleSetAction(_prev: FormState, fd: FormData): Promise<FormState> {
  const me = await requirePermission("compensation.manage");
  const rulesetId = String(fd.get("rulesetId") ?? "");
  if (!rulesetId) return { ok: false, error: "Missing rule set." };

  const ruleset = await prisma.taxRuleSet.findUnique({
    where: { id: rulesetId },
    select: { id: true, name: true },
  });
  if (!ruleset) return { ok: false, error: "Rule set not found." };

  await prisma.$transaction(async (tx) => {
    await tx.taxRuleSet.updateMany({ data: { isActive: false }, where: {} });
    await tx.taxRuleSet.update({ where: { id: rulesetId }, data: { isActive: true } });
  });

  await writeAudit({
    actorId: me.id,
    action: "taxruleset.activate",
    entityType: "tax_rule_set",
    entityId: rulesetId,
    metadata: { name: ruleset.name },
  });

  revalidatePath("/compensation/tax");
  revalidatePath("/compensation");
  redirect("/compensation/tax");
}
