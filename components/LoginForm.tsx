"use client";
import { useActionState } from "react";
import { loginAction, type LoginState } from "@/lib/auth/actions";

const initial: LoginState = {};

export default function LoginForm() {
  const [state, action, pending] = useActionState(loginAction, initial);
  return (
    <form action={action} className="login-form">
      {state.error ? <div className="login-err">{state.error}</div> : null}
      <label className="login-label" htmlFor="email">
        Work email
      </label>
      <input
        id="email"
        name="email"
        type="email"
        autoComplete="username"
        required
        className="login-input"
        placeholder="you@transworld.com.ng"
      />
      <label className="login-label" htmlFor="password">
        Password
      </label>
      <input
        id="password"
        name="password"
        type="password"
        autoComplete="current-password"
        required
        className="login-input"
        placeholder="••••••••"
      />
      <button className="btn btn-pri login-btn" type="submit" disabled={pending}>
        {pending ? "Signing in…" : "Sign in"}
      </button>
    </form>
  );
}
