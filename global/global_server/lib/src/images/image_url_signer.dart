import 'package:serverpod/serverpod.dart';

/// Signs image object paths of the private RustFS bucket into short-lived
/// presigned GET URLs for every payload that leaves the server.
///
/// Semantics: `imageUrl`-shaped fields in the database hold the OBJECT PATH
/// (e.g. `member_images/<id>.jpg`, `site_images/<id>.jpg`) since the
/// paths are deterministic (one object per person/site). Presigning happens
/// at every payload assembly, so each response carries a fresh signature;
/// an outdated signature automatically implies no stale image cache.
///
/// Only the two known image folder prefixes are signed — anything else
/// yields `null`.
class ImageUrlSigner {
  static const String _storageId = 'public';
  static const _allowedPrefixes = ['member_images/', 'site_images/'];

  static const Duration _expiration = Duration(minutes: 15);

  const ImageUrlSigner._();

  /// Returns a presigned GET URL for the path, `null` when there is no
  /// path, the path is not an image path, or the object does not exist.
  static Future<String?> signed(final Session session, final String? path) =>
      signedWithExpiry(session, path, _expiration);

  /// Variant with an explicit expiration (e.g. a tighter window for
  /// server-to-server image transfers).
  static Future<String?> signedWithExpiry(
    final Session session,
    final String? path,
    final Duration expiration,
  ) async {
    final normalized = _normalizePath(path);
    if (normalized == null) {
      return null;
    }
    try {
      final uri = await session.storage.temporaryDownloadUrl(
        storageId: _storageId,
        path: normalized,
        options: TemporaryDownloadUrlOptions(
          expirationDuration: expiration,
        ),
      );
      return uri.toString();
    } on CloudStorageFileNotFoundException {
      return null;
    }
  }

  /// Extracts the object path from legacy rows that still store an
  /// absolute URL (pre-presigning rows; self-heal at the next image
  /// write — path migration rides along with the next real schema
  /// migration, see AGENTS.md).
  static String? _normalizePath(final String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final prefix in _allowedPrefixes) {
      final index = value.indexOf(prefix);
      if (index >= 0) {
        final candidate = value.substring(index);
        // Sign only the path itself — legacy URLs are stored plain.
        final queryIndex = candidate.indexOf('?');
        return queryIndex >= 0 ? candidate.substring(0, queryIndex) : candidate;
      }
    }
    return null;
  }
}
