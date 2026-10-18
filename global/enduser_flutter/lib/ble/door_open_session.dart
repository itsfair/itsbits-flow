import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

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

/// One-shot BLE session against a doorinterface: resolve Bluetooth
/// state (WAIT for it — the manager resolves its state asynchronously,
/// see diag report) → connect → MTU → discover → subscribe → write the
/// verify request (code is computed by the caller with a fresh
/// timestamp) → await the notify response → disconnect.
///
/// EVERY await carries a timeout so a hanging GATT operation can never
/// freeze the UI and the guaranteed cleanup (disconnect) always runs —
/// no connection leaks that poison later attempts.
///
/// Uses `bluetooth_low_energy` (Apache-2.0). Android-first: the device
/// is addressed by its BLE MAC from the QR code.
class DoorOpenSession {
  Future<DoorOpenResult> run({
    required final String remoteId,
    required final String requestJson,
  }) async {
    final manager = CentralManager();
    Peripheral? peripheral;
    StreamSubscription<dynamic>? notifySub;
    try {
      final bluetoothError = await _awaitBluetoothReady(manager);
      if (bluetoothError != null) {
        return DoorOpenResult(
          finalPhase: DoorOpenPhase.error,
          success: false,
          errorMessage: bluetoothError,
        );
      }

      peripheral = await manager.getPeripheral(remoteId);
      await manager.connect(peripheral).timeout(BleConstants.connectTimeout);

      // Android defaults to MTU 23 (20 payload bytes) — without an
      // explicit request both the request JSON and the ESP's response
      // get truncated. The ESP caps negotiation at its setMTU(128).
      try {
        await manager.requestMTU(peripheral, mtu: 185).timeout(_mtuTimeout);
      } on UnsupportedError catch (_) {}

      final services = await manager
          .discoverGATT(peripheral)
          .timeout(_discoveryTimeout);
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
      await manager
          .setCharacteristicNotifyState(peripheral, responseChar, state: true)
          .timeout(_opTimeout);

      await manager
          .writeCharacteristic(
            peripheral,
            requestChar,
            value: Uint8List.fromList(utf8.encode(requestJson)),
            type: GATTCharacteristicWriteType.withResponse,
          )
          .timeout(_opTimeout);

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
        errorMessage:
            'Verbindung zum Gerät ist nicht stabil — bitte erneut '
            'scannen.',
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
          await manager.disconnect(peripheral).timeout(_opTimeout);
        } catch (_) {}
      }
    }
  }

  Future<String?> _awaitBluetoothReady(final CentralManager manager) async {
    const resolveTimeout = Duration(seconds: 5);
    if (manager.state == BluetoothLowEnergyState.poweredOn) return null;

    for (var attempt = 0; attempt < 3; attempt++) {
      final completer = Completer<BluetoothLowEnergyState>();
      final sub = manager.stateChanged.listen(
        (args) {
          if (!completer.isCompleted) completer.complete(args.state);
        },
      );
      BluetoothLowEnergyState state;
      try {
        state = await completer.future.timeout(resolveTimeout);
      } on TimeoutException {
        await sub.cancel();
        return 'Bluetooth-Status konnte nicht ermittelt werden — '
            'bitte erneut scannen.';
      } finally {
        await sub.cancel();
      }

      if (state == BluetoothLowEnergyState.poweredOn) return null;
      if (state == BluetoothLowEnergyState.unauthorized) {
        // Pops the Android permission dialog; the next loop iteration
        // waits for the resulting state change.
        await manager.authorize();
        continue;
      }
      return switch (state) {
        BluetoothLowEnergyState.unsupported =>
          'Bluetooth wird von diesem Gerät nicht unterstützt.',
        BluetoothLowEnergyState.poweredOff => 'Bluetooth ist ausgeschaltet.',
        _ => 'Bluetooth ist nicht verfügbar.',
      };
    }
    return 'Bluetooth-Berechtigung wurde nicht erteilt — bitte erneut '
        'scannen.';
  }
}

const Duration _mtuTimeout = Duration(seconds: 5);
const Duration _discoveryTimeout = Duration(seconds: 10);
const Duration _opTimeout = Duration(seconds: 5);

bool _sameUuid(final UUID a, final UUID b) {
  for (var i = 0; i < 16; i++) {
    if (a.value[i] != b.value[i]) return false;
  }
  return true;
}
