import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getDeferrals, fmtNaira } from "@/lib/bonus-deferrals";
import DeferralControls from "@/components/bonus/DeferralControls";

export const metadata = { title: "Bonus deferrals · Transworld PeopleOps" };

export default async function BonusDeferralsPage({
  searchParams,
}: {
  searchParams: Promise<{ year?: string }>;
}) {
  const me = await requirePermission("bonus.view");
  const canManage = hasPermission(me, "bonus.manage");
  const canApprove = hasPermission(me, "bonus.approve");

  const sp = await searchParams;
  const requested = sp.year ? Number(sp.year) : undefined;
  const view = await getDeferrals(Number.isFinite(requested) ? requested : undefined);

  // Serialize Date -> string for the client component.
  const serialize = (t: (typeof view.dueThisYear)[number]) => ({
    ...t,
    paidAt: t.paidAt ? new Date(t.paidAt).toISOString() : null,
  });
  const dueThisYear = view.dueThisYear.map(serialize);
  const employees = view.employees.map((e) => ({ ...e, tranches: e.tranches.map(serialize) }));

  return (
    <div className="pay-wide">
      <div className="page-h">
        <div>
          <h1 className="serif">Bonus deferrals</h1>
          <p>
            <Link href="/bonus" className="jc-link">Bonus</Link> · the cross-year deferral ledger
            (WS6 Part 3). Senior (G4/G5) awards release 65% / 26.25% / 8.75% over three Aprils; every
            award is recorded here. Mark due tranches paid, claw back, and handle leavers. The portal
            records and reconciles — it never pays.
          </p>
        </div>
      </div>

      {!view.hasLockedRounds ? (
        <div className="card">
          <div className="card-pad">
            <div className="note">
              <span>ℹ</span>
              <div>
                <b>No deferral schedule yet.</b> Tranches appear here once a bonus round has been
                approved and locked as evidence. Each award then carries its April release schedule.
              </div>
            </div>
          </div>
        </div>
      ) : (
        <>
          <div className="grid kpis pay-meta">
            <div className="card kpi"><div className="lab">Scheduled (unpaid)</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(view.rollup.scheduledNet)}</div></div>
            <div className="card kpi"><div className="lab">Paid to date</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(view.rollup.paidNet)}</div></div>
            <div className="card kpi"><div className="lab">Clawed back</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(view.rollup.clawed)}</div></div>
            <div className="card kpi"><div className="lab">Forfeited</div><div className="val" style={{ fontSize: 18 }}>{fmtNaira(view.rollup.forfeited)}</div></div>
          </div>

          {view.years.length > 1 ? (
            <div className="note" style={{ marginBottom: 16 }}>
              <span>📅</span>
              <div>
                April due year:{" "}
                {view.years.map((y) => (
                  <span key={y}>
                    {y === view.focusYear ? (
                      <b className="mono">{y}</b>
                    ) : (
                      <Link href={`/bonus/deferrals?year=${y}`} className="jc-link mono">{y}</Link>
                    )}
                    {" "}
                  </span>
                ))}
              </div>
            </div>
          ) : null}

          <DeferralControls
            focusYear={view.focusYear}
            dueThisYear={dueThisYear}
            dueTotal={view.dueTotal}
            employees={employees}
            canManage={canManage}
            canApprove={canApprove}
          />
        </>
      )}
    </div>
  );
}
