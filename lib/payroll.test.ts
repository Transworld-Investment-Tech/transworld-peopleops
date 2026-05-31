// Unit tests for the pure pay/tax engine. Run: npx -y tsx payroll.test.ts
import { computePay, computeBandTax, type TaxRules, type ComputePayInput } from "./payroll";

let pass = 0, fail = 0;
function eq(label: string, got: number, want: number) {
  const ok = Math.abs(got - want) < 0.005;
  if (ok) { pass++; } else { fail++; console.error(`✗ ${label}: got ${got}, want ${want}`); }
}
function truthy(label: string, cond: boolean) {
  if (cond) { pass++; } else { fail++; console.error(`✗ ${label}: expected true`); }
}

// A clean rule set resembling the Nigeria Tax Act 2025 shape: ₦800k tax-free as
// a 0% first band, 15% to ₦3m, 25% thereafter.
const rules: TaxRules = {
  exemptThresholdAnnual: 800000,
  pensionEmployeeRate: 0.08,
  pensionEmployerRate: 0.10,
  nhfRate: 0.025,
  rentReliefRate: 0.20,
  rentReliefCapAnnual: 500000,
  pensionOnBasicOnly: true,
  bands: [
    { sequence: 1, lowerBound: 0, upperBound: 800000, rate: 0 },
    { sequence: 2, lowerBound: 800000, upperBound: 3000000, rate: 0.15 },
    { sequence: 3, lowerBound: 3000000, upperBound: null, rate: 0.25 },
  ],
};

// 1-3: computeBandTax — below floor, mid band, spanning bands.
eq("bandTax below floor", computeBandTax(500000, rules.bands), 0);
eq("bandTax mid band", computeBandTax(2000000, rules.bands), 180000);
eq("bandTax spanning bands", computeBandTax(4000000, rules.bands), 580000);

// 4-11: full PAYE case, hand-computed.
const paye: ComputePayInput = {
  basicSalary: 500000, utilityAllowance: 100000, quarterlyAllowance: 300000,
  taxTreatment: "PAYE", flatTaxRate: null, annualRentPaid: 600000,
  pensionApplicable: true, nhfApplicable: true,
};
const b = computePay(paye, rules);
eq("PAYE monthlyGross", b.monthlyGross, 600000);
eq("PAYE pensionEmployee", b.pensionEmployee, 40000);
eq("PAYE pensionEmployer", b.pensionEmployer, 50000);
eq("PAYE nhf", b.nhf, 12500);
eq("PAYE annualTaxableIncome", b.annualTaxableIncome, 6450000);
eq("PAYE annualPaye", b.annualPaye, 1192500);
eq("PAYE monthly paye", b.paye, 99375);
eq("PAYE netPay", b.netPay, 448125);

// 12-14: pensionOnBasicOnly:false — pension base = gross, NHF still on basic.
const grossRules: TaxRules = { ...rules, pensionOnBasicOnly: false };
const g = computePay({ ...paye }, grossRules);
eq("gross-base pensionEmployee", g.pensionEmployee, 48000);
eq("gross-base pensionEmployer", g.pensionEmployer, 60000);
eq("gross-base nhf still on basic", g.nhf, 12500);

// 15-16: EXEMPT — net = basic, no PAYE.
const ex = computePay({
  basicSalary: 300000, utilityAllowance: 0, quarterlyAllowance: 0,
  taxTreatment: "EXEMPT", flatTaxRate: null, annualRentPaid: null,
  pensionApplicable: false, nhfApplicable: false,
}, rules);
eq("EXEMPT paye", ex.paye, 0);
eq("EXEMPT net = basic", ex.netPay, 300000);

// 17-18: FLAT_RATE 10% of gross.
const fr = computePay({
  basicSalary: 200000, utilityAllowance: 0, quarterlyAllowance: 0,
  taxTreatment: "FLAT_RATE", flatTaxRate: 0.10, annualRentPaid: null,
  pensionApplicable: false, nhfApplicable: false,
}, rules);
eq("FLAT_RATE paye", fr.paye, 20000);
eq("FLAT_RATE net", fr.netPay, 180000);

// 19-20: FLAT_RATE with no rate set — PAYE 0 + a note.
const frn = computePay({
  basicSalary: 200000, utilityAllowance: 0, quarterlyAllowance: 0,
  taxTreatment: "FLAT_RATE", flatTaxRate: null, annualRentPaid: null,
  pensionApplicable: false, nhfApplicable: false,
}, rules);
eq("FLAT_RATE null paye", frn.paye, 0);
truthy("FLAT_RATE null note", frn.notes.some((n) => n.toLowerCase().includes("not set")));

// 21: rent-relief cap binds (20% of ₦5m = ₦1m, capped at ₦500k).
const cap = computePay({
  basicSalary: 1000000, utilityAllowance: 0, quarterlyAllowance: 0,
  taxTreatment: "PAYE", flatTaxRate: null, annualRentPaid: 5000000,
  pensionApplicable: true, nhfApplicable: true,
}, rules);
eq("rent relief capped", cap.rentReliefApplied, 500000);

// 22: EXEMPT note present.
truthy("EXEMPT note", ex.notes.some((n) => n.toLowerCase().includes("exempt")));

// 23-24: pensionApplicable:false — both pension sides 0.
const np = computePay({
  basicSalary: 500000, utilityAllowance: 100000, quarterlyAllowance: 0,
  taxTreatment: "PAYE", flatTaxRate: null, annualRentPaid: null,
  pensionApplicable: false, nhfApplicable: true,
}, rules);
eq("no-pension employee side", np.pensionEmployee, 0);
eq("no-pension employer side", np.pensionEmployer, 0);

console.log(`\n${pass}/${pass + fail} checks passed.`);
if (fail > 0) process.exit(1);
