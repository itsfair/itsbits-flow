import 'dart:typed_data';

import 'package:itsbits_shared/screens/site_details_editor.dart';
import 'package:itsbits_shared/site_directory.dart';
import 'package:local_client/local_client.dart' as lc;

/// Adapter mapping the generated local-client admin endpoints onto the
/// shared [SiteDetailsApi] contract. All writes hit the local
/// `siteAdmin` endpoint, which gates on the live connection and pushes to
/// the global instance BEFORE updating the local snapshot (fail-closed).
class LocalSiteDetailsApi implements SiteDetailsApi {
  final lc.Client _client;

  LocalSiteDetailsApi(this._client);

  @override
  Future<SiteData> get() async {
    final info = await _client.siteSetup.adminInfo();
    return SiteData(
      id: info.siteId ?? 0,
      name: info.siteName ?? '',
      street: info.siteStreet ?? '',
      zipCode: info.siteZipCode ?? '',
      city: info.siteCity ?? '',
      country: info.siteCountry ?? '',
      companyEmail: info.siteCompanyEmail ?? '',
      imageUrl: info.siteImageUrl,
      isOnline: info.connectionState == lc.SiteConnectionState.connected,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<SiteData> save({
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
  }) async {
    final row = await _client.siteAdmin.updateSite(
      name: name,
      street: street,
      zipCode: zipCode,
      city: city,
      country: country,
      companyEmail: companyEmail,
    );
    return _toData(row);
  }

  @override
  Future<SiteData> setSiteImage({required final Uint8List image}) async {
    final row = await _client.siteAdmin.setSiteImage(
      image: ByteData.sublistView(image),
    );
    return _toData(row);
  }

  @override
  Future<SiteData> removeSiteImage() async {
    final row = await _client.siteAdmin.removeSiteImage();
    return _toData(row);
  }

  SiteData _toData(final lc.SiteConnection row) => SiteData(
    id: row.siteId,
    name: row.siteName,
    street: row.siteStreet ?? '',
    zipCode: row.siteZipCode ?? '',
    city: row.siteCity ?? '',
    country: row.siteCountry ?? '',
    companyEmail: row.siteCompanyEmail ?? '',
    imageUrl: row.siteImageUrl,
    isOnline: false,
    createdAt: row.enrolledAt,
  );
}
