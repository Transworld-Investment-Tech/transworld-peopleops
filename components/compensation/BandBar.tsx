// components/compensation/BandBar.tsx — the salary-band position bar (v0.57.0).
//
// Pure presentation: plots a fully-loaded value against its grade band
// (min / midpoint / max). No Prisma, no data access, no client hooks — it takes
// numbers and renders an SVG-free CSS bar, so it is safe to drop into any
// server component. The navy handle marks where the person sits; the gold tick
// marks the band midpoint. Endpoint labels carry the ₦ amounts.
//
// HR-ONLY surface. This is the compa-ratio / band-positioning visual used on the
// admin compensation record; it is never shown to an employee about themselves
// (band positioning is walked through with HR during the appraisal review).

function ngn(n: number): string {
  return `₦${Math.round(n).toLocaleString("en-NG")}`;
}

function clampPct(value: number, min: number, span: number): number {
  const p = ((value - min) / span) * 100;
  if (!Number.isFinite(p)) return 0;
  return Math.min(100, Math.max(0, p));
}

export default function BandBar({
  min,
  mid,
  max,
  value,
}: {
  min: number;
  mid: number;
  max: number;
  value: number;
}) {
  const span = Math.max(max - min, 1);
  const pos = clampPct(value, min, span);
  const midPos = clampPct(mid, min, span);

  return (
    <div className="bandbar">
      <div className="bandbar-track">
        <span className="bandbar-fill" style={{ width: `${pos}%` }} />
        <span className="bandbar-mid" style={{ left: `${midPos}%` }} />
        <span className="bandbar-handle" style={{ left: `${pos}%` }} />
      </div>
      <div className="bandbar-scale">
        <div className="bandbar-pt min">
          <span className="bandbar-pt-lab">min</span>
          <span className="bandbar-pt-val">{ngn(min)}</span>
        </div>
        <div className="bandbar-pt mid" style={{ left: `${midPos}%` }}>
          <span className="bandbar-pt-lab">mid</span>
          <span className="bandbar-pt-val">{ngn(mid)}</span>
        </div>
        <div className="bandbar-pt max">
          <span className="bandbar-pt-lab">max</span>
          <span className="bandbar-pt-val">{ngn(max)}</span>
        </div>
      </div>
    </div>
  );
}
