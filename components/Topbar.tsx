// Server component. Replaces the prototype "Viewing as…" switcher with the
// real signed-in identity, a link to change your own password, and a working
// sign-out backed by a server action.
import Link from "next/link";
import { logoutAction } from "@/lib/auth/actions";
import { ROLE_LABELS } from "@/lib/permissions";

function initialsOf(name: string): string {
  return (
    name
      .split(/\s+/)
      .filter(Boolean)
      .map((s) => s[0])
      .slice(0, 2)
      .join("")
      .toUpperCase() || "?"
  );
}

export default function Topbar({
  name,
  roleKeys,
}: {
  name: string;
  roleKeys: string[];
}) {
  const roleText =
    roleKeys.map((k) => ROLE_LABELS[k] ?? k).join(" · ") || "No role assigned";
  return (
    <header className="topbar">
      <div className="crumb">
        <b>Transworld PeopleOps</b> · Control Room
      </div>
      <div className="topbar-right">
        <div className="who">
          <div className="avatar">{initialsOf(name)}</div>
          <div className="who-meta">
            <div className="who-name">{name}</div>
            <div className="who-roles">{roleText}</div>
          </div>
        </div>
        <Link className="btn" href="/account/profile">
          My profile
        </Link>
        <Link className="btn" href="/account/password">
          Change password
        </Link>
        <form action={logoutAction}>
          <button className="btn" type="submit">
            Sign out
          </button>
        </form>
      </div>
    </header>
  );
}
