import { fmtNaira } from "@/lib/compensation";
import type { PayBreakdown as PayBreakdownData } from "@/lib/payroll";

// A plain, hook-free slip-style card showing a provisional monthly breakdown:
// gross -> deductions (pension, NHF, PAYE) -> net, with employer pension and the
// separately-paid quarterly allowance shown apart, plus the engine's notes and a
// clear "provisional" caption. Cross-check only; HumanManager + Remita are
// authoritative.
function Row({
  label,
  value,
  kind,
}: {
  label: string;
  value: string;
  kind?: "add" | "sub" | "net" | "muted";
}) {
  return (
    <div className={"comp-slip-row" + (kind ? ` ${kind}` : "")}>
      <span className="comp-slip-lab">{label}</span>
      <span className="comp-slip-val mono num">{value}</span>
    </div>
  );
}

export default function PayBreakdown({
  breakdown,
  title = "Provisional monthly breakdown",
}: {
  breakdown: PayBreakdownData;
  title?: string;
}) {
  const b = breakdown;
  return (
    <div className="comp-slip">
      <div className="comp-slip-h">
        <h4>{title}</h4>
        <span className="b b-amb">Provisional</span>
      </div>
      <div className="comp-slip-body">
        <Row label="Monthly gross (basic + utility)" value={fmtNaira(b.monthlyGross)} kind="add" />
        <Row label="Pension (employee)" value={`− ${fmtNaira(b.pensionEmployee)}`} kind="sub" />
        <Row label="NHF" value={`− ${fmtNaira(b.nhf)}`} kind="sub" />
        <Row label="PAYE (estimate)" value={`− ${fmtNaira(b.paye)}`} kind="sub" />
        <Row label="Net pay (estimate)" value={fmtNaira(b.netPay)} kind="net" />

        <div className="comp-slip-sep" />
        <Row label="Employer pension (cost, not a deduction)" value={fmtNaira(b.pensionEmployer)} kind="muted" />

        {b.taxTreatment === "PAYE" ? (
          <>
            <div className="comp-slip-sep" />
            <Row label="Annual gross" value={fmtNaira(b.annualGross)} kind="muted" />
            <Row label="Rent relief applied (annual)" value={fmtNaira(b.rentReliefApplied)} kind="muted" />
            <Row label="Annual taxable income" value={fmtNaira(b.annualTaxableIncome)} kind="muted" />
            <Row label="Annual PAYE (estimate)" value={fmtNaira(b.annualPaye)} kind="muted" />
          </>
        ) : null}
      </div>

      {b.notes.length ? (
        <ul className="comp-slip-notes">
          {b.notes.map((n, i) => (
            <li key={i}>{n}</li>
          ))}
        </ul>
      ) : null}

      <p className="comp-slip-foot">
        Provisional cross-check only. The portal does not pay anyone — HumanManager and Remita remain
        the authoritative payroll and payment systems.
      </p>
    </div>
  );
}
