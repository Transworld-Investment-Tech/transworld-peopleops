import { requirePermission } from "@/lib/auth/rbac";
import { getMyPayslips, fmtNaira, type MyPaySlip } from "@/lib/my-payslips";

export const metadata = { title: "My payslips · Transworld PeopleOps" };

function lockedDate(d: Date | null): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

function Slip({ slip, eeId, open }: { slip: MyPaySlip; eeId: string; open: boolean }) {
  const allowanceAdj = slip.adjustments.filter((a) => a.kind === "ALLOWANCE");
  const deductionAdj = slip.adjustments.filter((a) => a.kind === "DEDUCTION");
  return (
    <details className="payslip-d" open={open}>
      <summary className="payslip-sum">
        <span className="serif payslip-month">{slip.label}</span>
        <span className="payslip-sum-right">
          <span className="b b-grn">Locked</span>
          <span className="num mono payslip-net">{fmtNaira(slip.netPay)}</span>
        </span>
      </summary>

      <div className="comp-slip">
        <div className="comp-slip-h">
          <h4>{slip.label} — net pay {fmtNaira(slip.netPay)}</h4>
          <span className="faint mono">{eeId}</span>
        </div>

        <div className="comp-slip-body">
          {/* Earnings */}
          <div className="comp-slip-row">
            <span className="comp-slip-lab">Basic salary</span>
            <span className="comp-slip-val num">{fmtNaira(slip.basicSalary)}</span>
          </div>
          {slip.utilityAllowance > 0 ? (
            <div className="comp-slip-row">
              <span className="comp-slip-lab">Utility allowance</span>
              <span className="comp-slip-val num">{fmtNaira(slip.utilityAllowance)}</span>
            </div>
          ) : null}
          {allowanceAdj.map((a, i) => (
            <div className="comp-slip-row" key={`al-${i}`}>
              <span className="comp-slip-lab">{a.label}</span>
              <span className="comp-slip-val num">{fmtNaira(a.amount)}</span>
            </div>
          ))}

          <div className="comp-slip-sep" />
          <div className="comp-slip-row">
            <span className="comp-slip-lab">Gross for the month</span>
            <span className="comp-slip-val num">{fmtNaira(slip.grossForMonth)}</span>
          </div>

          {/* Deductions */}
          <div className="comp-slip-sep" />
          {slip.employeePension > 0 ? (
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">Pension (employee, 8%)</span>
              <span className="comp-slip-val num">−{fmtNaira(slip.employeePension)}</span>
            </div>
          ) : null}
          {slip.nhf > 0 ? (
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">NHF</span>
              <span className="comp-slip-val num">−{fmtNaira(slip.nhf)}</span>
            </div>
          ) : null}
          {slip.itf > 0 ? (
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">ITF (1%)</span>
              <span className="comp-slip-val num">−{fmtNaira(slip.itf)}</span>
            </div>
          ) : null}
          {slip.payeTax > 0 ? (
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">PAYE tax</span>
              <span className="comp-slip-val num">−{fmtNaira(slip.payeTax)}</span>
            </div>
          ) : null}
          {deductionAdj.map((a, i) => (
            <div className="comp-slip-row sub" key={`de-${i}`}>
              <span className="comp-slip-lab">{a.label}</span>
              <span className="comp-slip-val num">−{fmtNaira(a.amount)}</span>
            </div>
          ))}
          <div className="comp-slip-row">
            <span className="comp-slip-lab">Total deductions</span>
            <span className="comp-slip-val num">−{fmtNaira(slip.totalDeductions)}</span>
          </div>

          {/* Net */}
          <div className="comp-slip-row net">
            <span className="comp-slip-lab">Net pay</span>
            <span className="comp-slip-val num">{fmtNaira(slip.netPay)}</span>
          </div>

          {/* Paid separately + informational */}
          {slip.quarterlyAllowance > 0 ? (
            <>
              <div className="comp-slip-sep" />
              <div className="comp-slip-row">
                <span className="comp-slip-lab">Quarterly allowance (paid on top)</span>
                <span className="comp-slip-val num">{fmtNaira(slip.quarterlyAllowance)}</span>
              </div>
              <div className="comp-slip-row net">
                <span className="comp-slip-lab">Total payable this month</span>
                <span className="comp-slip-val num">{fmtNaira(slip.totalPayable)}</span>
              </div>
            </>
          ) : null}
          <div className="comp-slip-row muted">
            <span className="comp-slip-lab">Employer pension (paid by the firm, not deducted)</span>
            <span className="comp-slip-val num">{fmtNaira(slip.employerPension)}</span>
          </div>
        </div>

        <ul className="comp-slip-notes">
          <li>Locked as evidence on {lockedDate(slip.lockedAt)}.</li>
          <li>
            Provisional cross-check — HumanManager and Remita remain the authoritative payroll
            and payment systems.
          </li>
        </ul>
      </div>
    </details>
  );
}

export default async function MyPayslipsPage() {
  const me = await requirePermission("payslips.view_own");
  const data = await getMyPayslips(me.id);

  if (!data.linked) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My payslips</h1>
            <p>Your monthly pay records, drawn from locked payroll cycles.</p>
          </div>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once it is, your
                payslips will appear here.
              </div>
            </div>
          </div>
        </div>
      </>
    );
  }

  const { employee, slips, latest } = data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My payslips</h1>
          <p>
            {employee.name}
            {employee.grade ? ` · ${employee.grade}` : ""} · {employee.eeId}. Your monthly pay
            records, drawn from locked payroll cycles.
          </p>
        </div>
      </div>

      {slips.length === 0 || !latest ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No payslips yet.</b> Your payslips appear here once a monthly payroll cycle has
                been locked. The current month becomes available after it is approved and locked.
              </div>
            </div>
          </div>
        </div>
      ) : (
        <>
          <div className="kpis">
            <div className="kpi">
              <div className="lab">Latest net pay · {latest.label}</div>
              <div className="val num">{fmtNaira(latest.netPay)}</div>
            </div>
            <div className="kpi">
              <div className="lab">Latest gross</div>
              <div className="val num">{fmtNaira(latest.grossForMonth)}</div>
            </div>
            <div className="kpi">
              <div className="lab">Latest deductions</div>
              <div className="val num">{fmtNaira(latest.totalDeductions)}</div>
            </div>
            <div className="kpi">
              <div className="lab">Payslips on record</div>
              <div className="val num">{slips.length}</div>
            </div>
          </div>

          <div className="card" style={{ marginBottom: 18 }}>
            <div className="card-h">
              <h3 className="serif">Pay history</h3>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Period</th>
                  <th>Status</th>
                  <th className="num">Gross</th>
                  <th className="num">Deductions</th>
                  <th className="num">Net pay</th>
                  <th className="num">Quarterly</th>
                  <th className="num">Total payable</th>
                </tr>
              </thead>
              <tbody>
                {slips.map((s) => (
                  <tr key={s.payItemId}>
                    <td>{s.label}</td>
                    <td>
                      <span className="b b-grn">Locked</span>
                    </td>
                    <td className="num">{fmtNaira(s.grossForMonth)}</td>
                    <td className="num">{fmtNaira(s.totalDeductions)}</td>
                    <td className="num">{fmtNaira(s.netPay)}</td>
                    <td className="num">
                      {s.quarterlyAllowance > 0 ? fmtNaira(s.quarterlyAllowance) : "—"}
                    </td>
                    <td className="num">{fmtNaira(s.totalPayable)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="sec-t" style={{ marginBottom: 10 }}>
            Payslips
          </div>
          {slips.map((s, i) => (
            <Slip key={s.payItemId} slip={s} eeId={employee.eeId} open={i === 0} />
          ))}
        </>
      )}
    </>
  );
}
