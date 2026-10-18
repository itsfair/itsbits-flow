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

/// Result of pushing the backend config (serverUrl + siteId) to a
/// doorinterface: the ESP answers with its identity when it accepted
/// and stored the configuration.
abstract class DoorDevicePushResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoorDevicePushResult._({
    required this.ok,
    this.error,
    this.mac,
    this.hostname,
  });

  factory DoorDevicePushResult({
    required bool ok,
    String? error,
    String? mac,
    String? hostname,
  }) = _DoorDevicePushResultImpl;

  factory DoorDevicePushResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DoorDevicePushResult(
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      error: jsonSerialization['error'] as String?,
      mac: jsonSerialization['mac'] as String?,
      hostname: jsonSerialization['hostname'] as String?,
    );
  }

  /// True when the device confirmed the configuration.
  bool ok;

  /// Error description when the device could not be reached or rejected
  /// the config.
  String? error;

  /// BLE MAC reported by the device (stored on the registry row).
  String? mac;

  /// Hostname reported by the device.
  String? hostname;

  /// Returns a shallow copy of this [DoorDevicePushResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorDevicePushResult copyWith({
    bool? ok,
    String? error,
    String? mac,
    String? hostname,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorDevicePushResult',
      'ok': ok,
      if (error != null) 'error': error,
      if (mac != null) 'mac': mac,
      if (hostname != null) 'hostname': hostname,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorDevicePushResult',
      'ok': ok,
      if (error != null) 'error': error,
      if (mac != null) 'mac': mac,
      if (hostname != null) 'hostname': hostname,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorDevicePushResultImpl extends DoorDevicePushResult {
  _DoorDevicePushResultImpl({
    required bool ok,
    String? error,
    String? mac,
    String? hostname,
  }) : super._(
         ok: ok,
         error: error,
         mac: mac,
         hostname: hostname,
       );

  /// Returns a shallow copy of this [DoorDevicePushResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorDevicePushResult copyWith({
    bool? ok,
    Object? error = _Undefined,
    Object? mac = _Undefined,
    Object? hostname = _Undefined,
  }) {
    return DoorDevicePushResult(
      ok: ok ?? this.ok,
      error: error is String? ? error : this.error,
      mac: mac is String? ? mac : this.mac,
      hostname: hostname is String? ? hostname : this.hostname,
    );
  }
}
