import Link from "next/link";
import { requirePermission } from "@/lib/auth/rbac";
import { getSponsorshipFormData } from "@/lib/sponsorship-reads";
import CompTabs from "@/components/compensation/CompTabs";
import SponsorshipForm from "@/components/compensation/SponsorshipForm";

export const metadata = { title: "New sponsorship · Transworld PeopleOps" };

export default async function NewSponsorshipPage() {
  await requirePermission("compensation.manage");
  const data = await getSponsorshipFormData();

  return (
    <>
      <div className="page-h">
        <div>
          <h1 className="serif">New sponsorship</h1>
          <p>Propose a firm-funded professional qualification for an employee (WS6 Part 4).</p>
        </div>
        <Link href="/compensation/sponsorship" className="btn">← Sponsorship</Link>
      </div>

      <CompTabs active="sponsorship" />

      <div className="card">
        <div className="card-h"><h3 className="serif">Sponsorship details</h3></div>
        <div className="card-pad">
          {data.employees.length === 0 ? (
            <div className="note">
              <span>ℹ</span>
              <div>No active employees to sponsor.</div>
            </div>
          ) : (
            <SponsorshipForm employees={data.employees} modules={data.modules} />
          )}
        </div>
      </div>
    </>
  );
}
