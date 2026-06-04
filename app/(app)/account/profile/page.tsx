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

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">My profile</h1>
          <p>
            Signed in as <span className="mono">{p.loginEmail}</span>. Your preferred name and
            phone are yours to edit; everything else is maintained by HR.
          </p>
        </div>
      </div>

      {!p.linked || !p.employee ? (
        <div className="note">
          <span>ℹ</span>
          <div>
            Your login isn’t linked to an employee record yet. Once HR links it, your details
            will appear here. You can still{" "}
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
              <span className={`b ${statusCls(p.employee.status)}`}>{pretty(p.employee.status)}</span>
            </div>
            <div className="card-pad">
              <Row label="Employee ID">
                <span className="mono">{p.employee.eeId}</span>
              </Row>
              <Row label="Full name">{p.employee.fullName}</Row>
              <Row label="Preferred name">{p.employee.preferredName || "—"}</Row>
              <Row label="Work email">{p.employee.workEmail || "—"}</Row>
              <Row label="Phone">{p.employee.phone || "—"}</Row>
              <Row label="Department">{p.employee.department || "—"}</Row>
              <Row label="Role">{p.employee.role || "—"}</Row>
              <Row label="Grade">{p.employee.grade || "—"}</Row>
              <Row label="Job family">{pretty(p.employee.family)}</Row>
              <Row label="Track / rung">
                {p.employee.track || p.employee.rung
                  ? `${pretty(p.employee.track)}${p.employee.rung ? ` · ${pretty(p.employee.rung)}` : ""}`
                  : "—"}
              </Row>
              <Row label="Manager">{p.employee.manager || "—"}</Row>
              <Row label="Entity">{p.employee.entity || "—"}</Row>
              <Row label="Employment type">{pretty(p.employee.employmentType)}</Row>
              <Row label="FTE">{p.employee.fte}</Row>
              <Row label="Start date">{fmtDate(p.employee.startDate)}</Row>
              <Row label="Bank">
                {p.employee.bankNameMasked || p.employee.bankAcctMasked
                  ? `${p.employee.bankNameMasked ?? ""}${
                      p.employee.bankAcctMasked ? ` · ****${p.employee.bankAcctMasked}` : ""
                    }`.trim()
                  : "—"}
              </Row>
            </div>
          </div>

          <div className="sec-t mt">Edit your details</div>
          <ProfileForm
            defaults={{
              preferredName: p.employee.preferredName ?? "",
              phone: p.employee.phone ?? "",
            }}
          />
        </>
      )}
    </>
  );
}
