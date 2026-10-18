import 'package:itsbits_shared/door_code.dart' as door_code;
import 'package:local_server/src/door/door_access_verifier.dart';
import 'package:local_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  const secret =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
  const deviceMac = 'A4:CF:12:9D:71:E2';
  const siteId = 42;
  final userKey = UuidValue.fromString(
    '3f2a4c1e-0000-4000-8000-000000000001',
  );

  withServerpod('Given DoorAccessVerifier', (sessionBuilder, endpoints) {
    late DoorAccessVerifier verifier;

    setUpAll(() async {
      verifier = DoorAccessVerifier();
    });

    Future<void> seed({
      bool withConnection = true,
      bool withMember = true,
      bool active = true,
      String? secretValue = secret,
    }) async {
      final session = sessionBuilder.build();
      if (withConnection) {
        await SiteConnection.db.insertRow(
          session,
          SiteConnection(
            globalApiUrl: 'http://localhost:8080',
            siteId: siteId,
            siteName: 'Testsite',
          ),
        );
      }
      if (withMember) {
        final profile = await MemberProfile.db.insertRow(
          session,
          MemberProfile(
            globalAuthUserId: userKey,
            email: 'member@example.com',
            doorCodeSecret: secretValue,
          ),
        );
        await MemberMembership.db.insertRow(
          session,
          MemberMembership(
            memberProfileId: profile.id!,
            globalAuthUserId: userKey,
            active: active,
          ),
        );
      }
    }

    String codeFor({required int step, String mac = deviceMac}) =>
        door_code.computeDoorCode(
          secretHex: secret,
          step: step,
          deviceMac: mac,
        );

    test('when the code is valid then access is granted and the log row '
        'exists', () async {
      await seed();
      final session = sessionBuilder.build();
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
        deviceMac: deviceMac,
        siteId: siteId,
      );
      expect(result, DoorAccessResult.granted);

      final logs = await DoorAccessLog.db.find(session);
      expect(logs, hasLength(1));
      expect(logs.single.result, DoorAccessResult.granted);
    });

    test('when the same code is replayed then access is denied', () async {
      await seed();
      final session = sessionBuilder.build();
      final code = codeFor(step: door_code.doorCodeStep(DateTime.now()));
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: code,
          deviceMac: deviceMac,
          siteId: siteId,
        ),
        DoorAccessResult.granted,
      );
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: code,
          deviceMac: deviceMac,
          siteId: siteId,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when the code is wrong then access is denied', () async {
      await seed();
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: '000000',
          deviceMac: deviceMac,
          siteId: siteId,
        ),
        DoorAccessResult.denied,
      );
    });

    test(
      'when the code is bound to another door then access is denied',
      () async {
        await seed();
        final session = sessionBuilder.build();
        expect(
          await verifier.verify(
            session,
            userKey: userKey,
            code: codeFor(
              step: door_code.doorCodeStep(DateTime.now()),
              mac: 'AA:BB:CC:DD:EE:FF',
            ),
            deviceMac: deviceMac,
            siteId: siteId,
          ),
          DoorAccessResult.denied,
        );
      },
    );

    test(
      'when the siteId does not match then the request is invalid',
      () async {
        await seed();
        final session = sessionBuilder.build();
        expect(
          await verifier.verify(
            session,
            userKey: userKey,
            code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
            deviceMac: deviceMac,
            siteId: siteId + 1,
          ),
          DoorAccessResult.invalid,
        );
      },
    );

    test('when the user is unknown then access is denied', () async {
      await seed(withMember: false);
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
          deviceMac: deviceMac,
          siteId: siteId,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when the membership is inactive then access is denied', () async {
      await seed(active: false);
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
          deviceMac: deviceMac,
          siteId: siteId,
        ),
        DoorAccessResult.denied,
      );
    });

    test(
      'when there is no site connection then the request is invalid',
      () async {
        await seed(withConnection: false);
        final session = sessionBuilder.build();
        expect(
          await verifier.verify(
            session,
            userKey: userKey,
            code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
            deviceMac: deviceMac,
            siteId: siteId,
          ),
          DoorAccessResult.invalid,
        );
      },
    );

    test(
      'when denied attempts pile up then the user is rate limited',
      () async {
        await seed();
        final session = sessionBuilder.build();
        for (var i = 0; i < DoorAccessVerifier.maxDeniedPerMinute; i++) {
          expect(
            await verifier.verify(
              session,
              userKey: userKey,
              code: '00000$i',
              deviceMac: deviceMac,
              siteId: siteId,
            ),
            DoorAccessResult.denied,
          );
        }
        expect(
          await verifier.verify(
            session,
            userKey: userKey,
            code: codeFor(step: door_code.doorCodeStep(DateTime.now())),
            deviceMac: deviceMac,
            siteId: siteId,
          ),
          DoorAccessResult.rateLimited,
        );
      },
    );
  });
}
