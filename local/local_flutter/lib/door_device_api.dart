import 'package:itsbits_shared/door_device_directory.dart';
import 'package:local_client/local_client.dart' as lc;

/// Adapter mapping the generated local-client `doorDeviceAdmin` endpoint
/// onto the shared [DoorDeviceApi] contract. All device HTTP calls happen
/// server-side; the app only talks to its own backend.
class LocalDoorDeviceApi implements DoorDeviceApi {
  final lc.Client _client;

  LocalDoorDeviceApi(this._client);

  @override
  Future<List<DoorDeviceData>> listDevices() async =>
      (await _client.doorDeviceAdmin.listDevices()).map(_toData).toList();

  @override
  Future<DoorDeviceData> addDevice({
    required final String name,
    required final String address,
  }) async => _toData(
    await _client.doorDeviceAdmin.addDevice(name: name, address: address),
  );

  @override
  Future<DoorDeviceData> updateDevice({
    required final int id,
    final String? name,
    final String? address,
  }) async => _toData(
    await _client.doorDeviceAdmin.updateDevice(
      id: id,
      name: name,
      address: address,
    ),
  );

  @override
  Future<void> removeDevice({required final int id}) =>
      _client.doorDeviceAdmin.removeDevice(id: id);

  @override
  Future<DoorDevicePushData> pushConfig({required final int id}) async {
    final result = await _client.doorDeviceAdmin.pushConfig(id: id);
    return DoorDevicePushData(
      ok: result.ok,
      error: result.error,
      mac: result.mac,
      hostname: result.hostname,
    );
  }

  @override
  Future<DoorDeviceStatusData> testDevice({required final int id}) async =>
      _toStatusData(await _client.doorDeviceAdmin.testDevice(id: id));

  @override
  Future<DoorDeviceStatusData> unlockNuki({required final int id}) async =>
      _toStatusData(await _client.doorDeviceAdmin.unlockNuki(id: id));

  @override
  Future<DoorDeviceStatusData> lockNuki({required final int id}) async =>
      _toStatusData(await _client.doorDeviceAdmin.lockNuki(id: id));

  @override
  Future<DoorDeviceStatusData> openNuki({required final int id}) async =>
      _toStatusData(await _client.doorDeviceAdmin.openNuki(id: id));

  DoorDeviceData _toData(final lc.DoorDevice row) => DoorDeviceData(
    id: row.id!,
    name: row.name,
    address: row.address,
  );

  DoorDeviceStatusData _toStatusData(final lc.DoorDeviceStatus status) =>
      DoorDeviceStatusData(
        ok: status.ok,
        error: status.error,
        wifiSsid: status.wifiSsid,
        wifiRssi: status.wifiRssi,
        wifiIp: status.wifiIp,
        locksAvailable: status.locksAvailable,
        locksPaired: status.locksPaired,
        locksPairing: status.locksPairing,
        locksCount: status.locksCount,
        locksLockState: status.locksLockState,
        locksBatteryPct: status.locksBatteryPct,
        locksBatteryCritical: status.locksBatteryCritical,
        locksRssi: status.locksRssi,
        firmwareVersion: status.firmwareVersion,
      );
}
