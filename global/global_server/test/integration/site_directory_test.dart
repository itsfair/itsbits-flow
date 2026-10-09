import 'package:global_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the siteDirectory endpoints', (
    sessionBuilder,
    endpoints,
  ) {
    // -- Helpers (DB seeding; tests bypass the IdP and assemble rows)

    Future<(UuidValue authUserId, MemberProfile profile)> createProfile(
      final Session session, {
      final String? firstName = 'Alex',
      final String? lastName = 'Muster',
    }) async {
      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      final profile = await MemberProfile.db.insertRow(
        session,
        MemberProfile(
          authUserId: authUser.id!,
          email: 'alex@example.com',
          firstName: firstName,
          lastName: lastName,
          birthday: DateTime.utc(1985, 7, 1),
        ),
      );
      return (authUser.id!, profile);
    }

    Future<Site> createSite(
      final Session session, {
      final SiteSetupStatus status = SiteSetupStatus.registered,
      final DateTime? lastSeenAt,
    }) async {
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
          status: status,
          lastSeenAt: lastSeenAt,
          firstAdminId: authUser.id!,
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

    test('when browsing anonymously only registered sites are listed',
        () async {
      final session = sessionBuilder.build();
      await createSite(session, lastSeenAt: DateTime.now());
      await createSite(session, status: SiteSetupStatus.pendingSetup);

      final listed = await endpoints.siteDirectory.listSites(
        sessionBuilder,
        offset: 0,
        limit: 50,
      );
      final latest = await endpoints.siteDirectory.listLatest(
        sessionBuilder,
        limit: 5,
      );
      final total = await endpoints.siteDirectory.countSites(sessionBuilder);

      expect(listed, hasLength(1));
      expect(latest, hasLength(1));
      expect(total, 1);
    });

    test('when querying getSite for a pendingSetup site it is not found',
        () async {
      final session = sessionBuilder.build();
      final pending = await createSite(
        session,
        status: SiteSetupStatus.pendingSetup,
      );

      await expectLater(
        () => endpoints.siteDirectory.getSite(
          sessionBuilder,
          siteId: pending.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test('when subscribing without login it fails', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());

      await expectLater(
        () => endpoints.siteDirectory.subscribe(
          sessionBuilder,
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test('when subscribing to an offline site it is rejected', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: null);
      final (authUserId, _) = await createProfile(session);

      await expectLater(
        () => endpoints.siteDirectory.subscribe(
          authenticated(authUserId),
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test('when subscribing with an incomplete profile it is rejected',
        () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final (authUserId, _) =
          await createProfile(session, firstName: null, lastName: null);

      await expectLater(
        () => endpoints.siteDirectory.subscribe(
          authenticated(authUserId),
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test(
        'when subscribing a complete user it creates the membership and '
        'enqueues the delivery exactly once', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final (authUserId, profile) = await createProfile(session);

      final membership = await endpoints.siteDirectory.subscribe(
        authenticated(authUserId),
        siteId: site.id!,
      );

      expect(membership.active, true);
      expect(membership.roleName, 'member');
      expect(membership.siteId, site.id);

      final tasks = await SiteSyncTask.db.find(session);
      expect(tasks, hasLength(1));
      expect(tasks.single.siteId, site.id);
      expect(tasks.single.profileId, profile.id);

      await expectLater(
        () => endpoints.siteDirectory.subscribe(
          authenticated(authUserId),
          siteId: site.id!,
        ),
        throwsA(isA<SiteAdminException>()),
      );
    });

    test('when saving the profile twice the queue collapses to one row',
        () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final (authUserId, profile) = await createProfile(session);
      final authed = authenticated(authUserId);

      // The queue only follows sites with an ACTIVE membership.
      await endpoints.siteDirectory.subscribe(authed, siteId: site.id!);
      await endpoints.memberProfile.save(
        authed,
        firstName: 'Alex',
        lastName: 'Muster-Zwo',
        birthday: DateTime.utc(1985, 7, 1),
      );
      await endpoints.memberProfile.save(
        authed,
        firstName: 'Alex',
        lastName: 'Muster-Drei',
        birthday: DateTime.utc(1985, 7, 1),
      );

      final tasks = await SiteSyncTask.db.find(session);
      expect(tasks, hasLength(1));
      expect(tasks.single.siteId, site.id);
      expect(tasks.single.profileId, profile.id);
    });

    test(
        'when unsubscribing the membership is deactivated and marked '
        '(not deleted)', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final (authUserId, _) = await createProfile(session);
      final authed = authenticated(authUserId);

      await endpoints.siteDirectory.subscribe(authed, siteId: site.id!);
      await endpoints.siteDirectory.unsubscribe(authed, siteId: site.id!);

      final membershipRow = (await SiteMembership.db.find(session)).single;
      expect(membershipRow.active, false);
      expect(membershipRow.endedAt, isNotNull);
    });

    test(
        'when a device session pulls pending tasks it receives the current '
        'state and the tasks are deleted after confirming', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final (authUserId, profile) = await createProfile(session);
      await endpoints.siteDirectory.subscribe(
        authenticated(authUserId),
        siteId: site.id!,
      );

      // Fake device session pointing at the site (SAS auth simulation).
      final deviceSessionId = UuidValue.fromString('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d');
      await SiteDeviceSession.db.insertRow(
        session,
        SiteDeviceSession(
          siteId: site.id!,
          serverSideSessionId: deviceSessionId,
        ),
      );
      final deviceSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUserId.uuid,
          {const Scope('site-device')},
          authId: deviceSessionId.uuid,
        ),
      );

      final payload = await endpoints.siteSync.pullPending(deviceSession);
      expect(payload, hasLength(1));
      expect(payload.single.globalAuthUserId, authUserId);
      expect(payload.single.active, true);
      expect(payload.single.email, 'alex@example.com');

      await endpoints.siteSync.confirmProcessed(
        deviceSession,
        taskIds: [payload.single.taskId],
      );
      expect(await SiteSyncTask.db.find(session), isEmpty);
    });

    test(
        'when a device session has no pending tasks pullPending returns '
        'empty', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session, lastSeenAt: DateTime.now());
      final deviceSessionId = UuidValue.fromString('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d');
      await SiteDeviceSession.db.insertRow(
        session,
        SiteDeviceSession(
          siteId: site.id!,
          serverSideSessionId: deviceSessionId,
        ),
      );
      final deviceSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'unused-by-site-resolution',
          {const Scope('site-device')},
          authId: deviceSessionId.uuid,
        ),
      );

      final payload = await endpoints.siteSync.pullPending(deviceSession);
      expect(payload, isEmpty);
    });
  });
}
