// Supabase Storage wrapper (server-only). Uses the service-role key, so this
// module must never be imported into client components. Mirrors the lib/db
// singleton style. All access to stored files goes through here: server-side
// upload, short-lived signed-URL download, and delete. The bucket is private.
import { createClient, type SupabaseClient } from "@supabase/supabase-js";

const url = process.env.SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

/** Bucket name (override with SUPABASE_STORAGE_BUCKET). */
export const STORAGE_BUCKET = process.env.SUPABASE_STORAGE_BUCKET ?? "peopleops";

/** True when the storage env vars are present, so callers can degrade gracefully. */
export function storageConfigured(): boolean {
  return Boolean(url && serviceKey);
}

let _client: SupabaseClient | null = null;
function client(): SupabaseClient {
  if (!url || !serviceKey) {
    throw new Error(
      "Supabase Storage is not configured. Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY."
    );
  }
  if (!_client) {
    _client = createClient(url, serviceKey, { auth: { persistSession: false } });
  }
  return _client;
}

/** Upload (overwrite) an object at `path`. */
export async function putObject(
  path: string,
  body: Buffer | Uint8Array,
  contentType?: string
): Promise<void> {
  const { error } = await client()
    .storage.from(STORAGE_BUCKET)
    .upload(path, body, { contentType: contentType || "application/octet-stream", upsert: true });
  if (error) throw new Error(`Storage upload failed: ${error.message}`);
}

/** A short-lived signed URL for downloading a private object. */
export async function signedUrl(path: string, expiresInSeconds = 120): Promise<string> {
  const { data, error } = await client()
    .storage.from(STORAGE_BUCKET)
    .createSignedUrl(path, expiresInSeconds);
  if (error || !data) {
    throw new Error(`Could not create signed URL: ${error?.message ?? "unknown error"}`);
  }
  return data.signedUrl;
}

/** Best-effort delete; callers may ignore failures during cleanup. */
export async function removeObject(path: string): Promise<void> {
  const { error } = await client().storage.from(STORAGE_BUCKET).remove([path]);
  if (error) throw new Error(`Storage delete failed: ${error.message}`);
}
