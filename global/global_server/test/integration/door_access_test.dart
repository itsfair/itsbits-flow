import 'package:global_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the doorAccess endpoint', (sessionBuilder, endpoints) {
    Future<(UuidValue, MemberProfile)> createProfile(
      final Session session,
    ) async {
      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      final profile = await MemberProfile.db.insertRow(
        session,
        MemberProfile(
          authUserId: authUser.id!,
          email: 'alex@example.com',
          firstName: 'Alex',
          lastName: 'Muster',
          birthday: DateTime.utc(1985, 7, 1),
        ),
      );
      return (authUser.id!, profile);
    }

    Future<Site> createSite(final Session session) async {
      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      return Site.db.insertRow(
        session,
        Site(
          name: 'Musterbetrieb',
          street: 'Musterweg 1',
          zipCode: '12345',
          city: 'Abcstadt',
          country: 'Deutschland',
          companyEmail: 'info@musterbetrieb.de',
          status: SiteSetupStatus.registered,
          firstAdminId: authUser.id!,
        ),
      );
    }

    Future<SiteMembership> createMembership(
      final Session session, {
      required final int siteId,
      required final int profileId,
      final bool active = true,
      final String? secret,
    }) async {
      return SiteMembership.db.insertRow(
        session,
        SiteMembership(
          siteId: siteId,
          profileId: profileId,
          active: active,
          doorCodeSecret: secret,
        ),
      );
    }

    TestSessionBuilder authenticated(final UuidValue authUserId) =>
        sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.uuid,
            {},
          ),
        );

    test('when the caller has an active membership then the secret is '
        'returned', () async {
      final session = sessionBuilder.build();
      final (authUserId, profile) = await createProfile(session);
      final site = await createSite(session);
      await createMembership(
        session,
        siteId: site.id!,
        profileId: profile.id!,
        secret: 'aabbccdd',
      );

      final info = await endpoints.doorAccess.getMySiteSecret(
        authenticated(authUserId),
        siteId: site.id!,
      );
      expect(info.siteId, site.id);
      expect(info.siteName, 'Musterbetrieb');
      expect(info.secret, 'aabbccdd');
    });

    test('when the membership has no secret yet then one is generated '
        'lazily', () async {
      final session = sessionBuilder.build();
      final (authUserId, profile) = await createProfile(session);
      final site = await createSite(session);
      await createMembership(
        session,
        siteId: site.id!,
        profileId: profile.id!,
      );

      final info = await endpoints.doorAccess.getMySiteSecret(
        authenticated(authUserId),
        siteId: site.id!,
      );
      expect(info.secret, hasLength(64));

      final stored = await SiteMembership.db.findFirstRow(session);
      expect(stored?.doorCodeSecret, info.secret);
    });

    test('when the membership is inactive then access is rejected', () async {
      final session = sessionBuilder.build();
      final (authUserId, profile) = await createProfile(session);
      final site = await createSite(session);
      await createMembership(
        session,
        siteId: site.id!,
        profileId: profile.id!,
        active: false,
      );

      await expectLater(
        endpoints.doorAccess.getMySiteSecret(
          authenticated(authUserId),
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test('when the caller is not a member then access is rejected', () async {
      final session = sessionBuilder.build();
      final (authUserId, profile) = await createProfile(session);
      final site = await createSite(session);

      await expectLater(
        endpoints.doorAccess.getMySiteSecret(
          authenticated(authUserId),
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
      expect(profile.id, isNotNull);
    });
  });
}
