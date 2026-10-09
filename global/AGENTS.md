# AGENTS.md — global (Dart workspace: global instance)

This workspace holds the **global instance** — the single central
platform level of itsbits-flow. End users register here (email +
password); user accounts and profiles live here. Repo structure,
domain rules, and conventions: [root AGENTS.md](../AGENTS.md).

## Packages

| Package | What |
|---|---|
| `global_server` | Serverpod backend of the global instance |
| `global_client` | Generated client package (never edited) |
| `global_flutter` | **Platform admin app** (manage the global instance) |
| `enduser_flutter` | **End-user app** (runs on a physical device; not launched by `serverpod start` on the dev machine every time) |

## Purpose (target state)

- Registration/login of end users (email IdP) and password reset.
- Own person/profile model `member_profile` — the data basis the local
  instances synchronize from (site admins, member profiles).
- Platform admin areas: user management (`usersAdmin`), sites
  management (`sitesAdmin`).
- Site connection level: enrollment of local instances
  (`siteEnrollment`) and the device method stream (`siteConnection`).
- Later possibly global entities (e.g. course catalog).

## Ports (dev)

API server 8080, Insights 8081, Web server 8082; Postgres 8090, Redis
8091 (disabled), RustFS S3 9000 / console 9001. DB name `global`.
Details and full stack: root AGENTS.md.

## Flutter apps (dev)

Declared under `serverpod: flutter_apps:` in `global_server/pubspec.yaml`:

- `global` → `global_flutter` (platform admin app)
- `enduser` → `enduser_flutter`

## Target endpoints (own code)

| Endpoint | Purpose |
|---|---|
| `emailIdp` (`src/auth/email_idp_endpoint.dart`) | Email IdP: registration, login, password reset (verification codes are only logged in dev). `onAfterAccountCreated` hook creates the sparse `member_profile` row |
| `jwtRefresh` (`src/auth/jwt_refresh_endpoint.dart`) | Renew access tokens |
| `memberProfile` | Own person endpoints: `get`, `save` (names 1–60 chars + birthday), `setUserImage`, `removeUserImage` |
| `usersAdmin` | Platform admin: `listUsers` (50/page, email/name filter), `getUser`, `setBlocked`, `setGlobalAdmin` |
| `sitesAdmin` | Platform admin, sites: `createSite` (no secrets), `listSites`/`countSites`, `getSite`, `revokeSiteConnection` |
| `siteEnrollment` | Public: `listSiteAdminCandidates` + `enroll({email, password, siteId?})` for the local instance |
| `siteConnection` | Device connection method stream (`connect(Stream<SitePing>) → Stream<SiteEvent>`), scope `site-device` |

## Key design points

- **member_profile** (own person model): `authUser` relation (required;
  sparse row at registration), `email`, `firstName`/`lastName`,
  `birthday` (UTC-midnight sentinel), `imageUrl`, `createdAt`; unique
  index on `authUserId`. Images at `member_images/<authUserId>.jpg`
  (deterministic, overwrite, JPEG-only for now). The built-in Serverpod
  UserProfile feature is bypassed by design.
- **Admin scopes**: `global-admin` scope enforced declaratively via
  `Endpoint.requiredScopes`; scopes are baked into tokens at login —
  `setBlocked`/`setGlobalAdmin` revoke all tokens afterwards. Blocking
  yourself / revoking your own scope is rejected. The **first admin**
  is created manually (SQL: scope on the auth user row) + re-login.
- **Site linkage**: `SiteMembership.profile` FK → `member_profile`
  (membership links the person via the directory, not the auth user).
- **Site setup**: `createSite` generates no secrets — the site admin
  sets up the local instance on site with their global credentials
  (`siteEnrollment.enroll`); device credential = non-rotating SAS
  session key (`method: 'device'`, token-level scope `site-device`,
  pepper `serverSideSessionKeyHashPepper`).
- Auth setup in `lib/server.dart` (`initializeAuthServices`: JWT +
  site-device token manager + EmailIdp incl. the member_profile hook).
- Known harmless log entries with device connections: an
  `Invalid JWT access token` debug line (JWT is the primary token
  manager; the SAS key is validated afterwards by the session manager)
  and a persistent `STREAM siteConnection.connect` entry (the long-lived
  method stream — normal while a site is connected).

## Open work items (this part)

- Protect/limit registration in the platform admin app (end-user
  registration must not be possible there — attempts with blank texts +
  controller subclass did not work; look for another approach).
- Live status push to admin clients instead of 30 s polling
  (cross-cutting, see root AGENTS.md).
- Integration tests for `usersAdmin` endpoints; confirmation dialog on
  block; keep admin endpoints strictly behind `requiredScopes`.
- Add `SERVERPOD_PASSWORD_serverSideSessionKeyHashPepper` to CI test
  workflow; unify CI tool versions.

---

## Serverpod workflow (development)

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `global_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `global_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

### Windows start troubleshooting

Closing the `serverpod start` TUI can leave the watch processes orphaned
(`dart.exe` watcher + compiled `dartvm.exe` of the previous session still
alive, holding the ports and the native-assets DLL
`.dart_tool/serverpod/lib/serverpod_argon2.dll`). A then-started new
`serverpod start` fails at "Running build hooks" with
`PathAccessException ... serverpod_argon2.dll (OS Error: Zugriff
verweigert, errno = 5)`. Fix: end the leftover `dart.exe`/`dartvm.exe`
processes (`Get-NetTCPConnection -State Listen | Where-Object LocalPort -in <ports>`
to find them; or Task Manager), then start again.
