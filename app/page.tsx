import { redirect } from "next/navigation";

export default function Home() {
  // The authenticated layout will bounce unauthenticated visitors to /login.
  redirect("/dashboard");
}
