import 'dart:typed_data';

import 'package:global_client/global_client.dart' as gc;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'global_site_connection.dart';

const String _storageId = 'public';
const String _siteImagesFolder = 'site_images';

/// Local admin endpoint for editing THIS site's properties (name, address,
/// contact) and its image. Editing happens LOCALLY only (mirror rule
/// reversed versus member profiles) and — by design — requires the live
/// connection to the global instance: the update is pushed FIRST to the
/// global `siteDetails` endpoint (device credential, server-to-server) and
/// only on success applied to the local snapshot. No queuing/offline mode.
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`).
class SiteAdminEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kLocalAdminScope)};

  /// Updates the site properties (fail-closed: any push failure leaves the
  /// local snapshot untouched; validation happens on the global side —
  /// one source of truth for the field rules).
  Future<SiteConnection> updateSite(
    final Session session, {
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
  }) async {
    final row = await _requireConnectionRow(session);
    await _requireConnected();
    final client = await _globalClient();
    await client.siteDetails.push(
      name: name,
      street: street,
      zipCode: zipCode,
      city: city,
      country: country,
      companyEmail: companyEmail,
      removeImage: false,
    );
    return SiteConnection.db.updateRow(
      session,
      row.copyWith(
        siteName: name.trim(),
        siteStreet: street.trim(),
        siteZipCode: zipCode.trim(),
        siteCity: city.trim(),
        siteCountry: country.trim(),
        siteCompanyEmail: companyEmail.trim().toLowerCase(),
      ),
    );
  }

  /// Uploads/overwrites the site image (JPEG, like the profile image).
  /// The object is stored BOTH globally (end user + admin display) and
  /// locally (offline-capable local display), deterministic path.
  Future<SiteConnection> setSiteImage(
    final Session session, {
    required final ByteData image,
  }) async {
    final row = await _requireConnectionRow(session);
    await _requireConnected();
    final client = await _globalClient();
    await client.siteDetails.push(
      name: row.siteName,
      street: row.siteStreet ?? '',
      zipCode: row.siteZipCode ?? '',
      city: row.siteCity ?? '',
      country: row.siteCountry ?? '',
      companyEmail: row.siteCompanyEmail ?? '',
      image: image,
      removeImage: false,
    );
    await session.storage.storeFile(
      storageId: _storageId,
      path: _siteImagePath(row.siteId),
      byteData: image,
    );

    // The snapshot stores the object PATH (presigning happens at payload
    // assembly — see ImageUrlSigner); a publicDownloadUrl here would
    // throw on the private bucket.
    return SiteConnection.db.updateRow(
      session,
      row.copyWith(siteImageUrl: _siteImagePath(row.siteId)),
    );
  }

  /// Removes the site image on BOTH sides (global first, then local).
  Future<SiteConnection> removeSiteImage(final Session session) async {
    final row = await _requireConnectionRow(session);
    await _requireConnected();
    final client = await _globalClient();
    await client.siteDetails.push(
      name: row.siteName,
      street: row.siteStreet ?? '',
      zipCode: row.siteZipCode ?? '',
      city: row.siteCity ?? '',
      country: row.siteCountry ?? '',
      companyEmail: row.siteCompanyEmail ?? '',
      removeImage: true,
    );
    if (row.siteImageUrl case final url? when url.isNotEmpty) {
      await session.storage.deleteFile(
        storageId: _storageId,
        path: _siteImagePath(row.siteId),
      );
    }

    return SiteConnection.db.updateRow(
      session,
      row.copyWith(siteImageUrl: null),
    );
  }

  // -- Private helpers

  /// The instance's single enrollment row; without it no editing exists.
  Future<SiteConnection> _requireConnectionRow(
    final Session session,
  ) async {
    final row = await SiteConnection.db.findFirstRow(session);
    if (row == null) {
      throw SiteSetupException(
        message: 'Diese Instanz ist nicht eingerichtet.',
      );
    }
    return row;
  }

  /// Strict connectivity gate (no queueing): only the `connected` state
  /// allows site edits.
  Future<void> _requireConnected() async {
    final status = GlobalSiteConnection.instance.status();
    if (status.state != SiteConnectionState.connected) {
      throw SiteSetupException(
        message:
            'Die Verbindung zur globalen Instanz ist nicht aktiv — '
            'Änderungen sind nur bei bestehender Verbindung möglich.',
      );
    }
  }

  /// The device-credentialed global client (ownership: connection worker).
  Future<gc.Client> _globalClient() async {
    final client = await GlobalSiteConnection.instance.openSyncClient();
    if (client == null) {
      throw SiteSetupException(
        message:
            'Keine Geräte-Anmeldung vorhanden — bitte die Einrichtung '
            'wiederholen.',
      );
    }
    return client;
  }

  String _siteImagePath(final int siteId) => '$_siteImagesFolder/$siteId.jpg';
}
