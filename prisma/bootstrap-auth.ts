// Idempotent auth bootstrap — the ONLY database-writing step in this module.
// Run explicitly with:  npm run auth:bootstrap
//
// It (a) upserts the permission catalog, (b) maps permissions onto the existing
// seeded roles, and (c) creates exactly one SUPER_ADMIN user from env vars.
// Re-running is safe: it never duplicates rows and never creates a second admin.
// It does NOT run migrations, alter the schema, or touch any seeded HR/payroll
// data — it only adds the access-control rows the app needs to function.
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";
import { readFileSync, existsSync } from "node:fs";
import { resolve } from "node:path";
import { PERMISSIONS, ROLE_PERMISSIONS } from "../lib/permissions";

// Minimal .env loader (no extra dependency) so ADMIN_* values are available
// when this script runs under tsx.
function loadEnv() {
  const p = resolve(process.cwd(), ".env");
  if (!existsSync(p)) return;
  for (const line of readFileSync(p, "utf8").split("\n")) {
    const m = line.match(/^\s*([\w.]+)\s*=\s*(.*?)\s*$/);
    if (!m) continue;
    const k = m[1];
    const v = m[2].replace(/^["']|["']$/g, "");
    if (process.env[k] === undefined) process.env[k] = v;
  }
}
loadEnv();

const prisma = new PrismaClient();

async function main() {
  const email = (process.env.ADMIN_EMAIL || "").trim().toLowerCase();
  const password = process.env.ADMIN_PASSWORD || "";
  const name = process.env.ADMIN_NAME || "Administrator";

  if (!email || !password) {
    throw new Error(
      "Set ADMIN_EMAIL and ADMIN_PASSWORD in .env before running auth:bootstrap."
    );
  }

  // 1) Permission catalog (upsert by unique key).
  for (const p of PERMISSIONS) {
    await prisma.permission.upsert({
      where: { key: p.key },
      update: { label: p.label },
      create: { key: p.key, label: p.label },
    });
  }

  // 2) Role -> permission links (upsert by composite key).
  const allPermKeys = PERMISSIONS.map((p) => p.key);
  for (const [roleKey, perms] of Object.entries(ROLE_PERMISSIONS)) {
    const role = await prisma.role.findUnique({ where: { key: roleKey } });
    if (!role) {
      console.warn(`  ! Role ${roleKey} not found in DB — skipping.`);
      continue;
    }
    const keys = perms === "*" ? allPermKeys : perms;
    for (const pk of keys) {
      const perm = await prisma.permission.findUnique({ where: { key: pk } });
      if (!perm) continue;
      await prisma.rolePermission.upsert({
        where: {
          roleId_permissionId: { roleId: role.id, permissionId: perm.id },
        },
        update: {},
        create: { roleId: role.id, permissionId: perm.id },
      });
    }
  }

  // 3) Bootstrap exactly one SUPER_ADMIN user (idempotent).
  const superAdmin = await prisma.role.findUnique({
    where: { key: "SUPER_ADMIN" },
  });
  if (!superAdmin) {
    throw new Error(
      "SUPER_ADMIN role is missing — run the foundation seed first."
    );
  }

  let user = await prisma.user.findUnique({ where: { email } });
  let created = false;
  if (!user) {
    const passwordHash = await bcrypt.hash(password, 10);
    user = await prisma.user.create({
      data: { email, name, passwordHash, status: "active" },
    });
    created = true;
  }

  await prisma.userRole.upsert({
    where: { userId_roleId: { userId: user.id, roleId: superAdmin.id } },
    update: {},
    create: { userId: user.id, roleId: superAdmin.id },
  });

  await prisma.auditLog.create({
    data: {
      actorId: user.id,
      action: created ? "auth.bootstrap_admin_created" : "auth.bootstrap_ran",
      entityType: "user",
      entityId: user.id,
      metadata: { email },
    },
  });

  const [permCount, rpCount, userCount] = await Promise.all([
    prisma.permission.count(),
    prisma.rolePermission.count(),
    prisma.user.count(),
  ]);

  console.log("Auth bootstrap complete.");
  console.log(`  Admin: ${email} (${created ? "created" : "already existed"})`);
  console.log(
    `  Permissions: ${permCount} · Role-permission links: ${rpCount} · Users: ${userCount}`
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
