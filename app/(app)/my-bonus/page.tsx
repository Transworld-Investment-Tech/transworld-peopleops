import { requirePermission } from "@/lib/auth/rbac";
import {
  getMyBonus,
  fmtNaira,
  monthLabel,
  trancheStatusBadge,
  type MyBonusAward,
} from "@/lib/my-bonus";

export const metadata = { title: "My bonus · Transworld PeopleOps" };

function lockedDate(d: Date | null): string {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

function AwardCard({ award, eeId }: { award: MyBonusAward; eeId: string }) {
  return (
    <div className="comp-slip" style={{ marginBottom: 14 }}>
      <div className="comp-slip-h">
        <h4>
          Award {award.awardYear} — awarded {fmtNaira(award.awardedBonus)}
        </h4>
        <span className="faint mono">
          {eeId} · {award.grade}
        </span>
      </div>

      <div className="comp-slip-body">
        <div className="comp-slip-row">
          <span className="comp-slip-lab">Target bonus (at target, ×1.0)</span>
          <span className="comp-slip-val num">{fmtNaira(award.targetBonus)}</span>
        </div>
        <div className="comp-slip-row sub">
          <span className="comp-slip-lab">
            Gross monthly salary {fmtNaira(award.monthlySalary)} × {award.targetMonths} month
            {award.targetMonths === 1 ? "" : "s"} (grade {award.grade})
          </span>
          <span className="comp-slip-val num faint">—</span>
        </div>

        <div className="comp-slip-row">
          <span className="comp-slip-lab">Performance multiplier</span>
          <span className="comp-slip-val num">×{award.multiplier.toFixed(2)}</span>
        </div>
        {award.integrityGate ? (
          <div className="comp-slip-row sub">
            <span className="comp-slip-lab">Integrity / compliance gate applied</span>
            <span className="comp-slip-val">
              <span className="b b-red">×0</span>
            </span>
          </div>
        ) : null}

        <div className="comp-slip-sep" />
        <div className="comp-slip-row net">
          <span className="comp-slip-lab">Awarded bonus</span>
          <span className="comp-slip-val num">{fmtNaira(award.awardedBonus)}</span>
        </div>

        {!award.deferred && award.tranches.length > 0 ? (
          <div className="comp-slip-row sub">
            <span className="comp-slip-lab">
              Payment ({monthLabel(award.tranches[0].scheduledMonth)} {award.tranches[0].scheduledYear})
            </span>
            <span className="comp-slip-val">
              <span className={`b ${trancheStatusBadge(award.tranches[0].status).cls}`}>
                {trancheStatusBadge(award.tranches[0].status).label}
              </span>
            </span>
          </div>
        ) : null}

        {award.deferred ? (
          <>
            <div className="comp-slip-sep" />
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">
                Paid immediately ({monthLabel(award.paymentMonth)} {award.paymentYear})
              </span>
              <span className="comp-slip-val num">{fmtNaira(award.immediateAmount)}</span>
            </div>
            <div className="comp-slip-row sub">
              <span className="comp-slip-lab">Deferred (released in later years)</span>
              <span className="comp-slip-val num">{fmtNaira(award.deferredAmount)}</span>
            </div>
          </>
        ) : null}
      </div>

      {award.deferred && award.tranches.length > 0 ? (
        <div style={{ padding: "0 16px 8px" }}>
          <table>
            <thead>
              <tr>
                <th>Tranche</th>
                <th>Scheduled</th>
                <th className="num">Amount</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {award.tranches.map((t) => {
                const tb = trancheStatusBadge(t.status);
                return (
                  <tr key={t.id}>
                    <td>{t.label}</td>
                    <td>
                      {monthLabel(t.scheduledMonth)} {t.scheduledYear}
                    </td>
                    <td className="num">{fmtNaira(t.amount)}</td>
                    <td>
                      <span className={`b ${tb.cls}`}>{tb.label}</span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : null}

      <ul className="comp-slip-notes">
        <li>Locked as evidence on {lockedDate(award.lockedAt)}.</li>
        <li>
          The difference between your target and awarded bonus reflects your performance multiplier
          and any firm-wide pool scaling.
        </li>
        <li>
          Provisional cross-check — HumanManager and Remita remain the authoritative payroll and
          payment systems.
        </li>
      </ul>
    </div>
  );
}

export default async function MyBonusPage() {
  const me = await requirePermission("bonus.view_own");
  const data = await getMyBonus(me.id);

  if (!data.linked) {
    return (
      <>
        <div className="page-h">
          <div>
            <h1 className="serif">My bonus</h1>
            <p>Your profit-share bonus — target, awards, and deferral schedule.</p>
          </div>
        </div>
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>Your login isn’t linked to an employee record yet.</b> Once it is, your bonus
                will appear here.
              </div>
            </div>
          </div>
        </div>
      </>
    );
  }

  const { employee, indicative, awards } = data;

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My bonus</h1>
          <p>
            {employee.name}
            {employee.grade ? ` · ${employee.grade}` : ""} · {employee.eeId}. Your profit-share
            bonus — an indicative target, plus awards and the deferral schedule from locked rounds.
          </p>
        </div>
      </div>

      {/* Indicative target ----------------------------------------------------- */}
      {indicative ? (
        <>
          <div className="kpis">
            <div className="kpi">
              <div className="lab">Target bonus · illustrative</div>
              <div className="val num">{fmtNaira(indicative.targetBonus)}</div>
            </div>
            <div className="kpi">
              <div className="lab">Gross monthly salary</div>
              <div className="val num">{fmtNaira(indicative.monthlySalary)}</div>
            </div>
            <div className="kpi">
              <div className="lab">Target months · grade {indicative.grade}</div>
              <div className="val num">{indicative.targetMonths}</div>
            </div>
            <div className="kpi">
              <div className="lab">Senior deferral</div>
              <div className="val">{indicative.deferred ? "Yes (G4/G5)" : "No"}</div>
            </div>
          </div>
          <div className="note" style={{ marginBottom: 18 }}>
            <span>ℹ</span>
            <div>
              <b>Illustrative only.</b> This is your bonus <i>if</i> the firm meets its annual profit
              budget (so the pool is not scaled down) <i>and</i> you meet your appraisal target (a
              ×1.0 performance multiplier). It is calculated as your gross monthly salary × your
              grade’s target months. Bonuses are discretionary, depend on audited firm profit, and
              are not a promise of payment. The portal records and reconciles; it never pays.
            </div>
          </div>
        </>
      ) : (
        <div className="card" style={{ marginBottom: 18 }}>
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No target bonus to show yet.</b> A target appears once you have a current
                compensation profile and a graded role.
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Awards from locked rounds -------------------------------------------- */}
      <div className="sec-t" style={{ marginBottom: 10 }}>
        Awards
      </div>
      {awards.length === 0 ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No awarded bonuses yet.</b> Your awards appear here once a bonus round has been
                approved and locked as evidence. Bonuses are paid in April against audited results.
              </div>
            </div>
          </div>
        </div>
      ) : (
        awards.map((a) => <AwardCard key={a.id} award={a} eeId={employee.eeId} />)
      )}
    </>
  );
}
