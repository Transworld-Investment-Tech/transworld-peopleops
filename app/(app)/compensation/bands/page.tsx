import { requirePermission, hasPermission } from "@/lib/auth/rbac";
import { getSalaryBands, getPendingRequestCount, fmtNaira } from "@/lib/compensation";
import CompTabs from "@/components/compensation/CompTabs";
import SalaryBandsForm from "@/components/compensation/SalaryBandsForm";

export const metadata = { title: "Salary bands · Transworld PeopleOps" };

export default async function SalaryBandsPage() {
  const me = await requirePermission("compensation.view");
  const canManage = hasPermission(me, "compensation.manage");

  const [bands, pendingCount] = await Promise.all([
    getSalaryBands(),
    getPendingRequestCount(),
  ]);

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">Salary bands</h1>
          <p>The grade structure pay is checked against. Reference only — it doesn’t change anyone’s actual pay.</p>
        </div>
      </div>

      <CompTabs active="bands" pendingCount={pendingCount} />

      <div className="card">
        <div className="card-h">
          <h3>Grade structure</h3>
          <span className="hint">{bands.length} band{bands.length === 1 ? "" : "s"}</span>
        </div>
        <div className="card-pad">
          {bands.length === 0 ? (
            <div className="note">
              <span>ℹ</span>
              <div>
                No salary bands defined yet.
                {canManage ? " Add the grade structure below." : " Ask an HR admin to set one up."}
              </div>
            </div>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Grade</th>
                  <th>Band</th>
                  <th className="num">Min</th>
                  <th className="num">Midpoint</th>
                  <th className="num">Max</th>
                  <th className="num">Staff</th>
                </tr>
              </thead>
              <tbody>
                {bands.map((b) => (
                  <tr key={b.id}>
                    <td className="mono">{b.grade}</td>
                    <td>{b.label}</td>
                    <td className="num mono">{fmtNaira(b.min)}</td>
                    <td className="num mono">{fmtNaira(b.midpoint)}</td>
                    <td className="num mono">{fmtNaira(b.max)}</td>
                    <td className="num">{b.staff}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {canManage ? (
        <SalaryBandsForm
          initial={bands.map((b) => ({
            grade: b.grade,
            label: b.label,
            min: b.min,
            midpoint: b.midpoint,
            max: b.max,
          }))}
        />
      ) : null}
    </>
  );
}
