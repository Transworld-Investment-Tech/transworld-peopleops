/**
 * Payroll computation engine — reproduces Ifunanya's control sheet.
 * The portal does NOT pay anyone; HumanManager remains authoritative.
 * These figures are a control/cross-check and the source for the generated sheet.
 *
 * !! VERIFY tax bands & relief rules against the Nigeria Tax Act 2025 (effective 2026)
 *    and/or your tax advisor before relying on computed PAYE. They are stored in the
 *    `tax_rule_sets` / `tax_bands` tables and are fully configurable — never hardcode.
 */

export type TaxTreatment = "PAYE" | "EXEMPT" | "FLAT_RATE";

export interface TaxBand { lowerBound: number; upperBound: number | null; rate: number }
export interface TaxRuleSet {
  exemptThresholdAnnual: number;
  pensionEmployeeRate: number;   // e.g. 0.08
  pensionEmployerRate: number;   // e.g. 0.10
  nhfRate: number;               // e.g. 0.025
  rentReliefRate: number;        // e.g. 0.20
  rentReliefCapAnnual: number;   // e.g. 500000
  pensionOnBasicOnly: boolean;   // sheet computes pension on basic
  bands: TaxBand[];
  flatRate?: number;             // for FLAT_RATE treatment (e.g. 0.10)
}

export interface PayInputs {
  basicSalary: number;
  utilityAllowance: number;
  quarterlyAllowance: number;
  taxTreatment: TaxTreatment;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
}

export interface PayOutputs {
  grossPay: number;
  employeePension: number;
  nhf: number;
  taxableIncome: number;
  payeTax: number;
  netPay: number;
  employerPension: number;
}

const r2 = (n: number) => Math.round(n * 100) / 100;

export function computePay(inp: PayInputs, rules: TaxRuleSet, flatRate = 0.1): PayOutputs {
  const gross = r2(inp.basicSalary + inp.utilityAllowance);
  const pensionBase = rules.pensionOnBasicOnly ? inp.basicSalary : gross;
  const employeePension = inp.pensionApplicable ? r2(pensionBase * rules.pensionEmployeeRate) : 0;
  const nhf = inp.nhfApplicable ? r2(pensionBase * rules.nhfRate) : 0;
  const employerPension = inp.pensionApplicable ? r2(gross * rules.pensionEmployerRate) : 0;

  if (inp.taxTreatment === "EXEMPT") {
    return { grossPay: gross, employeePension, nhf, taxableIncome: 0, payeTax: 0,
      netPay: r2(gross - employeePension - nhf), employerPension };
  }
  if (inp.taxTreatment === "FLAT_RATE") {
    const tax = r2(gross * (rules.flatRate ?? flatRate));
    return { grossPay: gross, employeePension, nhf, taxableIncome: gross, payeTax: tax,
      netPay: r2(gross - tax), employerPension };
  }

  // PAYE (annualized) — NTA 2025 style: gross less pension, NHF, capped rent relief
  const annualGross = gross * 12;
  const rentRelief = Math.min(rules.rentReliefRate * annualGross, rules.rentReliefCapAnnual);
  const annualTaxable = Math.max(0, annualGross - employeePension * 12 - nhf * 12 - rentRelief);

  let remaining = annualTaxable;
  let annualTax = 0;
  for (const b of rules.bands) {
    const ceiling = b.upperBound ?? Infinity;
    const width = Math.max(0, Math.min(remaining, ceiling - b.lowerBound));
    if (annualTaxable > b.lowerBound) annualTax += width * b.rate;
    remaining = annualTaxable - ceiling;
    if (remaining <= 0) break;
  }
  const payeTax = r2(annualTax / 12);
  return {
    grossPay: gross, employeePension, nhf,
    taxableIncome: r2(annualTaxable / 12), payeTax,
    netPay: r2(gross - employeePension - nhf - payeTax), employerPension,
  };
}
