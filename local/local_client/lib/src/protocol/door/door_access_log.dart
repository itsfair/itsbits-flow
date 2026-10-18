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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../door/door_access_result.dart' as _i63ctnyt;

/// Audit/statistics log of every door-access verification attempt
/// (granted AND denied). This is the data basis for the later
/// per-(door, member) time-window rules and for statistics.
abstract class DoorAccessLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoorAccessLog._({
    this.id,
    this.deviceMac,
    this.userKey,
    required this.result,
    this.detail,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorAccessLog({
    int? id,
    String? deviceMac,
    _isc.UuidValue? userKey,
    required _i63ctnyt.DoorAccessResult result,
    String? detail,
    DateTime? createdAt,
  }) = _DoorAccessLogImpl;

  factory DoorAccessLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorAccessLog(
      id: jsonSerialization['id'] as int?,
      deviceMac: jsonSerialization['deviceMac'] as String?,
      userKey: jsonSerialization['userKey'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userKey']),
      result: _i63ctnyt.DoorAccessResult.fromJson(
        (jsonSerialization['result'] as String),
      ),
      detail: jsonSerialization['detail'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// BLE MAC of the reporting device (from the verify payload); matched
  /// against door_devices.mac for attribution (informational — device
  /// authentication is a separate hardening step).
  String? deviceMac;

  /// The member the access was requested for (null for malformed
  /// requests without a parseable id).
  _isc.UuidValue? userKey;

  /// Outcome of the attempt.
  _i63ctnyt.DoorAccessResult result;

  /// Optional detail (e.g. which sub-check failed internally for
  /// debugging — never surfaced to the device).
  String? detail;

  /// When the attempt happened.
  DateTime createdAt;

  /// Returns a shallow copy of this [DoorAccessLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoorAccessLog copyWith({
    int? id,
    String? deviceMac,
    _isc.UuidValue? userKey,
    _i63ctnyt.DoorAccessResult? result,
    String? detail,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorAccessLog',
      if (id != null) 'id': id,
      if (deviceMac != null) 'deviceMac': deviceMac,
      if (userKey != null) 'userKey': userKey?.toJson(),
      'result': result.toJson(),
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorAccessLog',
      if (id != null) 'id': id,
      if (deviceMac != null) 'deviceMac': deviceMac,
      if (userKey != null) 'userKey': userKey?.toJson(),
      'result': result.toJson(),
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorAccessLogImpl extends DoorAccessLog {
  _DoorAccessLogImpl({
    int? id,
    String? deviceMac,
    _isc.UuidValue? userKey,
    required _i63ctnyt.DoorAccessResult result,
    String? detail,
    DateTime? createdAt,
  }) : super._(
         id: id,
         deviceMac: deviceMac,
         userKey: userKey,
         result: result,
         detail: detail,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorAccessLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoorAccessLog copyWith({
    Object? id = _Undefined,
    Object? deviceMac = _Undefined,
    Object? userKey = _Undefined,
    _i63ctnyt.DoorAccessResult? result,
    Object? detail = _Undefined,
    DateTime? createdAt,
  }) {
    return DoorAccessLog(
      id: id is int? ? id : this.id,
      deviceMac: deviceMac is String? ? deviceMac : this.deviceMac,
      userKey: userKey is _isc.UuidValue? ? userKey : this.userKey,
      result: result ?? this.result,
      detail: detail is String? ? detail : this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
