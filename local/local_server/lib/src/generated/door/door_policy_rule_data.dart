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

/// One rule of a policy as seen by the admin UI (door display name
/// resolved; null device = all doors).
abstract class DoorPolicyRuleData
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoorPolicyRuleData._({
    required this.id,
    this.deviceId,
    this.deviceName,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
  });

  factory DoorPolicyRuleData({
    required int id,
    int? deviceId,
    String? deviceName,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) = _DoorPolicyRuleDataImpl;

  factory DoorPolicyRuleData.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorPolicyRuleData(
      id: jsonSerialization['id'] as int,
      deviceId: jsonSerialization['deviceId'] as int?,
      deviceName: jsonSerialization['deviceName'] as String?,
      weekday: jsonSerialization['weekday'] as int,
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
    );
  }

  int id;

  int? deviceId;

  String? deviceName;

  int weekday;

  int startMinute;

  int endMinute;

  /// Returns a shallow copy of this [DoorPolicyRuleData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorPolicyRuleData copyWith({
    int? id,
    int? deviceId,
    String? deviceName,
    int? weekday,
    int? startMinute,
    int? endMinute,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorPolicyRuleData',
      'id': id,
      if (deviceId != null) 'deviceId': deviceId,
      if (deviceName != null) 'deviceName': deviceName,
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorPolicyRuleData',
      'id': id,
      if (deviceId != null) 'deviceId': deviceId,
      if (deviceName != null) 'deviceName': deviceName,
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorPolicyRuleDataImpl extends DoorPolicyRuleData {
  _DoorPolicyRuleDataImpl({
    required int id,
    int? deviceId,
    String? deviceName,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) : super._(
         id: id,
         deviceId: deviceId,
         deviceName: deviceName,
         weekday: weekday,
         startMinute: startMinute,
         endMinute: endMinute,
       );

  /// Returns a shallow copy of this [DoorPolicyRuleData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorPolicyRuleData copyWith({
    int? id,
    Object? deviceId = _Undefined,
    Object? deviceName = _Undefined,
    int? weekday,
    int? startMinute,
    int? endMinute,
  }) {
    return DoorPolicyRuleData(
      id: id ?? this.id,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      deviceName: deviceName is String? ? deviceName : this.deviceName,
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
    );
  }
}
