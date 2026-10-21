import 'dart:typed_data';

import 'package:global_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the siteDetails endpoint', (sessionBuilder, endpoints) {
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

    TestSessionBuilder deviceSessionFor(final Site site) {
      final deviceSessionId = UuidValue.fromString(
        'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',
      );
      return sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'unused-by-site-resolution',
          {const Scope('site-device')},
          authId: deviceSessionId.uuid,
        ),
      );
    }

    Future<SiteDeviceSession> insertDeviceSessionRow(
      final Session session,
      final Site site,
    ) async {
      return SiteDeviceSession.db.insertRow(
        session,
        SiteDeviceSession(
          siteId: site.id!,
          serverSideSessionId: UuidValue.fromString(
            'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',
          ),
        ),
      );
    }

    Future<void> pushFields(
      final TestSessionBuilder builder,
      final Site site,
    ) async {
      await endpoints.siteDetails.push(
        builder,
        name: 'Neu',
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        removeImage: false,
      );
    }

    test('push with image stores the object path', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session);
      final builder = deviceSessionFor(site);
      await insertDeviceSessionRow(session, site);

      await endpoints.siteDetails.push(
        builder,
        name: site.name,
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        image: ByteData(4),
        removeImage: false,
      );

      final updated = await Site.db.findById(session, site.id!);
      expect(updated?.imageUrl, 'site_images/${site.id}.jpg');
    });

    test('fields-only push after image push preserves the path', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session);
      final builder = deviceSessionFor(site);
      await insertDeviceSessionRow(session, site);

      await endpoints.siteDetails.push(
        builder,
        name: site.name,
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        image: ByteData(4),
        removeImage: false,
      );
      await pushFields(builder, site);

      final updated = await Site.db.findById(session, site.id!);
      expect(updated?.imageUrl, 'site_images/${site.id}.jpg');
      expect(updated?.name, 'Neu');
    });

    test('image push after fields-only push rewrites the path', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session);
      final builder = deviceSessionFor(site);
      await insertDeviceSessionRow(session, site);

      await pushFields(builder, site);
      await endpoints.siteDetails.push(
        builder,
        name: site.name,
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        image: ByteData(4),
        removeImage: false,
      );

      final updated = await Site.db.findById(session, site.id!);
      expect(updated?.name, 'Musterbetrieb');
      expect(updated?.imageUrl, 'site_images/${site.id}.jpg');
    });

    test('removeImage clears the path', () async {
      final session = sessionBuilder.build();
      final site = await createSite(session);
      final builder = deviceSessionFor(site);
      await insertDeviceSessionRow(session, site);

      await endpoints.siteDetails.push(
        builder,
        name: site.name,
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        image: ByteData(4),
        removeImage: false,
      );
      await endpoints.siteDetails.push(
        builder,
        name: site.name,
        street: site.street,
        zipCode: site.zipCode,
        city: site.city,
        country: site.country,
        companyEmail: site.companyEmail,
        removeImage: true,
      );

      final updated = await Site.db.findById(session, site.id!);
      expect(updated?.imageUrl, isNull);
    });
  });
}
