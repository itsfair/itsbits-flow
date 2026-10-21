# AGENTS.md — itsbits-flow (repo root)

This repo holds the complete itsbits-flow system: two Serverpod backends
with their Flutter clients, the end-user app, and (at `doorinterface/`)
the ESP32 firmware for the door hardware. Every instance and project
part has its own AGENTS.md with the part's details (purpose, endpoints,
open work items). This root file holds the **global structure and
conventions** — wherever a session starts, this is the entry point.

**Answer language:** the user writes in German; agents answer in chat in
**English**. All AGENTS.md files and docs are written in English.

## What is itsbits-flow? (short version)

Digital door access solution ("self-entry" via NUKI smart locks
controlled by an ESP32; smartphone clients connect over BLE), being
extended into an ERP system for businesses.

- **Global instance** — the single central platform level. End users
  register here (email/password); user accounts and profiles live here.
- **Local instance** — one per business/site (door installation).
  Represents the business: door access (self-entry), later ERP features
  (course management, employee management, shift scheduling). Must keep
  running autonomously during short internet outages.
- **Interplay** — a user becomes a member of a business globally
  (registration) and locally (enrollment/enrollment-sync); the local
  instance receives the user data it needs, synchronized from the global
  instance.

Target flow "self-entry" (end user is a member of a local instance):
scan the QR code at the location → request OTP → send OTP over BLE to
the ESP32 → ESP32 forwards to the local instance → the instance checks
the access data → door unlocks via NUKI. Door access works **without a
cloud round trip** (BLE + local instance suffice); securing that path
(OTP origin, synchronization) is a long-term goal.

## Domain rules (target state)

- **Person model = own `member_profile` model on BOTH instances**
  (uniform shape). The built-in Serverpod UserProfile feature is
  bypassed on both sides; profiles are edited **globally only** (sync
  rule) — local copies are mirrors.
- Global `member_profile`: required auth link; row is created **sparse
  at registration** via the `EmailIdpConfig.onAfterAccountCreated` hook.
  Local `member_profile`: optional auth link (only site admin/staff have
  local logins) + required unique `globalAuthUserId` (exchange id, door
  authorization key, and image-object key).
- **No local self-registration** — local logins are only ever created
  from verified global logins (site admin at setup; employees later via
  the local admin).
- **Images**: `member_images/<globalAuthUserId>.jpg` in each instance's
  RustFS — deterministic paths, one object per person, overwrite on
  change, fail-fast transfer at enrollment.
- **Birthday convention**: values travel as UTC-midnight date sentinels
  (`DateTime.utc(y, m, d)`); the backend validates against UTC calendar
  days only — no server-side re-normalization.
- Site device connections use a **non-rotating SAS session key**
  (`method: 'device'`, token-level scope `site-device`, pepper
  `serverSideSessionKeyHashPepper` in `config/passwords.yaml`).

## Layout

| Path | What | Purpose | Own AGENTS.md |
|---|---|---|---|
| `global/` | Global-instance packages | `global_server` (backend), `global_client` (generated), `global_flutter` (platform admin app), `enduser_flutter` (end-user app, runs on a physical device) | [`global/AGENTS.md`](global/AGENTS.md) |
| `local/` | Local-site-packages | `local_server` (backend), `local_client` (generated), `local_flutter` (site admin app) | [`local/AGENTS.md`](local/AGENTS.md) |
| `shared/` | Shared Dart package | Client-agnostic Flutter/UI building blocks and shared logic for both instances; never imports `global_client`/`local_client` types (clients arrive injected) | [`shared/AGENTS.md`](shared/AGENTS.md) |
| `doorinterface/` | ESP32 firmware (PlatformIO/Arduino) | Door control: NUKI BLE, Wi-Fi setup via captive portal, web interface, BLE peripheral for the end-user app, OTA | [`doorinterface/AGENTS.md`](doorinterface/AGENTS.md) |

- All Dart/Flutter packages live in **one workspace** (`pubspec.yaml` at
  the repo root; `dart pub get` there). `shared/` is created when the
  shared components are ported — its AGENTS.md documents the
  client-agnostic pattern.

- `global_client` / `local_client` are generated packages — never edit
  them; change `.spy.yaml` models / endpoints / `lib/server.dart` and
  regenerate.
- The local backend verifies global site-admin credentials during site
  setup — it depends on the `global_client` package (relative path
  dependency into the same workspace).
- **Logo contract** (this session): the brand logo lives ONCE at
  `shared/assets/logo.svg` (package asset
  `packages/itsbits_shared/assets/logo.svg`, rendered via the shared
  `AppLogo` widget) and serves ALL instance apps; a PNG export at
  `global_server/assets/logo.png` is embedded into verification emails
  (see `global/AGENTS.md`, "SMTP verification emails"). For the local
  server no email/logo wiring exists yet (it still uses the
  Serverpod-Cloud email config — self-hosted production there cannot
  send; swap it to the same EmailSender pattern when needed).

## Infrastructure (dev)

Full Docker setup per workspace: Postgres + Redis + RustFS via the
server's `docker-compose.yaml` (start with `serverpod start` or
`docker compose up --build --detach`).

| | global | local |
|---|---|---|
| API server | 8080 | 8180 |
| Insights | 8081 | 8181 |
| Web server | 8082 | 8182 |
| Postgres | 8090 | 8190 |
| Redis | 8091 (disabled) | 8191 (disabled) |
| RustFS S3 / console | 9000 / 9001 | 9200 / 9201 |

- DB names: `global` and `local`. Both stacks can run simultaneously
  (the local RustFS console uses 9101 to avoid a collision).
- **Tests need no Docker**: `config/test.yaml` sets
  `database.dataPath`, so Serverpod starts and manages the test database
  (embedded PostgreSQL) itself; just run `dart test` in the server
  package.
- File storage: RustFS (S3 API), bucket `itsbits-flow`, credentials
  `rustfsadmin / rustfsadmin_secret` (defaults of the
  `serverpod_cloud_storage_rustfs` adapter). The **endpoint**
  (scheme/host/port of the S3 API) is a deployment value and travels
  via the `rustFsEndpoint` password key in `config/passwords.yaml`
  (`shared:` block) — override chain in `lib/server.dart`:
  `SERVERPOD_RUSTFS_ENDPOINT` env var > password file > local default
  (global `:9000`, local `:9200`; local avoids 9100 — Dart DevTools
  binds it by default). Dev password value: LAN IP of the
  dev machine so tests from real devices work. Credentials/bucket can
  also be overridden via `SERVERPOD_RUSTFS_ACCESS_KEY/SECRET_KEY/BUCKET`.
  **Do not set `publicHost`** — keep the adapter's default URL scheme
  (`{baseUri}/{bucket}/{path}`). Flutter web access to files needs CORS
  on the bucket. RustFS stays LAN-only (never expose the ports).

## Toolchain requirements

- Dart SDK `^3.12.2` (workspace constraint; locally installed 3.13.4),
  Flutter 3.47.5, Serverpod 4.0.3 (CLI globally 4.0.3 as well).
- Firmware: PlatformIO (`pio` CLI) — see `doorinterface/AGENTS.md`.
- Check installed versions before work (`dart --version`,
  `flutter --version`, `serverpod --version`).
- Agent tooling: one `opencode.json` at the repo root registers **two**
  Serverpod MCP servers (`serverpod_global` → `global/global_server`,
  `serverpod_local` → `local/local_server`) plus the `dart` MCP.
- Git hygiene: `.dart_tool/` (root AND nested workspaces) and
  `devtools_options.yaml` are **ignored** (committed once as build
  artifacts by accident; untracked since). On a fresh clone run
  `dart pub get` (workspace root) — the toolchain regenerates all
  `.dart_tool` state itself. Team/agent configs (`.vscode/launch.json`,
  `tasks.json`, `opencode.json`) ARE tracked on purpose.

## General conventions

- Agents answer in chat in **English** (user writes German).
- Never edit generated code (`lib/src/generated/**`, `*_client`
  packages); change models/endpoints and regenerate instead.
- No auto-commits — `git commit` only on explicit user request. Commits
  per sub-package are fine; avoid cross-package commits.
- No comments in code (by agreement), except where semantics require.
- After changes: `dart analyze`, `dart format`, migrations via the
  Serverpod MCP if needed, `dart test` — see the per-workspace AGENTS.md
  checklists.

## Open work items (cross-cutting roadmap)

1. **Membership sync over the method stream**: core propagation is
   IMPLEMENTED (global `site_sync_tasks` queue + real-time stream push;
   local `SiteSyncProcessor` pulls at every connection event; new
   member/profile updates/deactivation markers incl. image mirroring at
   the identical `member_images/<globalAuthUserId>.jpg` paths; local
   `member_membership` role/active mirror). Remaining: staff switch →
   local login (employees flow); roles/status reported back via
   `site-device`-restricted endpoints.
2. **Live status push** to the admin clients (message central) instead
   of 30 s polling in the global sites list.
3. **Profile-editing sync**: IMPLEMENTED for the global→local direction
   (profiles are edited globally only — all global edits enqueue into
   `site_sync_tasks` and reach every subscribed site with the next
   connection; real-time when online). The local-side settings (image
   upload, site details) stay local for now.
4. **Local protection layer**: STARTED — the local `membersAdmin`
   endpoint is scope-enforced (`local-admin`); the shell hides
   drawer/dropdown during setup states. Remaining: apply the same
   enforcement to further member/employee admin endpoints as they are
   added.
5. **Employees flow**: member verifies on site with global credentials →
   local login created (same model as admin setup); membership role
   must be adjusted when a member receives a local login.
6. **Site editor/roadmap**: edit/delete site, memberships view per site;
   "same password globally + locally" — the local copy is created at the
   *verified* global login (self-healing on password change). Site
   deletion must also drop that site's `site_sync_tasks` rows.
7. **Security hardening / GDPR**: ABOVE ALL — the subscription consent
   text (`shared/lib/screens/membership_terms_dialog.dart`) is a plain
   draft; needs a proper GDPR review (Arts. 13/14 information duties,
   deletion concepts per Art. 17 — subscriptions currently keep data
   after deactivation on PURPOSE, document this), re-check on every data
   set change. Plus: presigned/short-lived image URLs for the enrollment
   transfer instead of raw capability URLs; enforce HTTPS for all
   transfers in production; rotate S3 credentials before production;
   encryption at rest for the local `site_connections` row.
8. **ESP32 ↔ backend protocol**: DECIDED + implemented: the ESP is a
   plain HTTP client on demand — one `POST /api/door/verify` per BLE
   request against the local web server (custom REST route, no Serverpod
   protocol), config pushed from the local registry
   (`doorDeviceAdmin.pushConfig` on add + manual re-push). Rolling door
   codes (reworked this session to TIMESTAMP-based): per-(person, site)
   secret (global issues at subscribe/reactivate, travels via member
   sync, cached in the end-user app's secure storage) → app computes the
   code OFFLINE from a FRESH millisecond timestamp
   (HMAC over `<ms>:<doorMAC>` — every request unique: unlimited
   frequency, instant retries, multiple doors; NO time slots), local
   verifies offline (±30 s skew + distinct TIME_SKEW code, single-use
   per (user, timestamp) consumed AFTER the policy check, per-user rate
   limit, `door_access_logs` audit). Remaining hardening (one package):
   device auth/token, TLS or HMAC challenge, ESP web interface auth,
   BLE GATT encryption.
9. **Disable registration in the platform admin app**: DONE — the
   admin apps use the shared login-only sign-in screen
   (`shared/lib/screens/sign_in_screen.dart`, no sign-up affordances);
   end-user registration stays in the end-user app's full
   `SignInWidget`.
10. **flutter_blue_plus license**: RESOLVED (this session) — the
    end-user app switched to `bluetooth_low_energy` (Apache-2.0, no
    license gate); flutter_blue_plus is fully removed.
11. **Access policies / time windows**: DONE (this session, local
    instance): deny-by-default policy layer (`access_policies` +
    `access_policy_rules` door×weekday×minute-window + 
    `access_policy_members` per-user validity), enforced in
    `DoorAccessVerifier`, admin UI under the drawer section
    "Selbsteinlass" (`/self-entry/policies`, routes all English:
    `/self-entry` = Check-ins overview placeholder, `/self-entry/locks`,
    `/self-entry/policies`). Next step: COURSES (local ERP feature) —
    course enrollment creates/links policy assignments so participants
    gain door windows; the `access_policy_members` table is the seam.
11. **Site-image upload**: DONE (this session) — implemented at the
    LOCAL instance and pushed to the global backend (reversed sync
    direction; strict "connected only" rule, no queueing): the "Standort"
    editor (`shared/lib/screens/site_details_editor.dart` + local
    `siteAdmin` endpoint) updates fields + image
    (`site_images/<siteId>.jpg` on both buckets). The end-user app and
    the global admin display render the image automatically.
12. **SiteSyncNotifier scaling**: the real-time push registry is
    in-process (dev: single server instance); multi-instance production
    needs a message bus (Redis pub/sub).
13. **SiteSync task retry cap**: task rows survive failed applications
    indefinitely (retried on every ping); add an attempt cap + alarm
    (log/notify) before production.
14. **Site block/delete**: currently only `revokeSiteConnection`
    (forces re-setup). An explicit global admin "block" (queue-only, no
    re-setup) and "delete" (mark + drop queue rows) feature is planned.
15. **Image cache-busting (OBSERVED in testing, fix pending)**:
    image URLs are deterministic without a version — after an overwrite
    the browser/Flutter `ImageCache` keeps serving the OLD picture
    (profile AND site images; the storage bytes are replaced correctly).
    Fix: append `?v=<epochMs>` on every image write
    (`memberProfile.setUserImage` global, `siteDetails.push` image path,
    local `siteAdmin.setSiteImage`) so each change yields a NEW URL.
    Related/observed in the same manual test: the global `sites.imageUrl`
    ended up NULL after a fields-only push although the object still
    exists in both buckets — suspected deserialization/copyWith edge in
    the `siteDetails.push` fields-only path (all 16 logged pushes returned
    success). Fix: only touch `imageUrl` in the row update when an image
    change is intended (avoid the explicit same-value write), verify with
    integration tests for the push order (fields-only after image, image
    after fields), investigate further if the test does not reproduce.

Part-specific backlogs live in the workspace/instance AGENTS.md files
(`global/AGENTS.md`, `local/AGENTS.md`, `doorinterface/AGENTS.md`).
