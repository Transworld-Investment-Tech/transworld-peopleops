// Placeholder shown for modules that are gated and reachable now but whose
// full UI is scheduled for a later build phase. Access control already applies.
export default function ComingSoon({ title }: { title: string }) {
  return (
    <>
      <div className="page-h">
        <div>
          <h1>{title}</h1>
          <p>Module scheduled for a later build phase.</p>
        </div>
      </div>
      <div className="note">
        <span>ℹ</span>
        <div>
          <b>Coming soon.</b> This module is part of the planned build sequence.
          Sign-in and server-enforced access control already apply to this
          route — you reached it because your role grants permission.
        </div>
      </div>
    </>
  );
}
