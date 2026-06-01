"use client";
import { useActionState, useRef, useState, useEffect } from "react";
import { signDocumentAction, type FormState } from "@/lib/staff-documents-actions";

const EMPTY: FormState = { ok: false };

export default function SignDocument({
  docId,
  title,
  defaultName,
}: {
  docId: string;
  title: string;
  defaultName: string;
}) {
  const [state, action, pending] = useActionState(signDocumentAction, EMPTY);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const hiddenRef = useRef<HTMLInputElement | null>(null);
  const drawing = useRef(false);
  const [hasInk, setHasInk] = useState(false);

  useEffect(() => {
    const c = canvasRef.current;
    if (!c) return;
    const ctx = c.getContext("2d");
    if (!ctx) return;
    ctx.lineWidth = 2.2;
    ctx.lineCap = "round";
    ctx.strokeStyle = "#1d2733";
  }, []);

  function pos(e: React.PointerEvent<HTMLCanvasElement>) {
    const c = canvasRef.current!;
    const r = c.getBoundingClientRect();
    return { x: e.clientX - r.left, y: e.clientY - r.top };
  }
  function start(e: React.PointerEvent<HTMLCanvasElement>) {
    const ctx = canvasRef.current!.getContext("2d")!;
    drawing.current = true;
    const p = pos(e);
    ctx.beginPath();
    ctx.moveTo(p.x, p.y);
    canvasRef.current!.setPointerCapture(e.pointerId);
  }
  function move(e: React.PointerEvent<HTMLCanvasElement>) {
    if (!drawing.current) return;
    const ctx = canvasRef.current!.getContext("2d")!;
    const p = pos(e);
    ctx.lineTo(p.x, p.y);
    ctx.stroke();
    setHasInk(true);
  }
  function end() {
    drawing.current = false;
    if (hiddenRef.current && canvasRef.current && hasInk) {
      hiddenRef.current.value = canvasRef.current.toDataURL("image/png");
    }
  }
  function clear() {
    const c = canvasRef.current!;
    c.getContext("2d")!.clearRect(0, 0, c.width, c.height);
    setHasInk(false);
    if (hiddenRef.current) hiddenRef.current.value = "";
  }

  if (state.ok) {
    return (
      <div className="note">
        <span>✓</span>
        <div>{state.message ?? "Signed."}</div>
      </div>
    );
  }

  return (
    <form action={action}>
      <input type="hidden" name="docId" value={docId} />
      <input type="hidden" name="signatureData" ref={hiddenRef} />
      <p style={{ marginTop: 0 }}>
        <a href={`/staff-documents/${docId}/file`} target="_blank" rel="noopener noreferrer" className="jc-link">
          Open “{title}” to read it
        </a>{" "}
        before you sign.
      </p>
      <div className="field">
        <label htmlFor={`name-${docId}`}>Type your full name</label>
        <input id={`name-${docId}`} name="signerName" defaultValue={defaultName} placeholder="Full name" />
      </div>
      <div className="field">
        <label>Draw your signature (optional)</label>
        <canvas
          ref={canvasRef}
          width={360}
          height={110}
          onPointerDown={start}
          onPointerMove={move}
          onPointerUp={end}
          onPointerLeave={end}
          style={{ border: "1px solid var(--line)", borderRadius: 8, touchAction: "none", background: "#fff", maxWidth: "100%" }}
        />
        <div>
          <button type="button" className="btn" onClick={clear} style={{ marginTop: 6, padding: "5px 10px" }}>
            Clear
          </button>
        </div>
      </div>
      <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: 14, margin: "8px 0" }}>
        <input type="checkbox" name="consent" />
        <span>I have read this document and agree to it. I understand this is my electronic signature.</span>
      </label>
      {state.error ? <div className="form-err">{state.error}</div> : null}
      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Signing…" : "Sign document"}
        </button>
      </div>
    </form>
  );
}
