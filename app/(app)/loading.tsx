// Instant navigation feedback for every route in the (app) group. Next renders
// this skeleton inside the persistent shell (sidebar + topbar stay put) while the
// destination server component resolves its data, so a click feels immediate
// instead of hanging on the old page. Pure presentational; reuses the house
// .page-h / .grid.kpis / .card classes plus the .sk shimmer in globals.css.
export default function Loading() {
  return (
    <>
      <div className="page-h">
        <div>
          <div className="sk sk-title" />
          <div className="sk sk-sub" />
        </div>
      </div>

      <div className="grid kpis">
        {[0, 1, 2, 3].map((i) => (
          <div className="card kpi" key={i}>
            <div className="sk sk-lab" />
            <div className="sk sk-val" />
          </div>
        ))}
      </div>

      <div className="card" style={{ marginTop: 4 }}>
        <div className="card-pad">
          <div className="sk sk-line" />
          <div className="sk sk-line" />
          <div className="sk sk-line short" />
        </div>
      </div>
    </>
  );
}
