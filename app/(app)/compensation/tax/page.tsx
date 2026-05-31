import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getTaxRuleSets, getPendingRequestCount, fmtNaira, fmtPct } from "@/lib/compensation";
import CompTabs from "@/components/compensation/CompTabs";
import TaxRuleSetActivate from "@/components/compensation/TaxRuleSetActivate";
import TaxRuleSetForm, { type TaxRuleSetInitial } from "@/components/compensation/TaxRuleSetForm";

export const metadata = { title: "Tax rules · Transworld PeopleOps" };

function num(v: unknown): number {
  return v === null || v === undefined ? 0 : Number(v);
}
function numOrNull(v: unknown): number | null {
  if (v === null || v === undefined) return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
}
function isoDate(d: Date): string {
  return d.toISOString().slice(0, 10);
}
function fmtDate(d: Date): string {
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}
function pctStr(fraction: number): string {
  return String(Math.round(fraction * 100 * 10000) / 10000);
}

const BLANK_RULESET: TaxRuleSetInitial = {
  id: "",
  name: "",
  effectiveFrom: isoDate(new Date()),
  exemptThresholdAnnual: "",
  pensionEmployeeRate: "",
  pensionEmployerRate: "",
  nhfRate: "",
  rentReliefRate: "",
  rentReliefCapAnnual: "",
  pensionOnBasicOnly: true,
  isActive: false,
  bands: [],
};

export default async function TaxRulesPage({
  searchParams,
}: {
  searchParams: Promise<{ edit?: string; new?: string }>;
}) {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");
  const { edit, new: isNew } = await searchParams;

  const [ruleSets, pendingCount] = await Promise.all([
    getTaxRuleSets(),
    getPendingRequestCount(),
  ]);

  const editing = edit ? ruleSets.find((r) => r.id === edit) : undefined;
  const showForm = canManage && (isNew !== undefined || !!editing);

  let formInitial: TaxRuleSetInitial = BLANK_RULESET;
  if (editing) {
    formInitial = {
      id: editing.id,
      name: editing.name,
      effectiveFrom: isoDate(editing.effectiveFrom),
      exemptThresholdAnnual: String(num(editing.exemptThresholdAnnual)),
      pensionEmployeeRate: pctStr(num(editing.pensionEmployeeRate)),
      pensionEmployerRate: pctStr(num(editing.pensionEmployerRate)),
      nhfRate: pctStr(num(editing.nhfRate)),
      rentReliefRate: pctStr(num(editing.rentReliefRate)),
      rentReliefCapAnnual: String(num(editing.rentReliefCapAnnual)),
      pensionOnBasicOnly: editing.pensionOnBasicOnly,
      isActive: editing.isActive,
      bands: editing.bands.map((b) => ({
        lowerBound: String(num(b.lowerBound)),
        upperBound: numOrNull(b.upperBound) === null ? "" : String(num(b.upperBound)),
        ratePercent: pctStr(num(b.rate)),
      })),
    };
  }

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Tax rules</h1>
          <p>The PAYE schedule, pension, NHF and rent-relief rates the breakdowns are computed from.</p>
        </div>
        {canManage && !showForm ? (
          <Link href="/compensation/tax?new=1" className="btn btn-pri">
            New rule set
          </Link>
        ) : null}
      </div>

      <CompTabs active="tax" pendingCount={pendingCount} />

      <div className="card">
        <div className="card-pad">
          <div className="note">
            <span>⚠</span>
            <div>
              <b>Provisional and unverified.</b> The seeded 2026 PAYE bands have not been checked against the
              published Finance Act tables. Treat every breakdown as a cross-check only — HumanManager and Remita
              remain authoritative. Use the editor here to correct the rates once confirmed.
            </div>
          </div>
        </div>
      </div>

      {ruleSets.length === 0 ? (
        <div className="card mt">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                No tax rule sets yet.
                {canManage ? " Create one to enable PAYE estimates." : " Ask an HR admin to set one up."}
              </div>
            </div>
          </div>
        </div>
      ) : (
        ruleSets.map((rs) => (
          <div className="card mt" key={rs.id}>
            <div className="card-h">
              <h3>
                {rs.name}{" "}
                {rs.isActive ? (
                  <span className="b b-grn">Active</span>
                ) : (
                  <span className="b b-gry">Inactive</span>
                )}
              </h3>
              <span className="hint">effective {fmtDate(rs.effectiveFrom)}</span>
            </div>
            <div className="card-pad">
              <div className="kpis">
                <div className="kpi">
                  <span className="lab">Exempt threshold</span>
                  <span className="val mono">{fmtNaira(num(rs.exemptThresholdAnnual))}</span>
                </div>
                <div className="kpi">
                  <span className="lab">Pension (emp / co.)</span>
                  <span className="val mono">
                    {fmtPct(num(rs.pensionEmployeeRate))} / {fmtPct(num(rs.pensionEmployerRate))}
                  </span>
                </div>
                <div className="kpi">
                  <span className="lab">NHF</span>
                  <span className="val mono">{fmtPct(num(rs.nhfRate))}</span>
                </div>
                <div className="kpi">
                  <span className="lab">Rent relief</span>
                  <span className="val mono">
                    {fmtPct(num(rs.rentReliefRate))} · cap {fmtNaira(num(rs.rentReliefCapAnnual))}
                  </span>
                </div>
              </div>

              <p className="faint" style={{ marginTop: 12 }}>
                Pension base: {rs.pensionOnBasicOnly ? "basic only" : "gross"}.
              </p>

              <table style={{ marginTop: 8 }}>
                <thead>
                  <tr>
                    <th>#</th>
                    <th className="num">Lower bound</th>
                    <th className="num">Upper bound</th>
                    <th className="num">Rate</th>
                  </tr>
                </thead>
                <tbody>
                  {rs.bands.map((b) => (
                    <tr key={b.id}>
                      <td>{b.sequence}</td>
                      <td className="num mono">{fmtNaira(num(b.lowerBound))}</td>
                      <td className="num mono">
                        {numOrNull(b.upperBound) === null ? "no ceiling" : fmtNaira(num(b.upperBound))}
                      </td>
                      <td className="num mono">{fmtPct(num(b.rate))}</td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {canManage ? (
                <div className="comp-ruleset-actions">
                  {!rs.isActive ? <TaxRuleSetActivate rulesetId={rs.id} /> : null}
                  <Link href={`/compensation/tax?edit=${rs.id}`} className="btn">
                    Edit
                  </Link>
                </div>
              ) : null}
            </div>
          </div>
        ))
      )}

      {showForm ? (
        <div className="mt">
          <TaxRuleSetForm initial={formInitial} />
        </div>
      ) : null}
    </>
  );
}
