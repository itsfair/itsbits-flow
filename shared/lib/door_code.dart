/// Rolling door codes (TOTP-style, 30 s steps) shared by the end-user
/// app (code computation) and the local instance (verification).
///
/// One secret per (person, site) — issued by the global instance. The
/// code binds the door: the device MAC from the QR code is part of the
/// HMAC input, so a captured code is useless at any other door and
/// single-use enforcement stays strict even across multiple doors in
/// quick succession.
///
///     code = 6 digits of HMAC-SHA256(secret, utf8("<step>:<normalizedMac>"))
///
/// Both sides MUST use the same normalization: `normalizeDeviceMac`
/// (uppercase hex pairs, colons/spaces stripped).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Duration of one code step.
const Duration doorCodeStepLength = Duration(seconds: 30);

/// How many steps beside the current one are accepted at verification
/// (clock skew tolerance; ±1 = ~30 s each way).
const int doorCodeStepWindow = 1;

/// The time step containing [utcNow].
int doorCodeStep(final DateTime utcNow) =>
    (utcNow.toUtc().millisecondsSinceEpoch ~/ 1000) ~/ 30;

/// All steps accepted at verification time ([now] ± [window]).
List<int> doorCodeSteps(
  final DateTime now, {
  final int window = doorCodeStepWindow,
}) {
  final current = doorCodeStep(now);
  return [
    for (var offset = -window; offset <= window; offset++) current + offset,
  ];
}

/// Canonical MAC form used in the HMAC input: uppercase, no separators.
String normalizeDeviceMac(final String mac) =>
    mac.replaceAll(RegExp(r'[\s:-]'), '').toUpperCase();

/// Computes the 6-digit door code for [step].
String computeDoorCode({
  required final String secretHex,
  required final int step,
  required final String deviceMac,
}) {
  final key = _hexBytes(secretHex);
  if (key.isEmpty) {
    throw ArgumentError('door code secret is empty or not hex');
  }
  final mac = normalizeDeviceMac(deviceMac);
  final message = utf8.encode('$step:$mac');
  final digest = Hmac(sha256, key).convert(message).bytes;
  return _dynamicTruncate(digest, digits: 6);
}

/// True when [code] matches the expected code for any step around [now].
bool verifyDoorCode({
  required final String secretHex,
  required final String code,
  required final String deviceMac,
  required final DateTime now,
  final int window = doorCodeStepWindow,
}) {
  final normalized = code.trim();
  for (final step in doorCodeSteps(now, window: window)) {
    if (computeDoorCode(
          secretHex: secretHex,
          step: step,
          deviceMac: deviceMac,
        ) ==
        normalized) {
      return true;
    }
  }
  return false;
}

/// The step a given code was computed for, searched around [now] — used
/// to consume exactly the matched step (single-use). Null = no match.
int? matchedDoorCodeStep({
  required final String secretHex,
  required final String code,
  required final String deviceMac,
  required final DateTime now,
  final int window = doorCodeStepWindow,
}) {
  final normalized = code.trim();
  for (final step in doorCodeSteps(now, window: window)) {
    if (computeDoorCode(
          secretHex: secretHex,
          step: step,
          deviceMac: deviceMac,
        ) ==
        normalized) {
      return step;
    }
  }
  return null;
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

/// RFC 4226 dynamic truncation, zero-padded to [digits].
String _dynamicTruncate(final List<int> hmac, {required final int digits}) {
  final offset = hmac.last & 0x0f;
  final binary =
      ((hmac[offset] & 0x7f) << 24) |
      (hmac[offset + 1] << 16) |
      (hmac[offset + 2] << 8) |
      hmac[offset + 3];
  var divisor = 1;
  for (var i = 0; i < digits; i++) {
    divisor *= 10;
  }
  final value = binary % divisor;
  return value.toString().padLeft(digits, '0');
}
