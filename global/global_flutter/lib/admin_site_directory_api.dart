import 'package:global_client/global_client.dart' as gc;
import 'package:itsbits_shared/site_directory.dart';

import 'client.dart';

/// Admin adapter implementing the shared [SiteDirectoryApi] against the
/// `sitesAdmin` endpoints — the admin list intentionally shows ALL sites
/// (including pendingSetup ones, surfaced via the chip `statusLabel`).
/// Membership operations are end-user-only and unused here.
class AdminSiteDirectoryApi implements SiteDirectoryApi {
  const AdminSiteDirectoryApi();

  @override
  Future<List<SiteData>> listLatest({final int limit = 5}) =>
      list(offset: 0, limit: limit);

  @override
  Future<List<SiteData>> list({
    final String? query,
    final int offset = 0,
    final int limit = 50,
  }) async {
    final sites = await client.sitesAdmin.listSites(
      query: query,
      offset: offset,
      limit: limit,
    );
    return [for (final site in sites) _toData(site)];
  }

  @override
  Future<int> count({final String? query}) =>
      client.sitesAdmin.countSites(query: query);

  @override
  Future<SiteData> getSite(final int siteId) async =>
      _toData(await client.sitesAdmin.getSite(siteId: siteId));

  @override
  Future<MyMembershipData?> myMembership(final int siteId) => Future.value();

  @override
  Future<MyMembershipData> subscribe(final int siteId) =>
      Future.error(UnimplementedError('membership is end-user-only'));

  @override
  Future<void> unsubscribe(final int siteId) async {}

  SiteData _toData(final gc.Site site) {
    final pendingSetup = site.status == gc.SiteSetupStatus.pendingSetup;
    final lastSeen = site.lastSeenAt;
    return SiteData(
      id: site.id ?? 0,
      name: site.name,
      street: site.street,
      zipCode: site.zipCode,
      city: site.city,
      country: site.country,
      companyEmail: site.companyEmail,
      imageUrl: site.imageUrl,
      isOnline:
          !pendingSetup &&
          lastSeen != null &&
          DateTime.now().difference(lastSeen) <= const Duration(seconds: 90),
      statusLabel: pendingSetup ? 'Setup offen' : null,
      createdAt: site.createdAt,
    );
  }
}
