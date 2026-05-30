// Dependency-free signed-cookie sessions using Node's built-in crypto.
// A session token is base64url(JSON payload) + "." + base64url(HMAC-SHA256).
// No third-party session library is added, keeping Vercel builds clean.
import { cookies } from "next/headers";
import crypto from "node:crypto";

const COOKIE = "tw_session";
const MAX_AGE = 60 * 60 * 8; // 8 hours

function secret(): string {
  const s = process.env.SESSION_SECRET;
  if (!s || s.length < 16) {
    throw new Error(
      "SESSION_SECRET is missing or too short. Add a long random value to .env (and to the Vercel environment) before signing in."
    );
  }
  return s;
}

type Payload = { uid: string; iat: number; exp: number };

function sign(data: string): string {
  return crypto.createHmac("sha256", secret()).update(data).digest("base64url");
}

export function createToken(uid: string): string {
  const now = Math.floor(Date.now() / 1000);
  const payload: Payload = { uid, iat: now, exp: now + MAX_AGE };
  const body = Buffer.from(JSON.stringify(payload)).toString("base64url");
  return `${body}.${sign(body)}`;
}

export function verifyToken(token: string | undefined | null): Payload | null {
  if (!token) return null;
  const [body, sig] = token.split(".");
  if (!body || !sig) return null;
  const expected = sign(body);
  const a = Buffer.from(sig);
  const b = Buffer.from(expected);
  if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) return null;
  try {
    const payload = JSON.parse(
      Buffer.from(body, "base64url").toString("utf8")
    ) as Payload;
    if (!payload?.uid || !payload?.exp) return null;
    if (payload.exp < Math.floor(Date.now() / 1000)) return null;
    return payload;
  } catch {
    return null;
  }
}

export async function setSessionCookie(uid: string): Promise<void> {
  const store = await cookies();
  store.set(COOKIE, createToken(uid), {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    path: "/",
    maxAge: MAX_AGE,
  });
}

export async function clearSessionCookie(): Promise<void> {
  const store = await cookies();
  store.set(COOKIE, "", {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    path: "/",
    maxAge: 0,
  });
}

export async function readSessionUid(): Promise<string | null> {
  const store = await cookies();
  const token = store.get(COOKIE)?.value;
  return verifyToken(token)?.uid ?? null;
}
