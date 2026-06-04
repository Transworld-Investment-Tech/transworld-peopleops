import { requireUser } from "@/lib/auth/rbac";
import { helpIndexBySection } from "@/lib/help";
import HelpSearch from "./HelpSearch";

export const metadata = { title: "Help · Transworld PeopleOps" };

// Shell-level page: the (app) layout already enforces sign-in via requireUser(),
// so /help needs no extra permission. The CONTENT is filtered to what this user
// can reach, mirroring the sidebar.
export default async function HelpIndexPage() {
  const me = await requireUser();
  const groups = helpIndexBySection(me.permissions);

  return (
    <>
      <div className="page-h">
        <div>
          <h1>Help</h1>
          <p>
            A guide to every page you can reach — what it&apos;s for, who can use it, what the actions
            do, and the things to watch. Press the <b>?</b> on any page for help on that page.
          </p>
        </div>
      </div>
      <HelpSearch groups={groups} />
    </>
  );
}
