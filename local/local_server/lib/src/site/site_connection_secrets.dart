import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

/// At-rest encryption for the stored device session key
/// (`site_connections.deviceSessionKey`, written once at enrollment — a
/// non-rotating credential that unlocks the site's member data at the
/// global backend).
///
/// Storage format: `enc:v1.<nonce-b64>.<mac-b64>.<cipher-b64>`
/// (AES-256-GCM, 12-byte nonce, 16-byte MAC). The AES key is derived
/// (SHA-256) from the `siteDeviceKeyCipherPassword` password key — set
/// it in `config/passwords.yaml` / `SERVERPOD_PASSWORD_siteDeviceKeyCipherPassword`.
///
/// Legacy rows (written before this layer, plain session keys) read as
/// plaintext passthrough and re-encrypt on the next enrollment write —
/// no data migration needed. Without a configured cipher password new
/// writes stay PLAINTEXT (dev convenience; production must set the key
/// or the at-rest protection is silently absent).
abstract final class SiteConnectionSecrets {
  static const String _prefix = 'enc:v1';
  static const String _derivationInfo = 'site-device-key-cipher:v1';

  static final AesGcm _aesGcm = AesGcm.with256bits();

  /// Test seam: when set, used INSTEAD of the Serverpod password lookup.
  static String? debugPasswordOverride;

  /// Stores [sessionKey] encrypted (or plaintext when no cipher password
  /// is configured).
  static Future<String> encrypt(final String sessionKey) async {
    final keyBytes = await _cipherKeyBytes();
    if (keyBytes == null) {
      stderr.writeln(
        '[SiteConnectionSecrets] siteDeviceKeyCipherPassword is NOT '
        'configured — storing the device session key in PLAINTEXT.',
      );
      return sessionKey;
    }
    final secretKey = SecretKey(keyBytes);
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(sessionKey),
      secretKey: secretKey,
    );
    return '$_prefix'
        '.${base64Encode(secretBox.nonce)}'
        '.${base64Encode(secretBox.mac.bytes)}'
        '.${base64Encode(secretBox.cipherText)}';
  }

  /// Decrypts a `enc:v1` value; anything else is a legacy plaintext
  /// session key and passes through unchanged.
  static Future<String> decrypt(final String stored) async {
    if (!stored.startsWith('$_prefix.')) {
      return stored;
    }
    final keyBytes = await _cipherKeyBytes();
    if (keyBytes == null) {
      throw StateError(
        'site_connections stores an ENCRYPTED device session key '
        '($_prefix) but siteDeviceKeyCipherPassword is not configured — '
        'cannot decrypt. Missing deployment value?',
      );
    }
    final parts = stored.substring(_prefix.length + 1).split('.');
    if (parts.length != 3) {
      throw StateError('Corrupt encrypted device session key format.');
    }
    final SecretBox secretBox = SecretBox(
      base64Decode(parts[2]),
      nonce: base64Decode(parts[0]),
      mac: Mac(base64Decode(parts[1])),
    );
    final List<int> plain;
    try {
      plain = await _aesGcm.decrypt(
        secretBox,
        secretKey: SecretKey(keyBytes),
      );
    } catch (e) {
      throw StateError(
        'The stored device session key could not be decrypted '
        '(wrong or changed siteDeviceKeyCipherPassword, or corrupt '
        'value): $e',
      );
    }
    return utf8.decode(plain);
  }

  /// The 32-byte AES key derived from the cipher password (null when the
  /// password key is not configured).
  static Future<Uint8List?> _cipherKeyBytes() async {
    final String? password;
    try {
      password =
          debugPasswordOverride ??
          Serverpod.instance.getPassword('siteDeviceKeyCipherPassword');
    } catch (e) {
      // Serverpod not initialized (unit tests): behave like "not set".
      return null;
    }
    if (password == null || password.isEmpty) {
      return null;
    }
    final digest = sha256.convert(
      utf8.encode('$_derivationInfo:$password'),
    );
    return Uint8List.fromList(digest.bytes);
  }
}
