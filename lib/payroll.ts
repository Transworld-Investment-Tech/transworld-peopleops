// lib/payroll.ts — configurable pay/tax engine for the Compensation control room.
// Cross-check only; HumanManager + Remita stay authoritative. Nothing hardcoded:
// rates/threshold/caps come from the active TaxRuleSet; PAYE is the TaxBand rows
// as a marginal schedule over annual taxable income. Pure function -> unit-testable
// and reusable by Phase-2 Payroll.
export const TAX_TREATMENT_VALUES = ["PAYE", "EXEMPT", "FLAT_RATE"] as const;
export type TaxTreatmentValue = (typeof TAX_TREATMENT_VALUES)[number];
export type ComputePayInput = {
  basicSalary: number; utilityAllowance: number; quarterlyAllowance: number;
  taxTreatment: TaxTreatmentValue; flatTaxRate: number | null; annualRentPaid: number | null;
  pensionApplicable: boolean; nhfApplicable: boolean;
};
export type TaxBandInput = { sequence: number; lowerBound: number; upperBound: number | null; rate: number };
export type TaxRules = {
  exemptThresholdAnnual: number; pensionEmployeeRate: number; pensionEmployerRate: number;
  nhfRate: number; rentReliefRate: number; rentReliefCapAnnual: number;
  pensionOnBasicOnly: boolean; bands: TaxBandInput[];
};
export type PayBreakdown = {
  taxTreatment: TaxTreatmentValue; monthlyGross: number; pensionEmployee: number; nhf: number;
  paye: number; netPay: number; pensionEmployer: number; quarterlyAllowance: number;
  annualGross: number; annualPensionEmployee: number; annualNhf: number; rentReliefApplied: number;
  annualTaxableIncome: number; annualPaye: number; notes: string[]; provisional: true;
};
function round2(n: number): number { return Math.round((n + Number.EPSILON) * 100) / 100; }
export function computeBandTax(taxable: number, bands: TaxBandInput[]): number {
  if (taxable <= 0 || bands.length === 0) return 0;
  const sorted = [...bands].sort((a, b) => a.sequence - b.sequence);
  let tax = 0;
  for (const band of sorted) {
    const lower = band.lowerBound; const upper = band.upperBound ?? Number.POSITIVE_INFINITY;
    if (taxable <= lower) continue;
    const slice = Math.min(taxable, upper) - lower;
    if (slice > 0) tax += slice * band.rate;
  }
  return tax;
}
export function computePay(input: ComputePayInput, rules: TaxRules): PayBreakdown {
  const notes: string[] = [];
  const basic = Math.max(0, input.basicSalary);
  const utility = Math.max(0, input.utilityAllowance);
  const monthlyGross = round2(basic + utility);
  const pensionBase = rules.pensionOnBasicOnly ? basic : monthlyGross;        // single flag governs BOTH sides
  const pensionEmployee = input.pensionApplicable ? round2(pensionBase * rules.pensionEmployeeRate) : 0;
  const pensionEmployer = input.pensionApplicable ? round2(pensionBase * rules.pensionEmployerRate) : 0;
  const nhf = input.nhfApplicable ? round2(basic * rules.nhfRate) : 0;        // NHF always on basic
  let paye = 0, rentReliefApplied = 0, annualTaxableIncome = 0, annualPaye = 0;
  const annualGross = round2(monthlyGross * 12);
  const annualPensionEmployee = round2(pensionEmployee * 12);
  const annualNhf = round2(nhf * 12);
  if (input.taxTreatment === "EXEMPT") {
    notes.push("Tax exempt — no PAYE applied.");
  } else if (input.taxTreatment === "FLAT_RATE") {
    if (input.flatTaxRate === null || input.flatTaxRate <= 0) {
      notes.push("Flat tax rate not set on this profile — PAYE shown as ₦0.");
    } else {
      paye = round2(monthlyGross * input.flatTaxRate);
      notes.push(`Flat rate of ${round2(input.flatTaxRate * 100)}% applied to gross (not banded PAYE).`);
    }
  } else {
    const rent = input.annualRentPaid ?? 0;
    if (!input.annualRentPaid || input.annualRentPaid <= 0) notes.push("Annual rent not captured — rent relief not applied.");
    else rentReliefApplied = round2(Math.min(rent * rules.rentReliefRate, rules.rentReliefCapAnnual));
    annualTaxableIncome = Math.max(0, round2(annualGross - annualPensionEmployee - annualNhf - rentReliefApplied));
    annualPaye = round2(computeBandTax(annualTaxableIncome, rules.bands));
    paye = round2(annualPaye / 12);
    notes.push("PAYE is a provisional estimate; quarterly allowance is excluded.");
  }
  const netPay = round2(monthlyGross - pensionEmployee - nhf - paye);
  return { taxTreatment: input.taxTreatment, monthlyGross, pensionEmployee, nhf, paye, netPay,
    pensionEmployer, quarterlyAllowance: round2(Math.max(0, input.quarterlyAllowance)),
    annualGross, annualPensionEmployee, annualNhf, rentReliefApplied, annualTaxableIncome,
    annualPaye, notes, provisional: true };
}
