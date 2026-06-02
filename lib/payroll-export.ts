// lib/payroll-export.ts — builds the monthly control sheet as an .xlsx that mirrors
// Ifunanya's HumanManager input sheet ("...COMPANY NET PAY FIGURES WITH ONLY BASIC
// SALARIES") column-for-column, plus an End-of-Month Summary block with the
// period-over-period variance HumanManager produces. Server-only (used by the
// export route). The portal never pays anyone — this is a cross-check artifact.
import * as XLSX from "xlsx";
import { getCycle, type CycleView, type PayRow } from "@/lib/payroll-cycle";

// Column order matches the firm's current sheet (Sheet 1). Under the 2026 tax
// method the three relief columns follow the new rules (rent relief, not CRA);
// a footnote records this. Headers are kept identical so it stays a drop-in.
const HEADERS = [
  "S/N", "EE's ID", "Employee's Name", "Pay Group", "FTE",
  "Basic Salary", "Utility Allowance", "Monthly Gross Pay", "ITF", "PENSION", "NHF",
  "Gross income for CRA", "Consolidated Relief", "Total Reliefs", "Taxable Income",
  "Computed Tax", "Effective Rate of Tax", "GROSS PAY AFTER TAX", "NETPAY AFTER TAX",
  "QUARTERLY ALLOWANCE", "EMPLOYER PENSION",
];

function r2(n: number): number { return Math.round((n + Number.EPSILON) * 100) / 100; }

function payRowToCells(i: number, r: PayRow): (string | number)[] {
  const grossAfterTax = r2(r.grossPay - r.payeTax);
  // Relief columns (2026 method): pre-relief base, applied relief (usually 0), and
  // their monthly sum; taxable income is the annual taxable / 12.
  const grossIncomeForCRA = r2(r.basicSalary - r.employeePension - r.nhf);
  const consolidatedRelief = 0; // 2026: no CRA; the ₦800k tax-free is a 0% band, not a relief
  const totalReliefs = r2(r.employeePension + r.nhf + consolidatedRelief);
  const monthlyTaxable = r2(r.taxableIncome / 12);
  const effectiveRate = r.grossPay > 0 ? r2(r.payeTax / r.grossPay) : 0;
  return [
    i + 1, r.eeId, r.name, r.payCategory ?? "", 1,
    r2(r.basicSalary), r2(r.utilityAllowance), r2(r.grossPay), r2(r.itf), r2(r.employeePension), r2(r.nhf),
    grossIncomeForCRA, consolidatedRelief, totalReliefs, monthlyTaxable,
    r2(r.payeTax), effectiveRate, grossAfterTax, r2(r.netPay),
    r2(r.quarterlyAllowance), r2(r.employerPension),
  ];
}

function buildPayrollSheet(cycle: NonNullable<CycleView>): XLSX.WorkSheet {
  const aoa: (string | number)[][] = [];
  aoa.push(["TRANSWORLD INVESTMENT & SECURITIES LIMITED"]);
  aoa.push([`${cycle.label.toUpperCase()} PAYROLL — COMPANY NET PAY FIGURES (BASIC-ONLY TAX BASE)`]);
  aoa.push([]);
  aoa.push(HEADERS);
  cycle.rows.forEach((r, i) => aoa.push(payRowToCells(i, r)));
  const t = cycle.totals;
  aoa.push([
    "", "", "TOTAL", "", "",
    r2(t.basic), r2(t.utility), r2(t.gross), r2(t.itf), r2(t.employeePension), r2(t.nhf),
    "", "", "", "", r2(t.paye), "", r2(t.gross - t.paye), r2(t.net),
    r2(t.quarterly), r2(t.employerPension),
  ]);
  aoa.push([]);
  aoa.push(["Tax computed on basic salary only (allowances excluded), 2026 Nigeria Tax Act bands, per firm policy."]);
  aoa.push(["Provisional cross-check only. HumanManager + Remita remain authoritative for payment and remittance."]);
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = HEADERS.map((h, idx) => ({ wch: idx === 2 ? 32 : idx === 3 ? 22 : Math.max(10, h.length + 1) }));
  return ws;
}

function buildSummarySheet(cycle: NonNullable<CycleView>): XLSX.WorkSheet {
  const t = cycle.totals;
  const aoa: (string | number)[][] = [];
  aoa.push(["TRANSWORLD INVESTMENT & SECURITIES LIMITED"]);
  aoa.push([`END OF MONTH SUMMARY — ${cycle.label}`]);
  aoa.push([]);
  aoa.push(["Pay Item", "Amount", "Staff Count"]);
  aoa.push(["Basic Salary", r2(t.basic), cycle.rows.length]);
  aoa.push(["Total Allowance", r2(t.utility + t.quarterly + t.adjustmentAllowances), cycle.rows.length]);
  aoa.push(["Gross Pay", r2(t.gross), cycle.rows.length]);
  aoa.push(["PAYE (Tax)", r2(t.paye), cycle.rows.length]);
  aoa.push(["Pension (Employee)", r2(t.employeePension), cycle.rows.length]);
  aoa.push(["NHF", r2(t.nhf), cycle.rows.length]);
  aoa.push(["ITF", r2(t.itf), cycle.rows.length]);
  aoa.push(["Other Deductions", r2(t.otherDeductions), cycle.rows.length]);
  aoa.push(["Total Deductions", r2(t.totalDeductions), cycle.rows.length]);
  aoa.push(["Net Pay", r2(t.net), cycle.rows.length]);
  aoa.push(["Quarterly Allowance (paid separately)", r2(t.quarterly), cycle.rows.length]);
  aoa.push(["Total Payable (net + quarterly)", r2(t.totalPayable), cycle.rows.length]);
  aoa.push(["Employer Pension (firm cost)", r2(t.employerPension), cycle.rows.length]);
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = [{ wch: 38 }, { wch: 16 }, { wch: 12 }];
  return ws;
}

function buildAdjustmentsSheet(cycle: NonNullable<CycleView>): XLSX.WorkSheet | null {
  const rowsWithAdj = cycle.rows.filter((r) => r.adjustments.length > 0);
  if (rowsWithAdj.length === 0) return null;
  const aoa: (string | number)[][] = [];
  aoa.push(["ADJUSTMENTS — operator-entered for this cycle"]);
  aoa.push([]);
  aoa.push(["EE's ID", "Employee", "Label", "Kind", "Amount", "Note"]);
  for (const r of rowsWithAdj) {
    for (const a of r.adjustments) {
      aoa.push([r.eeId, r.name, a.label, a.kind === "DEDUCTION" ? "Deduction" : "Allowance", r2(a.amount), r.changeNote ?? ""]);
    }
  }
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = [{ wch: 10 }, { wch: 30 }, { wch: 28 }, { wch: 12 }, { wch: 14 }, { wch: 40 }];
  return ws;
}

/** Build the .xlsx workbook for a cycle and return it as a Node Buffer. */
export async function buildControlSheetBuffer(cycleId: string): Promise<{ buffer: Buffer; filename: string } | null> {
  const cycle = await getCycle(cycleId);
  if (!cycle) return null;
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, buildPayrollSheet(cycle), "Payroll");
  XLSX.utils.book_append_sheet(wb, buildSummarySheet(cycle), "Summary");
  const adj = buildAdjustmentsSheet(cycle);
  if (adj) XLSX.utils.book_append_sheet(wb, adj, "Adjustments");
  const out = XLSX.write(wb, { type: "buffer", bookType: "xlsx" }) as Buffer;
  const safe = cycle.label.replace(/\s+/g, "_");
  return { buffer: out, filename: `Transworld_Payroll_Control_${safe}.xlsx` };
}
