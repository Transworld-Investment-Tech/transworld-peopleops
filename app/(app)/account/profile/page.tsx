import { requireUser } from "@/lib/auth/rbac";
import { getMyProfile } from "@/lib/profile";
import ProfileForm from "@/components/account/ProfileForm";

export const metadata = { title: "My profile · Transworld PeopleOps" };

function pretty(v: string | null): string {
  if (!v) return "—";
  return v
    .toLowerCase()
    .split("_")
    .map((w) => (w ? w[0].toUpperCase() + w.slice(1) : w))
    .join(" ");
}

function fmtDate(d: Date | null): string {
  if (!d) return "—";
  return d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
}

function statusCls(s: string): string {
  switch (s) {
    case "ACTIVE":
      return "b-grn";
    case "PROBATION":
    case "ON_LEAVE":
      return "b-amb";
    case "SUSPENDED":
    case "EXITED":
      return "b-red";
    default:
      return "b-gry";
  }
}

const rowStyle = {
  display: "grid",
  gridTemplateColumns: "180px 1fr",
  gap: 12,
  padding: "9px 0",
  borderTop: "1px solid var(--line, #eceff3)",
} as const;
const labStyle = { fontSize: 13 } as const;

function Row({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div style={rowStyle}>
      <div className="faint" style={labStyle}>
        {label}
      </div>
      <div>{children}</div>
    </div>
  );
}

export default async function MyProfilePage() {
  const me = await requireUser();
  const p = await getMyProfile(me);

  const e = p.employee;
  const addressLine =
    e && (e.residentialAddress || e.city || e.stateRegion || e.country)
      ? [e.residentialAddress, e.city, e.stateRegion, e.country].filter(Boolean).join(", ")
      : "—";
  const nok =
    e && (e.nokName || e.nokRelationship || e.nokPhone)
      ? `${e.nokName ?? ""}${e.nokRelationship ? ` (${e.nokRelationship})` : ""}${e.nokPhone ? ` · ${e.nokPhone}` : ""}`.trim()
      : "—";

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My profile</h1>
          <p>
            Signed in as <span className="mono">{p.loginEmail}</span>. Your contact details, address
            and next-of-kin are yours to edit; everything else is maintained by HR.
          </p>
        </div>
      </div>

      {!p.linked || !e ? (
        <div className="note">
          <span>ℹ</span>
          <div>
            Your login isn’t linked to an employee record yet. Once HR links it, your details will
            appear here. You can still{" "}
            <a className="jc-link" href="/account/password">
              change your password
            </a>
            .
          </div>
        </div>
      ) : (
        <>
          <div className="card">
            <div className="card-h">
              <h3>Your record</h3>
              <span className={`b ${statusCls(e.status)}`}>{pretty(e.status)}</span>
            </div>
            <div className="card-pad">
              <Row label="Employee ID"><span className="mono">{e.eeId}</span></Row>
              <Row label="Full name">{e.fullName}</Row>
              <Row label="Preferred name">{e.preferredName || "—"}</Row>
              <Row label="Work email">{e.workEmail || "—"}</Row>
              <Row label="Work phone">{e.phone || "—"}</Row>
              <Row label="Department">{e.department || "—"}</Row>
              <Row label="Role">{e.role || "—"}</Row>
              <Row label="Grade">{e.grade || "—"}</Row>
              <Row label="Job family">{pretty(e.family)}</Row>
              <Row label="Track / rung">
                {e.track || e.rung
                  ? `${pretty(e.track)}${e.rung ? ` · ${pretty(e.rung)}` : ""}`
                  : "—"}
              </Row>
              <Row label="Manager">{e.manager || "—"}</Row>
              <Row label="Entity">{e.entity || "—"}</Row>
              <Row label="Employment type">{pretty(e.employmentType)}</Row>
              <Row label="Work location">{pretty(e.workLocation)}</Row>
              <Row label="FTE">{e.fte}</Row>
              <Row label="Start date">{fmtDate(e.startDate)}</Row>
              <Row label="Date of birth">{fmtDate(e.dateOfBirth)}</Row>
              <Row label="Gender">{pretty(e.gender)}</Row>
              <Row label="Marital status">{pretty(e.maritalStatus)}</Row>
              <Row label="Nationality">{e.nationality || "—"}</Row>
              <Row label="Personal email">{e.personalEmail || "—"}</Row>
              <Row label="Personal phone">{e.personalPhone || "—"}</Row>
              <Row label="Address">{addressLine}</Row>
              <Row label="Next of kin">{nok}</Row>
              <Row label="Identification">
                {e.idType ? `${pretty(e.idType)}${e.idNumberMasked ? ` · ${e.idNumberMasked}` : ""}` : "—"}
              </Row>
              <Row label="Bank">
                {e.bankNameMasked || e.bankAcctMasked
                  ? `${e.bankNameMasked ?? ""}${e.bankAcctMasked ? ` · ****${e.bankAcctMasked}` : ""}`.trim()
                  : "—"}
              </Row>
              <Row label="Dependents">
                {e.dependents.length === 0
                  ? "—"
                  : e.dependents
                      .map((d) => `${d.fullName}${d.relationship ? ` (${pretty(d.relationship)})` : ""}`)
                      .join(", ")}
              </Row>
            </div>
          </div>

          <div className="sec-t mt">Edit your details</div>
          <ProfileForm
            defaults={{
              preferredName: e.preferredName ?? "",
              phone: e.phone ?? "",
              personalEmail: e.personalEmail ?? "",
              personalPhone: e.personalPhone ?? "",
              residentialAddress: e.residentialAddress ?? "",
              city: e.city ?? "",
              stateRegion: e.stateRegion ?? "",
              country: e.country ?? "",
              nokName: e.nokName ?? "",
              nokRelationship: e.nokRelationship ?? "",
              nokPhone: e.nokPhone ?? "",
              nokAddress: e.nokAddress ?? "",
            }}
          />
        </>
      )}
    </>
  );
}
