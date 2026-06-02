import Link from "next/link";
import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getBonusHome, getOpenPreview, bonusStateBadge, fmtNaira, monthLabel } from "@/lib/bonus-round";
import OpenRoundForm from "@/components/bonus/OpenRoundForm";

export const metadata = { title: "Bonus · Transworld PeopleOps" };

export default async function BonusPage() {
  const me = await requirePermission("bonus.view");
  const canManage = hasPermission(me, "bonus.manage");

  const home = await getBonusHome();
  const preview = canManage ? await getOpenPreview() : { eligible: [], skipped: [] };

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Bonus</h1>
          <p>
            The annual profit-share bonus (WS6 Part 3): a 15%-of-PBT pool, distributed by grade and
            scaled by performance, paid in April against audited results. The portal records and
            reconciles — it never pays.
          </p>
        </div>
      </div>

      <div className="card" style={{ marginBottom: 18 }}>
        <div className="card-h"><h3 className="serif">Bonus rounds</h3></div>
        {home.rounds.length === 0 ? (
          <div className="card-pad"><p className="faint">No bonus rounds yet.</p></div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Round</th>
                <th>Status</th>
                <th className="num">Staff</th>
                <th className="num">Pool</th>
                <th className="num">Awarded</th>
                <th>Payment</th>
              </tr>
            </thead>
            <tbody>
              {home.rounds.map((r) => {
                const b = bonusStateBadge(r.status);
                return (
                  <tr key={r.id}>
                    <td><Link href={`/bonus/${r.id}`} className="jc-link">{r.label}</Link></td>
                    <td><span className={`b ${b.cls}`}>{b.label}</span></td>
                    <td className="num">{r.awardCount}</td>
                    <td className="num mono">{fmtNaira(r.poolAmount)}</td>
                    <td className="num mono">{r.totalAwarded === null ? "—" : fmtNaira(r.totalAwarded)}</td>
                    <td>{monthLabel(r.paymentMonth)} {r.paymentYear}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {canManage ? (
        <div className="card">
          <div className="card-h"><h3 className="serif">Open a bonus round</h3></div>
          <div className="card-pad">
            {home.hasOpenRound ? (
              <div className="note">
                <span>ℹ</span>
                <div>A bonus round is already open. Lock or finish it before opening another.</div>
              </div>
            ) : (
              <OpenRoundForm
                defaultYear={home.suggestedYear}
                eligibleCount={preview.eligible.length}
                skipped={preview.skipped}
                appraisalCycles={home.appraisalCycles}
              />
            )}
          </div>
        </div>
      ) : null}
    </>
  );
}
