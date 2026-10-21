# AGENTS.md — local (Dart workspace: local site instance)

This workspace holds the **local instance** of itsbits-flow — **one
instance per business/site (door installation)**. Represents the
on-site operation: self-entry (door access) and later ERP features
(course management, employee management, shift scheduling). Must keep
running autonomously during short internet outages. Repo structure,
domain rules, and conventions: [root AGENTS.md](../AGENTS.md).

## Packages

| Package | What |
|---|---|
| `local_server` | Serverpod backend of the local instance |
| `local_client` | Generated client package (never edited) |
| `local_flutter` | **Site admin app** (devices, members, access rights; later ERP areas) |

## Purpose (target state)

- Door access authorization: the ESP32 forwards (BLE-received from the
  end-user app) access data to this instance; verification and door
  control happen here. **Without a cloud round trip** — the instance
  holds the member data it needs locally, synchronized from the global
  instance.
- Person directory `member_profile` (mirror of the global instance's
  model; one row per person of the site).
- Site connection to the global instance (method stream worker).
- Local admin areas behind the `local-admin` login.
- ERP extension step by step: courses, employees, shift scheduling.

## Ports (dev)

API server 8180, Insights 8181, Web server 8182; Postgres 8190, Redis
8191 (disabled), RustFS S3 9200 / console 9201 (host ports differ from
the global instance 9000/9001 so both stacks can run simultaneously;
9100 is avoided — Dart DevTools binds it by default).
DB name `local`. Details and full stack: root AGENTS.md.

## Target endpoints (own code)

| Endpoint | Purpose |
|---|---|
| `emailIdp` (`src/auth/email_idp_endpoint.dart`) | Email IdP: local login only — member self-signup/registration is intentionally off |
| `jwtRefresh` (`src/auth/jwt_refresh_endpoint.dart`) | Renew access tokens |
| `memberProfile` | Own person endpoints (mirror of global): `get`, `save`, `setUserImage`, `removeUserImage` — for locally logged-in persons (site admin/staff) |
| `siteSetup` | `enterSetup({email, password, siteId?})`: verifies the **global credentials** of the site admin against the global instance (via the global client package), processes the transfer (member_profile copy + local `local-admin` login + image) — `adminInfo()`, `connectionStatus()` for the app connection chip |
| `membersAdmin` | Local member directory (read-only, `local-admin` scope): `listMembers` (search/pagination), `countMembers`, `getMember({globalAuthUserId})` — member_profile mirror + `member_membership` mirror (role/active/endedAt) |
| `doorDeviceAdmin` | LAN registry of this site's doorinterface (ESP32) devices (`local-admin` scope): `listDevices`, `addDevice` (+ automatic backend-config push), `updateDevice`, `removeDevice`, `pushConfig` (serverUrl from `localApiUrl` password key + site ID → ESP `/api/backend/config`, ACK stores the device MAC), `testDevice` (`GET /api/status` probe), `unlockNuki`/`lockNuki`/`openNuki` (fixed ESP paths). The HTTP calls to the ESP run SERVER-side (plain HTTP into the LAN, MVP; device auth/TLS = backlog) — no generic proxying |
| `POST /api/door/verify` (web route, `src/web/routes/door_verify_route.dart`) | REST route for the ESPs (plain HTTP, no device auth in the MVP): one call per BLE request `{userKey, code, siteId, deviceMac}` → `{ok, code, message}` with uniform result codes (`OK` / `ACCESS_DENIED` / `RATE_LIMITED` / `CRED_INVALID` / `SERVER_ERROR`) — no information leak about which sub-check failed |
| `doorPolicyAdmin` (`src/door/door_policy_admin_endpoint.dart`) | Access-policy admin (`local-admin` scope): `listPolicies`, `getPolicy`, `createPolicy`/`updatePolicy`/`removePolicy`, `addRule` (weekday multi-select → N rules)/`updateRule`/`removeRule`, `addMemberAssignment` (per-USER validity period, by `globalAuthUserId`)/`updateMemberAssignment`/`removeMemberAssignment`, `listPoliciesFor` |
| `siteAdmin` | Site-properties editing (local-owner rule, reversed vs. profiles; `local-admin` scope): `updateSite`, `setSiteImage`, `removeSiteImage` — strict `connected` gate (no queueing), global `siteDetails.push` runs FIRST (validated there), local snapshot update only after the global push succeeded (fail-closed) |
| `siteSync` (pull side only, in `SiteSyncProcessor`) | Pulls pending member-data deliveries from the global `siteSync` endpoint on every connection event (initial `needsSiteSync` fire, stream pushes, pings as watchdog) and confirms them |

## Key design points

- **member_profile** (symmetric to global): one row per person;
  `authUserId` optional (only site admin/staff have a local login;
  `onDelete=SetNull`), **`globalAuthUserId` required + unique**
  (exchange id, door authorization key, and image-object key),
  mirrored `email`/`firstName`/`lastName`/`birthday`/`imageUrl`.
  Profiles are edited **globally only** — local copies are mirrors.
- **No local self-registration**: local logins are only ever created
  from *verified* global logins — the site admin at setup (local
  AuthUser + email login with the same password, scope `local-admin`,
  linked to the member_profile copy); employees later the same way.
- **Image handling**: `member_images/<globalAuthUserId>.jpg`
  (deterministic, one object per person, overwrite on change,
  JPEG-only). `imageUrl` stores the object PATH; payload assembly
  presigns (`ImageUrlSigner`, private bucket, see root AGENTS.md).
  Enrollment transfers the image **fail-fast** (download from the
  global-signed `imageUrl` first — failure aborts the whole
  enrollment; then DB transaction, then upload into the local RustFS).
  A member→user conversion needs no image move (identical path for
  every person). Flutter web display needs CORS on the local RustFS
  (console :9101).
- **Enrollment transfer**: the bootstrap payload carries the complete
  admin setup — profile fields + `adminDoorCodeSecret` + the
  `deviceSessionKey`. `_processTransfer` creates the local AuthUser +
  login + `member_profile` copy (with secret) **and the
  `member_membership` mirror** (role siteAdmin, active — deterministic,
  the transfer only originates from an active siteAdmin membership).
  Recovery with preserved local data tops up ONLY the door fields
  (secret + mirror) idempotently; person/login stay untouched.
- **Device connection worker** (`GlobalSiteConnection`, started in
  `server.dart`): connects to the global instance with the
  non-rotating SAS session key (`method: 'device'`), method stream
  `siteConnection.connect`, ping every 30 s (keeps global
  `lastSeenAt` fresh); reconnect with backoff (5→60 s); state machine
  `noneSetup|connecting|reconnecting|connected|needsReSetup|failure`
  (`needsReSetup` = revoked/expired → re-run setup with global
  credentials). Config: `globalApiUrl` password key in
  `config/passwords.yaml` (dev: `http://localhost:8080`; devices:
  LAN IP; env override `SERVERPOD_PASSWORD_globalApiUrl`).
- **Member sync** (`SiteSyncProcessor`, triggered on every connection
  event): pulls the pending batch (one payload per person; bytes apply
  as an idempotent upsert — at-least-once). Fresh member: fail-fast
  image transfer (enrollment principle); existing member: text fields
  always applied, image best-effort overwrite/removal at the same
  deterministic path; task confirmed only on full success (failed stays
  pending, retried at the next ping). Deactivations mirror
  `active=false`/`endedAt` — person data kept. Local membership mirror
  table: `member_membership` (one membership per person, role, active,
  endedAt).
- **Site data is edited LOCALLY only** (reversed rule vs. member
  profiles, which are global-only): the "Standort" editor (shared
  `SiteDetailsEditorScreen`) saves through `siteAdmin`; the update is
  pushed to the global instance first (device credential,
  server-to-server) and applied to the `site_connections` snapshot on
  success only. The site image lives at `site_images/<siteId>.jpg` on
  BOTH RustFS buckets (global for end-user/admin display, local mirror
  for offline-capable display; deterministic, overwrite).
- **Door access (offline)**: the ESP posts verification requests to the
  `/api/door/verify` web route; `DoorAccessVerifier` (`src/door/`)
  checks the member mirror (`globalAuthUserId` → `doorCodeSecret`) and
  the membership mirror (`active`), then the door-bound TIMESTAMP code
  (shared `itsbits_shared/door_code.dart`: HMAC-SHA256 over
  `<ms-since-epoch>:<normalizedMac>`; every request is unique —
  unlimited frequency/instant retries/multiple doors, NO slots; valid
  ±30 s skew, distinct `timeSkew` result) — single-use via the
  `door_access_consumed` table (unique user+timestamp, race-safe,
  15 min retention pruning, consumed AFTER the policy check so denials
  never burn a code), per-user rate limit (5 denied/min, fed from the
  log; `timeSkew` does NOT feed it), every attempt logged to
  `door_access_logs` (audit + statistics). The member sync carries the
  per-(person, site) secrets
  (`SiteSyncMember.doorCodeSecret` → `member_profile.doorCodeSecret`).
- **Access policies (deny-by-default)**: WITHOUT an active assignment
  nobody may open any door (also the site admin). `access_policies`
  (name only) + `access_policy_rules` (door `DoorDevice?` null=all
  doors, weekday 0=Mo..6=So, `startMinute`/`endMinute` minutes of
  SERVER-LOCAL time; end exclusive, 1440 = midnight end; NO overnight
  wrap — an overnight window is two rules) + `access_policy_members`
  (assignment with per-USER validity `validFrom`/`validUntil?`, unique
  policy+user). Verifier resolves the door by normalized MAC
  (`door_devices.mac`, stored normalized at config push) and
  OR-combines all assignments; grants/denials are logged with the
  reason (`policy <id>` / `no active policy assignment` / `outside
  policy window` / `unknown device`). Uniform `ACCESS_DENIED` to the
  device. Future courses plug in as additional policy sources (the
  member-link table is the seam).
- Birthday as UTC-midnight date sentinel (no server-side
  re-normalization) — see root AGENTS.md.
- **Door devices MVP** (`src/door/`, table `door_devices`, one row per
  ESP): manually managed LAN registry — the admin enters name + address
  (`host[:port]`, scheme stripped) in the Selbsteinlass screen; address
  is unique. The backend performs the ESP HTTP calls itself
  (`Uri.http(address, path)`, 5 s timeout): `/api/status` probe parsed
  losslessly into `DoorDeviceStatus`, NUKI actions are fixed paths
  (`/api/nuki/unlock|lock|open`), results are plain `{ok, error}`
  statuses, never exceptions (network errors are folded into the result).
  App side: shared `DoorDeviceApi` contract + status card + add/edit
  dialog (`itsbits_shared`), adapter `local_flutter/lib/
  door_device_api.dart`, list `/self-entry/locks` + detail
  `/self-entry/locks/:id` (confirm dialogs before every NUKI action,
  direct link to the ESP web UI via `url_launcher`).
- **Admin app shell state machine**: the setup mask (`/setup`) is forced
  while the connection is `noneSetup`/`needsReSetup` (drawer + login
  dropdown hidden; banner shows the reason: first setup vs. corrupted
  credential). Enrolled + signed out → `/sign-in`; signed in → free
  navigation (staff scopes come with the employees flow). The profile
  screen uses the SHARED `ProfileScreen` with `editingEnabled: false`
  (read-only; the id field carries the `globalAuthUserId` door key for
  the QR). The built-in Serverpod UserProfile feature is bypassed (the
  auth module still writes its own profile tables internally — unused).

## Open work items (this part)

- **Membership sync over the connection**: core propagation (new
  members, profile updates, deactivation markers) IS implemented via
  `SiteSyncProcessor`. Remaining: staff/admin role switch → local login
  (analyzed with the employees flow); roles/status reporting back to
  global via `site-device`-restricted endpoints.
- **Protection layer**: THREE endpoints enforced now — `membersAdmin`,
  `siteAdmin` and `doorDeviceAdmin` are scope-checked (`local-admin`);
  the shell hides drawer/dropdown during setup states. Remaining: apply
  the same enforcement to further member/employee admin endpoints as
  they are added.
- **Employees flow**: member verifies on site with global credentials →
  local login (same model as the admin setup).
- **Password self-healing**: "same password globally + locally" — the
  local copy's password is derived from the *verified* global login;
  define behavior on global password change.
- ~~Encryption at rest for the stored device session key~~ DONE (this
  session): `SiteConnectionSecrets` (`src/site/`) stores
  `deviceSessionKey` as AES-256-GCM ciphertext (`enc:v1...`); key via
  the `siteDeviceKeyCipherPassword` password key (set in production);
  legacy plaintext rows pass through on read and re-encrypt on the
  next enrollment write. Regression-tested in
  `site_connection_secrets_test.dart`.

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

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `local_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

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

The app is launched from `local_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

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
