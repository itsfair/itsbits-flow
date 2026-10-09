import 'package:global_client/global_client.dart' as gc;
import 'package:itsbits_shared/site_directory.dart';

/// Adapter mapping the generated global-client `siteDirectory` endpoint
/// onto the shared [SiteDirectoryApi] contract (~the MemberProfileApi
/// pattern; the shared package never sees generated types).
class GlobalSiteDirectoryApi implements SiteDirectoryApi {
  final gc.Client _client;

  GlobalSiteDirectoryApi(this._client);

  @override
  Future<List<SiteData>> listLatest({final int limit = 5}) async {
    final sites = await _client.siteDirectory.listLatest(limit: limit);
    return [for (final site in sites) _toData(site)];
  }

  @override
  Future<List<SiteData>> list({
    final String? query,
    final int offset = 0,
    final int limit = 50,
  }) async {
    final sites = await _client.siteDirectory.listSites(
      query: query,
      offset: offset,
      limit: limit,
    );
    return [for (final site in sites) _toData(site)];
  }

  @override
  Future<int> count({final String? query}) =>
      _client.siteDirectory.countSites(query: query);

  @override
  Future<SiteData> getSite(final int siteId) async =>
      _toData(await _client.siteDirectory.getSite(siteId: siteId));

  @override
  Future<MyMembershipData?> myMembership(final int siteId) async {
    final membership = await _client.siteDirectory.myMembership(siteId: siteId);
    if (membership == null) return null;
    return _membershipData(membership);
  }

  @override
  Future<MyMembershipData> subscribe(final int siteId) async =>
      _membershipData(await _client.siteDirectory.subscribe(siteId: siteId));

  @override
  Future<void> unsubscribe(final int siteId) =>
      _client.siteDirectory.unsubscribe(siteId: siteId);

  SiteData _toData(final gc.SitePublic site) => SiteData(
    id: site.id,
    name: site.name,
    street: site.street,
    zipCode: site.zipCode,
    city: site.city,
    country: site.country,
    companyEmail: site.companyEmail,
    imageUrl: site.imageUrl,
    isOnline: site.isOnline,
    createdAt: site.createdAt,
  );

  MyMembershipData _membershipData(final gc.MyMembershipInfo m) =>
      MyMembershipData(
        siteId: m.siteId,
        roleName: m.roleName,
        active: m.active,
        endedAt: m.endedAt,
        createdAt: m.createdAt,
      );
}
