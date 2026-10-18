import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

/// BLE/QR constants for the DoorInterface self-entry flow + the QR
/// payload parser (`doorinterface|<MAC>|<siteId>`). Spec:
/// doorinterface/docs/ble_interface.md.
abstract final class BleConstants {
  static const String qrPrefix = 'doorinterface|';
  static const String serviceUuid = '5f6d4f5a-0001-0001-8000-00805f9b34fb';
  static const String requestCharUuid = '5f6d4f5a-0002-0001-8000-00805f9b34fb';
  static const String responseCharUuid = '5f6d4f5a-0003-0001-8000-00805f9b34fb';
  static const Duration responseTimeout = Duration(seconds: 25);
  static const Duration connectTimeout = Duration(seconds: 12);

  static final UUID service = UUID.fromString(serviceUuid);
  static final UUID requestChar = UUID.fromString(requestCharUuid);
  static final UUID responseChar = UUID.fromString(responseCharUuid);
}

class ParsedQr {
  final String remoteId;
  final int? siteId;

  const ParsedQr({required this.remoteId, this.siteId});

  static ParsedQr? tryParse(String raw) {
    if (!raw.startsWith(BleConstants.qrPrefix)) return null;
    final rest = raw.substring(BleConstants.qrPrefix.length);
    final parts = rest.split('|');
    if (parts.isEmpty || parts.first.isEmpty) return null;
    final remoteId = parts.first.toUpperCase();
    if (!_isValidMac(remoteId)) return null;
    final siteId = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;
    return ParsedQr(remoteId: remoteId, siteId: siteId);
  }

  static bool _isValidMac(String mac) {
    final re = RegExp(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$');
    return re.hasMatch(mac);
  }
}
