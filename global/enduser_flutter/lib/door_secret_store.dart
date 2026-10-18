import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'client.dart';

/// Caches the user's per-site door secrets (secure storage) and fetches
/// them on demand from the global `doorAccess` endpoint. After the first
/// fetch per site, door codes are computed fully offline.
class DoorSecretStore {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// The (person, site) TOTP secret; fetched once per site from the
  /// global instance and cached on the device.
  Future<String> secretForSite(final int siteId) async {
    final cached = await _storage.read(key: _key(siteId));
    if (cached != null && cached.isNotEmpty) return cached;
    final info = await client.doorAccess.getMySiteSecret(siteId: siteId);
    await _storage.write(key: _key(siteId), value: info.secret);
    return info.secret;
  }

  /// Drops the cached secret (e.g. after ending the membership).
  Future<void> forgetSite(final int siteId) =>
      _storage.delete(key: _key(siteId));

  String _key(final int siteId) => 'door_secret_$siteId';
}

/// App-wide door-secret cache.
final DoorSecretStore doorSecretStore = DoorSecretStore();
