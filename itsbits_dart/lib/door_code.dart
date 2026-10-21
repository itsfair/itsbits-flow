/// Rolling door codes shared by the end-user app (code computation) and
/// the local instance (verification).
///
/// One secret per (person, site) — issued by the global instance. The
/// code is computed PER REQUEST from the exact millisecond timestamp
/// (no 30 s slots, unlimited frequency), bound to the door via the
/// device MAC from the QR code, and consumed once per (person,
/// timestamp) by the local instance (replay protection):
///
///     code = 6 digits of HMAC-SHA256(secret, utf8("<timestampMs>:<normalizedMac>"))
///
/// Both sides MUST use the same normalization: `normalizeDeviceMac`
/// (uppercase hex pairs, colons/spaces stripped).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Maximum difference between the code's timestamp and the verifying
/// server's time (clock skew tolerance, both directions).
const int doorCodeMaxSkewSeconds = 30;

/// Canonical MAC form used in the HMAC input: uppercase, no separators.
String normalizeDeviceMac(final String mac) =>
    mac.replaceAll(RegExp(r'[\s:-]'), '').toUpperCase();

/// Computes the 6-digit door code for [timestampMs].
String computeDoorCode({
  required final String secretHex,
  required final int timestampMs,
  required final String deviceMac,
}) {
  final key = _hexBytes(secretHex);
  if (key.isEmpty) {
    throw ArgumentError('door code secret is empty or not hex');
  }
  final mac = normalizeDeviceMac(deviceMac);
  final message = utf8.encode('$timestampMs:$mac');
  final digest = Hmac(sha256, key).convert(message).bytes;
  return _dynamicTruncate(digest);
}

/// Verifies a computed code against the receiving server's [now]:
/// true only when the code matches its timestamp AND the timestamp
/// lies within the skew window.
bool verifyDoorCode({
  required final String secretHex,
  required final String code,
  required final String deviceMac,
  required final int timestampMs,
  required final DateTime now,
}) {
  if (code.trim() ==
      computeDoorCode(
        secretHex: secretHex,
        timestampMs: timestampMs,
        deviceMac: deviceMac,
      )) {
    final skew = (now.toUtc().millisecondsSinceEpoch - timestampMs).abs();
    return skew <= doorCodeMaxSkewSeconds * 1000;
  }
  return false;
}

/// True when the code matches its timestamp but the timestamp is OUTSIDE
/// the skew window — the app's clock is off (distinct, user-actionable
/// error; only a holder of the correct secret can produce it).
bool isTimeSkewOnly({
  required final String secretHex,
  required final String code,
  required final String deviceMac,
  required final int timestampMs,
  required final DateTime now,
}) {
  final matches =
      code.trim() ==
      computeDoorCode(
        secretHex: secretHex,
        timestampMs: timestampMs,
        deviceMac: deviceMac,
      );
  final skew = (now.toUtc().millisecondsSinceEpoch - timestampMs).abs();
  return matches && skew > doorCodeMaxSkewSeconds * 1000;
}

Uint8List _hexBytes(final String hex) {
  final clean = hex.replaceAll(RegExp(r'\s'), '').toLowerCase();
  if (clean.isEmpty || clean.length.isOdd) return Uint8List(0);
  final bytes = Uint8List(clean.length ~/ 2);
  for (var i = 0; i < bytes.length; i++) {
    final byte = int.tryParse(clean.substring(i * 2, i * 2 + 2), radix: 16);
    if (byte == null) return Uint8List(0);
    bytes[i] = byte;
  }
  return bytes;
}

/// RFC 4226 dynamic truncation, zero-padded to 6 digits.
String _dynamicTruncate(final List<int> hmac) {
  final offset = hmac.last & 0x0f;
  final binary =
      ((hmac[offset] & 0x7f) << 24) |
      (hmac[offset + 1] << 16) |
      (hmac[offset + 2] << 8) |
      hmac[offset + 3];
  return (binary % 1000000).toString().padLeft(6, '0');
}
