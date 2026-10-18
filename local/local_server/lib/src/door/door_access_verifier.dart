import 'package:itsbits_shared/door_code.dart' as door_code;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Verifies one door-access attempt fully offline: member mirror +
/// membership activity + timestamp-based door code (door-bound, valid
/// ±30 s around the request timestamp) + single-use consumption per
/// (user, timestamp) + per-user rate limiting + the POLICY layer
/// (deny-by-default: an active policy assignment must grant this door
/// on this weekday inside its minute window — server-local time). Every
/// attempt is written to the `door_access_logs` audit/statistics table.
///
/// Check ORDER matters: the single-use consumption happens AFTER the
/// policy check — a policy denial must never burn a code (the app
/// retries immediately with a fresh timestamp; each scan is unique by
/// construction).
///
/// Security stance: ALL credential/policy failures return the uniform
/// `denied` result — the device never learns WHICH check failed (no
/// user enumeration). The only distinct outcomes are `timeSkew` (the
/// code itself was valid — phone clock issue, user-actionable) and
/// details go into the log row only.
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
    required final int timestampMs,
    final DateTime? now,
  }) async {
    final at = now ?? DateTime.now();
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

    // Code check: recompute from the transmitted timestamp. A match
    // outside the skew window = phone clock problem (distinct, helpful
    // result; the limiter does NOT count these).
    final codeMatches =
        code.trim() ==
        door_code.computeDoorCode(
          secretHex: secret,
          timestampMs: timestampMs,
          deviceMac: deviceMac,
        );
    if (!codeMatches) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'code mismatch',
      );
    }
    final skewMs = (at.toUtc().millisecondsSinceEpoch - timestampMs).abs();
    if (skewMs > door_code.doorCodeMaxSkewSeconds * 1000) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.timeSkew,
        detail: 'skew ${skewMs ~/ 1000} s',
      );
    }

    // Policy layer (deny-by-default): BEFORE consumption — a denial
    // here must not burn the request's unique code.
    final device = await _resolveDevice(session, deviceMac);
    if (device == null) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: 'unknown device',
      );
    }

    final policyCheck = await _policyGrants(
      session,
      userKey: userKey,
      deviceId: device.id!,
      now: at,
    );
    if (!policyCheck.granted) {
      return _log(
        session,
        userKey: userKey,
        deviceMac: deviceMac,
        result: DoorAccessResult.denied,
        detail: policyCheck.reason,
      );
    }

    // Single-use consumption LAST (right before the grant): the unique
    // (user, timestamp) index makes this race-safe — a failed insert
    // means the pair was already used (replay).
    try {
      await DoorAccessConsumed.db.insertRow(
        session,
        DoorAccessConsumed(userKey: userKey, timestampMs: timestampMs),
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
        where: (t) => t.createdAt < at.subtract(_consumedRetention),
      );
    } catch (_) {}

    return _log(
      session,
      userKey: userKey,
      deviceMac: deviceMac,
      result: DoorAccessResult.granted,
      detail: policyCheck.reason,
    );
  }

  // -- Policy layer

  Future<DoorDevice?> _resolveDevice(
    final Session session,
    final String deviceMac,
  ) async {
    final devices = await DoorDevice.db.find(session);
    final incoming = door_code.normalizeDeviceMac(deviceMac);
    if (incoming.isEmpty) return null;
    for (final device in devices) {
      final mac = device.mac;
      if (mac != null && door_code.normalizeDeviceMac(mac) == incoming) {
        return device;
      }
    }
    return null;
  }

  Future<({bool granted, String reason})> _policyGrants(
    final Session session, {
    required final UuidValue userKey,
    required final int deviceId,
    required final DateTime now,
  }) async {
    final assignments = await AccessPolicyMember.db.find(
      session,
      where: (t) => t.globalAuthUserId.equals(userKey),
    );
    final active = assignments
        .where(
          (a) =>
              !now.isBefore(a.validFrom) &&
              (a.validUntil == null || now.isBefore(a.validUntil!)),
        )
        .toList();
    if (active.isEmpty) {
      return (granted: false, reason: 'no active policy assignment');
    }

    final policyIds = active.map((a) => a.policyId).toSet();
    final rules = await AccessPolicyRule.db.find(
      session,
      where: (t) => t.policyId.inSet(policyIds),
    );

    final minute = now.hour * 60 + now.minute;
    final weekday = now.weekday - 1; // Dart: Monday=1 .. Sunday=7 → 0..6
    for (final rule in rules) {
      if (rule.deviceId != null && rule.deviceId != deviceId) continue;
      if (rule.weekday != weekday) continue;
      if (minute >= rule.startMinute && minute < rule.endMinute) {
        return (granted: true, reason: 'policy ${rule.policyId}');
      }
    }
    return (granted: false, reason: 'outside policy window');
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
