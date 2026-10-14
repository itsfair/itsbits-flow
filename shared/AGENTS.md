# AGENTS.md — shared package (`itsbits_shared`)

Client-agnostic Flutter components shared by the frontends of both
instances (end-user app, global admin app, later the local site admin
app). Repo context: [root AGENTS.md](../AGENTS.md).

## The pattern (IMPORTANT)

This package must **never import** `global_client`/`local_client`
types — the two generated clients are completely independent packages;
their same-named model classes (e.g. `MemberProfile`) are different
Dart types. The backend **contract** is what is shared: every instance
maintains `member_profile` endpoints with identical method signatures.

Components get backend access **injected**:

- `MemberProfileApi` (interface, `lib/profile_state.dart`) +
  `MemberProfileData` (plain struct): each app implements the interface
  against its own generated client (~20 lines, one adapter file) and
  passes it at construction time.
- Widgets (`ProfileScreen`, `AccountDropdown`) receive plain
  parameters/callbacks only — no client anywhere.

Client plain-fields (image URL, names, birthday) travel as
`String?`/`DateTime?` in `MemberProfileData`; **model-typed calls**
(do NOT go into this package) belong to the app that owns them.

## Contents

| File | What |
|---|---|
| `lib/profile_state.dart` | `MemberProfileData`, `MemberProfileApi`, `ProfileState` (ChangeNotifier; load/update/reset, `isComplete`) |
| `lib/screens/profile_screen.dart` | Profile editor: names, birthday, optional JPEG image, email + person id + QR code. `editingEnabled` parameter (default `true`): mirrors (local app) run it read-only — profiles are edited globally only |
| `lib/screens/sign_in_screen.dart` | Login-only email/password form (NO sign-up affordances by design) + `EmailSignInApi` (host adapter: `emailIdp.login` + **`client.auth.updateSignedInUser`** — the plain endpoint call does NOT store the session). Used by local site admin app + global platform admin app (no registration in admin apps) |
| `lib/widgets/account_dropdown.dart` | AppBar account menu; host-injected login/logout/navigation; avatar from image URL or initials |
| `lib/site_directory.dart` | `SiteData` (+ optional `statusLabel`), `MyMembershipData`, `SiteDirectoryApi` (injected backend contract: browse anonymously ok, subscribe/unsubscribe auth'd), `SiteMembershipState` |
| `lib/widgets/site_card.dart` | `SiteImage` (placeholder fallback), `SiteCard` (image header + online/setup chip) |
| `lib/widgets/site_carousel.dart` | Horizontal "newest sites" section for home screens |
| `lib/screens/site_list_screen.dart` | Full list: debounced search, pagination, grid of `SiteCard`s; optional host FAB |
| `lib/screens/site_detail_body.dart` | Shared site detail display body (image/chip/address/contact) |
| `lib/screens/site_details_editor.dart` | Site-properties editor (fields + JPEG image) + `SiteDetailsApi` (get/save/setSiteImage/removeSiteImage) — the local app's "Standort" page; connectivity gating is server-side |
| `lib/screens/membership_terms_dialog.dart` | DSGVO consent dialog before subscribing (default German draft text; hosts may not override yet) |
| `lib/shared_flags.dart` | `kProfileEditingEnabled` (package-level default; hosts overrule by not wiring editing) |

## Conventions

- Birthday values travel as UTC-midnight sentinels
  (`DateTime.utc(y, m, d)`) — no server-side re-normalization.
- Profile data is fetched through `ProfileState`; hosts drive
  `load()`/`reset()` from their auth listeners.
- Keeping this package lints-clean: `dart analyze` from the package
  directory works like any workspace member.
- BLE apps: `flutter_blue_plus` (end-user app) requires a `License` at
  `device.connect()` — currently `License.nonprofit`; the production
  license decision is root-AGENTS backlog item 10.
