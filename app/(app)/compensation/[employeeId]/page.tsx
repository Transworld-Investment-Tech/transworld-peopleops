import Link from "next/link";
import { notFound } from "next/navigation";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import {
  getEmployeeCompensation,
  fmtNaira,
  fmtPct,
  treatmentBadge,
  type ProfileView,
  type CompFields as CompFieldsData,
} from "@/lib/compensation";
import PayBreakdown from "@/components/compensation/PayBreakdown";
import CompProfileForm from "@/components/compensation/CompProfileForm";
import CompChangeRequestForm from "@/components/compensation/CompChangeRequestForm";
import CompChangeReview from "@/components/compensation/CompChangeReview";
import type { CompFormInitial } from "@/components/compensation/CompFields";

export const metadata = { title: "Compensation profile · Transworld PeopleOps" };

function isoDate(d: Date): string {
  return d.toISOString().slice(0, 10);
}
function fmtDate(d: Date): string {
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}
function pctFromFraction(f: number | null): string {
  if (f === null) return "";
  return String(Math.round(f * 100 * 10000) / 10000);
}
function initialFromFields(f: CompFieldsData, effectiveDate: string): CompFormInitial {
  return {
    basicSalary: String(f.basicSalary),
    utilityAllowance: String(f.utilityAllowance),
    quarterlyAllowance: String(f.quarterlyAllowance),
    taxTreatment: f.taxTreatment,
    flatTaxRatePercent: pctFromFraction(f.flatTaxRate),
    annualRentPaid: f.annualRentPaid === null ? "" : String(f.annualRentPaid),
    pensionApplicable: f.pensionApplicable,
    nhfApplicable: f.nhfApplicable,
    effectiveDate,
  };
}
const BLANK_INITIAL: CompFormInitial = {
  basicSalary: "",
  utilityAllowance: "",
  quarterlyAllowance: "",
  taxTreatment: "PAYE",
  flatTaxRatePercent: "",
  annualRentPaid: "",
  pensionApplicable: true,
  nhfApplicable: true,
  effectiveDate: isoDate(new Date()),
};

function ProfileSummary({ p }: { p: ProfileView }) {
  const tb = treatmentBadge(p.taxTreatment);
  return (
    <div className="kpis">
      <div className="kpi">
        <span className="lab">Basic salary</span>
        <span className="val mono">{fmtNaira(p.basicSalary)}</span>
      </div>
      <div className="kpi">
        <span className="lab">Utility allowance</span>
        <span className="val mono">{fmtNaira(p.utilityAllowance)}</span>
      </div>
      <div className="kpi">
        <span className="lab">Quarterly allowance</span>
        <span className="val mono">{fmtNaira(p.quarterlyAllowance)}</span>
      </div>
      <div className="kpi">
        <span className="lab">Tax treatment</span>
        <span className="val">
          <span className={`b ${tb.cls}`}>{tb.label}</span>
          {p.taxTreatment === "FLAT_RATE" ? <span className="faint"> {fmtPct(p.flatTaxRate)}</span> : null}
        </span>
      </div>
    </div>
  );
}

export default async function EmployeeCompensationPage({
  params,
}: {
  params: Promise<{ employeeId: string }>;
}) {
  const { employeeId } = await params;
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");
  const canApprove = hasPermission(me, "compensation.approve");

  const data = await getEmployeeCompensation(employeeId);
  if (!data) notFound();

  const { employee, role, grade, payCategory, current, versions, hasActiveRuleSet, breakdown, pending, pendingPreview } =
    data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">{employee.name}</h1>
          <p>
            <span className="mono">{employee.eeId}</span>
            {role ? ` · ${role}` : ""}
            {grade ? ` · ${grade}` : ""}
            {payCategory ? ` · ${payCategory}` : ""}
          </p>
        </div>
        <Link href="/compensation" className="btn">
          ← Register
        </Link>
      </div>

      {!hasActiveRuleSet ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No active tax rule set.</b> PAYE estimates aren’t shown until one is activated under Tax rules.
              </div>
            </div>
          </div>
        </div>
      ) : null}

      {current ? (
        <div className="card">
          <div className="card-h">
            <h3>Current profile</h3>
            <span className="hint">effective {fmtDate(current.effectiveDate)}</span>
          </div>
          <div className="card-pad">
            <ProfileSummary p={current} />
          </div>
        </div>
      ) : (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>⚠</span>
              <div>
                <b>No compensation profile yet.</b>{" "}
                {canManage
                  ? "Establish one below so this person appears with a provisional breakdown in the register."
                  : "Ask an HR admin to establish one."}
              </div>
            </div>
          </div>
        </div>
      )}

      {breakdown ? (
        <div style={{ marginTop: 18 }}>
          <PayBreakdown breakdown={breakdown} />
        </div>
      ) : null}

      {pending ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Change pending sign-off</h3>
            <span className="b b-amb">Pending</span>
          </div>
          <div className="card-pad">
            <p className="faint" style={{ marginTop: 0 }}>
              Raised {fmtDate(pending.requestedAt)}
              {pending.requestedBy ? ` by ${pending.requestedBy}` : ""} · effective{" "}
              {fmtDate(pending.effectiveDate)}.
            </p>
            {pending.reason ? <p>{pending.reason}</p> : null}
            <ProfileSummary
              p={{
                ...pending.fields,
                id: pending.id,
                effectiveDate: pending.effectiveDate,
                isCurrent: false,
              }}
            />
            {pendingPreview ? (
              <div style={{ marginTop: 16 }}>
                <PayBreakdown breakdown={pendingPreview} title="Provisional breakdown if approved" />
              </div>
            ) : null}

            {canApprove ? (
              <div style={{ marginTop: 16 }}>
                <CompChangeReview requestId={pending.id} selfApproval={pending.requestedById === me.id} />
              </div>
            ) : (
              <p className="note" style={{ marginTop: 16 }}>
                <span>ℹ</span>
                <span>Awaiting exec sign-off. You don’t have approval rights for compensation changes.</span>
              </p>
            )}
          </div>
        </div>
      ) : null}

      {!current && canManage ? (
        <div className="mt">
          <CompProfileForm employeeId={employee.id} initial={BLANK_INITIAL} />
        </div>
      ) : null}

      {current && canManage && !pending ? (
        <div className="mt">
          <CompChangeRequestForm
            employeeId={employee.id}
            initial={initialFromFields(
              {
                basicSalary: current.basicSalary,
                utilityAllowance: current.utilityAllowance,
                quarterlyAllowance: current.quarterlyAllowance,
                taxTreatment: current.taxTreatment,
                flatTaxRate: current.flatTaxRate,
                annualRentPaid: current.annualRentPaid,
                pensionApplicable: current.pensionApplicable,
                nhfApplicable: current.nhfApplicable,
              },
              isoDate(new Date())
            )}
          />
        </div>
      ) : null}

      {versions.length ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Version history</h3>
            <span className="hint">{versions.length} version{versions.length === 1 ? "" : "s"}</span>
          </div>
          <div className="card-pad">
            <table>
              <thead>
                <tr>
                  <th>Effective</th>
                  <th className="num">Basic</th>
                  <th className="num">Utility</th>
                  <th className="num">Quarterly</th>
                  <th>Tax</th>
                  <th>State</th>
                </tr>
              </thead>
              <tbody>
                {versions.map((v) => {
                  const tb = treatmentBadge(v.taxTreatment);
                  return (
                    <tr key={v.id}>
                      <td>{fmtDate(v.effectiveDate)}</td>
                      <td className="num mono">{fmtNaira(v.basicSalary)}</td>
                      <td className="num mono">{fmtNaira(v.utilityAllowance)}</td>
                      <td className="num mono">{fmtNaira(v.quarterlyAllowance)}</td>
                      <td>
                        <span className={`b ${tb.cls}`}>{tb.label}</span>
                      </td>
                      <td>
                        {v.isCurrent ? <span className="b b-grn">Current</span> : <span className="b b-gry">Superseded</span>}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      ) : null}
    </>
  );
}
