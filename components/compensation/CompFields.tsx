"use client";
import { useState } from "react";
import { TAX_TREATMENTS } from "@/lib/compensation";

// Shared field block for the establish + change-request forms. Money fields are
// plain text (the action strips ₦ and commas); the flat-rate field is a whole
// number percent (the action divides by 100 only when treatment is FLAT_RATE).
export type CompFormInitial = {
  basicSalary: string;
  utilityAllowance: string;
  quarterlyAllowance: string;
  taxTreatment: string;
  flatTaxRatePercent: string; // whole-number percent, e.g. "10"
  annualRentPaid: string;
  pensionApplicable: boolean;
  nhfApplicable: boolean;
  effectiveDate: string; // yyyy-mm-dd
};

export function CompFields({
  initial,
  fieldErrors,
}: {
  initial: CompFormInitial;
  fieldErrors: Record<string, string>;
}) {
  const [treatment, setTreatment] = useState(initial.taxTreatment || "PAYE");
  const fe = fieldErrors;
  const isFlat = treatment === "FLAT_RATE";

  return (
    <div className="form-grid">
      <div className="field">
        <label htmlFor="basicSalary">Basic salary (₦ / month)</label>
        <input id="basicSalary" name="basicSalary" inputMode="numeric" defaultValue={initial.basicSalary} placeholder="e.g. 500,000" />
        {fe.basicSalary ? <span className="err">{fe.basicSalary}</span> : null}
      </div>
      <div className="field">
        <label htmlFor="utilityAllowance">Utility allowance (₦ / month)</label>
        <input id="utilityAllowance" name="utilityAllowance" inputMode="numeric" defaultValue={initial.utilityAllowance} placeholder="e.g. 100,000" />
        {fe.utilityAllowance ? <span className="err">{fe.utilityAllowance}</span> : null}
      </div>
      <div className="field">
        <label htmlFor="quarterlyAllowance">Quarterly allowance (₦)</label>
        <input id="quarterlyAllowance" name="quarterlyAllowance" inputMode="numeric" defaultValue={initial.quarterlyAllowance} placeholder="paid separately" />
        {fe.quarterlyAllowance ? <span className="err">{fe.quarterlyAllowance}</span> : null}
      </div>
      <div className="field">
        <label htmlFor="taxTreatment">Tax treatment</label>
        <select
          id="taxTreatment"
          name="taxTreatment"
          value={treatment}
          onChange={(e) => setTreatment(e.target.value)}
        >
          {TAX_TREATMENTS.map((t) => (
            <option key={t.value} value={t.value}>
              {t.label}
            </option>
          ))}
        </select>
      </div>
      <div className="field">
        <label htmlFor="flatTaxRate">Flat tax rate (%) {isFlat ? "" : "— flat-rate only"}</label>
        <input
          id="flatTaxRate"
          name="flatTaxRate"
          inputMode="decimal"
          defaultValue={initial.flatTaxRatePercent}
          placeholder="e.g. 10"
          disabled={!isFlat}
        />
        {fe.flatTaxRate ? <span className="err">{fe.flatTaxRate}</span> : null}
      </div>
      <div className="field">
        <label htmlFor="annualRentPaid">Annual rent paid (₦) — for PAYE rent relief</label>
        <input id="annualRentPaid" name="annualRentPaid" inputMode="numeric" defaultValue={initial.annualRentPaid} placeholder="optional" />
        {fe.annualRentPaid ? <span className="err">{fe.annualRentPaid}</span> : null}
      </div>
      <div className="field">
        <label htmlFor="effectiveDate">Effective date</label>
        <input id="effectiveDate" name="effectiveDate" type="date" defaultValue={initial.effectiveDate} />
        {fe.effectiveDate ? <span className="err">{fe.effectiveDate}</span> : null}
      </div>
      <div className="field">
        <label>Benefits</label>
        <div className="comp-checks">
          <label className="comp-check">
            <input type="checkbox" name="pensionApplicable" value="1" defaultChecked={initial.pensionApplicable} />
            <span>Pension applies</span>
          </label>
          <label className="comp-check">
            <input type="checkbox" name="nhfApplicable" value="1" defaultChecked={initial.nhfApplicable} />
            <span>NHF applies</span>
          </label>
        </div>
      </div>
    </div>
  );
}
