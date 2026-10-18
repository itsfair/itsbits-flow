import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../profile/member_profile_checks.dart';
import 'site_connection_status.dart';
import 'site_sync_queue.dart';
import 'door_code_secrets.dart';
import 'sites_admin_endpoint.dart';

/// End-user directory for sites ("Betriebe"): browseable WITHOUT login
/// (`listLatest`, `list`, `count`, `getSite` — only fully registered sites
/// are visible). Subscribing/unsubscribing requires a signed-in user whose
/// member_profile is complete.
///
/// Membership = global `SiteMembership` row (role `member`, unique per
/// person+site). Creating/reactivating one also enqueues the member-data
/// delivery to the site's local instance (`SiteSyncQueue`) and kicks a
/// real-time stream event if the site is currently connected.
class SiteDirectoryEndpoint extends Endpoint {
  SiteAdminException _error(final String message) =>
      SiteAdminException(message: message);

  UuidValue? _ownAuthUserId(final Session session) =>
      session.authenticated?.authUserId;

  /// The newest registered sites for the home screen carousel.
  Future<List<SitePublic>> listLatest(
    final Session session, {
    final int limit = 5,
  }) async {
    return _sitePublicList(
      session,
      limit: limit.clamp(1, 10),
      offset: 0,
    );
  }

  /// All registered sites, newest first, paginated; [query] filters name,
  /// company email or city (case-insensitive substring).
  Future<List<SitePublic>> listSites(
    final Session session, {
    final String? query,
    final int offset = 0,
    final int limit = SitesAdminEndpoint.pageSize,
  }) async {
    return _sitePublicList(
      session,
      query: query,
      limit: limit,
      offset: offset,
    );
  }

  /// Number of sites matching [query] (pagination/"more available" hint).
  Future<int> countSites(final Session session, {final String? query}) async {
    final q = query?.trim() ?? '';
    final filter = _siteFilter(q);
    final where = filter == null
        ? (final SiteTable t) => t.status.equals(SiteSetupStatus.registered)
        : (final SiteTable t) =>
              filter(t) & t.status.equals(SiteSetupStatus.registered);
    return Site.db.count(session, where: where);
  }

  /// A single registered site (detail view). Unregistered/unknown sites
  /// are indistinguishable on purpose (no leak of setup states).
  Future<SitePublic> getSite(
    final Session session, {
    required final int siteId,
  }) async {
    final site = await Site.db.findById(session, siteId);
    if (site == null || site.status != SiteSetupStatus.registered) {
      throw _error('Site wurde nicht gefunden.');
    }
    return _sitePublic(site);
  }

  // -- Authenticated membership level (requireLogin-like guards below).

  /// The signed-in user's membership at the site (null = not subscribed).
  Future<MyMembershipInfo?> myMembership(
    final Session session, {
    required final int siteId,
  }) async {
    final membership = await _ownMembership(session, siteId);
    if (membership == null) return null;
    return _membershipInfo(membership);
  }

  /// Subscribes the signed-in user to a site. Requires:
  /// - a complete member_profile (reusable `profileIsComplete` rule),
  /// - a registered site whose local instance is currently connected
  ///   (the initial data transfer happens right away; offline sites are
  ///   rejected here by design).
  ///
  /// An existing deactivated membership is reactivated in place (history
  /// is kept; delivery to the site re-triggers via the sync queue).
  Future<MyMembershipInfo> subscribe(
    final Session session, {
    required final int siteId,
  }) async {
    final authUserId = _requireLogin(session);

    final profile = await _ownProfile(session, authUserId);
    if (!profile.profileIsComplete) {
      throw _error(
        'Das Profil muss vervollständigt werden, bevor eine Mitgliedschaft '
        'abgeschlossen werden kann.',
      );
    }

    final site = await Site.db.findById(session, siteId);
    if (site == null || site.status != SiteSetupStatus.registered) {
      throw _error('Site wurde nicht gefunden.');
    }
    if (!SiteConnectionStatus.isConnected(site)) {
      throw _error(
        'Die Site ist gerade nicht erreichbar — bitte später erneut '
        'versuchen.',
      );
    }

    var membership = await SiteMembership.db.findFirstRow(
      session,
      where: (t) => t.siteId.equals(siteId) & t.profileId.equals(profile.id!),
    );
    if (membership == null) {
      membership = await SiteMembership.db.insertRow(
        session,
        SiteMembership(
          siteId: siteId,
          profileId: profile.id!,
          doorCodeSecret: generateDoorCodeSecret(),
        ),
      );
    } else if (!membership.active) {
      // Reactivation ROTATES the secret (old app-side copies die with it).
      membership = await SiteMembership.db.updateRow(
        session,
        membership.copyWith(
          active: true,
          endedAt: null,
          doorCodeSecret: generateDoorCodeSecret(),
        ),
      );
    } else {
      throw _error('Du bist bereits Mitglied bei dieser Site.');
    }

    await SiteSyncQueue.enqueueForSites(
      session,
      profileId: profile.id!,
      siteIds: [siteId],
    );

    return _membershipInfo(membership);
  }

  /// Ends the signed-in user's membership at the site: only a marker
  /// (inclusive `endedAt`) is set — the membership row and the local data
  /// are kept for later viewing; the local instance marks its mirror
  /// inactive via the sync queue.
  Future<void> unsubscribe(
    final Session session, {
    required final int siteId,
  }) async {
    final authUserId = _requireLogin(session);
    final membership = await _ownMembership(session, siteId, authUserId);
    if (membership == null) {
      throw _error('Du bist nicht Mitglied bei dieser Site.');
    }
    if (!membership.active) return;

    final updated = await SiteMembership.db.updateRow(
      session,
      membership.copyWith(active: false, endedAt: DateTime.now()),
    );
    await SiteSyncQueue.enqueueForSites(
      session,
      profileId: updated.profileId,
      siteIds: [siteId],
    );
  }

  // -- Private helpers

  WhereExpressionBuilder<SiteTable>? _siteFilter(final String query) {
    final q = query.trim();
    if (q.isEmpty) return null;
    final escaped = _escapeLike(q);
    return (final SiteTable t) =>
        Site.t.name.ilike('%$escaped%') |
        Site.t.companyEmail.ilike('%$escaped%') |
        Site.t.city.ilike('%$escaped%');
  }

  Future<List<SitePublic>> _sitePublicList(
    final Session session, {
    final String? query,
    required final int limit,
    required final int offset,
  }) async {
    final filter = _siteFilter(query ?? '');
    final where = filter == null
        ? (final SiteTable t) => t.status.equals(SiteSetupStatus.registered)
        : (final SiteTable t) =>
              filter(t) & t.status.equals(SiteSetupStatus.registered);
    final sites = await Site.db.find(
      session,
      where: where,
      limit: limit.clamp(1, SitesAdminEndpoint.pageSize),
      offset: offset < 0 ? 0 : offset,
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    return [for (final site in sites) _sitePublic(site)];
  }

  SitePublic _sitePublic(final Site site) => SitePublic(
    id: site.id!,
    name: site.name,
    street: site.street,
    zipCode: site.zipCode,
    city: site.city,
    country: site.country,
    companyEmail: site.companyEmail,
    imageUrl: site.imageUrl,
    isOnline: SiteConnectionStatus.isConnected(site),
    createdAt: site.createdAt,
  );

  MyMembershipInfo _membershipInfo(final SiteMembership membership) =>
      MyMembershipInfo(
        siteId: membership.siteId,
        roleName: membership.role.name,
        active: membership.active,
        endedAt: membership.endedAt,
        createdAt: membership.createdAt,
      );

  UuidValue _requireLogin(final Session session) {
    final authUserId = _ownAuthUserId(session);
    if (authUserId == null) {
      throw _error('Melde dich an, um eine Mitgliedschaft abzuschließen.');
    }
    return authUserId;
  }

  Future<MemberProfile> _ownProfile(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (profile == null) {
      throw _error('Es fehlt ein member_profile für diesen Nutzer.');
    }
    return profile;
  }

  Future<SiteMembership?> _ownMembership(
    final Session session,
    final int siteId, [
    final UuidValue? authUserId,
  ]) async {
    final userId = authUserId ?? _ownAuthUserId(session);
    if (userId == null) return null;
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (profile?.id == null) return null;
    return SiteMembership.db.findFirstRow(
      session,
      where: (t) => t.siteId.equals(siteId) & t.profileId.equals(profile!.id!),
    );
  }

  String _escapeLike(final String value) {
    return value
        .replaceAll('\\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}
