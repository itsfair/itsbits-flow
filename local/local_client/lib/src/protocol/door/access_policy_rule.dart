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
import 'package:local_client/src/protocol/protocol.dart' as _ioaiyikp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../door/access_policy.dart' as _iesob2yd;
import '../door/door_device.dart' as _i3q1tj4m;

/// One rule of an access policy: which door may be opened on which
/// weekday in which minute window (SERVER-LOCAL time = site time).
/// endMinute is exclusive; 1440 encodes "midnight end" (24:00).
/// Overnight windows are expressed as TWO rules (Mo 22:00-23:59 + Di
/// 00:00-04:00) — no wrap semantics.
abstract class AccessPolicyRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccessPolicyRule._({
    this.id,
    required this.policyId,
    this.policy,
    this.deviceId,
    this.device,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
  });

  factory AccessPolicyRule({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) = _AccessPolicyRuleImpl;

  factory AccessPolicyRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessPolicyRule(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ioaiyikp.Protocol().deserialize<_iesob2yd.AccessPolicy>(
              jsonSerialization['policy'],
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      device: jsonSerialization['device'] == null
          ? null
          : _ioaiyikp.Protocol().deserialize<_i3q1tj4m.DoorDevice>(
              jsonSerialization['device'],
            ),
      weekday: jsonSerialization['weekday'] as int,
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int policyId;

  /// The policy this rule belongs to.
  _iesob2yd.AccessPolicy? policy;

  int? deviceId;

  /// The door device this rule grants (null = ALL registered doors).
  _i3q1tj4m.DoorDevice? device;

  /// 0 = Monday … 6 = Sunday (server-local weekday).
  int weekday;

  /// Window start, minutes since local midnight (0-1439).
  int startMinute;

  /// Window end, EXCLUSIVE minutes (1-1440; 1440 = midnight end).
  int endMinute;

  /// Returns a shallow copy of this [AccessPolicyRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccessPolicyRule copyWith({
    int? id,
    int? policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    int? weekday,
    int? startMinute,
    int? endMinute,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessPolicyRule',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessPolicyRule',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessPolicyRuleImpl extends AccessPolicyRule {
  _AccessPolicyRuleImpl({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         deviceId: deviceId,
         device: device,
         weekday: weekday,
         startMinute: startMinute,
         endMinute: endMinute,
       );

  /// Returns a shallow copy of this [AccessPolicyRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccessPolicyRule copyWith({
    Object? id = _Undefined,
    int? policyId,
    Object? policy = _Undefined,
    Object? deviceId = _Undefined,
    Object? device = _Undefined,
    int? weekday,
    int? startMinute,
    int? endMinute,
  }) {
    return AccessPolicyRule(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _iesob2yd.AccessPolicy?
          ? policy
          : this.policy?.copyWith(),
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      device: device is _i3q1tj4m.DoorDevice?
          ? device
          : this.device?.copyWith(),
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
    );
  }
}
