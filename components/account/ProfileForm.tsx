"use client";
import { useActionState } from "react";
import { updateMyProfileAction, type ProfileState } from "@/lib/profile-actions";

const EMPTY: ProfileState = { ok: false };

function Err({ msg }: { msg?: string }) {
  return msg ? <span className="err">{msg}</span> : null;
}

export type ProfileDefaults = {
  preferredName: string;
  phone: string;
  personalEmail: string;
  personalPhone: string;
  residentialAddress: string;
  city: string;
  stateRegion: string;
  country: string;
  nokName: string;
  nokRelationship: string;
  nokPhone: string;
  nokAddress: string;
};

export default function ProfileForm({ defaults }: { defaults: ProfileDefaults }) {
  const [state, formAction, pending] = useActionState(updateMyProfileAction, EMPTY);
  const fe = state.fieldErrors ?? {};

  return (
    <form action={formAction}>
      {state.error && <div className="form-err">{state.error}</div>}
      {state.ok && state.message && (
        <div className="note" style={{ background: "#e6f4ea", borderColor: "#bfe3cc", color: "#1c6b3c" }}>
          <span>✓</span>
          <div>{state.message}</div>
        </div>
      )}

      <div className="card">
        <div className="card-h">
          <h3>Name &amp; phone</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="preferredName">Preferred name</label>
              <input id="preferredName" name="preferredName" type="text" defaultValue={defaults.preferredName} placeholder="What you’d like to be called" autoComplete="nickname" />
              <Err msg={fe.preferredName} />
            </div>
            <div className="field">
              <label htmlFor="phone">Work phone</label>
              <input id="phone" name="phone" type="tel" defaultValue={defaults.phone} placeholder="e.g. 080 0000 0000" autoComplete="tel" />
              <Err msg={fe.phone} />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Personal contact &amp; address</h3>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="personalEmail">Personal email</label>
              <input id="personalEmail" name="personalEmail" type="email" defaultValue={defaults.personalEmail} autoComplete="email" />
              <Err msg={fe.personalEmail} />
            </div>
            <div className="field">
              <label htmlFor="personalPhone">Personal phone</label>
              <input id="personalPhone" name="personalPhone" type="tel" defaultValue={defaults.personalPhone} />
              <Err msg={fe.personalPhone} />
            </div>
            <div className="field">
              <label htmlFor="residentialAddress">Residential address</label>
              <input id="residentialAddress" name="residentialAddress" type="text" defaultValue={defaults.residentialAddress} />
              <Err msg={fe.residentialAddress} />
            </div>
            <div className="field">
              <label htmlFor="city">City</label>
              <input id="city" name="city" type="text" defaultValue={defaults.city} />
            </div>
            <div className="field">
              <label htmlFor="stateRegion">State</label>
              <input id="stateRegion" name="stateRegion" type="text" defaultValue={defaults.stateRegion} />
            </div>
            <div className="field">
              <label htmlFor="country">Country</label>
              <input id="country" name="country" type="text" defaultValue={defaults.country} />
            </div>
          </div>
        </div>
      </div>

      <div className="card mt">
        <div className="card-h">
          <h3>Next of kin</h3>
          <span className="hint">Your emergency contact</span>
        </div>
        <div className="card-pad">
          <div className="form-grid">
            <div className="field">
              <label htmlFor="nokName">Name</label>
              <input id="nokName" name="nokName" type="text" defaultValue={defaults.nokName} />
              <Err msg={fe.nokName} />
            </div>
            <div className="field">
              <label htmlFor="nokRelationship">Relationship</label>
              <input id="nokRelationship" name="nokRelationship" type="text" defaultValue={defaults.nokRelationship} placeholder="e.g. Spouse, Parent" />
            </div>
            <div className="field">
              <label htmlFor="nokPhone">Phone</label>
              <input id="nokPhone" name="nokPhone" type="tel" defaultValue={defaults.nokPhone} />
              <Err msg={fe.nokPhone} />
            </div>
            <div className="field">
              <label htmlFor="nokAddress">Address</label>
              <input id="nokAddress" name="nokAddress" type="text" defaultValue={defaults.nokAddress} />
              <Err msg={fe.nokAddress} />
            </div>
          </div>
          <p className="faint" style={{ fontSize: 12.5, marginTop: 4 }}>
            You can keep your own contact details, address and next-of-kin current here. Date of
            birth, identification, grade, department, bank details and dependents are maintained by HR.
          </p>
        </div>
      </div>

      <div className="form-actions">
        <button className="btn btn-pri" type="submit" disabled={pending}>
          {pending ? "Saving…" : "Save changes"}
        </button>
      </div>
    </form>
  );
}
