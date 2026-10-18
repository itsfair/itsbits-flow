import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'door_code_secrets.dart';

/// End-user door-access secret delivery (`requireLogin`): returns the
/// caller's own per-(person, site) TOTP secret for one site — the raw
/// material the end-user app computes its rolling codes from (offline,
/// no global round trip at door time).
///
/// Access rules: the caller must hold an ACTIVE membership at the site.
/// The secret itself lives on the `SiteMembership` row (serverOnly) and
/// is generated at subscribe/reactivate time; legacy rows are generated
/// lazily here (self-healing backfill).
class DoorAccessEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The signed-in user's door secret for [siteId]; inactive/missing
  /// memberships are rejected.
  Future<MyDoorSecretInfo> getMySiteSecret(
    final Session session, {
    required final int siteId,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw SiteAdminException(
        message: 'Melde dich an, um deine Zugangsberechtigung zu nutzen.',
      );
    }

    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (profile == null) {
      throw SiteAdminException(
        message: 'Es fehlt ein member_profile für diesen Nutzer.',
      );
    }

    final site = await Site.db.findById(session, siteId);
    if (site == null) {
      throw SiteAdminException(message: 'Site wurde nicht gefunden.');
    }

    var membership = await SiteMembership.db.findFirstRow(
      session,
      where: (t) => t.siteId.equals(siteId) & t.profileId.equals(profile.id!),
    );
    if (membership == null || !membership.active) {
      throw SiteAdminException(
        message: 'Du bist nicht (mehr) Mitglied bei dieser Site.',
      );
    }

    if (membership.doorCodeSecret == null) {
      membership = await SiteMembership.db.updateRow(
        session,
        membership.copyWith(doorCodeSecret: generateDoorCodeSecret()),
      );
    }

    return MyDoorSecretInfo(
      siteId: siteId,
      siteName: site.name,
      secret: membership.doorCodeSecret!,
    );
  }
}
