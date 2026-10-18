/// Backend-agnostic contract for the local door-device admin
/// (`doorDeviceAdmin` endpoint on the local server). Implemented by the
/// local admin app as a thin adapter over its generated client — this
/// package never imports generated client types.
library;

/// One registered doorinterface (ESP32) in the LAN.
class DoorDeviceData {
  final int id;
  final String name;
  final String address;

  const DoorDeviceData({
    required this.id,
    required this.name,
    required this.address,
  });
}

/// Result of probing the device (`/api/status`) — mirrors the ESP JSON
/// losslessly (null = field not present / no answer).
class DoorDeviceStatusData {
  final bool ok;
  final String? error;

  final String? wifiSsid;
  final int? wifiRssi;
  final String? wifiIp;

  final bool? locksAvailable;
  final bool? locksPaired;
  final bool? locksPairing;
  final int? locksCount;
  final String? locksLockState;
  final int? locksBatteryPct;
  final bool? locksBatteryCritical;
  final int? locksRssi;

  final String? firmwareVersion;

  const DoorDeviceStatusData({
    required this.ok,
    this.error,
    this.wifiSsid,
    this.wifiRssi,
    this.wifiIp,
    this.locksAvailable,
    this.locksPaired,
    this.locksPairing,
    this.locksCount,
    this.locksLockState,
    this.locksBatteryPct,
    this.locksBatteryCritical,
    this.locksRssi,
    this.firmwareVersion,
  });
}

/// Result of pushing the backend config (serverUrl + siteId) to a
/// device (ESP ACK: {ok, mac, hostname}).
class DoorDevicePushData {
  final bool ok;
  final String? error;
  final String? mac;
  final String? hostname;

  const DoorDevicePushData({
    required this.ok,
    this.error,
    this.mac,
    this.hostname,
  });
}

/// Injected backend access for the shared door-device screens.
abstract interface class DoorDeviceApi {
  /// All registered devices (newest first).
  Future<List<DoorDeviceData>> listDevices();

  /// Registers a new device ("Gerät hinzufügen") — the backend config
  /// push happens server-side right after.
  Future<DoorDeviceData> addDevice({
    required final String name,
    required final String address,
  });

  /// Updates display name and/or address.
  Future<DoorDeviceData> updateDevice({
    required final int id,
    final String? name,
    final String? address,
  });

  /// Removes the registry entry (hard delete — it's just an address row).
  Future<void> removeDevice({required final int id});

  /// Pushes the backend config (serverUrl + siteId) to the device.
  Future<DoorDevicePushData> pushConfig({required final int id});

  /// Probes the device's `/api/status` (server-side call).
  Future<DoorDeviceStatusData> testDevice({required final int id});

  /// NUKI entriegeln (`POST /api/nuki/unlock`).
  Future<DoorDeviceStatusData> unlockNuki({required final int id});

  /// NUKI verriegeln (`POST /api/nuki/lock`).
  Future<DoorDeviceStatusData> lockNuki({required final int id});

  /// NUKI entsichern/Unlatch (`POST /api/nuki/open`).
  Future<DoorDeviceStatusData> openNuki({required final int id});
}

/// The device's base URL (`http://<address>`) for the host-provided
/// web-interface deep link.
String doorDeviceWebUrl(final String address) => 'http://$address';
