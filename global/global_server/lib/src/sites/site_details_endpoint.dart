import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../auth/scopes.dart';
import '../generated/protocol.dart';
import 'site_device_context.dart';
import 'site_field_validation.dart';

const String _storageId = 'public';
const String _siteImagesFolder = 'site_images';

/// Device-scoped site-details push (the LOCAL instance is the editor; the
/// global row is the mirror). Called over the device credential while the
/// local worker is connected — the local `siteAdmin` endpoint invokes it
/// server-to-server, and it performs the whole update (fields + optional
/// image) before the local side touches its own snapshot.
///
/// Image objects live at `site_images/<siteId>.jpg` (deterministic, one
/// object per site, overwrite on change, JPEG-only like profile images).
class SiteDetailsEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kSiteDeviceScope)};

  /// Pushes the full (validated) site field set; optional image transfer
  /// (bytes upload or removal). Image handling is fail-fast: a failing
  /// upload/replacement aborts the whole push, the row keeps its prior
  /// state.
  Future<void> push(
    final Session session, {
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
    final ByteData? image,
    final bool removeImage = false,
  }) async {
    final site = await requireDeviceSite(session);
    final fields = SiteFieldValidation.requireAll(
      name: name,
      street: street,
      zipCode: zipCode,
      city: city,
      country: country,
      companyEmail: companyEmail,
    );

    String? imageUrl = site.imageUrl;
    if (removeImage) {
      if (imageUrl case final url? when url.isNotEmpty) {
        await session.storage.deleteFile(
          storageId: _storageId,
          path: _siteImagePath(site.id!),
        );
      }
      imageUrl = null;
    } else if (image != null) {
      final path = _siteImagePath(site.id!);
      await session.storage.storeFile(
        storageId: _storageId,
        path: path,
        byteData: image,
      );
      final url = await session.storage.publicDownloadUrl(
        storageId: _storageId,
        path: path,
      );
      imageUrl = url.toString();
    }

    await Site.db.updateRow(
      session,
      site.copyWith(
        name: fields.name,
        street: fields.street,
        zipCode: fields.zipCode,
        city: fields.city,
        country: fields.country,
        companyEmail: fields.companyEmail,
        imageUrl: imageUrl,
      ),
    );
  }

  String _siteImagePath(final int siteId) => '$_siteImagesFolder/$siteId.jpg';
}
