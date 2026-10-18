import 'package:local_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given DoorDeviceAdminEndpoint', (sessionBuilder, endpoints) {
    TestSessionBuilder admin() => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo('admin', {
        const Scope('local-admin'),
      }),
    );

    test(
      'when listing devices unauthenticated then access is denied',
      () async {
        await expectLater(
          endpoints.doorDeviceAdmin.listDevices(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test('when adding a device then it appears in the list', () async {
      final session = admin();
      final device = await endpoints.doorDeviceAdmin.addDevice(
        session,
        name: 'Hauseingang',
        address: '192.168.1.50',
      );
      expect(device.name, 'Hauseingang');
      expect(device.address, '192.168.1.50');

      final devices = await endpoints.doorDeviceAdmin.listDevices(session);
      expect(devices.map((d) => d.id), contains(device.id!));
    });

    test(
      'when adding a device with a path in the address then it is rejected',
      () async {
        await expectLater(
          endpoints.doorDeviceAdmin.addDevice(
            admin(),
            name: 'Keller',
            address: 'http://192.168.1.50/status',
          ),
          throwsA(isA<DoorDeviceException>()),
        );
      },
    );

    test('when adding a duplicate address then it is rejected', () async {
      final session = admin();
      await endpoints.doorDeviceAdmin.addDevice(
        session,
        name: 'Eins',
        address: '10.0.0.5:8080',
      );
      await expectLater(
        endpoints.doorDeviceAdmin.addDevice(
          session,
          name: 'Zwei',
          address: 'http://10.0.0.5:8080/',
        ),
        throwsA(
          isA<DoorDeviceException>().having(
            (e) => e.message,
            'message',
            contains('bereits'),
          ),
        ),
      );
    });

    test(
      'when updating name and address then the changes are persisted',
      () async {
        final session = admin();
        final device = await endpoints.doorDeviceAdmin.addDevice(
          session,
          name: 'Alt',
          address: '192.168.1.60',
        );
        final updated = await endpoints.doorDeviceAdmin.updateDevice(
          session,
          id: device.id!,
          name: 'Neu',
          address: 'door-1a2b.local',
        );
        expect(updated.name, 'Neu');
        expect(updated.address, 'door-1a2b.local');
      },
    );

    test(
      'when updating to the address of another device then it is rejected',
      () async {
        final session = admin();
        final first = await endpoints.doorDeviceAdmin.addDevice(
          session,
          name: 'A',
          address: '192.168.1.61',
        );
        await endpoints.doorDeviceAdmin.addDevice(
          session,
          name: 'B',
          address: '192.168.1.62',
        );
        await expectLater(
          endpoints.doorDeviceAdmin.updateDevice(
            session,
            id: first.id!,
            address: '192.168.1.62',
          ),
          throwsA(isA<DoorDeviceException>()),
        );
      },
    );

    test('when removing a device then it disappears from the list', () async {
      final session = admin();
      final device = await endpoints.doorDeviceAdmin.addDevice(
        session,
        name: 'Weg',
        address: '192.168.1.63',
      );
      await endpoints.doorDeviceAdmin.removeDevice(session, id: device.id!);
      expect(await endpoints.doorDeviceAdmin.listDevices(session), isEmpty);
    });

    test(
      'when testing an unreachable device then the probe fails gracefully',
      () async {
        final session = admin();
        final device = await endpoints.doorDeviceAdmin.addDevice(
          session,
          name: 'Offline',
          address: '127.0.0.1:1',
        );
        final status = await endpoints.doorDeviceAdmin.testDevice(
          session,
          id: device.id!,
        );
        expect(status.ok, isFalse);
        expect(status.error, isNotNull);
      },
    );

    test('when calling a NUKI action on an unreachable device then it fails '
        'gracefully', () async {
      final session = admin();
      final device = await endpoints.doorDeviceAdmin.addDevice(
        session,
        name: 'Offline',
        address: '127.0.0.1:1',
      );
      final status = await endpoints.doorDeviceAdmin.unlockNuki(
        session,
        id: device.id!,
      );
      expect(status.ok, isFalse);
      expect(status.error, isNotNull);
    });
  });
}
