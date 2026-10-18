import 'package:itsbits_shared/door_code.dart' as door_code;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Verifies one door-access attempt fully offline: member mirror +
/// membership activity + TOTP code (door-bound, ±1 step) + single-use
/// consumption + per-user rate limiting. Every attempt is written to the
/// `door_access_logs` audit/statistics table.
///
/// Security stance: ALL credential failures return the uniform `denied`
/// result — the device never learns WHICH check failed (no user
/// enumeration). Details go into the log row only.
class DoorAccessVerifier {
  /// Denied attempts allowed per user per minute before rate limiting
  /// kicks in (code brute-force protection; BLE + network round trips
  /// make much more than a handful impractical anyway).
  static const int maxDeniedPerMinute = 5;

  static const Duration _rateLimitWindow = Duration(seconds: 60);
  static const Duration _consumedRetention = Duration(minutes: 15);

  Future<DoorAccessResult> verify(
    final Session session, {
    required final UuidValue userKey,
    required final String code,
    required final String deviceMac,
    required final int siteId,
  }) async {
    // The instance only accepts requests meant for its own site.
    final connection = await SiteConnection.db.findFirstRow(session);
    if (connection == null || connection.siteId != siteId) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.invalid,
        detail: 'siteId mismatch',
      );
    }

    // Rate limit on previous DENIED attempts (granted/limited requests
    // do not feed the limiter).
    final deniedRecently = await DoorAccessLog.db.count(
      session,
      where: (t) =>
          t.userKey.equals(userKey) &
          t.result.equals(DoorAccessResult.denied) &
          (t.createdAt > DateTime.now().subtract(_rateLimitWindow)),
    );
    if (deniedRecently >= maxDeniedPerMinute) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.rateLimited,
      );
    }

    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.globalAuthUserId.equals(userKey),
    );
    final secret = profile?.doorCodeSecret;
    if (profile == null || secret == null || secret.isEmpty) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'unknown user or no secret',
      );
    }

    final membership = await MemberMembership.db.findFirstRow(
      session,
      where: (t) => t.globalAuthUserId.equals(userKey),
    );
    if (membership == null || !membership.active) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'membership inactive',
      );
    }

    final step = door_code.matchedDoorCodeStep(
      secretHex: secret,
      code: code,
      deviceMac: deviceMac,
      now: DateTime.now(),
    );
    if (step == null) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'code mismatch',
      );
    }

    // Single-use: the unique (user, step) index makes this race-safe —
    // a failed insert means the code was already consumed (replay).
    try {
      await DoorAccessConsumed.db.insertRow(
        session,
        DoorAccessConsumed(userKey: userKey, step: step),
      );
    } catch (e) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'replay or consume failed: $e',
      );
    }

    // Opportunistic pruning of stale consumption rows (best-effort).
    try {
      await DoorAccessConsumed.db.deleteWhere(
        session,
        where: (t) => t.createdAt < DateTime.now().subtract(_consumedRetention),
      );
    } catch (_) {}

    return _log(
      session,
      userKey: userKey,
      deviceMac: deviceMac,
      result: DoorAccessResult.granted,
      detail: 'step $step',
    );
  }

  Future<DoorAccessResult> _log(
    final Session session, {
    required final UuidValue? userKey,
    required final String deviceMac,
    required final DoorAccessResult result,
    final String? detail,
  }) async {
    await DoorAccessLog.db.insertRow(
      session,
      DoorAccessLog(
        userKey: userKey,
        deviceMac: deviceMac,
        result: result,
        detail: detail,
      ),
    );
    return result;
  }
}
