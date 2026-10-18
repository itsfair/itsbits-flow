import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:itsbits_shared/door_code.dart' as door_code;

import 'ble_constants.dart';

/// Phases of one door-open attempt (for the progress UI).
enum DoorOpenPhase {
  preparing,
  connecting,
  verifying,
  done,
  error,
}

/// Result of one door-open attempt: [success] mirrors the ESP response;
/// [responseCode]/[responseMessage] are the raw ESP values (already
/// mapped to user-facing text by the screen).
class DoorOpenResult {
  final DoorOpenPhase finalPhase;
  final bool success;
  final String? responseCode;
  final String? responseMessage;
  final String? errorMessage;

  const DoorOpenResult({
    required this.finalPhase,
    required this.success,
    this.responseCode,
    this.responseMessage,
    this.errorMessage,
  });
}

/// One-shot BLE session against a doorinterface: connect → discover →
/// subscribe → compute the rolling door code (TOTP, door-bound) → write
/// the verify request → await the notify response → disconnect.
///
/// Uses `bluetooth_low_energy` (Apache-2.0) instead of flutter_blue_plus
/// (proprietary license at connect since 2.x). Android-first: the device
/// is addressed by its BLE MAC from the QR code.
class DoorOpenSession {
  Future<DoorOpenResult> run({
    required final String remoteId,
    required final int siteId,
    required final String userKey,
    required final String secretHex,
  }) async {
    final manager = CentralManager();
    Peripheral? peripheral;
    StreamSubscription<dynamic>? notifySub;
    try {
      final state = manager.state;
      if (state == BluetoothLowEnergyState.unauthorized) {
        await manager.authorize();
      }
      if (manager.state != BluetoothLowEnergyState.poweredOn) {
        return const DoorOpenResult(
          finalPhase: DoorOpenPhase.error,
          success: false,
          errorMessage: 'Bluetooth ist nicht aktiv oder nicht berechtigt.',
        );
      }

      peripheral = await manager.getPeripheral(remoteId);
      await manager.connect(peripheral).timeout(BleConstants.connectTimeout);

      // Android defaults to MTU 23 (20 payload bytes) — without an
      // explicit request both the ~100-byte request JSON and the ESP's
      // response get truncated (FormatException on the response JSON).
      // The ESP caps negotiation at its local setMTU(128).
      try {
        await manager.requestMTU(peripheral, mtu: 185);
      } on UnsupportedError catch (_) {}

      final services = await manager.discoverGATT(peripheral);
      GATTCharacteristic? requestChar;
      GATTCharacteristic? responseChar;
      for (final service in services) {
        if (!_sameUuid(service.uuid, BleConstants.service)) continue;
        for (final characteristic in service.characteristics) {
          if (_sameUuid(characteristic.uuid, BleConstants.requestChar)) {
            requestChar = characteristic;
          } else if (_sameUuid(
            characteristic.uuid,
            BleConstants.responseChar,
          )) {
            responseChar = characteristic;
          }
        }
      }
      if (requestChar == null || responseChar == null) {
        return const DoorOpenResult(
          finalPhase: DoorOpenPhase.error,
          success: false,
          errorMessage: 'DoorInterface-Dienst nicht gefunden.',
        );
      }

      final completer = Completer<String>();
      notifySub = manager.characteristicNotified.listen((args) {
        if (_sameUuid(args.characteristic.uuid, BleConstants.responseChar) &&
            !completer.isCompleted) {
          completer.complete(utf8.decode(args.value, allowMalformed: true));
        }
      });
      await manager.setCharacteristicNotifyState(
        peripheral,
        responseChar,
        state: true,
      );

      final code = door_code.computeDoorCode(
        secretHex: secretHex,
        step: door_code.doorCodeStep(DateTime.now()),
        deviceMac: remoteId,
      );
      final request = jsonEncode({
        'action': 'open',
        'userId': userKey,
        'code': code,
        'deviceId': 'flutter-enduser',
      });
      await manager.writeCharacteristic(
        peripheral,
        requestChar,
        value: Uint8List.fromList(utf8.encode(request)),
        type: GATTCharacteristicWriteType.withResponse,
      );

      final responseJson = await completer.future.timeout(
        BleConstants.responseTimeout,
      );
      final response = jsonDecode(responseJson) as Map<String, dynamic>;
      final success = response['success'] == true;
      return DoorOpenResult(
        finalPhase: success ? DoorOpenPhase.done : DoorOpenPhase.error,
        success: success,
        responseCode: response['code'] as String?,
        responseMessage: response['message'] as String?,
      );
    } on TimeoutException {
      return const DoorOpenResult(
        finalPhase: DoorOpenPhase.error,
        success: false,
        errorMessage: 'Keine Antwort vom Gerät (Timeout).',
      );
    } on FormatException catch (e) {
      return DoorOpenResult(
        finalPhase: DoorOpenPhase.error,
        success: false,
        errorMessage:
            'Antwort vom Gerät unvollständig ($e) — bitte erneut '
            'versuchen.',
      );
    } catch (e) {
      return DoorOpenResult(
        finalPhase: DoorOpenPhase.error,
        success: false,
        errorMessage: 'BLE-Fehler: $e',
      );
    } finally {
      await notifySub?.cancel();
      if (peripheral != null) {
        try {
          await manager.disconnect(peripheral);
        } catch (_) {}
      }
    }
  }
}

bool _sameUuid(final UUID a, final UUID b) {
  for (var i = 0; i < 16; i++) {
    if (a.value[i] != b.value[i]) return false;
  }
  return true;
}
