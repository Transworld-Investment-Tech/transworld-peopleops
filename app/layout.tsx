import "./globals.css";
import { fontVars } from "./fonts";

export const metadata = {
  title: "Transworld PeopleOps Portal",
  description:
    "HR, payroll-control and compliance-evidence control room for Transworld Investment & Securities Limited.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={fontVars}>
      <body>{children}</body>
    </html>
  );
}
