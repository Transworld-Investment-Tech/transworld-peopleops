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
  getEmployeePositioning,
} from "@/lib/compensation";
import { bandFlagBadge } from "@/lib/raise-cycle";
import { getEmployeeSponsorships } from "@/lib/sponsorship-reads";
import { sponsorshipStatusBadge } from "@/lib/sponsorship";
import PayBreakdown from "@/components/compensation/PayBreakdown";
import CompProfileForm from "@/components/compensation/CompProfileForm";
import CompChangeRequestForm from "@/components/compensation/CompChangeRequestForm";
import CompChangeReview from "@/components/compensation/CompChangeReview";
import BandBar from "@/components/compensation/BandBar";
import type { CompFormInitial } from "@/components/compensation/CompFields";

export const metadata = { title: "Compensation profile · Transworld PeopleOps" };

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
  taxTreatment: "PAYE",
  flatTaxRatePercent: "",
  annualRentPaid: "",
  pensionApplicable: true,
  nhfApplicable: true,
  effectiveDate: isoDate(new Date()),
};

function ProfileSummary({ p }: { p: ProfileView }) {
  const tb = treatmentBadge(p.taxTreatment);
  const gross = p.basicSalary + p.utilityAllowance;
  return (
    <>
      <div className="comp-figs">
        <div className="comp-fig">
          <span className="comp-fig-lab">Basic salary</span>
          <span className="comp-fig-val serif">{fmtNaira(p.basicSalary)}</span>
        </div>
        <div className="comp-fig">
          <span className="comp-fig-lab">Utility allowance</span>
          <span className="comp-fig-val serif">{fmtNaira(p.utilityAllowance)}</span>
        </div>
        <div className="comp-fig">
          <span className="comp-fig-lab">Monthly gross</span>
          <span className="comp-fig-val serif">{fmtNaira(gross)}</span>
        </div>
      </div>
      <div className="comp-tax">
        <span className="comp-fig-lab">Tax treatment</span>
        <span>
          <span className={`b ${tb.cls}`}>{tb.label}</span>
          {p.taxTreatment === "FLAT_RATE" ? <span className="faint"> {fmtPct(p.flatTaxRate)}</span> : null}
        </span>
      </div>
    </>
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

  const [data, sponsorships] = await Promise.all([
    getEmployeeCompensation(employeeId),
    getEmployeeSponsorships(employeeId),
  ]);
  if (!data) notFound();

  const { employee, fte, role, grade, payCategory, current, versions, hasActiveRuleSet, breakdown, pending, pendingPreview } =
    data;

  const monthlyGross = current ? current.basicSalary + current.utilityAllowance : null;
  const positioning = await getEmployeePositioning(grade, monthlyGross, fte);
  const positionFlagBadge = positioning.bandFlag ? bandFlagBadge(positioning.bandFlag) : null;

  return (
    <>
      <div className="comp-head">
        <div className="comp-head-id">
          <span className="comp-avatar" aria-hidden="true">{initialsOf(employee.name)}</span>
          <div>
            <h1 className="serif comp-head-name">{employee.name}</h1>
            <div className="comp-head-chips">
              <span className="chip"><span className="chip-k">EID</span> {employee.eeId}</span>
              {role ? <span className="chip"><span className="chip-k">Role</span> {role}</span> : null}
              {grade ? <span className="chip"><span className="chip-k">Grade</span> {grade}</span> : null}
              {payCategory ? <span className="chip"><span className="chip-k">Pay cat.</span> {payCategory}</span> : null}
            </div>
          </div>
        </div>
        <div className="comp-head-right">
          <Link href="/compensation" className="btn">← Register</Link>
          {current ? (
            <div className="comp-head-eff">
              <span>Effective</span>
              {fmtDate(current.effectiveDate)}
            </div>
          ) : null}
        </div>
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

      {current && positioning.band ? (
        <div className="card mt">
          <div className="card-h">
            <h3>Band positioning</h3>
            <span className="hint">{positioning.band.label} · fully-loaded basis</span>
          </div>
          <div className="card-pad">
            <div className="bandbar-stats">
              <div className="bandbar-stat">
                <span className="comp-fig-lab">Fully-loaded{fte !== 1 ? ` (FTE ${fte})` : ""}</span>
                <span className="comp-fig-val serif">{fmtNaira(positioning.fullyLoaded)}</span>
              </div>
              <div className="bandbar-stat">
                <span className="comp-fig-lab">Compa-ratio</span>
                <span className="comp-fig-val serif">
                  {positioning.compaRatio === null ? "—" : positioning.compaRatio.toFixed(2)}
                  {positioning.cooAware ? (
                    <span className="b b-red" style={{ marginLeft: 8 }}>
                      Above {positioning.crThreshold.toFixed(2)}
                    </span>
                  ) : null}
                  {positioning.atTarget ? (
                    <span className="b b-grn" style={{ marginLeft: 8 }}>
                      At {positioning.prioritiseThreshold.toFixed(2)}
                    </span>
                  ) : null}
                  {positioning.prioritise ? (
                    <span className="b b-amb" style={{ marginLeft: 8 }}>
                      Below {positioning.prioritiseThreshold.toFixed(2)}
                    </span>
                  ) : null}
                </span>
              </div>
              <div className="bandbar-stat">
                <span className="comp-fig-lab">Position</span>
                <span>
                  {positionFlagBadge ? (
                    <span className={`b ${positionFlagBadge.cls}`}>{positionFlagBadge.label}</span>
                  ) : (
                    <span className="faint">—</span>
                  )}
                </span>
              </div>
            </div>

            <BandBar
              min={positioning.band.min}
              mid={positioning.band.midpoint}
              max={positioning.band.max}
              value={positioning.fullyLoaded ?? positioning.band.min}
            />

            <p className="faint" style={{ marginTop: 18, marginBottom: 0 }}>
              The marker is the fully-loaded, FTE-normalized monthly-equivalent (monthly gross × 17 ÷ 12 ÷ FTE)
              against the {grade} midpoint, on the same basis as the bands. Awareness only — it doesn’t change pay.
              {positioning.belowMin ? " This rate is below the band minimum — escalate to the COO." : ""}
            </p>
          </div>
        </div>
      ) : current && grade && !positioning.band ? (
        <div className="card mt">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                No salary band defined for grade <span className="mono">{grade}</span> — set one under
                Salary bands to see positioning.
              </div>
            </div>
          </div>
        </div>
      ) : null}

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

      <div className="card mt">
        <div className="card-h">
          <h3>Qualification sponsorship</h3>
          <Link href="/compensation/sponsorship" className="hint">All sponsorships →</Link>
        </div>
        <div className="card-pad">
          {sponsorships.length === 0 ? (
            <p className="faint" style={{ marginTop: 0 }}>No sponsorships on record.</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Qualification</th>
                  <th>Status</th>
                  <th className="num">Committed</th>
                  <th className="num">Exposure</th>
                </tr>
              </thead>
              <tbody>
                {sponsorships.map((sp) => {
                  const sb = sponsorshipStatusBadge(sp.status);
                  return (
                    <tr key={sp.id}>
                      <td>
                        <Link href={`/compensation/sponsorship/${sp.id}`} className="jc-link">
                          {sp.qualificationName}
                        </Link>
                        {sp.awardingBody ? <div className="faint">{sp.awardingBody}</div> : null}
                      </td>
                      <td><span className={`b ${sb.cls}`}>{sb.label}</span></td>
                      <td className="num mono">{fmtNaira(sp.committed)}</td>
                      <td className="num mono">{sp.exposure > 0 ? fmtNaira(sp.exposure) : "—"}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      </div>

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
