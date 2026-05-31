"use client";
import { useActionState, useState } from "react";
import Link from "next/link";
import { saveTaxRuleSetAction, type FormState } from "@/lib/compensation-actions";

// Editor for a tax rule set and its bands. Rates are entered as whole-number
// percents (the action divides by 100); amounts are naira. Band rows are
// serialized to a hidden JSON input. A hidden `rulesetId` switches create/edit.
type BandRow = { lowerBound: string; upperBound: string; ratePercent: string };

export type TaxRuleSetInitial = {
  id: string;
  name: string;
  effectiveFrom: string; // yyyy-mm-dd
  exemptThresholdAnnual: string;
  pensionEmployeeRate: string; // whole percent
  pensionEmployerRate: string; // whole percent
  nhfRate: string; // whole percent
  rentReliefRate: string; // whole percent
  rentReliefCapAnnual: string;
  pensionOnBasicOnly: boolean;
  isActive: boolean;
  bands: BandRow[];
};

const EMPTY: FormState = { ok: false };

function blankBand(): BandRow {
  return { lowerBound: "", upperBound: "", ratePercent: "" };
}

export default function TaxRuleSetForm({ initial }: { initial: TaxRuleSetInitial }) {
  const [state, formAction, pending] = useActionState(saveTaxRuleSetAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  const [bands, setBands] = useState<BandRow[]>(() =>
    initial.bands.length ? initial.bands.map((b) => ({ ...b })) : [blankBand()]
  );

  const serialized = JSON.stringify(
    bands.map((b) => ({
      lowerBound: b.lowerBound,
      upperBound: b.upperBound.trim() === "" ? null : b.upperBound,
      ratePercent: b.ratePercent,
    }))
  );

  function update(i: number, patch: Partial<BandRow>) {
    setBands((bs) => bs.map((b, idx) => (idx === i ? { ...b, ...patch } : b)));
  }
  function addBand() {
    setBands((bs) => [...bs, blankBand()]);
  }
  function removeBand(i: number) {
    setBands((bs) => (bs.length <= 1 ? [blankBand()] : bs.filter((_, idx) => idx !== i)));
  }

  return (
    <form action={formAction}>
      <input type="hidden" name="rulesetId" value={initial.id} />
      <input type="hidden" name="bands" value={serialized} />
      {state.error ? <div className="form-err">{state.error}</div> : null}

      <div className="card mt">
        <div className="card-h">
          <h3>{initial.id ? "Edit tax rule set" : "New tax rule set"}</h3>
          <span className="hint">rates are percentages · amounts are annual naira</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="name">Name</label>
              <input id="name" name="name" defaultValue={initial.name} placeholder="e.g. Nigeria PAYE 2026" />
              {fe.name ? <span className="err">{fe.name}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="effectiveFrom">Effective from</label>
              <input id="effectiveFrom" name="effectiveFrom" type="date" defaultValue={initial.effectiveFrom} />
              {fe.effectiveFrom ? <span className="err">{fe.effectiveFrom}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="exemptThresholdAnnual">Exempt threshold (annual ₦)</label>
              <input id="exemptThresholdAnnual" name="exemptThresholdAnnual" inputMode="numeric" defaultValue={initial.exemptThresholdAnnual} placeholder="e.g. 800,000" />
              {fe.exemptThresholdAnnual ? <span className="err">{fe.exemptThresholdAnnual}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="pensionEmployeeRate">Pension — employee (%)</label>
              <input id="pensionEmployeeRate" name="pensionEmployeeRate" inputMode="decimal" defaultValue={initial.pensionEmployeeRate} placeholder="e.g. 8" />
              {fe.pensionEmployeeRate ? <span className="err">{fe.pensionEmployeeRate}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="pensionEmployerRate">Pension — employer (%)</label>
              <input id="pensionEmployerRate" name="pensionEmployerRate" inputMode="decimal" defaultValue={initial.pensionEmployerRate} placeholder="e.g. 10" />
              {fe.pensionEmployerRate ? <span className="err">{fe.pensionEmployerRate}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="nhfRate">NHF rate (%)</label>
              <input id="nhfRate" name="nhfRate" inputMode="decimal" defaultValue={initial.nhfRate} placeholder="e.g. 2.5" />
              {fe.nhfRate ? <span className="err">{fe.nhfRate}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="rentReliefRate">Rent relief rate (%)</label>
              <input id="rentReliefRate" name="rentReliefRate" inputMode="decimal" defaultValue={initial.rentReliefRate} placeholder="e.g. 20" />
              {fe.rentReliefRate ? <span className="err">{fe.rentReliefRate}</span> : null}
            </div>
            <div className="field">
              <label htmlFor="rentReliefCapAnnual">Rent relief cap (annual ₦)</label>
              <input id="rentReliefCapAnnual" name="rentReliefCapAnnual" inputMode="numeric" defaultValue={initial.rentReliefCapAnnual} placeholder="e.g. 500,000" />
              {fe.rentReliefCapAnnual ? <span className="err">{fe.rentReliefCapAnnual}</span> : null}
            </div>
            <div className="field">
              <label>Options</label>
              <div className="comp-checks">
                <label className="comp-check">
                  <input type="checkbox" name="pensionOnBasicOnly" value="1" defaultChecked={initial.pensionOnBasicOnly} />
                  <span>Pension on basic only</span>
                </label>
                <label className="comp-check">
                  <input type="checkbox" name="isActive" value="1" defaultChecked={initial.isActive} />
                  <span>Make this the active rule set</span>
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Tax bands</h3>
          <span className="hint">marginal schedule over annual taxable income · leave the last upper bound blank for “no ceiling”</span>
        </div>
        <div className="card-pad">
          {fe.bands ? <div className="form-err" style={{ marginBottom: 10 }}>{fe.bands}</div> : null}
          <div className="comp-band-rows">
            <div className="comp-band-head comp-taxband-head">
              <span>#</span>
              <span>Lower bound (₦)</span>
              <span>Upper bound (₦)</span>
              <span>Rate (%)</span>
              <span />
            </div>
            {bands.map((b, i) => (
              <div className="comp-band-row comp-taxband-row" key={i}>
                <span className="sc-row-n">{i + 1}</span>
                <input
                  value={b.lowerBound}
                  onChange={(e) => update(i, { lowerBound: e.target.value })}
                  placeholder="e.g. 0"
                  inputMode="numeric"
                  aria-label={`Lower bound for band ${i + 1}`}
                />
                <input
                  value={b.upperBound}
                  onChange={(e) => update(i, { upperBound: e.target.value })}
                  placeholder="blank = no ceiling"
                  inputMode="numeric"
                  aria-label={`Upper bound for band ${i + 1}`}
                />
                <input
                  value={b.ratePercent}
                  onChange={(e) => update(i, { ratePercent: e.target.value })}
                  placeholder="e.g. 15"
                  inputMode="decimal"
                  aria-label={`Rate for band ${i + 1}`}
                />
                <button
                  type="button"
                  className="sc-remove"
                  onClick={() => removeBand(i)}
                  aria-label={`Remove band ${i + 1}`}
                >
                  ×
                </button>
              </div>
            ))}
          </div>
          <button type="button" className="btn sc-add" onClick={addBand}>
            + Add band
          </button>
        </div>
      </div>

      <div className="form-actions">
        <Link href="/compensation/tax" className="btn">
          Cancel
        </Link>
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save tax rule set"}
        </button>
      </div>
    </form>
  );
}
