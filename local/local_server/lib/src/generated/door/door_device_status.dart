/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Result of probing one doorinterface's HTTP API (server-side call to
/// `GET http://<address>/api/status`). The raw response fields are parsed
/// losslessly (null when the ESP returned no such field or no status
/// could be obtained).
abstract class DoorDeviceStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoorDeviceStatus._({
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

  factory DoorDeviceStatus({
    required bool ok,
    String? error,
    String? wifiSsid,
    int? wifiRssi,
    String? wifiIp,
    bool? locksAvailable,
    bool? locksPaired,
    bool? locksPairing,
    int? locksCount,
    String? locksLockState,
    int? locksBatteryPct,
    bool? locksBatteryCritical,
    int? locksRssi,
    String? firmwareVersion,
  }) = _DoorDeviceStatusImpl;

  factory DoorDeviceStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorDeviceStatus(
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      error: jsonSerialization['error'] as String?,
      wifiSsid: jsonSerialization['wifiSsid'] as String?,
      wifiRssi: jsonSerialization['wifiRssi'] as int?,
      wifiIp: jsonSerialization['wifiIp'] as String?,
      locksAvailable: jsonSerialization['locksAvailable'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['locksAvailable']),
      locksPaired: jsonSerialization['locksPaired'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['locksPaired']),
      locksPairing: jsonSerialization['locksPairing'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['locksPairing']),
      locksCount: jsonSerialization['locksCount'] as int?,
      locksLockState: jsonSerialization['locksLockState'] as String?,
      locksBatteryPct: jsonSerialization['locksBatteryPct'] as int?,
      locksBatteryCritical: jsonSerialization['locksBatteryCritical'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['locksBatteryCritical'],
            ),
      locksRssi: jsonSerialization['locksRssi'] as int?,
      firmwareVersion: jsonSerialization['firmwareVersion'] as String?,
    );
  }

  /// True when the HTTP call answered with a valid JSON body.
  bool ok;

  /// Error description when the call failed (LAN host not reachable,
  /// response not JSON, ...) — null on success.
  String? error;

  /// Display fields the ESP dashboard also shows (server.reachable /
  /// host.reachable / no connection).
  String? wifiSsid;

  int? wifiRssi;

  String? wifiIp;

  /// Lock area of the ESP status JSON.
  bool? locksAvailable;

  bool? locksPaired;

  bool? locksPairing;

  int? locksCount;

  String? locksLockState;

  int? locksBatteryPct;

  bool? locksBatteryCritical;

  int? locksRssi;

  /// ESP firmware version.
  String? firmwareVersion;

  /// Returns a shallow copy of this [DoorDeviceStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorDeviceStatus copyWith({
    bool? ok,
    String? error,
    String? wifiSsid,
    int? wifiRssi,
    String? wifiIp,
    bool? locksAvailable,
    bool? locksPaired,
    bool? locksPairing,
    int? locksCount,
    String? locksLockState,
    int? locksBatteryPct,
    bool? locksBatteryCritical,
    int? locksRssi,
    String? firmwareVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorDeviceStatus',
      'ok': ok,
      if (error != null) 'error': error,
      if (wifiSsid != null) 'wifiSsid': wifiSsid,
      if (wifiRssi != null) 'wifiRssi': wifiRssi,
      if (wifiIp != null) 'wifiIp': wifiIp,
      if (locksAvailable != null) 'locksAvailable': locksAvailable,
      if (locksPaired != null) 'locksPaired': locksPaired,
      if (locksPairing != null) 'locksPairing': locksPairing,
      if (locksCount != null) 'locksCount': locksCount,
      if (locksLockState != null) 'locksLockState': locksLockState,
      if (locksBatteryPct != null) 'locksBatteryPct': locksBatteryPct,
      if (locksBatteryCritical != null)
        'locksBatteryCritical': locksBatteryCritical,
      if (locksRssi != null) 'locksRssi': locksRssi,
      if (firmwareVersion != null) 'firmwareVersion': firmwareVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorDeviceStatus',
      'ok': ok,
      if (error != null) 'error': error,
      if (wifiSsid != null) 'wifiSsid': wifiSsid,
      if (wifiRssi != null) 'wifiRssi': wifiRssi,
      if (wifiIp != null) 'wifiIp': wifiIp,
      if (locksAvailable != null) 'locksAvailable': locksAvailable,
      if (locksPaired != null) 'locksPaired': locksPaired,
      if (locksPairing != null) 'locksPairing': locksPairing,
      if (locksCount != null) 'locksCount': locksCount,
      if (locksLockState != null) 'locksLockState': locksLockState,
      if (locksBatteryPct != null) 'locksBatteryPct': locksBatteryPct,
      if (locksBatteryCritical != null)
        'locksBatteryCritical': locksBatteryCritical,
      if (locksRssi != null) 'locksRssi': locksRssi,
      if (firmwareVersion != null) 'firmwareVersion': firmwareVersion,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorDeviceStatusImpl extends DoorDeviceStatus {
  _DoorDeviceStatusImpl({
    required bool ok,
    String? error,
    String? wifiSsid,
    int? wifiRssi,
    String? wifiIp,
    bool? locksAvailable,
    bool? locksPaired,
    bool? locksPairing,
    int? locksCount,
    String? locksLockState,
    int? locksBatteryPct,
    bool? locksBatteryCritical,
    int? locksRssi,
    String? firmwareVersion,
  }) : super._(
         ok: ok,
         error: error,
         wifiSsid: wifiSsid,
         wifiRssi: wifiRssi,
         wifiIp: wifiIp,
         locksAvailable: locksAvailable,
         locksPaired: locksPaired,
         locksPairing: locksPairing,
         locksCount: locksCount,
         locksLockState: locksLockState,
         locksBatteryPct: locksBatteryPct,
         locksBatteryCritical: locksBatteryCritical,
         locksRssi: locksRssi,
         firmwareVersion: firmwareVersion,
       );

  /// Returns a shallow copy of this [DoorDeviceStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorDeviceStatus copyWith({
    bool? ok,
    Object? error = _Undefined,
    Object? wifiSsid = _Undefined,
    Object? wifiRssi = _Undefined,
    Object? wifiIp = _Undefined,
    Object? locksAvailable = _Undefined,
    Object? locksPaired = _Undefined,
    Object? locksPairing = _Undefined,
    Object? locksCount = _Undefined,
    Object? locksLockState = _Undefined,
    Object? locksBatteryPct = _Undefined,
    Object? locksBatteryCritical = _Undefined,
    Object? locksRssi = _Undefined,
    Object? firmwareVersion = _Undefined,
  }) {
    return DoorDeviceStatus(
      ok: ok ?? this.ok,
      error: error is String? ? error : this.error,
      wifiSsid: wifiSsid is String? ? wifiSsid : this.wifiSsid,
      wifiRssi: wifiRssi is int? ? wifiRssi : this.wifiRssi,
      wifiIp: wifiIp is String? ? wifiIp : this.wifiIp,
      locksAvailable: locksAvailable is bool?
          ? locksAvailable
          : this.locksAvailable,
      locksPaired: locksPaired is bool? ? locksPaired : this.locksPaired,
      locksPairing: locksPairing is bool? ? locksPairing : this.locksPairing,
      locksCount: locksCount is int? ? locksCount : this.locksCount,
      locksLockState: locksLockState is String?
          ? locksLockState
          : this.locksLockState,
      locksBatteryPct: locksBatteryPct is int?
          ? locksBatteryPct
          : this.locksBatteryPct,
      locksBatteryCritical: locksBatteryCritical is bool?
          ? locksBatteryCritical
          : this.locksBatteryCritical,
      locksRssi: locksRssi is int? ? locksRssi : this.locksRssi,
      firmwareVersion: firmwareVersion is String?
          ? firmwareVersion
          : this.firmwareVersion,
    );
  }
}
