// lib/bonus-export.ts — builds the bonus round control sheet as an .xlsx: an
// "Awards" sheet (per-person target/multiplier/calculated/awarded), a "Summary"
// sheet (PBT, pool, reconciliation), and a "Tranches" sheet (the G4/G5 deferral
// schedule). Server-only; the portal records and reconciles — it never pays.
import * as XLSX from "xlsx";
import { getRound, type RoundView } from "@/lib/bonus-round";

function r2(n: number): number { return Math.round((n + Number.EPSILON) * 100) / 100; }

const MONTHS = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December",
];

const HEADERS = [
  "S/N", "EE's ID", "Employee's Name", "Grade", "Monthly Salary",
  "Target Months", "Target Bonus", "Multiplier", "Integrity Gate",
  "Calculated", "Awarded", "Immediate", "Deferred",
];

function buildAwardsSheet(round: NonNullable<RoundView>): XLSX.WorkSheet {
  const aoa: (string | number)[][] = [];
  aoa.push(["TRANSWORLD INVESTMENT & SECURITIES LIMITED"]);
  aoa.push([`${round.label.toUpperCase()} — ANNUAL BONUS (WS6 PART 3)`]);
  aoa.push([`Salary basis: ${round.salaryBasis} · Payment: April ${round.paymentYear}`]);
  aoa.push([]);
  aoa.push(HEADERS);
  round.rows.forEach((r, i) => {
    aoa.push([
      i + 1, r.eeId, r.name, r.grade, r2(r.monthlySalary),
      r.targetMonths, r2(r.targetBonus), r.multiplier, r.integrityGate ? "GATED (×0)" : "",
      r2(r.calculatedBonus), r2(r.awardedBonus), r2(r.immediateAmount), r2(r.deferredAmount),
    ]);
  });
  const t = round.totals;
  aoa.push([
    "", "", "TOTAL", "", "", "", r2(t.targetBonus), "", "",
    r2(t.calculated), r2(t.awarded), r2(t.immediate), r2(t.deferred),
  ]);
  aoa.push([]);
  aoa.push(["Individual bonus = target months (by grade) × monthly salary × multiplier (×0–×1.3); a serious integrity/compliance breach gates the multiplier to ×0."]);
  aoa.push(["Provisional record. Payment is made in April against audited results; the firm's payroll/payment systems remain authoritative."]);
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = HEADERS.map((h, idx) => ({ wch: idx === 2 ? 30 : Math.max(11, h.length + 1) }));
  return ws;
}

function buildSummarySheet(round: NonNullable<RoundView>): XLSX.WorkSheet {
  const rec = round.reconciliation;
  const t = round.totals;
  const aoa: (string | number)[][] = [];
  aoa.push(["TRANSWORLD INVESTMENT & SECURITIES LIMITED"]);
  aoa.push([`BONUS POOL RECONCILIATION — ${round.label}`]);
  aoa.push([]);
  aoa.push(["Item", "Amount"]);
  aoa.push(["Profit before tax (PBT)", r2(rec.pbt)]);
  aoa.push([`Pool rate`, rec.poolRate]);
  aoa.push(["Bonus pool", r2(rec.poolAmount)]);
  aoa.push(["Total target bonus", r2(t.targetBonus)]);
  aoa.push(["Total calculated (after multipliers)", r2(rec.totalCalculated)]);
  aoa.push(["Scaling factor", rec.scalingFactor]);
  aoa.push(["Total awarded (after scaling)", r2(t.awarded)]);
  aoa.push(["Total immediate", r2(t.immediate)]);
  aoa.push(["Total deferred (G4/G5)", r2(t.deferred)]);
  aoa.push([rec.withinPool ? "Within pool" : "Oversubscribed — scaled to fit", r2(rec.headroom)]);
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = [{ wch: 40 }, { wch: 18 }];
  return ws;
}

function buildTranchesSheet(round: NonNullable<RoundView>): XLSX.WorkSheet | null {
  if (round.tranches.length === 0) return null;
  const aoa: (string | number)[][] = [];
  aoa.push(["BONUS PAYMENT SCHEDULE (TRANCHES)"]);
  aoa.push([]);
  aoa.push(["EE's ID", "Employee", "Tranche", "Amount", "Scheduled", "Status"]);
  for (const t of round.tranches) {
    aoa.push([t.eeId, t.name, t.label, r2(t.amount), `${MONTHS[t.scheduledMonth - 1] ?? t.scheduledMonth} ${t.scheduledYear}`, t.status]);
  }
  const ws = XLSX.utils.aoa_to_sheet(aoa);
  ws["!cols"] = [{ wch: 10 }, { wch: 30 }, { wch: 26 }, { wch: 14 }, { wch: 16 }, { wch: 12 }];
  return ws;
}

export async function buildBonusSheetBuffer(roundId: string): Promise<{ buffer: Buffer; filename: string } | null> {
  const round = await getRound(roundId);
  if (!round) return null;
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, buildAwardsSheet(round), "Awards");
  XLSX.utils.book_append_sheet(wb, buildSummarySheet(round), "Summary");
  const tr = buildTranchesSheet(round);
  if (tr) XLSX.utils.book_append_sheet(wb, tr, "Tranches");
  const out = XLSX.write(wb, { type: "buffer", bookType: "xlsx" }) as Buffer;
  const safe = round.label.replace(/\s+/g, "_");
  return { buffer: out, filename: `Transworld_Bonus_${safe}.xlsx` };
}
