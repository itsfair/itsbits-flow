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
| `lib/screens/profile_screen.dart` | Profile editor: names, birthday, optional JPEG image, email + person id + QR code. Honors `kProfileEditingEnabled` (read-only fallback for mirrors) |
| `lib/widgets/account_dropdown.dart` | AppBar account menu; host-injected login/logout/navigation; avatar from image URL or initials |
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
