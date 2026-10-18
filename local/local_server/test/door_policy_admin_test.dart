import 'package:local_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  final userKey = UuidValue.fromString(
    '3f2a4c1e-0000-4000-8000-000000000001',
  );

  withServerpod('Given DoorPolicyAdminEndpoint', (sessionBuilder, endpoints) {
    TestSessionBuilder admin() => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo('admin', {
        const Scope('local-admin'),
      }),
    );

    Future<int> seedMember(final Session session) async {
      final profile = await MemberProfile.db.insertRow(
        session,
        MemberProfile(
          globalAuthUserId: userKey,
          email: 'member@example.com',
          firstName: 'Alex',
          lastName: 'Muster',
        ),
      );
      return profile.id!;
    }

    Future<int> seedDevice(final Session session) async {
      final device = await DoorDevice.db.insertRow(
        session,
        DoorDevice(name: 'Tür 1', address: '192.168.1.50'),
      );
      return device.id!;
    }

    test('when unauthenticated then access is denied', () async {
      await expectLater(
        endpoints.doorPolicyAdmin.listPolicies(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test(
      'when creating and listing a policy then counts are correct',
      () async {
        final session = admin();
        final dbSession = sessionBuilder.build();
        await seedMember(dbSession);
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Kurs Yoga',
        );
        await endpoints.doorPolicyAdmin.addRule(
          session,
          policyId: policy.id,
          deviceId: null,
          weekdays: [0, 1],
          startMinute: 14 * 60,
          endMinute: 18 * 60,
        );
        await endpoints.doorPolicyAdmin.addMemberAssignment(
          session,
          policyId: policy.id,
          globalAuthUserId: userKey,
        );

        final listed = await endpoints.doorPolicyAdmin.listPolicies(session);
        expect(listed, hasLength(1));
        expect(listed.first.name, 'Kurs Yoga');
        expect(listed.first.ruleCount, 2);
        expect(listed.first.memberCount, 1);
      },
    );

    test(
      'when adding a rule with an invalid window then it is rejected',
      () async {
        final session = admin();
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Test',
        );
        await expectLater(
          endpoints.doorPolicyAdmin.addRule(
            session,
            policyId: policy.id,
            deviceId: null,
            weekdays: [0],
            startMinute: 18 * 60,
            endMinute: 14 * 60,
          ),
          throwsA(isA<DoorDeviceException>()),
        );
        await expectLater(
          endpoints.doorPolicyAdmin.addRule(
            session,
            policyId: policy.id,
            deviceId: null,
            weekdays: [0],
            startMinute: 10 * 60,
            endMinute: 10 * 60,
          ),
          throwsA(isA<DoorDeviceException>()),
        );
        await expectLater(
          endpoints.doorPolicyAdmin.addRule(
            session,
            policyId: policy.id,
            deviceId: null,
            weekdays: [7],
            startMinute: 10 * 60,
            endMinute: 12 * 60,
          ),
          throwsA(isA<DoorDeviceException>()),
        );
      },
    );

    test(
      'when updating and removing a rule then the detail reflects it',
      () async {
        final session = admin();
        final dbSession = sessionBuilder.build();
        final deviceId = await seedDevice(dbSession);
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Test',
        );
        final rules = await endpoints.doorPolicyAdmin.addRule(
          session,
          policyId: policy.id,
          deviceId: deviceId,
          weekdays: [2],
          startMinute: 8 * 60,
          endMinute: 12 * 60,
        );
        final updated = await endpoints.doorPolicyAdmin.updateRule(
          session,
          ruleId: rules.first.id,
          deviceId: null,
          weekday: 3,
          startMinute: 9 * 60,
          endMinute: 11 * 60,
        );
        expect(updated.deviceId, isNull);
        expect(updated.weekday, 3);

        await endpoints.doorPolicyAdmin.removeRule(
          session,
          ruleId: rules.first.id,
        );
        final detail = await endpoints.doorPolicyAdmin.getPolicy(
          session,
          id: policy.id,
        );
        expect(detail.rules, isEmpty);
      },
    );

    test(
      'when assigning a member twice then the duplicate is rejected',
      () async {
        final session = admin();
        final dbSession = sessionBuilder.build();
        await seedMember(dbSession);
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Test',
        );
        await endpoints.doorPolicyAdmin.addMemberAssignment(
          session,
          policyId: policy.id,
          globalAuthUserId: userKey,
        );
        await expectLater(
          endpoints.doorPolicyAdmin.addMemberAssignment(
            session,
            policyId: policy.id,
            globalAuthUserId: userKey,
          ),
          throwsA(
            isA<DoorDeviceException>().having(
              (e) => e.message,
              'message',
              contains('bereits'),
            ),
          ),
        );
      },
    );

    test(
      'when the assignment period is inverted then it is rejected',
      () async {
        final session = admin();
        final dbSession = sessionBuilder.build();
        await seedMember(dbSession);
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Test',
        );
        await expectLater(
          endpoints.doorPolicyAdmin.addMemberAssignment(
            session,
            policyId: policy.id,
            globalAuthUserId: userKey,
            validFrom: DateTime(2026, 2, 1),
            validUntil: DateTime(2026, 1, 1),
          ),
          throwsA(isA<DoorDeviceException>()),
        );
      },
    );

    test('when updating the assignment period then it is persisted', () async {
      final session = admin();
      final dbSession = sessionBuilder.build();
      await seedMember(dbSession);
      final policy = await endpoints.doorPolicyAdmin.createPolicy(
        session,
        name: 'Test',
      );
      final assignment = await endpoints.doorPolicyAdmin.addMemberAssignment(
        session,
        policyId: policy.id,
        globalAuthUserId: userKey,
      );
      final updated = await endpoints.doorPolicyAdmin.updateMemberAssignment(
        session,
        assignmentId: assignment.id,
        validFrom: DateTime(2026, 2, 1),
        validUntil: DateTime(2026, 3, 1),
      );
      expect(
        updated.validFrom.millisecondsSinceEpoch,
        DateTime(2026, 2, 1).millisecondsSinceEpoch,
      );
      expect(
        updated.validUntil!.millisecondsSinceEpoch,
        DateTime(2026, 3, 1).millisecondsSinceEpoch,
      );

      await endpoints.doorPolicyAdmin.removeMemberAssignment(
        session,
        assignmentId: assignment.id,
      );
      final forUser = await endpoints.doorPolicyAdmin.listPoliciesFor(
        session,
        globalAuthUserId: userKey,
      );
      expect(forUser, isEmpty);
    });

    test(
      'when removing a policy then rules and assignments are gone',
      () async {
        final session = admin();
        final dbSession = sessionBuilder.build();
        await seedMember(dbSession);
        final policy = await endpoints.doorPolicyAdmin.createPolicy(
          session,
          name: 'Weg damit',
        );
        await endpoints.doorPolicyAdmin.addRule(
          session,
          policyId: policy.id,
          deviceId: null,
          weekdays: [0],
          startMinute: 0,
          endMinute: 1440,
        );
        await endpoints.doorPolicyAdmin.addMemberAssignment(
          session,
          policyId: policy.id,
          globalAuthUserId: userKey,
        );

        await endpoints.doorPolicyAdmin.removePolicy(
          session,
          id: policy.id,
        );
        expect(
          await AccessPolicy.db.find(dbSession),
          isEmpty,
        );
        expect(await AccessPolicyRule.db.find(dbSession), isEmpty);
        expect(await AccessPolicyMember.db.find(dbSession), isEmpty);
      },
    );

    test('when renaming an unknown policy then it is rejected', () async {
      await expectLater(
        endpoints.doorPolicyAdmin.updatePolicy(
          admin(),
          id: 424242,
          name: 'Nix',
        ),
        throwsA(isA<DoorDeviceException>()),
      );
    });
  });
}
