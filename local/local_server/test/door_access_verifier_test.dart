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
  const deviceMacNormalized = 'A4CF129D71E2';
  const otherMac = 'AA:BB:CC:DD:EE:FF';
  const siteId = 42;

  // Fixed verification time: Monday 2026-01-05, 10:00 local.
  final now = DateTime(2026, 1, 5, 10, 0, 0);
  final monday = now.weekday - 1; // 0
  final timestampMs = now.toUtc().millisecondsSinceEpoch;

  final userKey = UuidValue.fromString(
    '3f2a4c1e-0000-4000-8000-000000000001',
  );

  withServerpod('Given DoorAccessVerifier', (sessionBuilder, endpoints) {
    late DoorAccessVerifier verifier;

    setUpAll(() async {
      verifier = DoorAccessVerifier();
    });

    String codeFor({required int timestampMs, String mac = deviceMac}) =>
        door_code.computeDoorCode(
          secretHex: secret,
          timestampMs: timestampMs,
          deviceMac: mac,
        );

    Future<AccessPolicy> seedPolicy(
      final Session session, {
      required final UuidValue forUser,
      required final int memberProfileId,
      final int? deviceId,
      final int? weekday,
      final int startMinute = 0,
      final int endMinute = 1440,
      final DateTime? validFrom,
      final DateTime? validUntil,
    }) async {
      final policy = await AccessPolicy.db.insertRow(
        session,
        AccessPolicy(name: 'Test-Policy'),
      );
      await AccessPolicyRule.db.insertRow(
        session,
        AccessPolicyRule(
          policyId: policy.id!,
          deviceId: deviceId,
          weekday: weekday ?? monday,
          startMinute: startMinute,
          endMinute: endMinute,
        ),
      );
      await AccessPolicyMember.db.insertRow(
        session,
        AccessPolicyMember(
          policyId: policy.id!,
          memberProfileId: memberProfileId,
          globalAuthUserId: forUser,
          validFrom: validFrom ?? now.subtract(const Duration(days: 1)),
          validUntil: validUntil,
        ),
      );
      return policy;
    }

    /// Seeds site connection, member (with TOTP secret + active
    /// membership) and one registered device (normalized MAC); returns
    /// the profile id.
    Future<int> seed({
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
        await DoorDevice.db.insertRow(
          session,
          DoorDevice(name: 'Tür 1', address: '192.168.1.50', mac: deviceMacNormalized),
        );
        return profile.id!;
      }
      return 0;
    }

    test('when the code is valid and a policy grants the door then access '
        'is granted', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.granted);

      final log = (await DoorAccessLog.db.find(session)).first;
      expect(log.result, DoorAccessResult.granted);
      expect(log.detail, contains('policy'));
    });

    test('when scanning again with a fresh timestamp then access is '
        'granted immediately (no cooldown)', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final secondAt = now.add(const Duration(seconds: 3));
      final secondTs = secondAt.toUtc().millisecondsSinceEpoch;
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: secondTs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: secondTs,
          now: secondAt,
        ),
        DoorAccessResult.granted,
      );
    });

    test('when the same (user, timestamp) is replayed then access is '
        'denied', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final code = codeFor(timestampMs: timestampMs);
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: code,
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
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
          timestampMs: timestampMs,
          now: now.add(const Duration(seconds: 5)),
        ),
        DoorAccessResult.denied,
      );
      expect(
        (await DoorAccessLog.db.find(session)).last.detail,
        contains('replay'),
      );
    });

    test('when a policy denies the request then the timestamp is NOT '
        'burned (retry works after fixing the policy)', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      // Policy that does NOT grant (wrong weekday).
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        weekday: monday + 1,
      );
      final code = codeFor(timestampMs: timestampMs);
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: code,
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.denied,
      );
      // Fix the rule window → the SAME (user, ts) must still be usable.
      final rule = (await AccessPolicyRule.db.find(session)).first;
      await AccessPolicyRule.db.updateRow(
        session,
        rule.copyWith(weekday: monday),
      );
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: code,
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.granted,
      );
    });

    test('when the timestamp is outside the skew window with a valid code '
        'then the result is timeSkew', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final staleTs = now
          .subtract(const Duration(seconds: 45))
          .toUtc()
          .millisecondsSinceEpoch;
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: staleTs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: staleTs,
        now: now,
      );
      expect(result, DoorAccessResult.timeSkew);
    });

    test('when the timestamp drifts within the skew window then access is '
        'granted', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final driftedTs = now
          .subtract(const Duration(seconds: 25))
          .toUtc()
          .millisecondsSinceEpoch;
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: driftedTs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: driftedTs,
          now: now,
        ),
        DoorAccessResult.granted,
      );
    });

    test('when no policy is assigned then access is denied (deny-by-default)',
        () async {
      await seed();
      final session = sessionBuilder.build();
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.denied);
      expect(
        (await DoorAccessLog.db.find(session)).first.detail,
        'no active policy assignment',
      );
    });

    test('when the assignment is expired then access is denied', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        validUntil: now.subtract(const Duration(minutes: 1)),
      );
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when the assignment is not yet valid then access is denied',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        validFrom: now.add(const Duration(minutes: 10)),
      );
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when the rule is for another weekday then access is denied',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        weekday: monday + 1,
      );
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.denied);
      expect(
        (await DoorAccessLog.db.find(session)).first.detail,
        'outside policy window',
      );
    });

    test('when the rule window does not contain the time then access is '
        'denied', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        startMinute: 12 * 60,
        endMinute: 14 * 60,
      );
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.denied);
      expect(
        (await DoorAccessLog.db.find(session)).first.detail,
        'outside policy window',
      );
    });

    test('when the rule is bound to another door then access is denied',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      final otherDevice = await DoorDevice.db.insertRow(
        session,
        DoorDevice(
          name: 'Tür 2',
          address: '192.168.1.51',
          mac: door_code.normalizeDeviceMac(otherMac),
        ),
      );
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        deviceId: otherDevice.id!,
      );
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.denied);
    });

    test('when the rule grants all doors then any registered door is '
        'granted', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await DoorDevice.db.insertRow(
        session,
        DoorDevice(
          name: 'Tür 2',
          address: '192.168.1.51',
          mac: door_code.normalizeDeviceMac(otherMac),
        ),
      );
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        deviceId: null,
      );
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs, mac: otherMac),
        deviceMac: otherMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.granted);
    });

    test('when two policies OR-combine then one matching rule is enough',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      final otherDevice = await DoorDevice.db.insertRow(
        session,
        DoorDevice(
          name: 'Tür 2',
          address: '192.168.1.51',
          mac: door_code.normalizeDeviceMac(otherMac),
        ),
      );
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        deviceId: otherDevice.id!,
      );
      await seedPolicy(
        session,
        forUser: userKey,
        memberProfileId: profileId,
        deviceId: null,
      );
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: deviceMac,
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.granted);
    });

    test('when the reporting device is unknown then access is denied',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      final result = await verifier.verify(
        session,
        userKey: userKey,
        code: codeFor(timestampMs: timestampMs),
        deviceMac: '11:22:33:44:55:66',
        siteId: siteId,
        timestampMs: timestampMs,
        now: now,
      );
      expect(result, DoorAccessResult.denied);
    });

    test('when the code is wrong then access is denied', () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: '000000',
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when the siteId does not match then the request is invalid',
        () async {
      await seed();
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId + 1,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.invalid,
      );
    });

    test('when the user is unknown then access is denied', () async {
      await seed(withMember: false);
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
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
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.denied,
      );
    });

    test('when there is no site connection then the request is invalid',
        () async {
      await seed(withConnection: false);
      final session = sessionBuilder.build();
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.invalid,
      );
    });

    test('when denied attempts pile up then the user is rate limited',
        () async {
      final profileId = await seed();
      final session = sessionBuilder.build();
      await seedPolicy(session, forUser: userKey, memberProfileId: profileId);
      for (var i = 0; i < DoorAccessVerifier.maxDeniedPerMinute; i++) {
        expect(
          await verifier.verify(
            session,
            userKey: userKey,
            code: '00000$i',
            deviceMac: deviceMac,
            siteId: siteId,
            timestampMs: timestampMs,
            now: now,
          ),
          DoorAccessResult.denied,
        );
      }
      expect(
        await verifier.verify(
          session,
          userKey: userKey,
          code: codeFor(timestampMs: timestampMs),
          deviceMac: deviceMac,
          siteId: siteId,
          timestampMs: timestampMs,
          now: now,
        ),
        DoorAccessResult.rateLimited,
      );
    });
  });
}
