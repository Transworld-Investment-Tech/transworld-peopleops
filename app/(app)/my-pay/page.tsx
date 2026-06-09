import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { fmtNaira, fmtPct, treatmentBadge } from "@/lib/compensation";
import { getMyCompensation } from "@/lib/my-compensation";
import { getFeatureFlags } from "@/lib/feature-flags";

export const metadata = { title: "My Pay · Transworld PeopleOps" };

function initialsOf(name: string): string {
  return (
    name
      .split(/\s+/)
      .filter(Boolean)
      .map((s) => s[0])
      .slice(0, 2)
      .join("")
      .toUpperCase() || "?"
  );
}
function fmtDate(d: Date): string {
  return new Date(d).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

export default async function MyPayPage() {
  const me = await requirePermission("compensation.view_own");
  const flags = await getFeatureFlags();
  if (!flags.my_pay) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My Pay</h1>
            <p>Your standing pay structure.</p>
          </div>
        </div>
        <div className="note">
          <span>ℹ</span>
          <div>My Pay isn&rsquo;t available yet. It will appear here once HR switches it on.</div>
        </div>
      </>
    );
  }
  const data = await getMyCompensation(me.id);

  if (!data.linked) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My Pay</h1>
            <p>Your standing pay structure.</p>
          </div>
        </div>
        <div className="note">
          <span>ℹ</span>
          <div>Your login isn&rsquo;t linked to an employee record yet. Ask HR to link it so your pay appears here.</div>
        </div>
      </>
    );
  }

  const { employee, hasProfile } = data;
  const tb = treatmentBadge(data.taxTreatment);

  return (
    <>
      <div className="comp-head">
        <div className="comp-head-id">
          <span className="comp-avatar" aria-hidden="true">{initialsOf(employee.name)}</span>
          <div>
            <h1 className="serif comp-head-name">{employee.name}</h1>
            <div className="comp-head-chips">
              <span className="chip"><span className="chip-k">EID</span> {employee.eeId}</span>
              {employee.role ? <span className="chip"><span className="chip-k">Role</span> {employee.role}</span> : null}
              {employee.grade ? <span className="chip"><span className="chip-k">Grade</span> {employee.grade}</span> : null}
            </div>
          </div>
        </div>
        {hasProfile && data.effectiveDate ? (
          <div className="comp-head-eff">
            <span>Effective</span>
            {fmtDate(data.effectiveDate)}
          </div>
        ) : null}
      </div>

      {!hasProfile ? (
        <div className="note">
          <span>ℹ</span>
          <div>No compensation profile is on record for you yet. Ask HR to establish one — it will appear here once it&rsquo;s set.</div>
        </div>
      ) : (
        <>
          <div className="card">
            <div className="card-h">
              <h3>Current profile</h3>
              <span className="hint">monthly</span>
            </div>
            <div className="card-pad">
              <div className="comp-figs">
                <div className="comp-fig">
                  <span className="comp-fig-lab">Basic salary</span>
                  <span className="comp-fig-val serif">{fmtNaira(data.basicSalary)}</span>
                </div>
                <div className="comp-fig">
                  <span className="comp-fig-lab">Utility allowance</span>
                  <span className="comp-fig-val serif">{fmtNaira(data.utilityAllowance)}</span>
                </div>
                <div className="comp-fig">
                  <span className="comp-fig-lab">Monthly gross</span>
                  <span className="comp-fig-val serif">{fmtNaira(data.monthlyGross)}</span>
                </div>
              </div>
              <div className="comp-tax">
                <span className="comp-fig-lab">Tax treatment</span>
                <span>
                  <span className={`b ${tb.cls}`}>{tb.label}</span>
                  {data.taxTreatment === "FLAT_RATE" && data.flatTaxRate !== null ? (
                    <span className="faint"> {fmtPct(data.flatTaxRate)}</span>
                  ) : null}
                </span>
              </div>
            </div>
          </div>

          <div className="card mt">
            <div className="card-h">
              <h3>Fully-loaded pay</h3>
              <span className="hint">monthly equivalent</span>
            </div>
            <div className="card-pad">
              <div className="comp-fig">
                <span className="comp-fig-lab">Fully-loaded{data.fte !== 1 ? ` (FTE ${data.fte})` : ""}</span>
                <span className="comp-fig-val serif comp-fig-lg">{fmtNaira(data.fullyLoaded)}</span>
              </div>
              <p className="faint" style={{ marginTop: 10, marginBottom: 0 }}>
                Your fully-loaded figure is your total monthly package — gross pay plus the firm&rsquo;s
                allowance and benefit loading. It&rsquo;s the basis the firm uses internally; it isn&rsquo;t
                a take-home figure. What actually lands each month is on your{" "}
                <Link href="/payslips" className="jc-link">payslips</Link>.
              </p>
            </div>
          </div>
        </>
      )}
    </>
  );
}
