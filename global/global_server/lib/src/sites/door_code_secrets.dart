/// TOTP door-code secret handling for the site membership rows.
///
/// One random secret per (person, site): the end-user app computes the
/// rolling code from it (HMAC over time step + door MAC, see the shared
/// `door_code` helpers), the local instance verifies offline against the
/// mirrored copy. The secret is generated when a membership is created
/// or reactivated — and lazily during sync pulls for legacy rows
/// (self-healing backfill, no dedicated migration run needed).
library;

import 'dart:math';

/// Generates a new random secret (hex-encoded, 32 bytes).
String generateDoorCodeSecret() {
  final random = Random.secure();
  return List<int>.generate(
    32,
    (_) => random.nextInt(256),
  ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}
